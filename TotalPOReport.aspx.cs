using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

public partial class TotalPOReport : System.Web.UI.Page
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
            Report.Columns.Add("Sno");
            Report.Columns.Add("PO Date");
            Report.Columns.Add("PO No");
            Report.Columns.Add("Supplier Name");
            Report.Columns.Add("Product Name");
            Report.Columns.Add("Quantity");
            Report.Columns.Add("Price");
            Report.Columns.Add("CST Value");
            Report.Columns.Add("ED Value");
            Report.Columns.Add("PandF");
            Report.Columns.Add("Discount");
            Report.Columns.Add("SGST");
            Report.Columns.Add("CGST");
            Report.Columns.Add("IGST");
            Report.Columns.Add("Reverse Charge");
            Report.Columns.Add("Fright Amount");
            Report.Columns.Add("Total Amount");
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
            string julydt = "07/01/2017";
            DateTime gst_dt = Convert.ToDateTime(julydt);
            cmd = new SqlCommand("SELECT po_entrydetailes.reversecharge,po_sub_detailes.sgst,po_sub_detailes.cgst,po_sub_detailes.igst,pandf.pandf AS pf,po_sub_detailes.edtax,po_sub_detailes.description,po_entrydetailes.code,po_entrydetailes.ponumber,po_entrydetailes.podate as Purchasedate, po_entrydetailes.podate, po_entrydetailes.poamount, po_entrydetailes.name, po_entrydetailes.freigtamt, po_entrydetailes.vattin, po_entrydetailes.sno, po_sub_detailes.free,po_sub_detailes.cost,po_sub_detailes.qty, po_sub_detailes.taxtype, po_sub_detailes.ed, po_sub_detailes.dis, po_sub_detailes.disamt, po_sub_detailes.po_refno, po_sub_detailes.tax  FROM po_entrydetailes INNER JOIN po_sub_detailes ON po_entrydetailes.sno = po_sub_detailes.po_refno INNER JOIN suppliersdetails ON po_entrydetailes.supplierid = suppliersdetails.supplierid INNER JOIN productmaster ON po_sub_detailes.productsno=productmaster.productid  LEFT OUTER JOIN pandf ON pandf.sno=po_entrydetailes.pfid     where  (po_entrydetailes.podate between @fromdate and @todate) AND (po_entrydetailes.branchid=@branchid) order by po_entrydetailes.sno");//CONVERT(VARCHAR(20),po_entrydetailes.podate, 103) AS podate
            cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
            cmd.Parameters.Add("@todate", GetHighDate(todate));
            cmd.Parameters.Add("@branchid", branchid);
            DataTable dttotalpo = SalesDB.SelectQuery(cmd).Tables[0];
            if (dttotalpo.Rows.Count > 0)
            {
                double totaldiscount = 0;
                double totalqty = 0;
                double gtotalqty = 0;
                double gtotaldiscount = 0;
                double ttotalamount = 0;
                double gtotalamount = 0;
                double totalprice = 0;
                double toatlpq = 0;
                double totalpriceqty = 0;
                double edamount = 0;
                double pfamount = 0;
                double tpfamount = 0;
                double totaledamt = 0;
                double gtotaledamt = 0;
                double tcsttax = 0;
                double tfreight = 0;
                double totalsgst = 0;
                double grandsgst = 0;
                double totalcgst = 0;
                double grandcgst = 0;
                double totaligst = 0;
                double grandigst = 0;
                DateTime dt = DateTime.Now;
                string prevdate = string.Empty;
                string prevpono = "";
                var i = 1;
                int count = 1;
                int rowcount = 1;
                double tedamount = 0;
                double gedamount = 0;
                double gcsttax = 0;
                double gpfamount = 0;
                double gfright = 0;
                DateTime dtapril = new DateTime();
                DateTime dtmarch = new DateTime();
                foreach (DataRow dr in dttotalpo.Rows)
                {
                    DataRow newrow = Report.NewRow();
                    newrow["Sno"] = i++.ToString();
                    string prespono = dr["sno"].ToString();
                    string date = dr["podate"].ToString();
                    string date_po = ((DateTime)dr["podate"]).ToString("dd-MM-yyyy");
                    string podate1 = ((DateTime)dr["podate"]).ToString();
                    //string podate1 = "7/17/2017 12:00:00 AM";
                    DateTime podate = Convert.ToDateTime(podate1);
                    if (prespono == prevpono)
                    {
                        double sgstper = 0, cgstper = 0, igstper = 0;
                        double sgstamt = 0, cgstamt = 0, igstamt = 0;
                        double csttaxamt = 0;
                        newrow["Product Name"] = dr["description"].ToString();
                        double price = 0;
                        double.TryParse(dr["cost"].ToString(), out price);
                        totalprice += price;
                        double cost = Convert.ToDouble(dr["cost"].ToString());
                        newrow["Price"] = cost.ToString("f2");
                        double qty = 0;
                        double.TryParse(dr["qty"].ToString(), out qty);
                        totalqty += qty;
                        newrow["Quantity"] = dr["qty"].ToString();
                        double toatlpq1 = 0;
                        toatlpq1 = qty * price;
                        double dis = 0;
                        double.TryParse(dr["disamt"].ToString(), out dis);
                        totaldiscount += dis;
                        toatlpq = toatlpq1 - dis;
                        newrow["Discount"] = dis.ToString("f2");
                        totalpriceqty += toatlpq;
                        double totamount = 0;
                        double pfamt = 0;
                        double.TryParse(dr["pf"].ToString(), out pfamt);
                        pfamount = (toatlpq * pfamt) / 100;
                        newrow["PandF"] = pfamount.ToString("f2");
                        tpfamount += pfamount;
                        double totalamount = 0;
                        if (podate < gst_dt)
                        {
                            double edamt = 0;
                            double.TryParse(dr["edtax"].ToString(), out edamt);
                            totaledamt += edamt;
                            gtotaledamt += totaledamt;
                            edamount = (toatlpq * edamt) / 100;
                            newrow["ED Value"] = edamount.ToString("f2");
                            tedamount += edamount;
                            totamount += toatlpq + edamount + pfamount;
                            double csttax = 0;
                            double.TryParse(dr["tax"].ToString(), out csttax);
                            csttaxamt = (totamount * csttax) / 100;
                            newrow["CST Value"] = csttaxamt.ToString("f2");
                            tcsttax += csttaxamt;
                            double freight = 0;
                            totalamount = totamount + csttaxamt + freight;//grand total in that coming
                            sgstamt = 0;
                            newrow["SGST"] = "0.00";
                            totalsgst += sgstamt;
                            cgstamt = 0;
                            newrow["CGST"] = "0.00";
                            totalcgst += cgstamt;
                            igstamt = 0;
                            newrow["IGST"] = "0.00";
                            totaligst += igstamt;
                            newrow["Reverse Charge"] = "0.00";
                        }
                        else {
                            
                            double.TryParse(dr["sgst"].ToString(), out sgstper);
                            sgstamt = ((toatlpq + pfamount) * sgstper) / 100;
                            totalsgst += sgstamt;
                            double.TryParse(dr["cgst"].ToString(), out cgstper);
                            cgstamt = ((toatlpq + pfamount) * cgstper) / 100;
                            totalcgst += cgstamt;
                            double.TryParse(dr["igst"].ToString(), out igstper);
                            igstamt = ((toatlpq + pfamount) * igstper) / 100;
                            totaligst += igstamt;
                            newrow["SGST"] = sgstamt.ToString("f2");
                            newrow["CGST"] = cgstamt.ToString("f2");
                            newrow["IGST"] = igstamt.ToString("f2");
                            if (dr["reversecharge"].ToString() == "N")
                            {
                                totalamount = toatlpq + pfamount + sgstamt + cgstamt + igstamt;
                                newrow["Reverse Charge"] = "0.00";
                            }
                            else
                            {
                                totalamount = toatlpq + pfamount;
                                double rev_chrg = sgstamt + cgstamt + igstamt;
                                newrow["Reverse Charge"] = rev_chrg.ToString("f2");
                            }
                            //totalamount = toatlpq + pfamount + sgstamt + cgstamt + igstamt;
                            edamount = 0;
                            newrow["ED Value"] = edamount.ToString("f2");
                            tedamount += edamount;
                            csttaxamt = 0;
                            newrow["CST Value"] = "0.00";
                            tcsttax += csttaxamt;
                        }
                        newrow["Total Amount"] = totalamount.ToString("f2");
                        ttotalamount += totalamount;
                        Report.Rows.Add(newrow);
                        rowcount++;
                        DataTable dtin = new DataTable();
                        DataRow[] drr = dttotalpo.Select("sno='" + prespono + "'");
                        if (drr.Length > 0)
                        {
                            dtin = drr.CopyToDataTable();
                         }
                        int dttotalpocount = dtin.Rows.Count;
                        if (dttotalpocount == rowcount)
                        {
                            DataRow newrow1 = Report.NewRow();
                            newrow1["Product Name"] = "Total";
                            totalqty = Math.Round(totalqty, 2);
                            newrow1["Quantity"] = totalqty;
                            double tot_dis = Math.Round(totaldiscount, 2);
                            newrow1["Discount"] = tot_dis.ToString("f2");
                            tcsttax = Math.Round(tcsttax, 2);
                            newrow1["CST Value"] = tcsttax.ToString("f2");
                            tpfamount = Math.Round(tpfamount, 2);
                            newrow1["PandF"] = tpfamount.ToString("f2");
                            tedamount = Math.Round(tedamount, 2);
                            newrow1["ED Value"] = tedamount.ToString("f2");
                            totalsgst = Math.Round(totalsgst, 2);
                            newrow1["SGST"] = totalsgst.ToString("f2");
                            totalcgst = Math.Round(totalcgst, 2);
                            newrow1["CGST"] = totalcgst.ToString("f2");
                            totaligst = Math.Round(totaligst, 2);
                            newrow1["IGST"] = totaligst.ToString("f2");
                            tfreight = Math.Round(tfreight, 2);
                            newrow1["Fright Amount"] = tfreight.ToString("f2");
                            ttotalamount = Math.Round(ttotalamount, 2);
                            newrow1["Total Amount"] = ttotalamount.ToString("f2");
                            Report.Rows.Add(newrow1);
                            grandsgst += totalsgst;
                            grandcgst += totalcgst;
                            grandigst += totaligst;
                            gtotalqty += totalqty;
                            gtotaldiscount += totaldiscount;
                            gcsttax += tcsttax;
                            gpfamount += tpfamount;
                            gedamount += tedamount;
                            gtotalamount += ttotalamount;
                            gfright += tfreight;
                            tedamount = 0;
                            totaldiscount = 0;
                            tpfamount = 0;
                            tcsttax = 0;
                            ttotalamount = 0;
                            totalqty = 0;
                            tfreight = 0;
                            totaligst = 0;
                            totalcgst = 0;
                            totalsgst = 0;
                            rowcount = 1;
                        }
                    }
                    else
                    {
                        double sgstper = 0, cgstper = 0, igstper = 0;
                        double sgstamt = 0, cgstamt = 0, igstamt = 0;
                        double csttaxamt = 0;
                        prevpono = prespono;
                        newrow["PO Date"] = date_po;//date.ToString();

                        DateTime dt_po = Convert.ToDateTime(dr["Purchasedate"].ToString());
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
                        string PO = "";
                        PO = "SVDS/PBK/PO/" + dtapril.ToString("yy") + "-" + dtmarch.ToString("yy") + "/" + dr["ponumber"].ToString();
                        newrow["PO No"] = PO.ToString();
                        newrow["Supplier Name"] = dr["name"].ToString();
                        newrow["Product Name"] = dr["description"].ToString();
                        double price = 0;
                        double.TryParse(dr["cost"].ToString(), out price);
                        totalprice += price;
                        newrow["Price"] = price.ToString("f2");
                        double qty = 0;
                        double.TryParse(dr["qty"].ToString(), out qty);
                        totalqty += qty;
                        newrow["Quantity"] = dr["qty"].ToString();
                        double toatlpq1 = 0;
                        toatlpq1 = qty * price;
                        double dis = 0;
                        double.TryParse(dr["disamt"].ToString(), out dis);
                        totaldiscount += dis;
                        toatlpq = toatlpq1 - dis;
                        newrow["Discount"] = dis.ToString("f2");
                        totalpriceqty += toatlpq;
                        double totamount = 0;
                        double pfamt = 0;
                        double.TryParse(dr["pf"].ToString(), out pfamt);
                        pfamount = (toatlpq * pfamt) / 100;
                        newrow["PandF"] = pfamount.ToString("f2");
                        tpfamount += pfamount;
                        double totalamount = 0;
                        if (podate < gst_dt)
                        {
                            double edamt = 0;
                            double.TryParse(dr["edtax"].ToString(), out edamt);
                            totaledamt += edamt;
                            gtotaledamt += totaledamt;
                            edamount = (toatlpq * edamt) / 100;
                            newrow["ED Value"] = edamount.ToString("f2");
                            tedamount += edamount;
                            totamount += toatlpq + edamount + pfamount;
                            double csttax = 0;
                            double.TryParse(dr["tax"].ToString(), out csttax);
                            csttaxamt = (totamount * csttax) / 100;
                            newrow["CST Value"] = csttaxamt.ToString("f2");
                            tcsttax += csttaxamt;
                            double freight = 0;
                            totalamount = totamount + csttaxamt + freight;//grand total in that coming
                            sgstamt = 0;
                            newrow["SGST"] = "0.00";
                            totalsgst += sgstamt;
                            cgstamt = 0;
                            newrow["CGST"] = "0.00";
                            totalcgst += cgstamt;
                            igstamt = 0;
                            newrow["IGST"] = "0.00";
                            totaligst += igstamt;
                            newrow["Reverse Charge"] = "0.00";
                        }
                        else
                        {

                            double.TryParse(dr["sgst"].ToString(), out sgstper);
                            sgstamt = ((toatlpq + pfamount) * sgstper) / 100;
                            totalsgst += sgstamt;
                            double.TryParse(dr["cgst"].ToString(), out cgstper);
                            cgstamt = ((toatlpq + pfamount) * cgstper) / 100;
                            totalcgst += cgstamt;
                            double.TryParse(dr["igst"].ToString(), out igstper);
                            igstamt = ((toatlpq + pfamount) * igstper) / 100;
                            totaligst += igstamt;
                            newrow["SGST"] = sgstamt.ToString("f2");
                            newrow["CGST"] = cgstamt.ToString("f2");
                            newrow["IGST"] = igstamt.ToString("f2");
                            if (dr["reversecharge"].ToString() == "N")
                            {
                                totalamount = toatlpq + pfamount + sgstamt + cgstamt + igstamt;
                                newrow["Reverse Charge"] = "0.00";
                            }
                            else
                            {
                                totalamount = toatlpq + pfamount;
                                double rev_chrg = sgstamt + cgstamt + igstamt;
                                newrow["Reverse Charge"] = rev_chrg.ToString("f2");
                            }
                            //totalamount = toatlpq + pfamount + sgstamt + cgstamt + igstamt;
                            edamount = 0;
                            newrow["ED Value"] = edamount.ToString("f2");
                            tedamount += edamount;
                            csttaxamt = 0;
                            newrow["CST Value"] = "0.00";
                            tcsttax += csttaxamt;
                        }
                        //double edamt = 0;
                        //double.TryParse(dr["edtax"].ToString(), out edamt);
                        //totaledamt += edamt;
                        //gtotaledamt += totaledamt;
                        //edamount = (toatlpq * edamt) / 100;
                        //newrow["ED Value"] = edamount;
                        //tedamount += edamount;
                        //totamount += toatlpq + edamount + pfamount;
                        //double csttax = 0;
                        //double.TryParse(dr["tax"].ToString(), out csttax);
                        //double csttaxamt = 0;
                        //csttaxamt = (totamount * csttax) / 100;
                        //newrow["CST Value"] = csttaxamt;
                        //tcsttax += csttaxamt;
                        //double freight = 0;
                        //double.TryParse(dr["freigtamt"].ToString(), out freight);
                        //tfreight += freight;
                        //double totalamount = 0;
                        //totalamount = totamount + csttaxamt + freight;//grand total in that coming
                        newrow["Total Amount"] = totalamount.ToString("f2");
                        ttotalamount += totalamount;
                        Report.Rows.Add(newrow);
                            DataTable dtin = new DataTable();
                            DataRow[] drr = dttotalpo.Select("sno='" + prespono + "'");
                            if (drr.Length > 0)
                            {
                                dtin = drr.CopyToDataTable();
                            }
                            int dttotalpocount = dtin.Rows.Count;
                            if (dttotalpocount > 1)
                            {
                            }
                            else
                            {
                                DataRow newrow1 = Report.NewRow();
                                newrow1["Product Name"] = "Total";
                                totalqty = Math.Round(totalqty, 2);  
                                newrow1["Quantity"] = totalqty;
                                newrow1["Discount"] = Math.Round(totaldiscount, 2).ToString("f2");
                                tcsttax = Math.Round(tcsttax, 2);
                                newrow1["CST Value"] = tcsttax.ToString("f2");
                                tpfamount = Math.Round(tpfamount, 2);
                                newrow1["PandF"] = tpfamount.ToString("f2");
                                tedamount = Math.Round(tedamount, 2);
                                newrow1["ED Value"] = tedamount.ToString("f2");
                                totalsgst = Math.Round(totalsgst, 2);
                                newrow1["SGST"] = totalsgst.ToString("f2");
                                totalcgst = Math.Round(totalcgst, 2);
                                newrow1["CGST"] = totalcgst.ToString("f2");
                                totaligst = Math.Round(totaligst, 2);
                                newrow1["IGST"] = totaligst.ToString("f2");
                                tfreight = Math.Round(tfreight, 2);
                                newrow1["Fright Amount"] = tfreight.ToString("f2");
                                ttotalamount = Math.Round(ttotalamount, 2);
                                newrow1["Total Amount"] = ttotalamount.ToString("f2");
                                Report.Rows.Add(newrow1);
                                grandsgst += totalsgst;
                                grandcgst += totalcgst;
                                grandigst += totaligst;
                                gtotalqty += totalqty;
                                gtotaldiscount += totaldiscount;
                                gcsttax += tcsttax;
                                gpfamount += tpfamount;
                                gedamount += tedamount;
                                gtotalamount += ttotalamount;
                                gfright += tfreight;
                                tedamount = 0;
                                totaldiscount = 0;
                                tpfamount = 0;
                                tcsttax = 0;
                                ttotalamount = 0;
                                totalqty = 0;
                                tfreight = 0;
                                totaligst = 0;
                                totalcgst = 0;
                                totalsgst = 0;
                                count++;
                                rowcount = 1;
                            }
                    }
                }
                gtotalqty += totalqty;
                gcsttax += tcsttax;
                gpfamount += tpfamount;
                gedamount += tedamount;
                gtotalamount += ttotalamount;
                DataRow salesreport1 = Report.NewRow();
                salesreport1["Product Name"] = "Grand Total";
                gtotalqty = Math.Round(gtotalqty, 2);
                salesreport1["Quantity"] = gtotalqty;
                salesreport1["Discount"] = Math.Round(gtotaldiscount, 2).ToString("f2");
                gcsttax = Math.Round(gcsttax, 2);
                salesreport1["CST Value"] = gcsttax.ToString("f2");
                gpfamount = Math.Round(gpfamount, 2);
                salesreport1["PandF"] = gpfamount.ToString("f2");
                gedamount = Math.Round(gedamount, 2);
                salesreport1["Ed Value"] = gedamount.ToString("f2");
                grandsgst = Math.Round(grandsgst, 2);
                salesreport1["SGST"] = grandsgst.ToString("f2");
                grandcgst = Math.Round(grandcgst, 2);
                salesreport1["CGST"] = grandcgst.ToString("f2");
                grandigst = Math.Round(grandigst, 2);
                salesreport1["IGST"] = grandigst.ToString("f2");
                gfright = Math.Round(gfright, 2);
                salesreport1["Fright Amount"] = gfright.ToString("f2");
                gtotalamount = Math.Round(gtotalamount, 2);
                salesreport1["Total Amount"] = gtotalamount.ToString("f2");
                Report.Rows.Add(salesreport1);
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
            if (e.Row.Cells[4].Text == "Total")
            {
                e.Row.BackColor = System.Drawing.Color.Aquamarine;
                e.Row.Font.Size = FontUnit.Medium;
                e.Row.Font.Bold = true;
            }
            if (e.Row.Cells[4].Text == "Grand Total")
            {
                e.Row.BackColor = System.Drawing.Color.DeepSkyBlue;
                e.Row.Font.Size = FontUnit.Large;
                e.Row.Font.Bold = true;
            }
        }
    }
}