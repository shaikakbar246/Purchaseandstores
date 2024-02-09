<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true"
    CodeFile="Vendor_Quotation_Report.aspx.cs" Inherits="Vendor_Quotation_Report" %>

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

        function btn_Quotation_Details_click() {
            var from_date = document.getElementById('txt_from').value;
            if (from_date == "") {
                alert("Enter From Date");
                return false;
            }
            var to_date = document.getElementById('txt_to').value;
            if (to_date == "") {
                alert("Enter To Date");
                return false;
            }
            var data = { 'op': 'get_vendor_quotation_date', 'from_date': from_date, 'to_date': to_date };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fill_quotation_det(msg);

                    }
                    else {
                        fill_quotation_det(msg);
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

        function fill_quotation_det(msg) {
            if (msg.length > 0) {
                var l = 0;
                //var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
                var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
                var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
                results += '<thead><tr style="background:#3c8dbc; color: white; font-weight: bold;"><th scope="col"></th><th scope="col">Quotation No</th><th scope="col">Quotation Date</th><th scope="col">Supplier Name</th></tr></thead></tbody>';
                for (var i = 0; i < msg.length; i++) {
                    results += '<tr style="background-color:' + COLOR[l] + '">';//<td><input id="btn_print" type="button"  onclick="printclick(this)" name="Print" class="btn btn-primary" value="Print" /></td>
                    results += '<td data-title="brandstatus"><button type="button" title="Click Here To Print!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 printcls"  onclick="printclick(this)"><span class="glyphicon glyphicon-print" style="top: 0px !important;"></span></button></td>';
                    results += '<td data-title="Quotation No" class="1" >' + msg[i].quo_no + '</td>';
                    results += '<td data-title="Quotation Date" class="2">' + msg[i].quo_dt + '</td>';
                    results += '<td data-title="Supplier Name" class="3">' + msg[i].sup_name + '</td>';
                    results += '<td style="display:none;" data-title="Supplier Name" class="4">' + msg[i].sup_id + '</td>';
                    results += '<td style="display:none;" data-title="sno" class="11">' + msg[i].sno + '</td></tr>';
                    l = l + 1;
                    if (l == 4) {
                        l = 0;
                    }
                }
                results += '</table></div>';
                $("#div_quotation_det").html(results);
            }
            else {
                msg = "NO DATA FOUND";
                results = msg.fontcolor("red");
                $("#div_quotation_det").html(results);
            }
        }
        function printclick(thisid) {
            var refdcno = $(thisid).parent().parent().children('.1').html();
            var date = new Date();
            var data = { 'op': 'get_vendor_quotation_det_click', 'refdcno': refdcno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        
                        var quo_req_det = msg[0].DataTable;
                        var quo_prod_det = msg[0].DataTable1;
                        if (quo_req_det.length != 0 && quo_prod_det.length != 0) {
                            $('#divPrint').css('display', 'block');
                            $('#Button2').css('display', 'block');

                            document.getElementById('spn_quo_no').innerHTML = quo_req_det[0].quo_no;
                            document.getElementById('spnAddress').innerHTML = quo_req_det[0].Add_ress;
                            document.getElementById('spn_sup_name').innerHTML = quo_req_det[0].sup_name;
                            document.getElementById('spn_date').innerHTML = (date.getDate() < 10 ? '0' : '') + date.getDate() + "-" + (date.getMonth() < 10 ? '0' : '') + (date.getMonth() + 1) + "-" + date.getFullYear();;

                            fill_quotation_details(quo_prod_det);
                        }
                        else {
                            alert("NO DATA FOUND");
                            return false;
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

        function fill_quotation_details(msg) {
            var results = '<div ><table class="table table-bordered table-hover dataTable no-footer" border="2" style="width:100%;">';
            results += '<thead><tr style="background: antiquewhite;"><th value="#" colspan="1" style="font-size: 12px;" rowspan="2">Sno</th><th value="Item Code" style="font-size: 12px;" colspan="1" rowspan="2">Item Code</th><th style="font-size: 12px;" value="Item Name" colspan="1" rowspan="2">Item Name</th><th style="font-size: 12px;" value="HSN CODE" colspan="1" rowspan="2">HSN CODE</th><th value="UOM" style="font-size: 12px;" colspan="1" rowspan="2">UOM</th><th value="Qty" style="font-size: 12px;" colspan="1" rowspan="2">Qty</th><th value="Rate/Item (Rs.)" style="font-size: 12px;" colspan="1" rowspan="2">Rate/Item (Rs.)</th><th value="Discount (Rs.)" style="font-size: 12px;" colspan="1" rowspan="2">Discount (Rs.)</th><th value="Taxable Value" style="font-size: 12px;" colspan="1" rowspan="2">Taxable Value</th><th value="CGST" style="font-size: 12px;" colspan="2" rowspan="1">SGST</th><th value="SGST" colspan="2" style="font-size: 12px;" rowspan="1">CGST</th><th value="IGST" style="font-size: 12px;" colspan="2" rowspan="1">IGST</th><th value="Taxable Value" style="font-size: 12px;" colspan="1" rowspan="2">Total Amount</th></tr><tr style="background: antiquewhite;"><th value="%" style="font-size: 12px;" colspan="1" rowspan="1">%</th><th style="font-size: 12px;" value="Amt (Rs.)" colspan="1" rowspan="1">Amt (Rs.)</th><th value="%" style="font-size: 12px;" colspan="1" rowspan="1">%</th><th style="font-size: 12px;" value="Amt (Rs.)" colspan="1" rowspan="1">Amt (Rs.)</th><th value="%" style="font-size: 12px;" colspan="1" rowspan="1">%</th><th value="Amt (Rs.)" colspan="1" rowspan="1" style="font-size: 12px;">Amt (Rs.)</th></tr></thead>';//<th style="font-size: 12px;" value="Item Description" colspan="1" rowspan="2">Item Description</th>
            var j = 1;
            var trans = 0, transport = 0;
            var totamount = 0; toted = 0; var tot_amount = 0; var tot_amt_tax = 0; var grandtotal = 0, total_pf = 0;
            var total_sgst = 0, total_cgst = 0, total_igst = 0;
            for (var i = 0; i < msg.length; i++) {
                var qty = 0;
                qty = parseFloat(msg[i].qty);
                var price = 0;
                price = parseFloat(msg[i].price);
                var tot_amt1 = (qty * price);
                var tot_amt = tot_amt1; //Math.round(tot_amt1, 2); //parseFloat(tot_amt1).toFixed(2);
                var dis_per = parseFloat(msg[i].dis_per);
                var dis_amt = 0;
                dis_amt = (dis_per * tot_amt) / 100;
                tot_amt = tot_amt - dis_amt;
                var pandf = parseFloat(msg[i].pandf);
                var pf_amt = (pandf * tot_amt) / 100 || 0;
                total_pf += pf_amt;
                var taxable = tot_amt + pf_amt;
                totamount += taxable;
                var sgst = parseFloat(msg[i].sgst) || 0;
                var sgstamt = (taxable * sgst) / 100;
                total_sgst += sgstamt;
                var cgst = parseFloat(msg[i].cgst) || 0;
                var cgstamt = (taxable * cgst) / 100;
                total_cgst += cgstamt;
                var igst = parseFloat(msg[i].igst) || 0;
                var igstamt = (taxable * igst) / 100;
                total_igst += igstamt;
                var tot_amount1 = taxable + sgstamt + cgstamt + igstamt;
                tot_amount += tot_amount1;
                if (j == 1) {
                    freight1 = parseFloat(msg[i].freight);
                    freight = freight1;
                    trans = parseFloat(msg[i].transport);
                    transport = trans;
                }
                results += '<tr><th scope="row" class="1" style="text-align:center;">' + (i + 1) + '</th>';
                results += '<td data-title="UOM" class="3" style="text-align:center;">' + msg[i].sku + '</td>';
                results += '<td data-title="Product Name" style="text-align:center;" class="2">' + msg[i].prod_name + '</td>';
                results += '<td data-title="UOM" class="3" style="text-align:center;">' + msg[i].hsncode + '</td>';
                results += '<td data-title="UOM" class="3" style="text-align:center;">' + msg[i].uim + '</td>';
                results += '<td data-title="Required Qty" style="text-align:center;" class="4">' + msg[i].qty + '</td>';
                results += '<td data-title="Price" style="text-align:center;" class="5">' + parseFloat(msg[i].price).toFixed(2) + '</td>';
                results += '<td data-title="Discount %" style="text-align:center;" class="6">' + dis_amt + '</td>';
                results += '<td data-title="Discount %" style="text-align:center;" class="6">' + taxable + '</td>';
                results += '<td data-title="Discount %" style="text-align:center;" class="6">' + sgst + '</td>';
                results += '<td data-title="Discount %" style="text-align:center;" class="6">' + sgstamt + '</td>';
                results += '<td data-title="Discount %" style="text-align:center;" class="6">' + cgst + '</td>';
                results += '<td data-title="Discount %" style="text-align:center;" class="6">' + cgstamt + '</td>';
                results += '<td data-title="Discount %" style="text-align:center;" class="6">' + igst + '</td>';
                results += '<td data-title="Discount %" style="text-align:center;" class="6">' + igstamt + '</td>';
                results += '<td data-title="Total Amount" style="text-align:center;" class="7">' + parseFloat(tot_amt).toFixed(2) + '</td></tr>';
                j++;

                var grandtotal1 = 0;
                grandtotal1 = tot_amount1 + freight + transport;
                grandtotal += grandtotal1;
                freight = 0;
                transport = 0;
            }

            if (total_pf != 0) {
                document.getElementById('spn_pf').innerHTML = parseFloat(total_pf).toFixed(2);
                $('#lblpf').show();
                toted = 0;
            }
            else {
                $('#lblpf').hide();
                document.getElementById('spn_pf').innerHTML = "";
            }
            
            if (freight != 0 || transport != 0) {
                if (freight != 0) {
                    document.getElementById('spn_fright_amount').innerHTML = parseFloat(freight).toFixed(2);
                }
                else {
                    document.getElementById('spn_fright_amount').innerHTML = parseFloat(transport).toFixed(2);
                }
                $('#lblfright').show();
            }
            else {
                $('#lblfright').hide();
                document.getElementById('spn_fright_amount').innerHTML = "";
            }
            document.getElementById('spn_grandtotal').innerHTML = parseFloat(grandtotal).toFixed(2); ;
            document.getElementById('spn_Total').innerHTML = parseFloat(tot_amount).toFixed(2);
            grandtotal = 0;

            tot_amount = 0;
            //          
            var t2 = "Total";
            results += '<tr><th scope="row" class="1" colspan="8" style="text-align:center;">' + t2 + '</th>';
            results += '<td data-title="brandstatus" class="2">' + totamount + '</td>';
            results += '<td data-title="brandstatus" colspan="2" class="3">' + total_sgst + '</td>';
            results += '<td data-title="brandstatus" colspan="2" class="4">' + total_cgst + '</td>';
            results += '<td data-title="brandstatus" colspan="2" class="5">' + total_igst + '</td>';
            results += '<td data-title="brandstatus" class="7"><span id="totalcls"></span></td></tr>';
            results += '</table></div>';
            $("#div_itemdetails").html(results);
            // GetTotalCal();
            document.getElementById('totalcls').innerHTML = parseFloat(tot_amount1).toFixed(2);
            tot_amount1 = 0;
            totamount = 0;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Vendor Quotation Report
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i></a></li>
            <li><a href="#">Vendor Quotation Report</a></li>
        </ol>
    </section>
    <section class="content">
            <div class="box box-info">
                <div id="div_Account">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Vendor Quotation Report
                        </h3>
                    </div>
                    <div class="box-body">
                        <div id="div_Emp">
                        </div>
                        <div id='fillform'>
                            <table align="center">
                                <tr>
                                    <th>
                                    </th>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            From Date
                                        </label>
                                    </td>
                                    <td>
                                        <input type="date" id="txt_from" class="form-control" name="from_date" />
                                    </td>
                                    <td style="width:5px;"></td>
                                    <td style="height: 40px;">
                                        <label>
                                            To Date
                                        </label>
                                    </td>
                                    <td>
                                        <input type="date" id="txt_to" class="form-control" name="to_date" />
                                    </td>
                                     <td style="width:5px;"></td>
                                    <td style="height: 40px;">
                                        <%--<input id="btn_generate" type="button" class="btn btn-primary" name="submit" value="Generate" onclick="btn_Quotation_Details_click();" />--%>
                                        <div class="input-group">
                                            <div class="input-group-addon">
                                                <span class="glyphicon glyphicon-flash" onclick="btn_Quotation_Details_click();"></span> <span id="btn_generate" onclick="btn_Quotation_Details_click();">Generate</span>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                            <div id="div_quotation_det">
                            </div>
                        </div>
                    </div>
                    <div id="divPrint" style="display: none;">
                <div >
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
                    </div>
                    <div align="center" style="border-bottom: 1px solid gray; border-top: 1px solid gray;">
                        <span style="font-size: 18px; font-weight: bold;">QUOTATION </span>
                    </div>
                    <div style="width: 100%;">
                        
                        <table style="width: 100%;">
                            <tr>

                                <td >
                                    <label style="font-size: 16px"><b>
                            Quotation No:</b></label>
                                    <span id="spn_quo_no"></span>
                                </td>
                                </tr>
                            <tr>
                                <td><label style="font-size: 16px"><b>
                            Date:</b></label><span id="spn_date"></span></td>
                                
                            </tr>
                        </table>
                    </div>
                    <div style="text-align: center; border-top: 1px solid gray;">
                        <br />
                    </div>
                    <table><tr><td><label style="font-size: 16px">
                            Mr/Mrs:</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span id="spn_sup_name" style="font-weight:bold;"></span></td></tr></table>
                    <br />
                    <label style="font-size: 16px"><b>
                        Dear Sir/Madam,</b>
                    </label>
                    <br />
                    <label style="font-size: 16px"><b>
                        Subject : Quotation,</b>
                    </label>
                    <div style="text-align: center;">
                        We here by submitting the following Quotation to you:
                    </div>
                    <div id="div_itemdetails">
                    </div>
                    <div>
                        <table class="table table-bordered table-hover dataTable no-footer" style="width: 100%;">
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
                                    <label style="font-size: 16px" id="lblpf"><b>
                                        P and F:</b></label>
                                </td>
                                <td style="width: 15%;">
                                    <span id="spn_pf"></span>
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
                                    <label style="font-size: 16px"><b>
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
                                    <label style="font-size: 16px" id="lblfright"><b>
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
                                    <label style="font-size: 16px"><b>
                                        Grand Total:</b></label>
                                </td>
                                <td>
                                    <span id="spn_grandtotal"></span>
                                </td>
                            </tr>
                        </table>
                    </div>
                  <br />   <br />
                    
                    Thanks & Regards<br />   <br />
                             <br /> <br /><br />
                    </div>
                          </div>
                <table><tr><td>
                <%--<input id="Button2" type="button" class="btn btn-primary" name="submit" style="display:none;" value='Print' onclick="javascript: CallPrint('divPrint');" />--%>
                <div class="input-group" id="Button2" style="display:none">
                    <div class="input-group-addon">
                        <span class="glyphicon glyphicon-print" onclick="javascript: CallPrint('divPrint');"></span> <span id="Span1" onclick="javascript: CallPrint('divPrint');">Print</span>
                    </div>
                </div> 
                </td></tr></table>
                </div>
            </div>
        </section>
</asp:Content>
