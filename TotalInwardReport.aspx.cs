using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;
public partial class TotalInwardReport : System.Web.UI.Page
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
            Report.Columns.Add("Inward Date");
            Report.Columns.Add("Referance No");
            Report.Columns.Add("MRN No");
            Report.Columns.Add("Supplier Name");
            Report.Columns.Add("Product Name");
            Report.Columns.Add("Quantity");
            Report.Columns.Add("Price");
            Report.Columns.Add("CST Value");
            Report.Columns.Add("ED Value");
            Report.Columns.Add("PandF");
            Report.Columns.Add("Discount");
            Report.Columns.Add("Fright Amount");
            Report.Columns.Add("Taxable Amount");
            Report.Columns.Add("Tax Amount");
            Report.Columns.Add("Discount Amount");
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


            cmd = new SqlCommand("SELECT    inwarddetails.mrnno,inwarddetails.sno AS inwardsno, CONVERT(VARCHAR(20),inwarddetails.inwarddate, 103) AS inwarddate, inwarddetails.invoiceno,  inwarddetails.podate, inwarddetails.doorno, inwarddetails.remarks, inwarddetails.pono, inwarddetails.inwardno,suppliersdetails.name,subinwarddetails.quantity, subinwarddetails.perunit, subinwarddetails.igst, subinwarddetails.cgst, subinwarddetails.sgst, subinwarddetails.dis,  productmaster.productname, productmaster.sku FROM inwarddetails INNER JOIN subinwarddetails ON inwarddetails.sno = subinwarddetails.in_refno INNER JOIN productmaster ON productmaster.productid = subinwarddetails.productid INNER JOIN suppliersdetails ON suppliersdetails.supplierid=inwarddetails.supplierid  WHERE  (inwarddetails.inwarddate between @fromdate and @todate) AND inwarddetails.branchid=@branchid and (subinwarddetails.quantity>0) order by inwarddetails.sno");
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
                    DateTime dt = DateTime.Now;
                    string prevdate = string.Empty;
                    string prevpono = "";
                    var i = 1;
                    int count = 1;
                    int rowcount = 1;
                    double taxamttotal = 0;
                    double Taxabletotal = 0;
                    foreach (DataRow dr in dttotalinward.Rows)
                    {
                        DataRow newrow = Report.NewRow();
                        newrow["Sno"] = i++.ToString();
                        string prespono = dr["inwardsno"].ToString();
                        string date = dr["inwarddate"].ToString();
                        if (prespono == prevpono)
                        {
                            newrow["Product Name"] = dr["productname"].ToString();
                            double price = 0;
                            double.TryParse(dr["perunit"].ToString(), out price);
                            totalprice += price;
                            newrow["Price"] = price.ToString("f2");
                            double qty = 0;
                            double.TryParse(dr["quantity"].ToString(), out qty);
                            totalqty += qty;
                            newrow["Quantity"] = qty.ToString();
                            double total; double totamount = 0;
                            total = qty * price;
                            totamount += total;
                            double totalamount = 0;
                            newrow["Taxable Amount"] = totamount;
                            Taxabletotal += totamount;

                            double igst = 0;
                            double.TryParse(dr["igst"].ToString(), out igst);
                            double cgst = 0;
                            double.TryParse(dr["cgst"].ToString(), out cgst);
                            double sgst = 0;
                            double.TryParse(dr["sgst"].ToString(), out sgst);
                            double tax = igst + sgst + cgst;
                            double taxamt = (totamount * tax) / 100;


                            double dis = 0;
                            double.TryParse(dr["dis"].ToString(), out dis);
                            double DISCOUNT = (totamount * dis) / 100;

                            newrow["Discount Amount"] = DISCOUNT;
                            newrow["Tax Amount"] = taxamt;
                            taxamttotal += taxamt;
                            totalamount = totamount + taxamt;
                            totalamount = totalamount - DISCOUNT;
                            newrow["Total Amount"] = totalamount.ToString("f2");
                            ttotalamount += totalamount;
                            Report.Rows.Add(newrow);
                            rowcount++;
                            DataTable dtin = new DataTable();
                            DataRow[] drr = dttotalinward.Select("inwardsno='" + prespono + "'");
                            if (drr.Length > 0)
                            {
                                dtin = drr.CopyToDataTable();
                            }
                            int dttotalpocount = dtin.Rows.Count;
                            if (dttotalpocount == rowcount)
                            {
                                gtotalqty += totalqty;
                                gtotalamount += ttotalamount;
                                ttotalamount = 0;
                                totalqty = 0;
                                rowcount = 1;
                            }
                        }
                        else
                        {
                            prevpono = prespono;
                            newrow["Inward Date"] = date.ToString();
                            newrow["Referance No"] = dr["inwardsno"].ToString();
                            newrow["MRN No"] = dr["mrnno"].ToString();
                            newrow["Supplier Name"] = dr["name"].ToString();
                            newrow["Product Name"] = dr["productname"].ToString();
                            double price = 0;
                            double.TryParse(dr["perunit"].ToString(), out price);
                            totalprice += price;
                            newrow["Price"] = price.ToString("f2");
                            double qty = 0;
                            double.TryParse(dr["quantity"].ToString(), out qty);
                            totalqty += qty;
                            newrow["Quantity"] = qty.ToString();
                            double total = 0; double totamount = 0;
                            total = qty * price;
                            totamount += total;
                            double totalamount = 0;
                            newrow["Taxable Amount"] = totamount;
                            Taxabletotal += totamount;
                            double igst = 0;
                            double.TryParse(dr["igst"].ToString(), out igst);
                            double cgst = 0;
                            double.TryParse(dr["cgst"].ToString(), out cgst);
                            double sgst = 0;
                            double.TryParse(dr["sgst"].ToString(), out sgst);
                            double tax = igst + sgst + cgst;
                            double taxamt = (totamount * tax) / 100;
                            newrow["Tax Amount"] = taxamt;

                            double dis = 0;
                            double.TryParse(dr["dis"].ToString(), out dis);
                            double DISCOUNT = (totamount * dis) / 100;
                            newrow["Discount Amount"] = DISCOUNT;

                            taxamttotal += taxamt;
                            totalamount = totamount + taxamt;
                            totalamount = totalamount - DISCOUNT;
                            newrow["Total Amount"] = totalamount.ToString("f2");
                            ttotalamount += totalamount;
                            Report.Rows.Add(newrow);
                            DataTable dtin = new DataTable();
                            DataRow[] drr = dttotalinward.Select("inwardsno='" + prespono + "'");
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
                                gtotalqty += totalqty;
                                gtotalamount += ttotalamount;
                                ttotalamount = 0;
                                totalqty = 0;
                                count++;
                                rowcount = 1;
                            }
                        }
                    }
                    gtotalqty += totalqty;
                    gtotalamount += ttotalamount;
                    DataRow salesreport1 = Report.NewRow();
                    salesreport1["Product Name"] = "Grand Total";
                    gtotalqty = Math.Round(gtotalqty, 2);
                    salesreport1["Quantity"] = gtotalqty;
                    gtotalamount = Math.Round(gtotalamount, 2);
                    salesreport1["Total Amount"] = gtotalamount.ToString("f2");
                    salesreport1["Tax Amount"] = taxamttotal.ToString("f2");
                    salesreport1["Taxable Amount"] = Taxabletotal.ToString("f2");
                    Report.Rows.Add(salesreport1);
                    foreach (var column in Report.Columns.Cast<DataColumn>().ToArray())
                    {
                        if (Report.AsEnumerable().All(dr => dr.IsNull(column)))
                            Report.Columns.Remove(column);
                    }
                    grdReports.DataSource = Report;
                    grdReports.DataBind();
                    Session["xportdata"] = Report;
                    Session["filename"] = "Inward Report";
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
            if (e.Row.Cells[8].Text != "Total")
            {
                e.Row.Cells[8].HorizontalAlign = HorizontalAlign.Right;
            }
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