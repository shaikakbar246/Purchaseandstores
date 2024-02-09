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

public partial class storesstocktransfor : System.Web.UI.Page
{
    SqlCommand cmd;
    SalesDBManager vdm;
    public string tempinvoiceno = string.Empty;
    public double temptotal = 0.0;
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
                    bindbranches();
                    //ddlbranchname.Visible = false;
                    //Label1.Visible = false;
                }
            }
        }
    }
    private void bindbranches()
    {
        string branchid1 = Session["Po_BranchID"].ToString();
        cmd = new SqlCommand("SELECT  branchid, branchname FROM branchmaster");
        // cmd = new SqlCommand("SELECT  branchid, branchname FROM branchmaster where branchid=@branchid");
        cmd.Parameters.Add("@branchid", branchid1);
        DataTable dttrips = vdm.SelectQuery(cmd).Tables[0];
        ddlbranch.DataSource = dttrips;
        ddlbranch.DataTextField = "branchname";
        ddlbranch.DataValueField = "branchid";
        ddlbranch.DataBind();
        ddlbranch.ClearSelection();
        ddlbranch.Items.Insert(0, new ListItem { Value = "0", Text = "--Select Branch--", Selected = true });
        ddlbranch.SelectedValue = "0";
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
            lblFromDate.Text = fromdate.ToString("dd/MM/yyyy");
            lbltodate.Text = todate.ToString("dd/MM/yyyy");
            string branch_id = Session["Po_BranchID"].ToString();
            string bid = ddlbranch.SelectedItem.Value;

            cmd = new SqlCommand("SELECT stocktransferdetails.salesinvoiceno, stocktransfersubdetails.igst, stocktransfersubdetails.cgst, stocktransfersubdetails.sgst, stocktransferdetails.salesstno, stocktransferdetails.transportname, stocktransferdetails.remarks, stocktransferdetails.invoicetype,stocktransferdetails.invoiceno, stocktransferdetails.invoicedate AS invoicedate, stocktransferdetails.vehicleno,stocktransfersubdetails.price,stocktransfersubdetails.taxvalue,stocktransfersubdetails.taxtype,stocktransfersubdetails.freigtamt,stocktransferdetails.sno as refno,stocktransfersubdetails.sno,branchmaster.branchname, branchmaster_1.branchname AS BranchName, productmaster.productname, stocktransferdetails.frombranch, stocktransferdetails.tobranch,  stocktransfersubdetails.quantity, stocktransfersubdetails.stock_refno, stocktransfersubdetails.productid, stocktransferdetails.doe FROM  stocktransferdetails INNER JOIN stocktransfersubdetails ON stocktransferdetails.sno = stocktransfersubdetails.stock_refno LEFT OUTER JOIN  branchmaster ON stocktransferdetails.frombranch = branchmaster.branchid LEFT OUTER JOIN branchmaster AS branchmaster_1 ON stocktransferdetails.tobranch = branchmaster_1.branchid INNER JOIN productmaster ON stocktransfersubdetails.productid = productmaster.productid where (stocktransferdetails.invoicedate between @fromdate and @todate) AND (stocktransferdetails.tobranch=@branch_id) AND (stocktransferdetails.branchid=@MAINBRANCH) and (stocktransfersubdetails.quantity>0)");
            cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
            cmd.Parameters.Add("@todate", GetHighDate(todate));
            cmd.Parameters.Add("@branch_id", bid);
            cmd.Parameters.Add("@MAINBRANCH", branch_id);
            
            DataTable dtstocktransfer = SalesDB.SelectQuery(cmd).Tables[0];
            if (dtstocktransfer.Rows.Count > 0)
            {
                double total_amount = 0, totamt = 0, totalprice = 0, totalqty = 0, totaltaxamt = 0, gtotaltaxamt = 0, taxamount = 0, ttaxamount = 0, ttotalamount = 0;
                int count = 1;
                int rowcount = 1;
                double tfreight = 0, gtotalqty = 0, gtotalamount = 0, gfrightamt = 0, gtaxamount = 0;
                string previnvoiceno = "";


                DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
                DateTime dtapril = new DateTime();
                DateTime dtmarch = new DateTime();
                int currentyear = ServerDateCurrentdate.Year;
                int nextyear = ServerDateCurrentdate.Year + 1;
                int currntyearnum = 0;
                int nextyearnum = 0;
                if (ServerDateCurrentdate.Month > 3)
                {
                    string apr = "4/1/" + currentyear;
                    dtapril = DateTime.Parse(apr);
                    string march = "3/31/" + nextyear;
                    dtmarch = DateTime.Parse(march);
                    currntyearnum = currentyear;
                    nextyearnum = nextyear;
                }
                if (ServerDateCurrentdate.Month <= 3)
                {
                    string apr = "4/1/" + (currentyear - 1);
                    dtapril = DateTime.Parse(apr);
                    string march = "3/31/" + (nextyear - 1);
                    dtmarch = DateTime.Parse(march);
                    currntyearnum = currentyear - 1;
                    nextyearnum = nextyear - 1;
                }
                cmd = new SqlCommand("select statemaster.sno,statemaster.code AS statecode,statemaster.gststatecode,statemaster.statename,branchmaster.GSTIN,branchmaster.address,branchmaster.branchname from statemaster INNER JOIN branchmaster ON statemaster.sno = branchmaster.statename WHERE branchmaster.branchid = @branch_id");
                cmd.Parameters.Add("@branch_id", branch_id);
                DataTable dt_branch = vdm.SelectQuery(cmd).Tables[0];
                string fromstate = dt_branch.Rows[0]["statename"].ToString();
                string frombranch_gstin = dt_branch.Rows[0]["GSTIN"].ToString();
                string frombranch_address = dt_branch.Rows[0]["address"].ToString();
                string frombranch_stateid = dt_branch.Rows[0]["gststatecode"].ToString();
                string frombranch_statesno = dt_branch.Rows[0]["sno"].ToString();
                string frombranch_name = dt_branch.Rows[0]["branchname"].ToString();
                string frombranch_statecode = dt_branch.Rows[0]["statecode"].ToString();
                foreach (DataRow dr in dtstocktransfer.Rows)
                {
                    string date = dr["invoicedate"].ToString();
                    if (date != "")
                    {
                        DataRow newrow = Report.NewRow();
                        string ledgertype = "Sales Accounts";
                        string bname = dr["BranchName1"].ToString();
                        newrow["Ledger Type"] = ledgertype;
                        newrow["Customer Name"] = bname;
                        string invoiceno = dr["invoiceno"].ToString();
                        string salesinvoiceno = dr["salesinvoiceno"].ToString();
                        string stnumber = "";

                        double igst = 0;
                        double.TryParse(dr["igst"].ToString(), out igst);
                        double cgst = 0;
                        double.TryParse(dr["cgst"].ToString(), out cgst);
                        double sgst = 0;
                        double.TryParse(dr["sgst"].ToString(), out sgst);

                        if (salesinvoiceno == "0")
                        {
                            salesinvoiceno = dr["salesstno"].ToString();
                            string newreceipt = "0";
                            int countdc = 0;
                            int.TryParse(salesinvoiceno, out countdc);
                            if (countdc < 10)
                            {
                                newreceipt = "000" + countdc;
                            }
                            if (countdc >= 10 && countdc <= 99)
                            {
                                newreceipt = "00" + countdc;
                            }
                            if (countdc >= 99 && countdc <= 999)
                            {
                                newreceipt = "0" + countdc;
                            }
                            if (countdc > 999)
                            {
                                newreceipt = "" + countdc;
                            }
                            stnumber = frombranch_statecode + "/ST" + dtapril.ToString("yy") + "-" + dtmarch.ToString("yy") + "/" + newreceipt;
                        }
                        else
                        {
                            string newreceipt = "0";
                            int countdc = 0;
                            int.TryParse(salesinvoiceno, out countdc);
                            if (countdc < 10)
                            {
                                newreceipt = "000" + countdc;
                            }
                            if (countdc >= 10 && countdc <= 99)
                            {
                                newreceipt = "00" + countdc;
                            }
                            if (countdc >= 99 && countdc <= 999)
                            {
                                newreceipt = "0" + countdc;
                            }
                            if (countdc > 999)
                            {
                                newreceipt = "" + countdc;
                            }
                            double tax = igst + sgst + cgst;
                            if (tax > 0)
                            {
                                stnumber = frombranch_statecode + "/T" + dtapril.ToString("yy") + "-" + dtmarch.ToString("yy") + "/" + newreceipt;
                            }
                            else
                            {
                                stnumber = frombranch_statecode + "/N" + dtapril.ToString("yy") + "-" + dtmarch.ToString("yy") + "/" + newreceipt;
                            }
                        }
                        DateTime dtdate = Convert.ToDateTime(date);
                        string invoicedate = dtdate.ToString("dd-MMM-yyyy");
                        string invoicedate1 = dtdate.ToString("dd/MM/yyyy");
                        newrow["Invoce No."] = stnumber;
                        newrow["Invoice Date"] = invoicedate;
                        newrow["Item Name"] = dr["productname"].ToString();
                        double price = 0;
                        double.TryParse(dr["price"].ToString(), out price);
                        totalprice += price;
                        newrow["Rate"] = Math.Round(price, 2).ToString("f2"); //dr["price"].ToString();
                        double qty = 0;
                        double.TryParse(dr["quantity"].ToString(), out qty);
                        totalqty += qty;
                        newrow["Qty"] = dr["quantity"].ToString();
                        string taxper = dr["taxvalue"].ToString();
                       
                        double total = 0; double totamount = 0;
                        total = qty * price;
                        newrow["Taxable Value"] = Math.Round(total, 2).ToString("f2"); 
                        newrow["SGST%"] = sgst;
                        newrow["CGST%"] = cgst;
                        newrow["IGST%"] = igst;
                        double igstamount = (total * igst) / 100;
                        double cgstamount = (total * cgst) / 100;
                        double sgstamount = (total * sgst) / 100;
                        newrow["SGST Amount"] = Math.Round(sgstamount, 2).ToString("f2");
                        newrow["CGST Amount"] = Math.Round(cgstamount, 2).ToString("f2");
                        newrow["IGST Amount"] = Math.Round(igstamount, 2).ToString("f2");
                        double netvalue = total + sgstamount + cgstamount + igstamount;
                        totamount += total;
                        double freight = 0;
                        double.TryParse(dr["freigtamt"].ToString(), out freight);
                        tfreight += freight;
                        totamount = netvalue + freight;
                        double totalamount = 0;
                        totalamount = totamount;
                        newrow["Net Value"] = Math.Round(totalamount, 2).ToString("f2");
                        ttotalamount += totalamount;
                        newrow["Narration"] = "Being  " + dr["remarks"].ToString() + "  From SVDS Punabaka,Invoice No: " + stnumber + ",Inv Dt" + invoicedate1 + ",Amount" + totalamount + "";//dr["invoicedate"].ToString()
                        Report.Rows.Add(newrow);
                    }
                }
                Session["xportdata"] = Report;
                Session["filename"] = "Stores Branch Transfer report";
                grdReports.DataSource = Report;
                grdReports.DataBind();
                hidepanel.Visible = true;
            }
            else
            {
                grdReports.DataSource = null;
                grdReports.DataBind();
            }
        }
        catch (Exception ex)
        {

        }
    }
    protected void gvMenu_DataBinding(object sender, EventArgs e)
    {

    }
    protected void grdReports_RowDataBound(object sender, GridViewRowEventArgs e)
    {

    }
}