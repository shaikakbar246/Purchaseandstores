<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true"
    CodeFile="PurchaseOrder_New.aspx.cs" Inherits="PurchaseOrder" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <%--<script src="js/jquery-1.4.4.js" type="text/javascript"></script>--%>
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            scrollTo(0, 0);
            $('#btn_addDept').click(function () {
                scrollTo(0, 0);
                $('#PurchaseOrder_FillForm').css('display', 'block');
                $('#showlogs').css('display', 'none');
                $('#div_POData').hide();
                $('#newrow').css('display', 'block');
                get_TAX();
                get_DelivaryTerms();
                get_PaymentDetails();
                get_PandF();
                get_productcode();
                get_supplier();
                //GetFixedrows();
                get_Address();
                emptytable1 = [];
                emptytable = [];
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
                $('#txtDelivaryDate').val(yyyy + '-' + mm + '-' + dd);
                $('#txtPoDate').val(yyyy + '-' + mm + '-' + dd);
                $('#txtExipredate').val(yyyy + '-' + mm + '-' + dd);
                $('#txtQtnDate').val(yyyy + '-' + mm + '-' + dd);
            });
            $('#close_vehmaster').click(function () {
                $('#PurchaseOrder_FillForm').css('display', 'none');
                $('#showlogs').css('display', 'block');
                $('#div_POData').show();
                forclearall();
                emptytable1 = [];
                emptytable = [];
            });
            get_purchaseorder_details();
            get_DelivaryTerms();
            get_PaymentDetails();
            get_PandF();
            forclearall();
            get_Address();
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
            $('#txtDelivaryDate').val(yyyy + '-' + mm + '-' + dd);
            $('#txtPoDate').val(yyyy + '-' + mm + '-' + dd);
            $('#txtExipredate').val(yyyy + '-' + mm + '-' + dd);
            $('#txtQtnDate').val(yyyy + '-' + mm + '-' + dd);
            emptytable1 = [];
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

        var supperdetails = [];
        function get_supplier() {
            var data = { 'op': 'get_supplier' };
            var s = function (msg) {
                if (msg) {
                    supperdetails = msg;
                    var availableTags = [];
                    for (i = 0; i < msg.length; i++) {
                        availableTags.push(msg[i].companyname);
                    }
                    $("#txtshortName").autocomplete({
                        source: function (req, responseFn) {
                            var re = $.ui.autocomplete.escapeRegex(req.term);
                            var matcher = new RegExp("^" + re, "i");
                            var a = $.grep(availableTags, function (item, index) {
                                return matcher.test(item);
                            });
                            responseFn(a);
                        },
                        change: ravi,
                        autoFocus: true
                    });
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        function ravi() {
            //alert('hi')
            var name = document.getElementById('txtshortName').value;
            for (var i = 0; i < supperdetails.length; i++) {
                if (name == supperdetails[i].companyname) {
                    document.getElementById('txtName').value = supperdetails[i].name;
                    document.getElementById('txtsupid').value = supperdetails[i].supplierid;
                }
            }
        }
        var DataTable;
        function removerow(thisid) {
            $(thisid).parents('tr').remove();
        }
        var replaceHtmlEntites = (function () {
            return function (s) {
                return (s.replace(translate_re, function (match, entity) {
                    return translate[entity];
                }));
            }
        })();
        function save_edit_podetails_click() {
            var ven_quo_no = document.getElementById('txt_ven_quo_no').value;
            var indent_no = document.getElementById('txt_indent_no').value;
            var PONo = document.getElementById('lblsno').value;
            var name = document.getElementById('txtName').value;
            var shortname = document.getElementById('txtshortName').value;
            var poamount = document.getElementById('txtPoamount').innerHTML;
            var delivarydate = document.getElementById('txtDelivaryDate').value;
            var freigtamt = document.getElementById('txtFrAmt').value;
            var billingaddress = document.getElementById('ddlAddress1').value;
            var address = document.getElementById('ddlAddress').value;
            var pf = document.getElementById('ddlpf').value;
            var terms = document.getElementById('ddlterms').value;
            var transport_charges = document.getElementById('txt_transport').value;
            var pricebasis = document.getElementById('ddlprice').value;
            var remarks = document.getElementById('txtRemarks').value;
            var payment = document.getElementById('ddlpayment').value;
            var quotationno = document.getElementById('txtQutn').value;
            var quotationdate = document.getElementById('txtQtnDate').value;
            var hiddensupplyid = document.getElementById('txtsupid').value;
            var btnval = document.getElementById('btn_RaisePO').value;
            var status = "P";
            if (name == "") {
                alert("Enter  Supplier Name");
                return false;
            }
            if (shortname == "") {
                alert("Enter  CompanyName");
                return false;
            }
            if (delivarydate == "") {
                alert("Select  Delivarydate");
                return false;
            }
            var purchage_array = [];
            $('#tabledetails> tbody > tr').each(function () {
                var txtsno = $(this).find('#txtSno').text();
                var code = $(this).find('#txtCode').val();
                var description = $(this).find('#txtDescription').val();
                var qty = $(this).find('#txtQty').val();
                var cost = $(this).find('#txtCost').val();
                //var free = $(this).find('#txtFree').val();
                var taxtype = $(this).find('#ddlTaxtype').val();
                var ed = $(this).find('#ddlEd').val();
                var dis = $(this).find('#txtDis').val();
                var disamt = $(this).find('#txtDisAmt').val();
                var tax = $(this).find('#txtTax').val();
                var edtax = $(this).find('#txtEdtax').val();
                var productamount = $(this).find('#spn_total').text();
                var sno = $(this).find('#txt_sub_sno').val();
                var hdnproductsno = $(this).find('#hdnproductsno').val();
                if (hdnproductsno == "" || hdnproductsno == "0") {
                }
                else {
                    purchage_array.push({ 'txtsno': txtsno, 'code': code, 'description': description, 'qty': qty, 'cost': cost, 'dis': dis, 'disamt': disamt, 'taxtype': taxtype, 'ed': ed, 'tax': tax, 'edtax': edtax, 'sno': sno, 'hdnproductsno': hdnproductsno, 'productamount': productamount });
                }
            });
            var Data = { 'op': 'save_edit_po_click', 'indent_no': indent_no, 'remarks': remarks, 'pono': PONo, 'shortname': shortname, 'poamount': poamount, 'name': name, 'delivarydate': delivarydate, 'terms': terms, 'pf': pf, 'freigntamt': freigtamt, 'quotationno': quotationno, 'quotationdate': quotationdate, 'payment': payment, 'hiddensupplyid': hiddensupplyid, 'btnval': btnval, 'status': status, 'pricebasis': pricebasis, 'address': address, 'billingaddress': billingaddress, 'transport_charges': transport_charges, 'Purchase_subarray': purchage_array };
            var s = function (msg) {
                if (msg) {
                    alert(msg);
                    get_purchaseorder_details();
                    $('#PurchaseOrder_FillForm').css('display', 'none');
                    $('#showlogs').css('display', 'block');
                    $('#div_POData').show();
                    forclearall();
                }
            }
            var e = function (x, h, e) {
            };
            CallHandlerUsingJson(Data, s, e);
        }
        function get_purchaseorder_details() {
            var data = { 'op': 'get_purchase_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillpurchase_details(msg);
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
        var purchase_sub_list = [];
        function fillpurchase_details(msg) {
            get_TAX();
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr><th scope="col"></th><th scope="col"></th><th scope="col">Ref NO</th><th scope="col">Po No</th><th scope="col">Supplier Name</th><th scope="col">Po Date</th></tr></thead></tbody>';
            var po = msg[0].podetails;
            purchase_sub_list = msg[0].subpurchasedetails;
            var k = 1;
            var l = 0;
            //var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            for (var i = 0; i < po.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '"><td><input id="btn_poplate" type="button"  onclick="getpurchasevalues(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
                results += '<td><input id="btn_Print" type="button"   onclick="prntPo(this);"  name="Edit" class="btn btn-primary" value="Print" /></td>'
                results += '<td class="12"  onclick="subpurchaseproduct(\'' + po[i].pono + '\');">' + po[i].pono + '</td>';
                results += '<td data-title="podate" class="5">' + po[i].ponumber + '</td>';
                results += '<td data-title="name" class="1">' + po[i].name + '</td>';
                results += '<td data-title="delivarydate" style="display:none;" class="3">' + po[i].delivarydate + '</td>';
                results += '<td data-title="expiredate" class="4">' + po[i].podate + '</td>';
                results += '<td data-title="poamount" style="display:none;" class="6">' + po[i].poamount + '</td>';
                results += '<td data-title="shortname" class="7" style="display:none;">' + po[i].shortname + '</td>';
                results += '<td data-title="freigntamt" class="8" style="display:none;">' + po[i].freigntamt + '</td>';
                results += '<td data-title="freigntamt" class="29" style="display:none;">' + po[i].transport_charges + '</td>';
                results += '<td data-title="email" class="14" style="display:none;">' + po[i].billingaddress + '</td>';
                results += '<td data-title="address" class="15" style="display:none;">' + po[i].addressid + '</td>';
                results += '<td data-title="quotationno" class="16" style="display:none;">' + po[i].quotationno + '</td>';
                results += '<td data-title="quotationdate" class="17" style="display:none;">' + po[i].quotationdate + '</td>';
                results += '<td data-title="quotationdate" class="22" style="display:none;">' + po[i].payment + '</td>';
                results += '<td data-title="quotationdate" class="20" style="display:none;">' + po[i].terms + '</td>';
                results += '<td data-title="quotationdate" class="21" style="display:none;">' + po[i].pf + '</td>';
                results += '<td data-title="quotationdate" class="26" style="display:none;">' + po[i].remarks + '</td>';
                results += '<td data-title="quotationdate" class="30" style="display:none;">' + po[i].indent_no + '</td>';
                results += '<td data-title="quotationdate" class="27" style="display:none;">' + po[i].pricebasis + '</td>';
                results += '<td data-title="hiddensupplyid" class="18" style="display:none;">' + po[i].hiddensupplyid + '</td>';
                results += '<td data-title="sno" class="13" style="display:none;">' + po[i].sno + '</td></tr>';

                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }

            results += '</table></div>';
            $("#div_POData").html(results);
        }
        var sno = 0;
        function getpurchasevalues(thisid) {
            scrollTo(0, 0);
            get_supplier();
            get_productcode();
            get_TAX();
            clstotalval();
            calTotal();
            $('#PurchaseOrder_FillForm').css('display', 'block');
            $('#showlogs').css('display', 'none');
            $('#div_POData').hide();
            $('#newrow').css('display', 'none');
            var name = $(thisid).parent().parent().children('.1').html();
            var delivarydate2 = $(thisid).parent().parent().children('.3').html();
            var poamount = $(thisid).parent().parent().children('.6').html();
            var shortname = $(thisid).parent().parent().children('.7').html();
            var freigntamt = $(thisid).parent().parent().children('.8').html();
            var transport_charges = $(thisid).parent().parent().children('.29').html();
            var PONo = $(thisid).parent().parent().children('.12').html();
            var sno = $(thisid).parent().parent().children('.13').html();
             var billingaddress = $(thisid).parent().parent().children('.14').html();
             var address = $(thisid).parent().parent().children('.15').html();
            var quotationno = $(thisid).parent().parent().children('.16').html();
            var quotationdate2 = $(thisid).parent().parent().children('.17').html();
            var terms = $(thisid).parent().parent().children('.20').html();
            var pf = $(thisid).parent().parent().children('.21').html();
            var payment = $(thisid).parent().parent().children('.22').html();
            var remarks = $(thisid).parent().parent().children('.26').html();
            var pricebasis = $(thisid).parent().parent().children('.27').html();
            var hiddensupplyid = $(thisid).parent().parent().children('.18').html();
            var indent_no = $(thisid).parent().parent().children('.30').html();

            var delivarydate1 = delivarydate2.split('-');
            var delivarydate = delivarydate1[2] + '-' + delivarydate1[1] + '-' + delivarydate1[0];

            var quotationdate1 = quotationdate2.split('-');
            var quotationdate = quotationdate1[2] + '-' + quotationdate1[1] + '-' + quotationdate1[0];

            document.getElementById('txtName').value = name;
            document.getElementById('lblsno').value = PONo;
            document.getElementById('txtshortName').value = shortname;
            document.getElementById('txtPoamount').innerHTML = poamount;
            document.getElementById('txtDelivaryDate').value = delivarydate;
            document.getElementById('ddlAddress').value = address;
            document.getElementById('ddlAddress1').value = billingaddress;
            document.getElementById('txtFrAmt').value = freigntamt;
            document.getElementById('txt_transport').value = transport_charges;
            document.getElementById('txtQutn').value = quotationno;
            document.getElementById('ddlterms').value = terms;
            document.getElementById('ddlpf').value = pf;
             document.getElementById('ddlprice').value = pricebasis;
            document.getElementById('txtRemarks').value = remarks;
            document.getElementById('txtQtnDate').value = quotationdate;
            document.getElementById('ddlpayment').value = payment;
            document.getElementById('txtsupid').value = hiddensupplyid;
            if (indent_no != "")
            {
                document.getElementById('txt_indent_no').value = indent_no;
            }
            document.getElementById('btn_RaisePO').value = "Modify";
            var table = document.getElementById("tabledetails");
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Code</th><th scope="col">Description</th><th scope="col">UOM</th><th scope="col">Qty</th><th scope="col">Rate</th><th scope="col">Dis%</th><th scope="col">Dis Amt</th><th scope="col">Tax Type</th><th scope="col">Tax%</th><th scope="col">ED</th><th scope="col">ED Tax%</th><th scope="col"></th></tr></thead></tbody>';
            var k = 1;
            for (var i = 0; i < purchase_sub_list.length; i++) {
                if (PONo == purchase_sub_list[i].pono) {
                    if (indent_no != "") {
                        results += '<tr><td data-title="Sno" class="1">' + k + '</td>';
                        results += '<td ><input id="txtCode" class="codecls" name="code" readonly value="' + purchase_sub_list[i].code + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                        results += '<td ><input class="3" id="txtDescription"  name="description" readonly class="clsdesc" value="' + purchase_sub_list[i].description + '" style="width:90px; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                        results += '<td ><input  class="clsUom" id="txtUom" name="cost"  value="' + purchase_sub_list[i].uim + '" onkeypress="return isFloat(event)" style="width:60px; font-size:12px;padding: 0px 5px;height:30px;display:none"></td>';
                        results += '<td ><input class="clsQty" id="txtQty"  name="qty"  value="' + purchase_sub_list[i].qty + '" onkeypress="return isFloat(event)" style="width:60px; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                        results += '<td ><input  class="clscost" id="txtCost" name="cost"  value="' + purchase_sub_list[i].cost + '" onkeypress="return isFloat(event)" style="width:60px; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                        results += '<td ><input  id="txtDis" name="dis" class="clsdis" value="' + purchase_sub_list[i].dis + '" onkeypress="return isFloat(event)"  style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                        results += '<td ><input  id="txtDisAmt" class="clsdisamt" name="disamt" value="' + purchase_sub_list[i].disamt + '" onkeypress="return isFloat(event)" style="width:60px; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                        //results += '<td data-title="From"><input id="ddlTaxtype1" type="text" readonly class="Taxtypecls" name="taxname"   value="' + purchase_sub_list[i].taxname + '"  style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"/></td>';
                        results += '<td ><select id="ddlTaxtype" class="Taxtypecls" name="taxtype"   value="' + purchase_sub_list[i].taxtype + '"  style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></select></td>';
                        results += '<td ><input  id="txtTax" class="clstax"  name="tax" value="' + purchase_sub_list[i].tax + '" onkeypress="return isFloat(event)" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                        //results += '<td data-title="From"><input id="ddlEd1" type="text" readonly class="edcls"  name="edname"  value="' + purchase_sub_list[i].edname + '"  style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"/></td>';
                        results += '<td ><select id="ddlEd" class="edcls"  name="ed"  value="' + purchase_sub_list[i].ed + '"  style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></select></td>';
                        results += '<td ><input  id="txtEdtax" name="edtax" class="clsed" value="' + purchase_sub_list[i].edtax + '" onkeypress="return isFloat(event)" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                        results += '<td><span id="spn_total"  class="clstotal"  onkeypress="return isFloat(event)"style="width:500px;">' + purchase_sub_list[i].productamount + '</span></td>';
                        results += '<td style="display:none" data-title="From"><input class="13" id="hdnproductsno" type="hidden" name="hdnproductsno" value="' + purchase_sub_list[i].hdnproductsno + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                        results += '<td data-title="Minus"><span><img src="images/minus.png" onclick="removerow(this)" style="cursor:pointer"/></span></td>';
                        results += '<td style="display:none"><input class="14" id="txt_sub_sno" name="txt_sub_sno" value="' + purchase_sub_list[i].sno + '"style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td></tr>';
                        k++;
                    }
                    else {
                        results += '<tr><td data-title="Sno" class="1">' + k + '</td>';
                        results += '<td data-title="From"><input id="txtCode" class="codecls" name="code" readonly value="' + purchase_sub_list[i].code + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                        results += '<td data-title="From"><input class="3" id="txtDescription"  name="description" readonly class="clsdesc" value="' + purchase_sub_list[i].description + '" style="width:90px; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                        results += '<td data-title="From"><input  class="clsUom" id="txtUom" name="cost"  value="' + purchase_sub_list[i].uim + '" onkeypress="return isFloat(event)" style="width:60px; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                        results += '<td data-title="From"><input class="clsQty" id="txtQty"  name="qty"  value="' + purchase_sub_list[i].qty + '" onkeypress="return isFloat(event)" style="width:60px; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                        results += '<td data-title="From"><input  class="clscost" id="txtCost" name="cost"  value="' + purchase_sub_list[i].cost + '" onkeypress="return isFloat(event)" style="width:60px; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                        results += '<td data-title="From"><input  id="txtDis" name="dis" class="clsdis" value="' + purchase_sub_list[i].dis + '" onkeypress="return isFloat(event)"  style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                        results += '<td data-title="From"><input  id="txtDisAmt" class="clsdisamt" name="disamt" value="' + purchase_sub_list[i].disamt + '" onkeypress="return isFloat(event)" style="width:60px; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                        results += '<td data-title="From"><input id="ddlTaxtype1" type="text" readonly class="Taxtypecls" name="taxname"   value="' + purchase_sub_list[i].taxname + '"  style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"/></td>';
                        results += '<td style="display:none" data-title="From"><input id="ddlTaxtype" type="text" readonly class="Taxtypecls1" name="taxtype"   value="' + purchase_sub_list[i].taxtype + '"  style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"/></td>';
                        results += '<td data-title="From"><input  id="txtTax" class="clstax"  name="tax" value="' + purchase_sub_list[i].tax + '" onkeypress="return isFloat(event)" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                        results += '<td data-title="From"><input id="ddlEd1" type="text" readonly class="edcls"  name="edname"  value="' + purchase_sub_list[i].edname + '"  style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"/></td>';
                        results += '<td style="display:none" data-title="From"><input id="ddlEd" type="text" readonly class="edcls1"  name="ed"  value="' + purchase_sub_list[i].ed + '"  style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"/></td>';
                        results += '<td data-title="From"><input  id="txtEdtax" name="edtax" class="clsed" value="' + purchase_sub_list[i].edtax + '" onkeypress="return isFloat(event)" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                        results += '<td><span id="spn_total"  class="clstotal"  onkeypress="return isFloat(event)"style="width:500px;">' + purchase_sub_list[i].productamount + '</span></td>';
                        results += '<td style="display:none" data-title="From"><input class="13" id="hdnproductsno" type="hidden" name="hdnproductsno" value="' + purchase_sub_list[i].hdnproductsno + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                        results += '<td data-title="Minus"><span><img src="images/minus.png" onclick="removerow(this)" style="cursor:pointer"/></span></td>';
                        results += '<td data-title="From" style="display:none"><input class="14" id="txt_sub_sno" name="txt_sub_sno" value="' + purchase_sub_list[i].sno + '"style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td></tr>';
                        k++;
                    }
                    
                }
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
        }
        function fillcategoryvalues(msg) {
            scrollTo(0, 0);
            $('#divMainAddNewRow').css('display', 'block');
            $('#hiddeninward').css('display', 'none');
            $('#hiddenoutward').css('display', 'none');
            j = 1;
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr></th><th scope="col">Sno</th><th scope="col">ProductName</th><th scope="col">Price</th><th scope="col">Quantity</th><th scope="col">Value</th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '"><th scope="row" class="1" style="text-align:center;">' + j + '</th>';
                results += '<td data-title="inwarddate" class="2">' + msg[i].productname + '</td>';
                results += '<td data-title="inwarddate" class="3">' + msg[i].price + '</td>';
                results += '<td data-title="inwarddate" class="4">' + msg[i].qty + '</td>';
                results += '<td data-title="invoicedate" class="tammountcls" >' + msg[i].StoresValue + '</td><tr>';
                j++;

                l = l + 1;
                if (l == 4) {
                    l = 0;
                }

            }
            results += '<tr><th scope="row" class="1" style="text-align:center;"></th>';
            results += '<td data-title="brandstatus" class="badge bg-yellow">Total</td>';
            results += '<td data-title="brandstatus" class="3"></td>';
            results += '<td data-title="brandstatus" class="4"></td>';
            results += '<td data-title="brandstatus" class="5"><span id="totalcls" class="badge bg-yellow"></span></td></tr>';
            results += '</table></div>';
            $("#ShowCategoryData").html(results);
            GettotalclsCal();
        }
        function GettotalclsCal() {
            var totamount = 0;
            $('.tammountcls').each(function (i, obj) {
                var qtyclass = $(this).text();
                if (qtyclass == "" || qtyclass == "0") {
                }
                else {
                    totamount += parseFloat(qtyclass);
                }
            });
            document.getElementById('totalcls').innerHTML = parseFloat(totamount).toFixed(2);
        }
        function CloseClick() {
            $('#divMainAddNewRow').css('display', 'none');
            $('#hiddeninward').css('display', 'block');
            $('#hiddenoutward').css('display', 'block');
            scrollTo(0, 0);
        }
        function subpurchaseproduct(pono) {
            var pono;
            var data = { 'op': 'purchaseorderproductname', 'psno': pono };
            var s = function (msg) {
                if (msg) {
                    if (msg) {
                        $('#divMainAddNewRow').css('display', 'none');
                        fillcategoryvalues(msg);
                    }
                    else {
                    }
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        function prntPo(thisid) {
            var psno = $(thisid).parent().parent().children('.12').html();
            var data = { 'op': 'get_Po_print', 'sno': psno };
            var s = function (msg) {
                if (msg) {
                    window.open("POReport.aspx", "_self");
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        function get_PaymentDetails() {
            var data = { 'op': 'get_PaymentDetails' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillpayment(msg);
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
        function clstotalval() {
            var totaamount = 0; var totalpfamount = 0;
            $('.clstotal').each(function (i, obj) {
                var totlclass = $(this).html();

                if (totlclass == "" || totlclass == "0") {
                }
                else {
                    totaamount += parseFloat(totlclass);
                }
            });

            var totalamount1 = parseFloat(totaamount) + parseFloat(fright) + parseFloat(transport_chrgs);//+ parseFloat(insurance_chrgs) + parseFloat(other_chrgs)
            var grandtotal = parseFloat(totalamount1);

            document.getElementById('txtPoamount').innerHTML = grandtotal.toFixed(2);
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
        var taxper = "";
        var edtotalval = "";
        var totalpoval = "";
        var totalclsval;
        var Discount = 0;
        var fright = 0;
        var transport_chrgs = 0;
        var insurance_chrgs = 0;
        var other_chrgs = 0;
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
        function calTotal() {
            $('#tabledetails> tbody > tr').each(function () {
                var quantity = $(this).find('#txtQty').val();
                var price = $(this).find('#txtCost').val();
                sum = quantity;
                discount1 = sum * price;
                var disper = $(this).find('#txtDis').val();
                totalval = parseFloat(discount1) * (disper) / 100 || 0;
                discount = discount1 - totalval;
                $(this).find('.clsdisamt').val(totalval);
                pf = document.getElementById("ddlpf");
                pf1 = pf.options[pf.selectedIndex].text;
                pfamt = pf1;
                tpfamt = parseFloat(pfamt) / 100;
                tpfamt1 = parseFloat(discount) * (tpfamt) || 0;
                
                var edval = $(this).find('#txtEdtax').val();
                edper = parseFloat(edval); /// 100;
                edtotalval = (discount * edper) / 100 || 0;
                Discountedpf = tpfamt1 + edtotalval + discount;
                var tax1 = $(this).find('#txtTax').val();
                taxper = parseFloat(tax1);
                totaltax = (Discountedpf * taxper) / 100 || 0;
                if (edtotalval == 0 || totaltax == 0) {
                    if (discount == 0) {
                        $(this).find('.clstotal').html(parseFloat(Discountedpf).toFixed(2));
                    }
                    else {
                        if (totaltax == 0) {
                            $(this).find('.clstotal').html(parseFloat(Discountedpf).toFixed(2));
                        }
                        else {
                            var withtaxval = parseFloat(totaltax) + parseFloat(Discountedpf);
                            $(this).find('.clstotal').html(parseFloat(withtaxval).toFixed(2));
                        }
                    }
                }
                else {
                    totalpoval = parseFloat(edtotalval) + parseFloat(totaltax) + parseFloat(tpfamt1) + parseFloat(discount);
                    $(this).find('.clstotal').html(parseFloat(totalpoval).toFixed(2));
                }
            });
            fright = document.getElementById('txtFrAmt').value || 0;
            transport_chrgs = document.getElementById('txt_transport').value || 0;
            //insurance_chrgs = document.getElementById('txt_insurance').value || 0;
            //other_chrgs = document.getElementById('txt_others').value || 0;

            clstotalval();
        }
        function fillpayment(msg) {
            var data = document.getElementById('ddlpayment');
            var length = data.options.length;
            document.getElementById('ddlpayment').options.length = null;
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].paymenttype != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].paymenttype;
                    option.value = msg[i].sno;
                    data.appendChild(option);
                }
            }
        }
        function get_PandF() {
            var data = { 'op': 'get_PandF' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillpf(msg);
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
        function fillpf(msg) {
            var data = document.getElementById('ddlpf');
            var length = data.options.length;
            document.getElementById('ddlpf').options.length = null;
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].pandf != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].pandf;
                    option.value = msg[i].sno;
                    data.appendChild(option);
                }
            }
        }
        function get_Address() {
            var data = { 'op': 'get_Address_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillDelivaryAddress(msg);
                        fillBillingAddress(msg);
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
        function fillDelivaryAddress(msg) {
            var data = document.getElementById('ddlAddress');
            var length = data.options.length;
            document.getElementById('ddlAddress').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "select DelivaryAddress";
            opt.value = "select DelivaryAddress";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].Address != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].Address;
                    option.value = msg[i].sno;
                    data.appendChild(option);
                }
            }
        }
        function fillBillingAddress(msg) {
            var data = document.getElementById('ddlAddress1');
            var length = data.options.length;
            document.getElementById('ddlAddress1').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "select BillingAddress";
            opt.value = "select BillingAddresss";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].Address != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].Address;
                    option.value = msg[i].sno;
                    data.appendChild(option);
                }
            }
        }
        function get_DelivaryTerms() {
            var data = { 'op': 'get_DelivaryTerms' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillterms(msg);
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
        function fillterms(msg) {
            var data = document.getElementById('ddlterms');
            var length = data.options.length;
            document.getElementById('ddlterms').options.length = null;
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].terms != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].terms;
                    option.value = msg[i].sno;
                    data.appendChild(option);
                }
            }
        }
        function get_TAX() {
            var data = { 'op': 'get_TAX' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillTax(msg);
                        fillED(msg);
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
            //$('.Taxtypecls').each(function () {
            //    var taxtype = $(this);
            //    taxtype[0].options.length = null;
            //    for (var i = 0; i < msg.length; i++) {
            //        if (msg[i].type != null) {
            //            if (msg[i].taxtype == "Tax") {
            //                var option = document.createElement('option');
            //                option.innerHTML = msg[i].type;
            //                option.value = msg[i].sno;
            //                taxtype[0].appendChild(option);
            //            }
            //        }
            //    }
            //});
        }
        function fillED(msg) {
            //$('.edcls').each(function () {
            //    var ed = $(this);
            //    ed[0].options.length = null;
            //    for (var i = 0; i < msg.length; i++) {
            //        if (msg[i].type != null) {
            //            if (msg[i].taxtype == "ExchangeDuty") {
            //                var option = document.createElement('option');
            //                option.innerHTML = msg[i].type;
            //                option.value = msg[i].sno;
            //                ed[0].appendChild(option);
            //            }
            //        }
            //    }
            //});
        }
        var filldescrption = [];
        var filldescrption1 = [];
        function get_productcode() {
            var data = { 'op': 'get_product_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        filldata(msg);
                        filldata1(msg);
                        filldescrption = msg;
                        filldescrption1 = msg;
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
                var sku = msg[i].sku;
                compiledList.push(sku);
            }

            $('.codecls').autocomplete({
                source: compiledList,
                change: test1,
                autoFocus: true
            });
        }
        var emptytable = [];
        function test1() {
            var sku = $(this).val();
            var checkflag = true;
            if (emptytable.indexOf(sku) == -1) {
                for (var i = 0; i < filldescrption.length; i++) {
                    if (sku == filldescrption[i].sku) {
                        $(this).closest('tr').find('#txtDescription').val(filldescrption[i].productname);
                        $(this).closest('tr').find('#txtCost').val(filldescrption[i].price);
                        $(this).closest('tr').find('#txtUom').val(filldescrption[i].uim);
                        $(this).closest('tr').find('#hdnproductsno').val(filldescrption[i].productid);
                        emptytable.push(sku);
                    }
                }
            }
            else {
                alert("Product Code already added");
                var empt = "";
                $(this).val(empt);
                $(this).focus();
                return false;
            }
        }
        function filldata1(msg) {
            var compiledList = [];
            for (var i = 0; i < msg.length; i++) {
                var productname = msg[i].productname;
                compiledList.push(productname);
            }

            $('.clsdesc').autocomplete({
                source: compiledList,
                change: test2,
                autoFocus: true
            });
        }
        var emptytable1 = [];
        function test2() {
            var productname = $(this).val();
            var checkflag = true;
            if (emptytable1.indexOf(productname) == -1) {
                for (var i = 0; i < filldescrption1.length; i++) {
                    if (productname == filldescrption1[i].productname) {
                        $(this).closest('tr').find('#txtCode').val(filldescrption1[i].sku);
                        $(this).closest('tr').find('#hdnproductsno').val(filldescrption1[i].productid);
                        $(this).closest('tr').find('#txtUom').val(filldescrption[i].uim);
                        $(this).closest('tr').find('#txtCost').val(filldescrption[i].price);
                        emptytable1.push(productname);
                    }
                }
            }
            else {
                alert("Product Name already added");
                var empt1 = "";
                $(this).val(empt1);
                $(this).focus();
                return false;
            }
        }
        function forclearall() {
            scrollTo(0, 0);
            document.getElementById('txt_ven_quo_no').value = "";
            document.getElementById('txt_indent_no').value = "";
            document.getElementById('txtName').value = "";
            document.getElementById('txtshortName').value = "";
            document.getElementById('txtDelivaryDate').value = "";
            document.getElementById('txtPoamount').innerHTML = "";
            document.getElementById('txtFrAmt').value = "";
            document.getElementById('txt_transport').value = "";
            document.getElementById('txtQutn').value = "";
            document.getElementById('txtQtnDate').value = "";
            document.getElementById('txtRemarks').value = "";
            document.getElementById('txtsupid').value = "";
            document.getElementById('ddlpayment').selectedIndex = 0;
            document.getElementById('ddlprice').selectedIndex = 0;
            document.getElementById('ddlterms').selectedIndex = 0;
            document.getElementById('ddlAddress').selectedIndex = 0;
            document.getElementById('ddlAddress1').selectedIndex = 0;
            document.getElementById('ddlpf').selectedIndex = 0;
            document.getElementById('btn_RaisePO').value = "Raise";
            var empty = [];
            var results = '<div  style="overflow:auto;"><table id="tabledetails" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Per Unit Rs</th><th scope="col">Quantity</th><th scope="col">Total Cost</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < empty.length; i++) {
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
        }
        function myFunction() {
            if (event.keyCode == 46 || event.keyCode == 110 || event.keyCode == 8 || event.keyCode == 9 || event.keyCode == 27 || event.keyCode == 13 || event.keyCode == 190 ||
            (event.keyCode == 65 && event.ctrlKey === true) ||
            (event.keyCode >= 35 && event.keyCode <= 39)) {
                return;
            }
            else {
                if (event.shiftKey || (event.keyCode < 48 || event.keyCode > 57) && (event.keyCode < 96 || event.keyCode > 105)) {
                    event.preventDefault();
                }
            }
        }

        function get_indent_details() {
            indent_no = document.getElementById('txt_indent_no').value;
            var data = { 'op': 'get_Indent_Data_Details_PO', 'indent_no': indent_no };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        forclearall();
                        document.getElementById("txt_indent_no").value = indent_no;
                        fill_po_details_indent(msg);
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

        function fill_po_details_indent(msg) {
            get_TAX();
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Code</th><th scope="col">Description</th><th scope="col">UOM</th><th scope="col">Qty</th><th scope="col">Rate</th><th scope="col">Dis%</th><th scope="col">Dis Amt</th><th scope="col">Tax Type</th><th scope="col">Tax %</th><th scope="col">ED</th><th scope="col">ED Tax%</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + (i + 1) + '</td>';
                results += '<td ><span id="spn_code">' + msg[i].sku + '</span><input id="txtCode" type="text" class="codecls"  style="width:90px;display:none;" readonly onkeypress="return isFloat(event)"  value="' + msg[i].sku + '"/></td>';
                results += '<td ><span id="spn_description">' + msg[i].prod_name + '</span><input id="txtDescription" type="text" class="clsdesc" readonly style="width:90px;display:none;" value="' + msg[i].prod_name + '"/></td>';
                results += '<td ><span id="spn_uim">' + msg[i].uom + '</span><input id="txtUom" type="text" class="clsUom"  readonly onkeypress="return isFloat(event)" style="width:50px;display:none;" value="' + msg[i].uom + '"/></td>';
                results += '<td ><input id="txtQty" type="text" class="clsQty" onkeypress="return isFloat(event)" style="width:60px;" value="' + msg[i].qty + '"/></td>';
                results += '<td ><input id="txtCost" type="text" class="clscost" onkeypress="return isFloat(event)" style="width:50px;"/></td>';
                results += '<td ><input id="txtDis" type="text" class="clsdis" style="width:50px;" onkeypress="return isFloat(event)"/></td>';
                results += '<td ><input id="txtDisAmt" type="text" class="clsdisamt" readonly style="width:50px;" onkeypress="return isFloat(event)"/></td>';
                //results += '<td><input id="ddlTaxtype1" type="text" class="clsTaxtype" readonly style="width:90px;"/></td>';
                results += '<td ><select id="ddlTaxtype" class="Taxtypecls" style="width:90px;"></select></td>';
                results += '<td ><input id="txtTax" type="text" class="clstax" style="width:50px;" onkeypress="return isFloat(event)"/></td>';
                //results += '<td ><input id="ddlEd1" type="text" class="clsed" readonly style="width:90px;"/></td>';
                results += '<td ><select id="ddlEd" class="edcls" style="width:90px;"></select></td>';
                results += '<td ><input id="txtEdtax" type="text" class="clsed" style="width:50px;" onkeypress="return isFloat(event)"/></td>';
                results += '<td><span id="spn_total"  class="clstotal" onkeypress="return isFloat(event)"style="width:500px;"></span></td>';
                //results += '<td style="display:none"><input id="hdnproductsno" type="hidden" value="' + msg[i].hdnproductsno + '"/></td>';
                //results += '<td data-title="Minus"><span><img src="images/minus.png" onclick="removerow(this)" style="cursor:pointer"/></span></td>';
                results += '</tr>';
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
            //calTotal();
        }

        $(document).click(function () {
            $('#tabledetails').on('change', '.clsQty', calTotal1)
            $('#tabledetails').on('change', '.clscost', calTotal1)
            $('#tabledetails').on('change', '.clsfree', calTotal1)
            $('#tabledetails').on('change', '.clsdis', calTotal1)
            $('#tabledetails').on('change', '.clstax', calTotal1)
            $('#tabledetails').on('change', '.clsed', calTotal1)
            $('#tabledetails').on('change', '.clstotal', calTotal1)
        });

        function calTotal1() {
            var $row = $(this).closest('tr'),
           price = $row.find('.clscost').val(),
           quantity = $row.find('.clsQty').val(),
            //free = $row.find('.clsfree').val(),
            sum = quantity;
            discount1 = sum * price;
            disper = $row.find('.clsdis').val(),
            totalval = parseFloat(discount1) * (disper) / 100 || 0;;
            // Discount = document.getElementById('txtDiscount').value || 0;
            discount = discount1 - totalval;
            $row.find('.clsdisamt').val(totalval);
            pf = document.getElementById("ddlpf");
            pf1 = pf.options[pf.selectedIndex].text;
            pfamt = pf1;
            tpfamt = parseFloat(pfamt) / 100;
            tpfamt1 = parseFloat(discount) * (tpfamt) || 0;
            edval = $row.find('.clsed').val(),
            edper = parseFloat(edval) / 100;
            edtotalval = (discount * edper) || 0;
            Discountedpf = tpfamt1 + edtotalval + discount;
            //            disper = $row.find('.clsdis').val(),
            //            totalval = parseFloat(discount) * (disper) / 100;
            //            totaldisamount = parseFloat(discount) - parseFloat(totalval) || 0;
            //            $row.find('.clsdisamt').val(totalval);
            tax1 = $row.find('.clstax').val(),
            tax = parseFloat(tax1) / 100;
            totaltax = parseFloat(Discountedpf) * (tax) || 0;
            fright = document.getElementById('txtFrAmt').value || 0;
            transport_chrgs = document.getElementById('txt_transport').value || 0;

            if (edtotalval == 0 || totaltax == 0) {
                if (discount == 0) {
                    $row.find('.clstotal').html(parseFloat(Discountedpf).toFixed(2));
                }
                else {
                    if (totaltax == 0) {
                        $row.find('.clstotal').html(parseFloat(Discountedpf).toFixed(2));
                    }
                    else {
                        var withtaxval = parseFloat(totaltax) + parseFloat(Discountedpf);
                        $row.find('.clstotal').html(parseFloat(withtaxval).toFixed(2));
                    }
                }
            }
            else {
                totalpoval = parseFloat(edtotalval) + parseFloat(totaltax) + parseFloat(tpfamt1) + parseFloat(discount);
                $row.find('.clstotal').html(parseFloat(totalpoval).toFixed(2));
            }
            clstotalval();
        }

        function get_quotation_details()
        {
            ven_quo_no = document.getElementById('txt_ven_quo_no').value;
            var data = { 'op': 'get_Vendor_Quotation_Data_Details', 'ven_quo_no': ven_quo_no };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        forclearall();
                        document.getElementById("txt_ven_quo_no").value = ven_quo_no;
                        fill_po_details(msg);
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

        function fill_po_details(msg)
        {
            var po_details = msg[0].DataTable;
            var product_details = msg[0].DataTable1;
            var quotation_no = document.getElementById('txt_ven_quo_no').value;

            document.getElementById('txtName').value = po_details[0].sup_name;
            document.getElementById('txtshortName').value = po_details[0].sup_comp_name;
            document.getElementById('txtFrAmt').value = po_details[0].freight_amt;
            document.getElementById('txt_transport').value = po_details[0].transport_chrgs;
            document.getElementById('txtQtnDate').value = po_details[0].doe;
            document.getElementById('txtsupid').value = po_details[0].sup_id;
            document.getElementById('txtQutn').value = quotation_no;
            //document.getElementById('txt_others').value = po_details[0].other_chrgs;
            document.getElementById('ddlpayment').value = po_details[0].payment_type;
            document.getElementById('ddlprice').value = po_details[0].price_basis;
            document.getElementById('ddlterms').value = po_details[0].delivery_terms;
            document.getElementById('ddlpf').value = po_details[0].pandf;
            document.getElementById('ddlAddress').value = po_details[0].delivery_addr;
            document.getElementById('ddlAddress1').value = po_details[0].billing_addr;
            fill_product_details(product_details);
        }

        function fill_product_details(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Code</th><th scope="col">Description</th><th scope="col">UOM</th><th scope="col">Qty</th><th scope="col">Rate</th><th scope="col">Dis%</th><th scope="col">Dis Amt</th><th scope="col">Tax Type</th><th scope="col">Tax %</th><th scope="col">ED</th><th scope="col">ED Tax%</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + (i + 1) + '</td>';
                results += '<td ><span id="spn_code">' + msg[i].sku + '</span><input id="txtCode" type="text" class="codecls"  style="width:90px;display:none;" readonly onkeypress="return isFloat(event)"  value="' + msg[i].sku + '"/></td>';
                results += '<td ><span id="spn_desc">' + msg[i].prod_name + '</span><input id="txtDescription" type="text" class="clsdesc" readonly style="width:90px;display:none;" value="' + msg[i].prod_name + '"/></td>';
                results += '<td ><span id="spn_uim">' + msg[i].uim + '</span><input id="txtUom" type="text" class="clsUom"  readonly onkeypress="return isFloat(event)" style="width:50px;display:none;" value="' + msg[i].uim + '"/></td>';
                results += '<td ><span id="spn_qty">' + msg[i].qty + '</span><input id="txtQty" type="text" class="clsQty"  readonly onkeypress="return isFloat(event)" style="width:60px;display:none;" value="' + msg[i].qty + '"/></td>';
                results += '<td ><span id="spn_cost">' + msg[i].price + '</span><input id="txtCost" type="text" class="clscost"  readonly onkeypress="return isFloat(event)" style="width:50px;display:none;" value="' + msg[i].price + '"/></td>';
                results += '<td ><span id="spn_dis">' + msg[i].dis_per + '</span><input id="txtDis" type="text" class="clsdis" readonly style="width:50px;display:none;" onkeypress="return isFloat(event)" value="' + msg[i].dis_per + '"/></td>';
                results += '<td ><span id="spn_dis_amt">' + msg[i].dis_amt + '</span><input id="txtDisAmt" type="text" class="clsdisamt" readonly style="width:50px;display:none;" onkeypress="return isFloat(event)" value="' + msg[i].dis_amt + '"/></td>';
                results += '<td><span id="spn_taxtype1">' + msg[i].tax_type + '</span><input id="ddlTaxtype1" type="text" class="clsTaxtype" readonly style="width:90px;display:none;" value="' + msg[i].tax_type + '"/></td>';
                results += '<td style="display:none;"><input id="ddlTaxtype" type="text"  readonly class="Taxtypecls1" style="width:90px;" value="' + msg[i].tax_type_id + '"/></td>';
                results += '<td ><span id="spn_tax">' + msg[i].tax_per + '</span><input id="txtTax" type="text" class="clstax"  readonly style="width:50px;display:none;" onkeypress="return isFloat(event)" value="' + msg[i].tax_per + '"/></td>';
                results += '<td ><span id="spn_ed1">' + msg[i].ed + '</span><input id="ddlEd1" type="text" class="clsed" readonly style="width:90px;display:none;" value="' + msg[i].ed + '"/></td>';
                results += '<td style="display:none"><input id="ddlEd" readonly type="text" class="edcls1" style="width:90px;" value="' + msg[i].ed_id + '"/></td>';
                results += '<td ><span id="spn_edtax">' + msg[i].ed_tax_per + '</span><input id="txtEdtax" type="text" class="clsed"  readonly style="width:50px;display:none;" onkeypress="return isFloat(event)" value="' + msg[i].ed_tax_per + '"/></td>';
                results += '<td><span id="spn_total"  class="clstotal"  readonly onkeypress="return isFloat(event)"style="width:500px;"></span></td>';
                //results += '<td style="display:none"><input id="hdnproductsno" type="hidden" value="' + msg[i].hdnproductsno + '"/></td>';
                //results += '<td data-title="Minus"><span><img src="images/minus.png" onclick="removerow(this)" style="cursor:pointer"/></span></td>';
                results += '</tr>';
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
            calTotal();
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Purchase Order <small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operations</a></li>
            <li><a href="#">Purchase Order</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Purchase Order Details
                </h3>
            </div>
            <div class="box-body">
                <div id="showlogs" align="center">
                    <%--<input id="btn_addDept" type="button" name="submit" value='Add PO' class="btn btn-primary" />--%>
                    <div class="input-group" style="padding-left:90%">
                        <div class="input-group-addon">
                            <span class="glyphicon glyphicon-plus-sign"></span> <span id="btn_addDept">Add PO</span>
                        </div>
                    </div>
                </div>
                <div id="div_POData">
                </div>
                <div id='PurchaseOrder_FillForm' style="display: none;">
                    <table align="center">
                        <tr>
                            <td>
                                <label>Vendor Quotation No</label>
                            </td>
                            <td>
                                <input id="txt_ven_quo_no" type="text" class="form-control" name="ven_quote_no" placeholder="Enter Vendor Quotation No" onchange="get_quotation_details();" />
                            </td>
                            <td>
                                <label>Indent No</label>
                            </td>
                            <td>
                                <input id="txt_indent_no" type="text" class="form-control" name="indent_no" placeholder="Enter Indent No" onchange="get_indent_details();" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Company Name</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txtshortName" type="text" class="form-control" name="ShortName" placeholder="Enter CompanyName" />
                            </td>
                            <td>
                                <label>
                                    Name</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txtName" type="text" class="form-control" placeholder="Enter SupplierName"
                                    onkeypress="return ValidateAlpha(event);" />
                            </td>
                             <td>
                                <label>
                                    Delivery Date</label>
                            </td>
                            <td style="height: 40px;">
                                <input type="date" class="form-control" id="txtDelivaryDate" name="Date" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    P and F</label>
                            </td>
                            <td style="height: 40px;">
                                <select id="ddlpf" class="form-control" onchange="calTotal();">
                                    <option selected disabled value="select pf" >select pf</option>
                                </select>
                            </td>
                            <td>
                                <label>
                                    Freight Amount</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txtFrAmt" type="text" class="form-control" name="FreAmount" onkeypress="return isFloat(event)" placeholder="Enter  Freight Amount" onchange="calTotal();" />
                            </td>
                             <td>
                                <label>
                                    Quotation</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txtQutn" type="text" class="form-control" name="quotation" placeholder="Enter Quotation" />
                            </td>
                        </tr>
                        <tr>
                           
                            <td>
                                <label>
                                    Quotation Date</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txtQtnDate" type="date" class="form-control" name="QuotationDate" placeholder="Enter  QuotationDate" />
                            </td>
                           <td>
                                <label>
                                    Delivary Terms</label>
                            </td>
                            <td style="height: 40px;">
                                <select id="ddlterms" class="form-control">
                                    <option selected disabled value="select terms">select terms</option>
                                </select>
                            </td>
                            <td>
                                <label>
                                    Payment Type</label>
                            </td>
                            <td style="height: 40px;">
                                <select id="ddlpayment" class="form-control">
                                    <option selected disabled value="select payment">select payment</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                         <td>
                                <label>
                                    Price Basis</label>
                            </td>
                            <td style="height: 40px;">
                                <select id="ddlprice" class="form-control">
                                    <option value="Ex-factary">Ex-factary</option>
                                    <option value="Ex-OurLocation">Ex-OurLocation</option>
                                </select>
                            </td>
                            <td>
                                <label>
                                   Delivary Address</label>
                            </td>
                            <td style="height: 40px;">
                                <select id="ddlAddress" class="form-control">
                                    <option selected disabled value="select DelivaryAddress" >select DelivaryAddress</option>
                                </select>
                            </td>
                            <td>
                                <label>
                                   Billing Address</label>
                            </td>
                            <td style="height: 40px;">
                                <select id="ddlAddress1" class="form-control">
                                    <option selected disabled value="select BillingAddress" >select BillingAddress</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                   Transport Charges</label>
                            </td>
                            <td>
                                <input id="txt_transport" type="text" class="form-control" name="transport_charges" onkeypress="return isFloat(event)" placeholder="Enter Transport Charges" onchange="calTotal();" />
                            </td>
                            <td>
                                <label style="display:none">
                                   Insurance Charges</label>
                            </td>
                            <td>
                                <input id="txt_insurance" type="text" style="display:none" class="form-control" name="insurance_charges" onkeypress="return isFloat(event)" placeholder="Enter Transport Charges" onchange="calTotal();" />
                            </td>
                            <td>
                                <label style="display:none">
                                   Other Charges</label>
                            </td>
                            <td>
                                <input id="txt_others" type="text" style="display:none" class="form-control" name="other_charges" onkeypress="return isFloat(event)" placeholder="Enter Transport Charges" onchange="calTotal();" />
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <input id="txtsupid" type="hidden" class="form-control" name="hiddensupplyid" hidden />
                            </td>
                        </tr>
                         <tr>
                            <td style="height: 40px;">
                                <input id="lblsno" type="hidden" class="form-control" hidden />
                            </td>
                        </tr>
                    </table>
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
                    </div>
                    <table align="center" id="po">
                             <tr>
                            <td>
                                <label>
                                    PO Amount</label>
                            </td>
                            <td>
                                <span id="txtPoamount" type="text" style="width: 500px; color: Red; font-weight: bold;
                                    font-size: 25px;" class="clspomount" name="PoAmount" onkeypress="return isFloat(event)"
                                    placeholder="Enter PO Amount"></span>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Remarks</label>
                            </td>
                            <td style="width: 420px;">
                                <textarea id="txtRemarks" rows="4" cols="10" name="Remarks" class="form-control"
                                    placeholder="Enter Remarks">
                              </textarea>
                            </td>
                        </tr>
                    </table>
                    <%--<p id="newrow">
                        <input type="button" onclick="insertrow();" class="btn btn-default" value="Insert row" /></p>--%>
                    <div id="">
                    </div>
                    <table align="center">
                        <tr>
                            <td>
                                <%--<input type="button" class="btn btn-primary" id="btn_RaisePO" value="Raise" onclick="save_edit_podetails_click();" />
                                <input type="button" class="btn btn-danger" id="close_vehmaster" value="Close" />--%>
                                <table>
                                   <tr>
                                    <td>
                                    <div class="input-group">
                                        <div class="input-group-addon">
                                        <span class="glyphicon glyphicon-ok" id="btn_RaisePO1" onclick="save_edit_podetails_click()"></span> <span id="btn_RaisePO" onclick="save_edit_podetails_click()">Raise</span>
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
         <div id="divMainAddNewRow" class="pickupclass" style="text-align: center; height: 100%;
             width: 100%; position: absolute; display: none; left: 0%; top: 0%; z-index: 99999;
             background: rgba(192, 192, 192, 0.7);">
             <div id="divAddNewRow" style="border: 5px solid #A0A0A0; position: absolute; top: 8%;
                 background-color: White; left: 10%; right: 10%; width: 80%; height: 100%; -webkit-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                 -moz-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65); box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                 border-radius: 10px 10px 10px 10px;">
                 <table align="left" cellpadding="0" cellspacing="0" style="float: left; width: 100%;"
                     id="tableCollectionDetails" class="mainText2" border="1">
                     <%--<tr>
                            <td>
                                Name
                            </td>
                            <td style="height: 40px;">
                                <span id="spnName" class="form-control"></span>
                            </td>
                        </tr>--%>
                     <tr>
                         <td colspan="2">
                             <div id="ShowCategoryData">
                             </div>
                         </td>
                     </tr>
                     <tr>
                         <td>
                             <%--<input type="button" class="btn btn-danger" id="Button1" value="Close" onclick="CloseClick();" />--%>
                             <table align="center">
                                   <tr>
                                    <td>
                                     <div class="input-group">
                                        <div class="input-group-close">
                                        <span class="glyphicon glyphicon-remove" onclick="CloseClick();" id='Span3'></span> <span id='Span4' onclick="CloseClick();">Close</span>
                                  </div>
                                  </div>
                                    </td>
                                    </tr>
                               </table>
                         </td>
                     </tr>
                 </table>
             </div>
             <div id="divclose" style="width: 35px; top: 7.5%; right: 8%; position: absolute;
                 z-index: 99999; cursor: pointer;">
                 <img src="Images/Close.png" alt="close" style="width: 33px;height: 33px;" onclick="CloseClick();" />
             </div>
         </div>
        </div>
    </section>
</asp:Content>
