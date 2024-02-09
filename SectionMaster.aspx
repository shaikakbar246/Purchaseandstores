<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true"
    CodeFile="SectionMaster.aspx.cs" Inherits="SectionMaster" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        $(function () {
            get_section_details();
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
            $("#div_SectionData").show();
            $("#fillform").hide();
            $('#showlogs').show();
            forclearall();
        }
        function saveSectionDetails() {
            var name = document.getElementById('txtSectionName').value;
            if (name == "") {
                alert("Enter Section Name");
                document.getElementById('txtSectionName').focus();
                return false;
            }
            var sectionid = document.getElementById('lbl_sno').value;
            var status = document.getElementById('ddlstatus').value;
            if (status == "") {
                alert("please Select status");
                document.getElementById('ddlstatus').focus();
                return false;
            }
            var btnval = document.getElementById('btn_save').innerHTML;
            var data = { 'op': 'saveSectionDetails', 'Name': name, 'Status': status, 'btnVal': btnval, 'sectionid': sectionid };//, 'Color': color
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        forclearall();
                        get_section_details();
                        $('#div_SectionData').show();
                        $('#fillform').css('display', 'none');
                        $('#showlogs').css('display', 'block');
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

        function showdesign() {
            $("#div_SectionData").hide();
            $("#fillform").show();
            $('#showlogs').hide();
            forclearall();
        }
        function get_section_details() {
            var data = { 'op': 'get_section_details' };
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
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable">';
            results += '<thead><tr role="row" class="trbgclrcls"><th scope="col" style="font-weight: bold;">Section Name</th><th scope="col" style="font-weight: bold;">Status</th><th scope="col" style="font-weight: bold;"></th></tr></thead></tbody>';

            var k = 1;
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">'; //<td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="Edit" /></td>
                results += '<td scope="row" class="1">' + msg[i].sectionname + '</td>';
                results += '<td data-title="sectionstatus" class="3">' + msg[i].status + '</td>';
                results += '<td data-title="brandstatus"><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"  onclick="getme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td>';
                results += '<td style="display:none" class="4">' + msg[i].SectionId + '</td></tr>';

                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
        }
        function getme(thisid) {
        scrollTo(0, 0);
        var sectionname = $(thisid).parent().parent().children('.1').html();
        var statuscode = $(thisid).parent().parent().children('.3').html();
        var SectionId = $(thisid).parent().parent().children('.4').html();

        if (statuscode == "Enabled") {

            status = "0";
        }
        else {
            status = "1";
        }


        document.getElementById('txtSectionName').value = sectionname;
        document.getElementById('ddlstatus').value = status;
        document.getElementById('lbl_sno').value = SectionId;
        document.getElementById('btn_save').innerHTML = "Modify";
        $("#div_SectionData").hide();
        $("#fillform").show();
        $('#showlogs').hide();
    }
    function forclearall() {
        document.getElementById('txtSectionName').value = "";
        document.getElementById('ddlstatus').selectedIndex = 0;
        document.getElementById('lbl_sno').value = "";
        document.getElementById('btn_save').innerHTML = "Save";
        $("#lbl_code_error_msg").hide();
        $("#lbl_name_error_msg").hide();
        scrollTo(0, 0);
    }
    </script>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Section Master
        </h1>
   <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operation</a></li>
            <li><a href="#">SectionMaster</a></li>
        </ol> 
  </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Section Details
                </h3>
            </div>
            <div class="box-body">
                <div id="showlogs" align="center">
                    <div id="show_department" class="input-group" style="padding-left:89%;">
                      <div class="input-group-addon">
                        <span class="glyphicon glyphicon-plus-sign" onclick="showdesign()"></span> <span onclick="showdesign()">Add Section</span>
                      </div>
                    </div>
                </div>
                <div id="div_SectionData" style="padding-top:2px;"></div>
           
                <div id='fillform' style="display: none;">
                   <table align="center" style="width: 60%;">
                        <tr>
                            <th>
                            </th>
                        </tr>
                        <tr>
                            <td style="height:40px;">
                             <label>Section Name</label><span style="color: red;">*</span>
                            </td>
                            <td>
                                <input id="txtSectionName" type="text" maxlength="45" class="form-control" name="vendorcode"
                                    placeholder="Enter Section Name"/><label id="lbl_code_error_msg" class="errormessage">* Please Enter
                                        SectionName</label>
                            </td>
                        </tr>
                      
                      <tr>
                             <td style="height:40px;">
                             <label>Select Status</label><span style="color: red;">*</span>     
                            </td>
                             <td>
                             <select ID="ddlstatus"  class="form-control">
                             <option value="1">Active</option>
                             <option value="0">InActive</option>
                             </select>
                             </td>
                      </tr>
                      <tr style="display:none;">
                        <td >
                        <label id="lbl_sno"></label>
                        </td>
                        </tr>
                      <tr>
                           <td colspan="2" align="center" style="height:40px;">
                                <table>
                                   <tr>
                                    <td>
                                    <div class="input-group">
                                        <div class="input-group-addon">
                                        <span class="glyphicon glyphicon-ok" id="btn_save1" onclick="saveSectionDetails()"></span> <span id="btn_save" onclick="saveSectionDetails()">save</span>
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
