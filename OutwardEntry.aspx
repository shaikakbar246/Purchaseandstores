<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true"
    CodeFile="OutwardEntry.aspx.cs" Inherits="OutwardEntry" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            $('#btn_addOutward').click(function () {
                $('#Outward_FillForm').css('display', 'block');
                $('#Outward_Showlogs').css('display', 'none');
                $('#div_OutwardValue').hide();
                $('#skutable').css('display', 'block');
                $('#lblproductcode').css('display', 'block');
                get_productcode();
                myFunction();
                forclearall();
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
                $('#txt_invoicedate').val(yyyy + '-' + mm + '-' + dd);
                $('#txt_inwarddate').val(yyyy + '-' + mm + '-' + dd);
                scrollTo(0, 0);
            });
            $('#close_vehmaster').click(function () {
                $('#Outward_FillForm').css('display', 'none');
                $('#Outward_Showlogs').css('display', 'block');
                $('#div_OutwardValue').show();
                forclearall();
                ProductTable = [];
            });
            get_OutwardData();
            get_section_details();
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
            $('#txt_invoicedate').val(yyyy + '-' + mm + '-' + dd);
            $('#txt_inwarddate').val(yyyy + '-' + mm + '-' + dd);
            scrollTo(0, 0);
            emptytable = [];
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
            get_productcode();
            DummyTable1;
            DataTable = [];
            var rows = $("#tabledetails tr:gt(0)");
            var txtsno = 0;
            var rowsno = 1;
            $(rows).each(function (i, obj) {
                if ($(this).find('#txtProductname').val() != "") {
                    txtsno = rowsno;
                    productname = $(this).find('#txtProductname').val();
                    uim = $(this).find('#ddlUim').val();
                    PerUnitRs = $(this).find('#txt_perunitrs').val();
                    moniterqty = $(this).find('#txt_AvilableStores').val();
                    Quantity = $(this).find('#txt_quantity').val();
                    TotalCost = $(this).find('#spn_total').text();
                    sisno = $(this).find('#subsno').val();
                    hdnproductsno = $(this).find('#hdnproductsno').val();
                    DataTable.push({ Sno: txtsno, productname: productname, PerUnitRs: PerUnitRs, moniterqty: moniterqty, Quantity: Quantity, TotalCost: TotalCost, hdnproductsno: hdnproductsno, sisno: sisno, uim: uim });
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
            var uim = 0;

            var Sno = parseInt(txtsno) + 1;
            if (txtbarcode != "") {
                if (ProductTable.indexOf(txtbarcode) == -1) {
                    for (var i = 0; i < productarray.length; i++) {
                        if (txtbarcode == productarray[i].sku) {
                            productname = productarray[i].productname;
                            hdnproductsno = productarray[i].productid;
                            uim = productarray[i].uim;
                            PerUnitRs = productarray[i].price;
                            moniterqty = productarray[i].moniterqty;
                            DataTable.push({ Sno: Sno, productname: productname, uim: uim, PerUnitRs: PerUnitRs, Quantity: Quantity, TotalCost: TotalCost, moniterqty: moniterqty, hdnproductsno: hdnproductsno, sisno: sisno });
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
                            uim = productarray[i].uim;
                            PerUnitRs = productarray[i].price;
                            moniterqty = productarray[i].moniterqty;
                            DataTable.push({ Sno: Sno, productname: productname, uim: uim, PerUnitRs: PerUnitRs, Quantity: Quantity, TotalCost: TotalCost, moniterqty: moniterqty, hdnproductsno: hdnproductsno, sisno: sisno });
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
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">UOM</th><th scope="col">Per Unit Rs</th><th scope="col">Avail Stores</th><th scope="col">Quantity</th><th scope="col">Total Cost</th><th scope="col"></th></tr></thead></tbody>';
            var j = 1;
            for (var i = 0; i < DataTable.length; i++) {
            
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + j + '</td>';
                results += '<td class="tdcls"><span id="spn_Productname">' + DataTable[i].productname + '<input id="txtProductname"   class="productcls" style="width:90px;display:none" value="' + DataTable[i].productname + '"/></td>';
                results += '<td style="display:none;" class="2">' + DataTable[i].productname + '</td>';
                results += '<td class="tdcls"><span id="spn_uim">' + DataTable[i].uim + '</span><input id="ddlUim" type="text" class="uomcls"  onkeypress="return isFloat(event)" style="width:90px;display:none" value="' + DataTable[i].uim + '"/></td>';
                results += '<td class="tdcls"><input id="txt_perunitrs" type="text" class="price"   onkeypress="return isFloat(event)" style="width:90px;" value="' + DataTable[i].PerUnitRs + '"/></td>';
                results += '<td class="tdcls"><span id="spn_AvilableStores">' + DataTable[i].moniterqty + '</span><input id="txt_AvilableStores" type="text" class="avilablestores" readonly name="quantity" onkeypress="return isFloat(event)" style="width:90px;display:none" value="' + DataTable[i].moniterqty + '"/></td>';
                results += '<td ><input id="txt_quantity" type="text" class="quantity" name="quantity" onkeypress="return isFloat(event)" style="width:90px;" onchange="qtychage(this);" value="' + DataTable[i].Quantity + '"/></td>';
                results += '<td class="tdcls"><span id="spn_total">' + DataTable[i].TotalCost + '</span><input id="txtTotal" type="text" class="Total" readonly style="width:90px;display:none;" value="' + DataTable[i].TotalCost + '"/></td>';
                results += '<th style="display:none"><input id="hdnproductsno" type="hidden" value="' + DataTable[i].hdnproductsno + '"/></th>';
                results += '<th style="display:none"><input  id="subsno" type="hidden" name="subsno" value="' + DataTable[i].sisno + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input>';
                results += '<td><span onclick="removerow1(this)"><img src="images/minus.png" style="cursor:pointer"/></span></td>';
                results += '<td style="display:none" class="4">' + i + '</td></tr>';
                j++;
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
            document.getElementById('txtSku').value = "";
            document.getElementById('txtProductcode').value = "";
        }
        var avail_stores;
        var qty;
        $(document).click(function () {
            $('#tabledetails').on('change', '.price', calTotal)
                .on('blur', '.avilablestores', calTotal)
                  .on('change', '.quantity', calTotal);
            function calTotal() {
                var $row = $(this).closest('tr'),
                price = $row.find('.price').val(),
                avail_st = $row.find('.avilablestores').val(),
                avail_stores = parseFloat(avail_st);
                if (avail_stores <= 0) {
                    $row.find('.quantity').val('');
                    $row.find('.quantity').prop('disabled', true);
                    total = 0;
                }
                else {
                    $row.find('.quantity').prop('disabled', false);
                }
                quantity = $row.find('.quantity').val(),
                qty = parseFloat(quantity);
                if (qty > avail_stores) {
                    $row.find('.quantity').val('');
                    total = 0;
                }
                else {
                    total = price * quantity;
                }
                $row.find('.Total').val(total);
                $row.find('#spn_total').text(total);
                clstotalval();
            }
        });

        function clstotalval() {
            var totaamount = 0;
            $('.Total').each(function (i, obj) {
                var totlclass = $(this).val();

                if (totlclass == "" || totlclass == "0") {
                }
                else {
                    totaamount += parseFloat(totlclass);
                }
            });

            var grandtotal = parseFloat(totaamount);
            var grandtotal1 = grandtotal.toFixed(2);
            var diff = 0;
            if (grandtotal > grandtotal1) {
                diff = grandtotal - grandtotal1;
            }
            else {
                diff = grandtotal1 - grandtotal;
            }
            document.getElementById('spn_totalissueamt').innerHTML = grandtotal;
            document.getElementById('spn_roundoff').innerHTML = diff.toFixed(2);
            document.getElementById('spn_issueamt').innerHTML = grandtotal1;
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

        function fillproductdetails(msg) {
            var SubIndentdetails = msg[0].SubIndent;
            var IndentDetails = msg[0].Indent;
            var sno = document.getElementById('txt_indentnumber').value;
            var results = '<div  style="overflow:auto;"><table ID="tabledetails" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" >';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Per Unit Rs</th><th scope="col">Quantity</th><th scope="col">Total Cost</th><th scope="col"></th></tr></thead></tbody>';
            var p = 1;
            for (var i = 0; i < IndentDetails.length; i++) {
                if (sno == IndentDetails[i].sno) {
                    for (var i = 0; i < SubIndentdetails.length; i++) {

                        results += '<tr><td data-title="Sno" class="1">' + p + '</td>';
                        results += '<td class="tdcls"><input id="txtProductname" readonly class="productcls"  name="productname" value="' + SubIndentdetails[i].productname + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                        results += '<td class="tdcls"><input class="price" id="txt_perunitrs" name="PerUnitRs" onkeypress="return isFloat(event)"  value="' + SubIndentdetails[i].price + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                        results += '<td ><input class="quantity"  id="txt_quantity" onkeypress="return isFloat(event)" name="Quantity" value="' + SubIndentdetails[i].qty + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                        results += '<td class="tdcls"><span id="spn_total"></span><input class="Total" id="txtTotal" onkeypress="return isFloat(event)" name="Quantity" value="' + SubIndentdetails[i].qty * SubIndentdetails[i].price + '" style="width:100%;display:none; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                        results += '<td style="display:none"><input class="5" id="hdnproductsno" type="hidden" name="hdnproductsno" value="' + SubIndentdetails[i].hdnproductsno + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                        results += '<td><span onclick="removerow1(this)"><img src="images/minus.png" style="cursor:pointer"/></span></td>';
                        results += '<td style="display:none" class="6">' + i + '</td></tr>';
                        p++;
                    }
                }
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
        }

        function qtychage(thisid) {
            var rows = $("#tabledetails tr:gt(0)");
            $(rows).each(function (i, obj) {
                if ($(this).find('#txtProductname').val() != "") {
                    var productname = $(this).find('#txtProductname').val();
                    var moniterqty = $(this).find('#txt_AvilableStores').val();
                    var Quantity = $(this).find('#txt_quantity').val();
                    var qty = parseFloat(Quantity);
                    var avlqty = parseFloat(moniterqty);
                    if (qty > avlqty) {
                        alert("enter quantity is more then the available quantity");
                    }
                }
            });
        }

        var DummyTable1 = [];
        function removerow(thisid) {
            DataTable = [];
            ProductTable = [];
            var rows = $("#tabledetails tr:gt(0)");
            $(rows).each(function (i, obj) {
                if ($(this).find('#txtProductname').val() != "") {
                    txtsno = rowsno;
                    var productname = $(this).find('#txtProductname').val();
                    var uim = $(this).find('#ddlUim').val();
                    var PerUnitRs = $(this).find('#txt_perunitrs').val();
                    var moniterqty = $(this).find('#txt_AvilableStores').val();
                    var Quantity = $(this).find('#txt_quantity').val();
                    var TotalCost = $(this).find('#spn_total').text();
                    var sisno = $(this).find('#subsno').val();
                    var hdnproductsno = $(this).find('#hdnproductsno').val();
                    var hdnproductcode = $(this).find('#hdnproductcode').val();
                    DataTable.push({ Sno: txtsno, productname: productname, PerUnitRs: PerUnitRs, moniterqty: moniterqty, Quantity: Quantity, TotalCost: TotalCost, hdnproductsno: hdnproductsno, sku: hdnproductcode, uim: uim });
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
                    var uim = DataTable[i].uim;
                    var moniterqty = DataTable[i].moniterqty;
                    var Quantity = DataTable[i].Quantity;
                    var TotalCost = DataTable[i].TotalCost;
                    var sisno = "0";
                    var hdnproductsno = DataTable[i].hdnproductsno;
                    var hdnproductcode = DataTable[i].sku;
                    DummyTable1.push({ Sno: txtsno, productname: productname, PerUnitRs: PerUnitRs, moniterqty: moniterqty, Quantity: Quantity, TotalCost: TotalCost, hdnproductsno: hdnproductsno, sku: hdnproductcode, uim: uim });
                    ProductTable.push(hdnproductcode);
                }
            }

            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col" >Product Name</th><th scope="col">UOM</th><th scope="col">Per Unit Rs</th><th scope="col">Avail Stores</th><th scope="col">Quantity</th><th scope="col">Total Cost</th><th scope="col"></th></tr></thead></tbody>';
            var j = 1;
            for (var i = 0; i < DummyTable1.length; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + j + '</td>';
                results += '<td class="tdcls"><span id="spn_Productname">' + DummyTable1[i].productname + '</span><input id="txtProductname" readonly   class="productcls" style="width:90px;display:none" value="' + DummyTable1[i].productname + '"/></td>';
                results += '<td style="display:none;" class="2">' + DummyTable1[i].productname + '</td>';
                results += '<td class="tdcls"><span id="spn_uim">' + DummyTable1[i].uim + '</span><input id="ddlUim" type="text" class="uomcls" style="width:90px;display:none" value="' + DummyTable1[i].uim + '"/></td>';
                results += '<td class="tdcls"><span id="spn_perunitrs">' + DummyTable1[i].PerUnitRs + '</span><input id="txt_perunitrs" type="text"  class="price" onkeypress="return isFloat(event)"  style="width:90px;display:none" value="' + DummyTable1[i].PerUnitRs + '"/></td>';
                results += '<td class="tdcls"><span id="spn_AvilableStores">' + DummyTable1[i].moniterqty + '</span><input id="txt_AvilableStores" type="text" class="avilablestores" readonly onkeypress="return isFloat(event)" style="width:90px;display:none" value="' + DummyTable1[i].moniterqty + '"/></td>';
                results += '<td ><input id="txt_quantity" type="text" class="quantity"   style="width:90px;" onchange="qtychage(this);" value="' + DummyTable1[i].Quantity + '"/></td>';
                results += '<td class="tdcls"><span id="spn_total">' + DummyTable1[i].TotalCost + '</span><input id="txtTotal" type="text" readonly class="Total"  style="width:90px;display:none;" value="' + DummyTable1[i].TotalCost + '"/></td>';
                results += '<td style="display:none"><input id="hdnproductsno" type="hidden" value="' + DummyTable1[i].hdnproductsno + '"/><input id="hdnproductcode" type="hidden" value="' + DataTable[i].sku + '"/></td>';
                results += '<td ><input id="btn_poplate" type="button"  onclick="removerow(this)" name="Edit" class="btn btn-primary" value="Remove" /></td>';
                results += '<td style="display:none" class="4">' + i + '</td></tr>';
                j++;
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
        }
        var DataTable;
        function removerow1(thisid) {
            $(thisid).parents('tr').remove();
        }
        function save_edit_Outward() {
            var inwarddate = document.getElementById('txt_inwarddate').value;
            var sno = document.getElementById('lbl_sno').value;
            var remarks = document.getElementById('txt_remarks').value;
            var modeofoutward = document.getElementById('slct_mdeofinwrd').value;
            var hiddensupplyid = document.getElementById('txtsupid').value;
            var btnval = document.getElementById('btn_RaisePO').innerHTML;
            var indentno = document.getElementById('txt_indentnumber').value;
            var ddlname = document.getElementById('ddlname').value;
            if (inwarddate == "") {
                alert("Enter Outwarddate");
                return false;
            }

            if (ddlname == "" || ddlname == "Select Name") {
                alert("Select Section Name");
                return false;
            }
            var fillitems = [];
            $('#tabledetails> tbody > tr').each(function () {
                var txtsno = $(this).find('#txtSno').text();
                var productname = $(this).find('#txtProductname').val();
                var PerUnitRs = $(this).find('#txt_perunitrs').val();
                var Quantity = $(this).find('#txt_quantity').val();
                var TotalCost = $(this).find('#spn_total').text();
                var sisno = $(this).find('#subsno').val();
                var moniterqty = $(this).find('#txt_AvilableStores').val();
                var sno = $(this).find('#txt_sub_sno').val();
                var hdnproductsno = $(this).find('#hdnproductsno').val();
                if (hdnproductsno == "" || hdnproductsno == "0") {
                }
                else {
                    fillitems.push({ 'txtsno': txtsno, 'productname': productname, 'PerUnitRs': PerUnitRs, 'Quantity': Quantity, 'moniterqty': moniterqty, 'TotalCost': TotalCost, 'hdnproductsno': hdnproductsno, 'sisno': sisno
                    });
                }
            });
            if (fillitems.length == 0) {
                alert("Please Select Product Names");
                return false;
            }
            var Data = { 'op': 'save_edit_Outward', 'modeofoutward': modeofoutward, 'name': ddlname, 'inwarddate': inwarddate, 'remarks': remarks, 'indentno': indentno, 'sno': sno, 'btnval': btnval, 'fillitems': fillitems };
            var s = function (msg) {
                if (msg) {
                    if (msg == "Contact Apurva Sir") {
                        alert(msg);
                        return false;
                    }
                    else {
                        if (msg.length > 0) {
                            alert(msg);
                            forclearall();
                            get_OutwardData();
                            $('#Outward_FillForm').css('display', 'none');
                            $('#Outward_Showlogs').css('display', 'block');
                            $('#div_OutwardValue').show();
                        }
                    }
                }
            }
            var e = function (x, h, e) {
            };
            CallHandlerUsingJson(Data, s, e);
        }
        function get_OutwardData() {
            var data = { 'op': 'get_outward_Data' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fill_Outward_Data(msg);
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
        var outward_subdetails = [];
        function fill_Outward_Data(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr class="trbgclrcls"><th scope="col">Issue Date</th><th scope="col">Name</th><th scope="col">Issue No</th><th scope="col"></th><th scope="col"></th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            outward_subdetails = msg[0].SubOutward;
            var outward = msg[0].OutwardDetails;
            for (var i = 0; i < outward.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">';//<td><input id="btn_poplate" type="button"  onclick="update(this)" name="Edit" class="btn btn-primary" value="Edit" /></td>
                results += '<td data-title="inwarddate" class="3">' + outward[i].inwarddate + '</td>';
                results += '<td data-title="name" class="7" >' + outward[i].name + '</td>';
                results += '<td data-title="remarks" class="10" style="display:none;">' + outward[i].remarks + '</td>';
                results += '<td data-title="pono" class="13" style="display:none;">' + outward[i].modeofoutward + '</td>';
                results += '<td data-title="pono" class="16" style="display:none;">' + outward[i].indentno + '</td>';
                results += '<td data-title="sno" class="17" >' + outward[i].issueno + '</td>';
                results += '<td data-title="sno" class="11" style="display:none;" >' + outward[i].sno + '</td>';
                results += '<td data-title="brandstatus"><button type="button" title="Click Here To Print!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 printcls" onclick="printoutward(this)"><span class="glyphicon glyphicon-print" style="top: 0px !important;"></span></button></td>';
                results += '<td data-title="brandstatus"><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls" onclick="update(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td>';
                results += '<td data-title="hiddensupplyid" class="14" style="display:none;">' + outward[i].hiddenid + '</td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }

            }
            results += '</table></div>';
            $("#div_OutwardValue").html(results);
        }
        var sno = 0;
        function update(thisid) {
            scrollTo(0, 0);
            get_productcode();
            $('#Outward_FillForm').css('display', 'block');
            $('#Outward_Showlogs').css('display', 'none');
            $('#div_OutwardValue').hide();
            var inwarddate2 = $(thisid).parent().parent().children('.3').html();
            var remarks = $(thisid).parent().parent().children('.10').html();
            var sno = $(thisid).parent().parent().children('.11').html();
            var modeofoutward = $(thisid).parent().parent().children('.13').html();
            var indentno = $(thisid).parent().parent().children('.16').html();
            var hiddenid = $(thisid).parent().parent().children('.14').html();
            var name = $(thisid).parent().parent().children('.7').html();

            var inwarddate1 = inwarddate2.split('-');
            var inwarddate = inwarddate1[2] + '-' + inwarddate1[1] + '-' + inwarddate1[0];

            document.getElementById('txt_inwarddate').value = inwarddate;
            document.getElementById('txt_section_name').value = name;
            document.getElementById('ddlname').value = hiddenid;
            document.getElementById('txt_remarks').value = remarks;
            document.getElementById('txt_indentnumber').value = indentno;
            document.getElementById('lbl_sno').value = sno;
            document.getElementById('slct_mdeofinwrd').value = modeofoutward;
            document.getElementById('btn_RaisePO').innerHTML = "Modify";
            var table = document.getElementById("tabledetails");
            var results = '<div  style="overflow:auto;"><table id="tabledetails" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">UOM</th><th scope="col">Per Unit Rs</th><th scope="col">Avail Stores</th><th scope="col">Quantity</th><th scope="col">Total Cost</th><th scope="col"></th></tr></thead></tbody>';
            var k = 1;
            for (var i = 0; i < outward_subdetails.length; i++) {
                if (sno == outward_subdetails[i].inword_refno) {
                    results += '<tr><td data-title="Sno" class="1">' + k + '</td>';
                    results += '<td class="tdcls"><span id="spn_Productname">' + outward_subdetails[i].productname + '</span><input id="txtProductname" class="productcls"  name="productname" value="' + outward_subdetails[i].productname + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;display:none"></input></td>';
                    results += '<td class="tdcls"><span id="spn_uim">' + outward_subdetails[i].uim + '</span><input type="text" id="ddlUim" class="uomcls" name="uom"   value="' + outward_subdetails[i].uim + '"  style="width:100%; font-size:12px;padding: 0px 5px;height:30px;display:none"></input></td>';
                    results += '<td class="tdcls"><span id="spn_perunitrs">' + outward_subdetails[i].PerUnitRs + '</span><input id="txt_perunitrs" class="price" onkeypress="return isFloat(event)" name="PerUnitRs"  value="' + outward_subdetails[i].PerUnitRs + '" style="width:100%;display:none; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';//<span id="spn_perunitrs">' + outward_subdetails[i].PerUnitRs + '</span>
                    results += '<td class="tdcls"><span id="spn_AvilableStores">' + outward_subdetails[i].moniterqty + '</span><input id="txt_AvilableStores" type="text" class="avilablestores" readonly onkeypress="return isFloat(event)" style="width:90px;display:none" value="' + outward_subdetails[i].moniterqty + '"/></td>';
                    results += '<td data-title="From"><input id="txt_quantity" class="quantity"  name="quantity" onkeypress="return isFloat(event)"  value="' + outward_subdetails[i].quantity + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<td class="tdcls"><span id="spn_total">' + outward_subdetails[i].totalcost + '</span><input id="txtTotal" class="Total" readonly name="TotalCost" value="' + outward_subdetails[i].totalcost + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;display:none;"></input></td>';
                    results += '<td style="display:none"><input class="6" id="hdnproductsno" type="hidden" name="hdnproductsno" value="' + outward_subdetails[i].hdnproductsno + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<td style="display:none"><input class="7" id="subsno" type="hidden" name="subsno" value="' + outward_subdetails[i].sisno + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<td><span onclick="removerow1(this)"><img src="images/minus.png" style="cursor:pointer"/></span></td>';
                    results += '<th data-title="From" style="display:none"><input class="7" id="txt_sub_sno" name="txt_sub_sno" value="' + outward_subdetails[i].sno + '"style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td></tr>';
                    ProductTable.push(outward_subdetails[i].productname);
                    k++;
                }
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
            clstotalval();
        }

        function printoutward(thisid) {
            var sno = $(thisid).parent().parent().children('.11').html();
            var data = { 'op': 'get_outward_print', 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    window.open("OutwardReport.aspx", "_self");
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        var productarray = []; //var productarray1 = [];
        function get_productcode() {
            var data = { 'op': 'get_productissue_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        filldata(msg);
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
        var compiledList = [];
        function filldata(msg) {
            var compiledList = [];
            for (var i = 0; i < msg.length; i++) {
                var productname = msg[i].productname;
                compiledList.push(productname);
            }
            $('#txtProductcode').autocomplete({
                source: compiledList,
                change: barcode,
                autoFocus: true
            });
        }
        function forclearall() {
            scrollTo(0, 0);
            document.getElementById('txt_inwarddate').value = "";
            document.getElementById('txt_remarks').value = "";
            document.getElementById('lbl_sno').value = "";
            document.getElementById('txtSku').value = "";
            document.getElementById('txt_inward_no').value = "";
            document.getElementById('btn_RaisePO').innerHTML = "Save";
            document.getElementById('txt_section_name').value = "";
            document.getElementById('ddlname').value = "";
            document.getElementById('slct_mdeofinwrd').selectedIndex = 0;
            var empty = [];
            var results = '<div  style="overflow:auto;"><table id="tabledetails" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Per Unit Rs</th><th scope="col">Quantity</th><th scope="col">Total Cost</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < empty.length; i++) {
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
        }

        var section_list = [];
        function get_section_details() {
            var data = { 'op': 'get_section_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillsections(msg);
                        section_list = msg;
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
        function fillsections(msg) {           
            var compiledList = [];
            for (var i = 0; i < msg.length; i++) {
                var name = msg[i].sectionname;
                compiledList.push(name);
            }

            $('#txt_section_name').autocomplete({
                source: compiledList,
                change: test1,
                autoFocus: true
            });
        }

        var emptytable = [];
        function test1() {
            var name = document.getElementById('txt_section_name').value;
            var checkflag = true;
            for (var i = 0; i < section_list.length; i++) {
                if (name == section_list[i].sectionname) {
                    document.getElementById('ddlname').value = section_list[i].SectionId;
                    emptytable.push(name);
                }
            }
        }

        function inwardnumber()
        {
            var inward_no = document.getElementById('txt_inward_no').value;
            if (inward_no != "") {
                var data = { 'op': 'get_Inward_Details_Outward', 'inward_no': inward_no };
                var s = function (msg) {
                    if (msg) {
                        if (msg.length > 0) {
                            fillinwardproductdetails(msg);

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
        }

        function fillinwardproductdetails(msg)
        {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">UOM</th><th scope="col">Per Unit Rs</th><th scope="col">Avail Stores</th><th scope="col">Quantity</th><th scope="col">Total Cost</th><th scope="col"></th></tr></thead></tbody>';
            var j = 1;
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + j + '</td>';
                results += '<td class="tdcls"><span id="spn_Productname">' + msg[i].productname + '<input id="txtProductname"   class="productcls" style="width:90px;display:none" value="' + msg[i].productname + '"/></td>';
                results += '<td style="display:none;" class="2">' + msg[i].productname + '</td>';
                results += '<td class="tdcls"><span id="spn_uim">' + msg[i].uim + '</span><input id="ddlUim" type="text" class="uomcls"  onkeypress="return isFloat(event)" style="width:90px;display:none" value="' + msg[i].uim + '"/></td>';
                results += '<td class="tdcls"><span id="spn_perunitrs">' + msg[i].PerUnitRs + '</span><input id="txt_perunitrs" type="text" class="price"   onkeypress="return isFloat(event)" style="width:90px;display:none" value="' + msg[i].PerUnitRs + '"/></td>';
                results += '<td class="tdcls"><span id="spn_AvilableStores">' + msg[i].quantity + '</span><input id="txt_AvilableStores" type="text" class="avilablestores" readonly value="' + msg[i].quantity + '" name="quantity" onkeypress="return isFloat(event)" style="width:90px;display:none" value="' + msg[i].moniterqty + '"/></td>';
                results += '<td ><input id="txt_quantity" type="text" class="quantity" placeholder="Enter Quantity" name="quantity" onkeypress="return isFloat(event)" style="width:90px;" onchange="qtychage(this);" /></td>';
                results += '<td class="tdcls"><span id="spn_total"></span><input id="txtTotal" type="text" class="Total" readonly style="width:90px;display:none" /></td>';
                results += '<td style="display:none"><input id="hdnproductsno" type="hidden" value="' + msg[i].productid + '"/></td>';
                results += '<th style="display:none"><input  id="subsno" type="hidden" name="subsno" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input>';
                results += '<td><span onclick="removerow1(this)"><img src="images/minus.png" style="cursor:pointer"/></span></td>';
                results += '<td style="display:none" class="4">' + i + '</td></tr>';
                j++;
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
        }

        

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Product Issue <small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operations</a></li>
            <li><a href="#">Product Issue</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Product Issue Details
                </h3>
            </div>
            <div class="box-body">
                <div id="Outward_Showlogs" align="center">
                    <div class="input-group" style="padding-left:90%">
                        <div class="input-group-addon">
                            <span class="glyphicon glyphicon-plus-sign"></span> <span id="btn_addOutward">Add Issue</span>
                        </div>
                    </div>
                </div>
                <div id="div_OutwardValue" style="padding-top:2px;">
                </div>
                <div id='Outward_FillForm' style="display: none;">
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
                              <input id="txt_inwarddate" class="form-control" type="date" />
                            </div>
                            </td>
                            <td style="width:5px"></td>
                            <td>
                                <label>
                                    Mode of Issue</label>
                            </td>
                            <td style="height: 40px;">
                                <select id="slct_mdeofinwrd" class="form-control">
                                    <option value="Select Mode of Issue" disabled selected>Select Mode of Issue</option>
                                    <option value="Cash">Cash</option>
                                    <option value="Credit">Credit</option>
                                    <option value="Warranty">Warranty</option>
                                    <option value="Transported">Transported</option>
                                    <option value="AuditCorrrection">AuditCorrrection</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                        <td>
                                <label>
                                   Section Name</label><span style="color: red;">*</span>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_section_name" class="form-control" type="text" placeholder="Enter Section Name" />
                                <input id="ddlname" class="form-control" type="text" style="display:none" />
                            </td>
                            <td style="width:5px"></td>
                            <td>
                                <label>
                                    Indent Number</label>
                            </td>
                            <td>
                                <input id="txt_indentnumber" class="form-control" type="text" placeholder="Enter Indent Number" onchange="indentnumber(this);"/>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>Inward No</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_inward_no" class="form-control" type="text" placeholder="Enter Inward Number" onchange="inwardnumber();" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Remarks</label>
                            </td>
                            <td colspan="4">
                                <textarea id="txt_remarks" class="form-control" type="text" rows="4" cols="45" placeholder="Enter Remarks"></textarea>
                            </td>
                        </tr>
                        <td>
                            <label id="lbl_sno" style="display: none;">
                            </label>
                        </td>
                        <td style="height: 40px;">
                            <input id="txtsupid" type="hidden" class="form-control" name="hiddensupplyid" />
                        </td>
                    </table>
                      <div class="box box-info">
                        <div class="box-header with-border">
                            <h3 class="box-title">
                                <i style="padding-right: 5px;" class="fa fa-list"></i>Select Product(s)
                            </h3>
                        </div>
                        <div class="box-body">
                    <div>
                        <table id="skutable" align="left">
                            <tr>
                                <td>
                                    <label id="lblproductcode">
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
                                    <input id="txtProductcode" type="text" class="productcls" name="productcode" placeholder="Select Product Description"/>
                                </td>
                                <td style="width: 10px">
                            </td>
                            <td>
                                <i class="fa fa-search" aria-hidden="true">Search</i>
                            </td>
                            </tr>
                        </table>
                    </div>
                    <br />
                    <br />
                    <div id="div_SectionData">
                    </div>
                    </div>
                    </div>
                    <div>
                        <table align="center">
                        <tr>
                            <td>
                                <label>
                                    Issue Amount</label>
                            </td>
                            <td>
                                <span id="spn_totalissueamt" style="width: 500px; color: Red; font-weight: bold; font-size: 25px;"></span>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>Round off Difference Amount</label>
                            </td>
                            <td>
                                <span id="spn_roundoff" style="width: 500px; color: Red; font-weight: bold; font-size: 25px;"></span>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>Final Issue Amount</label>
                            </td>
                            <td>
                                <span id="spn_issueamt" style="width: 500px; color: Red; font-weight: bold; font-size: 25px;"></span>
                            </td>
                        </tr>
                    </table>
                    </div>
                    <table align="center">
                        <tr>
                            <td>
                                <table>
                                   <tr>
                                    <td>
                                    <div class="input-group">
                                        <div class="input-group-addon">
                                        <span class="glyphicon glyphicon-ok" id="btn_RaisePO1" onclick="save_edit_Outward()"></span> <span id="btn_RaisePO" onclick="save_edit_Outward()">Save</span>
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
