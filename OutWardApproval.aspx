<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true" CodeFile="OutWardApproval.aspx.cs" Inherits="OutWardApproval" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
           
            $('#close_vehmaster').click(function () {
                $('#OutwardApproval_FillForm').css('display', 'none');
                $('#div_OutwardApproval').show();
                forclearall();
            });
            getalloutward();
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
        function myFunction() {
            if (event.keyCode == 46 || event.keyCode == 110 || event.keyCode == 8 || event.keyCode == 9 || event.keyCode == 27 || event.keyCode == 13 || event.keyCode == 190 ||
            // Allow: Ctrl+A
            (event.keyCode == 65 && event.ctrlKey === true) ||
            // Allow: home, end, left, right
            (event.keyCode >= 35 && event.keyCode <= 39)) {
                // let it happen, don't do anything
                return;
            }
            else {
                // Ensure that it is a number and stop the keypress
                if (event.shiftKey || (event.keyCode < 48 || event.keyCode > 57) && (event.keyCode < 96 || event.keyCode > 105)) {
                    event.preventDefault();
                }
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
        var DataTable;
        var ProductTable = [];
        function barcode() {
            var txtbarcode = document.getElementById('txtSku').value;
            productarray;
            DummyTable1;
            DataTable = [];
            var rows = $("#tabledetails tr:gt(0)");
            var txtsno = 0;
            var rowsno = 1;
            $(rows).each(function (i, obj) {
                if ($(this).find('#txtProductname').val() != "") {
                    txtsno = rowsno;
                    productname = $(this).find('#txtProductname').val();
                    PerUnitRs = $(this).find('#txt_perunitrs').val();
                    moniterqty = $(this).find('#txt_AvilableStores').val();
                    Quantity = $(this).find('#txt_quantity').val();
                    TotalCost = $(this).find('#txtTotal').val();
                    sisno = $(this).find('#subsno').val();
                    hdnproductsno = $(this).find('#hdnproductsno').val();
                    DataTable.push({ Sno: txtsno, productname: productname, PerUnitRs: PerUnitRs, moniterqty: moniterqty, Quantity: Quantity, TotalCost: TotalCost, hdnproductsno: hdnproductsno, sisno: sisno });
                    rowsno++;
                }
            });
            var productname = 0;
            var PerUnitRs = 0;
            var Quantity = 0;
            var TotalCost = 0;
            var hdnproductsno = 0;
            var moniterqty = 0;
            var sisno = 0;
            var Sno = parseInt(txtsno) + 1;
            if (txtbarcode != "") {
                if (ProductTable.indexOf(txtbarcode) == -1) {
                    for (var i = 0; i < productarray.length; i++) {
                        if (txtbarcode == productarray[i].sku) {
                            productname = productarray[i].productname;
                            hdnproductsno = productarray[i].productid;
                            PerUnitRs = productarray[i].price;
                            moniterqty = productarray[i].moniterqty;
                            DataTable.push({ Sno: Sno, productname: productname, PerUnitRs: PerUnitRs, Quantity: Quantity, TotalCost: TotalCost, moniterqty: moniterqty, hdnproductsno: hdnproductsno, sisno: sisno });
                            ProductTable.push(txtbarcode);
                        }
                    }
                }
                else {
                    alert("Product Name already added");
                    document.getElementById('txtSku').value = "";
                    document.getElementById('txtProductcode').value = "";
                    return false;
                }
            }
            var productname = document.getElementById('txtProductcode').value;
            if (productname != "") {
                if (ProductTable.indexOf(productname) == -1) {
                    for (var i = 0; i < productarray.length; i++) {
                        if (productname == productarray[i].productname) {
                            hdnproductsno = productarray[i].productid;
                            productname = productarray[i].productname;
                            PerUnitRs = productarray[i].price;
                            moniterqty = productarray[i].moniterqty;
                            DataTable.push({ Sno: Sno, productname: productname, PerUnitRs: PerUnitRs, Quantity: Quantity, TotalCost: TotalCost, moniterqty: moniterqty, hdnproductsno: hdnproductsno, sisno: sisno });
                            ProductTable.push(productname);
                        }
                    }
                }
                else {
                    alert("Product Name already added");
                    document.getElementById('txtSku').value = "";
                    document.getElementById('txtProductcode').value = "";
                    return false;
                }
            }
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Per Unit Rs</th><th scope="col">Avail Stores</th><th scope="col">Quantity</th><th scope="col">Total Cost</th><th scope="col"></th></tr></thead></tbody>';
            var j = 1;
            for (var i = 0; i < DataTable.length; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + j + '</td>';
                results += '<td ><input id="txtProductname"  readonly class="productcls" style="width:90px;" value="' + DataTable[i].productname + '"/></td>';
                results += '<td style="display:none;" class="2">' + DataTable[i].productname + '</td>';
                results += '<td ><input id="txt_perunitrs" type="text" class="price" readonly onkeypress="return isFloat(event)" style="width:90px;" value="' + DataTable[i].PerUnitRs + '"/></td>';
                results += '<td ><input id="txt_AvilableStores" type="text" class="quantity" readonly name="quantity" onkeypress="return isFloat(event)" style="width:90px;" value="' + DataTable[i].moniterqty + '"/></td>';
                results += '<td ><input id="txt_quantity" type="text" class="quantity" name="quantity" onkeypress="return isFloat(event)" style="width:90px;" onchange="qtychage(this);" value="' + DataTable[i].Quantity + '"/></td>';
                results += '<td ><input id="txtTotal" type="text" class="Total" readonly style="width:90px;" value="' + DataTable[i].TotalCost + '"/></td>';
                results += '<td style="display:none"><input id="hdnproductsno" type="hidden" value="' + DataTable[i].hdnproductsno + '"/></td>';
                results += '<th style="display:none"><input  id="subsno" type="hidden" name="subsno" value="' + DataTable[i].sisno + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input>';
                results += '<td data-title="Minus"><input id="btn_poplate" type="button"  onclick="removerow(this)" name="Edit" class="btn btn-primary" value="Remove" /></td>';
                results += '<td style="display:none" class="4">' + i + '</td></tr>';
                j++;
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
            document.getElementById('txtSku').value = "";
            document.getElementById('txtProductcode').value = "";
        }


        function indentnumber(txt_indentnumber) {
            var sno = document.getElementById('txt_indentnumber').value;
            var data = { 'op': 'get_Indent_Details_Outward', 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {

                        fillproductdetails(msg);

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

        var DataTable;
        function removerow1(thisid) {
            $(thisid).parents('tr').remove();
        }

        function getalloutward() {
            var data = { 'op': 'get_Pending_outward_Data' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {

                        fill_foreground_tbl(msg);
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
        var inward_subdetails = [];
        function fill_foreground_tbl(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr class="trbgclrcls"><th scope="col">Issue Date</th><th scope="col">Name</th><th scope="col">Ref No</th><th scope="col">Issue No</th><th scope="col"></th></tr></thead></tbody>';
            inward_subdetails = msg[0].SubOutward;
            var inward = msg[0].OutwardDetails;
            var k = 1;
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            for (var i = 0; i < inward.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">';//<td><input id="btn_poplate" type="button"  onclick="update(this)" name="Approval" class="btn btn-primary" value="Approval" /></td>
                results += '<td data-title="inwarddate" class="3">' + inward[i].inwarddate + '</td>';
                results += '<td data-title="name" class="7" >  ' + inward[i].name + '</td>';
                results += '<td data-title="remarks" class="10" style="display:none;">' + inward[i].remarks + '</td>';
                results += '<td data-title="pono" class="13" style="display:none;">' + inward[i].modeofoutward + '</td>';
                results += '<td data-title="pono" class="16" style="display:none;">' + inward[i].indentno + '</td>';
                results += '<td data-title="sno" class="11" >' + inward[i].sno + '</td>';
                results += '<td data-title="issueno" class="17">' + inward[i].issueno + '</td>';
                results += '<td data-title="brandstatus"><button type="button" title="Click Here To Approve!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 apprvcls"  onclick="update(this)"><span class="glyphicon glyphicon-thumbs-up" style="top: 0px !important;"></span></button></td>';
                results += '<td data-title="hiddensupplyid" class="14" style="display:none;">' + inward[i].hiddenid + '</td></tr>';

                l = l + 1;
                if (l == 4) {
                    l = 0;
                }

            }
            results += '</table></div>';
            $("#div_OutwardApproval").html(results);
        }
        var sno = 0;
        function update(thisid) {
            scrollTo(0, 0);
            $('#OutwardApproval_FillForm').css('display', 'block');
            $('#div_OutwardApproval').hide();
            var inwarddate = $(thisid).parent().parent().children('.3').html();
            var name = $(thisid).parent().parent().children('.7').html();
            var remarks = $(thisid).parent().parent().children('.10').html();
            var sno = $(thisid).parent().parent().children('.11').html();
            var modeofoutward = $(thisid).parent().parent().children('.13').html();
            var indentno = $(thisid).parent().parent().children('.16').html();
            var hiddenid = $(thisid).parent().parent().children('.14').html();
            var name = $(thisid).parent().parent().children('.7').html();
            document.getElementById('txt_inwarddate').innerHTML = inwarddate;
            document.getElementById('ddlname').innerHTML = name;
            document.getElementById('txt_remarks').innerHTML = remarks;
            document.getElementById('txt_indentnumber').innerHTML = indentno;
            document.getElementById('lbl_sno').innerHTML = sno;
            document.getElementById('slct_mdeofinwrd').innerHTML = modeofoutward;
            document.getElementById('btn_RaisePO').innerHTML = "Approve";
            var table = document.getElementById("tabledetails");
            var results = '<div  style="overflow:auto;"><table id="tabledetails" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Per Unit Rs</th><th scope="col">Quantity</th><th scope="col">Total Cost</th><th scope="col"></th></tr></thead></tbody>';
            var k = 1;
            for (var i = 0; i < inward_subdetails.length; i++) {
                if (sno == inward_subdetails[i].inword_refno) {
                    results += '<tr><td data-title="Sno" class="1">' + k + '</td>';
                    results += '<th data-title="From"><span id="spn_Productname">' + inward_subdetails[i].productname + '</span><input id="txtProductname" class="productcls" readonly name="productname" value="' + inward_subdetails[i].productname + '" style="display:none;width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<th data-title="From"><span id="spn_perunitrs">' + inward_subdetails[i].PerUnitRs + '</span><input id="txt_perunitrs"readonly class="price" onkeypress="return isFloat(event)" name="PerUnitRs" readonly value="' + inward_subdetails[i].PerUnitRs + '" style="display:none;width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<th data-title="From"><span id="spn_quantity">' + inward_subdetails[i].quantity + '</span><input id="txt_quantity" readonly class="quantity"  name="quantity" onkeypress="return isFloat(event)"  value="' + inward_subdetails[i].quantity + '" style="display:none;width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<th data-title="From"><span id="spn_Total">' + inward_subdetails[i].totalcost + '</span><input id="txtTotal" class="Total" readonly name="TotalCost" value="' + inward_subdetails[i].totalcost + '" style="display:none;width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<th style="display:none"><input class="6" id="hdnproductsno" readonly type="hidden" name="hdnproductsno" value="' + inward_subdetails[i].hdnproductsno + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input>';
                    results += '<th style="display:none"><input class="7" id="subsno" type="hidden" name="subsno" value="' + inward_subdetails[i].sisno + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input>';
                    results += '<td><span onclick="removerow1(this)"><img src="images/minus.png" style="cursor:pointer"/></span></td>';
                    results += '<td data-title="From" style="display:none"><input class="7" id="txt_sub_sno" name="txt_sub_sno" value="' + inward_subdetails[i].sno + '"style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td></tr>';
                    ProductTable.push(inward_subdetails[i].sku);
                    k++;
                }
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
        }
        function approval_pending_Outward_click() {
            var outwardsno = document.getElementById('lbl_sno').innerHTML;
            var status = document.getElementById('ddlstatus').value;
            if (status == "") {
                alert("select status");
            }

            var fillitems = [];
            $('#tabledetails> tbody > tr').each(function () {
                var Quantity = $(this).find('#txt_quantity').val();
                var hdnproductsno = $(this).find('#hdnproductsno').val();
                if (hdnproductsno == "" || hdnproductsno == "0") {
                }
                else {
                    fillitems.push({ 'Quantity': Quantity,  'hdnproductsno': hdnproductsno
                    });
                }
            });
            if (fillitems.length == 0) {
                alert("Please Select Product Names");
                return false;
            }
            var Data = { 'op': 'approval_pending_Outward_click', 'outwardsno': outwardsno, 'status': status, 'fillitems': fillitems };
            var s = function (msg) {
                if (msg) {
                    alert(msg);
                    $('#OutwardApproval_FillForm').css('display', 'none');
                    $('#div_OutwardApproval').show();
                    getalloutward();
                    forclearall();
                }
            }
            var e = function (x, h, e) {
            };
            CallHandlerUsingJson(Data, s, e);
        }
        function forclearall() {
            document.getElementById('txt_inwarddate').value = "";
            document.getElementById('txt_remarks').value = "";
            document.getElementById('lbl_sno').value = "";
            document.getElementById('btn_RaisePO').innerHTML = "Save";
            document.getElementById('slct_mdeofinwrd').selectedIndex = 0;
            var empty = [];
            var results = '<div  style="overflow:auto;"><table id="tabledetails" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Per Unit Rs</th><th scope="col">Quantity</th><th scope="col">Total Cost</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < empty.length; i++) {
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
            scrollTo(0, 0);
        }
 </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Product Issue Approval <small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operations</a></li>
            <li><a href="#">Product Issue Approval</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Product Issue Approval Details
                </h3>
            </div>
            <div class="box-body">
                <div id="div_OutwardApproval">
                </div>
                <div id='OutwardApproval_FillForm' style="display: none;">
                    <table align="center">
                        <tr>
                            <td>
                                <label>
                                    Issue Date</label><span style="color: red;">*</span>
                            </td>
                            <td style="height: 40px;">
                                <div class="input-group date" style="width:100%;">
                                  <div class="input-group-addon cal">
                                    <i class="fa fa-calendar"></i>
                                  </div>
                                  <span id="txt_inwarddate" class="form-control" type="date" />
                                </div>
                            </td>
                            <td style="width: 5px"></td>
                            <td>
                                <label>
                                    Mode of Issue</label>
                            </td>
                            <td style="height: 40px;width: 30%;">
                                <span id="slct_mdeofinwrd" class="form-control" type="text" />
                            </td>
                        </tr>
                        <tr>
                        <td>
                                <label>
                                   Section Name</label><span style="color: red;">*</span>
                            </td>
                             <td style="height: 40px;">
                                <span id="ddlname" class="form-control" type="text" />
                            </td>
                           <td style="width: 5px"></td>
                            <td>
                                <label>
                                    Indent Number</label>
                            </td>
                            <td>
                                <span id="txt_indentnumber" class="form-control" type="text"/>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Remarks</label>
                            </td>
                            <td colspan="5">
                                <span id="txt_remarks" class="form-control" type="text" rows="4" cols="45" "></span>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Status</label>
                            </td>
                            <td style="height: 40px;">
                                <select id="ddlstatus" class="form-control">
                                    <option value="A">Approval</option>
                                    <option value="C">Cancel</option>
                                </select>
                            </td>
                        </tr>
                         <tr>
                        <td>
                            <label id="lbl_sno" style="display: none;">
                            </label>
                        </td>
                        <td style="height: 40px;">
                            <input id="txtsupid" type="hidden" class="form-control" name="hiddensupplyid" />
                        </td>
                         </tr>
                        
                    </table>
                      <div class="box box-info">
                        <div class="box-body">
                    
                    <br />
                    <br />
                    <div id="div_SectionData">
                    </div>
                    </div>
                    </div>
                    <div id="">
                    </div>
                    <table align="center">
                        <tr>
                            <td>
                                <table>
                                   <tr>
                                    <td>
                                    <div class="input-group">
                                        <div class="input-group-addon">
                                        <span class="glyphicon glyphicon-ok" id="btn_RaisePO1" onclick="approval_pending_Outward_click()"></span> <span id="btn_RaisePO" onclick="approval_pending_Outward_click()">Approval</span>
                                  </div>
                                  </div>
                                    </td>
                                    <td style="width:10px;"></td>
                                    <td>
                                     <div class="input-group">
                                        <div class="input-group-close">
                                        <span class="glyphicon glyphicon-remove" id='close_vehmaster1'></span> <span id='close_vehmaster'>Close</span>
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
