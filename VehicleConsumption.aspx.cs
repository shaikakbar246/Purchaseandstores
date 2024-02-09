using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;
public partial class VehicleConsumption : System.Web.UI.Page
{
    SqlCommand cmd;
    string UserName = "";
    SalesDBManager vdm;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["UserName"] == null)
            Response.Redirect("Login.aspx");
        else
        {
            UserName = Session["UserName"].ToString();
            vdm = new SalesDBManager();
            if (!Page.IsPostBack)
            {
                if (!Page.IsCallback)
                {
                    dtp_FromDate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
                    dtp_Todate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
                    lblAddress.Text = Session["Address"].ToString();
                    lblTitle.Text = Session["TitleName"].ToString();
                    // bindbranches();
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
    //private void bindbranches()
    //{
    //    string branchid1 = Session["Po_BranchID"].ToString();
    //    cmd = new SqlCommand("SELECT  productid, subcategoryid, productname, productcode, sub_cat_code, sku FROM productmaster where branchid=@branchid  ");
    //    cmd.Parameters.Add("@branchid", branchid1);
    //    DataTable dttrips = vdm.SelectQuery(cmd).Tables[0];
    //    ddlproducts.DataSource = dttrips;
    //    ddlproducts.DataTextField = "productname";
    //    ddlproducts.DataValueField = "productid";
    //    ddlproducts.DataBind();
    //}
    double totalmilk;
    protected void btn_Generate_Click(object sender, EventArgs e)
    {
        report();
    }
    DataTable collection = new DataTable();
    DataTable Report = new DataTable();
    private void report()
    {
        try
        {
            Report.Columns.Add("Sno");
            Report.Columns.Add("Date");
           // Report.Columns.Add("Issue No");
            Report.Columns.Add("VehcleNumber");
            Report.Columns.Add("Product Name");
            Report.Columns.Add("Quantity");
            Report.Columns.Add("Price");
            Report.Columns.Add("Total Amount");
            lblmsg.Text = "";
            string milkopeningbal = string.Empty;
            string milkclosingbal = string.Empty;
            SalesDBManager SalesDB = new SalesDBManager();
            DateTime fromdate = DateTime.Now;
            DateTime todate = DateTime.Now;
            string idcno = string.Empty;
            string inworddate = string.Empty;
            double totalinwardqty = 0;
            double totalissueqty = 0;
            double totaltransferquantity = 0;
            double tranqtydateqty = 0;
            double totalReturnqty = 0;
            double returndateqty = 0;
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
            lblFromDate.Text = fromdate.ToString("dd/MMM/yyyy");
            lbltodate.Text = todate.ToString("dd/MMM/yyyy");
            // string ClientValue = Request.Form["txtShortName"];
            string sectionid = TextBox1.Text;
            // string productid =.('<%=txtShortName.ClientID %>').ToString();
            // int productid = Convert.ToInt32(txtShortName.Text);
            string branchid = Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT outwarddetails.sno,CONVERT(VARCHAR(20), outwarddetails.inwarddate, 103) AS outwarddate, productmaster.productname, outwarddetails.branch_id, outwarddetails.section_id, outwarddetails.type,  suboutwarddetails.sno AS Expr1,  suboutwarddetails.quantity, suboutwarddetails.perunit, suboutwarddetails.totalcost, suboutwarddetails.in_refno,sectionmaster.name, branchmaster.branchname FROM outwarddetails INNER JOIN suboutwarddetails ON outwarddetails.sno = suboutwarddetails.in_refno INNER JOIN productmaster ON suboutwarddetails.productid = productmaster.productid LEFT OUTER JOIN sectionmaster ON outwarddetails.section_id = sectionmaster.sectionid LEFT OUTER JOIN branchmaster ON outwarddetails.branch_id = branchmaster.branchid where  (outwarddetails.inwarddate between @fromdate and @todate) AND (outwarddetails.branchid=@branchid) AND (suboutwarddetails.quantity >0) and sectionmaster.name=@sectionid order by outwarddetails.sno");
            cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
            cmd.Parameters.Add("@todate", GetHighDate(todate));
            cmd.Parameters.Add("@branchid", branchid);
            cmd.Parameters.Add("@sectionid", sectionid);
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
                    DataRow newrow = Report.NewRow();
                    newrow["Sno"] = i++.ToString();
                    string prespono = dr["sno"].ToString();
                    newrow["Date"] = dr["outwarddate"].ToString();
                    //DateTime dtdoe = Convert.ToDateTime(dr["outwarddate"].ToString());
                    //string currentdate = dtdoe.ToString("dd/MM/yyyy");
                    //string date = dtdoe.ToString("dd/MM/yyyy");
                    if (i == 2)
                    {
                        newrow["VehcleNumber"] = dr["name"].ToString();
                    }
                    newrow["Product Name"] = dr["productname"].ToString();
                    double price = 0;
                    double.TryParse(dr["perunit"].ToString(), out price);
                    totalprice += price;
                    newrow["Price"] = dr["perunit"].ToString();
                    double qty = 0;
                    double.TryParse(dr["quantity"].ToString(), out qty);
                    totalqty += qty;
                    newrow["Quantity"] = dr["quantity"].ToString();
                    double total; double totamount = 0;
                    total = qty * price;
                    totamount += total;
                    double totalamount = 0;
                    totalamount = totamount;//grand total in that coming
                    newrow["Total Amount"] = totalamount;
                    ttotalamount += totalamount;
                    Report.Rows.Add(newrow);
                    count++;
                }
                DataRow newrow1 = Report.NewRow();
                newrow1["Product Name"] = "Total";
                totalqty = Math.Round(totalqty, 2);
                newrow1["Quantity"] = totalqty;
                ttotalamount = Math.Round(ttotalamount, 2);
                newrow1["Total Amount"] = ttotalamount;
                Report.Rows.Add(newrow1);
                
            }
            else
            {
                lblmsg.Text = "No data were found";
               // hidepanel.Visible = false;
            }
            grdReports.DataSource = Report;
            grdReports.DataBind();
            hidepanel.Visible = true;
            ScriptManager.RegisterStartupScript(Page, GetType(), "JsStatus", "get_section_details();", true);
        }
        catch (Exception ex)
        {
            lblmsg.Text = ex.Message;
        }
    }
}