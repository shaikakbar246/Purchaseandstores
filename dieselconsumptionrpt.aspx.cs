using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

public partial class dieselconsumptionrpt : System.Web.UI.Page
{
    DataTable dtAddress = new DataTable();
    VehicleDBMgr devdm;
    SqlCommand cmd;
    SalesDBManager vdm;
    string UserName;

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

                    //bindvechcle();
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



    protected void btnGenerate_Click(object sender, EventArgs e)
    {
        try
        {

            devdm = new VehicleDBMgr();
            SalesDBManager vdm = new SalesDBManager();
            DateTime fromdate = DateTime.Now;
            string[] dateFromstrig = txtFromdate.Text.Split(' ');
            if (dateFromstrig.Length > 1)
            {
                if (dateFromstrig[0].Split('-').Length > 0)
                {
                    string[] dates = dateFromstrig[0].Split('-');
                    string[] times = dateFromstrig[1].Split(':');
                    fromdate = new DateTime(int.Parse(dates[2]), int.Parse(dates[1]), int.Parse(dates[0]), int.Parse(times[0]), int.Parse(times[1]), 0);
                }
            }
            DateTime Todate = DateTime.Now;
            string[] dateTostrig = txtTodate.Text.Split(' ');
            if (dateTostrig.Length > 1)
            {
                if (dateTostrig[0].Split('-').Length > 0)
                {
                    string[] dates = dateTostrig[0].Split('-');
                    string[] times = dateTostrig[1].Split(':');
                    Todate = new DateTime(int.Parse(dates[2]), int.Parse(dates[1]), int.Parse(dates[0]), int.Parse(times[0]), int.Parse(times[1]), 0);
                }
            }

            cmd = new SqlCommand("SELECT productid, qty, doe, vehicleno, dieselcost FROM   diesel_consumptiondetails  WHERE (doe BETWEEN @d1 AND @d2) AND branchid=@branchid");
            cmd.Parameters.Add("@d1", GetLowDate(fromdate));
            cmd.Parameters.Add("@d2", GetLowDate(Todate));
            cmd.Parameters.Add("@branchid", "2");
            DataTable dttotal = vdm.SelectQuery(cmd).Tables[0];
            grdReports.DataSource = dttotal;
            grdReports.DataBind();
            string title = "DieselReport From: " + fromdate.ToString() + "  To: " + Todate.ToString();
            Session["title"] = title;
            Session["filename"] = "DieselReport";
            Session["xportdata"] = dttotal;
            pvisible.Visible = true;
            //Session["quantity"] = quantity;

        }
        catch (Exception ex)
        {
            lblmsg.Text = ex.Message;
        }
    }

    double valnewCash; double quantity;
    DataTable Report = new DataTable();

    
}