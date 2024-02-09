<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true" CodeFile="StoresReturnApproval.aspx.cs" Inherits="StoresReturnApproval" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            $('#add_Inward').click(function () {
                $('#vehmaster_fillform').css('display', 'block');
                $('#showlogs').css('display', 'none');
                $('#div_inwardtable').hide();
                forclearall();
                get_productcode();
                ProductTable = [];

                var today = new Date();
                var dd = today.getDate();
                var mm = today.getMonth() + 1; //January is 0!
                var yyyy = today.getFullYear();
                if (dd < 10) {
                    dd = '0' + dd
                }
                if (mm < 10) {
                    mm = '0' + mm
                }
                var hrs = today.getHours();
                var mnts = today.getMinutes();
                $('#txt_inwarddate').val(yyyy + '-' + mm + '-' + dd);
                scrollTo(0, 0);
            });

            $('#close_vehmaster').click(function () {
                $('#vehmaster_fillform').css('display', 'none');
                $('#showlogs').css('display', 'block');
                $('#div_inwardtable').show();
                forclearall();
            });
            get_Stores_details();
            scrollTo(0, 0);

            var today = new Date();
            var dd = today.getDate();
            var mm = today.getMonth() + 1; //January is 0!
            var yyyy = today.getFullYear();
            if (dd < 10) {
                dd = '0' + dd
            }
            if (mm < 10) {
                mm = '0' + mm
            }
            var hrs = today.getHours();
            var mnts = today.getMinutes();
            $('#txt_inwarddate').val(yyyy + '-' + mm + '-' + dd);


        });

        function isFloat(evt) {
            var charCode = (event.which) ? event.which : event.keyCode;
            if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
                alert('Please enter only no or float value');
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
        //var DataTable;
        //var ProductTable = [];
        //function barcode() {
        //    var txtbarcode = document.getElementById('txtSku').value;
        //    productarray;
        //    DummyTable1;
        //    DataTable = [];
        //    var rows = $("#tabledetails tr:gt(0)");
        //    var txtsno = 0;
        //    var rowsno = 1;
        //    $(rows).each(function (i, obj) {
        //        if ($(this).find('#txtProductname').val() != "") {
        //            txtsno = rowsno;
        //            productname = $(this).find('#txtProductname').val();
        //            PerUnitRs = $(this).find('#txt_perunitrs').val();
        //            Quantity = $(this).find('#txt_quantity').val();
        //            sisno = $(this).find('#subsno').val();
        //            hdnproductsno = $(this).find('#hdnproductsno').val();
        //            hdnproductcode = $(this).find('#hdnproductcode').val();
        //            DataTable.push({ Sno: txtsno, productname: productname, PerUnitRs: PerUnitRs, Quantity: Quantity, hdnproductsno: hdnproductsno, sku: hdnproductcode, sisno: sisno });
        //            rowsno++;
        //        }
        //    });
        //    var productname = 0;
        //    var PerUnitRs = 0;
        //    var Quantity = 0;
        //    var hdnproductsno = 0;
        //    var hdnproductcode = 0;
        //    var Sno = parseInt(txtsno) + 1;
        //    if (txtbarcode != "") {
        //        if (ProductTable.indexOf(txtbarcode) == -1) {
        //            for (var i = 0; i < productarray.length; i++) {
        //                if (txtbarcode == productarray[i].sku) {
        //                    productname = productarray[i].productname;
        //                    hdnproductsno = productarray[i].productid;
        //                    PerUnitRs = productarray[i].price;
        //                    DataTable.push({ Sno: Sno, productname: productname, PerUnitRs: PerUnitRs, Quantity: Quantity, hdnproductsno: hdnproductsno, sku: productarray[i].sku });
        //                    ProductTable.push(txtbarcode);
        //                }
        //            }
        //        }
        //        else {
        //            alert("Product Name already added");
        //            document.getElementById('txtSku').value = "";
        //            document.getElementById('txtProductcode').value = "";
        //            return false;
        //        }
        //    }
        //    var productname = document.getElementById('txtProductcode').value;
        //    if (productname != "") {
        //        if (ProductTable.indexOf(productname) == -1) {
        //            for (var i = 0; i < productarray.length; i++) {
        //                if (productname == productarray[i].productname) {
        //                    hdnproductsno = productarray[i].productid;
        //                    productname = productarray[i].productname;
        //                    PerUnitRs = productarray[i].price;
        //                    DataTable.push({ Sno: Sno, productname: productname, PerUnitRs: PerUnitRs, Quantity: Quantity, hdnproductsno: hdnproductsno, sku: productarray[i].sku });
        //                    ProductTable.push(productname);
        //                }
        //            }
        //        }
        //        else {
        //            alert("Product Name already added");
        //            document.getElementById('txtSku').value = "";
        //            document.getElementById('txtProductcode').value = "";
        //            return false;
        //        }
        //    }
        //    var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
        //    results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Per Unit Rs</th><th scope="col">Quantity</th><th scope="col"></th></tr></thead></tbody>';
        //    var j = 1;
        //    for (var i = 0; i < DataTable.length; i++) {
        //        //if (txtbarcode == productarray[i].productcode) {
        //        results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + j + '</td>';
        //        results += '<td ><input id="txtProductname" readonly  class="productcls" style="width:90px;" value="' + DataTable[i].productname + '"/></td>';
        //        results += '<td style="display:none;" class="2">' + DataTable[i].productname + '</td>';
        //        results += '<td ><input id="txt_perunitrs" type="text" class="price"  onkeypress="return isFloat(event)" style="width:90px;" value="' + DataTable[i].PerUnitRs + '"/></td>';
        //        results += '<td ><input id="txt_quantity" type="text" class="quantity"  onkeypress="return isFloat(event)" style="width:90px;" value="' + DataTable[i].Quantity + '"/></td>';
        //        results += '<td ><input id="hdnproductsno" type="hidden" value="' + DataTable[i].hdnproductsno + '"/><input id="hdnproductcode" type="hidden" value="' + DataTable[i].sku + '"/></td>';
        //        results += '<td data-title="Minus"><input id="btn_poplate" type="button"  onclick="removerow(this)" name="Edit" class="btn btn-primary" value="Remove" /></td>';
        //        results += '<td style="display:none" class="4">' + i + '</td></tr>';
        //        j++;
        //        //}

        //    }
        //    results += '</table></div>';
        //    $("#div_SectionData").html(results);
        //    document.getElementById('txtSku').value = "";
        //    document.getElementById('txtProductcode').value = "";
        //}


        $(document).click(function () {
            $('#tabledetails').on('change', '.price', calTotal)
                  .on('change', '.quantity', calTotal);
            function calTotal() {
                var $row = $(this).closest('tr'),
            price = $row.find('.price').val(),
            quantity = $row.find('.quantity').val(),
            total = price * quantity;
                // change the value in total
                $row.find('.Total').val(total)
            }

        });

        var DummyTable1 = [];
        function removerow(thisid) {
            DataTable = [];
            ProductTable = [];
            var rows = $("#tabledetails tr:gt(0)");
            $(rows).each(function (i, obj) {
                if ($(this).find('#txtProductname').val() != "") {
                    txtsno = rowsno;
                    var productname = $(this).find('#txtProductname').val();
                    var PerUnitRs = $(this).find('#txt_perunitrs').val();
                    var Quantity = $(this).find('#txt_quantity').val();
                    var sisno = $(this).find('#subsno').val();
                    var hdnproductsno = $(this).find('#hdnproductsno').val();
                    var hdnproductcode = $(this).find('#hdnproductcode').val();
                    DataTable.push({ Sno: txtsno, productname: productname, PerUnitRs: PerUnitRs, Quantity: Quantity, hdnproductsno: hdnproductsno, sku: hdnproductcode });
                }
            });
            var product_name = $(thisid).parent().parent().children('.2').html();
            var txtsno = 0;
            var rowsno = 1;
            DummyTable1 = [];
            for (var i = 0; i < DataTable.length; i++) {
                if (product_name == DataTable[i].productname) {
                }
                else {
                    txtsno = rowsno;
                    var productname = DataTable[i].productname;
                    var PerUnitRs = DataTable[i].PerUnitRs;
                    var Quantity = DataTable[i].Quantity;
                    var sisno = "0";
                    var hdnproductsno = DataTable[i].hdnproductsno;
                    var hdnproductcode = DataTable[i].sku;
                    DummyTable1.push({ Sno: txtsno, productname: productname, PerUnitRs: PerUnitRs, Quantity: Quantity, hdnproductsno: hdnproductsno, sku: hdnproductcode });
                    ProductTable.push(hdnproductcode);
                }
            }
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col" >Product Name</th><th scope="col">Per Unit Rs</th><th scope="col">Quantity</th><th scope="col"></th></tr></thead></tbody>';
            var j = 1;
            for (var i = 0; i < DummyTable1.length; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + j + '</td>';
                results += '<td ><input id="txtProductname" readonly   class="productcls" style="width:90px;" value="' + DummyTable1[i].productname + '"/></td>';
                results += '<td style="display:none;" class="2">' + DummyTable1[i].productname + '</td>';
                results += '<td ><input id="txt_perunitrs" type="text" class="price" readonly onkeypress="return isFloat(event)" style="width:90px;" value="' + DummyTable1[i].PerUnitRs + '"/></td>';
                results += '<td ><input id="txt_quantity" type="text" class="quantity"  onkeypress="return isFloat(event)" style="width:90px;" value="' + DummyTable1[i].Quantity + '"/></td>';
                results += '<td style="display:none"><input id="hdnproductsno" type="hidden" value="' + DataTable[i].hdnproductsno + '"/><input id="hdnproductcode" type="hidden" value="' + DataTable[i].sku + '"/></td>';
                results += '<td data-title="Minus"><input id="btn_poplate" type="button"  onclick="removerow(this)" name="Edit" class="btn btn-primary" value="Remove" /></td>';
                results += '<td style="display:none" class="4">' + i + '</td></tr>';
                j++;
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
        }
        var replaceHtmlEntites = (function () {
            return function (s) {
                return (s.replace(translate_re, function (match, entity) {
                    return translate[entity];
                }));
            }
        })();

        function removerow1(thisid) {
            $(thisid).parents('tr').remove();

        }
        function approval_pending_StoresReturn_click() {
            var streturnsno = document.getElementById('lbl_sno').innerHTML;
            var status = document.getElementById('ddlstatus').value;
            if (status == "") {
                alert("select status");
                return false;
            }
            var fillitems = [];
            $('#tabledetails> tbody > tr').each(function () {
                var Quantity = $(this).find('#txt_quantity').val();
                var hdnproductsno = $(this).find('#hdnproductsno').val();
                if (hdnproductsno == "" || hdnproductsno == "0") {
                }
                else {

                    fillitems.push({'Quantity': Quantity, 'hdnproductsno': hdnproductsno
                    });
                }

            });
            if (fillitems.length == 0) {
                alert("Please Select Product Names");
                return false;
            }
            var Data = { 'op': 'approval_pending_StoresReturn_click', 'streturnsno': streturnsno, 'status': status, 'fillitems': fillitems };
            var s = function (msg) {
                if (msg) {
                    alert(msg);
                    $('#vehmaster_fillform').css('display', 'none');
                    $('#div_inwardtable').show();
                    get_Stores_details();
                    forclearall();
                }
            }
            var e = function (x, h, e) {
            };
            CallHandlerUsingJson(Data, s, e);
        }
        function get_Stores_details() {
            var data = { 'op': 'get_Stores_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillstores(msg);
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
        var stores_subdetails = [];
        function fillstores(msg) {
            var results = '<div><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr role="row" class="trbgclrcls"><th scope="col">Name</th><th scope="col">Remarks</th><th scope="col"></th></tr></thead></tbody>';
            stores_subdetails = msg[0].SubStoresReturn;
            var storesdetails = msg[0].StoresReturn;

            var k = 1;
            var l = 0;
            //var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];

            for (var i = 0; i < storesdetails.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">';//<td><input id="btn_poplate" type="button"  onclick="update(this)" name="Edit" class="btn btn-primary" value="Approval" /></td>
                results += '<td data-title="name" class="1" >' + storesdetails[i].name + '</td>';
                results += '<td data-title="remarks" class="2">' + storesdetails[i].remarks + '</td>';
                results += '<td data-title="remarks" class="3" style="display:none;">' + storesdetails[i].doe + '</td>';
                results += '<td data-title="brandstatus"><button type="button" title="Click Here To Approve!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 apprvcls"  onclick="update(this)"><span class="glyphicon glyphicon-thumbs-up" style="top: 0px !important;"></span></button></td>';
                results += '<td data-title="sno" class="4" style="display:none;">' + storesdetails[i].sno + '</td></tr>';


                l = l + 1;
                if (l == 4) {
                    l = 0;
                }


            }
            results += '</table></div>';
            $("#div_inwardtable").html(results);
        }
        function update(thisid) {
            scrollTo(0, 0);
            $('#vehmaster_fillform').css('display', 'block');
            $('#showlogs').css('display', 'none');
            $('#div_inwardtable').hide();
            get_productcode();
            removerow(thisid);
            //barcode();
            var name = $(thisid).parent().parent().children('.1').html();
            var remaks = $(thisid).parent().parent().children('.2').html();
            var doe = $(thisid).parent().parent().children('.3').html();
            var sno = $(thisid).parent().parent().children('.4').html();

            document.getElementById('txt_inwarddate').innerHTML = doe;
            document.getElementById('txt_Name').innerHTML = name;
            document.getElementById('txt_remarks').innerHTML = remaks;
            document.getElementById('lbl_sno').innerHTML = sno;
            document.getElementById('btn_RaisePO').innerHTML = "Modify";

            var table = document.getElementById("tabledetails");
            var results = '<div><table ID="tabledetails" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" >';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Per Unit Rs</th><th scope="col">Quantity</th><th scope="col"></th></tr></thead></tbody>';
            var k = 1;
            for (var i = 0; i < stores_subdetails.length; i++) {
                if (sno == stores_subdetails[i].sstore_refno) {
                    results += '<tr><td data-title="Sno" class="1">' + k + '</td>';
                    results += '<td data-title="From"><span id="spn_Productname">' + stores_subdetails[i].productname + '</span><input id="txtProductname" readonly class="productcls"  name="productname" value="' + stores_subdetails[i].productname + '" style="display:none;width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<td data-title="From"><span id="spn_perunitrs">' + stores_subdetails[i].PerUnitRs + '</span><input class="price" id="txt_perunitrs" name="PerUnitRs" readonly value="' + stores_subdetails[i].PerUnitRs + '" style="display:none;width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<td data-title="From"><span id="spn_quantity">' + stores_subdetails[i].quantity + '</span><input class="quantity" id="txt_quantity" readonly onkeypress="myFunction()" name="Quantity" value="' + stores_subdetails[i].quantity + '" style="display:none;width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<td style="display:none"><input class="6" id="hdnproductsno" type="hidden" name="hdnproductsno" value="' + stores_subdetails[i].hdnproductsno + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<td style="display:none"><input class="7" id="subsno" type="hidden" name="subsno" value="' + stores_subdetails[i].sisno + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    //results += '<td data-title="Minus"><input id="btn_poplate" type="button"  onclick="removerow1(this)" name="Edit" class="btn btn-primary" value="Remove" /></td>';
                    results += '<td><span onclick="removerow1(this)"><img src="images/minus.png" style="cursor:pointer"/></span></td>';
                    results += '<th data-title="From" style="display:none"><input class="7" id="txt_sub_sno" name="txt_sub_sno" value="' + stores_subdetails[i].sno + '"style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td></tr>';
                    ProductTable.push(stores_subdetails[i].sku);
                    k++;
                }
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
        }

        var productarray = [];
        function get_productcode() {
            var data = { 'op': 'get_branchwiseproduct_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        //filldata(msg);

                        productarray = msg;
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
        //var compiledList = [];
        //function filldata(msg) {
        //    var compiledList = [];
        //    for (var i = 0; i < msg.length; i++) {
        //        var productname = msg[i].productname;
        //        compiledList.push(productname);
        //    }
        //    $('#txtProductcode').autocomplete({
        //        source: compiledList,
        //        change: barcode,
        //        autoFocus: true
        //    });
        //}
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
        function forclearall() {
            document.getElementById('txt_inwarddate').value = "";
            document.getElementById('txt_remarks').value = "";
            document.getElementById('btn_RaisePO').innerHTML = "Save";
            document.getElementById('txt_Name').value = "";
            var empty = [];
            var results = '<div  style="overflow:auto;"><table id="tabledetails" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Per Unit Rs</th><th scope="col">Quantity</th><th scope="col"></th></tr></thead></tbody>';
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
            Stores Return <small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operations</a></li>
            <li><a href="#">Stores Return</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Stores Return Approval
                </h3>
            </div>
            <div class="box-body">
                <%--<div id="showlogs" align="center">
                    <input id="add_Inward" type="button" name="submit" value='StoresReturnApproval' class="btn btn-primary" />
                </div>--%>
                <div id="div_inwardtable">
                </div>
                <div id='vehmaster_fillform' style="display: none;">
                    <table align="center">
                        <tr>
                            <td>
                                <label>
                                    Date</label>
                            </td>
                            <td style="height: 40px;">
                                <div class="input-group date" style="width:100%;">
                                  <div class="input-group-addon cal">
                                    <i class="fa fa-calendar"></i>
                                  </div>
                                  <span id="txt_inwarddate" type="date" class="form-control" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Name</label>
                            </td>
                            <td style="height: 40px;">
                                <span style="font-weight:100" id="txt_Name" class="form-control" type="text" placeholder="Enter Name" onKeyPress="return ValidateAlpha(event);" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Remarks</label>
                            </td>
                            <td colspan="4">
                                <span id="txt_remarks" class="form-control" type="text" rows="3" cols="35" placeholder="Enter Remarks"></textarea>
                            </td>
                            <td>
                                <label id="lbl_sno" style="display: none;">
                                </label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Status</label><span style="color: red;">*</span>
                            </td>
                            <td style="height: 40px;">
                                <select id="ddlstatus" class="form-control">
                                    <option value="A">Approval</option>
                                    <option value="C">Cancel</option>
                                </select>
                            </td>
                        </tr>
                        <td style="height: 40px;">
                            <input id="txtsupid" type="hidden" class="form-control" name="hiddensupplyid" />
                        </td>
                    </table>
                    <div class="box box-info">
                        <%--<div class="box-header with-border">
                            <h3 class="box-title">
                                <i style="padding-right: 5px;" class="fa fa-list"></i>Select Product(s)
                            </h3>
                        </div>--%>
                        <div class="box-body">
                    <%--<div>
                        <table id="skutable" align="left">
                            <tr>
                                <td>
                                    <label>
                                        Product Code &nbsp&nbsp&nbsp</label>
                                </td>
                                <td style="height: 40px;">
                                    <input id="txtSku" type="text" class="form-control" name="sku" onchange="barcode();"
                                        placeholder="Scan Here" />
                                </td>
                                <td style="width: 6px;">
                                </td>
                              
                                <td>
                                    <label>
                                        OR</label>
                                </td>
                                  <td style="width: 6px;">
                                </td>
                                <td>
                                    <input id="txtProductcode" type="text" class="form-control" name="productcode" placeholder="Select Product Description"/>
                                </td>
                            </tr>
                        </table>
                    </div>--%>
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
                                <%--<input type="button" class="btn btn-primary" id="btn_RaisePO" value="APPROVAL" onclick="approval_pending_StoresReturn_click();" />
                                <input type="button" class="btn btn-danger" id="close_vehmaster" value="Close" />--%>
                                <table>
                                   <tr>
                                    <td>
                                    <div class="input-group">
                                        <div class="input-group-addon">
                                        <span class="glyphicon glyphicon-ok" id="btn_RaisePO1" onclick="approval_pending_StoresReturn_click()"></span> <span id="btn_RaisePO" onclick="approval_pending_StoresReturn_click()">APPROVAL</span>
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


