using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

public partial class LogOut : System.Web.UI.Page
{
    SalesDBManager vdm = new SalesDBManager();
    AccessControldbmanger Accescontrol_db = new AccessControldbmanger();
    SqlCommand cmd;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["Employ_Sno"] != null)
        {
            string sno = Session["Employ_Sno"].ToString();
            cmd = new SqlCommand("update employe_details set loginflag=@log where sno=@sno");
            cmd.Parameters.Add("@log", "0");
            cmd.Parameters.Add("@sno", sno);
            vdm.Update(cmd);

            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            cmd = new SqlCommand("Select max(sno) as transno from logininfo where UserId=@userid AND UserName=@UserName");
            cmd.Parameters.Add("@userid", Session["Employ_Sno"]);
            cmd.Parameters.Add("@UserName", Session["UserName"]);
            DataTable dttime = vdm.SelectQuery(cmd).Tables[0];
            if (dttime.Rows.Count > 0)
            {
                string transno = dttime.Rows[0]["transno"].ToString();
                cmd = new SqlCommand("UPDATE logininfo set logouttime=@logouttime where sno=@sno");
                cmd.Parameters.Add("@logouttime", ServerDateCurrentdate);
                cmd.Parameters.Add("@sno", transno);
                vdm.Update(cmd);
            }
        }
        else
        {
            cmd = new SqlCommand("update employe_details set loginflag=@log");
            cmd.Parameters.Add("@log", "0");
            vdm.Update(cmd);
        }
        Session.Clear();
        Session.RemoveAll();
        Session.Abandon();
        Response.Cookies["UserName"].Expires = DateTime.Now.AddDays(-1);
        Response.Cookies["Employ_Sno"].Expires = DateTime.Now.AddDays(-1);
        Response.Redirect("Default.aspx");
    }
}