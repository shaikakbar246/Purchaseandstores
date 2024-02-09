<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true" CodeFile="taxinvoice.aspx.cs" Inherits="taxinvoice" %>

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
            document.getElementById("tbl_po_print").style.borderCollapse = "collapse";
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
                        var branch = popo_details[0].branchid;
                        //if (branch == "2")
                        //{
                        document.getElementById('spnpono').innerHTML = "SVDS/PBK/00" + po_details[0].ponumber;
                        //}
                        //else if (branch == "4")
                        //{
                        //    document.getElementById('spnpono').innerHTML = "SVDS/CHN/00" + po_details[0].ponumber;
                        //}
                        //else if (branch == "35")
                        //{
                        //    document.getElementById('spnpono').innerHTML = "SVDS/MNPK/00" + po_details[0].ponumber;
                        //}
                        //else if (branch == "1040") {
                        //    document.getElementById('spnpono').innerHTML = "SVDS/KPM/00" + po_details[0].ponumber;
                        //}
                        //else {
                        //    document.getElementById('spnpono').innerHTML = "SVDS/00" + po_details[0].ponumber;
                        //}
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
                results += '<tr>'; //<td><input id="btn_Print" type="button" onclick="printclick(this);" name="Edit" class="btn btn-primary" value="Print" /></td>
                results += '<td data-title="brandstatus"><button type="button" title="Click Here To Print!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 printcls"  onclick="printclick(this)"><span class="glyphicon glyphicon-print" style="top: 0px !important;"></span></button></td>';
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
        var amountfri = 0; var amountvat = 0; var vatamount = 0; var amountfright = 0; var newXarray = [];
        function printclick(thisid) {
            var refdcno = $(thisid).parent().parent().children('.1').html();
            var Pono = $(thisid).parent().parent().children('.2').html();
            var refdcno1 = '<%=Session["POSno"] %>';
            var data = { 'op': 'get_purchase_order_details_click', 'refdcno': refdcno, 'refdcno1': refdcno1 };
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
                        document.getElementById('lbl_sup_state').innerHTML = po_details[0].supplierstate;
                        document.getElementById('spnpodate').innerHTML = po_details[0].podate;
                        document.getElementById('spantin').innerHTML = po_details[0].suppliergstin;
                        //                        var add = po_details[0].Address;
                        //                         newXarray = add.split(',');
                        ////                       for (var i = 0; i < newXarray.length; i++) {
                        ////                              var br1 + = newXarray.split(',');
                        ////                         break;
                        ////                        }
                        document.getElementById('spnAddress').innerHTML = po_details[0].Add_ress;
                        document.getElementById('spnstate').innerHTML = po_details[0].fromstate;
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

                        //var podate = po_details[0].podate;
                        //var todaydate = podate.split('/');
                        //var date = "2017-07-01".split('-');
                        //var firstDate = new Date();
                        //firstDate.setFullYear(todaydate[2], (todaydate[1] - 1), todaydate[0]);
                        //var secondDate = new Date();
                        //secondDate.setFullYear(date[0], (date[1] - 1), date[2]);
                        //if (secondDate < firstDate) {
                        //    fill_sub_Po_details(po_sub_details);
                        //}
                        //else {
                        //    fill_sub_Po_details_gst(po_sub_details);
                        //}
                        fill_sub_Po_details_gst(po_sub_details);
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
        var amountfright1 = 0; var totcst = 0; var ed = 0; var tax = 0; var pf = 0; var disamt = 0; var totamount = 0; var toted = 0; var tot_amount1 = 0; var grandtotal1 = 0; var totpf = 0;
        function fill_sub_Po_details(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" border="2" style="width:100%;">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Item Code</th><th scope="col">Item Name</th><th scope="col">Item Description</th><th scope="col">UOM</th><th scope="col">Qty</th><th scope="col">Rate</th><th scope="col">Discount</th><th scope="col">Amount</th></tr></thead></tbody>';
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
                results += '<td data-title="brandstatus" class="8">' + msg[i].productdescription + '</td>';
                results += '<td data-title="brandstatus" class="9">' + msg[i].uim + '</td>';
                results += '<td data-title="brandstatus" class="3">' + qty + '</td>';
                results += '<td data-title="brandstatus" class="4">' + parseFloat(cost).toFixed(2) + '</td>'; //LEFT OUTER JOIN branchmaster ON inwarddetails.branchid=branchmaster.branchid
                results += '<td data-title="brandstatus" class="4">' + parseFloat(disamt).toFixed(2) + '</td>';
                results += '<td data-title="brandstatus" class="tammountcls">' + parseFloat(amount).toFixed(2) + '</td></tr>'
                j++;


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
                grandtotal1 += grandtotal;
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
            //          
            var t2 = "Total";
            results += '<tr><th scope="row" class="1" style="text-align:center;"></th>';
            results += '<td data-title="brandstatus" class="2"></td>';
            results += '<td data-title="brandstatus" class="3"></td>';
            results += '<td data-title="brandstatus" class="4"></td>';
            results += '<td data-title="brandstatus" class="5"></td>';
            results += '<td data-title="brandstatus" class="5"></td>';
            results += '<td data-title="brandstatus" class="5"></td>';
            results += '<td data-title="brandstatus"  class="6">' + t2 + '</td>';
            results += '<td data-title="brandstatus" class="7"><span id="totalcls"></span></td></tr>';
            results += '</table></div>';
            $("#div_itemdetails").html(results);
            // GetTotalCal();
            document.getElementById('totalcls').innerHTML = parseFloat(totamount).toFixed(2);
            totamount = 0;
        }

        function fill_sub_Po_details_gst(msg) {
            var transcharge = 0, gst = 0, sgst_per = 0, sgst_amt = 0, cgst_per = 0, cgst_amt = 0, igst_per = 0, igst_amt = 0, tot_sgst = 0, tot_cgst = 0, tot_igst = 0;
            var total_amount = 0;
            var results = '<div><table id = "tbl_po_print" class="table table-bordered table-hover dataTable no-footer" border="2" style="width:100%;">';
            //results += '<thead><tr><th rowspan="2">Sno</th><th rowspan="2">Item Code</th><th rowspan="2">Item Name</th><th rowspan="2">HSN CODE</th><th rowspan="2">UOM</th><th rowspan="2">Qty</th><th rowspan="2">Rate</th><th rowspan="2">Discount</th><th rowspan="2">Taxable Amount</th><th scope="col" colspan="2">SGST</th><th scope="col" colspan="2">CGST</th><th scope="col" colspan="2">IGST</th><th scope="col">Total Amount</th></tr></thead></tbody>';
            //results += '<thead><tr><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th scope="col">%</th><th scope="col">Amount</th><th scope="col">%</th><th scope="col">Amount</th><th scope="col">%</th><th scope="col">Amount</th><th></th></tr></thead></tbody>';
            results += '<thead><tr style="background: antiquewhite;"><th value="#" colspan="1" style = "font-size: 12px;" rowspan="2">Sno</th><th value="Item Code" style = "font-size: 12px;" colspan="1" rowspan="2">Item Code</th><th style = "font-size: 12px;" value="Item Name" colspan="1" rowspan="2">Item Description</th><th style = "font-size: 12px;" value="HSN CODE" colspan="1" rowspan="2">HSN CODE</th><th value="UOM" style = "font-size: 12px;" colspan="1" rowspan="2">UOM</th><th value="Qty" style = "font-size: 12px;" colspan="1" rowspan="2">Qty</th><th value="Rate/Item (Rs.)" style = "font-size: 12px;" colspan="1" rowspan="2">Rate/Item (Rs.)</th><th value="Discount (Rs.)" style = "font-size: 12px;" colspan="1" rowspan="2">Discount (Rs.)</th><th value="Taxable Value" style = "font-size: 12px;" colspan="1" rowspan="2">Taxable Value</th><th value="CGST" style = "font-size: 12px;" colspan="2" rowspan="1">SGST</th><th value="SGST" colspan="2" style = "font-size: 12px;" rowspan="1">CGST</th><th value="IGST" style = "font-size: 12px;" colspan="2" rowspan="1">IGST</th><th value="Taxable Value" style = "font-size: 12px;" colspan="1" rowspan="2">Total Amount</th></tr><tr style="background: antiquewhite;"><th value="%" style = "font-size: 12px;" colspan="1" rowspan="1">%</th><th style = "font-size: 12px;" value="Amt (Rs.)" colspan="1" rowspan="1">Amt (Rs.)</th><th value="%" style = "font-size: 12px;" colspan="1" rowspan="1">%</th><th style = "font-size: 12px;" value="Amt (Rs.)" colspan="1" rowspan="1">Amt (Rs.)</th><th value="%" style = "font-size: 12px;" colspan="1" rowspan="1">%</th><th value="Amt (Rs.)" colspan="1" rowspan="1" style = "font-size: 12px;">Amt (Rs.)</th></tr></thead>';
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
                disamt = parseFloat(msg[i].disamt).toFixed(2);
                diswithamount = amt - disamt;
                amount = parseFloat(diswithamount).toFixed(2);
                sgst_per = parseFloat(msg[i].sgst_per);
                cgst_per = parseFloat(msg[i].cgst_per);
                igst_per = parseFloat(msg[i].igst_per);

                pf = parseFloat(msg[i].pfamount);

                if (j == 1) {
                    amountfright = parseFloat(msg[i].freigntamt);
                    amountfright1 = amountfright;
                    transcharge = parseFloat(msg[i].transcharge) || 0;
                    transcharge1 = transcharge;
                }

                var pf_amount = 0;
                pf_amount = (diswithamount * pf) / 100 || 0;
                totpf += pf_amount;

                var tot_amount = 0;
                tot_amount = diswithamount + pf_amount;
                tot_amount1 += tot_amount;

                sgst_amt = (tot_amount * sgst_per) / 100 || 0;
                tot_sgst += sgst_amt;
                cgst_amt = (tot_amount * cgst_per) / 100 || 0;
                tot_cgst += cgst_amt;
                igst_amt = (tot_amount * igst_per) / 100 || 0;
                tot_igst += igst_amt;
                gst += (sgst_amt + cgst_amt + igst_amt);

                var tot_amt = 0;
                tot_amt = tot_amount + sgst_amt + cgst_amt + igst_amt;
                total_amount += tot_amt;

                results += '<tr><th scope="row" class="1" style = "font-size: 11px;">' + j + '</th>';
                results += '<td style = "font-size: 11px;">' + msg[i].code + '</td>';
                results += '<td style = "font-size: 11px;">' + msg[i].description + '</td>';
                results += '<td style = "font-size: 11px;">' + msg[i].hsn_code + '</td>';
                results += '<td style = "font-size: 11px;">' + msg[i].uim + '</td>';
                results += '<td style = "font-size: 11px;">' + qty + '</td>';
                results += '<td style = "font-size: 11px;">' + parseFloat(cost).toFixed(2) + '</td>'; //<i class="fa fa-fw fa-rupee"></i>&nbsp;
                results += '<td style = "font-size: 11px;">' + parseFloat(disamt).toFixed(2) + '</td>';
                results += '<td style = "font-size: 11px;">' + parseFloat(tot_amount).toFixed(2) + '</td>'; //<i class="fa fa-fw fa-rupee"></i>&nbsp;
                results += '<td style = "font-size: 11px;">' + sgst_per + '</td>';
                results += '<td style = "font-size: 11px;">' + sgst_amt.toFixed(2) + '</td>';
                results += '<td style = "font-size: 11px;">' + cgst_per + '</td>';
                results += '<td style = "font-size: 11px;">' + cgst_amt.toFixed(2) + '</td>';
                results += '<td style = "font-size: 11px;">' + igst_per + '</td>';
                results += '<td style = "font-size: 11px;">' + igst_amt.toFixed(2) + '</td>';
                results += '<td style = "font-size: 11px;">' + tot_amt.toFixed(2) + '</td></tr>';
                j++;


                totamount += diswithamount;
                var grandtotal = 0;
                grandtotal = tot_amount + sgst_amt + cgst_amt + igst_amt + transcharge + amountfright;
                grandtotal1 += grandtotal;
                amountfright = 0;
                transcharge = 0;

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
            $('#lblpf').hide();
            $('#lbled').hide();
            $('#lbl_total').hide();
            document.getElementById('spn_grandtotal').innerHTML = parseFloat(grandtotal1).toFixed(2); ;
            //document.getElementById('spn_Total').innerHTML = parseFloat(tot_amount1).toFixed(2);
            grandtotal1 = 0;

            //          
            var t2 = "Total";
            results += '<tr>';
            results += '<td style = "font-size: 11px;text-align:center;background: antiquewhite;" colspan="8"><label>' + t2 + '</label></td>';
            results += '<td style = "font-size: 11px;"><label><span id="totalcls"></span></label></td>'; //<i class="fa fa-fw fa-rupee"></i>&nbsp;
            results += '<td colspan="2" style="text-align:center;font-size: 11px;"><label>' + tot_sgst.toFixed(2) + '</label></td>';
            results += '<td colspan="2" style="text-align:center;font-size: 11px;"><label>' + tot_cgst.toFixed(2) + '</label></td>';
            results += '<td colspan="2" style="text-align:center;font-size: 11px;"><label>' + tot_igst.toFixed(2) + '</label></td>';
            results += '<td style="font-size: 11px;"><label>' + total_amount.toFixed(2) + '</label></td>';
            results += '</tr></table></div>';
            $("#div_itemdetails").html(results);
            // GetTotalCal();
            document.getElementById('totalcls').innerHTML = parseFloat(tot_amount1).toFixed(2); //parseFloat(totamount).toFixed(2);
            totamount = 0;
            tot_amount1 = 0;
            //$('#tbl_po_print>tr>th').css("font-size", "10px");
            //$('#tbl_po_print>tr>td').css("font-size", "9px");
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
                                <%--<input id="btn_save" type="button" class="btn btn-primary" name="submit" value='Get Details' onclick="btnPODetails_click()" />--%>
                                <div class="input-group">
                                    <div class="input-group-addon">
                                        <span class="glyphicon glyphicon-flash" onclick="btnPODetails_click();"></span> <span id="btn_save" onclick="btnPODetails_click();">Get Details</span>
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </table>
                    <div id="divPOdata" style="height: 300px; overflow-y: scroll;">
                    </div>
                </div>
                <div>
                </div>
              <div id="divPrint" style="display: none;">
                <div id="divrowcnt" style="height:1040px;border: 2px solid gray;">
                    <div style="width: 17%; float: right; padding-top:5px;">
                        <img src="Images/Vyshnavilogo.png" alt="Vyshnavi" width="100px" height="72px" />
                        <br />
                    </div>
                    <div style="border: 1px solid gray; height:8%;">
                        <div style="font-family: Arial; font-size: 20px; font-weight: bold; color: Black;text-align: center;">
                            <span>Sri Vyshnavi Dairy Specialities (P) Ltd </span>
                            <br />
                        </div>
                        <div style="width:68%;text-align: center;padding-left: 8%;">
                        <span id="spnAddress" style="font-size: 12px;"></span>
                        </div>
                        <div style="width:40%;">
                        <span id="spnstate" style="font-size: 12px; display:none;"></span>
                        </div>
                    </div>
                    <div align="center" style="border-bottom: 1px solid gray; border-top: 1px solid gray;background-color: antiquewhite;">
                        <span style="font-size: 18px; font-weight: bold;">PURCHASE ORDER </span>
                    </div>
                    
                    <div style="width: 100%;">
                        
                        <table style="width: 100%;">
                        <tr>
                        <td>
                        <label style="font-size: 13px;"><b>
                                      To </b></label>
                        </td>
                         <td style="text-align:center;">
                       
                        </td>
                        </tr>
                            <tr>
                                <td style="width: 49%;  padding-left:2%; border:2px solid gray;">
                                    <span style="font-weight:bold;font-size:12px;" id="spnvendorname"></span>
                                    <br />
                                    <label style="font-size: 13px;"><b>
                                        Address :</b></label>
                                    <span id="spnaddress" style="font-size: 12px;"></span>
                                    <br />
                                    <label style="font-size: 13px;"><b>
                                        GSTIN :</b></label>
                                    <span id="spantin" style="font-size: 12px;"></span>
                                    <br />
                                    <label style="font-size: 13px;"><b>
                                        Telephone no :</b></label>
                                    <span id="lblvendorphoneno" style="font-size: 12px;"></span>
                                    <br />
                                    <label style="font-size: 13px;"><b>
                                        Email Id :</b></label>
                                    <span id="lblvendoremail" style="font-size: 12px;"></span>
                                    <br />
                                    <label style="font-size: 13px;"><b>State :</b></label>
                                    <span id="lbl_sup_state" style="font-size: 12px;"></span>
                                </td>
                                <td style="width: 49%; border:2px solid gray;padding-left:2%;">
                                    <label style="font-size: 13px;"><b>
                                        PO. No. :</b></label>
                                    <span id="spnpono" style="font-size: 12px;"></span>
                                    <br />
                                    <label style="font-size: 13px;"><b>
                                        Ref NO :</b></label>
                                    <span id="spnreferenceno" style="font-size: 12px;"></span>
                                    <br />
                                    <label style="font-size: 13px;"><b>
                                        PO Date :</b></label>
                                    <span id="spnpodate" style="font-size: 12px;"></span>
                                    <br />
                                    <label style="font-size: 13px;"><b>
                                        Quotation No. :</b></label>
                                    <span id="spnquotationno" style="font-size: 12px;"></span>
                                    <br />
                                    <label style="font-size: 13px;"><b>
                                        Quotation Date :</b></label>
                                    <span id="spnquotationdate" style="font-size: 12px;"></span>
                                    <br />
                                </td>
                            </tr>
                        </table>
                    </div>
                   <div style="text-align: center; border-top: 1px solid gray; display:none;">
                        <label style="font-size: 13px;"><b>
                            Kind Attn :</b></label>
                        <span id="spancontactname"></span>
                        <br />
                    </div>
                    <label style="font-size: 13px;display:none;"><b>
                        Dear Sir/Madam,</b>
                    </label>
                    <div  style="border-bottom: 1px solid gray; border-top: 1px solid gray;text-align: center;">
                       <br />
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
                                    <label style="font-size: 13px;" id="lblpf"><b>
                                        P&f:</b></label>
                                </td>
                                <td>
                                    <span id="SspanP&f" style="font-size: 12px;"></span>
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
                                    <label style="font-size: 13px;" id="lbled"><b>
                                        ED:</b></label>
                                </td>
                                <td style="width: 15%;">
                                    <span id="spn_ed" style="font-size: 12px;"></span>
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
                                    <label id="lbl_total" style="font-size: 13px;"><b>
                                        Total:</b></label>
                                </td>
                                <td>
                                    <span id="spn_Total" style="font-size: 12px;"></span>
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
                                    <label style="font-size: 13px;" id="lblfright"><b>
                                        Fright Amount:</b></label>
                                </td>
                                <td style="width: 15%;">
                                    <span id="spn_fright_amount" style="font-size: 12px;"></span><%--<i id="i_freight_amount" class="fa fa-fw fa-rupee">&nbsp;</i>--%>
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
                                    <label style="font-size: 13px;" id="lbltransport"><b>
                                        Transport Charge:</b></label>
                                </td>
                                <td>
                                    <span id="spn_transcharge" style="font-size: 12px;"></span><%--<i id="i_transcharge" class="fa fa-fw fa-rupee">&nbsp;</i>--%>
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
                                    <span id="spntaxheading" style="font-weight: bold;font-size: 13px;"></span>
                                      
                                </td>
                                <td>
                                    <span id="spn_cst" style="font-weight: bold;font-size: 12px;"></span><%--<i id="i_cst" class="fa fa-fw fa-rupee">&nbsp;</i>--%>
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
                                    <label style="font-size: 13px;"><b>
                                        GRAND TOTAL:</b></label>
                                </td>
                                <td>
                                    <span id="spn_grandtotal" style="font-size: 12px;"></span><%--<i class="fa fa-fw fa-rupee">&nbsp;</i>--%>
                                </td>
                            </tr>
                        </table>

                        <table class="table table-bordered table-hover dataTable no-footer" style="width:30%;">
                        <tr>
                        <td style="padding-left: 12%; background:antiquewhite;">
                           Bank Details
                        </td>
                        </tr>
                        <tr>
                        <td>
                           Bank A/C : <span id="spnbankacno">123456789</span>
                        </td>
                       
                        </tr>
                        <tr>
                        <td>
                           Bank IFSC : <span id="Span2">123456789</span>
                        </td>
                        </tr>
                        </table>
                    </div>
                    </div>
                  <br />
                  <br />
                   <label>Terms and Conditions:-</label> 
                  <br /> <br />
                        <label style="font-size: 13px;"><b>
                            1.Price Basis :</b></label>
                        <span id="spanpricebasis" style="font-size: 12px;"></span>
                        <br />
                         <br />
                        <label style="font-size: 13px;"><b>
                            2. DelivaryTerms :</b></label>
                        <span id="spanterms" style="font-size: 12px;"></span>
                        <br />   <br />
                        <%-- <label>
                                     2.Tax  :</label>
                                    <span id="spanTax"> YES</span>
                                    <br />--%>
                        <label style="font-size: 13px;"><b>
                            3.Insurence :</b></label>
                        <span id="spaninsurence" style="font-size: 12px;"></span>
                        <br />   <br />
                        <label style="font-size: 13px;"><b>
                            4.Payment :</b></label>
                        <span id="spanpayment" style="font-size: 12px;"></span>
                        <br />   <br />
                        <label style="font-size: 13px;"><b>
                            5.warranty/ Guarantee :</b></label>
                        <span id="spanwarranty" style="font-size: 12px;"></span>
                        <br />   <br />
                        <label style="font-size: 13px;"><b>
                            6.DelivaryAddress :</b></label>
                        <span id="spanDelivaryAddress" style="font-size: 12px;"></span>
                        <br />   <br />
                        <label style="font-size: 13px;"><b>
                            7.BillingAddress :</b></label>
                        <span id="spanBillingAddress" style="font-size: 12px;"></span>
                        <br />   <br />
                        <label style="font-size: 13px;"><b>
                            8.Remarks :</b></label>
                        <span id="spnremarks" style="font-size: 12px;"></span>
                        <br />   <br />
                   <span style="font-size: 12px;">
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
                                        </span><br /> <br /><br />
                    <table style="width: 100%;">
                        <tr>
                            <td style="width: 25%;">
                                <span style="font-weight: bold; font-size: 14px;">MANAGER(Stores&Purchase)</span>
                            </td>
                            <td style="width: 25%;">
                                <span style="font-weight: bold; font-size: 14px;">GENERAL MANAGER</span>
                            </td>
                            <td style="width: 25%;">
                                <span style="font-weight: bold; font-size: 14px;">DIRECTOR</span>
                            </td>
                        </tr>
                    </table>
                </div>
                <%--<input id="Button2" type="button" class="btn btn-primary" name="submit" style="display:none;" value='Print' onclick="javascript:CallPrint('divPrint');" />--%>
                <div class="input-group" id="Button2" style="display:none;padding-right: 90%;">
                    <div class="input-group-addon">
                        <span class="glyphicon glyphicon-print" onclick="javascript: CallPrint('divPrint');"></span> <span id="Span1" onclick="javascript: CallPrint('divPrint');">Print</span>
                    </div>
                </div>
                <asp:Label ID="lblmsg" runat="server" Font-Size="20px" ForeColor="Red" Text=""></asp:Label>
            </div>
            </div>
    </section>
</asp:Content>

