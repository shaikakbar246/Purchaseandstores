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
public partial class TallyBranchTransfer : System.Web.UI.Page
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
                    ddlbranchname.Visible = false;
                    Label1.Visible = false;
                }
            }
        }
    }

    protected void ddComapanyFilter_SelectedIndexChanged(object sender, EventArgs e)
    {
        string type = ddltype.SelectedItem.Value;
        if (type == "1")
        {
            ddlbranchname.Visible = false;
            Label1.Visible = false;
        }
        else {
            ddlbranchname.Visible = true;
            bindbranches();
        }
    }

    private void bindbranches()
    {
        string branchid1 = Session["Po_BranchID"].ToString();
        cmd = new SqlCommand("SELECT  branchid, branchname FROM branchmaster");
        cmd.Parameters.Add("@branchid", branchid1);
        DataTable dttrips = vdm.SelectQuery(cmd).Tables[0];
        ddlbranchname.DataSource = dttrips;
        ddlbranchname.DataTextField = "branchname";
        ddlbranchname.DataValueField = "branchid";
        ddlbranchname.DataBind();
        ddlbranchname.ClearSelection();
        ddlbranchname.Items.Insert(0, new ListItem { Value = "0", Text = "--Select Branch--", Selected = true });
        ddlbranchname.SelectedValue = "0";
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
            string transtype = ddlleveltype.SelectedItem.Value;
            string type = ddltype.SelectedItem.Value;
            string mainbranch_id = Session["Po_BranchID"].ToString();
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
            cmd = new SqlCommand("select statemaster.sno,statemaster.code AS statecode,statemaster.gststatecode,statemaster.statename,branchmaster.GSTIN,branchmaster.address,branchmaster.branchname from statemaster INNER JOIN branchmaster ON statemaster.sno = branchmaster.statename WHERE branchmaster.branchid = @mbranch_id");
            cmd.Parameters.Add("@mbranch_id", mainbranch_id);
            DataTable dt_branch = vdm.SelectQuery(cmd).Tables[0];
            string fromstate = dt_branch.Rows[0]["statename"].ToString();
            string frombranch_gstin = dt_branch.Rows[0]["GSTIN"].ToString();
            string frombranch_address = dt_branch.Rows[0]["address"].ToString();
            string frombranch_stateid = dt_branch.Rows[0]["gststatecode"].ToString();
            string frombranch_statesno = dt_branch.Rows[0]["sno"].ToString();
            string frombranch_name = dt_branch.Rows[0]["branchname"].ToString();
            string frombranch_statecode = dt_branch.Rows[0]["statecode"].ToString();
            if (type == "0")
            {
                Report.Columns.Add("B.Transfer");
                Report.Columns.Add("JV Date");
                Report.Columns.Add("LedgerName");
                Report.Columns.Add("Amount");
                Report.Columns.Add("Narration");
                Report.Columns.Add("InvoiceNo");
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
                lblFromDate.Text = fromdate.ToString("MM/dd/yyyy");
                lbltodate.Text = todate.ToString("MM/dd/yyyy");
                string branch_id = Session["Po_BranchID"].ToString();
                int branchid = Convert.ToInt32(ddlbranchname.SelectedItem.Value);
                if (transtype == "0")
                {
                    cmd = new SqlCommand("SELECT  stocktransferdetails.remarks, stocktransferdetails.salesstno, stocktransferdetails.salesinvoiceno,stocktransferdetails.invoiceno, stocktransferdetails.invoicedate, stocktransfersubdetails.price, stocktransfersubdetails.taxvalue, stocktransfersubdetails.freigtamt, stocktransfersubdetails.sno, branchmaster_1.branchname, productmaster.productname, stocktransfersubdetails.quantity,subcategorymaster.ledgername, subcategorymaster.sub_cat_code FROM stocktransferdetails INNER JOIN stocktransfersubdetails ON stocktransferdetails.sno = stocktransfersubdetails.stock_refno LEFT OUTER JOIN branchmaster AS branchmaster_1 ON stocktransferdetails.tobranch = branchmaster_1.branchid INNER JOIN productmaster ON stocktransfersubdetails.productid = productmaster.productid LEFT OUTER JOIN  subcategorymaster ON productmaster.subcategoryid = subcategorymaster.subcategoryid WHERE (stocktransferdetails.invoicedate BETWEEN @fromdate AND @todate) AND (stocktransferdetails.branch_id = @branch_id) AND (stocktransfersubdetails.quantity > 0) AND (stocktransferdetails.tobranch = @branchid) AND (stocktransferdetails.transtype='0') GROUP BY stocktransferdetails.remarks, stocktransferdetails.invoiceno, stocktransferdetails.invoicedate, stocktransfersubdetails.price, stocktransfersubdetails.taxvalue,stocktransfersubdetails.freigtamt, stocktransfersubdetails.sno, branchmaster_1.branchname, productmaster.productname, stocktransfersubdetails.quantity, subcategorymaster.ledgername, subcategorymaster.sub_cat_code,stocktransferdetails.salesinvoiceno, stocktransferdetails.salesstno");
                }
                else
                {
                    cmd = new SqlCommand("SELECT  stocktransferdetails.remarks, stocktransferdetails.salesstno, stocktransferdetails.salesinvoiceno,stocktransferdetails.invoiceno, stocktransferdetails.invoicedate, stocktransfersubdetails.price, stocktransfersubdetails.taxvalue, stocktransfersubdetails.freigtamt, stocktransfersubdetails.sno, branchmaster_1.branchname, productmaster.productname, stocktransfersubdetails.quantity,subcategorymaster.ledgername, subcategorymaster.sub_cat_code FROM stocktransferdetails INNER JOIN stocktransfersubdetails ON stocktransferdetails.sno = stocktransfersubdetails.stock_refno LEFT OUTER JOIN branchmaster AS branchmaster_1 ON stocktransferdetails.tobranch = branchmaster_1.branchid INNER JOIN productmaster ON stocktransfersubdetails.productid = productmaster.productid LEFT OUTER JOIN  subcategorymaster ON productmaster.subcategoryid = subcategorymaster.subcategoryid WHERE (stocktransferdetails.invoicedate BETWEEN @fromdate AND @todate) AND (stocktransferdetails.branch_id = @branch_id) AND (stocktransfersubdetails.quantity > 0) AND (stocktransferdetails.tobranch = @branchid) AND (stocktransferdetails.transtype='1') GROUP BY stocktransferdetails.remarks, stocktransferdetails.invoiceno, stocktransferdetails.invoicedate, stocktransfersubdetails.price, stocktransfersubdetails.taxvalue,stocktransfersubdetails.freigtamt, stocktransfersubdetails.sno, branchmaster_1.branchname, productmaster.productname, stocktransfersubdetails.quantity, subcategorymaster.ledgername, subcategorymaster.sub_cat_code,stocktransferdetails.salesinvoiceno, stocktransferdetails.salesstno");
                }
                cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
                cmd.Parameters.Add("@todate", GetHighDate(todate));
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@branch_id", branch_id);
                DataTable dtstocktransfer = SalesDB.SelectQuery(cmd).Tables[0];
                if (dtstocktransfer.Rows.Count > 0)
                {

                    string branchname = "";
                    double totalqty = 0;
                    double ttotalamount = 0;
                    double gtotalamount = 0;
                    double totalprice = 0;
                    double totaltaxamt = 0;
                    double gtotaltaxamt = 0;
                    double taxamount = 0;
                    double ttaxamount = 0;
                    double tfreight = 0;
                    DateTime dt = DateTime.Now;
                    string prevdate = string.Empty;
                    string prevledgername = "";
                    string tlname = "";
                    string tidate = "";
                    string tnaration = "";
                    string invoiceno = "";
                    int rowcount = 1;
                    string previnvoiceno = string.Empty;
                    foreach (DataRow dr in dtstocktransfer.Rows)
                    {
                        invoiceno = dr["invoiceno"].ToString();
                        string ledgername = dr["ledgername"].ToString();
                        string invoicdate = dr["invoicedate"].ToString();
                        tidate = invoicdate;
                        branchname = dr["branchname"].ToString();
                        tlname = branchname;
                        if (invoiceno == previnvoiceno)
                        {
                            double price = 0;
                            double.TryParse(dr["price"].ToString(), out price);
                            totalprice += price;
                            double qty = 0;
                            double.TryParse(dr["quantity"].ToString(), out qty);
                            totalqty += qty;
                            double total; double totamount = 0;
                            total = qty * price;
                            totamount += total;
                            double taxamt = 0;
                            double.TryParse(dr["taxvalue"].ToString(), out taxamt);
                            totaltaxamt += taxamt;
                            gtotaltaxamt += totaltaxamt;
                            taxamount = (total * taxamt) / 100;
                            ttaxamount += taxamount;
                            double freight = 0;
                            totamount = total + taxamount + freight;
                            double totalamount = 0;
                            totalamount = totamount;//grand total in that coming
                            ttotalamount += totalamount;
                            gtotalamount += totalamount;
                            rowcount++;
                            DataRow newrow1 = Report.NewRow();
                            branchname = dr["branchname"].ToString();
                            string invoicedate1 = invoicdate.ToString();
                            DateTime Invoice = Convert.ToDateTime(invoicedate1);
                            string invoicedate = Invoice.ToString("MM/dd/yyyy");
                            string InVoiceNo = dr["invoiceno"].ToString();
                            string remarks = dr["remarks"].ToString();
                            ttotalamount = Math.Round(ttotalamount, 2);
                            string amount = totalamount.ToString();
                            string ledger = dr["ledgername"].ToString();
                            string salesinvoiceno = dr["salesinvoiceno"].ToString();
                            string stnumber = "";
                           
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
                                stnumber = frombranch_statecode + "/I" + dtapril.ToString("yy") + "-" + dtmarch.ToString("yy") + "/" + newreceipt;
                            }

                            newrow1["InvoiceNo"] = stnumber;
                            // newrow1["InvoiceNo"] = dr["salesinvoiceno"].ToString();
                            newrow1["Amount"] = totalamount.ToString("f2");
                            newrow1["JV Date"] = invoicedate;
                            newrow1["LedgerName"] = dr["ledgername"].ToString() + "-" + dr["branchname"].ToString().Substring(12, 6) + ""; ;
                            newrow1["B.Transfer"] = dr["branchname"].ToString();
                            newrow1["Narration"] = "Being  " + remarks + "  From SVDS Punabaka,Invoice No: " + InVoiceNo + ",Inv Dt" + invoicedate + ",Amount" + amount + "To" + ledger + "";
                            tnaration = "Being  " + remarks + "  From SVDS Punabaka,Invoice No: " + stnumber + ",Inv Dt" + invoicedate + ",Amount" + amount + "To" + ledger + "";
                            Report.Rows.Add(newrow1);
                        }
                        else
                        {
                            if (gtotalamount > 0)
                            {
                                DataRow newvartical2 = Report.NewRow();
                                newvartical2["LedgerName"] = "SVDS.P.Ltd.Punabaka";
                                DateTime tiDate = Convert.ToDateTime(tidate);
                                string jvinvoiceDate = tiDate.ToString("MM/dd/yyyy");
                                newvartical2["JV Date"] = jvinvoiceDate;
                                newvartical2["B.Transfer"] = tlname;
                                newvartical2["Narration"] = tnaration;
                                branchname = dr["branchname"].ToString();
                                ledgername = dr["ledgername"].ToString();
                                string invoicedate = invoicdate.ToString();
                                string salesinvoiceno = dr["salesinvoiceno"].ToString();
                                string stnumber = "";
                                stnumber = frombranch_statecode + "/I" + dtapril.ToString("yy") + "-" + dtmarch.ToString("yy") + "/" + salesinvoiceno;
                                string InVoiceNo = stnumber;
                               // string InVoiceNo = dr["salesinvoiceno"].ToString();
                                string remarks = dr["remarks"].ToString();
                                ttotalamount = Math.Round(ttotalamount, 2);
                                string amount = gtotalamount.ToString();
                                newvartical2["Amount"] = "-" + gtotalamount + "";
                                Report.Rows.Add(newvartical2);
                                ttotalamount = 0;
                                gtotalamount = 0;
                            }
                            previnvoiceno = invoiceno;
                            prevledgername = ledgername;
                            double price = 0;
                            double.TryParse(dr["price"].ToString(), out price);
                            totalprice += price;
                            double qty = 0;
                            double.TryParse(dr["quantity"].ToString(), out qty);
                            totalqty += qty;
                            double total = 0; double totamount = 0;
                            total = qty * price;
                            totamount += total;
                            double taxamt = 0;
                            double.TryParse(dr["taxvalue"].ToString(), out taxamt);
                            totaltaxamt += taxamt;
                            gtotaltaxamt += totaltaxamt;
                            taxamount = (total * taxamt) / 100;
                            ttaxamount += taxamount;
                            double freight = 0;
                            double.TryParse(dr["freigtamt"].ToString(), out freight);
                            tfreight += freight;
                            totamount = total + taxamount + freight;
                            double totalamount = 0;
                            totalamount = totamount;//grand total in that coming
                            ttotalamount += totalamount;
                            gtotalamount += totalamount;
                            DataRow newrow1 = Report.NewRow();
                            branchname = dr["branchname"].ToString();
                            ledgername = dr["ledgername"].ToString();
                            string drinvoicedate1 = invoicdate.ToString();
                            DateTime Invoice = Convert.ToDateTime(drinvoicedate1);
                            string drinvoicedate = Invoice.ToString("MM/dd/yyyy");
                            string salesinvno = dr["salesinvoiceno"].ToString();
                            string stnum = "";
                            if (salesinvno == "0")
                            {
                                salesinvno = dr["salesstno"].ToString();
                                string newreceipt = "0";
                                int countdc = 0;
                                int.TryParse(salesinvno, out countdc);
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
                                stnum = frombranch_statecode + "/ST" + dtapril.ToString("yy") + "-" + dtmarch.ToString("yy") + "/" + newreceipt;
                            }
                            else
                            {
                                string newreceipt = "0";
                                int countdc = 0;
                                int.TryParse(salesinvno, out countdc);
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
                                stnum = frombranch_statecode + "/I" + dtapril.ToString("yy") + "-" + dtmarch.ToString("yy") + "/" + newreceipt;
                            }
                            string drInVoiceNo = stnum;
                           // string drInVoiceNo = dr["invoiceno"].ToString();
                            string drremarks = dr["remarks"].ToString();
                            ttotalamount = Math.Round(ttotalamount, 2);
                            string dramount = totalamount.ToString();
                            newrow1["InvoiceNo"] = dr["salesinvoiceno"].ToString();
                            newrow1["Amount"] = totalamount.ToString("f2");
                            newrow1["JV Date"] = drinvoicedate.ToString();
                            newrow1["LedgerName"] = dr["ledgername"].ToString() + "-" + dr["branchname"].ToString().Substring(12, 6) + "";
                            newrow1["B.Transfer"] = "SVDS.P.Ltd." + dr["branchname"].ToString() + "-" + drInVoiceNo + "";
                            newrow1["Narration"] = "Being  " + drremarks + "  From SVDS Punabaka,Invoice No: " + drInVoiceNo + ",Inv Dt" + drinvoicedate + ",Amount" + dramount + "";
                            tnaration = "Being  " + drremarks + "  From SVDS Punabaka,Invoice No: " + drInVoiceNo + ",Inv Dt" + drinvoicedate + "";
                            Report.Rows.Add(newrow1);
                        }
                    }
                    DataRow gnewrow = Report.NewRow();
                    gnewrow["LedgerName"] = "SVDS.P.Ltd.Punabaka";
                    DateTime tiDate1 = Convert.ToDateTime(tidate);
                    string jvinvoicedate = tiDate1.ToString("MM/dd/yyyy");
                    gnewrow["JV Date"] = jvinvoicedate;
                    gnewrow["B.Transfer"] = "SVDS.P.Ltd." + tlname + "-" + invoiceno + "";
                    // gnewrow["Narration"] = tnaration;
                    gnewrow["Amount"] = "-" + gtotalamount.ToString("f2") + "";
                    Report.Rows.Add(gnewrow);
                    Session["xportdata"] = Report;
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
            else//punabaka
            {
                Report.Columns.Add("ProductName");
                Report.Columns.Add("B.Transfer");
                Report.Columns.Add("JV Date");
                Report.Columns.Add("LedgerName");
                Report.Columns.Add("Amount");
                Report.Columns.Add("Narration");
                Report.Columns.Add("InvoiceNo");
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
                lblFromDate.Text = fromdate.ToString("MM/dd/yyyy");
                lbltodate.Text = todate.ToString("MM/dd/yyyy");
                string branch_id = Session["Po_BranchID"].ToString();
                if (transtype == "0")
                {
                    cmd = new SqlCommand("SELECT stocktransferdetails.remarks, stocktransferdetails.salesstno, stocktransferdetails.salesinvoiceno, stocktransferdetails.invoiceno, stocktransferdetails.invoicedate AS invoicedate,  stocktransfersubdetails.price, stocktransfersubdetails.taxvalue, stocktransfersubdetails.freigtamt,  stocktransfersubdetails.sno, branchmaster_1.branchname, productmaster.productname, stocktransfersubdetails.quantity,  subcategorymaster.ledgername,subcategorymaster.sub_cat_code FROM stocktransferdetails INNER JOIN stocktransfersubdetails ON stocktransferdetails.sno = stocktransfersubdetails.stock_refno LEFT OUTER JOIN branchmaster AS branchmaster_1 ON stocktransferdetails.tobranch = branchmaster_1.branchid INNER JOIN productmaster ON stocktransfersubdetails.productid = productmaster.productid INNER JOIN subcategorymaster ON productmaster.subcategoryid = subcategorymaster.subcategoryid WHERE (stocktransferdetails.invoicedate BETWEEN @fromdate AND @todate) AND (stocktransferdetails.branch_id = @branch_id)  AND (stocktransfersubdetails.quantity > 0) AND (stocktransferdetails.transtype='0') GROUP BY  stocktransferdetails.remarks,stocktransferdetails.invoiceno,  invoicedate,  stocktransfersubdetails.price, stocktransfersubdetails.taxvalue, stocktransfersubdetails.freigtamt,  stocktransfersubdetails.sno, branchmaster_1.branchname, productmaster.productname, stocktransfersubdetails.quantity,  subcategorymaster.ledgername,subcategorymaster.sub_cat_code,stocktransferdetails.salesinvoiceno, stocktransferdetails.salesstno");
                }
                else
                {
                    cmd = new SqlCommand("SELECT stocktransferdetails.remarks, stocktransferdetails.salesstno, stocktransferdetails.salesinvoiceno, stocktransferdetails.invoiceno, stocktransferdetails.invoicedate AS invoicedate,  stocktransfersubdetails.price, stocktransfersubdetails.taxvalue, stocktransfersubdetails.freigtamt,  stocktransfersubdetails.sno, branchmaster_1.branchname, productmaster.productname, stocktransfersubdetails.quantity,  subcategorymaster.ledgername,subcategorymaster.sub_cat_code FROM stocktransferdetails INNER JOIN stocktransfersubdetails ON stocktransferdetails.sno = stocktransfersubdetails.stock_refno LEFT OUTER JOIN branchmaster AS branchmaster_1 ON stocktransferdetails.tobranch = branchmaster_1.branchid INNER JOIN productmaster ON stocktransfersubdetails.productid = productmaster.productid INNER JOIN subcategorymaster ON productmaster.subcategoryid = subcategorymaster.subcategoryid WHERE (stocktransferdetails.invoicedate BETWEEN @fromdate AND @todate) AND (stocktransferdetails.branch_id = @branch_id)  AND (stocktransfersubdetails.quantity > 0) AND (stocktransferdetails.transtype='1') GROUP BY  stocktransferdetails.remarks,stocktransferdetails.invoiceno,  invoicedate,  stocktransfersubdetails.price, stocktransfersubdetails.taxvalue, stocktransfersubdetails.freigtamt,  stocktransfersubdetails.sno, branchmaster_1.branchname, productmaster.productname, stocktransfersubdetails.quantity,  subcategorymaster.ledgername,subcategorymaster.sub_cat_code,stocktransferdetails.salesinvoiceno, stocktransferdetails.salesstno");
                }
                cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
                cmd.Parameters.Add("@todate", GetHighDate(todate));
                cmd.Parameters.Add("@branch_id", branch_id);
                DataTable dtstocktransfer = SalesDB.SelectQuery(cmd).Tables[0];
                if (dtstocktransfer.Rows.Count > 0)
                {
                    string branchname = "";
                    double totalqty = 0;
                    double gtotalqty = 0;
                    double ttotalamount = 0;
                    double gtotalamount = 0;
                    double totalprice = 0;
                    double toatlpq = 0;
                    double totalpriceqty = 0;
                    double totaltaxamt = 0;
                    double gtotaltaxamt = 0;
                    double taxamount = 0;
                    double ttaxamount = 0;
                    double tfreight = 0;
                    double gfrightamt = 0;
                    double gtaxamount = 0;
                    DateTime dt = DateTime.Now;
                    string prevdate = string.Empty;
                    string previnvoiceno = "";
                    string prevledgername = "";
                    var i = 1;
                    int count = 1;
                    int rowcount = 1;
                    
                    foreach (DataRow dr in dtstocktransfer.Rows)
                    {
                        string invoiceno = dr["invoiceno"].ToString();
                        string ledgername = dr["ledgername"].ToString();
                        string invoicdate = dr["invoicedate"].ToString();
                        branchname = dr["branchname"].ToString();
                        if (invoiceno == previnvoiceno)
                        {
                            double price = 0;
                            double.TryParse(dr["price"].ToString(), out price);
                            totalprice += price;
                            double qty = 0;
                            double.TryParse(dr["quantity"].ToString(), out qty);
                            totalqty += qty;
                            double total; double totamount = 0;
                            total = qty * price;
                            totamount += total;
                            double taxamt = 0;
                            double.TryParse(dr["taxvalue"].ToString(), out taxamt);
                            totaltaxamt += taxamt;
                            gtotaltaxamt += totaltaxamt;
                            taxamount = (total * taxamt) / 100;
                            ttaxamount += taxamount;
                            double freight = 0;
                            totamount = total + taxamount + freight;
                            double totalamount = 0;
                            totalamount = totamount;//grand total in that coming
                            ttotalamount += totalamount;
                            rowcount++;
                            DataTable dtin = new DataTable();
                            DataRow[] drr = dtstocktransfer.Select("invoiceno='" + invoiceno + "'");
                            if (drr.Length > 0)
                            {
                                dtin = drr.CopyToDataTable();
                            }
                            int dttotalpocount = dtin.Rows.Count;
                            if (dttotalpocount == rowcount)
                            {
                                DataRow newrow1 = Report.NewRow();
                                branchname = dr["branchname"].ToString();
                                string invoicedate = invoicdate.ToString();
                                DateTime Invoicedte = Convert.ToDateTime(invoicedate);
                                string InvoiceDate = Invoicedte.ToString("MM/dd/yyyy");
                                string InVoiceNo = dr["invoiceno"].ToString();
                                string remarks = dr["remarks"].ToString();
                                ttotalamount = Math.Round(ttotalamount, 2);
                                string amount = ttotalamount.ToString();
                                string salesinvno = dr["salesinvoiceno"].ToString();
                                string stnum = "";
                                if (salesinvno == "0")
                                {
                                    salesinvno = dr["salesstno"].ToString();
                                    string newreceipt = "0";
                                    int countdc = 0;
                                    int.TryParse(salesinvno, out countdc);
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
                                    stnum = frombranch_statecode + "/ST" + dtapril.ToString("yy") + "-" + dtmarch.ToString("yy") + "/" + newreceipt;
                                }
                                else
                                {
                                    string newreceipt = "0";
                                    int countdc = 0;
                                    int.TryParse(salesinvno, out countdc);
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
                                    stnum = frombranch_statecode + "/I" + dtapril.ToString("yy") + "-" + dtmarch.ToString("yy") + "/" + newreceipt;
                                }

                               



                                // newrow1["InvoiceNo"] = dr["salesinvoiceno"].ToString();
                                newrow1["InvoiceNo"] = stnum;
                                newrow1["Amount"] = ttotalamount.ToString("f2");
                                newrow1["JV Date"] = invoicdate.ToString();
                                newrow1["LedgerName"] = dr["ledgername"].ToString();
                                newrow1["B.Transfer"] = dr["branchname"].ToString();
                                newrow1["Narration"] = "Being  " + remarks + "  From SVDS Punabaka,Invoice No: " + stnum + ",Inv Dt" + InvoiceDate + ",Amount" + amount + ""; ;
                                newrow1["ProductName"] = "Total";
                                Report.Rows.Add(newrow1);
                                gtotalamount += ttotalamount;
                                ttotalamount = 0;
                                totalamount = 0;
                                rowcount = 1;
                            }
                        }
                        else
                        {
                            previnvoiceno = invoiceno;
                            prevledgername = ledgername;
                            double price = 0;
                            double.TryParse(dr["price"].ToString(), out price);
                            totalprice += price;
                            double qty = 0;
                            double.TryParse(dr["quantity"].ToString(), out qty);
                            totalqty += qty;
                            double total = 0; double totamount = 0;
                            total = qty * price;
                            totamount += total;
                            double taxamt = 0;
                            double.TryParse(dr["taxvalue"].ToString(), out taxamt);
                            totaltaxamt += taxamt;
                            gtotaltaxamt += totaltaxamt;
                            taxamount = (total * taxamt) / 100;
                            ttaxamount += taxamount;
                            double freight = 0;
                            double.TryParse(dr["freigtamt"].ToString(), out freight);
                            tfreight += freight;
                            totamount = total + taxamount + freight;
                            double totalamount = 0;
                            totalamount = totamount;//grand total in that coming
                            ttotalamount += totalamount;
                            DataTable dtin = new DataTable();
                            DataRow[] drr = dtstocktransfer.Select("invoiceno='" + invoiceno + "'");
                            if (drr.Length > 0)
                            {
                                dtin = drr.CopyToDataTable();
                            }
                            int dttotalpocount = dtin.Rows.Count;
                            if (dttotalpocount > 1)
                            {
                            }
                            else
                            {
                                DataRow newrow1 = Report.NewRow();
                                branchname = dr["branchname"].ToString();
                                ledgername = dr["ledgername"].ToString();
                                string invoicedate = invoicdate.ToString();
                                DateTime Invoicedte = Convert.ToDateTime(invoicedate);
                                string InvoiceDate = Invoicedte.ToString("MM/dd/yyyy");
                                string InVoiceNo = dr["invoiceno"].ToString();
                                string remarks = dr["remarks"].ToString();
                                ttotalamount = Math.Round(ttotalamount, 2);
                                string amount = ttotalamount.ToString();
                                string salesinvoiceno = dr["salesinvoiceno"].ToString();
                                string stnumber = "";
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
                                    stnumber = frombranch_statecode + "/I" + dtapril.ToString("yy") + "-" + dtmarch.ToString("yy") + "/" + newreceipt;
                                }
                                newrow1["InvoiceNo"] = stnumber;
                               // newrow1["InvoiceNo"] = dr["invoiceno"].ToString();
                                newrow1["Amount"] = ttotalamount.ToString("f2");
                                newrow1["JV Date"] = invoicdate.ToString();
                                newrow1["LedgerName"] = dr["ledgername"].ToString();
                                newrow1["B.Transfer"] = dr["branchname"].ToString();
                                newrow1["Narration"] = "Being  " + remarks + "  From SVDS Punabaka,Invoice No: " + stnumber + ",Inv Dt" + InvoiceDate + ",Amount" + amount + ""; ;
                                newrow1["ProductName"] = "Total";
                                Report.Rows.Add(newrow1);
                                gtotalamount += ttotalamount;
                                ttotalamount = 0;
                                totalamount = 0;
                                count++;
                                rowcount = 1;
                            }
                        }
                    }
                    DataTable newdatatable = new DataTable();
                    newdatatable.Columns.Add("B.Transfer");
                    newdatatable.Columns.Add("JV Date");
                    newdatatable.Columns.Add("LedgerName");
                    newdatatable.Columns.Add("Amount");
                    newdatatable.Columns.Add("Narration");
                    string credit = "Total";
                    foreach (DataRow drrepo in Report.Select("ProductName='" + credit + "'"))
                    {
                        DataRow reportnewrow = newdatatable.NewRow();
                        string invoiceno = drrepo["InvoiceNo"].ToString();
                        reportnewrow["B.Transfer"] = "SVDS.P.Ltd.Punabaka-" + invoiceno + "";
                        string jvinvoicedate = drrepo["JV Date"].ToString();
                        DateTime Invoice = Convert.ToDateTime(jvinvoicedate);
                        string Invoicdate = Invoice.ToString("MM/dd/yyyy");
                        reportnewrow["JV Date"] = Invoicdate;
                        reportnewrow["LedgerName"] = "SVDS.P.Ltd." + drrepo["B.Transfer"].ToString() + ""; ;
                        reportnewrow["Amount"] = drrepo["Amount"].ToString(); ;
                        reportnewrow["Narration"] = drrepo["Narration"].ToString(); ;
                        newdatatable.Rows.Add(reportnewrow);
                        DataRow reportnewrow1 = newdatatable.NewRow();
                        string InvoiceNo = drrepo["InvoiceNo"].ToString();
                        reportnewrow1["B.Transfer"] = "SVDS.P.Ltd.Punabaka-" + InvoiceNo + "";
                        string jvinvdate = drrepo["JV Date"].ToString();
                        DateTime Invoicedte = Convert.ToDateTime(jvinvdate);
                        string InvoiceDate = Invoicedte.ToString("MM/dd/yyyy");
                        reportnewrow1["JV Date"] = InvoiceDate;
                        reportnewrow1["LedgerName"] = "Stock of Stores & Spares - Punabaka";//Stock Stores&Spares
                        reportnewrow1["Amount"] = "-" + drrepo["Amount"].ToString(); ;
                        newdatatable.Rows.Add(reportnewrow1);
                    }
                    Session["xportdata"] = newdatatable;
                    Session["filename"] = "Tally Branch Transfor Report";
                    Session["Address"] = "";
                    grdReports.DataSource = newdatatable;
                    grdReports.DataBind();
                    hidepanel.Visible = true;
                }
                else
                {
                    lblmsg.Text = "No data were found";
                    hidepanel.Visible = false;
                }
            }

        }
        catch (Exception ex)
        {
            lblmsg.Text = ex.Message;
            hidepanel.Visible = false;
        }
    }
    int indexOfColumn = 1;
    protected void grdReports_RowDataBound(object sender, GridViewRowEventArgs e)
    {
         string type = ddltype.SelectedItem.Value;
         if (type == "0")
         {
             double Amount = 0;
             if (e.Row.RowType == DataControlRowType.DataRow)
             {
                 e.Row.Cells[5].Visible = false;
                 grdReports.HeaderRow.Cells[5].Visible = false;
             }
         }
         else
         {
             double Amount = 0;
             if (e.Row.RowType == DataControlRowType.DataRow)
             {
                 string invoiceno = e.Row.Cells[0].Text;
                 if (tempinvoiceno == invoiceno)
                 {
                     tempinvoiceno = invoiceno;
                     string amount = e.Row.Cells[4].Text;
                     double.TryParse(amount, out Amount);
                     temptotal += Amount;
                 }
                 else
                 {
                     tempinvoiceno = invoiceno;
                     string amount = e.Row.Cells[4].Text;
                     double.TryParse(amount, out Amount);
                     temptotal += Amount;
                 }
             }
         }
    }
    protected void btnexport_click(object sender, EventArgs e)
    {
        Response.Redirect("~/exporttoxl.aspx");
    }
    protected void gvMenu_DataBinding(object sender, EventArgs e)
    {
    }
}
