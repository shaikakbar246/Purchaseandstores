using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class VendordetailsReport : System.Web.UI.Page
{
    SqlCommand cmd;
    ///string BranchID = "";
    SalesDBManager vdm;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["Po_BranchID"] == null)
            Response.Redirect("Login.aspx");
        else
        {
            //BranchID = Session["Po_BranchID"].ToString();
            vdm = new SalesDBManager();
            if (!Page.IsPostBack)
            {
                if (!Page.IsCallback)
                {
                    lblAddress.Text = Session["Address"].ToString();
                    GetReport();
                    lblTitle.Text = Session["TitleName"].ToString();
                }
            }
        }
    }
    void GetReport()
    {
        try
        {
            SalesDBManager SalesDB = new SalesDBManager();
            lblmsg.Text = "";
            DataTable dtIssueTyre = new DataTable();
            string branchid = Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT  supplierid, name, description, companyname, contactname, street1, street2, city, state, country, zipcode, phoneno, mobileno, emailid, websiteurl, createdby,createdon, status, warranty, warrantytype, insurance, insuranceamount, contactnumber, branchid, name + '_' + street1 AS Address FROM suppliersdetails WHERE (branchid = @branchid)");
            //cmd = new SqlCommand("SELECT sno, productid, qty, doe, vehicleno, branchid FROM diesel_consumptiondetails ORDER BY doe");
            cmd.Parameters.Add("@branchid", branchid);
            DataTable dtoutward = SalesDB.SelectQuery(cmd).Tables[0];
            if (dtoutward.Rows.Count > 0)
            {
                grdReports.DataSource = dtoutward;
                grdReports.DataBind();
                string title = "Supplier Details";
                Session["title"] = title;
                Session["filename"] = "Supplier Details Report";
                Session["xportdata"] = dtoutward;
            }
            else
            {
                lblmsg.Text = "No data found";
            }
        }
        catch (Exception ex)
        {
            lblmsg.Text = ex.Message;
        }
    }
}