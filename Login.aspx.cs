using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using System.Data.SqlClient;
using System.Web.Script.Serialization;
using System.Data;
using System.Web.Services;
using System.Net.Mail;
using System.Net;
using System.Text;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Globalization;
using System.Security.Cryptography;
using System.Net.Sockets;
using System.Text.RegularExpressions;
public partial class Login : System.Web.UI.Page
{
    SalesDBManager vdm = new SalesDBManager();
    AccessControldbmanger Accescontrol_db = new AccessControldbmanger();
    SqlCommand cmd;
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (!IsPostBack)
            {
                btnLogin_Click();
            }
        }
        catch (Exception ex)
        {
            //lblMsg.Text = ex.Message;
        }
    }
    protected void login_click(object sender, EventArgs e)
    {
        try
        {
            vdm = new SalesDBManager();
            string userid = Usernme_txt.Text, password = Pass_pas.Text;
            cmd = new SqlCommand("SELECT branchmaster.gstin, branchmaster.branchledgername, branchmapping.mainbranch, employe_details.sno, employe_details.loginflag, employe_details.employename, employe_details.userid, employe_details.password, employe_details.emailid, employe_details.phone, employe_details.branchtype, employe_details.leveltype, employe_details.departmentid, employe_details.branchid, branchmaster.branchid AS Expr1, branchmaster.branchname, branchmaster.address, branchmaster.branchcode, branchmaster.phone AS Expr2, branchmaster.tino, branchmaster.stno, branchmaster.cstno, branchmaster.emailid AS Expr3, branchmaster.statename FROM employe_details INNER JOIN branchmaster ON employe_details.branchid = branchmaster.branchid INNER JOIN departmentmaster ON departmentmaster.sno=employe_details.departmentid INNER JOIN branchmapping ON branchmaster.branchid=branchmapping.subbranch WHERE (employe_details.userid = @userid) AND (employe_details.password = @pwd)");
            cmd.Parameters.Add("@pwd", password);
            cmd.Parameters.Add("@userid", userid);
            DataTable dt = vdm.SelectQuery(cmd).Tables[0];
            if (dt.Rows.Count > 0)
            {
                string loginflag = dt.Rows[0]["loginflag"].ToString();
                //if (loginflag == "False")
                //{
                    string sno = dt.Rows[0]["sno"].ToString();
                    cmd = new SqlCommand("update employe_details set loginflag=@log where sno=@sno");
                    cmd.Parameters.Add("@log", "1");
                    cmd.Parameters.Add("@sno", sno);
                    vdm.Update(cmd);
                    Session["TinNo"] = "37921042267";
                    Session["mainbranch"] = dt.Rows[0]["mainbranch"].ToString();
                    Session["Employ_Sno"] = dt.Rows[0]["sno"].ToString();
                    Session["Po_BranchID"] = dt.Rows[0]["branchid"].ToString();
                    Session["stateid"] = dt.Rows[0]["statename"].ToString();
                    Session["TitleName"] = "SRI VYSHNAVI DAIRY SPECIALITIES (P) LTD";
                    string julydt = "07/01/2017 12:00:00 AM";
                    DateTime gst_dt = Convert.ToDateTime(julydt);
                    DateTime today = DateTime.Today;
                    //if (today > gst_dt)
                    //{
                    Session["Address"] = dt.Rows[0]["address"].ToString();
                    Session["gstin"] = dt.Rows[0]["gstin"].ToString();
                    //}
                    //else
                    //{
                    //    Session["Address"] = "Survey No. 381-2, Punabaka Village, Pellakuru mandal SPSR Nellore (Dt) Pin - 524129, Andhra Pradesh,11. Email : purchase@vyshnavidairy.in Phone: 7729995606; GSTIN NO: 37921042267.";
                    //   // Session["Address"] = "Survey No. 381-2, Punabaka Village, Pellakuru mandal SPSR Nellore (Dt) Pin - 524129.Couriering address : No.45, Madhu apartments,Panagal-517640,Srikalahasthi,Chittoor(dt),AndhraPradesh. Email : gupta@vyshnavi.in;purchase@vyshnavidairy.in Phone: 7729995606,7729995603,9382525913; GSTIN: 37921042267."; //dt.Rows[0]["address"].ToString();
                    //}
                    Session["BranchCode"] = dt.Rows[0]["branchcode"].ToString();
                    Session["TinNo"] = "37921042267";
                    Session["stno"] = dt.Rows[0]["stno"].ToString();
                    Session["cstno"] = dt.Rows[0]["cstno"].ToString();
                    Session["phone"] = dt.Rows[0]["phone"].ToString();
                    Session["emailid"] = dt.Rows[0]["emailid"].ToString();
                    Session["UserName"] = dt.Rows[0]["employename"].ToString();
                    Session["password"] = dt.Rows[0]["password"].ToString();
                    Session["BranchType"] = dt.Rows[0]["branchtype"].ToString();
                    Session["Department"] = dt.Rows[0]["departmentid"].ToString();
                    Session["leveltype"] = dt.Rows[0]["leveltype"].ToString();
                    Session["branchledgername"] = dt.Rows[0]["branchledgername"].ToString();

                    
                    string branchtype = dt.Rows[0]["BranchType"].ToString();
                    string leveltype = dt.Rows[0]["leveltype"].ToString();

                   


                    Response.Cookies["UserName"].Value = HttpUtility.UrlEncode("true");
                    Response.Cookies["UserName"].Path = "/";
                    Response.Cookies["UserName"].Expires = DateTime.Now.AddDays(1);

                    Response.Cookies["Employ_Sno"].Value = HttpUtility.UrlEncode("true");
                    Response.Cookies["Employ_Sno"].Path = "/";
                    Response.Cookies["Employ_Sno"].Expires = DateTime.Now.AddDays(1);

                    //get ip address and device type
                    string ipaddress;
                    ipaddress = Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
                    if (ipaddress == "" || ipaddress == null)
                    {
                        ipaddress = Request.ServerVariables["REMOTE_ADDR"];
                    }
                    DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
                    HttpBrowserCapabilities browser = Request.Browser;
                    string devicetype = "";
                    string userAgent = Request.ServerVariables["HTTP_USER_AGENT"];
                    Regex OS = new Regex(@"(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino", RegexOptions.IgnoreCase | RegexOptions.Multiline);
                    Regex device = new Regex(@"1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-", RegexOptions.IgnoreCase | RegexOptions.Multiline);
                    string device_info = string.Empty;
                    if (OS.IsMatch(userAgent))
                    {
                        device_info = OS.Match(userAgent).Groups[0].Value;
                    }
                    if (device.IsMatch(userAgent.Substring(0, 4)))
                    {
                        device_info += device.Match(userAgent).Groups[0].Value;
                    }
                    if (!string.IsNullOrEmpty(device_info))
                    {
                        devicetype = device_info;
                        string[] words = devicetype.Split(')');
                        devicetype = words[0].ToString();
                    }
                    else
                    {
                        devicetype = "Desktop";
                    }


                    //string alphabets = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
                    //string small_alphabets = "abcdefghijklmnopqrstuvwxyz";
                    //string numbers = "1234567890";

                    //string characters = numbers;
                    //characters += alphabets + small_alphabets + numbers;
                    //int length = 8;
                    //string otp = string.Empty;
                    //for (int i = 0; i < length; i++)
                    //{
                    //    string character = string.Empty;
                    //    do
                    //    {
                    //        int index = new Random().Next(0, characters.Length);
                    //        character = characters.ToCharArray()[index].ToString();
                    //    } while (otp.IndexOf(character) != -1);
                    //    otp += character; 
                    //}
                    cmd = new SqlCommand("INSERT INTO logininfo(userid, username, logintime, ipaddress, devicetype) values (@userid, @UserName, @logintime, @ipaddress, @device)");
                    cmd.Parameters.Add("@userid", dt.Rows[0]["sno"].ToString());
                    cmd.Parameters.Add("@UserName", Session["UserName"]);
                    cmd.Parameters.Add("@logintime", ServerDateCurrentdate);
                    cmd.Parameters.Add("@ipaddress", ipaddress);
                    cmd.Parameters.Add("@device", devicetype);
                    //cmd.Parameters.Add("@otp", otp);
                    vdm.insert(cmd);
                    // Session["leveltype"] = "Admin";
                    if (leveltype == "Admin     ")
                    {
                        Response.Redirect("chartdashboard.aspx", false);
                    }
                    if (leveltype == "SuperAdmin")
                    {
                        Response.Redirect("chartdashboard.aspx", false);
                    }
                    if (leveltype == "User      ")
                    {
                        Response.Redirect("InwardReport.aspx", false);
                    }
                    if (leveltype == "Operations")
                    {
                        Response.Redirect("PoDashBoard.aspx", false);
                    }
                    if (leveltype == "Issue     ")
                    {
                        Response.Redirect("IssueDashBoard.aspx", false);
                    }
                    if (leveltype == "Receipt   ")
                    {
                        Response.Redirect("InwardDashboard.aspx", false);
                    }
                    if (leveltype == "Section   ")
                    {
                        Response.Redirect("IndentEntry.aspx", false);
                    }
                //}
                //else
                //{
                //    lblMsg.Text = "Already Some one Login With This User Name";
                //}
            }
            else
            {
                lblMsg.Text = "Invalid userId and Password";
            }
        }
        catch (Exception ex)
        {
            lblMsg.Text = ex.Message;
        }
    }

    private void btnLogin_Click()
    {
        try
        {
            vdm = new SalesDBManager();
            string firstname = Request.QueryString["username"];
            string lastname = Request.QueryString["pwd"];
            Usernme_txt.Text = firstname;
            Pass_pas.Text = lastname;
            if (Usernme_txt.Text.Trim() == "" || Pass_pas.Text.Trim() == "")
            {
                lblMsg.Text = "Required userName and password";
                return;
            }
            string userid = Usernme_txt.Text, password = Pass_pas.Text;
            cmd = new SqlCommand("SELECT branchmaster.gstin, branchmaster.branchledgername, branchmapping.mainbranch, employe_details.sno, employe_details.loginflag, employe_details.employename, employe_details.userid, employe_details.password, employe_details.emailid, employe_details.phone, employe_details.branchtype, employe_details.leveltype, employe_details.departmentid, employe_details.branchid, branchmaster.branchid AS Expr1, branchmaster.branchname, branchmaster.address, branchmaster.branchcode, branchmaster.phone AS Expr2, branchmaster.tino, branchmaster.stno, branchmaster.cstno, branchmaster.emailid AS Expr3, branchmaster.statename FROM employe_details INNER JOIN branchmaster ON employe_details.branchid = branchmaster.branchid INNER JOIN departmentmaster ON departmentmaster.sno=employe_details.departmentid INNER JOIN branchmapping ON branchmaster.branchid=branchmapping.subbranch WHERE (employe_details.userid = @userid) AND (employe_details.password = @pwd)");
            cmd.Parameters.Add("@pwd", password);
            cmd.Parameters.Add("@userid", userid);
            DataTable dt = vdm.SelectQuery(cmd).Tables[0];
            if (dt.Rows.Count > 0)
            {
                string loginflag = dt.Rows[0]["loginflag"].ToString();
                //if (loginflag == "False")
                //{
                string sno = dt.Rows[0]["sno"].ToString();
                cmd = new SqlCommand("update employe_details set loginflag=@log where sno=@sno");
                cmd.Parameters.Add("@log", "1");
                cmd.Parameters.Add("@sno", sno);
                vdm.Update(cmd);
                Session["TinNo"] = "37921042267";
                Session["mainbranch"] = dt.Rows[0]["mainbranch"].ToString();
                Session["Employ_Sno"] = dt.Rows[0]["sno"].ToString();
                Session["Po_BranchID"] = dt.Rows[0]["branchid"].ToString();
                Session["stateid"] = dt.Rows[0]["statename"].ToString();
                Session["TitleName"] = "SRI VYSHNAVI DAIRY SPECIALITIES (P) LTD";
                string julydt = "07/01/2017 12:00:00 AM";
                DateTime gst_dt = Convert.ToDateTime(julydt);
                DateTime today = DateTime.Today;
                //if (today > gst_dt)
                //{
                Session["Address"] = dt.Rows[0]["address"].ToString();
                Session["gstin"] = dt.Rows[0]["gstin"].ToString();
                //}
                //else
                //{
                //    Session["Address"] = "Survey No. 381-2, Punabaka Village, Pellakuru mandal SPSR Nellore (Dt) Pin - 524129, Andhra Pradesh,11. Email : purchase@vyshnavidairy.in Phone: 7729995606; GSTIN NO: 37921042267.";
                //   // Session["Address"] = "Survey No. 381-2, Punabaka Village, Pellakuru mandal SPSR Nellore (Dt) Pin - 524129.Couriering address : No.45, Madhu apartments,Panagal-517640,Srikalahasthi,Chittoor(dt),AndhraPradesh. Email : gupta@vyshnavi.in;purchase@vyshnavidairy.in Phone: 7729995606,7729995603,9382525913; GSTIN: 37921042267."; //dt.Rows[0]["address"].ToString();
                //}
                Session["BranchCode"] = dt.Rows[0]["branchcode"].ToString();
                Session["TinNo"] = "37921042267";
                Session["stno"] = dt.Rows[0]["stno"].ToString();
                Session["cstno"] = dt.Rows[0]["cstno"].ToString();
                Session["phone"] = dt.Rows[0]["phone"].ToString();
                Session["emailid"] = dt.Rows[0]["emailid"].ToString();
                Session["UserName"] = dt.Rows[0]["employename"].ToString();
                Session["password"] = dt.Rows[0]["password"].ToString();
                Session["BranchType"] = dt.Rows[0]["branchtype"].ToString();
                Session["Department"] = dt.Rows[0]["departmentid"].ToString();
                Session["leveltype"] = dt.Rows[0]["leveltype"].ToString();
                Session["branchledgername"] = dt.Rows[0]["branchledgername"].ToString();


                string branchtype = dt.Rows[0]["BranchType"].ToString();
                string leveltype = dt.Rows[0]["leveltype"].ToString();




                Response.Cookies["UserName"].Value = HttpUtility.UrlEncode("true");
                Response.Cookies["UserName"].Path = "/";
                Response.Cookies["UserName"].Expires = DateTime.Now.AddDays(1);

                Response.Cookies["Employ_Sno"].Value = HttpUtility.UrlEncode("true");
                Response.Cookies["Employ_Sno"].Path = "/";
                Response.Cookies["Employ_Sno"].Expires = DateTime.Now.AddDays(1);

                //get ip address and device type
                string ipaddress;
                ipaddress = Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
                if (ipaddress == "" || ipaddress == null)
                {
                    ipaddress = Request.ServerVariables["REMOTE_ADDR"];
                }
                DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
                HttpBrowserCapabilities browser = Request.Browser;
                string devicetype = "";
                string userAgent = Request.ServerVariables["HTTP_USER_AGENT"];
                Regex OS = new Regex(@"(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino", RegexOptions.IgnoreCase | RegexOptions.Multiline);
                Regex device = new Regex(@"1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-", RegexOptions.IgnoreCase | RegexOptions.Multiline);
                string device_info = string.Empty;
                if (OS.IsMatch(userAgent))
                {
                    device_info = OS.Match(userAgent).Groups[0].Value;
                }
                if (device.IsMatch(userAgent.Substring(0, 4)))
                {
                    device_info += device.Match(userAgent).Groups[0].Value;
                }
                if (!string.IsNullOrEmpty(device_info))
                {
                    devicetype = device_info;
                    string[] words = devicetype.Split(')');
                    devicetype = words[0].ToString();
                }
                else
                {
                    devicetype = "Desktop";
                }


                //string alphabets = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
                //string small_alphabets = "abcdefghijklmnopqrstuvwxyz";
                //string numbers = "1234567890";

                //string characters = numbers;
                //characters += alphabets + small_alphabets + numbers;
                //int length = 8;
                //string otp = string.Empty;
                //for (int i = 0; i < length; i++)
                //{
                //    string character = string.Empty;
                //    do
                //    {
                //        int index = new Random().Next(0, characters.Length);
                //        character = characters.ToCharArray()[index].ToString();
                //    } while (otp.IndexOf(character) != -1);
                //    otp += character; 
                //}
                cmd = new SqlCommand("INSERT INTO logininfo(userid, username, logintime, ipaddress, devicetype) values (@userid, @UserName, @logintime, @ipaddress, @device)");
                cmd.Parameters.Add("@userid", dt.Rows[0]["sno"].ToString());
                cmd.Parameters.Add("@UserName", Session["UserName"]);
                cmd.Parameters.Add("@logintime", ServerDateCurrentdate);
                cmd.Parameters.Add("@ipaddress", ipaddress);
                cmd.Parameters.Add("@device", devicetype);
                //cmd.Parameters.Add("@otp", otp);
                vdm.insert(cmd);
                // Session["leveltype"] = "Admin";
                if (leveltype == "Admin     ")
                {
                    Response.Redirect("chartdashboard.aspx", false);
                }
                if (leveltype == "SuperAdmin")
                {
                    Response.Redirect("chartdashboard.aspx", false);
                }
                if (leveltype == "User      ")
                {
                    Response.Redirect("InwardReport.aspx", false);
                }
                if (leveltype == "Operations")
                {
                    Response.Redirect("PoDashBoard.aspx", false);
                }
                if (leveltype == "Issue     ")
                {
                    Response.Redirect("IssueDashBoard.aspx", false);
                }
                if (leveltype == "Receipt   ")
                {
                    Response.Redirect("InwardDashboard.aspx", false);
                }
                if (leveltype == "Section   ")
                {
                    Response.Redirect("IndentEntry.aspx", false);
                }
                //}
                //else
                //{
                //    lblMsg.Text = "Already Some one Login With This User Name";
                //}
            }
            else
            {
                lblMsg.Text = "Invalid userId and Password";
            }
        }
        catch (Exception ex)
        {
            lblMsg.Text = ex.Message;
        }
    }

}