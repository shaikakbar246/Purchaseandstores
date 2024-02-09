<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true" CodeFile="invoice.aspx.cs" Inherits="invoice" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        .container
        {
            max-width: 100%;
        }
        th
        {
            text-align: center;
        }
    </style>
    <script type="text/javascript">
        function CallPrint(strid) {
            var divToPrint = document.getElementById(strid);
            var newWin = window.open('', 'Print-Window', 'width=400,height=400,top=100,left=100');
            newWin.document.open();
            newWin.document.write('<html><body   onload="window.print()">' + divToPrint.innerHTML + '</body></html>');
            newWin.document.close();
        }
    </script>
    <script type="text/javascript">
        $(function () {
            var refdcno1 = '<%=Session["POSno"] %>';
            if (refdcno1 != "") {
                btn_Purchase_order_click1();
            }
            $('#hiderefno').css('display', 'none');
            $('#Button2').css('display', 'none');
        });
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
        function btn_Purchase_order_click1() {
            var refdcno = document.getElementById('txt_refdcno').value
            var refdcno1 = '<%=Session["POSno"] %>';
            var data = { 'op': 'get_purchase_order_details_click', 'refdcno': refdcno, 'refdcno1': refdcno1 };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        $('#divPrint').css('display', 'block');
                        var po_details = msg[0].podetails;
                        var po_sub_details = msg[0].subpurchasedetails;
                        amountfright = parseFloat(po_details[0].freigntamt);
                        amountvat = parseFloat(po_details[0].vatamount);
                        vatamount = parseFloat(po_details[0].vatamount);
                        document.getElementById('spnvendorname').innerHTML = po_details[0].name;
                        document.getElementById('lblvendorphoneno').innerHTML = po_details[0].mobile;
                        document.getElementById('spnaddress').innerHTML = po_details[0].address;
                        document.getElementById('spnpono').innerHTML = "SVDS/PBK/00" + po_details[0].ponumber;
                        document.getElementById('spnreferenceno').innerHTML = po_details[0].pono;
                        document.getElementById('lblvendoremail').innerHTML = po_details[0].email;
                        document.getElementById('spnpodate').innerHTML = po_details[0].podate;
                        document.getElementById('spantin').innerHTML = po_details[0].vattin;
                        document.getElementById('spnquotationno').innerHTML = po_details[0].quotationno;
                        document.getElementById('spnquotationdate').innerHTML = po_details[0].quotationdate;
                        document.getElementById('spanDelivaryAddress').innerHTML = po_details[0].deliveryaddress;
                        document.getElementById('spanBillingAddress').innerHTML = po_details[0].billingaddress;
                        document.getElementById('spanterms').innerHTML = po_details[0].terms;
                        document.getElementById('spancontactname').innerHTML = po_details[0].contactnumber;
                        var ins = po_details[0].insurence;
                        if (ins == "YES") {
                            document.getElementById('spaninsurence').innerHTML = po_details[0].insuranceamount;
                        }
                        else {
                            document.getElementById('spaninsurence').innerHTML = po_details[0].insurence;
                        }
                        document.getElementById('spanpayment').innerHTML = po_details[0].payment;

                        var warranty = po_details[0].warranytype;
                        if (warranty == "YES") {
                            document.getElementById('spanwarranty').innerHTML = po_details[0].warranty;
                        }
                        else {
                            document.getElementById('spaninsurence').innerHTML = po_details[0].warranytype;
                        }
                        document.getElementById('spnremarks').innerHTML = po_details[0].SupplierRemarks;
                        document.getElementById('spanpricebasis').innerHTML = po_details[0].pricebasis;
                        fill_sub_Po_details(po_sub_details);
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
        function btnPODetails_click() {
            var fromdate = document.getElementById('txtfromdate').value;
            var todate = document.getElementById('txttodate').value
            if (fromdate == "") {
                alert("Please select from date");
                return false;
            }
            if (todate == "") {
                alert("Please select to date");
                return false;
            }
            var data = { 'op': 'get_po_details_click', 'fromdate': fromdate, 'todate': todate };
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
            // var status = "A";
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col"></th><th scope="col">Ref No</th><th scope="col">PO Number</th><th scope="col">Name</th><th scope="col">Po Date</th><th scope="col">Deivery Date</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                //if (status == msg[i].status) {
                results += '<tr><th><input id="btn_Print" type="button"   onclick="printclick(this);"  name="Edit" class="btn btn-primary" value="Print" /></th>'
                results += '<td scope="row" class="1"  style="text-align:center;">' + msg[i].sno + '</td>';
                results += '<td data-title="brandstatus" class="2">' + msg[i].ponumber + '</td>';
                results += '<td data-title="brandstatus" class="2">' + msg[i].name + '</td>';
                results += '<td data-title="brandstatus" class="2">' + msg[i].podate + '</td>';
                results += '<td data-title="brandstatus" class="2">' + msg[i].delivarydate + '</td></tr>';
                // results += '<td data-title="brandstatus" class="2">' + msg[i].expiredate + '</td></tr>';
                //}
            }
            results += '</table></div>';
            $("#divPOdata").html(results);
        }
        var amountfri = 0; var amountvat = 0; var vatamount = 0; var amountfright = 0; var newXarray = [];var podate;
        function printclick(thisid) {
            var refdcno = $(thisid).parent().parent().children('.1').html();
            var Pono = $(thisid).parent().parent().children('.2').html();
            var refdcno1 = '<%=Session["POSno"] %>';
            var data = { 'op': 'get_purchaseINVOCE_order_details_click', 'refdcno': refdcno, 'refdcno1': refdcno1 };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        $('#divPrint').css('display', 'block');
                        $('#Button2').css('display', 'block');
                        var po_details = msg[0].podetails;
                        var po_sub_details = msg[0].subpurchasedetails;
                        amountvat = parseFloat(po_details[0].vatamount);
                        vatamount = parseFloat(po_details[0].vatamount);
                        document.getElementById('spnvendorname').innerHTML = po_details[0].name;
                        document.getElementById('lblvendorphoneno').innerHTML = po_details[0].mobile;
                        document.getElementById('spnaddress').innerHTML = po_details[0].address;
                        document.getElementById('spnpono').innerHTML = Pono;
                        document.getElementById('spnreferenceno').innerHTML = po_details[0].pono;
                        document.getElementById('lblvendoremail').innerHTML = po_details[0].email;
                        document.getElementById('spnpodate').innerHTML = po_details[0].podate;
                        document.getElementById('spantin').innerHTML = po_details[0].vattin;
                        document.getElementById('spnAddress').innerHTML = po_details[0].Add_ress;
                        document.getElementById('spnquotationno').innerHTML = po_details[0].quotationno;
                        document.getElementById('spnquotationdate').innerHTML = po_details[0].quotationdate;
                        document.getElementById('spanDelivaryAddress').innerHTML = po_details[0].deliveryaddress;
                        document.getElementById('spanBillingAddress').innerHTML = po_details[0].billingaddress;
                        document.getElementById('spanterms').innerHTML = po_details[0].terms;
                        document.getElementById('spancontactname').innerHTML = po_details[0].contactnumber;
                        var ins = po_details[0].insurence;
                        if (ins == "YES") {
                            document.getElementById('spaninsurence').innerHTML = po_details[0].insuranceamount;
                        }
                        else {
                            document.getElementById('spaninsurence').innerHTML = po_details[0].insurence;
                        }
                        document.getElementById('spanpayment').innerHTML = po_details[0].payment;
                        var warranty = po_details[0].warranytype;
                        if (warranty == "YES") {
                            document.getElementById('spanwarranty').innerHTML = po_details[0].warranty;
                        }
                        else {
                            document.getElementById('spaninsurence').innerHTML = po_details[0].warranytype;
                        }
                        document.getElementById('spnremarks').innerHTML = po_details[0].SupplierRemarks;
                        document.getElementById('spanpricebasis').innerHTML = po_details[0].pricebasis;
                        podate = po_details[0].podate;
                        fill_sub_Po_details(po_sub_details);
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
        var amountfright1 = 0; var totcst = 0; var taxabletotalamount = 0; var taxablegrandtotal = 0; var ed = 0; var tax = 0; var pf = 0; var disamt = 0; var totamount = 0; var toted = 0; var tot_amount1 = 0; var grandtotal1 = 0; var totpf = 0;
        function fill_sub_Po_details(msg) {
            var junedate = "06/30/2017";
            var jd = new Date(junedate);
            var pd = new Date("07/01/2017");
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" border="2" style="width:100%;">';
            if (pd > jd) {
                results += '<thead><tr><th value="#" colspan="1" rowspan="2">Sno</th><th value="Item Code" colspan="1" rowspan="2">Item Code</th><th value="Item Name" colspan="1" rowspan="2">Item Name</th><th value="HSN" colspan="1" rowspan="2">HSN</th><th value="Item Description" colspan="1" rowspan="2">Item Description</th><th value="UOM" colspan="1" rowspan="2">UOM</th><th value="Qty" colspan="1" rowspan="2">Qty</th><th value="Rate/Item (Rs.)" colspan="1" rowspan="2">Rate/Item (Rs.)</th><th value="Discount (Rs.)" colspan="1" rowspan="2">Discount (Rs.)</th><th value="Taxable Value" colspan="1" rowspan="2">Taxable Value</th><th value="CGST" colspan="2" rowspan="1" class="cgst">CGST</th><th value="SGST" colspan="2" rowspan="1" class="sgst">SGST</th><th value="IGST" colspan="2" rowspan="1" class="igst">IGST</th></tr><tr><th value="%" colspan="1" rowspan="1" class="cgst">%</th><th value="Amt (Rs.)" colspan="1" rowspan="1" class="cgst">Amt (Rs.)</th><th value="%" colspan="1" rowspan="1" class="sgst">%</th><th value="Amt (Rs.)" colspan="1" rowspan="1" class="sgst">Amt (Rs.)</th><th value="%" colspan="1" rowspan="1" class="igst">%</th><th value="Amt (Rs.)" colspan="1" rowspan="1" class="igst">Amt (Rs.)</th><th value="Total Amt" colspan="1" rowspan="2" class="igst">Total Amt</th></tr></thead>'
            }
            else {
                results += '<thead><tr><th scope="col">Sno</th><th scope="col">Item Code</th><th scope="col">Item Name</th><th scope="col">Item Description</th><th scope="col">UOM</th><th scope="col">Qty</th><th scope="col">Rate</th><th scope="col">Discount</th><th scope="col">Amount</th></tr></thead></tbody>';
            }
            var j = 1;
            if (msg.length > 11) {
                $('#divrowcnt').css('height', '2080px');
            }
            for (var i = 0; i < msg.length; i++) {
                var qty = 0;
                qty = parseFloat(msg[i].qty);
                var cost = 0;
                var taxvalue = 0;
                var totaltax = 0;
                cost = parseFloat(msg[i].cost);
                var amt = 0; var amount = 0; var amount1 = 0;
                amt = qty * cost;
                amount1 = parseFloat(amt).toFixed(2);
                disamt = parseFloat(msg[i].disamt);
                diswithamount = amt - disamt;
                amount = parseFloat(diswithamount).toFixed(2);
                ed = parseFloat(msg[i].edtax);
                taxid = parseFloat(msg[i].taxtype);
                pf = parseFloat(msg[i].pfamount);
                tax = parseFloat(msg[i].tax);
                if (j == 1) {
                    amountfright = parseFloat(msg[i].freigntamt);
                    amountfright1 = amountfright;
                    transcharge = parseFloat(msg[i].transcharge) || 0;
                    transcharge1 = transcharge;
                }
                results += '<tr><th scope="row" class="1" style="text-align:center;">' + j + '</th>';
                results += '<td data-title="brandstatus" class="2">' + msg[i].code + '</td>';
                results += '<td data-title="brandstatus" class="8">' + msg[i].description + '</td>';
                if (pd > jd) {
                    results += '<td data-title="brandstatus" class="8">HSN123</td>';
                }
                results += '<td data-title="brandstatus" class="8">' + msg[i].productdescription + '</td>';
                results += '<td data-title="brandstatus" class="9">' + msg[i].uim + '</td>';
                results += '<td data-title="brandstatus" class="3">' + qty + '</td>';
                results += '<td data-title="brandstatus" class="4">' + parseFloat(cost).toFixed(2) + '</td>';
                results += '<td data-title="brandstatus" class="4">' + parseFloat(disamt).toFixed(2) + '</td>';
                results += '<td data-title="brandstatus" class="tammountcls">' + parseFloat(amount).toFixed(2) + '</td>'
                if (pd > jd) {
                    var taxamount = parseFloat(amount).toFixed(2);
                    taxabletotalamount += taxamount;
                    var sgstamt = (taxamount * 2.5) / 100;
                    var cgstamt = (taxamount * 2.5) / 100;
                    results += '<td data-title="brandstatus" class="10">2.5</td>'
                    results += '<td data-title="brandstatus" class="11">' + parseFloat(sgstamt).toFixed(2) + '</td>'
                    results += '<td data-title="brandstatus" class="12">2.5</td>'
                    results += '<td data-title="brandstatus" class="13">' + parseFloat(cgstamt).toFixed(2) + '</td>'
                    results += '<td data-title="brandstatus" class="14">0</td>'
                    results += '<td data-title="brandstatus" class="15">0</td>'
                    var totalamt = parseFloat(taxamount) + parseFloat(sgstamt) + parseFloat(cgstamt);
                    var grandtotal = 0;
                    grandtotal += totalamt;
                    taxablegrandtotal += grandtotal;
                    grandtotal1 += grandtotal;
                    tot_amount1 += totalamt;
                    results += '<td data-title="brandstatus" class="16">' + parseFloat(totalamt).toFixed(2) + '</td></tr>'
                }
                else {
                    totamount += diswithamount;
                    var edamount = 0;
                    edamount = (diswithamount * ed) / 100 || 0;
                    toted += edamount
                    var pf_amount = 0;
                    pf_amount = (diswithamount * pf) / 100 || 0;
                    totpf += pf_amount;
                    var tot_amount = 0;
                    tot_amount = diswithamount + edamount + pf_amount;
                    tot_amount1 += tot_amount;
                    var cst = 0;
                    cst = (tot_amount * tax) / 100 || 0;
                    totcst += cst;
                    var grandtotal = 0;
                    grandtotal = tot_amount + cst + transcharge + amountfright;
                    results += '</tr>'
                    grandtotal1 += grandtotal;
                }
                j++;
                amountfright = 0;
                transcharge = 0;
            }
            if (toted != 0) {
                document.getElementById('spn_ed').innerHTML = parseFloat(toted).toFixed(2);
                $('#lbled').show();
                toted = 0;
            }
            else {
                $('#lbled').hide();
                document.getElementById('spn_ed').innerHTML = "";
            }
            if (totpf != 0) {
                document.getElementById('SspanP&f').innerHTML = parseFloat(totpf).toFixed(2); ;
                $('#lblpf').show();
                totpf = 0;
            }
            else {
                $('#lblpf').hide();
                document.getElementById('SspanP&f').innerHTML = "";
            }
            if (totcst != 0) {
                document.getElementById('spn_cst').innerHTML = parseFloat(totcst).toFixed(2); ;
                totcst = 0;
                if (taxid == 1) {
                    document.getElementById('spntaxheading').innerHTML = "CST 2% against Form C1";
                    $('#spntaxheading').show();
                }
                if (taxid == 3) {
                    document.getElementById('spntaxheading').innerHTML = "Inclusive against Form C";
                    $('#spntaxheading').show();
                }
                if (taxid == 4) {
                    document.getElementById('spntaxheading').innerHTML = "vat 5%";
                    $('#spntaxheading').show();
                }
                if (taxid == 5) {
                    document.getElementById('spntaxheading').innerHTML = "vat  14.5%";
                    $('#spntaxheading').show();
                }
                if (taxid == 7) {
                    document.getElementById('spntaxheading').innerHTML = "Vat 5.5%";
                    $('#spntaxheading').show();
                }
                if (taxid == 8) {
                    document.getElementById('spntaxheading').innerHTML = "Service Tax 15%";
                    $('#spntaxheading').show();
                }
                if (taxid == 9) {
                    document.getElementById('spntaxheading').innerHTML = "Input CST @2%";
                    $('#spntaxheading').show();
                }
                if (taxid == 10) {
                    document.getElementById('spntaxheading').innerHTML = "Input CST @5%";
                    $('#spntaxheading').show();
                }
                if (taxid == 11) {
                    document.getElementById('spntaxheading').innerHTML = "Input VAT @0%";
                    $('#spntaxheading').show();
                }
                if (taxid == 12) {
                    document.getElementById('spntaxheading').innerHTML = "Input VAT @14.5%";
                    $('#spntaxheading').show();
                }
                if (taxid == 13) {
                    document.getElementById('spntaxheading').innerHTML = "Input VAT @5%";
                    $('#spntaxheading').show();
                }
                if (taxid == 14) {
                    document.getElementById('spntaxheading').innerHTML = "Taxes Inclusive";
                    $('#spntaxheading').show();
                }
                if (taxid == 15) {
                    document.getElementById('spntaxheading').innerHTML = "CST 6%";
                    $('#spntaxheading').show();
                }
            }
            else {
                $('#spntaxheading').hide();
                document.getElementById('spn_cst').innerHTML = "";
            }
            if (amountfright1 != 0) {
                document.getElementById('spn_fright_amount').innerHTML = parseFloat(amountfright1).toFixed(2);
                $('#lblfright').show();
            }
            else {
                $('#lblfright').hide();
                document.getElementById('spn_fright_amount').innerHTML = "";
            }
            if (transcharge1 != 0) {
                document.getElementById('spn_transcharge').innerHTML = parseFloat(transcharge1).toFixed(2);
                $('#lbltransport').show();
            }
            else {
                $('#lbltransport').hide();
                document.getElementById('spn_transcharge').innerHTML = "";
            }
            document.getElementById('spn_grandtotal').innerHTML = parseFloat(grandtotal1).toFixed(2); ;
            document.getElementById('spn_Total').innerHTML = parseFloat(tot_amount1).toFixed(2);
            grandtotal1 = 0;
            tot_amount1 = 0;
            var t2 = "Total";
            results += '<tr><th scope="row" class="1" style="text-align:center;"></th>';
            results += '<td data-title="brandstatus" class="2"></td>';
            results += '<td data-title="brandstatus" class="3"></td>';
            results += '<td data-title="brandstatus" class="4"></td>';
            results += '<td data-title="brandstatus" class="5"></td>';
            results += '<td data-title="brandstatus" class="5"></td>';
            results += '<td data-title="brandstatus" class="5"></td>';
            results += '<td data-title="brandstatus" class="5"></td>';
            results += '<td data-title="brandstatus"  class="6">' + t2 + '</td>';
            results += '<td data-title="brandstatus" class="7"><span id="totalcls"></span></td>';
            results += '<td data-title="brandstatus"  class="6"></td>';
            results += '<td data-title="brandstatus"  class="6"></td>';
            results += '<td data-title="brandstatus"  class="6"></td>';
            results += '<td data-title="brandstatus"  class="6"></td>';
            results += '<td data-title="brandstatus"  class="6"></td>';
            results += '<td data-title="brandstatus"  class="6"></td>';
            results += '<td data-title="brandstatus"  class="6"><span id="totalgstcls"></span></td></tr>';
            results += '</table></div>';
            $("#div_itemdetails").html(results);
            // GetTotalCal();
            if (pd > jd) {
                document.getElementById('totalcls').innerHTML = parseFloat(taxabletotalamount).toFixed(2);
                document.getElementById('totalgstcls').innerHTML = parseFloat(taxablegrandtotal).toFixed(2);
            }
            else {
                document.getElementById('totalcls').innerHTML = parseFloat(totamount).toFixed(2);
            }
            totamount = 0;
            taxabletotalamount = 0;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Purchase Order Report<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Reports</a></li>
            <li><a href="#">Purchase Order Report</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Purchase Order Report
                </h3>
            </div>
            <div class="box-body">
                <div runat="server" id="d">
                    <table>
                        <tr>
                            <td>
                                <label>
                                    From Date:</label>
                            </td>
                            <td>
                                <input type="date" id="txtfromdate" class="form-control" />
                            </td>
                            <td>
                                <label>
                                    To Date:</label>
                            </td>
                            <td>
                                <input type="date" id="txttodate" class="form-control" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td>
                                <input id="btn_save" type="button" class="btn btn-primary" name="submit" value='Get Details'
                                    onclick="btnPODetails_click()" />
                            </td>
                        </tr>
                    </table>
                    <div id="divPOdata" style="height: 300px; overflow-y: scroll;">
                    </div>
                </div>
                <div>
                </div>
              <div id="divPrint" style="display: none;">
                <div id="divrowcnt" style="height:1040px;">
                    <div style="width: 13%; float: right;">
                        <img src="Images/Vyshnavilogo.png" alt="Vyshnavi" width="100px" height="72px" />
                        <br />
                    </div>
                    <div>
                        <div style="font-family: Arial; font-size: 14pt; font-weight: bold; color: Black;">
                            <span>Sri Vyshnavi Dairy Specialities (P) Ltd </span>
                            <br />
                        </div>
                        <div style="width:33%;">
                        <span id="spnAddress" style="font-size: 14px;"></span>
                        </div>
                       <%-- R.S.No:381/2,Punabaka village Post<br />
                        Pellakuru Mandal,Nellore District -524129.,
                        <br />
                        ANDRAPRADESH (State)<br />
                        Phone: 9440622077, Fax: 044 – 26177799,<br />
                        TIN NO: 37921042267. --%>
                    </div>
                    <div align="center" style="border-bottom: 1px solid gray; border-top: 1px solid gray;">
                        <span style="font-size: 18px; font-weight: bold;">PURCHASE ORDER </span>
                    </div>
                    <div style="width: 100%;">
                        <label style="font-size: 16px"><b>
                            To,</b></label>
                        <table style="width: 100%;">
                            <tr>
                                <td style="width: 49%; float: left;">
                                    <span style="font-weight:bold;font-size:16px;" id="spnvendorname"></span>
                                    <br />
                                    <label style="font-size: 16px;"><b>
                                        Address :</b></label>
                                    <span id="spnaddress" style="font-size: 14px;"></span>
                                    <br />
                                    <label style="font-size: 16px;"><b>
                                        Tin no :</b></label>
                                    <span id="spantin" style="font-size: 14px;"></span>
                                    <br />
                                    <label style="font-size: 16px;"><b>
                                        Telephone no :</b></label>
                                    <span id="lblvendorphoneno" style="font-size: 14px;"></span>
                                    <br />
                                    <label style="font-size: 16px;"><b>
                                        Email Id :</b></label>
                                    <span id="lblvendoremail" style="font-size: 14px;"></span>
                                    <br />
                                </td>
                                <td style="width: 49%; float: right;">
                                    <label style="font-size: 16px;"><b>
                                        PO. No. :</b></label>
                                    <span id="spnpono" style="font-size: 14px;"></span>
                                    <br />
                                    <label style="font-size: 16px;"><b>
                                        Ref NO :</b></label>
                                    <span id="spnreferenceno" style="font-size: 14px;"></span>
                                    <br />
                                    <label style="font-size: 16px;"><b>
                                        PO Date :</b></label>
                                    <span id="spnpodate" style="font-size: 14px;"></span>
                                    <br />
                                    <label style="font-size: 16px;"><b>
                                        Quotation No. :</b></label>
                                    <span id="spnquotationno" style="font-size: 14px;"></span>
                                    <br />
                                    <label style="font-size: 16px;"><b>
                                        Quotation Date :</b></label>
                                    <span id="spnquotationdate" style="font-size: 14px;"></span>
                                    <br />
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div style="text-align: center; border-top: 1px solid gray;">
                        <label style="font-size: 16px;"><b>
                            Kind Attn :</b></label>
                        <span id="spancontactname"></span>
                        <br />
                    </div>
                    <label style="font-size: 16px;"><b>
                        Dear Sir/Madam,</b>
                    </label>
                    <div style="text-align: center;">
                        We here by are placing the following order on you:
                    </div>
                    <div id="div_itemdetails">
                    </div>
                    <div>
                        <table class="table table-bordered table-hover dataTable no-footer" style="width: 100%;">
                            <tr>
                                <td>
                                </td>
                                <td>
                                </td>
                                <td>
                                </td>
                                <td>
                                </td>
                                <td>
                                </td>
                                <td>
                                    <label style="font-size: 16px;" id="lblpf"><b>
                                        P&f:</b></label>
                                </td>
                                <td>
                                    <span id="SspanP&f"></span>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 15%;">
                                </td>
                                <td style="width: 15%;">
                                </td>
                                <td style="width: 15%;">
                                </td>
                                <td style="width: 15%;">
                                </td>
                                <td style="width: 15%;">
                                </td>
                                <td style="width: 15%;">
                                    <label style="font-size: 16px;" id="lbled"><b>
                                        ED:</b></label>
                                </td>
                                <td style="width: 15%;">
                                    <span id="spn_ed"></span>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                </td>
                                <td>
                                </td>
                                <td>
                                </td>
                                <td>
                                </td>
                                <td>
                                </td>
                                <td>
                                    <label style="font-size: 16px;"><b>
                                        Total:</b></label>
                                </td>
                                <td>
                                    <span id="spn_Total"></span>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                </td>
                                <td>
                                </td>
                                <td>
                                </td>
                                <td>
                                </td>
                                <td>
                                </td>
                                <td>
                                    <label style="font-size: 16px;" id="lblfright"><b>
                                        Fright Amount:</b></label>
                                </td>
                                <td>
                                    <span id="spn_fright_amount"></span>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                </td>
                                <td>
                                </td>
                                <td>
                                </td>
                                <td>
                                </td>
                                <td>
                                </td>
                                <td>
                                    <label style="font-size: 16px;" id="lbltransport"><b>
                                        Transport Charge:</b></label>
                                </td>
                                <td>
                                    <span id="spn_transcharge"></span>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                </td>
                                <td>
                                </td>
                                <td>
                                </td>
                                <td>
                                </td>
                                <td>
                                </td>
                                <td>
                                    <span id="spntaxheading" style="font-weight: bold;font-size: 16px;"></span>
                                      
                                </td>
                                <td>
                                    <span id="spn_cst" style="font-weight: bold;font-size: 16px;"></span>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                </td>
                                <td>
                                </td>
                                <td>
                                </td>
                                <td>
                                </td>
                                <td>
                                </td>
                                <td>
                                    <label style="font-size: 16px;"><b>
                                        Grand Total:</b></label>
                                </td>
                                <td>
                                    <span id="spn_grandtotal"></span>
                                </td>
                            </tr>
                        </table>
                    </div>
                    </div>
                  <br />
                  <br />
                   <label>Terms and Conditions:-</label> 
                  <br /> <br />
                        <label style="font-size: 16px;"><b>
                            1.Price Basis :</b></label>
                        <span id="spanpricebasis"></span>
                        <br />
                         <br />
                        <label style="font-size: 16px;"><b>
                            2. DelivaryTerms :</b></label>
                        <span id="spanterms"></span>
                        <br />   <br />
                        <%-- <label>
                                     2.Tax  :</label>
                                    <span id="spanTax"> YES</span>
                                    <br />--%>
                        <label style="font-size: 16px;"><b>
                            3.Insurence :</b></label>
                        <span id="spaninsurence"></span>
                        <br />   <br />
                        <label style="font-size: 16px;"><b>
                            4.Payment :</b></label>
                        <span id="spanpayment"></span>
                        <br />   <br />
                        <label style="font-size: 16px;"><b>
                            5.warranty/ Guarantee :</b></label>
                        <span id="spanwarranty"></span>
                        <br />   <br />
                        <label style="font-size: 16px;"><b>
                            6.DelivaryAddress :</b></label>
                        <span id="spanDelivaryAddress"></span>
                        <br />   <br />
                        <label style="font-size: 16px;"><b>
                            7.BillingAddress :</b></label>
                        <span id="spanBillingAddress"></span>
                        <br />   <br />
                        <label style="font-size: 16px;"><b>
                            8.Remarks :</b></label>
                        <span id="spnremarks"></span>
                        <br />   <br />
                   
                    9. Any Other Terms :AS PER SPECIFICATION MATERIAL REQUIRED,<br />   <br />
                    10. Goods should be delivered to our factory between 9.00 am to 5.00 pm at our Plant<br />   <br />
                    11. Pl. ship / send the material in locked vehicles/containers/ railcars & it<br />   <br />
                    should be sealed with Security Seals. Also, kindly ensure that, the vehicle should
                    be cleaned before loading.<br />   <br />
                    12. Each Carton / Bag should be properly labeled indicating Cartons/ Bags Number
                    & Date,Item, Size,Quantity & Challan Number etc.<br />   <br />
                    13.Goods not conforming to our specifications & standards or to samples approved
                    will be rejected. Also, in case of required item consume Energy, then the final
                    payment will be released on the basis of it’s Energy Performance OR that item will
                    be rejected.<br />   <br />
                    14. Pl. quote this Purchase Order No. on all your Challans and Bills for the supply.<br />   <br />
                                        <br /> <br /><br />
                    <table style="width: 100%;">
                        <tr>
                            <td style="width: 25%;">
                                <span style="font-weight: bold; font-size: 16px;">MANAGER(Stores&Purchase)</span>
                            </td>
                            <td style="width: 25%;">
                                <span style="font-weight: bold; font-size: 16px;">GENERAL MANAGER</span>
                            </td>
                            <td style="width: 25%;">
                                <span style="font-weight: bold; font-size: 16px;">DIRECTOR</span>
                            </td>
                        </tr>
                    </table>
                </div>
                <input id="Button2" type="button" class="btn btn-primary" name="submit" style="display:none;" value='Print'
                    onclick="javascript:CallPrint('divPrint');" />
                <asp:Label ID="lblmsg" runat="server" Font-Size="20px" ForeColor="Red" Text=""></asp:Label>
            </div>
            </div>
    </section>
</asp:Content>

