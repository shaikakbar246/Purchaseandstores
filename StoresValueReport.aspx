<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true" CodeFile="StoresValueReport.aspx.cs" Inherits="StoresValueReport" %>

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
        function StoresItems() {
            var stores = document.getElementById('ddlstores').value;
            var data = { 'op': 'get_StoresItems_details_click', 'stores': stores };
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
            results += '<thead><tr><th scope="col">ItemName</th><th scope="col">name</th><th scope="col">qty</th><th scope="col">price</th><th scope="col">value</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><th scope="row" class="1" style="display:none;">' + msg[i].sno + '</th>';
                results += '<td data-title="brandstatus" style="text-align:center;" class="2">' + msg[i].productname + '</td>';
                results += '<td data-title="brandstatus" style="text-align:center;" class="2">' + msg[i].name + '</td>';
                results += '<td data-title="brandstatus" style="text-align:center;" class="2">' + msg[i].price + '</td>';
                results += '<td data-title="brandstatus" style="text-align:center;" class="2">' + msg[i].qty + '</td>';
                results += '<td data-title="brandstatus" style="text-align:center;" class="2">' + msg[i].Value + '</td>';

            }
            results += '</table></div>';
            $("#div_itemdetails").html(results);
        }
   </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
 <section class="content-header">
        <h1>
            Stores Values Report<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Reports</a></li>
            <li><a href="#">Stores Values Report</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i> Stores Values Report
                </h3>
            </div>
            <div class="box-body">
                <div>
                    <table>
                        <tr>
                            <td>
                                <label>
                                    Select Value</label>
                            </td>
                             <td style="height: 40px;">
                                <select id="ddlstores" class="form-control">
                                    <option value="Select AnyOne" disabled selected>Select AnyOne</option>
                                    <option value="Category">Category</option>
                                    <option value="SubCategory">SubCategory</option>
                                     <option value="Item">Item</option>
                                </select>
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td>
                                <input id="Button1" type="button" class="btn btn-primary" name="submit" value='Generate'
                                    onclick="StoresItems();"/>
                            </td>
                        </tr>
                    </table>
                </div>
                <div id="divPrint">
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
                        <span style="font-size: 24px; font-weight: bold;"> Stores Values Report </span>
                    </div>
                     <div id="div_itemdetails">
                    </div>
                    <br />
                    <br />
                   <%-- <table style="width: 100%;">
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
                    </table>--%>
                </div>
                <input id="Button2" type="button" class="btn btn-primary" name="submit" value='Print'
                    onclick="javascript:CallPrint('divPrint');" />
                <asp:Label ID="lblmsg" runat="server" Font-Size="20px" ForeColor="Red" Text=""></asp:Label>
            </div>
        </div>
    </section>
</asp:Content>

