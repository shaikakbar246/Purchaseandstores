<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true" CodeFile="WorkOrder.aspx.cs" Inherits="WorkOrder" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <%--<script src="js/jquery-1.4.4.js" type="text/javascript"></script>--%>
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            $('#btn_addDept').click(function () {
                $('#vehmaster_fillform').css('display', 'block');
                $('#showlogs').css('display', 'none');
                $('#div_Grid').hide();
                $('#newrow').css('display', 'block');
                get_TAX();
                get_DelivaryTerms();
                get_PaymentDetails();
                get_PandF();
                get_productcode();
                get_supplier();
                GetFixedrows();
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
                scrollTo(0, 0);
            });
            $('#close_vehmaster').click(function () {
                $('#vehmaster_fillform').css('display', 'none');
                $('#showlogs').css('display', 'block');
                $('#div_Grid').show();
                forclearall();
                emptytable1 = [];
                emptytable = [];
            });
            get_WorkOrder_details();
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
            today_date = yyyy + '-' + mm + '-' + dd;
            emptytable1 = [];
            emptytable = [];
            scrollTo(0, 0);
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
            var name = document.getElementById('txtshortName').value;
            for (var i = 0; i < supperdetails.length; i++) {
                if (name == supperdetails[i].companyname) {
                    document.getElementById('txtName').value = supperdetails[i].name;
                    document.getElementById('txtsupid').value = supperdetails[i].supplierid;
                }
            }
            var name = document.getElementById('txtshortName').value;
            for (var i = 0; i < supperdetails.length; i++) {
                if (name == supperdetails[i].companyname) {
                    var sup_stateid = supperdetails[i].stateid;
                    if (sup_stateid == "") {
                        alert("Supplier without State cannot be accepted or please update the Supplier with State");
                        document.getElementById('txtshortName').value = "";
                        document.getElementById('txtName').value = "";
                        document.getElementById('txt_sup_state').value = "";
                        document.getElementById('txtsupid').value = "";
                        return false;
                    }
                    else {
                        document.getElementById('txtName').value = supperdetails[i].name;
                        document.getElementById('txt_sup_state').value = supperdetails[i].stateid;
                        document.getElementById('txtsupid').value = supperdetails[i].supplierid;
                        if (supperdetails[i].gstin != "") {
                            document.getElementById('txt_sup_gstin').value = supperdetails[i].gstin;
                            //document.getElementById('txt_rev_chrg').value = "N";
                        }
                        else {
                            document.getElementById('txt_sup_gstin').value = "";
                            //document.getElementById('txt_rev_chrg').value = "Y";
                            //alert('Supplier without GSTIN cannot be accepted for raising PO');
                            //document.getElementById('txtName').value = "";
                            //document.getElementById('txt_sup_state').value = "";
                            //document.getElementById('txt_sup_gstin').value = "";
                            //document.getElementById('txtsupid').value = "";
                            //document.getElementById('txtshortName').value = "";
                            //document.getElementById('txtshortName').focus();
                            //return false;
                        }
                    }
                }
            }
        }
        function GetFixedrows() {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Code</th><th scope="col">Description</th><th scope="col">Services</th><th scope="col">UOM</th><th scope="col">Qty</th><th scope="col">Rate</th><th scope="col">Dis %</th><th scope="col">Dis Amt</th><th scope="col">Taxable Value</th><th scope="col">SGST %</th><th scope="col">CGST %</th><th scope="col">IGST %</th><th scope="col"></th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 1; i < 11; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;width:40px;" id="txtsno" >' + i + '</td>';
                results += '<td ><input id="txtCode" type="text" class="codecls"   placeholder= "Enter Product Code" style="width:90px;" /></td>';
                results += '<td ><input id="txtDescription" type="text" class="clsdesc"  placeholder= "Enter Product Name"  style="width:90px;"/></td>';
                results += '<td ><input id="txtServices" type="text" class="clsservices"  placeholder= "Enter Services"  style="width:90px;"/></td>';
                results += '<td ><span id="spn_uom"></span><input id="txtUom" type="text"  class="clsUom"  placeholder= "UOM" onkeypress="return isFloat(event)" class="form-control"  style="width:50px;display:none;"/></td>'

                results += '<td ><input id="txtQty" type="text"  class="clsQty"  placeholder= "Enter Qty" onkeypress="return isFloat(event)"   style="width:60px;"/></td>';
                results += '<td ><input id="txtCost" type="text"  class="clscost"  placeholder= "Cost" onkeypress="return isFloat(event)"   style="width:50px;"/></td>'
                results += '<td ><input id="txtDis" type="text" class="clsdis"  placeholder= "Dis" onkeypress="return isFloat(event)" style="width:50px;"/></td>';
                results += '<td ><span id="spn_dis_amt"></span><input id="txtDisAmt" type="text" class="clsdisamt" placeholder= "Dis Amt" onkeypress="return isFloat(event)" style="width:60px;display:none"/></td>';

                results += '<td ><span id="spn_taxable"></span><input id="txt_taxable" type="text"  placeholder="Taxable Value" class="clstaxable" onkeypress="return isFloat(event)" style="width:50px;display:none;"/></td>';
                results += '<td ><span id="spn_sgst"></span><input id="txtsgst" type="text"  placeholder="SGST %" class="clssgst" readonly onkeypress="return isFloat(event)" style="width:50px;display:none;"/></td>';
                results += '<td ><span id="spn_cgst"></span><input id="txtcgst" type="text"  placeholder="CGST %" class="clscgst" readonly onkeypress="return isFloat(event)" style="width:50px;display:none;"/></td>';
                results += '<td ><span id="spn_igst"></span><input id="txtigst" type="text" class="clsigst" placeholder="IGST %" readonly onkeypress="return isFloat(event)"  style="width:50px;display:none;"/></td>';
                results += '<td ><span id="txttotal"  class="clstotal"  onkeypress="return isFloat(event)"  style="width:500px;"></td>';
                results += '<td style="display:none"><input id="hdnproductsno" type="hidden" /></td>';
                results += '<td data-title="Minus"><span><img src="images/minus.png" onclick="removerow(this)" style="cursor:pointer"/></span></td>';
                results += '<td style="display:none" class="4">' + i + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
        }
        var DataTable;
        var sub_sno = "";
        function insertrow() {
            get_productcode();
            get_supplier();
            DataTable = [];
            var txtsno = 0;
            var code = 0;
            var description = 0;
            var qty = 0;
            var cost = 0;
            var free = 0;
            var uim = 0;
            var services = 0;
            var taxable = 0;
            var sgst = 0;
            var cgst = 0;
            var igst = 0;
            var productamount = 0;
            var hdnproductsno = 0;
            var rows = $("#tabledetails tr:gt(0)");
            var rowsno = 1;
            $(rows).each(function (i, obj) {
                if ($(this).find('#txtCode').val() != "") {
                    txtsno = rowsno;
                    code = $(this).find('#txtCode').val();
                    description = $(this).find('#txtDescription').val();
                    services = $(this).find('#txtServices').val();
                    qty = $(this).find('#txtQty').val();
                    cost = $(this).find('#txtCost').val();
                    uim = $(this).find('#txtUom').val();
                    dis = $(this).find('#txtDis').val();
                    disamt = $(this).find('#spn_dis_amt').text();
                    taxable = $(this).find('#spn_taxable').text();
                    sgst = $(this).find('#spn_sgst').text();
                    cgst = $(this).find('#spn_cgst').text();
                    igst = $(this).find('#spn_igst').text();
                    productamount = $(this).find('#txttotal').text();
                    hdnproductsno = $(this).find('#hdnproductsno').val();
                    DataTable.push({ Sno: txtsno, services: services, code: code, description: description, uim: uim, qty: qty, cost: cost, dis: dis, sgst: sgst, cgst: cgst, igst: igst, taxable: taxable, disamt: disamt, hdnproductsno: hdnproductsno, productamount: productamount });//, taxtype: taxtype, ed: ed, tax: tax, edtax: edtax
                    rowsno++;
                }
            });
            code = 0;
            description = 0;
            qty = 0;
            cost = 0;
            free = 0;
            taxtype = 0;
            ed = 0;
            services = 0;
            uim = 0;
            disamt = 0;
            dis = 0;
            tax = 0;
            edtax = 0;
            taxable = 0;
            sgst = 0;
            cgst = 0;
            igst = 0;
            productamount = 0;
            hdnproductsno = 0;
            var Sno = parseInt(txtsno) + 1;
            DataTable.push({ Sno: Sno, services: services, code: code, description: description, uim: uim, qty: qty, cost: cost, sgst: sgst, cgst: cgst, igst: igst, taxable: taxable, dis: dis, disamt: disamt, hdnproductsno: hdnproductsno, productamount: productamount });//, taxtype: taxtype, ed: ed, tax: tax, edtax: edtax
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            //results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Code</th><th scope="col">Product Name</th><th scope="col">Services</th><th scope="col">UOM</th><th scope="col">Qty</th><th scope="col">Rate</th><th scope="col">Dis%</th><th scope="col">Dis Amt</th><th scope="col">Tax Type</th><th scope="col">Tax %</th><th scope="col">ED</th><th scope="col">ED Tax %</th><th scope="col"></th><th scope="col"></th></tr></thead></tbody>';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Code</th><th scope="col">Description</th><th scope="col">Services</th><th scope="col">UOM</th><th scope="col">Qty</th><th scope="col">Rate</th><th scope="col">Dis %</th><th scope="col">Dis Amt</th><th scope="col">Taxable Value</th><th scope="col">SGST %</th><th scope="col">CGST %</th><th scope="col">IGST %</th><th scope="col"></th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < DataTable.length; i++) {
                sub_sno = DataTable[i].sno;
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + DataTable[i].Sno + '</td>';
                results += '<td ><input id="txtCode" placeholder="Enter Product Code" type="text" class="codecls"  style="width:90px;" onkeypress="return isFloat(event)"  value="' + DataTable[i].code + '"/></td>';
                results += '<td ><input id="txtDescription" placeholder="Enter Product Description" type="text" class="clsdesc" style="width:90px;" value="' + DataTable[i].description + '"/></td>';
                results += '<td ><input id="txtServices" type="text" placeholder="Enter Services needed" class="clsservices" style="width:90px;" value="' + DataTable[i].services + '"/></td>';
                results += '<td ><span id="spn_uom">' + DataTable[i].uim + '</span><input  class="clsUom" id="txtUom" name="uom"  onkeypress="return isFloat(event)" style="width:50px;display:none;" value="' + DataTable[i].uim + '"/></td>';
                results += '<td ><input id="txtQty" type="text" class="clsQty" placeholder="Enter Quantity" onkeypress="return isFloat(event)" style="width:60px;" value="' + DataTable[i].qty + '"/></td>';
                results += '<td ><input id="txtCost" type="text" class="clscost" placeholder="Enter Cost" onkeypress="return isFloat(event)" style="width:50px;" value="' + DataTable[i].cost + '"/></td>';
                results += '<td ><input id="txtDis" type="text" class="clsdis" style="width:50px;" onkeypress="return isFloat(event)" value="' + DataTable[i].dis + '"/></td>';
                results += '<td ><span id="spn_dis_amt">' + DataTable[i].disamt + '</span><input id="txtDisAmt" type="text" class="clsdisamt" style="width:50px;display:none;" onkeypress="return isFloat(event)" value="' + DataTable[i].disamt + '"/></td>';
                results += '<td ><span id="spn_taxable">' + DataTable[i].taxable + '</span><input id="txt_taxable"  value="' + DataTable[i].taxable + '" type="text"  placeholder="Taxable Value" class="clstaxable" onkeypress="return isFloat(event)" style="width:50px;display:none;"/></td>';
                results += '<td ><span id="spn_sgst">' + DataTable[i].sgst + '</span><input id="txtsgst" value="' + DataTable[i].sgst + '" type="text"  placeholder="SGST %" class="clssgst" readonly onkeypress="return isFloat(event)" style="width:50px;display:none;"/></td>';
                results += '<td ><span id="spn_cgst">' + DataTable[i].cgst + '</span><input id="txtcgst" value="' + DataTable[i].cgst + '" type="text"  placeholder="CGST %" class="clscgst" readonly onkeypress="return isFloat(event)" style="width:50px;display:none;"/></td>';
                results += '<td ><span id="spn_igst">' + DataTable[i].igst + '</span><input id="txtigst" value="' + DataTable[i].igst + '" type="text" class="clsigst" placeholder="IGST %" readonly onkeypress="return isFloat(event)"  style="width:50px;display:none;"/></td>';
                results += '<td ><span id="txttotal"  class="clstotal"   onkeypress="return isFloat(event)"  style="width:500px;" value="' + DataTable[i].productamount + '"/></td>';
                results += '<td style="display:none"><input id="hdnproductsno" type="hidden" value="' + DataTable[i].hdnproductsno + '"/></td>';
                results += '<td data-title="Minus"><span><img src="images/minus.png" onclick="removerow(this)" style="cursor:pointer"/></span></td>';
                results += '<td style="display:none;" class="4">' + i + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
        }

        

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
        function save_edit_WorkOrder_click() {

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
            var pricebasis = document.getElementById('ddlprice').value;
            var remarks = document.getElementById('txtRemarks').value;
            var payment = document.getElementById('ddlpayment').value;
            var quotationno = document.getElementById('txtQutn').value;
            var quotationdate = document.getElementById('txtQtnDate').value;
            var hiddensupplyid = document.getElementById('txtsupid').value;
            var btnval = document.getElementById('btn_RaisePO').innerHTML;
            var status = "P";
            if (name == "") {
                alert("Enter  Supplier Name");
                return false;
            }
            if (shortname == "") {
                alert("Enter  Company Name");
                return false;
            }
            if (delivarydate == "") {
                alert("Select  Delivary Date");
                return false;
            }
            var WorkOrder_array = [];
            $('#tabledetails> tbody > tr').each(function () {
                var txtsno = $(this).find('#txtSno').text();
                var code = $(this).find('#txtCode').val();
                var description = $(this).find('#txtDescription').val();
                var qty = $(this).find('#txtQty').val();
                var cost = $(this).find('#txtCost').val();
                var services = $(this).find('#txtServices').val();
                var dis = $(this).find('#txtDis').val();
                var disamt = $(this).find('#spn_dis_amt').text();
                var sgst = $(this).find('#spn_sgst').text();
                var cgst = $(this).find('#spn_cgst').text();
                var igst = $(this).find('#spn_igst').text();
                var productamount = $(this).find('#txttotal').text();
                var sno = $(this).find('#txt_sub_sno').val();
                var hdnproductsno = $(this).find('#hdnproductsno').val();
                if (hdnproductsno == "" || hdnproductsno == "0") {
                }
                else {
                    WorkOrder_array.push({
                        'txtsno': txtsno, 'code': code, 'description': description, 'services': services, 'qty': qty, 'cost': cost, 'dis': dis, 'disamt': disamt, 'taxtype': "", 'ed': "", 'tax': "0", 'edtax': "0", 'sgst': sgst, 'cgst': cgst, 'igst': igst, 'sno': sno, 'hdnproductsno': hdnproductsno, 'productamount': productamount
                    });
                }
            });
            var Data = { 'op': 'save_edit_WorkOrder_click', 'remarks': remarks, 'pono': PONo, 'shortname': shortname, 'poamount': poamount, 'name': name, 'delivarydate': delivarydate, 'terms': terms, 'pf': pf, 'freigntamt': freigtamt, 'quotationno': quotationno, 'quotationdate': quotationdate, 'payment': payment, 'hiddensupplyid': hiddensupplyid, 'btnval': btnval, 'status': status, 'pricebasis': pricebasis, 'address': address, 'billingaddress': billingaddress, 'WorkOrder_array': WorkOrder_array };
            var s = function (msg) {
                if (msg) {
                    alert(msg);
                    get_WorkOrder_details();
                    $('#vehmaster_fillform').css('display', 'none');
                    $('#showlogs').css('display', 'block');
                    $('#div_Grid').show();
                    forclearall();
                }
            }
            var e = function (x, h, e) {
            };
            CallHandlerUsingJson(Data, s, e);
        }
        function get_WorkOrder_details() {
            var data = { 'op': 'get_WorkOrder_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillWorkOrder_details(msg);
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
        var WorkOrder_sub_list = [];
        function fillWorkOrder_details(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr class="trbgclrcls"><th scope="col">Ref NO</th><th scope="col">Wo No</th><th scope="col">Supplier Name</th><th scope="col">WO Date</th><th scope="col"></th></tr></thead></tbody>';
            var WorkOrder = msg[0].workorderdetails;
            WorkOrder_sub_list = msg[0].subworkorderdetails;
            var k = 1;
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            for (var i = 0; i < WorkOrder.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">';
                results += '<td class="12">' + WorkOrder[i].pono + '</td>';
                results += '<td data-title="podate" class="5">' + WorkOrder[i].ponumber + '</td>';
                results += '<td data-title="name" class="1">' + WorkOrder[i].name + '</td>';
                results += '<td data-title="delivarydate" style="display:none;" class="3">' + WorkOrder[i].delivarydate + '</td>';
                results += '<td data-title="expiredate" class="4">' + WorkOrder[i].podate + '</td>';
                results += '<td data-title="poamount" style="display:none;" class="6">' + parseFloat(WorkOrder[i].poamount).toFixed(2) + '</td>';
                results += '<td data-title="shortname" class="7" style="display:none;">' + WorkOrder[i].shortname + '</td>';
                results += '<td data-title="freigntamt" class="8" style="display:none;">' + parseFloat(WorkOrder[i].freigntamt).toFixed(2) + '</td>';
                results += '<td data-title="email" class="14" style="display:none;">' + WorkOrder[i].billingaddress + '</td>';
                results += '<td data-title="address" class="15" style="display:none;">' + WorkOrder[i].addressid + '</td>';
                results += '<td data-title="quotationno" class="16" style="display:none;">' + WorkOrder[i].quotationno + '</td>';
                results += '<td data-title="quotationdate" class="17" style="display:none;">' + WorkOrder[i].quotationdate + '</td>';
                results += '<td data-title="quotationdate" class="22" style="display:none;">' + WorkOrder[i].payment + '</td>';
                results += '<td data-title="quotationdate" class="20" style="display:none;">' + WorkOrder[i].terms + '</td>';
                results += '<td data-title="quotationdate" class="21" style="display:none;">' + WorkOrder[i].pf + '</td>';
                results += '<td data-title="quotationdate" class="26" style="display:none;">' + WorkOrder[i].remarks + '</td>';
                results += '<td data-title="quotationdate" class="27" style="display:none;">' + WorkOrder[i].pricebasis + '</td>';
                results += '<td data-title="brandstatus"><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"  onclick="getpurchasevalues(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td>';
                results += '<td data-title="hiddensupplyid" class="18" style="display:none;">' + WorkOrder[i].hiddensupplyid + '</td>';
                results += '<td data-title="sno" class="13" style="display:none;">' + WorkOrder[i].sno + '</td></tr>';

                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }

            results += '</table></div>';
            $("#div_Grid").html(results);
        }
        var sno = 0;
        function getpurchasevalues(thisid) {
            scrollTo(0, 0);
            get_supplier();
            get_productcode();
            clstotalval();
            calTotal();
            $('#vehmaster_fillform').css('display', 'block');
            $('#showlogs').css('display', 'none');
            $('#div_Grid').hide();
            $('#newrow').css('display', 'none');
            var name = $(thisid).parent().parent().children('.1').html();
            var delivarydate2 = $(thisid).parent().parent().children('.3').html();
            var poamount = $(thisid).parent().parent().children('.6').html();
            var shortname = $(thisid).parent().parent().children('.7').html();
            var freigntamt = $(thisid).parent().parent().children('.8').html();
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
            document.getElementById('txtQutn').value = quotationno;
            document.getElementById('ddlterms').value = terms;
            document.getElementById('ddlpf').value = pf;
            document.getElementById('ddlprice').value = pricebasis;
            document.getElementById('txtRemarks').value = remarks;
            document.getElementById('txtQtnDate').value = quotationdate;
            document.getElementById('ddlpayment').value = payment;
            document.getElementById('txtsupid').value = hiddensupplyid;
            document.getElementById('btn_RaisePO').innerHTML = "Modify";
            var table = document.getElementById("tabledetails");
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            //results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Code</th><th scope="col">Product Name</th><th scope="col">Services</th><th scope="col">UOM</th><th scope="col">Qty</th><th scope="col">Rate</th><th scope="col">Dis%</th><th scope="col">Dis Amt</th><th scope="col">Tax Type</th><th scope="col">Tax%</th><th scope="col">ED</th><th scope="col">ED Tax %</th><th scope="col"></th><th scope="col"></th></tr></thead></tbody>';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Code</th><th scope="col">Description</th><th scope="col">Services</th><th scope="col">UOM</th><th scope="col">Qty</th><th scope="col">Rate</th><th scope="col">Dis %</th><th scope="col">Dis Amt</th><th scope="col">Taxable Value</th><th scope="col">SGST %</th><th scope="col">CGST %</th><th scope="col">IGST %</th><th scope="col"></th><th scope="col"></th></tr></thead></tbody>';
            var k = 1;
            var pf = document.getElementById("ddlpf");
            var pf1 = pf.options[pf.selectedIndex].text;
            for (var i = 0; i < WorkOrder_sub_list.length; i++) {
                if (PONo == WorkOrder_sub_list[i].pono) {
                    results += '<tr><td data-title="Sno" class="1">' + k + '</td>';
                    results += '<td data-title="From"><input id="txtCode" class="codecls" name="code" readonly value="' + WorkOrder_sub_list[i].code + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<td data-title="From"><input class="3" id="txtDescription" readonly name="description" class="clsdesc" value="' + WorkOrder_sub_list[i].description + '" style="width:90px; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<td data-title="From"><input  id="txtServices"  name="description" class="clsservices" value="' + WorkOrder_sub_list[i].services + '" style="width:90px; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<td data-title="From"><span id="spn_uim">' + WorkOrder_sub_list[i].uim + '</span><input  class="clsUom" id="txtUom" name="uom"  value="' + WorkOrder_sub_list[i].uim + '" onkeypress="return isFloat(event)" style="width:60px; font-size:12px;padding: 0px 5px;height:30px;display:none;"></td>';
                    results += '<td data-title="From"><input class="clsQty" id="txtQty"  name="qty"  value="' + WorkOrder_sub_list[i].qty + '" onkeypress="return isFloat(event)" style="width:60px; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                    results += '<td data-title="From"><input  class="clscost" id="txtCost" name="cost"  value="' + parseFloat(WorkOrder_sub_list[i].cost).toFixed(2) + '" onkeypress="return isFloat(event)" style="width:60px; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                    results += '<td data-title="From"><input  id="txtDis" name="dis" class="clsdis" value="' + WorkOrder_sub_list[i].dis + '" onkeypress="return isFloat(event)"  style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                    var qty = parseFloat(WorkOrder_sub_list[i].qty);
                    var price = parseFloat(WorkOrder_sub_list[i].cost);
                    var dis_per = parseFloat(WorkOrder_sub_list[i].dis);
                    var dis_amt = parseFloat(WorkOrder_sub_list[i].disamt);
                    var cost = (qty * price) - dis_amt;
                    var pfamt = (cost * parseFloat(pf1)) / 100;
                    var taxable = cost + pfamt;
                    results += '<td data-title="From"><span id="spn_dis_amt">' + parseFloat(WorkOrder_sub_list[i].disamt).toFixed(2) + '</span><input  id="txtDisAmt" class="clsdisamt" name="disamt" value="' + parseFloat(WorkOrder_sub_list[i].disamt).toFixed(2) + '" onkeypress="return isFloat(event)" style="width:60px; font-size:12px;padding: 0px 5px;height:30px;display:none;"></td>';
                    results += '<td ><span id="spn_taxable">' + taxable + '</span><input id="txt_taxable"  value="' + taxable + '" type="text"  placeholder="Taxable Value" class="clstaxable" onkeypress="return isFloat(event)" style="width:50px;display:none;"/></td>';
                    results += '<td ><span id="spn_sgst">' + WorkOrder_sub_list[i].sgst + '</span><input id="txtsgst" value="' + WorkOrder_sub_list[i].sgst + '" type="text"  placeholder="SGST %" class="clssgst" readonly onkeypress="return isFloat(event)" style="width:50px;display:none;"/></td>';
                    results += '<td ><span id="spn_cgst">' + WorkOrder_sub_list[i].cgst + '</span><input id="txtcgst" value="' + WorkOrder_sub_list[i].cgst + '" type="text"  placeholder="CGST %" class="clscgst" readonly onkeypress="return isFloat(event)" style="width:50px;display:none;"/></td>';
                    results += '<td ><span id="spn_igst">' + WorkOrder_sub_list[i].igst + '</span><input id="txtigst" value="' + WorkOrder_sub_list[i].igst + '" type="text" class="clsigst" placeholder="IGST %" readonly onkeypress="return isFloat(event)"  style="width:50px;display:none;"/></td>';
                    results += '<td><span id="txttotal"  class="clstotal"  onkeypress="return isFloat(event)"style="width:500px;">' + parseFloat(WorkOrder_sub_list[i].productamount).toFixed(2) + '</span></td>';
                    results += '<td style="display:none" data-title="From"><input class="13" id="hdnproductsno" type="hidden" name="hdnproductsno" value="' + WorkOrder_sub_list[i].hdnproductsno + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<td data-title="Minus"><span><img src="images/minus.png" onclick="removerow(this)" style="cursor:pointer"/></span></td>';
                    results += '<td data-title="From" style="display:none"><input class="14" id="txt_sub_sno" name="txt_sub_sno" value="' + WorkOrder_sub_list[i].sno + '"style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td></tr>';
                    k++;
                }
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
        }

        function gettaxtypevalues(PONo, WorkOrder_sub_list) {
            $('.Taxtypecls').each(function () {
                var taxtype = $(this);
                taxtype[0].options.length = null;
                for (var i = 0; i < TAX_Types.length; i++) {
                    if (TAX_Types[i].type != null) {
                        if (TAX_Types[i].taxtype == "Tax") {
                            var option = document.createElement('option');
                            option.innerHTML = TAX_Types[i].type;
                            option.value = TAX_Types[i].sno;
                            taxtype[0].appendChild(option);
                        }
                    }
                }
            });

            $('.Taxtypecls').each(function () {
                for (var i = 0; i < WorkOrder_sub_list.length; i++) {
                    if (PONo == WorkOrder_sub_list[i].pono) {
                        $(this).val(WorkOrder_sub_list[i].taxtype);
                    }
                }
            });
        }

        function getedtypevalues(PONo, WorkOrder_sub_list) {
            $('.edcls').each(function () {
                var taxtype = $(this);
                taxtype[0].options.length = null;
                for (var i = 0; i < TAX_Types.length; i++) {
                    if (TAX_Types[i].type != null) {
                        if (TAX_Types[i].taxtype == "ExchangeDuty") {
                            var option = document.createElement('option');
                            option.innerHTML = TAX_Types[i].type;
                            option.value = TAX_Types[i].sno;
                            taxtype[0].appendChild(option);
                        }
                    }
                }
            });

            $('.edcls').each(function () {
                for (var i = 0; i < WorkOrder_sub_list.length; i++) {
                    if (PONo == WorkOrder_sub_list[i].pono) {
                        $('.edcls').val(WorkOrder_sub_list[i].ed);
                    }
                }
            });
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
            var freightamount = parseFloat(document.getElementById('txtFrAmt').value) || 0;
            var totalamount1 = parseFloat(totaamount) + freightamount;
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
        function calTotal() {
            var $row = $(this).closest('tr'),
            price = $row.find('.clscost').val(),
            quantity = $row.find('.clsQty').val(),
            sum = quantity;
            discount1 = sum * price;
            disper = $row.find('.clsdis').val(),
            totalval = parseFloat(discount1) * (disper) / 100 || 0;
            discount = discount1 - totalval;
            $row.find('.clsdisamt').val(totalval.toFixed(2));
            $row.find('#spn_dis_amt').text(totalval.toFixed(2));
            pf = document.getElementById("ddlpf");
            pf1 = pf.options[pf.selectedIndex].text;
            tpfamt = parseFloat(pf1) / 100;
            tpfamt1 = parseFloat(discount) * (tpfamt) || 0;
            var taxable = tpfamt1 + discount;
            $row.find('.clstaxable').val(taxable.toFixed(2));
            $row.find('#spn_taxable').text(taxable.toFixed(2));
            var sgst = parseFloat($row.find('#spn_sgst').text()) || 0;
            var sgstamt = (taxable * sgst) / 100;
            var cgst = parseFloat($row.find('#spn_cgst').text()) || 0;
            var cgstamt = (taxable * cgst) / 100;
            var igst = parseFloat($row.find('#spn_igst').text()) || 0;
            var igstamt = (taxable * igst) / 100;

            
            totalpoval = sgstamt + cgstamt + igstamt + taxable;
            $row.find('.clstotal').html(parseFloat(totalpoval).toFixed(2));
            clstotalval();
        }
        $(document).click(function () {
            $('#tabledetails').on('change', '.clsQty', calTotal)
            $('#tabledetails').on('change', '.clscost', calTotal)
            $('#tabledetails').on('change', '.clsfree', calTotal)
            $('#tabledetails').on('change', '.clsdis', calTotal)
            $('#tabledetails').on('change', '.clstax', calTotal)
            $('#tabledetails').on('change', '.clsed', calTotal)
            $('#tabledetails').on('change', '.clstotal', calTotal)
        });
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
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
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
        var filldescrption = [];
        var filldescrption1 = [];
        function get_productcode() {
            var data = { 'op': 'get_product_details_po' };
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
            var sup_state = document.getElementById('txt_sup_state').value;
            var sku = $(this).val();
            var checkflag = true;
            for (var i = 0; i < filldescrption.length; i++) {
                if (sku == filldescrption[i].sku) {
                    if (sup_state == "") {
                        alert("Please Enter Suplier Name or Update the Supplier with State");
                        $(this).closest('tr').find('#txtDescription').val("");
                        $(this).closest('tr').find('#txtCode_gst').val("");
                        return false;
                    }
                    else {
                        if (filldescrption[i].igst != "") {
                            $(this).closest('tr').find('#txtDescription').val(filldescrption[i].productname);
                            $(this).closest('tr').find('#txtCost').val(filldescrption[i].price);
                            $(this).closest('tr').find('#txtUom').val(filldescrption[i].uim);
                            $(this).closest('tr').find('#spn_uom').text(filldescrption[i].uim);
                            $(this).closest('tr').find('#hdnproductsno').val(filldescrption[i].productid);
                            var item_state = filldescrption[i].state;

                            if (sup_state == item_state) {
                                $(this).closest('tr').find('#txtsgst').val(filldescrption[i].sgst);
                                $(this).closest('tr').find('#txtcgst').val(filldescrption[i].cgst);
                                $(this).closest('tr').find('#txtigst').val("0");
                                $(this).closest('tr').find('#spn_sgst').text(filldescrption[i].sgst);
                                $(this).closest('tr').find('#spn_cgst').text(filldescrption[i].cgst);
                                $(this).closest('tr').find('#spn_igst').text("0");
                            }
                            else {
                                $(this).closest('tr').find('#txtsgst').val("0");
                                $(this).closest('tr').find('#txtcgst').val("0");
                                $(this).closest('tr').find('#txtigst').val(filldescrption[i].igst);
                                $(this).closest('tr').find('#spn_sgst').text("0");
                                $(this).closest('tr').find('#spn_cgst').text("0");
                                $(this).closest('tr').find('#spn_igst').text(filldescrption[i].igst);
                            }
                            emptytable.push(sku);
                        }
                        else {
                            alert("Product without IGST or CGST or SGST cannot be added");
                            $(this).closest('tr').find('#txtDescription').val("");
                            $(this).closest('tr').find('#txtCode_gst').val("");
                            return false;
                        }
                    }
                }
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
            var sup_state = document.getElementById('txt_sup_state').value;
            var productname = $(this).val();
            var checkflag = true;
            for (var i = 0; i < filldescrption1.length; i++) {
                if (productname == filldescrption1[i].productname) {
                    if (sup_state == "") {
                        alert("Please Enter Suplier Name or Update the Supplier with State");
                        $(this).closest('tr').find('#txtDescription').val("");
                        $(this).closest('tr').find('#txtCode_gst').val("");
                        return false;
                    }
                    else {
                        if (filldescrption[i].igst != "") {
                            $(this).closest('tr').find('#txtCode').val(filldescrption1[i].sku);
                            $(this).closest('tr').find('#hdnproductsno').val(filldescrption1[i].productid);
                            $(this).closest('tr').find('#txtUom').val(filldescrption[i].uim);
                            $(this).closest('tr').find('#spn_uom').text(filldescrption[i].uim);
                            $(this).closest('tr').find('#txtCost').val(filldescrption[i].price);
                            var item_state = filldescrption[i].state;
                            if (sup_state == item_state) {
                                $(this).closest('tr').find('#txtsgst').val(filldescrption[i].sgst);
                                $(this).closest('tr').find('#txtcgst').val(filldescrption[i].cgst);
                                $(this).closest('tr').find('#txtigst').val("0");
                                $(this).closest('tr').find('#spn_sgst').text(filldescrption[i].sgst);
                                $(this).closest('tr').find('#spn_cgst').text(filldescrption[i].cgst);
                                $(this).closest('tr').find('#spn_igst').text("0");
                            }
                            else {
                                $(this).closest('tr').find('#txtsgst').val("0");
                                $(this).closest('tr').find('#txtcgst').val("0");
                                $(this).closest('tr').find('#txtigst').val(filldescrption[i].igst);
                                $(this).closest('tr').find('#spn_sgst').text("0");
                                $(this).closest('tr').find('#spn_cgst').text("0");
                                $(this).closest('tr').find('#spn_igst').text(filldescrption[i].igst);
                            }
                            emptytable1.push(productname);
                        }
                        else {
                            alert("Product without IGST or CGST or SGST cannot be added");
                            $(this).closest('tr').find('#txtDescription').val("");
                            $(this).closest('tr').find('#txtCode_gst').val("");
                            return false;
                        }
                    }
                }
            }
        }
        function forclearall() {
            document.getElementById('txtName').value = "";
            document.getElementById('txtshortName').value = "";
            document.getElementById('txtDelivaryDate').value = "";
            document.getElementById('txtPoamount').innerHTML = "";
            document.getElementById('txtFrAmt').value = "";
            document.getElementById('txtQutn').value = "";
            document.getElementById('txtQtnDate').value = "";
            document.getElementById('txtRemarks').value = "";
            document.getElementById('txtsupid').value = "";
            document.getElementById('ddlpayment').selectedIndex = 0;
            document.getElementById('ddlprice').selectedIndex = 0;
            document.getElementById('ddlterms').selectedIndex = 0;
            document.getElementById('ddlpf').selectedIndex = 0;
            document.getElementById('btn_RaisePO').innerHTML = "Raise";
            var empty = [];
            var results = '<div  style="overflow:auto;"><table id="tabledetails" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Productname</th><th scope="col">Per Unit Rs</th><th scope="col">Quantity</th><th scope="col">Total Cost</th><th scope="col"></th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < empty.length; i++) {
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
            scrollTo(0, 0);
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
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Work Order <small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operations</a></li>
            <li><a href="#">Work Order</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Work Order Details
                </h3>
            </div>
            <div class="box-body">
                <div id="showlogs" align="center">
                    <div class="input-group" style="padding-left:90%">
                        <div class="input-group-addon">
                            <span class="glyphicon glyphicon-plus-sign"></span> <span id="btn_addDept">Work Order</span>
                        </div>
                    </div>
                </div>
                <div id="div_Grid" style="padding-top:2px;">
                </div>
                <div id='vehmaster_fillform' style="display: none;">
                    <table align="center" style="width:60%">
                        <tr>
                            <td style="width:10%;height: 40px;">
                                <label>
                                    Company Name</label><span style="color: red;">*</span>
                                <input id="txtshortName" type="text" class="form-control" name="ShortName" placeholder="Enter Company Name" />
                            </td>
                            <td style="width:5px"></td>
                            <td style="height: 40px;">
                                <label>
                                    Name</label><span style="color: red;">*</span>
                                <input id="txtName" type="text" class="form-control" placeholder="Enter Supplier Name"
                                    onkeypress="return ValidateAlpha(event);" />
                                <input id="txt_sup_state" type="text" style="display:none;" />
                                <input id="txt_sup_gstin" type="text" style="display:none;" />
                            </td>
                        </tr>
                        <tr>
                             <td style="height: 40px;">
                                <label>
                                    Delivery Date</label><span style="color: red;">*</span>
                                <div class="input-group date" style="width:100%;">
                                  <div class="input-group-addon cal">
                                    <i class="fa fa-calendar"></i>
                                  </div>
                                  <input type="date" class="form-control" id="txtDelivaryDate" name="Date" />
                                </div>
                            </td>
                            <td style="width:5px"></td>
                            <td style="height: 40px;">
                                <label>
                                    P and F</label>
                                <select id="ddlpf" class="form-control" onchange="calTotal();">
                                    <option selected disabled value="select pf" >select pf</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>
                                    Freight Amount</label>
                                <input id="txtFrAmt" type="text" class="form-control" name="FreAmount" onkeypress="return isFloat(event)"
                                    placeholder="Enter  Freight Amount" onchange="calTotal();" />
                            </td>
                            <td style="width:5px"></td>
                             <td style="height: 40px;">
                                <label>
                                    Quotation</label>
                                <input id="txtQutn" type="text" class="form-control" name="quotation" placeholder="Enter Quotation" />
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>
                                    Quotation Date</label>
                                <div class="input-group date" style="width:100%;">
                                  <div class="input-group-addon cal">
                                    <i class="fa fa-calendar"></i>
                                  </div>
                                  <input id="txtQtnDate" type="date" class="form-control" name="QuotationDate" placeholder="Enter  QuotationDate" />
                                </div>
                            </td>
                            <td style="width:5px"></td>
                            <td style="height: 40px;">
                                <label>
                                    Delivary Terms</label>
                                <select id="ddlterms" class="form-control">
                                    <option selected disabled value="select terms">select terms</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>
                                    Payment Type</label>
                                <select id="ddlpayment" class="form-control">
                                    <option selected disabled value="select payment">select payment</option>
                                </select>
                            </td>
                            <td style="width:5px"></td>
                            <td style="height: 40px;">
                                <label>
                                    Price Basis</label>
                                <select id="ddlprice" class="form-control">
                                    <option value="Ex-factary">Ex-factary</option>
                                    <option value="Ex-OurLocation">Ex-OurLocation</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>
                                   Delivary Address</label>
                                <select id="ddlAddress" class="form-control">
                                    <option selected disabled value="select DelivaryAddress" >select DelivaryAddress</option>
                                </select>
                            </td>
                            <td style="width:5px"></td>
                            <td style="height: 40px;">
                                <label>
                                   Billing Address</label>
                                <select id="ddlAddress1" class="form-control">
                                    <option selected disabled value="select BillingAddress" >select BillingAddress</option>
                                </select>
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
                                        <span class="glyphicon glyphicon-ok" id="btn_RaisePO1" onclick="save_edit_WorkOrder_click()"></span> <span id="btn_RaisePO" onclick="save_edit_WorkOrder_click()">Raise</span>
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
                     <tr>
                         <td colspan="2">
                             <div id="ShowCategoryData">
                             </div>
                         </td>
                     </tr>
                     <tr>
                         <td>
                             <input type="button" class="btn btn-danger" id="Button1" value="Close" onclick="CloseClick();" />
                         </td>
                     </tr>
                 </table>
             </div>
             <div id="divclose" style="width: 35px; top: 7.5%; right: 8%; position: absolute;
                 z-index: 99999; cursor: pointer;">
                 <img src="Images/Close.png" alt="close" onclick="CloseClick();" />
             </div>
         </div>
        </div>
    </section>
</asp:Content>

