using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class Quotation_Comparison_Statement : System.Web.UI.Page
{
    SqlCommand cmd;
    string BranchID = "";
    string mainhead = "";
    double grandtotal = 0;
    double grndtotalperltr = 0;
    SalesDBManager vdm;
    private string _seperator = "|";
    protected void Page_Load(object sender, EventArgs e)
    {
        vdm = new SalesDBManager();
        if (!Page.IsPostBack)
        {
            if (!Page.IsCallback)
            {
                txt_quote_date.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
            }
        }
    }
    DataTable Report = new DataTable();
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
    protected void btn_Generate_Click(object sender, EventArgs e)
    {
        try
        {
            lblmsg.Text = "";
            SalesDBManager SalesDB = new SalesDBManager();
            DateTime date = DateTime.Now;
            DateTime only_date = DateTime.Now;
            string[] datestrig = txt_quote_date.Text.Split(' ');
            string dateonly = datestrig[0];
            string[] datestring = only_date.ToString().Split(' ');
            string today_date = datestring[0];
            if (datestrig.Length > 1)
            {
                if (datestrig[0].Split('-').Length > 0)
                {
                    string[] dates = datestrig[0].Split('-');
                    string[] times = datestrig[1].Split(':');
                    date = new DateTime(int.Parse(dates[2]), int.Parse(dates[1]), int.Parse(dates[0]), int.Parse(times[0]), int.Parse(times[1]), 0);
                }
            }
            string indent_no = txt_indentno.Text;
            string quote_date = txt_quote_date.Text;
            cmd = new SqlCommand("SELECT s.name,q.quotationno,q.suplierid,q.indentno,q.quotationdate from quotation_request q join suppliersdetails s on s.supplierid=q.suplierid join vendor_quotationdetails vq on vq.quotationno=q.quotationno where q.quotationdate=@quote_date AND q.indentno=@indent_no");
            cmd.Parameters.Add("@indent_no", indent_no);
            cmd.Parameters.Add("@quote_date", GetLowDate(date));
            DataTable dtsuppliers = SalesDB.SelectQuery(cmd).Tables[0];

            if (dtsuppliers.Rows.Count > 0)
            {
                string sup_id = dtsuppliers.Rows[0]["suplierid"].ToString();
                cmd = new SqlCommand("SELECT productmaster.productname, productmaster.itemcode, productmaster.sku, uimmaster.uim, indent_subtable.qty FROM productmaster INNER JOIN indent_subtable ON productmaster.productid = indent_subtable.productid INNER JOIN uimmaster ON productmaster.uim = uimmaster.sno WHERE (indent_subtable.indentno = @indent_no)");
                cmd.Parameters.Add("@indent_no", indent_no);
                DataTable dtproducts = SalesDB.SelectQuery(cmd).Tables[0];
                //cmd = new SqlCommand("SELECT vendor_qtion_subdetails.qty, vendor_qtion_subdetails.price, vendor_quotationdetails.supplierid, vendor_quotationdetails.quotationno, vendor_quotationdetails.quotationdate, vendor_quotationdetails.pricebasis, vendor_quotationdetails.despatchmode, vendor_quotationdetails.frieght, vendor_quotationdetails.transport, vendor_quotationdetails.insurance, vendor_quotationdetails.others, suppliersdetails.name, paymentmaster.paymenttype, deliveryterms.deliveryterms, pandf.pandf, addressdetails.address, addressdetails_1.address AS address1, productmaster.productname, productmaster.itemcode, productmaster.sku, uimmaster.uim, taxmaster.taxtype, taxmaster_1.taxtype AS ed FROM quotation_request INNER JOIN vendor_quotationdetails ON quotation_request.quotationno = vendor_quotationdetails.quotationno INNER JOIN vendor_qtion_subdetails ON vendor_quotationdetails.sno = vendor_qtion_subdetails.vendorqtionrefno INNER JOIN suppliersdetails ON vendor_quotationdetails.supplierid = suppliersdetails.supplierid INNER JOIN paymentmaster ON vendor_quotationdetails.paymentmode = paymentmaster.sno INNER JOIN deliveryterms ON vendor_quotationdetails.deliveryterms = deliveryterms.sno INNER JOIN pandf ON vendor_quotationdetails.pandf = pandf.sno INNER JOIN addressdetails ON vendor_quotationdetails.billingto = addressdetails.sno INNER JOIN addressdetails AS addressdetails_1 ON vendor_quotationdetails.shipto = addressdetails_1.sno INNER JOIN productmaster ON vendor_qtion_subdetails.productid = productmaster.productid INNER JOIN uimmaster ON vendor_qtion_subdetails.uom = uimmaster.sno INNER JOIN taxmaster ON vendor_qtion_subdetails.taxtype = taxmaster.sno INNER JOIN taxmaster AS taxmaster_1 ON vendor_qtion_subdetails.exchangeduty = taxmaster_1.sno WHERE (vendor_quotationdetails.quotationdate = @quote_date) AND (quotation_request.indentno = @indent_no)");
                cmd = new SqlCommand("SELECT vendor_qtion_subdetails.qty, vendor_qtion_subdetails.price, vendor_quotationdetails.supplierid, vendor_quotationdetails.quotationno, vendor_quotationdetails.quotationdate, vendor_quotationdetails.pricebasis, vendor_quotationdetails.despatchmode, vendor_quotationdetails.frieght, vendor_quotationdetails.transport, vendor_quotationdetails.insurance, vendor_quotationdetails.others, suppliersdetails.name, paymentmaster.paymenttype, deliveryterms.deliveryterms, pandf.pandf, addressdetails.address, addressdetails_1.address AS address1, productmaster.productname, productmaster.itemcode, productmaster.sku, uimmaster.uim, taxmaster.taxtype, taxmaster_1.taxtype AS ed FROM quotation_request INNER JOIN vendor_quotationdetails ON quotation_request.quotationno = vendor_quotationdetails.quotationno INNER JOIN vendor_qtion_subdetails ON vendor_quotationdetails.sno = vendor_qtion_subdetails.vendorqtionrefno INNER JOIN suppliersdetails ON vendor_quotationdetails.supplierid = suppliersdetails.supplierid INNER JOIN paymentmaster ON vendor_quotationdetails.paymentmode = paymentmaster.sno INNER JOIN deliveryterms ON vendor_quotationdetails.deliveryterms = deliveryterms.sno LEFT OUTER JOIN pandf ON vendor_quotationdetails.pandf = pandf.sno INNER JOIN addressdetails ON vendor_quotationdetails.billingto = addressdetails.sno INNER JOIN addressdetails AS addressdetails_1 ON vendor_quotationdetails.shipto = addressdetails_1.sno INNER JOIN productmaster ON vendor_qtion_subdetails.productid = productmaster.productid INNER JOIN uimmaster ON vendor_qtion_subdetails.uom = uimmaster.sno LEFT OUTER JOIN taxmaster ON vendor_qtion_subdetails.taxtype = taxmaster.sno LEFT OUTER JOIN taxmaster AS taxmaster_1 ON vendor_qtion_subdetails.exchangeduty = taxmaster_1.sno WHERE (vendor_quotationdetails.quotationdate = @quote_date) AND (quotation_request.indentno = @indent_no)");
                cmd.Parameters.Add("@indent_no", indent_no);
                cmd.Parameters.Add("@quote_date", GetLowDate(date));
                DataTable timeSheetData = SalesDB.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT vendor_quotationdetails.supplierid, suppliersdetails.name FROM vendor_quotationdetails INNER JOIN quotation_request ON vendor_quotationdetails.quotationno = quotation_request.quotationno INNER JOIN suppliersdetails ON vendor_quotationdetails.supplierid = suppliersdetails.supplierid WHERE (vendor_quotationdetails.quotationdate = @quote_date) AND (quotation_request.indentno = @indent_no)");
                cmd.Parameters.Add("@indent_no", indent_no);
                cmd.Parameters.Add("@quote_date", GetLowDate(date));
                DataTable dt_suppliers = SalesDB.SelectQuery(cmd).Tables[0];

                if (timeSheetData.Rows.Count > 0)
                {
                    // Creating a customized time sheet table for binding with data grid view
                    var timeSheet = new DataTable("");

                    timeSheet.Columns.Add("S.NO." + _seperator + "");
                    timeSheet.Columns.Add("Item Code" + _seperator + "");
                    timeSheet.Columns.Add("Item Description" + _seperator + "");
                    timeSheet.Columns.Add("UOM" + _seperator + "");
                    timeSheet.Columns.Add("QTY" + _seperator + "");

                    foreach (DataRow item in dtsuppliers.Rows)
                    {
                        string columnName = item["name"].ToString().Trim();
                        timeSheet.Columns.Add(columnName + _seperator + "Rate");
                        timeSheet.Columns.Add(columnName + _seperator + "Amount");
                    }

                    string suppliername = "", supplierid = "", gross_amt = "", sup_name = "";
                    double total = 0, price = 0, quantity = 0;
                    int a = 0;
                    string price1, qty1;
                    foreach (DataRow row in dtproducts.Rows)
                    {
                        string itemcode = row["itemcode"].ToString();
                        string sku = row["sku"].ToString();
                        string item_desc = row["productname"].ToString();
                        string uim = row["uim"].ToString();
                        string qty = row["qty"].ToString();
                        var dataRow = timeSheet.NewRow();

                        foreach (DataRow dra in timeSheetData.Select("sku='" + sku + "' AND productname='" + item_desc + "'"))
                        {
                            suppliername = dra["name"].ToString();
                            dataRow["S.NO." + _seperator + ""] = (a + 1).ToString();
                            dataRow["Item Code" + _seperator + ""] = dra["itemcode"].ToString();
                            dataRow["Item Description" + _seperator + ""] = dra["productname"].ToString();
                            dataRow["UOM" + _seperator + ""] = dra["uim"].ToString();
                            dataRow["QTY" + _seperator + ""] = dra["qty"].ToString();
                            price1 = dra["price"].ToString();
                            price = Convert.ToDouble(price1);
                            qty1 = dra["qty"].ToString();
                            quantity = Convert.ToDouble(qty1);
                            double amount = 0;
                            amount = (price * quantity);
                            dataRow[suppliername + "|Rate"] = price;
                            dataRow[suppliername + "|Amount"] = amount;
                            total += amount;
                        }
                        timeSheet.Rows.Add(dataRow);
                        a++;
                    }
                    var dataRow1 = timeSheet.NewRow();
                    dataRow1["S.NO." + _seperator + ""] = " ";
                    dataRow1["Item Code" + _seperator + ""] = "";
                    dataRow1["Item Description" + _seperator + ""] = "Gross Total";
                    dataRow1["UOM" + _seperator + ""] = "";
                    dataRow1["QTY" + _seperator + ""] = "";

                    foreach (DataRow sup in dt_suppliers.Rows)
                    {
                        supplierid = sup["supplierid"].ToString();
                        sup_name = sup["name"].ToString();

                        cmd = new SqlCommand("SELECT quotationno FROM vendor_quotationdetails WHERE (vendor_quotationdetails.supplierid = @sup_id) AND (vendor_quotationdetails.quotationdate = @quote_date)");
                        cmd.Parameters.Add("@sup_id", supplierid);
                        cmd.Parameters.Add("@quote_date", GetLowDate(date));
                        DataTable dt_quotation_num = vdm.SelectQuery(cmd).Tables[0];
                        string quotation_no = dt_quotation_num.Rows[0]["quotationno"].ToString();

                        cmd = new SqlCommand("SELECT SUM(vendor_qtion_subdetails.price * vendor_qtion_subdetails.qty) AS amount FROM vendor_quotationdetails INNER JOIN vendor_qtion_subdetails ON vendor_quotationdetails.sno = vendor_qtion_subdetails.vendorqtionrefno INNER JOIN quotation_request ON vendor_quotationdetails.quotationno = quotation_request.quotationno WHERE (vendor_quotationdetails.supplierid = @sup_id) AND (vendor_quotationdetails.quotationdate = @quote_date) AND (vendor_quotationdetails.quotationno = @quotation_no) AND (quotation_request.indentno = @indentno)");
                        cmd.Parameters.Add("@sup_id", supplierid);
                        cmd.Parameters.Add("@quotation_no", quotation_no);
                        cmd.Parameters.Add("@quote_date", GetLowDate(date));
                        cmd.Parameters.Add("@indentno", txt_indentno.Text);
                        DataTable dt_total_amt = SalesDB.SelectQuery(cmd).Tables[0];
                        gross_amt = dt_total_amt.Rows[0]["amount"].ToString();
                        dataRow1[sup_name + "|Rate"] = "";
                        dataRow1[sup_name + "|Amount"] = Convert.ToDouble(gross_amt).ToString("f2"); //total.ToString();
                    }
                    timeSheet.Rows.Add(dataRow1);

                    var dataRow2 = timeSheet.NewRow();
                    dataRow2["S.NO." + _seperator + ""] = " ";
                    dataRow2["Item Code" + _seperator + ""] = "";
                    dataRow2["Item Description" + _seperator + ""] = "Discount Amount";
                    dataRow2["UOM" + _seperator + ""] = "";
                    dataRow2["QTY" + _seperator + ""] = "";
                    string discountamount = "";
                    foreach (DataRow sup1 in dt_suppliers.Rows)
                    {
                        supplierid = sup1["supplierid"].ToString();
                        sup_name = sup1["name"].ToString();

                        cmd = new SqlCommand("SELECT quotationno FROM vendor_quotationdetails WHERE (vendor_quotationdetails.supplierid = @sup_id) AND (vendor_quotationdetails.quotationdate = @quote_date)");
                        cmd.Parameters.Add("@sup_id", supplierid);
                        cmd.Parameters.Add("@quote_date", GetLowDate(date));
                        DataTable dt_quotation_num = vdm.SelectQuery(cmd).Tables[0];
                        string quotation_no = dt_quotation_num.Rows[0]["quotationno"].ToString();

                        cmd = new SqlCommand("SELECT SUM(vendor_qtion_subdetails.discountamount) AS discountamount FROM vendor_quotationdetails INNER JOIN vendor_qtion_subdetails ON vendor_quotationdetails.sno = vendor_qtion_subdetails.vendorqtionrefno INNER JOIN quotation_request ON vendor_quotationdetails.quotationno = quotation_request.quotationno WHERE (vendor_quotationdetails.supplierid = @sup_id) AND (vendor_quotationdetails.quotationdate = @quote_date) AND (vendor_quotationdetails.quotationno = @quotation_no) AND (quotation_request.indentno = @indentno)");
                        cmd.Parameters.Add("@sup_id", supplierid);
                        cmd.Parameters.Add("@quotation_no", quotation_no);
                        cmd.Parameters.Add("@quote_date", GetLowDate(date));
                        cmd.Parameters.Add("@indentno", txt_indentno.Text);
                        DataTable dt_total_amt = SalesDB.SelectQuery(cmd).Tables[0];
                        discountamount = dt_total_amt.Rows[0]["discountamount"].ToString();
                        dataRow2[sup_name + "|Rate"] = "";
                        dataRow2[sup_name + "|Amount"] = Convert.ToDouble(discountamount).ToString("f2");
                    }
                    timeSheet.Rows.Add(dataRow2);

                    var dataRow3 = timeSheet.NewRow();
                    dataRow3["S.NO." + _seperator + ""] = " ";
                    dataRow3["Item Code" + _seperator + ""] = "";
                    dataRow3["Item Description" + _seperator + ""] = "P AND F";
                    dataRow3["UOM" + _seperator + ""] = "";
                    dataRow3["QTY" + _seperator + ""] = "";
                    string pandfamount = "", pandf = "";
                    string taxamount = "", tax = "";
                    foreach (DataRow sup2 in dt_suppliers.Rows)
                    {
                        supplierid = sup2["supplierid"].ToString();
                        sup_name = sup2["name"].ToString();

                        cmd = new SqlCommand("SELECT quotationno FROM vendor_quotationdetails WHERE (vendor_quotationdetails.supplierid = @sup_id) AND (vendor_quotationdetails.quotationdate = @quote_date)");
                        cmd.Parameters.Add("@sup_id", supplierid);
                        cmd.Parameters.Add("@quote_date", GetLowDate(date));
                        DataTable dt_quotation_num = vdm.SelectQuery(cmd).Tables[0];
                        string quotation_no = dt_quotation_num.Rows[0]["quotationno"].ToString();

                        cmd = new SqlCommand("SELECT SUM(pandf.pandf * (vendor_qtion_subdetails.qty * vendor_qtion_subdetails.price - vendor_qtion_subdetails.discountamount) / 100) AS pandfamount FROM vendor_quotationdetails INNER JOIN vendor_qtion_subdetails ON vendor_quotationdetails.sno = vendor_qtion_subdetails.vendorqtionrefno LEFT OUTER JOIN pandf ON vendor_quotationdetails.pandf = pandf.sno INNER JOIN quotation_request ON vendor_quotationdetails.quotationno = quotation_request.quotationno WHERE (vendor_quotationdetails.supplierid = @sup_id) AND (vendor_quotationdetails.quotationdate = @quote_date) AND (vendor_quotationdetails.quotationno = @quotation_no) AND (quotation_request.indentno = @indentno)");
                        cmd.Parameters.Add("@sup_id", supplierid);
                        cmd.Parameters.Add("@quote_date", GetLowDate(date));
                        cmd.Parameters.Add("@quotation_no", quotation_no);
                        cmd.Parameters.Add("@indentno", txt_indentno.Text);
                        DataTable dt_pandf_amt = SalesDB.SelectQuery(cmd).Tables[0];
                        pandfamount = dt_pandf_amt.Rows[0]["pandfamount"].ToString();
                        string p_and_f = "";
                        if (pandfamount != "")
                        {
                            p_and_f = Convert.ToDouble(pandfamount).ToString("f2");
                        }
                        dataRow3[sup_name + "|Rate"] = "";
                        dataRow3[sup_name + "|Amount"] = p_and_f;
                    }
                    timeSheet.Rows.Add(dataRow3);
                    var dataRow4 = timeSheet.NewRow();
                    dataRow4["S.NO." + _seperator + ""] = " ";
                    dataRow4["Item Code" + _seperator + ""] = "";
                    dataRow4["Item Description" + _seperator + ""] = "Exchange Duty";
                    dataRow4["UOM" + _seperator + ""] = "";
                    dataRow4["QTY" + _seperator + ""] = "";
                    string edamount = "", ed = "";
                    double ed_per = 0, ed_amt = 0;
                    foreach (DataRow sup3 in dt_suppliers.Rows)
                    {
                        supplierid = sup3["supplierid"].ToString();
                        sup_name = sup3["name"].ToString();

                        cmd = new SqlCommand("SELECT quotationno FROM vendor_quotationdetails WHERE (vendor_quotationdetails.supplierid = @sup_id) AND (vendor_quotationdetails.quotationdate = @quote_date)");
                        cmd.Parameters.Add("@sup_id", supplierid);
                        cmd.Parameters.Add("@quote_date", GetLowDate(date));
                        DataTable dt_quotation_num = vdm.SelectQuery(cmd).Tables[0];
                        string quotation_no = dt_quotation_num.Rows[0]["quotationno"].ToString();

                        cmd = new SqlCommand("SELECT SUM(vendor_qtion_subdetails.edtaxpercentage * (vendor_qtion_subdetails.qty * vendor_qtion_subdetails.price - vendor_qtion_subdetails.discountamount) / 100) AS edtaxamount FROM vendor_quotationdetails INNER JOIN vendor_qtion_subdetails ON vendor_quotationdetails.sno = vendor_qtion_subdetails.vendorqtionrefno INNER JOIN quotation_request ON vendor_quotationdetails.quotationno = quotation_request.quotationno WHERE (vendor_quotationdetails.supplierid = @sup_id) AND (vendor_quotationdetails.quotationdate = @quote_date) AND (vendor_quotationdetails.quotationno = @quotation_no) AND (quotation_request.indentno = @indentno)");
                        cmd.Parameters.Add("@sup_id", supplierid);
                        cmd.Parameters.Add("@quote_date", GetLowDate(date));
                        cmd.Parameters.Add("@quotation_no", quotation_no);
                        cmd.Parameters.Add("@indentno", txt_indentno.Text);
                        DataTable dt_pandf_amt = SalesDB.SelectQuery(cmd).Tables[0];
                        edamount = dt_pandf_amt.Rows[0]["edtaxamount"].ToString();
                        string ed_amount = "";
                        if (edamount != "")
                        {
                            ed_amount = Convert.ToDouble(edamount).ToString("f2");
                        }
                        dataRow4[sup_name + "|Rate"] = "";
                        dataRow4[sup_name + "|Amount"] = ed_amount;
                    }
                    timeSheet.Rows.Add(dataRow4);

                    var dataRow5 = timeSheet.NewRow();
                    dataRow5["S.NO." + _seperator + ""] = " ";
                    dataRow5["Item Code" + _seperator + ""] = "";
                    dataRow5["Item Description" + _seperator + ""] = "TAX";
                    dataRow5["UOM" + _seperator + ""] = "";
                    dataRow5["QTY" + _seperator + ""] = "";

                    foreach (DataRow sup3 in dt_suppliers.Rows)
                    {
                        supplierid = sup3["supplierid"].ToString();
                        sup_name = sup3["name"].ToString();

                        cmd = new SqlCommand("SELECT quotationno FROM vendor_quotationdetails WHERE (vendor_quotationdetails.supplierid = @sup_id) AND (vendor_quotationdetails.quotationdate = @quote_date)");
                        cmd.Parameters.Add("@sup_id", supplierid);
                        cmd.Parameters.Add("@quote_date", GetLowDate(date));
                        DataTable dt_quotation_num = vdm.SelectQuery(cmd).Tables[0];
                        string quotation_no = dt_quotation_num.Rows[0]["quotationno"].ToString();

                        cmd = new SqlCommand("SELECT SUM(vendor_qtion_subdetails.taxpercentage * (((vendor_qtion_subdetails.qty * vendor_qtion_subdetails.price - vendor_qtion_subdetails.discountamount) + (vendor_qtion_subdetails.qty * vendor_qtion_subdetails.price - vendor_qtion_subdetails.discountamount) * pandf.pandf / 100) + (vendor_qtion_subdetails.qty * vendor_qtion_subdetails.price - vendor_qtion_subdetails.discountamount) * vendor_qtion_subdetails.edtaxpercentage / 100) / 100) AS taxamount FROM vendor_quotationdetails INNER JOIN vendor_qtion_subdetails ON vendor_quotationdetails.sno = vendor_qtion_subdetails.vendorqtionrefno LEFT OUTER JOIN pandf ON vendor_quotationdetails.pandf = pandf.sno INNER JOIN quotation_request ON vendor_quotationdetails.quotationno = quotation_request.quotationno WHERE (vendor_quotationdetails.supplierid = @sup_id) AND (vendor_quotationdetails.quotationdate = @quote_date) AND (vendor_quotationdetails.quotationno = @quotation_no) AND (quotation_request.indentno = @indentno) GROUP BY pandf.pandf");
                        cmd.Parameters.Add("@sup_id", supplierid);
                        cmd.Parameters.Add("@quote_date", GetLowDate(date));
                        cmd.Parameters.Add("@quotation_no", quotation_no);
                        cmd.Parameters.Add("@indentno", txt_indentno.Text);
                        DataTable dt_pandf_amt = SalesDB.SelectQuery(cmd).Tables[0];
                        taxamount = dt_pandf_amt.Rows[0]["taxamount"].ToString();
                        string tax_amount = "";
                        if (taxamount != "")
                        {
                            tax_amount = Convert.ToDouble(taxamount).ToString("f2");
                        }
                        dataRow5[sup_name + "|Rate"] = "";
                        dataRow5[sup_name + "|Amount"] = tax_amount;
                    }
                    timeSheet.Rows.Add(dataRow5);

                    var dataRow6 = timeSheet.NewRow();
                    dataRow6["S.NO." + _seperator + ""] = " ";
                    dataRow6["Item Code" + _seperator + ""] = "";
                    dataRow6["Item Description" + _seperator + ""] = "Frieght Charges";
                    dataRow6["UOM" + _seperator + ""] = "";
                    dataRow6["QTY" + _seperator + ""] = "";
                    string frieghtamount = "";
                    foreach (DataRow sup3 in dt_suppliers.Rows)
                    {
                        supplierid = sup3["supplierid"].ToString();
                        sup_name = sup3["name"].ToString();

                        cmd = new SqlCommand("SELECT quotationno FROM vendor_quotationdetails WHERE (vendor_quotationdetails.supplierid = @sup_id) AND (vendor_quotationdetails.quotationdate = @quote_date)");
                        cmd.Parameters.Add("@sup_id", supplierid);
                        cmd.Parameters.Add("@quote_date", GetLowDate(date));
                        DataTable dt_quotation_num = vdm.SelectQuery(cmd).Tables[0];
                        string quotation_no = dt_quotation_num.Rows[0]["quotationno"].ToString();

                        //cmd = new SqlCommand("SELECT vendor_quotationdetails.frieght FROM vendor_quotationdetails LEFT OUTER JOIN pandf ON vendor_quotationdetails.pandf = pandf.sno INNER JOIN quotation_request ON vendor_quotationdetails.quotationno = quotation_request.quotationno WHERE (vendor_quotationdetails.supplierid = @sup_id) AND (vendor_quotationdetails.quotationdate = @quote_date) AND (vendor_quotationdetails.quotationno = @quotation_no) AND (quotation_request.indentno = @indentno)");
                        cmd = new SqlCommand("SELECT vendor_quotationdetails.frieght FROM vendor_quotationdetails INNER JOIN quotation_request ON vendor_quotationdetails.quotationno = quotation_request.quotationno WHERE (vendor_quotationdetails.supplierid = @sup_id) AND (vendor_quotationdetails.quotationdate = @quote_date) AND (vendor_quotationdetails.quotationno = @quotation_no) AND (quotation_request.indentno = @indentno)");
                        cmd.Parameters.Add("@sup_id", supplierid);
                        cmd.Parameters.Add("@quote_date", GetLowDate(date));
                        cmd.Parameters.Add("@quotation_no", quotation_no);
                        cmd.Parameters.Add("@indentno", txt_indentno.Text);
                        DataTable dt_pandf_amt = SalesDB.SelectQuery(cmd).Tables[0];
                        frieghtamount = dt_pandf_amt.Rows[0]["frieght"].ToString();
                        dataRow6[sup_name + "|Rate"] = "";
                        dataRow6[sup_name + "|Amount"] = frieghtamount;
                    }
                    timeSheet.Rows.Add(dataRow6);

                    var dataRow7 = timeSheet.NewRow();
                    dataRow7["S.NO." + _seperator + ""] = " ";
                    dataRow7["Item Code" + _seperator + ""] = "";
                    dataRow7["Item Description" + _seperator + ""] = "Transport Charges";
                    dataRow7["UOM" + _seperator + ""] = "";
                    dataRow7["QTY" + _seperator + ""] = "";
                    string transportamount = "";
                    foreach (DataRow sup3 in dt_suppliers.Rows)
                    {
                        supplierid = sup3["supplierid"].ToString();
                        sup_name = sup3["name"].ToString();

                        cmd = new SqlCommand("SELECT quotationno FROM vendor_quotationdetails WHERE (vendor_quotationdetails.supplierid = @sup_id) AND (vendor_quotationdetails.quotationdate = @quote_date)");
                        cmd.Parameters.Add("@sup_id", supplierid);
                        cmd.Parameters.Add("@quote_date", GetLowDate(date));
                        DataTable dt_quotation_num = vdm.SelectQuery(cmd).Tables[0];
                        string quotation_no = dt_quotation_num.Rows[0]["quotationno"].ToString();

                        //cmd = new SqlCommand("SELECT vendor_quotationdetails.transport FROM vendor_quotationdetails LEFT OUTER JOIN pandf ON vendor_quotationdetails.pandf = pandf.sno INNER JOIN quotation_request ON vendor_quotationdetails.quotationno = quotation_request.quotationno WHERE (vendor_quotationdetails.supplierid = @sup_id) AND (vendor_quotationdetails.quotationdate = @quote_date) AND (vendor_quotationdetails.quotationno = @quotation_no) AND (quotation_request.indentno = @indentno)");
                        cmd = new SqlCommand("SELECT vendor_quotationdetails.transport FROM vendor_quotationdetails INNER JOIN quotation_request ON vendor_quotationdetails.quotationno = quotation_request.quotationno WHERE (vendor_quotationdetails.supplierid = @sup_id) AND (vendor_quotationdetails.quotationdate = @quote_date) AND (vendor_quotationdetails.quotationno = @quotation_no) AND (quotation_request.indentno = @indentno)");
                        cmd.Parameters.Add("@sup_id", supplierid);
                        cmd.Parameters.Add("@quote_date", GetLowDate(date));
                        cmd.Parameters.Add("@quotation_no", quotation_no);
                        cmd.Parameters.Add("@indentno", txt_indentno.Text);
                        DataTable dt_pandf_amt = SalesDB.SelectQuery(cmd).Tables[0];
                        transportamount = dt_pandf_amt.Rows[0]["transport"].ToString();
                        dataRow7[sup_name + "|Rate"] = "";
                        dataRow7[sup_name + "|Amount"] = transportamount;
                    }
                    timeSheet.Rows.Add(dataRow7);

                    var dataRow8 = timeSheet.NewRow();
                    dataRow8["S.NO." + _seperator + ""] = " ";
                    dataRow8["Item Code" + _seperator + ""] = "";
                    dataRow8["Item Description" + _seperator + ""] = "Insurance Charges";
                    dataRow8["UOM" + _seperator + ""] = "";
                    dataRow8["QTY" + _seperator + ""] = "";
                    string insurancecharges = "";
                    foreach (DataRow sup3 in dt_suppliers.Rows)
                    {
                        supplierid = sup3["supplierid"].ToString();
                        sup_name = sup3["name"].ToString();

                        cmd = new SqlCommand("SELECT quotationno FROM vendor_quotationdetails WHERE (vendor_quotationdetails.supplierid = @sup_id) AND (vendor_quotationdetails.quotationdate = @quote_date)");
                        cmd.Parameters.Add("@sup_id", supplierid);
                        cmd.Parameters.Add("@quote_date", GetLowDate(date));
                        DataTable dt_quotation_num = vdm.SelectQuery(cmd).Tables[0];
                        string quotation_no = dt_quotation_num.Rows[0]["quotationno"].ToString();

                        cmd = new SqlCommand("SELECT vendor_quotationdetails.insurance FROM vendor_quotationdetails INNER JOIN quotation_request ON vendor_quotationdetails.quotationno = quotation_request.quotationno WHERE (vendor_quotationdetails.supplierid = @sup_id) AND (vendor_quotationdetails.quotationdate = @quote_date) AND (vendor_quotationdetails.quotationno = @quotation_no) AND (quotation_request.indentno = @indentno)");
                        cmd.Parameters.Add("@sup_id", supplierid);
                        cmd.Parameters.Add("@quotation_no", quotation_no);
                        cmd.Parameters.Add("@quote_date", GetLowDate(date));
                        cmd.Parameters.Add("@indentno", txt_indentno.Text);
                        DataTable dt_pandf_amt = SalesDB.SelectQuery(cmd).Tables[0];
                        insurancecharges = dt_pandf_amt.Rows[0]["insurance"].ToString();
                        dataRow8[sup_name + "|Rate"] = "";
                        dataRow8[sup_name + "|Amount"] = insurancecharges;
                    }
                    timeSheet.Rows.Add(dataRow8);

                    var dataRow9 = timeSheet.NewRow();
                    dataRow9["S.NO." + _seperator + ""] = " ";
                    dataRow9["Item Code" + _seperator + ""] = "";
                    dataRow9["Item Description" + _seperator + ""] = "Other Charges";
                    dataRow9["UOM" + _seperator + ""] = "";
                    dataRow9["QTY" + _seperator + ""] = "";
                    string othercharges = "";
                    foreach (DataRow sup3 in dt_suppliers.Rows)
                    {
                        supplierid = sup3["supplierid"].ToString();
                        sup_name = sup3["name"].ToString();

                        cmd = new SqlCommand("SELECT quotationno FROM vendor_quotationdetails WHERE (vendor_quotationdetails.supplierid = @sup_id) AND (vendor_quotationdetails.quotationdate = @quote_date)");
                        cmd.Parameters.Add("@sup_id", supplierid);
                        cmd.Parameters.Add("@quote_date", GetLowDate(date));
                        DataTable dt_quotation_num = vdm.SelectQuery(cmd).Tables[0];
                        string quotation_no = dt_quotation_num.Rows[0]["quotationno"].ToString();

                        cmd = new SqlCommand("SELECT vendor_quotationdetails.others FROM vendor_quotationdetails INNER JOIN quotation_request ON vendor_quotationdetails.quotationno = quotation_request.quotationno WHERE (vendor_quotationdetails.supplierid = @sup_id) AND (vendor_quotationdetails.quotationdate = @quote_date) AND (vendor_quotationdetails.quotationno = @quotation_no) AND (quotation_request.indentno = @indentno)");
                        cmd.Parameters.Add("@sup_id", supplierid);
                        cmd.Parameters.Add("@quote_date", GetLowDate(date));
                        cmd.Parameters.Add("@quotation_no", quotation_no);
                        cmd.Parameters.Add("@indentno", txt_indentno.Text);
                        DataTable dt_pandf_amt = SalesDB.SelectQuery(cmd).Tables[0];
                        othercharges = dt_pandf_amt.Rows[0]["others"].ToString();
                        dataRow9[sup_name + "|Rate"] = "";
                        dataRow9[sup_name + "|Amount"] = othercharges;
                    }
                    timeSheet.Rows.Add(dataRow9);

                    var dataRow10 = timeSheet.NewRow();
                    dataRow10["S.NO." + _seperator + ""] = " ";
                    dataRow10["Item Code" + _seperator + ""] = "";
                    dataRow10["Item Description" + _seperator + ""] = "Total Amount";
                    dataRow10["UOM" + _seperator + ""] = "";
                    dataRow10["QTY" + _seperator + ""] = "";
                    string totalamount = "";
                    foreach (DataRow sup3 in dt_suppliers.Rows)
                    {
                        supplierid = sup3["supplierid"].ToString();
                        sup_name = sup3["name"].ToString();

                        cmd = new SqlCommand("SELECT quotationno FROM vendor_quotationdetails WHERE (vendor_quotationdetails.supplierid = @sup_id) AND (vendor_quotationdetails.quotationdate = @quote_date)");
                        cmd.Parameters.Add("@sup_id", supplierid);
                        cmd.Parameters.Add("@quote_date", GetLowDate(date));
                        DataTable dt_quotation_num = vdm.SelectQuery(cmd).Tables[0];
                        string quotation_no = dt_quotation_num.Rows[0]["quotationno"].ToString();

                        cmd = new SqlCommand("SELECT vendor_quotationdetails.frieght + vendor_quotationdetails.transport + vendor_quotationdetails.insurance + vendor_quotationdetails.others + SUM(pandf.pandf * (vendor_qtion_subdetails.qty * vendor_qtion_subdetails.price - vendor_qtion_subdetails.discountamount) / 100) + SUM(vendor_qtion_subdetails.edtaxpercentage * (vendor_qtion_subdetails.qty * vendor_qtion_subdetails.price - vendor_qtion_subdetails.discountamount) / 100) + SUM(vendor_qtion_subdetails.qty * vendor_qtion_subdetails.price - vendor_qtion_subdetails.discountamount) + SUM(vendor_qtion_subdetails.taxpercentage * (((vendor_qtion_subdetails.qty * vendor_qtion_subdetails.price - vendor_qtion_subdetails.discountamount) + (vendor_qtion_subdetails.qty * vendor_qtion_subdetails.price - vendor_qtion_subdetails.discountamount) * pandf.pandf / 100) + (vendor_qtion_subdetails.qty * vendor_qtion_subdetails.price - vendor_qtion_subdetails.discountamount) * vendor_qtion_subdetails.edtaxpercentage / 100) / 100) AS total_amount FROM vendor_quotationdetails INNER JOIN vendor_qtion_subdetails ON vendor_quotationdetails.sno = vendor_qtion_subdetails.vendorqtionrefno LEFT OUTER JOIN pandf ON vendor_quotationdetails.pandf = pandf.sno INNER JOIN quotation_request ON vendor_quotationdetails.quotationno = quotation_request.quotationno WHERE (vendor_quotationdetails.supplierid = @sup_id) AND (vendor_quotationdetails.quotationdate = @quote_date) AND (vendor_quotationdetails.quotationno = @quotation_no) AND (quotation_request.indentno = @indentno) GROUP BY pandf.pandf, vendor_quotationdetails.frieght, vendor_quotationdetails.transport, vendor_quotationdetails.insurance, vendor_quotationdetails.others");
                        cmd.Parameters.Add("@sup_id", supplierid);
                        cmd.Parameters.Add("@quote_date", GetLowDate(date));
                        cmd.Parameters.Add("@quotation_no", quotation_no);
                        cmd.Parameters.Add("@indentno", txt_indentno.Text);
                        DataTable dt_pandf_amt = SalesDB.SelectQuery(cmd).Tables[0];
                        totalamount = dt_pandf_amt.Rows[0]["total_amount"].ToString();
                        dataRow10[sup_name + "|Rate"] = "";
                        dataRow10[sup_name + "|Amount"] = Convert.ToDouble(totalamount).ToString("f2");
                    }
                    timeSheet.Rows.Add(dataRow10);

                    var dataRow11 = timeSheet.NewRow();
                    dataRow11["S.NO." + _seperator + ""] = " ";
                    dataRow11["Item Code" + _seperator + ""] = "";
                    dataRow11["Item Description" + _seperator + ""] = "Price Basis";
                    dataRow11["UOM" + _seperator + ""] = "";
                    dataRow11["QTY" + _seperator + ""] = "";
                    string price_basis = "";
                    foreach (DataRow sup3 in dt_suppliers.Rows)
                    {
                        supplierid = sup3["supplierid"].ToString();
                        sup_name = sup3["name"].ToString();

                        cmd = new SqlCommand("SELECT quotationno FROM vendor_quotationdetails WHERE (vendor_quotationdetails.supplierid = @sup_id) AND (vendor_quotationdetails.quotationdate = @quote_date)");
                        cmd.Parameters.Add("@sup_id", supplierid);
                        cmd.Parameters.Add("@quote_date", GetLowDate(date));
                        DataTable dt_quotation_num = vdm.SelectQuery(cmd).Tables[0];
                        string quotation_no = dt_quotation_num.Rows[0]["quotationno"].ToString();

                        cmd = new SqlCommand("SELECT vendor_quotationdetails.pricebasis FROM vendor_quotationdetails INNER JOIN quotation_request ON vendor_quotationdetails.quotationno = quotation_request.quotationno WHERE (vendor_quotationdetails.supplierid = @sup_id) AND (vendor_quotationdetails.quotationdate = @quote_date) AND (vendor_quotationdetails.quotationno = @quotation_no) AND (quotation_request.indentno = @indentno)");
                        cmd.Parameters.Add("@sup_id", supplierid);
                        cmd.Parameters.Add("@quote_date", GetLowDate(date));
                        cmd.Parameters.Add("@quotation_no", quotation_no);
                        cmd.Parameters.Add("@indentno", txt_indentno.Text);
                        DataTable dt_pandf_amt = SalesDB.SelectQuery(cmd).Tables[0];
                        price_basis = dt_pandf_amt.Rows[0]["pricebasis"].ToString();
                        dataRow11[sup_name + "|Rate"] = "";
                        dataRow11[sup_name + "|Amount"] = price_basis;
                    }
                    timeSheet.Rows.Add(dataRow11);

                    var dataRow12 = timeSheet.NewRow();
                    dataRow12["S.NO." + _seperator + ""] = " ";
                    dataRow12["Item Code" + _seperator + ""] = "";
                    dataRow12["Item Description" + _seperator + ""] = "Payment Mode";
                    dataRow12["UOM" + _seperator + ""] = "";
                    dataRow12["QTY" + _seperator + ""] = "";
                    string payment_mode = "";
                    foreach (DataRow sup3 in dt_suppliers.Rows)
                    {
                        supplierid = sup3["supplierid"].ToString();
                        sup_name = sup3["name"].ToString();

                        cmd = new SqlCommand("SELECT quotationno FROM vendor_quotationdetails WHERE (vendor_quotationdetails.supplierid = @sup_id) AND (vendor_quotationdetails.quotationdate = @quote_date)");
                        cmd.Parameters.Add("@sup_id", supplierid);
                        cmd.Parameters.Add("@quote_date", GetLowDate(date));
                        DataTable dt_quotation_num = vdm.SelectQuery(cmd).Tables[0];
                        string quotation_no = dt_quotation_num.Rows[0]["quotationno"].ToString();

                        cmd = new SqlCommand("SELECT paymentmaster.paymenttype FROM vendor_quotationdetails INNER JOIN paymentmaster ON vendor_quotationdetails.paymentmode = paymentmaster.sno INNER JOIN quotation_request ON vendor_quotationdetails.quotationno = quotation_request.quotationno WHERE (vendor_quotationdetails.supplierid = @sup_id) AND (vendor_quotationdetails.quotationdate = @quote_date) AND (vendor_quotationdetails.quotationno = @quotation_no) AND (quotation_request.indentno = @indentno)");
                        cmd.Parameters.Add("@sup_id", supplierid);
                        cmd.Parameters.Add("@quote_date", GetLowDate(date));
                        cmd.Parameters.Add("@quotation_no", quotation_no);
                        cmd.Parameters.Add("@indentno", txt_indentno.Text);
                        DataTable dt_pandf_amt = SalesDB.SelectQuery(cmd).Tables[0];
                        payment_mode = dt_pandf_amt.Rows[0]["paymenttype"].ToString();
                        dataRow12[sup_name + "|Rate"] = "";
                        dataRow12[sup_name + "|Amount"] = payment_mode;
                    }
                    timeSheet.Rows.Add(dataRow12);

                    var dataRow13 = timeSheet.NewRow();
                    dataRow13["S.NO." + _seperator + ""] = " ";
                    dataRow13["Item Code" + _seperator + ""] = "";
                    dataRow13["Item Description" + _seperator + ""] = "Mode of Dispatch";
                    dataRow13["UOM" + _seperator + ""] = "";
                    dataRow13["QTY" + _seperator + ""] = "";
                    string dispatch_mode = "";
                    foreach (DataRow sup3 in dt_suppliers.Rows)
                    {
                        supplierid = sup3["supplierid"].ToString();
                        sup_name = sup3["name"].ToString();

                        cmd = new SqlCommand("SELECT quotationno FROM vendor_quotationdetails WHERE (vendor_quotationdetails.supplierid = @sup_id) AND (vendor_quotationdetails.quotationdate = @quote_date)");
                        cmd.Parameters.Add("@sup_id", supplierid);
                        cmd.Parameters.Add("@quote_date", GetLowDate(date));
                        DataTable dt_quotation_num = vdm.SelectQuery(cmd).Tables[0];
                        string quotation_no = dt_quotation_num.Rows[0]["quotationno"].ToString();

                        cmd = new SqlCommand("SELECT vendor_quotationdetails.despatchmode FROM vendor_quotationdetails INNER JOIN quotation_request ON vendor_quotationdetails.quotationno = quotation_request.quotationno WHERE (vendor_quotationdetails.supplierid = @sup_id) AND (vendor_quotationdetails.quotationdate = @quote_date) AND (vendor_quotationdetails.quotationno = @quotation_no) AND (quotation_request.indentno = @indentno)");
                        cmd.Parameters.Add("@sup_id", supplierid);
                        cmd.Parameters.Add("@quote_date", GetLowDate(date));
                        cmd.Parameters.Add("@quotation_no", quotation_no);
                        cmd.Parameters.Add("@indentno", txt_indentno.Text);
                        DataTable dt_pandf_amt = SalesDB.SelectQuery(cmd).Tables[0];
                        dispatch_mode = dt_pandf_amt.Rows[0]["despatchmode"].ToString();
                        dataRow13[sup_name + "|Rate"] = "";
                        dataRow13[sup_name + "|Amount"] = dispatch_mode;
                    }
                    timeSheet.Rows.Add(dataRow13);

                    var dataRow14 = timeSheet.NewRow();
                    dataRow14["S.NO." + _seperator + ""] = " ";
                    dataRow14["Item Code" + _seperator + ""] = "";
                    dataRow14["Item Description" + _seperator + ""] = "Delivery Terms";
                    dataRow14["UOM" + _seperator + ""] = "";
                    dataRow14["QTY" + _seperator + ""] = "";
                    string delivery_terms = "";
                    foreach (DataRow sup3 in dt_suppliers.Rows)
                    {
                        supplierid = sup3["supplierid"].ToString();
                        sup_name = sup3["name"].ToString();

                        cmd = new SqlCommand("SELECT quotationno FROM vendor_quotationdetails WHERE (vendor_quotationdetails.supplierid = @sup_id) AND (vendor_quotationdetails.quotationdate = @quote_date)");
                        cmd.Parameters.Add("@sup_id", supplierid);
                        cmd.Parameters.Add("@quote_date", GetLowDate(date));
                        DataTable dt_quotation_num = vdm.SelectQuery(cmd).Tables[0];
                        string quotation_no = dt_quotation_num.Rows[0]["quotationno"].ToString();

                        cmd = new SqlCommand("SELECT deliveryterms.deliveryterms FROM vendor_quotationdetails INNER JOIN deliveryterms ON vendor_quotationdetails.deliveryterms = deliveryterms.sno INNER JOIN quotation_request ON vendor_quotationdetails.quotationno = quotation_request.quotationno WHERE (vendor_quotationdetails.supplierid = @sup_id) AND (vendor_quotationdetails.quotationdate = @quote_date) AND (vendor_quotationdetails.quotationno = @quotation_no) AND (quotation_request.indentno = @indentno)");
                        cmd.Parameters.Add("@sup_id", supplierid);
                        cmd.Parameters.Add("@quote_date", GetLowDate(date));
                        cmd.Parameters.Add("@quotation_no", quotation_no);
                        cmd.Parameters.Add("@indentno", txt_indentno.Text);
                        DataTable dt_pandf_amt = SalesDB.SelectQuery(cmd).Tables[0];
                        delivery_terms = dt_pandf_amt.Rows[0]["deliveryterms"].ToString();
                        dataRow14[sup_name + "|Rate"] = "";
                        dataRow14[sup_name + "|Amount"] = delivery_terms;
                    }
                    timeSheet.Rows.Add(dataRow14);

                    var dataRow15 = timeSheet.NewRow();
                    dataRow15["S.NO." + _seperator + ""] = " ";
                    dataRow15["Item Code" + _seperator + ""] = "";
                    dataRow15["Item Description" + _seperator + ""] = "Request for Quotation No";
                    dataRow15["UOM" + _seperator + ""] = "";
                    dataRow15["QTY" + _seperator + ""] = "";
                    string quotation_num = "";
                    foreach (DataRow sup3 in dt_suppliers.Rows)
                    {
                        supplierid = sup3["supplierid"].ToString();
                        sup_name = sup3["name"].ToString();
                        cmd = new SqlCommand("SELECT vendor_quotationdetails.quotationno FROM vendor_quotationdetails INNER JOIN quotation_request ON vendor_quotationdetails.quotationno = quotation_request.quotationno WHERE (vendor_quotationdetails.supplierid = @sup_id) AND (vendor_quotationdetails.quotationdate = @quote_date) AND (quotation_request.indentno = @indentno)");
                        cmd.Parameters.Add("@sup_id", supplierid);
                        cmd.Parameters.Add("@quote_date", GetLowDate(date));
                        cmd.Parameters.Add("@indentno", txt_indentno.Text);
                        DataTable dt_pandf_amt = SalesDB.SelectQuery(cmd).Tables[0];
                        quotation_num = dt_pandf_amt.Rows[0]["quotationno"].ToString();
                        dataRow15[sup_name + "|Rate"] = "";
                        dataRow15[sup_name + "|Amount"] = quotation_num;
                    }
                    timeSheet.Rows.Add(dataRow15);

                    var dataRow16 = timeSheet.NewRow();
                    dataRow16["S.NO." + _seperator + ""] = " ";
                    dataRow16["Item Code" + _seperator + ""] = "";
                    dataRow16["Item Description" + _seperator + ""] = "Request for Quotation Date";
                    dataRow16["UOM" + _seperator + ""] = "";
                    dataRow16["QTY" + _seperator + ""] = "";
                    foreach (DataRow sup3 in dt_suppliers.Rows)
                    {
                        sup_name = sup3["name"].ToString();
                        dataRow16[sup_name + "|Rate"] = "";
                        dataRow16[sup_name + "|Amount"] = dateonly;
                    }
                    timeSheet.Rows.Add(dataRow16);
                    Session["xportdata"] = timeSheet;
                    grdReports.DataSource = timeSheet;
                    grdReports.DataBind();
                    hidepanel.Visible = true;
                }
                else
                {
                    lblmsg.Text = "No Data Found";
                }
            }
            else
            {
                lblmsg.Text = "No Data Found";
            }
        }
        catch (Exception ex)
        {
            lblmsg.Text = ex.Message;
            DataTable empty = new DataTable("");
            grdReports.DataSource = empty;
            grdReports.DataBind();
            hidepanel.Visible = true;
        }
    }


    protected void gvMenu_DataBinding(object sender, EventArgs e)
    {
        GridViewGroup First = new GridViewGroup(grdReports, null, "S.NO.|");
        GridViewGroup second = new GridViewGroup(grdReports, First, "Item Code|");
        GridViewGroup three = new GridViewGroup(grdReports, second, "Item Description|");
        GridViewGroup four = new GridViewGroup(grdReports, three, "UOM|");
        GridViewGroup five = new GridViewGroup(grdReports, four, "QTY|");
    }

    protected void gvMenu_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        int cellCount = e.Row.Cells.Count;

        for (int item = 3; item < cellCount; item = item + 2)
        {
            if (e.Row.Cells != null)
            {
                var cellText = e.Row.Cells[item].Text;
            }
        }
    }

    protected void gvMenu_RowCreated(object sender, GridViewRowEventArgs e)
    {

        if (e.Row.RowType == DataControlRowType.Header)
            CustomizeGridHeader((GridView)sender, e.Row, 2);
    }

    private void CustomizeGridHeader(GridView timeSheetGrid, GridViewRow gridRow, int headerLevels)
    {
        for (int item = 1; item <= headerLevels; item++)
        {

            GridViewRow gridviewRow = new GridViewRow(0, 0, DataControlRowType.Header, DataControlRowState.Insert);
            IEnumerable<IGrouping<string, string>> gridHeaders = null;


            gridHeaders = gridRow.Cells.Cast<TableCell>()
                        .Select(cell => GetHeaderText(cell.Text, item))
                        .GroupBy(headerText => headerText);

            foreach (var header in gridHeaders)
            {
                TableHeaderCell cell = new TableHeaderCell();

                if (item == 2)
                {
                    cell.Text = header.Key.Substring(header.Key.LastIndexOf(_seperator) + 1);
                }
                else
                {
                    cell.Text = header.Key.ToString();
                    if (!cell.Text.Contains("Item") && !cell.Text.Contains("S.NO") && !cell.Text.Contains("UOM") && !cell.Text.Contains("QTY"))
                    {
                        cell.ColumnSpan = 2;
                    }
                }
                gridviewRow.Cells.Add(cell);
            }

            timeSheetGrid.Controls[0].Controls.AddAt(gridRow.RowIndex, gridviewRow);
        }

        gridRow.Visible = false;
    }

    private string GetHeaderText(string headerText, int headerLevel)
    {
        if (headerLevel == 2)
        {
             return headerText;
        }
        return headerText.Substring(0, headerText.LastIndexOf(_seperator));
    }

    protected void btnexport_click(object sender, EventArgs e)
    {

        Response.Redirect("~/exporttoxl.aspx");

    }

}