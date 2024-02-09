using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

public partial class SubCategoryWiseReport : System.Web.UI.Page
{
    SqlCommand cmd;
    string UserName = "";
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
            Report.Columns.Add("Sub Code");
            Report.Columns.Add("Sub Category");
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
            if (ddlconsumption.SelectedValue == "WithQuantity")
            {
                if (branchid == "2")
                {
                    cmd = new SqlCommand("SELECT subcategorymaster.categoryid, subcategorymaster.subcategoryid  FROM subcategorymaster WHERE (subcategorymaster.branchid = @branchid)");
                }
                else
                {
                    cmd = new SqlCommand("SELECT subcategorymaster.categoryid, subcategorymaster.subcategoryid  FROM subcategorymaster INNER JOIN productmaster ON productmaster.subcategoryid=subcategorymaster.subcategoryid INNER JOIN productmoniter ON productmoniter.productid=productmaster.productid WHERE (productmoniter.branchid = @branchid)");
                }
                cmd.Parameters.Add("@branchid", branchid);
                DataTable dtproducts = SalesDB.SelectQuery(cmd).Tables[0];
                if (branchid == "2")
                {
                    cmd = new SqlCommand("SELECT subcategorymaster.categoryid, subcategorymaster.subcategoryid, subcategorymaster.sub_cat_code, categorymaster.cat_code, categorymaster.category, subcategorymaster.subcategoryname FROM subcategorymaster LEFT OUTER JOIN categorymaster ON subcategorymaster.categoryid = categorymaster.categoryid WHERE subcategorymaster.branchid=@bid GROUP BY subcategorymaster.categoryid, subcategorymaster.subcategoryid, categorymaster.category, subcategorymaster.subcategoryname, subcategorymaster.sub_cat_code, categorymaster.cat_code  ORDER BY subcategorymaster.categoryid");
                }
                else
                {
                    cmd = new SqlCommand("SELECT subcategorymaster.categoryid, subcategorymaster.subcategoryid, subcategorymaster.sub_cat_code, categorymaster.cat_code, categorymaster.category, subcategorymaster.subcategoryname FROM subcategorymaster LEFT OUTER JOIN categorymaster ON subcategorymaster.categoryid = categorymaster.categoryid INNER JOIN productmaster ON productmaster.subcategoryid = subcategorymaster.subcategoryid INNER JOIN productmoniter ON productmoniter.productid=productmaster.productid WHERE (productmoniter.branchid = @bid) GROUP BY subcategorymaster.categoryid, subcategorymaster.subcategoryid, categorymaster.category, subcategorymaster.subcategoryname, subcategorymaster.sub_cat_code, categorymaster.cat_code  ORDER BY subcategorymaster.categoryid");
                }
                cmd.Parameters.Add("@bid", branchid);
                DataTable dtdetails = SalesDB.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT productmaster.categoryid,productmaster.subcategoryid,  SUM(stockclosingdetails.qty) AS openingbalance FROM  stockclosingdetails INNER JOIN productmaster ON productmaster.productid = stockclosingdetails.productid WHERE (stockclosingdetails.doe BETWEEN @d1 AND @d2) AND (stockclosingdetails.branchid=@branchid) GROUP BY productmaster.categoryid,productmaster.subcategoryid");
               // cmd = new SqlCommand("SELECT productmaster.productcode,productmaster.sub_cat_code,  SUM(producttransactions.qty) AS openingbalance FROM  productmaster INNER JOIN producttransactions ON producttransactions.productid = productmaster.productid WHERE (producttransactions.doe BETWEEN @d1 AND @d2) AND (producttransactions.branchid=@branchid) GROUP BY productmaster.productcode,productmaster.sub_cat_code");
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
                    cmd = new SqlCommand("SELECT  productmaster.categoryid,productmaster.subcategoryid, SUM(subinwarddetails.quantity) AS inwardqty  FROM  productmaster  INNER JOIN subinwarddetails ON subinwarddetails.productid = productmaster.productid INNER JOIN  inwarddetails  ON inwarddetails.sno=subinwarddetails.in_refno  where (inwarddetails.inwarddate BETWEEN @fromdate AND @todate) AND (inwarddetails.branchid=@branchid) GROUP BY productmaster.categoryid,productmaster.subcategoryid");
                    cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
                    cmd.Parameters.Add("@todate", GetHighDate(todate));
                    cmd.Parameters.Add("@branchid", branchid);
                    DataTable dtreceipt = SalesDB.SelectQuery(cmd).Tables[0];
                    cmd = new SqlCommand("SELECT  productmaster.categoryid,productmaster.subcategoryid, SUM(suboutwarddetails.quantity) AS issuestopunabaka  FROM  productmaster  INNER JOIN suboutwarddetails ON suboutwarddetails.productid = productmaster.productid INNER JOIN outwarddetails ON  outwarddetails.sno= suboutwarddetails.in_refno where (outwarddetails.inwarddate BETWEEN @fromdate AND @todate) AND (outwarddetails.branchid=@branchid) GROUP BY productmaster.categoryid,productmaster.subcategoryid ");
                    cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
                    cmd.Parameters.Add("@todate", GetHighDate(todate));
                    cmd.Parameters.Add("@branchid", branchid);
                    DataTable dtIsspcode = SalesDB.SelectQuery(cmd).Tables[0];
                    cmd = new SqlCommand("SELECT productmaster.categoryid,productmaster.subcategoryid, SUM(stocktransfersubdetails.quantity) AS branchtransfer  FROM  productmaster  INNER JOIN stocktransfersubdetails ON stocktransfersubdetails.productid = productmaster.productid INNER JOIN stocktransferdetails ON stocktransferdetails.sno=stocktransfersubdetails.stock_refno  where  (stocktransferdetails.invoicedate BETWEEN @fromdate AND @todate) AND (stocktransferdetails.branch_id=@branchid) GROUP BY productmaster.categoryid,productmaster.subcategoryid ");
                    cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
                    cmd.Parameters.Add("@todate", GetHighDate(todate));
                    cmd.Parameters.Add("@branchid", branchid);
                    DataTable dttransferpcode = SalesDB.SelectQuery(cmd).Tables[0];
                    var i = 1;
                    foreach (DataRow dr in dtproducts.Rows)
                    {
                        DataRow newrow = Report.NewRow();
                        newrow["sno"] = i++.ToString();
                        double openingqty = 0;
                        double receptqty = 0;
                        double issueqty = 0;
                        double bqty = 0;
                        //double.TryParse(dr["openingbalance"].ToString(), out openingqty);
                        //Totalopeningqty += openingqty;
                        foreach (DataRow drd in dtdetails.Select("subcategoryid='" + dr["subcategoryid"].ToString() + "'"))
                        {
                            newrow["Main Code"] = drd["cat_code"].ToString();
                            newrow["Sub Code"] = drd["sub_cat_code"].ToString();
                            newrow["Category"] = drd["category"].ToString();
                            newrow["Sub Category"] = drd["subcategoryname"].ToString();
                        }
                        //newrow["Main Code"] = dr["productcode"].ToString();
                        //newrow["Sub Code"] = dr["sub_cat_code"].ToString();
                        //newrow["Category"] = dr["category"].ToString();
                        //newrow["Sub Category"] = dr["subcategoryname"].ToString();
                        //newrow["OpeningBalance"] = dr["openingbalance"].ToString();
                        foreach (DataRow dropp in dtInward.Select("subcategoryid='" + dr["subcategoryid"].ToString() + "'"))
                        {
                            double.TryParse(dropp["openingbalance"].ToString(), out openingqty);
                            Totalopeningqty += openingqty;
                            newrow["Opening Balance"] = dropp["openingbalance"].ToString();
                        }
                        foreach (DataRow drreceipt in dtreceipt.Select("subcategoryid='" + dr["subcategoryid"].ToString() + "'"))
                        {
                            double.TryParse(drreceipt["inwardqty"].ToString(), out receptqty);
                            double reciptpunabaka = receptqty;
                            reciptpunabaka = Math.Round(reciptpunabaka, 2);
                            newrow["Receipt Values"] = reciptpunabaka;
                            Totalreceptqty += receptqty;
                        }
                        foreach (DataRow drissue in dtIsspcode.Select("subcategoryid='" + dr["subcategoryid"].ToString() + "'"))
                        {
                            double.TryParse(drissue["issuestopunabaka"].ToString(), out issueqty);
                            double isspunabaka = issueqty;
                            isspunabaka = Math.Round(isspunabaka, 2);
                            newrow["Issues To Punabaka"] = isspunabaka;
                            Totalissueqty += issueqty;
                        }
                        foreach (DataRow drtransfer in dttransferpcode.Select("subcategoryid='" + dr["subcategoryid"].ToString() + "'"))
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
                    stockreport["Opening Balance"] = Math.Round(Totalopeningqty, 2);//Totalopeningqty;
                    stockreport["Receipt Values"] = Math.Round(Totalreceptqty, 2);//Totalreceptqty;
                    stockreport["Issues To Punabaka"] = Math.Round(Totalissueqty, 2);  //Totalissueqty;
                    stockreport["Branch Transfers"] = Math.Round(Totalbqty, 2);//Totalbqty
                    stockreport["Closing Balance"] = Math.Round(Totalclosingqty, 2);// Totalclosingqty;
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
                   // cmd = new SqlCommand("SELECT subcategorymaster.categoryid, subcategorymaster.subcategoryid, categorymaster.category, subcategorymaster.subcategoryname FROM subcategorymaster INNER JOIN categorymaster ON subcategorymaster.categoryid = categorymaster.categoryid WHERE subcategorymaster.branchid=@branchid GROUP BY subcategorymaster.categoryid, subcategorymaster.subcategoryid, categorymaster.category, subcategorymaster.subcategoryname ORDER BY subcategorymaster.categoryid");
                    cmd = new SqlCommand("SELECT subcategorymaster.categoryid, subcategorymaster.subcategoryid  FROM subcategorymaster WHERE (subcategorymaster.branchid = @branchid)");
                    cmd.Parameters.Add("@branchid", branchid);
                    DataTable dtproducts = SalesDB.SelectQuery(cmd).Tables[0];

                    cmd = new SqlCommand("SELECT subcategorymaster.categoryid, subcategorymaster.subcategoryid, subcategorymaster.sub_cat_code, categorymaster.cat_code, categorymaster.category, subcategorymaster.subcategoryname FROM subcategorymaster LEFT OUTER JOIN categorymaster ON subcategorymaster.categoryid = categorymaster.categoryid WHERE subcategorymaster.branchid=@bid GROUP BY subcategorymaster.categoryid, subcategorymaster.subcategoryid, categorymaster.category, subcategorymaster.subcategoryname, subcategorymaster.sub_cat_code, categorymaster.cat_code  ORDER BY subcategorymaster.categoryid");
                    cmd.Parameters.Add("@bid", branchid);
                    DataTable dtdetails = SalesDB.SelectQuery(cmd).Tables[0];

                    ////cmd = new SqlCommand("SELECT  categorymaster.category,subcategorymaster.subcategoryname,productmaster.productcode,productmaster.sub_cat_code, SUM(productmaster.aqty) AS openingbalance FROM  productmaster INNER JOIN subcategorymaster ON productmaster.subcategoryid=subcategorymaster.subcategoryid INNER JOIN categorymaster ON categorymaster.categoryid=subcategorymaster.categoryid GROUP BY  productmaster.productcode,productmaster.sub_cat_code,categorymaster.category,subcategorymaster.subcategoryname ORDER BY productmaster.productcode,productmaster.sub_cat_code,categorymaster.category,subcategorymaster.subcategoryname ");
                    cmd = new SqlCommand("SELECT productmaster.categoryid,productmaster.subcategoryid,  SUM(stockclosingdetails.qty*stockclosingdetails.price) AS openingbalance FROM  productmaster INNER JOIN stockclosingdetails ON stockclosingdetails.productid = productmaster.productid WHERE (stockclosingdetails.doe BETWEEN @d1 AND @d2) AND (stockclosingdetails.branchid=@branchid) GROUP BY productmaster.categoryid,productmaster.subcategoryid");
                    cmd.Parameters.Add("@d1", GetLowDate(fromdate));
                    cmd.Parameters.Add("@d2", GetHighDate(todate));
                    cmd.Parameters.Add("@branchid", branchid);
                    //cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
                    //cmd.Parameters.Add("@todate", GetHighDate(todate));
                    //cmd = new SqlCommand("SELECT  productcode,sub_cat_code, SUM(aqty) AS openingbalance FROM  productmaster  GROUP BY  productcode,sub_cat_code ORDER BY  productcode,sub_cat_code ");
                    DataTable dtInward = SalesDB.SelectQuery(cmd).Tables[0];
                    if (dtproducts.Rows.Count > 0)
                    {
                        double Totalopeningqty = 0;
                        double Totalreceptqty = 0;
                        double Totalissueqty = 0;
                        double Totalbqty = 0;
                        double Totalclosingqty = 0;
                        cmd = new SqlCommand("SELECT  productmaster.categoryid, productmaster.subcategoryid, SUM(subinwarddetails.quantity *subinwarddetails.perunit) AS inwardqty  FROM  productmaster  INNER JOIN subinwarddetails ON subinwarddetails.productid = productmaster.productid INNER JOIN  inwarddetails  ON     inwarddetails.sno=subinwarddetails.in_refno  where (inwarddetails.inwarddate BETWEEN @fromdate AND @todate) AND (inwarddetails.branchid=@branchid) GROUP BY productmaster.categoryid, productmaster.subcategoryid");
                        cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
                        cmd.Parameters.Add("@todate", GetHighDate(todate));
                        cmd.Parameters.Add("@branchid", branchid);
                        DataTable dtreceipt = SalesDB.SelectQuery(cmd).Tables[0];
                        cmd = new SqlCommand("SELECT  productmaster.categoryid, productmaster.subcategoryid, SUM(suboutwarddetails.quantity * suboutwarddetails.perunit) AS issuestopunabaka  FROM  productmaster  INNER JOIN suboutwarddetails ON suboutwarddetails.productid = productmaster.productid INNER JOIN outwarddetails ON  outwarddetails.sno= suboutwarddetails.in_refno where (outwarddetails.inwarddate BETWEEN @fromdate AND @todate) AND (outwarddetails.branchid=@branchid) GROUP BY productmaster.categoryid, productmaster.subcategoryid");
                        cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
                        cmd.Parameters.Add("@todate", GetHighDate(todate));
                        cmd.Parameters.Add("@branchid", branchid);
                        DataTable dtIsspcode = SalesDB.SelectQuery(cmd).Tables[0];
                        cmd = new SqlCommand("SELECT productmaster.categoryid, productmaster.subcategoryid, SUM(stocktransfersubdetails.quantity* stocktransfersubdetails.price) AS branchtransfer  FROM  productmaster  INNER JOIN stocktransfersubdetails ON stocktransfersubdetails.productid = productmaster.productid INNER JOIN stocktransferdetails ON stocktransferdetails.sno=stocktransfersubdetails.stock_refno  where  (stocktransferdetails.invoicedate BETWEEN @fromdate AND @todate) AND (stocktransferdetails.branch_id=@branchid) GROUP BY productmaster.categoryid, productmaster.subcategoryid ");
                        cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
                        cmd.Parameters.Add("@todate", GetHighDate(todate));
                        cmd.Parameters.Add("@branchid", branchid);
                        DataTable dttransferpcode = SalesDB.SelectQuery(cmd).Tables[0];
                        var i = 1;
                        foreach (DataRow dr in dtproducts.Rows)
                        {
                            DataRow newrow = Report.NewRow();
                            newrow["sno"] = i++.ToString();
                            double openingqty = 0;
                            double receptqty = 0;
                            double issueqty = 0;
                            double bqty = 0;
                            //double.TryParse(dr["openingbalance"].ToString(), out openingqty);
                            //Totalopeningqty += openingqty;
                            //string maincode = dr["productcode"].ToString();
                            //if (maincode == "15")
                            //{
                               // newrow["Main Code"] = dr["categoryid"].ToString();
                               // newrow["Sub Code"] = dr["subcategoryid"].ToString();
                              //  newrow["Category"] = "";
                              //  newrow["Sub Category"] = "";
                                //newrow["OpeningBalance"] = dr["openingbalance"].ToString();

                                foreach (DataRow drd in dtdetails.Select("subcategoryid='" + dr["subcategoryid"].ToString() + "'"))
                                {
                                    newrow["Main Code"] = drd["cat_code"].ToString();
                                    newrow["Sub Code"] = drd["sub_cat_code"].ToString();
                                    newrow["Category"] = drd["category"].ToString();
                                    newrow["Sub Category"] = drd["subcategoryname"].ToString();
                                }

                                foreach (DataRow dropp in dtInward.Select("subcategoryid='" + dr["subcategoryid"].ToString() + "'"))
                                {
                                    double.TryParse(dropp["openingbalance"].ToString(), out openingqty);
                                    Totalopeningqty += openingqty;
                                    newrow["Opening Balance"] = dropp["openingbalance"].ToString();
                                }
                                foreach (DataRow drreceipt in dtreceipt.Select("subcategoryid='" + dr["subcategoryid"].ToString() + "'"))
                                {
                                    double.TryParse(drreceipt["inwardqty"].ToString(), out receptqty);
                                    double reciptpunabaka = receptqty;
                                    reciptpunabaka = Math.Round(reciptpunabaka, 2);
                                    newrow["Receipt Values"] = reciptpunabaka;
                                    Totalreceptqty += receptqty;
                                }
                                foreach (DataRow drissue in dtIsspcode.Select("subcategoryid='" + dr["subcategoryid"].ToString() + "'"))
                                {
                                    double.TryParse(drissue["issuestopunabaka"].ToString(), out issueqty);
                                    double isspunabaka = issueqty;
                                    isspunabaka = Math.Round(isspunabaka, 2);
                                    newrow["Issues To Punabaka"] = isspunabaka;
                                    Totalissueqty += issueqty;
                                }
                                foreach (DataRow drtransfer in dttransferpcode.Select("subcategoryid='" + dr["subcategoryid"].ToString() + "'"))
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
                        stockreport["Opening Balance"] = Math.Round(Totalopeningqty, 2);//Totalopeningqty;
                        stockreport["Receipt Values"] = Math.Round(Totalreceptqty, 2);//Totalreceptqty;
                        stockreport["Issues To Punabaka"] = Math.Round(Totalissueqty, 2);  //Totalissueqty;
                        stockreport["Branch Transfers"] = Math.Round(Totalbqty, 2);//Totalbqty
                        stockreport["Closing Balance"] = Math.Round(Totalclosingqty, 2);// Totalclosingqty;
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
            string ReceiptNo = row.Cells[2].Text;
            //string Type = row.Cells[4].Text;
            string SubReceiptNo = row.Cells[4].Text;
            Report.Columns.Add("sno");
            Report.Columns.Add("Product Name");
            Report.Columns.Add("Category");
            Report.Columns.Add("Sub Code");
            Report.Columns.Add("Sub Category");
            Report.Columns.Add("Product Id");
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
            if (ddlconsumption.SelectedValue == "WithQuantity")
            {
                //cmd = new SqlCommand("SELECT productid, productname,price FROM productmaster where productcode=@productcode and sub_cat_code=@sub_cat_code AND branchid=@branchid");
                cmd = new SqlCommand("SELECT productmaster.sub_cat_code, productmaster.productid, productmaster.productname, productmaster.price, subcategorymaster.subcategoryname, categorymaster.category FROM productmaster INNER JOIN productmoniter ON productmaster.productid = productmoniter.productid INNER JOIN subcategorymaster ON productmaster.subcategoryid = subcategorymaster.subcategoryid INNER JOIN categorymaster ON productmaster.productcode = categorymaster.cat_code WHERE (productmaster.productcode = @productcode) AND (productmaster.sub_cat_code = @sub_cat_code) AND (productmoniter.branchid = @branchid)");
                cmd.Parameters.Add("@productcode", ReceiptNo);
                cmd.Parameters.Add("@sub_cat_code", SubReceiptNo);
                cmd.Parameters.Add("@branchid", branchid);
                DataTable dtproducts = SalesDB.SelectQuery(cmd).Tables[0];
                //cmd = new SqlCommand("SELECT categorymaster.category, subcategorymaster.subcategoryname, categorymaster.cat_code,  SUM(productmaster.aqty) AS openingbalance, productmaster.sub_cat_code FROM productmaster INNER JOIN subcategorymaster ON productmaster.subcategoryid = subcategorymaster.subcategoryid INNER JOIN categorymaster ON subcategorymaster.categoryid = categorymaster.categoryid GROUP BY categorymaster.category, subcategorymaster.subcategoryname, productmaster.sub_cat_code, categorymaster.cat_code");

                cmd = new SqlCommand("SELECT productmaster.productcode,productmaster.productid,productmaster.productname, categorymaster.category, productmaster.sub_cat_code, subcategorymaster.subcategoryname, SUM(stockclosingdetails.qty) AS openingbalance, subcategorymaster.categoryid FROM productmaster INNER JOIN categorymaster ON productmaster.productcode = categorymaster.cat_code INNER JOIN subcategorymaster ON categorymaster.categoryid = subcategorymaster.categoryid AND productmaster.sub_cat_code = subcategorymaster.sub_cat_code INNER JOIN stockclosingdetails ON stockclosingdetails.productid=productmaster.productid  where  (stockclosingdetails.doe between @d1 and @d2) AND (productmaster.productcode=@ReceiptNo) AND (productmaster.sub_cat_code=@SubReceiptNo) AND (stockclosingdetails.branchid=@branchid)  GROUP BY productmaster.productcode,productmaster.productid, categorymaster.category, productmaster.sub_cat_code,productmaster.productname, subcategorymaster.categoryid, subcategorymaster.subcategoryname ORDER BY categorymaster.category");
                
               // cmd = new SqlCommand("SELECT productmaster.productcode,productmaster.productid,productmaster.productname, categorymaster.category, productmaster.sub_cat_code, subcategorymaster.subcategoryname, SUM(producttransactions.qty) AS openingbalance, subcategorymaster.categoryid FROM productmaster INNER JOIN categorymaster ON productmaster.productcode = categorymaster.cat_code INNER JOIN subcategorymaster ON categorymaster.categoryid = subcategorymaster.categoryid AND productmaster.sub_cat_code = subcategorymaster.sub_cat_code INNER JOIN producttransactions ON producttransactions.productid=productmaster.productid  where  (producttransactions.doe between @d1 and @d2) AND (productmaster.productcode=@ReceiptNo) AND (productmaster.sub_cat_code=@SubReceiptNo) AND (producttransactions.branchid=@branchid)  GROUP BY productmaster.productcode,productmaster.productid, categorymaster.category, productmaster.sub_cat_code,productmaster.productname, subcategorymaster.categoryid, subcategorymaster.subcategoryname ORDER BY categorymaster.category");
                cmd.Parameters.Add("@d1", GetLowDate(fromdate));
                cmd.Parameters.Add("@d2", GetHighDate(todate));
                cmd.Parameters.Add("@ReceiptNo", ReceiptNo);
                cmd.Parameters.Add("@SubReceiptNo", SubReceiptNo);
                cmd.Parameters.Add("@branchid", branchid);
                DataTable dtInward = SalesDB.SelectQuery(cmd).Tables[0];
                if (dtproducts.Rows.Count > 0)
                {
                    double Totalopeningqty = 0;
                    double Totalreceptqty = 0;
                    double Totalissueqty = 0;
                    double Totalbqty = 0;
                    double Totalclosingqty = 0;
                    cmd = new SqlCommand("SELECT  productmaster.productid,productmaster.productcode,productmaster.sub_cat_code, SUM(subinwarddetails.quantity) AS inwardqty  FROM  productmaster  INNER JOIN subinwarddetails ON subinwarddetails.productid = productmaster.productid INNER JOIN  inwarddetails  ON     inwarddetails.sno=subinwarddetails.in_refno  where (inwarddetails.inwarddate BETWEEN @fromdate AND @todate) AND (inwarddetails.branchid=@branchid) GROUP BY productmaster.productid, productmaster.productcode,productmaster.sub_cat_code ");
                    cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
                    cmd.Parameters.Add("@todate", GetHighDate(todate));
                    cmd.Parameters.Add("@branchid", branchid);
                    DataTable dtreceipt = SalesDB.SelectQuery(cmd).Tables[0];
                    cmd = new SqlCommand("SELECT productmaster.productid, productmaster.productcode,productmaster.sub_cat_code, SUM(suboutwarddetails.quantity) AS issuestopunabaka  FROM  productmaster  INNER JOIN suboutwarddetails ON suboutwarddetails.productid = productmaster.productid INNER JOIN outwarddetails ON  outwarddetails.sno= suboutwarddetails.in_refno where (outwarddetails.inwarddate BETWEEN @fromdate AND @todate) AND (outwarddetails.branchid=@branchid)  GROUP BY productmaster.productid,  productmaster.productcode,productmaster.sub_cat_code ");
                    cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
                    cmd.Parameters.Add("@todate", GetHighDate(todate));
                    cmd.Parameters.Add("@branchid", branchid);
                    DataTable dtIsspcode = SalesDB.SelectQuery(cmd).Tables[0];
                    cmd = new SqlCommand("SELECT productmaster.productid,productmaster.productcode,productmaster.sub_cat_code, SUM(stocktransfersubdetails.quantity) AS branchtransfer  FROM  productmaster  INNER JOIN stocktransfersubdetails ON stocktransfersubdetails.productid = productmaster.productid INNER JOIN stocktransferdetails ON stocktransferdetails.sno=stocktransfersubdetails.stock_refno  where  (stocktransferdetails.invoicedate BETWEEN @fromdate AND @todate) AND (stocktransferdetails.branch_id=@branchid) GROUP BY productmaster.productid, productmaster.productcode,productmaster.sub_cat_code ");
                    cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
                    cmd.Parameters.Add("@todate", GetHighDate(todate));
                    cmd.Parameters.Add("@branchid", branchid);
                    DataTable dttransferpcode = SalesDB.SelectQuery(cmd).Tables[0];
                    var i = 1;
                    foreach (DataRow dr in dtproducts.Rows)
                    {
                        DataRow newrow = Report.NewRow();
                        newrow["sno"] = i++.ToString();
                        double openingqty = 0;
                        double receptqty = 0;
                        double issueqty = 0;
                        double bqty = 0;
                        newrow["Product Id"] = dr["productid"].ToString();
                        newrow["Product Name"] = dr["productname"].ToString();
                        newrow["Category"] = dr["Category"].ToString();
                        newrow["Sub Code"] = dr["sub_cat_code"].ToString();
                        newrow["Sub Category"] = dr["subcategoryname"].ToString();
                        foreach (DataRow dropp in dtInward.Select("productid='" + dr["productid"].ToString() + "'"))
                        {
                            double.TryParse(dropp["openingbalance"].ToString(), out openingqty);
                            Totalopeningqty += openingqty;
                            newrow["Opening Balance"] = dropp["openingbalance"].ToString();
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
                    stockreport["Product Name"] = "TotalValue";
                    stockreport["Opening Balance"] = Math.Round(Totalopeningqty, 2);//Totalopeningqty;
                    stockreport["Receipt Values"] = Math.Round(Totalreceptqty, 2);//Totalreceptqty;
                    stockreport["Issues To Punabaka"] = Math.Round(Totalissueqty, 2);  //Totalissueqty;
                    stockreport["Branch Transfers"] = Math.Round(Totalbqty, 2);//Totalbqty
                    stockreport["Closing Balance"] = Math.Round(Totalclosingqty, 2);// Totalclosingqty;
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
                    //cmd = new SqlCommand("SELECT productid, productname,price FROM productmaster where productcode=@productcode and sub_cat_code=@sub_cat_code AND branchid=@branchid");
                    cmd = new SqlCommand("SELECT productmaster.productid, productmaster.productname, productmaster.price FROM productmaster INNER JOIN productmoniter ON productmaster.productid = productmoniter.productid WHERE (productmaster.productcode = @productcode) AND (productmaster.sub_cat_code = @sub_cat_code) AND (productmoniter.branchid = @branchid)");
                    cmd.Parameters.Add("@productcode", ReceiptNo);
                    cmd.Parameters.Add("@sub_cat_code", SubReceiptNo);
                    cmd.Parameters.Add("@branchid", branchid);
                    DataTable dtproducts = SalesDB.SelectQuery(cmd).Tables[0];
                    ////cmd = new SqlCommand("SELECT  categorymaster.category,subcategorymaster.subcategoryname,productmaster.productcode,productmaster.sub_cat_code, SUM(productmaster.aqty) AS openingbalance FROM  productmaster INNER JOIN subcategorymaster ON productmaster.subcategoryid=subcategorymaster.subcategoryid INNER JOIN categorymaster ON categorymaster.categoryid=subcategorymaster.categoryid GROUP BY  productmaster.productcode,productmaster.sub_cat_code,categorymaster.category,subcategorymaster.subcategoryname ORDER BY productmaster.productcode,productmaster.sub_cat_code,categorymaster.category,subcategorymaster.subcategoryname ");
                    cmd = new SqlCommand("SELECT productmaster.productcode,productmaster.productid, categorymaster.category, productmaster.sub_cat_code, subcategorymaster.subcategoryname, SUM(stockclosingdetails.qty*stockclosingdetails.price) AS openingbalance, subcategorymaster.categoryid FROM productmaster INNER JOIN categorymaster ON productmaster.productcode = categorymaster.cat_code INNER JOIN subcategorymaster ON categorymaster.categoryid = subcategorymaster.categoryid AND productmaster.sub_cat_code = subcategorymaster.sub_cat_code INNER JOIN stockclosingdetails ON stockclosingdetails.productid=productmaster.productid  where  (stockclosingdetails.doe between @d1 and @d2) AND (productmaster.productcode=@ReceiptNo) AND (productmaster.sub_cat_code=@SubReceiptNo) AND (stockclosingdetails.branchid=@branchid) GROUP BY productmaster.productcode,productmaster.productid, categorymaster.category, productmaster.sub_cat_code, subcategorymaster.categoryid, subcategorymaster.subcategoryname ORDER BY categorymaster.category");
                    cmd.Parameters.Add("@d1", GetLowDate(fromdate));
                    cmd.Parameters.Add("@d2", GetHighDate(todate));
                    cmd.Parameters.Add("@ReceiptNo", ReceiptNo);
                    cmd.Parameters.Add("@SubReceiptNo", SubReceiptNo);
                    cmd.Parameters.Add("@branchid", branchid);
                    //cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
                    //cmd.Parameters.Add("@todate", GetHighDate(todate));
                    //cmd = new SqlCommand("SELECT  productcode,sub_cat_code, SUM(aqty) AS openingbalance FROM  productmaster  GROUP BY  productcode,sub_cat_code ORDER BY  productcode,sub_cat_code ");
                    DataTable dtInward = SalesDB.SelectQuery(cmd).Tables[0];
                    if (dtproducts.Rows.Count > 0)
                    {
                        double Totalopeningqty = 0;
                        double Totalreceptqty = 0;
                        double Totalissueqty = 0;
                        double Totalbqty = 0;
                        double Totalclosingqty = 0;
                        cmd = new SqlCommand("SELECT  productmaster.productid,productmaster.productcode,productmaster.sub_cat_code, SUM(subinwarddetails.quantity *subinwarddetails.perunit) AS inwardqty  FROM  productmaster  INNER JOIN subinwarddetails ON subinwarddetails.productid = productmaster.productid INNER JOIN  inwarddetails  ON     inwarddetails.sno=subinwarddetails.in_refno  where (inwarddetails.inwarddate BETWEEN @fromdate AND @todate) AND (inwarddetails.branchid=@branchid) GROUP BY productmaster.productid,productmaster.productcode,productmaster.sub_cat_code ");
                        cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
                        cmd.Parameters.Add("@todate", GetHighDate(todate));
                        cmd.Parameters.Add("@branchid", branchid);
                        DataTable dtreceipt = SalesDB.SelectQuery(cmd).Tables[0];
                        cmd = new SqlCommand("SELECT  productmaster.productid,productmaster.productcode,productmaster.sub_cat_code, SUM(suboutwarddetails.quantity * suboutwarddetails.perunit) AS issuestopunabaka  FROM  productmaster  INNER JOIN suboutwarddetails ON suboutwarddetails.productid = productmaster.productid INNER JOIN outwarddetails ON  outwarddetails.sno= suboutwarddetails.in_refno where (outwarddetails.inwarddate BETWEEN @fromdate AND @todate) AND (outwarddetails.branchid=@branchid) GROUP BY productmaster.productid,productmaster.productcode,productmaster.sub_cat_code ");
                        cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
                        cmd.Parameters.Add("@todate", GetHighDate(todate));
                        cmd.Parameters.Add("@branchid", branchid);
                        DataTable dtIsspcode = SalesDB.SelectQuery(cmd).Tables[0];
                        cmd = new SqlCommand("SELECT productmaster.productid,productmaster.productcode,productmaster.sub_cat_code, SUM(stocktransfersubdetails.quantity* stocktransfersubdetails.price) AS branchtransfer  FROM  productmaster  INNER JOIN stocktransfersubdetails ON stocktransfersubdetails.productid = productmaster.productid INNER JOIN stocktransferdetails ON stocktransferdetails.sno=stocktransfersubdetails.stock_refno  where  (stocktransferdetails.invoicedate BETWEEN @fromdate AND @todate) AND (stocktransferdetails.branch_id=@branchid) GROUP BY productmaster.productid,productmaster.productcode,productmaster.sub_cat_code ");
                        cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
                        cmd.Parameters.Add("@todate", GetHighDate(todate));
                        cmd.Parameters.Add("@branchid", branchid);
                        DataTable dttransferpcode = SalesDB.SelectQuery(cmd).Tables[0];
                        var i = 1;
                        foreach (DataRow dr in dtproducts.Rows)
                        {
                            DataRow newrow = Report.NewRow();
                            newrow["sno"] = i++.ToString();
                            double openingqty = 0;
                            double receptqty = 0;
                            double issueqty = 0;
                            double bqty = 0;
                            newrow["Product Name"] = dr["productname"].ToString();
                            newrow["Product Id"] = dr["productid"].ToString();
                            foreach (DataRow dropp in dtInward.Select("productid='" + dr["productid"].ToString() + "'"))
                            {
                                double.TryParse(dropp["openingbalance"].ToString(), out openingqty);
                                Totalopeningqty += openingqty;
                                newrow["Opening Balance"] = dropp["openingbalance"].ToString();
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
                                DataTable dt_diesel = new DataTable();
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
                        stockreport["Product Name"] = "TotalValue";
                        stockreport["Opening Balance"] = Math.Round(Totalopeningqty, 2);//Totalopeningqty;
                        stockreport["Receipt Values"] = Math.Round(Totalreceptqty, 2);//Totalreceptqty;
                        stockreport["Issues To Punabaka"] = Math.Round(Totalissueqty, 2);  //Totalissueqty;
                        stockreport["Branch Transfers"] = Math.Round(Totalbqty, 2);//Totalbqty
                        stockreport["Closing Balance"] = Math.Round(Totalclosingqty, 2);// Totalclosingqty;
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
