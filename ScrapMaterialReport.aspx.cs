using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

public partial class ScrapMaterialReport : System.Web.UI.Page
{
    SqlCommand cmd;
    ///string BranchID = "";
    SalesDBManager vdm;
    protected void Page_Load(object sender, EventArgs e)
    {
        vdm = new SalesDBManager();
        if (!Page.IsPostBack)
        {
            if (!Page.IsCallback)
            {
                dtp_FromDate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");//Convert.ToString(lblFromDate.Text); ////     /////
                dtp_Todate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");// Convert.ToString(lbltodate.Text);/// //// 
                //  lblAddress.Text = Session["Address"].ToString();
                // lblTitle.Text = Session["TitleName"].ToString();
            }
        }
        //if (Session["Po_BranchID"] == null)
        //    Response.Redirect("Login.aspx");
        //else
        //{
        //    BranchID = Session["Po_BranchID"].ToString();
        //    vdm = new SalesDBManager();
        //    if (!Page.IsPostBack)
        //    {
        //        if (!Page.IsCallback)
        //        {
        //            dtp_FromDate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
        //            dtp_Todate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
        //            lblAddress.Text = Session["Address"].ToString();
        //            lblTitle.Text = Session["TitleName"].ToString();
        //        }
        //    }
        //}
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
            Report.Columns.Add("DATE");
            Report.Columns.Add("Product Name");
            Report.Columns.Add("Quantity");
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
            //cmd = new SqlCommand("SELECT scrapmaterial.doe, productmaster.productname, scrapmaterial.qty  FROM scrapmaterial INNER JOIN  productmaster ON scrapmaterial.productid = productmaster.productid where scrapmaterial.doe between @fromdate and @todate and scrapmaterial.branchid=@branchid");
            cmd = new SqlCommand("SELECT scrapmaterial.doe,scrapmaterial.sno, scrapmaterial.sectionid, scrapmaterial.name, productmaster.productname, subscrapmaterial.productid, subscrapmaterial.qty FROM scrapmaterial INNER JOIN subscrapmaterial ON scrapmaterial.sno = subscrapmaterial.sm_refno INNER JOIN productmaster ON subscrapmaterial.productid = productmaster.productid WHERE (scrapmaterial.doe BETWEEN @fromdate AND @todate) AND (scrapmaterial.branchid = @branchid)");
            cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
            cmd.Parameters.Add("@todate", GetHighDate(todate));
            cmd.Parameters.Add("@branchid", branchid);
            DataTable dtInward = SalesDB.SelectQuery(cmd).Tables[0];

            if (dtInward.Rows.Count > 0)
            {
                double totalquantity = 0;
                var i = 1;
                foreach (DataRow dr in dtInward.Rows)
                {
                    DataRow newrow = Report.NewRow();
                    newrow["Sno"] = i++.ToString();
                    newrow["Quantity"] = dr["qty"].ToString();
                    newrow["Product Name"] = dr["productname"].ToString();
                    newrow["DATE"] = ((DateTime)dr["doe"]).ToString("dd-MM-yyyy"); //dr["doe"].ToString();
                    double qty = 0;
                    double.TryParse(dr["qty"].ToString(), out qty);
                    totalquantity += qty;
                    Report.Rows.Add(newrow);
                }
                DataRow stockreport = Report.NewRow();
                stockreport["Product Name"] = "TotalQty";
                stockreport["Quantity"] = totalquantity;
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
 }
