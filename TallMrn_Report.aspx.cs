using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;
public partial class TallMrn_Report : System.Web.UI.Page
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
            Report.Columns.Add("Mrn NO");
            Report.Columns.Add("JV Date");
            Report.Columns.Add("Ledger Name");
            Report.Columns.Add("Amount");
            Report.Columns.Add("TotalAmount");
            Report.Columns.Add("Narration");
            Report.Columns.Add("Discount");
            Report.Columns.Add("ED");
            Report.Columns.Add("Tax");
            Report.Columns.Add("EDType");
            Report.Columns.Add("TaxType");
            Report.Columns.Add("FrightAmt");
            Report.Columns.Add("TransportCharge");
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
            DateTime ServerDateCurrentdate = fromdate;
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
            string branchid = Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT  inwarddetails.invoicedate, inwarddetails.freigtamt, inwarddetails.invoiceno, inwarddetails.remarks, inwarddetails.mrnno, inwarddetails.sno AS inwardsno,inwarddetails.inwarddate, inwarddetails.invoiceno AS Expr1, inwarddetails.podate, inwarddetails.doorno, inwarddetails.remarks AS Expr2, inwarddetails.pono,inwarddetails.inwardno, suppliersdetails.name, subinwarddetails.quantity, subinwarddetails.perunit, productmaster.productname, productmaster.sku,taxmaster.type AS taxtype, taxmaster_1.type AS edtype, subinwarddetails.tax, subinwarddetails.disamt, subinwarddetails.dis, subinwarddetails.taxtype AS taxtypeid,subinwarddetails.edtax AS ed, inwarddetails.transportcharge FROM inwarddetails INNER JOIN subinwarddetails ON inwarddetails.sno = subinwarddetails.in_refno INNER JOIN productmaster ON productmaster.productid = subinwarddetails.productid INNER JOIN suppliersdetails ON suppliersdetails.supplierid = inwarddetails.supplierid LEFT OUTER JOIN taxmaster AS taxmaster_1 ON subinwarddetails.ed = taxmaster_1.sno LEFT OUTER JOIN taxmaster ON subinwarddetails.taxtype = taxmaster.sno WHERE  (inwarddetails.inwarddate BETWEEN @fromdate AND @todate) AND (inwarddetails.branchid = @branchid) AND (subinwarddetails.quantity > 0)   ORDER BY inwardsno");
            cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
            cmd.Parameters.Add("@todate", GetHighDate(todate));
            cmd.Parameters.Add("@branchid", branchid);
            DataTable dttotalinward = vdm.SelectQuery(cmd).Tables[0];
            if (dttotalinward.Rows.Count > 0)
            {
                DataView view = new DataView(dttotalinward);
                DataTable distinctinwardsno = view.ToTable(true, "inwardsno");

                foreach (DataRow drinsno in distinctinwardsno.Rows)
                {

                    //foreach (DataRow dr in dttotalinward.Select("inwardsno='" + drinsno["inwardsno"].ToString() + "' AND productname='" + drinsno["productname"].ToString() + "'"))
                    //    {
                    string MrnDate = "";
                    string Invoic_date = "";
                    string ledgername = "";
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
                    double tedamount = 0;
                    double totamount = 0;
                    double ttransport = 0;
                    DateTime dt = DateTime.Now;
                    string taxtype = "";
                    string edtype = "";
                    string MrnNO = "";
                    string invoice = "";
                    string suppliername = "";
                    foreach (DataRow dr in dttotalinward.Select("inwardsno='" + drinsno["inwardsno"].ToString() + "'"))
                    {
                        double price = 0;
                        double.TryParse(dr["perunit"].ToString(), out price);
                        totalprice += price;
                        double qty = 0;
                        double.TryParse(dr["quantity"].ToString(), out qty);
                        totalqty += qty;
                        double toatlpq1 = 0;
                        toatlpq = qty * price;
                        double dis = 0;
                        double.TryParse(dr["disamt"].ToString(), out dis);
                        totaldiscount += dis;
                        toatlpq1 = toatlpq - dis;
                        totalpriceqty += toatlpq1;
                        double edamt = 0;
                        double.TryParse(dr["ed"].ToString(), out edamt);
                        totaledamt += edamt;
                        gtotaledamt += totaledamt;
                        edamount = (toatlpq1 * edamt) / 100;
                        tedamount += edamount;
                        double totedamount = 0;
                        totedamount = toatlpq1 + edamount;//stock
                        totamount += totedamount;// totalpriceqty + edamount;//stock
                        double csttax = 0;
                        double.TryParse(dr["tax"].ToString(), out csttax);
                        double csttaxamt = 0;
                        csttaxamt = (totedamount * csttax) / 100;
                        tcsttax += csttaxamt;
                        double freight = 0;
                        double.TryParse(dr["freigtamt"].ToString(), out freight);
                        tfreight += freight;
                        double transport = 0;
                        double.TryParse(dr["transportcharge"].ToString(), out transport);
                        ttransport = transport;
                        double totalamount = 0;
                        totalamount = totedamount + csttaxamt ; ;//grand total in that coming
                        ttotalamount += totalamount;
                        edtype = dr["edtype"].ToString();
                        taxtype = dr["taxtype"].ToString();
                        MrnNO = "" + Session["BranchCode"].ToString() + "MRNJV/" + dtapril.ToString("yy") + "-" + dtmarch.ToString("yy") + "/0" + dr["mrnno"].ToString() + "";
                        string invoicdate = dr["invoicedate"].ToString();
                        DateTime Invoice = Convert.ToDateTime(invoicdate);
                        Invoic_date = Invoice.ToString("MM/dd/yyyy");
                        string mdate = dr["inwarddate"].ToString();
                        DateTime mrn_date = Convert.ToDateTime(mdate);
                        MrnDate = mrn_date.ToString("MM/dd/yyyy");
                        ledgername = dr["name"].ToString();
                        invoice = dr["invoiceno"].ToString();
                         suppliername = dr["name"].ToString();
                    }
                    //}
                    DataRow newrow = Report.NewRow();
                    newrow["JV Date"] = MrnDate;
                    newrow["Mrn NO"] = MrnNO;
                    newrow["Ledger Name"] = ledgername;
                    newrow["Amount"] = totalpriceqty.ToString("f2");
                    newrow["Discount"] = totaldiscount.ToString("f2");
                    newrow["ED"] = tedamount.ToString("f2");
                    newrow["Tax"] = tcsttax.ToString("f2");
                    newrow["EDType"] = edtype; ;
                    newrow["TaxType"] = taxtype;
                    newrow["FrightAmt"] = tfreight;
                    newrow["TransportCharge"] = ttransport;
                    double ToatlAmount = ttotalamount + tfreight + ttransport;
                    newrow["TotalAmount"] = ToatlAmount.ToString("f2");
                    newrow["Narration"] = "Being PurchasingMaterials From  " + suppliername + ",Invoice No: " + invoice + ",Inv Dt" + Invoic_date + ",MRN No-" + MrnNO + ",Dt:" + MrnDate + ".";
                    newrow["Sno"] = "Total";
                    Report.Rows.Add(newrow);
                }
                DataTable newdatatable = new DataTable();
                newdatatable.Columns.Add("Mrn NO");
                newdatatable.Columns.Add("JV Date");
                newdatatable.Columns.Add("Ledger Name");
                newdatatable.Columns.Add("Amount");
                newdatatable.Columns.Add("Narration");
                string credit = "Total";
                string bcode = Session["BranchCode"].ToString();
                foreach (DataRow drrepo in Report.Select("Sno='" + credit + "'"))
                {
                    DataRow reportnewrow1 = newdatatable.NewRow();
                    double TOTALA = Convert.ToDouble(drrepo["TotalAmount"].ToString());
                    reportnewrow1["Mrn NO"] =  drrepo["Mrn NO"].ToString();
                    reportnewrow1["JV Date"] = drrepo["JV Date"].ToString();
                    reportnewrow1["Ledger Name"] = drrepo["Ledger Name"].ToString() + "";
                    reportnewrow1["Amount"] = "-" + Math.Round(TOTALA, 0);
                    reportnewrow1["Narration"] = drrepo["Narration"].ToString();
                    newdatatable.Rows.Add(reportnewrow1);
                    string ttax = drrepo["Tax"].ToString();
                    double ttax1 = 0;
                    double.TryParse(ttax, out ttax1);
                    string eed = drrepo["ED"].ToString();
                    double eedtax = 0;
                    double.TryParse(eed, out eedtax);
                    string fri = drrepo["FrightAmt"].ToString();
                    double frig = 0;
                    double.TryParse(fri, out frig);
                    string trans = drrepo["TransportCharge"].ToString();
                    double tramt = 0;
                    double.TryParse(trans, out tramt);
                    if (frig != 0 || eedtax != 0 || ttax1 != 0 || tramt != 0)
                    {
                        DataRow reportnewrow2 = newdatatable.NewRow();

                        reportnewrow2["Mrn NO"] = drrepo["Mrn NO"].ToString();
                        reportnewrow2["JV Date"] = drrepo["JV Date"].ToString();
                        reportnewrow2["Ledger Name"] = Session["branchledgername"].ToString();
                        double TAA = Convert.ToDouble(drrepo["Amount"].ToString());
                        reportnewrow2["Amount"] = Math.Round(TAA, 0);
                        newdatatable.Rows.Add(reportnewrow2);
                    }
                    else
                    {
                        DataRow reportnewrow2 = newdatatable.NewRow();
                        reportnewrow2["Mrn NO"] = drrepo["Mrn NO"].ToString() + "";
                        reportnewrow2["JV Date"] = drrepo["JV Date"].ToString();
                        reportnewrow2["Ledger Name"] = Session["branchledgername"].ToString();
                        // reportnewrow2["Ledger Name"] = "Stock of Stores & Spares - Punabaka";
                        double TA = Convert.ToDouble(drrepo["TotalAmount"].ToString());
                        reportnewrow2["Amount"] = Math.Round(TA, 0);
                        newdatatable.Rows.Add(reportnewrow2);
                    }
                    if (frig != 0)
                    {
                        DataRow reportnewrow3 = newdatatable.NewRow();
                        reportnewrow3["Mrn NO"] = drrepo["Mrn NO"].ToString();
                        reportnewrow3["JV Date"] = drrepo["JV Date"].ToString();
                        reportnewrow3["Amount"] = Math.Round(frig, 0);
                        reportnewrow3["Ledger Name"] = "FreightCharges";
                        newdatatable.Rows.Add(reportnewrow3);
                    }
                    else if (ttax1 != 0)
                    {
                        DataRow reportnewrow4 = newdatatable.NewRow();
                        reportnewrow4["Mrn NO"] =drrepo["Mrn NO"].ToString();
                        reportnewrow4["JV Date"] = drrepo["JV Date"].ToString();
                        reportnewrow4["Ledger Name"] = drrepo["taxtype"].ToString() + "";
                        reportnewrow4["Amount"] = Math.Round(ttax1, 0);
                        // reportnewrow4["Narration"] = drrepo["Narration"].ToString() + "_" + drrepo["taxtype"].ToString() + "";
                        newdatatable.Rows.Add(reportnewrow4);
                    }
                    else if (tramt != 0)
                    {
                        DataRow reportnewrow5 = newdatatable.NewRow();
                        reportnewrow5["Mrn NO"] =drrepo["Mrn NO"].ToString();
                        reportnewrow5["JV Date"] = drrepo["JV Date"].ToString();
                        reportnewrow5["Ledger Name"] = "Transportation Charges-Pbk";
                        reportnewrow5["Amount"] = Math.Round(tramt, 0);
                        //reportnewrow5["Narration"] = "TransportCharges" + "tramt " + drrepo["Narration"].ToString(); ;
                        newdatatable.Rows.Add(reportnewrow5);
                    }
                    else
                    {
                    }
                }
                Session["xportdata"] = newdatatable;
                Session["filename"] = "Tally MRN Report";
                Session["Address"] = "";
                grdReports.DataSource = newdatatable;
                grdReports.DataBind();
                hidepanel.Visible = true;
                //grdReports.DataSource = Report;
                //grdReports.DataBind();
                //hidepanel.Visible = true;
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