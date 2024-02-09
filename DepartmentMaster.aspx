<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true"
    CodeFile="DepartmentMaster.aspx.cs" Inherits="DepartmentMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        $(function () {
            get_Department_Details();
            scrollTo(0, 0);
        });
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
        function canceldetails() {
            $("#Div_Department").show();
            $("#Department_fillform").hide();
            $('#show_department').show();
            forclearall();
            scrollTo(0, 0);
        }
        function saveDepartmentDetails() {
            var department = document.getElementById('txtDepartment').value;
            if (department == "") {
                alert("Enter Department  Name");
                document.getElementById('txtDepartment').focus();
                return false;
            }
            var sno = document.getElementById('lbl_sno').value;
            var status = document.getElementById('ddlstatus').value;
            var btnval = document.getElementById('btn_save').innerHTML;
            var data = { 'op': 'saveDepartmentdetails', 'department': department, 'status': status, 'btnVal': btnval, 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        forclearall();
                        get_Department_Details();
                        $('#Div_Department').show();
                        $('#Department_fillform').css('display', 'none');
                        $('#show_department').css('display', 'block');
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
        function showdepartment_design() {
            $("#Div_Department").hide();
            $("#Department_fillform").show();
            $('#show_department').hide();
            forclearall();
            scrollTo(0, 0);
        }
        function get_Department_Details() {
            var data = { 'op': 'get_Department_Details' };
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
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable" role="grid">';
            results += '<thead><tr role="row" class="trbgclrcls"><th scope="col" style="font-weight: bold;">Department Name</th><th scope="col" style="font-weight: bold;">Status</th><th></th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">';
                results += '<td scope="row" class="1">' + msg[i].department + '</td>';
                results += '<td class="2" >' + msg[i].status + '</td>';
                results += '<td data-title="brandstatus"><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls" onclick="getme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td>';
                results += '<td style="display:none" class="3">' + msg[i].sno + '</td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#Div_Department").html(results);
        }
        function getme(thisid) {
            scrollTo(0, 0);
            var department = $(thisid).parent().parent().children('.1').html();
            var statuscode = $(thisid).parent().parent().children('.2').html();
            var sno = $(thisid).parent().parent().children('.3').html();
            if (statuscode == "Enabled") {
                status = "0";
            }
            else {
                status = "1";
            }
            document.getElementById('txtDepartment').value = department;
            document.getElementById('ddlstatus').value = status;
            document.getElementById('lbl_sno').value = sno;
            document.getElementById('btn_save').innerHTML = "Modify";
            $("#Div_Department").hide();
            $("#Department_fillform").show();
            $('#show_department').hide();
        }
        function forclearall() {
            document.getElementById('txtDepartment').value = "";
            document.getElementById('ddlstatus').selectedIndex = 0;
            document.getElementById('lbl_sno').value = "";
            document.getElementById('btn_save').innerHTML = "Save";
            $("#lbl_code_error_msg").hide();
            $("#lbl_name_error_msg").hide();
        } 
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Department Master
        </h1>
   <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operation</a></li>
            <li><a href="#">Department Master</a></li>
        </ol> 
  </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Department Master
                </h3>
            </div>
            <div class="box-body">
                <div id="show_department" class="input-group" style="padding-left:81%;">
                     <div class="input-group-addon">
                         <span class="glyphicon glyphicon-plus-sign" onclick="showbranchdesign()"></span> <span onclick="showdepartment_design()">Add Department</span>
                     </div>
                </div>
               
                <div id="Div_Department" style="padding-top:2px;">
                </div>
                <div id='Department_fillform' style="display: none;">
                   <table align="center" style="width: 60%;">
                        <tr>
                            <th>
                            </th>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                             <label>Department Name<span style="color: red;">*</span></label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txtDepartment" type="text" maxlength="45" class="form-control" name="Department"
                                    placeholder="Enter Department Name"/><label id="lbl_code_error_msg" class="errormessage">* Please Enter
                                         Department Name</label>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                            <label>Status<span style="color: red;">*</span></label>     
                            </td>
                            <td style="height: 40px;">
                             <select ID="ddlstatus" class="form-control" >
                             <option value="1">Active</option>
                             <option value="0">InActive</option>
                             </select>
                             </td>
                        </tr>
                      
                        
                      <tr style="display:none;">
                      <td>
                      <label id="lbl_sno"></label>
                      </td>
                      </tr>
                      <tr>
                           <td colspan="4" align="center" style="height:40px;">
                              <table>
                                   <tr>
                                    <td>
                                    <div class="input-group">
                                        <div class="input-group-addon">
                                          <span class="glyphicon glyphicon-ok" id="btn_save1" onclick="saveDepartmentDetails()"></span> <span id="btn_save" onclick="saveDepartmentDetails()">save</span>
                                        </div>
                                    </div>
                                    </td>
                                    <td style="width:10px;"></td>
                                    <td>
                                    <div class="input-group">
                                        <div class="input-group-close">
                                            <span class="glyphicon glyphicon-remove" id='btn_close1' onclick="canceldetails()"></span> <span id='btn_close' onclick="canceldetails()">Close</span>
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
