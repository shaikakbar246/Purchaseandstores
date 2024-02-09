using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

public partial class storesissuerpt : System.Web.UI.Page
{
    SqlCommand cmd;
    ///string BranchID = "";
    SalesDBManager vdm;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["Employ_Sno"] == "" || Session["Employ_Sno"] == null)
        {
            Response.Redirect("Login.aspx");
        }
        else
        {
            vdm = new SalesDBManager();
            if (!Page.IsPostBack)
            {
                if (!Page.IsCallback)
                {
                    dtp_FromDate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");//Convert.ToString(lblFromDate.Text); ////     /////
                    dtp_Todate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");// Convert.ToString(lbltodate.Text);/// //// 
                    lblAddress.Text = Session["Address"].ToString();
                    lblTitle.Text = Session["TitleName"].ToString();
                }
            }
        }
    }

    private DateTime GetLowDate(DateTime dt)
    {
        double Hour, Min, Sec;
        DateTime DT = DateTime.Now;
        DT = dt;
        Hour = -dt.Hour;
        Min = -dt.Minute;
        Sec = -dt.Second;
        DT = DT.AddHours(Hour);
        DT = DT.AddMinutes(Min);
        DT = DT.AddSeconds(Sec);
        return DT;
    }
    private DateTime GetHighDate(DateTime dt)
    {
        double Hour, Min, Sec;
        DateTime DT = DateTime.Now;
        Hour = 23 - dt.Hour;
        Min = 59 - dt.Minute;
        Sec = 59 - dt.Second;
        DT = dt;
        DT = DT.AddHours(Hour);
        DT = DT.AddMinutes(Min);
        DT = DT.AddSeconds(Sec);
        return DT;
    }
    DataTable Report = new DataTable();
    protected void btn_Generate_Click(object sender, EventArgs e)
    {
        try
        {
            Report.Columns.Add("Voucher Date");
            Report.Columns.Add("Voucher No");
            Report.Columns.Add("Section Name");
            Report.Columns.Add("Item Name");
            Report.Columns.Add("Qty");
            Report.Columns.Add("Rate");
            Report.Columns.Add("Amount");
            Report.Columns.Add("Narration");
            lblmsg.Text = "";
            SalesDBManager SalesDB = new SalesDBManager();
            DateTime fromdate = DateTime.Now;
            DateTime todate = DateTime.Now;
            string[] datestrig = dtp_FromDate.Text.Split(' ');
            if (datestrig.Length > 1)
            {
                if (datestrig[0].Split('-').Length > 0)
                {
                    string[] dates = datestrig[0].Split('-');
                    string[] times = datestrig[1].Split(':');
                    fromdate = new DateTime(int.Parse(dates[2]), int.Parse(dates[1]), int.Parse(dates[0]), int.Parse(times[0]), int.Parse(times[1]), 0);
                }
            }
            datestrig = dtp_Todate.Text.Split(' ');
            if (datestrig.Length > 1)
            {
                if (datestrig[0].Split('-').Length > 0)
                {
                    string[] dates = datestrig[0].Split('-');
                    string[] times = datestrig[1].Split(':');
                    todate = new DateTime(int.Parse(dates[2]), int.Parse(dates[1]), int.Parse(dates[0]), int.Parse(times[0]), int.Parse(times[1]), 0);
                }
            }
            lblFromDate.Text = fromdate.ToString("dd/MM/yyyy");
            lbltodate.Text = todate.ToString("dd/MM/yyyy");
            string branchid = Session["Po_BranchID"].ToString();
            string branchcode = Session["BranchCode"].ToString();
            cmd = new SqlCommand("SELECT outwarddetails.sno, outwarddetails.remarks, outwarddetails.issueno,outwarddetails.inwarddate AS outwarddate, productmaster.productname, outwarddetails.branch_id, outwarddetails.section_id, outwarddetails.type,  suboutwarddetails.sno AS Expr1,  suboutwarddetails.quantity, suboutwarddetails.perunit, suboutwarddetails.totalcost, suboutwarddetails.in_refno, sectionmaster.name, sectionmaster.sec_code, branchmaster.branchname FROM outwarddetails INNER JOIN suboutwarddetails ON outwarddetails.sno = suboutwarddetails.in_refno INNER JOIN productmaster ON suboutwarddetails.productid = productmaster.productid LEFT OUTER JOIN sectionmaster ON outwarddetails.section_id = sectionmaster.sectionid LEFT OUTER JOIN branchmaster ON outwarddetails.branch_id = branchmaster.branchid where  (outwarddetails.inwarddate between @fromdate and @todate) AND (outwarddetails.branchid=@branchid) AND (suboutwarddetails.quantity >0) AND (outwarddetails.status='A') AND (sectionmaster.sec_code IS NULL) order by outwarddetails.sno");
            cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
            cmd.Parameters.Add("@todate", GetHighDate(todate));
            cmd.Parameters.Add("@branchid", branchid);
            DataTable dttotalpo = SalesDB.SelectQuery(cmd).Tables[0];
            if (dttotalpo.Rows.Count > 0)
            {
                double totalqty = 0;
                double gtotalqty = 0;
                double ttotalamount = 0;
                double gtotalamount = 0;
                double totalprice = 0;
                double toatlpq = 0;
                double totalpriceqty = 0;
                DateTime dt = DateTime.Now;
                string prevdate = string.Empty;
                string prevpono = "";
                var i = 1;
                int count = 1;
                int rowcount = 1;
                foreach (DataRow dr in dttotalpo.Rows)
                {
                    string name = dr["productname"].ToString();
                    if (name != "DIESEL")
                    {
                        DataRow newrow = Report.NewRow();
                        string prespono = "" + branchcode + "OUT/0" + dr["issueno"].ToString() + "";
                        newrow["Voucher No"] = prespono;
                        string date = dr["outwarddate"].ToString();
                        DateTime dttime = Convert.ToDateTime(date);
                        newrow["Voucher Date"] = dttime.ToString("dd-MMM-yyyy");
                        newrow["Section Name"] = dr["name"].ToString();
                        newrow["Item Name"] = dr["productname"].ToString();
                        double price = 0;
                        double.TryParse(dr["perunit"].ToString(), out price);
                        totalprice += price;
                        newrow["Rate"] = Math.Round(price, 2).ToString("f2");
                        double qty = 0;
                        double.TryParse(dr["quantity"].ToString(), out qty);
                        totalqty += qty;
                        newrow["Qty"] = dr["quantity"].ToString();
                        double total; double totamount = 0;
                        total = qty * price;
                        totamount += total;
                        double totalamount = 0;
                        totalamount = totamount;//grand total in that coming
                        newrow["Amount"] = Math.Round(totalamount, 2).ToString("f2");
                        ttotalamount += totalamount;
                        string Narration = dr["remarks"].ToString();
                        newrow["Narration"] = Narration;
                        Report.Rows.Add(newrow);
                    }
                }
                grdReports.DataSource = Report;
                grdReports.DataBind();
                Session["xportdata"] = Report;
                Session["filename"] = "Stores ISSUE Report";
                hidepanel.Visible = true;
            }
            else
            {
                lblmsg.Text = "No data were found";
                hidepanel.Visible = false;
            }
        }
        catch (Exception ex)
        {
            lblmsg.Text = ex.Message;
            hidepanel.Visible = false;
        }
    }
}