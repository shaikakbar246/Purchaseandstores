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
public partial class TallyInwardReport : System.Web.UI.Page
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
        Report.Columns.Add("Sno");
        Report.Columns.Add("MrnNO");
        Report.Columns.Add("MrnDate");
        Report.Columns.Add("LedgerName");
        Report.Columns.Add("Amount");
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
      

        vdm = new SalesDBManager();
        DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
        string julydt = "07/01/2017";
        DateTime gst_dt = Convert.ToDateTime(julydt);
        cmd = new SqlCommand("SELECT  inwarddetails.sno, subinwarddetails.in_refno, inwarddetails.supplierid, po_entrydetailes.ponumber,po_entrydetailes.podate,inwarddetails.status,po_entrydetailes.reversecharge,suppliersdetails.bankaccountno,suppliersdetails.bankifsccode,state_sup.statename as sup_state,suppliersdetails.GSTIN as sup_gstin,suppliersdetails.stateid as sup_stateid,productmaster.HSNcode,subinwarddetails.igst,subinwarddetails.cgst,subinwarddetails.sgst,pandf.pandf, paymentmaster.paymenttype, inwarddetails.pfid, inwarddetails.inwardamount, inwarddetails.transportcharge,inwarddetails.modeofinward, inwarddetails.mrnno, inwarddetails.pono, inwarddetails.sno AS inwardno, inwarddetails.status, inwarddetails.inwarddate,inwarddetails.invoiceno, inwarddetails.invoicedate, inwarddetails.dcno, inwarddetails.lrno, inwarddetails.supplierid, inwarddetails.podate, inwarddetails.indentno, inwarddetails.remarks, inwarddetails.pono AS Expr1, inwarddetails.inwardno AS Expr2, inwarddetails.transportname, inwarddetails.vehicleno,inwarddetails.modeofinward AS Expr3, inwarddetails.securityno, subinwarddetails.productid, subinwarddetails.quantity, subinwarddetails.perunit, subinwarddetails.totalcost, subinwarddetails.in_refno, subinwarddetails.status AS Expr4, productmaster.productname, productmaster.sku, productmaster.itemcode,productmaster.productcode, suppliersdetails.name, suppliersdetails.street1, suppliersdetails.city, suppliersdetails.state, uimmaster.uim, suppliersdetails.country, suppliersdetails.zipcode, taxmaster.type AS taxtype,taxmaster_1.type AS ed, subinwarddetails.tax, subinwarddetails.edtax, subinwarddetails.disamt, subinwarddetails.dis, inwarddetails.freigtamt FROM inwarddetails INNER JOIN subinwarddetails ON inwarddetails.sno = subinwarddetails.in_refno INNER JOIN productmaster ON productmaster.productid = subinwarddetails.productid INNER JOIN suppliersdetails ON suppliersdetails.supplierid = inwarddetails.supplierid LEFT OUTER JOIN taxmaster ON subinwarddetails.taxtype = taxmaster.sno LEFT OUTER JOIN taxmaster AS taxmaster_1 ON subinwarddetails.tax = taxmaster_1.sno LEFT OUTER JOIN uimmaster ON uimmaster.sno = productmaster.uim LEFT OUTER JOIN pandf on pandf.sno=inwarddetails.pfid LEFT OUTER JOIN po_entrydetailes on po_entrydetailes.sno = inwarddetails.pono LEFT OUTER JOIN paymentmaster ON paymentmaster.sno = po_entrydetailes.paymentid LEFT OUTER JOIN statemaster as state_sup ON state_sup.sno=suppliersdetails.stateid WHERE (inwarddetails.inwarddate BETWEEN @fromdate AND @todate) AND (inwarddetails.branchid = @branchid)");
        cmd.Parameters.Add("@branchid", branchid);
        cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
        cmd.Parameters.Add("@todate", GetHighDate(todate));
        DataTable routes = vdm.SelectQuery(cmd).Tables[0];
        DataView view = new DataView(routes);
        DataTable dtinward = view.ToTable(true, "sno", "supplierid", "name", "mrnno", "inwarddate", "podate", "status", "reversecharge", "sup_gstin", "sup_state", "bankaccountno", "bankifsccode", "inwardamount", "paymenttype", "inwardno", "pono", "modeofinward", "zipcode", "invoiceno", "invoicedate", "remarks", "street1", "city");
        DataTable dtinwardtotcost = view.ToTable(true, "sno", "supplierid", "totalcost", "quantity", "perunit", "igst", "cgst", "sgst");
        DataTable dtinward_subdetails = view.ToTable(true, "in_refno", "supplierid", "mrnno", "pandf", "totalcost", "pfid", "productname", "transportcharge", "inwardno", "status", "inwarddate", "productid", "quantity", "perunit", "sku", "itemcode", "productcode", "uim", "remarks", "taxtype", "ed", "tax", "igst", "cgst", "sgst", "HSNcode", "edtax", "disamt", "dis", "freigtamt");
       
        cmd = new SqlCommand("select statemaster.statename,branchmaster.branchname,branchmaster.GSTIN from statemaster INNER JOIN branchmaster on statemaster.sno=branchmaster.statename WHERE branchmaster.branchid=@branchid");
        cmd.Parameters.Add("@branchid", branchid);
        DataTable dt_state = vdm.SelectQuery(cmd).Tables[0];

        

        string purchasedstate = dt_state.Rows[0]["statename"].ToString();
        string branchname = dt_state.Rows[0]["branchname"].ToString();
        string gstin = dt_state.Rows[0]["GSTIN"].ToString();
        DateTime dtapril = new DateTime();
        DateTime dtmarch = new DateTime();
        foreach (DataRow dri in dtinward.Rows)
        {
            DataRow newrow = Report.NewRow();
            string supplierid = dri["supplierid"].ToString();
            string sno = dri["sno"].ToString();
            newrow["Sno"] = sno;
            string ledgername = dri["name"].ToString();
            string invoiceno = dri["invoiceno"].ToString();
            string invoicedate = dri["invoicedate"].ToString();
            DateTime dt_invoicedt = Convert.ToDateTime(invoicedate);
            double tot_amount = 0;
            string productlist = "";
            cmd = new SqlCommand("SELECT productmaster.productname, subinwarddetails.quantity, subinwarddetails.perunit FROM inwarddetails INNER JOIN subinwarddetails ON inwarddetails.sno = subinwarddetails.in_refno INNER JOIN productmaster ON subinwarddetails.productid = productmaster.productid WHERE (inwarddetails.sno = @mrn)");
            cmd.Parameters.Add("@mrn", sno);
            DataTable dtproducts = vdm.SelectQuery(cmd).Tables[0];
            foreach (DataRow dtp in dtproducts.Rows)
            {
                string prod_qty = dtp["quantity"].ToString();
                string perunit = dtp["perunit"].ToString();
                double tot_amt = (Convert.ToDouble(prod_qty) * Convert.ToDouble(perunit));
                tot_amount += tot_amt;
                productlist += dtp["productname"].ToString() + " " + tot_amt.ToString() + "/-, ";
            }



            //invoiceno", "invoicedate"

            string totamt = "";
            DateTime dt_inw = Convert.ToDateTime(dri["inwarddate"].ToString());
            int currentyear = dt_inw.Year;
            int nextyear = dt_inw.Year + 1;
            int currntyearnum = 0;
            int nextyearnum = 0;
            if (dt_inw.Month > 3)
            {
                string apr = "4/1/" + currentyear;
                dtapril = DateTime.Parse(apr);
                string march = "3/31/" + nextyear;
                dtmarch = DateTime.Parse(march);
                currntyearnum = currentyear;
                nextyearnum = nextyear;
            }
            if (dt_inw.Month <= 3)
            {
                string apr = "4/1/" + (currentyear - 1);
                dtapril = DateTime.Parse(apr);
                string march = "3/31/" + (nextyear - 1);
                dtmarch = DateTime.Parse(march);
                currntyearnum = currentyear - 1;
                nextyearnum = nextyear - 1;
            }
            string mrnnumber = "";
            if (branchid == "2")
            {
                mrnnumber = "PBK/MRN/" + dtapril.ToString("yy") + "-" + dtmarch.ToString("yy") + "/" + dri["mrnno"].ToString();
            }
            else if (branchid == "4")
            {
                mrnnumber = "CHN/MRN/" + dtapril.ToString("yy") + "-" + dtmarch.ToString("yy") + "/" + dri["mrnno"].ToString();
            }
            else if (branchid == "35")
            {
                mrnnumber = "MNPK/MRN/" + dtapril.ToString("yy") + "-" + dtmarch.ToString("yy") + "/" + dri["mrnno"].ToString();
            }
            else if (branchid == "1040")
            {
                mrnnumber = "KPM/MRN/" + dtapril.ToString("yy") + "-" + dtmarch.ToString("yy") + "/" + dri["mrnno"].ToString();
            }
            else
            {
                mrnnumber = "MRN/" + dtapril.ToString("yy") + "-" + dtmarch.ToString("yy") + "/" + dri["mrnno"].ToString();
            }
            string mrnno = mrnnumber.ToString();
            newrow["MrnNO"] = mrnnumber;
            newrow["MrnDate"] = dt_inw.ToString("dd/MM/yyyy");
            newrow["LedgerName"] = ledgername;
            double totcost = 0;
            double totitemcost = 0;
            double tottaxablevalue = 0;
            foreach (DataRow drt in dtinwardtotcost.Select("supplierid='" + supplierid + "' AND sno='" + sno + "'"))
            {
                string totalcval = drt["totalcost"].ToString();
                double ttv = Convert.ToDouble(totalcval);
                totcost += ttv;

                double quantityy = 0;
                double.TryParse(drt["quantity"].ToString(), out quantityy);
                double perunity = 0;
                double.TryParse(drt["perunit"].ToString(), out perunity);
                double tiv = quantityy * perunity;
                totitemcost += tiv;

                double igstv = 0;
                double.TryParse(drt["igst"].ToString(), out igstv);
                double cgstv = 0;
                double.TryParse(drt["cgst"].ToString(), out cgstv);
                 double sgstv = 0;
                double.TryParse(drt["sgst"].ToString(), out sgstv);
                double taxpercent = igstv + cgstv + sgstv;
                double taxtval = (tiv * taxpercent) / 100;
                tottaxablevalue += taxtval;


            }
            newrow["Amount"] = totcost;

            string narration = "Being PurchasingMaterials " + productlist + "Taxable Amount " + totitemcost + ", TaxAmount " + tottaxablevalue + ", GrandTotal:" + totcost + " From  " + ledgername + ",Invoice No: " + invoiceno + ",Inv Dt" + dt_invoicedt.ToString("dd/MM/yyyy") + ",MRN No-" + mrnnumber + ",Dt:" + dt_inw.ToString("dd/MM/yyyy") + ".";
            newrow["Narration"] = narration;
            Report.Rows.Add(newrow);
            foreach (DataRow dr in dtinward_subdetails.Select("supplierid='" + supplierid + "' AND in_refno='" + sno + "'"))
            {
                DataRow newrow1 = Report.NewRow();
                newrow1["Sno"] = sno;
                string inwarddate1 = ((DateTime)dr["inwarddate"]).ToString();
                //string inwarddate1 = "7/17/2017 12:00:00 AM";
                DateTime inwarddate = Convert.ToDateTime(inwarddate1);
               
                string mrnnumberr = "";
                if (branchid == "2")
                {
                    mrnnumberr = "PBK/MRN/" + dtapril.ToString("yy") + "-" + dtmarch.ToString("yy") + "/" + dr["mrnno"].ToString();
                }
                else if (branchid == "4")
                {
                    mrnnumberr = "CHN/MRN/" + dtapril.ToString("yy") + "-" + dtmarch.ToString("yy") + "/" + dr["mrnno"].ToString();
                }
                else if (branchid == "35")
                {
                    mrnnumberr = "MNPK/MRN/" + dtapril.ToString("yy") + "-" + dtmarch.ToString("yy") + "/" + dr["mrnno"].ToString();
                }
                else if (branchid == "1040")
                {
                    mrnnumberr = "KPM/MRN/" + dtapril.ToString("yy") + "-" + dtmarch.ToString("yy") + "/" + dr["mrnno"].ToString();
                }
                else
                {
                    mrnnumberr = "MRN/" + dtapril.ToString("yy") + "-" + dtmarch.ToString("yy") + "/" + dr["mrnno"].ToString();
                }
                string mrnnoo = mrnnumberr.ToString();
                if (inwarddate < gst_dt)
                {
                    string ed = dr["ed"].ToString();
                    string edtax = dr["edtax"].ToString();
                    string taxtype = dr["taxtype"].ToString();
                    string tax = dr["tax"].ToString();
                    string gst_exists = "0";
                }
                else
                {
                    double sgst_per = 0;
                    double.TryParse(dr["sgst"].ToString(), out sgst_per);
                    double cgst_per = 0;
                    double.TryParse(dr["cgst"].ToString(), out cgst_per);
                    double igst_per = 0;
                    double.TryParse(dr["igst"].ToString(), out igst_per);
                    string hsn_code = dr["HSNcode"].ToString();
                    string gst_exists = "1";
                    double quantity = 0;
                    double.TryParse(dr["quantity"].ToString(), out quantity);
                    double perunit = 0;
                    double.TryParse(dr["perunit"].ToString(), out perunit);
                   
                    string bebitledgername = "Purchase of Store Materials";
                    if (igst_per != 0)
                    {
                        bebitledgername = "Purchase of Store Materials-IGST " + igst_per + "%";
                        newrow1["LedgerName"] = bebitledgername;
                        double value = perunit * quantity;
                        newrow1["Amount"] = value;
                        newrow1["MrnNO"] = mrnnoo;
                        newrow1["MrnDate"] = dt_inw.ToString("dd/MM/yyyy");
                        newrow1["Narration"] = "";
                        Report.Rows.Add(newrow1);

                        DataRow newrow2 = Report.NewRow();
                        double igstvale = (value * igst_per) / 100;
                        newrow2["Sno"] = sno;
                        newrow2["LedgerName"] = "Input IGST " + igst_per + "%";
                        newrow2["Amount"] = igstvale;
                        newrow2["MrnNO"] = mrnnoo;
                        newrow2["MrnDate"] = dt_inw.ToString("dd/MM/yyyy");
                        newrow2["Narration"] = "";
                        Report.Rows.Add(newrow2);
                    }
                    else
                    {
                        double percent = cgst_per + sgst_per;
                        if (percent != 0)
                        {
                            bebitledgername = "Purchase of Store Materials-CGST/SGST " + percent + "%";
                            newrow1["Sno"] = sno;
                            newrow1["LedgerName"] = bebitledgername;
                            double value = perunit * quantity;
                            newrow1["Amount"] = value;

                            newrow1["MrnNO"] = mrnnoo;
                            newrow1["MrnDate"] = dt_inw.ToString("dd/MM/yyyy");
                            newrow1["Narration"] = "";
                            Report.Rows.Add(newrow1);

                            DataRow newrow2 = Report.NewRow();
                            double Cgstvale = (value * cgst_per) / 100;
                            double Sgstvale = (value * sgst_per) / 100;
                            newrow2["Sno"] = sno;
                            newrow2["LedgerName"] = "Input CGST " + cgst_per + "%";
                            newrow2["Amount"] = Cgstvale;
                            newrow2["MrnNO"] = mrnnoo;
                            newrow2["MrnDate"] = dt_inw.ToString("dd/MM/yyyy");
                            newrow2["Narration"] = "";
                            Report.Rows.Add(newrow2);

                            DataRow newrow3 = Report.NewRow();
                            newrow3["Sno"] = sno;
                            newrow3["LedgerName"] = "Input SGST " + sgst_per + "%";
                            newrow3["Amount"] = Sgstvale;
                            newrow3["MrnNO"] = mrnnoo;
                            newrow3["MrnDate"] = dt_inw.ToString("dd/MM/yyyy");
                            newrow3["Narration"] = "";
                            Report.Rows.Add(newrow3);
                        }
                        else
                        {
                            bebitledgername = "Purchase of Store Materials-Nil Tax";
                            newrow1["Sno"] = sno;
                            newrow1["LedgerName"] = bebitledgername;
                            double value = perunit * quantity;
                            newrow1["Amount"] = value;
                            newrow1["MrnNO"] = mrnnoo;
                            newrow1["MrnDate"] = dt_inw.ToString("dd/MM/yyyy");
                            newrow1["Narration"] = "";
                            Report.Rows.Add(newrow1);
                        }
                        
                    }
                }
            }
        }

        DataTable NewRpt = new DataTable();
        NewRpt.Columns.Add("Mrn NO");
        NewRpt.Columns.Add("Mrn Date");
        NewRpt.Columns.Add("Ledger Name");
        NewRpt.Columns.Add("Amount");
        NewRpt.Columns.Add("Narration");

        DataView viewrpt = new DataView(Report);
        //Sno	Mrn NO	Mrn Date	Ledger Name	Amount	Narration
        DataTable dtbind = viewrpt.ToTable(true, "Sno", "MrnNO", "MrnDate", "LedgerName", "Amount", "Narration");
        DataTable dtrpt = viewrpt.ToTable(true, "Sno", "LedgerName");
        if (dtrpt.Rows.Count > 0)
        {
            foreach (DataRow drr in dtrpt.Rows)
            {
                DataRow newrow = NewRpt.NewRow();
                string sno = drr["sno"].ToString();
                string ledger = drr["LedgerName"].ToString();
                newrow["Ledger Name"] = ledger;
                double famt = 0;
                string mrndate = "";
                string narration = "";
                string mrnno = "";
                foreach (DataRow dr in dtbind.Select("Sno='" + sno + "' AND LedgerName='" + ledger + "'"))
                {
                    string amt = dr["Amount"].ToString();
                    double addamt = Convert.ToDouble(amt);
                    famt += addamt;
                    mrndate = dr["MrnDate"].ToString();
                    narration = dr["Narration"].ToString();
                    mrnno = dr["MrnNO"].ToString();
                }
                newrow["Mrn NO"] = mrnno;
                newrow["Mrn Date"] = mrndate;
                newrow["Amount"] = famt;
                newrow["Narration"] = narration;
                NewRpt.Rows.Add(newrow);
            }
        }
        Session["xportdata"] = NewRpt;
        Session["filename"] = "Tally MRN Report";
        Session["Address"] = "";
        grdReports.DataSource = NewRpt;
        grdReports.DataBind();
        hidepanel.Visible = true;
    }

    //protected void btn_Generate_Click(object sender, EventArgs e)
    //{
    //    try
    //    {

    //        Report.Columns.Add("Sno");
    //        Report.Columns.Add("Mrn NO");
    //        Report.Columns.Add("JV Date");
    //        Report.Columns.Add("Ledger Name");
    //        Report.Columns.Add("Amount");
    //        Report.Columns.Add("TotalAmount");
    //        Report.Columns.Add("Narration");
    //        Report.Columns.Add("Discount");
    //        Report.Columns.Add("ED");
    //        Report.Columns.Add("Tax");
    //        Report.Columns.Add("EDType");
    //        Report.Columns.Add("TaxType");
    //        Report.Columns.Add("FrightAmt");
    //        Report.Columns.Add("TransportCharge");
    //        lblmsg.Text = "";
    //        SalesDBManager SalesDB = new SalesDBManager();
    //        DateTime fromdate = DateTime.Now;
    //        DateTime todate = DateTime.Now;
    //        string[] datestrig = dtp_FromDate.Text.Split(' ');
    //        if (datestrig.Length > 1)
    //        {
    //            if (datestrig[0].Split('-').Length > 0)
    //            {
    //                string[] dates = datestrig[0].Split('-');
    //                string[] times = datestrig[1].Split(':');
    //                fromdate = new DateTime(int.Parse(dates[2]), int.Parse(dates[1]), int.Parse(dates[0]), int.Parse(times[0]), int.Parse(times[1]), 0);
    //            }
    //        }
    //        datestrig = dtp_Todate.Text.Split(' ');
    //        if (datestrig.Length > 1)
    //        {
    //            if (datestrig[0].Split('-').Length > 0)
    //            {
    //                string[] dates = datestrig[0].Split('-');
    //                string[] times = datestrig[1].Split(':');
    //                todate = new DateTime(int.Parse(dates[2]), int.Parse(dates[1]), int.Parse(dates[0]), int.Parse(times[0]), int.Parse(times[1]), 0);
    //            }
    //        }
    //        lblFromDate.Text = fromdate.ToString("MM/dd/yyyy");
    //        lbltodate.Text = todate.ToString("MM/dd/yyyy");
    //        string branchid = Session["Po_BranchID"].ToString();
    //        cmd = new SqlCommand("SELECT  inwarddetails.invoicedate, inwarddetails.freigtamt, inwarddetails.invoiceno, inwarddetails.remarks, inwarddetails.mrnno, inwarddetails.sno AS inwardsno,inwarddetails.inwarddate, inwarddetails.invoiceno AS Expr1, inwarddetails.podate, inwarddetails.doorno, inwarddetails.remarks AS Expr2, inwarddetails.pono,inwarddetails.inwardno, suppliersdetails.name, subinwarddetails.quantity, subinwarddetails.perunit, productmaster.productname, productmaster.sku,taxmaster.type AS taxtype, taxmaster_1.type AS edtype, subinwarddetails.tax, subinwarddetails.disamt, subinwarddetails.dis, subinwarddetails.taxtype AS taxtypeid,subinwarddetails.edtax AS ed, inwarddetails.transportcharge FROM inwarddetails INNER JOIN subinwarddetails ON inwarddetails.sno = subinwarddetails.in_refno INNER JOIN productmaster ON productmaster.productid = subinwarddetails.productid INNER JOIN suppliersdetails ON suppliersdetails.supplierid = inwarddetails.supplierid LEFT OUTER JOIN taxmaster AS taxmaster_1 ON subinwarddetails.ed = taxmaster_1.sno LEFT OUTER JOIN taxmaster ON subinwarddetails.taxtype = taxmaster.sno WHERE  (inwarddetails.inwarddate BETWEEN @fromdate AND @todate) AND (inwarddetails.branchid = @branchid) AND (subinwarddetails.quantity > 0)   ORDER BY inwardsno");
    //        cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
    //        cmd.Parameters.Add("@todate", GetHighDate(todate));
    //        cmd.Parameters.Add("@branchid", branchid);
    //        DataTable dttotalinward = vdm.SelectQuery(cmd).Tables[0];
    //        if (dttotalinward.Rows.Count > 0)
    //        {
    //            double totaldiscount = 0;
    //            double totalqty = 0;
    //            double ttotalamount = 0;
    //            double gtotalamount = 0;
    //            double totalprice = 0;
    //            double toatlpq = 0;
    //            double totalpriceqty = 0;
    //            double edamount = 0;
    //            double totaledamt = 0;
    //            double gtotaledamt = 0;
    //            double tcsttax = 0;
    //            double tfreight = 0;
    //            double tedamount = 0;
    //            double totamount = 0;
    //            DateTime dt = DateTime.Now;
    //            string prevdate = string.Empty;
    //            string prevpono = "";
    //            int i = 1;
    //            int count = 1;
    //            int rowcount = 1;
    //            foreach (DataRow dr in dttotalinward.Rows)
    //            {
    //                string prespono = dr["inwardsno"].ToString();
    //                DateTime dtdoe = Convert.ToDateTime(dr["inwarddate"].ToString());
    //                string currentdate = dtdoe.ToString("MM/dd/yyyy");
    //                i++;
    //                if (prespono == prevpono)
    //                {
    //                    double price = 0;
    //                    double.TryParse(dr["perunit"].ToString(), out price);
    //                    totalprice += price;
    //                    double qty = 0;
    //                    double.TryParse(dr["quantity"].ToString(), out qty);
    //                    totalqty += qty;
    //                    double toatlpq1 = 0;
    //                    toatlpq = qty * price;
    //                    double dis = 0;
    //                    double.TryParse(dr["disamt"].ToString(), out dis);
    //                    totaldiscount += dis;
    //                    toatlpq1 = toatlpq - dis;
    //                    totalpriceqty += toatlpq1;
    //                    double edamt = 0;
    //                    double.TryParse(dr["ed"].ToString(), out edamt);
    //                    totaledamt += edamt;
    //                    gtotaledamt += totaledamt;
    //                    edamount = (toatlpq1 * edamt) / 100;
    //                    tedamount += edamount;
    //                    double totedamount = 0;
    //                    totedamount = toatlpq1 + edamount;//stock
    //                    totamount += totedamount;
    //                    double csttax = 0;
    //                    double.TryParse(dr["tax"].ToString(), out csttax);
    //                    double csttaxamt = 0;
    //                    csttaxamt = (totedamount * csttax) / 100;
    //                    tcsttax += csttaxamt;
    //                    double totalamount = 0;
    //                    totalamount = totedamount + csttaxamt;//grand total in that coming
    //                    ttotalamount += totalamount;
    //                    rowcount++;
    //                    DataTable dtin = new DataTable();
    //                    DataRow[] drr = dttotalinward.Select("inwardsno='" + prespono + "'");
    //                    if (drr.Length > 0)
    //                    {
    //                        dtin = drr.CopyToDataTable();
    //                    }
    //                    int dttotalpocount = dtin.Rows.Count;
    //                    if (dttotalpocount == rowcount)
    //                    {
    //                        DataRow newrow1 = Report.NewRow();
    //                        ttotalamount = Math.Round(ttotalamount, 2);
    //                        newrow1["JV Date"] = currentdate;
    //                        newrow1["Mrn No"] = dr["mrnno"].ToString();
    //                        newrow1["Ledger Name"] = dr["name"].ToString();
    //                        string remarks = dr["remarks"].ToString();
    //                        string amount = ttotalamount.ToString();
    //                        string invoice = dr["invoiceno"].ToString();
    //                        string invoicdate = dr["invoicedate"].ToString();
    //                        DateTime Invoice = Convert.ToDateTime(invoicdate);
    //                        string Invoicdate = Invoice.ToString("MM/dd/yyyy");
    //                        string mrndate1 = dr["inwarddate"].ToString();
    //                        DateTime mrndate2 = Convert.ToDateTime(mrndate1);
    //                        string mrndate = mrndate2.ToString("MM/dd/yyyy");
    //                        string MRNNO = dr["mrnno"].ToString();
    //                        string productlist = "", total_amount;
    //                        double tot_amt = 0, tot_amount = 0;
    //                        cmd = new SqlCommand("SELECT productmaster.productname, subinwarddetails.quantity, subinwarddetails.perunit FROM inwarddetails INNER JOIN subinwarddetails ON inwarddetails.sno = subinwarddetails.in_refno INNER JOIN productmaster ON subinwarddetails.productid = productmaster.productid WHERE (inwarddetails.mrnno = @mrn)");
    //                        cmd.Parameters.Add("@mrn", MRNNO);
    //                        DataTable dtproducts = vdm.SelectQuery(cmd).Tables[0];
    //                        foreach (DataRow dtp in dtproducts.Rows)
    //                        {
    //                            string prod_qty = dtp["quantity"].ToString();
    //                            string perunit = dtp["perunit"].ToString();
    //                            tot_amt = (Convert.ToDouble(prod_qty) * Convert.ToDouble(perunit));
    //                            tot_amount += tot_amt;
    //                            productlist += dtp["productname"].ToString() + " " + tot_amt.ToString() + "/-, ";
    //                        }
    //                        string suppliername = dr["name"].ToString();
    //                        newrow1["Discount"] = totaldiscount.ToString("f2");
    //                        newrow1["ED"] = tedamount.ToString();
    //                        newrow1["Tax"] = tcsttax.ToString();
    //                        newrow1["EDType"] = dr["edtype"].ToString(); ;
    //                        newrow1["TaxType"] = dr["taxtype"].ToString();
    //                        double frigh = 0;
    //                        double.TryParse(dr["freigtamt"].ToString(), out frigh);
    //                        double tramount = 0;
    //                        double.TryParse(dr["transportcharge"].ToString(), out tramount);
    //                        if (tramount.ToString() != "" || tramount.ToString() != "0")
    //                        {
    //                            productlist += " Transport " + tramount.ToString() + "/-";
    //                        }
    //                        else if (frigh.ToString() != "" || frigh.ToString() != "0")
    //                        {
    //                            productlist += " Transport " + frigh.ToString() + "/-";
    //                        }
    //                        total_amount = tot_amount.ToString();
    //                        productlist += " Total Amount " + amount + "/-";

    //                        if (frigh != 0)
    //                        {
    //                            newrow1["FrightAmt"] = Convert.ToDouble(dr["freigtamt"].ToString()).ToString("f2");//"-" + "FreightCharges" + "-" + "" + dr["freigtamt"].ToString() +
    //                            if (branchid == "4" || branchid == "35")
    //                            {
    //                                newrow1["Narration"] = "Being PurchasingMaterials" + remarks + "," + "From" + suppliername + ",Invoice No: " + invoice + ",Inv Dt" + Invoicdate + ",Amount" + amount + ",MRNJV" + MRNNO + ",Dt:" + mrndate + "";
    //                            }
    //                            else
    //                            {
    //                                newrow1["Narration"] = "Being PurchasingMaterials " + productlist + " , " + "From " + suppliername + ",Invoice No: " + invoice + ",Inv Dt: " + Invoicdate + ",MRNJV" + MRNNO + ",Dt:" + mrndate + "";
    //                            }
    //                        }
    //                        if (tramount != 0)
    //                        {
    //                            newrow1["TransportCharge"] = Convert.ToDouble(dr["transportcharge"].ToString()).ToString("f2");//"-" + "TransportCharges" + "-" + "" + dr["transportcharge"].ToString() +
    //                            if (branchid == "4" || branchid == "35")
    //                            {
    //                                newrow1["Narration"] = "Being PurchasingMaterials" + remarks + "," + "From" + suppliername + ",Invoice No: " + invoice + ",Inv Dt" + Invoicdate + ",Amount" + amount + ",MRNJV" + MRNNO + ",Dt:" + mrndate + "";
    //                            }
    //                            else
    //                            {
    //                                newrow1["Narration"] = "Being PurchasingMaterials " + productlist + " , " + "From " + suppliername + ",Invoice No: " + invoice + ",Inv Dt: " + Invoicdate + ",MRNJV" + MRNNO + ",Dt:" + mrndate + "";
    //                            }
    //                        }
    //                        if (dr["taxtype"].ToString() != "Input VAT @0%")
    //                        {
    //                            if (branchid == "4" || branchid == "35")
    //                            {
    //                                newrow1["Narration"] = "Being PurchasingMaterials" + remarks + "," + "From" + suppliername + ",Invoice No: " + invoice + ",Inv Dt" + Invoicdate + ",Amount" + amount + ",MRNJV" + MRNNO + ",Dt:" + mrndate + "";
    //                            }
    //                            else
    //                            {
    //                                newrow1["Narration"] = "Being PurchasingMaterials " + productlist + " , " + "From " + suppliername + ",Invoice No: " + invoice + ",Inv Dt: " + Invoicdate + ",MRNJV" + MRNNO + ",Dt:" + mrndate + "";
    //                            }
    //                        }
    //                        if (frigh == 0 && tramount == 0 && dr["taxtype"].ToString() == "Input VAT @0%")
    //                        {
    //                            if (branchid == "4" || branchid == "35")
    //                            {
    //                                newrow1["Narration"] = "Being PurchasingMaterials" + remarks + "," + "From" + suppliername + ",Invoice No: " + invoice + ",Inv Dt" + Invoicdate + ",Amount" + amount + ",MRNJV" + MRNNO + ",Dt:" + mrndate + "";
    //                            }
    //                            else
    //                            {
    //                                newrow1["Narration"] = "Being PurchasingMaterials " + productlist + " , " + "From " + suppliername + ",Invoice No: " + invoice + ",Inv Dt: " + Invoicdate + ",MRNJV" + MRNNO + ",Dt:" + mrndate + "";
    //                            }
    //                        }
    //                        newrow1["Amount"] = totamount.ToString("f2");
    //                        newrow1["TotalAmount"] = ttotalamount.ToString("f2");
    //                        newrow1["Sno"] = "Total";
    //                        Report.Rows.Add(newrow1);
    //                        gtotalamount += ttotalamount;
    //                        ttotalamount = 0;
    //                        totalqty = 0;
    //                        tedamount = 0;
    //                        totamount = 0;
    //                        tcsttax = 0;
    //                        tfreight = 0;
    //                        rowcount = 1;
    //                    }
    //                }
    //                else
    //                {
    //                    prevpono = prespono;
    //                    double price = 0;
    //                    double.TryParse(dr["perunit"].ToString(), out price);
    //                    totalprice += price;
    //                    double qty = 0;
    //                    double.TryParse(dr["quantity"].ToString(), out qty);
    //                    totalqty += qty;
    //                    double toatlpq1 = 0;
    //                    toatlpq = qty * price;
    //                    double dis = 0;
    //                    double.TryParse(dr["disamt"].ToString(), out dis);
    //                    totaldiscount += dis;
    //                    toatlpq1 = toatlpq - dis;
    //                    totalpriceqty += toatlpq1;
    //                    double edamt = 0;
    //                    double.TryParse(dr["ed"].ToString(), out edamt);
    //                    totaledamt += edamt;
    //                    gtotaledamt += totaledamt;
    //                    edamount = (toatlpq1 * edamt) / 100;
    //                    tedamount += edamount;
    //                    double totedamount = 0;
    //                    totedamount = toatlpq1 + edamount;//stock
    //                    totamount += totedamount;// totalpriceqty + edamount;//stock
    //                    double csttax = 0;
    //                    double.TryParse(dr["tax"].ToString(), out csttax);
    //                    double csttaxamt = 0;
    //                    csttaxamt = (totedamount * csttax) / 100;
    //                    tcsttax += csttaxamt;
    //                    double freight = 0;
    //                    double.TryParse(dr["freigtamt"].ToString(), out freight);
    //                    tfreight += freight;
    //                    double transport = 0;
    //                    double.TryParse(dr["transportcharge"].ToString(), out transport);
    //                    double totalamount = 0;
    //                    totalamount = totedamount + csttaxamt + freight + transport; ;//grand total in that coming
    //                    ttotalamount += totalamount;
    //                    DataTable dtin = new DataTable();
    //                    DataRow[] drr = dttotalinward.Select("inwardsno='" + prespono + "'");
    //                    if (drr.Length > 0)
    //                    {
    //                        dtin = drr.CopyToDataTable();
    //                    }
    //                    int dttotalpocount = dtin.Rows.Count;
    //                    if (dttotalpocount > 1)
    //                    {
    //                        //rowcount++;
    //                    }
    //                    else
    //                    {
    //                        DataRow newrow1 = Report.NewRow();
    //                        ttotalamount = Math.Round(ttotalamount, 2);
    //                        newrow1["JV Date"] = currentdate;
    //                        newrow1["Mrn No"] = dr["mrnno"].ToString();
    //                        newrow1["Ledger Name"] = dr["name"].ToString();
    //                        string remarks = dr["remarks"].ToString();
    //                        string amount = ttotalamount.ToString();
    //                        string invoice = dr["invoiceno"].ToString();
    //                        string invoicdate = dr["invoicedate"].ToString();
    //                        DateTime Invoice = Convert.ToDateTime(invoicdate);
    //                        string Invoicdate = Invoice.ToString("MM/dd/yyyy");
    //                        string mrndate1 = dr["inwarddate"].ToString();
    //                        DateTime mrndate2 = Convert.ToDateTime(mrndate1);
    //                        string mrndate = mrndate2.ToString("MM/dd/yyyy");
    //                        string MRNNO = dr["mrnno"].ToString();
    //                        string productlist = "", total_amount;
    //                        double tot_amt = 0, tot_amount = 0;
    //                        cmd = new SqlCommand("SELECT productmaster.productname, subinwarddetails.quantity, subinwarddetails.perunit FROM inwarddetails INNER JOIN subinwarddetails ON inwarddetails.sno = subinwarddetails.in_refno INNER JOIN productmaster ON subinwarddetails.productid = productmaster.productid WHERE (inwarddetails.mrnno = @mrn)");
    //                        cmd.Parameters.Add("@mrn", MRNNO);
    //                        DataTable dtproducts = vdm.SelectQuery(cmd).Tables[0];
    //                        foreach (DataRow dtp in dtproducts.Rows)
    //                        {
    //                            string prod_qty = dtp["quantity"].ToString();
    //                            string perunit = dtp["perunit"].ToString();
    //                            tot_amt = (Convert.ToDouble(prod_qty) * Convert.ToDouble(perunit));
    //                            tot_amount += tot_amt;
    //                            productlist += dtp["productname"].ToString() + " " + tot_amt.ToString() + "/-, ";
    //                        }
    //                        //total_amount = tot_amount.ToString();
    //                        //productlist += " Total Amount " + total_amount + "/-";
    //                        string suppliername = dr["name"].ToString();
    //                        newrow1["Discount"] = totaldiscount.ToString("f2");
    //                        newrow1["ED"] = tedamount.ToString();
    //                        newrow1["Tax"] = tcsttax.ToString();
    //                        newrow1["EDType"] = dr["edtype"].ToString(); ;
    //                        newrow1["TaxType"] = dr["taxtype"].ToString();
    //                        double frigh = 0;
    //                        double.TryParse(dr["freigtamt"].ToString(), out frigh);
    //                        double tramount = 0;
    //                        double.TryParse(dr["transportcharge"].ToString(), out tramount);
    //                        if (tramount.ToString() != "" || tramount.ToString() != "0")
    //                        {
    //                            productlist += " Transport " + tramount.ToString() + "/-";
    //                        }
    //                        else if (frigh.ToString() != "" || frigh.ToString() != "0")
    //                        {
    //                            productlist += " Transport " + frigh.ToString() + "/-";
    //                        }
    //                        total_amount = tot_amount.ToString();
    //                        productlist += " Total Amount " + amount + "/-";
    //                        if (frigh != 0)
    //                        {
    //                            newrow1["FrightAmt"] = Convert.ToDouble(dr["freigtamt"].ToString()).ToString("f2");//"-" + "FreightCharges" + "-" + "" + dr["freigtamt"].ToString() +
    //                            if (branchid == "4" || branchid == "35")
    //                            {
    //                                newrow1["Narration"] = "Being PurchasingMaterials" + remarks + "," + "From" + suppliername + ",Invoice No: " + invoice + ",Inv Dt" + Invoicdate + ",Amount" + amount + ",MRNJV" + MRNNO + ",Dt:" + mrndate + "";
    //                            }
    //                            else
    //                            {
    //                                newrow1["Narration"] = "Being PurchasingMaterials " + productlist + " , " + "From " + suppliername + ",Invoice No: " + invoice + ",Inv Dt: " + Invoicdate + ",MRNJV" + MRNNO + ",Dt:" + mrndate + "";
    //                            }
    //                        }
    //                        if (tramount != 0)
    //                        {
    //                            newrow1["TransportCharge"] = Convert.ToDouble(dr["transportcharge"].ToString()).ToString("f2");//"-" + "TransportCharges" + "-" + "" + dr["transportcharge"].ToString() +
    //                            if (branchid == "4" || branchid == "35")
    //                            {
    //                                newrow1["Narration"] = "Being PurchasingMaterials" + remarks + "," + "From" + suppliername + ",Invoice No: " + invoice + ",Inv Dt" + Invoicdate + ",Amount" + amount + ",MRNJV" + MRNNO + ",Dt:" + mrndate + "";
    //                            }
    //                            else
    //                            {
    //                                newrow1["Narration"] = "Being PurchasingMaterials " + productlist + " , " + "From " + suppliername + ",Invoice No: " + invoice + ",Inv Dt: " + Invoicdate + ",MRNJV" + MRNNO + ",Dt:" + mrndate + "";
    //                            }
    //                        }
    //                        if (dr["taxtype"].ToString() != "Input VAT @0%")
    //                        {
    //                            //newrow1["Narration"] = "Being PurchasingMaterials" + remarks +  "," + "From" + suppliername + ",Invoice No: " + invoice + ",Inv Dt" + Invoicdate + ",Amount" + amount + ",MRNJV" + MRNNO + ",Dt:" + mrndate + ""; ;
    //                            if (branchid == "4" || branchid == "35")
    //                            {
    //                                newrow1["Narration"] = "Being PurchasingMaterials" + remarks + "," + "From" + suppliername + ",Invoice No: " + invoice + ",Inv Dt" + Invoicdate + ",Amount" + amount + ",MRNJV" + MRNNO + ",Dt:" + mrndate + "";
    //                            }
    //                            else
    //                            {
    //                                newrow1["Narration"] = "Being PurchasingMaterials " + productlist + " , " + "From " + suppliername + ",Invoice No: " + invoice + ",Inv Dt: " + Invoicdate + ",MRNJV" + MRNNO + ",Dt:" + mrndate + "";
    //                            }
    //                        }
    //                        if (frigh == 0 && tramount == 0 && dr["taxtype"].ToString() == "Input VAT @0%")
    //                        {
    //                            //newrow1["Narration"] = "Being PurchasingMaterials" + remarks + "," + "From" + suppliername + ",Invoice No: " + invoice + ",Inv Dt" + Invoicdate + ",Amount" + amount + ",MRNJV" + MRNNO + ",Dt:" + mrndate + ""; ;
    //                            if (branchid == "4" || branchid == "35")
    //                            {
    //                                newrow1["Narration"] = "Being PurchasingMaterials" + remarks + "," + "From" + suppliername + ",Invoice No: " + invoice + ",Inv Dt" + Invoicdate + ",Amount" + amount + ",MRNJV" + MRNNO + ",Dt:" + mrndate + "";
    //                            }
    //                            else
    //                            {
    //                                newrow1["Narration"] = "Being PurchasingMaterials " + productlist + " , " + "From " + suppliername + ",Invoice No: " + invoice + ",Inv Dt: " + Invoicdate + ",MRNJV" + MRNNO + ",Dt:" + mrndate + "";
    //                            }
    //                        }
    //                        newrow1["Amount"] = totamount.ToString("f2");
    //                        newrow1["TotalAmount"] = ttotalamount.ToString("f2");
    //                        newrow1["Sno"] = "Total";
    //                        Report.Rows.Add(newrow1);
    //                        gtotalamount += ttotalamount;
    //                        ttotalamount = 0;
    //                        totalqty = 0;
    //                        tcsttax = 0;
    //                        tfreight = 0;
    //                        tedamount = 0;
    //                        totamount = 0;
    //                        count++;
    //                        rowcount = 1;
    //                    }
    //                    //}s
    //                }
    //            }
    //            DataTable newdatatable = new DataTable();
    //            newdatatable.Columns.Add("Mrn NO");
    //            newdatatable.Columns.Add("JV Date");
    //            newdatatable.Columns.Add("Ledger Name");
    //            newdatatable.Columns.Add("Amount");
    //            newdatatable.Columns.Add("Narration");
    //            string credit = "Total";
    //            string bcode = Session["BranchCode"].ToString();
    //            foreach (DataRow drrepo in Report.Select("Sno='" + credit + "'"))
    //            {
    //                DataRow reportnewrow1 = newdatatable.NewRow();
    //                double TOTALA = Convert.ToDouble(drrepo["TotalAmount"].ToString());
    //                reportnewrow1["Mrn NO"] = "" + bcode + "MRNJV" + drrepo["Mrn NO"].ToString() + "";
    //                reportnewrow1["JV Date"] = drrepo["JV Date"].ToString();
    //                reportnewrow1["Ledger Name"] = drrepo["Ledger Name"].ToString() + "";
    //                reportnewrow1["Amount"] = "-" + Math.Round(TOTALA, 0);
    //                reportnewrow1["Narration"] = drrepo["Narration"].ToString();
    //                newdatatable.Rows.Add(reportnewrow1);
    //                string ttax = drrepo["Tax"].ToString();
    //                double ttax1 = 0;
    //                double.TryParse(ttax, out ttax1);
    //                string eed = drrepo["ED"].ToString();
    //                double eedtax = 0;
    //                double.TryParse(eed, out eedtax);
    //                string fri = drrepo["FrightAmt"].ToString();
    //                double frig = 0;
    //                double.TryParse(fri, out frig);
    //                string trans = drrepo["TransportCharge"].ToString();
    //                double tramt = 0;
    //                double.TryParse(trans, out tramt);
    //                if (frig != 0 || eedtax != 0 || ttax1 != 0 || tramt != 0)
    //                {
    //                    DataRow reportnewrow2 = newdatatable.NewRow();

    //                    reportnewrow2["Mrn NO"] = "" + bcode + "MRNJV" + drrepo["Mrn NO"].ToString() + "";
    //                    reportnewrow2["JV Date"] = drrepo["JV Date"].ToString();
    //                    reportnewrow2["Ledger Name"] = Session["branchledgername"].ToString();
    //                    double TAA = Convert.ToDouble(drrepo["Amount"].ToString());
    //                    reportnewrow2["Amount"] = Math.Round(TAA, 0);
    //                    newdatatable.Rows.Add(reportnewrow2);
    //                }
    //                else
    //                {
    //                    DataRow reportnewrow2 = newdatatable.NewRow();
    //                    reportnewrow2["Mrn NO"] = "" + bcode + "MRNJV" + drrepo["Mrn NO"].ToString() + "";
    //                    reportnewrow2["JV Date"] = drrepo["JV Date"].ToString();
    //                    reportnewrow2["Ledger Name"] = Session["branchledgername"].ToString();
    //                    // reportnewrow2["Ledger Name"] = "Stock of Stores & Spares - Punabaka";
    //                    double TA = Convert.ToDouble(drrepo["TotalAmount"].ToString());
    //                    reportnewrow2["Amount"] = Math.Round(TA, 0);
    //                    newdatatable.Rows.Add(reportnewrow2);
    //                }
    //                if (frig != 0)
    //                {
    //                    DataRow reportnewrow3 = newdatatable.NewRow();
    //                    reportnewrow3["Mrn NO"] = "" + bcode + "MRNJV" + drrepo["Mrn NO"].ToString() + "";
    //                    reportnewrow3["JV Date"] = drrepo["JV Date"].ToString();
    //                    reportnewrow3["Amount"] = Math.Round(frig, 0);
    //                    reportnewrow3["Ledger Name"] = "FreightCharges";
    //                    newdatatable.Rows.Add(reportnewrow3);
    //                }
    //                if (ttax1 != 0)
    //                {
    //                    DataRow reportnewrow4 = newdatatable.NewRow();
    //                    reportnewrow4["Mrn NO"] = "" + bcode + "MRNJV" + drrepo["Mrn NO"].ToString() + "";
    //                    reportnewrow4["JV Date"] = drrepo["JV Date"].ToString();
    //                    reportnewrow4["Ledger Name"] = drrepo["taxtype"].ToString() + "";
    //                    reportnewrow4["Amount"] = Math.Round(ttax1, 0);
    //                    // reportnewrow4["Narration"] = drrepo["Narration"].ToString() + "_" + drrepo["taxtype"].ToString() + "";
    //                    newdatatable.Rows.Add(reportnewrow4);
    //                }
    //                if (tramt != 0)
    //                {
    //                    DataRow reportnewrow5 = newdatatable.NewRow();
    //                    reportnewrow5["Mrn NO"] = "" + bcode + "MRNJV" + drrepo["Mrn NO"].ToString() + "";
    //                    reportnewrow5["JV Date"] = drrepo["JV Date"].ToString();
    //                    reportnewrow5["Ledger Name"] = "Transportation Charges-Pbk";
    //                    reportnewrow5["Amount"] = Math.Round(tramt, 0);
    //                    //reportnewrow5["Narration"] = "TransportCharges" + "tramt " + drrepo["Narration"].ToString(); ;
    //                    newdatatable.Rows.Add(reportnewrow5);
    //                }
    //            }
    //            Session["xportdata"] = newdatatable;
    //            Session["filename"] = "Tally MRN Report";
    //            Session["Address"] = "";
    //            grdReports.DataSource = newdatatable;
    //            grdReports.DataBind();
    //            hidepanel.Visible = true;
    //        }
    //        else
    //        {
    //            lblmsg.Text = "No data were found";
    //            hidepanel.Visible = false;
    //        }
    //    }
    //    catch (Exception ex)
    //    {
    //        lblmsg.Text = ex.Message;
    //        hidepanel.Visible = false;
    //    }
    //}
}