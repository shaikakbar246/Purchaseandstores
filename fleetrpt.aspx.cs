using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using MySql.Data.MySqlClient;
using System.Data.SqlClient;
using System;

public partial class fleetrpt : System.Web.UI.Page
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
        ddlvehicle.DataSource = dtvehcle;
        ddlvehicle.DataTextField = "registration_no";
        ddlvehicle.DataValueField = "vm_sno";
        ddlvehicle.DataBind();
        ddlvehicle.ClearSelection();
        ddlvehicle.Items.Insert(0, new ListItem { Value = "0", Text = "--Select VehcleNumber--", Selected = true });
        ddlvehicle.SelectedValue = "0";
    }


    double valnewCash; double quantity;
    DataTable Report = new DataTable();
    protected void btn_Generate_Click(object sender, EventArgs e)
    {
        try
        {
            lblmsg.Text = "";
            Report.Columns.Add("Ledger Type");
            Report.Columns.Add("Customer Name");
            Report.Columns.Add("Invoce No.");
            Report.Columns.Add("Invoice Date");
            Report.Columns.Add("Item Name");
            Report.Columns.Add("Qty");
            Report.Columns.Add("Rate");
            Report.Columns.Add("Taxable Value");
            Report.Columns.Add("SGST%");
            Report.Columns.Add("SGST Amount");
            Report.Columns.Add("CGST%");
            Report.Columns.Add("CGST Amount");
            Report.Columns.Add("IGST%");
            Report.Columns.Add("IGST Amount");
            Report.Columns.Add("Net Value");
            Report.Columns.Add("Narration");
            devdm = new VehicleDBMgr();
            SalesDBManager vdm = new SalesDBManager();
            DateTime fromdate = DateTime.Now;
            string[] dateFromstrig = dtp_FromDate.Text.Split(' ');

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
            string[] dateTostrig = dtp_Todate.Text.Split(' ');
            if (dateTostrig.Length > 1)
            {
                if (dateTostrig[0].Split('-').Length > 0)
                {
                    string[] dates = dateTostrig[0].Split('-');
                    string[] times = dateTostrig[1].Split(':');
                    Todate = new DateTime(int.Parse(dates[2]), int.Parse(dates[1]), int.Parse(dates[0]), int.Parse(times[0]), int.Parse(times[1]), 0);
                }
            }
            lblFromDate.Text = fromdate.ToString("dd/MM/yyyy");
            lbltodate.Text = Todate.ToString("dd/MM/yyyy");
            int vehcleid = Convert.ToInt32(ddlvehicle.SelectedItem.Value);
           
            vecmd = new MySqlCommand("SELECT sno, fuel, doe, userid, operetedby, costperltr FROM fuel_transaction WHERE (doe BETWEEN @d1 AND @d2) AND (transtype = 2)");
            vecmd.Parameters.Add("@d1", GetLowDate(fromdate).AddDays(-1));
            vecmd.Parameters.Add("@d2", GetHighDate(Todate).AddDays(-1));
            DataTable dtOpp = devdm.SelectQuery(vecmd).Tables[0];
            if (dtOpp.Rows.Count > 0)
            {

            }
            vecmd = new MySqlCommand("SELECT sno, fuel, doe, userid, operetedby, costperltr FROM fuel_transaction WHERE (doe BETWEEN @d1 AND @d2) AND (transtype = 2)");
            vecmd.Parameters.Add("@d1", GetLowDate(fromdate));
            vecmd.Parameters.Add("@d2", GetHighDate(Todate));
            DataTable dtclo = devdm.SelectQuery(vecmd).Tables[0];
            if (dtclo.Rows.Count > 0)
            {

            }
            int BranchID = 1;
            if (vehcleid != 0)
            {
                vecmd = new MySqlCommand("SELECT employdata.employname,tripdata.routeid, tripdata.DieselCost, tripdata.fueltank,tripdata.pumpreading,tripdata.Tokenno, tripdata.vehiclestartreading,tripdata.refrigeration_fuel, tripdata.gpskms, tripdata.tripsheetno, tripdata.enddate, employdata.Phoneno AS phoneNumber, tripdata.sno, tripdata.loadtype, employdata.emp_licencenum AS LicenseNo, tripdata.routeid AS RouteName, vehicel_master.registration_no AS Vehicleno, vehicel_master.vm_model AS VehicleModel, minimasters.mm_name AS VehicleType, minimasters_1.mm_name AS VehicleMake,tripdata.endfuelvalue FROM tripdata INNER JOIN employdata ON tripdata.driverid = employdata.emp_sno INNER JOIN vehicel_master ON tripdata.vehicleno = vehicel_master.vm_sno INNER JOIN minimasters ON vehicel_master.vhtype_refno = minimasters.sno INNER JOIN minimasters minimasters_1 ON vehicel_master.vhmake_refno = minimasters_1.sno WHERE (tripdata.enddate BETWEEN @d1 AND @d2) AND (tripdata.userid = @BranchID) AND (tripdata.status = 'C') AND (vehicel_master.vm_sno=@vehcleid)  order by tripdata.enddate");
                vecmd.Parameters.Add("@BranchID", BranchID);
                vecmd.Parameters.Add("@d1", GetLowDate(fromdate));
                vecmd.Parameters.Add("@d2", GetHighDate(Todate));
                vecmd.Parameters.Add("@vehcleid", vehcleid);
            }
            else
            {

                vecmd = new MySqlCommand("SELECT employdata.employname,tripdata.routeid, tripdata.DieselCost, tripdata.fueltank,tripdata.pumpreading,tripdata.Tokenno, tripdata.vehiclestartreading,tripdata.refrigeration_fuel, tripdata.gpskms, tripdata.tripsheetno, tripdata.enddate, employdata.Phoneno AS phoneNumber, tripdata.sno, tripdata.loadtype, employdata.emp_licencenum AS LicenseNo, tripdata.routeid AS RouteName, vehicel_master.registration_no AS Vehicleno, vehicel_master.vm_model AS VehicleModel, minimasters.mm_name AS VehicleType, minimasters_1.mm_name AS VehicleMake,tripdata.endfuelvalue FROM tripdata INNER JOIN employdata ON tripdata.driverid = employdata.emp_sno INNER JOIN vehicel_master ON tripdata.vehicleno = vehicel_master.vm_sno INNER JOIN minimasters ON vehicel_master.vhtype_refno = minimasters.sno INNER JOIN minimasters minimasters_1 ON vehicel_master.vhmake_refno = minimasters_1.sno WHERE (tripdata.enddate BETWEEN @d1 AND @d2) AND (tripdata.userid = @BranchID) AND (tripdata.status = 'C')  order by tripdata.enddate");
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
                    string assigndate = dr["enddate"].ToString();
                    DateTime dtPlantime = Convert.ToDateTime(assigndate);
                    string date = dtPlantime.ToString("dd-MMM-yyyy");
                    string time = dtPlantime.ToString("dd/MMM/yyyy HH:mm");
                    string strPlantime = dtPlantime.ToString();
                    string[] PlanDateTime = time.Split(' ');
                    string ledgertype = "Sales Accounts";
                    newrow["Ledger Type"] = ledgertype;
                    newrow["Invoice Date"] = date;
                    newrow["Customer Name"] = dr["Vehicleno"].ToString();

                    double DieselCost = 0;
                    double.TryParse(dr["DieselCost"].ToString(), out DieselCost);
                    double Diesel = 0;
                    double.TryParse(dr["endfuelvalue"].ToString(), out Diesel);
                    double refrigeration_fuel = 0;
                    double.TryParse(dr["refrigeration_fuel"].ToString(), out refrigeration_fuel);
                    double total = 0;
                    total = Diesel + refrigeration_fuel;
                    newrow["Qty"] = total;
                    double NETVAL = total * DieselCost;
                    newrow["Rate"] = DieselCost;
                    newrow["Invoce No."] = "SVDS/PBK/DSL" + dr["Tokenno"].ToString() + "";
                    newrow["Item Name"] = "DIESEL";
                    newrow["Narration"] = "Being Diesel Isuue To " + dr["Vehicleno"].ToString() + " Invoice no: " + dr["Tokenno"].ToString() + ", Date: " + date + "";
                    newrow["Taxable Value"] = Math.Round(NETVAL, 2);
                    newrow["Net Value"] = Math.Round(NETVAL, 2);
                    newrow["CGST%"] = "0";
                    newrow["CGST Amount"] = "0";
                    newrow["IGST%"] = "0";
                    newrow["IGST Amount"] = "0";
                    newrow["SGST%"] = "0";
                    newrow["SGST Amount"] = "0";
                    Report.Rows.Add(newrow);
                }
                grdReports.DataSource = Report;
                grdReports.DataBind();
                string title = "DieselReport From: " + fromdate.ToString() + "  To: " + Todate.ToString();
                Session["title"] = title;
                Session["filename"] = "DieselReport";
                Session["xportdata"] = Report;
                //Session["quantity"] = quantity;
            }
            else
            {
                lblmsg.Text = "No data were found";
            }
        }
        catch (Exception ex)
        {
            lblmsg.Text = ex.Message;
        }
    }
    SqlCommand sqlcmd;
    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        try
        {

            SalesDBManager nvdm = new SalesDBManager();
            DataTable dtconsumption = (DataTable)Session["xportdata"];
            DateTime CreateDate = SalesDBManager.GetTime(nvdm.conn);
            string createdby = Session["Employ_Sno"].ToString();
            if (dtconsumption.Rows.Count > 0)
            {
                foreach (DataRow dr in dtconsumption.Rows)
                {
                    string date = dr["Invoice Date"].ToString();
                    DateTime dt = Convert.ToDateTime(date);
                    string qty = dr["Qty"].ToString();
                    string vcehicleno = dr["Customer Name"].ToString();
                    string Rate = dr["Rate"].ToString();
                    string pid = "2285";
                    if (Convert.ToDouble(qty) > 0)
                    {
                        sqlcmd = new SqlCommand("Insert into diesel_consumptiondetails (productid, qty, doe, vehicleno, dieselcost, createdby, createddate, branchid, categoryid, subcategoryid) values (@productid, @qty, @doe, @vehicleno, @dieselcost, @createdby, @createddate,@branchid, @catid, @subcatid)");
                        sqlcmd.Parameters.Add("@productid", pid);
                        sqlcmd.Parameters.Add("@qty", qty);
                        sqlcmd.Parameters.Add("@doe", dt);
                        sqlcmd.Parameters.Add("@vehicleno", vcehicleno);
                        sqlcmd.Parameters.Add("@createdby", createdby);
                        sqlcmd.Parameters.Add("@createddate", CreateDate);
                        sqlcmd.Parameters.Add("@dieselcost", Rate);
                        sqlcmd.Parameters.Add("@branchid", "2");
                        sqlcmd.Parameters.Add("@catid", "8");
                        sqlcmd.Parameters.Add("@subcatid", "37");
                        nvdm.insert(sqlcmd);

                        sqlcmd = new SqlCommand("update productmoniter set qty=qty-@qty where productid='2285' AND branchid=@branchid");
                        sqlcmd.Parameters.Add("@branchid", "2");
                        sqlcmd.Parameters.Add("@qty", qty);
                        nvdm.Update(sqlcmd);
                    }

                }
                lblmsg.Text = "Successfuly Saved";
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
}