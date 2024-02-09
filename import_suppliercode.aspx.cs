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

public partial class import_suppliercode : System.Web.UI.Page
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

            OleDbCommand cmd = new OleDbCommand("SELECT * FROM [Sheet1$]", OleDbcon);//Sheet1$
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
            DataTable dt = (DataTable)Session["btnImport"];
            int i = 1;
            foreach (DataRow dr in dt.Rows)
            {
                vdm = new SalesDBManager();
                string sup_name = dr["Software Name"].ToString();
                cmd = new SqlCommand("update suppliersdetails set suppliercode=@sapcode,tsuppliername=@tallyname where name=@sup_name");
                cmd.Parameters.Add("@sapcode", dr["Sap Code"].ToString());
                cmd.Parameters.Add("@sup_name", sup_name);
                cmd.Parameters.Add("@tallyname", dr["Tally Name"].ToString());
                vdm.Update(cmd);
                i++;
            }
            lblmsg.Text = i + "Records updated successfully";
        }
        catch
        {

        }
    }
}