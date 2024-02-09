<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true" CodeFile="IssueDashBoard.aspx.cs" Inherits="IssueDashBoard" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
 <script type="text/javascript">
     $(function () {
         get_issue_DataDashboard();
         get_Transfer_DataDashboard();
     });

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

     function fillcategoryvalues(msg) {
         $('#divMainAddNewRow').css('display', 'block');
         $('#hiddeninward').css('display', 'none');
         $('#hiddenoutward').css('display', 'none');
         j = 1;
         var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
         results += '<thead><tr></th><th style="text-align:center;" scope="col">Sno</th><th style="text-align:center;" scope="col">Item Name</th><th style="text-align:center;" scope="col">Quantity</th><th style="text-align:center;" scope="col">Price</th><th style="text-align:center;" scope="col">Value</th></tr></thead></tbody>';

         var k = 1;
         var l = 0;
         var COLOR = ["##87CEEB", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];

         for (var i = 0; i < msg.length; i++) {
             results += '<tr style="background-color:' + COLOR[l] + '"><th scope="row" class="1" style="text-align:center;">' + j + '</th>';
             results += '<td data-title="inwarddate" class="2">' + msg[i].productname + '</td>';
             results += '<td data-title="inwarddate" class="4">' + msg[i].qty + '</td>';
             results += '<td data-title="inwarddate" class="3">' + msg[i].price + '</td>';
             results += '<td data-title="invoicedate" class="tammountcls" >' + msg[i].StoresValue + '</td><tr>';

             j++;
             l = l + 1;
             if (l == 4) {
                 l = 0;
             }

         }
         results += '<tr><th scope="row" class="1" style="text-align:center;"></th>';
         results += '<td data-title="brandstatus" class="badge bg-yellow">Total</td>';
         results += '<td data-title="brandstatus" class="3"></td>';
         results += '<td data-title="brandstatus" class="4"></td>';
         results += '<td data-title="brandstatus" class="5"><span id="totalcls" class="badge bg-yellow"></span></td></tr>';
         results += '</table></div>';
         $("#Show_ProductsData").html(results);
         GettotalclsCal();
     }
     function GettotalclsCal() {
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
     function CloseClick() {
         $('#divMainAddNewRow').css('display', 'none');
         $('#hiddeninward').css('display', 'block');
         $('#hiddenoutward').css('display', 'block');
     }
     function subcategoryproduct(sno) {
         var sno;
         var data = { 'op': 'issuedashboardproductname', 'sno': sno };
         var s = function (msg) {
             if (msg) {
                 if (msg) {
                     // alert(msg);
                     $('#divMainAddNewRow').css('display', 'none');
                     fillcategoryvalues(msg);
                     //GetTotalCal();
                 }
                 else {
                 }
             }
         };
         var e = function (x, h, e) {
         };
         $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
         callHandler(data, s, e);
     }
     function get_issue_DataDashboard() {
         var table = document.getElementById("tbl_Stores_value");
         for (var i = table.rows.length - 1; i > 0; i--) {
             table.deleteRow(i);
         }
         var data = { 'op': 'get_issue_DataDashboard' };
         var s = function (msg) {
             if (msg) {
                 var j = 1;
                 var k = 1;
                 var l = 0;
                 var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
                 for (var i = 0; i < msg.length; i++) {
                     var tablerowcnt = document.getElementById("tbl_Stores_value").rows.length;
                     $('#tbl_Stores_value').append('<tr style="background-color:' + COLOR[l] + '"><td data-title="sno">' + j + '</td><th scope="Category Name"   onclick="subcategoryproduct(\'' + msg[i].sno + '\');"><i class="fa fa-arrow-circle-right"  aria-hidden="true">&nbsp;&nbsp;&nbsp;&nbsp;' + msg[i].sno + '          ' + '</th><th><span id="spnmoniterqty" class="badge bg-green"><span class="clsmoniterqty">' + msg[i].inwarddate + '</span></span></th><th><span id="spnmoniterqty" class="badge bg-green"><span class="clsmoniterqty">' + msg[i].sectionname + '</span></span></th></td></tr>');
                     j++;

                     l = l + 1;
                     if (l == 4) {
                         l = 0;
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

     function get_Transfer_DataDashboard() {
         var table1 = document.getElementById("tbl_Branch_Transfer_Value");
         for (var i = table1.rows.length - 1; i > 0; i--) {
             table1.deleteRow(i);
         }
         var data = { 'op': 'get_Transfer_DataDashboard' };
         var s = function (msg) {
             if (msg) {
                 var j = 1;
                 var k = 1;
                 var l = 0;
                 var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];

                 for (var i = 0; i < msg.length; i++) {
                     var tablerowcnt = document.getElementById("tbl_Branch_Transfer_Value").rows.length;
                     //$('#tbl_Branch_Transfer_Value').append('<tr style="background-color:' + COLOR[l] + '"><td data-title="sno">' + j + '</td><th><span id="spninqty" onclick="transferproductname(\'' + msg[i].sno + '\');"  class="badge bg-green"><span class="clsinqty">' + msg[i].sno + '         ' + '</span></span><i class="fa fa-arrow-circle-right"  aria-hidden="true"></th><th><span id="spninqty" class="badge bg-green"><span class="clsinqty">' + msg[i].invoicedate + '</span></span></th><th><span id="spninqty" class="badge bg-green"><span class="clsinqty">' + msg[i].branchname + '</span></span></th></td></tr>');
                     $('#tbl_Branch_Transfer_Value').append('<tr style="background-color:' + COLOR[l] + '"><td data-title="sno">' + j + '</td><th style="width: 100%;" onclick="transferproductname(\'' + msg[i].sno + '\');"><i class="fa fa-arrow-circle-right"  aria-hidden="true">&nbsp;&nbsp;&nbsp;&nbsp;' + msg[i].sno + '         ' + '</th><th><span id="spninqty" ><span class="clsinqty">' + msg[i].invoicedate + '</span></span></th><th><span id="spninqty"><span class="clsinqty">' + msg[i].branchname + '</span></span></th></td></tr>');//class="badge bg-green"
                     j++

                     l = l + 1;
                     if (l == 4) {
                         l = 0;
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

     function transferproductname(sno) {
         var sno;
         var data = { 'op': 'transferdashboardproductname', 'sno': sno };
         var s = function (msg) {
             if (msg) {
                 if (msg) {
                     // alert(msg);
                     $('#divMainAddNewRow').css('display', 'none');
                     fillcategoryvalues1(msg);
                     //GetTotalCal();
                 }
                 else {
                 }
             }
         };
         var e = function (x, h, e) {
         };
         $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
         callHandler(data, s, e);
     }

     function fillcategoryvalues1(msg) {
         $('#divMainAddNewRow').css('display', 'block');
         $('#hiddeninward').css('display', 'none');
         $('#hiddenoutward').css('display', 'none');
         j = 1;
         var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
         results += '<thead><tr></th><th style="text-align:center;" scope="col">Sno</th><th style="text-align:center;" scope="col">Item Name</th><th style="text-align:center;" scope="col">Quantity</th><th style="text-align:center;" scope="col">Price</th><th style="text-align:center;" scope="col">Value</th></tr></thead></tbody>';

         var k = 1;
         var l = 0;
         var COLOR = ["##87CEEB", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];

         for (var i = 0; i < msg.length; i++) {
             results += '<tr style="background-color:' + COLOR[l] + '"><th scope="row" class="1" style="text-align:center;">' + j + '</th>';
             results += '<td data-title="inwarddate" class="2">' + msg[i].productname + '</td>';
             results += '<td data-title="inwarddate" class="3">' + msg[i].price + '</td>';
             results += '<td data-title="inwarddate" class="4">' + msg[i].qty + '</td>';
             results += '<td data-title="invoicedate" class="tammountcls1" >' + msg[i].StoresValue + '</td><tr>';

             j++;
             l = l + 1;
             if (l == 4) {
                 l = 0;
             }

         }
         results += '<tr><th scope="row" class="1" style="text-align:center;"></th>';
         results += '<td data-title="brandstatus" class="badge bg-yellow">Total</td>';
         results += '<td data-title="brandstatus" class="3"></td>';
         results += '<td data-title="brandstatus" class="4"></td>';
         results += '<td data-title="brandstatus" class="5"><span id="totalcls1" class="badge bg-yellow"></span></td></tr>';
         results += '</table></div>';
         $("#Show_ProductsData").html(results);
         GettotalclsCal1();
     }
     function GettotalclsCal1() {
         var totamount = 0;
         $('.tammountcls1').each(function (i, obj) {
             var qtyclass = $(this).text();
             if (qtyclass == "" || qtyclass == "0") {
             }
             else {
                 totamount += parseFloat(qtyclass);
             }
         });
         document.getElementById('totalcls1').innerHTML = parseFloat(totamount).toFixed(2);
     }
    
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            DashBoard <small>Preview</small>
        </h1>
        <ol class="breadcrumb">
        
        </ol>
    </section>
    <!-- Main content -->
    <section class="content">
        <div class="row">
            <div class="col-md-6" style="width: 100%;">
                </div>
                <!-- AREA CHART -->
            <div class="col-md-6" id="hiddeninward">
                <div class="box box-solid box-success">
                    <div class="box-header">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Today Issue Details</h3>
                    </div>
                    <div class="box-body">
                        <div class="box-body no-padding">
                            <table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-
                                describedby="example2_info" id="tbl_Stores_value">
                                <tr>
                                    <th style="width: 10px">
                                        #
                                    </th>
                                    <th>
                                       Issue No
                                    </th>
                                    <th>
                                        Issue Date
                                    </th>
                                    <th>
                                        Supplier Name
                                    </th>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-6" id="hiddenoutward">
                <div class="box box-solid box-danger">
                    <div class="box-header">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Today Stock Transfers Details
                        </h3>
                        <%--<div class="box-tools pull-right">
                            <button class="btn btn-box-tool" data- widget="collapse">
                                <i class="fa fa-minus"></i>
                            </button>
                        </div>--%>
                    </div>
                    <div class="box-body">
                        <div class="box-body no-padding">
                            <table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-
                                describedby="example2_info" id="tbl_Branch_Transfer_Value">
                                <tr>
                                    <th style="width: 10px">
                                        #
                                    </th>
                                     <th>
                                       Invoice NO
                                    </th>
                                     <th>
                                        Invoice Date
                                    </th>
                                    <th>
                                      Branch Name
                                    </th>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
          <%--  <div class="col-md-6" id="hiddenoutward">
                <div class="box box-danger">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i> Outward Details
                        </h3>
                        <div class="box-tools pull-right">
                            <button class="btn btn-box-tool" data- widget="collapse">
                                <i class="fa fa-minus"></i>
                            </button>
                        </div>
                    </div>
                    <div class="box-body">
                        <div class="box-body no-padding">
                            <table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-
                                describedby="example2_info" id="tbl_Outward_Value">
                                <tr>
                                    <th style="width: 10px">
                                        #
                                    </th>
                                     <th>
                                        Reciever Name
                                    </th>
                                     <th>
                                        IssueDate
                                    </th>
                                    <th>
                                       Item Name
                                    </th>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
            </div>--%>
          <div id="divMainAddNewRow" class="pickupclass" style="text-align: center; height: 100%;
                width: 100%; position: absolute; display: none; left: 0%; top: 0%; z-index: 99999;
                background: rgba(192, 192, 192, 0.7);">
                <div id="divAddNewRow" style="border: 5px solid #A0A0A0; position: absolute; top: 8%;
                    background-color: White; left: 10%; right: 10%; width: 80%; height: 100%; -webkit-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                    -moz-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65); box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                    border-radius: 10px 10px 10px 10px;">
                    <table align="left" cellpadding="0" cellspacing="0" style="float: left; width: 100%;"
                        id="tableCollectionDetails" class="mainText2" border="1">
                       
                      <tr>
                            <td colspan="2">
                                <div id="Show_ProductsData">
                                </div>
                            </td>
                        </tr>
                     <tr>
                            <td>
                                <input type="button" class="btn btn-danger" id="close_vehmaster" value="Close" onclick="CloseClick();" />
                            </td>
                        </tr>
                    </table>
             </div>>
           <div id="divclose" style="width: 35px; top: 7.5%; right: 10%; position: absolute;
                    z-index: 99999; cursor: pointer;">
                    <img src="Images/Close.png" alt="close" width="100%" height="100%" onclick="CloseClick();" />
                </div>
          </div>
        </div>
    </section>
</asp:Content>

