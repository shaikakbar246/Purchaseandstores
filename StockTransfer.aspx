<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true"
    CodeFile="StockTransfer.aspx.cs" Inherits="StockTransfer" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            $('#add_Stock').click(function () {
                $('#fillform').css('display', 'block');
                $('#showlogs').css('display', 'none');
                $('#div_stocktransfer').hide();
                get_productcode();
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
                $('#txtInvoicedate').val(yyyy + '-' + mm + '-' + dd);
                scrollTo(0, 0);
            });
            $('#close_vehmaster').click(function () {
                $('#fillform').css('display', 'none');
                $('#showlogs').css('display', 'block');
                $('#div_stocktransfer').show();
                forclearall();
                emptytable1 = [];
                emptytable = [];
            });
            scrollTo(0, 0);
            get_StockTransfer_details();
            get_productcode();
            get_Branch_details();
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
            $('#txtInvoicedate').val(yyyy + '-' + mm + '-' + dd);
            today_date = yyyy + '-' + mm + '-' + dd;
            emptytable = [];
            emptytable1 = [];
            GetFixedrows();
            
        });
        var today_date = "";
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
        var Branchdata = [];
        function get_Branch_details() {
            var branch_type = document.getElementById('slct_branch_type').value;
            var data = { 'op': 'get_Branch_details_type', 'branch_type': branch_type };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillbranche(msg);
                        Branchdata = msg;
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
        function fillbranche(msg) {
            var data = document.getElementById('ddlfrombranch');
            var brtype = document.getElementById('slct_branch_type').value;
            var length = data.options.length;
            document.getElementById('ddlfrombranch').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select Name";
            opt.value = "Select Name";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].branchname != null) {
                    if (brtype == msg[i].type) {
                        var option = document.createElement('option');
                        option.innerHTML = msg[i].branchname;
                        option.value = msg[i].branchid;
                        data.appendChild(option);
                    }
                }
            }
        }

        function GetFixedrows() {

            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails_gst">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Item Code</th><th scope="col">Price</th><th scope="col">Avail Stores</th><th scope="col">Quantity</th><th scope="col">Taxable Value</th><th scope="col">SGST %</th><th scope="col">CGST %</th><th scope="col">IGST %</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 1; i < 11; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + i + '</td>';
                results += '<td><input id="txtproductname" type="text"  class="productcls_gst" placeholder= "Enter Product" style="width:90px;"/></td>';
                results += '<td><span id="spn_itemcode" ></span></td>';
                results += '<td><span id="spn_perunitrs" style="display:none;"></span><input id="txt_perunitrs" type="text"  class="price_gst" placeholder="Enter Price" onkeypress="return isFloat(event)" style="width:90px;"/></td>';
                results += '<td><span id="spn_available_gst"></span><input id="txtavailable" type="text" readonly class="availablestores_gst" placeholder="Enter Avail Stores" onkeypress="return isFloat(event)" style="width:90px;display:none"/></td>';
                results += '<td><input id="txt_quantity" type="text" class="quantity_gst" placeholder="Enter Qty" onchange="qtychage_gst(this);" onkeypress="return isFloat(event)" style="width:90px;"/></td>';
                results += '<td><span id="spn_taxable"></span><input id="txt_taxable" type="text" class="taxable" placeholder="Taxable Amount" onkeypress="return isFloat(event)" style="width:90px;display:none;"/></td>';
                results += '<td><span id="spn_sgst"></span><input id="txt_sgst" type="text" class="clssgst" placeholder="Enter SGST %" onkeypress="return isFloat(event)" style="width:90px;display:none;"/></td>';
                results += '<td><span id="spn_cgst"></span><input id="txt_cgst" type="text" class="clscgst" placeholder="Enter CGST %" onkeypress="return isFloat(event)" style="width:90px;display:none;"/></td>';
                results += '<td><span id="spn_igst"></span><input id="txt_igst" type="text" class="clsigst" placeholder="Enter IGST %" onkeypress="return isFloat(event)" style="width:90px;display:none;"/></td>';
                results += '<td ><span id="txttotal"  class="clstotal_gst"  onkeypress="return isFloat(event)"  style="width:90px;"></td>';
                results += '<td style="display:none"><input id="hdnproductsno" type="hidden"/></td>';
                results += '<td style="display:none"><input id="txt_stsno" type="hidden" /></td>';
                results += '<td style="display:none" class="4">' + i + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
        }


        $(document).click(function () {
            $('#tabledetails_gst').on('change', '.quantity_gst', calTotal_gst)
            $('#tabledetails_gst').on('change', '.clsfright_gst', calTotal_gst)
            $('#tabledetails_gst').on('change', '.availablestores_gst', calTotal_gst)
            $('#tabledetails_gst').on('change', '.price_gst', calTotal_gst)
            $('#tabledetails_gst').on('blur', '.availablestores_gst', calTotal_gst)
            $('#tabledetails_gst').on('change', '.clstotal_gst', calTotal_gst)
        });

        function clstotalval_gst() {
            var totaamount = 0; //var totalpfamount = 0;
            $('.clstotal_gst').each(function (i, obj) {
                var totlclass = $(this).html();

                if (totlclass == "" || totlclass == "0") {
                }
                else {
                    totaamount += parseFloat(totlclass);
                }
            });

            var totalamount1 = parseFloat(totaamount);
            var freight = parseFloat(document.getElementById('txt_freight').value) || 0;
            var grandtotal = parseFloat(totalamount1) + freight;
            var grandtotal1 = grandtotal.toFixed(2);
            var diff = 0;
            if (grandtotal > grandtotal1) {
                diff = grandtotal - grandtotal1;
            }
            else {
                diff = grandtotal1 - grandtotal;
            }
            document.getElementById('spn_st_amt').innerHTML = grandtotal;
            document.getElementById('spn_roundoffamt').innerHTML = diff;
            document.getElementById('spn_total_amount').innerHTML = grandtotal1;
        }

        var gst = 0;
        var sgst_per = 0;
        var sgst_amount = 0;
        var cgst_per = 0;
        var cgst_amount = 0;
        var igst_per = 0;
        var igst_amount = 0;
        function calTotal_gst() {
            var $row = $(this).closest('tr'),
            price = $row.find('.price_gst').val(),
            avail_st = parseFloat($row.find('.availablestores_gst').val()) || 0;
            avail_stores = avail_st;
            if (avail_stores <= 0) {
                $row.find('.quantity_gst').val('');
                $row.find('.quantity_gst').prop('disabled', true);
                total_price = 0;
            }
            else {
                $row.find('.quantity_gst').prop('disabled', false);
                
            }
            quantity = $row.find('.quantity_gst').val(),
            sum = parseFloat(quantity) || 0;
            if (sum > avail_stores) {
                $row.find('.quantity_gst').val('');
                $row.find('.clssgst').val('');
                $row.find('.clscgst').val('');
                $row.find('.clsigst').val('');
                quantity = "0" || 0;
                sum = 0;
                total_price = 0;
                sgst_amount = 0; cgst_amount = 0; igst_amount = 0;
            }
            else {
                total_price = sum * price;
                $row.find('.taxable').val(total_price);
                $row.find('#spn_taxable').text(total_price.toFixed(2));
                sgst_per = parseFloat($row.find('.clssgst').val()) || 0;
                if (sgst_per != 0) {
                    sgst_amount = (sgst_per * total_price) / 100 || 0;
                    
                }
                else {
                    sgst_amount = 0;
                }
                cgst_per = parseFloat($row.find('.clscgst').val()) || 0;
                if (cgst_per != 0) {
                    cgst_amount = (cgst_per * total_price) / 100 || 0;
                    
                }
                else {
                    cgst_amount = 0;
                }
                igst_per = parseFloat($row.find('.clsigst').val()) || 0;
                if (igst_per != 0) {
                    igst_amount = (igst_per * total_price) / 100 || 0;
                    
                }
                else {
                    igst_amount = 0;
                }
                total_price = parseFloat(sgst_amount) + parseFloat(cgst_amount) + parseFloat(igst_amount) + parseFloat(total_price);
                
            }

            $row.find('.clstotal_gst').html(parseFloat(total_price).toFixed(2));
            clstotalval_gst();
        }

        function qtychage_gst(thisid) {
            var rows = $("#tabledetails tr:gt(0)");
            $(rows).each(function (i, obj) {
                if ($(this).find('#txtProductname').val() != "") {
                    var moniterqty = $(this).find('#txtavailable').val();
                    var Quantity = $(this).find('#txt_quantity').val();
                    var qty = parseFloat(Quantity);
                    var avlqty = parseFloat(moniterqty);
                    if (qty > avlqty) {
                        alert("enter quantity is more then the available quantity");
                    }
                }
            });
        }

        var DataTable;
        function insertrow() {
            var todaydate = today_date.split('-');
            //var todaydate = "2017-07-17".split('-');
            var date = "2017-07-01".split('-');

            var firstDate = new Date();
            firstDate.setFullYear(todaydate[0], (todaydate[1] - 1), todaydate[2]);
            var secondDate = new Date();
            secondDate.setFullYear(date[0], (date[1] - 1), date[2]);

            if (firstDate < secondDate) {
                var type_branch = document.getElementById('slct_branch_type').value;
                if (type_branch == "") {
                    alert("Select  branch type");
                    return false;
                }

                if (type_branch == "Inter Branch") {
                    get_productcode();
                    DataTable = [];
                    var txtsno = 0;
                    var productname = 0;
                    var price = 0;
                    var quantity = 0;
                    var moniterqty = 0;
                    var stockrefno = 0;
                    var hdnproductsno = 0;
                    var sno = 0;
                    var rows = $("#tabledetails tr:gt(0)");
                    var rowsno = 1;
                    $(rows).each(function (i, obj) {
                        if ($(this).find('#txtproductname').val() != "") {
                            txtsno = rowsno;
                            productname = $(this).find('#txtproductname').val();
                            price = $(this).find('#txt_perunitrs').val();
                            moniterqty = $(this).find('#txtavailable').val();
                            quantity = $(this).find('#txt_quantity').val();
                            stockrefno = $(this).find('#txt_stsno').val();
                            productamount = $(this).find('#txttotal').text();
                            sno = $(this).find('#txt_sub_sno').val();
                            hdnproductsno = $(this).find('#hdnproductsno').val();
                            DataTable.push({ Sno: txtsno, productname: productname, moniterqty: moniterqty, price: price, quantity: quantity, hdnproductsno: hdnproductsno, stockrefno: stockrefno, productamount: productamount });
                            rowsno++;
                        }

                    });
                    productname = 0;
                    price = 0;
                    quantity = 0;
                    moniterqty = 0;
                    stockrefno = 0;
                    hdnproductsno = 0;
                    productamount = 0;
                    var Sno = parseInt(txtsno) + 1;
                    DataTable.push({ Sno: Sno, productname: productname, moniterqty: moniterqty, price: price, quantity: quantity, hdnproductsno: hdnproductsno, stockrefno: stockrefno, productamount: productamount });
                    var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
                    results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Price</th><th scope="col">Avail Stores</th><th scope="col">Quantity</th></tr></thead></tbody>';
                    for (var i = 0; i < DataTable.length; i++) {
                        results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + DataTable[i].Sno + '</td>';
                        results += '<td ><input id="txtproductname" type="text" class="productcls" style="width:90px;"   value="' + DataTable[i].productname + '"/></td>';
                        results += '<td ><span id="spn_perunitrs" style="display:none;">' + DataTable[i].price + '</span><input id="txt_perunitrs" type="text"  class="price" style="width:90px;" value="' + DataTable[i].price + '"/></td>';
                        results += '<td ><span id="spn_available">' + DataTable[i].moniterqty + '</span><input id="txtavailable" type="text" readonly class="availablestores" style="width:90px;display:none" value="' + DataTable[i].moniterqty + '"/></td>';
                        results += '<td ><input id="txt_quantity" type="text" class="quantity"  onkeypress="return isFloat(event)" style="width:90px;" value="' + DataTable[i].quantity + '"/></td>';
                        results += '<td><span id="txttotal"  class="clstotal"  onkeypress="return isFloat(event)"style="width:90px;">' + DataTable[i].productamount + '</span></td>';
                        results += '<td><input  type="hidden" id="txt_stsno" class="8" value="' + DataTable[i].stockrefno + '"/></td>';
                        results += '<td style="display:none"><input id="hdnproductsno" type="hidden" value="' + DataTable[i].hdnproductsno + '"/></td>';
                        results += '<td style="display:none" class="4">' + i + '</td></tr>';
                    }
                    results += '</table></div>';
                    $("#div_SectionData").html(results);
                }
                else {
                    get_productcode();
                    DataTable = [];
                    var txtsno = 0;
                    var productname = 0;
                    var price = 0;
                    var quantity = 0;
                    var taxtype = 0;
                    var taxvalue = 0;
                    var freigtamt = 0;
                    var moniterqty = 0;
                    var stockrefno = 0;
                    var hdnproductsno = 0;
                    var sno = 0;
                    var rows = $("#tabledetails tr:gt(0)");
                    var rowsno = 1;
                    $(rows).each(function (i, obj) {
                        if ($(this).find('#txtproductname').val() != "") {
                            txtsno = rowsno;
                            productname = $(this).find('#txtproductname').val();
                            price = $(this).find('#txt_perunitrs').val();
                            moniterqty = $(this).find('#txtavailable').val();
                            quantity = $(this).find('#txt_quantity').val();
                            taxtype = $(this).find('#ddltax').val();
                            taxvalue = $(this).find('#txt_Tax').val();
                            stockrefno = $(this).find('#txt_stsno').val();
                            productamount = $(this).find('#txttotal').text();
                            sno = $(this).find('#txt_sub_sno').val();
                            hdnproductsno = $(this).find('#hdnproductsno').val();
                            DataTable.push({ Sno: txtsno, productname: productname, moniterqty: moniterqty, price: price, quantity: quantity, taxtype: taxtype, taxvalue: taxvalue, freigtamt: freigtamt, hdnproductsno: hdnproductsno, stockrefno: stockrefno, productamount: productamount });
                            rowsno++;
                        }

                    });
                    productname = 0;
                    price = 0;
                    quantity = 0;
                    taxtype = 0;
                    taxvalue = 0;
                    freigtamt = 0;
                    moniterqty = 0;
                    stockrefno = 0;
                    hdnproductsno = 0;
                    productamount = 0;
                    var Sno = parseInt(txtsno) + 1;
                    DataTable.push({ Sno: Sno, productname: productname, moniterqty: moniterqty, price: price, quantity: quantity, taxtype: taxtype, taxvalue: taxvalue, freigtamt: freigtamt, hdnproductsno: hdnproductsno, stockrefno: stockrefno, productamount: productamount });
                    var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
                    results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Price</th><th scope="col">Avail Stores</th><th scope="col">Quantity</th><th scope="col">Tax</th><th scope="col">Tax Value</th></tr></thead></tbody>';
                    for (var i = 0; i < DataTable.length; i++) {
                        results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + DataTable[i].Sno + '</td>';
                        results += '<td ><input id="txtproductname" type="text" class="productcls" style="width:90px;"   value="' + DataTable[i].productname + '"/></td>';
                        results += '<td ><span id="spn_perunitrs" style="display:none;">' + DataTable[i].price + '</span><input id="txt_perunitrs" type="text"  class="price" style="width:90px;" value="' + DataTable[i].price + '"/></td>';
                        results += '<td ><span id="spn_available">' + DataTable[i].moniterqty + '</span><input id="txtavailable" type="text" readonly class="availablestores" style="width:90px;display:none" value="' + DataTable[i].moniterqty + '"/></td>';
                        results += '<td ><input id="txt_quantity" type="text" class="quantity"  onkeypress="return isFloat(event)" style="width:90px;" value="' + DataTable[i].quantity + '"/></td>';
                        results += '<td data-title="Phosps"><select id="ddltax" class="Taxtypecls" style="width:90px;" ><option value="withtax">withtax</option><option  value="withouttax">withouttax</option></select></td>';
                        results += '<td><input id="txt_Tax" type="text" class="clstax"  onkeypress="return isFloat(event)" style="width:90px;" value="' + DataTable[i].taxvalue + '"/></td>';
                        results += '<td><span id="txttotal"  class="clstotal"  onkeypress="return isFloat(event)"style="width:90px;">' + DataTable[i].productamount + '</span></td>';
                        results += '<td><input  type="hidden" id="txt_stsno" class="8" value="' + DataTable[i].stockrefno + '"/></td>';
                        results += '<td style="display:none"><input id="hdnproductsno" type="hidden" value="' + DataTable[i].hdnproductsno + '"/></td>';
                        results += '<td style="display:none" class="4">' + i + '</td></tr>';
                    }
                    results += '</table></div>';
                    $("#div_SectionData").html(results);
                }
            }
            else {//gst
                get_productcode();
                DataTable = [];
                var DataTable1 = [];
                var txtsno = 0;
                var productname = 0;
                var price = 0;
                var quantity = 0;
                var itemcode = 0;
                var sgst_per = 0;
                var cgst_per = 0;
                var igst_per = 0;
                var freigtamt = 0;
                var moniterqty = 0;
                var stockrefno = 0;
                var hdnproductsno = 0;
                var taxable = 0;
                var sno = 0;
                var rows = $("#tabledetails_gst tr:gt(0)");
                var rowsno = 1;
                $(rows).each(function (i, obj) {
                    if ($(this).find('#txtproductname').val() != "") {
                        txtsno = rowsno;
                        productname = $(this).find('#txtproductname').val();
                        price = $(this).find('#txt_perunitrs').val();
                        moniterqty = $(this).find('#txtavailable').val();
                        quantity = $(this).find('#txt_quantity').val();
                        itemcode = $(this).find('#spn_itemcode').text();
                        taxable = $(this).find('#txt_taxable').val();
                        sgst_per = $(this).find('#txt_sgst').val();
                        cgst_per = $(this).find('#txt_cgst').val();
                        igst_per = $(this).find('#txt_igst').val();
                        stockrefno = $(this).find('#txt_stsno').val();
                        productamount = $(this).find('#txttotal').text();
                        sno = $(this).find('#txt_sub_sno').val();
                        hdnproductsno = $(this).find('#hdnproductsno').val();
                        DataTable1.push({ Sno: txtsno, productname: productname, taxable: taxable, moniterqty: moniterqty, price: price, quantity: quantity, itemcode: itemcode, sgst_per: sgst_per, cgst_per: cgst_per, igst_per: igst_per, hdnproductsno: hdnproductsno, stockrefno: stockrefno, productamount: productamount });//, freigtamt: freigtamt
                        rowsno++;
                    }
                });

                for (var i = 0; i < DataTable1.length; i++) {
                    var name_check = DataTable1[i].productname;
                    if (name_check != "") {
                        DataTable.push({ Sno: DataTable1[i].Sno, productname: DataTable1[i].productname, taxable: DataTable1[i].taxable, moniterqty: DataTable1[i].moniterqty, price: DataTable1[i].price, quantity: DataTable1[i].quantity, itemcode: DataTable1[i].itemcode, sgst_per: DataTable1[i].sgst_per, cgst_per: DataTable1[i].cgst_per, igst_per: DataTable1[i].igst_per, hdnproductsno: DataTable1[i].hdnproductsno, stockrefno: DataTable1[i].stockrefno, productamount: DataTable1[i].productamount });//, freigtamt: DataTable1[i].freigtamt
                    }
                }

                productname = 0;
                price = 0;
                quantity = 0;
                itemcode = 0;
                sgst_per = 0;
                cgst_per = 0;
                igst_per = 0;
                freigtamt = 0;
                moniterqty = 0;
                stockrefno = 0;
                hdnproductsno = 0;
                taxable = 0;
                productamount = 0;
                var Sno = parseInt(txtsno) + 1;
                DataTable.push({ Sno: Sno, productname: productname, taxable: taxable, moniterqty: moniterqty, price: price, quantity: quantity, itemcode: itemcode, sgst_per: sgst_per, cgst_per: cgst_per, igst_per: igst_per, hdnproductsno: hdnproductsno, stockrefno: stockrefno, productamount: productamount });//, freigtamt: freigtamt
                var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails_gst">';
                results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Item Code</th><th scope="col">Price</th><th scope="col">Avail Stores</th><th scope="col">Quantity</th><th scope="col">Taxable Value</th><th scope="col">SGST %</th><th scope="col">CGST %</th><th scope="col">IGST %</th><th scope="col"></th></tr></thead></tbody>';
                for (var i = 0; i < DataTable.length; i++) {
                    results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + DataTable[i].Sno + '</td>';
                    results += '<td ><input id="txtproductname" type="text" class="productcls_gst" style="width:90px;" value="' + DataTable[i].productname + '"/></td>';
                    results += '<td><span id="spn_itemcode" >' + DataTable[i].sku + '</span></td>';
                    results += '<td ><span id="spn_perunitrs" style="display:none;">' + DataTable[i].price + '</span><input id="txt_perunitrs" type="text"  class="price_gst" style="width:90px;" value="' + DataTable[i].price + '"/></td>';
                    results += '<td ><span id="spn_available_gst">' + DataTable[i].moniterqty + '</span><input id="txtavailable" type="text" readonly class="availablestores_gst" style="width:90px;display:none" value="' + DataTable[i].moniterqty + '"/></td>';
                    results += '<td ><input id="txt_quantity" type="text" class="quantity_gst"  onkeypress="return isFloat(event)" style="width:90px;" value="' + DataTable[i].quantity + '"/></td>';
                    results += '<td><span id="spn_taxable">' + DataTable[i].taxable + '</span><input id="txt_taxable" type="text" class="taxable" value="' + DataTable[i].taxable + '" placeholder="Taxable Amount" onkeypress="return isFloat(event)" style="width:90px;display:none;"/></td>';
                    results += '<td><span id="spn_sgst">' + DataTable[i].sgst_per + '</span><input id="txt_sgst" type="text" class="clssgst" value="' + DataTable[i].sgst_per + '" placeholder="Enter SGST %" onkeypress="return isFloat(event)" style="width:90px;display:none;"/></td>';
                    results += '<td><span id="spn_cgst">' + DataTable[i].cgst_per + '</span><input id="txt_cgst" type="text" class="clscgst" value="' + DataTable[i].cgst_per + '" placeholder="Enter CGST %" onkeypress="return isFloat(event)" style="width:90px;display:none;"/></td>';
                    results += '<td><span id="spn_igst">' + DataTable[i].igst_per + '</span><input id="txt_igst" type="text" class="clsigst" value="' + DataTable[i].igst_per + '" placeholder="Enter IGST %" onkeypress="return isFloat(event)" style="width:90px;display:none;"/></td>';
                    results += '<td><span id="txttotal"  class="clstotal_gst"  onkeypress="return isFloat(event)"style="width:90px;">' + DataTable[i].productamount + '</span></td>';
                    results += '<td style="display:none"><input  type="hidden" id="txt_stsno" class="8" value="' + DataTable[i].stockrefno + '"/></td>';
                    results += '<td style="display:none"><input id="hdnproductsno" type="hidden" value="' + DataTable[i].hdnproductsno + '"/></td>';
                    results += '<td style="display:none" class="4">' + i + '</td></tr>';
                }
                results += '</table></div>';
                $("#div_SectionData").html(results);
            }
        }
        $(document).click(function () {
            $('#tabledetails').on('change', '.price', calTotal)
                  .on('change', '.quantity', calTotal);

            // find the value and calculate it

            function calTotal() {
                var $row = $(this).closest('tr'),
            price = $row.find('.price').val(),
            quantity = $row.find('.quantity').val(),
            total = price * quantity;

                // change the value in total
                $row.find('.Total').val(total)
            }

        });

        function save_stock_transfer_click() {
            var todaydate = today_date.split('-');
            //var todaydate = "2017-07-17".split('-');
            var date = "2017-07-01".split('-');
            var firstDate = new Date();
            var secondDate = new Date();
            
            var branch_type = document.getElementById('slct_branch_type').value;
            var tobranch = document.getElementById('ddlfrombranch').value;
            var transportname = document.getElementById('txtTransport').value;
            var vehicleno = document.getElementById('txtvehcleno').value;
            var invoicetype = document.getElementById('ddltype').value;
            var invoiceno = document.getElementById('txtInvoiceno').value;
            var invoicedate = document.getElementById('txtInvoicedate').value;
            var remarks = document.getElementById('txt_remarks').value;
            var salesinvoicetype = document.getElementById('slctinvoicetype').value;

            if (salesinvoicetype == "Select" || salesinvoicetype == "") {
                alert("Select Invoice Type");
                return false;
            }
            var status = "p";
            var sno = document.getElementById('lbl_sno').value
            if (branch_type == "") {
                alert("Select  branch type");
                return false;
            }
            if (tobranch == "" || tobranch == "Select Name") {
                alert("Select From Branch");
                return false;
            }
            if (invoicedate == "") {
                alert("Select  InvoiceDate");
                return false;
            }
            var freight = document.getElementById('txt_freight').value;
            var btnval = document.getElementById('btn_save').innerHTML;
            if (btnval == "Modify") {
                var invoicedate1 = invoicedate.split('-');
                firstDate.setFullYear(invoicedate1[0], (invoicedate1[1] - 1), invoicedate1[2]);
                secondDate.setFullYear(date[0], (date[1] - 1), date[2]);
            }
            else {
                firstDate.setFullYear(todaydate[0], (todaydate[1] - 1), todaydate[2]);
                secondDate.setFullYear(date[0], (date[1] - 1), date[2]);
            }

            var filldetails = [];
            if (firstDate < secondDate) {
                $('#tabledetails> tbody > tr').each(function () {
                    var txtsno = $(this).find('#txtSno').text();
                    var productname = $(this).find('#txtproductname').val();
                    var price = $(this).find('#txt_perunitrs').val();
                    var quantity = $(this).find('#txt_quantity').val();
                    var taxtype = $(this).find('#ddltax').val();
                    var taxvalue = $(this).find('#txt_Tax').val();
                    var stockrefno = $(this).find('#txt_stsno').val();
                    var sno = $(this).find('#txt_sub_sno').val();
                    var hdnproductsno = $(this).find('#hdnproductsno').val();
                    if (hdnproductsno == "" || hdnproductsno == "0") {
                    }
                    else {
                        filldetails.push({ 'txtsno': txtsno, 'productname': productname, 'taxtype': taxtype, 'taxvalue': taxvalue, 'igst_per': "0", 'cgst_per': "0", 'sgst_per': "0", 'price': price, 'quantity': quantity, 'hdnproductsno': hdnproductsno, 'stockrefno': stockrefno });//, 'freigtamt': freigtamt
                    }
                });
            }
            else {
                $('#tabledetails_gst> tbody > tr').each(function () {
                    var txtsno = $(this).find('#txtSno').text();
                    var productname = $(this).find('#txtproductname').val();
                    var price = $(this).find('#txt_perunitrs').val();
                    var quantity = $(this).find('#txt_quantity').val();
                    var sgst = $(this).find('#txt_sgst').val();
                    var cgst = $(this).find('#txt_cgst').val();
                    var igst = $(this).find('#txt_igst').val();
                    var stockrefno = $(this).find('#txt_stsno').val();
                    var sno = $(this).find('#txt_sub_sno').val();
                    var hdnproductsno = $(this).find('#hdnproductsno').val();
                    if (hdnproductsno == "" || hdnproductsno == "0") {
                    }
                    else {
                        filldetails.push({ 'txtsno': txtsno, 'productname': productname, 'taxtype': "", 'taxvalue': "0", 'igst_per': igst, 'cgst_per': cgst, 'sgst_per': sgst, 'price': price, 'quantity': quantity, 'hdnproductsno': hdnproductsno, 'stockrefno': stockrefno });//, 'freigtamt': freigtamt
                    }
                });
            }
            
            if (filldetails.length == 0) {
                alert("Please Select Product Names");
                return false;
            }
            var Data = { 'op': 'save_stock_transfer_click', 'freight': freight, 'invoiceno': invoiceno, 'invoicedate': invoicedate, 'tobranch': tobranch, 'transportname': transportname, 'invoicetype': invoicetype, 'vehicleno': vehicleno, 'btnval': btnval, 'remarks': remarks, 'sno': sno, 'status': status, 'salesinvoicetype': salesinvoicetype, 'filldetails': filldetails };
            var s = function (msg) {
                if (msg) {
                    if (msg == "Contact Apurva Sir") {
                        alert(msg);
                        return false;
                    }
                    else {
                        alert(msg);
                        get_StockTransfer_details();
                        $('#fillform').css('display', 'none');
                        $('#showlogs').css('display', 'block');
                        $('#div_stocktransfer').show();
                        GetFixedrows();
                        get_productcode();
                        forclearall();
                    }
                }
            }
            var e = function (x, h, e) {
            };
            CallHandlerUsingJson(Data, s, e);
        }
        var filldescrption = [];
        function get_productcode() {
            var data = { 'op': 'get_productissue_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        filldata1(msg);
                        filldata(msg);
                        filldescrption = msg;
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

        function filldata(msg) {
            var compiledList = [];
            for (var i = 0; i < msg.length; i++) {
                var name = msg[i].productname;
                compiledList.push(name);
            }

            $('.productcls').autocomplete({
                source: compiledList,
                change: test1,
                autoFocus: true
            });
        }
        var emptytable = [];
        function test1() {
            var name = $(this).val();
            var checkflag = true;
            if (emptytable.indexOf(name) == -1) {
                for (var i = 0; i < filldescrption.length; i++) {
                    if (name == filldescrption[i].productname) {
                        $(this).closest('tr').find('#hdnproductsno').val(filldescrption[i].productid);
                        $(this).closest('tr').find('#txt_perunitrs').val(filldescrption[i].price);
                        $(this).closest('tr').find('#txtavailable').val(filldescrption[i].moniterqty);
                        $(this).closest('tr').find('#spn_perunitrs').text(filldescrption[i].price);
                        $(this).closest('tr').find('#spn_available').text(filldescrption[i].moniterqty);
                        emptytable.push(name);
                    }
                }
            }
            else {
                alert("Product Name already added");
                var empt = "";
                $(this).val(empt);
                $(this).focus();
                return false;
            }
        }
        function filldata1(msg) {
            var compiledList = [];
            for (var i = 0; i < msg.length; i++) {
                var name = msg[i].productname;
                compiledList.push(name);
            }

            $('.productcls_gst').autocomplete({
                source: compiledList,
                change: test2,
                autoFocus: true
            });
        }
        var emptytable1 = [];
        function test2() {
            var branchtype = document.getElementById('slct_branch_type').value;
            var tobranch_state = document.getElementById('txt_tobranch_state').value;
            if (tobranch_state == "")
            {
                alert("Select Branch Name or update the branch with state");
                document.getElementById('txt_tobranch_state').focus();
                $('#txtproductname').val("");
                return false;
            }
            var name = $(this).val();
            var checkflag = true;
            if (emptytable1.indexOf(name) == -1) {
                for (var i = 0; i < filldescrption.length; i++) {
                    if (name == filldescrption[i].productname) {
                        if (filldescrption[i].hsn_code != "") {
                            if (filldescrption[i].igst != "") {
                                $(this).closest('tr').find('#hdnproductsno').val(filldescrption[i].productid);
                                $(this).closest('tr').find('#txt_perunitrs').val(filldescrption[i].price);
                                $(this).closest('tr').find('#txtavailable').val(filldescrption[i].moniterqty);
                                $(this).closest('tr').find('#spn_perunitrs').text(filldescrption[i].price);
                                $(this).closest('tr').find('#spn_available_gst').text(filldescrption[i].moniterqty);
                                $(this).closest('tr').find('#spn_itemcode').text(filldescrption[i].itemcode);
                                var frombranch_state = filldescrption[i].state;
                                if (tobranch_state != frombranch_state) {
                                    $(this).closest('tr').find('#spn_sgst').text("0");
                                    $(this).closest('tr').find('#spn_cgst').text("0");
                                    $(this).closest('tr').find('#spn_igst').text(filldescrption[i].igst);
                                    $(this).closest('tr').find('#txt_sgst').val("0");
                                    $(this).closest('tr').find('#txt_cgst').val("0");
                                    $(this).closest('tr').find('#txt_igst').val(filldescrption[i].igst);
                                }
                                else {
                                    if (branchtype == "Inter Branch") {
                                        if (tobranch_state == frombranch_state) {
                                            $(this).closest('tr').find('#spn_sgst').text("0");
                                            $(this).closest('tr').find('#spn_cgst').text("0");
                                            $(this).closest('tr').find('#spn_igst').text("0");
                                            $(this).closest('tr').find('#txt_sgst').val("0");
                                            $(this).closest('tr').find('#txt_cgst').val("0");
                                            $(this).closest('tr').find('#txt_igst').val("0");
                                        }
                                        else {
                                            $(this).closest('tr').find('#spn_sgst').text("0");
                                            $(this).closest('tr').find('#spn_cgst').text("0");
                                            $(this).closest('tr').find('#spn_igst').text(filldescrption[i].igst);
                                            $(this).closest('tr').find('#txt_sgst').val("0");
                                            $(this).closest('tr').find('#txt_cgst').val("0");
                                            $(this).closest('tr').find('#txt_igst').val(filldescrption[i].igst);
                                        }
                                    }
                                    else {
                                        $(this).closest('tr').find('#spn_sgst').text(filldescrption[i].sgst);
                                        $(this).closest('tr').find('#spn_cgst').text(filldescrption[i].cgst);
                                        $(this).closest('tr').find('#spn_igst').text("0");
                                        $(this).closest('tr').find('#txt_sgst').val(filldescrption[i].sgst);
                                        $(this).closest('tr').find('#txt_cgst').val(filldescrption[i].cgst);
                                        $(this).closest('tr').find('#txt_igst').val("0");
                                    }
                                }
                                emptytable1.push(name);
                            }
                            else {
                                alert("Product without IGST or CGST or SGST cannot be added");
                                $(this).closest('tr').find('#txtproductname').val("");
                                return false;
                            }
                        }
                        else {
                            alert("Product without HSN CODE cannot be added, Please update the Product with HSN CODE");
                            $(this).closest('tr').find('#txtproductname').val("");
                            return false;
                        }
                    }
                }
            }
            else {
                alert("Product Name already added");
                var empt = "";
                $(this).val(empt);
                $(this).focus();
                return false;
            }
        }
        function get_StockTransfer_details() {
            var data = { 'op': 'get_StockTransfer_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillStockTransfer(msg);
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
        var Stocktransfer_sub_list = [];
        function fillStockTransfer(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr class="trbgclrcls"><th scope="col">From Branch</th><th scope="col">Invoice No</th><th scope="col">Invoice Date</th><th scope="col"></th><th scope="col"></th></tr></thead></tbody>';
            var stocktransferdetails = msg[0].stocktransferdetails;
            Stocktransfer_sub_list = msg[0].stocktransfersubdetails;

            var k = 1;
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];

            for (var i = 0; i < stocktransferdetails.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">';//<td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="Edit" /></td>
                results += '<th scope="row" class="1" style="display:none;" >' + stocktransferdetails[i].tobranch + '</th>';
                results += '<td data-title="sectionstatus" class="4">' + stocktransferdetails[i].bname + '</td>';
                results += '<td data-title="sectionstatus"  style="display:none;" class="6">' + stocktransferdetails[i].transportname + '</td>';
                results += '<td data-title="sectionstatus"  style="display:none;" class="7">' + stocktransferdetails[i].vehicleno + '</td>';
                results += '<td data-title="sectionstatus" class="10">' + stocktransferdetails[i].invoiceno + '</td>';
                results += '<td data-title="sectionstatus" class="9">' + stocktransferdetails[i].invoicedate + '</td>';
                results += '<td data-title="sectionstatus"  style="display:none;" class="8">' + stocktransferdetails[i].invoicetype + '</td>';
                results += '<td data-title="sectionstatus"  style="display:none;" class="11">' + stocktransferdetails[i].remarks + '</td>';
                results += '<td data-title="sectionstatus"  style="display:none;" class="12">' + stocktransferdetails[i].freight + '</td>';
                results += '<td data-title="sectionstatus"  style="display:none;" class="13">' + stocktransferdetails[i].tostate + '</td>';
                results += '<td data-title="brandstatus"><button type="button" title="Click Here To Print!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 printcls"  onclick="printstock(this)"><span class="glyphicon glyphicon-print" style="top: 0px !important;"></span></button></td>';
                results += '<td data-title="brandstatus"><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"  onclick="getme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td>';
                results += '<td data-title="sno" class="5" style="display:none;">' + stocktransferdetails[i].sno + '</td></tr>';


                l = l + 1;
                if (l == 4) {
                    l = 0;
                }

            }
            results += '</table></div>';
            $("#div_stocktransfer").html(results);
        }
        function Getbranches(msg) {
            var data = document.getElementById('ddlfrombranch');
            var brtype =   document.getElementById('slct_branch_type').value;
            var length = data.options.length;
            document.getElementById('ddlfrombranch').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select Name";
            opt.value = "Select Name";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].branchname != null) {
                    if (brtype == msg[i].type) {
                        var option = document.createElement('option');
                        option.innerHTML = msg[i].branchname;
                        option.value = msg[i].branchid;
                        data.appendChild(option);
                    }
                }
            }
        }

        var sno = 0;
        function getme(thisid) {
            scrollTo(0, 0);
            $('#fillform').css('display', 'block');
            $('#showlogs').css('display', 'none');
            $('#div_stocktransfer').hide();
            get_productcode();
            var bname = $(thisid).parent().parent().children('.4').html();
            var tobranch = $(thisid).parent().parent().children('.1').html();
            var transportname = $(thisid).parent().parent().children('.6').html();
            var vehicleno = $(thisid).parent().parent().children('.7').html();
            var invoicedate2 = $(thisid).parent().parent().children('.9').html();
            var invoiceno = $(thisid).parent().parent().children('.10').html();
            var invoicetype = $(thisid).parent().parent().children('.8').html();
            var freight = $(thisid).parent().parent().children('.12').html();
            var remarks = $(thisid).parent().parent().children('.11').html();
            var tostate = $(thisid).parent().parent().children('.13').html();
            var sno = $(thisid).parent().parent().children('.5').html();

            var invoicedate1 = invoicedate2.split('-');
            var invoicedate = invoicedate1[2] + '-' + invoicedate1[1] + '-' + invoicedate1[0];
            
            if (invoicetype == "BranchTransfer") {
                document.getElementById('slct_branch_type').value = "Inter Branch";
                Getbranches(Branchdata);
                document.getElementById('ddlfrombranch').value = tobranch;
                document.getElementById('txt_tobranch_state').value = tostate;

                var data = document.getElementById('ddltype');
                var length = data.options.length;
                document.getElementById('ddltype').options.length = null;
                var option = document.createElement('option');
                option.innerHTML = "BranchTransfer";
                option.value = "BranchTransfer";
                data.appendChild(option);
            }
            else {
                document.getElementById('slct_branch_type').value = "Other Branch";
                Getbranches(Branchdata);
                document.getElementById('ddlfrombranch').value = tobranch;
                document.getElementById('txt_tobranch_state').value = tostate;
                var data = document.getElementById('ddltype');
                var length = data.options.length;
                document.getElementById('ddltype').options.length = null;
                var option = document.createElement('option');
                option.innerHTML = "Invoice";
                option.value = "Invoice";
                data.appendChild(option);
            }
            document.getElementById('txtTransport').value = transportname;
            document.getElementById('txtInvoiceno').value = invoiceno;
            document.getElementById('txtInvoicedate').value = invoicedate;
            document.getElementById('txtvehcleno').value = vehicleno;
            document.getElementById('ddltype').value = invoicetype;
            document.getElementById('txt_remarks').value = remarks;
            document.getElementById('lbl_sno').value = sno;
            document.getElementById('txt_freight').value = freight;
            document.getElementById('btn_save').innerHTML = "Modify";
            var table = document.getElementById("tabledetails");

            var todaydate = invoicedate.split('-');
            //var todaydate = "2017-07-17".split('-');
            var date = "2017-07-01".split('-');
            var firstDate = new Date();
            firstDate.setFullYear(todaydate[0], (todaydate[1] - 1), todaydate[2]);
            var secondDate = new Date();
            secondDate.setFullYear(date[0], (date[1] - 1), date[2]);
            
            if (firstDate >= secondDate) {
                var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails_gst">';
                results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Item Code</th><th scope="col">Price</th><th scope="col">Avail Stores</th><th scope="col">Quantity</th><th scope="col">Taxable Value</th><th scope="col">SGST %</th><th scope="col">CGST %</th><th scope="col">IGST %</th><th scope="col"></th><th scope="col"></th></tr></thead></tbody>';
                var total_amount = 0;
                var k = 1;
                for (var i = 0; i < Stocktransfer_sub_list.length; i++) {
                    if (sno == Stocktransfer_sub_list[i].sno)
                    {
                        results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + k + '</td>';
                        results += '<td ><input id="txtproductname" type="text" class="productcls_gst" style="width:90px;" value="' + Stocktransfer_sub_list[i].productname + '"/></td>';
                        results += '<td><span id="spn_itemcode" >' + Stocktransfer_sub_list[i].itemcode + '</span></td>';
                        results += '<td ><span id="spn_perunitrs" style="display:none;">' + Stocktransfer_sub_list[i].price + '</span><input id="txt_perunitrs" type="text"  class="price_gst" style="width:90px;" value="' + Stocktransfer_sub_list[i].price + '"/></td>';
                        results += '<td ><span id="spn_available_gst">' + Stocktransfer_sub_list[i].moniterqty + '</span><input id="txtavailable" type="text" readonly class="availablestores_gst" style="width:90px;display:none" value="' + Stocktransfer_sub_list[i].moniterqty + '"/></td>';
                        results += '<td ><input id="txt_quantity" type="text" class="quantity_gst"  onkeypress="return isFloat(event)" style="width:90px;" value="' + Stocktransfer_sub_list[i].quantity + '"/></td>';
                        var qty = parseFloat(Stocktransfer_sub_list[i].quantity);
                        var cost = parseFloat(Stocktransfer_sub_list[i].price);
                        var taxable = qty * cost;
                        results += '<td><span id="spn_taxable">' + taxable.toFixed(2)+ '</span><input id="txt_taxable" type="text" class="taxable" value="' + taxable + '" placeholder="Taxable Amount" onkeypress="return isFloat(event)" style="width:90px;display:none;"/></td>';
                        results += '<td><span id="spn_sgst">' + Stocktransfer_sub_list[i].sgst_per + '</span><input id="txt_sgst" type="text" class="clssgst" value="' + Stocktransfer_sub_list[i].sgst_per + '" placeholder="Enter SGST %" onkeypress="return isFloat(event)" style="width:90px;display:none;"/></td>';
                        results += '<td><span id="spn_cgst">' + Stocktransfer_sub_list[i].cgst_per + '</span><input id="txt_cgst" type="text" class="clscgst" value="' + Stocktransfer_sub_list[i].cgst_per + '" placeholder="Enter CGST %" onkeypress="return isFloat(event)" style="width:90px;display:none;"/></td>';
                        results += '<td><span id="spn_igst">' + Stocktransfer_sub_list[i].igst_per + '</span><input id="txt_igst" type="text" class="clsigst" value="' + Stocktransfer_sub_list[i].igst_per + '" placeholder="Enter IGST %" onkeypress="return isFloat(event)" style="width:90px;display:none;"/></td>';
                        var sgst_amt = (parseFloat(Stocktransfer_sub_list[i].sgst_per) * parseFloat(taxable)) / 100 || 0;
                        var cgst_amt = (parseFloat(Stocktransfer_sub_list[i].cgst_per) * parseFloat(taxable)) / 100 || 0;
                        var igst_amt = (parseFloat(Stocktransfer_sub_list[i].igst_per) * parseFloat(taxable)) / 100 || 0;
                        //var freight1 = parseFloat(Stocktransfer_sub_list[i].freigtamt) || 0;
                        var tot_amount = parseFloat(sgst_amt) + parseFloat(cgst_amt) + parseFloat(igst_amt) + parseFloat(taxable);// + parseFloat(freight1)
                        total_amount += parseFloat(tot_amount);
                        results += '<td><span id="txttotal"  class="clstotal_gst"  onkeypress="return isFloat(event)"style="width:90px;">' + tot_amount.toFixed(2) + '</span></td>';
                        results += '<td style="display:none"><input  type="hidden" id="txt_stsno" class="8" value="' + Stocktransfer_sub_list[i].stockrefno + '"/></td>';
                        results += '<td style="display:none"><input id="hdnproductsno" type="hidden" value="' + Stocktransfer_sub_list[i].hdnproductsno + '"/></td>';
                        results += '<td style="display:none" class="4">' + i + '</td></tr>';
                        k++;
                    }
                }
                results += '</table></div>';
                $("#div_SectionData").html(results);
                total_amount = total_amount + freight
                var grandtotal1 = total_amount.toFixed(2);
                var diff = 0;
                if (total_amount > grandtotal1) {
                    diff = total_amount - grandtotal1;
                }
                else {
                    diff = grandtotal1 - total_amount;
                }
                document.getElementById('spn_st_amt').innerHTML = total_amount;
                document.getElementById('spn_roundoffamt').innerHTML = diff;
                document.getElementById('spn_total_amount').innerHTML = grandtotal1;
            }
            else {
                if (invoicetype == "BranchTransfer") {
                    var results = '<div  style="overflow:auto;"><table id="tabledetails" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
                    results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Price</th><th scope="col">Avail Stores</th><th scope="col">Quantity</th><th scope="col"></th></tr></thead></tbody>';
                    var k = 1;
                    for (var i = 0; i < Stocktransfer_sub_list.length; i++) {
                        if (sno == Stocktransfer_sub_list[i].sno) {
                            results += '<tr><td data-title="Sno">' + k + '</td>';
                            results += '<td><span id="spn_productname">' + Stocktransfer_sub_list[i].productname + '</span><input id="txtproductname" style="display:none" class="productcls"   value="' + Stocktransfer_sub_list[i].productname + '"></td>';
                            results += '<td><span id="spn_perunitrs" style="display:none">' + Stocktransfer_sub_list[i].price + '</span><input id="txt_perunitrs"   data-title="sectionstatus"   class="price" value="' + Stocktransfer_sub_list[i].price + '"></td>';
                            results += '<td><span id="spn_available">' + Stocktransfer_sub_list[i].moniterqty + '</span><input id="txtavailable"  style="display:none" data-title="sectionstatus" readonly class="availablestores" value="' + Stocktransfer_sub_list[i].moniterqty + '"></td>';
                            results += '<td><input id="txt_quantity"  data-title="sectionstatus"  class="4" value="' + Stocktransfer_sub_list[i].quantity + '"></td>';
                            results += '<td><input scope="row" type="hidden" id="txt_stsno" class="8" value="' + Stocktransfer_sub_list[i].stockrefno + '"></td>';
                            results += '<td><data-title="sectionstatus" style="display:none" class="2" value="' + Stocktransfer_sub_list[i].sno + '"></td>';
                            results += '<td><input id="hdnproductsno"  type="hidden"  class="5" value="' + Stocktransfer_sub_list[i].hdnproductsno + '"></td></tr>';
                            k++
                        }
                    }
                    results += '</table></div>';
                    $("#div_SectionData").html(results);
                }
                else {
                    var results = '<div  style="overflow:auto;"><table id="tabledetails" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
                    results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Price</th><th scope="col">Avail Stores</th><th scope="col">Quantity</th><th scope="col">Tax Value</th><th scope="col">Tax Type</th><th scope="col"></th></tr></thead></tbody>';
                    var k = 1;
                    for (var i = 0; i < Stocktransfer_sub_list.length; i++) {
                        if (sno == Stocktransfer_sub_list[i].sno) {
                            results += '<tr><td data-title="Sno">' + k + '</td>';
                            results += '<td><span id="spn_productname">' + Stocktransfer_sub_list[i].productname + '</span><input id="txtproductname" class="productcls"  style="display:none"  value="' + Stocktransfer_sub_list[i].productname + '"></td>';
                            results += '<td><span id="spn_perunitrs"  style="display:none" >' + Stocktransfer_sub_list[i].price + '</span><input id="txt_perunitrs"  data-title="sectionstatus" class="price" value="' + Stocktransfer_sub_list[i].price + '"></td>';
                            results += '<td><span id="spn_available">' + Stocktransfer_sub_list[i].moniterqty + '</span><input id="txtavailable"  data-title="sectionstatus" style="display:none" readonly class="availablestores" value="' + Stocktransfer_sub_list[i].moniterqty + '"></td>';
                            results += '<td><input id="txt_quantity"  data-title="sectionstatus"  class="4" value="' + Stocktransfer_sub_list[i].quantity + '"></td>';
                            results += '<td><input id="txt_Tax" class="clstax" value="' + Stocktransfer_sub_list[i].taxvalue + '"></td>';
                            results += '<td><input id="ddltax" class="Taxtypecls" value="' + Stocktransfer_sub_list[i].taxtype + '"></td>';
                            results += '<td><input scope="row" type="hidden" id="txt_stsno" class="8" value="' + Stocktransfer_sub_list[i].stockrefno + '"></td>';
                            results += '<td><data-title="sectionstatus" style="display:none" class="2" value="' + Stocktransfer_sub_list[i].sno + '"></td>';
                            results += '<td><input id="hdnproductsno"  type="hidden"  class="5" value="' + Stocktransfer_sub_list[i].hdnproductsno + '"></td></tr>';
                            k++
                        }
                    }
                    results += '</table></div>';
                    $("#div_SectionData").html(results);
                }
            }
        }

        function printstock(thisid) {
            var sno = $(thisid).parent().parent().children('.5').html();
            var data = { 'op': 'get_stock_print', 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    window.open("StockTransferReport.aspx", "_self");
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        $(document).click(function () {
            $('#tabledetails').on('change', '.quantity', calTotal)
            //$('#tabledetails').on('change', '.clsfright', calTotal)
            $('#tabledetails').on('change', '.availablestores', calTotal)
            $('#tabledetails').on('change', '.price', calTotal)
            $('#tabledetails').on('change', '.clstax', calTotal)
            //$('#tabledetails').on('change', '.clsed', calTotal)
            $('#tabledetails').on('blur', '.availablestores', calTotal)
            $('#tabledetails').on('change', '.clstotal', calTotal)
        });
        
        function clstotalval() {
            var totaamount = 0; //var totalpfamount = 0;
            $('.clstotal').each(function (i, obj) {
                var totlclass = $(this).html();

                if (totlclass == "" || totlclass == "0") {
                }
                else {
                    totaamount += parseFloat(totlclass);
                }
            });

            var totalamount1 = parseFloat(totaamount);
            var freight = document.getElementById('txt_freight').value;
            var grandtotal = parseFloat(totalamount1) + parseFloat(freight);

            var grandtotal1 = grandtotal.toFixed(2);
            var diff = 0;
            if (grandtotal > grandtotal1) {
                diff = grandtotal - grandtotal1;
            }
            else {
                diff = grandtotal1 - grandtotal;
            }
            document.getElementById('spn_st_amt').innerHTML = grandtotal;
            document.getElementById('spn_roundoffamt').innerHTML = diff;
            document.getElementById('spn_total_amount').innerHTML = grandtotal1;
        }

        var total;
        var tax_type;
        var sum;
        var total_price;
        var tax_amount;
        var tax_amt;
        var tax = "";
        var totaltax = "";
        var fright = 0;
        var fright_amt = 0;
        var price = 0;
        var quantity = 0;
        var avail_st;
        var avail_stores = 0;
        var grandtotal = 0;
        var totaamount = 0;
        function calTotal() {
            var $row = $(this).closest('tr'),
            price = $row.find('.price').val(),
            avail_st = parseFloat($row.find('.availablestores').val()),
            avail_stores = avail_st;
            if (avail_stores <= 0) {
                $row.find('.quantity').val('');
                $row.find('.clstax').val('');
                $row.find('.quantity').prop('disabled', true);
                $row.find('.clstax').prop('disabled', true);
                total_price = 0;
            }
            else {
                $row.find('.quantity').prop('disabled', false);
                $row.find('.clstax').prop('disabled', false);
            }
            quantity = $row.find('.quantity').val(),
            sum = parseFloat(quantity) || 0;
            if (sum > avail_stores) {
                $row.find('.quantity').val('');
                $row.find('.clstax').val('');
                quantity = "0" || 0;
                sum = 0;
                total_price = 0;
            }
            else {
                total_price = sum * price;
                tax = $row.find('.clstax').val(),
                tax_amt = parseFloat(tax) || 0;
                if (tax_amt != 0) {
                    tax_amount = (tax_amt * total_price) / 100 || 0;
                    total_price = total_price + tax_amount;
                }
                total_price = total_price;
            }
            
            $row.find('.clstotal').html(parseFloat(total_price).toFixed(2));
            clstotalval();
        }

        function forclearall() {
            scrollTo(0, 0);
            document.getElementById('ddlfrombranch').selectedIndex = "";
            document.getElementById('slct_branch_type').selectedIndex = 0;
            document.getElementById('txt_tobranch_state').value = "";
            document.getElementById('txtTransport').value = "";
            document.getElementById('txtvehcleno').value = "";
            document.getElementById('txtInvoicedate').value = "";
            document.getElementById('txtInvoiceno').value = "";
            document.getElementById('ddltype').selectedIndex = "";
            document.getElementById('txt_remarks').value = "";
            document.getElementById('txt_freight').value = "";
            document.getElementById('btn_save').innerHTML = "Save";
            document.getElementById('spn_st_amt').innerHTML = "";
            document.getElementById('spn_roundoffamt').innerHTML = "";
            document.getElementById('spn_total_amount').innerHTML = "";
            GetFixedrows();
        }

        function branch_type_operation()
        {
            emptytable1 = [];
            emptytable = [];
            var branch_type = document.getElementById('slct_branch_type').value;
            if (branch_type == "") {
                alert("Select  branch type");
                return false;
            }
            var branch = document.getElementById('ddlfrombranch').value;
            for (var i = 0; i < Branchdata.length; i++)
            {
                if (Branchdata[i].branchid == branch)
                {
                    if (Branchdata[i].fromstate == Branchdata[i].state) {
                        if (Branchdata[i].type == "Inter Branch") {
                            $("#lbl_inv_no").css("display", "none");
                            $("#lbl_bt_no").css("display", "block");
                            $("#lbl_inv_dt").css("display", "none");
                            $("#lbl_bt_dt").css("display", "block");
                            document.getElementById('txtInvoiceno').placeholder = "Enter Branch Transfer Number";
                            var todaydate = today_date.split('-');
                            //var todaydate = "2017-07-17".split('-');
                            var date = "2017-07-01".split('-');
                            var firstDate = new Date();
                            firstDate.setFullYear(todaydate[0], (todaydate[1] - 1), todaydate[2]);
                            var secondDate = new Date();
                            secondDate.setFullYear(date[0], (date[1] - 1), date[2]);

                            if (firstDate < secondDate) {
                                //GetFixedrows1();
                            }
                            else {
                                GetFixedrows();
                            }
                            get_StockTransfer_details();
                            get_productcode();
                        }
                        else {
                            $("#lbl_inv_no").css("display", "block");
                            $("#lbl_bt_no").css("display", "none");
                            $("#lbl_inv_dt").css("display", "block");
                            $("#lbl_bt_dt").css("display", "none");
                            document.getElementById('txtInvoiceno').placeholder = "Enter Invoice Number";
                            GetFixedrows();
                            get_StockTransfer_details();
                            get_productcode();
                        }
                    }
                    else {
                        $("#lbl_inv_no").css("display", "block");
                        $("#lbl_bt_no").css("display", "none");
                        $("#lbl_inv_dt").css("display", "block");
                        $("#lbl_bt_dt").css("display", "none");
                        document.getElementById('txtInvoiceno').placeholder = "Enter Invoice Number";
                        GetFixedrows();
                        get_StockTransfer_details();
                        get_productcode();
                    }
                }
            }
            slct_invoice_branch_trans();
        }

        function slct_invoice_branch_trans()
        {
            var branch_type = document.getElementById('slct_branch_type').value;
            if (branch_type == "") {
                alert("Select  branch type");
                return false;
            }
            var branch = document.getElementById('ddlfrombranch').value;
            for (var i = 0; i < Branchdata.length; i++)
            {
                if (Branchdata[i].branchid == branch)
                {
                    if (Branchdata[i].fromstate == Branchdata[i].state) {
                        var data = document.getElementById('ddltype');
                        var length = data.options.length;
                        document.getElementById('ddltype').options.length = null;
                        var option = document.createElement('option');
                        option.innerHTML = "BranchTransfer";
                        option.value = "BranchTransfer";
                        data.appendChild(option);
                    }
                    else {
                        var data = document.getElementById('ddltype');
                        var length = data.options.length;
                        document.getElementById('ddltype').options.length = null;
                        var option = document.createElement('option');
                        option.innerHTML = "Invoice";
                        option.value = "Invoice";
                        data.appendChild(option);
                    }
                }
            }
            
        }

        function get_tobranch_state()
        {
            var tobranch = document.getElementById('ddlfrombranch').value;
            for (var i = 0; i < Branchdata.length; i++)
            {
                if (tobranch == Branchdata[i].branchid)
                {
                    if (Branchdata[i].gst_no !== "") {
                        document.getElementById('txt_tobranch_state').value = Branchdata[i].state;
                        branch_type_operation();
                    }
                    else {
                        alert("Branch without GSTIN cannot be raised or Update Branch with GSTIN");
                        document.getElementById('txt_tobranch_state').value == "";
                        document.getElementById('ddlfrombranch').selectedIndex = 0;
                        return false;
                    }
                }
            }
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Outward Entry<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Reports</a></li>
            <li><a href="#"> Outward Entry </a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i> Outward Entry
                </h3>
            </div>
            <div class="box-body">
                <div id="showlogs" align="center">
                    <div class="input-group" style="padding-left:88%">
                        <div class="input-group-addon">
                            <span class="glyphicon glyphicon-plus-sign"></span> <span id="add_Stock">Add Outward</span>
                        </div>
                    </div>
                </div>
                <div id="div_stocktransfer" style="padding-top:2px;">
                </div>
                <div id='fillform' style="display: none;">
                    <table align="center">
                        <tr>
                            <td>
                                <label>Branch Type</label><span style="color: red;">*</span>
                            </td>
                            <td>
                                <select id="slct_branch_type" class="form-control" onchange="get_Branch_details();">
                                    <option value="">SELECT TYPE</option>
                                    <option value="Inter Branch">Inter Branch</option>
                                    <option value="Other Branch">Other Branch</option>
                                </select>
                            </td>
                        </tr>
                    </table>
                    <br />
                    <table align="center">
                        <tr>
                            <td style="height: 40px;">
                                <label>Branch Name</label><span style="color: red;">*</span>
                                <select id="ddlfrombranch" class="form-control" onchange="get_tobranch_state()"></select>
                                <input id="txt_tobranch_state" type="text" style="display:none;" />
                            </td>
                            <td style="width:5px"></td>
                            <td style="height: 40px;">
                                <label>Transport Name:</label><span style="color: red;"></span>
                                <input id="txtTransport" type="text" class="form-control" name="Transport" placeholder="Enter Transport Name"/>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>Vehicle Number</label><span style="color: red;"></span>
                                <input id="txtvehcleno" type="text" class="form-control" placeholder="Enter Vehicle Number"
                                    name="Transport" />
                            </td>
                            <td style="width:5px"></td>
                            <td style="height: 40px;">
                                <label>Select Type</label><span style="color: red;"></span>
                                <select id="ddltype" class="form-control"></select>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label id="lbl_inv_no">Invoice Number</label><label id="lbl_bt_no" style="display:none">Branch Transfer Number</label><span style="color: red;"></span>
                                <input id="txtInvoiceno" type="text" class="form-control" name="invoiceno" placeholder="Enter Invoice Number" />
                            </td>
                            <td style="width:5px"></td>
                            <td style="height: 40px;">
                                <label id="lbl_inv_dt">Invoice Date</label><label id="lbl_bt_dt" style="display:none">Branch Transfer Date</label><span style="color: red;">*</span>
                                <div class="input-group date" style="width:100%;">
                                  <div class="input-group-addon cal">
                                    <i class="fa fa-calendar"></i>
                                  </div>
                                  <input id="txtInvoicedate" type="date" class="form-control" placeholder="Enter InvoiceDate"
                                        name="InvoiceDate" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>Freight</label>
                                <input id="txt_freight" type="text" name="freight" class="form-control" placeholder="Enter Freight Amount" onchange="calTotal_gst();" />
                            </td>
                            <td style="width:5px"></td>
                            <td style="height: 40px;">
                                <label>Invoice Type</label><span style="color: red;"></span>
                                <select id="slctinvoicetype" class="form-control">
                                <option value="Select">Select</option>
                                <option value="Taxable">Taxable</option>
                                <option value="NonTaxable">NonTaxable</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" style="height: 40px;">
                                <label>Remarks</label><span style="color: red;"></span>
                                <textarea id="txt_remarks" class="form-control" type="text" rows="3" cols="35" placeholder="Enter Remarks"></textarea>
                            </td>
                        </tr>
                    </table>
                    <br />
                    <div class="box box-info">
                        <div class="box-header with-border">
                            <h3 class="box-title">
                                <i style="padding-right: 5px;" class="fa fa-list"></i>Select Product(s)
                            </h3>
                        </div>
                        <div class="box-body">
                            <div id="div_SectionData">
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
                    <label id="lbl_sno" style="display: none;">
                    </label>
                    <label><b>Amount:</b></label>&nbsp;&nbsp;<span id="spn_st_amt"></span>
                    <br />
                    <label><b>Round off Difference Amount:</b></label>&nbsp;&nbsp;<span id="spn_roundoffamt"></span>
                    <br />
                    <label><b>Total Amount:</b></label>&nbsp;&nbsp;<span id="spn_total_amount"></span>
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
                                        <span class="glyphicon glyphicon-ok" id="btn_save1" onclick="save_stock_transfer_click()"></span> <span id="btn_save" onclick="save_stock_transfer_click()">Save</span>
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