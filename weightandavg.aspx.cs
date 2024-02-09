﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;
using System.Globalization;

public partial class weightandavg : System.Web.UI.Page
{
    SqlCommand cmd;
    string UserName = "";
    SalesDBManager vdm;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["UserName"] == null)
            Response.Redirect("Login.aspx");
        else
        {
            UserName = Session["UserName"].ToString();
            vdm = new SalesDBManager();
            if (!Page.IsPostBack)
            {
                if (!Page.IsCallback)
                {
                    dtp_FromDate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
                    dtp_Todate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
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
    double totalmilk;
    protected void btn_Generate_Click(object sender, EventArgs e)
    {
        report();
    }
    DataTable collection = new DataTable();
    DataTable Report = new DataTable();
    private void report()
    {
        try
        {
            lblmsg.Text = "";
            string milkopeningbal = string.Empty;
            string milkclosingbal = string.Empty;
            SalesDBManager SalesDB = new SalesDBManager();
            DateTime fromdate = DateTime.Now;
            DateTime todate = DateTime.Now;
            string idcno = string.Empty;
            string inworddate = string.Empty;
            double totalinwardqty = 0;
            double totalissueqty = 0;
            double totaltransferquantity = 0;
            double tranqtydateqty = 0;
            double totalReturnqty = 0;
            double returndateqty = 0;
            double totinwardvalue = 0;
            double totoutwardvalue = 0;
            double tottransfervalue = 0;
            double totreturnvalue = 0;
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
            lblFromDate.Text = fromdate.ToString("dd/MMM/yyyy");
            lbltodate.Text = todate.ToString("dd/MMM/yyyy");
            string productid = TextBox1.Text;
            Report.Columns.Add("Sno");
            Report.Columns.Add("Date");
            Report.Columns.Add("Opp Qty");
            Report.Columns.Add("Opp Price");
            Report.Columns.Add("Opp Value");
            Report.Columns.Add("ReceiptsQty").DataType = typeof(double);
            Report.Columns.Add("ReceiptsPrice");
            Report.Columns.Add("ReceiptsValue").DataType = typeof(double);
            Report.Columns.Add("ReturnQty").DataType = typeof(double);
            Report.Columns.Add("ReturnPrice");
            Report.Columns.Add("ReturnValue").DataType = typeof(double);

            Report.Columns.Add("IssuesQty").DataType = typeof(double);
            Report.Columns.Add("IssuesPrice");
            Report.Columns.Add("IssuesValue").DataType = typeof(double);

            Report.Columns.Add("IssuesQty1").DataType = typeof(double);
            Report.Columns.Add("IssuesPrice1");
            Report.Columns.Add("IssuesValue1").DataType = typeof(double);

            Report.Columns.Add("TransferQty").DataType = typeof(double);
            Report.Columns.Add("TransferPrice");
            Report.Columns.Add("TransferValue").DataType = typeof(double);

            Report.Columns.Add("TransferQty1").DataType = typeof(double);
            Report.Columns.Add("Transferprice1");
            Report.Columns.Add("Transfervale1").DataType = typeof(double);


            Report.Columns.Add("Clo Qty");
            Report.Columns.Add("Clo Price");
            Report.Columns.Add("Clo Value");
            hidepanel.Visible = true;
            Session["filename"] = "Ledger";
            Session["title"] = "Ledger Details";
            TimeSpan dateSpan = todate.Subtract(fromdate);
            int NoOfdays = dateSpan.Days;
            NoOfdays = NoOfdays + 1;
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string branchid = Session["Po_BranchID"].ToString();

            // inward
            cmd = new SqlCommand("SELECT SUM(subinwarddetails.quantity) AS inwardqty,subinwarddetails.perunit,SUM(subinwarddetails.quantity*subinwarddetails.perunit) AS inwardvalue, productmaster.productname, subinwarddetails.tax, subinwarddetails.edtax,  inwarddetails.inwarddate AS inwarddate  FROM inwarddetails INNER JOIN subinwarddetails ON inwarddetails.sno = subinwarddetails.in_refno INNER JOIN productmaster ON subinwarddetails.productid = productmaster.productid WHERE (productmaster.productname = @ProductID) AND (inwarddetails.inwarddate BETWEEN @d1 AND @d2) AND (inwarddetails.branchid=@branchid) AND (subinwarddetails.quantity>0) AND (inwarddetails.status='A') GROUP BY productmaster.productname,subinwarddetails.perunit, inwarddetails.inwarddate, subinwarddetails.tax, subinwarddetails.edtax");
            cmd.Parameters.Add("@d1", GetLowDate(fromdate));
            cmd.Parameters.Add("@d2", ServerDateCurrentdate);
            cmd.Parameters.Add("@ProductID", productid);
            cmd.Parameters.Add("@branchid", branchid);
            DataTable dtinward = SalesDB.SelectQuery(cmd).Tables[0];
            double inquantity = 0; double suminvalue = 0;
            foreach (DataRow drin in dtinward.Rows)
            {
                double.TryParse(drin["inwardqty"].ToString(), out inquantity);
                double.TryParse(drin["inwardvalue"].ToString(), out suminvalue);
                totalinwardqty += inquantity;
                totinwardvalue += suminvalue;
            }

            // outward (or) issue
            cmd = new SqlCommand("SELECT SUM(suboutwarddetails.quantity) AS issueqty,suboutwarddetails.perunit,SUM(suboutwarddetails.quantity*suboutwarddetails.perunit) AS outwardvalue,productmaster.productname, outwarddetails.inwarddate AS outwarddate FROM outwarddetails INNER JOIN suboutwarddetails ON outwarddetails.sno = suboutwarddetails.in_refno INNER JOIN productmaster ON suboutwarddetails.productid = productmaster.productid WHERE (productmaster.productname = @ProductID) AND (outwarddetails.inwarddate BETWEEN @d1 AND @d2) AND (outwarddetails.branchid=@branchid) AND (suboutwarddetails.quantity>0) AND (outwarddetails.status='A') GROUP BY productmaster.productname,suboutwarddetails.perunit, outwarddetails.inwarddate");
            cmd.Parameters.Add("@d1", GetLowDate(fromdate));
            cmd.Parameters.Add("@d2", GetLowDate(todate));
            cmd.Parameters.Add("@ProductID", productid);
            cmd.Parameters.Add("@branchid", branchid);
            DataTable dtoutward = SalesDB.SelectQuery(cmd).Tables[0];
            double outquantity = 0; string outwarddate; double sumoutvalue = 0;
            foreach (DataRow drout in dtoutward.Rows)
            {
                double.TryParse(drout["issueqty"].ToString(), out outquantity);
                double.TryParse(drout["outwardvalue"].ToString(), out sumoutvalue);
                totalissueqty += outquantity;
                totoutwardvalue += sumoutvalue;
            }

            // stocktransfer

            cmd = new SqlCommand("SELECT SUM(stocktransfersubdetails.quantity) AS transferqty,stocktransfersubdetails.price, productmaster.productname,SUM(stocktransfersubdetails.quantity*stocktransfersubdetails.price) AS transfervalue,  stocktransferdetails.invoicedate  FROM stocktransferdetails INNER JOIN stocktransfersubdetails ON stocktransferdetails.sno = stocktransfersubdetails.stock_refno INNER JOIN productmaster ON stocktransfersubdetails.productid = productmaster.productid WHERE (productmaster.productname = @ProductID) AND (stocktransferdetails.invoicedate BETWEEN @d1 AND @d2) AND (stocktransferdetails.branchid=@branchid) and (stocktransfersubdetails.quantity>0) and (stocktransferdetails.status='A') GROUP BY productmaster.productname,stocktransfersubdetails.price,stocktransfersubdetails.price, stocktransferdetails.invoicedate");
            cmd.Parameters.Add("@d1", GetLowDate(fromdate));
            cmd.Parameters.Add("@d2", ServerDateCurrentdate);
            cmd.Parameters.Add("@ProductID", productid);
            cmd.Parameters.Add("@branchid", branchid);
            DataTable dttransfer = SalesDB.SelectQuery(cmd).Tables[0];
            double transferquantity = 0; string invoicedate; double sumtransfervalue = 0;
            foreach (DataRow drtran in dttransfer.Rows)
            {
                double.TryParse(drtran["transferqty"].ToString(), out transferquantity);
                double.TryParse(drtran["transfervalue"].ToString(), out sumtransfervalue);
                totaltransferquantity += transferquantity;
                tottransfervalue += sumtransfervalue;
                // outwarddate = drout["transferqty"].ToString();
            }

            // returns
            cmd = new SqlCommand("SELECT SUM(sub_stores_return.quantity) AS returnqty,sub_stores_return.perunit,SUM(sub_stores_return.quantity*sub_stores_return.perunit) AS returnvalue, productmaster.productname, stores_return.doe  FROM stores_return INNER JOIN sub_stores_return ON stores_return.sno = sub_stores_return.storesreturn_sno INNER JOIN productmaster ON sub_stores_return.productid = productmaster.productid WHERE (productmaster.productname = @ProductID) AND (stores_return.doe BETWEEN @d1 AND @d2) AND (stores_return.branchid=@branchid) AND (sub_stores_return.quantity>0) GROUP BY productmaster.productname, stores_return.doe,sub_stores_return.perunit");
            cmd.Parameters.Add("@d1", GetLowDate(fromdate));
            cmd.Parameters.Add("@d2", ServerDateCurrentdate);
            cmd.Parameters.Add("@ProductID", productid);
            cmd.Parameters.Add("@branchid", branchid);
            DataTable dtreturn = SalesDB.SelectQuery(cmd).Tables[0];
            double Returnqty = 0; double sumreturnvalue = 0;
            foreach (DataRow drreturn in dtreturn.Rows)
            {
                double.TryParse(drreturn["returnqty"].ToString(), out Returnqty);
                double.TryParse(drreturn["returnvalue"].ToString(), out sumreturnvalue);
                totalReturnqty += Returnqty;
                totreturnvalue += sumreturnvalue;
            }

            cmd = new SqlCommand("SELECT Distinct stockclosingdetails.productid,stockclosingdetails.qty, stockclosingdetails.price, (stockclosingdetails.qty * stockclosingdetails.price) opvalue, stockclosingdetails.branchid, productmaster.productname FROM  stockclosingdetails INNER JOIN productmaster ON stockclosingdetails.productid = productmaster.productid WHERE (productmaster.productname = @productid) AND (stockclosingdetails.branchid = @branchid) AND (stockclosingdetails.doe BETWEEN @d11 and @d12) GROUP BY stockclosingdetails.productid,stockclosingdetails.qty, stockclosingdetails.branchid, stockclosingdetails.price, productmaster.productname");
            cmd.Parameters.Add("@productid", productid);
            cmd.Parameters.Add("@branchid", branchid);
            cmd.Parameters.Add("@d11", GetLowDate(fromdate));
            cmd.Parameters.Add("@d12", GetHighDate(fromdate));
            DataTable dtProduct_presentopp = vdm.SelectQuery(cmd).Tables[0];
            double productpresentopp = 0; double productpresenvalue = 0; double openingprice = 0;
            if (dtProduct_presentopp.Rows.Count > 0)
            {
                double.TryParse(dtProduct_presentopp.Rows[0]["qty"].ToString(), out productpresentopp);
                double.TryParse(dtProduct_presentopp.Rows[0]["opvalue"].ToString(), out productpresenvalue);
                double.TryParse(dtProduct_presentopp.Rows[0]["price"].ToString(), out openingprice);
            }
            int i = 1;
            double openbal = productpresentopp;
            double opevalue = productpresenvalue;
            double openprice = openingprice;
            double opbal = productpresentopp;
            //double openbal = (productpresentopp + totalissueqty + totaltransferquantity) - (totalinwardqty + totalReturnqty);
            // double opevalue = (productpresenvalue + totoutwardvalue + tottransfervalue) - (totinwardvalue + totreturnvalue);
            double oprate = 0; double rate = 0;
            double Prevqty = 0; double Prevalue = 0; double recipttotal = 0; double prevprice = 0; double outreciptprice = 0; double reciptprice = 0; double diffoutvalue = 0; double diffob = 0; double transdiffoutvalue = 0; double transdiffob = 0;
            for (int j = 0; j < NoOfdays; j++)
            {
                double inwardquantity = 0;
                double outwarquantity = 0;
                double inwardvalue = 0;
                double outwardvalue = 0;
                double transfervalue = 0;
                double transoutwardvalue = 0;
                double returnvalue = 0;
                DataRow newrow = Report.NewRow();
                newrow["Sno"] = i;
                string dtcount = fromdate.AddDays(j).ToString();
                DateTime dtDOE = Convert.ToDateTime(dtcount);
                string dtdate1 = dtDOE.AddDays(-1).ToString();
                DateTime dtDOE1 = Convert.ToDateTime(dtdate1).AddDays(1);
                string ChangedTime1 = dtDOE1.ToString("MM/dd/yyyy", CultureInfo.InvariantCulture);
                DateTime dateinward = DateTime.ParseExact(ChangedTime1, "MM/dd/yyyy", CultureInfo.InvariantCulture);
                dateinward = dateinward.Date;
                newrow["Date"] = dtDOE1.ToString("dd-MM-yyyy"); //ChangedTime1;
                DataTable dtin = new DataTable();
                DataRow[] drrin = dtinward.Select("inwarddate = '" + dateinward + "'");
                if (drrin.Length > 0)
                {
                    dtin = drrin.CopyToDataTable();
                }
                double indateqty = 0; double invalue = 0; double inprice = 0; double tax = 0; double edtax = 0; double recprice = 0;
                foreach (DataRow drinward in dtin.Rows)
                {
                    double.TryParse(drinward["inwardqty"].ToString(), out inwardquantity);
                    double.TryParse(drinward["inwardvalue"].ToString(), out inwardvalue);
                    double.TryParse(drinward["perunit"].ToString(), out inprice);
                    indateqty += inwardquantity;
                    invalue += inwardvalue;
                    if (inprice > 0)
                    {
                        double.TryParse(drinward["tax"].ToString(), out tax);
                        double.TryParse(drinward["edtax"].ToString(), out edtax);
                        double edvalue = (inprice * edtax) / 100;
                        double taxvalue = (inprice * tax) / 100;
                        reciptprice = inprice + edvalue + taxvalue;
                        reciptprice = Math.Round(reciptprice, 2);
                        recprice = reciptprice;
                        inwardvalue = inwardquantity * reciptprice;
                        inwardvalue = Math.Round(inwardvalue, 2);
                    }
                }
                DataTable dtout = new DataTable();
                DataRow[] drrout = dtoutward.Select("outwarddate ='" + dateinward + "'");
                if (drrout.Length > 0)
                {
                    dtout = drrout.CopyToDataTable();
                }
                double outdateqty = 0; double outvalue = 0; double outprice = 0; double issueqty1 = 0; double issueprice = 0; double issuevalue1 = 0; double diffobvalue = 0;
                foreach (DataRow droutward in dtout.Rows)
                {
                    double.TryParse(droutward["issueqty"].ToString(), out outwarquantity);
                    double.TryParse(droutward["perunit"].ToString(), out outprice);
                    outdateqty += outwarquantity;
                    recipttotal += outwarquantity;
                    if (recipttotal > opbal)
                    {
                        if (opbal > 0)
                        {
                            diffob = opbal - outwarquantity;
                        }
                        else
                        {
                            diffob = outwarquantity;
                        }
                        diffoutvalue = outwarquantity - diffob;
                        issueprice = reciptprice;
                        issueqty1 = diffoutvalue;
                        outreciptprice = issueprice;
                        if (issueqty1 < 0)
                        {
                            diffob = outwarquantity;
                            issueprice = 0;
                            issueqty1 = 0;
                            outprice = reciptprice;
                        }
                        recipttotal = 0;
                        if (opbal > 0)
                        {
                            diffobvalue = diffob * outprice;
                        }
                        else
                        {
                            diffobvalue = diffob * reciptprice;
                            outprice = reciptprice;
                        }
                        outwardvalue = diffob * reciptprice;
                        opbal = Prevqty;

                    }
                    else
                    {
                        if (outreciptprice > 0)
                        {
                            outprice = reciptprice;
                            outwardvalue = outwarquantity * outprice;
                        }
                        else
                        {
                            outwardvalue = outwarquantity * outprice;
                        }
                    }
                    outvalue += outwardvalue;
                }
                DataTable drtran = new DataTable();
                DataRow[] drrtrans = dttransfer.Select("invoicedate ='" + dateinward + "'");
                if (drrtrans.Length > 0)
                {
                    drtran = drrtrans.CopyToDataTable();
                }
                double tranqty = 0; double negative = 0; double outtransvalue = 0; double transoutreciptprice = 0; double transdiffobvalue = 0; double transvalue = 0; double transferprice = 0; double transoutprice = 0; double transissueprice = 0; double transissueqty1 = 0;

                foreach (DataRow drr1tran in drtran.Rows)
                {
                    double.TryParse(drr1tran["transferqty"].ToString(), out tranqty);
                    double.TryParse(drr1tran["transfervalue"].ToString(), out transfervalue);
                    double.TryParse(drr1tran["price"].ToString(), out transferprice);
                    tranqtydateqty += tranqty;
                    transvalue += transfervalue;
                    if (tranqtydateqty > opbal)
                    {
                        if (opbal > 0)
                        {
                            transdiffob = opbal - tranqty;
                            negative = transdiffob;
                            if (transdiffob < 0)
                            {
                                transdiffob = tranqty - opbal;
                            }
                        }
                        else
                        {
                            transdiffob = tranqty;
                        }
                        transdiffoutvalue = tranqty - transdiffob;
                        transissueprice = reciptprice;
                        transissueqty1 = transdiffoutvalue;
                        transoutreciptprice = transissueprice;
                        if (transissueqty1 < 0)
                        {
                            transdiffob = tranqty;
                            issueprice = 0;
                            issueqty1 = 0;
                            transferprice = reciptprice;
                        }
                        recipttotal = 0;
                        if (opbal > 0)
                        {
                            transdiffobvalue = transdiffob * transferprice;
                        }
                        else
                        {
                            transdiffobvalue = transdiffob * reciptprice;
                            transferprice = reciptprice;
                        }
                        transoutwardvalue = transdiffob * reciptprice;
                        opbal = Prevqty;
                    }
                    else
                    {
                        if (transoutreciptprice > 0)
                        {
                            transferprice = reciptprice;
                            transoutwardvalue = tranqty * transferprice;
                        }
                        else
                        {
                            transoutwardvalue = tranqty * transferprice;
                        }
                    }
                    outtransvalue += transoutwardvalue;
                }



                DataTable dttreturn = new DataTable();
                DataRow[] drrreturn = dtreturn.Select("doe ='" + dateinward + "'");
                if (drrreturn.Length > 0)
                {
                    dttreturn = drrreturn.CopyToDataTable();
                }
                double returnqty = 0; double retvalue = 0; double returnprice = 0;
                foreach (DataRow drrreturn1 in dttreturn.Rows)
                {
                    double.TryParse(drrreturn1["returnqty"].ToString(), out returnqty);
                    double.TryParse(drrreturn1["returnvalue"].ToString(), out returnvalue);
                    double.TryParse(drrreturn1["perunit"].ToString(), out returnprice);
                    returndateqty += returnqty;
                    retvalue += returnvalue;
                }
                if (i == 1)
                {
                    openbal = openbal;
                    opevalue = opevalue;
                    openingprice = openingprice;
                }
                else
                {
                    openbal = Prevqty;
                    opevalue = Prevalue;
                    openingprice = prevprice;
                }
                double openamt = 0;
                double openval = 0;
                double closingqty = 0;
                double closingvalue = 0;
                double opprice = 0;
                productpresentopp = 0;
                issuevalue1 = issueqty1 * issueprice;
                if (diffobvalue > 0)
                {
                    outwardvalue = diffobvalue;
                    closingvalue = (opevalue - outwardvalue - transfervalue - issuevalue1) + (inwardvalue + returnvalue);
                }
                else
                {
                    closingvalue = (opevalue - outwardvalue - transfervalue - issuevalue1) + (inwardvalue + returnvalue);
                }
                closingqty = (openbal - outdateqty - tranqty) + (indateqty + returnqty);
                oprate = closingvalue / closingqty;
                newrow["Opp Qty"] = Math.Round(openbal, 2);
                openbal = openamt;
                newrow["Opp Price"] = Math.Round(openingprice, 2);
                openingprice = opprice;
                newrow["Opp Value"] = Math.Round(opevalue, 2);
                opevalue = openval;
                newrow["ReceiptsQty"] = Math.Round(indateqty, 2);
                newrow["ReceiptsPrice"] = Math.Round(recprice, 2);
                newrow["ReceiptsValue"] = Math.Round(inwardvalue, 2);
                newrow["ReturnQty"] = Math.Round(returnqty, 2);
                newrow["ReturnPrice"] = returnprice;
                newrow["ReturnValue"] = Math.Round(retvalue, 2);
                if (diffob > 0)
                {
                    newrow["IssuesQty"] = Math.Round(diffob, 2);
                    newrow["IssuesValue"] = Math.Round(diffobvalue, 2);
                }
                else
                {
                    newrow["IssuesQty"] = Math.Round(outdateqty, 2);
                    newrow["IssuesValue"] = Math.Round(outvalue, 2);
                }
                newrow["IssuesPrice"] = outprice;
                newrow["IssuesQty1"] = issueqty1;
                newrow["IssuesPrice1"] = issueprice;
                double sum = issueqty1 * issueprice;

                newrow["IssuesValue1"] = Math.Round(sum, 2);

                if (transdiffob > 0)
                {
                    newrow["TransferQty"] = Math.Round(transdiffob, 2);
                    double transsum = transdiffob * transferprice;
                    newrow["TransferValue"] = Math.Round(transsum, 2);
                }
                else
                {
                    newrow["TransferQty"] = Math.Round(tranqty, 2);
                    double transsumm = tranqty * transferprice;
                    newrow["TransferValue"] = Math.Round(transsumm, 2);
                }

                newrow["TransferPrice"] = Math.Round(transferprice, 2);
                newrow["TransferQty1"] = transissueqty1;
                newrow["Transferprice1"] = transissueprice;
                double transssum = transissueqty1 * transissueprice;
                newrow["Transfervale1"] = Math.Round(transssum, 2);

                //if (negative > 0)
                //{
                //    if (transdiffob > 0)
                //    {
                //        newrow["TransferQty"] = Math.Round(transdiffob, 2);
                //        double transsum = transdiffob * transferprice;
                //        newrow["TransferValue"] = Math.Round(transsum, 2);
                //    }
                //    else
                //    {
                //        newrow["TransferQty"] = Math.Round(tranqty, 2);
                //        double transsumm = tranqty * transferprice;
                //        newrow["TransferValue"] = Math.Round(transsumm, 2);
                //    }

                //    newrow["TransferPrice"] = Math.Round(transferprice, 2);
                //    newrow["TransferQty1"] = transissueqty1;
                //    newrow["Transferprice1"] = transissueprice;
                //    double transssum = transissueqty1 * transissueprice;
                //    newrow["Transfervale1"] = Math.Round(transssum, 2);
                //}
                //else
                //{
                    
                //}
                
                
                
                if (closingvalue < 0)
                {
                    closingqty = 0;
                    oprate = 0;
                    closingvalue = 0;
                }
                newrow["Clo Qty"] = Math.Round(closingqty, 2);
                string cval = oprate.ToString();
                if (cval == "NaN")
                {
                    oprate = 0;
                }
                newrow["Clo Price"] = Math.Round(oprate, 2);
                newrow["Clo Value"] = Math.Round(closingvalue, 2);
                Prevqty = closingqty;
                Prevalue = closingvalue;
                prevprice = oprate;
                issueqty1 = 0;
                transissueqty1 = 0;
                transissueprice = 0;
                issueprice = 0;
                diffob = 0;
                diffobvalue = 0;
                transdiffob = 0;
                inwardvalue = 0;
                recprice = 0;
                Report.Rows.Add(newrow);
                i++;
            }
            DataRow newTotal = Report.NewRow();
            newTotal["Date"] = "Total";
            double val = 0.0;
            foreach (DataColumn dc in Report.Columns)
            {
                if (dc.DataType == typeof(Double))
                {
                    val = 0.0;
                    double.TryParse(Report.Compute("sum([" + dc.ToString() + "])", "[" + dc.ToString() + "]<>'0'").ToString(), out val);
                    newTotal[dc.ToString()] = val;
                }
            }
            Report.Rows.Add(newTotal);
            grdReports.DataSource = Report;
            grdReports.DataBind();
            Session["xportdata"] = Report;
            Session["filename"] = "Item Ledger";
            Session["Address"] = "Punabaka";
            hidepanel.Visible = true;
            ScriptManager.RegisterStartupScript(Page, GetType(), "JsStatus", "get_product_details();", true);
        }
        catch (Exception ex)
        {
            lblmsg.Text = ex.Message;
            hidepanel.Visible = false;
        }
    }
    protected void grdReports_RowCreated(object sender, GridViewRowEventArgs e)
    {
        try
        {
            if (e.Row.RowType == DataControlRowType.Header)
            {
                GridViewRow HeaderRow = new GridViewRow(2, 0, DataControlRowType.Header, DataControlRowState.Insert);

                TableCell HeaderCell2 = new TableCell();
                // HeaderCell2.Text = ddl_Plantname.Text + ":Garbar Details:" + "From:" + txt_FromDate.Text + "To:" + txt_ToDate.Text;
                HeaderCell2.Text = "Date";
                HeaderCell2.ColumnSpan = 2;
                HeaderCell2.HorizontalAlign = HorizontalAlign.Center;
                HeaderRow.Cells.Add(HeaderCell2);
                HeaderCell2 = new TableCell();
                HeaderCell2.Text = "OpeningBalance";
                HeaderCell2.ColumnSpan = 3;
                HeaderCell2.HorizontalAlign = HorizontalAlign.Center;
                HeaderRow.Cells.Add(HeaderCell2);

                HeaderCell2 = new TableCell();
                HeaderCell2.Text = "Inwards";
                HeaderCell2.ColumnSpan = 3;
                HeaderCell2.HorizontalAlign = HorizontalAlign.Center;
                HeaderRow.Cells.Add(HeaderCell2);

                HeaderCell2 = new TableCell();
                HeaderCell2.Text = "Returns";
                HeaderCell2.ColumnSpan = 3;
                HeaderCell2.HorizontalAlign = HorizontalAlign.Center;
                HeaderRow.Cells.Add(HeaderCell2);
                grdReports.Controls[0].Controls.AddAt(0, HeaderRow);

                HeaderCell2 = new TableCell();
                HeaderCell2.Text = "Outwards";
                HeaderCell2.ColumnSpan = 3;
                HeaderCell2.HorizontalAlign = HorizontalAlign.Center;
                HeaderRow.Cells.Add(HeaderCell2);
                grdReports.Controls[0].Controls.AddAt(0, HeaderRow);

                HeaderCell2 = new TableCell();
                HeaderCell2.Text = " ";
                HeaderCell2.ColumnSpan = 3;
                HeaderCell2.HorizontalAlign = HorizontalAlign.Center;
                HeaderRow.Cells.Add(HeaderCell2);
                grdReports.Controls[0].Controls.AddAt(0, HeaderRow);

                HeaderCell2 = new TableCell();
                HeaderCell2.Text = "Transfer";
                HeaderCell2.ColumnSpan = 3;
                HeaderCell2.HorizontalAlign = HorizontalAlign.Center;
                HeaderRow.Cells.Add(HeaderCell2);
                grdReports.Controls[0].Controls.AddAt(0, HeaderRow);
                HeaderCell2 = new TableCell();
                HeaderCell2.Text = " ";
                HeaderCell2.ColumnSpan = 3;
                HeaderCell2.HorizontalAlign = HorizontalAlign.Center;
                HeaderRow.Cells.Add(HeaderCell2);
                grdReports.Controls[0].Controls.AddAt(0, HeaderRow);

                HeaderCell2 = new TableCell();
                HeaderCell2.Text = "ClosingBalance";
                HeaderCell2.ColumnSpan = 3;
                HeaderCell2.HorizontalAlign = HorizontalAlign.Center;
                HeaderRow.Cells.Add(HeaderCell2);
                grdReports.Controls[0].Controls.AddAt(0, HeaderRow);

            }
        }
        catch (Exception ex)
        {
        }
    }
}