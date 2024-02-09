<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true"
    CodeFile="OutwardReport.aspx.cs" Inherits="OutwardReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
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
            var refdcno1 = '<%=Session["OutSno"] %>';
            if (refdcno1 != "") {
                get_Outward_Sub_details1_click();
            }
            $('#hiderefno').css('display', 'none');
            $('#Button2').css('display', 'none');
        });

        function get_Outward_Sub_details1_click() {
            var refdcno = document.getElementById('txt_refdcno').value;
            var refdcno1 = '<%=Session["OutSno"] %>';
            var data = { 'op': 'get_Outward_Sub_details_click', 'refdcno': refdcno, 'refdcno1': refdcno1 };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {

                        $('#divPrint').css('display', 'block');
                        var Indent_details = msg[0].OutwardDetails;
                        var indent_sub_details = msg[0].SubOutward;
                        document.getElementById('indentname').innerHTML = Indent_details[0].name;
                        document.getElementById('indentnumber').innerHTML = "00" + Indent_details[0].sno;
                        document.getElementById('indentdate').innerHTML = Indent_details[0].inwarddate;
                        document.getElementById('remarks').innerHTML = Indent_details[0].remarks;
                        fill_sub_indent_details(indent_sub_details);
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
        function get_outward_details_click() {
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
            var type = document.getElementById('ddlsclttype').value;
            var data = { 'op': 'get_outward_details_click', 'fromdate': fromdate, 'todate': todate, 'type': type };
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
            var status = 'A';
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col"></th><th scope="col">Ref No</th><th scope="col">Outward Date</th><th scope="col">Description</th><th scope="col">Status</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                if (status == msg[i].status) {
                    results += '<tr>';
                    results += '<td data-title="brandstatus"><button type="button" title="Click Here To Print!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 printcls"  onclick="printclick(this)"><span class="glyphicon glyphicon-print" style="top: 0px !important;"></span></button></td>';
                    results += '<td scope="row" class="1"  style="text-align:center;">' + msg[i].sno + '</td>';
                    results += '<td data-title="brandstatus" style="text-align:center;" class="2">' + msg[i].inwarddate + '</td>';
                    results += '<td data-title="brandstatus" style="text-align:center;" class="2">' + msg[i].remarks + '</td>';
                    results += '<td data-title="brandstatus" style="text-align:center;" class="2">' + msg[i].status + '</td></tr>';
                }
                else {
                    results += '<tr>';
                    results += '<td data-title="brandstatus"><button type="button" title="Click Here To Print!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 printcls"  onclick="printclick(this)"><span class="glyphicon glyphicon-print" style="top: 0px !important;"></span></button></td>';
                    results += '<td scope="row" class="1"  style="text-align:center;">' + msg[i].sno + '</td>';
                    results += '<td data-title="brandstatus" style="text-align:center;" class="2">' + msg[i].inwarddate + '</td>';
                    results += '<td data-title="brandstatus" style="text-align:center;" class="2">' + msg[i].remarks + '</td>';
                    results += '<td data-title="brandstatus" style="text-align:center;" class="2">' + msg[i].status + '</td></tr>';

                }
            }
            results += '</table></div>';
            $("#divPOdata").html(results);
        }
        function printclick(thisid) {
            var refdcno = $(thisid).parent().parent().children('.1').html();
            var refdcno1 = '<%=Session["OutSno"] %>';
            var data = { 'op': 'get_Outward_Sub_details_click', 'refdcno': refdcno, 'refdcno1': refdcno1 };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        $('#divPrint').css('display', 'block');
                        $('#Button2').css('display', 'block');
                        var Indent_details = msg[0].OutwardDetails;
                        var indent_sub_details = msg[0].SubOutward;
                        document.getElementById('indentname').innerHTML = Indent_details[0].name;
                        document.getElementById('indentnumber').innerHTML = Indent_details[0].issueno; //"00" + Indent_details[0].issueno;
                        document.getElementById('indentdate').innerHTML = Indent_details[0].inwarddate;
                        document.getElementById('remarks').innerHTML = Indent_details[0].remarks;
                        fill_sub_indent_details(indent_sub_details);
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
        function fill_sub_indent_details(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" border="2" style="width:100%;">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Product Code</th><th scope="col">Qty</th><th scope="col">UOM</th><th scope="col">Price</th><th scope="col">Amount</th></tr></thead></tbody>';
            var j = 1;
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].status == "P") {
                    var Quantity = 0;
                    Quantity = parseFloat(msg[i].quantity);
                    var price = 0;
                    price = parseFloat(msg[i].PerUnitRs).toFixed(2);
                    var amt = 0; var amount = 0;
                    amt = Quantity * price;
                    amount = parseFloat(amt).toFixed(2);
                    document.getElementById('spnheading').innerHTML = "Issue Voucher For Verification  ";
                    results += '<tr><th scope="row" class="1" style="text-align:center;">' + j + '</th>';
                    results += '<td data-title="brandstatus"  class="2">' + msg[i].productname + '</td>';
                    results += '<td data-title="brandstatus"  class="2">' + msg[i].productcode + '</td>';
                    results += '<td data-title="brandstatus"  class="qtycls">' + Quantity + '</td>';
                    results += '<td data-title="brandstatus"  class="5">' + msg[i].uim + '</td>';
                    results += '<td data-title="brandstatus"  class="4">' + price + '</td>';
                    results += '<td data-title="brandstatus" class="ammountcls">' + amount + '</td></tr>';
                    j++;
                }
                else {
                    var Quantity = 0;
                    Quantity = parseFloat(msg[i].quantity);
                    var price = 0;
                    price = parseFloat(msg[i].PerUnitRs).toFixed(2);
                    var amt = 0; var amount = 0;
                    amt = Quantity * price;
                    amount = parseFloat(amt).toFixed(2);
                    document.getElementById('spnheading').innerHTML = "Issue Voucher";
                    results += '<tr><th scope="row" class="1" style="text-align:center;">' + j + '</th>';
                    results += '<td data-title="brandstatus"  class="2">' + msg[i].productname + '</td>';
                    results += '<td data-title="brandstatus"  class="2">' + msg[i].productcode + '</td>';
                    results += '<td data-title="brandstatus"  class="qtycls">' + Quantity + '</td>';
                    results += '<td data-title="brandstatus"  class="5">' + msg[i].uim + '</td>';
                    results += '<td data-title="brandstatus"  class="4">' + price + '</td>';
                    results += '<td data-title="brandstatus" class="ammountcls">' + amount + '</td></tr>';
                    j++;
                }
            }
            var tot = "";
            var tqty = "Total"
            results += '<tr><th scope="row" class="1" style="text-align:center;"></th>';
            results += '<td data-title="brandstatus" class="5"></td>';
            results += '<td data-title="brandstatus"  class="2">' + tqty + '</td>';
            results += '<td data-title="brandstatus"  class="3"><span id="totamcls"></span></td>';
            results += '<td data-title="brandstatus"  class="6">' + tot + '</td>';
            results += '<td data-title="brandstatus" class="5"></td>';
            results += '<td data-title="brandstatus"  class="7"><span id="totammountcls"></span></td></tr>';
            results += '</table></div>';
            $("#div_itemdetails").html(results);
            GetTotalCal();
            GetTotalQty();
        }
        function GetTotalCal() {
            var totamount = 0;
            $('.ammountcls').each(function (i, obj) {
                var qtyclass = $(this).text();
                if (qtyclass == "" || qtyclass == "0") {
                }
                else {
                    totamount += parseFloat(qtyclass);
                }
            });
            document.getElementById('totammountcls').innerHTML = parseFloat(totamount).toFixed(2);
            var amountwords = totamount.toFixed(0);
            var diffamt = totamount - amountwords;
            document.getElementById('spntotalissueamt').innerHTML = parseFloat(totamount).toFixed(2);
            document.getElementById('spnroundoffamt').innerHTML = parseFloat(diffamt).toFixed(2);
            document.getElementById('spngrandtotal').innerHTML = parseFloat(amountwords);
            document.getElementById('recevied').innerHTML = inWords(amountwords);
        }
        function GetTotalQty() {
            var TotalQty = 0;
            $('.qtycls').each(function (i, obj) {
                var qty = $(this).text();
                if (qty == "" || qty == "0") {
                }
                else {
                    TotalQty += parseFloat(qty);
                }
            });
            document.getElementById('totamcls').innerHTML = parseFloat(TotalQty).toFixed(2);
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
             Issue Voucher<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Reports</a></li>
            <li><a href="#"> Issue Voucher</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i> Issue Voucher
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

                            <td>
                                <label>
                                    Select Type</label>
                            </td>
                           
                           <td>
                                <select id="ddlsclttype" class="form-control">
                                    <option selected disabled value="Select Category Type">Select Category Type</option>
                                    <option value="p">Pending</option>
                                    <option value="A">Approval</option>
                                  
                                </select>
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td>
                                <div class="input-group">
                                    <div class="input-group-addon">
                                        <span class="glyphicon glyphicon-flash" onclick="get_outward_details_click();"></span> <span id="btn_save" onclick="get_outward_details_click();">Get Details</span>
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
                <div id="divPrint" style="display:none;">
                    <div  style="width: 13%; float: left;">
                        <img src="Images/Vyshnavilogo.png" alt="Vyshnavi" width="100px" height="72px" />
                        <br />
                    </div>
                    <div>
                        <div align="center" style="font-family: Arial; font-size: 18pt; font-weight: bold;
                            color: Black;">
                            <span>Sri Vyshnavi Dairy Specialities (P) Ltd </span>
                            <br />
                        </div>
                    </div>
                     <div align="center">
                        <span id="spnheading" style="font-size: 24px; font-weight: bold;"></span>
                    </div>
                    <div style="width: 100%;">
                        <table style="width: 100%;">
                            <tr>
                                <td style="width: 49%;"><%-- float: left;--%>
                                 <label style="font-size: 16px; font-weight: bold;">
                                          Name:</label>
                                    <span id="indentname" style="font-weight: bold;"></span>
                                    <br />
                                    <label style="font-size: 16px; font-weight: bold;">
                                         Issue Voucher Number :</label>
                                    <span id="indentnumber"></span>
                                </td>
                                <td>
                                </td>
                                <td style="width: 49%;"><%-- float: right;--%>
                                    <label style="font-size: 16px; font-weight: bold;">
                                        OutwardDate:</label>
                                    <span id="indentdate"></span>
                                    <br />
                                </td>
                            </tr>
                        </table>
                    </div>
                     <div id="div_itemdetails">
                    </div>
                    
                    <table style="width:100%;">
                    <tr style="text-align:right;">
                                <td style="width: 49%; padding-right:5%;">
                                    <label style="font-size: 16px; font-weight: bold;">
                                        Total Issue Amount :</label>
                                    <span id="spntotalissueamt" style="font-weight: bold; padding-left: 3%;"></span>
                                    <br />
                                    <label style="font-size: 16px; font-weight: bold;">
                                        Round Off Diff Amount :
                                         </label>
                                    <span id="spnroundoffamt" style="font-weight: bold;padding-left: 6%;"></span>
                                    <br />
                                    <label style="font-size: 16px; font-weight: bold;">
                                       Grand Total:
                                         </label>
                                         <span id="spngrandtotal" style="font-weight: bold;padding-left: 5%;"></span>
                                </td>
                            </tr>
                    <tr>
                                <td style="width: 49%; float: left;">
                                    <span id="Span1"></span>
                                    <br />
                                    <label style="font-size: 16px; font-weight: bold;">
                                        Description :</label>
                                    <span id="remarks"></span>
                                    <br />
                                    <label style="font-size: 16px; font-weight: bold;">
                                        Received:
                                         </label>
                                    <span id="recevied" onclick="test.inum.value = toWords(test.inum.value);" value="To Words"></span>
                                </td>
                            </tr>
                    </table>
                    <br />
                    <br />
                    <table style="width: 100%;">
                        <tr>
                            <td style="width: 25%;">
                                <span style="font-weight: bold; font-size: 12px;">INDENTED BY</span>
                            </td>
                            <td style="width: 25%;">
                                <span style="font-weight: bold; font-size: 12px;">APPROVED BY</span>
                            </td>
                            <td style="width: 25%;">
                                <span style="font-weight: bold; font-size: 12px;">STORES</span>
                            </td>
                             <td style="width: 25%;">
                                <span style="font-weight: bold; font-size: 12px;">RECEIVER SIGNATURE</span>
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="input-group" id="Button2" style="display:none;padding-right: 90%;">
                    <div class="input-group-addon">
                        <span class="glyphicon glyphicon-print" onclick="javascript: CallPrint('divPrint');"></span> <span id="Span2" onclick="javascript: CallPrint('divPrint');">Print</span>
                    </div>
                </div>
                <asp:Label ID="lblmsg" runat="server" Font-Size="20px" ForeColor="Red" Text=""></asp:Label>
            </div>
        </div>
    </section>
</asp:Content>
