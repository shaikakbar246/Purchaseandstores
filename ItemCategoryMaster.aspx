<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true" CodeFile="ItemCategoryMaster.aspx.cs" Inherits="CategoryMaster" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    $(function () {
        get_Category_details();
        scrollTo(0, 0);
    });
    function isFloat(evt) {
        var charCode = (event.which) ? event.which : event.keyCode;
        if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
            return false;
        }
        else {
            //if dot sign entered more than once then don't allow to enter dot sign again. 46 is the code for dot sign
            var parts = evt.srcElement.value.split('.');
            if (parts.length > 1 && charCode == 46)
                return false;
            return true;
        }
    }
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
        $("#div_CategoryData").show();
        $("#fillform").hide();
        $('#showlogs').show();
        forclearall();
        scrollTo(0, 0);
    }
    function saveCategoryDetails() {
        var category = document.getElementById('txtCategoryName').value;
        if (category == "") {
            alert("Enter Category Name");
            document.getElementById('txtCategoryName').focus();
            return false;
        }
        var cat_code = document.getElementById('txt_cat_code').value;
        if (cat_code == "")
        {
            alert("Enter Category Code");
            document.getElementById('txt_cat_code').focus();
            return false;
        }
        var sapcode = document.getElementById('txt_sap_code').value;
        //if (sapcode == "") {
        //    alert("Enter SAP Code");
        //    return false;
        //}
        var Categoryid = document.getElementById('lbl_sno').value;
        var status = document.getElementById('ddlstatus').value;
        var btnval = document.getElementById('btn_save').innerHTML;
        var data = { 'op': 'saveCategoryDetails', 'Name': category, 'sapcode': sapcode, 'Status': status, 'btnVal': btnval, 'categoryid': Categoryid, 'cat_code': cat_code };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    alert(msg);
                    forclearall();
                    get_Category_details();
                    $('#div_CategoryData').show();
                    $('#fillform').css('display', 'none');
                    $('#showlogs').css('display', 'block');
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
    function show_CategoryDesign() {
        $("#div_CategoryData").hide();
        $("#fillform").show();
        $('#showlogs').hide();
        forclearall();
        scrollTo(0, 0);
    }
    function get_Category_details() {
        var data = { 'op': 'get_Category_details' };
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
        results += '<thead><tr class="trbgclrcls"><th scope="col" style="font-weight: bold;">Category Name</th><th scope="col" style="font-weight: bold;">Category Code</th><th scope="col" style="font-weight: bold;">Status</th><th scope="col"></th></tr></thead></tbody>';
        var k = 1;
        var l = 0;
        var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
        for (var i = 0; i < msg.length; i++) {
            results += '<tr style="background-color:' + COLOR[l] + '">';
            results += '<td data-title="brandstatus" class="1"><span class="glyphicon glyphicon-list" style="color: cadetblue;"></span> <span id="1" class="1"> ' + msg[i].Category + ' </span></td>';
            results += '<td data-title="brandstatus" class="4">' + msg[i].cat_code + '</td>';
            results += '<td data-title="brandstatus" class="2">' + msg[i].status + '</td>';
            results += '<td data-title="brandstatus"><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls" onclick="getme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td>';
            results += '<td style="display:none" class="3">' + msg[i].categoryid + '</td></tr>';
            l = l + 1;
            if (l == 4) {
                l = 0;
            }
        }
        results += '</table></div>';
        $("#div_CategoryData").html(results);
    }
    function getme(thisid) {
        scrollTo(0, 0);
        var CategoryName = $(thisid).parent().parent().find('#1').html();
        var statuscode = $(thisid).parent().parent().children('.2').html();
        var categoryid = $(thisid).parent().parent().children('.3').html();
        var cat_code = $(thisid).parent().parent().children('.4').html();

        if (statuscode == "Enabled") {

            status = "0";
        }
        else {
            status = "1";
        }

        document.getElementById('txtCategoryName').value = CategoryName;
        document.getElementById('txt_cat_code').value = cat_code;
        document.getElementById('ddlstatus').value = status;
        document.getElementById('lbl_sno').value = categoryid;
        document.getElementById('btn_save').innerHTML = "Modify";
        $("#div_CategoryData").hide();
        $("#fillform").show();
        $('#showlogs').hide();
    }
    function forclearall() {
        document.getElementById('txtCategoryName').value = "";
        document.getElementById('txt_sap_code').value = "";
        document.getElementById('ddlstatus').selectedIndex =0;
        document.getElementById('lbl_sno').value = "";
        document.getElementById('txt_cat_code').value = "";
        document.getElementById('btn_save').innerHTML = "Save";
        $("#lbl_code_error_msg").hide();
        $("#lbl_name_error_msg").hide();
    }
 </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<section class="content-header">
        <h1>
            Item Category  Master
        </h1>
   <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operation</a></li>
            <li><a href="#">Item CategoryMaster</a></li>
        </ol> 
</section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Item Category Details
                </h3>
            </div>
            <div class="box-body">
              <div id="showlogs" class="input-group" style="padding-left:88%;">
                                <div class="input-group-addon">
                                <span class="glyphicon glyphicon-plus-sign" onclick="show_CategoryDesign()"></span> <span onclick="show_CategoryDesign()">Add Category</span>
                          </div>
                          </div>
                <div id="div_CategoryData" style="padding-top:2px;">
                </div>
                <div id='fillform' style="display: none;">
                   <table align="center" style="width: 42%;">
                        <tr>
                            <th>
                            </th>
                        </tr>
                        <tr>
                            <td style="height:40px; width:35%;">
                            <label>Category Name</label><span style="color: red;">*</span>
                            </td>
                            <td>
                                <input id="txtCategoryName" type="text" maxlength="45" class="form-control" name="vendorcode"
                                    placeholder="Enter Category Name"/><label id="lbl_code_error_msg" class="errormessage">* Please Enter
                                        CategoryName</label>
                            </td>
                        </tr>
                        <tr>
                            <td style="height:40px;">
                                <label>Category Code</label><span style="color: red;">*</span>
                            </td>
                            <td>
                                <input id="txt_cat_code" class="form-control" type="text" name="cat_code" onkeypress="return isNumber(event)" placeholder="Enter Category Code" />
                            </td>
                        </tr>
                        <tr>
                            <td style="height:40px;"><label>SAP Code</label><%--<span style="color: red;">*</span>--%></td>
                            <td>
                                <input id="txt_sap_code" type="text" class="form-control" name="sapcode" placeholder="Enter SAP Code" />
                            </td>
                        </tr>
                        <tr>
                            <td style="height:40px;">
                           <label>Status</label><span style="color: red;">*</span>     
                           </td>
                            <td>
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
                           <td colspan="2" align="center" style="height:40px;">
                                <table>
                                   <tr>
                                    <td>
                                    <div class="input-group">
                                        <div class="input-group-addon">
                                        <span class="glyphicon glyphicon-ok" id="btn_save1" onclick="saveCategoryDetails()"></span> <span id="btn_save" onclick="saveCategoryDetails()">save</span>
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

