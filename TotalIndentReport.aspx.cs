using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;
public partial class TotalIndentReport : System.Web.UI.Page
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
            Report.Columns.Add("Indent No");
            Report.Columns.Add("Indent Date");
            Report.Columns.Add("Section Name");
            Report.Columns.Add("Product Name");
            Report.Columns.Add("Quantity");
            Report.Columns.Add("Price");
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
            cmd = new SqlCommand("SELECT  sectionmaster.name SectionName, indents.sectionid, indents.i_date, indents.name AS IndenterName, indents.remarks, indents.entry_by, indents.status, indent_subtable.productid, productmaster.productname, indent_subtable.qty, indent_subtable.indentno AS refno, indent_subtable.price, indent_subtable.sno AS subsno, indents.sno AS indentsno FROM productmaster INNER JOIN indents INNER JOIN indent_subtable ON indents.sno = indent_subtable.indentno INNER JOIN sectionmaster ON indents.sectionid = sectionmaster.sectionid ON productmaster.productid = indent_subtable.productid  WHERE  (indents.i_date between @fromdate and @todate) AND (indents.branch_id=@branchid) and (indent_subtable.qty>0)  order by indents.sno");
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
                foreach (DataRow dr in dttotalinward.Rows)
                {
                    DataRow newrow = Report.NewRow();
                    newrow["Sno"] = i++.ToString();
                    string prespono = dr["indentsno"].ToString();
                    string date = ((DateTime)dr["i_date"]).ToString("dd-MM-yyyy"); //dr["i_date"].ToString();
                    //DateTime dtdoe = Convert.ToDateTime(dr["outwarddate"].ToString());
                    //string currentdate = dtdoe.ToString("dd/MM/yyyy");
                    //string date = dtdoe.ToString("dd/MM/yyyy");
                    if (prespono == prevpono)
                    {
                        newrow["Product Name"] = dr["productname"].ToString();
                        double price = 0;
                        double.TryParse(dr["price"].ToString(), out price);
                        totalprice += price;
                        newrow["Price"] = price.ToString("f2");
                        double qty = 0;
                        double.TryParse(dr["qty"].ToString(), out qty);
                        totalqty += qty;
                        newrow["Quantity"] = dr["qty"].ToString();
                        double total; double totamount = 0;
                        total = qty * price;
                        totamount += total;
                        double totalamount = 0;
                        totalamount = totamount;//grand total in that coming
                        newrow["Total Amount"] = totalamount.ToString("f2");
                        ttotalamount += totalamount;
                        Report.Rows.Add(newrow);
                        rowcount++;
                        DataTable dtin = new DataTable();
                        DataRow[] drr = dttotalinward.Select("indentsno='" + prespono + "'");
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
                            newrow1["Total Amount"] = ttotalamount.ToString("f2");
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
                        prevpono = prespono;
                        newrow["Indent Date"] = date.ToString();
                      //newrow["Referance No"] = dr["indentsno"].ToString();
                        newrow["Indent No"] = dr["indentsno"].ToString();
                        newrow["Section Name"] = dr["SectionName"].ToString();
                        newrow["Product Name"] = dr["productname"].ToString();
                        double price = 0;
                        double.TryParse(dr["price"].ToString(), out price);
                        totalprice += price;
                        newrow["Price"] = price.ToString("f2");
                        double qty = 0;
                        double.TryParse(dr["qty"].ToString(), out qty);
                        totalqty += qty;
                        newrow["Quantity"] = dr["qty"].ToString();
                        double total = 0; double totamount = 0;
                        total = qty * price;
                        totamount += total;
                        double totalamount = 0;
                        totalamount = totamount;//grand total in that coming
                        newrow["Total Amount"] = totalamount.ToString("f2");
                        ttotalamount += totalamount;
                        Report.Rows.Add(newrow);
                     //if (count == 1)
                      //{
                        DataTable dtin = new DataTable();
                        DataRow[] drr = dttotalinward.Select("indentsno='" + prespono + "'");
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
                            newrow1["Total Amount"] = ttotalamount.ToString("f2");
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
                gtotalqty += totalqty;
                gtotalamount += ttotalamount;
                DataRow salesreport1 = Report.NewRow();
                salesreport1["Product Name"] = "Grand Total";
                gtotalqty = Math.Round(gtotalqty, 2);
                salesreport1["Quantity"] = gtotalqty;
                gtotalamount = Math.Round(gtotalamount, 2);
                salesreport1["Total Amount"] = gtotalamount.ToString("f2");
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
            if (e.Row.Cells[4].Text == "Total")
            {
                e.Row.Font.Size = FontUnit.Medium;
                e.Row.Font.Bold = true;
                e.Row.BackColor = System.Drawing.Color.DeepSkyBlue;
            }
            if (e.Row.Cells[4].Text == "Grand Total")
            {
                e.Row.BackColor = System.Drawing.Color.CadetBlue;
                e.Row.Font.Size = FontUnit.Large;
                e.Row.Font.Bold = true;
            }
        }
    }
}