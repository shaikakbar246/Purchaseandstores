using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

public partial class SectionWiseReport : System.Web.UI.Page
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
            if (!this.IsPostBack)
            {
                if (!Page.IsCallback)
                {
                    dtp_FromDate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");//Convert.ToString(lblFromDate.Text); ////     /////
                    dtp_Todate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
                    lblAddress.Text = Session["Address"].ToString();
                    lblTitle.Text = Session["TitleName"].ToString();
                    //loadReport();
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
            Report.Columns.Add("sno");
            Report.Columns.Add("Section Id");
            Report.Columns.Add("Section Name");
            Report.Columns.Add("Value");
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
            lblfrom_date.Text = fromdate.ToString("dd/MM/yyyy");
            lblto_date.Text = todate.ToString("dd/MM/yyyy");
            //DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string branchid = Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT sectionid, name, color, status, sec_code, branchid  FROM  sectionmaster where branchid  =@branchid");  
           // cmd = new SqlCommand("SELECT sectionmaster.sectionid,sectionmaster.name FROM productmaster RIGHT OUTER JOIN  sectionmaster ON productmaster.sectionid=sectionmaster.sectionid WHERE sectionmaster.branchid=@branchid group by sectionmaster.sectionid,sectionmaster.name");
            cmd.Parameters.Add("@branchid", branchid);
            DataTable dtproducts = SalesDB.SelectQuery(cmd).Tables[0];

            cmd = new SqlCommand("SELECT  outwarddetails.section_id,SUM(suboutwarddetails.quantity*suboutwarddetails.perunit) AS issuestopunabaka FROM outwarddetails INNER JOIN suboutwarddetails  ON outwarddetails.sno = suboutwarddetails.in_refno  WHERE (outwarddetails.inwarddate BETWEEN @fromdate AND @todate) AND (outwarddetails.branchid=@branchid)  GROUP BY outwarddetails.section_id");
            cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
            cmd.Parameters.Add("@todate", GetHighDate(todate));
            cmd.Parameters.Add("@branchid", branchid);
            DataTable dtIsspcode = SalesDB.SelectQuery(cmd).Tables[0];


            if (dtproducts.Rows.Count > 0)
            {
                double Totalissueqty = 0;
                double gTotalissueqty1 = 0;
                double Totalissueqty1 = 0;
                var i = 1;
                foreach (DataRow dr in dtproducts.Rows)
                {
                    double issueqty = 0;
                    int sectionid;
                    int.TryParse(dr["sectionid"].ToString(), out sectionid);
                    foreach (DataRow drissue in dtIsspcode.Select("section_id='" + sectionid + "'"))
                    {
                        DataRow newrow = Report.NewRow();
                        newrow["sno"] = i++.ToString();
                        newrow["Section Name"] = dr["name"].ToString();
                        newrow["Section Id"] = dr["sectionid"].ToString();
                        double.TryParse(drissue["issuestopunabaka"].ToString(), out issueqty);
                        double isspunabaka = issueqty;
                        isspunabaka = Math.Round(isspunabaka, 2);
                        Totalissueqty += issueqty;
                        Totalissueqty1 = Math.Round(Totalissueqty, 2);
                        newrow["Value"] = Math.Round(issueqty, 2);
                        gTotalissueqty1 += Totalissueqty1;
                        Totalissueqty1 = 0;
                        Report.Rows.Add(newrow);
                    }
                    //newrow["Value"] = Totalissueqty1;
                }
                //gTotalissueqty1 += Totalissueqty1;
                DataRow stockreport = Report.NewRow();
                stockreport["Section Name"] = "TotalValue";
                stockreport["Value"] = Math.Round(Totalissueqty, 2); //Totalclosingqty;
                Report.Rows.Add(stockreport);
                grdReports.DataSource = Report;
                grdReports.DataBind();
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
    protected void grdReports_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        try
        {
            int rowIndex = Convert.ToInt32(e.CommandArgument);
            GridViewRow row = grdReports.Rows[rowIndex];
            string ReceiptNo = row.Cells[2].Text;
            Report.Columns.Add("sno");
            Report.Columns.Add("Product Id");
            Report.Columns.Add("Product Name");
            //Report.Columns.Add("Outward Date");
            Report.Columns.Add("Quantity");
            Report.Columns.Add("Price");
            Report.Columns.Add("Value");
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
                lblfrom_date.Text = fromdate.ToString("dd/MM/yyyy");
                lblto_date.Text = todate.ToString("dd/MM/yyyy");
                string branchid = Session["Po_BranchID"].ToString();
                cmd = new SqlCommand("SELECT productid, productname,price,sectionid FROM productmaster");
                DataTable dtproducts = SalesDB.SelectQuery(cmd).Tables[0];
                if (dtproducts.Rows.Count > 0)
                {
                    double Totalopeningqty = 0;
                    double Totalreceptqty = 0;
                    double Totalissueqty = 0;
                    double Totalbqty = 0;
                    double Totalclosingqty = 0;
                    var i = 1;
                    cmd = new SqlCommand("SELECT  productmaster.productname, productmaster.productid, (suboutwarddetails.quantity*suboutwarddetails.perunit) AS Value,suboutwarddetails.quantity,suboutwarddetails.perunit, outwarddetails.inwarddate FROM   outwarddetails INNER JOIN   suboutwarddetails ON outwarddetails.sno = suboutwarddetails.in_refno INNER JOIN productmaster  ON productmaster.productid = suboutwarddetails.productid WHERE (outwarddetails.inwarddate BETWEEN @fromdate AND @todate) AND (outwarddetails.section_id = @sectionid) AND (outwarddetails.branchid = @branchid) AND suboutwarddetails.quantity != '0'");
                    cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
                    cmd.Parameters.Add("@todate", GetHighDate(todate));
                    cmd.Parameters.Add("@sectionid", ReceiptNo);
                    cmd.Parameters.Add("@branchid", branchid);
                    DataTable dtIsspcode = SalesDB.SelectQuery(cmd).Tables[0];
                    foreach (DataRow dr in dtproducts.Rows)
                    {
                        double openingqty = 0;
                        double receptqty = 0;
                        double qty = 0;
                        double bqty = 0;
                        foreach (DataRow drissue in dtIsspcode.Select("productid='" + dr["productid"].ToString() + "'"))
                        {
                            DataRow newrow = Report.NewRow();
                            newrow["sno"] = i++.ToString();
                            newrow["Product Id"] = dr["productid"].ToString();
                            newrow["Product Name"] = dr["productname"].ToString();
                           // newrow["OutwardDate"] = drissue["inwarddate"].ToString();
                           // double price = 0; 
                           // double.TryParse(drissue["perunit"].ToString(), out price);
                            newrow["Price"] = drissue["perunit"].ToString();
                            newrow["Quantity"] = drissue["quantity"].ToString();
                            double value = 0;
                            double.TryParse(drissue["Value"].ToString(), out value);
                            value = Math.Round(value, 2);
                            newrow["Value"] = value; 
                            Totalissueqty += value;
                            Report.Rows.Add(newrow);
                        }
                    }
                    DataRow stockreport = Report.NewRow();
                    stockreport["Product Name"] = "Total";
                    stockreport["Value"] = Totalissueqty;
                    //stockreport["ClosingBalance"] = Math.Round(Totalclosingqty, 2); //Totalclosingqty;
                    Report.Rows.Add(stockreport);
                    GrdProducts.DataSource = Report;
                    GrdProducts.DataBind();
                    hidepanel.Visible = true;
                }
                else
                {
                    lblmsg.Text = "No data were found";
                    hidepanel.Visible = false;
                }
              ScriptManager.RegisterStartupScript(Page, GetType(), "JsStatus", "PopupOpen();", true);
            }
        catch (Exception ex)
        {
            lblmsg.Text = ex.Message;
            hidepanel.Visible = false;
        }
    }
}
