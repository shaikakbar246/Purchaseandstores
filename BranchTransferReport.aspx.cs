using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

public partial class BranchTransferReport : System.Web.UI.Page
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
                    bindbranches();
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

    private void bindbranches()
    {
        cmd = new SqlCommand("SELECT  branchid, branchname FROM branchmaster");
        DataTable dttrips = vdm.SelectQuery(cmd).Tables[0];
        ddlagentname.DataSource = dttrips;
        ddlagentname.DataTextField = "branchname";
        ddlagentname.DataValueField = "branchid";
        ddlagentname.DataBind();
        ddlagentname.ClearSelection();
        ddlagentname.Items.Insert(0, new ListItem { Value = "0", Text = "--Select Branch--", Selected = true });
        ddlagentname.SelectedValue = "0";
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
            SalesDBManager vdm = new SalesDBManager();
            DateTime fromdate = DateTime.Now;
            DateTime todate = DateTime.Now;
            string idcno = string.Empty;
            string inworddate = string.Empty;
            double totalinwardqty = 0;
            double totalissueqty = 0;


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
            int branchid = Convert.ToInt32(ddlagentname.SelectedItem.Value);
            Report.Columns.Add("Sno");
            Report.Columns.Add("Branch Name");
           // Report.Columns.Add("Outward No");
            Report.Columns.Add("Product Name");
            Report.Columns.Add("Quantity");
            Report.Columns.Add("Price");
            Report.Columns.Add("TotalAmount");
            //Report.Columns.Add("Incentive");
            hidepanel.Visible = true;
            if (branchid != 0)
            {
                cmd = new SqlCommand("SELECT stocktransfersubdetails.price,stocktransfersubdetails.taxvalue,stocktransfersubdetails.taxtype,stocktransfersubdetails.freigtamt,stocktransferdetails.sno as refno,stocktransfersubdetails.sno, branchmaster_1.branchname AS ToBranchName, productmaster.productname, stocktransferdetails.tobranch, stocktransfersubdetails.quantity, stocktransfersubdetails.stock_refno, stocktransfersubdetails.productid,stocktransfersubdetails.price, stocktransferdetails.doe FROM  stocktransferdetails INNER JOIN stocktransfersubdetails ON stocktransferdetails.sno = stocktransfersubdetails.stock_refno INNER JOIN branchmaster AS branchmaster_1 ON stocktransferdetails.tobranch = branchmaster_1.branchid INNER JOIN productmaster ON stocktransfersubdetails.productid = productmaster.productid WHERE (stocktransferdetails.tobranch =@branchid) AND (stocktransferdetails.doe BETWEEN @fromdate AND @todate)");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
                cmd.Parameters.Add("@todate", GetHighDate(todate));
            }
            else
            {
                cmd = new SqlCommand("SELECT stocktransferdetails.remarks,stocktransferdetails.transportname,stocktransferdetails.invoicetype,stocktransferdetails.invoiceno,stocktransferdetails.invoicedate,stocktransferdetails.vehicleno,stocktransfersubdetails.price,stocktransfersubdetails.taxvalue,stocktransfersubdetails.taxtype,stocktransfersubdetails.freigtamt,stocktransferdetails.sno as refno,stocktransfersubdetails.sno, branchmaster_1.branchname AS ToBranchName, productmaster.productname, stocktransferdetails.tobranch, stocktransfersubdetails.quantity, stocktransfersubdetails.stock_refno, stocktransfersubdetails.productid,stocktransfersubdetails.price, stocktransferdetails.doe FROM  stocktransferdetails INNER JOIN stocktransfersubdetails ON stocktransferdetails.sno = stocktransfersubdetails.stock_refno INNER JOIN branchmaster AS branchmaster_1 ON stocktransferdetails.tobranch = branchmaster_1.branchid INNER JOIN productmaster ON stocktransfersubdetails.productid = productmaster.productid WHERE  (stocktransferdetails.doe BETWEEN @fromdate AND @todate)");
                cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
                cmd.Parameters.Add("@todate", GetHighDate(todate));
            }
            DataTable dtprocurement = vdm.SelectQuery(cmd).Tables[0];
            if (dtprocurement.Rows.Count > 0)
            {
                double totlmilklitrs = 0;
                double TotalCans = 0;
                double gtotalqty = 0;
                double gtotlmilklitrs = 0;
                double gTotalQuantity = 0;
                double gTotalCans = 0;
                double gtotalamount = 0;
                double totalamount = 0;
                double TotalQuantity = 0;
                DateTime dt = DateTime.Now;
                string prevdate = string.Empty;
                string prevbranch = "";
                var i = 1;
                int count = 1;
                int rowcount = 1;
                foreach (DataRow dr in dtprocurement.Rows)
                {
                    DataRow newrow = Report.NewRow();
                    newrow["Sno"] = i++.ToString();
                    string presentbranch = dr["ToBranchName"].ToString();
                    if (presentbranch == prevbranch)
                    {
                        newrow["Product Name"] = dr["productname"].ToString();
                        newrow["Price"] = dr["price"].ToString();
                        newrow["Quantity"] = dr["quantity"].ToString();
                        double price = 0;
                        double.TryParse(dr["price"].ToString(), out price);
                        double Quantity = 0;
                        double.TryParse(dr["quantity"].ToString(), out Quantity);
                        TotalQuantity += Quantity;
                        double amount = 0; double totamount = 0;
                        totamount = price * Quantity;
                        newrow["TotalAmount"] = totamount;

                        totalamount += totamount;
                        Report.Rows.Add(newrow);
                        rowcount++;
                        DataTable dtin = new DataTable();
                        DataRow[] drr = dtprocurement.Select("ToBranchName='" + presentbranch + "'");
                        if (drr.Length > 0)
                        {
                            dtin = drr.CopyToDataTable();
                        }
                        int dttotalpocount = dtin.Rows.Count;
                        if (dttotalpocount == rowcount)
                        {
                            DataRow newrow1 = Report.NewRow();
                            newrow1["Product Name"] = "Total";
                            newrow1["Quantity"] = Math.Round(TotalQuantity, 2);
                            newrow1["TotalAmount"] = Math.Round(totalamount, 2);
                            Report.Rows.Add(newrow1);
                            gtotalamount += totalamount;
                            gTotalQuantity += TotalQuantity;
                            TotalQuantity = 0;
                            totalamount = 0;
                            rowcount = 1;
                        }
                    }
                    else
                    {
                        prevbranch = presentbranch;
                        newrow["Branch Name"] = dr["ToBranchName"].ToString();
                        newrow["Product Name"] = dr["productname"].ToString();
                        newrow["Price"] = dr["price"].ToString();
                        newrow["Quantity"] = dr["quantity"].ToString();
                        double price = 0;
                        double.TryParse(dr["price"].ToString(), out price);
                        double Quantity = 0;
                        double.TryParse(dr["quantity"].ToString(), out Quantity);
                        TotalQuantity += Quantity;
                        double amount = 0; double totamount = 0;
                        totamount = price * Quantity;
                        newrow["TotalAmount"] = totamount;
                        totalamount += totamount;
                        Report.Rows.Add(newrow);
                        DataTable dtin = new DataTable();
                        DataRow[] drr = dtprocurement.Select("ToBranchName='" + presentbranch + "'");
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
                            newrow1["Quantity"] = Math.Round(TotalQuantity, 2);
                            newrow1["TotalAmount"] = Math.Round(totalamount, 2);
                            Report.Rows.Add(newrow1);
                            gtotalamount += totalamount;
                            gTotalQuantity += TotalQuantity;
                            TotalQuantity = 0;
                            totalamount = 0;
                            count++;
                            rowcount = 1;
                        }
                    }
                }
                gtotalamount += totalamount;
                gTotalQuantity += TotalQuantity;
                DataRow salesreport1 = Report.NewRow();
                salesreport1["Product Name"] = "Grand Total";
                salesreport1["Quantity"] = Math.Round(gTotalQuantity, 2);
                salesreport1["TotalAmount"] = Math.Round(gtotalamount, 2);
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
        }
    }
    protected void grdReports_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (e.Row.Cells[2].Text == "Total")
            {
                e.Row.BackColor = System.Drawing.Color.Aquamarine;
                e.Row.Font.Size = FontUnit.Medium;
                e.Row.Font.Bold = true;
            }
            if (e.Row.Cells[2].Text == "Grand Total")
            {
                e.Row.BackColor = System.Drawing.Color.DeepSkyBlue;
                e.Row.Font.Size = FontUnit.Large;
                e.Row.Font.Bold = true;
            }
        }
    }
}