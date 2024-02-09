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
public partial class OpeningBalance : System.Web.UI.Page
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
            if (!this.IsPostBack)
            {
                if (!Page.IsCallback)
                {
                    dtp_FromDate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");//Convert.ToString(lblFromDate.Text); ////     /////
                    dtp_Todate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
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
                Report.Columns.Add("sno");
               // Report.Columns.Add("ProductId");
                Report.Columns.Add("Product Name");
                Report.Columns.Add("OpQty").DataType = typeof(double);
                Report.Columns.Add("OpPrice");
                Report.Columns.Add("OpValue").DataType = typeof(double);
                Report.Columns.Add("ReceiptQty").DataType = typeof(double);
                Report.Columns.Add("ReceiptPrice");
                Report.Columns.Add("ReceiptValue").DataType = typeof(double);
                Report.Columns.Add("IssueQty").DataType = typeof(double);
                Report.Columns.Add("IssuePrice");
                Report.Columns.Add("IssueValue").DataType = typeof(double);
                Report.Columns.Add("TransferQty").DataType = typeof(double);
                Report.Columns.Add("TransferPrice");
                Report.Columns.Add("TransferValue").DataType = typeof(double);
                Report.Columns.Add("ClosingQty").DataType = typeof(double);
                Report.Columns.Add("ClosingPrice");
                Report.Columns.Add("ClosingValue").DataType = typeof(double);
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
                string month = (fromdate.Month).ToString();
                string year = (fromdate.Year).ToString();
                int mnth = Convert.ToInt32(month);
                int yr = Convert.ToInt32(year);
                lblfrom_date.Text = fromdate.ToString("dd/MM/yyyy");
                lblto_date.Text = todate.ToString("dd/MM/yyyy");
                string branchid = Session["Po_BranchID"].ToString();
                cmd = new SqlCommand("SELECT productmaster.productname, productmaster.productid FROM  productmaster INNER JOIN productmoniter ON productmoniter.productid = productmaster.productid WHERE (productmoniter.branchid = @branchid)");//  WHERE branchid = @branchid
                cmd.Parameters.Add("@branchid", branchid);
                DataTable dtproducts = SalesDB.SelectQuery(cmd).Tables[0];

                cmd = new SqlCommand("SELECT stockclosingdetails.productid,stockclosingdetails.qty, stockclosingdetails.price, stockclosingdetails.branchid FROM  stockclosingdetails WHERE (stockclosingdetails.branchid = @branchid) and (stockclosingdetails.doe between @d1 and @d2)");
                cmd.Parameters.Add("@d1", GetLowDate(fromdate));
                cmd.Parameters.Add("@d2", GetHighDate(fromdate));
                cmd.Parameters.Add("@branchid", branchid);
                DataTable dtInward = SalesDB.SelectQuery(cmd).Tables[0];

                cmd = new SqlCommand("SELECT productmaster.productid, SUM(subinwarddetails.quantity) AS quantity,subinwarddetails.perunit  FROM  productmaster  INNER JOIN subinwarddetails ON subinwarddetails.productid = productmaster.productid INNER JOIN  inwarddetails  ON  inwarddetails.sno=subinwarddetails.in_refno  where (inwarddetails.inwarddate BETWEEN @fromdate AND @todate)  AND (inwarddetails.branchid=@branchid)  GROUP BY productmaster.productid,subinwarddetails.perunit");
                cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
                cmd.Parameters.Add("@todate", GetHighDate(todate));
                cmd.Parameters.Add("@branchid", branchid);
                DataTable dtreceipt = SalesDB.SelectQuery(cmd).Tables[0];

                cmd = new SqlCommand("SELECT  productmaster.productid, SUM(suboutwarddetails.quantity) AS quantity,suboutwarddetails.perunit  FROM  productmaster  INNER JOIN suboutwarddetails ON suboutwarddetails.productid = productmaster.productid INNER JOIN outwarddetails ON  outwarddetails.sno= suboutwarddetails.in_refno where (outwarddetails.inwarddate BETWEEN @fromdate AND @todate)  AND (outwarddetails.branchid=@branchid)   GROUP BY productmaster.productid,suboutwarddetails.perunit");
                cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
                cmd.Parameters.Add("@todate", GetHighDate(todate));
                cmd.Parameters.Add("@branchid", branchid);
                DataTable dtIsspcode = SalesDB.SelectQuery(cmd).Tables[0];

                cmd = new SqlCommand("SELECT productmaster.productid, SUM(stocktransfersubdetails.quantity) AS quantity, stocktransfersubdetails.price FROM  productmaster  INNER JOIN stocktransfersubdetails ON stocktransfersubdetails.productid = productmaster.productid INNER JOIN stocktransferdetails ON stocktransferdetails.sno=stocktransfersubdetails.stock_refno  where  (stocktransferdetails.invoicedate BETWEEN @fromdate AND @todate)  AND (stocktransferdetails.branch_id=@branchid)   GROUP BY productmaster.productid,  stocktransfersubdetails.price");
                cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
                cmd.Parameters.Add("@todate", GetHighDate(todate));
                cmd.Parameters.Add("@branchid", branchid);
                DataTable dttransferpcode = SalesDB.SelectQuery(cmd).Tables[0];

                if (dtproducts.Rows.Count > 0)
                {
                   
                    int i = 1;
                    DataRow newrow = null;
                    foreach (DataRow dr in dtproducts.Rows)
                    {                       
                        int newrowflag = 0;
                        int opflag = 0;
                        int inwflag = 0;
                        int issflag = 0;
                        int transflag = 0;
                        double Totalopeningqty = 0;
                        double Totalopeningvalue = 0;
                        double Totalreceptqty = 0;
                        double Totalreceptvalue = 0;
                        double Totalissueqty = 0;
                        double Totalissuevalue = 0;
                        double Totalbranchtransforvalue = 0;
                        double Totalclosingqty = 0;
                        double totalclosingqtybalance = 0;
                        double Totoeningquantity = 0;
                        double Totinwardquantity = 0;
                        double Totoutwardquantity = 0;
                        double TotBranachTransferquantity = 0;
                        double openingqty = 0;
                        double openingvalue = 0;
                        double receptqty = 0;
                        double receptvalue = 0;
                        double reciptcost = 0;
                        double totalissueprice = 0;
                        double btprice = 0;
                        double receptprice = 0;
                        double issueqty = 0;
                        double transfervalue = 0;
                        double bqty = 0;
                        double qty = 0;
                        double inqty = 0;
                        double oueqty = 0;
                        double transferqty = 0;
                        double transferprice = 0;
                        double outprice = 0;
                        double price = 0;
                        double inprice = 0;
                        var count = 0;
                        if (newrowflag == 0)
                        {
                            newrow = Report.NewRow();
                        }
                        newrow["sno"] = "" + i++ + "";
                        newrow["Product Name"] = dr["productname"].ToString();
                        foreach (DataRow dropp in dtInward.Select("productid='" + dr["productid"].ToString() + "'"))
                        {
                           // newrow["sno"] = "" + i++ + "";
                           // newrow["Product Name"] = dr["productname"].ToString();
                            double.TryParse(dropp["qty"].ToString(), out qty);
                            openingqty = qty;
                            Totalopeningqty += qty;
                            double.TryParse(dropp["price"].ToString(), out price);
                            string id = dropp["productid"].ToString();
                            newrow["OpQty"] = Math.Round(qty, 1);
                            newrow["OpPrice"] = Math.Round(price, 2);
                            openingvalue = qty * price;
                            openingvalue = Math.Round(openingvalue, 2);
                            Totalopeningvalue += openingvalue;
                            newrow["OpValue"] = openingvalue.ToString();
                        }
                        if (price > 0)
                        {
                        }
                        else
                        {
                            newrow["OpQty"] = Math.Round(qty, 1);
                            newrow["OpPrice"] = Math.Round(price, 2);
                            newrow["OpValue"] = openingvalue.ToString();
                        }
                        foreach (DataRow drreceipt in dtreceipt.Select("productid='" + dr["productid"].ToString() + "'"))
                        {
                            double.TryParse(drreceipt["quantity"].ToString(), out inqty);
                            Totinwardquantity += inqty;
                            double.TryParse(drreceipt["perunit"].ToString(), out inprice);
                            receptprice = inprice;
                            receptqty = inqty;
                            receptvalue = inqty * inprice;
                            double reciptpunabaka = receptvalue;
                            reciptpunabaka = Math.Round(reciptpunabaka, 2);
                            Totalreceptqty += receptqty;
                            Totalreceptvalue += receptvalue;

                            reciptcost = Totalreceptvalue / Totalreceptqty;

                            inwflag = 1;
                        }
                        if (reciptcost > 0)
                        {
                            newrow["ReceiptQty"] = Math.Round(Totalreceptqty, 2);
                            newrow["ReceiptValue"] = Math.Round(Totalreceptvalue);
                            newrow["ReceiptPrice"] = Math.Round(reciptcost, 3);
                        }
                        else
                        {
                            newrow["ReceiptQty"] = Math.Round(Totalreceptqty, 1);
                            newrow["ReceiptValue"] = Math.Round(Totalreceptvalue);
                            newrow["ReceiptPrice"] = Math.Round(reciptcost, 3);
                        }

                        if (dr["productid"].ToString() == "2285" && mnth <= 6 && yr <= 2017)
                        {
                            DataTable dt_diesel = new DataTable();
                            cmd = new SqlCommand("SELECT SUM(diesel_consumptiondetails.qty) AS qty, diesel_consumptiondetails.productid, diesel_consumptiondetails.dieselcost FROM diesel_consumptiondetails INNER JOIN productmaster ON diesel_consumptiondetails.productid = productmaster.productid WHERE (diesel_consumptiondetails.branchid = @branchid) AND (diesel_consumptiondetails.doe BETWEEN @fromdate AND @todate) GROUP BY diesel_consumptiondetails.productid, diesel_consumptiondetails.dieselcost");
                            cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
                            cmd.Parameters.Add("@todate", GetHighDate(todate));
                            cmd.Parameters.Add("@branchid", branchid);
                            dt_diesel = SalesDB.SelectQuery(cmd).Tables[0];
                            if (dt_diesel.Rows.Count > 0)
                            {
                                foreach (DataRow drdiesel in dt_diesel.Rows)
                                {
                                    double.TryParse(drdiesel["qty"].ToString(), out oueqty);
                                    double.TryParse(drdiesel["dieselcost"].ToString(), out outprice);
                                    Totalissueqty += oueqty;
                                    double Totalissuevalue1 = oueqty * outprice;
                                    Totalissuevalue += Math.Round(Totalissuevalue1, 2);
                                    totalissueprice = Totalissuevalue / Totalissueqty;
                                    issflag = 1;
                                }
                            }
                            if (totalissueprice > 0)
                            {
                                newrow["IssueQty"] = Math.Round(Totalissueqty, 1);
                                newrow["IssuePrice"] = Math.Round(totalissueprice, 3);
                                newrow["IssueValue"] = Math.Round(Totalissuevalue, 1);
                            }
                            else
                            {
                                newrow["IssueQty"] = Math.Round(Totalissueqty, 1);
                                newrow["IssuePrice"] = Math.Round(totalissueprice, 3);
                                newrow["IssueValue"] = Math.Round(Totalissuevalue, 1);
                            }
                        }
                        else
                        {
                            foreach (DataRow drissue in dtIsspcode.Select("productid='" + dr["productid"].ToString() + "'"))
                            {
                                double.TryParse(drissue["quantity"].ToString(), out oueqty);
                                double.TryParse(drissue["perunit"].ToString(), out outprice);
                                Totalissueqty += oueqty;
                                issueqty = oueqty * outprice;
                                Totalissuevalue += Math.Round(issueqty, 2);
                                totalissueprice = Totalissuevalue / Totalissueqty;
                                issflag = 1;
                            }
                            if (totalissueprice > 0)
                            {
                                newrow["IssueQty"] = Math.Round(Totalissueqty, 1);
                                newrow["IssuePrice"] = Math.Round(totalissueprice, 3);
                                newrow["IssueValue"] = Math.Round(Totalissuevalue, 1);
                            }
                            else
                            {
                                newrow["IssueQty"] = Math.Round(Totalissueqty, 1);
                                newrow["IssuePrice"] = Math.Round(totalissueprice, 3);
                                newrow["IssueValue"] = Math.Round(Totalissuevalue, 1);
                            }
                        }
                        foreach (DataRow drtransfer in dttransferpcode.Select("productid='" + dr["productid"].ToString() + "'"))
                        {
                            double.TryParse(drtransfer["quantity"].ToString(), out transferqty);
                            TotBranachTransferquantity += transferqty;
                            double.TryParse(drtransfer["price"].ToString(), out transferprice);
                            transfervalue = transferqty * transferprice;
                            double isspunabaka = transfervalue;
                            Totalbranchtransforvalue += transfervalue;
                            btprice = Totalbranchtransforvalue / TotBranachTransferquantity;
                            transflag = 1;
                        }
                        if (btprice > 0)
                        {
                            newrow["TransferQty"] = Math.Round(TotBranachTransferquantity, 1);
                            newrow["TransferValue"] = Math.Round(Totalbranchtransforvalue, 1);
                            newrow["TransferPrice"] = Math.Round(btprice, 3);
                        }
                        else
                        {
                            newrow["TransferQty"] = Math.Round(TotBranachTransferquantity, 1);
                            newrow["TransferValue"] = Math.Round(Totalbranchtransforvalue, 1);
                            newrow["TransferPrice"] = Math.Round(btprice, 3);
                        }
                        inwflag = 0;
                        issflag = 0;
                        transflag = 0;
                        newrowflag = 0;
                        double obqty = openingqty + Totalreceptqty;
                        double deductionqty = Totalissueqty + TotBranachTransferquantity;
                        double closingqty = obqty - deductionqty;
                        closingqty = Math.Round(closingqty, 2);
                        if (closingqty < 0)
                        {
                            closingqty = 0;
                            newrow["ClosingQty"] = Math.Round(closingqty, 2);
                        }
                        else
                        {
                            newrow["ClosingQty"] = Math.Round(closingqty, 2);
                        }
                        Totalreceptvalue = Totalreceptqty * inprice;
                        double obvalue = openingvalue + Totalreceptvalue;
                        double deductionvalue = Totalissuevalue + Totalbranchtransforvalue;
                        double closingvalue = obvalue - deductionvalue;
                        closingvalue = Math.Round(closingvalue, 2);
                        if (closingqty > 0)
                        {
                            newrow["ClosingValue"] = Math.Round(closingvalue, 2);
                        }
                        else
                        {
                            closingvalue = 0;
                            newrow["ClosingValue"] = Math.Round(closingvalue, 2);
                        }

                        double closingprice = closingvalue / closingqty;
                        closingprice = Math.Round(closingprice, 2);
                        if (closingvalue > 0)
                        {
                            newrow["ClosingPrice"] = Math.Round(closingprice, 2);
                        }
                        else
                        {
                            closingprice = 0;
                            newrow["ClosingPrice"] = Math.Round(closingprice, 2);
                        }

                        Report.Rows.Add(newrow);
                        TotBranachTransferquantity = 0;
                        Totalbranchtransforvalue = 0;
                        transferprice = 0;
                        Totalissueqty = 0;
                        outprice = 0;
                        Totalissuevalue = 0;
                        Totalreceptqty = 0;
                        Totalreceptvalue = 0;
                        inprice = 0;
                        openingvalue = 0;
                        openingqty = 0;
                        
                    }
                    DataRow newTotal = Report.NewRow();
                    newTotal["Product Name"] = "Total";
                    double val = 0.0;
                    foreach (DataColumn dc in Report.Columns)
                    {
                        if (dc.DataType == typeof(Double))
                        {
                            val = 0.0;
                            double.TryParse(Report.Compute("sum([" + dc.ToString() + "])", "[" + dc.ToString() + "]<>'0'").ToString(), out val);
                            newTotal[dc.ToString()] = val;
                        }
                    }
                    Report.Rows.Add(newTotal);
                    grdReports.DataSource = Report;
                    grdReports.DataBind();
                    hidepanel.Visible = true;
                    Session["xportdata"] = Report;
                    Session["filename"] = "Consumption Report";
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
    protected void grdReports_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        
    }
    protected void btnexport_click(object sender, EventArgs e)
    {

        Response.Redirect("~/exporttoxl.aspx");

    }
    protected void grdReports_RowCreated(object sender, GridViewRowEventArgs e)
    {
        try
        {
            if (e.Row.RowType == DataControlRowType.Header)
            {
                GridViewRow HeaderRow = new GridViewRow(2, 0, DataControlRowType.Header, DataControlRowState.Insert);

                TableCell HeaderCell2 = new TableCell();
                HeaderCell2.Text = "ProductName";
                HeaderCell2.ColumnSpan = 2;
                HeaderCell2.HorizontalAlign = HorizontalAlign.Center;
                HeaderRow.Cells.Add(HeaderCell2);


                HeaderCell2 = new TableCell();
                HeaderCell2.Text = "OpeningBalance";
                HeaderCell2.ColumnSpan = 3;
                HeaderCell2.HorizontalAlign = HorizontalAlign.Center;
                HeaderRow.Cells.Add(HeaderCell2);

                HeaderCell2 = new TableCell();
                HeaderCell2.Text = "Inwards";
                HeaderCell2.ColumnSpan = 3;
                HeaderCell2.HorizontalAlign = HorizontalAlign.Center;
                HeaderRow.Cells.Add(HeaderCell2);

                HeaderCell2 = new TableCell();
                HeaderCell2.Text = "Outwards";
                HeaderCell2.ColumnSpan = 3;
                HeaderCell2.HorizontalAlign = HorizontalAlign.Center;
                HeaderRow.Cells.Add(HeaderCell2);
                grdReports.Controls[0].Controls.AddAt(0, HeaderRow);

                HeaderCell2 = new TableCell();
                HeaderCell2.Text = "Transfer";
                HeaderCell2.ColumnSpan = 3;
                HeaderCell2.HorizontalAlign = HorizontalAlign.Center;
                HeaderRow.Cells.Add(HeaderCell2);
                grdReports.Controls[0].Controls.AddAt(0, HeaderRow);

                HeaderCell2 = new TableCell();
                HeaderCell2.Text = "ClosingBalance";
                HeaderCell2.ColumnSpan = 3;
                HeaderCell2.HorizontalAlign = HorizontalAlign.Center;
                HeaderRow.Cells.Add(HeaderCell2);
                grdReports.Controls[0].Controls.AddAt(0, HeaderRow);

            }
        }
        catch (Exception ex)
        {
        }
    }
    protected void grdReports_RowDataBound(object o, GridViewRowEventArgs e)
    {
        try
        {

            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                e.Row.Cells[0].HorizontalAlign = HorizontalAlign.Left;
                e.Row.Cells[1].HorizontalAlign = HorizontalAlign.Left;
            }
        }
        catch (Exception ex)
        {
        }
    }
    protected void finalize_stockclosing(object sender, EventArgs e)
    {
        vdm = new SalesDBManager();
        DataTable dt = (DataTable)Session["xportdata"];
        DateTime doe = SalesDBManager.GetTime(vdm.conn);
        DateTime closingdate = doe.AddDays(1);
        string entryby = Session["Employ_Sno"].ToString();
        string branchid = Session["Po_BranchID"].ToString();
        foreach (DataRow dr in dt.Rows)
        {
            try
            {
                string productname = dr["Product Name"].ToString();
                if (productname != "Total")
                {
                    string qty = dr["ClosingQty"].ToString();
                    if (qty != "0")
                    {
                        double price = Convert.ToDouble(dr["OpPrice"].ToString());
                        if (price > 1)
                        {

                        }
                        else
                        {
                            price = Convert.ToDouble(dr["ReceiptPrice"].ToString());
                        }
                        cmd = new SqlCommand("select productid from productmaster where productname = @productname");
                        cmd.Parameters.Add("@productname", productname);
                        DataTable dt_productid = vdm.SelectQuery(cmd).Tables[0];
                        string productid = dt_productid.Rows[0]["productid"].ToString();
                        cmd = new SqlCommand("insert into stockclosingdetails (productid,qty,price,doe,entryby,branchid) values (@productid,@qty,@price,@doe,@entryby,@branchid)");
                        cmd.Parameters.Add("@productid", productid);
                        cmd.Parameters.Add("@qty", qty);
                        cmd.Parameters.Add("@price", price);
                        cmd.Parameters.Add("@doe", closingdate);
                        cmd.Parameters.Add("@entryby", entryby);
                        cmd.Parameters.Add("@branchid", branchid);
                        vdm.insert(cmd);
                    }
                    else
                    {

                    }
                }
            }
            catch (Exception ex)
            {
                string productname = dr["Product Name"].ToString();
            }
        }
        lblmsg.Text = "Saved successfully";
        DataTable dtempty = new DataTable();
        grdReports.DataSource = dtempty;
        grdReports.DataBind();
    }
}