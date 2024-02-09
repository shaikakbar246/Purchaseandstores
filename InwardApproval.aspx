<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true"
    CodeFile="InwardApproval.aspx.cs" Inherits="InwardApproval" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            $('#add_Inward').click(function () {
                $('#inward_fillform').css('display', 'block');
                $('#showlogs').css('display', 'none');
                $('#div_inwardtable').hide();
                getallinward();
                get_supplier();
                ProductTable = [];
                scrollTo(0, 0);
            });
            $('#close_vehmaster').click(function () {
                $('#inward_fillform').css('display', 'none');
                $('#showlogs').css('display', 'block');
                $('#div_inwardtable').show();
                forclearall();
            });
            scrollTo(0, 0);
            getallinward();
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
                }
            }
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
                    Quantity = $(this).find('#txt_quantity').val();
                    TotalCost = $(this).find('#txtTotal').val();
                    sisno = $(this).find('#subsno').val();
                    hdnproductsno = $(this).find('#hdnproductsno').val();
                    hdnproductcode = $(this).find('#hdnproductcode').val();
                    DataTable.push({ Sno: txtsno, productname: productname, PerUnitRs: PerUnitRs, Quantity: Quantity, TotalCost: TotalCost, hdnproductsno: hdnproductsno, sku: hdnproductcode, sisno: sisno });
                    rowsno++;
                }
            });
            var productname = 0;
            var PerUnitRs = 0;
            var Quantity = 0;
            var TotalCost = 0;
            var hdnproductsno = 0;
            var hdnproductcode = 0;
            var Sno = parseInt(txtsno) + 1;
            if (txtbarcode != "") {
                if (ProductTable.indexOf(txtbarcode) == -1) {
                    for (var i = 0; i < productarray.length; i++) {
                        if (txtbarcode == productarray[i].sku) {
                            productname = productarray[i].productname;
                            hdnproductsno = productarray[i].productid;
                            PerUnitRs = productarray[i].price;
                            DataTable.push({ Sno: Sno, productname: productname, PerUnitRs: PerUnitRs, Quantity: Quantity, TotalCost: TotalCost, hdnproductsno: hdnproductsno, sku: productarray[i].sku });
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
                            DataTable.push({ Sno: Sno, productname: productname, PerUnitRs: PerUnitRs, Quantity: Quantity, TotalCost: TotalCost, hdnproductsno: hdnproductsno, sku: productarray[i].sku });
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
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Per Unit Rs</th><th scope="col">Quantity</th><th scope="col">Total Cost</th><th scope="col"></th></tr></thead></tbody>';
            var j = 1;
            for (var i = 0; i < DataTable.length; i++) {
                //if (txtbarcode == productarray[i].productcode) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + j + '</td>';
                results += '<td ><input id="txtProductname" readonly  class="productcls" style="width:90px;" value="' + DataTable[i].productname + '"/></td>';
                results += '<td style="display:none;" class="2">' + DataTable[i].productname + '</td>';
                results += '<td ><input id="txt_perunitrs" type="text" class="price"  onkeypress="return isFloat(event)" style="width:90px;" value="' + DataTable[i].PerUnitRs + '"/></td>';
                results += '<td ><input id="txt_quantity" type="text" class="quantity"  onkeypress="return isFloat(event)" style="width:90px;" value="' + DataTable[i].Quantity + '"/></td>';
                results += '<td ><input id="txtTotal" type="text" readonly class="Total" onkeypress="return isFloat(event)" style="width:90px;" value="' + DataTable[i].TotalCost + '"/></td>';
                results += '<td style="display:none"><input id="hdnproductsno" type="hidden" value="' + DataTable[i].hdnproductsno + '"/><input id="hdnproductcode" type="hidden" value="' + DataTable[i].sku + '"/></td>';
                results += '<td data-title="Minus"><input id="btn_poplate" type="button"  onclick="removerow(this)" name="Edit" class="btn btn-primary" value="Remove" /></td>';
                results += '<td style="display:none" class="4">' + i + '</td></tr>';
                j++;
                //}

            }
            results += '</table></div>';
            $("#div_inward_ProductsData").html(results);
            document.getElementById('txtSku').value = "";
            document.getElementById('txtProductcode').value = "";
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
        var replaceHtmlEntites = (function () {
            return function (s) {
                return (s.replace(translate_re, function (match, entity) {
                    return translate[entity];
                }));
            }
        })();

        function ponumber(txt_pono) {
            var pono = document.getElementById('txt_pono').value;
            var data = { 'op': 'get_purchaserOrder_details_inward', 'pono': pono };
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

        function getallinward() {
            var data = { 'op': 'get_Pending_inward_Data' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        var inwardsubdetails = msg[0].SubInward;
                        var inward = msg[0].InwardDetails;
                        if (inward.length > 0 && inwardsubdetails.length > 0) {
                            fill_foreground_tbl(msg);
                        }
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
            results += '<thead><tr class="trbgclrcls"><th scope="col">Inward No</th><th scope="col">MRN NO</th><th scope="col">Invoice No</th><th scope="col">Inward Date</th><th scope="col">Supplier Name</th><th scope="col"></th></tr></thead></tbody>';
            inward_subdetails = msg[0].SubInward;
            var inward = msg[0].InwardDetails;

            var k = 1;
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            for (var i = 0; i < inward.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">';//<td><input id="btn_poplate" type="button"  onclick="update(this)" name="Approval" class="btn btn-primary" value="Approval" /></td>
                results += '<td data-title="sno" class="19">' + inward[i].sno + '</td>';
                results += '<td data-title="invoiceno" class="2">' + inward[i].mrnno + '</td>';
                results += '<td data-title="invoiceno" class="20">' + inward[i].invoiceno + '</td>';
                results += '<td data-title="inwarddate" class="3">' + inward[i].inwarddate + '</td>';
                results += '<td data-title="invoicedate" class="4" style="display:none;">' + inward[i].invoicedate + '</td>';
                results += '<td data-title="dcno" class="5" style="display:none;">' + inward[i].dcno + '</td>';
                results += '<td data-title="lrno" class="6" style="display:none;">' + inward[i].lrno + '</td>';
                results += '<td data-title="name" class="7" >' + inward[i].name + '</td>';
                results += '<td data-title="podate" class="8" style="display:none;">' + inward[i].podate + '</td>';
                results += '<td data-title="doorno" class="9" style="display:none;">' + inward[i].doorno + '</td>';
                results += '<td data-title="remarks" class="10" style="display:none;">' + inward[i].remarks + '</td>';
                results += '<td data-title="pono" class="11" readonly style="display:none;">' + inward[i].pono + '</td>';
                results += '<td data-title="pono" class="15" style="display:none;">' + inward[i].modeofinward + '</td>';
                results += '<td data-title="pono" class="16" style="display:none;">' + inward[i].vehicleno + '</td>';
                results += '<td data-title="pono" class="17" style="display:none;">' + inward[i].transportname + '</td>';
                results += '<td data-title="pono" class="18" style="display:none;">' + inward[i].securityno + '</td>';
                results += '<td data-title="brandstatus"><button type="button" title="Click Here To Approve!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 apprvcls" onclick="update(this)"><span class="glyphicon glyphicon-thumbs-up" style="top: 0px !important;"></span></button></td>';
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
            $('#inward_fillform').css('display', 'block');
            $('#div_inwardtable').hide();
            scrollTo(0, 0);
            var invoiceno = $(thisid).parent().parent().children('.20').html();
            var inwarddate = $(thisid).parent().parent().children('.3').html();
            var invoicedate = $(thisid).parent().parent().children('.4').html();
            var dcno = $(thisid).parent().parent().children('.5').html();
            var lrno = $(thisid).parent().parent().children('.6').html();
            var name = $(thisid).parent().parent().children('.7').html();
            var podate = $(thisid).parent().parent().children('.8').html();
            var doorno = $(thisid).parent().parent().children('.9').html();
            var remarks = $(thisid).parent().parent().children('.10').html();
            var pono = $(thisid).parent().parent().children('.11').html();
            var sno = $(thisid).parent().parent().children('.19').html();
            var hiddensupplyid = $(thisid).parent().parent().children('.14').html();
            var modeofinward = $(thisid).parent().parent().children('.15').html();
            var vehicleno = $(thisid).parent().parent().children('.16').html();
            var transportname = $(thisid).parent().parent().children('.17').html();
            var securityno = $(thisid).parent().parent().children('.18').html();

            document.getElementById('txt_inwarddate').innerHTML = inwarddate;
            document.getElementById('txt_invoice').innerHTML = invoiceno;
            document.getElementById('txt_invoicedate').innerHTML = invoicedate;
            document.getElementById('txt_dcno').innerHTML = dcno;
            document.getElementById('txt_lrno').innerHTML = lrno;
            document.getElementById('txtSuplyname').innerHTML = name;
            document.getElementById('txt_podate').innerHTML = podate;
            document.getElementById('txt_pono').innerHTML = pono;
            document.getElementById('txt_doorno').innerHTML = doorno;
            document.getElementById('txt_remarks').innerHTML = remarks;
            document.getElementById('txtsupid').innerHTML = hiddensupplyid;
            document.getElementById('lbl_sno').innerHTML = sno;
            document.getElementById('slct_mdeofinwrd').innerHTML = modeofinward;
            document.getElementById('txtvehiclenumber').innerHTML = vehicleno;
            document.getElementById('txtsecurenum').innerHTML = securityno;
            document.getElementById('txttransportname').innerHTML = transportname;
            document.getElementById('btn_RaisePO').innerHTML = "Approve";
            var table = document.getElementById("tabledetails");

            var todaydate = inwarddate.split('-');
            //var todaydate = "2017-07-17".split('-');
            var date = "2017-07-01".split('-');

            var firstDate = new Date();
            firstDate.setFullYear(todaydate[0], (todaydate[1] - 1), todaydate[2]);
            var secondDate = new Date();
            secondDate.setFullYear(date[0], (date[1] - 1), date[2]);

            if (firstDate < secondDate) {
                var results = '<div  style="overflow:auto;"><table ID="tabledetails" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" >';
                results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Per Unit Rs</th><th scope="col">Quantity</th><th scope="col">Total Cost</th><th scope="col"></th></tr></thead></tbody>';
                var k = 1;
                for (var i = 0; i < inward_subdetails.length; i++) {
                    if (sno == inward_subdetails[i].inword_refno) {
                        results += '<tr><td data-title="Sno" class="1">' + k + '</td>';
                        results += '<th data-title="From"><span id="spn_productname">' + inward_subdetails[i].productname + '</span><input id="txtProductname" readonly class="productcls"  name="productname" value="' + inward_subdetails[i].productname + '" style="display:none;width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                        results += '<th data-title="From"><span id="spn_perunitrs">' + inward_subdetails[i].PerUnitRs + '</span><input class="price" id="txt_perunitrs" readonly name="PerUnitRs" onkeypress="return isFloat(event)"  value="' + inward_subdetails[i].PerUnitRs + '" style="display:none;width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                        results += '<th data-title="From"><span id="spn_quantity">' + inward_subdetails[i].quantity + '</span><input class="quantity"  id="txt_quantity" readonly onkeypress="return isFloat(event)" name="Quantity" value="' + inward_subdetails[i].quantity + '" style="display:none;width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                        results += '<th data-title="From"><span id="spn_Total">' + inward_subdetails[i].totalcost + '</span><input class="Total" readonly id="txtTotal" readonly onkeypress="return isFloat(event)" name="TotalCost" value="' + inward_subdetails[i].totalcost + '" style="display:none;width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                        results += '<th style="display:none"><input class="5" id="hdnproductsno" type="hidden"  name="hdnproductsno" value="' + inward_subdetails[i].hdnproductsno + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input>';
                        results += '<th style="display:none"><input class="6" id="subsno" type="hidden" name="subsno" value="' + inward_subdetails[i].sisno + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input>';
                        results += '<td><span onclick="removerow1(this)"><img src="images/minus.png" style="cursor:pointer"/></span></td>';
                        results += '<th data-title="From" style="display:none"><input class="7" id="txt_sub_sno" name="txt_sub_sno" value="' + inward_subdetails[i].sno + '"style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td></tr>';
                        ProductTable.push(inward_subdetails[i].sku);
                        k++;
                    }
                }
                results += '</table></div>';
                $("#div_inward_ProductsData").html(results);
            }
            else {
                var results = '<div  style="overflow:auto;"><table ID="tabledetails" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" >';
                results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Per Unit Rs</th><th scope="col">Quantity</th><th scope="col">SGST %</th><th scope="col">CGST %</th><th scope="col">IGST %</th><th scope="col">Total Cost</th><th scope="col"></th></tr></thead></tbody>';
                var k = 1;
                for (var i = 0; i < inward_subdetails.length; i++) {
                    if (sno == inward_subdetails[i].inword_refno) {
                        results += '<tr><td data-title="Sno" class="1">' + k + '</td>';
                        results += '<td class="tdmaincls"><span id="spn_productname">' + inward_subdetails[i].productname + '</span><input id="txtProductname" readonly class="productcls"  name="productname" value="' + inward_subdetails[i].productname + '" style="display:none;width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                        results += '<td class="tdmaincls"><span id="spn_perunitrs">' + inward_subdetails[i].PerUnitRs + '</span><input class="price" id="txt_perunitrs" readonly name="PerUnitRs" onkeypress="return isFloat(event)"  value="' + inward_subdetails[i].PerUnitRs + '" style="display:none;width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                        results += '<td class="tdmaincls"><span id="spn_quantity">' + inward_subdetails[i].quantity + '</span><input class="quantity"  id="txt_quantity" readonly onkeypress="return isFloat(event)" name="Quantity" value="' + inward_subdetails[i].quantity + '" style="display:none;width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                        results += '<td class="tdmaincls"><span id="spn_sgst">' + inward_subdetails[i].sgst_per + '</span><input class="sgst" readonly id="txt_sgst" readonly onkeypress="return isFloat(event)" name="TotalCost" value="' + inward_subdetails[i].sgst_per + '" style="display:none;width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                        results += '<td class="tdmaincls"><span id="spn_cgst">' + inward_subdetails[i].cgst_per + '</span><input class="cgst" readonly id="txt_cgst" readonly onkeypress="return isFloat(event)" name="TotalCost" value="' + inward_subdetails[i].cgst_per + '" style="display:none;width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                        results += '<td class="tdmaincls"><span id="spn_igst">' + inward_subdetails[i].igst_per + '</span><input class="igst" readonly id="txt_igst" readonly onkeypress="return isFloat(event)" name="TotalCost" value="' + inward_subdetails[i].igst_per + '" style="display:none;width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                        results += '<td class="tdmaincls"><span id="spn_Total">' + inward_subdetails[i].totalcost + '</span><input class="Total" readonly id="txtTotal" readonly onkeypress="return isFloat(event)" name="TotalCost" value="' + inward_subdetails[i].totalcost + '" style="display:none;width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                        results += '<td class="tdmaincls" style="display:none"><input class="5" id="hdnproductsno" type="hidden"  name="hdnproductsno" value="' + inward_subdetails[i].hdnproductsno + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input>';
                        results += '<td class="tdmaincls" style="display:none"><input class="6" id="subsno" type="hidden" name="subsno" value="' + inward_subdetails[i].sisno + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input>';
                        results += '<td><span onclick="removerow1(this)"><img src="images/minus.png" style="cursor:pointer"/></span></td>';
                        results += '<th data-title="From" style="display:none"><input class="7" id="txt_sub_sno" name="txt_sub_sno" value="' + inward_subdetails[i].sno + '"style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td></tr>';
                        ProductTable.push(inward_subdetails[i].sku);
                        k++;
                    }
                }
                results += '</table></div>';
                $("#div_inward_ProductsData").html(results);
            }
            
        }
        function removerow1(thisid) {
            $(thisid).parents('tr').remove();
        }
        function approval_pending_inward_click() {
            var inwardsno = document.getElementById('lbl_sno').innerHTML;
            var status = document.getElementById('ddlstatus').value;
            if (status == "") {

                alert("select status");
            }

            var fillitems = [];
            $('#tabledetails> tbody > tr').each(function () {
                var productname = $(this).find('#txtProductname').val();
                var PerUnitRs = $(this).find('#txt_perunitrs').val();
                var Quantity = $(this).find('#txt_quantity').val();
                var hdnproductsno = $(this).find('#hdnproductsno').val();
                if (hdnproductsno == "" || hdnproductsno == "0") {
                }
                else {
                    fillitems.push({ 'productname': productname, 'PerUnitRs': PerUnitRs, 'Quantity': Quantity, 'hdnproductsno': hdnproductsno
                    });
                }
            });
            if (fillitems.length == 0) {
                alert("Please Select Product Names");
                return false;
            }
            var Data = { 'op': 'approval_pending_inward_click', 'inwardsno': inwardsno, 'status': status, 'fillitems': fillitems };
            var s = function (msg) {
                if (msg) {
                    alert(msg);
                    $('#inward_fillform').css('display', 'none');
                    $('#div_inwardtable').show();
                    getallinward();
                    forclearall();
                }
            }
            var e = function (x, h, e) {
            };
            CallHandlerUsingJson(Data, s, e);
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
        function forclearall() {
            document.getElementById('txt_inwarddate').value = "";
            document.getElementById('txt_invoice').value = "";
            document.getElementById('txt_invoicedate').value = "";
            document.getElementById('txt_dcno').value = "";
            document.getElementById('txt_lrno').value = "";
            document.getElementById('txtSuplyname').value = "";
            document.getElementById('txt_podate').value = "";
            document.getElementById('txt_pono').value = "";
            document.getElementById('txt_doorno').value = "";
            document.getElementById('txt_remarks').value = "";
            document.getElementById('slct_mdeofinwrd').selectedIndex = "";
            document.getElementById('txtvehiclenumber').value = "";
            document.getElementById('txtsecurenum').value = "";
            document.getElementById('txttransportname').value = "";
            document.getElementById('lbl_sno').value = "";
            document.getElementById('btn_RaisePO').innerHTML = "Save";
            var empty = [];
            var results = '<div  style="overflow:auto;"><table id="tabledetails" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Per Unit Rs</th><th scope="col">Quantity</th><th scope="col">Total Cost</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < empty.length; i++) {
            }
            results += '</table></div>';
            $("#div_inward_ProductsData").html(results);
            scrollTo(0, 0);
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Inward Entry Approval<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operations</a></li>
            <li><a href="#">Inward Entry Approval</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Inward Entry Approval Details
                </h3>
            </div>
            <div class="box-body">
                <div id="div_inwardtable">
                </div>
                <div id='inward_fillform' style="display: none;">
                    <table align="center">
                        <tr>
                            <td style="height: 40px;">
                                <label>
                                    Inward Date</label><span style="color: red;">*</span>
                                <div class="input-group date" style="width:100%;">
                                  <div class="input-group-addon cal">
                                    <i class="fa fa-calendar"></i>
                                  </div>
                                  <span id="txt_inwarddate" class="form-control" type="date" />
                                </div>
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;width: 48%;">
                                <label>
                                    Inward Number</label><span style="color: red;">*</span>
                                <span id="txt_inwardno" class="form-control" type="text" readonly placeholder="Enter Inward Number" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>
                                    Invoice Number</label>
                                <span id="txt_invoice" class="form-control" type="text" onkeypress="return isNumber(event)"
                                    placeholder="Enter Invoice Number" />
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
                                  <span id="txt_invoicedate" class="form-control" type="date" />
                                </div>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>
                                    DC Number</label><span style="color: red;">*</span>
                                <span id="txt_dcno" class="form-control" type="text" onkeypress="return isNumber(event)"
                                    placeholder="Enter DC Number" />
                            </td>
                            <td>
                            </td>
                            <td style="height: 40px;">
                                <label>
                                    LR Number</label>
                                <span id="txt_lrno" class="form-control" type="text" onkeypress="return isNumber(event)"
                                    placeholder="Enetr LR Number" />
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>
                                    Supplier Name</label><span style="color: red;">*</span>
                                <span id="txtSuplyname" class="form-control" type="text" placeholder="Select Supplier Name"
                                    onkeypress="return ValidateAlpha(event);" />
                            </td>
                            <td>
                            </td>
                            <td style="height: 40px;">
                                <label>
                                    PO Date</label>
                                <div class="input-group date" style="width:100%;">
                                  <div class="input-group-addon cal">
                                    <i class="fa fa-calendar"></i>
                                  </div>
                                  <span id="txt_podate" class="form-control" />
                                </div>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>
                                    Mode of Inward</label>
                                <span id="slct_mdeofinwrd" class="form-control">
                                    <option value="Select Mode of Inward" disabled selected>Select Mode of Inward</option>
                                    <option value="Cash">Cash</option>
                                    <option value="Credit">Credit</option>
                                    <option value="CheckPaid">CheckPaid</option>
                                    <option value="FOC">FOC</option>
                                    <option value="Refurbished">Refurbished</option>
                                    <option value="Warranty">Warranty</option>
                                    <option value="Transported">Transported</option>
                                    <option value="Returnble">Returnble</option>
                                    <option value="AgainstLoan">AgainstLoan</option>
                                    <option value="Repair">Repair</option>
                                    <option value="AuditCorrrection">AuditCorrrection</option></select>
                            </td>
                            <td>
                            </td>
                            <td style="height: 40px;">
                                <label>
                                    PO Number</label>
                                <span id="txt_pono" class="form-control" type="text" onkeypress="return isNumber(event)"
                                    placeholder="Enetr PO Number" onchange="ponumber(this);" />
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>
                                    Door Number</label>
                                <span id="txt_doorno" class="form-control" type="text" placeholder="Door Number" />
                            </td>
                            <td>
                            </td>
                            <td style="height: 40px;">
                                <label>
                                    Security Number</label>
                                <span id="txtsecurenum" class="form-control" type="text" onkeypress="return isNumber(event)"
                                    placeholder="security Number" />
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>
                                    Name Of the Transport</label>
                                <span id="txttransportname" class="form-control" type="text" placeholder="Enter TransPort Name"
                                    onkeypress="return ValidateAlpha(event);" />
                            </td>
                            <td>
                            </td>
                            <td style="height: 40px;">
                                <label>
                                    Vehicle Number</label>
                                <span id="txtvehiclenumber" class="form-control" type="text" placeholder="Vehicle Number" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3">
                                <label>
                                    Remarks</label>
                                <span id="txt_remarks" class="form-control" rows="4" cols="45" placeholder="Enter Remarks">
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>
                                    Status</label>
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
                    <br />
                    <br />
                    <div id="div_inward_ProductsData">
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
                                        <span class="glyphicon glyphicon-ok" id="btn_RaisePO1" onclick="approval_pending_inward_click()"></span> <span id="btn_RaisePO" onclick="approval_pending_inward_click()">Approval</span>
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
