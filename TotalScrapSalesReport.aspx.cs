using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;
public partial class TotalScrapSalesReport : System.Web.UI.Page
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
            Report.Columns.Add("InvoiceNo");
            Report.Columns.Add("Invoice Date");
            Report.Columns.Add("BuyerName");
            Report.Columns.Add("ProductName");
            Report.Columns.Add("Quantity");
            Report.Columns.Add("Price");
            Report.Columns.Add("Tax");
            Report.Columns.Add("Total Amount");
            lblmsg.Text = "";
            string mypo;
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
            cmd = new SqlCommand("SELECT subscrapsales.productid, suppliersdetails.name, scrapitemdetails.itemname, uimmaster.uim, scrapitemdetails.price, scrapitemdetails.branchid, scrapsales.transportname, scrapsales.invoicetype, scrapsales.status, scrapsales.vehicleno, scrapsales.invoiceno, scrapsales.invoicedate, scrapsales.remarks,scrapsales.branchid AS Expr1, scrapsales.entryby, scrapsales.doe, subscrapsales.qty, subscrapsales.price AS scrapprice, subscrapsales.sales_refno,subscrapsales.taxvalue, subscrapsales.freightamt, subscrapsales.taxtype, subscrapsales.doe AS Expr3, scrapsales.sno, branchmaster.branchname FROM scrapsales INNER JOIN subscrapsales ON scrapsales.sno = subscrapsales.sales_refno INNER JOIN scrapitemdetails ON subscrapsales.productid = scrapitemdetails.sno INNER JOIN suppliersdetails ON scrapsales.supplierid = suppliersdetails.supplierid INNER JOIN uimmaster ON scrapitemdetails.uom = uimmaster.sno INNER JOIN branchmaster ON scrapsales.branchid = branchmaster.branchid WHERE (scrapsales.branchid = @branchid) AND (scrapsales.invoicedate between @fromdate and @todate)");
            cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
            cmd.Parameters.Add("@todate", GetHighDate(todate));
            cmd.Parameters.Add("@branchid", branchid);
            DataTable dttotalinward = vdm.SelectQuery(cmd).Tables[0];
            if (dttotalinward.Rows.Count > 0)
            {
                double totalqty = 0;
                double gtotalqty = 0;
                double ttotalamount = 0;
                double gtotalamount = 0;
                double totalprice = 0;
                double toatlpq = 0;
                double totalpriceqty = 0;
                double ttax = 0;
                double gtax = 0;
                DateTime dt = DateTime.Now;
                string prevdate = string.Empty;
                string prevscrapno = "";
                var i = 1;
                int count = 1;
                int rowcount = 1;
                foreach (DataRow dr in dttotalinward.Rows)
                {
                    DataRow newrow = Report.NewRow();
                    newrow["Sno"] = i++.ToString();
                    string presscrapno = dr["sno"].ToString();
                    string date = dr["invoicedate"].ToString();
                    //DateTime dtdoe = Convert.ToDateTime(dr["outwarddate"].ToString());
                    //string currentdate = dtdoe.ToString("dd/MM/yyyy");
                    //string date = dtdoe.ToString("dd/MM/yyyy");
                    if (presscrapno == prevscrapno)
                    {
                        newrow["ProductName"] = dr["itemname"].ToString();
                        double price = 0;
                        double.TryParse(dr["price"].ToString(), out price);
                        totalprice += price;
                        newrow["Price"] = dr["price"].ToString();
                        double qty = 0;
                        double.TryParse(dr["qty"].ToString(), out qty);
                        totalqty += qty;
                        newrow["Quantity"] = dr["qty"].ToString();
                        double total; double totamount = 0;
                        total = qty * price;
                        totamount += total;
                        double totalamount = 0;
                        totalamount = totamount;//grand total in that coming
                        newrow["Total Amount"] = totalamount;
                        double tax = 0;
                        double.TryParse(dr["taxvalue"].ToString(), out tax);
                        double taxamt = 0;
                        taxamt = (totalamount * tax) / 100;
                        newrow["Tax"] = taxamt;
                        ttax += taxamt;
                        ttotalamount += totalamount + taxamt;
                        Report.Rows.Add(newrow);
                        rowcount++;
                        DataTable dtin = new DataTable();
                        DataRow[] drr = dttotalinward.Select("sno='" + presscrapno + "'");
                        if (drr.Length > 0)
                        {
                            dtin = drr.CopyToDataTable();
                        }
                        int dttotalpocount = dtin.Rows.Count;
                        if (dttotalpocount == rowcount)
                        {
                            DataRow newrow1 = Report.NewRow();
                            newrow1["ProductName"] = "Total";
                            totalqty = Math.Round(totalqty, 2);
                            newrow1["Quantity"] = totalqty;
                            newrow1["Tax"] = Math.Round(ttax, 2);
                            ttotalamount = Math.Round(ttotalamount, 2);
                            newrow1["Total Amount"] = ttotalamount;
                            Report.Rows.Add(newrow1);
                            gtotalqty += totalqty;
                            gtax += ttax;
                            gtotalamount += ttotalamount;
                            ttotalamount = 0;
                            totalqty = 0;
                            rowcount = 1;
                        }
                    }
                    else
                    {
                        prevscrapno = presscrapno;
                        newrow["Invoice Date"] = date.ToString();
                        newrow["InvoiceNo"] = dr["invoiceno"].ToString();
                        newrow["BuyerName"] = dr["name"].ToString();
                        newrow["ProductName"] = dr["itemname"].ToString();
                        double price = 0;
                        double.TryParse(dr["price"].ToString(), out price);
                        totalprice += price;
                        newrow["Price"] = dr["price"].ToString();
                        double qty = 0;
                        double.TryParse(dr["qty"].ToString(), out qty);
                        totalqty += qty;
                        newrow["Quantity"] = dr["qty"].ToString();
                        double total = 0; double totamount = 0;
                        total = qty * price;
                        totamount += total;
                        double totalamount = 0;
                        totalamount = totamount;//grand total in that coming
                        newrow["Total Amount"] = totalamount;
                        double tax = 0;
                        double.TryParse(dr["taxvalue"].ToString(), out tax);
                        double taxamt = 0;
                        taxamt = (totalamount * tax) / 100;
                        newrow["Tax"] = taxamt;
                        ttax += taxamt;
                        ttotalamount += totalamount + taxamt;
                        Report.Rows.Add(newrow);
                        //if (count == 1)
                        //{
                        DataTable dtin = new DataTable();
                        DataRow[] drr = dttotalinward.Select("sno='" + presscrapno + "'");
                        if (drr.Length > 0)
                        {
                            dtin = drr.CopyToDataTable();
                        }
                        int dttotalpocount = dtin.Rows.Count;
                        if (dttotalpocount > 1)
                        {
                            //rowcount++;pur
                        }
                        else
                        {
                            DataRow newrow1 = Report.NewRow();
                            newrow1["ProductName"] = "Total";
                            totalqty = Math.Round(totalqty, 2);
                            newrow1["Quantity"] = totalqty;
                            ttotalamount = Math.Round(ttotalamount, 2);
                            newrow1["Total Amount"] = ttotalamount;
                            newrow1["Tax"] = Math.Round(ttax, 2);
                            Report.Rows.Add(newrow1);
                            gtotalqty += totalqty;
                            gtax += ttax;
                            gtotalamount += ttotalamount;
                            ttotalamount = 0;
                            ttax = 0;
                            totalqty = 0;
                            count++;
                            rowcount = 1;
                        }
                        //}
                    }
                }

                ////DataRow salesreport = Report.NewRow();
                ////salesreport["Product Name"] = "Total";
                ////salesreport["Quantity"] = totalqty;
                ////salesreport["CST Value"] = tcsttax;
                ////salesreport["PandF"] = tpfamount;
                ////salesreport["ED Value"] = tedamount;
                ////salesreport["Fright Amount"] = tfreight;
                ////salesreport["Total Amount"] = ttotalamount;
                ////Report.Rows.Add(salesreport);
                gtotalqty += totalqty;
                gtotalamount += ttotalamount;
                gtax += ttax;
                DataRow salesreport1 = Report.NewRow();
                salesreport1["ProductName"] = "Grand Total";
                gtotalqty = Math.Round(gtotalqty, 2);
                salesreport1["Tax"] = gtax;
                salesreport1["Quantity"] = gtotalqty;
                gtotalamount = Math.Round(gtotalamount, 2);
                salesreport1["Total Amount"] = gtotalamount;
                Report.Rows.Add(salesreport1);
                foreach (var column in Report.Columns.Cast<DataColumn>().ToArray())
                {
                    if (Report.AsEnumerable().All(dr => dr.IsNull(column)))
                        Report.Columns.Remove(column);
                }
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
            if (e.Row.Cells[5].Text == "Total")
            {
                e.Row.Font.Size = FontUnit.Medium;
                e.Row.Font.Bold = true;
            }
            if (e.Row.Cells[5].Text == "Grand Total")
            {
                e.Row.BackColor = System.Drawing.Color.DeepSkyBlue;
                e.Row.Font.Size = FontUnit.Large;
                e.Row.Font.Bold = true;
            }
        }
    }
}