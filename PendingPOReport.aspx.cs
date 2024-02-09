using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;
public partial class PendingPOReport : System.Web.UI.Page
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
            Report.Columns.Add("Reference No");
            Report.Columns.Add("PO No");
            Report.Columns.Add("PO Date");
            Report.Columns.Add("Supplier Name");
            Report.Columns.Add("Product Name");
            Report.Columns.Add("UOM");
            Report.Columns.Add("Qty Raised");
            Report.Columns.Add("Qty Pending");
            Report.Columns.Add("Status");
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
            cmd = new SqlCommand("SELECT DISTINCT podate, shortname, sno, description, poqty, ponumber, quantity, pono, uim FROM  (SELECT DISTINCT table1.podate, table1.shortname, table1.sno, table1.description, table1.poqty, table1.ponumber, table2.quantity, table2.pono, table1.uim FROM (SELECT  TOP (100) PERCENT po_entrydetailes.podate, po_entrydetailes.shortname, po_entrydetailes.sno, po_sub_detailes.description, po_sub_detailes.qty AS poqty, po_entrydetailes.ponumber, uimmaster.uim, po_sub_detailes.productsno FROM  po_entrydetailes INNER JOIN po_sub_detailes ON po_entrydetailes.sno = po_sub_detailes.po_refno INNER JOIN productmaster ON po_sub_detailes.productsno = productmaster.productid INNER JOIN uimmaster ON productmaster.uim = uimmaster.sno WHERE  (po_entrydetailes.podate BETWEEN @fromdate AND @todate) AND (po_entrydetailes.branchid = @branchid) AND (po_sub_detailes.qty > 0) ORDER BY po_entrydetailes.sno) AS table1 LEFT OUTER JOIN (SELECT DISTINCT subinwarddetails.quantity, inwarddetails.pono, subinwarddetails.productid FROM  inwarddetails INNER JOIN subinwarddetails ON inwarddetails.sno = subinwarddetails.in_refno WHERE  (inwarddetails.inwarddate BETWEEN @fromdate AND @todate) AND (inwarddetails.branchid = @branchid)) AS table2 ON  table1.sno = table2.pono AND table1.productsno = table2.productid) AS derivedtbl_1");
            cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
            cmd.Parameters.Add("@todate", GetHighDate(todate));
            cmd.Parameters.Add("@branchid", branchid);
            DataTable dtpo = vdm.SelectQuery(cmd).Tables[0];
            if (dtpo.Rows.Count > 0)
            {
                double totalqty = 0;
                double totalqty1 = 0;
                double gtotalqty = 0;
                double gtotalqty1 = 0;
                DateTime dt = DateTime.Now;
                string prevdate = string.Empty;
                string prevpono = "";
                var i = 1;
                int count = 1;
                int rowcount = 1;
                DateTime dtapril = new DateTime();
                DateTime dtmarch = new DateTime();
                foreach (DataRow dr in dtpo.Rows)
                {
                    DataRow newrow = Report.NewRow();
                    newrow["Sno"] = i++.ToString();
                    string prespono = dr["sno"].ToString();
                    string date = ((DateTime)dr["podate"]).ToString("dd-MM-yyyy"); //dr["podate"].ToString();
                    DateTime dt_po = Convert.ToDateTime(dr["podate"].ToString());
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
                    string pono = dr["pono"].ToString();
                    if ((prespono != pono) || (prespono == pono))
                    {
                        if (prespono == prevpono)
                        {
                            newrow["Product Name"] = dr["description"].ToString();
                            newrow["UOM"] = dr["uim"].ToString();
                            double poqty = 0; double inwardqty = 0;
                            double.TryParse(dr["poqty"].ToString(), out poqty);
                            totalqty += poqty;
                            double.TryParse(dr["quantity"].ToString(), out inwardqty);
                            double PendingQty = poqty - inwardqty;
                            newrow["Qty Raised"] = dr["poqty"].ToString();
                            newrow["Qty Pending"] = PendingQty;
                            totalqty1 += PendingQty;
                            if (PendingQty != 0)
                            {
                                newrow["Status"] = "P";
                            }
                            else
                            {
                                newrow["Status"] = "V";
                            }
                            Report.Rows.Add(newrow);
                            rowcount++;
                            DataTable dtin = new DataTable();
                            DataRow[] drr = dtpo.Select("sno='" + prespono + "'");
                            if (drr.Length > 0)
                            {
                                dtin = drr.CopyToDataTable();
                            }
                            int dttotalpocount = dtin.Rows.Count;
                            if (dttotalpocount == rowcount)
                            {
                                DataRow newrow1 = Report.NewRow();
                                newrow1["Product Name"] = "Total";
                                newrow1["Qty Raised"] = Math.Round(totalqty, 2); ;
                                newrow1["Qty Pending"] = Math.Round(totalqty1, 2); ;
                                Report.Rows.Add(newrow1);
                                gtotalqty += totalqty;
                                gtotalqty1 += totalqty1;
                                totalqty = 0;
                                totalqty1 = 0;
                                rowcount = 1;
                            }
                        }
                        else
                        {
                            string productname = dr["description"].ToString();

                            prevpono = prespono;
                            newrow["PO Date"] = date.ToString();
                            newrow["Reference No"] = dr["sno"].ToString();
                            newrow["PO NO"] = PO.ToString();
                            newrow["Product Name"] = dr["description"].ToString();
                            newrow["UOM"] = dr["uim"].ToString();
                            newrow["Supplier Name"] = dr["shortname"].ToString();
                            double poqty = 0; double inwardqty = 0;
                            double.TryParse(dr["poqty"].ToString(), out poqty);
                            totalqty += poqty;
                            double.TryParse(dr["quantity"].ToString(), out inwardqty);
                            double PendingQty = poqty - inwardqty;
                            newrow["Qty Raised"] = dr["poqty"].ToString();
                            newrow["Qty Pending"] = PendingQty;
                            totalqty1 += PendingQty;
                            if (PendingQty != 0)
                            {
                                newrow["Status"] = "P";
                            }
                            else
                            {
                                newrow["Status"] = "V";
                            }
                            Report.Rows.Add(newrow);
                            DataTable dtin = new DataTable();
                            DataRow[] drr = dtpo.Select("sno='" + prespono + "'");
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
                                newrow1["Qty Raised"] = totalqty;
                                newrow1["Qty Pending"] = totalqty1;
                                Report.Rows.Add(newrow1);
                                gtotalqty += totalqty;
                                gtotalqty1 += totalqty1;
                                totalqty = 0;
                                totalqty1 = 0;
                                count++;
                                rowcount = 1;
                            }
                        }
                    }
                }
                gtotalqty += totalqty;
                gtotalqty1 += totalqty1;
                DataRow salesreport1 = Report.NewRow();
                salesreport1["Product Name"] = "Grand Total";
                salesreport1["Qty Raised"] = Math.Round(gtotalqty, 2); ;
                salesreport1["Qty Pending"] = Math.Round(gtotalqty1, 2); ;
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