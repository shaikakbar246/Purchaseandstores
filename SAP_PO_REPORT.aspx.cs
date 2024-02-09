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

public partial class SAP_PO_REPORT : System.Web.UI.Page
{
    SqlCommand cmd;
    SalesDBManager vdm;
    string tempval;
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
                    dtp_FromDate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
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

    DataTable DataReport = new DataTable();
    protected void btn_Generate_Click(object sender, EventArgs e)
    {
        try
        {
            DataReport.Columns.Add("CREATE DATE");
            DataReport.Columns.Add("CARD CODE");
            DataReport.Columns.Add("CARD NAME");
            DataReport.Columns.Add("DISCOUNT %");
            DataReport.Columns.Add("REFERENCE NO");
            DataReport.Columns.Add("ITEMCODE");
            DataReport.Columns.Add("DESCRIPTION");
            DataReport.Columns.Add("WARE HOUSE CODE");
            DataReport.Columns.Add("QUANTITY");
            DataReport.Columns.Add("PRICE");
            DataReport.Columns.Add("TAXCODE");
            DataReport.Columns.Add("TAX%");
            DataReport.Columns.Add("TRANSPORT");
            DataReport.Columns.Add("Narration");
            lblmsg.Text = "";
            SalesDBManager SalesDB = new SalesDBManager();
            DateTime fromdate = DateTime.Now;
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
            string branchid = Session["Po_BranchID"].ToString();

            cmd = new SqlCommand("SELECT po_entrydetailes.remarks, po_entrydetailes.sno, po_entrydetailes.shortname, po_entrydetailes.podate, po_entrydetailes.poamount, po_entrydetailes.name, po_entrydetailes.delivarydate, po_entrydetailes.freigtamt, po_entrydetailes.status, po_entrydetailes.quotationdate, po_entrydetailes.supplierid, po_entrydetailes.others, po_entrydetailes.paymentid, po_entrydetailes.deliverytermsid, po_entrydetailes.insurance, po_entrydetailes.insuranceamount, po_entrydetailes.remarks, po_entrydetailes.otp, po_entrydetailes.ponumber, po_entrydetailes.branchid, po_entrydetailes.pricebasis, po_entrydetailes.addressid, po_entrydetailes.billaddressid, po_entrydetailes.transportcharge, po_entrydetailes.indentno, po_sub_detailes.code AS Expr1, po_sub_detailes.sno AS Expr2, po_sub_detailes.description, po_sub_detailes.qty, po_sub_detailes.cost, po_sub_detailes.taxtype, po_sub_detailes.ed, po_sub_detailes.dis, po_sub_detailes.disamt, po_sub_detailes.tax, po_sub_detailes.po_refno, po_sub_detailes.productsno, po_sub_detailes.edtax, po_sub_detailes.productamount, productmaster.productname, productmaster.itemcode, suppliersdetails.name AS sup_name, suppliersdetails.suppliercode, taxmaster.type, taxmaster_1.type AS edtype, po_entrydetailes.pfid, po_sub_detailes.igst, po_sub_detailes.cgst, po_sub_detailes.sgst FROM po_entrydetailes INNER JOIN po_sub_detailes ON po_entrydetailes.sno = po_sub_detailes.po_refno INNER JOIN productmaster ON po_sub_detailes.productsno = productmaster.productid LEFT OUTER JOIN taxmaster ON po_sub_detailes.taxtype = taxmaster.sno INNER JOIN suppliersdetails ON po_entrydetailes.supplierid = suppliersdetails.supplierid LEFT OUTER JOIN taxmaster AS taxmaster_1 ON po_sub_detailes.ed = taxmaster_1.sno WHERE (po_entrydetailes.podate BETWEEN @fromdate AND @todate) AND (po_entrydetailes.branchid = @branchid)");
            cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
            cmd.Parameters.Add("@todate", GetHighDate(fromdate));
            cmd.Parameters.Add("@branchid", branchid);
            DataTable dttotalinward = vdm.SelectQuery(cmd).Tables[0];
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            if (dttotalinward.Rows.Count > 0)
            {
                string taxcode = "", taxtype = "", transport = "";
                double ttotalamount = 0;
                DateTime dt = DateTime.Now;
                string prevdate = string.Empty;
                DateTime dtapril = new DateTime();
                DateTime dtmarch = new DateTime();
               
                foreach (DataRow dr in dttotalinward.Rows)
                {

                    DataRow newrow = DataReport.NewRow();
                    DateTime dt_po = Convert.ToDateTime(dr["podate"].ToString());
                    int currentyear = dt_po.Year;
                    int nextyear = dt_po.Year + 1;
                    int currntyearnum = 0;
                    int nextyearnum = 0;
                    if (dt_po.Month > 3)
                    {
                        string apr = "4/1/" + currentyear;
                        dtapril = DateTime.Parse(apr);
                        string march = "3/31/" + nextyear;
                        dtmarch = DateTime.Parse(march);
                        currntyearnum = currentyear;
                        nextyearnum = nextyear;
                    }
                    if (dt_po.Month <= 3)
                    {
                        string apr = "4/1/" + (currentyear - 1);
                        dtapril = DateTime.Parse(apr);
                        string march = "3/31/" + (nextyear - 1);
                        dtmarch = DateTime.Parse(march);
                        currntyearnum = currentyear - 1;
                        nextyearnum = nextyear - 1;
                    }
                    string dt_po_date = dt_po.ToString("dd/MM/yyyy");
                    newrow["CREATE DATE"] = dt_po_date; 
                    newrow["CARD CODE"] = dr["suppliercode"].ToString();
                    newrow["CARD NAME"] = dr["sup_name"].ToString();
                    newrow["DISCOUNT %"] = dr["dis"].ToString();
                    string po = "";
                    po = "SVDS/PBK/PO/" + dtapril.ToString("yy") + "-" + dtmarch.ToString("yy") + "/" + dr["ponumber"].ToString();
                    newrow["REFERENCE NO"] = po.ToString();
                    newrow["ITEMCODE"] = dr["itemcode"].ToString();
                    newrow["DESCRIPTION"] = dr["productname"].ToString();
                    newrow["WARE HOUSE CODE"] = "SVDSPP02"; 
                    newrow["QUANTITY"] = dr["qty"].ToString();
                    newrow["PRICE"] = dr["cost"].ToString();
                    taxtype = dr["type"].ToString();
                    string igst = dr["igst"].ToString();
                    string cgst = dr["cgst"].ToString();
                    string sgst = dr["sgst"].ToString();
                    if (igst != "0")
                    {
                        taxcode = "IGST" + igst + "";
                        newrow["TAX%"] = igst;
                    }
                    if (cgst != "0")
                    {
                        double ctax = Convert.ToDouble(cgst);
                        cgst = (ctax + ctax).ToString();
                        taxcode = "CGST" + cgst + "";
                        newrow["TAX%"] = ctax;
                    }
                    if (igst == "0" && cgst == "0")
                    {
                        taxcode = "EXEMPT";
                        newrow["TAX%"] = "0";
                    }
                    newrow["TAXCODE"] = taxcode;
                    double total = 0; double vat_amt = 0; double amt_tax = 0;
                    string trans_chrgs = dr["transportcharge"].ToString();
                    string freight_chrgs = dr["freigtamt"].ToString();
                    if (trans_chrgs != "" || trans_chrgs != "0")
                    {
                        transport = trans_chrgs;
                    }
                    else if (freight_chrgs != "" || freight_chrgs != "0")
                    {
                        transport = freight_chrgs;
                    }
                    else
                    {
                        transport = "0";
                    }
                    amt_tax = total + vat_amt + Convert.ToDouble(transport);
                    newrow["TRANSPORT"] = transport;
                    newrow["Narration"] = dr["remarks"].ToString(); 
                    ttotalamount += amt_tax;
                    DataReport.Rows.Add(newrow);
                }
                Session["xportdata"] = DataReport;
                Session["filename"] = "SAP PO Report";
                grdReports.DataSource = DataReport;
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
            foreach (DataRow dr in dt.Rows)
            {
                string itemcode = dr["ITEMCODE"].ToString();
                string cardcode = dr["CARD CODE"].ToString();
                if (itemcode == "")
                {
                }
                else if (cardcode == "")
                {
                }
                else
                {
                    cmd = new SqlCommand("SELECT * FROM EMROPOR WHERE (TaxDate BETWEEN @d1 AND @d2) AND (ReferenceNo = @ReferenceNo) AND (ItemCode = @ItemCode) AND (WhsCode = @WhsCode)");
                    cmd.Parameters.Add("@d1",GetLowDate(fromdate));
                    cmd.Parameters.Add("@d2",GetHighDate(fromdate));
                    cmd.Parameters.Add("@ReferenceNo", dr["REFERENCE NO"].ToString());
                    cmd.Parameters.Add("@WhsCode", dr["WARE HOUSE CODE"].ToString());
                    cmd.Parameters.Add("@ItemCode", dr["ITEMCODE"].ToString());
                    DataTable dtPCH = SAPvdm.SelectQuery(cmd).Tables[0];
                    if (dtPCH.Rows.Count > 0)
                    {
                    }
                    else
                    {
                        cmd = new SqlCommand("insert into EMROPOR (CreateDate, CardCode, CardName, TaxDate, DocDate, DocDueDate, DiscPercent, ReferenceNo, ItemCode, Dscription, WhsCode, Quantity, Price, OcrCode, TaxCode, PURCHASETYPE, B1Upload, Processed,remarks,VAT_Percent) values (@CreateDate, @CardCode, @CardName, @TaxDate, @DocDate, @DocDueDate, @DiscPercent, @ReferenceNo, @ItemCode, @Dscription, @WhsCode, @Quantity, @Price, @OcrCode, @TaxCode, @purchasetype, @B1Upload, @Processed,@remarks,@TAXPER)");
                        cmd.Parameters.Add("@CreateDate", CreateDate);
                        cmd.Parameters.Add("@CardCode", dr["CARD CODE"].ToString());
                        cmd.Parameters.Add("@CardName", dr["CARD NAME"].ToString());
                        cmd.Parameters.Add("@TaxDate", fromdate);
                        cmd.Parameters.Add("@DocDate", fromdate);
                        cmd.Parameters.Add("@DocDueDate", fromdate);
                        cmd.Parameters.Add("@DiscPercent", dr["DISCOUNT %"].ToString());
                        cmd.Parameters.Add("@ReferenceNo", dr["REFERENCE NO"].ToString());
                        cmd.Parameters.Add("@ItemCode", dr["ITEMCODE"].ToString());
                        cmd.Parameters.Add("@Dscription", dr["DESCRIPTION"].ToString());
                        cmd.Parameters.Add("@WhsCode", dr["WARE HOUSE CODE"].ToString());
                        double qty = 0;
                        double.TryParse(dr["QUANTITY"].ToString(), out qty);
                        cmd.Parameters.Add("@Quantity", qty);
                        double price = 0;
                        double.TryParse(dr["PRICE"].ToString(), out price);
                        cmd.Parameters.Add("@Price", price);
                        cmd.Parameters.Add("@OcrCode", dr["WARE HOUSE CODE"].ToString());
                        cmd.Parameters.Add("@TaxCode", dr["TAXCODE"].ToString());
                        cmd.Parameters.Add("@TAXPER", dr["TAX%"].ToString());
                        string B1Upload = "N";
                        string Processed = "N";
                        string purchasetype = "93";
                        cmd.Parameters.Add("@purchasetype", purchasetype);
                        cmd.Parameters.Add("@B1Upload", B1Upload);
                        cmd.Parameters.Add("@Processed", Processed);
                        cmd.Parameters.Add("@remarks", dr["Narration"].ToString());
                        if (qty == 0.0)
                        {
                        }
                        else
                        {
                            SAPvdm.insert(cmd);
                        }
                    }
                }
            }
            hidepanel.Visible = false;
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
    protected void btnexport_click(object sender, EventArgs e)
    {
        Response.Redirect("~/exporttoxl.aspx");
    }
    protected void grdReports_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {

            string val = e.Row.Cells[4].Text;
            if (val == tempval)
            {
                double tamount = Convert.ToDouble(e.Row.Cells[12].Text);
                //double totamount = Convert.ToDouble(e.Row.Cells[13].Text);
                //e.Row.Cells[12].Text = "0";
                //e.Row.Cells[12].Text =  tamount.ToString();
                tempval = val;
            }
            else
            {
                tempval = val;
            }
        }
    }
}