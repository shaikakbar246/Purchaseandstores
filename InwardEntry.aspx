<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true"
    CodeFile="InwardEntry.aspx.cs" Inherits="InwardEntry" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            scrollTo(0, 0);
            $('#add_Inward').click(function () {
                $('#Inward_FillForm').css('display', 'block');
                $('#showlogs').css('display', 'none');
                $('#div_inwardtable').hide();
                Inward_forClearAll();
                get_productcode();
                get_supplier();
                get_TAX();
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
                $('#pandf').css('display', 'none');
                $('#Inward_FillForm').css('display', 'none');
                $('#showlogs').css('display', 'block');
                $('#div_inwardtable').show();
                Inward_forClearAll(); 
                ProductTable = [];
                document.getElementById('txtFrAmt').value = "";
            });
            getcode();
            get_TAX();
            getallinward();
            get_supplier();
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
            today_date = yyyy + '-' + mm + '-' + dd;
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
        function ValidateAlpha(evt) {
            var keyCode = (evt.which) ? evt.which : evt.keyCode
            if ((keyCode < 65 || keyCode > 90) && (keyCode < 97 || keyCode > 123) && keyCode != 32)

                return false;
            return true;
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
        var supperdetails = [];
        function get_supplier() {
            var data = { 'op': 'get_supplier' };
            var s = function (msg) {
                if (msg) {
                    supperdetails = msg;
                    var availableTags = [];
                    for (i = 0; i < msg.length; i++) {
                        availableTags.push(msg[i].name);
                    }
                    $("#txtSuplyname").autocomplete({
                        source: function (req, responseFn) {
                            var re = $.ui.autocomplete.escapeRegex(req.term);
                            var matcher = new RegExp("^" + re, "i");
                            var a = $.grep(availableTags, function (item, index) {
                                return matcher.test(item);
                            });
                            responseFn(a);
                        },
                        change: Getsupplierid,
                        autoFocus: true
                    });
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        function Getsupplierid() {
            var name = document.getElementById('txtSuplyname').value;
            for (var i = 0; i < supperdetails.length; i++) {
                if (name == supperdetails[i].name) {
                    document.getElementById('txtsupid').value = supperdetails[i].supplierid;
                    document.getElementById('txt_sup_state').value = supperdetails[i].state;
                }
            }
        }
        var DataTable;
        var ProductTable = [];
        function barcode() {
            var txtbarcode = document.getElementById('txtSku').value;
            productarray;
            get_productcode();
            get_TAX();
            DummyTable1;
            DataTable = [];
            var rows = $("#tabledetails tr:gt(0)");
            var txtsno = 0;
            var rowsno = 1;
            var taxtype = 0;
            var ed = 0;
            var disamt = 0;
            var dis = 0;
            var tax = 0;
            var edtax = 0;
            $(rows).each(function (i, obj) {
                if ($(this).find('#txtProductname').val() != "") {
                    txtsno = rowsno;
                    productname = $(this).find('#txtProductname').val();
                    uim = $(this).find('#ddlUim').val();
                    PerUnitRs = $(this).find('#txt_perunitrs').val();
                    Quantity = $(this).find('#txt_quantity').val();
                    taxtype = $(this).find('#ddlTaxtype').val();
                    ed = $(this).find('#ddlEd').val();
                    dis = $(this).find('#txtDis').val();
                    disamt = $(this).find('#spn_dis_amt').text();
                    tax = $(this).find('#txtTax').val();
                    edtax = $(this).find('#txtEdtax').val();
                    TotalCost = $(this).find('#spn_total').text();
                    sisno = $(this).find('#subsno').val();
                    hdnproductsno = $(this).find('#hdnproductsno').val();
                    hdnproductcode = $(this).find('#hdnproductcode').val();
                    DataTable.push({ Sno: txtsno, productname: productname, uim: uim, PerUnitRs: PerUnitRs, Quantity: Quantity, TotalCost: TotalCost, hdnproductsno: hdnproductsno, sku: hdnproductcode, taxtype: taxtype, dis: dis, disamt: disamt, ed: ed, tax: tax, edtax: edtax, sisno: sisno });
                    rowsno++;
                }
            });
            var productname = 0;
            var PerUnitRs = 0;
            var Quantity = 0;
            var TotalCost = 0;
            var hdnproductsno = 0;
            var hdnproductcode = 0;
            var sisno = 0;
            var taxtype = 0;
            var ed = 0;
            var disamt = 0;
            var dis = 0;
            var tax = 0;
            var edtax = 0;
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
                            DataTable.push({ Sno: Sno, productname: productname, uim: uim, PerUnitRs: PerUnitRs, Quantity: Quantity, taxtype: taxtype, ed: ed, dis: dis, disamt: disamt, tax: tax, edtax: edtax, TotalCost: TotalCost, hdnproductsno: hdnproductsno, sku: productarray[i].sku, sisno: sisno });
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
                            DataTable.push({ Sno: Sno, productname: productname, uim: uim, PerUnitRs: PerUnitRs, Quantity: Quantity, taxtype: taxtype, ed: ed, dis: dis, disamt: disamt, tax: tax, edtax: edtax, TotalCost: TotalCost, hdnproductsno: hdnproductsno, sku: productarray[i].sku, sisno: sisno });
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
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Quantity</th><th scope="col">UOM</th><th scope="col">Per Unit Rs</th><th scope="col">Dis%</th><th scope="col">Dis Amt</th><th scope="col">Tax Type</th><th scope="col">Tax %</th><th scope="col">ED</th><th scope="col">ED Tax%</th><th scope="col">Total Cost</th><th scope="col"></th></tr></thead></tbody>';
            var j = 1;
            for (var i = 0; i < DataTable.length; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + j + '</td>';
                results += '<td ><span id="spn_Productname">' + DataTable[i].productname + '</span><input id="txtProductname" readonly  class="productcls" style="width:90px;display:none;" value="' + DataTable[i].productname + '"/></td>';
                results += '<td style="display:none;" class="2">' + DataTable[i].productname + '</td>';
                results += '<td ><span style="display:none;" id="spn_quantity">' + DataTable[i].Quantity + '</span><input id="txt_quantity" type="text" class="quantity"  onkeypress="return isFloat(event)" style="width:90px;" value="' + DataTable[i].Quantity + '"/></td>';
                results += '<td ><span id="spn_uim">' + DataTable[i].uim + '</span><input id="ddlUim" type="text" class="uomcls"  onkeypress="return isFloat(event)" style="width:90px;display:none;" value="' + DataTable[i].uim + '"/></td>';
                results += '<td ><span style="display:none;" id="spn_perunitrs">' + DataTable[i].PerUnitRs + '</span><input id="txt_perunitrs" type="text" class="price" readonly  onkeypress="return isFloat(event)" style="width:90px;" value="' + DataTable[i].PerUnitRs + '"/></td>';
                results += '<td ><input id="txtDis" type="text" class="clsdis" style="width:50px;" onkeypress="return isFloat(event)" value="' + DataTable[i].dis + '"/></td>';
                results += '<td ><span id="spn_dis_amt">' + DataTable[i].disamt + '</span><input id="txtDisAmt" type="text" class="clsdisamt" style="width:50px;display:none" onkeypress="return isFloat(event)" value="' + DataTable[i].disamt + '"/></td>';
                results += '<td><select id="ddlTaxtype"  class="Taxtypecls" style="width:90px; value="' + DataTable[i].taxtype + '"/></td>';
                results += '<td ><input id="txtTax" type="text" class="clstax"  style="width:50px;" onkeypress="return isFloat(event)" value="' + DataTable[i].tax + '"/></td>';
                results += '<td ><select id="ddlEd" type="text" class="edcls" style="width:90px;" value="' + DataTable[i].ed + '"/></td>';
                results += '<td ><input id="txtEdtax" type="text" class="clsed"  style="width:50px;" onkeypress="return isFloat(event)" value="' + DataTable[i].edtax + '"/></td>';
                results += '<td ><span id="spn_total">' + DataTable[i].TotalCost + '</span><input id="txtTotal" type="text"  class="clstotal" onkeypress="return isFloat(event)" style="width:90px;display:none;" value="' + DataTable[i].TotalCost + '"/></td>';
                results += '<td style="display:none" ><input id="hdnproductsno" type="hidden" value="' + DataTable[i].hdnproductsno + '"/><input id="hdnproductcode" type="hidden" value="' + DataTable[i].sku + '"/></td>';
                results += '<th style="display:none" data-title="From"><input  id="subsno" type="hidden" name="subsno" value="' + DataTable[i].sisno + '" style="width:90px;" font-size:12px;padding: 0px 5px;height:30px;"></input>';
                results += '<td><span onclick="removerow1(this)"><img src="images/minus.png" style="cursor:pointer"/></span></td>';
                results += '<td style="display:none" class="4">' + i + '</td></tr>';
                j++;
            }
            results += '</table></div>';
            $("#div_InwardProductsData").html(results);
            document.getElementById('txtSku').value = "";
            document.getElementById('txtProductcode').value = "";
        }

        function barcode_gst() {
            var txtbarcode = document.getElementById('txtSku').value;
            var supplier_state = "2";
            if (supplier_state == "")
            {
                alert("Enter Supplier Name");
                document.getElementById('txt_sup_state').focus;
                return false;
            }
            productarray;
            get_productcode();
            get_TAX();
            DummyTable1;
            DataTable = [];
            var rows = $("#tabledetails_gst tr:gt(0)");
            var txtsno = 0;
            var rowsno = 1;
            var taxable = 0;
            var sgst_per = 0;
            var cgst_per = 0;
            var igst_per = 0;
            var disamt = 0;
            var dis = 0;
            $(rows).each(function (i, obj) {
                if ($(this).find('#txtProductname').val() != "") {
                    txtsno = rowsno;
                    productname = $(this).find('#txtProductname').val();
                    uim = $(this).find('#ddlUim').val();
                    PerUnitRs = $(this).find('#txt_perunitrs').val();
                    Quantity = $(this).find('#txt_quantity').val();
                    dis = $(this).find('#txtDis').val();
                    disamt = $(this).find('#spn_dis_amt').text();
                    taxable = $(this).find('#txt_taxable').val();
                    sgst_per = $(this).find('#txt_sgst_per').val();
                    cgst_per = $(this).find('#txt_cgst_per').val();
                    igst_per = $(this).find('#txt_igst_per').val();
                    TotalCost = $(this).find('#spn_total').text();
                    sisno = $(this).find('#subsno').val();
                    hdnproductsno = $(this).find('#hdnproductsno').val();
                    hdnproductcode = $(this).find('#hdnproductcode').val();
                    DataTable.push({ Sno: txtsno, productname: productname, uim: uim, PerUnitRs: PerUnitRs, Quantity: Quantity, TotalCost: TotalCost, hdnproductsno: hdnproductsno, sku: hdnproductcode, dis: dis, disamt: disamt, taxable: taxable, sgst_per: sgst_per, cgst_per: cgst_per, igst_per: igst_per, sisno: sisno });
                    rowsno++;
                }
            });
            var productname = 0;
            var PerUnitRs = 0;
            var Quantity = 0;
            var TotalCost = 0;
            var hdnproductsno = 0;
            var hdnproductcode = 0;
            var sisno = 0;
            var disamt = 0;
            var dis = 0;
            var sgst_per = 0;
            var cgst_per = 0;
            var igst_per = 0;
            var uim = 0;
            var Sno = parseInt(txtsno) + 1;
            if (txtbarcode != "") {
                if (ProductTable.indexOf(txtbarcode) == -1) {
                    for (var i = 0; i < productarray.length; i++) {
                        if (txtbarcode == productarray[i].sku) {
                            if (productarray[i].hsn_code != "") {
                                if (productarray[i].igst != "") {
                                    productname = productarray[i].productname;
                                    hdnproductsno = productarray[i].productid;
                                    uim = productarray[i].uim;
                                    PerUnitRs = productarray[i].price;
                                    var branch_state = productarray[i].state;
                                    if (supplier_state != branch_state) {
                                        igst_per = productarray[i].igst;
                                        sgst_per = 0;
                                        cgst_per = 0;
                                    }
                                    else {
                                        sgst_per = productarray[i].sgst;
                                        cgst_per = productarray[i].cgst;
                                        igst_per = 0;
                                    }
                                    DataTable.push({ Sno: Sno, productname: productname, uim: uim, PerUnitRs: PerUnitRs, Quantity: Quantity, dis: dis, disamt: disamt, taxable: taxable, sgst_per: sgst_per, cgst_per: cgst_per, igst_per: igst_per, TotalCost: TotalCost, hdnproductsno: hdnproductsno, sku: productarray[i].sku, sisno: sisno });
                                    ProductTable.push(txtbarcode);
                                }
                                else {
                                    alert("Product without IGST or CGST or SGST cannot be added, Please update Product with IGST or CGST or SGST");
                                    return false;
                                }
                            }
                            else {
                                alert("Product without HSN CODE cannot be added, Please update Product with HSN CODE");
                                return false;
                            }
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
                            if (productarray[i].hsn_code != "") {
                                if (productarray[i].igst != "")
                                {
                                    hdnproductsno = productarray[i].productid;
                                    productname = productarray[i].productname;
                                    uim = productarray[i].uim;
                                    PerUnitRs = productarray[i].price;
                                    var branch_state = productarray[i].state;
                                    if (supplier_state != branch_state) {
                                        igst_per = productarray[i].igst;
                                        sgst_per = 0;
                                        cgst_per = 0;
                                    }
                                    else {
                                        sgst_per = productarray[i].sgst;
                                        cgst_per = productarray[i].cgst;
                                        igst_per = 0;
                                    }
                                    DataTable.push({ Sno: Sno, productname: productname, uim: uim, PerUnitRs: PerUnitRs, Quantity: Quantity, dis: dis, disamt: disamt, taxable: taxable, sgst_per: sgst_per, cgst_per: cgst_per, igst_per: igst_per, TotalCost: TotalCost, hdnproductsno: hdnproductsno, sku: productarray[i].sku, sisno: sisno });
                                    ProductTable.push(productname);
                                }
                                else {
                                    alert("Product without IGST or CGST or SGST cannot be added, Please update Product with IGST or CGST or SGST");
                                    return false;
                                }
                            }
                            else {
                                alert("Product without HSN CODE cannot be added, Please update Product with HSN CODE");
                                return false;
                            }
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
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails_gst">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Quantity</th><th scope="col">UOM</th><th scope="col">Per Unit Rs</th><th scope="col">Dis %</th><th scope="col">Dis Amt</th><th scope="col">Taxable</th><th scope="col">SGST %</th><th scope="col">CGST %</th><th scope="col">IGST %</th><th scope="col">Total Cost</th><th scope="col"></th></tr></thead></tbody>';
            var j = 1;
            for (var i = 0; i < DataTable.length; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + j + '</td>';
                results += '<td ><span id="spn_Productname">' + DataTable[i].productname + '</span><input id="txtProductname" readonly  class="productcls" style="width:90px;display:none;" value="' + DataTable[i].productname + '"/></td>';
                results += '<td style="display:none;" class="2">' + DataTable[i].productname + '</td>';
                results += '<td ><span style="display:none;" id="spn_quantity">' + DataTable[i].Quantity + '</span><input id="txt_quantity" type="text" class="quantity"  onkeypress="return isFloat(event)" style="width:100%;" value="' + DataTable[i].Quantity + '"/></td>';
                results += '<td ><span id="spn_uim">' + DataTable[i].uim + '</span><input id="ddlUim" type="text" class="uomcls"  onkeypress="return isFloat(event)" style="width:90px;display:none;" value="' + DataTable[i].uim + '"/></td>';
                results += '<td ><span style="display:none;" id="spn_perunitrs">' + DataTable[i].PerUnitRs + '</span><input id="txt_perunitrs" type="text" class="price" readonly  onkeypress="return isFloat(event)" style="width:90px;" value="' + DataTable[i].PerUnitRs + '"/></td>';
                results += '<td ><input id="txtDis" type="text" class="clsdis" style="width:50px;" onkeypress="return isFloat(event)" value="' + DataTable[i].dis + '"/></td>';
                results += '<td ><span id="spn_dis_amt">' + DataTable[i].disamt + '</span><input id="txtDisAmt" type="text" class="clsdisamt" style="width:50px;display:none" onkeypress="return isFloat(event)" value="' + DataTable[i].disamt + '"/></td>';
                results += '<td ><span id="spn_taxable"></span><input id="txt_taxable" class="cls_taxable" name="taxable" style="display:none;" /></td>';//' + taxable + '
                results += '<td ><span id="spn_sgst_per">' + DataTable[i].sgst_per + '</span><input id="txt_sgst_per" readonly class="cls_sgst_per" name="sgst_per" style="width:55px;display:none;" value="' + DataTable[i].sgst_per + '" /></td>';
                results += '<td ><span id="spn_cgst_per">' + DataTable[i].cgst_per + '</span><input id="txt_cgst_per" readonly class="cls_cgst_per" name="cgst_per" style="width:55px;display:none;" value="' + DataTable[i].cgst_per + '" /></td>';
                results += '<td ><span id="spn_igst_per">' + DataTable[i].igst_per + '</span><input id="txt_igst_per" readonly class="cls_igst_per" name="igst_per" style="width:55px;display:none;" value="' + DataTable[i].igst_per + '" /></td>';
                results += '<td ><span id="spn_total">' + DataTable[i].TotalCost + '</span><input id="txtTotal" type="text"  class="clstotal_gst" onkeypress="return isFloat(event)" style="width:90px;display:none;" value="' + DataTable[i].TotalCost + '"/></td>';
                results += '<td style="display:none" ><input id="hdnproductsno" type="hidden" value="' + DataTable[i].hdnproductsno + '"/><input id="hdnproductcode" type="hidden" value="' + DataTable[i].sku + '"/></td>';
                results += '<th style="display:none" data-title="From"><input  id="subsno" type="hidden" name="subsno" value="' + DataTable[i].sisno + '" style="width:90px;" font-size:12px;padding: 0px 5px;height:30px;"></input>';
                results += '<td><span onclick="removerow1(this)"><img src="images/minus.png" style="cursor:pointer"/></span></td>';
                results += '<td style="display:none" class="4">' + i + '</td></tr>';
                j++;
            }
            results += '</table></div>';
            $("#div_InwardProductsData").html(results);
            document.getElementById('txtSku').value = "";
            document.getElementById('txtProductcode').value = "";
        }

        var TAX_Types = [];
        function get_TAX() {
            var data = { 'op': 'get_TAX' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillTax(msg);
                        fillED(msg);
                        TAX_Types = msg;
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
        function fillTax(msg) {
            $('.Taxtypecls').each(function () {
                var taxtype = $(this);
                taxtype[0].options.length = null;
                for (var i = 0; i < msg.length; i++) {
                    if (msg[i].type != null) {
                        if (msg[i].taxtype == "Tax") {
                            var option = document.createElement('option');
                            option.innerHTML = msg[i].type;
                            option.value = msg[i].sno;
                            taxtype[0].appendChild(option);
                        }
                    }
                }
            });
        }
        function fillED(msg) {
            $('.edcls').each(function () {
                var ed = $(this);
                ed[0].options.length = null;
                for (var i = 0; i < msg.length; i++) {
                    if (msg[i].type != null) {
                        if (msg[i].taxtype == "ExchangeDuty") {
                            var option = document.createElement('option');
                            option.innerHTML = msg[i].type;
                            option.value = msg[i].sno;
                            ed[0].appendChild(option);
                        }
                    }
                }
            });
        }

        var DummyTable1 = [];
        function removerow(thisid) {
            get_TAX();
            DataTable = [];
            ProductTable = [];
            var rows = $("#tabledetails tr:gt(0)");
            $(rows).each(function (i, obj) {
                if ($(this).find('#txtProductname').val() != "") {
                    txtsno = rowsno;
                    var productname = $(this).find('#txtProductname').val();
                    var PerUnitRs = $(this).find('#txt_perunitrs').val();
                    uim = $(this).find('#ddlUim').val();
                    var Quantity = $(this).find('#txt_quantity').val();
                    var taxtype = $(this).find('#ddlTaxtype').val();
                    var ed = $(this).find('#ddlEd').val();
                    var dis = $(this).find('#txtDis').val();
                    var disamt = $(this).find('#spn_dis_amt').text();
                    var tax = $(this).find('#txtTax').val();
                    var edtax = $(this).find('#txtEdtax').val();
                    var TotalCost = $(this).find('#spn_total').text();
                    var sisno = $(this).find('#subsno').val();
                    var hdnproductsno = $(this).find('#hdnproductsno').val();
                    var hdnproductcode = $(this).find('#hdnproductcode').val();
                    DataTable.push({ Sno: txtsno, productname: productname, PerUnitRs: PerUnitRs, uim: uim, Quantity: Quantity, taxtype: taxtype, ed: ed, dis: dis, disamt: disamt, tax: tax, edtax: edtax, TotalCost: TotalCost, hdnproductsno: hdnproductsno, sku: hdnproductcode });
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
                    var taxtype = DataTable[i].taxtype;
                    var ed = DataTable[i].ed;
                    var dis = DataTable[i].dis;
                    var disamt = DataTable[i].disamt;
                    var tax = DataTable[i].tax;
                    var edtax = DataTable[i].edtax;
                    var Quantity = DataTable[i].Quantity;
                    var TotalCost = DataTable[i].TotalCost;
                    var sisno = "0";
                    var hdnproductsno = DataTable[i].hdnproductsno;
                    var hdnproductcode = DataTable[i].sku;
                    DummyTable1.push({ Sno: txtsno, productname: productname, PerUnitRs: PerUnitRs, uim: uim, Quantity: Quantity, taxtype: taxtype, ed: ed, dis: dis, disamt: disamt, tax: tax, edtax: edtax, TotalCost: TotalCost, hdnproductsno: hdnproductsno, sku: hdnproductcode });
                    ProductTable.push(hdnproductcode);
                }
            }
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col" >Product Name</th><th scope="col">Quantity</th><th scope="col">UOM</th><th scope="col">Per Unit Rs</th><th scope="col">Dis%</th><th scope="col">Dis Amt</th><th scope="col">Tax Type</th><th scope="col">Tax %</th><th scope="col">ED</th><th scope="col">ED Tax%</th><th scope="col">Total Cost</th><th scope="col"></th></tr></thead></tbody>';
            var j = 1;
            for (var i = 0; i < DummyTable1.length; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + j + '</td>';
                results += '<td ><span id="spn_Productname">' + DummyTable1[i].productname + '</span><input id="txtProductname" readonly   class="productcls" style="width:90px;display:none" value="' + DummyTable1[i].productname + '"/></td>';
                results += '<td style="display:none;" class="2">' + DummyTable1[i].productname + '</td>';
                results += '<td ><span id="spn_quantity">' + DummyTable1[i].Quantity + '</span><input id="txt_quantity" type="text" class="quantity"  onkeypress="return isFloat(event)" style="width:90px;display:none" value="' + DummyTable1[i].Quantity + '"/></td>';
                results += '<td ><span id="spn_uim">' + DummyTable1[i].uim + '</span><input id="ddlUim" type="text" class="uomcls"  onkeypress="return isFloat(event)" style="width:90pxdisplay:none;" value="' + DummyTable1[i].uim + '"/></td>';
                results += '<td ><span id="spn_perunitrs">' + DummyTable1[i].PerUnitRs + '</span><input id="txt_perunitrs" type="text" class="price" readonly onkeypress="return isFloat(event)" style="width:90px;display:none" value="' + DummyTable1[i].PerUnitRs + '"/></td>';
                results += '<td ><input id="txtDis" type="text" class="clsdis" style="width:50px;" onkeypress="return isFloat(event)" value="' + DummyTable1[i].dis + '"/></td>';
                results += '<td ><span id="spn_dis_amt">' + DummyTable1[i].disamt + '</span><input id="txtDisAmt" type="text" class="clsdisamt" style="width:50px;display:none;" onkeypress="return isFloat(event)" value="' + DummyTable1[i].disamt + '"/></td>';
                results += '<td><select type="text" id="ddlTaxtype"  class="Taxtypecls" style="width:90px;" value="' + DummyTable1[i].taxtype + '"></select></td>';
                results += '<td ><input id="txtTax" type="text" class="clstax"  style="width:50px;" onkeypress="return isFloat(event)" value="' + DummyTable1[i].tax + '"/></td>';
                results += '<td ><select type="text" id="ddlEd" type="text" class="edcls" style="width:90px;" value="' + DummyTable1[i].ed + '"></select></td>';
                results += '<td ><input id="txtEdtax" type="text" class="clsed"  style="width:50px;" onkeypress="return isFloat(event)" value="' + DummyTable1[i].edtax + '"/></td>';
                results += '<td ><span id="spn_total">' + DummyTable1[i].TotalCost + '</span><input id="txtTotal" type="text"  class="clstotal"  onkeypress="return isFloat(event)" style="width:90px;display:none;" value="' + DummyTable1[i].TotalCost + '"/></td>';
                results += '<td style="display:none"><input id="hdnproductsno" type="hidden" value="' + DummyTable1[i].hdnproductsno + '"/><input id="hdnproductcode" type="hidden" value="' + DummyTable1[i].sku + '"/></td>';
                results += '<td onclick="removerow(this)"><span><img src="images/minus.png" style="cursor:pointer"/></span></td>';
                results += '<td style="display:none" class="4">' + i + '</td></tr>';
                j++;
            }
            results += '</table></div>';
            $("#div_InwardProductsData").html(results);
            clstotalval();
        }
        var replaceHtmlEntites = (function () {
            return function (s) {
                return (s.replace(translate_re, function (match, entity) {
                    return translate[entity];
                }));
            }
        })();
        
        function ponumber(txt_pono) {
            var pono = document.getElementById('txt_pono').value;
            if (pono != "") {
                var data = { 'op': 'get_purchaserOrder_details_inward', 'pono': pono };
                var s = function (msg) {
                    if (msg) {
                        if (msg.length > 0) {
                            var podetails = msg[0].podetails;
                            if (podetails.length > 0) {
                                document.getElementById('txtpf').value = "";
                                document.getElementById('txtFrAmt').value = "";
                                fillproductdetails(msg);
                            }
                            else {
                                alert("Please Approve The Po");
                                return false;
                            }
                        }
                        else {
                            
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
        var po_subdetails;
        function fillproductdetails(msg) {
            var todaydate = today_date.split('-');
            var date = "2017-07-01".split('-');

            var firstDate = new Date();
            firstDate.setFullYear(todaydate[0], (todaydate[1] - 1), todaydate[2]);
            var secondDate = new Date();
            secondDate.setFullYear(date[0], (date[1] - 1), date[2]);

            var total_inward_amount = 0;
            po_subdetails = msg[0].subpurchasedetails;
            var podetails = msg[0].podetails;
            document.getElementById('txt_rev_chrg').value = podetails[0].rev_chrg;
            var rev_chrg = podetails[0].rev_chrg;
            document.getElementById('txtSuplyname').value = podetails[0].suppliername;
            document.getElementById('txtsupid').value = podetails[0].supplierid;
            var freigntamt = podetails[0].freigntamt;
            var transport_charges = podetails[0].transport_charges;
            var paymenttype = podetails[0].paymenttype;
            var pf = podetails[0].pf;
            var sup_state = podetails[0].supplierstate;
            var branch_state = podetails[0].branchstate;
            document.getElementById('txtInwardAmount').innerHTML = podetails[0].poamount;
            document.getElementById('txtpaymenttype').value = paymenttype;
            if (pf != "") {
                document.getElementById('txtpf').value = pf;
                $('#pandf').css('display', 'block');
            }
            if (freigntamt != "") {
                document.getElementById('txtFrAmt').value = freigntamt;
            }
            if (transport_charges != "")
            {
                document.getElementById('txtTransportCharge').value = transport_charges;
            }
            var pono = document.getElementById('txt_pono').value;
            var gst_exists = po_subdetails[0].gst_exists;
            if (gst_exists == "1") {
                var results = '<div  style="overflow:auto;"><table ID="tabledetails_gst" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" >';
                results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Quantity</th><th scope="col">UOM</th><th scope="col">Per Unit Rs</th><th scope="col">Dis %</th><th scope="col">Dis Amt</th><th scope="col">Taxable Amount</th><th scope="col">SGST %</th><th scope="col">CGST %</th><th scope="col">IGST %</th><th scope="col">Total Amount</th><th scope="col"></th></tr></thead></tbody>';
                var p = 1;
                for (var j = 0; j < podetails.length; j++) {
                    if (pono == podetails[j].pono) {
                        document.getElementById('txt_podate').value = podetails[j].podate;
                        for (var i = 0; i < po_subdetails.length; i++) {
                            results += '<tr><td data-title="Sno" class="1">' + p + '</td>';
                            results += '<td class="tdmaincls"><span id="spn_Productname">' + po_subdetails[i].description + '</span><input id="txtProductname" readonly class="productcls"  name="productname" value="' + po_subdetails[i].description + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;display:none;"></input></td>';
                            results += '<td style="display:none;" class="2">' + po_subdetails[i].description + '</td>';
                            results += '<td class="tdmaincls"><span id="spn_quantity" style="display:none;">' + po_subdetails[i].qty + '</span><input class="quantity"  id="txt_quantity" onkeypress="return isFloat(event)" name="Quantity" value="' + po_subdetails[i].qty + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                            results += '<td class="tdmaincls"><span id="spn_uim">' + po_subdetails[i].uim + '</span><input class="uomcls"  id="ddlUim" onkeypress="return isFloat(event)" name="Quantity" value="' + po_subdetails[i].uim + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;display:none;"></input></td>';
                            results += '<td class="tdmaincls"><span id="spn_perunitrs">' + po_subdetails[i].cost + '</span><input class="price" id="txt_perunitrs" readonly name="PerUnitRs" onkeypress="return isFloat(event)"  value="' + po_subdetails[i].cost + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;display:none;"></input></td>';
                            results += '<td ><span id="spn_dis">' + po_subdetails[i].dis + '</span><input id="txtDis" name="dis" class="clsdis" value="' + po_subdetails[i].dis + '" onkeypress="return isFloat(event)"  style="width:100%;display:none; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                            var quantity = parseFloat(po_subdetails[i].qty);
                            var price = parseFloat(po_subdetails[i].cost);
                            var cost = (quantity * price);
                            var discount_per = parseFloat(po_subdetails[i].dis);
                            var discount_amt = parseFloat(po_subdetails[i].disamt); //(cost * discount_per) / 100 || 0;
                            var costafterdiscount = cost - discount_amt;
                            var pf_per = parseFloat(podetails[j].pf);
                            var pf_amt = (costafterdiscount * pf_per) / 100 || 0;
                            var taxable = costafterdiscount + pf_amt;
                            results += '<td ><span id="spn_dis_amt">' + po_subdetails[i].disamt + '</span><input id="txtDisAmt" class="clsdisamt" name="disamt" value="' + po_subdetails[i].disamt + '" onkeypress="return isFloat(event)" style="width:60px; font-size:12px;padding: 0px 5px;height:30px;display:none;"></td>';
                            results += '<td ><span id="spn_taxable">' + taxable + '</span><input id="txt_taxable" class="cls_taxable" name="taxable" value="' + taxable + '" style="display:none;" /></td>';//' + taxable + '
                            var sgst_per = 0, cgst_per = 0, igst_per = 0;
                            igst_per = parseFloat(po_subdetails[i].igst_per);
                            sgst_per = parseFloat(po_subdetails[i].sgst_per);
                            cgst_per = parseFloat(po_subdetails[i].cgst_per);
                            results += '<td ><span id="spn_sgst_per">' + sgst_per + '</span><input id="txt_sgst_per" class="cls_sgst_per" name="sgst_per" value="' + sgst_per + '" style="display:none;" /></td>';
                            results += '<td ><span id="spn_cgst_per">' + cgst_per + '</span><input id="txt_cgst_per" class="cls_cgst_per" name="cgst_per" value="' + cgst_per + '" style="display:none;" /></td>';
                            results += '<td ><span id="spn_igst_per">' + igst_per + '</span><input id="txt_igst_per" class="cls_igst_per" name="igst_per" value="' + igst_per + '" style="display:none;" /></td>';
                            var sgst_amt = (taxable * sgst_per) / 100 || 0;
                            var cgst_amt = (taxable * cgst_per) / 100 || 0;
                            var igst_amt = (taxable * igst_per) / 100 || 0;
                            var productamount = 0;
                            if (rev_chrg == "N") {
                                productamount = taxable + sgst_amt + cgst_amt + igst_amt;
                            }
                            else if(rev_chrg=="Y") {
                                productamount = taxable;
                            }
                            else {
                                productamount = taxable + sgst_amt + cgst_amt + igst_amt;
                            }
                            total_inward_amount += productamount;
                            results += '<td class="tdmaincls"><span id="spn_total">' + productamount.toFixed(2) + '</span><input class="clstotal_gst"  id="txtTotal" onkeypress="return isFloat(event)" name="TotalCost" value="' + productamount.toFixed(2) + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;display:none;"></input></td>';//' + productamount + '
                            results += '<th style="display:none;"><input class="5" id="hdnproductsno" type="hidden" name="hdnproductsno" value="' + po_subdetails[i].hdnproductsno + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input>';
                            results += '<td><span onclick="removerow1(this)"><img src="images/minus.png" style="cursor:pointer"/></span></td>';
                            results += '<td style="display:none;" class="6">' + i + '</td></tr>';
                            p++;
                        }
                    }
                }
                results += '</table></div>';
                $("#div_InwardProductsData").html(results);
                clstotalval_gst();
            }
            else {
                var results = '<div  style="overflow:auto;"><table ID="tabledetails" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" >';
                results += '<thead><tr><th scope="col">Sno</th><th scope="col" >Product Name</th><th scope="col">Quantity</th><th scope="col">UOM</th><th scope="col">Per Unit Rs</th><th scope="col">Dis%</th><th scope="col">Dis Amt</th><th scope="col">Tax Type</th><th scope="col">Tax %</th><th scope="col">ED</th><th scope="col">ED Tax%</th><th scope="col">Total Cost</th><th scope="col"></th></tr></thead></tbody>';
                var p = 1;
                for (var i = 0; i < podetails.length; i++) {
                    if (pono == podetails[i].pono) {
                        document.getElementById('txt_podate').value = podetails[i].podate;
                        for (var i = 0; i < po_subdetails.length; i++) {
                            results += '<tr><td data-title="Sno" class="1">' + p + '</td>';
                            results += '<th ><span id="spn_Productname">' + po_subdetails[i].description + '</span><input id="txtProductname" readonly class="productcls"  name="productname" value="' + po_subdetails[i].description + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;display:none;"></input></td>';
                            results += '<td style="display:none;" class="2">' + po_subdetails[i].description + '</td>';
                            results += '<th ><span id="spn_quantity" style="display:none;">' + po_subdetails[i].qty + '</span><input class="quantity"  id="txt_quantity" onkeypress="return isFloat(event)" name="Quantity" value="' + po_subdetails[i].qty + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;display:none;"></input></td>';
                            results += '<th ><span id="spn_uim">' + po_subdetails[i].uim + '</span><input class="uomcls"  id="ddlUim" onkeypress="return isFloat(event)" name="Quantity" value="' + po_subdetails[i].uim + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;display:none;"></input></td>';
                            results += '<th ><span id="spn_perunitrs">' + po_subdetails[i].cost + '</span><input class="price" id="txt_perunitrs" readonly name="PerUnitRs" onkeypress="return isFloat(event)"  value="' + po_subdetails[i].cost + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;display:none;"></input></td>';
                            results += '<td ><input id="txtDis" name="dis" class="clsdis" value="' + po_subdetails[i].dis + '" onkeypress="return isFloat(event)"  style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                            results += '<td ><span id="spn_dis_amt">' + po_subdetails[i].disamt + '</span><input id="txtDisAmt" class="clsdisamt" name="disamt" value="' + po_subdetails[i].disamt + '" onkeypress="return isFloat(event)" style="width:60px; font-size:12px;padding: 0px 5px;height:30px;display:none;"></td>';
                            results += '<td ><input id="ddlTaxtype" class="Taxtypecls" name="taxtype"   value="' + po_subdetails[i].taxtype + '"  style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></select></td>';
                            results += '<td ><input  id="txtTax" class="clstax"  name="tax" value="' + po_subdetails[i].tax + '" onkeypress="return isFloat(event)" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                            results += '<td ><input id="ddlEd" class="edcls"  name="ed"  value="' + po_subdetails[i].ed + '"  style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></select></td>';
                            results += '<td ><input  id="txtEdtax" name="edtax" class="clsed" value="' + po_subdetails[i].edtax + '" onkeypress="return isFloat(event)" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                            results += '<th ><span id="spn_total">' + po_subdetails[i].productamount + '</span><input class="clstotal"  id="txtTotal" onkeypress="return isFloat(event)" name="TotalCost" value="' + po_subdetails[i].productamount + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;display:none;"></input></td>';
                            results += '<th style="display:none;"><input class="5" id="hdnproductsno" type="hidden" name="hdnproductsno" value="' + po_subdetails[i].hdnproductsno + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input>';
                            results += '<td><span onclick="removerow1(this)"><img src="images/minus.png" style="cursor:pointer"/></span></td>';
                            results += '<td style="display:none;" class="6">' + i + '</td></tr>';
                            p++;
                        }
                    }
                }
                results += '</table></div>';
                $("#div_InwardProductsData").html(results);
            }
        }
        function getcode() {
            var data = { 'op': 'get_purchase_details' };
            var s = function (msg) {
                if (msg) {
                    var availableTags = [];
                    for (i = 0; i < msg.length; i++) {
                        availableTags.push(msg[i].pono);
                    }
                    $("#txt_pono").autocomplete({
                        source: function (req, responseFn) {
                            var re = $.ui.autocomplete.escapeRegex(req.term);
                            var matcher = new RegExp("^" + re, "i");
                            var a = $.grep(availableTags, function (item, index) {
                                return matcher.test(item);
                            });
                            responseFn(a);
                        },
                        autoFocus: true
                    });
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }

        var DataTable;
        function removerow1(thisid) {
            $(thisid).parents('tr').remove();
            clstotalval();
        }
        function save_edit_Inward() {
            var todaydate = today_date.split('-');
            //var todaydate = "2017-07-17".split('-');
            var date = "2017-07-01".split('-');
            var firstDate = new Date();
            var secondDate = new Date();
            var pono = document.getElementById('txt_pono').value;
            if (pono == "") {
                alert("With out PO Number Can not be Possible raise MRN Entry");
                return false;
            }
            var inwarddate = document.getElementById('txt_inwarddate').value;
            var invoiceno = document.getElementById('txt_invoice').value;
            var invoicedate = document.getElementById('txt_invoicedate').value;
            var dcno = document.getElementById('txt_dcno').value;
            var lrno = document.getElementById('txt_lrno').value;
            var inwardamount = document.getElementById('txtInwardAmount').innerHTML;
            var podate = document.getElementById('txt_podate').value;
            var freigtamt = document.getElementById('txtFrAmt').value;
            //var indentno = document.getElementById('txt_indentnumber').value;
            var remarks = document.getElementById('txt_remarks').value;
            var modeofinward = document.getElementById('slct_mdeofinwrd').value;
            var securityno = document.getElementById('txtsecurenum').value;
            var transportname = document.getElementById('txttransportname').value;
            var vehicleno = document.getElementById('txtvehiclenumber').value;
            var sno = document.getElementById('lbl_sno').value;
            var pfid = document.getElementById('txtpf').value;
            var hiddensupplyid = document.getElementById('txtsupid').value;
            var btnval = document.getElementById('btn_RaisePO').innerHTML;
            if (btnval == "Save") {
                firstDate.setFullYear(todaydate[0], (todaydate[1] - 1), todaydate[2]);
                secondDate.setFullYear(date[0], (date[1] - 1), date[2]);
            }
            else {
                var inwarddate1 = inwarddate.split('-');
                firstDate.setFullYear(inwarddate1[0], (inwarddate1[1] - 1), inwarddate1[2]);
                secondDate.setFullYear(date[0], (date[1] - 1), date[2]);
            }
            var transport = document.getElementById('txtTransportCharge').value;
            var paymenttype = document.getElementById('txtpaymenttype').value;
            var rev_chrg = document.getElementById('txt_rev_chrg').value;
            var stocksno = 0;
            if (inwarddate == "") {
                alert("Select inwarddate");
                return false;
            }
            if (dcno == "") {
                alert("Enter DC Number");
                return false;
            }
            var fillitems = [];
            if (firstDate < secondDate) {
                $('#tabledetails> tbody > tr').each(function () {
                    var txtsno = $(this).find('#txtSno').text();
                    var productname = $(this).find('#txtProductname').val();
                    var PerUnitRs = $(this).find('#txt_perunitrs').val();
                    var Quantity = $(this).find('#txt_quantity').val();
                    var taxtype = $(this).find('#ddlTaxtype').val();
                    var ed = $(this).find('#ddlEd').val();
                    var dis = $(this).find('#txtDis').val();
                    var disamt = $(this).find('#spn_dis_amt').text();
                    var tax = $(this).find('#txtTax').val();
                    var edtax = $(this).find('#txtEdtax').val();
                    var TotalCost = $(this).find('#spn_total').text();
                    var sisno = $(this).find('#subsno').val();
                    var sno = $(this).find('#txt_sub_sno').val();
                    var hdnproductsno = $(this).find('#hdnproductsno').val();
                    if (hdnproductsno == "" || hdnproductsno == "0") {
                    }
                    else {
                        fillitems.push({
                            'txtsno': txtsno, 'productname': productname, 'PerUnitRs': PerUnitRs, 'Quantity': Quantity, 'dis': dis, 'disamt': disamt, 'taxtype': taxtype, 'ed': ed, 'tax': tax, 'edtax': edtax, 'igst_per': "0", 'cgst_per': "0", 'sgst_per': "0", 'TotalCost': TotalCost, 'hdnproductsno': hdnproductsno, 'sisno': sisno
                        });
                    }
                });
            }
            else {
                $('#tabledetails_gst> tbody > tr').each(function () {
                    var txtsno = $(this).find('#txtSno').text();
                    var productname = $(this).find('#txtProductname').val();
                    var PerUnitRs = $(this).find('#txt_perunitrs').val();
                    var Quantity = $(this).find('#txt_quantity').val();
                    var dis = $(this).find('#txtDis').val();
                    var disamt = $(this).find('#spn_dis_amt').text();
                    var sgst = $(this).find('#txt_sgst_per').val();
                    var cgst = $(this).find('#txt_cgst_per').val();
                    var igst = $(this).find('#txt_igst_per').val();
                    var TotalCost = $(this).find('#spn_total').text();
                    var sisno = $(this).find('#subsno').val();
                    var sno = $(this).find('#txt_sub_sno').val();
                    var hdnproductsno = $(this).find('#hdnproductsno').val();
                    if (hdnproductsno == "" || hdnproductsno == "0") {
                    }
                    else {
                        fillitems.push({
                            'txtsno': txtsno, 'productname': productname, 'PerUnitRs': PerUnitRs, 'Quantity': Quantity, 'dis': dis, 'disamt': disamt, 'taxtype': "", 'ed': "", 'tax': "0", 'edtax': "0", 'igst_per': igst, 'cgst_per': cgst, 'sgst_per': cgst, 'TotalCost': TotalCost, 'hdnproductsno': hdnproductsno, 'sisno': sisno
                        });
                    }
                });
            }
            
            if (fillitems.length == 0) {
                alert("Please Select Product Names");
                return false;
            }
            var Data = { 'op': 'save_edit_Inward', 'inwarddate': inwarddate, 'rev_chrg': rev_chrg, 'inwardamount': inwardamount, 'transport': transport, 'invoiceno': invoiceno, 'invoicedate': invoicedate, 'dcno': dcno, 'lrno': lrno, 'podate': podate, 'remarks': remarks, 'sno': sno, 'pono': pono, 'securityno': securityno, 'transportname': transportname, 'vehicleno': vehicleno, 'hiddensupplyid': hiddensupplyid, 'modeofinward': modeofinward, 'btnval': btnval, 'freigtamt': freigtamt, 'pfid': pfid, 'fillitems': fillitems, 'paymenttype': paymenttype, 'stocksno': stocksno }; //, 'indentno': indentno
            var s = function (msg) {
                if (msg) {
                    if (msg == "You Dont Have Permission This Date") {
                        alert(msg);
                        return false;
                    }
                    else {
                        alert(msg);
                        Inward_forClearAll();
                        getallinward();
                        $('#Inward_FillForm').css('display', 'none');
                        $('#showlogs').css('display', 'block');
                        $('#div_inwardtable').show();
                    }
                }
            }
            var e = function (x, h, e) {
            };
            CallHandlerUsingJson(Data, s, e);
        }
        function clstotalval() {
            var totaamount = 0; var totalpfamount = 0;
            var freight_amount = document.getElementById('txtFrAmt').value || 0;
            var transport_charge = document.getElementById('txtTransportCharge').value || 0;
            $('.clstotal').each(function (i, obj) {
                var totlclass = $(this).val();

                if (totlclass == "" || totlclass == "0") {
                }
                else {
                    totaamount += parseFloat(totlclass);
                }
            });

            var totalamount1 = parseFloat(totaamount) + parseFloat(freight_amount) + parseFloat(transport_charge);
            var grandtotal = parseFloat(totalamount1);
            var grandtotal1 = grandtotal.toFixed(2);
            var diff = 0;
            if (grandtotal > grandtotal1) {
                diff = grandtotal - grandtotal1;
            }
            else {
                diff = grandtotal1 - grandtotal;
            }
            document.getElementById('spn_inwardamt').innerHTML = grandtotal;
            document.getElementById('spn_roundoffamt').innerHTML = diff;
            document.getElementById('txtInwardAmount').innerHTML = grandtotal1;
            freight_amount = 0;
            transport_charge = 0;
        }
        var total;
        var totaldis;
        var edval;
        var totalpoamount;
        var sum;
        var discount;
        var disper;
        var totalval;
        var totaldisamount;
        var tax = "";
        var totaltax = "";
        var edper = "";
        var edtotalval = "";
        var totalpoval = "";
        var totalclsval;
        var Discount = 0;
        var fright = 0;
        var pf = 0;
        var pfamt = 0;
        var discount1 = 0;
        var Discountedpf = 0;
        var pf1 = 0;
        var price = 0;
        var quantity = 0;
        var tpfamt = 0;
        var free = 0;
        var tpfamt1 = 0;
        var transport = 0;
        function calTotal() {
            var $row = $(this).closest('tr'),
           price = $row.find('.price').val(),
           quantity = $row.find('.quantity').val(),
            sum = quantity;
            discount1 = sum * price;
            disper = $row.find('.clsdis').val(),
            totalval = parseFloat(discount1) * (disper) / 100 || 0;
            discount = discount1 - totalval;
            $row.find('.clsdisamt').val(totalval);
            $row.find('#spn_dis_amt').text(totalval);
            edval = $row.find('.clsed').val(),
            edper = parseFloat(edval) / 100;
            edtotalval = (discount * edper) || 0;
            Discountedpf =  edtotalval + discount;

            tax1 = $row.find('.clstax').val(),
            tax = parseFloat(tax1) / 100;
            totaltax = parseFloat(Discountedpf) * (tax) || 0;
            fright = document.getElementById('txtFrAmt').value || 0;
             transport = document.getElementById('txtTransportCharge').value || 0;

            if (edtotalval == 0 || totaltax == 0) {
                if (discount == 0) {
                    $row.find('.clstotal').val(parseFloat(Discountedpf).toFixed(2));
                    $row.find('#spn_total').text(parseFloat(Discountedpf).toFixed(2));
                }
                else {
                    if (totaltax == 0) {
                        $row.find('.clstotal').val(parseFloat(Discountedpf).toFixed(2));
                        $row.find('#spn_total').text(parseFloat(Discountedpf).toFixed(2));
                    }
                    else {
                        var withtaxval = parseFloat(totaltax) + parseFloat(Discountedpf);
                        $row.find('.clstotal').val(parseFloat(withtaxval).toFixed(2));
                        $row.find('#spn_total').test(parseFloat(withtaxval).toFixed(2));
                    }
                }
            }
            else {
                totalpoval = parseFloat(edtotalval) + parseFloat(totaltax) + parseFloat(tpfamt1) + parseFloat(discount);
                $row.find('.clstotal').val(parseFloat(totalpoval).toFixed(2));
                $row.find('spn_total').text(parseFloat(totalpoval).toFixed(2));
            }
            clstotalval();
        }
        $(document).click(function () {
            $('#tabledetails').on('change', '.quantity', calTotal)
            $('#tabledetails').on('change', '.price', calTotal)
            $('#tabledetails').on('change', '.clsfree', calTotal)
            $('#tabledetails').on('change', '.clsdis', calTotal)
            $('#tabledetails').on('change', '.clstax', calTotal)
            $('#tabledetails').on('change', '.clsed', calTotal)
            $('#tabledetails').on('change', '.clstotal', calTotal)
            $('#tabledetails').on('change', '#spn_total', calTotal)
        });
        $(document).click(function () {
            $('#tabledetails_gst').on('change', '.quantity', calTotal_gst)
            $('#tabledetails_gst').on('change', '.price', calTotal_gst)
            $('#tabledetails_gst').on('change', '.clsdis', calTotal_gst)
            $('#tabledetails_gst').on('change', '.cls_sgst_per', calTotal_gst)
            $('#tabledetails_gst').on('change', '.cls_cgst_per', calTotal_gst)
            $('#tabledetails_gst').on('change', '.cls_igst_per', calTotal_gst)
            $('#tabledetails_gst').on('change', '.clstotal', calTotal_gst)
        });

        var total_product_amount = 0;
        function calTotal_gst() {
            var $row = $(this).closest('tr');
            var price = 0;
            price = parseFloat($row.find('.price').val());
            var quantity = 0;
            quantity = parseFloat($row.find('.quantity').val());
            var cost = 0;
            cost = quantity * price;
            var disper = 0;
            disper = parseFloat($row.find('.clsdis').val());
            var totalval = 0;
            totalval = parseFloat(cost) * (disper) / 100 || 0;
            var costafterdis = 0;
            costafterdis = cost - totalval;
            $row.find('.clsdisamt').val(totalval);
            $row.find('#spn_dis_amt').text(totalval);
            var pf1 = document.getElementById("ddlpf");
            var pf_amt = 0;
            if (pf1 == null) {
                pf_amt = 0;
            }
            else {
                var pf = pf1.options[pf1.selectedIndex].text;
                pf_amt = (costafterdis * parseFloat(pf)) / 100 || 0;
            }
            var taxable = 0;
            taxable = pf_amt + costafterdis;
            $row.find('.cls_taxable').val(taxable);
            $row.find('#spn_taxable').text(taxable.toFixed(2));
            var sgst_per = 0, sgst_amt = 0;
            sgst_per = parseFloat($row.find('.cls_sgst_per').val());
            sgst_amt = (sgst_per * parseFloat(taxable)) / 100 || 0;
            var cgst_per = 0, cgst_amt = 0;
            cgst_per = parseFloat($row.find('.cls_cgst_per').val());
            cgst_amt = (cgst_per * parseFloat(taxable)) / 100 || 0;
            var igst_per = 0, igst_amt = 0;
            igst_per = parseFloat($row.find('.cls_igst_per').val());
            igst_amt = (igst_per * parseFloat(taxable)) / 100 || 0;
            
            total_product_amount = taxable + sgst_amt + cgst_amt + igst_amt;
            $row.find('.clstotal_gst').val(parseFloat(total_product_amount).toFixed(2));
            $row.find('#spn_total').text(parseFloat(total_product_amount).toFixed(2));
            clstotalval_gst();
        }

        function clstotalval_gst() {
            var totaamount = 0; var totalpfamount = 0;
            var freight_amount = document.getElementById('txtFrAmt').value || 0;
            var transport_charge = document.getElementById('txtTransportCharge').value || 0;
            $('.clstotal_gst').each(function (i, obj) {
                var totlclass = $(this).val();

                if (totlclass == "" || totlclass == "0") {
                }
                else {
                    totaamount += parseFloat(totlclass);
                }
            });

            var totalamount1 = parseFloat(totaamount) + parseFloat(freight_amount) + parseFloat(transport_charge);
            var grandtotal = parseFloat(totalamount1);
            var grandtotal1 = grandtotal.toFixed(2);
            var diff = 0;
            if (grandtotal > grandtotal1) {
                diff = grandtotal - grandtotal1;
            }
            else {
                diff = grandtotal1 - grandtotal;
            }
            document.getElementById('spn_inwardamt').innerHTML = grandtotal;
            document.getElementById('spn_roundoffamt').innerHTML = diff;
            document.getElementById('txtInwardAmount').innerHTML = grandtotal.toFixed(2);
            freight_amount = 0;
            transport_charge = 0;
        }

        function getallinward() {
            var data = { 'op': 'get_inward_Data' };
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
            scrollTo(0, 0);
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr class="trbgclrcls"><th scope="col">Invoice No</th><th scope="col">Inward Date</th><th scope="col"><i class="fa fa-user"></i>Supplier Name</th><th scope="col">Refn No</th><th scope="col">MRN Number</th><th scope="col"></th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            inward_subdetails = msg[0].SubInward;
            var inward = msg[0].InwardDetails;
            for (var i = 0; i < inward.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">';//<td><input id="btn_poplate" type="button"  onclick="update(this)" name="Edit" class="btn btn-primary" value="Edit" /></td>
                results += '<td data-title="invoiceno" class="2">' + inward[i].invoiceno + '</td>';
                results += '<td data-title="inwarddate" class="3">' + inward[i].inwarddate + '</td>';
                results += '<td data-title="invoicedate" class="4" style="display:none;">' + inward[i].invoicedate + '</td>';
                results += '<td data-title="dcno" class="5" style="display:none;">' + inward[i].dcno + '</td>';
                results += '<td data-title="lrno" class="6" style="display:none;">' + inward[i].lrno + '</td>';
                results += '<td data-title="name" class="7" >' + inward[i].name + '</td>';
                results += '<td data-title="podate" class="8" style="display:none;">' + inward[i].podate + '</td>';
                results += '<td data-title="remarks" class="10" style="display:none;">' + inward[i].remarks + '</td>';
                results += '<td data-title="pono" class="11" readonly style="display:none;">' + inward[i].pono + '</td>';
                results += '<td data-title="pono" class="15" style="display:none;">' + inward[i].modeofinward + '</td>';
                results += '<td data-title="pono" class="16" style="display:none;">' + inward[i].vehicleno + '</td>';
                results += '<td data-title="pono" class="17" style="display:none;">' + inward[i].transportname + '</td>';
                results += '<td data-title="pono" class="18" style="display:none;">' + inward[i].securityno + '</td>';
                results += '<td data-title="sno"  class="19">' + inward[i].sno + '</td>';
                results += '<td data-title="sno" class="20" >' + inward[i].mrnno + '</td>'; 
                results += '<td data-title="sno" style="display:none;" class="22">' + inward[i].freigtamt + '</td>';
                results += '<td data-title="sno" style="display:none;" class="23">' + inward[i].transport + '</td>';
                results += '<td data-title="sno" style="display:none;" class="24">' + inward[i].inwardamount + '</td>';
                results += '<td data-title="sno" style="display:none;" class="25">' + inward[i].pfid + '</td>';
                results += '<td data-title="sno" style="display:none;" class="26">' + inward[i].rev_chrg + '</td>';
                results += '<td data-title="brandstatus"><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"  onclick="update(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td>';
                results += '<td data-title="hiddensupplyid" class="14" style="display:none;">' + inward[i].hiddensupplyid + '</td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_inwardtable").html(results);
        }
        var sno = 0;
        function update(thisid) {
            scrollTo(0, 0);
            clstotalval();
            calTotal();
            get_TAX();
            get_supplier();
            get_productcode();
            $('#Inward_FillForm').css('display', 'block');
            $('#showlogs').css('display', 'none');
            $('#div_inwardtable').hide();
            var invoiceno = $(thisid).parent().parent().children('.2').html();
            var inwarddate2 = $(thisid).parent().parent().children('.3').html();
            var invoicedate2 = $(thisid).parent().parent().children('.4').html();
            var dcno = $(thisid).parent().parent().children('.5').html();
            var lrno = $(thisid).parent().parent().children('.6').html();
            var name = $(thisid).parent().parent().children('.7').html();
            var podate2 = $(thisid).parent().parent().children('.8').html();
            var remarks = $(thisid).parent().parent().children('.10').html();
            var pono = $(thisid).parent().parent().children('.11').html();
            var sno = $(thisid).parent().parent().children('.19').html();
            var freigntamt = $(thisid).parent().parent().children('.22').html();
            var hiddensupplyid = $(thisid).parent().parent().children('.14').html();
            var modeofinward = $(thisid).parent().parent().children('.15').html();
            var vehicleno = $(thisid).parent().parent().children('.16').html();
            var transportname = $(thisid).parent().parent().children('.17').html();
            var securityno = $(thisid).parent().parent().children('.18').html();
            var transport = $(thisid).parent().parent().children('.23').html();
            var inwardamount = $(thisid).parent().parent().children('.24').html();
            var pf = $(thisid).parent().parent().children('.25').html();
            var rev_chrg = $(thisid).parent().parent().children('.26').html();

            var inwarddate1 = inwarddate2.split('-');
            var inwarddate = inwarddate1[2] + '-' + inwarddate1[1] + '-' + inwarddate1[0];

            var invoicedate1 = invoicedate2.split('-');
            var invoicedate = invoicedate1[2] + '-' + invoicedate1[1] + '-' + invoicedate1[0];

            var podate1 = podate2.split('-');
            var podate = podate1[2] + '-' + podate1[1] + '-' + podate1[0];

            if (pf != "0") {
                document.getElementById('txtpf').value = pf;
                $('#pandf').css('display', 'block');
            }
            document.getElementById('txt_inwarddate').value = inwarddate;
            document.getElementById('txt_invoice').value = invoiceno;
            document.getElementById('txt_invoicedate').value = invoicedate;
            document.getElementById('txt_dcno').value = dcno;
            document.getElementById('txt_lrno').value = lrno;
            document.getElementById('txtFrAmt').value = freigntamt;
            document.getElementById('txtSuplyname').value = name;
            document.getElementById('txt_podate').value = podate;
            document.getElementById('txt_pono').value = pono;
            document.getElementById('txt_remarks').value = remarks;
            document.getElementById('txtsupid').value = hiddensupplyid;
            document.getElementById('lbl_sno').value = sno;
            document.getElementById('slct_mdeofinwrd').value = modeofinward;
            document.getElementById('txtvehiclenumber').value = vehicleno;
            document.getElementById('txtsecurenum').value = securityno;
            document.getElementById('txttransportname').value = transportname;
            document.getElementById('txtTransportCharge').value = transport;
            document.getElementById('txtInwardAmount').innerHTML = inwardamount;
            document.getElementById('txt_rev_chrg').value = rev_chrg;
            document.getElementById('btn_RaisePO').innerHTML = "Modify";
            var table = document.getElementById("tabledetails");

            var todaydate = inwarddate.split('-');
            //var todaydate = "2017-07-17".split('-');
            var date = "2017-07-01".split('-');
            var firstDate = new Date();
            firstDate.setFullYear(todaydate[0], (todaydate[1] - 1), todaydate[2]);
            var secondDate = new Date();
            secondDate.setFullYear(date[0], (date[1] - 1), date[2]);

            if (firstDate >= secondDate) {
                var results = '<div  style="overflow:auto;"><table ID="tabledetails_gst" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" >';
                results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Quantity</th><th scope="col">UOM</th><th scope="col">Per Unit Rs</th><th scope="col">Dis%</th><th scope="col">Dis Amt</th><th scope="col">Taxable</th><th scope="col">SGST %</th><th scope="col">CGST %</th><th scope="col">IGST %</th><th scope="col">Total Cost</th><th scope="col"></th></tr></thead></tbody>';
                var k = 1;
                var pandf1 = document.getElementById('txtpf').value || 0;
                for (var i = 0; i < inward_subdetails.length; i++) {
                    if (sno == inward_subdetails[i].inword_refno) {
                        results += '<tr><td data-title="Sno" class="1">' + k + '</td>';
                        results += '<td class="tdmaincls" ><span id="spn_Productname">' + inward_subdetails[i].productname + '</span><input id="txtProductname"  class="productcls"  name="productname" value="' + inward_subdetails[i].productname + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;display:none"></input></td>';
                        results += '<td class="tdmaincls" ><span id="spn_quantity">' + inward_subdetails[i].quantity + '</span><input class="quantity"  id="txt_quantity" onkeypress="return isFloat(event)" name="Quantity" value="' + inward_subdetails[i].quantity + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;display:none"></input></td>';
                        results += '<td class="tdmaincls" ><span id="spn_uim">' + inward_subdetails[i].uim + '</span><input type="text" id="ddlUim" class="uomcls" name="uom"   value="' + inward_subdetails[i].uim + '"  style="width:100%; font-size:12px;padding: 0px 5px;height:30px;display:none"></input></td>';
                        results += '<td class="tdmaincls" ><span id="spn_perunitrs">' + inward_subdetails[i].PerUnitRs + '</span><input class="price" id="txt_perunitrs" name="PerUnitRs" onkeypress="return isFloat(event)"  value="' + inward_subdetails[i].PerUnitRs + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;display:none"></input></td>';
                        results += '<td ><span id="spn_dis">' + inward_subdetails[i].dis + '</span><input id="txtDis" name="dis" class="clsdis" value="' + inward_subdetails[i].dis + '" onkeypress="return isFloat(event)"  style="width:100%;display:none; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                        var disc = parseFloat(inward_subdetails[i].dis);
                        var quantity = parseFloat(inward_subdetails[i].quantity);
                        var rs = parseFloat(inward_subdetails[i].PerUnitRs);
                        var qty_cost = quantity * rs;
                        var disc_amt = (qty_cost * disc) / 100 || 0;
                        results += '<td ><span id="spn_dis_amt">' + inward_subdetails[i].disamt + '</span><input id="txtDisAmt" class="clsdisamt" name="disamt" value="' + inward_subdetails[i].disamt + '" onkeypress="return isFloat(event)" style="width:60px; font-size:12px;padding: 0px 5px;height:30px;display:none;"></td>';
                        var amount_after_disc = qty_cost - disc_amt;
                        var tpandfamt = parseFloat(pandf1) / 100;
                        var tpandfamt1 = parseFloat(amount_after_disc) * (tpandfamt) || 0;
                        var taxable = tpandfamt1 + amount_after_disc;
                        results += '<td ><span id="spn_taxable">' + taxable.toFixed(2) + '</span><input id="txt_taxable" class="clstaxable"  name="taxable" onkeypress="return isFloat(event)" value="' + taxable + '" style="width:100%;display:none; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                        results += '<td ><span id="span_sgst_per">' + inward_subdetails[i].sgst_per + '</span><input id="txt_sgst_per" type="text" class="cls_sgst_per"  name="sgst_per"  value="' + inward_subdetails[i].sgst_per + '" onkeypress="return isFloat(event)" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;display:none;"/></td>';
                        var sgst_amount = taxable * (parseFloat(inward_subdetails[i].sgst_per)) / 100;
                        results += '<td ><span id="span_cgst_per">' + inward_subdetails[i].cgst_per + '</span><input id="txt_cgst_per" type="text" class="cls_cgst_per"  name="cgst_per"  value="' + inward_subdetails[i].cgst_per + '" onkeypress="return isFloat(event)" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;display:none;"/></td>';
                        var cgst_amount = taxable * (parseFloat(inward_subdetails[i].cgst_per)) / 100;
                        results += '<td ><span id="span_igst_per">' + inward_subdetails[i].igst_per + '</span><input id="txt_igst_per" type="text" name="igst_per"  class="cls_igst_per"  value="' + inward_subdetails[i].igst_per + '" onkeypress="return isFloat(event)" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;display:none;"></td>';
                        var igst_amount = taxable * (parseFloat(inward_subdetails[i].igst_per)) / 100;
                        var product_amount = 0;
                        if (rev_chrg == "N") {
                            product_amount = taxable + sgst_amount + cgst_amount + igst_amount;
                        }
                        else if (rev_chrg == "Y") {
                            product_amount = taxable;
                        }
                        else {
                            product_amount = taxable + sgst_amount + cgst_amount + igst_amount;
                        }
                        results += '<th ><span id="spn_total">' + product_amount.toFixed(2)+ '</span><input class="clstotal_gst"  id="txtTotal" onkeypress="return isFloat(event)" name="TotalCost" value="' + product_amount + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;display:none;"></input></td>';
                        results += '<th style="display:none;"><input class="5" id="hdnproductsno" type="hidden" name="hdnproductsno" value="' + inward_subdetails[i].hdnproductsno + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input>';
                        results += '<th style="display:none;"><input class="6" id="subsno" type="hidden" name="subsno" value="' + inward_subdetails[i].sisno + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input>';
                        results += '<td><span onclick="removerow1(this)"><img src="images/minus.png" style="cursor:pointer"/></span></td>';
                        results += '<th data-title="From" style="display:none"><input class="7" id="txt_sub_sno" name="txt_sub_sno" value="' + inward_subdetails[i].sno + '"style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td></tr>';
                        ProductTable.push(inward_subdetails[i].productname);
                        k++;
                    }
                }
                results += '</table></div>';
                $("#div_InwardProductsData").html(results);
                clstotalval_gst();
            }
            else {
                var results = '<div  style="overflow:auto;"><table ID="tabledetails" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" >';
                results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Quantity</th><th scope="col">UOM</th><th scope="col">Per Unit Rs</th><th scope="col">Dis%</th><th scope="col">Dis Amt</th><th scope="col">Tax Type</th><th scope="col">Tax %</th><th scope="col">ED</th><th scope="col">ED Tax%</th><th scope="col">Total Cost</th><th scope="col"></th></tr></thead></tbody>';
                var k = 1;
                for (var i = 0; i < inward_subdetails.length; i++) {
                    if (sno == inward_subdetails[i].inword_refno) {
                        results += '<tr><td data-title="Sno" class="1">' + k + '</td>';
                        results += '<th data-title="From"><span id="spn_Productname">' + inward_subdetails[i].productname + '</span><input id="txtProductname"  class="productcls"  name="productname" value="' + inward_subdetails[i].productname + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;display:none"></input></td>';
                        results += '<th data-title="From"><span id="spn_quantity">' + inward_subdetails[i].quantity + '</span><input class="quantity"  id="txt_quantity" onkeypress="return isFloat(event)" name="Quantity" value="' + inward_subdetails[i].quantity + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;display:none"></input></td>';
                        results += '<th data-title="From"><span id="spn_uim">' + inward_subdetails[i].uim + '</span><input type="text" id="ddlUim" class="uomcls" name="uom"   value="' + inward_subdetails[i].uim + '"  style="width:100%; font-size:12px;padding: 0px 5px;height:30px;display:none"></input></td>';
                        results += '<th data-title="From"><span id="spn_perunitrs">' + inward_subdetails[i].PerUnitRs + '</span><input class="price" id="txt_perunitrs" name="PerUnitRs" onkeypress="return isFloat(event)"  value="' + inward_subdetails[i].PerUnitRs + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;display:none"></input></td>';
                        results += '<td data-title="From"><input  id="txtDis" name="dis" class="clsdis" value="' + inward_subdetails[i].dis + '" onkeypress="return isFloat(event)"  style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                        results += '<td data-title="From"><span id="spn_dis_amt">' + inward_subdetails[i].disamt + '</span><input id="txtDisAmt" class="clsdisamt" name="disamt" value="' + inward_subdetails[i].disamt + '" onkeypress="return isFloat(event)" style="width:60px; font-size:12px;padding: 0px 5px;height:30px;display:none;"></td>';
                        results += '<td data-title="From"><select id="ddlTaxtype" class="Taxtypecls" name="taxtype"   value="' + inward_subdetails[i].tax + '"  style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></select></td>';
                        results += '<td data-title="From"><input  id="txtTax" class="clstax"  name="tax" value="' + inward_subdetails[i].taxtype + '" onkeypress="return isFloat(event)" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                        results += '<td data-title="From"><select id="ddlEd" class="edcls"  name="ed"  value="' + inward_subdetails[i].ed + '"  style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></select></td>';
                        results += '<td data-title="From"><input  id="txtEdtax" name="edtax" class="clsed" value="' + inward_subdetails[i].edtype + '" onkeypress="return isFloat(event)" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                        results += '<th data-title="From"><span id="spn_total">' + inward_subdetails[i].totalcost + '</span><input class="clstotal"  id="txtTotal" onkeypress="return isFloat(event)" name="TotalCost" value="' + inward_subdetails[i].totalcost + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;display:none;"></input></td>';
                        results += '<th data-title="From"><input class="5" id="hdnproductsno" type="hidden" name="hdnproductsno" value="' + inward_subdetails[i].hdnproductsno + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input>';
                        results += '<th data-title="From"><input class="6" id="subsno" type="hidden" name="subsno" value="' + inward_subdetails[i].sisno + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input>';
                        results += '<td><span onclick="removerow1(this)"><img src="images/minus.png" style="cursor:pointer"/></span></td>';
                        results += '<th data-title="From" style="display:none"><input class="7" id="txt_sub_sno" name="txt_sub_sno" value="' + inward_subdetails[i].sno + '"style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td></tr>';
                        ProductTable.push(inward_subdetails[i].productname);
                        k++;
                    }
                }
                results += '</table></div>';
                $("#div_InwardProductsData").html(results);
            }
        }
        function prntinward(thisid) {
            var sno = $(thisid).parent().parent().children('.19').html();
            var data = { 'op': 'get_inward_print', 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    window.open("InwardReport.aspx", "_self");
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        var productarray = [];
        function get_productcode() {
            var data = { 'op': 'get_branchwiseproduct_details' };
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
            var todaydate = today_date.split('-');
            //var todaydate = "2017-07-17".split('-');
            var date = "2017-07-01".split('-');

            var firstDate = new Date();
            firstDate.setFullYear(todaydate[0], (todaydate[1] - 1), todaydate[2]);
            var secondDate = new Date();
            secondDate.setFullYear(date[0], (date[1] - 1), date[2]);
            if (firstDate < secondDate) {
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
            else {
                var compiledList = [];
                for (var i = 0; i < msg.length; i++) {
                    var productname = msg[i].productname;
                    compiledList.push(productname);
                }
                $('#txtProductcode').autocomplete({
                    source: compiledList,
                    change: barcode_gst,
                    autoFocus: true
                });
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
        function Inward_forClearAll() {
            document.getElementById('txt_inwarddate').value = "";
            document.getElementById('txt_invoice').value = "";
            document.getElementById('txt_invoicedate').value = "";
            document.getElementById('txt_dcno').value = "";
            document.getElementById('txt_lrno').value = "";
            document.getElementById('txtSuplyname').value = "";
            document.getElementById('txt_podate').value = "";
            document.getElementById('txt_pono').value = "";
            document.getElementById('txt_remarks').value = "";
            document.getElementById('slct_mdeofinwrd').selectedIndex = "";
            document.getElementById('txtvehiclenumber').value = "";
            document.getElementById('txtsecurenum').value = "";
            document.getElementById('txttransportname').value = "";
            document.getElementById('lbl_sno').value = "";
            document.getElementById('txtpf').value = "";
            document.getElementById('txtTransportCharge').value = "";
            document.getElementById('spn_inwardamt').innerHTML = "";
            document.getElementById('spn_roundoffamt').innerHTML = "";
            document.getElementById('txtInwardAmount').innerHTML = "";
            document.getElementById('btn_RaisePO').innerHTML = "Save";
            var empty = [];
            var results = '<div  style="overflow:auto;"><table id="tabledetails" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Quantity</th><th scope="col">UOM</th><th scope="col">Per Unit Rs</th><th scope="col">Dis%</th><th scope="col">Dis Amt</th><th scope="col">Tax Type</th><th scope="col">Tax %</th><th scope="col">ED</th><th scope="col">ED Tax%</th><th scope="col">Total Cost</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < empty.length; i++) {
            }
            results += '</table></div>';
            $("#div_InwardProductsData").html(results);
            scrollTo(0, 0);
        }
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Inward Entry <small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operations</a></li>
            <li><a href="#">Inward Entry</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Inward Entry Details
                </h3>
            </div>
            <div class="box-body">
                <div id="showlogs" align="center">
                    <%--<input id="add_Inward" type="button" name="submit" value='Add Inward' class="btn btn-primary" />--%>
                    <div class="input-group" style="padding-left:90%">
                        <div class="input-group-addon">
                            <span class="glyphicon glyphicon-plus-sign"></span> <span id="add_Inward">Add Inward</span>
                        </div>
                    </div>
                </div>
                <div id="div_inwardtable" style="padding-top:2px;">
                </div>
                <div id='Inward_FillForm' style="display: none;">
                    <table align="center">
                        <tr>
                            <td style="height: 40px;">
                                <label>
                                    Inward Date</label><span style="color: red;">*</span>
                            <div class="input-group date" style="width:100%;">
                              <div class="input-group-addon cal">
                                <i class="fa fa-calendar"></i>
                              </div>
                              <input id="txt_inwarddate" class="form-control" type="date" />
                            </div>
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;">
                                <label>
                                    Inward Number</label><span style="color: red;">*</span>
                                <input id="txt_inwardno" class="form-control" type="text" readonly placeholder="Enter Inward Number"/>
                            </td>
                            <td style="width: 5px;">
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>
                                    Invoice Number</label>
                                <input id="txt_invoice" class="form-control" type="text"  placeholder="Enter Invoice Number"/><%--onkeypress="return isNumber(event)"--%>
                            </td>
                            <td>
                            </td>
                            <td style="height: 40px;">
                                <label>
                                    Invoice Date</label>
                            <div class="input-group date" style="width:100%;">
                              <div class="input-group-addon cal">
                                <i class="fa fa-calendar"></i>
                              </div>
                              <input id="txt_invoicedate" class="form-control" type="date" />
                            </div>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>
                                    DC Number</label><span style="color: red;">*</span>
                                <input id="txt_dcno" class="form-control" type="text" onkeypress="return isNumber(event)" placeholder="Enter DC Number"/>
                            </td>
                            <td>
                            </td>
                            <td style="height: 40px;">
                                <label>
                                    LR Number</label>
                                <input id="txt_lrno" class="form-control" type="text" onkeypress="return isNumber(event)" placeholder="Enetr LR Number"/>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>
                                    Supplier Name</label><span style="color: red;">*</span>
                                <input id="txtSuplyname" class="form-control" type="text" readonly placeholder="Select Supplier Name" onKeyPress="return ValidateAlpha(event);"/>
                                <input id="txt_sup_state" class="form-control" type="text" style="display:none;" />
                            </td>
                            <td>
                            </td>
                            <td style="height: 40px;">
                                <label>
                                    PO Date</label>
                                <input id="txt_podate" class="form-control" placeholder="PO Date" readonly/>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>
                                    Mode of Inward</label>
                                <select id="slct_mdeofinwrd" class="form-control">
                                    <option value="Select Mode of Inward" disabled selected>Select Mode of Inward</option>
                                    <option value="Cash Purchase">CashPurchase</option>
                                    <option value="Credit Purchase">CreditPurchase</option>
                                    <option value="CheckPaid">CheckPaid</option>
                                    <option value="FOC">FOC</option>
                                    <option value="Refurbished">Refurbished</option>
                                    <option value="Warranty">Warranty</option>
                                    <option value="Transported">Transported</option>
                                    <option value="Returnble">Returnble</option>
                                    <option value="AgainstLoan">AgainstLoan</option>
                                    <option value="Repair">Repair</option>
                                    <option value="AuditCorrrection">AuditCorrrection</option>
                                    <option value="Bank Tranfer">Bank Tranfer</option>
                                </select>
                            </td>
                            <td>
                            </td>
                            <td style="height: 40px;">
                                <label>
                                    PO Number</label><span style="color: red;">*</span>
                                <input id="txt_pono" class="form-control" type="text" onkeypress="return isNumber(event)"  placeholder="Enter PO Number" onchange="ponumber(this);" />
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                           
                            <td style="height: 40px;">
                                <label>
                                    Security Number</label>
                                <input id="txtsecurenum" class="form-control" type="text"   placeholder="Security Number" /><%--onkeypress="return isNumber(event)"--%>
                            </td>
                        </tr>
                         <tr>
                            <td style="height: 40px;">
                                <label>
                                    Name Of the Transport</label>
                                <input id="txttransportname" class="form-control" type="text"   placeholder="Enter TransPort Name" onkeypress="return ValidateAlpha(event);"/>
                            </td>
                            <td>
                            </td>
                            <td style="height: 40px;">
                                <label>
                                     Vehicle Number</label>
                                <input id="txtvehiclenumber" class="form-control" type="text"   placeholder="Vehicle Number" />
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>
                                    Freight Amount</label>
                                <input id="txtFrAmt" type="text" class="form-control" name="FreAmount"  onkeypress="return isFloat(event)"
                                    placeholder="Enter  Freight Amount" onchange="calTotal();" />
                            </td>
                            <td>
                            </td>
                            <td style="height: 40px;">
                                <label>
                                    Transport Charges</label>
                                <input id="txtTransportCharge" type="text" class="form-control"  name="TransportCharge" onkeypress="return isFloat(event)"
                                    placeholder="Enter  Transport Charges" onchange="calTotal();" />
                            </td>
                        </tr>
                        <tr id="pandf" style="display:none">
                            <td style="height: 40px;">
                                <label>
                                    P and F</label>
                                <input id="txtpf"  type="text"  class="form-control" name="FreAmount" readonly onkeypress="return isFloat(event)" placeholder="Enter P and F Amount"/>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4">
                            <label>
                                    Remarks</label>
                                <textarea id="txt_remarks" class="form-control" type="text" rows="3" cols="25" placeholder="Enter Remarks"></textarea>
                            </td>
                            
                        </tr>

                        <tr style="display:none;">
                        <td>
                         <label>
                                    Payment Type</label></td>
                         <td  colspan="4">
                                <input id="txtpaymenttype"  type="text"  class="form-control" name="paymenttype" readonly/>
                            </td>
                            
                        </tr>
                      
                        <td>
                            <label id="lbl_sno" style="display: none;">
                            </label>
                            <input id="txt_rev_chrg" type="text" style="display:none" />
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
                                    <input id="txtSku" type="text" class="form-control" name="sku" onchange="barcode();" placeholder="Scan Here"/>
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
                    <div id="div_InwardProductsData">
                    </div>
                    </div>
                    </div>
                         <table align="center" id="po">
                             <tr>
                            <td>
                                <label>
                                    Inward Amount</label>
                            </td>
                            <td>
                                <span id="spn_inwardamt" style="width: 500px; color: Red; font-weight: bold; font-size: 25px;"></span>
                            </td>
                        </tr>
                             <tr>
                                 <td>
                                     <label>Round off Difference Amount</label>
                                 </td>
                                 <td>
                                     <span id="spn_roundoffamt" style="width: 500px; color: Red; font-weight: bold; font-size: 25px;"></span>
                                 </td>
                             </tr>
                             <tr>
                                 <td>
                                     <label>Final Inward Amount</label>
                                 </td>
                                 <td>
                                     <span id="txtInwardAmount" type="text" style="width: 500px; color: Red; font-weight: bold;
                                    font-size: 25px;" class="clspomount" name="PoAmount" onkeypress="return isFloat(event)"
                                    placeholder="Enter PO Amount"></span>
                            </td>
                        </tr>
                                        </table>
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
                                        <span class="glyphicon glyphicon-ok" id="btn_RaisePO1" onclick="save_edit_Inward()"></span> <span id="btn_RaisePO" onclick="save_edit_Inward()">Save</span>
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
