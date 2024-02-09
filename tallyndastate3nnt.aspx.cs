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

public partial class tallyndastate3nnt : System.Web.UI.Page
{
    SqlCommand cmd;
    ///string BranchID = "";
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

            Report.Columns.Add("Sno");
            Report.Columns.Add("Customer Name");
            Report.Columns.Add("Invoice No");
            Report.Columns.Add("Invoice Date");
            Report.Columns.Add("Ledger Type");
            Report.Columns.Add("Ledger Amount");
            Report.Columns.Add("Ledgertype(IGST)");
            Report.Columns.Add("Ledgeramount(IGST)");
            Report.Columns.Add("Ledgertype(CGST)");
            Report.Columns.Add("Ledgeramount(CGST)");
            Report.Columns.Add("Ledgertype(SGST)");
            Report.Columns.Add("Ledgeramount(SGST)");
            Report.Columns.Add("Ledgertype(Other)");
            Report.Columns.Add("Ledgeramount(Other)");
            Report.Columns.Add("Net Value");
            Report.Columns.Add("Narration");

           

            //if (branchid == "4" || branchid == "35")
            //{
            //    newrow1["Narration"] = "Being PurchasingMaterials" + remarks + "," + "From" + suppliername + ",Invoice No: " + invoice + ",Inv Dt" + Invoicdate + ",Amount" + amount + ",MRNJV" + MRNNO + ",Dt:" + mrndate + "";
            //}
            //else
            //{
            //    newrow1["Narration"] = "Being PurchasingMaterials " + productlist + " , " + "From " + suppliername + ",Invoice No: " + invoice + ",Inv Dt: " + Invoicdate + ",MRNJV" + MRNNO + ",Dt:" + mrndate + "";
            //}

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
            string branchid = Session["Po_BranchID"].ToString();
            string bcode = Session["BranchCode"].ToString();
            cmd = new SqlCommand("SELECT  inwarddetails.sno AS inwardsno, productmaster.productname, subinwarddetails.quantity, subinwarddetails.perunit, subinwarddetails.igst, subinwarddetails.cgst, subinwarddetails.sgst, inwarddetails.mrnno, inwarddetails.remarks, inwarddetails.invoiceno, inwarddetails.invoicedate, inwarddetails.inwarddate, inwarddetails.transportcharge, inwarddetails.freigtamt,  suppliersdetails.name  FROM  inwarddetails INNER JOIN subinwarddetails ON inwarddetails.sno = subinwarddetails.in_refno INNER JOIN productmaster ON subinwarddetails.productid = productmaster.productid INNER JOIN suppliersdetails ON inwarddetails.supplierid = suppliersdetails.supplierid WHERE (inwarddetails.inwarddate BETWEEN @fromdate AND @todate) AND (inwarddetails.branchid = @branchid) AND (subinwarddetails.quantity > 0) ORDER BY inwardsno");
            cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
            cmd.Parameters.Add("@todate", GetHighDate(todate));
            cmd.Parameters.Add("@branchid", branchid);
            DataTable dttotalinward = vdm.SelectQuery(cmd).Tables[0];
            if (dttotalinward.Rows.Count > 0)
            {
                double totaldiscount = 0;
                double totalqty = 0;
                double ttotalamount = 0;
                double gtotalamount = 0;
                double totalprice = 0;
                double toatlpq = 0;
                double totalpriceqty = 0;
                double edamount = 0;
                double totaledamt = 0;
                double gtotaledamt = 0;
                double tcsttax = 0;
                double tfreight = 0;
                double ttransport = 0;
                double tedamount = 0;
                double totamount = 0;
                DateTime dt = DateTime.Now;
                string prevdate = string.Empty;
                string prevpono = "";
                int i = 1;
                int count = 1;
                int rowcount = 1;
                foreach (DataRow dr in dttotalinward.Rows)
                {
                    DataRow newrow = Report.NewRow();
                    string ledgertype = "Sales Accounts";
                    string bname = dr["name"].ToString();
                    string cinvoiceno = dr["invoiceno"].ToString();
                    string cinvoicedate = dr["invoicedate"].ToString();
                    DateTime cinvdate = Convert.ToDateTime(cinvoicedate);
                    string custmoreinvoicedate = cinvdate.ToString("dd-MMM-yyyy");
                    string remarks = dr["remarks"].ToString();
                    newrow["Customer Name"] = bname;
                    string invoiceno = dr["mrnno"].ToString();
                    string inwarddate = dr["inwarddate"].ToString();
                    DateTime dtdate = Convert.ToDateTime(inwarddate);
                    string invoicedate = dtdate.ToString("dd-MMM-yyyy");
                    string invoicedate1 = dtdate.ToString("dd/MM/yyyy");
                    newrow["Invoice No"] = "" + bcode + "MRNJV" + invoiceno + "";
                    newrow["Invoice Date"] = invoicedate;
                    string igst = dr["igst"].ToString();
                    string cgst = dr["cgst"].ToString();
                    string sgst = dr["sgst"].ToString();
                    string ledger = "Purchase of Store Materials-";
                    if (igst != "0")
                    {
                        ledger = ledger + "IGST " + igst + "%";
                    }
                    if (cgst != "0" && sgst !="0")
                    {
                        ledger = ledger + "CGST/SGST " + cgst + "%";
                    }
                    if (ledger == "Purchase of Store Materials-")
                    {
                        newrow["Ledger Type"] = "Purchase of Store Materials.NilTax";
                    }
                    else
                    {
                        newrow["Ledger Type"] = ledger;
                    }
                   
                    double price = 0;
                    double.TryParse(dr["perunit"].ToString(), out price);
                    totalprice += price;
                   // newrow["Rate"] = Math.Round(price, 2).ToString("f2"); //dr["price"].ToString();
                    double qty = 0;
                    double.TryParse(dr["quantity"].ToString(), out qty);
                    totalqty += qty;
                   // newrow["Qty"] = dr["quantity"].ToString();
                    string cgstper = dr["cgst"].ToString();
                    string sgstper = dr["sgst"].ToString();
                    string igstper = dr["igst"].ToString();
                    newrow["Ledgertype(CGST)"] = "InPut CGST " + dr["cgst"].ToString() + "%";
                    newrow["Ledgertype(SGST)"] = "InPut SGST " + dr["sgst"].ToString() + "%";
                    newrow["Ledgertype(IGST)"] = "InPut IGST " + dr["igst"].ToString() + "%";
                    double total = 0; double totamountt = 0; double cgsta = 0; double sgsta = 0; double igsta = 0;
                    total = qty * price;
                    if (cgstper != "" || cgstper != null)
                    {
                        cgsta = Convert.ToDouble(dr["cgst"].ToString());
                    }
                    if (sgstper != "" || sgstper != null)
                    {
                        sgsta = Convert.ToDouble(dr["sgst"].ToString());
                    }
                    if (igstper != "" || igstper != null)
                    {
                        igsta = Convert.ToDouble(dr["igst"].ToString());
                    }
                    double igstamount = (total * igsta) / 100;
                    double cgstamount = (total * cgsta) / 100;
                    double sgstamount = (total * sgsta) / 100;
                    newrow["Ledgeramount(IGST)"] = Math.Round(igstamount, 2).ToString("f2");
                    newrow["Ledgeramount(CGST)"] = Math.Round(cgstamount, 2).ToString("f2");
                    newrow["Ledgeramount(SGST)"] = Math.Round(sgstamount, 2).ToString("f2");
                    newrow["Ledger Amount"] = Math.Round(total, 2).ToString("f2");
                    totamount += total;
                    
                    double freight = 0;
                    double.TryParse(dr["freigtamt"].ToString(), out freight);
                    tfreight += freight;
                    if (freight != 0)
                    {
                        newrow["Ledgertype(Other)"] = "Freight  Charges";
                        newrow["Ledgeramount(Other)"] = Math.Round(freight, 2).ToString("f2");
                    }
                    double transport = 0;
                    double.TryParse(dr["transportcharge"].ToString(), out transport);
                    ttransport += transport;
                    if (transport != 0)
                    {
                        newrow["Ledgertype(Other)"] = "Transportation Charges-Pbk";
                        newrow["Ledgeramount(Other)"] = Math.Round(transport, 2).ToString("f2");
                    }
                    totamount = total + freight + igstamount + cgstamount + sgstamount + transport;
                    double totalamount = 0;
                    totalamount = totamount;
                    newrow["Net Value"] = Math.Round(totalamount, 2).ToString("f2");
                    // newrow["Rounding Off"] = "0";
                    ttotalamount += totalamount;
                    newrow["Narration"] = "Being PurchasingMaterials" + remarks + "," + "From" + bname + ",Invoice No: " + cinvoiceno + ",Inv Dt" + custmoreinvoicedate + ",Amount" + totalamount + ",MRNJV" + invoiceno + ",Dt:" + invoicedate + "";
                    Report.Rows.Add(newrow);
                }
                Session["xportdata"] = Report;
                Session["filename"] = "Tally MRN Report";
                Session["Address"] = "";
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
}