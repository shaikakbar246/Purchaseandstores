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

public partial class SAP_MRN_Report : System.Web.UI.Page
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
    protected void btn_Generate_Click(object sender, EventArgs e)
    {
        try
        {
            Report.Columns.Add("CREATE DATE");
            Report.Columns.Add("CARD CODE");
            Report.Columns.Add("CARD NAME");
            Report.Columns.Add("REFERENCE NO");
            Report.Columns.Add("ITEMCODE");
            Report.Columns.Add("DESCRIPTION");
            Report.Columns.Add("WARE HOUSE CODE");
            Report.Columns.Add("QUANTITY");
            Report.Columns.Add("PRICE");
            Report.Columns.Add("VAT PERCENT");
            Report.Columns.Add("LINE TOTAL");
            Report.Columns.Add("REMARKS");
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
            string branchid = Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT  suppliersdetails.name, suppliersdetails.suppliercode, inwarddetails.sno, inwarddetails.inwarddate, inwarddetails.invoiceno, inwarddetails.invoicedate,inwarddetails.dcno, inwarddetails.lrno, inwarddetails.supplierid, inwarddetails.podate, inwarddetails.doorno, inwarddetails.remarks, inwarddetails.pono, inwarddetails.inwardno, inwarddetails.transportname, inwarddetails.vehicleno, inwarddetails.modeofinward, inwarddetails.securityno, inwarddetails.uimid,inwarddetails.status, inwarddetails.mrnno, inwarddetails.indentno, inwarddetails.freigtamt, inwarddetails.transportcharge, inwarddetails.inwardamount,  subinwarddetails.sno AS Expr1, subinwarddetails.productid, subinwarddetails.quantity, subinwarddetails.perunit, subinwarddetails.totalcost, subinwarddetails.in_refno, subinwarddetails.status AS Expr2, subinwarddetails.taxtype, subinwarddetails.ed, subinwarddetails.dis, subinwarddetails.disamt, subinwarddetails.tax, subinwarddetails.edtax, productmaster.itemcode, productmaster.productname, taxmaster.type AS tax_type, taxmaster_1.type AS ed_type, inwarddetails.pfid, pandf.pandf, subinwarddetails.igst, subinwarddetails.cgst, subinwarddetails.sgst FROM inwarddetails INNER JOIN subinwarddetails ON inwarddetails.sno = subinwarddetails.in_refno INNER JOIN productmaster ON subinwarddetails.productid = productmaster.productid INNER JOIN suppliersdetails ON inwarddetails.supplierid = suppliersdetails.supplierid left outer JOIN taxmaster ON subinwarddetails.taxtype = taxmaster.sno left outer JOIN taxmaster AS taxmaster_1 ON subinwarddetails.ed = taxmaster_1.sno LEFT OUTER JOIN pandf ON inwarddetails.pfid = pandf.sno WHERE (inwarddetails.inwarddate BETWEEN @fromdate AND @todate) AND (inwarddetails.branchid = @branchid) AND (inwarddetails.mrnno IS NOT NULL) AND  (inwarddetails.mrnno <> 0)");
            cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
            cmd.Parameters.Add("@todate", GetHighDate(fromdate));
            cmd.Parameters.Add("@branchid", branchid);
            DataTable dttotalinward = vdm.SelectQuery(cmd).Tables[0];
            if (dttotalinward.Rows.Count > 0)
            {

                double ttotalamount = 0;
                DateTime dt = DateTime.Now;
                string prevdate = string.Empty;
                var i = 1;
                foreach (DataRow dr in dttotalinward.Rows)
                {
                    DataRow newrow = Report.NewRow();
                    DateTime dt_inward = Convert.ToDateTime(dr["inwarddate"].ToString());
                    string dt_inward_date = dt_inward.ToString("dd/MM/yyyy");
                    newrow["CREATE DATE"] = dt_inward_date; 
                    newrow["CARD CODE"] = dr["suppliercode"].ToString();
                    newrow["CARD NAME"] = dr["name"].ToString();
                    newrow["REFERENCE NO"] = dr["mrnno"].ToString();
                    newrow["ITEMCODE"] = dr["itemcode"].ToString();
                    newrow["DESCRIPTION"] = dr["productname"].ToString();
                    newrow["WARE HOUSE CODE"] = "SVDSPP02"; 
                    newrow["QUANTITY"] = dr["quantity"].ToString();
                    newrow["PRICE"] = dr["perunit"].ToString();
                    newrow["VAT PERCENT"] = dr["tax_type"].ToString();
                    double price = 0;
                    double.TryParse(dr["perunit"].ToString(), out price);
                    double qty = 0;
                    double.TryParse(dr["quantity"].ToString(), out qty);
                    double total = 0;  double vat_per = 0; double vat_amt = 0; double amt_tax = 0;
                    total = qty * price;
                    double.TryParse(dr["tax_type"].ToString(), out vat_per);
                    vat_amt = (total * vat_per) / 100;
                    amt_tax = total + vat_amt;
                    newrow["LINE TOTAL"] = amt_tax.ToString();
                    newrow["REMARKS"] = "";
                    ttotalamount += amt_tax;
                    Report.Rows.Add(newrow);
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
    protected void grdReports_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
        }
    }
    protected void btnexport_click(object sender, EventArgs e)
    {

        Response.Redirect("~/exporttoxl.aspx");

    }

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
            string ocrcode2 = "", remarks = "";
            foreach (DataRow dr in dt.Rows)
            {
                string itemcode = dr["ITEMCODE"].ToString();
                if (itemcode == "")
                {
                }
                else
                {
                    cmd = new SqlCommand("insert into EMROPDN (CreateDate, CardCode, CardName, TaxDate, DocDate, DocDueDate, ReferenceNo, ItemCode, Dscription, WhsCode, Quantity, Price, VAT_Percent, LineTotal, OcrCode, OcrCode2, REMARKS, B1Upload, Processed) values (@CreateDate, @CardCode, @CardName, @TaxDate, @DocDate, @DocDueDate, @ReferenceNo, @ItemCode, @Dscription, @WhsCode, @Quantity, @Price, @VAT_Percent, @LineTotal, @OcrCode, @OcrCode2, @REMARKS, @B1Upload, @Processed)");
                    cmd.Parameters.Add("@CreateDate", fromdate);
                    cmd.Parameters.Add("@CardCode", dr["CARD CODE"].ToString());
                    cmd.Parameters.Add("@CardName", dr["CARD NAME"].ToString());
                    cmd.Parameters.Add("@TaxDate", fromdate);
                    cmd.Parameters.Add("@DocDate", fromdate);
                    cmd.Parameters.Add("@DocDueDate", fromdate);
                    cmd.Parameters.Add("@ReferenceNo", dr["REFERENCE NO"].ToString());
                    cmd.Parameters.Add("@ItemCode", dr["ITEMCODE"].ToString());
                    cmd.Parameters.Add("@Dscription", dr["DESCRIPTION"].ToString());
                    cmd.Parameters.Add("@WhsCode", dr["WARE HOUSE CODE"].ToString());
                    double qty = 0;
                    double.TryParse(dr["QUANTITY"].ToString(), out qty);
                    cmd.Parameters.Add("@Quantity", qty);
                    double price = 0;
                    double.TryParse(dr["price"].ToString(), out price);
                    cmd.Parameters.Add("@Price", price);
                    double vatpercent = 0;
                    double.TryParse(dr["VAT PERCENT"].ToString(), out vatpercent);
                    cmd.Parameters.Add("@VAT_Percent", vatpercent);
                    double linetotal = 0;
                    double.TryParse(dr["LINE TOTAL"].ToString(), out linetotal);
                    cmd.Parameters.Add("@LineTotal", linetotal);
                    cmd.Parameters.Add("@OcrCode", dr["WARE HOUSE CODE"].ToString());
                    cmd.Parameters.Add("@OcrCode2", ocrcode2);
                    cmd.Parameters.Add("@REMARKS", remarks);
                    string B1Upload = "N";
                    string Processed = "N";
                    cmd.Parameters.Add("@B1Upload", B1Upload);
                    cmd.Parameters.Add("@Processed", Processed);
                    SAPvdm.insert(cmd);
                }
            }
            lblmsg.Text = "Saved successfully";
            DataTable dtempty = new DataTable();
            grdReports.DataSource = dtempty;
            grdReports.DataBind();
        }
        catch (Exception ex)
        {
            lblmsg.Text = ex.Message;
            hidepanel.Visible = false;
        }
    }
}