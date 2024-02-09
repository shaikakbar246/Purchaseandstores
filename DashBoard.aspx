<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true"
    CodeFile="DashBoard.aspx.cs" Inherits="DashBoard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        $(function () {
            GetDailyStoresValue();
            GetDailyInwardValue();
            GetDailyOutwardValue()
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
        function fillcategoryvalues(msg) {
            $('#divMainAddNewRow').css('display', 'block');
            $('#hiddeninward').css('display', 'none');
            $('#hiddenoutward').css('display', 'none');
            j = 1;
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr></th><th style="text-align:center;" scope="col">Sno</th><th> </th><th scope="col">Item Name</th><th style="text-align:center;" scope="col">MinStock</th><th style="text-align:center;" scope="col">MaxStock</th><th style="text-align:center;" scope="col">Quantity</th><th style="text-align:center;" scope="col">Price</th><th style="text-align:center;" scope="col">Value</th></tr></thead></tbody>';

            var k = 1;
            var l = 0;
            var COLOR = ["##87CEEB", "AntiqueWhite", "#daffff", "MistyRose", "Bisque" ];
            
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '"><th scope="row" class="1" style="text-align:center;">' + j + '</th>';
                results += '<td class="2" onclick="productdetails(\'' + msg[i].productid + '\');"><i class="fa fa-arrow-circle-right"  aria-hidden="true"></td>';
                results += '<td class="2" style="text-align: left;" onclick="productdetails(\'' + msg[i].productid + '\');">' + msg[i].productname + '</td>';
                results += '<td class="4">' + msg[i].minstock + '</td>';
                results += '<td class="4">' + msg[i].maxstock + '</td>';
                results += '<td class="4">' + msg[i].qty + '</td>';
                results += '<td class="3">' + msg[i].price + '</td>';
                results += '<td class="tammountcls" >' + msg[i].StoresValue + '</td><tr>';

                j++;
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }

            }
            results += '<tr><th scope="row" class="1" style="text-align:center;"></th>';
            results += '<td data-title="brandstatus" class="6"></td>';
            results += '<td data-title="brandstatus" class="badge bg-yellow">Total</td>';
            results += '<td data-title="brandstatus" class="3"></td>';
            results += '<td data-title="brandstatus" class="4"></td>';
            results += '<td data-title="brandstatus" class="7"></td>';
            results += '<td data-title="brandstatus" class="8"></td>';
            results += '<td data-title="brandstatus" class="5"><span id="totalcls" class="badge bg-yellow"></span></td></tr>';
            results += '</table></div>';
            $("#ShowCategoryData").html(results);
            GettotalclsCal();
        }

        function productdetails(productid)
        {
            var data = { 'op': 'get_product_details_id', 'productid': productid };
            var s = function (msg) {
                if (msg) {
                    if (msg) {
                        $('#divMainAddNewRow1').css('display', 'none');
                        fillproductdetails(msg);
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

        function fillproductdetails(msg) {
            $('#divMainAddNewRow1').css('display', 'block');
            $('#hiddeninward').css('display', 'none');
            $('#hiddenoutward').css('display', 'none');
            j = 1;
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr><th style="text-align:center;" scope="col">Sno</th><th style="text-align:center;" scope="col">Item Name</th><th style="text-align:center;" scope="col">UOM</th><th style="text-align:center;" scope="col">Product Code</th><th style="text-align:center;" scope="col">Category</th><th style="text-align:center;" scope="col">Sub Category</th><th style="text-align:center;" scope="col">SKU</th><th style="text-align:center;" scope="col">Supplier Name</th><th style="text-align:center;" scope="col">Item Code</th></tr></thead></tbody>';

            var k = 1;
            var l = 0;
            var COLOR = ["##87CEEB", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];

            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '"><th scope="row" class="1" style="text-align:center;">' + j + '</th>';
                results += '<td class="2">' + msg[i].productname + '</td>';
                results += '<td class="3">' + msg[i].uim + '</td>';
                results += '<td class="4">' + msg[i].productcode + '</td>';
                results += '<td class="5">' + msg[i].category + '</td>';
                results += '<td class="6">' + msg[i].subcatname + '</td>';
                results += '<td class="7">' + msg[i].sku + '</td>';
                results += '<td class="8">' + msg[i].suppliername + '</td>';
                results += '<td class="9" >' + msg[i].itemcode + '</td><tr>';

                j++;
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }

            }
            results += '</table></div>';
            $("#div_productdetails").html(results);
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
        function CloseClick_prod_det_close() {
            $('#divMainAddNewRow1').css('display', 'none');
            $('#divMainAddNewRow').css('display', 'block');
            $('#hiddeninward').css('display', 'block');
            $('#hiddenoutward').css('display', 'block');
        }
        function subcategoryproduct(category) {
            var category;
            var data = { 'op': 'subcategoryvalues', 'category': category };
            var s = function (msg) {
                if (msg) {
                    if (msg) {
                        $('#divMainAddNewRow').css('display', 'none');
                        fillcategoryvalues(msg);
                        GetTotalCal();
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
        function GetDailyStoresValue() {
            var table = document.getElementById("tbl_Stores_value");
            for (var i = table.rows.length - 1; i > 0; i--) {
                table.deleteRow(i);
            }
            var data = { 'op': 'Get_DailyStoresValue' };
            var s = function (msg) {
                if (msg) {
                    var j = 1;
                    var k = 1;
                    var l = 0;
                    var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
                    for (var i = 0; i < msg.length; i++) {
                        var tablerowcnt = document.getElementById("tbl_Stores_value").rows.length;
                        $('#tbl_Stores_value').append('<tr style="background-color:' + COLOR[l] + '"><td data-title="sno">' + j + '</td><th scope="Category Name"   onclick="subcategoryproduct(\'' + msg[i].cat_code + '\');"><i class="fa fa-arrow-circle-right"  aria-hidden="true">&nbsp;&nbsp;&nbsp;&nbsp;' + msg[i].cat_code + '      ' + '</th><th scope="Category Name">' + msg[i].category + '</th><th><span id="spnmoniterqty"><span class="clsmoniterqty">' + msg[i].StoresValue + '</span></span></th></td></tr>');// class="badge bg-green"
                        j++;

                        l = l + 1;
                        if (l == 4) {
                            l = 0;
                        }

                        }
                    
                       var monitertot = "Total";
                       $('#tbl_Stores_value').append('<tr><td data-title="sno"></td><th scope="Category Name"></th><th><span id="spnmoniterqtyt" class="badge bg-yellow"><span class="clsmoniterqtyt">' + monitertot + '</span></span></th><th><span id="spnmonitertotal" class="badge bg-yellow"></span></th></td></tr>');
                       GetTotalCal3();
                   
          
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function GetDailyInwardValue() {
            var table1 = document.getElementById("tbl_Inward_value");
            for (var i = table1.rows.length - 1; i > 0; i--) {
                table1.deleteRow(i);
            }
            var data = { 'op': 'GetDailyInwardValue' };
            var s = function (msg) {
                if (msg) {
                    var j = 1;
                    intot = "Total";
                    for (var i = 0; i < msg.length; i++) {
                        var tablerowcnt = document.getElementById("tbl_Inward_value").rows.length;
                        $('#tbl_Inward_value').append('<tr><td data-title="sno">' + j + '</td><th  onclick="inwardproduct();"><i class="fa fa-arrow-circle-right"  aria-hidden="true">&nbsp;&nbsp;&nbsp;&nbsp;<span id="spninqty"><span class="clsinqty">' + msg[i].InValue + '</span></span></th></td></tr>');// class="badge bg-green"
                        j++
                    }
                    $('#tbl_Inward_value').append('<tr><td data-title="sno">' + intot + '</td><th><span id="spnintotal" class="badge bg-yellow"></span></th></td></tr>');
                    GetTotalCal();

                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        function inwardproduct()
        {
            var data = { 'op': 'get_inward_DataDashboard' };
            var s = function (msg) {
                if (msg) {
                    $('#divMainAddNewRow').css('display', 'block');
                    $('#hiddeninward').css('display', 'none');
                    $('#hiddenoutward').css('display', 'none');

                    j = 1;
                    var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
                    results += '<thead><tr><th style="text-align:center;" scope="col">Reference No</th><th style="text-align:center;" scope="col">MRN No</th><th style="text-align:center;" scope="col">Inward Date</th><th style="text-align:center;" scope="col">Supplier Name</th></tr></thead></tbody>';

                    var k = 1;
                    var l = 0;
                    var COLOR = ["##87CEEB", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];

                    for (var i = 0; i < msg.length; i++) {
                        //var tablerowcnt = document.getElementById("tbl_Inward_value").rows.length;
                        //$('#tbl_Inward_value').append('<tr style="background-color:' + COLOR[l] + '"><td data-title="sno">' + j + '</td><th scope="Category Name"   onclick="show_InwardProductsData(\'' + msg[i].sno + '\');"><i class="fa fa-arrow-circle-right"  aria-hidden="true">&nbsp;&nbsp;&nbsp;&nbsp;' + msg[i].sno + '      ' + '</th><th scope="Category Name">' + msg[i].mrnno + '</th><th><span id="spnmoniterqty" class="badge bg-green"><span class="clsmoniterqty">' + msg[i].inwarddate + '</span></span></th><th><span id="spnmoniterqty" class="badge bg-green"><span class="clsmoniterqty">' + msg[i].suppliername + '</span></span></th></td></tr>');

                        results += '<tr style="background-color:' + COLOR[l] + '">';
                        results += '<td class="2">' + msg[i].sno + '</td>';
                        results += '<td class="3">' + msg[i].mrnno + '</td>';
                        results += '<td class="4">' + msg[i].inwarddate + '</td>';
                        results += '<td class="5">' + msg[i].suppliername + '</td>';

                        j++;

                        l = l + 1;
                        if (l == 4) {
                            l = 0;
                        }

                    }
                    results += '</table></div>';
                    $("#ShowCategoryData").html(results);
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        function GetDailyOutwardValue() {
            var table2 = document.getElementById("tbl_Outward_Value");
            for (var i = table2.rows.length - 1; i > 0; i--) {
                table2.deleteRow(i);
            }
            var data = { 'op': 'GetDailyOutwardValue' };
            var s = function (msg) {
                if (msg) {
                    var j = 1;
                    outtot = "Total";
                    for (var i = 0; i < msg.length; i++) {
                        var tablerowcnt = document.getElementById("tbl_Outward_Value").rows.length;
                        $('#tbl_Outward_Value').append('<tr><td data-title="sno">' + j + '</td><th onclick="issueproduct();"><i class="fa fa-arrow-circle-right"  aria-hidden="true">&nbsp;&nbsp;&nbsp;&nbsp;<span id="spnoutqty"><span class="clsoutqty">' + msg[i].OutValue + '</span></span></tr>');// class="badge bg-green"
                        j++;
                    }
                    $('#tbl_Outward_Value').append('<tr><td data-title="sno" >' + outtot + '</td><th><span id="spnouttotal" class="badge bg-yellow"></span></th></td></tr>');
                    GetTotalCal1();

                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        function issueproduct() {
            var data = { 'op': 'get_issue_DataDashboard' };
            var s = function (msg) {
                if (msg) {
                    $('#divMainAddNewRow').css('display', 'block');
                    $('#hiddeninward').css('display', 'none');
                    $('#hiddenoutward').css('display', 'none');

                    j = 1;
                    var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
                    results += '<thead><tr><th style="text-align:center;" scope="col">Issue No</th><th style="text-align:center;" scope="col">Issue Date</th><th style="text-align:center;" scope="col">Supplier Name</th></tr></thead></tbody>';

                    var k = 1;
                    var l = 0;
                    var COLOR = ["##87CEEB", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];

                    for (var i = 0; i < msg.length; i++) {
                        //var tablerowcnt = document.getElementById("tbl_Inward_value").rows.length;
                        //$('#tbl_Inward_value').append('<tr style="background-color:' + COLOR[l] + '"><td data-title="sno">' + j + '</td><th scope="Category Name"   onclick="show_InwardProductsData(\'' + msg[i].sno + '\');"><i class="fa fa-arrow-circle-right"  aria-hidden="true">&nbsp;&nbsp;&nbsp;&nbsp;' + msg[i].sno + '      ' + '</th><th scope="Category Name">' + msg[i].mrnno + '</th><th><span id="spnmoniterqty" class="badge bg-green"><span class="clsmoniterqty">' + msg[i].inwarddate + '</span></span></th><th><span id="spnmoniterqty" class="badge bg-green"><span class="clsmoniterqty">' + msg[i].suppliername + '</span></span></th></td></tr>');

                        results += '<tr style="background-color:' + COLOR[l] + '">';
                        results += '<td class="2">' + msg[i].sno + '</td>';
                        results += '<td class="3">' + msg[i].inwarddate + '</td>';
                        results += '<td class="4">' + msg[i].sectionname + '</td>';

                        j++;

                        l = l + 1;
                        if (l == 4) {
                            l = 0;
                        }

                    }
                    results += '</table></div>';
                    $("#ShowCategoryData").html(results);
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        function GetTotalCal() {
            var totalinquantity = 0;
            $('.clsinqty').each(function (i, obj) {
                var qtyclass = $(this).text();
                if (qtyclass == "" || qtyclass == "0") {
                }
                else {
                    totalinquantity += parseFloat(qtyclass);
                }

            });
            document.getElementById('spnintotal').innerHTML = parseFloat(totalinquantity).toFixed(2);
        }
        function GetTotalCal1() {
            var totaloutquantity = 0;
            $('.clsoutqty').each(function (i, obj) {
                var qtyclass1 = $(this).text();
                if (qtyclass1 == "" || qtyclass1 == "0") {
                }
                else {
                    totaloutquantity += parseFloat(qtyclass1);
                }

            });

            document.getElementById('spnouttotal').innerHTML = parseFloat(totaloutquantity).toFixed(2);
        }
        function GetTotalCal3() {
            var totalmoniterquantity = 0;
            $('.clsmoniterqty').each(function (i, obj) {
                var qtyclass2 = $(this).text();
                if (qtyclass2 == "" || qtyclass2 == "0") {
                }
                else {
                    totalmoniterquantity += parseFloat(qtyclass2);
                }

            });

            document.getElementById('spnmonitertotal').innerHTML = parseFloat(totalmoniterquantity).toFixed(2);
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
                <!-- AREA CHART -->
                <div class="box box-primary">
                    <div class="box-header">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>TotalStores Value</h3>
                        <div class="box-tools pull-right">
                            <button class="btn btn-box-tool" data- widget="collapse">
                                <i class="fa fa-minus"></i>
                            </button>
                        </div>
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
                                        Category Code
                                    </th>
                                    <th>
                                        Category
                                    </th>
                                    <th>
                                        Stores Value
                                    </th>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-6" id="hiddeninward">
                <!-- AREA CHART -->
                <div class="box box-success">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Daily Inward Details</h3>
                        <div class="box-tools pull-right">
                            <button class="btn btn-box-tool" data- widget="collapse">
                                <i class="fa fa-minus"></i>
                            </button>
                        </div>
                    </div>
                    <div class="box-body">
                        <div class="box-body no-padding">
                            <table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-
                                describedby="example2_info" id="tbl_Inward_value">
                                <tr>
                                    <th style="width: 10px">
                                        #
                                    </th>
                                    <th>
                                        Inward Value
                                    </th>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-6" id="hiddenoutward">
                <div class="box box-danger">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Daily Issue Details
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
                                        Issue Value
                                    </th>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <div id="divMainAddNewRow" class="pickupclass" style="text-align: center; height: 100%;
                width: 100%; position: absolute; display: none; left: 0%; top: 0%; z-index: 99999;
                background: rgba(192, 192, 192, 0.7);">
                <div id="divAddNewRow" style="border: 5px solid #A0A0A0; position: absolute; top: 8%;
                    background-color: White; left: 10%; right: 10%; width: 80%;  -webkit-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                    -moz-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65); box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                    border-radius: 10px 10px 10px 10px;">
                    <table align="left" cellpadding="0" cellspacing="0" style="float: left; width: 100%;"
                        id="tableCollectionDetails" class="mainText2" border="1">
                        <tr>
                            <td colspan="2">
                                <div id="ShowCategoryData">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <input type="button" class="btn btn-danger" id="close_vehmaster" value="Close" onclick="CloseClick();" />
                            </td>
                        </tr>
                    </table>
                </div>
                <div id="divclose" style="width: 35px; top: 7.5%; right: 10%; position: absolute;
                    z-index: 99999; cursor: pointer;">
                    <img src="Images/Close.png" alt="close" width="100%" height="100%" onclick="CloseClick();" />
                </div>
            </div>

            <div id="divMainAddNewRow1" class="pickupclass" style="text-align: center; height: 100%;
                width: 100%; position: absolute; display: none; left: 0%; top: 0%; z-index: 99999;
                background: rgba(192, 192, 192, 0.7);">
                <div id="div2" style="border: 5px solid #A0A0A0; position: absolute; top: 8%;
                    background-color: White; left: 10%; right: 10%; width: 80%; height: 100%; -webkit-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                    -moz-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65); box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                    border-radius: 10px 10px 10px 10px;">
                    <table align="left" cellpadding="0" cellspacing="0" style="float: left; width: 100%;"
                        id="table1" class="mainText3" border="1">
                        <tr>
                            <td colspan="2">
                                <div id="div_productdetails">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <input type="button" class="btn btn-danger" id="btn_prod_det_close" value="Close" onclick="CloseClick_prod_det_close();" />
                            </td>
                        </tr>
                    </table>
                </div>
                <div id="div_prod_det_close" style="width: 35px; top: 7.5%; right: 10%; position: absolute;
                    z-index: 99999; cursor: pointer;">
                    <img src="Images/Close.png" alt="close" width="100%" height="100%" onclick="CloseClick_prod_det_close();" />
                </div>
            </div>
        </div>
    </section>
</asp:Content>
