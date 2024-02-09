using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

public partial class Vehicle_Consumption_Report : System.Web.UI.Page
{
    SqlCommand cmd;
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
                    bindvechicle();
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

    private void bindvechicle()
    {
        vdm = new SalesDBManager();
        cmd = new SqlCommand("select sectionid,name from sectionmaster where name like '%AP%'");
        DataTable dtvehcle = vdm.SelectQuery(cmd).Tables[0];
        ddl_vehicle_no.DataSource = dtvehcle;
        ddl_vehicle_no.DataTextField = "name";
        ddl_vehicle_no.DataValueField = "name";
        ddl_vehicle_no.DataBind();
        ddl_vehicle_no.ClearSelection();
        ddl_vehicle_no.Items.Insert(0, new ListItem { Value = "0", Text = "--Select VehcleNumber--", Selected = true });
        ddl_vehicle_no.SelectedValue = "0";
    }

    DataTable Report = new DataTable();
    protected void btn_Generate_Click(object sender, EventArgs e)
    {
        try
        {
            Report.Columns.Add("SNO");
            Report.Columns.Add("Vehicle No");
            Report.Columns.Add("Product Name");
            Report.Columns.Add("UOM");
            Report.Columns.Add("Quantity");
            Report.Columns.Add("Price");
            Report.Columns.Add("Date");
            lblmsg.Text = "";
            vdm = new SalesDBManager();
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
            string vehicleno = ddl_vehicle_no.SelectedItem.Value;
            //cmd = new SqlCommand("SELECT sectionmaster.name, outwarddetails.inwarddate, outwarddetails.issueno, outwarddetails.branchid, suboutwarddetails.productid, suboutwarddetails.perunit, suboutwarddetails.quantity, suboutwarddetails.uim, productmaster.productname, uimmaster.uim AS uom FROM outwarddetails INNER JOIN suboutwarddetails ON outwarddetails.sno = suboutwarddetails.in_refno LEFT OUTER JOIN sectionmaster ON outwarddetails.section_id = sectionmaster.sectionid INNER JOIN productmaster ON suboutwarddetails.productid = productmaster.productid LEFT OUTER JOIN uimmaster ON suboutwarddetails.uim = uimmaster.sno WHERE (sectionmaster.name = @vehicleno) AND (outwarddetails.branchid = @branchid) AND (outwarddetails.inwarddate BETWEEN @fromdate AND @todate)");
            cmd = new SqlCommand("SELECT sectionmaster.name, outwarddetails.inwarddate, outwarddetails.issueno, outwarddetails.branchid, suboutwarddetails.productid, suboutwarddetails.perunit, suboutwarddetails.quantity, suboutwarddetails.uim, productmaster.productname, uimmaster.uim AS uom FROM outwarddetails INNER JOIN suboutwarddetails ON outwarddetails.sno = suboutwarddetails.in_refno LEFT OUTER JOIN sectionmaster ON outwarddetails.section_id = sectionmaster.sectionid INNER JOIN productmaster ON suboutwarddetails.productid = productmaster.productid LEFT OUTER JOIN uimmaster ON suboutwarddetails.uim = uimmaster.sno WHERE (sectionmaster.name = @vehicleno) AND (outwarddetails.branchid = @branchid) AND (outwarddetails.inwarddate BETWEEN @fromdate AND @todate)");
            cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
            cmd.Parameters.Add("@todate", GetHighDate(todate));
            cmd.Parameters.Add("@vehicleno", vehicleno);
            cmd.Parameters.Add("@branchid", branchid);
            DataTable dt_data = vdm.SelectQuery(cmd).Tables[0];
            if (dt_data.Rows.Count > 0)
            {
                int a=1;
                //string pre_veh_no = "";
                double total_quantity = 0, total_price = 0;
                foreach (DataRow dr in dt_data.Rows)
                {
                    DataRow newrow = Report.NewRow();
                    string veh_no = dr["name"].ToString();
                    //if (veh_no == pre_veh_no)
                    //{
                    //    newrow["SNO"] = a.ToString();
                    //    newrow["Vehicle No"] = "";
                    //    newrow["Product Name"] = dr["productname"].ToString();
                    //    newrow["UOM"] = dr["uom"].ToString();
                    //    newrow["Quantity"] = dr["quantity"].ToString();
                    //    newrow["Date"] = dr["inwarddate"].ToString();
                    //}
                    //else
                    //{
                    //pre_veh_no = veh_no;
                    newrow["SNO"] = a.ToString();
                    newrow["Vehicle No"] = veh_no;
                    newrow["Product Name"] = dr["productname"].ToString();
                    newrow["UOM"] = dr["uom"].ToString();
                    newrow["Quantity"] = dr["quantity"].ToString();
                    total_quantity += Convert.ToDouble(dr["quantity"].ToString());
                    newrow["Price"] = dr["perunit"].ToString();
                    total_price += Convert.ToDouble(dr["perunit"].ToString());
                    newrow["Date"] = dr["inwarddate"].ToString();
                    //}
                    Report.Rows.Add(newrow);
                    a++;
                }
                DataRow totalrow = Report.NewRow();
                totalrow["Vehicle No"] = "Total";
                totalrow["Quantity"] = total_quantity.ToString();
                totalrow["Price"] = total_price.ToString();
                Report.Rows.Add(totalrow);
                grdReports.DataSource = Report;
                grdReports.DataBind();
                hidepanel.Visible = true;
            }
        }
        catch (Exception ex)
        {
            lblmsg.Text = ex.Message;
            hidepanel.Visible = false;
        }
    }
    protected void OnRowDataBound(object sender, GridViewRowEventArgs e)
    {

        if (e.Row.RowType == DataControlRowType.Header)
        {
            e.Row.Cells[0].HorizontalAlign = HorizontalAlign.Center;
        }

    }
}