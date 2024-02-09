using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class SAP_GoodsIssue : System.Web.UI.Page
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
                    txtFromdate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");//Convert.ToString(lblFromDate.Text); ////     /////
                    txtTodate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
                    lblTitle.Text = Session["TitleName"].ToString();
                    bindbranches();
                }
            }
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
    protected void btnGenerate_Click(object sender, EventArgs e)
    {
        try
        {
            Report.Columns.Add("JV No");
            Report.Columns.Add("JV Date");
            Report.Columns.Add("whcode");
            Report.Columns.Add("Category Code");
            Report.Columns.Add("Item Code");
            Report.Columns.Add("Item Name");
            Report.Columns.Add("Qty");
            Report.Columns.Add("Rate");
            Report.Columns.Add("Amount");
            Report.Columns.Add("Milk Type");
            Report.Columns.Add("Narration");
            lblmsg.Text = "";
            SalesDBManager SalesDB = new SalesDBManager();
            DateTime fromdate = DateTime.Now;
            DateTime todate = DateTime.Now;
            string[] datestrig = txtFromdate.Text.Split(' ');
            if (datestrig.Length > 1)
            {
                if (datestrig[0].Split('-').Length > 0)
                {
                    string[] dates = datestrig[0].Split('-');
                    string[] times = datestrig[1].Split(':');
                    fromdate = new DateTime(int.Parse(dates[2]), int.Parse(dates[1]), int.Parse(dates[0]), int.Parse(times[0]), int.Parse(times[1]), 0);
                }
            }
            datestrig = txtTodate.Text.Split(' ');
            if (datestrig.Length > 1)
            {
                if (datestrig[0].Split('-').Length > 0)
                {
                    string[] dates = datestrig[0].Split('-');
                    string[] times = datestrig[1].Split(':');
                    todate = new DateTime(int.Parse(dates[2]), int.Parse(dates[1]), int.Parse(dates[0]), int.Parse(times[0]), int.Parse(times[1]), 0);
                }
            }
            DateTime ReportDate = fromdate;
            DateTime dtapril = new DateTime();
            DateTime dtmarch = new DateTime();
            int currentyear = ReportDate.Year;
            int nextyear = ReportDate.Year + 1;
            if (ReportDate.Month > 3)
            {
                string apr = "4/1/" + currentyear;
                dtapril = DateTime.Parse(apr);
                string march = "3/31/" + nextyear;
                dtmarch = DateTime.Parse(march);
            }
            if (ReportDate.Month <= 3)
            {
                string apr = "4/1/" + (currentyear - 1);
                dtapril = DateTime.Parse(apr);
                string march = "3/31/" + (nextyear - 1);
                dtmarch = DateTime.Parse(march);
            }
            string DCNO = "";
            if (ddlbranchname.SelectedValue == "174")
            {
            }
            lblbranchName.Text = ddlbranchname.SelectedItem.Text;
            cmd = new SqlCommand("SELECT branchid, branchname, whcode, tbranchname FROM branchmaster WHERE (branchid = @BranchID)");
            cmd.Parameters.Add("@BranchID", ddlbranchname.SelectedValue);
            DataTable dtincetivename = vdm.SelectQuery(cmd).Tables[0];
            string branch_id = Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT stocktransferdetails.remarks,productmaster.itemcode, stocktransferdetails.invoiceno, stocktransferdetails.invoicedate, stocktransfersubdetails.price, stocktransfersubdetails.taxvalue, stocktransfersubdetails.freigtamt, stocktransfersubdetails.sno, productmaster.productname, stocktransfersubdetails.quantity, subcategorymaster.ledgername, subcategorymaster.sub_cat_code, categorymaster.categeorycode FROM categorymaster INNER JOIN subcategorymaster ON categorymaster.categoryid = subcategorymaster.categoryid RIGHT OUTER JOIN stocktransferdetails INNER JOIN stocktransfersubdetails ON stocktransferdetails.sno = stocktransfersubdetails.stock_refno INNER JOIN productmaster ON stocktransfersubdetails.productid = productmaster.productid ON subcategorymaster.subcategoryid = productmaster.subcategoryid WHERE (stocktransferdetails.invoicedate BETWEEN @d1 AND @d2) AND (stocktransfersubdetails.quantity > 0) AND (stocktransferdetails.tobranch = @BranchID)");
            cmd.Parameters.Add("@d1", GetLowDate(fromdate));
            cmd.Parameters.Add("@d2", GetHighDate(todate));
            cmd.Parameters.Add("@BranchID", ddlbranchname.SelectedValue);
            DataTable dtstocktransfer = SalesDB.SelectQuery(cmd).Tables[0];

            double totalamount = 0;
            string invoiceno = "";
            foreach (DataRow branch in dtstocktransfer.Rows)
            {
                DataRow newrow = Report.NewRow();
                double Qty = 0;
                double.TryParse(branch["quantity"].ToString(), out Qty);
                if (Qty == 0.0)
                {
                }
                else
                {
                    double Rate = 0;
                    double.TryParse(branch["price"].ToString(), out Rate);
                    Rate = Math.Round(Rate, 2);
                    newrow["Qty"] = Qty;
                    newrow["Rate"] = Rate;
                    double amount = 0;
                    amount = Qty * Rate;
                    totalamount += amount;
                    invoiceno = branch["invoiceno"].ToString();
                    newrow["JV No"] = DCNO + "ST" + branch["invoiceno"].ToString();
                    newrow["JV Date"] = fromdate.ToString("dd-MMM-yyyy");
                    newrow["Category Code"] = branch["categeorycode"].ToString();
                    newrow["whcode"] = dtincetivename.Rows[0]["whcode"].ToString();
                    newrow["Item Code"] = branch["itemcode"].ToString();
                    newrow["Item Name"] = branch["productname"].ToString();
                    amount = Math.Round(amount, 2);
                    newrow["Amount"] = amount;
                    newrow["Milk Type"] = "StoresIssue";
                    newrow["Narration"] = "Being the Sale Of " + branch["productname"].ToString() + " Through " + ddlbranchname.SelectedItem.Text + ". Invoice No " + branch["invoiceno"].ToString() + ",Emp Name  " + Session["UserName"].ToString();
                    Report.Rows.Add(newrow);
                }
            }
            pnlHide.Visible = true;
            grdReports.DataSource = Report;
            grdReports.DataBind();
            Session["xportdata"] = Report;
        }
        catch
        {
        }
    }
    SqlCommand sqlcmd;
    protected void BtnSave_Click(object sender, EventArgs e)
    {
        try
        {
            SAPdbmanger SAPvdm = new SAPdbmanger();
            DateTime fromdate = DateTime.Now;
            DataTable dt = (DataTable)Session["xportdata"];
            string[] dateFromstrig = txtFromdate.Text.Split(' ');
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
                double amount = 0;
                double.TryParse(dr["Amount"].ToString(), out amount);
                string B1Upload = "N";
                string Processed = "N";
                sqlcmd = new SqlCommand("SELECT CreateDate, PostingDate, DocDate, ReferenceNo, ItemCode, ItemName, MILKTYPE FROM EMROIGE WHERE (PostingDate BETWEEN @d1 AND @d2) AND (ItemCode=@ItemCode) AND (ReferenceNo = @ReferenceNo) AND (WhsCode = @WhsCode)");
                sqlcmd.Parameters.Add("@d1", GetLowDate(fromdate));
                sqlcmd.Parameters.Add("@d2", GetHighDate(fromdate));
                sqlcmd.Parameters.Add("@ReferenceNo", dr["JV No"].ToString());
                sqlcmd.Parameters.Add("@WhsCode", dr["whcode"].ToString());
                sqlcmd.Parameters.Add("@ItemCode", dr["Item Code"].ToString());
                DataTable dtGoodsIssue = SAPvdm.SelectQuery(sqlcmd).Tables[0];
                if (dtGoodsIssue.Rows.Count > 0)
                {
                }
                else
                {
                    sqlcmd = new SqlCommand("Insert into EMROIGE (CreateDate,PostingDate,DocDate,ReferenceNo,ItemCode,ItemName,Price,Quantity,WhsCode,OcrCode,OcrCode2,Remarks,B1Upload,Processed,series,Milktype) values (@CreateDate,@PostingDate,@DocDate,@ReferenceNo,@ItemCode,@ItemName,@Price,@Quantity,@WhsCode,@OcrCode,@OcrCode2,@Remarks,@B1Upload,@Processed,@series,@Milktype)");
                    sqlcmd.Parameters.Add("@CreateDate", GetLowDate(fromdate));
                    sqlcmd.Parameters.Add("@PostingDate", GetLowDate(fromdate));
                    sqlcmd.Parameters.Add("@DocDate", GetLowDate(fromdate));
                    sqlcmd.Parameters.Add("@ReferenceNo", dr["JV No"].ToString());
                    sqlcmd.Parameters.Add("@ItemCode", dr["Item Code"].ToString());
                    sqlcmd.Parameters.Add("@ItemName", dr["Item Name"].ToString());
                    sqlcmd.Parameters.Add("@Price", amount);
                    sqlcmd.Parameters.Add("@Quantity", dr["Qty"].ToString());
                    sqlcmd.Parameters.Add("@WhsCode", dr["whcode"].ToString());
                    sqlcmd.Parameters.Add("@OcrCode", dr["whcode"].ToString());
                    sqlcmd.Parameters.Add("@OcrCode2", dr["Category Code"].ToString());
                    sqlcmd.Parameters.Add("@Remarks", dr["Narration"].ToString());
                    sqlcmd.Parameters.Add("@B1Upload", B1Upload);
                    sqlcmd.Parameters.Add("@Processed", Processed);
                    string series = "240";
                    sqlcmd.Parameters.Add("@series", series);
                    sqlcmd.Parameters.Add("@Milktype", dr["Milk Type"].ToString());
                    SAPvdm.insert(sqlcmd);
                }
            }
            pnlHide.Visible = false;
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
