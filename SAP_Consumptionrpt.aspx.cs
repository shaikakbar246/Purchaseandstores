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

public partial class SAP_Consumptionrpt : System.Web.UI.Page
{
    // JV No	JV Date	WH Code	Ledger Code	Ledger Name	Item Code	Item Name	Category Code	Total Amount	Narration
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
                    //  dtp_Todate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");// Convert.ToString(lbltodate.Text);/// //// 
                    ddlbranchname.Visible = false;
                    Label1.Visible = false;
                    bindbranches();
                }
            }
        }
    }

    private void bindbranches()
    {
        string branchid1 = Session["Po_BranchID"].ToString();
        cmd = new SqlCommand("SELECT branchid, branchname FROM branchmaster");
        cmd.Parameters.Add("@branchid", branchid1);
        DataTable dttrips = vdm.SelectQuery(cmd).Tables[0];
        ddltype.DataSource = dttrips;
        ddltype.DataTextField = "branchname";
        ddltype.DataValueField = "branchid";
        ddltype.DataBind();
        ddltype.ClearSelection();
        ddltype.Items.Insert(0, new ListItem { Value = "0", Text = "--Select Branch--", Selected = true });
        ddltype.SelectedValue = "0";
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
            string type = ddltype.SelectedItem.Value;
            string fromwhcode = "SVDSPP02";
            Report.Columns.Add("JV No");
            Report.Columns.Add("JV Date");
            Report.Columns.Add("WH Code");
            Report.Columns.Add("Ledger Code");
            Report.Columns.Add("Ledger Name");
            Report.Columns.Add("Item Code");
            Report.Columns.Add("Item Name");
            Report.Columns.Add("Qty");
            Report.Columns.Add("Price");
            Report.Columns.Add("Category Code");
            Report.Columns.Add("Total Amount");
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

            lblFromDate.Text = fromdate.ToString("dd/MM/yyyy");
            lbltodate.Text = todate.ToString("dd/MM/yyyy");
            string fdate = fromdate.ToString("dd/MM/yyyy");
            string[] substrings = fdate.Split('/');
            string date = substrings[0].ToString();
            string mnth = substrings[1].ToString();
            string branch_id = Session["Po_BranchID"].ToString();
            if (ddltype.SelectedItem.Value == "2")
            {
                cmd = new SqlCommand("SELECT PM.productid, SUM(SOD.quantity) AS quantity, SOD.perunit, CM.categeorycode, BM.whcode, PM.productname,  PM.itemcode, SCM.ledgername, SCM.ledgercode, SCM.subcategoryname FROM productmaster AS PM INNER JOIN suboutwarddetails AS SOD ON SOD.productid = PM.productid INNER JOIN outwarddetails AS OD ON OD.sno = SOD.in_refno INNER JOIN subcategorymaster AS SCM ON PM.subcategoryid = SCM.subcategoryid INNER JOIN branchmaster AS BM ON SCM.branchid = BM.branchid INNER JOIN categorymaster AS CM ON PM.productcode = CM.cat_code WHERE (OD.inwarddate BETWEEN @fromdate AND @todate) AND (OD.branchid = @branchid) GROUP BY PM.productid, SOD.perunit, SCM.ledgername, SCM.ledgercode, SCM.subcategoryname, PM.productname, PM.productcode, BM.whcode, PM.itemcode, CM.categeorycode");
            }
            else
            {
                cmd = new SqlCommand("SELECT PM.productid, SUM(STSD.quantity) AS quantity, STSD.price AS perunit, branchmaster.branchname, branchmaster.whcode, categorymaster.categeorycode, PM.itemcode, PM.productname,  subcategorymaster.ledgername, subcategorymaster.ledgercode FROM  productmaster AS PM INNER JOIN  stocktransfersubdetails AS STSD ON STSD.productid = PM.productid INNER JOIN stocktransferdetails AS STD ON STD.sno = STSD.stock_refno INNER JOIN  branchmaster ON STD.tobranch = branchmaster.branchid INNER JOIN subcategorymaster ON PM.subcategoryid = subcategorymaster.subcategoryid INNER JOIN categorymaster ON PM.productcode = categorymaster.cat_code WHERE (STD.invoicedate BETWEEN @fromdate AND @todate) AND (STD.tobranch = @branchid) GROUP BY PM.productid, STSD.price, branchmaster.branchname, branchmaster.whcode, PM.itemcode, PM.productname, subcategorymaster.ledgername, subcategorymaster.ledgercode, categorymaster.categeorycode");
            }
            cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
            cmd.Parameters.Add("@todate", GetHighDate(fromdate));
            cmd.Parameters.Add("@branchid", ddltype.SelectedItem.Value);
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
                string previnvoiceno = "";
                string prevledgername = "";
                var i = 1;
                int count = 1;
                int rowcount = 1;
                foreach (DataRow dr in dtstocktransfer.Rows)
                {
                    DataRow gnewrow = Report.NewRow();
                    //string ledgername = dr["ledgername"].ToString();
                    string invoicdate = fromdate.ToString("dd/MM/yyyy");
                    string VoucherNo = "SVDS/PBK/1718/Con/" + date + "" + mnth + "";
                    string FromWhsCode = fromwhcode;
                    string whcode = dr["whcode"].ToString();
                    string itemcode = dr["itemcode"].ToString();
                    string itemname = dr["productname"].ToString();
                    string ledgercode = dr["ledgercode"].ToString();
                    string ledgername = dr["ledgername"].ToString();
                    string qty = dr["quantity"].ToString();
                    string price = dr["perunit"].ToString();
                    string ocrcode = fromwhcode;
                    string narration = "";
                    string series = "241";
                    double quantity = Convert.ToDouble(qty);
                    double pprice = Convert.ToDouble(price);
                    double totalvalue = quantity * pprice;
                    totalvalue = Math.Round(totalvalue, 2);
                    gnewrow["JV No"] = VoucherNo;
                    gnewrow["JV Date"] = invoicdate;
                    gnewrow["WH Code"] = whcode;
                    gnewrow["Ledger Code"] = ledgercode;
                    gnewrow["Ledger Name"] = ledgername;
                    gnewrow["Item Code"] = itemcode;
                    gnewrow["Item Name"] = itemname;
                    gnewrow["Qty"] = Math.Round(quantity, 2);
                    gnewrow["Price"] = Math.Round(pprice,2);
                    gnewrow["Total Amount"] = totalvalue;
                    gnewrow["Narration"] = narration;
                    gnewrow["Category Code"] = dr["categeorycode"].ToString();
                    Report.Rows.Add(gnewrow);
                }
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
            //DataTable dt = grdReports.DataSource as DataTable;
            //DataRow row = dt.NewRow();
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
    SqlCommand sqlcmd;
    protected void BtnSave_Click(object sender, EventArgs e)
    {
        try
        {
            vdm = new SalesDBManager();
            DateTime CreateDate = SalesDBManager.GetTime(vdm.conn);
            SAPdbmanger SAPvdm = new SAPdbmanger();
            DateTime fromdate = DateTime.Now;
            DataTable dt = (DataTable)Session["xportdata"];
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
            foreach (DataRow dr in dt.Rows)
            {
                if (ddltype.SelectedItem.Value == "2")
                {
                    string AcctCode = dr["Ledger Code"].ToString();
                    string whCode = dr["WH Code"].ToString();
                    if (AcctCode == "" && whCode == "")
                    {
                    }
                    else
                    {
                        sqlcmd = new SqlCommand("SELECT CreateDate, RefDate, DocDate, Ref1, Ref2, Ref3, TransNo, AcctCode FROM EMROJDT WHERE (RefDate BETWEEN @d1 AND @d2) AND (TransNo = @TransNo) AND (Ref1=@Ref1) AND (OcrCode = @OcrCode) AND (AcctCode=@AcCode)");
                        sqlcmd.Parameters.Add("@d1", GetLowDate(fromdate));
                        sqlcmd.Parameters.Add("@d2", GetHighDate(fromdate));
                        sqlcmd.Parameters.Add("@TransNo", dr["JV No"].ToString());
                        sqlcmd.Parameters.Add("@OcrCode", dr["WH Code"].ToString());
                        sqlcmd.Parameters.Add("@Ref1", dr["Item Code"].ToString());
                        sqlcmd.Parameters.Add("@AcCode", dr["Ledger Code"].ToString());
                        DataTable dtJournelPay = SAPvdm.SelectQuery(sqlcmd).Tables[0];
                        if (dtJournelPay.Rows.Count > 0)
                        {
                        }
                        else
                        {
                            sqlcmd = new SqlCommand("Insert into EMROJDT (CreateDate, RefDate, DocDate, TransNo, AcctCode, AcctName, Debit, Credit, B1Upload, Processed,Ref1,OcrCode,OcrCode2,series) values (@CreateDate, @RefDate, @DocDate,@TransNo, @AcctCode, @AcctName, @Debit, @Credit, @B1Upload, @Processed,@Ref1,@OcrCode,@OcrCode2,@series)");
                            sqlcmd.Parameters.Add("@CreateDate", GetLowDate(fromdate));
                            sqlcmd.Parameters.Add("@RefDate", GetLowDate(fromdate));
                            sqlcmd.Parameters.Add("@docdate", GetLowDate(fromdate));
                            sqlcmd.Parameters.Add("@Ref1", dr["Item Code"].ToString());
                            sqlcmd.Parameters.Add("@TransNo", dr["JV No"].ToString());
                            sqlcmd.Parameters.Add("@AcctCode", dr["Ledger Code"].ToString());
                            sqlcmd.Parameters.Add("@AcctName", dr["Ledger Name"].ToString());
                            double amount = 0;
                            double.TryParse(dr["Total Amount"].ToString(), out amount);
                            double Debit = 0;
                            sqlcmd.Parameters.Add("@Debit", Debit);
                            sqlcmd.Parameters.Add("@Credit", amount);
                            string B1Upload = "N";
                            string Processed = "N";
                            sqlcmd.Parameters.Add("@B1Upload", B1Upload);
                            sqlcmd.Parameters.Add("@Processed", Processed);
                            sqlcmd.Parameters.Add("@OcrCode", dr["WH Code"].ToString());
                            sqlcmd.Parameters.Add("@OcrCode2", dr["Category Code"].ToString());
                            string series = "230";
                            sqlcmd.Parameters.Add("@series", series);
                            SAPvdm.insert(sqlcmd);


                            sqlcmd = new SqlCommand("Insert into EMROJDT (CreateDate, RefDate, DocDate, TransNo, AcctCode, AcctName, Debit, Credit, B1Upload, Processed,Ref1,OcrCode,OcrCode2,series) values (@CreateDate, @RefDate, @DocDate,@TransNo, @AcctCode, @AcctName, @Debit, @Credit, @B1Upload, @Processed,@Ref1,@OcrCode,@OcrCode2,@series)");
                            sqlcmd.Parameters.Add("@CreateDate", GetLowDate(fromdate));
                            sqlcmd.Parameters.Add("@RefDate", GetLowDate(fromdate));
                            sqlcmd.Parameters.Add("@docdate", GetLowDate(fromdate));
                            sqlcmd.Parameters.Add("@Ref1", dr["Item Code"].ToString());
                            sqlcmd.Parameters.Add("@TransNo", dr["JV No"].ToString());
                            sqlcmd.Parameters.Add("@AcctCode", dr["Ledger Code"].ToString());
                            sqlcmd.Parameters.Add("@AcctName", dr["Ledger Name"].ToString());
                            double tamount = 0;
                            double.TryParse(dr["Total Amount"].ToString(), out tamount);
                            double Credit = 0;
                            sqlcmd.Parameters.Add("@Debit", tamount);
                            sqlcmd.Parameters.Add("@Credit", Credit);
                            sqlcmd.Parameters.Add("@B1Upload", B1Upload);
                            sqlcmd.Parameters.Add("@Processed", Processed);
                            sqlcmd.Parameters.Add("@OcrCode", dr["WH Code"].ToString());
                            sqlcmd.Parameters.Add("@OcrCode2", dr["Category Code"].ToString());
                            sqlcmd.Parameters.Add("@series", series);
                            SAPvdm.insert(sqlcmd);
                        }
                    }
                }
                else
                {
                    double amount = 0;
                    double.TryParse(dr["Total Amount"].ToString(), out amount);
                    string B1Upload = "N";
                    string Processed = "N";
                    sqlcmd = new SqlCommand("SELECT CreateDate, PostingDate, DocDate, ReferenceNo, ItemCode, ItemName FROM EMROIGE WHERE (PostingDate BETWEEN @d1 AND @d2) AND (ItemCode=@ItemCode) AND (ReferenceNo = @ReferenceNo) AND (WhsCode = @WhsCode)");
                    sqlcmd.Parameters.Add("@d1", GetLowDate(fromdate));
                    sqlcmd.Parameters.Add("@d2", GetHighDate(fromdate));
                    sqlcmd.Parameters.Add("@ReferenceNo", dr["JV No"].ToString());
                    sqlcmd.Parameters.Add("@WhsCode", dr["WH Code"].ToString());
                    sqlcmd.Parameters.Add("@ItemCode", dr["Item Code"].ToString());
                    DataTable dtGoodsIssue = SAPvdm.SelectQuery(sqlcmd).Tables[0];
                    if (dtGoodsIssue.Rows.Count > 0)
                    {
                    }
                    else
                    {
                        sqlcmd = new SqlCommand("Insert into EMROIGE (CreateDate,PostingDate,DocDate,ReferenceNo,ItemCode,ItemName,Price,Quantity,WhsCode,OcrCode,OcrCode2,Remarks,B1Upload,Processed,series) values (@CreateDate,@PostingDate,@DocDate,@ReferenceNo,@ItemCode,@ItemName,@Price,@Quantity,@WhsCode,@OcrCode,@OcrCode2,@Remarks,@B1Upload,@Processed,@series)");
                        sqlcmd.Parameters.Add("@CreateDate", CreateDate);
                        sqlcmd.Parameters.Add("@PostingDate", GetLowDate(fromdate));
                        sqlcmd.Parameters.Add("@DocDate", GetLowDate(fromdate));
                        sqlcmd.Parameters.Add("@ReferenceNo", dr["JV No"].ToString());
                        sqlcmd.Parameters.Add("@ItemCode", dr["Item Code"].ToString());
                        sqlcmd.Parameters.Add("@ItemName", dr["Item Name"].ToString());
                        sqlcmd.Parameters.Add("@Price", amount);
                        sqlcmd.Parameters.Add("@Quantity", dr["Qty"].ToString());
                        sqlcmd.Parameters.Add("@WhsCode", dr["WH Code"].ToString());
                        sqlcmd.Parameters.Add("@OcrCode", dr["WH Code"].ToString());
                        sqlcmd.Parameters.Add("@OcrCode2", dr["Category Code"].ToString());
                        sqlcmd.Parameters.Add("@Remarks", dr["Narration"].ToString());
                        sqlcmd.Parameters.Add("@B1Upload", B1Upload);
                        sqlcmd.Parameters.Add("@Processed", Processed);
                        string series = "240";
                        sqlcmd.Parameters.Add("@series", series);
                        SAPvdm.insert(sqlcmd);
                    }
                    string AcctCode = dr["Ledger Code"].ToString();
                    string whCode = dr["WH Code"].ToString();
                    if (AcctCode == "" && whCode == "")
                    {
                    }
                    else
                    {
                        sqlcmd = new SqlCommand("SELECT CreateDate, RefDate, DocDate, Ref1, Ref2, Ref3, TransNo, AcctCode FROM EMROJDT WHERE (RefDate BETWEEN @d1 AND @d2) AND (TransNo = @TransNo) AND (Ref1=@Ref1) AND (OcrCode = @OcrCode)");
                        sqlcmd.Parameters.Add("@d1", GetLowDate(fromdate));
                        sqlcmd.Parameters.Add("@d2", GetHighDate(fromdate));
                        sqlcmd.Parameters.Add("@TransNo", dr["JV No"].ToString());
                        sqlcmd.Parameters.Add("@OcrCode", dr["WH Code"].ToString());
                        sqlcmd.Parameters.Add("@Ref1", dr["Item Code"].ToString());
                        DataTable dtJournelPay = SAPvdm.SelectQuery(sqlcmd).Tables[0];
                        if (dtJournelPay.Rows.Count > 0)
                        {

                        }
                        else
                        {
                            sqlcmd = new SqlCommand("Insert into EMROJDT (CreateDate, RefDate, DocDate, TransNo, AcctCode, AcctName, Debit, Credit, B1Upload, Processed,Ref1,OcrCode,OcrCode2,series) values (@CreateDate, @RefDate, @DocDate,@TransNo, @AcctCode, @AcctName, @Debit, @Credit, @B1Upload, @Processed,@Ref1,@OcrCode,@OcrCode2,@series)");
                            sqlcmd.Parameters.Add("@CreateDate", GetLowDate(fromdate));
                            sqlcmd.Parameters.Add("@RefDate", GetLowDate(fromdate));
                            sqlcmd.Parameters.Add("@docdate", GetLowDate(fromdate));
                            sqlcmd.Parameters.Add("@Ref1", dr["Item Code"].ToString());
                            sqlcmd.Parameters.Add("@TransNo", dr["JV No"].ToString());
                            sqlcmd.Parameters.Add("@AcctCode", dr["Ledger Code"].ToString());
                            sqlcmd.Parameters.Add("@AcctName", dr["Ledger Name"].ToString());
                            double camount = 0;
                            double.TryParse(dr["Total Amount"].ToString(), out camount);
                            double Debit = 0;
                            sqlcmd.Parameters.Add("@Debit", Debit);
                            sqlcmd.Parameters.Add("@Credit", camount);
                            string cB1Upload = "N";
                            string cProcessed = "N";
                            sqlcmd.Parameters.Add("@B1Upload", cB1Upload);
                            sqlcmd.Parameters.Add("@Processed", cProcessed);
                            sqlcmd.Parameters.Add("@OcrCode", dr["WH Code"].ToString());
                            sqlcmd.Parameters.Add("@OcrCode2", dr["Category Code"].ToString());
                            string series = "230";
                            sqlcmd.Parameters.Add("@series", series);
                            SAPvdm.insert(sqlcmd);


                            sqlcmd = new SqlCommand("Insert into EMROJDT (CreateDate, RefDate, DocDate, TransNo, AcctCode, AcctName, Debit, Credit, B1Upload, Processed,Ref1,OcrCode,OcrCode2,series) values (@CreateDate, @RefDate, @DocDate,@TransNo, @AcctCode, @AcctName, @Debit, @Credit, @B1Upload, @Processed,@Ref1,@OcrCode,@OcrCode2,@series)");
                            sqlcmd.Parameters.Add("@CreateDate", GetLowDate(fromdate));
                            sqlcmd.Parameters.Add("@RefDate", GetLowDate(fromdate));
                            sqlcmd.Parameters.Add("@docdate", GetLowDate(fromdate));
                            sqlcmd.Parameters.Add("@Ref1", dr["Item Code"].ToString());
                            sqlcmd.Parameters.Add("@TransNo", dr["JV No"].ToString());
                            sqlcmd.Parameters.Add("@AcctCode", dr["Ledger Code"].ToString());
                            sqlcmd.Parameters.Add("@AcctName", dr["Ledger Name"].ToString());
                            double damount = 0;
                            double.TryParse(dr["Total Amount"].ToString(), out damount);
                            double Credit = 0;
                            sqlcmd.Parameters.Add("@Debit", damount);
                            sqlcmd.Parameters.Add("@Credit", Credit);
                            sqlcmd.Parameters.Add("@B1Upload", B1Upload);
                            sqlcmd.Parameters.Add("@Processed", Processed);
                            sqlcmd.Parameters.Add("@OcrCode", dr["WH Code"].ToString());
                            sqlcmd.Parameters.Add("@OcrCode2", dr["Category Code"].ToString());
                            sqlcmd.Parameters.Add("@series", series);
                            SAPvdm.insert(sqlcmd);
                        }
                    }
                }
            }
            DataTable dtempty = new DataTable();
            grdReports.DataSource = dtempty;
            grdReports.DataBind();
            lblmsg.Text = "Successfully Saved";
        }
        catch (Exception ex)
        {
            lblmsg.Text = ex.ToString();
        }
    }
}