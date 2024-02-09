<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true"
    CodeFile="POApproval.aspx.cs" Inherits="POApproval" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        $(function () {
            $('#close_vehmaster').click(function () {
                $('#PO_ApprovalFillForm').css('display', 'none');
                $('#div_POApprovalData').show();
                forclearall();
            });
            get_purchaseorder_details();
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
        function getcode(thisid) {
            var code = $(thisid).parent().parent().children('.1').html();
            document.getElementById('txtcode').value = code;

        }

        function get_purchaseorder_details() {
            var data = { 'op': 'get_purchase_pendingdetails' };
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

            var results = '<div style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr class="trbgclrcls"><th scope="col">Po Date</th><th scope="col">Supplier Name</th><th scope="col">Delivery Date</th><th scope="col"></th></tr></thead></tbody>';
            var po = msg[0].podetails;
            purchase_sub_list = msg[0].subpurchasedetails;
            var k = 1;
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            for (var i = 0; i < po.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">';//<td><input id="btn_poplate" type="button"  onclick="getpurchasevalues(this)" name="submit" class="btn btn-primary" value="Approval" /></td>
                results += '<td data-title="podate" class="5">' + po[i].podate + '</td>';
                results += '<td data-title="name" class="1">' + po[i].name + '</td>';
                results += '<td data-title="delivarydate" class="3">' + po[i].delivarydate + '</td>';
                results += '<td data-title="PONo" style="display:none;" class="12">' + po[i].pono + '</td>';
                results += '<td data-title="poamount" style="display:none;" class="6">' + parseFloat(po[i].poamount).toFixed(2) + '</td>';
                results += '<td data-title="shortname" class="7" style="display:none;">' + po[i].shortname + '</td>';
                results += '<td data-title="freigntamt" class="8" style="display:none;">' + parseFloat(po[i].freigntamt).toFixed(2) + '</td>';
                results += '<td data-title="vattin" class="11" style="display:none;">' + parseFloat(po[i].disamt).toFixed(2) + '</td>';
                results += '<td data-title="address" class="15" style="display:none;">' + po[i].addressid + '</td>';
                results += '<td data-title="quotationno" class="16" style="display:none;">' + po[i].quotationno + '</td>';
                results += '<td data-title="quotationdate" class="17" style="display:none;">' + po[i].quotationdate + '</td>';
                results += '<td data-title="quotationdate" class="22" style="display:none;">' + po[i].paymenttype + '</td>';
                results += '<td data-title="quotationdate" class="20" style="display:none;">' + po[i].deliveryterms + '</td>';
                results += '<td data-title="quotationdate" class="21" style="display:none;">' + po[i].pandf + '</td>';
                results += '<td data-title="quotationdate" class="23" style="display:none;">' + po[i].pricebasis + '</td>';
                results += '<td data-title="quotationdate" class="26" style="display:none;">' + po[i].remarks + '</td>';
                results += '<td data-title="brandstatus"><button type="button" title="Click Here To Approve!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 apprvcls"  onclick="getpurchasevalues(this)"><span class="glyphicon glyphicon-thumbs-up" style="top: 0px !important;"></span></button></td>';
                results += '<td data-title="hiddensupplyid" class="18" style="display:none;">' + po[i].hiddensupplyid + '</td>';
                results += '<td data-title="sno" class="13" style="display:none;">' + po[i].sno + '</td></tr>';

                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_POApprovalData").html(results);
        }
        var sno = 0;
        function getpurchasevalues(thisid) {

            $('#PO_ApprovalFillForm').css('display', 'block');
            $('#div_POApprovalData').hide();
            scrollTo(0, 0);
            var name = $(thisid).parent().parent().children('.1').html();
            var delivarydate = $(thisid).parent().parent().children('.3').html();
            var poamount = $(thisid).parent().parent().children('.6').html();
            var shortname = $(thisid).parent().parent().children('.7').html();
            var freigntamt = $(thisid).parent().parent().children('.8').html();
            var PONo = $(thisid).parent().parent().children('.12').html();
            var sno = $(thisid).parent().parent().children('.13').html();
             var addressid = $(thisid).parent().parent().children('.15').html();
            var quotationno = $(thisid).parent().parent().children('.16').html();
            var quotationdate = $(thisid).parent().parent().children('.17').html();
            var deliveryterms = $(thisid).parent().parent().children('.20').html();
            var pandf = $(thisid).parent().parent().children('.21').html();
            var paymenttype = $(thisid).parent().parent().children('.22').html();
            var pricebasis = $(thisid).parent().parent().children('.23').html();
            var remarks = $(thisid).parent().parent().children('.26').html();
            var hiddensupplyid = $(thisid).parent().parent().children('.18').html();
            var podate2 = $(thisid).parent().parent().children('.5').html();

            var podate1 = podate2.split('-');
            var podate = podate1[2] + '-' + podate1[1] + '-' + podate1[0];

            document.getElementById('txtName').innerHTML = name;
            document.getElementById('txtPo').value = PONo;
            document.getElementById('txtshortName').innerHTML = shortname;
            document.getElementById('txtPoamount').innerHTML = poamount;
            document.getElementById('txtDelivaryDate').innerHTML = delivarydate;
            document.getElementById('txtFrAmt').innerHTML = freigntamt;
            document.getElementById('ddladdress').innerHTML = addressid;
            document.getElementById('txtQutn').innerHTML = quotationno;
            document.getElementById('ddlterms').value = deliveryterms;
            document.getElementById('ddlpf').value = pandf;
            document.getElementById('ddlprice').innerHTML = pricebasis;
            document.getElementById('txtRemarks').innerHTML = remarks;
            document.getElementById('txtQtnDate').innerHTML = quotationdate;
            document.getElementById('ddlpayment').value = paymenttype;
            document.getElementById('txtsupid').innerHTML = hiddensupplyid;
            document.getElementById('btn_RaisePO').innerHTML = "Approve";
            var table = document.getElementById("tabledetails");
            var todaydate = podate.split('-');
            var date = "2017-07-01".split('-');

            var firstDate = new Date();
            firstDate.setFullYear(todaydate[0], (todaydate[1] - 1), todaydate[2]);
            var secondDate = new Date();
            secondDate.setFullYear(date[0], (date[1] - 1), date[2]);
            if (firstDate >= secondDate) {
                var results = '<div  style="overflow:auto;"><table id="tabledetails_gst" class="table table-bordered table-hover dataTable no-footer">';
                results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Description</th><th scope="col">Qty</th><th scope="col">Rate</th><th scope="col">Dis %</th><th scope="col">Dis Amt</th><th scope="col">SGST %</th><th scope="col">CGST %</th><th scope="col">IGST %</th></tr></thead></tbody>';
                var k = 1;
                for (var i = 0; i < purchase_sub_list.length; i++) {
                    if (PONo == purchase_sub_list[i].pono) {
                        results += '<tr><td data-title="Sno" class="1">' + k + '</td>';
                        results += '<td data-title="From"><span id="spn_code">' + purchase_sub_list[i].code + '</span><input id="txtCode" class="codecls" name="code" readonly value="' + purchase_sub_list[i].code + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;display:none;"></input></td>';
                        results += '<td data-title="From"><span id="spn_description">' + purchase_sub_list[i].description + '</span><input class="3" readonly id="txtDescription" readonly name="description" class="clsdesc" value="' + purchase_sub_list[i].description + '" style="display:none;width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                        results += '<td data-title="From"><span id="spn_qty">' + purchase_sub_list[i].qty + '</span><input class="clsQty" readonly id="txtQty"  name="qty"  value="' + purchase_sub_list[i].qty + '" onkeypress="return isFloat(event)" style="display:none;width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                        results += '<td data-title="From"><span id="spn_cost">' + parseFloat(purchase_sub_list[i].cost).toFixed(2) + '</span><input  class="clscost" readonly id="txtCost" name="cost"  value="' + purchase_sub_list[i].cost + '" onkeypress="return isFloat(event)" style="display:none;width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                        results += '<td data-title="From"><span id="spn_dis">' + purchase_sub_list[i].dis + '</span><input  id="txtDis" readonly name="dis" class="clsdis" value="' + purchase_sub_list[i].dis + '" onkeypress="return isFloat(event)"  style="display:none;width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                        results += '<td data-title="From"><span id="spn_disamt">' + parseFloat(purchase_sub_list[i].disamt).toFixed(2) + '</span><input  id="txtDisAmt" readonly class="clsdisamt" name="disamt" value="' + purchase_sub_list[i].disamt + '" onkeypress="return isFloat(event)" style="display:none;width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                        results += '<td data-title="From"><span id="spn_sgst_per">' + purchase_sub_list[i].sgst_per + '</span><input id="txt_sgst_per" readonly class="cls_sgst_per" name="sgst_per" value="' + purchase_sub_list[i].sgst_per + '"  style="display:none;width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                        results += '<td data-title="From"><span id="spn_cgst_per">' + purchase_sub_list[i].cgst_per + '</span><input id="txt_cgst_per" readonly class="cls_cgst_per" name="cgst_per" value="' + purchase_sub_list[i].cgst_per + '"  style="display:none;width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                        results += '<td data-title="From"><span id="spn_igst_per">' + purchase_sub_list[i].igst_per + '</span><input id="txt_igst_per" readonly class="cls_igst_per" name="igst_per" value="' + purchase_sub_list[i].igst_per + '"  style="display:none;width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                        results += '<td style="display:none"><span id="txttotal" type="text" class="clstotal"  onkeypress="return isFloat(event)"  style="width:500px;"/></td>';
                        results += '<td style="display:none" data-title="From"><input class="13" id="hdnproductsno" type="hidden" name="hdnproductsno" value="' + purchase_sub_list[i].hdnproductsno + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                        results += '<td data-title="From" style="display:none"><input class="14" id="txt_sub_sno" name="txt_sub_sno" value="' + purchase_sub_list[i].sno + '"style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td></tr>';
                        k++;
                    }
                }
                results += '</table></div>';
                $("#div_SectionData").html(results);
            }
            else {
                var results = '<div  style="overflow:auto;"><table id="tabledetails" class="table table-bordered table-hover dataTable no-footer">';
                results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Description</th><th scope="col">Qty</th><th scope="col">Rate</th><th scope="col">Dis%</th><th scope="col">Dis Amt</th><th scope="col">Tax Type</th><th scope="col">Tax%</th><th scope="col">ED</th><th scope="col">ED Tax%</th></tr></thead></tbody>';
                var k = 1;
                for (var i = 0; i < purchase_sub_list.length; i++) {
                    if (PONo == purchase_sub_list[i].pono) {
                        results += '<tr><td data-title="Sno" class="1">' + k + '</td>';
                        results += '<td data-title="From"><span id="spn_code">' + purchase_sub_list[i].code + '</span><input id="txtCode" class="codecls" name="code" readonly value="' + purchase_sub_list[i].code + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;display:none;"></input></td>';
                        results += '<td data-title="From"><span id="spn_description">' + purchase_sub_list[i].description + '</span><input class="3" readonly id="txtDescription" readonly name="description" class="clsdesc" value="' + purchase_sub_list[i].description + '" style="display:none;width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                        results += '<td data-title="From"><span id="spn_qty">' + purchase_sub_list[i].qty + '</span><input class="clsQty" readonly id="txtQty"  name="qty"  value="' + purchase_sub_list[i].qty + '" onkeypress="return isFloat(event)" style="display:none;width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                        results += '<td data-title="From"><span id="spn_cost">' + parseFloat(purchase_sub_list[i].cost).toFixed(2) + '</span><input  class="clscost" readonly id="txtCost" name="cost"  value="' + purchase_sub_list[i].cost + '" onkeypress="return isFloat(event)" style="display:none;width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                        results += '<td data-title="From"><span id="spn_dis">' + purchase_sub_list[i].dis + '</span><input  id="txtDis" readonly name="dis" class="clsdis" value="' + purchase_sub_list[i].dis + '" onkeypress="return isFloat(event)"  style="display:none;width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                        results += '<td data-title="From"><span id="spn_disamt">' + parseFloat(purchase_sub_list[i].disamt).toFixed(2) + '</span><input  id="txtDisAmt" readonly class="clsdisamt" name="disamt" value="' + purchase_sub_list[i].disamt + '" onkeypress="return isFloat(event)" style="display:none;width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                        results += '<td data-title="From"><span id="spn_taxtype">' + purchase_sub_list[i].taxtype + '</span><input id="ddlTaxtype" readonly class="Taxtypecls" name="taxtype"   value="' + purchase_sub_list[i].taxtype + '"  style="display:none;width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                        results += '<td data-title="From"><span id="spn_tax">' + purchase_sub_list[i].tax + '</span><input  id="txtTax" readonly class="clstax"  name="tax" value="' + purchase_sub_list[i].tax + '" onkeypress="return isFloat(event)" style="display:none;width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                        results += '<td data-title="From"><span id="spn_ed">' + purchase_sub_list[i].ed + '</span><input id="ddlEd" readonly class="edcls"  name="ed"  value="' + purchase_sub_list[i].ed + '"  style="display:none;width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                        results += '<td data-title="From"><span id="spn_edtax">' + purchase_sub_list[i].edtax + '</span><input  id="txtEdtax" readonly name="edtax" class="clsed" value="' + purchase_sub_list[i].edtax + '" onkeypress="return isFloat(event)" style="display:none;width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                        results += '<td style="display:none"><span id="txttotal" type="text" class="clstotal"  onkeypress="return isFloat(event)"  style="width:500px;"/></td>';
                        results += '<td style="display:none" data-title="From"><input class="13" id="hdnproductsno" type="hidden" name="hdnproductsno" value="' + purchase_sub_list[i].hdnproductsno + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                        results += '<td data-title="From" style="display:none"><input class="14" id="txt_sub_sno" name="txt_sub_sno" value="' + purchase_sub_list[i].sno + '"style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td></tr>';
                        k++;
                    }
                }
                results += '</table></div>';
                $("#div_SectionData").html(results);
            }
        }
        function GetFixedrows() {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" ID="tabledetails">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Description</th><th scope="col">Qty</th><th scope="col">Rate</th><th scope="col">Dis %</th><th scope="col">Dis Amt</th><th scope="col">Tax Type</th><th scope="col">Tax %</th><th scope="col">ED</th><th scope="col">ED Tax%</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 1; i < 11; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + i + '</td>';
                results += '<td ><input id="txtCode" type="text" readonly class="codecls"   placeholder= "select ProductName" style="width:90px;" /></td>';
                results += '<td ><input id="txtDescription" readonly type="text" class="clsdesc"   style="width:90px;"/></td>';
                results += '<td ><input id="txtQty" type="text" readonly class="clsQty"  placeholder= "enter qty" onkeypress="return isFloat(event)" class="form-control"  style="width:90px;"/></td>';
                results += '<td ><input id="txtCost" type="text" readonly class="clscost"  placeholder= "cost" onkeypress="return isFloat(event)" class="form-control"  style="width:50px;"/></td>'
                results += '<td><input id="ddlTaxtype" readonly class="Taxtypecls" style="width:90px;"/></td>';
                results += '<td ><input id="txtTax" type="text" readonly placeholder= "tax" class="clstax" onkeypress="return isFloat(event)" style="width:50px;"/></td>';
                results += '<td ><input id="ddlEd" type="text" readonly class="edcls" style="width:90px;"/></td>';
                results += '<td ><input id="txtEdtax" readonly type="text" class="clsed" placeholder="Edtax" onkeypress="return isFloat(event)"  style="width:90px;"/></td>';
                results += '<td ><span id="txttotal" type="text" class="clstotal"  onkeypress="return isFloat(event)"  style="width:500px;"></td>';
                results += '<td ><input id="hdnproductsno" type="hidden" /></td>';
                results += '<td style="display:none" class="4">' + i + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
        }
        var DataTable;
        function insertrow() {
            DataTable = [];
            var txtsno = 0;
            var code = 0;
            var description = 0;
            var qty = 0;
            var cost = 0;
            var taxtype = 0;
            var ed = 0;
            var tax = 0;
            var edtax = 0;
            var hdnproductsno = 0;
            var rows = $("#tabledetails tr:gt(0)");
            var rowsno = 1;
            $(rows).each(function (i, obj) {
                if ($(this).find('#txtCode').val() != "") {
                    txtsno = rowsno;
                    code = $(this).find('#txtCode').val();
                    description = $(this).find('#txtDescription').val();
                    qty = $(this).find('#txtQty').val();
                    cost = $(this).find('#txtCost').val();
                    taxtype = $(this).find('#ddlTaxtype').val();
                    ed = $(this).find('#ddlEd').val();
                    tax = $(this).find('#txtTax').val();
                    edtax = $(this).find('#txtEdtax').val();
                    hdnproductsno = $(this).find('#hdnproductsno').val();
                    DataTable.push({ Sno: txtsno, code: code, description: description, qty: qty,  cost: cost, taxtype: taxtype, ed: ed,  tax: tax, edtax: edtax, hdnproductsno: hdnproductsno });
                    rowsno++;

                }
            });
            code = 0;
            description = 0;
            qty = 0;
            cost = 0;
            taxtype = 0;
            ed = 0;
            dis = 0;
            disamt = 0;
            tax = 0;
            edtax = 0;

            hdnproductsno = 0;
            var Sno = parseInt(txtsno) + 1;
            DataTable.push({ Sno: Sno, code: code, description: description, qty: qty,  cost: cost, taxtype: taxtype, ed: ed,  tax: tax, edtax: edtax, hdnproductsno: hdnproductsno });
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr><th scope="col"></th><th scope="col">Po No</th><th scope="col">Po Date</th><th scope="col">Supplier Name</th><th scope="col">Delivery Date</th><th scope="col">Expired Date</th></tr></thead></tbody>';
            for (var i = 0; i < DataTable.length; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + DataTable[i].Sno + '</td>';
                results += '<td ><input id="txtCode" readonly type="text" class="codecls"  style="width:90px;" onkeypress="return isFloat(event)"  value="' + DataTable[i].code + '"/></td>';
                results += '<td ><input id="txtDescription" readonly type="text" class="clsdesc" style="width:90px;" value="' + DataTable[i].description + '"/></td>';
                results += '<td ><input id="txtQty" type="text" readonly class="clsQty"  onkeypress="return isFloat(event)" style="width:90px;" value="' + DataTable[i].qty + '"/></td>';
                results += '<td ><input id="txtCost" type="text" readonly class="clscost"  onkeypress="return isFloat(event)" style="width:50px;" value="' + DataTable[i].cost + '"/></td>';
                results += '<td ><input id="txtDis" type="text" readonly class="clsdis" style="width:50px;" onkeypress="return isFloat(event)" value="' + DataTable[i].dis + '"/></td>';
                results += '<td ><input id="txtDisAmt" type="text" readonly class="clsdisamt" style="width:50px;" onkeypress="return isFloat(event)" value="' + DataTable[i].disamt + '"/></td>';
                results += '<td><input id="ddlTaxtype" readonly class="Taxtypecls" style="width:90px; value="' + DataTable[i].taxtype + '"/></td>';
                results += '<td ><input id="txtTax" type="text" readonly class="clstax"  style="width:50px;" onkeypress="return isFloat(event)" value="' + DataTable[i].tax + '"/></td>';
                results += '<td ><input id="ddlEd" type="text" readonly class="edcls" style="width:90px;" value="' + DataTable[i].ed + '"/></td>';
                results += '<td ><input id="txtEdtax" type="text" readonly class="clsed"  style="width:50px;" onkeypress="return isFloat(event)" value="' + DataTable[i].edtax + '"/></td>';
                results += '<td ><span id="txttotal" type="text" readonly class="clstotal"   onkeypress="return isFloat(event)"  style="width:500px;"/></td>';
                results += '<td ><input id="hdnproductsno" type="hidden" value="' + DataTable[i].hdnproductsno + '"/></td>';
                results += '<td style="display:none" class="4">' + i + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
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

        function forclearall() {
            document.getElementById('txtPo').value = "";
            document.getElementById('txtName').value = "";
            document.getElementById('txtshortName').value = "";
            document.getElementById('txtDelivaryDate').value = "";
            document.getElementById('ddlprice').value = "";
            document.getElementById('txtPoamount').value = "";
             document.getElementById('ddladdress').value = "";
            document.getElementById('ddlstatus').selectedIndex = "";
            document.getElementById('txtFrAmt').value = "";
            document.getElementById('btn_RaisePO').innerHTML = "Approval";
            scrollTo(0, 0);
            var empty = [];
            var results = '<div  style="overflow:auto;"><table id="tabledetails" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Per Unit Rs</th><th scope="col">Quantity</th><th scope="col">Total Cost</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < empty.length; i++) {
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
        }
        function approval_pending_podetails_click() {
            var PONo = document.getElementById('txtPo').value;
            var status = document.getElementById('ddlstatus').value;
            if (status == "") {

                alert("select status");
            }
            var Data = { 'op': 'approval_pending_podetails_click', 'pono': PONo, 'status': status };
            var s = function (msg) {
                if (msg) {
                    alert(msg);
                    get_purchaseorder_details();
                    $('#PO_ApprovalFillForm').css('display', 'none');
                    $('#div_POApprovalData').show();
                    forclearall();
                }
            }
            var e = function (x, h, e) {
            };
            callHandler(Data, s, e);
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
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            PO Approval Details<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operations</a></li>
            <li><a href="#">PO Approval Details</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>PO Approval Details Details
                </h3>
            </div>
            <div class="box-body">
                <div id="div_POApprovalData">
                </div>
                <div id='PO_ApprovalFillForm' style="display: none;">
                    <table align="center">
                        <tr>
                            <td style="height: 40px;">
                                <label>
                                    Name</label>
                                <span id="txtName" class="form-control" placeholder="Enter Name" onkeypress="return ValidateAlpha(event);" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;">
                                <label>
                                    Short Name</label>
                                <span id="txtshortName" class="form-control" name="ShortName" placeholder="Enter ShortName" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>
                                    Delivary Date</label>
                                <span type="date" class="form-control" id="txtDelivaryDate" name="Date" />
                            </td>
                            <td>
                            </td>
                            <td style="height: 40px;">
                                <label>
                                    Freight Amt</label>
                                <span id="txtFrAmt" class="form-control" name="FreAmount" onkeypress="return isFloat(event)"
                                    placeholder="Enter Freignt Amt" />
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>
                                    Quotation</label>
                                <span id="txtQutn" class="form-control" name="quotation" placeholder="Enter Quotation" />
                            </td>
                            <td>
                            </td>
                            <td style="height: 40px;">
                                <label>
                                    Quotation Date</label>
                                <div class="input-group date" style="width:100%;">
                                      <div class="input-group-addon cal">
                                        <i class="fa fa-calendar"></i>
                                      </div>
                                      <span id="txtQtnDate" type="date" class="form-control" name="QuotationDate" placeholder="Enter Quotation Date" />
                                </div>
                            </td>
                            <td style="height: 40px;">
                                <input id="txtsupid" type="hidden" class="form-control" name="hiddensupplyid" />
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>
                                    Delivary Terms</label>
                                <input id="ddlterms" readonly class="form-control"> </input>
                            </td>
                            <td>
                            </td>
                            <td style="height: 40px;">
                                <label>
                                    Payment Type</label>
                                <input id="ddlpayment" readonly class="form-control"> </input>
                            </td>
                        </tr>

                        <tr>
                            <td style="height: 40px;">
                                <label>
                                    P and F</label>
                                <input id="ddlpf" readonly class="form-control"> </input>
                            </td>
                            
                             <td>
                            </td>
                         
                            <td style="height: 40px;">
                                <label>
                                    Price Basis</label>
                                <input id="ddlprice" readonly  class="form-control" />
                            </td>
                            </tr>
                      <tr>
                            <td style="height: 40px;">
                                <label>
                                    Address</label>
                                <input id="ddladdress" readonly  class="form-control" />
                            </td>

                            <td>
                            </td>

                            <td style="height: 40px;">
                                <label>
                                    Status</label>
                                <select id="ddlstatus" class="form-control">
                                    <option value="A">Approval</option>
                                    <option value="C">Cancel</option>
                                </select>
                            </td>
                             <td>
                            </td>
                        </tr>
                       
                         <tr>
                            <td style="height: 40px;">
                                <input id="txtPo" type="hidden" class="form-control" hidden />
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
                                <span id="txtPoamount" style="width: 500px; color: Red; font-weight: bold; font-size: 25px;"
                                    class="clspomount" name="PoAmount" onkeypress="return isFloat(event)" placeholder="Enter PO Amount">
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Remarks</label>
                            </td>
                            <td style="height: 40px;">
                                <span id="txtRemarks" rows="4" cols="10" name="Remarks" class="form-control" placeholder="Enter Remarks">
                                </span>
                            </td>
                        </tr>
                    </table>
                    <table align="center">
                        <tr>
                            <td>
                                <table>
                                   <tr>
                                    <td>
                                    <div class="input-group">
                                        <div class="input-group-addon">
                                        <span class="glyphicon glyphicon-ok" id="btn_RaisePO1" onclick="approval_pending_podetails_click()"></span> <span id="btn_RaisePO" onclick="approval_pending_podetails_click()">Approval</span>
                                  </div>
                                  </div>
                                    </td>
                                    <td style="width:10px;"></td>
                                    <td>
                                     <div class="input-group">
                                        <div class="input-group-close">
                                        <span class="glyphicon glyphicon-remove" id='close_vehmaster1'></span> <span id='close_vehmaster'>Cancel</span>
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
    </section>
</asp:Content>
