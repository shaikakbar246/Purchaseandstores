using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using MySql.Data.MySqlClient;
using System.Data.SqlClient;

public partial class storesdieselrpt : System.Web.UI.Page
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

    private void bindvechcle()
    {
        devdm = new VehicleDBMgr();
        vdm = new SalesDBManager();
        cmd = new SqlCommand("SELECT sectionid, name, color, status, sec_code, branchid FROM sectionmaster WHERE (name LIKE '%AP%' OR name LIKE '%TN%') AND (branchid = '2')");
        DataTable dtvehcle = vdm.SelectQuery(cmd).Tables[0];
        //vecmd = new MySqlCommand("SELECT  vm_sno, registration_no FROM vehicel_master");
        //DataTable dtvehcle = devdm.SelectQuery(vecmd).Tables[0];
        ddlvehicle.DataSource = dtvehcle;
        ddlvehicle.DataTextField = "name";
        ddlvehicle.DataValueField = "sectionid";
        ddlvehicle.DataBind();
        ddlvehicle.ClearSelection();
        ddlvehicle.Items.Insert(0, new ListItem { Value = "0", Text = "--Select VehcleNumber--", Selected = true });
        ddlvehicle.SelectedValue = "0";
    }

    protected void btn_Generate_Click(object sender, EventArgs e)
    {
        try
        {
            lblmsg.Text = "";
            Report.Columns.Add("Ledger Type");
            Report.Columns.Add("Customer Name");
            Report.Columns.Add("Invoce No.");
            Report.Columns.Add("Invoice Date");
            Report.Columns.Add("HSN Code");
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
            string product = ddl_product.SelectedItem.Value;
            string type = ddl_type.SelectedItem.Value;
            DataTable dtDiesel = new DataTable();
            if (product == "Spares")
            {
                if (type == "vehicle")
                {
                    int vehcleid = Convert.ToInt32(ddlvehicle.SelectedItem.Value);
                    cmd = new SqlCommand("SELECT suboutwarddetails.perunit, suboutwarddetails.totalcost, suboutwarddetails.quantity, productmaster.productname, sectionmaster.name, outwarddetails.inwarddate, productmaster.HSNcode, outwarddetails.issueno FROM outwarddetails INNER JOIN suboutwarddetails ON outwarddetails.sno = suboutwarddetails.in_refno INNER JOIN productmaster ON suboutwarddetails.productid = productmaster.productid INNER JOIN categorymaster ON productmaster.productcode = categorymaster.cat_code INNER JOIN sectionmaster ON outwarddetails.section_id = sectionmaster.sectionid WHERE (categorymaster.cat_code = '15') AND (outwarddetails.inwarddate BETWEEN @fromdate AND @todate) AND (outwarddetails.branchid = '2') AND (sectionmaster.sectionid = @vehcleid)");
                    cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
                    cmd.Parameters.Add("@todate", GetLowDate(Todate));
                    cmd.Parameters.Add("@vehcleid", vehcleid);
                }
                else
                {
                    cmd = new SqlCommand("SELECT suboutwarddetails.perunit, suboutwarddetails.totalcost, suboutwarddetails.quantity, productmaster.productname, sectionmaster.name, outwarddetails.inwarddate, productmaster.HSNcode, outwarddetails.issueno FROM outwarddetails INNER JOIN suboutwarddetails ON outwarddetails.sno = suboutwarddetails.in_refno INNER JOIN productmaster ON suboutwarddetails.productid = productmaster.productid INNER JOIN categorymaster ON productmaster.productcode = categorymaster.cat_code INNER JOIN sectionmaster ON outwarddetails.section_id = sectionmaster.sectionid WHERE (categorymaster.cat_code = '15') AND (outwarddetails.inwarddate BETWEEN @fromdate AND @todate) AND (outwarddetails.branchid = '2')");
                    cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
                    cmd.Parameters.Add("@todate", GetLowDate(Todate));

                }
                dtDiesel = vdm.SelectQuery(cmd).Tables[0];
            }
            else if (product == "Diesel")
            {

            }
            
             //devdm.SelectQuery(vecmd).Tables[0];
            if (dtDiesel.Rows.Count > 0)
            {
                int i = 1;
                foreach (DataRow dr in dtDiesel.Rows)
                {
                    DataRow newrow = Report.NewRow();
                    string assigndate = dr["inwarddate"].ToString();
                    DateTime dtPlantime = Convert.ToDateTime(assigndate);
                    string date = dtPlantime.ToString("dd-MMM-yyyy");
                    string time = dtPlantime.ToString("dd/MMM/yyyy HH:mm");
                    string strPlantime = dtPlantime.ToString();
                    string[] PlanDateTime = time.Split(' ');
                    string ledgertype = "Sales Accounts";
                    newrow["HSN Code"] = dr["HSNcode"].ToString(); //"27101930";
                    newrow["Ledger Type"] = ledgertype;
                    newrow["Invoice Date"] = date;
                    newrow["Customer Name"] = dr["name"].ToString();
                    double Diesel = 0;
                    double.TryParse(dr["quantity"].ToString(), out Diesel);
                    //double refrigeration_fuel = 0;
                    //double.TryParse(dr["refrigeration_fuel"].ToString(), out refrigeration_fuel);
                    double total = 0;
                    total = Diesel; //+ refrigeration_fuel;
                    newrow["Qty"] = total;
                    double RATE = Convert.ToDouble(dr["perunit"].ToString()); //Convert.ToDouble(PRICE);
                    double NETVAL = total * RATE;
                    newrow["Rate"] = RATE;
                    newrow["Invoce No."] = "SVDS/PBK/DSL" + dr["issueno"].ToString() + "";
                    newrow["CGST%"] = "0";
                    newrow["CGST Amount"] = "0";
                    newrow["IGST%"] = "0";
                    newrow["IGST Amount"] = "0";
                    newrow["SGST%"] = "0";
                    newrow["SGST Amount"] = "0";
                    newrow["Item Name"] = dr["productname"].ToString(); //"DIESEL";
                    newrow["Narration"] = "Being " + dr["productname"].ToString() + " Isuue To " + dr["name"].ToString() + " Invoice no: " + dr["issueno"].ToString() + ", Date: " + date + "";
                    newrow["Taxable Value"] = Math.Round(NETVAL, 2);
                    newrow["Net Value"] = Math.Round(NETVAL, 2);
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
                if (product == "Diesel")
                {
                    lblmsg.Text = "Please Goto Stores Diesel Report";
                }
                else
                {
                    lblmsg.Text = "No data were found";
                }
            }
        }
        catch (Exception ex)
        {
            lblmsg.Text = ex.Message;
        }
    }

    double valnewCash; double quantity;
    DataTable Report = new DataTable();

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
                        sqlcmd = new SqlCommand("Insert into diesel_consumptiondetails (productid, qty, doe, vehicleno, createdby, createddate) values (@productid, @qty, @doe, @vehicleno, @createdby, @createddate)");
                        sqlcmd.Parameters.Add("@productid", pid);
                        sqlcmd.Parameters.Add("@qty", qty);
                        sqlcmd.Parameters.Add("@doe", dt);
                        sqlcmd.Parameters.Add("@vehicleno", vcehicleno);
                        sqlcmd.Parameters.Add("@createdby", createdby);
                        sqlcmd.Parameters.Add("@createddate", CreateDate);
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
    protected void changetype(object sender, EventArgs e)
    {
        string type = ddl_type.SelectedItem.Value;
        if (type == "vehicle")
        {
            lbl_vehicle.Visible = true;
            ddlvehicle.Visible = true;
            bindvechcle();
        }
        else
        {
            lbl_vehicle.Visible = false;
            ddlvehicle.Visible = false;
        }
    }
    protected void ddl_product_SelectedIndexChanged(object sender, EventArgs e)
    {

    }
}