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

public partial class SAP_INVOICE_Report : System.Web.UI.Page
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

    DataTable Report = new DataTable();
    protected void btn_Generate_Click(object sender, EventArgs e)
    {
        try
        {

            Report.Columns.Add("CREATE DATE");
            Report.Columns.Add("CARD CODE");
            Report.Columns.Add("CARD NAME");
            Report.Columns.Add("DISCOUNT %");
            Report.Columns.Add("REFERENCE NO");
            Report.Columns.Add("ITEMCODE");
            Report.Columns.Add("DESCRIPTION");
            Report.Columns.Add("WARE HOUSE CODE");
            Report.Columns.Add("QUANTITY");
            Report.Columns.Add("PRICE");
            Report.Columns.Add("TAX CODE");
            Report.Columns.Add("TAX%");
            Report.Columns.Add("TRANSPORT");
            Report.Columns.Add("LINE TOTAL");
            Report.Columns.Add("Narration");
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
            DateTime ReportDate = SalesDBManager.GetTime(SalesDB.conn);
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
            cmd = new SqlCommand("SELECT  suppliersdetails.name, suppliersdetails.suppliercode, inwarddetails.sno, inwarddetails.inwarddate, inwarddetails.invoiceno, inwarddetails.invoicedate,inwarddetails.dcno, inwarddetails.lrno, inwarddetails.supplierid, inwarddetails.podate, inwarddetails.doorno, inwarddetails.remarks, inwarddetails.pono, inwarddetails.inwardno, inwarddetails.transportname, inwarddetails.vehicleno, inwarddetails.modeofinward, inwarddetails.securityno, inwarddetails.uimid,inwarddetails.status, inwarddetails.mrnno, inwarddetails.indentno, inwarddetails.freigtamt, inwarddetails.transportcharge, inwarddetails.inwardamount,  subinwarddetails.sno AS Expr1, subinwarddetails.productid, subinwarddetails.quantity, subinwarddetails.perunit, subinwarddetails.totalcost, subinwarddetails.in_refno, subinwarddetails.status AS Expr2, subinwarddetails.taxtype, subinwarddetails.ed, subinwarddetails.dis, subinwarddetails.disamt, subinwarddetails.tax, subinwarddetails.edtax, productmaster.itemcode, productmaster.productname, taxmaster.type AS tax_type, taxmaster_1.type AS ed_type, inwarddetails.pfid, pandf.pandf, subinwarddetails.igst, subinwarddetails.cgst, subinwarddetails.sgst FROM inwarddetails INNER JOIN subinwarddetails ON inwarddetails.sno = subinwarddetails.in_refno INNER JOIN productmaster ON subinwarddetails.productid = productmaster.productid INNER JOIN suppliersdetails ON inwarddetails.supplierid = suppliersdetails.supplierid left outer JOIN taxmaster ON subinwarddetails.taxtype = taxmaster.sno left outer JOIN taxmaster AS taxmaster_1 ON subinwarddetails.ed = taxmaster_1.sno LEFT OUTER JOIN pandf ON inwarddetails.pfid = pandf.sno WHERE (inwarddetails.inwarddate BETWEEN @fromdate AND @todate) AND (inwarddetails.branchid = @branchid) AND (inwarddetails.mrnno IS NOT NULL) AND  (inwarddetails.mrnno <> 0)");
            cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
            cmd.Parameters.Add("@todate", GetHighDate(fromdate));
            cmd.Parameters.Add("@branchid", branchid);
            DataTable dttotalinward = vdm.SelectQuery(cmd).Tables[0];
            if (dttotalinward.Rows.Count > 0)
            {
                string taxcode = "", taxtype = "", transport = "";
                double ttotalamount = 0;
                DateTime dt = DateTime.Now;
                string prevdate = string.Empty;
                int i = 0;
                string PONo = "";
                string newpoNo = "";
                foreach (DataRow dr in dttotalinward.Rows)
                {
                    DataRow newrow = Report.NewRow();
                    DateTime dt_inward = Convert.ToDateTime(dr["inwarddate"].ToString());
                    string dt_inward_date = dt_inward.ToString("dd/MM/yyyy");

                    DateTime invoicedate = Convert.ToDateTime(dr["invoicedate"].ToString());
                    string indate = invoicedate.ToString("dd/MM/yyyy");
                  
                    newrow["CREATE DATE"] = dt_inward_date; //dr["inwarddate"].ToString();
                    newrow["CARD CODE"] = dr["suppliercode"].ToString();
                    newrow["CARD NAME"] = dr["name"].ToString();
                    string cardname = dr["name"].ToString();
                    newrow["DISCOUNT %"] = dr["dis"].ToString();
                    string newmrn = "0";
                    int countdc = 0;
                    int.TryParse(dr["mrnno"].ToString(), out countdc);
                    if (countdc < 10)
                    {
                        newmrn = "0000" + countdc;
                    }
                    if (countdc >= 10 && countdc <= 99)
                    {
                        newmrn = "000" + countdc;
                    }
                    if (countdc >= 99 && countdc <= 999)
                    {
                        newmrn = "00" + countdc;
                    }
                    if (countdc >= 999 && countdc <= 9999)
                    {
                        newmrn = "0" + countdc;
                    }
                    if (countdc > 9999)
                    {
                        newmrn = "" + countdc;
                    }
                    string BranchCode = Session["BranchCode"].ToString();
                    string invno = dr["invoiceno"].ToString();
                    newrow["REFERENCE NO"] = BranchCode + dtapril.ToString("yy") + "-" + dtmarch.ToString("yy") + "/" + newmrn;
                    newrow["ITEMCODE"] = dr["itemcode"].ToString();
                    newrow["DESCRIPTION"] = dr["productname"].ToString();
                    string product = dr["productname"].ToString();
                    newrow["WARE HOUSE CODE"] = "SVDSPP02";
                    newrow["QUANTITY"] = dr["quantity"].ToString();
                    double rate = 0;
                    double.TryParse(dr["perunit"].ToString(), out rate);
                    rate = Math.Round(rate, 2);
                    newrow["PRICE"] = rate;
                    taxtype = dr["tax_type"].ToString();
                    string edtype = dr["edtax"].ToString();
                    string IGST = dr["igst"].ToString();
                    string CGST = dr["cgst"].ToString();
                    string SGST = dr["sgst"].ToString();
                    if (IGST != "0")
                    {
                        double igsttax = Convert.ToDouble(IGST);
                        taxcode = "IGST" + IGST + "";
                        newrow["TAX%"] = IGST;
                    }
                    if (CGST != "0")
                    {
                        double cgsttax = Convert.ToDouble(CGST);
                        cgsttax = cgsttax + cgsttax;
                        taxcode = "CGST" + cgsttax + "";
                        newrow["TAX%"] = CGST;
                    }
                    if (IGST == "0" && CGST == "0")
                    {
                        taxcode = "EXEMPT";
                        newrow["TAX%"] = "0";
                    }
                    //if (edtype == "0")
                    //{
                    //    if (taxtype == "CST 2% against Form C1" || taxtype == "Input CST @2%")
                    //    {
                    //        taxcode = "CST@2";
                    //    }
                    //    else if (taxtype == "Input CST @5%")
                    //    {
                    //        taxcode = "CST@5";
                    //    }
                    //    else if (taxtype == "Input VAT @14.5%")
                    //    {
                    //        taxcode = "VAT@14.5";
                    //    }
                    //    else if (taxtype == "Input VAT @5%" || taxtype == "vat 5%")
                    //    {
                    //        taxcode = "VAT@5";
                    //    }
                    //    else if (taxtype == "Input VAT @0%")
                    //    {
                    //        taxcode = "EXEMPT";
                    //    }
                    //    else if (taxtype == "CST @14.5%")
                    //    {
                    //        taxcode = "CST@14.5";
                    //    }
                    //}
                    //else
                    //{
                    //    if (taxtype == "Input VAT @14.5%" && edtype == "12.5")
                    //    {
                    //        taxcode = "E125V145";
                    //    }
                    //    if (taxtype == "Input VAT @5%" && edtype == "12.5")
                    //    {
                    //        taxcode = "E12.5V5";
                    //    }
                    //    if ((taxtype == "CST 2% against Form C1" || taxtype == "Input CST @2%") && (edtype == "12.5"))
                    //    {
                    //        taxcode = "ED12.5C2";
                    //    }
                    //    if (taxtype == "Input VAT @0%" && edtype == "12.5")
                    //    {
                    //        taxcode = "ED@12.5";
                    //    }
                    //}
                    newrow["TAX CODE"] = taxcode;
                    double price = 0;
                    double.TryParse(dr["perunit"].ToString(), out price);
                    double qty = 0;
                    double.TryParse(dr["quantity"].ToString(), out qty);
                    double total = 0; 
                    double total_amt = 0, edamount = 0;
                    total = qty * price;
                    double dis = 0;
                    double.TryParse(dr["disamt"].ToString(), out dis);
                    total_amt = total - dis;


                    double pfamt = 0; double pfamount = 0;
                    if (dr["pandf"].ToString() != "")
                    {
                        double.TryParse(dr["pandf"].ToString(), out pfamt);
                        pfamount = (total_amt * pfamt) / 100;
                        newrow["TRANSPORT"] = pfamount.ToString();
                    }
                    string edcode = "";
                    //string edtype = dr["edtax"].ToString();
                    //if (edtype == "12.5")
                    //{
                    //    edcode = "ED@12.5";
                    //}
                    //else
                    //{
                    //    edcode = "EXEMPT";
                    //}
                    //newrow["ED CODE"] = edcode;
                    double edamt = 0;
                    double.TryParse(dr["edtax"].ToString(), out edamt);
                    edamount = (total_amt * edamt) / 100;
                    double totedamount = 0;
                    totedamount = total_amt + edamount + pfamount;
                    double vat_per = 0; double vat_amt = 0; double amt_tax = 0;
                    //double edamt = 0;
                    //double.TryParse(dr["edtax"].ToString(), out edamt);
                    //edamount = (total_amt * edamt) / 100;
                    //double totedamount = 0;
                    //totedamount = total_amt + edamount;//stock
                    double csttax = 0;
                   
                    string trans_chrgs = dr["transportcharge"].ToString();
                    int trans = 0;
                    int.TryParse(trans_chrgs, out trans);
                    string freight_chrgs = dr["freigtamt"].ToString();
                    int frigh = 0;
                    int.TryParse(freight_chrgs, out frigh);

                    if (trans != 0)
                    {
                        transport = trans_chrgs;
                    }
                    else if (frigh != 0)
                    {
                        transport = freight_chrgs;
                    }
                    else
                    {
                        transport = "0";
                    }

                    string val = newmrn;
                    if (val == tempval)
                    {
                        double tamount = Convert.ToDouble(transport);
                        transport = "0";
                        tempval = val;
                    }
                    else
                    {
                        if (transport == "0")
                        {
                            transport = "0";
                        }
                        else
                        {
                            newrow["TRANSPORT"] = transport;
                        }
                        tempval = val;
                    }
                    amt_tax = totedamount + vat_amt + Convert.ToDouble(transport);
                    newrow["LINE TOTAL"] = amt_tax.ToString("F2");
                    ttotalamount += amt_tax;
                    string narration = "Being the purchase of " + product + ", Qty:" + qty + ", Amount:" + amt_tax + "/-. From Invoice Name :" + cardname + ". Invoice No:" + invno + ", Invoice Date:" + indate + ",MRN No:" + newmrn + ", MRN Date:" + dt_inward_date + ", taxtype:" + taxtype + "";
                    newrow["Narration"] = narration;
                    Report.Rows.Add(newrow);
                    i++;
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
                    cmd = new SqlCommand("SELECT CreateDate, CardCode, CardName, TaxDate, DocDate, GRNRefNo, ItemCode, Dscription FROM EMROPCHS WHERE (TaxDate BETWEEN @d1 AND @d2) AND (ReferenceNo = @ReferenceNo) AND (ItemCode = @ItemCode) AND (WhsCode = @WhsCode)");
                    cmd.Parameters.Add("@d1", GetLowDate(fromdate));
                    cmd.Parameters.Add("@d2", GetHighDate(fromdate));
                    cmd.Parameters.Add("@ReferenceNo", dr["REFERENCE NO"].ToString());
                    cmd.Parameters.Add("@WhsCode", dr["WARE HOUSE CODE"].ToString());
                    cmd.Parameters.Add("@ItemCode", dr["ITEMCODE"].ToString());
                    DataTable dtPCH = SAPvdm.SelectQuery(cmd).Tables[0];
                    if (dtPCH.Rows.Count > 0)
                    {
                    }
                    else
                    {
                        string VAT_Percent = dr["TAX%"].ToString();
                        cmd = new SqlCommand("insert into EMROPCHS (CreateDate, CardCode, CardName, TaxDate, DocDate, DocDueDate, DiscPercent, ReferenceNo, GRNRefNo, ItemCode, Dscription, WhsCode, Quantity, Price, OcrCode, TaxCode, OverHeadAmount1, B1Upload, Processed,Purchasetype,Account,REMARKS,VAT_Percent) values (@CreateDate, @CardCode, @CardName, @TaxDate, @DocDate, @DocDueDate, @DiscPercent, @ReferenceNo, @GRNRefNo, @ItemCode, @Dscription, @WhsCode, @Quantity, @Price, @OcrCode, @TaxCode, @transport, @B1Upload, @Processed,@Purchasetype,@Account,@Narration,@VAT_Percent)");
                        cmd.Parameters.Add("@CreateDate", CreateDate);
                        cmd.Parameters.Add("@CardCode", dr["CARD CODE"].ToString());
                        cmd.Parameters.Add("@CardName", dr["CARD NAME"].ToString());
                        cmd.Parameters.Add("@TaxDate", fromdate);
                        cmd.Parameters.Add("@DocDate", fromdate);
                        cmd.Parameters.Add("@DocDueDate", fromdate);
                        cmd.Parameters.Add("@DiscPercent", dr["DISCOUNT %"].ToString());
                        cmd.Parameters.Add("@ReferenceNo", dr["REFERENCE NO"].ToString());
                        string GRNRefNo = "NA";
                        cmd.Parameters.Add("@GRNRefNo", GRNRefNo);
                        cmd.Parameters.Add("@ItemCode", dr["ITEMCODE"].ToString());
                        cmd.Parameters.Add("@Dscription", dr["DESCRIPTION"].ToString());
                        cmd.Parameters.Add("@WhsCode", dr["WARE HOUSE CODE"].ToString());
                        double qty = 0;
                        double.TryParse(dr["QUANTITY"].ToString(), out qty);
                        cmd.Parameters.Add("@Quantity", qty);
                        double price = 0;
                        double.TryParse(dr["price"].ToString(), out price);
                        cmd.Parameters.Add("@Price", price);
                        cmd.Parameters.Add("@OcrCode", dr["WARE HOUSE CODE"].ToString());
                        cmd.Parameters.Add("@TaxCode", dr["TAX CODE"].ToString());
                        string TRANSPORT= dr["TRANSPORT"].ToString();
                        if (TRANSPORT == "")
                        {
                            cmd.Parameters.Add("@transport",DBNull.Value);
                        }
                        else
                        {
                            cmd.Parameters.Add("@transport", dr["TRANSPORT"].ToString());
                        }
                        string B1Upload = "N";
                        string Processed = "N";
                        cmd.Parameters.Add("@B1Upload", B1Upload);
                        cmd.Parameters.Add("@Processed", Processed);
                        string Purchasetype = "212";
                        cmd.Parameters.Add("@Purchasetype", Purchasetype);
                        string Account = "1222030";
                        cmd.Parameters.Add("@Account", Account);
                        cmd.Parameters.Add("@VAT_Percent", VAT_Percent);
                        cmd.Parameters.Add("@Narration", dr["Narration"].ToString());
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
            Session["filename"] = "SAP INVOICE Report";
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
}