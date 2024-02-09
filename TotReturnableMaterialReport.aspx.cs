using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

public partial class ReturnableMaterialReport : System.Web.UI.Page
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
            Report.Columns.Add("RIG No");
            Report.Columns.Add("RIG Date");
            Report.Columns.Add("Receiver Name");
            Report.Columns.Add("Product Name");
            Report.Columns.Add("Quantity");
            Report.Columns.Add("Remarks");
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
            if (ddlReturnable.SelectedValue == "All")
            {
                cmd = new SqlCommand("SELECT  tools_issue_receive.sno,tools_issue_receive.status, tools_issue_receive.issueremarks, branchmaster.branchid, tools_issue_receive.issudate, sectionmaster.sectionid,  tools_issue_receive.name, tools_issue_receive.type, tools_issue_receive.branch_id, tools_issue_receive.section__id, sectionmaster.name AS sectionname,branchmaster.branchname, productmaster.productname, tools_issue_receive.others, subtools_issue_receive.productid, subtools_issue_receive.quantity FROM tools_issue_receive INNER JOIN subtools_issue_receive ON tools_issue_receive.sno = subtools_issue_receive.r_refno INNER JOIN productmaster ON subtools_issue_receive.productid = productmaster.productid LEFT OUTER JOIN sectionmaster ON tools_issue_receive.section__id = sectionmaster.sectionid LEFT OUTER JOIN branchmaster ON tools_issue_receive.branch_id = branchmaster.branchid WHERE (tools_issue_receive.issudate BETWEEN @fromdate AND @todate) AND (tools_issue_receive.branchid = @branchid)");
                cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
                cmd.Parameters.Add("@todate", GetHighDate(todate));
                cmd.Parameters.Add("@branchid", branchid);
            }
            if (ddlReturnable.SelectedValue == "Verified")
            {
                cmd = new SqlCommand("SELECT  tools_issue_receive.sno,tools_issue_receive.status, tools_issue_receive.issueremarks, branchmaster.branchid, tools_issue_receive.issudate, sectionmaster.sectionid,  tools_issue_receive.name, tools_issue_receive.type, tools_issue_receive.branch_id, tools_issue_receive.section__id, sectionmaster.name AS sectionname,branchmaster.branchname, productmaster.productname, tools_issue_receive.others, subtools_issue_receive.productid, subtools_issue_receive.quantity FROM tools_issue_receive INNER JOIN subtools_issue_receive ON tools_issue_receive.sno = subtools_issue_receive.r_refno INNER JOIN productmaster ON subtools_issue_receive.productid = productmaster.productid LEFT OUTER JOIN sectionmaster ON tools_issue_receive.section__id = sectionmaster.sectionid LEFT OUTER JOIN branchmaster ON tools_issue_receive.branch_id = branchmaster.branchid WHERE (tools_issue_receive.issudate BETWEEN @fromdate AND @todate) AND (tools_issue_receive.status='V') AND (tools_issue_receive.branchid = @branchid)");
                cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
                cmd.Parameters.Add("@todate", GetHighDate(todate));
                cmd.Parameters.Add("@branchid", branchid);
            }
            if (ddlReturnable.SelectedValue == "Pending")
            {
                cmd = new SqlCommand("SELECT  tools_issue_receive.sno,tools_issue_receive.status, tools_issue_receive.issueremarks, branchmaster.branchid, tools_issue_receive.issudate, sectionmaster.sectionid,  tools_issue_receive.name, tools_issue_receive.type, tools_issue_receive.branch_id, tools_issue_receive.section__id, sectionmaster.name AS sectionname,branchmaster.branchname, productmaster.productname, tools_issue_receive.others, subtools_issue_receive.productid, subtools_issue_receive.quantity FROM tools_issue_receive INNER JOIN subtools_issue_receive ON tools_issue_receive.sno = subtools_issue_receive.r_refno INNER JOIN productmaster ON subtools_issue_receive.productid = productmaster.productid LEFT OUTER JOIN sectionmaster ON tools_issue_receive.section__id = sectionmaster.sectionid LEFT OUTER JOIN branchmaster ON tools_issue_receive.branch_id = branchmaster.branchid WHERE (tools_issue_receive.issudate BETWEEN @fromdate AND @todate) AND (tools_issue_receive.status='P') AND (tools_issue_receive.branchid = @branchid)");
                cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
                cmd.Parameters.Add("@todate", GetHighDate(todate));
                cmd.Parameters.Add("@branchid", branchid);
            }
            DataTable dtreturn = SalesDB.SelectQuery(cmd).Tables[0];
            if (dtreturn.Rows.Count > 0)
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
                foreach (DataRow dr in dtreturn.Rows)
                {
                    DataRow newrow = Report.NewRow();
                    newrow["Sno"] = i++.ToString();
                    string prespono = dr["sno"].ToString();
                    string date = ((DateTime)dr["issudate"]).ToString("dd-MM-yyyy"); //dr["issudate"].ToString();
                    //DateTime dtdoe = Convert.ToDateTime(dr["outwarddate"].ToString());
                    //string currentdate = dtdoe.ToString("dd/MM/yyyy");
                    //string date = dtdoe.ToString("dd/MM/yyyy");
                    if (prespono == prevpono)
                    {
                        newrow["Product Name"] = dr["productname"].ToString();
                        double price = 0;
                        double qty = 0;
                        double.TryParse(dr["quantity"].ToString(), out qty);
                        totalqty += qty;
                        newrow["Quantity"] = dr["quantity"].ToString();
                        Report.Rows.Add(newrow);
                        rowcount++;
                        DataTable dtin = new DataTable();
                        DataRow[] drr = dtreturn.Select("sno='" + prespono + "'");
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
                            Report.Rows.Add(newrow1);
                            gtotalqty += totalqty;
                            totalqty = 0;
                            rowcount = 1;
                        }
                    }
                    else
                    {
                        
                        prevpono = prespono;
                        newrow["RIG Date"] = date.ToString();
                        newrow["RIG No"] = dr["sno"].ToString();
                        newrow["Status"] = dr["status"].ToString();
                        newrow["Remarks"] = dr["issueremarks"].ToString();
                        newrow["Receiver Name"] = dr["name"].ToString();
                        newrow["Product Name"] = dr["productname"].ToString();
                        double qty = 0;
                        double.TryParse(dr["quantity"].ToString(), out qty);
                        totalqty += qty;
                        newrow["Quantity"] = dr["quantity"].ToString();
                        Report.Rows.Add(newrow);
                        //if (count == 1)
                        //{
                        DataTable dtin = new DataTable();
                        DataRow[] drr = dtreturn.Select("sno='" + prespono + "'");
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
                            Report.Rows.Add(newrow1);
                            gtotalqty += totalqty;
                            totalqty = 0;
                            count++;
                            rowcount = 1;
                        }
                        //}
                    }
                }
                gtotalqty += totalqty;
                DataRow salesreport1 = Report.NewRow();
                salesreport1["Product Name"] = "Grand Total";
                gtotalqty = Math.Round(gtotalqty, 2);
                salesreport1["Quantity"] = gtotalqty;
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
            if (e.Row.Cells[3].Text == "Total")
            {
                e.Row.Font.Size = FontUnit.Medium;
                e.Row.Font.Bold = true;
            }
            if (e.Row.Cells[3].Text == "Grand Total")
            {
                e.Row.BackColor = System.Drawing.Color.DeepSkyBlue;
                e.Row.Font.Size = FontUnit.Large;
                e.Row.Font.Bold = true;
            }
        }
    }
}