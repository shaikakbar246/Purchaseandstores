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
public partial class ProductMaster : System.Web.UI.Page
{
    SqlCommand cmd;
    SalesDBManager vdm;
    protected void Page_Load(object sender, EventArgs e)
    {
        
    }
    DataTable Report = new DataTable();
    protected void btnexport_click(object sender, EventArgs e)
    {
        Report.Columns.Add("ProductId");
        Report.Columns.Add("ProductName");
        Report.Columns.Add("Main Code");
        Report.Columns.Add("Sub Code");
        Report.Columns.Add("SKU");
        Report.Columns.Add("UOM");
        Report.Columns.Add("MinStock");
        Report.Columns.Add("MaxStock");
        Report.Columns.Add("Avilable Stores").DataType = typeof(double);
        Report.Columns.Add("Price");
        string branchid = Session["Po_BranchID"].ToString();
        vdm = new SalesDBManager();
        cmd = new SqlCommand("SELECT productmaster.productid, productmaster.subcategoryid,productmoniter.minstock,productmoniter.maxstock, productmoniter.qty,productmoniter.price, productmaster.productname, productmaster.productcode,  productmaster.sub_cat_code,  productmaster.sku,  productmaster.description,  productmaster.sectionid,  productmaster.brandid,  productmaster.supplierid,  productmaster.modifierset,uimmaster.uim, productmaster.availablestores,  productmaster.color,  productmaster.uim AS puim,  productmaster.price FROM  productmaster  INNER JOIN productmoniter ON productmaster.productid=productmoniter.productid LEFT OUTER JOIN uimmaster ON uimmaster.sno=productmaster.uim WHERE productmoniter.branchid=@bid ORDER BY productmaster.productid");
        cmd.Parameters.Add("@bid", branchid);
        DataTable routes = vdm.SelectQuery(cmd).Tables[0];
        if (routes.Rows.Count > 0)
        {
            foreach (DataRow dr in routes.Rows)
            {
                DataRow newrow = Report.NewRow();
                newrow["ProductId"] = dr["productid"].ToString();
                newrow["ProductName"] = dr["productname"].ToString();
                newrow["Main Code"] = dr["productcode"].ToString();
                newrow["Sub Code"] = dr["sub_cat_code"].ToString();
                newrow["SKU"] = dr["sku"].ToString();
                newrow["UOM"] = dr["uim"].ToString();
                newrow["MinStock"] = dr["minstock"].ToString();
                newrow["MaxStock"] = dr["maxstock"].ToString();
                newrow["Avilable Stores"] = dr["qty"].ToString();
                newrow["Price"] = dr["price"].ToString();
                Report.Rows.Add(newrow);
            }
            Session["xportdata"] = Report;
            Session["filename"] = "ITEM DETAILS";
            Session["Address"] = "PUNABAKA";
            Response.Redirect("~/exporttoxl.aspx");
        }
    }
}