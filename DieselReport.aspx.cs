using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using MySql.Data.MySqlClient;
using System.Data.SqlClient;
public partial class DieselReport : System.Web.UI.Page
{
    MySqlCommand vecmd;
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
                    txtFromdate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
                    txtTodate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
                    lblAddress.Text = Session["Address"].ToString();
                    lblTitle.Text = Session["TitleName"].ToString();
                    bindvechcle();
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

    private void bindvechcle()
    {
        devdm = new VehicleDBMgr();
        vecmd = new MySqlCommand("SELECT  vm_sno, registration_no FROM vehicel_master");
        DataTable dtvehcle = devdm.SelectQuery(vecmd).Tables[0];
        ddlagentname.DataSource = dtvehcle;
        ddlagentname.DataTextField = "registration_no";
        ddlagentname.DataValueField = "vm_sno";
        ddlagentname.DataBind();
        ddlagentname.ClearSelection();
        ddlagentname.Items.Insert(0, new ListItem { Value = "0", Text = "--Select VehcleNumber--", Selected = true });
        ddlagentname.SelectedValue = "0";
    }


    double valnewCash; double quantity; 
    protected void btnGenerate_Click(object sender, EventArgs e)
    {
        try
        {
            lblmsg.Text = "";
           
            pvisible.Visible = true;
            devdm = new VehicleDBMgr();
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
            int vehcleid = Convert.ToInt32(ddlagentname.SelectedItem.Value);
            lblOppBal.Text = "";
            lblCloBal.Text = "";
            Session["title"] = "Diesel Report";
            DataTable Report = new DataTable();
            Report.Columns.Add("Sno");
            Report.Columns.Add("Date");
            Report.Columns.Add("Time");
            Report.Columns.Add("Route");
            Report.Columns.Add("Vehicle No");
            Report.Columns.Add("Vehicle Type");
            Report.Columns.Add("Diesel Filled").DataType = typeof(Double);
            Report.Columns.Add("Driver Name");
            Report.Columns.Add("Load Type");
            Report.Columns.Add("Start Reading");
            Report.Columns.Add("Pump Reading");
            Report.Columns.Add("Token"); 

            vecmd = new MySqlCommand("SELECT sno, fuel, doe, userid, operetedby, costperltr FROM fuel_transaction WHERE (doe BETWEEN @d1 AND @d2) AND (transtype = 2)");
            vecmd.Parameters.Add("@d1", GetLowDate(fromdate).AddDays(-1));
            vecmd.Parameters.Add("@d2", GetHighDate(Todate).AddDays(-1));
            DataTable dtOpp = devdm.SelectQuery(vecmd).Tables[0];
            if (dtOpp.Rows.Count > 0)
            {
                pnlOpp.Visible = true;
                lblOppBal.Text = dtOpp.Rows[0]["fuel"].ToString();
            }
            vecmd = new MySqlCommand("SELECT sno, fuel, doe, userid, operetedby, costperltr FROM fuel_transaction WHERE (doe BETWEEN @d1 AND @d2) AND (transtype = 2)");
            vecmd.Parameters.Add("@d1", GetLowDate(fromdate));
            vecmd.Parameters.Add("@d2", GetHighDate(Todate));
            DataTable dtclo = devdm.SelectQuery(vecmd).Tables[0];
            if (dtclo.Rows.Count > 0)
            {
                pnlClo.Visible = true;
                lblCloBal.Text = dtclo.Rows[0]["fuel"].ToString();
            }
            int BranchID = 1;
            if (vehcleid != 0)
            {
                vecmd = new MySqlCommand("SELECT employdata.employname,tripdata.routeid, tripdata.fueltank,tripdata.pumpreading,tripdata.Tokenno, tripdata.vehiclestartreading,tripdata.refrigeration_fuel, tripdata.gpskms, tripdata.tripsheetno, tripdata.enddate, employdata.Phoneno AS phoneNumber, tripdata.sno, tripdata.loadtype, employdata.emp_licencenum AS LicenseNo, tripdata.routeid AS RouteName, vehicel_master.registration_no AS Vehicleno, vehicel_master.vm_model AS VehicleModel, minimasters.mm_name AS VehicleType, minimasters_1.mm_name AS VehicleMake,tripdata.endfuelvalue FROM tripdata INNER JOIN employdata ON tripdata.driverid = employdata.emp_sno INNER JOIN vehicel_master ON tripdata.vehicleno = vehicel_master.vm_sno INNER JOIN minimasters ON vehicel_master.vhtype_refno = minimasters.sno INNER JOIN minimasters minimasters_1 ON vehicel_master.vhmake_refno = minimasters_1.sno WHERE (tripdata.enddate BETWEEN @d1 AND @d2) AND (tripdata.userid = @BranchID) AND (tripdata.status = 'C') AND (vehicel_master.vm_sno=@vehcleid)  order by tripdata.enddate");
                vecmd.Parameters.Add("@BranchID", BranchID);
                vecmd.Parameters.Add("@d1", GetLowDate(fromdate));
                vecmd.Parameters.Add("@d2", GetHighDate(Todate));
                vecmd.Parameters.Add("@vehcleid", vehcleid);
            }
            else
            {

                vecmd = new MySqlCommand("SELECT employdata.employname,tripdata.routeid, tripdata.fueltank,tripdata.pumpreading,tripdata.Tokenno, tripdata.vehiclestartreading,tripdata.refrigeration_fuel, tripdata.gpskms, tripdata.tripsheetno, tripdata.enddate, employdata.Phoneno AS phoneNumber, tripdata.sno, tripdata.loadtype, employdata.emp_licencenum AS LicenseNo, tripdata.routeid AS RouteName, vehicel_master.registration_no AS Vehicleno, vehicel_master.vm_model AS VehicleModel, minimasters.mm_name AS VehicleType, minimasters_1.mm_name AS VehicleMake,tripdata.endfuelvalue FROM tripdata INNER JOIN employdata ON tripdata.driverid = employdata.emp_sno INNER JOIN vehicel_master ON tripdata.vehicleno = vehicel_master.vm_sno INNER JOIN minimasters ON vehicel_master.vhtype_refno = minimasters.sno INNER JOIN minimasters minimasters_1 ON vehicel_master.vhmake_refno = minimasters_1.sno WHERE (tripdata.enddate BETWEEN @d1 AND @d2) AND (tripdata.userid = @BranchID) AND (tripdata.status = 'C')  order by tripdata.enddate");
                vecmd.Parameters.Add("@BranchID", BranchID);
                vecmd.Parameters.Add("@d1", GetLowDate(fromdate));
                vecmd.Parameters.Add("@d2", GetHighDate(Todate));

            }
            DataTable dtDiesel = devdm.SelectQuery(vecmd).Tables[0];
            if (dtDiesel.Rows.Count > 0)
            {
                int i = 1;
                foreach (DataRow dr in dtDiesel.Rows)
                {
                    DataRow newrow = Report.NewRow();
                    newrow["Sno"] = i++.ToString();
                    string assigndate = dr["enddate"].ToString();
                    DateTime dtPlantime = Convert.ToDateTime(assigndate);
                    string date = dtPlantime.ToString("dd/MMM/yyyy");
                    string time = dtPlantime.ToString("dd/MMM/yyyy HH:mm");
                    string strPlantime = dtPlantime.ToString();
                    string[] PlanDateTime = time.Split(' ');
                    newrow["Date"] = date;
                    newrow["Time"] = PlanDateTime[1];
                    newrow["Route"] = dr["routeid"].ToString();
                    newrow["Vehicle No"] = dr["Vehicleno"].ToString();
                    newrow["Vehicle Type"] = dr["VehicleType"].ToString();
                    double Diesel = 0;
                    double.TryParse(dr["endfuelvalue"].ToString(), out Diesel);
                    double refrigeration_fuel = 0;
                    double.TryParse(dr["refrigeration_fuel"].ToString(), out refrigeration_fuel);
                    double total = 0;
                    total = Diesel + refrigeration_fuel;
                    newrow["Diesel Filled"] = total;
                    newrow["Start Reading"] = dr["vehicleStartReading"].ToString();
                    newrow["Pump Reading"] = dr["pumpreading"].ToString();
                    newrow["Token"] = dr["Tokenno"].ToString();
                    newrow["Driver Name"] = dr["employname"].ToString();
                    newrow["Load Type"] = dr["loadtype"].ToString();
                    Report.Rows.Add(newrow);
                }
                DataRow New = Report.NewRow();
                New["Vehicle No"] = "Total";
                foreach (DataColumn dc in Report.Columns)
                {
                    if (dc.DataType == typeof(Double))
                    {
                        double.TryParse(Report.Compute("sum([" + dc.ToString() + "])", "[" + dc.ToString() + "]<>'0'").ToString(), out valnewCash);
                        New[dc.ToString()] = valnewCash;
                        quantity = valnewCash;
                        ViewState["qty"] = quantity;
                    }
                }
                Report.Rows.Add(New);
                grdReports.DataSource = Report;
                grdReports.DataBind();
                string title = "DieselReport From: " + fromdate.ToString() + "  To: " + Todate.ToString();
                Session["title"] = title;
                Session["filename"] = "DieselReport";
                Session["xportdata"] = Report;
            }
            else
            {
                pvisible.Visible = false;
                lblmsg.Text = "No data were found";
            }
        }
        catch (Exception ex)
        {
            lblmsg.Text = ex.Message;
        }
    }
    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        try
        {
            vdm = new SalesDBManager();
            string dieselqty =  Session["quantity"].ToString();
             string branchid=  Session["Po_BranchID"].ToString();
            double qty = Convert.ToDouble(dieselqty);
            cmd = new SqlCommand("update productmoniter set qty=qty-@qty where productid='2285' AND branchid=@branchid");
            cmd.Parameters.Add("@branchid", branchid);
            cmd.Parameters.Add("@qty", qty);
            vdm.Update(cmd);

            cmd = new SqlCommand("insert into diesellogs(Date,Route,VehicleNo,VehicleType,DieselFilled,DriverName,LoadType,StartReading,PumpReading,Token) values ()");
          
            lblmsg.Text = "Successfuly Updated";
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
}