using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

public partial class storesmrnrport : System.Web.UI.Page
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
            Report.Columns.Add("Voucher Date");
            Report.Columns.Add("Voucher No");
            Report.Columns.Add("Item Name");
            Report.Columns.Add("Qty");
            Report.Columns.Add("Rate");
            Report.Columns.Add("Amount");
            Report.Columns.Add("Narration");
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
            DateTime ServerDateCurrentdate = fromdate;
            DateTime dtapril = new DateTime();
            DateTime dtmarch = new DateTime();
            int currentyear = ServerDateCurrentdate.Year;
            int nextyear = ServerDateCurrentdate.Year + 1;
            int currntyearnum = 0;
            int nextyearnum = 0;
            if (ServerDateCurrentdate.Month > 3)
            {
                string apr = "4/1/" + currentyear;
                dtapril = DateTime.Parse(apr);
                string march = "3/31/" + nextyear;
                dtmarch = DateTime.Parse(march);
                currntyearnum = currentyear;
                nextyearnum = nextyear;
            }
            if (ServerDateCurrentdate.Month <= 3)
            {
                string apr = "4/1/" + (currentyear - 1);
                dtapril = DateTime.Parse(apr);
                string march = "3/31/" + (nextyear - 1);
                dtmarch = DateTime.Parse(march);
                currntyearnum = currentyear - 1;
                nextyearnum = nextyear - 1;
            }







            string branchid = Session["Po_BranchID"].ToString();
            string branchcode = Session["BranchCode"].ToString();
            
            //cmd = new SqlCommand("SELECT pono from inwarddetails where inwarddate between @fromdate and @todate AND branchid=@branchid order by inwarddetails.sno");
            //cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
            //cmd.Parameters.Add("@todate", GetHighDate(todate));
            //cmd.Parameters.Add("@branchid", branchid);
            //DataTable dtinwards = vdm.SelectQuery(cmd).Tables[0];
            ////foreach (DataRow dr in dtinwards.Rows)
            ////{
            ////    mypo = dr["pono"].ToString();
            ////}
            //mypo = dtinwards.Rows[0]["pono"].ToString();
            //if (mypo == "")
            //{

            cmd = new SqlCommand("SELECT  inwarddetails.transportcharge, subinwarddetails.igst, subinwarddetails.cgst, subinwarddetails.sgst, inwarddetails.remarks, inwarddetails.freigtamt,  subinwarddetails.tax, inwarddetails.mrnno, inwarddetails.invoiceno, inwarddetails.invoicedate, subinwarddetails.edtax, inwarddetails.pfid, inwarddetails.sno AS inwardsno, inwarddetails.inwarddate AS inwarddate, inwarddetails.invoiceno,  inwarddetails.podate, inwarddetails.doorno, inwarddetails.remarks, inwarddetails.pono, inwarddetails.inwardno,suppliersdetails.name,subinwarddetails.quantity, subinwarddetails.perunit,  productmaster.productname, productmaster.sku FROM inwarddetails INNER JOIN subinwarddetails ON inwarddetails.sno = subinwarddetails.in_refno INNER JOIN productmaster ON productmaster.productid = subinwarddetails.productid INNER JOIN suppliersdetails ON suppliersdetails.supplierid=inwarddetails.supplierid  WHERE  (inwarddetails.inwarddate between @fromdate and @todate) AND inwarddetails.branchid=@branchid and (subinwarddetails.quantity>0) order by inwarddetails.sno");
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
                    double transport = 0;
                    double transportval = 0;
                    double freight = 0;
                    string mrnno = dr["mrnno"].ToString();
                    cmd = new SqlCommand("SELECT  count(*) as count FROM inwarddetails INNER JOIN subinwarddetails ON inwarddetails.sno = subinwarddetails.in_refno  WHERE  (inwarddetails.mrnno = @mrnno)");
                    cmd.Parameters.Add("@mrnno", mrnno);
                    DataTable dtmrn = vdm.SelectQuery(cmd).Tables[0];
                    double mrnval = 0;
                    if (dtmrn.Rows.Count > 0)
                    {
                        string mrncount = dtmrn.Rows[0]["count"].ToString();
                        if (mrncount != "")
                        {
                            mrnval = Convert.ToDouble(mrncount);
                        }
                        double.TryParse(dr["transportcharge"].ToString(), out transport);
                        transportval = transport / mrnval;

                        double freightval = 0;
                        double.TryParse(dr["freigtamt"].ToString(), out freightval);
                        freight = freightval / mrnval;
                    }
                    string prespono = dr["inwardsno"].ToString();
                    string date1 = dr["inwarddate"].ToString();
                    DateTime date2 = Convert.ToDateTime(date1);
                    string date = date2.ToString("dd/MM/yyyy");
                    DateTime dttime = Convert.ToDateTime(date1);
                    newrow["Voucher Date"] = dttime.ToString("dd-MMM-yyyy");
                    newrow["Voucher No"] = "" + branchcode + "MRN0" + dr["mrnno"].ToString() + "";
                    string supliername = dr["name"].ToString();
                    newrow["Item Name"] = dr["productname"].ToString();
                    string productname = dr["productname"].ToString();
                    double price = 0;
                    double.TryParse(dr["perunit"].ToString(), out price);
                    totalprice += price;
                    newrow["Rate"] = dr["perunit"].ToString();
                    double qty = 0;
                    double.TryParse(dr["quantity"].ToString(), out qty);
                    totalqty += qty;


                    //double qty = 0;
                    //double.TryParse(dr["quantity"].ToString(), out qty);









                    string UOM = "";
                    newrow["Qty"] = dr["quantity"].ToString();
                    double total = 0; double totamount = 0;
                    total = qty * price;
                    totamount += total;
                    double ed = 0, totaled = 0;
                    double.TryParse(dr["edtax"].ToString(), out ed);
                    totaled = (ed * total) / 100;


                    double pf = 0, totalpf = 0;
                    double.TryParse(dr["pfid"].ToString(), out pf);
                    totalpf = (pf * total) / 100;
                    if (mrnval == 0)
                    {
                        mrnval = 1;
                        totalpf = totalpf / mrnval;
                    }
                    else
                    {
                        totalpf = totalpf / mrnval;
                    }
                    //total = total + totaled + totalpf;
                    //double taxamt = 0, taxamount = 0;
                    //double.TryParse(dr["tax"].ToString(), out taxamt);
                    //taxamount = (total * taxamt) / 100;

                    double igst = 0;
                    double.TryParse(dr["igst"].ToString(), out igst);
                    double cgst = 0;
                    double.TryParse(dr["cgst"].ToString(), out cgst);
                    double sgst = 0;
                    double.TryParse(dr["sgst"].ToString(), out sgst);
                    double tax = igst + sgst + cgst;
                    double taxamount = (total * tax) / 100;



                    totamount = total + taxamount + freight + transportval + totalpf;
                    double totalamount = 0;
                    totalamount = totamount;//grand total in that coming
                    newrow["Amount"] = Math.Round(totalamount, 2);
                    ttotalamount += totalamount;
                    string invoiceno = dr["invoiceno"].ToString();
                    string invoicedate = dr["invoicedate"].ToString();
                    string remarks = dr["invoicedate"].ToString();
                    //string narration = dr["remarks"].ToString();
                    string narration = "Being Purchasing Materials " + productname + " From " + supliername + ",INVOICE NO" + invoiceno + ", INVOICE DT " + date + ",Amount " + totalamount + "";
                    newrow["Narration"] = narration;
                    Report.Rows.Add(newrow);
                }
                grdReports.DataSource = Report;
                grdReports.DataBind();
                Session["xportdata"] = Report;
                Session["filename"] = "Stores MRN Report";
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