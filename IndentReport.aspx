<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true"
    CodeFile="IndentReport.aspx.cs" Inherits="IndentReport" %>

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
    <script>
        $(function () {
            $('#hiddenrefno').css('display', 'none');
            $('#Button1').css('display', 'none'); 
            $('#Button2').css('display', 'none'); 
        });
    
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
        function get_indent_details_click() {
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
            var data = { 'op': 'get_indent_details_click', 'fromdate': fromdate, 'todate': todate };
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
            results += '<thead><tr><th scope="col"></th><th scope="col">Ref No</th><th scope="col">Name</th><th scope="col">MRF Date</th><th scope="col">Status</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                var status = "";
                if (msg[i].status == "V") {
                    status = "Verified";
                }
                else {
                    status = "Pending";
                }
                results += '<tr>';
                results += '<td data-title="brandstatus"><button type="button" title="Click Here To Print!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 printcls"  onclick="printclick(this)"><span class="glyphicon glyphicon-print" style="top: 0px !important;"></span></button></td>';
                results += '<td scope="row" class="1"  style="text-align:center;">' + msg[i].sno + '</td>';
                results += '<td data-title="brandstatus" style="text-align:center;" class="2">' + msg[i].name + '</td>';
                results += '<td data-title="brandstatus" style="text-align:center;" class="2">' + msg[i].idate + '</td>';
                results += '<td data-title="brandstatus" style="text-align:center;" class="2">' + status + '</td></tr>';

            }
            results += '</table></div>';
            $("#divPOdata").html(results);
        }
       
        function  printclick(thisid) {
            var refdcno = $(thisid).parent().parent().children('.1').html();
            if (refdcno == "") {
                alert("Please enter ref dc no");
                return false;
            }
            var data = { 'op': 'get_Indent_Sub_details_click', 'refdcno': refdcno };
            var s = function (msg) {
                if (msg) {

                    if (msg.length > 0) {
                        $('#divPrint').css('display', 'block');
                        $('#hiddenrefno').css('display', 'none');
                        $('#Button2').css('display', 'block');
                        var Indent_details = msg[0].Indent;
                        var indent_sub_details = msg[0].SubIndent;
                        document.getElementById('indentname').innerHTML = Indent_details[0].name;
                        document.getElementById('indentdate').innerHTML = Indent_details[0].idate;
                        document.getElementById('spnsectionname').innerHTML = Indent_details[0].sectionname;
                        document.getElementById('indentnumber').innerHTML = "SVDS/IND/" + Indent_details[0].sno;
                        document.getElementById('spnrmks').innerHTML = Indent_details[0].remarks;
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
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Item Code</th><th scope="col">Product Name</th><th scope="col">Qty</th><th>Price</th><th scope="col">Remarks</th></tr></thead></tbody>';
            var j = 1;
            for (var i = 0; i < msg.length; i++) {
                var Quantity = 0;
                Quantity = parseFloat(msg[i].qty);
                var price = 0;
                price = parseFloat(msg[i].price).toFixed(2);
                var amount = 0;var amount1 = 0;
                amount1 = Quantity * price;
                amount = parseFloat(amount1).toFixed(2);
                var collen = 0;
                collen = msg.length;
                results += '<tr><th scope="row" class="1" style="text-align:center;">' + j + '</th>';
                results += '<td data-title="brandstatus" style="text-align:center;" class="2">' + msg[i].sku + '</td>';
                results += '<td data-title="brandstatus" style="text-align:center;" class="2">' + msg[i].productname + '</td>';
                results += '<td data-title="brandstatus" style="text-align:center;" class="qtycls">' + Quantity + '</td>';
                results += '<td data-title="brandstatus" style="text-align:center;" class="4">' + price + '</td>';
                results += '<td data-title="brandstatus" style="text-align:center;" class="ammountcls">' + amount + '</td>';
                j++;
            }
            var tot = "";
            var tqty = "Total"
            results += '<tr><th scope="row" class="1" style="text-align:center;"></th>';
            results += '<td data-title="brandstatus" style="text-align:center;" class="2"></td>';
            results += '<td data-title="brandstatus" style="text-align:center;" class="2">' + tqty + '</td>';
            results += '<td data-title="brandstatus" style="text-align:center;" class="3"><span id="totamcls"></span></td>';
            results += '<td data-title="brandstatus" style="text-align:center;" class="6">' + tot + '</td>';
          
            results += '<td data-title="brandstatus" style="text-align:center; " class="7"><span id="totammountcls"></span></td>';
            results += '<td data-title="brandstatus" style="text-align:center;" class="8"></td></tr>';
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
            document.getElementById('recevied').innerHTML = toWords(totamount);
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
        var th = ['', 'thousand', 'million', 'billion', 'trillion'];

        var dg = ['zero', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine'];

        var tn = ['ten', 'eleven', 'twelve', 'thirteen', 'fourteen', 'fifteen', 'sixteen', 'seventeen', 'eighteen', 'nineteen'];

        var tw = ['twenty', 'thirty', 'forty', 'fifty', 'sixty', 'seventy', 'eighty', 'ninety'];

        function toWords(s) {
            s = s.toString();
            s = s.replace(/[\, ]/g, '');
            if (s != parseFloat(s)) return 'not a number';
            var x = s.indexOf('.');
            if (x == -1) x = s.length;
            if (x > 15) return 'too big';
            var n = s.split('');
            var str = '';
            var sk = 0;
            for (var i = 0; i < x; i++) {
                if ((x - i) % 3 == 2) {
                    if (n[i] == '1') {
                        str += tn[Number(n[i + 1])] + ' ';
                        i++;
                        sk = 1;
                    } else if (n[i] != 0) {
                        str += tw[n[i] - 2] + ' ';
                        sk = 1;
                    }
                } else if (n[i] != 0) {
                    str += dg[n[i]] + ' ';
                    if ((x - i) % 3 == 0) str += 'hundred ';
                    sk = 1;
                }
                if ((x - i) % 3 == 1) {
                    if (sk) str += th[(x - i - 1) / 3] + ' ';
                    sk = 0;
                }
            }
            if (x != s.length) {
                var y = s.length;
                str += 'point ';
                for (var i = x + 1; i < y; i++) str += dg[n[i]] + ' ';
            }
            return str.replace(/\s+/g, ' ');

        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Material Requisition Form<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Reports</a></li>
            <li><a href="#">Material Requisition Form</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Material Requisition Form
                </h3>
            </div>
            <div class="box-body">
                <div runat="server" id="d">
                    <table>
                        <tr>
                            <td >
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
                                        <span class="glyphicon glyphicon-flash" onclick="get_indent_details_click();"></span> <span id="btn_save" onclick="get_indent_details_click();">Get Details</span>
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
                    <div style="width: 13%; float: left;">
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
                        <span style="font-size: 24px; font-weight: bold;">Material Requisition Form</span>
                        <br />
                    </div>
                    <div style="width: 100%;">
                        <table style="width: 100%;">
                            <tr>
                                <td>
                                    <label style="font-size: 16px; font-weight: bold;">
                                        Name:</label>
                                    <span style="font-weight: bold;" id="indentname"></span>
                                    <br />
                                    <label style="font-size: 16px; font-weight: bold;">
                                        SectionName:</label>
                                    <span id="spnsectionname"></span>
                                    <br />
                                    <label style="font-size: 16px; font-weight: bold;">
                                        To
                                    </label> 
                                    <br />
                                    PurchaseDepartment, 
                                    <br />
                                    Please Purchase Following Materials
                                    <br />
                                </td>
                                <td>
                                    <label style="font-size: 16px; font-weight: bold;">
                                        MRF Date:</label>
                                    <span id="indentdate"></span>
                                    <br />
                                    <label style="font-size: 16px; font-weight: bold;">
                                        MrReQ No :</label>
                                    <span id="indentnumber"></span>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div id="div_itemdetails">
                    </div>
                    <table style="width: 100%;">
                        <tr>
                            <td style="width: 49%; float: left;">
                                <span id="Span1"></span>
                                <br />
                                <label style="font-size: 16px; font-weight: bold;">
                                    Recevied as an MRF Value:
                                </label>
                                <span id="recevied" onclick="test.rnum.value = toWords(test.inum.value);" value="To Words">
                                </span><span>Rupees Only/-</span>
                                <br />
                            </td>
                        </tr>
                        <tr>
                        <td>
                        <span id="spnrmks" style="font-size: 16px; font-weight: bold;"></span>
                        </td>
                        </tr>
                    </table>
                    <br />
                    <table style="width: 100%;">
                        <tr>
                            <td style="width: 25%;">
                                <span style="font-weight: bold; font-size: 12px;">Indented By</span>
                            </td>
                            <td style="width: 25%;">
                                <span style="font-weight: bold; font-size: 12px;">Stores</span>
                            </td>
                            <td style="width: 25%;">
                                <span style="font-weight: bold; font-size: 12px;">Approved By</span>
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
