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
using System.Configuration;

public partial class import_itemcode : System.Web.UI.Page
{
    SalesDBManager vdm;
    SqlCommand cmd;
    protected void Page_Load(object sender, EventArgs e)
    {
        lblmsg.Visible = false;
    }

    protected void btn_Import_Click(object sender, EventArgs e)
    {
        try
        {
            string FilePath = ConfigurationManager.AppSettings["FilePath"].ToString();
            string filename = string.Empty;
            //To check whether file is selected or not to uplaod
            if (FileUploadToServer.HasFile)
            {
                try
                {
                    string[] allowdFile = { ".xls", ".xlsx" };
                    //Here we are allowing only excel file so verifying selected file pdf or not
                    string FileExt = System.IO.Path.GetExtension(FileUploadToServer.PostedFile.FileName);
                    //Check whether selected file is valid extension or not
                    bool isValidFile = allowdFile.Contains(FileExt);
                    if (!isValidFile)
                    {
                        lblmsg.ForeColor = System.Drawing.Color.Red;
                        lblmsg.Text = "Please upload only Excel";
                    }
                    else
                    {
                        // Get size of uploaded file, here restricting size of file
                        int FileSize = FileUploadToServer.PostedFile.ContentLength;
                        if (FileSize <= 1048576)//1048576 byte = 1MB
                        {
                            //Get file name of selected file
                            filename = Path.GetFileName(Server.MapPath(FileUploadToServer.FileName));

                            //Save selected file into server location
                            FileUploadToServer.SaveAs(Server.MapPath(FilePath) + filename);
                            //Get file path
                            string filePath = Server.MapPath(FilePath) + filename;
                            //Open the connection with excel file based on excel version
                            OleDbConnection con = null;
                            if (FileExt == ".xls")
                            {
                                con = new OleDbConnection(@"Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + filePath + ";Extended Properties=Excel 8.0;");

                            }
                            else if (FileExt == ".xlsx")
                            {
                                con = new OleDbConnection(@"Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + filePath + ";Extended Properties=Excel 12.0;");
                            }

                            con.Close(); con.Open();
                            //Get the list of sheet available in excel sheet
                            DataTable dt = con.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, null);
                            //Get first sheet name
                            string getExcelSheetName = dt.Rows[0]["Table_Name"].ToString();
                            //Select rows from first sheet in excel sheet and fill into dataset "SELECT * FROM [Sheet1$]";  
                            OleDbCommand ExcelCommand = new OleDbCommand(@"SELECT * FROM [" + getExcelSheetName + @"]", con);
                            OleDbDataAdapter ExcelAdapter = new OleDbDataAdapter(ExcelCommand);
                            DataSet ExcelDataSet = new DataSet();
                            ExcelAdapter.Fill(ExcelDataSet);
                            //Bind the dataset into gridview to display excel contents
                            grdReports.DataSource = ExcelDataSet;
                            grdReports.DataBind();
                            Session["dtImport"] = ExcelDataSet.Tables[0];
                            BtnSave.Visible = true;

                        }
                        else
                        {
                            lblmsg.Text = "Attachment file size should not be greater then 1 MB!";
                        }
                    }
                }
                catch (Exception ex)
                {
                    lblmsg.Text = "Error occurred while uploading a file: " + ex.Message;
                }
            }
            else
            {
                lblmsg.Text = "Please select a file to upload.";
            }
        }
        catch (Exception ex)
        {
            lblmsg.Text = ex.ToString();
            lblmsg.Visible = true;
        }
    }

    protected void btn_WIDB_Click(object sender, EventArgs e)
    {
        try
        {
            DataTable dt = (DataTable)Session["dtImport"];
            int i = 1;
            foreach (DataRow dr in dt.Rows)
            {
                vdm = new SalesDBManager();
                string itemcode = dr["icode"].ToString();
                string scc = dr["scode"].ToString();
                string pcode = dr["mcode"].ToString();
                cmd = new SqlCommand(" UPDATE productmaster SET  productcode = @pcode, sub_cat_code = @scc where itemcode =@itemcode");
                cmd.Parameters.Add("@itemcode", itemcode);
                cmd.Parameters.Add("@pcode", pcode);
                cmd.Parameters.Add("@scc", scc);
                vdm.Update(cmd);

                //cmd = new SqlCommand("update productmoniter set qty=@qty, price=@price where ProductId=@ProductId");
                //cmd.Parameters.Add("@qty", ClosingQty);
                //cmd.Parameters.Add("@price", ClosingPrice);
                //cmd.Parameters.Add("@ProductId", ProductId);
                //vdm.Update(cmd);
                //cmd = new SqlCommand("update productmaster set availablestores=@qty, price=@price where ProductId=@ProductId");
                //cmd.Parameters.Add("@qty", ClosingQty);
                //cmd.Parameters.Add("@price", ClosingPrice);
                //cmd.Parameters.Add("@ProductId", ProductId);
                //vdm.Update(cmd);
                i++;
            }
            lblmsg.Text = i+"Records updated successfully";
        }
        catch
        {

        }
    }
}