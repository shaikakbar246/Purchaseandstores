<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true"
    CodeFile="EmployeeDetails.aspx.cs" Inherits="EmployeeDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">

        $(function () {
            get_Employe_details();
            get_employee_names();
            get_Department_Details();
            get_Branch_details();
            scrollTo(0, 0);
        });

        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }
        function ValidateAlpha(evt) {
            var keyCode = (evt.which) ? evt.which : evt.keyCode
            if ((keyCode < 65 || keyCode > 90) && (keyCode < 97 || keyCode > 123) && keyCode != 32)

                return false;
            return true;
        }
        function validationemail() {
            var x = document.getElementById("txtMail").value;
            var atpos = x.indexOf("@");
            var dotpos = x.lastIndexOf(".");
            if (atpos < 1 || dotpos < atpos + 2 || dotpos + 2 >= x.length) {
                alert("Not a valid e-mail address");
            }
        }

        function callHandler(d, s, e) {
            $.ajax({
                url: 'FleetManagementHandler.axd',
                data: d,
                type: 'GET',
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                async: true,
                cache: true,
                success: s,
                Error: e
            });
        }
        function get_Department_Details() {
            var data = { 'op': 'get_Department_Details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        filldepartment(msg);
                    }
                    else {
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function filldepartment(msg) {
            var data = document.getElementById('ddldepartment');
            var length = data.options.length;
            document.getElementById('ddldepartment').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select Department";
            opt.value = "Select Department";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].department != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].department;
                    option.value = msg[i].sno;
                    data.appendChild(option);
                }
            }
        }


        function get_Branch_details() {
            var data = { 'op': 'get_Branch_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillbranch(msg);
                    }
                    else {
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function fillbranch(msg) {
            var data = document.getElementById('ddlbranch');
            var length = data.options.length;
            document.getElementById('ddlbranch').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select Branch";
            opt.value = "Select Branch";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].branchname != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].branchname;
                    option.value = msg[i].branchid;
                    data.appendChild(option);
                }
            }
        }

        function cancel_Employee_Details() {
            $("#div_EmployeeData").show();
            $("#employee_fillform").hide();
            $('#show_employeelogs').show();
            document.getElementById('txt_employee_search').value = "";
            scrollTo(0, 0);
        }

        function saveEmployeDetails() {
            var sno = document.getElementById('lbl_sno').value;
            var EmployeName = document.getElementById('txtEmpName').value;
            var Userid = document.getElementById('txtUserid').value;
            var password = document.getElementById('txtPaswd').value;
            var Phone = document.getElementById('txtPhnNO').value;
            var E_Mail = document.getElementById('txtMail').value;
            var BranchType = document.getElementById('ddlbranch').value;
            var Department = document.getElementById('ddldepartment').value;
            var LevelType = document.getElementById('slct_level').value;
            var btnval = document.getElementById('btn_save').innerHTML;
            var sno = document.getElementById('lbl_sno').value;

            if (EmployeName == "") {
                alert("Enter EmployeName name");
                document.getElementById("txtEmpName").focus();
                return false;
            }
            if (Userid == "") {
                alert("Enter  Userid");
                document.getElementById("txtUserid").focus();
                return false;
            }
            if (Phone.trim().length != 10)
            {
                alert("Phone number should be 10 digits only");
                document.getElementById("txtPhnNO").focus();
                return false;
            }
            if (password == "") {
                alert("Enter  password");
                document.getElementById("txtPaswd").focus();
                return false;
            }
            if (E_Mail == "") {
                alert("Enter E_Mail");
                document.getElementById("txtMail").focus();
                return false;
            }

            var atpos = E_Mail.indexOf("@");
            var dotpos = E_Mail.lastIndexOf(".");
            if (atpos < 1 || dotpos < atpos + 2 || dotpos + 2 >= E_Mail.length) {
                alert("Not a valid e-mail address");
                document.getElementById("txtMail").focus();
                return false;
            }

            if (Department == "" || Department == "Select Department") {

                alert("Select Departmet ");
                document.getElementById("ddldepartment").focus();
                return false;
            }

            var data = { 'op': 'saveEmployeDetails', 'EmployeName': EmployeName, 'Userid': Userid, 'password': password, 'Phone': Phone, 'E_Mail': E_Mail, 'BranchType': BranchType, 'Department': Department, 'LevelType': LevelType, 'btnVal': btnval, 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        forclearall();
                        get_Employe_details();
                        $('#div_EmployeeData').show();
                        $('#employee_fillform').css('display', 'none');
                        $('#show_employeelogs').css('display', 'block');
                        scrollTo(0, 0);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function forclearall() {
            document.getElementById('txt_employee_search').value = "";
            document.getElementById('txtEmpName').value = "";
            document.getElementById('txtUserid').value = "";
            document.getElementById('txtPaswd').value = "";
            document.getElementById('txtPhnNO').value = "";
            document.getElementById('txtMail').value = "";
            document.getElementById('ddlbranch').selectedIndex = 0;
            document.getElementById('ddldepartment').selectedIndex = 0;
            document.getElementById('slct_level').selectedIndex = 0;
            document.getElementById('btn_save').innerHTML = "save";
        }
        function show_employee_design() {
            $("#div_EmployeeData").hide();
            $("#employee_fillform").show();
            $('#show_employeelogs').hide();
            forclearall();
            scrollTo(0, 0);
        }

        function get_Employe_details() {
            var data = { 'op': 'get_Employe_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        filldetails(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        function filldetails(msg) {
            scrollTo(0, 0);
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable" role="grid">';
            results += '<thead><tr role="row" class="trbgclrcls"><th scope="col" class="thcls">Employee Name</th><th scope="col" class="thcls">User Id</th><th scope="col" class="thcls">Phone</th><th scope="col" class="thcls">EMail Id</th><th scope="col" class="thcls">Department</th><th scope="col" class="thcls">Level Type</th><th scope="col"></th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var cl = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            var lclr = ["#ff9800", "#d73925", "#1e88e5", "#f44336", "#4caf50"];
            for (var i = 0; i < msg.length; i++) {
                var clr = "";
                var levelty = msg[i].LevelType;
                if (levelty == "SuperAdmin") {
                    clr = "#ff9800";
                }
                if (levelty == "Operations") {
                    clr = "#1e88e5";
                }
                if (levelty == "Admin     ") {
                    clr = "#d73925";
                }
                if (levelty == "User      ") {
                    clr = "#f44336";
                }
                if (levelty == "Issue     ") {
                    clr = "#4caf50";
                }
                if (levelty == "Section   ") {
                    clr = "#4c5667";
                }
                results += '<tr style="background-color:' + COLOR[l] + '">';
                results += '<td> <span class="glyphicon glyphicon-user" style="color: cadetblue;"></span> <span id="1" class="1">' + msg[i].EmployeName + '</span></td>';
                results += '<td class="2">' + msg[i].Userid + '</td>';
                results += '<td style="display:none" class="3">' + msg[i].password + '</td>';
                results += '<td class="4"><span class="glyphicon glyphicon-phone-alt" style="color: cadetblue;"></span><span id="4" class="4"> ' + msg[i].Phone + '</span></td>';
                results += '<td class="5"><i class="fa fa-envelope" style="color: cadetblue;"></i> <span id="5" class="5">' + msg[i].E_Mail + '</span></td>';
                results += '<td style="display:none" class="6">' + msg[i].BranchType + '</td>';
                results += '<td style="display:none" class="11">' + msg[i].branchid + '</td>';
                results += '<td class="10">' + msg[i].departmentname + '</td>';
                results += '<td  style="display:none" class="7">' + msg[i].departmentid + '</td>';
                var leveltype = msg[i].LevelType;
                results += '<td  class="8"><span style="border-radius: 5px;color: white; letter-spacing: 0.05em; background-color:' + clr + '"><span id="8" class="8">' + leveltype.trim() + '</span></span></td>';
                results += '<td data-title="brandstatus"><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"  onclick="getme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td>';
                results += '<td style="display:none" class="9">' + msg[i].sno + '</td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
                cl = cl + 1;
                if (cl == 5) {
                    cl = 0;
                }
            }
            results += '</table></div>';
            $("#div_EmployeeData").html(results);
        }
        function getme(thisid) {
            scrollTo(0, 0);
            var EmployeName = $(thisid).parent().parent().find('#1').text();
            var Userid = $(thisid).parent().parent().children('.2').html();
            var password = $(thisid).parent().parent().children('.3').html();
            var Phone = $(thisid).parent().parent().find('#4').html();
            var E_Mail = $(thisid).parent().parent().find('#5').html();
            var BranchType = $(thisid).parent().parent().children('.6').html();
            var departmentid = $(thisid).parent().parent().children('.7').html();
            var LevelType = $(thisid).parent().parent().find('#8').html();
            var sno = $(thisid).parent().parent().children('.9').html();
            var departmentname = $(thisid).parent().parent().children('.10').html();
            var branchid = $(thisid).parent().parent().children('.11').html();
            document.getElementById('txtEmpName').value = EmployeName;
            document.getElementById('txtUserid').value = Userid;
            document.getElementById('txtPaswd').value = password;
            document.getElementById('txtPhnNO').value = Phone;
            document.getElementById('txtMail').value = E_Mail;
            document.getElementById('ddlbranch').value = branchid;
            document.getElementById('ddldepartment').value = departmentid;
            document.getElementById('lbl_sno').value = sno;
            document.getElementById('slct_level').value = LevelType;
            document.getElementById('btn_save').innerHTML = "Modify";
            $("#div_EmployeeData").hide();
            $("#employee_fillform").show();
            $('#show_employeelogs').hide();

        }

        var employeenames = [];
        function get_employee_names() {
            var data = { 'op': 'get_Employe_details' };
            var s = function (msg) {
                if (msg) {
                    employeenames = msg;
                    var availableTags = [];
                    for (var i = 0; i < msg.length; i++) {
                        var EmployeName = msg[i].EmployeName;
                        availableTags.push(EmployeName);
                    }
                    $('#txt_employee_search').autocomplete({
                        source: availableTags,
                        //change: employeenamechange,
                        autoFocus: true
                    });
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        
        function employee_det_byname()
        {
            var emp_name = document.getElementById('txt_employee_search').value;
            if (emp_name == "") {
                var data = { 'op': 'get_Employe_details' };
            }
            else {
                var data = { 'op': 'get_Employe_details_name', 'emp_name': emp_name };
            }
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        filldetails(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Employee Master
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Masters</a></li>
            <li><a href="#">EmployeeMaster</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Employee Details
                </h3>
            </div>
            <div class="box-body">
                <div id="show_employeelogs"><%-- align="center"--%>
                    <table>
                        <tr>
                            <td>
                               <div class="input-group margin">
                <input id="txt_employee_search" type="text" style="height: 28px; opacity: 1.0; width: 150px;" class="form-control" name="employee_search" onchange="employee_det_byname();" placeholder="Enter Emloyee Name" />
                
                    <span class="input-group-btn">
                      <button type="button" class="btn btn-info btn-flat" style="height: 28px;"><i class="fa fa-search" aria-hidden="true"></i></button>
                    </span>
              </div>
                                
                            </td>
                            <td style="width:66%">
                            </td>
                            <td>
                            <div class="input-group">
                                <div class="input-group-addon">
                                <span class="glyphicon glyphicon-plus-sign" onclick="showbranchdesign()"></span> <span onclick="show_employee_design()">Add Employee</span>
                          </div>
                          </div>
                               <%-- <input id="btn_addEmployee" type="button" name="submit" value='Add Employee' class="btn btn-primary" onclick="show_employee_design()" />--%>
                            </td>
                        </tr>
                    </table>
                </div>
                <div id="div_EmployeeData">
                </div>
                <div id='employee_fillform' style="display: none;">
                    <table align="center">
                        <tr>
                            <td style="height: 40px;">
                                <label>Employee Name</label><span style="color: red;">*</span>
                                <input id="txtEmpName" type="text" name="CustomerFName" class="form-control" placeholder="Enter Employee Name" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td>
                                <label>User Id</label><span style="color: red;">*</span>
                                <input id="txtUserid" type="text" name="CustomerLName" class="form-control" placeholder="Enter User Id" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>Password</label><span style="color: red;">*</span>
                                <input id="txtPaswd" type="text" name="CustomerCode" class="form-control" placeholder="Enter Password" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;">
                                <label>Phone No</label>
                                <input id="txtPhnNO" type="text" name="CCName" class="form-control" placeholder="Enter Phone Number" onkeypress="return isNumber(event)" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>EMail Id</label><span style="color: red;">*</span>
                                <input id="txtMail" type="text" name="CMobileNumber" class="form-control" placeholder="Enter Email" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td>
                                <label>Branch Type</label>
                                <select id="ddlbranch" class="form-control">
                                    <option placeholder="Select Branch">Select Branch</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                 <label>Department</label><span style="color: red;">*</span>
                                <select id="ddldepartment" class="form-control">
                                    <option placeholder="Select Department">Select Department</option>
                                </select>
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;">
                                <label>Level Type</label>
                                <select id="slct_level" class="form-control">
                                    <option>Admin</option>
                                    <option>SuperAdmin</option>
                                    <option>Operations</option>
                                     <option>Issue</option>
                                     <option>Receipt</option>
                                    <option>User</option>
                                </select>
                            </td>
                        </tr>
                        <tr hidden>
                            <td>
                                <label id="lbl_sno">
                                </label>
                            </td>
                        </tr>
                    </table>
                    <table align="center">
                        <tr>
                            <td colspan="2" style="height: 40px;">
                                <table>
                                   <tr>
                                    <td>
                                    <div class="input-group">
                                        <div class="input-group-addon">
                                        <span class="glyphicon glyphicon-ok" id="btn_save1" onclick="saveEmployeDetails()"></span> <span id="btn_save" onclick="saveEmployeDetails()">save</span>
                                  </div>
                                  </div>
                                    </td>
                                    <td style="width:10px;"></td>
                                    <td>
                                     <div class="input-group">
                                        <div class="input-group-close">
                                        <span class="glyphicon glyphicon-remove" id='btn_close1' onclick="cancel_Employee_Details()"></span> <span id='btn_close' onclick="cancel_Employee_Details()">Close</span>
                                  </div>
                                  </div>
                                    </td>
                                    </tr>
                               </table>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </section>
</asp:Content>
