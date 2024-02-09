using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.Common;
using System.Data.OleDb;
using System.Data.SqlClient;
using System.Data;
using MySql.Data.MySqlClient;
using System.Data.SqlClient;
public partial class Tally_Diesel_Report : System.Web.UI.Page
{
    MySqlCommand vecmd;
    VehicleDBMgr devdm;
    SqlCommand cmd;
    //string BranchID = "";
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
            Report.Columns.Add("Token No");
            Report.Columns.Add("JV Date");
            Report.Columns.Add("Ledger Name");
            Report.Columns.Add("Amount");
            Report.Columns.Add("Narration");
            lblmsg.Text = "";
            devdm = new VehicleDBMgr();

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
            string vehicletype = ddl_veh_type.SelectedItem.Value;
            string veh_type_name = ddl_veh_type.SelectedItem.Text;
            if (veh_type_name == "Puff")
            {
                vecmd = new MySqlCommand("SELECT employdata.employname,tripdata.routeid, tripdata.DieselCost, tripdata.fueltank,tripdata.pumpreading,tripdata.Tokenno, tripdata.vehiclestartreading,tripdata.refrigeration_fuel, tripdata.gpskms, tripdata.tripsheetno, tripdata.enddate, employdata.Phoneno AS phoneNumber, tripdata.sno, tripdata.loadtype, employdata.emp_licencenum AS LicenseNo, tripdata.routeid AS RouteName, vehicel_master.registration_no AS Vehicleno, vehicel_master.vhtype_refno as veh_type, vehicel_master.vm_model AS VehicleModel, minimasters.mm_name AS VehicleType, minimasters_1.mm_name AS VehicleMake,tripdata.endfuelvalue FROM tripdata INNER JOIN employdata ON tripdata.driverid = employdata.emp_sno INNER JOIN vehicel_master ON tripdata.vehicleno = vehicel_master.vm_sno INNER JOIN minimasters ON vehicel_master.vhtype_refno = minimasters.sno INNER JOIN minimasters minimasters_1 ON vehicel_master.vhmake_refno = minimasters_1.sno WHERE (tripdata.enddate BETWEEN @d1 AND @d2) AND (tripdata.userid = @BranchID) AND (tripdata.status = 'C') AND (tripdata.Tokenno > 0) AND (vehicel_master.vhtype_refno=@veh_type)  order by tripdata.enddate");
                vecmd.Parameters.Add("@veh_type", vehicletype);
            }
            else if (veh_type_name == "Tanker")
            {
                vecmd = new MySqlCommand("SELECT employdata.employname,tripdata.routeid, tripdata.DieselCost, tripdata.fueltank,tripdata.pumpreading,tripdata.Tokenno, tripdata.vehiclestartreading,tripdata.refrigeration_fuel, tripdata.gpskms, tripdata.tripsheetno, tripdata.enddate, employdata.Phoneno AS phoneNumber, tripdata.sno, tripdata.loadtype, employdata.emp_licencenum AS LicenseNo, tripdata.routeid AS RouteName, vehicel_master.registration_no AS Vehicleno, vehicel_master.vhtype_refno as veh_type, vehicel_master.vm_model AS VehicleModel, minimasters.mm_name AS VehicleType, minimasters_1.mm_name AS VehicleMake,tripdata.endfuelvalue FROM tripdata INNER JOIN employdata ON tripdata.driverid = employdata.emp_sno INNER JOIN vehicel_master ON tripdata.vehicleno = vehicel_master.vm_sno INNER JOIN minimasters ON vehicel_master.vhtype_refno = minimasters.sno INNER JOIN minimasters minimasters_1 ON vehicel_master.vhmake_refno = minimasters_1.sno WHERE (tripdata.enddate BETWEEN @d1 AND @d2) AND (tripdata.userid = @BranchID) AND (tripdata.status = 'C') AND (tripdata.Tokenno > 0) AND (vehicel_master.vhtype_refno=@veh_type)  order by tripdata.enddate");
                vecmd.Parameters.Add("@veh_type", vehicletype);
            }
            else
            {
                vecmd = new MySqlCommand("SELECT employdata.employname,tripdata.routeid,tripdata.DieselCost, tripdata.fueltank,tripdata.pumpreading,tripdata.Tokenno, tripdata.vehiclestartreading,tripdata.refrigeration_fuel, tripdata.gpskms, tripdata.tripsheetno, tripdata.enddate, employdata.Phoneno AS phoneNumber, tripdata.sno, tripdata.loadtype, employdata.emp_licencenum AS LicenseNo, tripdata.routeid AS RouteName, vehicel_master.registration_no AS Vehicleno, vehicel_master.vhtype_refno as veh_type, vehicel_master.vm_model AS VehicleModel, minimasters.mm_name AS VehicleType, minimasters_1.mm_name AS VehicleMake,tripdata.endfuelvalue FROM tripdata INNER JOIN employdata ON tripdata.driverid = employdata.emp_sno INNER JOIN vehicel_master ON tripdata.vehicleno = vehicel_master.vm_sno INNER JOIN minimasters ON vehicel_master.vhtype_refno = minimasters.sno INNER JOIN minimasters minimasters_1 ON vehicel_master.vhmake_refno = minimasters_1.sno WHERE (tripdata.enddate BETWEEN @d1 AND @d2) AND (tripdata.userid = @BranchID) AND (tripdata.status = 'C') AND (tripdata.Tokenno > 0) AND (vehicel_master.vhtype_refno != '7') AND (vehicel_master.vhtype_refno != '22') order by tripdata.enddate");//
            }
            vecmd.Parameters.Add("@d1", GetLowDate(fromdate)); 
            vecmd.Parameters.Add("@d2", GetHighDate(todate));
            vecmd.Parameters.Add("@BranchID", "1");

            DataTable dt_diesel = devdm.SelectQuery(vecmd).Tables[0];
            if (dt_diesel.Rows.Count > 0)
            {                                                               
                string pre_token_no = "";
                foreach (DataRow dr in dt_diesel.Rows)
                {
                    string token_no = dr["Tokenno"].ToString();

                    
                    DataRow newrow = Report.NewRow();
                    newrow["Token No"] = token_no;
                    string assigndate = dr["enddate"].ToString();
                    DateTime dtPlantime = Convert.ToDateTime(assigndate);
                    string date = dtPlantime.ToString("dd-MMM-yyyy");
                    newrow["JV Date"] = date;
                    newrow["Ledger Name"] = "SVDS Diesel Bunk (Punambakkam)";
                    double Diesel = 0;
                    double.TryParse(dr["endfuelvalue"].ToString(), out Diesel);
                    double DieselCost = 0;
                    double.TryParse(dr["DieselCost"].ToString(), out DieselCost);

                    double refrigeration_fuel = 0;
                    double.TryParse(dr["refrigeration_fuel"].ToString(), out refrigeration_fuel);
                    double total = 0;
                    total = Diesel + refrigeration_fuel;
                    double NETVAL = total * DieselCost;
                    double value = Math.Round(NETVAL, 0);
                    string val = value.ToString();
                    newrow["Amount"] = "-" + val;
                    newrow["Narration"] = "Being the Diesel Filling Qty in Ltr " + total.ToString() + " @ Rs." + DieselCost.ToString() + "/- per Ltr for " + dr["Vehicleno"].ToString() + " Vehicle Token No:" + token_no;
                    Report.Rows.Add(newrow);

                    DataRow newrow1 = Report.NewRow();
                    newrow1["Token No"] = token_no;
                    newrow1["JV Date"] = date;
                    if (dr["veh_type"].ToString() == "7")
                    {
                        newrow1["Ledger Name"] = "Sales Maintenance-Pbk-Diesel";
                    }
                    else if (dr["veh_type"].ToString() == "22")
                    {
                        newrow1["Ledger Name"] = "SVDS Tanker-" + dr["Vehicleno"].ToString();
                    }
                    else
                    {
                        string vt = dr["VehicleType"].ToString();
                        if (vt == "407")
                        {
                            newrow1["Ledger Name"] = "Diesel-Pbk (Generator)";
                        }
                        else
                        {
                            newrow1["Ledger Name"] = "SVDS " + dr["VehicleType"].ToString() + "-" + dr["Vehicleno"].ToString();
                        }
                    }
                    //newrow1["Ledger Name"] = "SVDS Tanker-" + dr["Vehicleno"].ToString();
                    newrow1["Amount"] = Math.Round(NETVAL, 0).ToString();
                    newrow1["Narration"] = "";
                    Report.Rows.Add(newrow1);
                }
                Session["xportdata"] = Report;
                Session["filename"] = "Tally Diesel Report";
                Session["Address"] = "";
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
            
        }
    }
}