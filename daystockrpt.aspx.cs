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

public partial class daystockrpt : System.Web.UI.Page
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

                    lblAddress.Text = Session["Address"].ToString();
                    lblTitle.Text = Session["TitleName"].ToString();
                    btn_Generate_Click();

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
    public void btn_Generate_Click()
    {
        try
        {
            Report.Columns.Add("sno");
            Report.Columns.Add("ERP Code");
            Report.Columns.Add("Item Name");
            Report.Columns.Add("UOM");
            Report.Columns.Add("Opening Balance");
            Report.Columns.Add("Per Day Concsumption");
            Report.Columns.Add("No of Days");
            Report.Columns.Add("Remarks");
            lblmsg.Text = "";
            SalesDBManager SalesDB = new SalesDBManager();
            DateTime fromdate = DateTime.Now;
            DateTime todate = DateTime.Now;
            string branchid = Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT productmoniter.productid, uimmaster.uim, productmoniter.qty, productmoniter.price, productmoniter.branchid, productmoniter.minstock, productmoniter.maxstock, productmoniter.perdayconcsumption, productmaster.productname, productmaster.itemcode FROM productmoniter INNER JOIN productmaster ON productmoniter.productid = productmaster.productid INNER JOIN  uimmaster ON productmaster.uim = uimmaster.sno WHERE        (productmoniter.perdayconcsumption IS NOT NULL) AND (productmoniter.branchid = @branchid) ORDER BY productmaster.productid");
            cmd.Parameters.Add("@branchid", branchid);
            DataTable dtproducts = SalesDB.SelectQuery(cmd).Tables[0];
            var i = 1;
            if (dtproducts.Rows.Count > 0)
            {
                foreach (DataRow dr in dtproducts.Rows)
                {
                    DataRow newrow = Report.NewRow();
                    newrow["Sno"] = i++.ToString();
                    newrow["ERP Code"] = dr["itemcode"].ToString();
                    newrow["Item Name"] = dr["productname"].ToString();
                    newrow["UOM"] = dr["uim"].ToString();
                    newrow["Opening Balance"] = dr["qty"].ToString();
                    double minqty = 0;
                    double OBQTY = Convert.ToDouble(dr["qty"].ToString());
                    string perdayconcsumption = dr["perdayconcsumption"].ToString();
                    double days = 0;
                    if (perdayconcsumption != "0")
                    {
                        minqty = Convert.ToDouble(perdayconcsumption);
                        days = OBQTY / minqty;
                    }
                    
                    newrow["Per Day Concsumption"] = perdayconcsumption;
                    newrow["No of Days"] = Math.Round(days, 2);
                    newrow["Remarks"] = "Based on need vary the perday consumption";
                    Report.Rows.Add(newrow);
                }
                grdReports.DataSource = Report;
                grdReports.DataBind();
            }

        }
        catch (Exception ex)
        {
            lblmsg.Text = ex.Message;
            hidepanel.Visible = false;
        }
    }

    protected void btnexport_click(object sender, EventArgs e)
    {

        Response.Redirect("~/exporttoxl.aspx");

    }


    protected void grdReports_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        //if (e.Row.RowType == DataControlRowType.DataRow)
        //{
        //    //e.Row.Cells[4].Visible = false;
        //    if (e.Row.Cells.Count > 2)
        //    {
        //        if (e.Row.Cells[8].Text == "Required Urgently")
        //        {
        //            e.Row.BackColor = System.Drawing.Color.CadetBlue;
        //            e.Row.ForeColor = System.Drawing.Color.White;
        //        }
        //    }
        //}
    }
   
}