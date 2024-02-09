<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true"
    CodeFile="POReport.aspx.cs" Inherits="POReport" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        th
        {
            text-align: center;
        }
    </style>
    <script type="text/javascript">
        function CallPrint(strid) {
            document.getElementById("tbl_po_print").style.borderCollapse = "collapse";
            var divToPrint = document.getElementById(strid);
            var newWin = window.open('', 'Print-Window', 'width=500,height=400,top=100,left=100');
            newWin.document.open();
            newWin.document.write('<html><body onload="window.print()">' + divToPrint.innerHTML + '</body></html>');
            newWin.document.close();
        }
    </script>
    <script type="text/javascript">
        $(function () {
            var date = new Date();
            var day = date.getDate();
            var month = date.getMonth() + 1;
            var year = date.getFullYear();
            if (month < 10) month = "0" + month;
            if (day < 10) day = "0" + day;
            today = year + "-" + month + "-" + day;
            $('#txtfromdate').val(today);
            $('#txttodate').val(today);

            var refdcno1 = '<%=Session["POSno"] %>';
            if (refdcno1 != "") {
                printclick(refdcno1);
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

            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col"></th><th scope="col">Ref No</th><th scope="col">PO Number</th><th scope="col">Name</th><th scope="col">Po Date</th><th scope="col">Deivery Date</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].branchid == "1") {
                    document.getElementById('spncmpname').innerHTML = "Sri Vyshnavi Dairy (P) Ltd";
                    document.getElementById('spncmpname2').innerHTML = "Sri Vyshnavi Dairy (P) Ltd";
                }
                else {
                    document.getElementById('spncmpname').innerHTML = "Sri Vyshnavi Dairy Specialities (P) Ltd";
                    document.getElementById('spncmpname2').innerHTML = "Sri Vyshnavi Dairy Specialities (P) Ltd";
                }
                results += '<tr>';//<td><input id="btn_Print" type="button" onclick="printclick(this);" name="Edit" class="btn btn-primary" value="Print" /></td>
                results += '<td data-title="brandstatus"><button type="button" title="Click Here To Print!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 printcls"  onclick="printclick(this)"><span class="glyphicon glyphicon-print" style="top: 0px !important;"></span></button></td>';
                results += '<td scope="row" class="1"  style="text-align:center;">' + msg[i].sno + '</td>';
                results += '<td data-title="brandstatus" class="2">' + msg[i].ponumber + '</td>';
                results += '<td data-title="brandstatus" class="2">' + msg[i].name + '</td>';
                results += '<td data-title="brandstatus" class="2">' + msg[i].podate + '</td>';
                results += '<td data-title="brandstatus" class="2">' + msg[i].delivarydate + '</td></tr>';
                
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

                        document.getElementById('spnvendorname').innerHTML = po_details[0].name;
                        document.getElementById('lblvendorphoneno').innerHTML = po_details[0].mobile;
                        document.getElementById('spnaddress').innerHTML = po_details[0].address;
                        document.getElementById('spnpono').innerHTML = Pono;
                        document.getElementById('spnreferenceno').innerHTML = po_details[0].pono;
                        document.getElementById('lblvendoremail').innerHTML = po_details[0].email;
                        document.getElementById('lbl_sup_state').innerHTML = po_details[0].supplierstate;
                        document.getElementById('spnpodate').innerHTML = po_details[0].podate;
                        document.getElementById('spantin').innerHTML = po_details[0].suppliergstin;
                        document.getElementById('spn_gstin').innerHTML = "GSTIN :" + po_details[0].session_gstin;
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
                        document.getElementById('spn_rev_chrg').innerHTML = po_details[0].rev_chrg;
                        var rev_chrg = po_details[0].rev_chrg;
                        document.getElementById('spnbranchname').innerHTML = po_details[0].branchname;
                        document.getElementById('spnbranchaddress').innerHTML = po_details[0].branchaddress;
                        document.getElementById('spnbranchphone').innerHTML = po_details[0].branchphone;
                        document.getElementById('spnbranchemail').innerHTML = po_details[0].branchemail;
                        document.getElementById('spnbranchgstin').innerHTML = po_details[0].branchgstin;
                        document.getElementById('spnbranchstate').innerHTML = po_details[0].branchstate;

                        fill_sub_Po_details_gst(po_sub_details,rev_chrg);
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
        var taxid = "";
        var amountfright1 = 0; var totcst = 0; var ed = 0; var tax = 0; var pf = 0; var disamt = 0; var totamount = 0; var toted = 0; var tot_amount1 = 0; var grandtotal1 = 0; var totpf = 0;
        function fill_sub_Po_details(msg) {
            var results = '<div><table class="table table-bordered table-hover dataTable no-footer" border="2" style="width:100%;">';
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
                taxid = msg[i].taxtype;
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

                document.getElementById('spntaxheading').innerHTML = taxid;
                $('#spntaxheading').show();

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
            var grandtotalamount = parseFloat(grandtotal1);
            var grand_total = grandtotalamount.toFixed(2);
            //var grandtotal1 = total_po_amount.toFixed(2);
            var diff = 0;
            if (grandtotalamount > grand_total) {
                diff = grandtotalamount - grand_total;
            }
            else {
                diff = grand_total - grandtotalamount;
            }
            document.getElementById('spn_totalpoamt').innerHTML = parseFloat(grandtotalamount).toFixed(2);
            document.getElementById('spn_roundoffamt').innerHTML = parseFloat(diff).toFixed(2);
            document.getElementById('spn_grandtotal').innerHTML = parseFloat(grandtotal1).toFixed(2);
            document.getElementById('spn_grandtotal_words').innerHTML = inWords(parseInt(grand_total));
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
            results += '<td data-title="brandstatus"  class="6">' + t2 + '</td>';
            results += '<td data-title="brandstatus" class="7"><span id="totalcls"></span></td></tr>';
            results += '</table></div>';
            $("#div_itemdetails").html(results);
            // GetTotalCal();
            document.getElementById('totalcls').innerHTML = parseFloat(totamount).toFixed(2);
            totamount = 0;
        }

        function fill_sub_Po_details_gst(msg, rev_chrg) {
            var rev_chrg = rev_chrg;
            var gst_exists = msg[0].gst_exists;
            if (gst_exists == "1") {
                var transcharge = 0, gst = 0, sgst_per = 0, sgst_amt = 0, cgst_per = 0, cgst_amt = 0, igst_per = 0, igst_amt = 0, tot_sgst = 0, tot_cgst = 0, tot_igst = 0;
                var total_amount = 0;
                var results = '<div><table id = "tbl_po_print" class="table table-bordered table-hover dataTable no-footer" border="2" style="width:100%;">';
                results += '<thead><tr style="background: antiquewhite;"><th value="#" colspan="1" style="font-size: 12px;" rowspan="2">Sno</th><th value="Item Code" style="font-size: 12px;" colspan="1" rowspan="2">Item Code</th><th style="font-size: 12px;" value="Item Name" colspan="1" rowspan="2">Item Name</th><th style="font-size: 12px;" value="Item Description" colspan="1" rowspan="2">Item Description</th><th style="font-size: 12px;" value="HSN CODE" colspan="1" rowspan="2">HSN CODE</th><th value="UOM" style="font-size: 12px;" colspan="1" rowspan="2">UOM</th><th value="Qty" style="font-size: 12px;" colspan="1" rowspan="2">Qty</th><th value="Rate/Item (Rs.)" style="font-size: 12px;" colspan="1" rowspan="2">Rate/Item (Rs.)</th><th value="Discount (Rs.)" style="font-size: 12px;" colspan="1" rowspan="2">Discount (Rs.)</th><th value="Taxable Value" style="font-size: 12px;" colspan="1" rowspan="2">Taxable Value</th><th value="CGST" style="font-size: 12px;" colspan="2" rowspan="1">SGST</th><th value="SGST" colspan="2" style="font-size: 12px;" rowspan="1">CGST</th><th value="IGST" style="font-size: 12px;" colspan="2" rowspan="1">IGST</th><th value="Taxable Value" style="font-size: 12px; width:10% !important;" colspan="1" rowspan="2">Total Amount</th></tr><tr style="background: antiquewhite;"><th value="%" style="font-size: 12px;" colspan="1" rowspan="1">%</th><th style="font-size: 12px;" value="Amt (Rs.)" colspan="1" rowspan="1">Amt (Rs.)</th><th value="%" style="font-size: 12px;" colspan="1" rowspan="1">%</th><th style="font-size: 12px;" value="Amt (Rs.)" colspan="1" rowspan="1">Amt (Rs.)</th><th value="%" style="font-size: 12px;" colspan="1" rowspan="1">%</th><th value="Amt (Rs.)" colspan="1" rowspan="1" style="font-size: 12px;">Amt (Rs.)</th></tr></thead>';
                var j = 1;
                if (msg.length >= 10) {
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
                    //if (rev_chrg == "Y") {
                    tot_amt = tot_amount + igst_amt + sgst_amt + cgst_amt;
                    //                    }
                    //                    else if (rev_chrg == "N") {
                    //                    tot_amt = tot_amount + igst_amt;
                    //                    } else {tot_amt = tot_amount + igst_amt; }
                    total_amount += tot_amt;

                    results += '<tr><th scope="row" class="1" style = "font-size: 11px;">' + j + '</th>';
                    results += '<td style = "font-size: 11px;">' + msg[i].code + '</td>';
                    results += '<td style = "font-size: 11px;">' + msg[i].description + '</td>';
                    results += '<td style = "font-size: 11px;">' + msg[i].productdescription + '</td>';
                    results += '<td style = "font-size: 11px;">' + msg[i].hsn_code + '</td>';
                    results += '<td style = "font-size: 11px;">' + msg[i].uim + '</td>';
                    results += '<td style = "font-size: 11px;">' + qty + '</td>';
                    results += '<td style = "font-size: 11px;">' + parseFloat(cost).toFixed(2) + '</td>'; //<i class="fa fa-fw fa-rupee"></i>&nbsp;
                    results += '<td style = "font-size: 11px;">' + parseFloat(disamt).toFixed(2) + '</td>';
                    results += '<td style = "font-size: 11px;"><div style="float:right;padding-right:30%;">' + parseFloat(tot_amount).toFixed(2) + '</div></td>'; //<i class="fa fa-fw fa-rupee"></i>&nbsp;
                    results += '<td style = "font-size: 11px;">' + sgst_per + '</td>';
                    results += '<td style = "font-size: 11px;">' + sgst_amt.toFixed(2) + '</td>';
                    results += '<td style = "font-size: 11px;">' + cgst_per + '</td>';
                    results += '<td style = "font-size: 11px;">' + cgst_amt.toFixed(2) + '</td>';
                    results += '<td style = "font-size: 11px;">' + igst_per + '</td>';
                    results += '<td style = "font-size: 11px;">' + igst_amt.toFixed(2) + '</td>';
                    results += '<td style = "font-size: 11px;"><div style="float:right;">' + tot_amt.toFixed(2) + '</div></td></tr>';
                    j++;


                    totamount += diswithamount;
                    var grandtotal = 0;
                    //                    if (rev_chrg == "Y") {
                    grandtotal = tot_amount + igst_amt + transcharge + amountfright + sgst_amt + cgst_amt;
                    //                    }
                    //                    else if (rev_chrg == "N") {
                    //                        grandtotal = tot_amount  + igst_amt + transcharge + amountfright;
                    //                    } else {grandtotal = tot_amount + igst_amt + transcharge + amountfright; }
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
                var grandtotal2 = parseFloat(grandtotal1);
                var grandtotal = grandtotal2.toFixed(2);
                var diff = 0;
                if (grandtotal2 > grandtotal1) {
                    diff = grandtotal2 - grandtotal1;
                }
                else {
                    diff = grandtotal1 - grandtotal2;
                }
                document.getElementById('spn_totalpoamt').innerHTML = parseFloat(grandtotal2).toFixed(2);
                document.getElementById('spn_roundoffamt').innerHTML = parseFloat(diff).toFixed(2);
                document.getElementById('spn_grandtotal').innerHTML = parseFloat(grandtotal).toFixed(2);
                var grand_total = parseFloat(grandtotal1).toFixed(2);
                document.getElementById('spn_grandtotal_words').innerHTML = inWords(parseInt(grand_total));
                grandtotal1 = 0;

                //          
                var t2 = "Total";
                results += '<tr>';
                results += '<td style = "font-size: 12px;text-align:center;background: antiquewhite;" colspan="9"><label>' + t2 + '</label></td>';
                results += '<td style = "font-size: 12px;"><div style="float:right;padding-right:20%;"><label><span id="totalcls"></span></label></div></td>'; //<i class="fa fa-fw fa-rupee"></i>&nbsp;
                results += '<td colspan="2" style="text-align:center;font-size: 12px;"><label>' + tot_sgst.toFixed(2) + '</label></td>';
                results += '<td colspan="2" style="text-align:center;font-size: 12px;"><label>' + tot_cgst.toFixed(2) + '</label></td>';
                results += '<td colspan="2" style="text-align:center;font-size: 12px;"><label>' + tot_igst.toFixed(2) + '</label></td>';
                results += '<td style="font-size: 12px;"><label><div style="float:right;padding-right:20%;">' + total_amount.toFixed(2) + '</div></label></td>';
                results += '</tr></table></div>';
                $("#div_itemdetails").html(results);
                document.getElementById('totalcls').innerHTML = parseFloat(tot_amount1).toFixed(2); //parseFloat(totamount).toFixed(2);
                totamount = 0;
                tot_amount1 = 0;
            }
            else {
                fill_sub_Po_details(msg);
            }
        }

        var a = ['', 'one ', 'two ', 'three ', 'four ', 'five ', 'six ', 'seven ', 'eight ', 'nine ', 'ten ', 'eleven ', 'twelve ', 'thirteen ', 'fourteen ', 'fifteen ', 'sixteen ', 'seventeen ', 'eighteen ', 'nineteen '];
        var b = ['', '', 'twenty', 'thirty', 'forty', 'fifty', 'sixty', 'seventy', 'eighty', 'ninety'];

        function inWords(num) {
            if ((num = num.toString()).length > 9) return 'overflow';
            n = ('000000000' + num).substr(-9).match(/^(\d{2})(\d{2})(\d{2})(\d{1})(\d{2})$/);
            if (!n) return; var str = '';
            str += (n[1] != 0) ? (a[Number(n[1])] || b[n[1][0]] + ' ' + a[n[1][1]]) + 'crore ' : '';
            str += (n[2] != 0) ? (a[Number(n[2])] || b[n[2][0]] + ' ' + a[n[2][1]]) + 'lakh ' : '';
            str += (n[3] != 0) ? (a[Number(n[3])] || b[n[3][0]] + ' ' + a[n[3][1]]) + 'thousand ' : '';
            str += (n[4] != 0) ? (a[Number(n[4])] || b[n[4][0]] + ' ' + a[n[4][1]]) + 'hundred ' : '';
            str += (n[5] != 0) ? ((str != '') ? 'and ' : '') + (a[Number(n[5])] || b[n[5][0]] + ' ' + a[n[5][1]]) + 'only ' : '';
            return str;
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
                <div id="divrowcnt" style="border: 2px solid gray; height:1020px;">
                    <div style="width: 17%; float: right; padding-top:5px;">
                        <img src="Images/Vyshnavilogo.png" alt="Vyshnavi" width="100px" height="72px" />
                        <br />
                    </div>
                    <div style="border: 1px solid gray; height:10%;">
                        <div style="font-family: Arial; font-size: 22px; font-weight: bold; color: Black;text-align: center;">
                            <span id="spncmpname">Sri Vyshnavi Dairy Specialities (P) Ltd </span>
                            <br />
                        </div>
                        <div style="width:68%;text-align: center;padding-left: 8%;">
                        <span id="spnAddress" style="font-size: 12px;"></span>
                        <br />
                        <span id="spn_gstin" style="font-size: 12px;"></span>
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
                                          From </b></label>
                            </td>
                            <td style="text-align:center;"></td>
                        </tr>
                            <tr>
                                <td style="width: 49%;  padding-left:2%; border:2px solid gray;">

                                <div style="font-family: Arial; font-size: 12px; font-weight: bold; color: Black;">
                            <span id="spncmpname2">Sri Vyshnavi Dairy Specialities (P) Ltd </span>
                            <br />
                        </div>
                                    <span style="font-size: 12px;font-weight:bold;" id="spnbranchname"></span>
                                    <br />
                                    <label style="font-size: 13px;"><b>
                                        Address :</b></label>
                                    <span id="spnbranchaddress" style="font-size: 12px;"></span>
                                    <br />
                                    <label style="font-size: 13px;"><b>
                                        GSTIN :</b></label>
                                    <span id="spnbranchgstin" style="font-size: 12px;"></span>
                                    <br />
                                    <label style="font-size: 13px;"><b>
                                        Telephone no :</b></label>
                                    <span id="spnbranchphone" style="font-size: 12px;"></span>
                                    <br />
                                    <label style="font-size: 13px;"><b>
                                        Email Id :</b></label>
                                    <span id="spnbranchemail" style="font-size: 12px;"></span>
                                    <br />
                                    <label style="font-size: 13px;"><b>State :</b></label>
                                    <span id="spnbranchstate" style="font-size: 12px;"></span>
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
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label style="font-size: 13px;"><b>
                                              To </b></label>
                                </td>
                                <td style="text-align:center;"></td>
                            </tr>
                            <tr>
                                <td style="width: 49%;  padding-left:2%; border:2px solid gray;">
                                    <span style="font-size: 12px;font-weight:bold;" id="spnvendorname"></span>
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
                                        Quotation No. :</b></label>
                                    <span id="spnquotationno" style="font-size: 12px;"></span>
                                    <br />
                                    <label style="font-size: 13px;"><b>
                                        Quotation Date :</b></label>
                                    <span id="spnquotationdate" style="font-size: 12px;"></span>
                                    <br />
                                    <label style="font-size: 13px;font-weight: bold;">Reverse Charge:</label>
                                    <span id="spn_rev_chrg" style="font-size: 12px;"></span>
                                    <br />
                                </td>
                            </tr>
                        </table>
                    </div>
                   <div style="text-align: center; border-top: 1px solid gray;">
                        <label style="font-size: 13px;"><b>
                            Kind Attn :</b></label>
                        <span id="spancontactname"></span>
                        <br />
                    </div>
                    <label style="font-size: 13px;display:none;"><b>
                        Dear Sir/Madam,</b>
                    </label>
                    <div  style="border-bottom: 1px solid gray;text-align: center;">
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
                                <td colspan="2">
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
                                <td style="width: 15%;" colspan="2">
                                    <label style="font-size: 13px;" id="lblfright"><b>
                                        Freight Amount:</b></label>
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
                                <td colspan="2">
                                    <label style="font-size: 13px;" id="lbltransport"><b>
                                        Transport Charge:</b></label>
                                </td>
                                <td>
                                    <span id="spn_transcharge" style="font-size: 12px;"></span>
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
                                    <span id="spntaxheading" style="font-size: 13px;font-weight: bold;"></span>
                                      
                                </td>
                                <td>
                                    <span id="spn_cst" style="font-size: 12px;font-weight: bold;"></span>
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
                                <td colspan="2">
                                    <label style="font-size: 13px;"><b>
                                        TOTAL PO AMOUNT :</b></label>
                                </td>
                                <td>
                                    <span id="spn_totalpoamt" style="font-size: 12px;"></span>
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
                                <td colspan="2">
                                    <label style="font-size: 13px;"><b>
                                        Round off Diff Amount :</b></label>
                                </td>
                                <td>
                                    <span id="spn_roundoffamt" style="font-size: 12px;"></span>
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
                                <td colspan="2">
                                    <label style="font-size: 13px;"><b>
                                        GRAND TOTAL:</b></label>
                                </td>
                                <td>
                                    <span id="spn_grandtotal" style="font-size: 12px;"></span>
                                </td>
                            </tr>
                        </table>
                    </div>
                    Rupees in Words :&nbsp;<span id="spn_grandtotal_words" style="font-size: 12px;"></span>
                    </div>
                  <br />
                  <br />
                  <br />
                  <br />
                  <br />
                  <br />
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
                            2. Delivery Terms :</b></label>
                        <span id="spanterms" style="font-size: 12px;"></span>
                        <br />   <br />
                        <label style="font-size: 13px;"><b>
                            3.Insurance :</b></label>
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
                            6.Delivery Address :</b></label>
                        <span id="spanDelivaryAddress" style="font-size: 12px;"></span>
                        <br />   <br />
                        <label style="font-size: 13px;"><b>
                            7.Billing Address :</b></label>
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
                                <span style="font-weight: bold; font-size: 14px;">PREPARED BY</span>
                            </td>
                            <td style="width: 25%;">
                                <span style="font-weight: bold; font-size: 14px;">MANAGER</span>
                            </td>
                            <td style="width: 25%;">
                                <span style="font-weight: bold; font-size: 14px;">DIRECTOR</span>
                            </td>
                        </tr>
                    </table>
                </div>
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
