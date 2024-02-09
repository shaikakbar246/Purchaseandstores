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

public partial class SAP_BranchTransfer : System.Web.UI.Page
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
        cmd = new SqlCommand("SELECT DISTINCT branchid, branchname FROM branchmaster INNER JOIN branchmapping ON branchmapping.mainbranch = branchmaster.branchid");
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
            Report.Columns.Add("CreateDate");
            Report.Columns.Add("PostingDate");
            Report.Columns.Add("DocDate");
            Report.Columns.Add("ReferenceNo");
            Report.Columns.Add("FromWhsCode");
            Report.Columns.Add("Wh Code");
            Report.Columns.Add("Item Code");
            Report.Columns.Add("Item Name");
            Report.Columns.Add("Qty");
            Report.Columns.Add("Price");
            Report.Columns.Add("Amount");
            Report.Columns.Add("OcrCode");
            Report.Columns.Add("Category Code");
            Report.Columns.Add("Narration");
            Report.Columns.Add("series");
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
            string branch_id = Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT STD.remarks, STD.frombranch, STD.tobranch, PM.itemcode, CM.categeorycode, BM.whcode AS towhcode, STD.invoiceno, STD.invoicedate, STSD.price, STSD.taxvalue, STSD.freigtamt, STSD.sno, PM.productname,  PM.productcode, STSD.quantity, BM.branchname FROM stocktransferdetails AS STD INNER JOIN stocktransfersubdetails AS STSD ON STD.sno = STSD.stock_refno INNER JOIN productmaster AS PM ON STSD.productid = PM.productid INNER JOIN branchmaster AS BM ON STD.tobranch = BM.branchid LEFT OUTER JOIN categorymaster AS CM ON CM.cat_code=PM.productcode WHERE (STD.invoicedate BETWEEN @fromdate AND @todate) AND (BM.type='Inter Branch') AND (STSD.quantity > 0) AND (STD.branchid=@branchid)");
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
                    string VoucherNo = "SVDS/PBK/1718/ " + dr["invoiceno"].ToString() + "";
                    string FromWhsCode = fromwhcode;
                    string toWhsCode = dr["towhcode"].ToString();
                    string itemcode = dr["itemcode"].ToString();
                    string itemname = dr["productname"].ToString();
                    string qty = dr["quantity"].ToString();
                    string price = dr["price"].ToString();
                    string ocrcode = fromwhcode;
                    string categorycode = dr["categeorycode"].ToString();
                    string narration = dr["remarks"].ToString();
                    string series = "241";
                    double quantity = Convert.ToDouble(qty);
                    double pprice = Convert.ToDouble(price);
                    double totalvalue = quantity * pprice;
                    totalvalue = Math.Round(totalvalue, 2);
                    gnewrow["Amount"] = totalvalue;
                    gnewrow["CreateDate"] = invoicdate;
                    gnewrow["PostingDate"] = invoicdate;
                    gnewrow["DocDate"] = invoicdate;
                    gnewrow["ReferenceNo"] = VoucherNo;
                    gnewrow["FromWhsCode"] = FromWhsCode;
                    gnewrow["Wh Code"] = toWhsCode;
                    gnewrow["Item Code"] = itemcode;
                    gnewrow["Item Name"] = itemname;
                    gnewrow["Qty"] = qty;
                    gnewrow["Price"] = price;
                    gnewrow["OcrCode"] = ocrcode;
                    gnewrow["Category Code"] = categorycode;
                    gnewrow["Narration"] = narration;
                    gnewrow["series"] = series;
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
    protected void btn_save_click(object sender, EventArgs e)
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
            fromdate = fromdate;
            foreach (DataRow dr in dt.Rows)
            {
                double amount = 10;
                string B1Upload = "N";
                string Processed = "N";
                string ledgercode = dr["Item Code"].ToString();
                if (ledgercode == "")
                {
                }
                else
                {
                    sqlcmd = new SqlCommand("SELECT CreateDate, PostingDate, DocDate, ReferenceNo AS Processed, Series FROM EMROWTR WHERE (PostingDate BETWEEN @d1 AND @d2) AND (ItemCode=@ItemCode) AND (ReferenceNo = @ReferenceNo)");
                    sqlcmd.Parameters.Add("@d1", GetLowDate(fromdate));
                    sqlcmd.Parameters.Add("@d2", GetHighDate(fromdate));
                    sqlcmd.Parameters.Add("@ReferenceNo", dr["ReferenceNo"].ToString());
                    sqlcmd.Parameters.Add("@ItemCode", dr["Item Code"].ToString());
                    DataTable dtST = SAPvdm.SelectQuery(sqlcmd).Tables[0];
                    if (dtST.Rows.Count > 0)
                    {
                    }
                    else
                    {
                        sqlcmd = new SqlCommand("Insert into EMROWTR (CreateDate,PostingDate,DocDate,ReferenceNo,FromWhsCode,ToWhsCode,ItemCode,ItemName,Quantity,Price,OcrCode,OcrCode2,Remarks,B1Upload,Processed,series) values (@CreateDate,@PostingDate,@DocDate,@ReferenceNo,@FromWhsCode,@ToWhsCode,@ItemCode,@ItemName,@Quantity,@Price,@OcrCode,@OcrCode2,@Remarks,@B1Upload,@Processed,@series)");
                        sqlcmd.Parameters.Add("@CreateDate", GetLowDate(fromdate));
                        sqlcmd.Parameters.Add("@PostingDate", GetLowDate(fromdate));
                        sqlcmd.Parameters.Add("@DocDate", GetLowDate(fromdate));
                        sqlcmd.Parameters.Add("@ReferenceNo", dr["ReferenceNo"].ToString());
                        string fromwhcode = "SVDSPP02";
                        sqlcmd.Parameters.Add("@FromWhsCode", fromwhcode);
                        sqlcmd.Parameters.Add("@ToWhsCode", dr["Wh Code"].ToString());
                        sqlcmd.Parameters.Add("@ItemCode", dr["Item Code"].ToString());
                        sqlcmd.Parameters.Add("@ItemName", dr["Item Name"].ToString());
                        sqlcmd.Parameters.Add("@Quantity", dr["Qty"].ToString());
                        sqlcmd.Parameters.Add("@Price", dr["Price"].ToString());
                        sqlcmd.Parameters.Add("@OcrCode", fromwhcode);
                        sqlcmd.Parameters.Add("@OcrCode2", "");
                        sqlcmd.Parameters.Add("@Remarks", dr["Narration"].ToString());
                        sqlcmd.Parameters.Add("@B1Upload", B1Upload);
                        sqlcmd.Parameters.Add("@Processed", Processed);
                        string series = "241";
                        sqlcmd.Parameters.Add("@series", series);
                        SAPvdm.insert(sqlcmd);
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