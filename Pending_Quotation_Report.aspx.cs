using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

public partial class Pending_Quotation_Report : System.Web.UI.Page
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
        Report.Columns.Add("Sno");
        Report.Columns.Add("RFQ No");
        Report.Columns.Add("RFQ Date");
        Report.Columns.Add("Supplier Name");
        Report.Columns.Add("Product Name");
        Report.Columns.Add("UOM");
        Report.Columns.Add("Quantity");
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
        cmd = new SqlCommand("SELECT quotation_request.sno, quotation_request.quotationno, quotation_request.suplierid, quotation_request.branchid, quotation_request.doe, quotation_request.quotationdate, quotation_request.entryby, quotation_request.entrydate, quotation_request.modifiedby, quotation_request.modifieddate, quotation_request.indentno, quotation_req_subdetails.productid, quotation_req_subdetails.qty, quotation_req_subdetails.sno AS subsno, suppliersdetails.name, productmaster.productname, uimmaster.uim FROM quotation_request INNER JOIN quotation_req_subdetails ON quotation_request.sno = quotation_req_subdetails.quotation_refno INNER JOIN suppliersdetails ON quotation_request.suplierid = suppliersdetails.supplierid INNER JOIN productmaster ON quotation_req_subdetails.productid = productmaster.productid INNER JOIN uimmaster ON productmaster.uim = uimmaster.sno WHERE (quotation_request.quotationdate BETWEEN @fromdate AND @todate)");
        cmd.Parameters.Add("@fromdate", fromdate);
        cmd.Parameters.Add("@todate", todate);
        DataTable dt_rfq_details = vdm.SelectQuery(cmd).Tables[0];
        int a = 1;
        if (dt_rfq_details.Rows.Count > 0)
        {
            string pre_rfqno = "";
            foreach (DataRow dr in dt_rfq_details.Rows)
            {
                string rfqno = dr["quotationno"].ToString();
                cmd = new SqlCommand("SELECT sno, quotationno, supplierid, quotationdate, branchid, doe, entryby, modifiedby, modifieddate, pricebasis, paymentmode, despatchmode, deliveryterms, frieght, transport, insurance, others, billingto, shipto, pandf, vqno FROM vendor_quotationdetails WHERE (quotationno = @quotationno)");
                cmd.Parameters.Add("@quotationno", dr["quotationno"].ToString());
                DataTable dt_ven_details = vdm.SelectQuery(cmd).Tables[0];

                if (dt_ven_details.Rows.Count > 0)
                {

                }
                else
                {
                    if (rfqno == pre_rfqno)
                    {
                        DataRow newrow = Report.NewRow();
                        newrow["Sno"] = a;
                        newrow["Product Name"] = dr["productname"].ToString();
                        newrow["UOM"] = dr["uim"].ToString();
                        newrow["Quantity"] = dr["qty"].ToString();
                        Report.Rows.Add(newrow);
                    }
                    else
                    {
                        DataRow newrow = Report.NewRow();
                        newrow["Sno"] = a;
                        newrow["RFQ No"] = dr["quotationno"].ToString();
                        string rfqdate1 = dr["quotationdate"].ToString();
                        string[] date2 = rfqdate1.Split(' ');
                        string date1 = date2[0];
                        string[] date = date1.Split('/');
                        string rfqdate = date[1] + "-" + date[0] + "-" + date[2];
                        newrow["RFQ Date"] = rfqdate;
                        newrow["Supplier Name"] = dr["name"].ToString();
                        newrow["Product Name"] = dr["productname"].ToString();
                        newrow["UOM"] = dr["uim"].ToString();
                        newrow["Quantity"] = dr["qty"].ToString();
                        Report.Rows.Add(newrow);
                        pre_rfqno = dr["quotationno"].ToString();
                    }
                    a++;
                }
            }
        }
        grdReports.DataSource = Report;
        grdReports.DataBind();
        hidepanel.Visible = true;
    }
    protected void grdReports_RowDataBound(object sender, GridViewRowEventArgs e)
    {

    }
}