<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true" CodeFile="ReturnableReport.aspx.cs" Inherits="ReturnableReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
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
            //            
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
        function get_stockrepair_details() {
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
            var data = { 'op': 'get_Returnble_Material_details_Report', 'fromdate': fromdate, 'todate': todate };
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
            results += '<thead><tr><th scope="col"></th><th scope="col">Refno</th><th scope="col">Name</th><th scope="col">Issue Date</th><th scope="col">Issue Remarks</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr>';//<th><input id="btn_Print" type="button"   onclick="printclick(this);"  name="Edit" class="btn btn-primary" value="Print" /></th>
                    results += '<td data-title="brandstatus"><button type="button" title="Click Here To Print!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5" style="border-radius: 100% !important;padding:0px !important;height:30px !important;width:30px !important;"  onclick="printclick(this)"><span class="glyphicon glyphicon-print" style="top: 0px !important;"></span></button></td>';
                    results += '<td scope="row" class="1"  style="text-align:center;">' + msg[i].sno + '</td>';
                    results += '<td data-title="brandstatus" style="text-align:center;" class="2">' + msg[i].name + '</td>';
                    results += '<td data-title="brandstatus" style="text-align:center;" class="2">' + msg[i].issudate + '</td>';
                    results += '<td data-title="brandstatus" style="text-align:center;" class="2">' + msg[i].issueremarks + '</td>';
            }
            results += '</table></div>';
            $("#divmaterialdata").html(results);
        }
        function printclick(thisid) {
            var refno = $(thisid).parent().parent().children('.1').html();
            var data = { 'op': 'get_Returnble_Material_Report_SubDetails', 'refno': refno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        var returnable = msg[0].tools_issue_receive;
                        var subreturnable = msg[0].subtools_issue_receive;
                        $('#divPrint').css('display', 'block');
                        $('#Button2').css('display', 'block');
                        document.getElementById('srepair_name').innerHTML = returnable[0].name;
                        document.getElementById('repairvnumber').innerHTML = returnable[0].sno;
                        document.getElementById('outdate').innerHTML = returnable[0].issudate;
                        document.getElementById('remarks').innerHTML = returnable[0].issueremarks;
                        fill_sub_Returnable_details(subreturnable);
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
        function fill_sub_Returnable_details(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" border="2" style="width:100%;">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Item Name</th><th scope="col">Qty</th></tr></thead></tbody>';
            var j = 1;
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><th scope="row" class="1" style="text-align:center;">' + j + '</th>';
                results += '<td data-title="brandstatus" style="text-align:center;" class="2">' + msg[i].productname + '</td>';
                results += '<td data-title="brandstatus" style="text-align:center;" class="tammountcls">' + msg[i].quantity + '</td></tr>'
                j++;
            }
            var t2 = "Total";
            results += '<tr><th scope="row" class="1" style="text-align:center;"></th>';
            results += '<td data-title="brandstatus"  class="6">' + t2 + '</td>';
            results += '<td data-title="brandstatus" class="7"><span id="totalcls"></span></td></tr>';
            results += '</table></div>';
            $("#div_itemdetails").html(results);
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
        }
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
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<section class="content-header">
        <h1>
             Returnable Issue Come Get Pass<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Reports</a></li>
            <li><a href="#"> Returnable Issue Come Get Pass</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Returnable Issue Come Get Pass
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
                                <%--<input id="btn_save" type="button" class="btn btn-primary" name="submit" value='Get Details' onclick="get_stockrepair_details()" />--%>
                                <div class="input-group">
                                    <div class="input-group-addon">
                                        <span class="glyphicon glyphicon-flash" onclick="get_stockrepair_details();"></span> <span id="btn_save" onclick="get_stockrepair_details();">Get Details</span>
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </table>
                    <div id="divmaterialdata" style="height: 300px; overflow-y: scroll;">
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
                        <span id="spnheading" style="font-size: 24px; font-weight: bold;">Returnable Issue Come GetPass</span>
                    </div>
                    <%--<div align="center">
                        <span style="font-size: 24px; font-weight: bold;"> Outward Issue Voucher </span>
                    </div>--%>
                    <div style="width: 100%;">
                        <table style="width: 100%;">
                            <tr>
                                <td style="width: 49%;"><%-- float: left;--%>
                                 <label style="font-size: 16px; font-weight: bold;">
                                          Name:</label>
                                    <span id="srepair_name" style="font-weight:bold"></span>
                                    <br />
                                    <label style="font-size: 16px; font-weight: bold;">
                                         RIG Number :</label>
                                    <span id="repairvnumber"></span>
                                    
                                </td>
                                <td>
                                </td>
                                <td style="width: 49%;"><%-- float: right;--%>
                                    <label style="font-size: 16px; font-weight: bold;">
                                        RIG Date:</label>
                                    <span id="outdate"></span>
                                    <br />
                                </td>
                              <%--  <td style="width: 49%; float: right;">
                                    <label>
                                        ExpectedDate:</label>
                                    <span id="expdate"></span>
                                    <br />
                                </td>--%>
                            </tr>
                        </table>
                    </div>
                    <div id="div_itemdetails">
                    </div>
                    <table style="width: 100%;">
                          <tr>
                                <td style="width: 49%; float: left;">
                                    <label style="font-size: 16px; font-weight: bold;">
                                        Remarks :</label>
                                    <span id="remarks"></span>
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

