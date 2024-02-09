using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;
public partial class StockTransferReport : System.Web.UI.Page
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
                   // bindbranches();
                }
            }
        }
    }
    private void bindbranches()
    {
        string branchid1 = Session["Po_BranchID"].ToString();
        cmd = new SqlCommand("SELECT  branchid, branchname FROM branchmaster");
       // cmd = new SqlCommand("SELECT  branchid, branchname FROM branchmaster where branchid=@branchid");
        cmd.Parameters.Add("@branchid", branchid1);
        DataTable dttrips = vdm.SelectQuery(cmd).Tables[0];
        //ddlbranch.DataSource = dttrips;
        //ddlbranch.DataTextField = "branchname";
        //ddlbranch.DataValueField = "branchid";
        //ddlbranch.DataBind();
        //ddlbranch.ClearSelection();
        //ddlbranch.Items.Insert(0, new ListItem { Value = "0", Text = "--Select Branch--", Selected = true });
        //ddlbranch.SelectedValue = "0";
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
            Report.Columns.Add("Date");
            Report.Columns.Add("Invoice No");
            Report.Columns.Add("Branch Name");
            Report.Columns.Add("Product Name");
            Report.Columns.Add("Price");
            Report.Columns.Add("Quantity");
            Report.Columns.Add("Tax Amount");
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
            string branch_id = Session["Po_BranchID"].ToString();
            if (ddltype.SelectedValue == "WithTax")
            {
                cmd = new SqlCommand("SELECT stocktransferdetails.transportname,stocktransferdetails.invoicetype,stocktransferdetails.invoiceno,CONVERT(VARCHAR(20),stocktransferdetails.invoicedate, 103) AS invoicedate,stocktransferdetails.vehicleno,stocktransfersubdetails.price,stocktransfersubdetails.taxvalue,stocktransfersubdetails.taxtype,stocktransfersubdetails.freigtamt,stocktransferdetails.sno as refno,stocktransfersubdetails.sno,branchmaster.branchname, branchmaster_1.branchname AS BranchName, productmaster.productname, stocktransferdetails.frombranch, stocktransferdetails.tobranch,  stocktransfersubdetails.quantity, stocktransfersubdetails.stock_refno, stocktransfersubdetails.productid, stocktransferdetails.doe FROM  stocktransferdetails INNER JOIN stocktransfersubdetails ON stocktransferdetails.sno = stocktransfersubdetails.stock_refno LEFT OUTER JOIN  branchmaster ON stocktransferdetails.frombranch = branchmaster.branchid LEFT OUTER JOIN branchmaster AS branchmaster_1 ON stocktransferdetails.tobranch = branchmaster_1.branchid INNER JOIN productmaster ON stocktransfersubdetails.productid = productmaster.productid where (stocktransferdetails.invoicedate between @fromdate and @todate) AND (stocktransfersubdetails.taxtype='WithTax') AND (stocktransferdetails.branch_id=@branch_id) and (stocktransfersubdetails.quantity>0)");
                cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
                cmd.Parameters.Add("@todate", GetHighDate(todate));
                cmd.Parameters.Add("@branch_id", branch_id);
            }
            if (ddltype.SelectedValue == "WithOutTax")
            {
                cmd = new SqlCommand("SELECT stocktransferdetails.transportname,stocktransferdetails.invoicetype,stocktransferdetails.invoiceno,CONVERT(VARCHAR(20),stocktransferdetails.invoicedate, 103) AS invoicedate,stocktransferdetails.vehicleno,stocktransfersubdetails.price,stocktransfersubdetails.taxvalue,stocktransfersubdetails.taxtype,stocktransfersubdetails.freigtamt,stocktransferdetails.sno as refno,stocktransfersubdetails.sno,branchmaster.branchname, branchmaster_1.branchname AS BranchName, productmaster.productname, stocktransferdetails.frombranch, stocktransferdetails.tobranch,  stocktransfersubdetails.quantity, stocktransfersubdetails.stock_refno, stocktransfersubdetails.productid, stocktransferdetails.doe FROM  stocktransferdetails INNER JOIN stocktransfersubdetails ON stocktransferdetails.sno = stocktransfersubdetails.stock_refno LEFT OUTER JOIN  branchmaster ON stocktransferdetails.frombranch = branchmaster.branchid LEFT OUTER JOIN branchmaster AS branchmaster_1 ON stocktransferdetails.tobranch = branchmaster_1.branchid INNER JOIN productmaster ON stocktransfersubdetails.productid = productmaster.productid where (stocktransferdetails.invoicedate between @fromdate and @todate) AND (stocktransfersubdetails.taxtype='WithOutTax') AND (stocktransferdetails.branch_id=@branch_id) and (stocktransfersubdetails.quantity>0)");
                cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
                cmd.Parameters.Add("@todate", GetHighDate(todate));
                cmd.Parameters.Add("@branch_id", branch_id);
            }
            if (ddltype.SelectedValue == "ALL")
            {
                cmd = new SqlCommand("SELECT stocktransferdetails.transportname,stocktransferdetails.invoicetype,stocktransferdetails.invoiceno,CONVERT(VARCHAR(20),stocktransferdetails.invoicedate, 103) AS invoicedate,stocktransferdetails.vehicleno,stocktransfersubdetails.price,stocktransfersubdetails.taxvalue,stocktransfersubdetails.taxtype,stocktransfersubdetails.freigtamt,stocktransferdetails.sno as refno,stocktransfersubdetails.sno,branchmaster.branchname, branchmaster_1.branchname AS BranchName, productmaster.productname, stocktransferdetails.frombranch, stocktransferdetails.tobranch,  stocktransfersubdetails.quantity, stocktransfersubdetails.stock_refno, stocktransfersubdetails.productid, stocktransferdetails.doe FROM  stocktransferdetails INNER JOIN stocktransfersubdetails ON stocktransferdetails.sno = stocktransfersubdetails.stock_refno LEFT OUTER JOIN  branchmaster ON stocktransferdetails.frombranch = branchmaster.branchid LEFT OUTER JOIN branchmaster AS branchmaster_1 ON stocktransferdetails.tobranch = branchmaster_1.branchid INNER JOIN productmaster ON stocktransfersubdetails.productid = productmaster.productid where (stocktransferdetails.invoicedate between @fromdate and @todate) AND (stocktransferdetails.branch_id=@branch_id)  and (stocktransfersubdetails.quantity>0)");
                cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
                cmd.Parameters.Add("@todate", GetHighDate(todate));
                cmd.Parameters.Add("@branch_id", branch_id);
            }
            DataTable dtstocktransfer = SalesDB.SelectQuery(cmd).Tables[0];
            if (dtstocktransfer.Rows.Count > 0)
            {
                double totalqty = 0;
                double gtotalqty = 0;
                double ttotalamount = 0;
                double gtotalamount = 0;
                double totalprice = 0;
                double toatlpq = 0;
                double totalpriceqty = 0;
                double totaltaxamt = 0;
                double gtotaltaxamt = 0;
                double taxamount = 0;
                double ttaxamount = 0;
                double tfreight = 0;
                double gfrightamt = 0;
                double gtaxamount = 0;
                DateTime dt = DateTime.Now;
                string prevdate = string.Empty;
                string previnvoiceno = "";
                var i = 1;
                int count = 1;
                int rowcount = 1;
                foreach (DataRow dr in dtstocktransfer.Rows)
                {
                    DataRow newrow = Report.NewRow();
                    newrow["sno"] = i++.ToString();
                    string invoiceno = dr["invoiceno"].ToString();
                    string date = dr["invoicedate"].ToString();
                    String Type = dr["taxtype"].ToString();
                    if (Type == "Withouttax")
                    {
                        if (invoiceno == previnvoiceno)
                        {
                            newrow["Product Name"] = dr["productname"].ToString();
                            double price = 0;
                            double.TryParse(dr["price"].ToString(), out price);
                            totalprice += price;
                            newrow["Price"] = dr["price"].ToString();
                            double qty = 0;
                            double.TryParse(dr["quantity"].ToString(), out qty);
                            totalqty += qty;
                            newrow["Quantity"] = dr["quantity"].ToString();
                            double total; double totamount = 0;
                            total = qty * price;
                            totamount += total;
                            double totalamount = 0;
                            totalamount = totamount;//grand total in that coming
                            newrow["Total Amount"] = totalamount;
                            ttotalamount += totalamount;
                            Report.Rows.Add(newrow);
                            rowcount++;
                            DataTable dtin = new DataTable();
                            DataRow[] drr = dtstocktransfer.Select("invoiceno='" + invoiceno + "'");
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
                                ttotalamount = Math.Round(ttotalamount, 2);
                                newrow1["Total Amount"] = ttotalamount;
                                Report.Rows.Add(newrow1);
                                gtotalqty += totalqty;
                                gtotalamount += ttotalamount;
                                ttotalamount = 0;
                                totalqty = 0;
                                rowcount = 1;
                            }
                        }
                        else
                        {
                            previnvoiceno = invoiceno;
                            newrow["Date"] = date.ToString();
                            newrow["Invoice No"] = invoiceno.ToString();
                            newrow["Branch Name"] = dr["BranchName1"].ToString();
                            newrow["Product Name"] = dr["productname"].ToString();
                            double price = 0;
                            double.TryParse(dr["price"].ToString(), out price);
                            totalprice += price;
                            newrow["Price"] = dr["price"].ToString();
                            double qty = 0;
                            double.TryParse(dr["quantity"].ToString(), out qty);
                            totalqty += qty;
                            newrow["Quantity"] = dr["quantity"].ToString();
                            double total = 0; double totamount = 0;
                            total = qty * price;
                            totamount += total;
                            double totalamount = 0;
                            totalamount = totamount;//grand total in that coming
                            newrow["Total Amount"] = totalamount;
                            ttotalamount += totalamount;
                            Report.Rows.Add(newrow);
                            //if (count == 1)
                            //{
                            DataTable dtin = new DataTable();
                            DataRow[] drr = dtstocktransfer.Select("invoiceno='" + invoiceno + "'");
                            if (drr.Length > 0)
                            {
                                dtin = drr.CopyToDataTable();
                            }
                            int dttotalpocount = dtin.Rows.Count;
                            if (dttotalpocount > 1)
                            {
                                //rowcount++;
                            }
                            else
                            {
                                DataRow newrow1 = Report.NewRow();
                                newrow1["Product Name"] = "Total";
                                totalqty = Math.Round(totalqty, 2);
                                newrow1["Quantity"] = totalqty;
                                ttotalamount = Math.Round(ttotalamount, 2);
                                newrow1["Total Amount"] = ttotalamount;
                                Report.Rows.Add(newrow1);
                                gtotalqty += totalqty;
                                gtotalamount += ttotalamount;
                                ttotalamount = 0;
                                totalqty = 0;
                                count++;
                                rowcount = 1;
                            }
                            //}
                        }
                    }
                    else if (Type == "WithTax")
                    {
                        if (invoiceno == previnvoiceno)
                        {
                            newrow["Product Name"] = dr["productname"].ToString();
                            double price = 0;
                            double.TryParse(dr["price"].ToString(), out price);
                            totalprice += price;
                            newrow["Price"] = dr["price"].ToString();
                            double qty = 0;
                            double.TryParse(dr["quantity"].ToString(), out qty);
                            totalqty += qty;
                            newrow["Quantity"] = dr["quantity"].ToString();
                            double total; double totamount = 0;
                            total = qty * price;
                            totamount += total;
                            double taxamt = 0;
                            double.TryParse(dr["taxvalue"].ToString(), out taxamt);
                            totaltaxamt += taxamt;
                            gtotaltaxamt += totaltaxamt;
                            taxamount = (total * taxamt) / 100;
                            newrow["Tax Amount"] = taxamount;
                            ttaxamount += taxamount;
                            double freight = 0;
                            totamount = total + taxamount + freight;
                            double totalamount = 0;
                            totalamount = totamount;//grand total in that coming
                            newrow["Total Amount"] = totalamount;
                            ttotalamount += totalamount;
                            Report.Rows.Add(newrow);
                            rowcount++;
                            DataTable dtin = new DataTable();
                            DataRow[] drr = dtstocktransfer.Select("invoiceno='" + invoiceno + "'");
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
                                ttaxamount = Math.Round(ttaxamount, 2);
                                newrow1["Tax Amount"] = ttaxamount;
                                tfreight = Math.Round(tfreight, 2);
                                newrow1["Fright Amount"] = tfreight;
                                ttotalamount = Math.Round(ttotalamount, 2);
                                newrow1["Total Amount"] = ttotalamount;
                                Report.Rows.Add(newrow1);
                                gtotalqty += totalqty;
                                gtotalamount += ttotalamount;
                                gfrightamt += tfreight;
                                gtaxamount += ttaxamount;
                                ttaxamount = 0;
                                ttotalamount = 0;
                                tfreight = 0;
                                totalqty = 0;
                                rowcount = 1;
                            }
                        }
                        else
                        {
                            previnvoiceno = invoiceno;
                            newrow["Date"] = date.ToString();
                            newrow["Invoice No"] = invoiceno.ToString();
                            newrow["Product Name"] = dr["productname"].ToString();
                            newrow["Branch Name"] = dr["BranchName1"].ToString();
                            double price = 0;
                            double.TryParse(dr["price"].ToString(), out price);
                            totalprice += price;
                            newrow["Price"] = dr["price"].ToString();
                            double qty = 0;
                            double.TryParse(dr["quantity"].ToString(), out qty);
                            totalqty += qty;
                            newrow["Quantity"] = dr["quantity"].ToString();
                            double total = 0; double totamount = 0;
                            total = qty * price;
                            totamount += total;
                            double taxamt = 0;
                            double.TryParse(dr["taxvalue"].ToString(), out taxamt);
                            totaltaxamt += taxamt;
                            gtotaltaxamt += totaltaxamt;
                            taxamount = (total * taxamt) / 100;
                            newrow["Tax Amount"] = taxamount;
                            ttaxamount += taxamount;
                            double freight = 0;
                            double.TryParse(dr["freigtamt"].ToString(), out freight);
                            tfreight += freight;
                            newrow["Fright Amount"] = dr["freigtamt"].ToString();
                            totamount = total + taxamount + freight;
                            double totalamount = 0;
                            totalamount = totamount;//grand total in that coming
                            newrow["Total Amount"] = totalamount;
                            ttotalamount += totalamount;
                            Report.Rows.Add(newrow);
                            //if (count == 1)
                            //{
                            DataTable dtin = new DataTable();
                            DataRow[] drr = dtstocktransfer.Select("invoiceno='" + invoiceno + "'");
                            if (drr.Length > 0)
                            {
                                dtin = drr.CopyToDataTable();
                            }
                            int dttotalpocount = dtin.Rows.Count;
                            if (dttotalpocount > 1)
                            {
                                //rowcount++;
                            }
                            else
                            {
                                DataRow newrow1 = Report.NewRow();
                                newrow1["Product Name"] = "Total";
                                totalqty = Math.Round(totalqty, 2);
                                newrow1["Quantity"] = totalqty;
                                ttaxamount = Math.Round(ttaxamount, 2);
                                newrow1["Tax Amount"] = ttaxamount;
                                tfreight = Math.Round(tfreight, 2);
                                newrow1["Fright Amount"] = tfreight;
                                ttotalamount = Math.Round(ttotalamount, 2);
                                newrow1["Total Amount"] = ttotalamount;
                                Report.Rows.Add(newrow1);
                                gtotalqty += totalqty;
                                gtotalamount += ttotalamount;
                                gtaxamount += ttaxamount;
                                gfrightamt += tfreight;
                                ttaxamount = 0;
                                ttotalamount = 0;
                                totalqty = 0;
                                tfreight = 0;
                                count++;
                                rowcount = 1;
                            }
                            //}
                        }

                    }
                    else
                    {

                        if (invoiceno == previnvoiceno)
                        {
                            newrow["Product Name"] = dr["productname"].ToString();
                            double price = 0;
                            double.TryParse(dr["price"].ToString(), out price);
                            totalprice += price;
                            newrow["Price"] = dr["price"].ToString();
                            double qty = 0;
                            double.TryParse(dr["quantity"].ToString(), out qty);
                            totalqty += qty;
                            newrow["Quantity"] = dr["quantity"].ToString();
                            double total; double totamount = 0;
                            total = qty * price;
                            totamount += total;
                            double taxamt = 0;
                            double.TryParse(dr["taxvalue"].ToString(), out taxamt);
                            totaltaxamt += taxamt;
                            gtotaltaxamt += totaltaxamt;
                            taxamount = (total * taxamt) / 100;
                            newrow["Tax Amount"] = taxamount;
                            ttaxamount += taxamount;
                            double freight = 0;
                            totamount = total + taxamount + freight;
                            double totalamount = 0;
                            totalamount = totamount;//grand total in that coming
                            newrow["Total Amount"] = totalamount;
                            ttotalamount += totalamount;
                            Report.Rows.Add(newrow);
                            rowcount++;
                            DataTable dtin = new DataTable();
                            DataRow[] drr = dtstocktransfer.Select("invoiceno='" + invoiceno + "'");
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
                                ttaxamount = Math.Round(ttaxamount, 2);
                                newrow1["Tax Amount"] = ttaxamount;
                                tfreight = Math.Round(tfreight, 2);
                                newrow1["Fright Amount"] = tfreight;
                                ttotalamount = Math.Round(ttotalamount, 2);
                                newrow1["Total Amount"] = ttotalamount;
                                Report.Rows.Add(newrow1);
                                gtotalqty += totalqty;
                                gtotalamount += ttotalamount;
                                gfrightamt += tfreight;
                                gtaxamount += ttaxamount;
                                ttaxamount = 0;
                                ttotalamount = 0;
                                tfreight = 0;
                                totalqty = 0;
                                rowcount = 1;
                            }
                        }
                        else
                        {
                            previnvoiceno = invoiceno;
                            newrow["Date"] = date.ToString();
                            newrow["Invoice No"] = invoiceno.ToString();
                            newrow["Product Name"] = dr["productname"].ToString();
                            newrow["Branch Name"] = dr["BranchName1"].ToString();
                            double price = 0;
                            double.TryParse(dr["price"].ToString(), out price);
                            totalprice += price;
                            newrow["Price"] = dr["price"].ToString();
                            double qty = 0;
                            double.TryParse(dr["quantity"].ToString(), out qty);
                            totalqty += qty;
                            newrow["Quantity"] = dr["quantity"].ToString();
                            double total = 0; double totamount = 0;
                            total = qty * price;
                            totamount += total;
                            double taxamt = 0;
                            double.TryParse(dr["taxvalue"].ToString(), out taxamt);
                            totaltaxamt += taxamt;
                            gtotaltaxamt += totaltaxamt;
                            taxamount = (total * taxamt) / 100;
                            newrow["Tax Amount"] = taxamount;
                            ttaxamount += taxamount;
                            double freight = 0;
                            double.TryParse(dr["freigtamt"].ToString(), out freight);
                            tfreight += freight;
                            newrow["Fright Amount"] = dr["freigtamt"].ToString();
                            totamount = total + taxamount + freight;
                            double totalamount = 0;
                            totalamount = totamount;//grand total in that coming
                            newrow["Total Amount"] = totalamount;
                            ttotalamount += totalamount;
                            Report.Rows.Add(newrow);
                            //if (count == 1)
                            //{
                            DataTable dtin = new DataTable();
                            DataRow[] drr = dtstocktransfer.Select("invoiceno='" + invoiceno + "'");
                            if (drr.Length > 0)
                            {
                                dtin = drr.CopyToDataTable();
                            }
                            int dttotalpocount = dtin.Rows.Count;
                            if (dttotalpocount > 1)
                            {
                                //rowcount++;
                            }
                            else
                            {
                                DataRow newrow1 = Report.NewRow();
                                newrow1["Product Name"] = "Total";
                                totalqty = Math.Round(totalqty, 2);
                                newrow1["Quantity"] = totalqty;
                                ttaxamount = Math.Round(ttaxamount, 2);
                                newrow1["Tax Amount"] = ttaxamount;
                                tfreight = Math.Round(tfreight, 2);
                                newrow1["Fright Amount"] = tfreight;
                                ttotalamount = Math.Round(ttotalamount, 2);
                                newrow1["Total Amount"] = ttotalamount;
                                Report.Rows.Add(newrow1);
                                gtotalqty += totalqty;
                                gtotalamount += ttotalamount;
                                gtaxamount += ttaxamount;
                                gfrightamt += tfreight;
                                ttaxamount = 0;
                                ttotalamount = 0;
                                totalqty = 0;
                                tfreight = 0;
                                count++;
                                rowcount = 1;
                            }
                            //}
                        }

                    }
                }
                gtotalqty += totalqty;
                gtotalamount += ttotalamount;
                gfrightamt += tfreight;
                gtaxamount += ttaxamount;
                DataRow salesreport1 = Report.NewRow();
                salesreport1["Product Name"] = "Grand Total";
                gtotalqty = Math.Round(gtotalqty, 2);
                salesreport1["Quantity"] = gtotalqty;
                gtaxamount = Math.Round(gtaxamount, 2);
                salesreport1["Tax Amount"] = gtaxamount;
                gfrightamt = Math.Round(gfrightamt, 2);
                salesreport1["Fright Amount"] = gfrightamt;
                gtotalamount = Math.Round(gtotalamount, 2);
                salesreport1["Total Amount"] = gtotalamount;
                Report.Rows.Add(salesreport1);
                //grdReports.DataSource = Report;
                //grdReports.DataBind();
                //hidepanel.Visible = true;
                DataRow stockreport = Report.NewRow();
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
