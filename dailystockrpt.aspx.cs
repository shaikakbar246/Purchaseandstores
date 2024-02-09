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

public partial class dailystockrpt : System.Web.UI.Page
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
            Report.Columns.Add("Category");
            Report.Columns.Add("Item Name");
            Report.Columns.Add("UOM");
            Report.Columns.Add("Opening Balance");
            Report.Columns.Add("Minimum Level");
            Report.Columns.Add("Requirement (Ordering Qty)");
            Report.Columns.Add("Remarks");
            lblmsg.Text = "";
            SalesDBManager SalesDB = new SalesDBManager();
            DateTime fromdate = DateTime.Now;
            DateTime todate = DateTime.Now;
            string branchid = Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT productmaster.productname, uimmaster.uim, productmaster.sku, categorymaster.category, productmaster.productid, productmoniter.qty, productmoniter.minstock  FROM  productmaster INNER JOIN productmoniter ON productmoniter.productid = productmaster.productid INNER JOIN categorymaster ON productmaster.categoryid = categorymaster.categoryid INNER JOIN  uimmaster ON productmaster.uim = uimmaster.sno WHERE (productmoniter.branchid = @branchid) ORDER BY productmaster.categoryid");//  WHERE branchid = @branchid
            cmd.Parameters.Add("@branchid", branchid);
            DataTable dtproducts = SalesDB.SelectQuery(cmd).Tables[0];
            var i = 1;
            if (dtproducts.Rows.Count > 0)
            {
                foreach (DataRow dr in dtproducts.Rows)
                {
                    string ob = dr["qty"].ToString();
                    if (ob != "0")
                    {
                        DataRow newrow = Report.NewRow();
                        newrow["Sno"] = i++.ToString();
                        newrow["ERP Code"] = dr["sku"].ToString();
                        newrow["Item Name"] = dr["productname"].ToString();
                        newrow["Category"] = dr["category"].ToString();
                        newrow["UOM"] = dr["uim"].ToString();
                        newrow["Opening Balance"] = dr["qty"].ToString();
                        double minqty = 0;
                        newrow["Minimum Level"] = dr["minstock"].ToString();
                        double OBQTY = Convert.ToDouble(dr["qty"].ToString());
                        string minstock = dr["minstock"].ToString();
                        if (minstock != "")
                        {
                            minqty = Convert.ToDouble(minstock);
                        }
                        if (OBQTY > minqty)
                        {
                            newrow["Requirement (Ordering Qty)"] = "Basing on need";
                            newrow["Remarks"] = "";
                        }
                        else
                        {
                            newrow["Requirement (Ordering Qty)"] = minqty;
                            newrow["Remarks"] = "Required Urgently";
                        }
                        Report.Rows.Add(newrow);
                    }
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
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            //e.Row.Cells[4].Visible = false;
            if (e.Row.Cells.Count > 2)
            {
                if (e.Row.Cells[8].Text == "Required Urgently")
                {
                    e.Row.BackColor = System.Drawing.Color.CadetBlue;
                    e.Row.ForeColor = System.Drawing.Color.White;
                }
            }
        }
    }
   
}