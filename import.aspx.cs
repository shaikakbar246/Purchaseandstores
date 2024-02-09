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
using System.IO;
using System.Drawing;
using ClosedXML.Excel;

public partial class import : System.Web.UI.Page
{
    SalesDBManager vdm;
    SqlCommand cmd;
    protected void Page_Load(object sender, EventArgs e)
    {
        lblMessage.Visible = false;
    }
    protected void btnImport_Click(object sender, EventArgs e)
    {
        try
        {
            vdm = new SalesDBManager();
            string connString = "";
            string filePath = Server.MapPath("~/Files/") + Path.GetFileName(fileuploadExcel.PostedFile.FileName);
            fileuploadExcel.SaveAs(filePath);
            if (filePath.Trim() == ".xls")
            {
                connString = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + filePath + ";Extended Properties=\"Excel 8.0;HDR=Yes;IMEX=2\"";
            }
            else if (filePath.Trim() == ".xlsx")
            {
                connString = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + filePath + ";Extended Properties=\"Excel 12.0;HDR=Yes;IMEX=2\"";
            }
            OleDbConnection OleDbcon = new OleDbConnection("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + filePath + ";Extended Properties=Excel 12.0;");

            OleDbCommand cmd = new OleDbCommand("SELECT * FROM [Sheet1$]", OleDbcon);
            OleDbDataAdapter da = new OleDbDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);
            Session["btnImport"] = dt;
            grvExcelData.DataSource = dt;
            grvExcelData.DataBind();
        }
        catch (Exception ex)
        {
            lblMessage.Text = ex.ToString();
            lblMessage.Visible = true;
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        try
        {
            DataTable dtmiss = new DataTable();
            dtmiss.Columns.Add("sno");
            dtmiss.Columns.Add("Itemcode");
            dtmiss.Columns.Add("productname");
            DataTable dt = (DataTable)Session["btnImport"];
            int count = dt.Rows.Count;
            int i = 1;
            foreach (DataRow dr in dt.Rows)
            {
                vdm = new SalesDBManager();
                //////string itemname = dr["MATERIAL"].ToString();
                //////string catname = dr["Category Name"].ToString();
                //////string subcatname = dr["Sub Category Name"].ToString();
                //////string UOM = dr["UOM"].ToString();
                //////string minstock = dr["MinStock"].ToString();
                //////string maxstock = dr["MaxStock"].ToString();
                //////string qty = dr["Avilable Stores"].ToString();
                //////string price = dr["Price"].ToString();
                //////string amt = dr["AMOUNT"].ToString();
                //////string uomid = "";
                

                //////cmd = new SqlCommand("insert into categorymaster(category, createdby, status,branchid) values(@productid,@qty,@price,@entryby,@doe,@branchid)");
                //////cmd.Parameters.Add("@category", catname);
                //////cmd.Parameters.Add("@status", "True");
                //////cmd.Parameters.Add("@createdby", "03/26/2018");
                //////cmd.Parameters.Add("@branchid", "1064");
                //////vdm.insert(cmd);

                //////cmd = new SqlCommand("SELECT MAX(categoryid) as categoryid FROM categorymaster");
                //////DataTable dtcategory = vdm.SelectQuery(cmd).Tables[0];
                //////string categoryid = dtcategory.Rows[0]["categoryid"].ToString();

                //////cmd = new SqlCommand("insert into subcategorymaster(categoryid,subcategoryname,status,branchid) values (@categoryid, @subcategoryname, @scstatus, @scbranchid )");
                //////cmd.Parameters.Add("@categoryid", categoryid);
                //////cmd.Parameters.Add("@subcategoryname", subcatname);
                //////cmd.Parameters.Add("@scstatus", "True");
                //////cmd.Parameters.Add("@scbranchid", "1064");
                //////vdm.insert(cmd);

                //////cmd = new SqlCommand("select MAX(subcategoryid) as subcategoryid from subcategorymaster");
                //////DataTable dtsubcategory = vdm.SelectQuery(cmd).Tables[0];
                //////string subcategoryid = dtsubcategory.Rows[0]["subcategoryid"].ToString();

                //////cmd = new SqlCommand("insert into productmaster(subcategoryid, productname, sku, price, availablestores, uim, categoryid, branchid, itemcode) values ()");
                //////cmd.Parameters.Add("@productname", itemname);
                //////cmd.Parameters.Add("@subcategoryid", subcategoryid);
                //////cmd.Parameters.Add("@sku", "productid");
                //////cmd.Parameters.Add("@price", price);
                //////cmd.Parameters.Add("@availablestores", qty);
                //////cmd.Parameters.Add("@uim", UOM);
                //////cmd.Parameters.Add("@categoryid", categoryid);
                //////cmd.Parameters.Add("@itemcode", itemname);
                //////cmd.Parameters.Add("@branchid", "1064");
                //////vdm.insert(cmd);

                //////cmd = new SqlCommand("select MAX(productid) as productid from productmaster");
                //////DataTable dtproduct = vdm.SelectQuery(cmd).Tables[0];
                //////string productid = dtsubcategory.Rows[0]["productid"].ToString();

                //////cmd = new SqlCommand("insert into productmoniter( productid, qty, price, branchid, minstock, maxstock) values (@productid, @mqty, @mprice,@mbranchid,@minstock,@maxstock)");
                //////cmd.Parameters.Add("@productid", productid);
                //////cmd.Parameters.Add("@mqty", qty);
                //////cmd.Parameters.Add("@mprice", price);
                //////cmd.Parameters.Add("@mbranchid", "1064");
                //////cmd.Parameters.Add("@minstock", minstock);
                //////cmd.Parameters.Add("@maxstock", maxstock);
                //////vdm.insert(cmd);


                 //////string itemname = dr["MATERIAL"].ToString();
                //////string catname = dr["Category Name"].ToString();
                //////string subcatname = dr["Sub Category Name"].ToString();
                //////string UOM = dr["UOM"].ToString();
                //////string minstock = dr["MinStock"].ToString();
                //////string maxstock = dr["MaxStock"].ToString();
                //////string qty = dr["Avilable Stores"].ToString();
                //////string price = dr["Price"].ToString();
                //////string amt = dr["AMOUNT"].ToString();
                //////string uomid = "";
                string productname = dr["Particulars"].ToString();
                string qty = dr["ERP"].ToString();
                string days = dr["Day cons"].ToString();
                cmd = new SqlCommand("SELECT productid FROM productmaster WHERE (productname=@productname)");
                cmd.Parameters.Add("@productname", productname);
                DataTable dtproducts = vdm.SelectQuery(cmd).Tables[0];
                if (dtproducts.Rows.Count > 0)
                {
                    cmd = new SqlCommand("update productmoniter  SET qty=@qty, perdayconcsumption=@perdayconcsumption WHERE  (productid=@productid) AND (branchid=@branchid)");
                    cmd.Parameters.Add("@productid", dtproducts.Rows[0]["productid"].ToString());
                    cmd.Parameters.Add("@qty", qty);
                    cmd.Parameters.Add("@branchid", "2");
                    if (days == "" || days == null)
                    {
                        days = "0";
                    }
                    cmd.Parameters.Add("@perdayconcsumption", days);
                    vdm.Update(cmd);
                }
                else
                {
                    DataRow newrow = dtmiss.NewRow();
                    newrow["Itemcode"] = productname;
                    newrow["productname"] = productname;
                    dtmiss.Rows.Add(newrow);
                }
                i++;
            }
            grdmiss.DataSource = dtmiss;
            grdmiss.DataBind();
            Session["xportdata"] = dtmiss;
            Session["filename"] = "report";
        }
        catch
        {

        }
        lblmsg.Text = "Records inserted successfully";
    }

}






   