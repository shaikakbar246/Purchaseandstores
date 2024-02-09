<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true"
    CodeFile="chartdashboard.aspx.cs" Inherits="chartdashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script src="https://www.amcharts.com/lib/3/amcharts.js"></script>
    <script src="https://www.amcharts.com/lib/3/serial.js"></script>
    <script src="https://www.amcharts.com/lib/3/plugins/export/export.min.js"></script>
    <link rel="stylesheet" href="https://www.amcharts.com/lib/3/plugins/export/export.css"
        type="text/css" media="all" />
    <script src="https://www.amcharts.com/lib/3/themes/light.js"></script>
    <script src="https://www.amcharts.com/lib/3/pie.js"></script>
    <script type="text/javascript">
        $(function () {
            document.getElementById('slct_branch').selectedIndex = 0;
            GetDailyStoresValue();
            Getinwardvaluedetails();
            Getoutwardvaluedetails();
            Getproductcountdetails();
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

        function Getproductcountdetails() {
            var branch = document.getElementById('slct_branch').value;
            var data = { 'op': 'get_productcountdetails', 'branch': branch };
            var s = function (msg) {
                if (msg) {
                    for (var i = 0; i < msg.length; i++) {
                        document.getElementById('lbltotalproducts').innerHTML = msg[i].productcount;
                        document.getElementById('lbllowstock').innerHTML = msg[i].lowstockcount;
                        document.getElementById('lblzerostock').innerHTML = msg[i].zerostockcount;
                        document.getElementById('lblmoststock').innerHTML = msg[i].morestockcount;
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

        var category_data = [];
        function GetDailyStoresValue() {
            var branch = document.getElementById('slct_branch').value;
            var data = { 'op': 'get_catagirywise_value', 'branch': branch };
            var s = function (msg) {
                if (msg) {
                    document.getElementById('slct_branch').value = msg[0].branchid;
                    var branchid = msg[0].branchid;
                    fillpiechart(msg);
                    filldata(msg);
                    category_data = msg;
                    if (branchid == "2") {
                        $('#a_po').text("Click Here To Raise PO for Punabaka");
                    }
                    else if (branchid == "4") {
                        $('#a_po').text("Click Here To Raise PO for Chennai");
                    }
                    else if (branchid == "35") {
                        $('#a_po').text("Click Here To Raise PO for Manapakkam");
                    }
                    else if (branchid == "1040") {
                        $('#a_po').text("Click Here To Raise PO for Kuppam");
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
        function GetTotalCal3() {
            var totalmoniterquantity = 0;
            $('.clsmoniterqty').each(function (i, obj) {
                var qtyclass2 = $(this).text();
                if (qtyclass2 == "" || qtyclass2 == "0") {
                }
                else {
                    totalmoniterquantity += parseFloat(qtyclass2) || 0;
                }

            });

            document.getElementById('spnmonitertotal').innerHTML = parseFloat(totalmoniterquantity).toFixed(2);
        }
        function filldata(data) {
            var table = document.getElementById("tbl_Stores_value");
            for (var i = table.rows.length - 1; i > 0; i--) {
                table.deleteRow(i);
            }
            var catvalue = data[0].Amount;
            var categoryname = data[0].RouteName;
            var catcode = data[0].catcode;
            if (categoryname != undefined) {
                var j = 1;
                var k = 1;
                var l = 0;
                var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
                for (var i = 0; i < categoryname.length; i++) {
                    var tablerowcnt = document.getElementById("tbl_Stores_value").rows.length;
                    var cat_value = parseFloat(catvalue[i]).toFixed(2) || 0;
                    $('#tbl_Stores_value').append('<tr style="background-color:' + COLOR[l] + '"><td data-title="sno">' + j + '</td><td class="tdmaincls" scope="Category Name"   onclick="subcategoryproduct(\'' + catcode[i] + '\');"><i class="fa fa-arrow-circle-right"  aria-hidden="true">&nbsp;&nbsp;&nbsp;&nbsp;' + catcode[i] + '      ' + '</td><td class="tdmaincls" scope="Category Name">' + categoryname[i] + '</td><td class="tdmaincls"><div style="text-align: right; width:50%;"><span class="clsmoniterqty">' + cat_value + '</span></div></td></tr>'); // class="badge bg-green"
                    j++;

                    l = l + 1;
                    if (l == 4) {
                        l = 0;
                    }
                }
                var monitertot = "Total";
                $('#tbl_Stores_value').append('<tr><td data-title="sno"></td><th></th><th><span id="spnmoniterqtyt" class="badge bg-yellow"><span class="clsmoniterqtyt">' + monitertot + '</span></span></th><th><div style="text-align: right; width:50%;"><span id="spnmonitertotal" class="badge bg-yellow"></span></div></th></td></tr>');
                GetTotalCal3();

            }
        }
        function subcategoryproduct(category) {
            var branchid = document.getElementById('slct_branch').value;
            var category;
            var data = { 'op': 'subcategoryvalues', 'category': category, 'branch': branchid };
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
        function fillcategoryvalues(msg) {
            scrollTo(0, 0);
            $('#divMainAddNewRow').css('display', 'block');
            j = 1;
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';// style="width:128% !important;max-width: 128% !important;"
            results += '<thead><tr><th style="text-align:center;" scope="col">Sno</th><th scope="col">Item Name</th><th style="text-align:center;" scope="col">MinStock</th><th style="text-align:center;" scope="col">MaxStock</th><th style="text-align:center;" scope="col">Quantity</th><th style="text-align:center;" scope="col">Price</th><th style="text-align:center;" scope="col">Value</th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            //var COLOR = ["##87CEEB", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '"><th scope="row" class="1" style="text-align:center;width:53px;">' + j + '</th>';
                //results += '<td class="2" onclick="productdetails(\'' + msg[i].productid + '\');"><i class="fa fa-arrow-circle-right"  aria-hidden="true"></td>';
                results += '<td class="2" style="text-align: left;cursor:pointer;width:239px;" onclick="productdetails(\'' + msg[i].productid + '\');">' + msg[i].productname + '</td>';
                results += '<td class="4" style="width:96px;">' + msg[i].minstock + '</td>';
                results += '<td class="4" style="width:98px;">' + msg[i].maxstock + '</td>';
                results += '<td class="4" style="width:100px;"><div style="float: right; padding-right:20%;">' + parseFloat(msg[i].qty).toFixed(2) + '</div></td>';
                results += '<td class="3" style="width:98px;"><div style="float: right; padding-right:20%;">' + parseFloat(msg[i].price).toFixed(2) + '</div></td>';
                results += '<td class="tammountcls" style="width:70px;" ><div style="float: right; padding-right:20%;">' + parseFloat(msg[i].StoresValue).toFixed(2) + '</div></td><tr>';

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
            //results += '<td data-title="brandstatus" class="8"></td>';
            results += '<td data-title="brandstatus" class="5"><span id="totalcls" class="badge bg-yellow"></span></td></tr>';
            results += '</table></div>';
            $("#ShowCategoryData").html(results);
            GettotalclsCal();
        }

        function productdetails(productid) {
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
            results += '<thead><tr style="background: #5aa4d0;"><th style="text-align:center;" scope="col">Sno</th><th style="text-align:center;" scope="col">Item Name</th><th style="text-align:center;" scope="col">UOM</th><th style="text-align:center;" scope="col">Product Code</th><th style="text-align:center;" scope="col">Category</th><th style="text-align:center;" scope="col">Sub Category</th><th style="text-align:center;" scope="col">SKU</th><th style="text-align:center;" scope="col">Supplier Name</th><th style="text-align:center;" scope="col">Item Code</th></tr></thead></tbody>';

            var k = 1;
            var l = 0;
            //var COLOR = ["##87CEEB", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
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

        function product_details(productid) {
            var data = { 'op': 'get_product_details_id', 'productid': productid };
            var s = function (msg) {
                if (msg) {
                    if (msg) {
                        $('#divMainAddNewRow1').css('display', 'none');
                        fill_product_details(msg);
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

        function fill_product_details(msg) {
            $('#divMainAddNewRow2').css('display', 'block');
            j = 1;
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr style="background: #5aa4d0;"><th style="text-align:center;" scope="col">Sno</th><th style="text-align:center;" scope="col">Item Name</th><th style="text-align:center;" scope="col">UOM</th><th style="text-align:center;" scope="col">Product Code</th><th style="text-align:center;" scope="col">Category</th><th style="text-align:center;" scope="col">Sub Category</th><th style="text-align:center;" scope="col">SKU</th><th style="text-align:center;" scope="col">Supplier Name</th><th style="text-align:center;" scope="col">Item Code</th></tr></thead></tbody>';

            var k = 1;
            var l = 0;
            //var COLOR = ["##87CEEB", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
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
            $("#div_product_details").html(results);
        }

        function CloseClick_prod_det_close() {
            $('#divMainAddNewRow1').css('display', 'none');
            $('#divMainAddNewRow').css('display', 'block');
            $('#hiddeninward').css('display', 'block');
            $('#hiddenoutward').css('display', 'block');
        }
        function divallproducts_close() {
            $('#divallproducts').css('display', 'none');
            $('#divhighstockproducts').css('display', 'none');
            $('#divlowstockproducts').css('display', 'none');
            $('#divzeroproducts').css('display', 'none');
            $('#div_all_products_data').css('display', 'none');
        }
        function divnward_list_data_close() {
            $('#divallproducts').css('display', 'none');
            $('#divhighstockproducts').css('display', 'block');
            $('#divlowstockproducts').css('display', 'none');
            $('#divzeroproducts').css('display', 'none');
            $('#div_inward_list').css('display', 'none');
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

        function printclick() {

        }

        function CloseClick_prod_det_close1() {
            $('#divMainAddNewRow2').css('display', 'none');
        }
        function CloseClick_supplier_det_close() {
            $('#divMainAddNewRow3').css('display', 'none');
        }

        function getmaxstockproductsinfo() {
            var branch = document.getElementById('slct_branch').value;
            var data = { 'op': 'getallproductsinfo', 'branch': branch };
            var s = function (msg) {
                if (msg) {
                    if (msg) {
                        $('#divMainAddNewRow1').css('display', 'none');
                        $('#divMainAddNewRow').css('display', 'none');
                        fillmaxstockproductinfo(msg);
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
        function fillmaxstockproductinfo(msg) {
            $('#divMainAddNewRow1').css('display', 'none');
            $('#divallproducts').css('display', 'none');
            $('#divhighstockproducts').css('display', 'block');
            $('#divlowstockproducts').css('display', 'none');
            $('#divzeroproducts').css('display', 'none');
            j = 1;
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            //results += '<thead><tr><th style="text-align:center;" scope="col">Sno</th><th style="text-align:center;" scope="col">Item Code</th><th scope="col">Category</th><th scope="col">Item Name</th><th scope="col">Max Stock</th><th scope="col">Qty</th><th scope="col">Price</th><th scope="col">UOM</th><th scope="col">SKU</th><th scope="col">Supplier Name</th><th scope="col"></th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            for (var i = 0; i < msg.length; i++) {
                var moniterqty = parseFloat(msg[i].moniterqty);
                var maxstock = parseFloat(msg[i].maxstock);
                if (moniterqty > maxstock) {
                    results += '<tr style="background-color:' + COLOR[l] + '"><th scope="row" class="1" style="text-align:center;width:50px;">' + j + '</th>';
                    results += '<td onclick="inwarddetails(\'' + msg[i].productid + '\');" class="8" style="width:73px;">' + msg[i].itemcode + '</td>';
                    results += '<td class="5" style="width:97px;">' + msg[i].category + '</td>';
                    results += '<td onclick="product_details(\'' + msg[i].productid + '\');" class="2" style="width:136px;cursor:pointer;">' + msg[i].productname + '</td>';
                    results += '<td class="3" style="width:59px;">' + msg[i].maxstock + '</td>';
                    results += '<td class="3" style="width:63px;">' + msg[i].moniterqty + '</td>';
                    results += '<td class="4" style="width:91px;">' + msg[i].price + '</td>';
                    results += '<td class="6" style="width:67px;">' + msg[i].uim + '</td>';
                    results += '<td class="7" style="width:84px;">' + msg[i].sku + '</td>';
                    results += '<td onclick="get_supplier_data(\'' + msg[i].supplierid + '\');" style="cursor:pointer;" class="8">' + msg[i].suppliername + '</td>';
                    results += '<tr>';
                    j++;
                    l = l + 1;
                    if (l == 4) {
                        l = 0;
                    }
                }
            }
            results += '</table></div>';
            $("#divhighstock").html(results);
        }

        function get_supplier_data(supplierid)
        {
            var data = { 'op': 'get_supplier_details_id', 'supplierid': supplierid };
            var s = function (msg) {
                if (msg) {
                    if (msg) {
                        fill_supplier_details(msg);
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

        function fill_supplier_details(msg)
        {
            //$('#divMainAddNewRow1').css('display', 'none');
            //$('#divMainAddNewRow2').css('display', 'none');
            //$('#divallproducts').css('display', 'none');
            //$('#divhighstockproducts').css('display', 'none');
            //$('#divlowstockproducts').css('display', 'none');
            //$('#divzeroproducts').css('display', 'none');
            //$('#div_all_products_data').css('display', 'none');
            //$('#hiddeninward').css('display', 'none');
            //$('#hiddenoutward').css('display', 'none');
            $('#divMainAddNewRow3').css('display', 'block');
            j = 1;
            var results = '<div><table class="responsive-table">';// style="width: 126% !important;"
            results += '<thead><tr style="background: #5aa4d0;"><th style="text-align:center;">Supplier Name</th><th style="text-align:center;">Contact Name</th><th style="text-align:center;">Contact Number</th><th style="text-align:center;">Email ID</th><th style="text-align:center;">Supplier Code</th></tr></thead></tbody>';//<th style="text-align:center;" scope="col">Supplier Address</th>
            var k = 1;
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];

            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">';
                results += '<td scope="row" class="1">' + msg[i].suppliername + '</td>';
                results += '<td style="display:none;" class="2">' + msg[i].street1 + ", " + msg[i].city + ", " + msg[i].state + '</td>';
                results += '<td class="3">' + msg[i].contactnumber + '</td>';
                results += '<td class="4">' + msg[i].mobileno + '</td>';
                results += '<td class="5">' + msg[i].emailid + '</td>';
                results += '<td class="6">' + msg[i].vendorcode + '</td>';
                results += '<td style="display:none;"  class="7">' + msg[i].supplierid + '</td>';

                l = l + 1;
                if (l == 4) {
                    l = 0;
                }

            }
            results += '</table></div>';
            $("#div_supplier_details").html(results);
        }

        function inwarddetails(productid) {
            var data = { 'op': 'get_inward_details_productid', 'productid': productid };
            var s = function (msg) {
                if (msg) {
                    if (msg) {
                        fillinwarddetails(msg);
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

        function fillinwarddetails(msg) {
            $('#divMainAddNewRow1').css('display', 'none');
            $('#divallproducts').css('display', 'none');
            $('#divhighstockproducts').css('display', 'block');
            $('#div_inward_list').css('display', 'block');
            $('#divlowstockproducts').css('display', 'none');
            $('#divzeroproducts').css('display', 'none');
            j = 1;
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr><th style="text-align:center;" scope="col">Sno</th><th style="text-align:center;" scope="col">Product Name</th><th scope="col">Inward Date</th><th scope="col">Quantity</th><th scope="col">Per Unit Price</th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var COLOR = ["##87CEEB", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            for (var i = msg.length - 1; i >= 0; i--) {
                results += '<tr style="background-color:' + COLOR[l] + '"><th scope="row" class="1" style="text-align:center;">' + j + '</th>';
                results += '<td class="9">' + msg[i].productname + '</td>';
                results += '<td class="2">' + msg[i].inword_refno + '</td>';
                results += '<td class="5">' + msg[i].quantity + '</td>';
                results += '<td class="3">' + msg[i].PerUnitRs + '</td>';
                results += '<td style="display:none" class="4">' + msg[i].hdnproductsno + '</td>';
                results += '<tr>';
                j++;
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_inward_list_data").html(results);
        }

        function getlowstockproductsinfo() {
            var branch = document.getElementById('slct_branch').value;
            var data = { 'op': 'getallproductsinfo', 'branch': branch };
            var s = function (msg) {
                if (msg) {
                    if (msg) {
                        $('#divMainAddNewRow1').css('display', 'none');
                        $('#divMainAddNewRow').css('display', 'none');
                        filllowStockproductinfo(msg);
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
        function filllowStockproductinfo(msg) {
            $('#divMainAddNewRow1').css('display', 'none');
            $('#divallproducts').css('display', 'none');
            $('#divhighstockproducts').css('display', 'none');
            $('#divlowstockproducts').css('display', 'block');
            $('#divzeroproducts').css('display', 'none');
            j = 1;
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            //results += '<thead><tr><th style="text-align:center;" scope="col">Sno</th><th style="text-align:center;" scope="col">Item Code</th><th scope="col">Category</th><th scope="col">Item Name</th><th scope="col">Min Stock</th><th scope="col">Qty</th><th scope="col">Price</th><th scope="col">UOM</th><th scope="col">SKU</th><th scope="col">Supplier Name</th><th scope="col"></th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            for (var i = 0; i < msg.length; i++) {
                var moniterqty = parseFloat(msg[i].moniterqty);
                var minstock = parseFloat(msg[i].minstock);
                if (moniterqty < minstock && moniterqty > 0) {
                    results += '<tr style="background-color:' + COLOR[l] + '"><th scope="row" class="1" style="text-align:center;width:42px;">' + j + '</th>';
                    results += '<td class="8" style="width:73px;">' + msg[i].itemcode + '</td>';
                    results += '<td class="5" style="width:97px;">' + msg[i].category + '</td>';
                    results += '<td class="2" onclick="product_details(\'' + msg[i].productid + '\');" style="width:138px;cursor:pointer;">' + msg[i].productname + '</td>';
                    results += '<td class="5" style="width:52px;">' + msg[i].minstock + '</td>';
                    results += '<td class="3" style="width:56px;">' + msg[i].moniterqty + '</td>';
                    results += '<td class="4" style="width:77px;">' + msg[i].price + '</td>';
                    results += '<td class="6" style="width:67px;">' + msg[i].uim + '</td>';
                    results += '<td class="7" style="width:78px;">' + msg[i].sku + '</td>';
                    results += '<td onclick="get_supplier_data(\'' + msg[i].supplierid + '\');" style="cursor:pointer;" class="8">' + msg[i].suppliername + '</td>';
                    results += '<tr>';

                    j++;
                    l = l + 1;
                    if (l == 4) {
                        l = 0;
                    }
                }
            }
            results += '</table></div>';
            $("#divlowstock").html(results);
        }

        function getzerostockproductsinfo() {
            var branch = document.getElementById('slct_branch').value;
            var data = { 'op': 'getallproductsinfo', 'branch': branch };
            var s = function (msg) {
                if (msg) {
                    if (msg) {
                        $('#divMainAddNewRow1').css('display', 'none');
                        $('#divMainAddNewRow').css('display', 'none');
                        fillzerostockproductinfo(msg);
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
        function fillzerostockproductinfo(msg) {
            $('#divMainAddNewRow1').css('display', 'none');
            $('#divallproducts').css('display', 'none');
            $('#divhighstockproducts').css('display', 'none');
            $('#divlowstockproducts').css('display', 'none');
            $('#divzeroproducts').css('display', 'block');
            j = 1;
            var results = '<div ><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            //results += '<thead><tr><th style="text-align:center;" scope="col">Sno</th><th style="text-align:center;" scope="col">Item Code</th><th scope="col">Category</th><th scope="col">Item Name</th><th scope="col">Qty</th><th scope="col">Price</th><th scope="col">UOM</th><th scope="col">SKU</th><th scope="col">Supplier Name</th><th scope="col"></th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            for (var i = 0; i < msg.length; i++) {
                var moniterqty = parseFloat(msg[i].moniterqty);
                if (moniterqty == 0) {
                    results += '<tr style="background-color:' + COLOR[l] + '"><th scope="row" class="1" style="text-align:center; width:50px;">' + j + '</th>';
                    results += '<td class="8" style="width:78px;">' + msg[i].itemcode + '</td>';
                    results += '<td class="5" style="width:97px;">' + msg[i].category + '</td>';
                    results += '<td class="2" onclick="product_details(\'' + msg[i].productid + '\');" style="width:210px;cursor:pointer;">' + msg[i].productname + '</td>';
                    results += '<td class="3" style="width:1px;">' + msg[i].moniterqty + '</td>';
                    results += '<td class="4" style="width:83px;">' + msg[i].price + '</td>';
                    results += '<td class="6" style="width:67px;">' + msg[i].uim + '</td>';
                    results += '<td class="7" style="width:80px;">' + msg[i].sku + '</td>';
                    results += '<td onclick="get_supplier_data(\'' + msg[i].supplierid + '\');" style="cursor:pointer;" class="8">' + msg[i].suppliername + '</td>';
                    results += '<tr>';

                    j++;
                    l = l + 1;
                    if (l == 4) {
                        l = 0;
                    }
                }
            }
            results += '</table></div>';
            $("#divzerostock").html(results);
        }

        function getallproductsinfo() {
            var branch = document.getElementById('slct_branch').value;
            var data = { 'op': 'getallproductsinfo', 'branch': branch };
            var s = function (msg) {
                if (msg) {
                    if (msg) {
                        $('#divMainAddNewRow1').css('display', 'none');
                        $('#divMainAddNewRow').css('display', 'none');
                        fillallproductinfo(msg);
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

        function fillallproductinfo(msg) {
            $('#divMainAddNewRow1').css('display', 'none');
            $('#divallproducts').css('display', 'block');
            $('#divhighstockproducts').css('display', 'none');
            $('#divlowstockproducts').css('display', 'none');
            $('#divzeroproducts').css('display', 'none');
            j = 1;
            var results = '<div ><table id="tbl_allproducts" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            var k = 1;
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            for (var i = 0; i < msg.length; i++) {
                var moniterqty = parseFloat(msg[i].moniterqty);
                if (moniterqty > 0)
                {
                    results += '<tr style="background-color:' + COLOR[l] + ';"><th scope="row" class="1" style="text-align:center; width:50px;">' + j + '</th>';
                    results += '<td class="8" style="width:73px;">' + msg[i].itemcode + '</td>';
                    results += '<td class="5" style="width:97px;">' + msg[i].category + '</td>';
                    results += '<td class="2" onclick="product_details(\'' + msg[i].productid + '\');" style="width:145px;cursor:pointer;">' + msg[i].productname + '</td>';
                    results += '<td class="3" style="width:70px;">' + msg[i].moniterqty + '</td>';
                    results += '<td class="4" style="width:91px;">' + msg[i].price + '</td>';
                    results += '<td class="6" style="width:67px;">' + msg[i].uim + '</td>';
                    results += '<td class="7" style="width:84px;">' + msg[i].sku + '</td>';
                    results += '<td onclick="get_supplier_data(\'' + msg[i].supplierid + '\');" style="cursor:pointer;" class="8">' + msg[i].suppliername + '</td>';
                    results += '</tr>';

                    j++;
                    l = l + 1;
                    if (l == 4) {
                        l = 0;
                    }
                }
            }
            results += '</table></div>';
            $("#divall").html(results);
        }

        function getallcombinedproductsinfo() {
            var branch = document.getElementById('slct_branch').value;
            var data = { 'op': 'getallproductsinfo_data', 'branch': branch };
            var s = function (msg) {
                if (msg) {
                    if (msg) {
                        $('#divMainAddNewRow1').css('display', 'none');
                        $('#divMainAddNewRow').css('display', 'none');
                        fillallcombinedproductinfo(msg);
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

        function fillallcombinedproductinfo(msg) {
            $('#divMainAddNewRow1').css('display', 'none');
            $('#divallproducts').css('display', 'none');
            $('#div_all_products_data').css('display', 'block');
            $('#divhighstockproducts').css('display', 'none');
            $('#divlowstockproducts').css('display', 'none');
            $('#divzeroproducts').css('display', 'none');
            j = 1;
            var results = '<div ><table id="tbl_allproducts" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            var k = 1;
            var l = 0;
            //var COLOR = ["##87CEEB", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + ';"><th scope="row" class="1" style="text-align:center; width:50px;">' + j + '</th>';
                results += '<td class="8" style="width:78px;">' + msg[i].itemcode + '</td>';
                results += '<td class="7" style="width:84px;">' + msg[i].sku + '</td>';
                results += '<td class="5" style="width:97px;">' + msg[i].category + '</td>';
                results += '<td class="5" style="width:114px;">' + msg[i].subcatname + '</td>';
                results += '<td class="2" onclick="branch_qty_data(' + msg[i].productid + ')" style="width:210px;cursor:pointer;">' + msg[i].productname + '</td>';
                results += '<td class="6" style="width:67px;">' + msg[i].uim + '</td>';
                results += '<td onclick="get_supplier_data(\'' + msg[i].supplierid + '\');" style="cursor:pointer;" class="8">' + msg[i].suppliername + '</td>';
                results += '</tr>';

                j++;
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#divalldata").html(results);
        }

        function branch_qty_data(productid)
        {
            var data = { 'op': 'getallbranchproductdata', 'productid': productid };
            var s = function (msg) {
                if (msg) {
                    if (msg) {
                        $('#divMainAddNewRow1').css('display', 'none');
                        $('#divMainAddNewRow').css('display', 'none');
                        fillbranch_qty_data(msg);
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

        function fillbranch_qty_data(msg)
        {
            $('#divMainAddNewRow1').css('display', 'none');
            $('#divallproducts').css('display', 'none');
            $('#div_all_products_data').css('display', 'none');
            $('#div_product_branch_data').css('display', 'block');
            $('#divhighstockproducts').css('display', 'none');
            $('#divlowstockproducts').css('display', 'none');
            $('#divzeroproducts').css('display', 'none');
            j = 1;
            var results = '<div ><table id="tbl_allproducts" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            var k = 1;
            var l = 0;
            //var COLOR = ["##87CEEB", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + ';border-bottom:1px;">';//<th scope="row" class="1" style="text-align:center; width:50px;">' + j + '</th>
                //results += '<td class="8" style="width:73px;">' + msg[i].itemcode + '</td>';
                //results += '<td class="7" style="width:84px;">' + msg[i].sku + '</td>';
                //results += '<td class="5" style="width:97px;">' + msg[i].category + '</td>';
                //results += '<td class="5" style="width:97px;">' + msg[i].subcatname + '</td>';
                results += '<td class="2" style="width:299px;border-right:1px solid;">' + msg[i].productname + '</td>';
                results += '<td class="6" style="width:141px;border-right:1px solid;">' + msg[i].punabaka_qty + '</td>';
                results += '<td class="6" style="width:135px;border-right:1px solid;">' + msg[i].chennai_qty + '</td>';
                results += '<td class="6" style="width:126px;border-right:1px solid;">' + msg[i].manapakkam_qty + '</td>';
                results += '<td class="8">' + msg[i].kuppam_qty + '</td>';
                results += '</tr>';

                j++;
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_branch_qty_data").html(results);
        }

        function div_branch_qty_data_close()
        {
            $('#div_product_branch_data').css('display', 'none');
            $('#div_all_products_data').css('display', 'block');
        }

        function fillpiechart(databind) {
            var xlabels = [];
            var yvalues = [];
            var newXarray = [];
            var cat_code = databind[0].catcode;
            var catvalue = databind[0].Amount;
            var categoryname = databind[0].RouteName;
            if (categoryname != undefined) {
                for (var i = 0; i < categoryname.length; i++) {
                    xlabels.push(categoryname[i]);
                    yvalues.push(parseInt(catvalue[i]));
                    newXarray.push({ "category": categoryname[i], "value": parseInt(catvalue[i]), "cat_code": cat_code[i] });
                }
            }
            var chart = AmCharts.makeChart("chartdiv", {
                "type": "pie",
                "theme": "light",
                "dataProvider": newXarray,
                "valueField": "value",
                "labelText": "[[title]]: [[value]]",
                "titleField": "category",
                "balloon": {
                    "fixedPosition": true
                },
                "export": {
                    "enabled": true
                },
                "listeners": [{
                    "event": "clickSlice",
                    "method": function (e) {
                        var dp = e.dataItem.dataContext.cat_code;
                        //if (dp[chart.colorField] === undefined)
                        //    dp[chart.colorField] = "#cc0000";
                        //else
                        //    dp[chart.colorField] = undefined;

                        //e.chart.validateData();
                        subcategoryproduct(dp);
                    }
                }]
            });
        }

        function subcategoryproduct_names(category) {
            var category;
            var data = { 'op': 'subcategoryvalues_name', 'category': category };
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

        function Getinwardvaluedetails() {
            var branch = document.getElementById('slct_branch').value;
            var data = { 'op': 'get_lastsixmonthsinward_value', 'branch': branch };
            var s = function (msg) {
                if (msg) {
                    fillbarcharts(msg)
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        function fillbarcharts(databind) {
            //-------------
            //- BAR CHART -
            //-------------
            var xlabels = [];
            var yvalues = [];
            var newXarray = [];
            var COLOR = ["#4CAF50", "#913167", "#b7b83f", "#2f4074", "#67b7dc"];
            var catvalue = databind[0].Amount;
            var categoryname = databind[0].RouteName;
            if (categoryname != undefined) {
                for (var i = 0; i < categoryname.length; i++) {
                    xlabels.push(categoryname[i]);
                    yvalues.push(parseInt(catvalue[i]));
                    newXarray.push({ "category": categoryname[i], "color": COLOR[i], "value": parseInt(catvalue[i]) });
                }
            }
            var chart = AmCharts.makeChart("barchart", {
                "type": "serial",
                "theme": "light",
                "dataProvider": newXarray,
                "valueAxes": [{
                    "gridColor": "#FFFFFF",
                    "gridAlpha": 0.2,
                    "dashLength": 0
                }],
                "gridAboveGraphs": true,
                "startDuration": 1,
                "graphs": [{
                    "balloonText": "[[category]]: <b>[[value]]</b>",
                    "fillAlphas": 0.8,
                    "lineAlpha": 0.2,
                    "type": "column",
                    "colorField": "color",
                    "valueField": "value"
                }],
                "chartCursor": {
                    "categoryBalloonEnabled": false,
                    "cursorAlpha": 0,
                    "zoomable": false
                },
                "categoryField": "category",
                "categoryAxis": {
                    "gridPosition": "start",
                    "gridAlpha": 0,
                    "tickPosition": "start",
                    "tickLength": 10,
                    "labelRotation": 65
                },
                "seriesColors": ["#FF00FF", "#0041C2", "#800517"],
                "export": {
                    "enabled": true
                }
            });
        }

        function Getoutwardvaluedetails() {
            var branch = document.getElementById('slct_branch').value;
            var data = { 'op': 'get_lastsixmonthsoutward_value', 'branch': branch };
            var s = function (msg) {
                if (msg) {
                    fillmybarcharts(msg);
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function fillmybarcharts(databind) {
            //-------------
            //- BAR CHART -
            //-------------
            var COLOR = ["#4CAF50", "#913167", "#b7b83f", "#2f4074", "#67b7dc"];
            var xlabels = [];
            var yvalues = [];
            var newXarray = [];
            var catvalue = databind[0].Amount;
            var categoryname = databind[0].RouteName;
            if (categoryname != undefined) {
                for (var i = 0; i < categoryname.length; i++) {
                    xlabels.push(categoryname[i]);
                    yvalues.push(parseInt(catvalue[i]));
                    newXarray.push({ "category": categoryname[i], "color": COLOR[i], "value": parseInt(catvalue[i]) });
                }
            }

            var chart = AmCharts.makeChart("mychart", {
                "type": "serial",
                "theme": "light",
                "dataProvider": newXarray,
                "valueAxes": [{
                    "gridColor": "#FFFFFF",
                    "gridAlpha": 0.2,
                    "dashLength": 0
                }],
                "gridAboveGraphs": true,
                "startDuration": 1,
                "graphs": [{
                    "balloonText": "[[category]]: <b>[[value]]</b>",
                    "fillAlphas": 0.8,
                    "lineAlpha": 0.2,
                    "type": "column",
                    "colorField": "color",
                    "valueField": "value"
                }],
                "chartCursor": {
                    "categoryBalloonEnabled": false,
                    "cursorAlpha": 0,
                    "zoomable": false
                },
                "categoryField": "category",
                "categoryAxis": {
                    "gridPosition": "start",
                    "gridAlpha": 0,
                    "tickPosition": "start",
                    "tickLength": 10,
                    "labelRotation": 65
                },
                "seriesColors": ["#FF00FF", "#0041C2", "#800517"],
                "export": {
                    "enabled": true
                }
            });
        }


        // line chart

        //branchwise dashboard

        function get_branchwise_dashboard() {
            GetDailyStoresValue_branch();
            Getinwardvaluedetails();
            Getoutwardvaluedetails();
            Getproductcountdetails_branch();
        }

        function GetDailyStoresValue_branch() {
            var branch = document.getElementById('slct_branch').value;
            var data = { 'op': 'get_catagirywise_value_branch', 'branch': branch };
            var s = function (msg) {
                if (msg) {
                    fillpiechart(msg);
                    filldata(msg);
                    category_data = msg;
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        function Getinwardvaluedetails_branch() {
            var branch = document.getElementById('slct_branch').value;
            var data = { 'op': 'get_lastsixmonthsinward_value_branch', 'branch': branch };
            var s = function (msg) {
                if (msg) {
                    fillbarcharts(msg)
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        function Getoutwardvaluedetails_branch() {
            var branch = document.getElementById('slct_branch').value;
            var data = { 'op': 'get_lastsixmonthsoutward_value_branch', 'branch': branch };
            var s = function (msg) {
                if (msg) {
                    fillmybarcharts(msg);
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        function Getproductcountdetails_branch() {
            var branch = document.getElementById('slct_branch').value;
            var data = { 'op': 'get_productcountdetails_branch', 'branch': branch };
            var s = function (msg) {
                if (msg) {
                    for (var i = 0; i < msg.length; i++) {
                        document.getElementById('lbltotalproducts').innerHTML = msg[i].productcount;
                        document.getElementById('lbllowstock').innerHTML = msg[i].lowstockcount;
                        document.getElementById('lblzerostock').innerHTML = msg[i].zerostockcount;
                        document.getElementById('lblmoststock').innerHTML = msg[i].morestockcount;
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

        function get_category_names() {
            var branch = document.getElementById('slct_branch').value;
            var data = { 'op': 'get_category_names', 'branch': branch };
            var s = function (msg) {
                if (msg) {
                    fill_category_all(msg);
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        function fill_category_all(msg) {
            var categoryname = msg[0].RouteName;
            var catcode = msg[0].catcode;
            var results = '<div  style="overflow:auto;"><table id="tbl_allproducts" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr><th style="text-align:center;" scope="col">Sno</th><th style="text-align:center;" scope="col">Category Code</th><th scope="col">Category</th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var j = 1;
            var COLOR = ["##87CEEB", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            for (var i = 0; i < categoryname.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + ';"><th scope="row" class="1" style="text-align:center;">' + j + '</th>';
                results += '<td class="8" onclick="subcategory_data(' + catcode[i] + ')"><i class="fa fa-arrow-circle-right" title="Click Here" aria-hidden="true">&nbsp;&nbsp;&nbsp;&nbsp;' + catcode[i] + '</td>';
                results += '<td class="5">' + categoryname[i] + '</td>';
                results += '</tr>';

                j++;
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_category_all").show();
            $("#div_category_all_data").html(results);
        }

        function div_category_all_close() {
            $("#div_category_all").hide();
        }

        function subcategory_data(catcode) {
            var data = { 'op': 'get_subcategory_data_catcode', 'catcode': catcode };
            var s = function (msg) {
                if (msg) {
                    fill_sub_category_all(msg);
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        function fill_sub_category_all(msg) {
            var results = '<div  style="overflow:auto;"><table id="tbl_allproducts" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr><th style="text-align:center;" scope="col">Sno</th><th style="text-align:center;" scope="col">Sub Category Code</th><th scope="col">Sub Category</th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var j = 1;
            var COLOR = ["##87CEEB", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + ';"><th scope="row" class="1" style="text-align:center;">' + j + '</th>';
                results += '<td class="8" onclick="get_products_all(' + msg[i].sub_cat_code + ',' + msg[i].cat_code + ')"><i class="fa fa-arrow-circle-right" title="Click Here" aria-hidden="true">&nbsp;&nbsp;&nbsp;&nbsp;' + msg[i].sub_cat_code + '</td>';
                results += '<td class="5">' + msg[i].subcatname + '</td>';
                results += '</tr>';
                j++;
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_sub_category_all").show();
            $("#div_sub_category_all_data").html(results);
        }

        function div_sub_category_all_close() {
            $("#div_sub_category_all").hide();
        }

        function get_products_all(sub_cat_code, cat_code) {
            var data = { 'op': 'get_products_data_subcatcode', 'sub_cat_code': sub_cat_code, 'cat_code': cat_code };
            var s = function (msg) {
                if (msg) {
                    fillallproduct(msg);
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        function fillallproduct(msg) {
            $('#divMainAddNewRow1').css('display', 'none');
            $('#divallproducts').css('display', 'block');
            $('#divhighstockproducts').css('display', 'none');
            $('#divlowstockproducts').css('display', 'none');
            $('#divzeroproducts').css('display', 'none');
            j = 1;
            var results = '<div  style="overflow:auto;"><table id="tbl_allproducts" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr><th style="text-align:center;" scope="col">Sno</th><th style="text-align:center;" scope="col">Item Code</th><th scope="col">Category</th><th scope="col">Item Name</th><th scope="col">Qty</th><th scope="col">Price</th><th scope="col">UOM</th><th scope="col">SKU</th><th scope="col">Supplier Name</th><th scope="col"></th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var COLOR = ["##87CEEB", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            for (var i = 0; i < msg.length; i++) {
                var moniterqty = parseFloat(msg[i].moniterqty);
                if (moniterqty > 0)
                {
                    results += '<tr style="background-color:' + COLOR[l] + ';"><th scope="row" class="1" style="text-align:center;">' + j + '</th>';
                    results += '<td class="8">' + msg[i].itemcode + '</td>';
                    results += '<td class="5">' + msg[i].category + '</td>';
                    results += '<td class="2">' + msg[i].productname + '</td>';
                    results += '<td class="3">' + msg[i].moniterqty + '</td>';
                    results += '<td class="4">' + msg[i].price + '</td>';
                    results += '<td class="6">' + msg[i].uim + '</td>';
                    results += '<td class="7">' + msg[i].sku + '</td>';
                    results += '<td class="8">' + msg[i].suppliername + '</td>';
                    results += '<tr>';

                    j++;
                    l = l + 1;
                    if (l == 4) {
                        l = 0;
                    }
                }
            }
            results += '</table></div>';
            $("#divall").html(results);
        }

        function get_category_names_zero() {
            var branch = document.getElementById('slct_branch').value;
            var data = { 'op': 'get_category_names', 'branch': branch };
            var s = function (msg) {
                if (msg) {
                    fill_category_zero(msg);
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        function fill_category_zero(msg) {
            var categoryname = msg[0].RouteName;
            var catcode = msg[0].catcode;
            var results = '<div  style="overflow:auto;"><table id="tbl_allproducts" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr><th style="text-align:center;" scope="col">Sno</th><th style="text-align:center;" scope="col">Category Code</th><th scope="col">Category</th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var j = 1;
            var COLOR = ["##87CEEB", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            for (var i = 0; i < categoryname.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + ';"><th scope="row" class="1" style="text-align:center;">' + j + '</th>';
                results += '<td class="8" onclick="subcategory_data_zero(' + catcode[i] + ')"><i class="fa fa-arrow-circle-right" title="Click Here" aria-hidden="true">&nbsp;&nbsp;&nbsp;&nbsp;' + catcode[i] + '</td>';
                results += '<td class="5">' + categoryname[i] + '</td>';
                results += '</tr>';

                j++;
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_category_all").show();
            $("#div_category_all_data").html(results);
        }

        function subcategory_data_zero(catcode) {
            var data = { 'op': 'get_subcategory_data_catcode', 'catcode': catcode };
            var s = function (msg) {
                if (msg) {
                    fill_sub_category_zero(msg);
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        function fill_sub_category_zero(msg) {
            var results = '<div  style="overflow:auto;"><table id="tbl_allproducts" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr><th style="text-align:center;" scope="col">Sno</th><th style="text-align:center;" scope="col">Sub Category Code</th><th scope="col">Sub Category</th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var j = 1;
            var COLOR = ["##87CEEB", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + ';"><th scope="row" class="1" style="text-align:center;">' + j + '</th>';
                results += '<td class="8" onclick="get_products_zero(' + msg[i].sub_cat_code + ',' + msg[i].cat_code + ')"><i class="fa fa-arrow-circle-right" title="Click Here" aria-hidden="true">&nbsp;&nbsp;&nbsp;&nbsp;' + msg[i].sub_cat_code + '</td>';
                results += '<td class="5">' + msg[i].subcatname + '</td>';
                results += '</tr>';
                j++;
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_sub_category_all").show();
            $("#div_sub_category_all_data").html(results);
        }

        function get_products_zero(sub_cat_code, cat_code) {
            var data = { 'op': 'get_products_data_subcatcode', 'sub_cat_code': sub_cat_code, 'cat_code': cat_code };
            var s = function (msg) {
                if (msg) {
                    fillallproduct_zero(msg);
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        function fillallproduct_zero(msg) {
            $('#divMainAddNewRow1').css('display', 'none');
            $('#divallproducts').css('display', 'block');
            $('#divhighstockproducts').css('display', 'none');
            $('#divlowstockproducts').css('display', 'none');
            $('#divzeroproducts').css('display', 'none');
            j = 1;
            var results = '<div  style="overflow:auto;"><table id="tbl_allproducts" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr><th style="text-align:center;" scope="col">Sno</th><th style="text-align:center;" scope="col">Item Code</th><th scope="col">Category</th><th scope="col">Item Name</th><th scope="col">Qty</th><th scope="col">Price</th><th scope="col">UOM</th><th scope="col">SKU</th><th scope="col">Supplier Name</th><th scope="col"></th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var COLOR = ["##87CEEB", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            for (var i = 0; i < msg.length; i++) {
                var moniterqty = parseFloat(msg[i].moniterqty) || 0;
                if (moniterqty == 0) {
                    results += '<tr style="background-color:' + COLOR[l] + ';"><th scope="row" class="1" style="text-align:center;">' + j + '</th>';
                    results += '<td class="8">' + msg[i].itemcode + '</td>';
                    results += '<td class="5">' + msg[i].category + '</td>';
                    results += '<td class="2">' + msg[i].productname + '</td>';
                    results += '<td class="3">' + msg[i].moniterqty + '</td>';
                    results += '<td class="4">' + msg[i].price + '</td>';
                    results += '<td class="6">' + msg[i].uim + '</td>';
                    results += '<td class="7">' + msg[i].sku + '</td>';
                    results += '<td class="8">' + msg[i].suppliername + '</td>';
                    results += '<tr>';

                    j++;
                    l = l + 1;
                    if (l == 4) {
                        l = 0;
                    }
                }
            }
            results += '</table></div>';
            $("#divall").html(results);
        }

        function get_category_names_low() {
            var branch = document.getElementById('slct_branch').value;
            var data = { 'op': 'get_category_names', 'branch': branch };
            var s = function (msg) {
                if (msg) {
                    fill_category_low(msg);
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        function fill_category_low(msg) {
            var categoryname = msg[0].RouteName;
            var catcode = msg[0].catcode;
            var results = '<div  style="overflow:auto;"><table id="tbl_allproducts" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr><th style="text-align:center;" scope="col">Sno</th><th style="text-align:center;" scope="col">Category Code</th><th scope="col">Category</th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var j = 1;
            var COLOR = ["##87CEEB", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            for (var i = 0; i < categoryname.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + ';"><th scope="row" class="1" style="text-align:center;">' + j + '</th>';
                results += '<td class="8" onclick="subcategory_data_low(' + catcode[i] + ')"><i class="fa fa-arrow-circle-right" title="Click Here" aria-hidden="true">&nbsp;&nbsp;&nbsp;&nbsp;' + catcode[i] + '</td>';
                results += '<td class="5">' + categoryname[i] + '</td>';
                results += '</tr>';

                j++;
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_category_all").show();
            $("#div_category_all_data").html(results);
        }

        function subcategory_data_low(catcode) {
            var data = { 'op': 'get_subcategory_data_catcode', 'catcode': catcode };
            var s = function (msg) {
                if (msg) {
                    fill_sub_category_low(msg);
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        function fill_sub_category_low(msg) {
            var results = '<div  style="overflow:auto;"><table id="tbl_allproducts" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr><th style="text-align:center;" scope="col">Sno</th><th style="text-align:center;" scope="col">Sub Category Code</th><th scope="col">Sub Category</th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var j = 1;
            var COLOR = ["##87CEEB", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + ';"><th scope="row" class="1" style="text-align:center;">' + j + '</th>';
                results += '<td class="8" onclick="get_products_low(' + msg[i].sub_cat_code + ',' + msg[i].cat_code + ')"><i class="fa fa-arrow-circle-right" title="Click Here" aria-hidden="true">&nbsp;&nbsp;&nbsp;&nbsp;' + msg[i].sub_cat_code + '</td>';
                results += '<td class="5">' + msg[i].subcatname + '</td>';
                results += '</tr>';
                j++;
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_sub_category_all").show();
            $("#div_sub_category_all_data").html(results);
        }

        function get_products_low(sub_cat_code, cat_code) {
            var data = { 'op': 'get_products_data_subcatcode', 'sub_cat_code': sub_cat_code, 'cat_code': cat_code };
            var s = function (msg) {
                if (msg) {
                    fillallproduct_low(msg);
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        function fillallproduct_low(msg) {
            $('#divMainAddNewRow1').css('display', 'none');
            $('#divallproducts').css('display', 'block');
            $('#divhighstockproducts').css('display', 'none');
            $('#divlowstockproducts').css('display', 'none');
            $('#divzeroproducts').css('display', 'none');
            j = 1;
            var results = '<div  style="overflow:auto;"><table id="tbl_allproducts" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr><th style="text-align:center;" scope="col">Sno</th><th style="text-align:center;" scope="col">Item Code</th><th scope="col">Category</th><th scope="col">Item Name</th><th scope="col">Min Stock</th><th scope="col">Qty</th><th scope="col">Price</th><th scope="col">UOM</th><th scope="col">SKU</th><th scope="col">Supplier Name</th><th scope="col"></th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var COLOR = ["##87CEEB", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            for (var i = 0; i < msg.length; i++) {
                var minstock = parseFloat(msg[i].minstock);
                var moniterqty = parseFloat(msg[i].moniterqty) || 0;
                if (moniterqty < minstock && moniterqty > 0) {
                    results += '<tr style="background-color:' + COLOR[l] + ';"><th scope="row" class="1" style="text-align:center;">' + j + '</th>';
                    results += '<td class="8">' + msg[i].itemcode + '</td>';
                    results += '<td class="5">' + msg[i].category + '</td>';
                    results += '<td class="2">' + msg[i].productname + '</td>';
                    results += '<td class="3">' + msg[i].minstock + '</td>';
                    results += '<td class="3">' + msg[i].moniterqty + '</td>';
                    results += '<td class="4">' + msg[i].price + '</td>';
                    results += '<td class="6">' + msg[i].uim + '</td>';
                    results += '<td class="7">' + msg[i].sku + '</td>';
                    results += '<td class="8">' + msg[i].suppliername + '</td>';
                    results += '<tr>';

                    j++;
                    l = l + 1;
                    if (l == 4) {
                        l = 0;
                    }
                }
            }
            results += '</table></div>';
            $("#divall").html(results);
        }

        function get_category_names_max() {
            var branch = document.getElementById('slct_branch').value;
            var data = { 'op': 'get_category_names', 'branch': branch };
            var s = function (msg) {
                if (msg) {
                    fill_category_max(msg);
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        function fill_category_max(msg) {
            var categoryname = msg[0].RouteName;
            var catcode = msg[0].catcode;
            var results = '<div  style="overflow:auto;"><table id="tbl_allproducts" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr><th style="text-align:center;" scope="col">Sno</th><th style="text-align:center;" scope="col">Category Code</th><th scope="col">Category</th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var j = 1;
            var COLOR = ["##87CEEB", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            for (var i = 0; i < categoryname.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + ';"><th scope="row" class="1" style="text-align:center;">' + j + '</th>';
                results += '<td class="8" onclick="subcategory_data_max(' + catcode[i] + ')"><i class="fa fa-arrow-circle-right" title="Click Here" aria-hidden="true">&nbsp;&nbsp;&nbsp;&nbsp;' + catcode[i] + '</td>';
                results += '<td class="5">' + categoryname[i] + '</td>';
                results += '</tr>';

                j++;
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_category_all").show();
            $("#div_category_all_data").html(results);
        }

        function subcategory_data_max(catcode) {
            var data = { 'op': 'get_subcategory_data_catcode', 'catcode': catcode };
            var s = function (msg) {
                if (msg) {
                    fill_sub_category_max(msg);
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        function fill_sub_category_max(msg) {
            var results = '<div  style="overflow:auto;"><table id="tbl_allproducts" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr><th style="text-align:center;" scope="col">Sno</th><th style="text-align:center;" scope="col">Sub Category Code</th><th scope="col">Sub Category</th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var j = 1;
            var COLOR = ["##87CEEB", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + ';"><th scope="row" class="1" style="text-align:center;">' + j + '</th>';
                results += '<td class="8" onclick="get_products_max(' + msg[i].sub_cat_code + ',' + msg[i].cat_code + ')"><i class="fa fa-arrow-circle-right" title="Click Here" aria-hidden="true">&nbsp;&nbsp;&nbsp;&nbsp;' + msg[i].sub_cat_code + '</td>';
                results += '<td class="5">' + msg[i].subcatname + '</td>';
                results += '</tr>';
                j++;
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_sub_category_all").show();
            $("#div_sub_category_all_data").html(results);
        }

        function get_products_max(sub_cat_code, cat_code) {
            var data = { 'op': 'get_products_data_subcatcode', 'sub_cat_code': sub_cat_code, 'cat_code': cat_code };
            var s = function (msg) {
                if (msg) {
                    fillallproduct_max(msg);
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        function fillallproduct_max(msg) {
            $('#divMainAddNewRow1').css('display', 'none');
            $('#divallproducts').css('display', 'block');
            $('#divhighstockproducts').css('display', 'none');
            $('#divlowstockproducts').css('display', 'none');
            $('#divzeroproducts').css('display', 'none');
            j = 1;
            var results = '<div  style="overflow:auto;"><table id="tbl_allproducts" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr><th style="text-align:center;" scope="col">Sno</th><th style="text-align:center;" scope="col">Item Code</th><th scope="col">Category</th><th scope="col">Item Name</th><th scope="col">Max Stock</th><th scope="col">Qty</th><th scope="col">Price</th><th scope="col">UOM</th><th scope="col">SKU</th><th scope="col">Supplier Name</th><th scope="col"></th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var COLOR = ["##87CEEB", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            for (var i = 0; i < msg.length; i++) {
                var maxstock = parseFloat(msg[i].maxstock);
                var moniterqty = parseFloat(msg[i].moniterqty);
                if (moniterqty > maxstock) {
                    results += '<tr style="background-color:' + COLOR[l] + ';"><th scope="row" class="1" style="text-align:center;">' + j + '</th>';
                    results += '<td class="8">' + msg[i].itemcode + '</td>';
                    results += '<td class="5">' + msg[i].category + '</td>';
                    results += '<td class="2">' + msg[i].productname + '</td>';
                    results += '<td class="3">' + msg[i].maxstock + '</td>';
                    results += '<td class="3">' + msg[i].moniterqty + '</td>';
                    results += '<td class="4">' + msg[i].price + '</td>';
                    results += '<td class="6">' + msg[i].uim + '</td>';
                    results += '<td class="7">' + msg[i].sku + '</td>';
                    results += '<td class="8">' + msg[i].suppliername + '</td>';
                    results += '<tr>';

                    j++;
                    l = l + 1;
                    if (l == 4) {
                        l = 0;
                    }
                }
            }
            results += '</table></div>';
            $("#divall").html(results);
        }

    </script>
    <script type="text/javascript">
        function CallPrint(strid) {
            var divToPrint = document.getElementById(strid);
            var newWin = window.open('', 'Print-Window', 'width=400,height=400,top=100,left=100');
            newWin.document.open();
            newWin.document.write('<html><body   onload="window.print()">' + divToPrint.innerHTML + '</body></html>');
            newWin.document.close();
        }
    </script>
    <style type="text/css">
        #barchart
        {
            width: 100%;
            height: 300px;
            font-size: 11px;
            font-weight: 600;
        }

        #chartdiv
        {
            width: 100%;
            height: 500px;
            font-size: 11px;
            font-weight: 600;
        }

        #mychart
        {
            width: 100%;
            height: 300px;
            font-size: 11px;
            font-weight: 600;
        }

        #linechart
        {
        }

        #pieChart
        {
            width: 200px;
            height: 200px;
        }

        #header-fixed
        {
            position: fixed;
            top: 0px;
            display: none;
            background-color: white;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script>
        $('body').addClass('hold-transition sidebar-mini skin-blue-light sidebar-collapse')
    </script>
    <section class="content-header">
        <h1>
           Charts<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Chart Reports</a></li>
            <li><a href="#">Pie Chart</a></li>
        </ol>
    </section>
    <div style="text-align: center;">
        <a href="PurchaseOrder.aspx" id="a_po" style="text-decoration: underline; font-size: 16px;">Click Here To Rise PO </a>
    </div>
    <div style="text-align: center;">
        <span onclick="getallcombinedproductsinfo();" style="text-decoration: underline; font-size: 16px;cursor:pointer;color:#337aa8;">Click Here To Get All Branches Product Info</span>
    </div>
    <div style="padding-left: 2%">
        <table>
            <tr>
                <td></td>
                <td>
                  
                </td>
            </tr>
        </table>
    </div>
    <section class="content">
        <div class="box box-info">
            <div class="row">
            <div class="col-xs-12">
                <!-- interactive chart -->
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <i class="fa fa-bar-chart-o"></i>
                        <h3 class="box-title">
                            Product Info Details</h3>
                      &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp
                      &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp
                       <b>Select Branch :</b><select id="slct_branch" onchange="get_branchwise_dashboard()">
                        <option disabled value="">SELECT BRANCH</option>
                        <option value="All">All</option>
                        <option value="2">PUNABAKA</option>
                        <option value="4">CHENNAI</option>
                        <option value="35">MANAPAKKAM</option>
                        <option value="1040">KUPPAM</option>
                    </select>
                    
                    </div>
                    <div class="box-body">
                    <div class="row" >
                            <div class="col-lg-3 col-xs-6">
                                <!-- small box -->
                                <div class="small-box bg-aqua">
                                    <div class="inner">
                                             <h3>
                                             <label id="lbltotalproducts"  style="font-weight: 500;color:White!important;font-size:40px !important;"></label></h3>
                                        <p>
                                           Total Products</p>
                                    </div>
                                    <div class="icon">
                                        <i class="ion ion-bag"></i>
                                    </div>
                                    <a href="#" onclick="getallproductsinfo();" class="small-box-footer"> <i class="fa fa-arrow-circle-right"></i>
                                    </a>
                                </div>
                            </div>
                            <!-- ./col -->
                            <div class="col-lg-3 col-xs-6"> 
                                <!-- small box -->
                                <div class="small-box bg-green">
                                    <div class="inner">
                                        <h3>
                                            <label id="lbllowstock"  style="font-weight: 500; color:White!important;font-size:40px !important;"></label></h3>
                                        <p>
                                           Low Stock Products</p>
                                    </div>
                                    <div class="icon">
                                        <i class="ion ion-stats-bars"></i>
                                    </div>
                                    <a href="#" onclick="getlowstockproductsinfo();" class="small-box-footer"> <i class="fa fa-arrow-circle-right"></i>
                                    </a>
                                </div>
                            </div>
                            <!-- ./col -->
                            <div class="col-lg-3 col-xs-6">
                                <!-- small box -->
                                <div class="small-box bg-yellow">
                                    <div class="inner">
                                        <h3>
                                            <label id="lblzerostock"  style="font-weight: 500;color:White!important; font-size:40px !important;"></label></h3>
                                        <p>
                                            Zero Stock Products</p>
                                    </div>
                                    <div class="icon">
                                        <i class="ion ion-person-add"></i>  
                                    </div>
                                    <a href="#" onclick="getzerostockproductsinfo();" class="small-box-footer"> <i class="fa fa-arrow-circle-right"></i>
                                    </a>
                                </div>
                            </div>
                            <!-- ./col -->
                            <div class="col-lg-3 col-xs-6">
                                <!-- small box -->
                                <div class="small-box bg-red">
                                    <div class="inner">
                                        <h3>
                                            <label id="lblmoststock"  style="font-weight: 500;color:White!important; font-size:40px !important;"></label></h3>
                                        <p>
                                            Max Stock products</p>
                                    </div>
                                    <div class="icon">
                                        <i class="ion ion-pie-graph"></i>
                                    </div>
                                    <a href="#" onclick="getmaxstockproductsinfo();" class="small-box-footer"> <i class="fa fa-arrow-circle-right"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- /.box-body-->
                </div>
                <!-- /.box -->
            </div>
        </div>


            <div class="row">

            <div class="col-md-6" style="width:100%;">
            <div class="box box-primary" style="width: 100%;">
                 <div class="box-body">
                    <table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" id="tbl_Stores_value">
                        <tr>
                            <th style="width: 10px;">
                                #
                            </th>
                            <th>
                                Category Code
                            </th>
                            <th>
                                Category
                            </th>
                            <th>
                            <div style="text-align: right; width:50%;">
                                Stores Value
                                </div>
                            </th>
                        </tr>
                    </table>
                </div>
            </div>
            </div>

            <div class="col-md-6" style="width:100%;">
            <div class="box box-primary" style="width: 100%;">
                 <div class="box-header">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Category Wise Store Value</h3>
                    </div>
                 <div class="box-body">
                    <div id="chartdiv">
                    </div>
                </div>
            </div>
            </div>

            <div class="col-md-6">
            <div class="box box-primary" style="width:100%;">
                    <div class="box-header">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Monthly Inward Value</h3>
                    </div>
                 <div class="box-body">
                     <div id="barchart">
                     </div>
                    
                 </div>
            </div>
            </div>
            <div class="col-md-6">
            <div class="box box-primary" style="width:100%;">
            <div class="box-header">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Monthly Issue Value</h3>
                    </div>
                 <div class="box-body">
                    <div id="mychart">
                     </div>
                 </div>
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
                    <div id="divd">
                    <table align="left" cellpadding="0" cellspacing="0" style="float: left; width: 100%;"
                        id="tableCollectionDetails" class="mainText2" border="1">
                       
                        <tr>
                            <td colspan="7">
                                <div style="height:500px;overflow-y:auto;" id="ShowCategoryData">
                                </div>
                            </td>
                        </tr>
                    </table></div>
                    <table><tr>
                            <td colspan="3" style="text-align:center">
                                <input type="button" class="btn btn-danger" id="close_vehmaster" value="Close" onclick="CloseClick();" />
                            </td>
                           
                            <td style="text-align:center">
                             <span class="glyphicon glyphicon-print" onclick="javascript: CallPrint('divd');"></span> <span id="Span1" onclick="javascript: CallPrint('divd');">Print</span>
                            </td>
                            
                        </tr></table>
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
                    background-color: White; left: 10%; right: 10%; width: 80%; -webkit-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
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

            

            <div id="div_category_all" class="pickupclass" style="text-align: center; height: 100%;
                width: 100%; position: absolute; display: none; left: 0%; top: 0%; z-index: 99999;
                background: rgba(192, 192, 192, 0.7);">
                <div id="div7" style="border: 5px solid #A0A0A0; position: absolute; top: 8%;
                    background-color: White; left: 10%; right: 10%; width: 80%; -webkit-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                    -moz-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65); box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                    border-radius: 10px 10px 10px 10px;">
                    <table align="left" cellpadding="0" cellspacing="0" style="float: left; width: 100%;"
                        id="tbl_category_all" class="mainText3" border="1">
                        <tr>
                            <td colspan="2">
                                <div id="div_category_all_data">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <input type="button" class="btn btn-danger" id="Button6" value="Close" onclick="div_category_all_close();" />
                            </td>
                        </tr>
                    </table>
                </div>
                <div id="div15" style="width: 35px; top: 7.5%; right: 10%; position: absolute;
                    z-index: 99999; cursor: pointer;">
                    <img src="Images/Close.png" alt="close" width="100%" height="100%" onclick="div_category_all_close();" />
                </div>
            </div>

            <div id="div_sub_category_all" class="pickupclass" style="text-align: center; height: 100%;
                width: 100%; position: absolute; display: none; left: 0%; top: 0%; z-index: 99999;
                background: rgba(192, 192, 192, 0.7);">
                <div id="div13" style="border: 5px solid #A0A0A0; position: absolute; top: 8%;
                    background-color: White; left: 10%; right: 10%; width: 80%; -webkit-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                    -moz-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65); box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                    border-radius: 10px 10px 10px 10px;">
                    <table align="left" cellpadding="0" cellspacing="0" style="float: left; width: 100%;"
                        id="tbl_sub_category_all" class="mainText3" border="1">
                        <tr>
                            <td colspan="2">
                                <div id="div_sub_category_all_data">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <input type="button" class="btn btn-danger" id="Button7" value="Close" onclick="div_sub_category_all_close();" />
                            </td>
                        </tr>
                    </table>
                </div>
                <div id="div17" style="width: 35px; top: 7.5%; right: 10%; position: absolute;
                    z-index: 99999; cursor: pointer;">
                    <img src="Images/Close.png" alt="close" width="100%" height="100%" onclick="div_sub_category_all_close();" />
                </div>
            </div>

            <div id="div_product_branch_data" class="pickupclass" style="text-align: center; height: 100%;
                width: 100%; position: absolute; display: none; left: 0%; top: 0%; z-index: 99999;
                background: rgba(192, 192, 192, 0.7);">
                <div id="div18" style="border: 5px solid #A0A0A0; position: absolute; top: 8%;
                    background-color: White; left: 10%; right: 10%; width: 84%; -webkit-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                    -moz-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65); box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                    border-radius: 10px 10px 10px 10px;">
                    <table align="left" cellpadding="0" cellspacing="0" style="float: left; width: 100%;"
                        id="table8" class="mainText3" border="1">
                        <tr style="height: 42px;background-color:cornflowerblue;" class="trbgclrcls">
                            <%--<th style="text-align:center;width:50px;" scope="col">Sno</th>
                            <th style="text-align:center;width:73px;" scope="col">Item Code</th>
                            <th scope="col" style="width:84px;">SKU</th>
                            <th scope="col" style="width:97px;">Category</th>
                            <th scope="col" style="width:97px;">Sub Category</th>--%>
                            <th scope="col" style="width:300px;">Item Name</th>
                            <th scope="col" style="width:141px;">PUNABAKA</th>
                            <th scope="col" style="width:135px;">CHENNAI</th>
                            <th scope="col" style="width:126px;">MANAPAKKAM</th>
                            <th scope="col">KUPPAM</th>
                            <th scope="col"></th>
                        </tr>
                        <tr>
                            <td colspan="9">
                                <div style="height:500px;overflow-y:auto;" id="div_branch_qty_data">
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
                <div id="div21" style="width: 35px; top: 7.5%; right: 4.8%; position: absolute;
                    z-index: 99999; cursor: pointer;">
                    <img src="Images/Close.png" alt="close" width="100%" height="100%" onclick="div_branch_qty_data_close();" />
                </div>
            </div>
            
            <div id="div_all_products_data" class="pickupclass" style="text-align: center; height: 100%;
                width: 100%; position: absolute; display: none; left: 0%; top: 0%; z-index: 99999;
                background: rgba(192, 192, 192, 0.7);">
                <div id="div16" style="border: 5px solid #A0A0A0; position: absolute; top: 8%;
                    background-color: White; left: 10%; right: 10%; width: 84%; -webkit-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                    -moz-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65); box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                    border-radius: 10px 10px 10px 10px;">
                    <table align="left" cellpadding="0" cellspacing="0" style="float: left; width: 100%;"
                        id="table7" class="mainText3" border="1">
                        <tr style="height: 42px;background-color:cornflowerblue;" class="trbgclrcls">
                            <th style="text-align:center;width:50px;" scope="col">Sno</th>
                            <th style="text-align:center;width:78px;" scope="col">Item Code</th>
                            <th scope="col" style="width:84px;">SKU</th>
                            <th scope="col" style="width:97px;">Category</th>
                            <th scope="col" style="width:114px;">Sub Category</th>
                            <th scope="col" style="width:210px;">Item Name</th>
                            <th scope="col" style="width:67px;">UOM</th>
                            <th scope="col">Supplier Name</th>
                            <th scope="col"></th>
                        </tr>
                        <tr>
                            <td colspan="9">
                                <div style="height:500px;overflow-y:auto;" id="divalldata">
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
                <div id="div19" style="width: 35px; top: 7.5%; right: 4.6%; position: absolute;
                    z-index: 99999; cursor: pointer;">
                    <img src="Images/Close.png" alt="close" width="100%" height="100%" onclick="divallproducts_close();" />
                </div>
            </div>

            <div id="divallproducts" class="pickupclass" style="text-align: center; height: 100%;
                width: 100%; position: absolute; display: none; left: 0%; top: 0%; z-index: 99999;
                background: rgba(192, 192, 192, 0.7);">
                <div id="div3" style="border: 5px solid #A0A0A0; position: absolute; top: 8%;
                    background-color: White; left: 10%; right: 10%; width: 84%; -webkit-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                    -moz-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65); box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                    border-radius: 10px 10px 10px 10px;">
                    <table align="left" cellpadding="0" cellspacing="0" style="float: left; width: 100%;"
                        id="table2" class="mainText3" border="1">
                        <tr style="height: 42px;background-color:cornflowerblue;" class="trbgclrcls">
                            <th style="text-align:center;width:50px;" scope="col">Sno</th>
                            <th style="text-align:center;width:73px;" scope="col">Item Code</th>
                            <th scope="col" style="width:97px;">Category</th>
                            <th scope="col" style="width:144px;">Item Name</th>
                            <th scope="col" style="width:70px;">Qty</th>
                            <th scope="col" style="width:91px;">Price</th>
                            <th scope="col" style="width:67px;">UOM</th>
                            <th scope="col" style="width:84px;">SKU</th>
                            <th scope="col">Supplier Name</th>
                            <th scope="col"></th>
                        </tr>
                        <tr>
                            <td colspan="9">
                                <div style="height:500px;overflow-y:auto;" id="divall">
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
                <div id="div5" style="width: 35px; top: 7.5%; right: 6.1%; position: absolute;
                    z-index: 99999; cursor: pointer;">
                    <img src="Images/Close.png" alt="close" width="100%" height="100%" onclick="divallproducts_close();" />
                </div>
            </div>
           
            <div id="divzeroproducts" class="pickupclass" style="text-align: center; height: 100%;
                width: 100%; position: absolute; display: none; left: 0%; top: 0%; z-index: 99999;
                background: rgba(192, 192, 192, 0.7);">
                <div id="div6" style="border: 5px solid #A0A0A0; position: absolute; top: 8%;
                    background-color: White; left: 10%; right: 10%; width: 85%; -webkit-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                    -moz-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65); box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                    border-radius: 10px 10px 10px 10px;">
                    <table align="left" cellpadding="0" cellspacing="0" style="float: left; width: 100%;"
                        id="table3" class="mainText3" border="1">
                        <tr style="height: 42px;background-color:cornflowerblue;" class="trbgclrcls">
                            <th style="text-align:center;width:50px;" scope="col">Sno</th>
                            <th style="text-align:center;width:78px;" scope="col">Item Code</th>
                            <th scope="col" style="width:97px;">Category</th>
                            <th scope="col" style="width:210px;">Item Name</th>
                            <th scope="col" style="width:1px;">Qty</th>
                            <th scope="col" style="width:83px;">Price</th>
                            <th scope="col" style="width:67px;">UOM</th>
                            <th scope="col" style="width:80px;">SKU</th>
                            <th scope="col" >Supplier Name</th>
                            <th scope="col"></th>
                        </tr>
                        <tr>
                            <td colspan="9">
                                <div style="height:500px;overflow-y:auto;" id="divzerostock">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td align="center" colspan="9">
                                <input type="button" class="btn btn-danger" id="Button2" value="Close" onclick="divallproducts_close();" />
                            </td>
                        </tr>
                    </table>
                </div>
                <div id="div8" style="width: 35px; top: 5%; right: 3.7%; position: absolute;
                    z-index: 99999; cursor: pointer;">
                    <img src="Images/Close.png" alt="close" width="100%" height="100%" onclick="divallproducts_close();" />
                </div>
            </div>
            
            <div id="divlowstockproducts" class="pickupclass" style="text-align: center; height: 100%;
                width: 100%; position: absolute; display: none; left: 0%; top: 0%; z-index: 99999;
                background: rgba(192, 192, 192, 0.7);">
                <div id="div9" style="border: 5px solid #A0A0A0; position: absolute; top: 8%;
                    background-color: White; left: 10%; right: 10%; width: 81%; -webkit-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                    -moz-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65); box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                    border-radius: 10px 10px 10px 10px;">
                    <table align="left" cellpadding="0" cellspacing="0" style="float: left; width: 100%;"
                        id="table4" class="mainText3" border="1">
                        <tr style="height:42px;background-color:cornflowerblue;" class="trbgclrcls">
                            <th style="text-align:center;width:42px;" scope="col">Sno</th>
                            <th style="text-align:center;width:73px;" scope="col">Item Code</th>
                            <th scope="col" style="width:97px;">Category</th>
                            <th scope="col" style="width:138px;">Item Name</th>
                            <th scope="col" style="width:52px;">Min Stock</th>
                            <th scope="col" style="width:63px;">Qty</th>
                            <th scope="col" style="width:77px;">Price</th>
                            <th scope="col" style="width:67px;">UOM</th>
                            <th scope="col" style="width:78px;">SKU</th>
                            <th scope="col">Supplier Name</th>
                            <th scope="col"></th>
                        </tr>
                        <tr>
                            <td colspan="10">
                                <div style="height:500px;overflow-y:auto;" id="divlowstock">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td align="center" colspan="10">
                                <input type="button" class="btn btn-danger" id="Button3" value="Close" onclick="divallproducts_close();" />
                            </td>
                        </tr>
                    </table>
                </div>
                <div id="div11" style="width: 35px; top: 6.5%; right: 8%; position: absolute;
                    z-index: 99999; cursor: pointer;">
                    <img src="Images/Close.png" alt="close" width="100%" height="100%" onclick="divallproducts_close();" />
                </div>
            </div>

            <div id="divhighstockproducts" class="pickupclass" style="text-align: center; height: 100%;
                width: 100%; position: absolute; display: none; left: 0%; top: 0%; z-index: 99999;
                background: rgba(192, 192, 192, 0.7);">
                <div id="div12" style="border: 5px solid #A0A0A0; position: absolute; top: 8%;
                    background-color: White; left: 10%; right: 10%; width: 88%;  -webkit-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                    -moz-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65); box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                    border-radius: 10px 10px 10px 10px;">
                    <table align="left" cellpadding="0" cellspacing="0" style="float: left; width: 100%;"
                        id="table5" class="mainText3" border="1">
                        <tr style="background-color:cornflowerblue;" class="trbgclrcls">
                            <th style="text-align:center;width:50px;" scope="col">Sno</th>
                            <th style="text-align:center;width:73px;" scope="col">Item Code</th>
                            <th scope="col" style="width:97px;">Category</th>
                            <th scope="col" style="width:136px;">Item Name</th>
                            <th scope="col" style="width:59px;">Max Stock</th>
                            <th scope="col" style="width:63px;">Qty</th>
                            <th scope="col" style="width:91px;">Price</th>
                            <th scope="col" style="width:67px;">UOM</th>
                            <th scope="col" style="width:84px;">SKU</th>
                            <th scope="col">Supplier Name</th>
                            <th scope="col"></th>
                        </tr>
                        <tr>
                            <td colspan="10">
                                <div style="height:500px;overflow-y:auto;" id="divhighstock">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td align="center" colspan="10">
                                <input type="button" class="btn btn-danger" id="Button4" value="Close" onclick="divallproducts_close();" />
                            </td>
                        </tr>
                    </table>
                </div>
                <div id="div14" style="width: 35px; top: 6%; right: 0.7%; position: absolute;
                    z-index: 99999; cursor: pointer;">
                    <img src="Images/Close.png" alt="close" width="100%" height="100%" onclick="divallproducts_close();" />
                </div>
            </div>

            <div id="div_inward_list" class="pickupclass" style="text-align: center; height: 100%;
                width: 100%; position: absolute; display: none; left: 0%; top: 0%; z-index: 99999;
                background: rgba(192, 192, 192, 0.7);">
                <div id="div4" style="border: 5px solid #A0A0A0; position: absolute; top: 8%;
                    background-color: White; left: 10%; right: 10%; width: 80%;  -webkit-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                    -moz-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65); box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                    border-radius: 10px 10px 10px 10px;">
                    <table align="left" cellpadding="0" cellspacing="0" style="float: left; width: 100%;"
                        id="table6" class="mainText3" border="1">
                        <tr>
                            <td colspan="2">
                                <div id="div_inward_list_data">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <input type="button" class="btn btn-danger" id="Button5" value="Close" onclick="divnward_list_data_close();" />
                            </td>
                        </tr>
                    </table>
                </div>
                <div id="div10" style="width: 35px; top: 7.5%; right: 10%; position: absolute;
                    z-index: 99999; cursor: pointer;">
                    <img src="Images/Close.png" alt="close" width="100%" height="100%" onclick="divnward_list_data_close();" />
                </div>
            </div>

            <div id="divMainAddNewRow2" class="pickupclass" style="text-align: center; height: 100%;
                width: 100%; position: absolute; display: none; left: 0%; top: 0%; z-index: 99999;
                background: rgba(192, 192, 192, 0.7);">
                <div id="div20" style="border: 5px solid #A0A0A0; position: absolute; top: 8%;
                    background-color: White; left: 10%; right: 10%; width: 80%; -webkit-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                    -moz-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65); box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                    border-radius: 10px 10px 10px 10px;">
                    <table align="left" cellpadding="0" cellspacing="0" style="float: left; width: 100%;"
                        id="table9" class="mainText3" border="1">
                        <tr>
                            <td colspan="2">
                                <div id="div_product_details">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <input type="button" class="btn btn-danger" id="Button1" value="Close" onclick="CloseClick_prod_det_close1();" />
                            </td>
                        </tr>
                    </table>
                </div>
                <div id="div23" style="width: 35px; top: 7.5%; right: 10%; position: absolute;
                    z-index: 99999; cursor: pointer;">
                    <img src="Images/Close.png" alt="close" width="100%" height="100%" onclick="CloseClick_prod_det_close1();" />
                </div>
            </div>

            <div id="divMainAddNewRow3" class="pickupclass" style="text-align: center; height: 100%;
                width: 100%; position: absolute; display: none; left: 0%; top: 0%; z-index: 99999;
                background: rgba(192, 192, 192, 0.7);">
                <div id="div22" style="border: 5px solid #A0A0A0; position: absolute; top: 8%;
                    background-color: White; left: 10%; right: 10%; width: 80%; -webkit-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                    -moz-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65); box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                    border-radius: 10px 10px 10px 10px;">
                    <table align="left" cellpadding="0" cellspacing="0" style="float: left; width: 100%;"
                        id="table10" class="mainText3" border="1">
                        <tr>
                            <td colspan="2">
                                <div id="div_supplier_details">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <input type="button" class="btn btn-danger" id="Button8" value="Close" onclick="CloseClick_supplier_det_close();" />
                            </td>
                        </tr>
                    </table>
                </div>
                <div id="div25" style="width: 35px; top: 7.5%; right: 10%; position: absolute;
                    z-index: 99999; cursor: pointer;">
                    <img src="Images/Close.png" alt="close" width="100%" height="100%" onclick="CloseClick_supplier_det_close();" />
                </div>
            </div>

    </section>
</asp:Content>
