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

public partial class import_branch : System.Web.UI.Page
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
            //string name = Path.GetFileName(fileuploadExcel.PostedFile.FileName); //get the path of the file  

            //if (str.Contains("."))
            //{
            //    int index = str.IndexOf('.');
            //    result = str.Substring(0, index);

            //    re = result;

            //}

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
                string itemcode = dr["Itemcode"].ToString();
                string productname = dr["productname"].ToString();
                cmd = new SqlCommand("SELECT productid FROM productmaster WHERE ((itemcode=@itemcode) OR (productname=@productname))");
                cmd.Parameters.Add("@itemcode", itemcode);
                cmd.Parameters.Add("@productname", productname);
                DataTable dtproducts = vdm.SelectQuery(cmd).Tables[0];
                if (dtproducts.Rows.Count > 0)
                {

                }
                else
                {
                    cmd = new SqlCommand("insert into productmaster(productname,itemcode,createdby, branchid) values(@productname,@itemcode,@entryby,@branchid)");
                    cmd.Parameters.Add("@productname", productname);
                    cmd.Parameters.Add("@itemcode", itemcode);
                    cmd.Parameters.Add("@branchid", "2");
                    cmd.Parameters.Add("@entryby", Session["Employ_Sno"].ToString());
                    vdm.insert(cmd);
                }

                //cmd = new SqlCommand("update branchmaster set whcode=@whcode where branchname=@branchname");
                //cmd.Parameters.Add("@whcode", dr["Center Code"].ToString());
                //cmd.Parameters.Add("@branchname", branchname);
                ////cmd.Parameters.Add("@bin", dr["Bin No"].ToString());
                //vdm.Update(cmd);
                i++;
            }
            lblmsg.Text = i + "Records updated successfully";
        }
        catch
        {

        }
    }

}