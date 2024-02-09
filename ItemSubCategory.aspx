<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true" CodeFile="ItemSubCategory.aspx.cs" Inherits="SubCategory" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    $(function () {
        get_Category_details();
        get_Sub_Category_details();
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
        forclearall();
        $("#div_SubCategoryData").show();
        $("#Sub_CategoryFillForm").hide();
        $('#sub_Category_FillForms').show();
        scrollTo(0, 0);
    }
    function showdesign() {
        forclearall();
        $("#div_SubCategoryData").hide();
        $("#Sub_CategoryFillForm").show();
        $('#sub_Category_FillForms').hide();
        scrollTo(0, 0);
    }

    function get_Category_details() {
        var data = { 'op': 'get_Category_details' };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    fillcategory(msg);
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
    function get_Sub_Category_details() {
        var data = { 'op': 'get_Sub_Category_details' };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    BindGrid(msg);
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
    function fillcategory(msg) {
        var data = document.getElementById('ddlcategory');
        var length = data.options.length;
        document.getElementById('ddlcategory').options.length = null;
        var opt = document.createElement('option');
        opt.innerHTML = "Select Category";
        opt.value = "Select category";
        opt.setAttribute("selected", "selected");
        opt.setAttribute("disabled", "disabled");
        opt.setAttribute("class", "dispalynone");
        data.appendChild(opt);
        for (var i = 0; i < msg.length; i++) {
            if (msg[i].Category != null) {
                var option = document.createElement('option');
                option.innerHTML = msg[i].Category;
                option.value = msg[i].categoryid;
                data.appendChild(option);
            }
        }
    }
    function saveSubcategoryDetails() {
        
        var ddlcategory = document.getElementById('ddlcategory').value;
        if (ddlcategory == "" || ddlcategory == "Select Category") {
            alert("Select Categary");
            document.getElementById('ddlcategory').focus();
            return false;
        }
        var subcategoryname = document.getElementById('txtSubCategoryName').value;
        if (subcategoryname == "") {
            alert("Enter Sub Category Name");
            document.getElementById('txtSubCategoryName').focus();
            return false;
        }
        var sub_cat_code = document.getElementById('txt_sub_cat_code').value;
        if (sub_cat_code == "")
        {
            alert("Enter Sub Category Code");
            document.getElementById('txt_sub_cat_code').focus();
            return false;
        }
        var LedgerName = document.getElementById('txtLedger').value;
        var ledgerCode = document.getElementById('txt_ledgerCode').value;
        var sapcode = document.getElementById('txt_sapcode').value;
        //if (sapcode == "") {
        //    alert("Enter Sap Code");
        //    return false;
        //}
        var Subcategoryid = document.getElementById('lbl_sno').value;
        var status = document.getElementById('ddlstatus').value;
        var btnval = document.getElementById('btn_save').innerHTML;
        var data = { 'op': 'saveSubcategoryDetails', 'sapcode': sapcode, 'sub_cat_code': sub_cat_code, 'ledgerCode': ledgerCode, 'CategoryId': ddlcategory, 'SubCategory': subcategoryname, 'LedgerName': LedgerName, 'Status': status, 'btnVal': btnval, 'Subcategoryid': Subcategoryid };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    alert(msg);
                    forclearall();
                    get_Sub_Category_details();
                    $('#div_SubCategoryData').show();
                    $('#Sub_CategoryFillForm').css('display', 'none');
                    $('#sub_Category_FillForms').css('display', 'block');
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
    function BindGrid(msg) {
        var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable" role="grid">';
        results += '<thead><tr class="trbgclrcls"><th scope="col" style="font-weight: bold;">Category Code</th><th scope="col" style="font-weight: bold;">Category Name</th><th scope="col" style="font-weight: bold;">Sub Category Code</th><th scope="col" style="font-weight: bold;">Sub Category Name</th><th scope="col" style="font-weight: bold;">Status</th><th scope="col" style="font-weight: bold;">Ledger Name</th><th scope="col"></th></tr></thead></tbody>';
        var k = 1;
        var l = 0;
        var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
        for (var i = 0; i < msg.length; i++) {
            results += '<tr style="background-color:' + COLOR[l] + '">';
            results += '<td  class="8">' + msg[i].cat_code + '</td>';
            results += '<td  class="1"><span class="glyphicon glyphicon-list" style="color: cadetblue;"></span> ' + msg[i].Category + '</td>';
            results += '<td class="9">' + msg[i].sub_cat_code + '</td>';
            results += '<td data-title="subcatname" class="2"><span class="glyphicon glyphicon-list" style="color: cadetblue;"></span> <span id="2" class="2"> ' + msg[i].subcatname + '</span></td>';
            results += '<td data-title="status" class="3">' + msg[i].status + '</td>';
            results += '<td style="display:none" class="4">' + msg[i].Categoryid + '</td>';
            results += '<td  class="6">' + msg[i].LedgerName + '</td>';
            results += '<td data-title="brandstatus"><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"  onclick="getme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td>';
            results += '<td  style="display:none" class="5">' + msg[i].subcategoryid + '</td>';
            results += '<td  style="display:none" class="7">' + msg[i].ledgerCode + '</td></tr>';
            l = l + 1;
            if (l == 4) {
                l = 0;
            }
        }
        results += '</table></div>';
        $("#div_SubCategoryData").html(results);
    } 
    function getme(thisid) {
        scrollTo(0, 0);
        var subcategoryid = $(thisid).parent().parent().children('.5').html();
        var Category = $(thisid).parent().parent().children('.1').html();
        var Categoryid = $(thisid).parent().parent().children('.4').html();
        var SubCategoryName = $(thisid).parent().parent().find('#2').html();
        var statuscode = $(thisid).parent().parent().children('.3').html();
        var ledgername = $(thisid).parent().parent().children('.6').html();
        var ledgerCode = $(thisid).parent().parent().children('.7').html();
        //var sapcode = $(thisid).parent().parent().children('.10').html();
        var sub_cat_code = $(thisid).parent().parent().children('.9').html();
        if (statuscode == "Enabled") {

            status = "0";
        }
        else {
            status = "1";
        }
        //document.getElementById('txt_sapcode').value = sapcode;
        document.getElementById('txt_sub_cat_code').value = sub_cat_code;
        document.getElementById('txtSubCategoryName').value = SubCategoryName;
        document.getElementById('ddlstatus').value = status;
        document.getElementById('ddlcategory').value = Categoryid;
        document.getElementById('txtLedger').value = ledgername;
        document.getElementById('txt_ledgerCode').value = ledgerCode;
        document.getElementById('lbl_sno').value = subcategoryid;
        document.getElementById('btn_save').innerHTML = "Modify";
        $("#div_SubCategoryData").hide();
        $("#Sub_CategoryFillForm").show();
        $('#sub_Category_FillForms').hide();
    }
    function forclearall() {
        document.getElementById('txt_sapcode').value = "";
        document.getElementById('ddlcategory').selectedIndex = 0;
        document.getElementById('ddlstatus').selectedIndex = 0;
        document.getElementById('txtSubCategoryName').value = "";
        document.getElementById('txtLedger').value = "";
        document.getElementById('lbl_sno').value = "";
        document.getElementById('txt_ledgerCode').value = "";
        document.getElementById('txt_sub_cat_code').value = "";
        document.getElementById('btn_save').innerHTML = "Save";
        $("#lbl_code_error_msg").hide();
        $("#lbl_name_error_msg").hide();
    }
    
 </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<section class="content-header">
        <h1>
            Item Sub Category Master
        </h1>
   <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operation</a></li>
            <li><a href="#">Item Sub Category Master</a></li>
        </ol> 
  </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Item Sub Category Details
                </h3>
            </div>
            <div class="box-body">
             <div id="sub_Category_FillForms" class="input-group" style="padding-left:85%;">
                                <div class="input-group-addon">
                                <span class="glyphicon glyphicon-plus-sign" onclick="showdesign()"></span> <span onclick="showdesign()">Add Sub Category</span>
                          </div>
                          </div>

               <%-- <div id="sub_Category_FillForms" align="center">
                    <input id="btn_addSubCategory" type="button" name="submit" value='Add Sub Category' class="btn btn-primary" onclick="showdesign()" />
                </div>--%>
                <div id="div_SubCategoryData" style="padding-top:2px;">
                </div>
                <div id='Sub_CategoryFillForm' style="display: none;">
                   <table align="center" style="width: 46%;">
                        <tr>
                            <th>
                            </th>
                        </tr>
                        <tr>
                            <td style="height:40px; width:40%;">
                             <label>Category</label><span style="color: red;">*</span>
                            </td>
                            <td>
                            <select id="ddlcategory" class="form-control">
                                      <option selected disabled value="Select category">Select Category</option>    
                            </select>
                            </td>
                        </tr>
                        <tr>
                            <td style="height:40px;">
                            <label>Sub Category Name</label><span style="color: red;">*</span>
                            </td>
                            <td>
                                <input id="txtSubCategoryName" type="text" maxlength="45" class="form-control" name="vendorcode"
                                    placeholder="Enter Sub Category Name"/><label id="lbl_code_error_msg" class="errormessage">* Please Enter
                                        SubCategoryName</label>
                            </td>
                        </tr>
                        <tr>
                            <td style="height:40px;">
                                <label>Sub Category Code</label><span style="color: red;">*</span>
                            </td>
                            <td>
                                <input id="txt_sub_cat_code" type="text" class="form-control" name="sub_cat_code" placeholder="Enter Sub Category Code" onkeypress="return isNumber(event)" />
                            </td>
                        </tr>
                        <tr>
                            <td style="height:40px;">
                            <label>Ledger Code</label><span style="color: red;">*</span>
                            </td>
                            <td>
                                <input id="txt_ledgerCode" type="text" maxlength="45" class="form-control" name="vendorcode"
                                    placeholder="Enter Ledger Code"/><label id="Label2" class="errormessage">* Please Enter
                                        Ledger Code</label>
                            </td>
                        </tr>
                        <tr>
                            <td style="height:40px;">
                            <label>Ledger Name</label><span style="color: red;">*</span>
                            </td>
                            <td>
                                <input id="txtLedger" type="text" maxlength="45" class="form-control" name="vendorcode"
                                    placeholder="Enter Ledger Name"/><label id="Label1" class="errormessage">* Please Enter
                                        LedgerName</label>
                            </td>
                        </tr>
                       <tr>
                           <td style="height:40px;"><label>SAP CODE</label><span style="color: red;"></span></td>
                           <td>
                               <input id="txt_sapcode" type="text" maxlength="45" class="form-control" name="sapcode"
                                    placeholder="Enter SAP Code"/><label id="Label3" class="errormessage">* Please Enter
                                        SapCode</label>
                           </td>
                       </tr>
                      
                         <tr>
                             <td style="height:40px;">
                             <label>Select Status</label><span style="color: red;">*</span>     
                             </td>
                             <td>
                             <select ID="ddlstatus">
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
                              <%--<input id="btn_save" type="button" class="btn btn-primary" name="submit" value='save' onclick="saveSubcategoryDetails()" />
                               <input id='btn_close' type="button" class="btn btn-danger" name="Close" value='Close' onclick="canceldetails()" />--%>
                               <table>
                                   <tr>
                                    <td>
                                    <div class="input-group">
                                        <div class="input-group-addon">
                                        <span class="glyphicon glyphicon-ok" id="btn_save1" onclick="saveSubcategoryDetails()"></span> <span id="btn_save" onclick="saveSubcategoryDetails()">save</span>
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
