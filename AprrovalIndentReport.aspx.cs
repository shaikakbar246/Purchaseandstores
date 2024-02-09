using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;


public partial class AprrovalIndentReport : System.Web.UI.Page
{
     SqlCommand cmd;
    
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
            Report.Columns.Add("sno");
            Report.Columns.Add("Name");
            Report.Columns.Add("Indent Date");
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
            //cmd = new SqlCommand("SELECT indents.sno, indent_subtable.sno AS sub_ind_sno, indents.name, indents.i_date, indents.d_date, indents.remarks, indents.status,  productmaster.productname, productmaster.productid, indent_subtable.qty FROM indents INNER JOIN indent_subtable ON indents.sno = indent_subtable.indentno INNER JOIN productmaster ON indent_subtable.productid = productmaster.productid  where tools_issue_receive.issudate between @fromdate and @todate");
            cmd = new SqlCommand("SELECT  indents.sno, indents.name, indents.i_date, productmaster.productname,indent_subtable.qty,  indents.d_date, indents.remarks, indents.status  FROM indents INNER JOIN indent_subtable ON indents.sno = indent_subtable.indentno INNER JOIN productmaster ON indent_subtable.productid = productmaster.productid  where indents.i_date between @fromdate and @todate and indents.status = 'V' ");
            cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
            cmd.Parameters.Add("@todate", GetHighDate(todate));
            DataTable dtInward = SalesDB.SelectQuery(cmd).Tables[0];

            if (dtInward.Rows.Count > 0)
            {
                double totalqty = 0;
                double totalamount = 0;
                var i = 1;
                foreach (DataRow dr in dtInward.Rows)
                {
                    DataRow newrow = Report.NewRow();
                    newrow["sno"] = i++.ToString();
                    newrow["Name"] = dr["name"].ToString();
                    newrow["Indent Date"] = ((DateTime)dr["i_date"]).ToString("dd-MM-yyyy"); //dr["i_date"].ToString();
                    newrow["Product Name"] = dr["productname"].ToString();
                    newrow["Quantity"] = dr["qty"].ToString();
                    newrow["Remarks"] = dr["remarks"].ToString();
                    newrow["Status"] = "Verify";
                    double qty = 0;
                    double.TryParse(dr["qty"].ToString(), out qty);
                    totalqty += qty;
                    Report.Rows.Add(newrow);
                }

                DataRow outwardreport = Report.NewRow();
                outwardreport["Product Name"] = "TotalQty";
                outwardreport["Quantity"] = totalqty;
                Report.Rows.Add(outwardreport);
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
