﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;
public partial class CategoryWiseReport : System.Web.UI.Page
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
            if (!this.IsPostBack)
            {
                if (!Page.IsCallback)
                {
                    dtp_FromDate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");//Convert.ToString(lblFromDate.Text); ////     /////
                    dtp_Todate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
                    lblAddress.Text = Session["Address"].ToString();
                    lblTitle.Text = Session["TitleName"].ToString();
                    //loadReport();
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
            Report.Columns.Add("sno");
            Report.Columns.Add("Main Code");
            Report.Columns.Add("Category");
            Report.Columns.Add("Opening Balance");
            Report.Columns.Add("Receipt Values");
            Report.Columns.Add("Issues To Punabaka");
            Report.Columns.Add("Branch Transfers");
            Report.Columns.Add("Closing Balance");
            //Report.Columns.Add("SubCategory");
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
            lblfrom_date.Text = fromdate.ToString("dd/MM/yyyy");
            lblto_date.Text = todate.ToString("dd/MM/yyyy");
            string branchid = Session["Po_BranchID"].ToString();
            //DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            if (ddlconsumption.SelectedValue == "WithQuantity")
            {
                if (branchid == "2")
                {
                    cmd = new SqlCommand("SELECT productmaster.categoryid, categorymaster.category FROM productmaster INNER JOIN   categorymaster ON productmaster.categoryid = categorymaster.categoryid WHERE categorymaster.branchid=@branchid GROUP BY productmaster.categoryid, categorymaster.category");
                    cmd.Parameters.Add("@branchid", branchid);
                }
                else
                {
                    cmd = new SqlCommand("SELECT  productmaster.categoryid, categorymaster.category FROM productmaster INNER JOIN  categorymaster ON productmaster.categoryid = categorymaster.categoryid  INNER JOIN productmoniter ON productmoniter.productid=productmaster.productid WHERE productmoniter.branchid=@branchid GROUP BY  productmaster.categoryid,categorymaster.category");
                    cmd.Parameters.Add("@branchid", branchid);
                }

                DataTable dtproducts = SalesDB.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT categoryid, category, cat_code FROM categorymaster");
                cmd.Parameters.Add("@branchid", branchid);
                DataTable dtdetails = SalesDB.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT productmaster.categoryid,  SUM(stockclosingdetails.qty) AS openingbalance FROM  stockclosingdetails INNER JOIN productmaster ON productmaster.productid = stockclosingdetails.productid WHERE (stockclosingdetails.doe BETWEEN @d1 AND @d2) AND (stockclosingdetails.branchid=@branchid) GROUP BY productmaster.categoryid");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@d1", GetLowDate(fromdate));
                cmd.Parameters.Add("@d2", GetHighDate(todate));
                DataTable dtInward = SalesDB.SelectQuery(cmd).Tables[0];
                if (dtproducts.Rows.Count > 0)
                {
                    double Totalopeningqty = 0;
                    double Totalreceptqty = 0;
                    double Totalissueqty = 0;
                    double Totalbqty = 0;
                    double Totalclosingqty = 0;
                    var i = 1;
                    cmd = new SqlCommand("SELECT  productmaster.categoryid, SUM(subinwarddetails.quantity) AS inwardqty  FROM  productmaster  INNER JOIN subinwarddetails ON subinwarddetails.productid = productmaster.productid INNER JOIN  inwarddetails  ON  inwarddetails.sno=subinwarddetails.in_refno  where (inwarddetails.inwarddate BETWEEN @fromdate AND @todate) AND (inwarddetails.branchid=@branchid)  GROUP BY productmaster.categoryid ");
                    cmd.Parameters.Add("@branchid", branchid);
                    cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
                    cmd.Parameters.Add("@todate", GetHighDate(todate));
                    DataTable dtreceipt = SalesDB.SelectQuery(cmd).Tables[0];
                    cmd = new SqlCommand("SELECT  productmaster.categoryid, SUM(suboutwarddetails.quantity) AS issuestopunabaka  FROM  productmaster  INNER JOIN suboutwarddetails ON suboutwarddetails.productid = productmaster.productid INNER JOIN outwarddetails ON  outwarddetails.sno= suboutwarddetails.in_refno where (outwarddetails.inwarddate BETWEEN @fromdate AND @todate) AND (outwarddetails.branchid=@branchid)  GROUP BY productmaster.categoryid");
                    cmd.Parameters.Add("@branchid", branchid);
                    cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
                    cmd.Parameters.Add("@todate", GetHighDate(todate));
                    DataTable dtIsspcode = SalesDB.SelectQuery(cmd).Tables[0];
                    cmd = new SqlCommand("SELECT productmaster.categoryid, SUM(stocktransfersubdetails.quantity) AS branchtransfer  FROM  productmaster  INNER JOIN stocktransfersubdetails ON stocktransfersubdetails.productid = productmaster.productid INNER JOIN stocktransferdetails ON stocktransferdetails.sno=stocktransfersubdetails.stock_refno  where  (stocktransferdetails.invoicedate BETWEEN @fromdate AND @todate) AND (stocktransferdetails.branch_id=@branchid) GROUP BY productmaster.categoryid");
                    cmd.Parameters.Add("@branchid", branchid);
                    cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
                    cmd.Parameters.Add("@todate", GetHighDate(todate));
                    DataTable dttransferpcode = SalesDB.SelectQuery(cmd).Tables[0];

                    //cmd = new SqlCommand("SELECT  categoryid, SUM(qty) AS Dieselqty FROM  diesel_consumptiondetails WHERE (doe BETWEEN @d1 and @d2) AND (branchid=@dbid) GROUP BY categoryid");
                    //cmd.Parameters.Add("@dbid", branchid);
                    //cmd.Parameters.Add("@d1", GetLowDate(fromdate));
                    //cmd.Parameters.Add("@d2", GetHighDate(todate));
                    //DataTable dtdiesel = SalesDB.SelectQuery(cmd).Tables[0];

                    foreach (DataRow dr in dtproducts.Rows)
                    {
                        DataRow newrow = Report.NewRow();
                        newrow["sno"] = dr["categoryid"].ToString();
                        double openingqty = 0;
                        double receptqty = 0;
                        double issueqty = 0;
                        double dieselissueqty = 0;
                        double bqty = 0;
                        foreach (DataRow drd in dtdetails.Select("categoryid='" + dr["categoryid"].ToString() + "'"))
                        {
                            newrow["Main Code"] = drd["cat_code"].ToString();
                            newrow["Category"] = drd["category"].ToString();
                        }
                       
                        foreach (DataRow dropp in dtInward.Select("categoryid='" + dr["categoryid"].ToString() + "'"))
                        {
                            double.TryParse(dropp["openingbalance"].ToString(), out openingqty);
                            Totalopeningqty += openingqty;
                            newrow["Opening Balance"] = dropp["openingbalance"].ToString();
                        }
                        foreach (DataRow drreceipt in dtreceipt.Select("categoryid='" + dr["categoryid"].ToString() + "'"))
                        {
                            double.TryParse(drreceipt["inwardqty"].ToString(), out receptqty);
                            double reciptpunabaka = receptqty;
                            reciptpunabaka = Math.Round(reciptpunabaka, 2);
                            newrow["Receipt Values"] = reciptpunabaka;
                            Totalreceptqty += receptqty;
                        }
                        foreach (DataRow drissue in dtIsspcode.Select("categoryid='" + dr["categoryid"].ToString() + "'"))
                        {
                            double.TryParse(drissue["issuestopunabaka"].ToString(), out issueqty);
                            double isspunabaka = issueqty;
                            isspunabaka = Math.Round(isspunabaka, 2);
                            newrow["Issues To Punabaka"] = isspunabaka;
                            Totalissueqty += issueqty;
                        }
                        foreach (DataRow drtransfer in dttransferpcode.Select("categoryid='" + dr["categoryid"].ToString() + "'"))
                        {
                            double.TryParse(drtransfer["branchtransfer"].ToString(), out bqty);
                            Totalbqty += bqty;
                            newrow["Branch Transfers"] = drtransfer["branchtransfer"].ToString();
                        }
                        double openreceiptvalue = 0;
                        openreceiptvalue = openingqty + receptqty;
                        double issueandtransfervalue = 0;
                        issueandtransfervalue = issueqty + bqty;
                        double closingqty = 0;
                        closingqty = openreceiptvalue - issueandtransfervalue;
                        double closingqty1 = closingqty;
                        closingqty1 = Math.Round(closingqty1, 2);
                        newrow["Closing Balance"] = closingqty1;
                        Report.Rows.Add(newrow);
                    }
                    double Totalopenreceiptvalue = 0;
                    Totalopenreceiptvalue += Totalopeningqty + Totalreceptqty;
                    double Totalissueandtransfervalue = 0;
                    Totalissueandtransfervalue += Totalissueqty + Totalbqty;
                    Totalclosingqty += Totalopenreceiptvalue - Totalissueandtransfervalue;
                    DataRow stockreport = Report.NewRow();
                    stockreport["Main Code"] = "TotalValue";
                    stockreport["Opening Balance"] = Math.Round(Totalopeningqty, 2);   //Totalopeningqty;
                    double Totalreceptqty1 = Totalreceptqty;
                    Totalreceptqty1 = Math.Round(Totalreceptqty1, 2);
                    stockreport["Receipt Values"] = Totalreceptqty1;
                    double Totalissueqty1 = Totalissueqty;
                    Totalissueqty1 = Math.Round(Totalissueqty1, 2);
                    stockreport["Issues To Punabaka"] = Math.Round(Totalissueqty1, 2); //Totalissueqty1;
                    double Totalbqty1 = Totalbqty;
                    stockreport["Branch Transfers"] = Totalbqty1;
                    stockreport["Closing Balance"] = Math.Round(Totalclosingqty, 2); //Totalclosingqty;
                    Report.Rows.Add(stockreport);
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
            else
            {
                if (ddlconsumption.SelectedValue == "WithAmount")
                {
                    if (branchid == "2")
                    {
                        cmd = new SqlCommand("SELECT  productmaster.categoryid, categorymaster.category FROM productmaster INNER JOIN   categorymaster ON productmaster.categoryid = categorymaster.categoryid WHERE categorymaster.branchid=@branchid GROUP BY  productmaster.categoryid,categorymaster.category");
                        cmd.Parameters.Add("@branchid", branchid);
                    }
                    else
                    {
                        cmd = new SqlCommand("SELECT  productmaster.categoryid, categorymaster.category FROM productmaster INNER JOIN  categorymaster ON productmaster.categoryid = categorymaster.categoryid  INNER JOIN productmoniter ON productmoniter.productid=productmaster.productid WHERE productmoniter.branchid=@branchid GROUP BY  productmaster.categoryid,categorymaster.category");
                        cmd.Parameters.Add("@branchid", branchid);
                    }
                    DataTable dtproducts = SalesDB.SelectQuery(cmd).Tables[0];
                    cmd = new SqlCommand("SELECT categoryid, category, cat_code FROM categorymaster");
                    cmd.Parameters.Add("@branchid", branchid);
                    DataTable dtdetails = SalesDB.SelectQuery(cmd).Tables[0];
                    cmd = new SqlCommand("SELECT productmaster.categoryid, SUM(stockclosingdetails.qty * stockclosingdetails.price) AS openingbalance FROM stockclosingdetails INNER JOIN productmaster ON productmaster.productid = stockclosingdetails.productid WHERE (stockclosingdetails.doe BETWEEN @d1 AND @d2) AND (stockclosingdetails.branchid=@branchid) GROUP BY productmaster.categoryid"); 
                    cmd.Parameters.Add("@d1", GetLowDate(fromdate));
                    cmd.Parameters.Add("@d2", GetHighDate(fromdate));
                    cmd.Parameters.Add("@branchid", branchid);
                    //cmd = new SqlCommand("SELECT  productcode, SUM(aqty) AS openingbalance FROM  productmaster GROUP BY  productcode ORDER BY productcode");
                    DataTable dtInward = SalesDB.SelectQuery(cmd).Tables[0];
                    if (dtproducts.Rows.Count > 0)
                    {
                        double Totalopeningqty = 0;
                        double Totalreceptqty = 0;
                        double Totalissueqty = 0;
                        double Totalbqty = 0;
                        double Totalclosingqty = 0;
                        var i = 1;
                        //cmd = new SqlCommand("SELECT        SUM(subinwarddetails.quantity * subinwarddetails.perunit) AS inwardqty, subcategorymaster.categoryid FROM   productmaster INNER JOIN subinwarddetails ON subinwarddetails.productid = productmaster.productid INNER JOIN inwarddetails ON inwarddetails.sno = subinwarddetails.in_refno INNER JOIN subcategorymaster ON productmaster.subcategoryid = subcategorymaster.subcategoryid WHERE (inwarddetails.inwarddate BETWEEN @fromdate AND @todate) AND (inwarddetails.branchid = @branchid) GROUP BY subcategorymaster.categoryid");
                        cmd = new SqlCommand("SELECT  productmaster.categoryid, SUM(subinwarddetails.quantity * subinwarddetails.perunit) AS inwardqty  FROM  productmaster  INNER JOIN subinwarddetails ON subinwarddetails.productid = productmaster.productid INNER JOIN  inwarddetails  ON  inwarddetails.sno=subinwarddetails.in_refno  where (inwarddetails.inwarddate BETWEEN @fromdate AND @todate) AND (inwarddetails.branchid=@branchid) GROUP BY productmaster.categoryid");
                        cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
                        cmd.Parameters.Add("@todate", GetHighDate(todate));
                        cmd.Parameters.Add("@branchid", branchid);
                        DataTable dtreceipt = SalesDB.SelectQuery(cmd).Tables[0];
                        cmd = new SqlCommand("SELECT  productmaster.categoryid, SUM(suboutwarddetails.quantity * suboutwarddetails.perunit) AS issuestopunabaka  FROM  productmaster  INNER JOIN suboutwarddetails ON suboutwarddetails.productid = productmaster.productid INNER JOIN outwarddetails ON  outwarddetails.sno= suboutwarddetails.in_refno where (outwarddetails.inwarddate BETWEEN @fromdate AND @todate) AND (outwarddetails.branchid=@branchid) GROUP BY productmaster.categoryid");
                        cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
                        cmd.Parameters.Add("@todate", GetHighDate(todate));
                        cmd.Parameters.Add("@branchid", branchid);
                        DataTable dtIsspcode = SalesDB.SelectQuery(cmd).Tables[0];
                        cmd = new SqlCommand("SELECT productmaster.categoryid, SUM(stocktransfersubdetails.quantity * stocktransfersubdetails.price) AS branchtransfer  FROM  productmaster  INNER JOIN stocktransfersubdetails ON stocktransfersubdetails.productid = productmaster.productid INNER JOIN stocktransferdetails ON stocktransferdetails.sno=stocktransfersubdetails.stock_refno  where  (stocktransferdetails.invoicedate BETWEEN @fromdate AND @todate) AND (stocktransferdetails.branch_id=@branchid) GROUP BY productmaster.categoryid");
                        cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
                        cmd.Parameters.Add("@todate", GetHighDate(todate));
                        cmd.Parameters.Add("@branchid", branchid);
                        DataTable dttransferpcode = SalesDB.SelectQuery(cmd).Tables[0];
                        foreach (DataRow dr in dtproducts.Rows)
                        {
                            DataRow newrow = Report.NewRow();
                            newrow["sno"] = i++.ToString();
                            double openingqty = 0;
                            double receptqty = 0;
                            double issueqty = 0;
                            double bqty = 0;
                            //string Main Code = dr["productcode"].ToString();
                            //if (Main Code == "15")
                            //{
                                
                                foreach (DataRow drd in dtdetails.Select("categoryid='" + dr["categoryid"].ToString() + "'"))
                                {
                                    newrow["Main Code"] = drd["cat_code"].ToString();
                                    newrow["Category"] = drd["category"].ToString();
                                }
                                foreach (DataRow dropp in dtInward.Select("categoryid='" + dr["categoryid"].ToString() + "'"))
                                {
                                    double.TryParse(dropp["openingbalance"].ToString(), out openingqty);
                                    Totalopeningqty += openingqty;
                                    newrow["Opening Balance"] = dropp["openingbalance"].ToString();
                                }
                                foreach (DataRow drreceipt in dtreceipt.Select("categoryid='" + dr["categoryid"].ToString() + "'"))
                                {
                                    double.TryParse(drreceipt["inwardqty"].ToString(), out receptqty);
                                    double reciptpunabaka = receptqty;
                                    reciptpunabaka = Math.Round(reciptpunabaka, 2);
                                    newrow["Receipt Values"] = reciptpunabaka;
                                    Totalreceptqty += receptqty;
                                }
                                foreach (DataRow drissue in dtIsspcode.Select("categoryid='" + dr["categoryid"].ToString() + "'"))
                                {
                                    double.TryParse(drissue["issuestopunabaka"].ToString(), out issueqty);
                                    double isspunabaka = issueqty;
                                    isspunabaka = Math.Round(isspunabaka, 2);
                                    newrow["Issues To Punabaka"] = isspunabaka;
                                    Totalissueqty += issueqty;
                                }
                                foreach (DataRow drtransfer in dttransferpcode.Select("categoryid='" + dr["categoryid"].ToString() + "'"))
                                {
                                    double.TryParse(drtransfer["branchtransfer"].ToString(), out bqty);
                                    Totalbqty += bqty;
                                    newrow["Branch Transfers"] = drtransfer["branchtransfer"].ToString();
                                }
                                double openreceiptvalue = 0;
                                openreceiptvalue = openingqty + receptqty;
                                double issueandtransfervalue = 0;
                                issueandtransfervalue = issueqty + bqty;
                                double closingqty = 0;
                                closingqty = openreceiptvalue - issueandtransfervalue;
                                double closingqty1 = closingqty;
                                closingqty1 = Math.Round(closingqty1, 2);
                                newrow["Closing Balance"] = closingqty1;
                                Report.Rows.Add(newrow);
                            //}
                        }
                        double Totalopenreceiptvalue = 0;
                        Totalopenreceiptvalue += Totalopeningqty + Totalreceptqty;
                        double Totalissueandtransfervalue = 0;
                        Totalissueandtransfervalue += Totalissueqty + Totalbqty;
                        Totalclosingqty += Totalopenreceiptvalue - Totalissueandtransfervalue;
                        DataRow stockreport = Report.NewRow();
                        stockreport["Main Code"] = "TotalValue";
                        stockreport["Opening Balance"] = Math.Round(Totalopeningqty, 2); //Totalopeningqty;
                        double Totalreceptqty1 = Totalreceptqty;
                        Totalreceptqty1 = Math.Round(Totalreceptqty1, 2);
                        stockreport["Receipt Values"] = Totalreceptqty1;
                        double Totalissueqty1 = Totalissueqty;
                        Totalissueqty1 = Math.Round(Totalissueqty1, 2);
                        stockreport["Issues To Punabaka"] = Math.Round(Totalissueqty1, 2);// Totalissueqty1;
                        double Totalbqty1 = Totalbqty;
                        stockreport["Branch Transfers"] = Math.Round(Totalbqty1, 2);// Totalbqty1;
                        stockreport["Closing Balance"] = Math.Round(Totalclosingqty, 2); //Totalclosingqty;
                        Report.Rows.Add(stockreport);
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
            }
        }
        catch (Exception ex)
        {
            lblmsg.Text = ex.Message;
            hidepanel.Visible = false;
        }

    }
    protected void grdReports_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        try
        {
            int rowIndex = Convert.ToInt32(e.CommandArgument);
            GridViewRow row = grdReports.Rows[rowIndex];
            string ReceiptNo = row.Cells[1].Text;
            Report.Columns.Add("sno");
            Report.Columns.Add("ProductId");
            Report.Columns.Add("Product Name");
            Report.Columns.Add("Opening Balance");
            Report.Columns.Add("Receipt Values");
            Report.Columns.Add("Issues To Punabaka");
            Report.Columns.Add("Branch Transfers");
            Report.Columns.Add("Closing Balance");
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
            lblfrom_date.Text = fromdate.ToString("dd/MM/yyyy");
            lblto_date.Text = todate.ToString("dd/MM/yyyy");
            string branchid = Session["Po_BranchID"].ToString();
            // DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            if (ddlconsumption.SelectedValue == "WithQuantity")
            {
                cmd = new SqlCommand("SELECT productmaster.productcode, productmaster.productname, productmaster.productid, categorymaster.category FROM productmaster INNER JOIN categorymaster ON productmaster.categoryid = categorymaster.categoryid WHERE (productmaster.categoryid = @productcode) AND categorymaster.branchid=@branchid GROUP BY productmaster.productcode, categorymaster.category, productmaster.productname, productmaster.productid");
                //cmd = new SqlCommand("SELECT productmaster.productcode,productmaster.productname,productmaster.productid, categorymaster.category FROM productmaster INNER JOIN productmoniter ON productmaster.productid = productmoniter.productid INNER JOIN   categorymaster ON productmaster.productcode = categorymaster.cat_code where productmaster.productcode=@productcode AND productmoniter.branchid=@branchid  GROUP BY productmaster.productcode, categorymaster.category,productmaster.productname,productmaster.productid");
                cmd.Parameters.Add("@branchid", branchid);
              //cmd = new SqlCommand("SELECT productid, productname,price FROM productmaster where productcode=@productcode");
                cmd.Parameters.Add("@productcode", ReceiptNo);
                DataTable dtproducts = SalesDB.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT stockclosingdetails.qty,stockclosingdetails.productid FROM stockclosingdetails INNER JOIN productmaster ON stockclosingdetails.productid = productmaster.productid  WHERE  (productmaster.categoryid = @ReceiptNo) AND (stockclosingdetails.doe BETWEEN @d1 AND @d2) AND (stockclosingdetails.branchid=@branchid)");
               // cmd = new SqlCommand("SELECT  ff.productid, ff.qty, ff.price FROM (SELECT productmaster.productid FROM  productmaster INNER JOIN categorymaster ON productmaster.categoryid = categorymaster.categoryid INNER JOIN  subcategorymaster ON categorymaster.categoryid = subcategorymaster.categoryid AND  productmaster.subcategoryid = subcategorymaster.subcategoryid WHERE (productmaster.productcode = @ReceiptNo) AND (productmaster.branchid = @branchid) GROUP BY productmaster.productid) AS ProductInfo INNER JOIN (SELECT sno, productid, qty, doe, entryby, price, branchid FROM (SELECT sno, productid, qty, doe, entryby, price, branchid FROM  stockclosingdetails WHERE (doe BETWEEN @d1 AND @d2) AND (branchid=@sbranchid)) AS Transinfo) AS ff ON ff.productid = ProductInfo.productid");
                cmd.Parameters.Add("@d1", GetLowDate(fromdate));
                cmd.Parameters.Add("@d2", GetHighDate(todate));
                cmd.Parameters.Add("@ReceiptNo", ReceiptNo);
                cmd.Parameters.Add("@branchid", branchid);
                
                DataTable dtInward = SalesDB.SelectQuery(cmd).Tables[0];

                if (dtproducts.Rows.Count > 0)
                {
                    double Totalopeningqty = 0;
                    double Totalreceptqty = 0;
                    double Totalissueqty = 0;
                    double Totalbqty = 0;
                    double Totalclosingqty = 0;
                    var i = 1;
                    cmd = new SqlCommand("SELECT  productmaster.productid, SUM(subinwarddetails.quantity) AS inwardqty  FROM  productmaster  INNER JOIN subinwarddetails ON subinwarddetails.productid = productmaster.productid INNER JOIN  inwarddetails  ON  inwarddetails.sno=subinwarddetails.in_refno  where (inwarddetails.inwarddate BETWEEN @fromdate AND @todate) AND (inwarddetails.branchid=@branchid) AND (productmaster.categoryid=@ReceiptNo) GROUP BY productmaster.productid ");
                    cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
                    cmd.Parameters.Add("@todate", GetHighDate(todate));
                    cmd.Parameters.Add("@ReceiptNo", ReceiptNo);
                    cmd.Parameters.Add("@branchid", branchid);
                    DataTable dtreceipt = SalesDB.SelectQuery(cmd).Tables[0];
                    cmd = new SqlCommand("SELECT  productmaster.productid, SUM(suboutwarddetails.quantity) AS issuestopunabaka  FROM  productmaster  INNER JOIN suboutwarddetails ON suboutwarddetails.productid = productmaster.productid INNER JOIN outwarddetails ON  outwarddetails.sno= suboutwarddetails.in_refno where (outwarddetails.inwarddate BETWEEN @fromdate AND @todate) AND (outwarddetails.branchid=@branchid) AND (productmaster.categoryid=@ReceiptNo) GROUP BY productmaster.productid");
                    cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
                    cmd.Parameters.Add("@todate", GetHighDate(todate));
                    cmd.Parameters.Add("@ReceiptNo", ReceiptNo);
                    cmd.Parameters.Add("@branchid", branchid);
                    DataTable dtIsspcode = SalesDB.SelectQuery(cmd).Tables[0];
                    cmd = new SqlCommand("SELECT productmaster.productid, SUM(stocktransfersubdetails.quantity) AS branchtransfer  FROM  productmaster  INNER JOIN stocktransfersubdetails ON stocktransfersubdetails.productid = productmaster.productid INNER JOIN stocktransferdetails ON stocktransferdetails.sno=stocktransfersubdetails.stock_refno  where  (stocktransferdetails.invoicedate BETWEEN @fromdate AND @todate) AND (stocktransferdetails.branch_id=@branchid) AND (productmaster.categoryid=@ReceiptNo) GROUP BY productmaster.productid");
                    cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
                    cmd.Parameters.Add("@todate", GetHighDate(todate));
                    cmd.Parameters.Add("@ReceiptNo", ReceiptNo);
                    cmd.Parameters.Add("@branchid", branchid);
                    DataTable dttransferpcode = SalesDB.SelectQuery(cmd).Tables[0];
                    foreach (DataRow dr in dtproducts.Rows)
                    {
                        DataRow newrow = Report.NewRow();
                        newrow["sno"] = i++.ToString();
                        double openingqty = 0;
                        double receptqty = 0;
                        double issueqty = 0;
                        double bqty = 0;
                        newrow["ProductId"] = dr["productid"].ToString();
                        newrow["Product Name"] = dr["productname"].ToString();

                        foreach (DataRow dropp in dtInward.Select("productid='" + dr["productid"].ToString() + "'"))
                        {
                            double qty = 0;
                            double.TryParse(dropp["qty"].ToString(), out qty);
                            openingqty = Math.Round(qty, 2);
                            Totalopeningqty += openingqty;
                            newrow["Opening Balance"] = openingqty.ToString();
                        }
                        foreach (DataRow drreceipt in dtreceipt.Select("productid='" + dr["productid"].ToString() + "'"))
                        {
                            double.TryParse(drreceipt["inwardqty"].ToString(), out receptqty);
                            double reciptpunabaka = receptqty;
                            reciptpunabaka = Math.Round(reciptpunabaka, 2);
                            newrow["Receipt Values"] = reciptpunabaka;
                            Totalreceptqty += receptqty;
                        }
                        if (dr["productid"].ToString() == "0")
                        {
                            DataTable dt_diesel = new DataTable();
                            cmd = new SqlCommand("SELECT SUM(diesel_consumptiondetails.qty) AS qty, diesel_consumptiondetails.productid, productmaster.price FROM diesel_consumptiondetails INNER JOIN productmaster ON diesel_consumptiondetails.productid = productmaster.productid WHERE (diesel_consumptiondetails.branchid = @branchid) AND (diesel_consumptiondetails.doe BETWEEN @fromdate AND @todate) GROUP BY diesel_consumptiondetails.productid, productmaster.price");
                            cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
                            cmd.Parameters.Add("@todate", GetHighDate(todate));
                            cmd.Parameters.Add("@branchid", branchid);
                            dt_diesel = SalesDB.SelectQuery(cmd).Tables[0];
                            if (dt_diesel.Rows.Count > 0)
                            {
                                double.TryParse(dt_diesel.Rows[0]["qty"].ToString(), out issueqty);
                                double isspunabaka = issueqty;
                                isspunabaka = Math.Round(isspunabaka, 2);
                                newrow["Issues To Punabaka"] = isspunabaka;
                                Totalissueqty += issueqty;
                            }
                        }
                        else
                        {
                            foreach (DataRow drissue in dtIsspcode.Select("productid='" + dr["productid"].ToString() + "'"))
                            {
                                double.TryParse(drissue["issuestopunabaka"].ToString(), out issueqty);
                                double isspunabaka = issueqty;
                                isspunabaka = Math.Round(isspunabaka, 2);
                                newrow["Issues To Punabaka"] = isspunabaka;
                                Totalissueqty += issueqty;
                            }
                        }
                        
                        foreach (DataRow drtransfer in dttransferpcode.Select("productid='" + dr["productid"].ToString() + "'"))
                        {
                            double.TryParse(drtransfer["branchtransfer"].ToString(), out bqty);
                            Totalbqty += bqty;
                            newrow["Branch Transfers"] = drtransfer["branchtransfer"].ToString();
                        }
                        double openreceiptvalue = 0;
                        openreceiptvalue = openingqty + receptqty;
                        double issueandtransfervalue = 0;
                        issueandtransfervalue = issueqty + bqty;
                        double closingqty = 0;
                        closingqty = openreceiptvalue - issueandtransfervalue;
                        double closingqty1 = closingqty;
                        closingqty1 = Math.Round(closingqty1, 2);
                        newrow["Closing Balance"] = closingqty1;
                        Report.Rows.Add(newrow);
                    }
                    double Totalopenreceiptvalue = 0;
                    Totalopenreceiptvalue += Totalopeningqty + Totalreceptqty;
                    double Totalissueandtransfervalue = 0;
                    Totalissueandtransfervalue += Totalissueqty + Totalbqty;
                    Totalclosingqty += Totalopenreceiptvalue - Totalissueandtransfervalue;
                    DataRow stockreport = Report.NewRow();
                    stockreport["ProductId"] = "TotalValue";
                    stockreport["Opening Balance"] = Math.Round(Totalopeningqty, 2); //Totalopeningqty;
                    double Totalreceptqty1 = Totalreceptqty;
                    Totalreceptqty1 = Math.Round(Totalreceptqty1, 2);
                    stockreport["Receipt Values"] = Totalreceptqty1;
                    double Totalissueqty1 = Totalissueqty;
                    Totalissueqty1 = Math.Round(Totalissueqty1, 2);
                    stockreport["Issues To Punabaka"] = Math.Round(Totalissueqty1, 2);//Totalissueqty1;
                    double Totalbqty1 = Totalbqty;
                    stockreport["Branch Transfers"] = Totalbqty1;
                    stockreport["Closing Balance"] = Math.Round(Totalclosingqty, 2); //Totalclosingqty;
                    Report.Rows.Add(stockreport);
                    GrdProducts.DataSource = Report;
                    GrdProducts.DataBind();
                    hidepanel.Visible = true;
                }
                else
                {
                    lblmsg.Text = "No data were found";
                    hidepanel.Visible = false;
                }
            }
            else
            {
                if (ddlconsumption.SelectedValue == "WithAmount")
                {
                   // cmd = new SqlCommand("SELECT productmaster.productcode,productmaster.productname,productmaster.productid, categorymaster.category FROM productmaster INNER JOIN productmoniter ON productmaster.productid = productmoniter.productid INNER JOIN   categorymaster ON productmaster.productcode = categorymaster.cat_code where productmaster.productcode=@productcode AND productmoniter.branchid=@branchid  GROUP BY productmaster.productcode, categorymaster.category,productmaster.productname,productmaster.productid");
                   //// cmd = new SqlCommand("SELECT productmaster.productcode,productmaster.productname,productmaster.productid, categorymaster.category FROM productmaster INNER JOIN subcategorymaster ON productmaster.subcategoryid = subcategorymaster.subcategoryid INNER JOIN categorymaster ON productmaster.productcode = categorymaster.cat_code AND subcategorymaster.categoryid = categorymaster.categoryid GROUP BY productmaster.productcode, categorymaster.category,productmaster.productid,productmaster.productname");
                   // cmd.Parameters.Add("@productcode", ReceiptNo);
                   // cmd.Parameters.Add("@branchid", branchid);
                   // DataTable dtproducts = SalesDB.SelectQuery(cmd).Tables[0];


                    cmd = new SqlCommand("SELECT productmaster.productcode, productmaster.productname, productmaster.productid, categorymaster.category FROM productmaster INNER JOIN categorymaster ON productmaster.categoryid = categorymaster.categoryid WHERE (productmaster.categoryid = @productcode) AND categorymaster.branchid=@branchid GROUP BY productmaster.productcode, categorymaster.category, productmaster.productname, productmaster.productid");
                   
                    cmd.Parameters.Add("@branchid", branchid);
                    cmd.Parameters.Add("@productcode", ReceiptNo);
                    DataTable dtproducts = SalesDB.SelectQuery(cmd).Tables[0];



                    cmd = new SqlCommand("SELECT ff.productid, ff.qty, ff.price FROM (SELECT productmaster.productid FROM productmaster INNER JOIN categorymaster ON productmaster.productcode = categorymaster.cat_code INNER JOIN  subcategorymaster ON categorymaster.categoryid = subcategorymaster.categoryid AND  productmaster.sub_cat_code = subcategorymaster.sub_cat_code WHERE (productmaster.productcode = @ReceiptNo) AND (productmaster.branchid = @branchid) GROUP BY productmaster.productid) AS ProductInfo INNER JOIN (SELECT  sno, productid, qty, doe, entryby, price, branchid FROM (SELECT  sno, productid, qty, doe, entryby, price, branchid FROM stockclosingdetails WHERE (doe BETWEEN @d1 AND @d2)) AS Transinfo) AS ff ON ff.productid = ProductInfo.productid");
                    //cmd = new SqlCommand("SELECT productmaster.productcode, categorymaster.category FROM productmaster INNER JOIN   categorymaster ON productmaster.productcode = categorymaster.cat_code GROUP BY productmaster.productcode, categorymaster.category");
                    cmd.Parameters.Add("@d1", GetLowDate(fromdate));
                    cmd.Parameters.Add("@d2", GetHighDate(fromdate));
                    cmd.Parameters.Add("@ReceiptNo", ReceiptNo);
                    cmd.Parameters.Add("@branchid", branchid);
                    //cmd = new SqlCommand("SELECT  productcode, SUM(aqty) AS openingbalance FROM  productmaster GROUP BY  productcode ORDER BY productcode");
                    DataTable dtInward = SalesDB.SelectQuery(cmd).Tables[0];
                    if (dtproducts.Rows.Count > 0)
                    {
                        double Totalopeningqty = 0;
                        double Totalreceptqty = 0;
                        double Totalissueqty = 0;
                        double Totalbqty = 0;
                        double Totalclosingqty = 0;
                        var i = 1;
                        cmd = new SqlCommand("SELECT productmaster.productid, SUM(subinwarddetails.quantity * subinwarddetails.perunit) AS inwardqty  FROM  productmaster  INNER JOIN subinwarddetails ON subinwarddetails.productid = productmaster.productid INNER JOIN  inwarddetails  ON  inwarddetails.sno=subinwarddetails.in_refno  where (inwarddetails.inwarddate BETWEEN @fromdate AND @todate) AND (productmaster.productcode=@ReceiptNo) AND (inwarddetails.branchid=@branchid) GROUP BY productmaster.productid ");
                        cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
                        cmd.Parameters.Add("@todate", GetHighDate(todate));
                        cmd.Parameters.Add("@ReceiptNo", ReceiptNo);
                        cmd.Parameters.Add("@branchid", branchid);
                        DataTable dtreceipt = SalesDB.SelectQuery(cmd).Tables[0];
                        cmd = new SqlCommand("SELECT  productmaster.productid, SUM(suboutwarddetails.quantity * suboutwarddetails.perunit) AS issuestopunabaka  FROM  productmaster  INNER JOIN suboutwarddetails ON suboutwarddetails.productid = productmaster.productid INNER JOIN outwarddetails ON  outwarddetails.sno= suboutwarddetails.in_refno where (outwarddetails.inwarddate BETWEEN @fromdate AND @todate) AND (productmaster.productcode=@ReceiptNo) AND (outwarddetails.branchid=@branchid) GROUP BY productmaster.productid");
                        cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
                        cmd.Parameters.Add("@todate", GetHighDate(todate));
                        cmd.Parameters.Add("@ReceiptNo", ReceiptNo);
                        cmd.Parameters.Add("@branchid", branchid);
                        DataTable dtIsspcode = SalesDB.SelectQuery(cmd).Tables[0];
                        cmd = new SqlCommand("SELECT productmaster.productid, SUM(stocktransfersubdetails.quantity * stocktransfersubdetails.price) AS branchtransfer  FROM  productmaster  INNER JOIN stocktransfersubdetails ON stocktransfersubdetails.productid = productmaster.productid INNER JOIN stocktransferdetails ON stocktransferdetails.sno=stocktransfersubdetails.stock_refno  where  (stocktransferdetails.invoicedate BETWEEN @fromdate AND @todate) AND (productmaster.productcode=@ReceiptNo) AND (stocktransferdetails.branch_id=@branchid) GROUP BY productmaster.productid");
                        cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
                        cmd.Parameters.Add("@todate", GetHighDate(todate));
                        cmd.Parameters.Add("@ReceiptNo", ReceiptNo);
                        cmd.Parameters.Add("@branchid", branchid);
                        DataTable dttransferpcode = SalesDB.SelectQuery(cmd).Tables[0];
                        foreach (DataRow dr in dtproducts.Rows)
                        {
                            DataRow newrow = Report.NewRow();
                            newrow["sno"] = i++.ToString();
                            double openingqty = 0;
                            double receptqty = 0;
                            double issueqty = 0;
                            double bqty = 0;
                            newrow["ProductId"] = dr["productid"].ToString();
                            newrow["Product Name"] = dr["productname"].ToString();
                            foreach (DataRow dropp in dtInward.Select("productid='" + dr["productid"].ToString() + "'"))
                            {
                                double qty = 0;
                                double.TryParse(dropp["qty"].ToString(), out qty);
                                double price = 0;
                                double.TryParse(dropp["price"].ToString(), out price);
                                openingqty = qty * price;
                                openingqty = Math.Round(openingqty, 2);
                                Totalopeningqty += openingqty;
                                newrow["Opening Balance"] = openingqty.ToString();
                            }
                                foreach (DataRow drreceipt in dtreceipt.Select("productid='" + dr["productid"].ToString() + "'"))
                                {
                                    double.TryParse(drreceipt["inwardqty"].ToString(), out receptqty);
                                    double reciptpunabaka = receptqty;
                                    reciptpunabaka = Math.Round(reciptpunabaka, 2);
                                    newrow["Receipt Values"] = reciptpunabaka;
                                    Totalreceptqty += receptqty;
                                }
                                if (dr["productid"].ToString() == "2285")
                                {
                                    DataTable dt_diesel=new DataTable();
                                    cmd = new SqlCommand("SELECT SUM(diesel_consumptiondetails.qty * productmoniter.price) AS value FROM diesel_consumptiondetails INNER JOIN productmoniter ON diesel_consumptiondetails.productid = productmoniter.productid WHERE (diesel_consumptiondetails.doe BETWEEN @fromdate AND @todate) AND (diesel_consumptiondetails.branchid = @branch_id) AND (productmoniter.branchid = @branchid) GROUP BY diesel_consumptiondetails.productid, productmoniter.price");
                                    cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
                                    cmd.Parameters.Add("@todate", GetHighDate(todate));
                                    cmd.Parameters.Add("@branchid", branchid);
                                    cmd.Parameters.Add("@branch_id", branchid);
                                    dt_diesel = SalesDB.SelectQuery(cmd).Tables[0];
                                    if (dt_diesel.Rows.Count > 0)
                                    {
                                        double.TryParse(dt_diesel.Rows[0]["value"].ToString(), out issueqty);
                                        double isspunabaka = issueqty;
                                        isspunabaka = Math.Round(isspunabaka, 2);
                                        newrow["Issues To Punabaka"] = isspunabaka;
                                        Totalissueqty += issueqty;
                                    }
                                }
                                else
                                {
                                    foreach (DataRow drissue in dtIsspcode.Select("productid='" + dr["productid"].ToString() + "'"))
                                    {
                                        double.TryParse(drissue["issuestopunabaka"].ToString(), out issueqty);
                                        double isspunabaka = issueqty;
                                        isspunabaka = Math.Round(isspunabaka, 2);
                                        newrow["Issues To Punabaka"] = isspunabaka;
                                        Totalissueqty += issueqty;
                                    }
                                }
                                foreach (DataRow drtransfer in dttransferpcode.Select("productid='" + dr["productid"].ToString() + "'"))
                                {
                                    double.TryParse(drtransfer["branchtransfer"].ToString(), out bqty);
                                    Totalbqty += bqty;
                                    newrow["Branch Transfers"] = drtransfer["branchtransfer"].ToString();
                                }
                                double openreceiptvalue = 0;
                                openreceiptvalue = openingqty + receptqty;
                                double issueandtransfervalue = 0;
                                issueandtransfervalue = issueqty + bqty;
                                double closingqty = 0;
                                closingqty = openreceiptvalue - issueandtransfervalue;
                                double closingqty1 = closingqty;
                                closingqty1 = Math.Round(closingqty1, 2);
                                newrow["Closing Balance"] = closingqty1;
                                Report.Rows.Add(newrow);
                            }
                            double Totalopenreceiptvalue = 0;
                            Totalopenreceiptvalue += Totalopeningqty + Totalreceptqty;
                            double Totalissueandtransfervalue = 0;
                            Totalissueandtransfervalue += Totalissueqty + Totalbqty;
                            Totalclosingqty += Totalopenreceiptvalue - Totalissueandtransfervalue;
                            DataRow stockreport = Report.NewRow();
                            stockreport["ProductId"] = "TotalValue";
                            stockreport["Opening Balance"] = Math.Round(Totalopeningqty, 2); //Totalopeningqty;
                            double Totalreceptqty1 = Totalreceptqty;
                            Totalreceptqty1 = Math.Round(Totalreceptqty1, 2);
                            stockreport["Receipt Values"] = Totalreceptqty1;
                            double Totalissueqty1 = Totalissueqty;
                            Totalissueqty1 = Math.Round(Totalissueqty1, 2);
                            stockreport["Issues To Punabaka"] = Math.Round(Totalissueqty1, 2);// Totalissueqty1;
                            double Totalbqty1 = Totalbqty;
                            stockreport["Branch Transfers"] = Math.Round(Totalbqty1, 2);// Totalbqty1;
                            stockreport["Closing Balance"] = Math.Round(Totalclosingqty, 2); //Totalclosingqty;
                            Report.Rows.Add(stockreport);
                            GrdProducts.DataSource = Report;
                            GrdProducts.DataBind();
                            hidepanel.Visible = true;
                        }
                    
                    else
                    {
                        lblmsg.Text = "No data were found";
                        hidepanel.Visible = false;
                    }
                }
            }
            ScriptManager.RegisterStartupScript(Page, GetType(), "JsStatus", "PopupOpen();", true);
        }
        catch (Exception ex)
        {
            lblmsg.Text = ex.Message;
            hidepanel.Visible = false;
        }
    }
}

