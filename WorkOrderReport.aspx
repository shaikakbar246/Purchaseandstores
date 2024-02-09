<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true" CodeFile="WorkOrderReport.aspx.cs" Inherits="WorkOrderReport" %>
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
        function btn_Purchase_order_click1() {
            var refdcno = document.getElementById('txt_refdcno').value
            var refdcno1 = '<%=Session["POSno"] %>';
            var data = { 'op': 'get_purchase_order_details_click', 'refdcno': refdcno, 'refdcno1': refdcno1 };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        $('#divPrint').css('display', 'block');
                        var workorder = msg[0].workorderdetails;
                        var subworkorder = msg[0].subworkorderdetails;
                        amountfright = parseFloat(workorder[0].freigntamt);
                        amountvat = parseFloat(workorder[0].vatamount);
                        vatamount = parseFloat(workorder[0].vatamount);
                        document.getElementById('spnvendorname').innerHTML = workorder[0].name;
                        document.getElementById('lblvendorphoneno').innerHTML = workorder[0].mobile;
                        document.getElementById('spnaddress').innerHTML = workorder[0].address;
                        document.getElementById('spnpono').innerHTML = "SVDS/PBK/00" + workorder[0].ponumber;
                        document.getElementById('spnreferenceno').innerHTML = workorder[0].pono;
                        document.getElementById('lblvendoremail').innerHTML = workorder[0].email;
                        document.getElementById('spnpodate').innerHTML = workorder[0].podate;
                        document.getElementById('spantin').innerHTML = workorder[0].vattin;
                        document.getElementById('spnquotationno').innerHTML = workorder[0].quotationno;
                        document.getElementById('spnquotationdate').innerHTML = workorder[0].quotationdate;
                        document.getElementById('spanDelivaryAddress').innerHTML = workorder[0].deliveryaddress;
                        document.getElementById('spanBillingAddress').innerHTML = workorder[0].billingaddress;
                        document.getElementById('spanterms').innerHTML = workorder[0].terms;
                        document.getElementById('spancontactname').innerHTML = workorder[0].contactnumber;
                        var ins = workorder[0].insurence;
                        if (ins == "YES") {
                            document.getElementById('spaninsurence').innerHTML = workorder[0].insuranceamount;
                        }
                        else {
                            document.getElementById('spaninsurence').innerHTML = workorder[0].insurence;
                        }
                        document.getElementById('spanpayment').innerHTML = workorder[0].payment;
                        var warranty = workorder[0].warranytype;
                        if (warranty == "YES") {
                            document.getElementById('spanwarranty').innerHTML = workorder[0].warranty;
                        }
                        else {
                            document.getElementById('spaninsurence').innerHTML = workorder[0].warranytype;
                        }
                        document.getElementById('spnremarks').innerHTML = workorder[0].SupplierRemarks;
                        document.getElementById('spanpricebasis').innerHTML = workorder[0].pricebasis;
                        fillsubworkorder(subworkorder);

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
        function btnWorkOrderDetails_click() {
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
            var data = { 'op': 'get_workOrder_click', 'fromdate': fromdate, 'todate': todate };
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
            var status = "P";
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col"></th><th scope="col">Ref No</th><th scope="col">WO. No</th><th scope="col">Supplier Name</th><th scope="col">WO Date</th><th scope="col">Deivery Date</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                if (status == msg[i].status) {
                    results += '<tr>';
                    results += '<td data-title="brandstatus"><button type="button" title="Click Here To Print!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 printcls"  onclick="printclick(this)"><span class="glyphicon glyphicon-print" style="top: 0px !important;"></span></button></td>';
                    results += '<td scope="row" class="1"  style="text-align:center;">' + msg[i].sno + '</td>';
                    results += '<td data-title="brandstatus" class="2">' + msg[i].ponumber + '</td>';
                    results += '<td data-title="brandstatus" class="2">' + msg[i].name + '</td>';
                    results += '<td data-title="brandstatus" class="2">' + msg[i].podate + '</td>';
                    results += '<td data-title="brandstatus" class="2">' + msg[i].delivarydate + '</td></tr>';
                }
            }
            results += '</table></div>';
            $("#divPOdata").html(results);
        }
        var amountfri = 0; var amountvat = 0; var vatamount = 0; var amountfright = 0;
        function printclick(thisid) {
             var refdcno = $(thisid).parent().parent().children('.1').html();
            var refdcno1 = '<%=Session["POSno"] %>';
            var data = { 'op': 'get_Sub_workOrder_click', 'refdcno': refdcno, 'refdcno1': refdcno1 };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        $('#divPrint').css('display', 'block');
                        $('#Button2').css('display', 'block');
                        var workorder = msg[0].workorderdetails;
                        var subworkorder = msg[0].subworkorderdetails;
                        if (workorder.length > 0) {
                            amountfright = parseFloat(workorder[0].freigntamt);
                            amountvat = parseFloat(workorder[0].vatamount);
                            vatamount = parseFloat(workorder[0].vatamount);
                            document.getElementById('spnvendorname').innerHTML = workorder[0].name;
                            document.getElementById('lblvendorphoneno').innerHTML = workorder[0].mobile;
                            document.getElementById('spnaddress').innerHTML = workorder[0].address;
                            document.getElementById('spnpono').innerHTML = "SVDS/PBK/00" + workorder[0].ponumber;
                            document.getElementById('spnreferenceno').innerHTML = workorder[0].pono;
                            document.getElementById('lblvendoremail').innerHTML = workorder[0].email;
                            document.getElementById('spnpodate').innerHTML = workorder[0].podate;
                            document.getElementById('spantin').innerHTML = workorder[0].sup_gstin;
                            document.getElementById('spnquotationno').innerHTML = workorder[0].quotationno;
                            document.getElementById('spnquotationdate').innerHTML = workorder[0].quotationdate;
                            document.getElementById('spanDelivaryAddress').innerHTML = workorder[0].deliveryaddress;
                            document.getElementById('spanBillingAddress').innerHTML = workorder[0].billingaddress;
                            document.getElementById('spanterms').innerHTML = workorder[0].terms;
                            document.getElementById('spancontactname').innerHTML = workorder[0].contactnumber;
                            var ins = workorder[0].insurence;
                            if (ins == "YES") {
                                document.getElementById('spaninsurence').innerHTML = workorder[0].insuranceamount;
                            }
                            else {
                                document.getElementById('spaninsurence').innerHTML = workorder[0].insurence;
                            }
                            document.getElementById('spanpayment').innerHTML = workorder[0].payment;
                            var warranty = workorder[0].warranytype;
                            if (warranty == "YES") {
                                document.getElementById('spanwarranty').innerHTML = workorder[0].warranty;
                            }
                            else {
                                document.getElementById('spaninsurence').innerHTML = workorder[0].warranytype;
                            }
                            document.getElementById('spnremarks').innerHTML = workorder[0].SupplierRemarks;
                            document.getElementById('spanpricebasis').innerHTML = workorder[0].pricebasis;
                            document.getElementById('spn_branch_address').innerHTML = workorder[0].branch_address;
                            document.getElementById('spn_gstin').innerHTML = "GSTIN :" + workorder[0].branch_gstin;
                            document.getElementById('lbl_sup_state').innerHTML = workorder[0].sup_statename;
                            document.getElementById('spnbranchname').innerHTML = workorder[0].branchname;
                            document.getElementById('spnbranchaddress').innerHTML = workorder[0].branch_address;
                            document.getElementById('spnbranchgstin').innerHTML = workorder[0].branch_gstin;
                            document.getElementById('spnbranchphone').innerHTML = workorder[0].branch_phone;
                            document.getElementById('spnbranchemail').innerHTML = workorder[0].branch_emailid;
                            document.getElementById('spnbranchstate').innerHTML = workorder[0].branch_statename;
                            fillsubworkorder_gst(subworkorder);
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
        var gst_exists = "";
        function fillsubworkorder_gst(msg) {
            gst_exists = msg[0].gst_exists;
            if (gst_exists == "1") {
                var results = '<div ><table class="table table-bordered table-hover dataTable no-footer" border="2" style="width:100%;">';
                results += '<thead><tr style="background: antiquewhite;"><th value="#" colspan="1" style="font-size: 12px;" rowspan="2">Sno</th><th value="Item Code" style="font-size: 12px;" colspan="1" rowspan="2">Item Code</th><th style="font-size: 12px;" value="Item Name" colspan="1" rowspan="2">Item Name</th><th style="font-size: 12px;" value="Services" colspan="1" rowspan="2">Services</th><th style="font-size: 12px;" value="HSN CODE" colspan="1" rowspan="2">HSN CODE</th><th value="UOM" style="font-size: 12px;" colspan="1" rowspan="2">UOM</th><th value="Qty" style="font-size: 12px;" colspan="1" rowspan="2">Qty</th><th value="Rate/Item (Rs.)" style="font-size: 12px;" colspan="1" rowspan="2">Rate/Item (Rs.)</th><th value="Discount (Rs.)" style="font-size: 12px;" colspan="1" rowspan="2">Discount (Rs.)</th><th value="Taxable Value" style="font-size: 12px;" colspan="1" rowspan="2">Taxable Value</th><th value="CGST" style="font-size: 12px;" colspan="2" rowspan="1">SGST</th><th value="SGST" colspan="2" style="font-size: 12px;" rowspan="1">CGST</th><th value="IGST" style="font-size: 12px;" colspan="2" rowspan="1">IGST</th><th value="Taxable Value" style="font-size: 12px;" colspan="1" rowspan="2">Total Amount</th></tr><tr style="background: antiquewhite;"><th value="%" style="font-size: 12px;" colspan="1" rowspan="1">%</th><th style="font-size: 12px;" value="Amt (Rs.)" colspan="1" rowspan="1">Amt (Rs.)</th><th value="%" style="font-size: 12px;" colspan="1" rowspan="1">%</th><th style="font-size: 12px;" value="Amt (Rs.)" colspan="1" rowspan="1">Amt (Rs.)</th><th value="%" style="font-size: 12px;" colspan="1" rowspan="1">%</th><th value="Amt (Rs.)" colspan="1" rowspan="1" style="font-size: 12px;">Amt (Rs.)</th></tr></thead>';
                var j = 1;
                var total_sgst = 0, total_cgst = 0, total_igst = 0, total_taxable = 0, total_amt = 0;
                for (var i = 0; i < msg.length; i++) {
                    var qty = 0;
                    qty = parseFloat(msg[i].qty);
                    var cost = 0;
                    cost = parseFloat(msg[i].cost);
                    var amt = 0; var amount = 0; var amount1 = 0; var igstamt = 0; var sgstamt = 0; var cgstamt = 0; var pfamt = 0; var taxable = 0;
                    var prod_amt = 0;
                    amt = qty * cost;
                    amount1 = parseFloat(amt).toFixed(2);
                    disamt = parseFloat(msg[i].disamt);
                    amount = amount1 - disamt;
                    pf = parseFloat(msg[i].pfamount);
                    pfamt = (pf * amount) / 100;
                    taxable = amount + pfamt;
                    total_taxable += taxable;
                    var sgst = parseFloat(msg[i].sgst) || 0;
                    sgstamt = (taxable * sgst) / 100;
                    total_sgst += sgstamt;
                    var cgst = parseFloat(msg[i].cgst) || 0;
                    cgstamt = (taxable * cgst) / 100;
                    total_cgst += cgstamt;
                    var igst = parseFloat(msg[i].igst) || 0;
                    igstamt = (taxable * igst) / 100;
                    total_igst += igstamt;
                    prod_amt = taxable + sgstamt + cgstamt + igstamt;
                    total_amt += prod_amt;

                    results += '<tr><th scope="row" class="1" style="text-align:center;">' + j + '</th>';
                    results += '<td data-title="brandstatus" style = "font-size: 11px;" class="2">' + msg[i].code + '</td>';
                    results += '<td data-title="brandstatus" style = "font-size: 11px;" class="8">' + msg[i].description + '</td>';
                    results += '<td data-title="brandstatus" style = "font-size: 11px;" class="8">' + msg[i].services + '</td>';
                    results += '<td data-title="brandstatus" style = "font-size: 11px;" class="8">' + msg[i].hsncode + '</td>';
                    results += '<td data-title="brandstatus" style = "font-size: 11px;" class="9">' + msg[i].uim + '</td>';
                    results += '<td data-title="brandstatus" style = "font-size: 11px;" class="3">' + qty + '</td>';
                    results += '<td data-title="brandstatus" style = "font-size: 11px;" class="4">' + parseFloat(cost).toFixed(2) + '</td>';
                    results += '<td data-title="brandstatus" style = "font-size: 11px;" class="4">' + parseFloat(disamt).toFixed(2) + '</td>';
                    results += '<td data-title="brandstatus" style = "font-size: 11px;" class="4">' + parseFloat(taxable).toFixed(2) + '</td>';
                    results += '<td data-title="brandstatus" style = "font-size: 11px;" class="3">' + sgst + '</td>';
                    results += '<td data-title="brandstatus" style = "font-size: 11px;" class="3">' + parseFloat(sgstamt).toFixed(2) + '</td>';
                    results += '<td data-title="brandstatus" style = "font-size: 11px;" class="3">' + cgst + '</td>';
                    results += '<td data-title="brandstatus" style = "font-size: 11px;" class="3">' + parseFloat(cgstamt).toFixed(2) + '</td>';
                    results += '<td data-title="brandstatus" style = "font-size: 11px;" class="3">' + igst + '</td>';
                    results += '<td data-title="brandstatus" style = "font-size: 11px;" class="3">' + parseFloat(igstamt).toFixed(2) + '</td>';
                    results += '<td data-title="brandstatus" style = "font-size: 11px;" class="tammountcls">' + parseFloat(prod_amt).toFixed(2) + '</td></tr>'
                    j++;
                }
                var t2 = "Total";
                results += '<tr><th scope="row" class="1" colspan="9" style="text-align:center;font-size: 12px;background: antiquewhite;">' + t2 + '</th>';
                results += '<td data-title="brandstatus" style="text-align:center;font-size: 12px;" class="2">' + total_taxable + '</td>';
                results += '<td data-title="brandstatus" style="text-align:center;font-size: 12px;" colspan="2" class="3">' + total_sgst + '</td>';
                results += '<td data-title="brandstatus" style="text-align:center;font-size: 12px;" colspan="2" class="4">' + total_cgst + '</td>';
                results += '<td data-title="brandstatus" style="text-align:center;font-size: 12px;" colspan="2" class="5">' + total_igst + '</td>';
                results += '<td data-title="brandstatus" style="text-align:center;font-size: 12px;" class="7"><span id="totalcls"></span></td></tr>';
                results += '</table></div>';
                $("#div_itemdetails").html(results);
                GetTotalCal();
            }
            else {
                //fillsubworkorder(msg)
            }
        }
        function GetTotalCal() {
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
            var pf_amount = 0;
            pf_amount = (totamount * pf) / 100 || 0;
            if (pf_amount != 0) {
                document.getElementById('SspanP&f').innerHTML = parseFloat(pf_amount).toFixed(2);;
                $('#lblpf').show();
            }
            else {
                $('#lblpf').hide();
                document.getElementById('SspanP&f').innerHTML = "";
            }
            var tot_amount = 0;
            var grandtotal = 0;

            $('#lbled').hide();
            document.getElementById('spn_ed').innerHTML = "";
            $('#lblcst').hide();
            document.getElementById('spn_cst').innerHTML = "";
            $('#lbl_total').hide();
            grandtotal = totamount + amountfright;

            //tot_amount = totamount + edamount + pf_amount;

            if (amountfright != 0) {
                document.getElementById('spn_fright_amount').innerHTML = parseFloat(amountfright).toFixed(2);
                $('#lblfright').show();
            }
            else {
                $('#lblfright').hide();
                document.getElementById('spn_fright_amount').innerHTML = "";
            }

            //grandtotal = tot_amount + amountfright + cst;
            document.getElementById('spnwototalamt').innerHTML = parseFloat(grandtotal).toFixed(2);
            var grandtotal1 = parseFloat(grandtotal).toFixed(0);
            var diff = grandtotal1 - grandtotal;
            document.getElementById('spnroundoff').innerHTML = parseFloat(diff).toFixed(2);
            document.getElementById('spn_grandtotal').innerHTML = grandtotal1;
            document.getElementById('recevied').innerHTML = inWords(parseInt(grandtotal1));
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Work Order Report<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Reports</a></li>
            <li><a href="#">Work Order Report</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Work Order Report
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
                                        <span class="glyphicon glyphicon-flash" onclick="btnWorkOrderDetails_click();"></span> <span id="btn_save" onclick="btnWorkOrderDetails_click();">Get Details</span>
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
                <div style="height:1040px;">
                    <div style="width: 13%; float: right;">
                        <img src="Images/Vyshnavilogo.png" alt="Vyshnavi" width="100px" height="72px" />
                        <br />
                    </div>
                    <div>
                        <div style="font-family: Arial; font-size: 22px; font-weight: bold; color: Black;text-align: center;">
                            <span>Sri Vyshnavi Dairy Specialities (P) Ltd </span>
                            <br />
                        </div>
                        <%--R.S.No:381/2,Punabaka village Post<br />
                        Pellakuru Mandal,Nellore District -524129.,
                        <br />
                        ANDRAPRADESH (State)<br />
                        Phone: 9440622077, Fax: 044 – 26177799,<br />
                        TIN NO: 37921042267. --%>
                        <div style="width:68%;text-align: center;padding-left: 17%;">
                        <span id="spn_branch_address" style="font-size: 12px;"></span>
                        <br />
                        <span id="spn_gstin" style="font-size: 12px;"></span>
                        </div>
                        <div style="width:40%;">
                        <span id="spnstate" style="font-size: 12px; display:none;"></span>
                        </div>
                    </div>
                    <div align="center" style="border-bottom: 1px solid gray; border-top: 1px solid gray;background-color: antiquewhite;">
                        <span style="font-size: 18px; font-weight: bold;">Work Order</span>
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
                                        WO. No. :</b></label>
                                    <span id="spnpono" style="font-size: 12px;"></span>
                                    <br />
                                    <label style="font-size: 13px;"><b>
                                        Ref NO :</b></label>
                                    <span id="spnreferenceno" style="font-size: 12px;"></span>
                                    <br />
                                    <label style="font-size: 13px;"><b>
                                        WO Date :</b></label>
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
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div style="text-align: center; border-top: 1px solid gray;">
                        <label style="font-size: 16px;font-weight: bold;">
                            Kind Attn :</label>
                        <span id="spancontactname"></span>
                        <br />
                    </div>
                    <label style="font-size: 16px;font-weight: bold;">
                        Dear Sir/Madam,
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
                                    <label style="font-size: 16px;font-weight: bold;" id="lblpf">
                                        P&f:</label>
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
                                    <label style="font-size: 16px;font-weight: bold;" id="lbled">
                                        ED:</label>
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
                                    <label id="lbl_total" style="font-size: 16px;font-weight: bold;">
                                        Total:</label>
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
                                    <label style="font-size: 16px;font-weight: bold;" id="lblfright">
                                        Fright Amount:</label>
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
                                    <label style="font-size: 16px;font-weight: bold;" id="lblcst">
                                        CST:</label>
                                </td>
                                <td>
                                    <span id="spn_cst"></span>
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
                                    <label style="font-size: 16px;font-weight: bold;">
                                        Total Amount :</label>
                                </td>
                                <td>
                                    <span id="spnwototalamt"></span>
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
                                    <label style="font-size: 16px;font-weight: bold;">
                                        Round Off Diff Amount :</label>
                                </td>
                                <td>
                                    <span id="spnroundoff"></span>
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
                                    <label style="font-size: 16px;font-weight: bold;">
                                        Grand Total:</label>
                                </td>
                                <td>
                                    <span id="spn_grandtotal"></span>
                                </td>
                            </tr>
                        </table>
                         <table style="width: 100%;">
                          <tr>
                                <td style="width: 49%; float: left;">
                                    <label style="font-size: 16px;font-weight: bold;">
                                        Received:
                                             </label><label>Rs.</label>
                                    <span id="recevied" onclick="test.rnum.value = toWords(test.inum.value);" value="To Words" class="spanrpt"></span>
                                </td>
                            </tr>
                    </table>
                    </div>
                    </div>
                   <label style="font-size: 18px;">Terms and Conditions:-</label> 
                  <br /> <br />
                        <label style="font-size: 16px;font-weight: bold;">
                            1.Price Basis :</label>
                        <span id="spanpricebasis"></span>
                        <br />
                         <br />
                        <label style="font-size: 16px;font-weight: bold;">
                            2. DelivaryTerms :</label>
                        <span id="spanterms"></span>
                        <br />   <br />
                        <label style="font-size: 16px;font-weight: bold;">
                            3.Insurence :</label>
                        <span id="spaninsurence"></span>
                        <br />   <br />
                        <label style="font-size: 16px;font-weight: bold;">
                            4.Payment :</label>
                        <span id="spanpayment"></span>
                        <br />   <br />
                        <label style="font-size: 16px;font-weight: bold;">
                            5.warranty/ Guarantee :</label>
                        <span id="spanwarranty"></span>
                        <br />   <br />
                        <label style="font-size: 16px;font-weight: bold;">
                            6.DelivaryAddress :</label>
                        <span id="spanDelivaryAddress"></span>
                        <br />   <br />
                        <label style="font-size: 16px;font-weight: bold;">
                            7.BillingAddress :</label>
                        <span id="spanBillingAddress"></span>
                        <br />   <br />
                        <label style="font-size: 16px;font-weight: bold;">
                            8.Remarks :</label>
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

