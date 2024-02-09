<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true" CodeFile="projectdetails.aspx.cs" Inherits="projectdetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    $(function () {
        get_projectinfo_detailes();
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
    function CallHandlerUsingJson(d, s, e) {
        d = JSON.stringify(d);
        d = encodeURIComponent(d);
        $.ajax({
            type: "GET",
            url: "FleetManagementHandler.axd?json=",
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            data: d,
            async: true,
            cache: true,
            success: s,
            error: e
        });
    }
    function canceldetails() {
        $("#div_CategoryData").show();
        $("#fillform").hide();
        $('#showlogs').show();
        $('#divbuttons').hide();
        forclearall();
        scrollTo(0, 0);
    }
    function show_CategoryDesign() {
        GetFixedrows();
        $("#div_CategoryData").hide();
        $("#fillform").show();
        $('#showlogs').hide();
        $('#divbuttons').show();

        
        scrollTo(0, 0);
    }
    function get_projectinfo_detailes() {
        var data = { 'op': 'get_projectinfo_detailes' };
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
        results += '<thead><tr class="trbgclrcls"><th scope="col" style="font-weight: bold;">Project Name</th><th scope="col" style="font-weight: bold;">Starting Date</th><th scope="col" style="font-weight: bold;">Execuition Days</th><th scope="col">Budjet</th><th scope="col">Description</th><th scope="col">Approved by</th></tr></thead></tbody>';
        var k = 1;
        var l = 0;
        var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
        for (var i = 0; i < msg.length; i++) {
            results += '<tr style="background-color:' + COLOR[l] + '">';
            results += '<td data-title="brandstatus" class="1"><span class="glyphicon glyphicon-list" style="color: cadetblue;"></span> <span id="1" class="1"> ' + msg[i].projectname + ' </span></td>';
            results += '<td data-title="brandstatus" class="4">' + msg[i].startingdate + '</td>';
            results += '<td data-title="brandstatus" class="2">' + msg[i].exicuationtime + '</td>';
            results += '<td data-title="brandstatus" class="2">' + msg[i].budjet + '</td>';
            results += '<td data-title="brandstatus" class="2">' + msg[i].description + '</td>';
            results += '<td data-title="brandstatus" class="2">' + msg[i].approvedby + '</td>';
            results += '<td style="display:none" data-title="brandstatus"><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls" onclick="getme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td>';
            results += '<td style="display:none" class="3"></td></tr>';
            l = l + 1;
            if (l == 4) {
                l = 0;
            }
        }
        results += '</table></div>';
        $("#div_CategoryData").html(results);
    }
   
    function forclearall() {
        document.getElementById('txt_projectname').value = "";
        document.getElementById('txtDescription').value = "";
        document.getElementById('txt_startdate').value = "";
        document.getElementById('ddl_approveby').value = "";
        document.getElementById('txt_remarks').value = "";
        document.getElementById('txt_exedays').value = "";
        document.getElementById('txt_budjet').value = "";
        $("#div_CategoryData").show();
        $("#fillform").hide();
        $('#showlogs').show();
        $('#divbuttons').hide();
        scrollTo(0, 0);
    }
    function GetFixedrows() {
        var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails_gst">';
        results += '<thead><tr><th scope="col">Sno</th><th scope="col">Items Into Be Needed</th><th scope="col">Description</th><th scope="col">Cost</th><th scope="col">Quantity</th><th scope="col"></th><th scope="col"></th></tr></thead></tbody>';
        for (var i = 1; i < 11; i++) {
            results += '<tr><td scope="row" class="1" style="text-align:center;width:40px;" id="txtsno" >' + i + '</td>';
            results += '<td ><input id="txtitem_details" type="text" class="codecls_gst"   placeholder= "Enter Item Details" style="width:100%;" /></td>';
            results += '<td ><input id="txtDescription" type="text" class="clsdesc_gst"  placeholder= "Enter Description"  style="width:100%;"/></td>';
            results += '<td ><input id="txt_cost" type="text" class="codecls_gst"  placeholder= "Enter Cost Details" style="width:100%;" /></td>';
            results += '<td ><input id="txt_qty" type="text" class="clsdesc_gst"  placeholder= "Enter Qty"  style="width:100%;"/></td>';
            results += '<td style="display:none"><input id="hdnproductsno" type="hidden" /></td>';
            results += '<td data-title="Minus"><span><img src="images/minus.png" onclick="removerow_product(this)" style="cursor:pointer"/></span></td>';
            results += '<td style="display:none;" class="4">' + i + '</td></tr>';
        }
        results += '</table></div>';
        $("#div_SectionData").html(results);
    }

    function save_edit_projectinfo_click() {
        var sno = document.getElementById('lblsno').value;
        var projectname = document.getElementById('txt_projectname').value;
        var description = document.getElementById('txtDescription').value;
        var startingdate = document.getElementById('txt_startdate').value;
        var approvedby = document.getElementById('ddl_approveby').value;
        var remarks = document.getElementById('txt_remarks').value;
        var exicuationtime = document.getElementById('txt_exedays').value;
        var budjet = document.getElementById('txt_budjet').value;
        var btnval = document.getElementById('btn_saveproject').innerHTML;
        var status = "P";
        if (projectname == "") {
            alert("Enter  Project Name");
            return false;
        }
        if (startingdate == "") {
            alert("Enter  Starting Date");
            return false;
        }
        if (approvedby == "") {
            alert("Select  Approved By");
            return false;
        }
        var project_array = [];
        $('#tabledetails_gst> tbody > tr').each(function () {
            var itemdetails = $(this).find('#txtitem_details').val();
            var description = $(this).find('#txtDescription').val();
            var qty = $(this).find('#txt_qty').val();
            var cost = $(this).find('#txt_cost').val();
            project_array.push({ 'itemdetails': itemdetails, 'description': description, 'qty': qty, 'cost': cost });
        });
        var Data = { 'op': 'save_edit_projectinfo_click', 'projectname': projectname, 'remarks': remarks, 'deescription': description, 'startingdate': startingdate, 'approvedby': approvedby, 'exicuationtime': exicuationtime, 'budjet': budjet, 'project_array': project_array, 'btnval': btnval };
        var s = function (msg) {
            if (msg) {
                alert(msg);
                forclearall();
                get_projectinfo_detailes();
            }
        }
        var e = function (x, h, e) {
        };
        CallHandlerUsingJson(Data, s, e);
    }

    var DataTable;
    var sub_sno = "";
    function insertrow() {
        DataTable = [];
        DataTable1 = [];
        var txtsno = 0;
        var itemdetails = "";
        var description = "";
        var cost = "";
        var qty = "";
        var rows = $("#tabledetails_gst tr:gt(0)");
        var rowsno = 1;
        $(rows).each(function (i, obj) {
            if ($(this).find('#txtitem_details').val() != "") {
                txtsno = rowsno;
                itemdetails = $(this).find('#txtitem_details').val();
                description = $(this).find('#txtDescription').val();
                cost = $(this).find('#txt_cost').val();
                qty = $(this).find('#txt_qty').val();
                hdnproductsno = $(this).find('#hdnproductsno').val();
                DataTable1.push({ Sno: txtsno, itemdetails: itemdetails, description: description, cost: cost, qty: qty });
                rowsno++;
            }
        });
        for (var i = 0; i < DataTable1.length; i++) {
            var code_check = DataTable1[i].itemdetails;
            if (code_check != "") {
                DataTable.push({ Sno: DataTable1[i].Sno, itemdetails: DataTable1[i].itemdetails,  description: DataTable1[i].description, cost: DataTable1[i].cost, qty: DataTable1[i].qty});
            }
        }
        itemdetails = "";
        description = "";
        hdnproductsno = 0;
        var Sno = parseInt(txtsno) + 1;
        DataTable.push({ Sno: Sno, itemdetails: itemdetails, description: description, cost: cost, qty: qty });
        var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails_gst">';
        results += '<thead><tr><th scope="col">Sno</th><th scope="col">Items Into Be Needed</th><th scope="col">Description</th><th scope="col">Cost</th><th scope="col">Quantity</th><th scope="col"></th><th scope="col"></th></tr></thead></tbody>';
        for (var i = 0; i < DataTable.length; i++) {
            results += '<tr><td scope="row" class="1" style="text-align:center;width:40px;" id="txtsno" >' + (i + 1) + '</td>';
            results += '<td ><input id="txtitem_details" type="text" class="codecls_gst" value="' + DataTable[i].itemdetails + '" placeholder= "Select Items Details" style="width:100%;" /></td>';
            results += '<td ><input id="txtDescription" type="text" class="clsdesc_gst" value="' + DataTable[i].description + '" placeholder= "Select Description"  style="width:100%;"/></td>';
            results += '<td ><input id="txt_cost" type="text" class="codecls_gst" value="' + DataTable[i].cost + '" placeholder= "Select Items Details" style="width:100%;" /></td>';
            results += '<td ><input id="txt_qty" type="text" class="clsdesc_gst" value="' + DataTable[i].qty + '" placeholder= "Select Description"  style="width:100%;"/></td>';
            results += '<td style="display:none"><input id="hdnproductsno" type="hidden" /></td>';
            results += '<td data-title="Minus"><span><img src="images/minus.png" onclick="removerow_product(this)" style="cursor:pointer"/></span></td>';
            results += '<td style="display:none;" class="4">' + (i + 1) + '</td></tr>';
        }
        results += '</table></div>';
        $("#div_SectionData").html(results);
    }

    function removerow_product(thisid) {
        $(thisid).parents('tr').remove();
        emptytable4 = [];
        $('#tabledetails_gst> tbody > tr').each(function () {
            var productname = $(this).find('#txtDescription').val();
            emptytable4.push(productname);
        });
        emptytable3 = [];
        $('#tabledetails_gst> tbody > tr').each(function () {
            var sku = $(this).find('#txtitem_details').val();
            emptytable4.push(sku);
        });
    }
    var replaceHtmlEntites = (function () {
        return function (s) {
            return (s.replace(translate_re, function (match, entity) {
                return translate[entity];
            }));
        }
    })();
 </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<section class="content-header">
        <h1>
            Project Details
        </h1>
   <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operation</a></li>
            <li><a href="#">Project Details</a></li>
        </ol> 
</section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Project Details
                </h3>
            </div>
            <div class="box-body">
              <div id="showlogs" class="input-group" style="padding-left:84%;">
                                <div class="input-group-addon">
                                <span class="glyphicon glyphicon-plus-sign" onclick="show_projectDesign()"></span> <span onclick="show_CategoryDesign()">Add Project Info</span>
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
                            <label>Project Name</label><span style="color: red;">*</span>
                            </td>
                            <td>
                                <input id="txt_projectname" type="text" maxlength="45" class="form-control" name="vendorcode"
                                    placeholder="Enter Project Name"/>
                            </td>
                        </tr>
                        <tr>
                            <td style="height:40px;">
                           <label>Description</label>
                           </td>
                            <td>
                             <textarea id="txtDescription" rows="4" cols="10" name="PDescription" class="form-control"
                                    placeholder="Enter Description">
                              </textarea>
                            </td>
                      </tr>
                        <tr>
                            <td style="height:40px;">
                                <label>Starting Date</label><span style="color: red;">*</span>
                            </td>
                            <td>
                                <input type="date" class="form-control" id="txt_startdate" name="Date" />
                            </td>
                        </tr> 
                        <tr>
                            <td style="height:40px;"><label>Approved By</label><%--<span style="color: red;">*</span>--%></td>
                            <td>
                                <select ID="ddl_approveby" class="form-control" >
                            <option value="Sri Rajesh Kumar Chavda">Sri Rajesh Kumar Chavda</option>
                            <option value="Apurva">Apurva</option>
                            </select>
                            </td>
                        </tr>
                        

                      <tr>
                            <td style="height:40px;">
                           <label>Remarks</label>
                           </td>
                            <td>
                             <textarea id="txt_remarks" rows="4" cols="10" name="Premarks" class="form-control"
                                    placeholder="Enter Remarks">
                              </textarea>
                            </td>
                      </tr>
                      <tr>
                            <td style="height:40px; width:35%;">
                            <label>Execution Time(in Days)</label><span style="color: red;">*</span>
                            </td>
                            <td>
                                <input id="txt_exedays" type="text" maxlength="45" onkeypress="return isNumber(event)" class="form-control" name="time" placeholder="Enter Execution Time"/>
                            </td>
                        </tr>
                        <tr>
                            <td style="height:40px; width:35%;">
                            <label>Budjet</label><span style="color: red;">*</span>
                            </td>
                            <td>
                                <input id="txt_budjet" type="text" maxlength="45"  class="form-control" name="time" placeholder="Enter Execution Time"/>
                            </td>
                        </tr>
                        <tr>
                        <label id="lblsno" style="display:none;"></label>
                        </tr>
                 </table>

                  <div class="box box-info">
                        <div class="box-header with-border">
                            <h3 class="box-title">
                                <i style="padding-right: 5px;" class="fa fa-list"></i>Project Sub Details
                            </h3>
                        </div>
                        <div class="box-body">
                            <div id="div_SectionData">
                            </div>
                        </div>
                    </div>
                    <table id="newrow">
                        <tr>
                            <td>
                                <div class="input-group" style="padding-right: 16px;">
                                    <div class="input-group-addon">
                                        <span class="glyphicon glyphicon-plus-sign" onclick="insertrow()"></span> <span onclick="insertrow()">ADD NEW ROW</span>
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </table>
              </div>
              <div id="divbuttons" style="display: none;">
              <table align="center">
                        <tr>
                            <td>
                                <table>
                                   <tr>
                                    <td>
                                    <div class="input-group">
                                        <div class="input-group-addon">
                                        <span class="glyphicon glyphicon-ok" id="btn_RaisePO1" onclick="save_edit_projectinfo_click()"></span> <span id="btn_saveproject" onclick="save_edit_projectinfo_click()">Raise</span>
                                  </div>
                                  </div>
                                    </td>
                                    <td style="width:10px;"></td>
                                    <td>
                                     <div class="input-group">
                                        <div class="input-group-close">
                                        <span class="glyphicon glyphicon-remove" id='close_vehmaster1' onclick="canceldetails();"></span> <span id='close' onclick="canceldetails();">Close</span>
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

