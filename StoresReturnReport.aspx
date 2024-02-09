<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true"
    CodeFile="StoresReturnReport.aspx.cs" Inherits="StockReturnReport" %>

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
        function get_Stores_return_Report_details() {
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
               // var data = { 'op': 'get_StockTransfer_details_click', 'fromdate': fromdate, 'todate': todate, 'invoicetype': invoicetype };
                var data = { 'op': 'get_Stores_return_Report_details', 'fromdate': fromdate, 'todate': todate };
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
            //}
        }

        function filldetails(msg) {
            
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col"></th><th scope="col">Ref No</th><th scope="col">Name</th><th scope="col">Date</th><th scope="col">Remarks</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                //if (invoicetype == msg[i].invoicetype) {
                results += '<tr>';//<th><input id="btn_Print" type="button" onclick="printclick(this);" name="Edit" class="btn btn-primary" value="Print" /></th>
                results += '<td data-title="brandstatus"><button type="button" title="Click Here To Print!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 printcls"  onclick="printclick(this)"><span class="glyphicon glyphicon-print" style="top: 0px !important;"></span></button></td>';
                results += '<td th scope="row" class="1"  style="text-align:center;">' + msg[i].sno + '</td>';
                results += '<td data-title="brandstatus" style="text-align:center;" class="3">' + msg[i].name + '</td>';
                results += '<td data-title="brandstatus" style="text-align:center;" class="2">' + msg[i].doe + '</td>';
                results += '<td data-title="brandstatus" style="text-align:center;" class="5">' + msg[i].remarks + '</td></tr>';
                   // results += '<td data-title="brandstatus"  style="display:none;">' + msg[i].vehicleno + '</td>';
                   // results += '<td data-title="brandstatus"  style="display:none;" class="6">' + msg[i].transportname + '</td>';

               // }
            }
            results += '</table></div>';
            $("#divPOdata").html(results);
        }
        function printclick(thisid) {
            var refdcno = $(thisid).parent().parent().children('.1').html();
            if (refdcno == "") {
                alert("Please enter ref dc no");
                return false;
            }
            var data = { 'op': 'get_SubStores_return_Report_details', 'refdcno': refdcno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        $('#divPrint').css('display', 'block');
                        var StoresReturndetails = msg[0].StoresReturn;
                        var subStoresReturnDetails = msg[0].SubStoresReturn;
                        document.getElementById('spnname').innerHTML = StoresReturndetails[0].name;
                        document.getElementById('spndate').innerHTML = StoresReturndetails[0].doe;
                        document.getElementById('spnremarks').innerHTML = StoresReturndetails[0].remarks;
                        fill_SubStores_return_Report_details(subStoresReturnDetails);
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
        function fill_SubStores_return_Report_details(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" border="2" style="width:100%;">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Price</th><th scope="col">Quantity</th><th scope="col">Amount</th></tr></thead></tbody>';
            var j = 1;
            $('#Button2').css('display', 'block');
            for (var i = 0; i < msg.length; i++) {
                var Quantity = 0; var Amount = 0; var tax = 0;
                Quantity = parseFloat(msg[i].quantity);
                price = parseFloat(msg[i].PerUnitRs).toFixed(2);
                Amount = Quantity * price;
                results += '<tr><th scope="row" class="1" style="text-align:center;">' + j + '</th>';
                results += '<td data-title="brandstatus" style="text-align:center;" class="2">' + msg[i].productname + '</td>';
                results += '<td data-title="brandstatus" style="text-align:center;" class="qtycls">' + price + '</td>';
                results += '<td data-title="brandstatus" style="text-align:center;" class="4">' + Quantity + '</td>';
                results += '<td data-title="brandstatus" style="text-align:center;" class="ammountcls">' + Amount.toFixed(2) + '</td></tr>';
                j++;
            }
            var tot = "";
            var tqty = "Total"
            results += '<tr><th scope="row" class="1" style="text-align:center;"></th>';
            results += '<td data-title="brandstatus" style="text-align:center;" class="2">' + tqty + '</td>';
            results += '<td data-title="brandstatus" style="text-align:center;" class="3"><span id="totamcls"></span></td>';
            results += '<td data-title="brandstatus" style="text-align:center;" class="6">' + tot + '</td>';
            results += '<td data-title="brandstatus" style="text-align:center;" class="7"><span id="totammountcls"></span></td></tr>';
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
            document.getElementById('spnstreturn').innerHTML = parseFloat(totamount).toFixed(2);
            var grandtotal = parseFloat(totamount).toFixed(0);
            var diff = grandtotal - totamount;
            document.getElementById('spnroundoffamt').innerHTML = parseFloat(diff).toFixed(2); ;
            document.getElementById('spngrandtotal').innerHTML = parseFloat(grandtotal).toFixed(2);
            document.getElementById('recevied').innerHTML = inWords(parseInt(grandtotal));
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
            Stores Return Report<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Reports</a></li>
            <li><a href="#">  Stores Return Report</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Stores Return Report
                </h3>
            </div>
            <div class="box-body">
                <div runat="server" id="d">
                    <table>
                        <tr>
                         <%-- <td>
                            <label>
                            Select Type
                              </label>
                          </td>
                           <td>
                             <select ID="ddltype"  onchange="ddltypechangeinvoice(this);">
                             <option value="Invoice">Invoice</option>
                             <option value="WithOutInvoice">WithOutInvoice</option>
                             </select>
                             </td>--%>
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
                                <%--<input id="btn_save" type="button" class="btn btn-primary" name="submit" value='Get Details' onclick="get_Stores_return_Report_details()" />--%>
                                <div class="input-group">
                                    <div class="input-group-addon">
                                        <span class="glyphicon glyphicon-flash" onclick="get_Stores_return_Report_details();"></span> <span id="btn_save" onclick="get_Stores_return_Report_details();">Get Details</span>
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
                        <span style="font-size: 24px; font-weight: bold;"> Stores Transfer Note </span>
                    </div>
                    <div style="width: 100%;">
                        <table style="width: 100%;">
                            <tr>
                                <td style="width: 49%;"><%-- float: left;--%>
                                 <label style="font-size: 16px; font-weight: bold;">
                                          Name:</label>
                                    <span id="spnname"></span>
                                    <br />
                                    
                                    
                                </td>
                                <td>
                                </td>
                                <td style="width: 49%;"><%-- float: right;--%>
                                    <label style="font-size: 16px; font-weight: bold;">
                                          STN Date:</label>
                                    <span id="spndate"></span>
                                    <br />
                                   
                                    
                                </td>
                            </tr>
                        </table>
                    </div>
                     <div id="div_itemdetails">
                    </div>
                    <table style="width: 100%;"> 
                      <tr style="text-align:right;">
                                <td style="width: 49%; padding-right:4%;">
                                    <br />
                                    <label style="font-size: 16px; font-weight: bold;">
                                        Total Return Value :</label>
                                    <span id="spnstreturn" style="font-weight: bold; padding-left:3%;"></span>
                                    <br />
                                    <label style="font-size: 16px; font-weight: bold;">
                                        Round off Diff Amount :
                                         </label>
                                     <span id="spnroundoffamt" style="font-weight: bold;padding-left:6%;"></span>
                                     <br />
                                     <label style="font-size: 16px; font-weight: bold;">
                                        Grand Total :
                                         </label>
                                     <span id="spngrandtotal" style="font-weight: bold;padding-left:5%;"></span>
                                </td>
                            </tr>
                          <tr>
                                <td style="width: 49%; float: left;">
                                    <span id="Span1"></span>
                                    <br />
                                    <label style="font-size: 16px; font-weight: bold;">
                                        Description :</label>
                                    <span id="spnremarks"></span>
                                    <br />
                                    <label style="font-size: 16px; font-weight: bold;">
                                        Received:
                                         </label>
                                    <label>Rs    </label>
                                    <span id="recevied" onclick="test.rnum.value = toWords(test.inum.value);" value="To Words">only</span>
                                </td>
                            </tr>
                    </table>
                    <br />
                    
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
                        <span class="glyphicon glyphicon-print" onclick="javascript: CallPrint('divPrint');"></span> <span id="Span2" onclick="javascript: CallPrint('divPrint');">Print</span>
                    </div>
                </div>
                <asp:Label ID="lblmsg" runat="server" Font-Size="20px" ForeColor="Red" Text=""></asp:Label>
            </div>
        </div>
    </section>  
</asp:Content>
