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

public partial class Branch_Transfer_Report : System.Web.UI.Page
{
    SqlCommand cmd;
    SalesDBManager vdm;
    public string tempinvoiceno = string.Empty;
    public double temptotal = 0.0;
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
                    //ddlbranchname.Visible = false;
                    //Label1.Visible = false;
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
            Report.Columns.Add("Voucher Date");
            Report.Columns.Add("Voucher No");
            Report.Columns.Add("Item Name");
            Report.Columns.Add("Qty");
            Report.Columns.Add("Rate");
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
            lblFromDate.Text = fromdate.ToString("dd/MM/yyyy");
            lbltodate.Text = todate.ToString("dd/MM/yyyy");
            string branch_id = Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT stocktransferdetails.remarks, stocktransferdetails.stock_sno,stocktransferdetails.transportname,stocktransferdetails.invoicetype,stocktransferdetails.invoiceno, stocktransferdetails.invoicedate AS invoicedate,stocktransferdetails.vehicleno,stocktransfersubdetails.price,stocktransfersubdetails.taxvalue,stocktransfersubdetails.taxtype,stocktransfersubdetails.freigtamt,stocktransferdetails.sno as refno,stocktransfersubdetails.sno,branchmaster.branchname, branchmaster_1.branchname AS BranchName, productmaster.productname, stocktransferdetails.frombranch, stocktransferdetails.tobranch,  stocktransfersubdetails.quantity, stocktransfersubdetails.stock_refno, stocktransfersubdetails.productid, stocktransferdetails.doe FROM  stocktransferdetails INNER JOIN stocktransfersubdetails ON stocktransferdetails.sno = stocktransfersubdetails.stock_refno LEFT OUTER JOIN  branchmaster ON stocktransferdetails.frombranch = branchmaster.branchid LEFT OUTER JOIN branchmaster AS branchmaster_1 ON stocktransferdetails.tobranch = branchmaster_1.branchid INNER JOIN productmaster ON stocktransfersubdetails.productid = productmaster.productid where (stocktransferdetails.invoicedate between @fromdate and @todate) AND (stocktransferdetails.branch_id=@branch_id) and (stocktransfersubdetails.quantity>0) order by rand(stocktransferdetails.invoiceno) asc");
            cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
            cmd.Parameters.Add("@todate", GetHighDate(todate));
            cmd.Parameters.Add("@branch_id", branch_id);
            DataTable dtstocktransfer = SalesDB.SelectQuery(cmd).Tables[0];
            if (dtstocktransfer.Rows.Count > 0)
            {
                double total_amount = 0, totamt = 0, totalprice = 0, totalqty = 0, totaltaxamt = 0, gtotaltaxamt = 0, taxamount = 0, ttaxamount = 0, ttotalamount = 0;
                int count = 1;
                int rowcount = 1;
                double tfreight = 0, gtotalqty = 0, gtotalamount = 0, gfrightamt = 0, gtaxamount = 0;
                string previnvoiceno = "";
                foreach (DataRow dr in dtstocktransfer.Rows)
                {
                    string date = dr["invoicedate"].ToString();
                    if (date != "")
                    {
                        DataRow newrow = Report.NewRow();
                        string invoiceno = dr["invoiceno"].ToString();
                        DateTime dtdate = Convert.ToDateTime(date);
                        string invoicedate = dtdate.ToString("dd-MMM-yyyy");
                        newrow["Voucher No"] = "SVDS/PBK/ST/" + dr["invoiceno"].ToString() + "";
                        newrow["Voucher Date"] = invoicedate;
                        newrow["Item Name"] = dr["productname"].ToString();
                        double price = 0;
                        double.TryParse(dr["price"].ToString(), out price);
                        totalprice += price;
                        newrow["Rate"] = Math.Round(price, 2); //dr["price"].ToString();
                        double qty = 0;
                        double.TryParse(dr["quantity"].ToString(), out qty);
                        totalqty += qty;
                        newrow["Qty"] = dr["quantity"].ToString();
                        double total = 0; double totamount = 0;
                        total = qty * price;
                        totamount += total;
                        double taxamt = 0;
                        double.TryParse(dr["taxvalue"].ToString(), out taxamt);
                        totaltaxamt += taxamt;
                        gtotaltaxamt += totaltaxamt;
                        taxamount = (total * taxamt) / 100;
                        //newrow["Tax Amount"] = taxamount;
                        ttaxamount += taxamount;
                        double freight = 0;
                        double.TryParse(dr["freigtamt"].ToString(), out freight);
                        tfreight += freight;
                        totamount = total + taxamount + freight;
                        double totalamount = 0;
                        totalamount = totamount;
                        newrow["Amount"] = Math.Round(totalamount, 2);
                        ttotalamount += totalamount;
                        newrow["Narration"] = "Being  " + dr["remarks"].ToString() + "  From SVDS Punabaka,Invoice No: " + dr["invoiceno"].ToString() + ",Inv Dt" + dr["invoicedate"].ToString() + ",Amount" + totalamount + "";
                        Report.Rows.Add(newrow);
                    }
                }
                Session["xportdata"] = Report;
                Session["filename"] = "Branch Transfer report";
                grdReports.DataSource = Report;
                grdReports.DataBind();
                hidepanel.Visible = true;
            }
        }
        catch (Exception ex)
        { 
            
        }
    }
    protected void gvMenu_DataBinding(object sender, EventArgs e)
    {

    }
    protected void grdReports_RowDataBound(object sender, GridViewRowEventArgs e)
    {

    }
 
}