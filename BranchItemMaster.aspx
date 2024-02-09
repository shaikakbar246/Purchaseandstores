<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true"
    CodeFile="BranchItemMaster.aspx.cs" Inherits="BranchItemMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script src="js1/imagezoom.js"></script>
    <script type='text/javascript'>
        $(function () {
            get_Sub_Category_details();
            get_Brand_details();
            get_Category_details();
            get_suplier_details();
            get_product_details();
            get_uim_master();
            scrollTo(0, 0);
        });
        function get_uim_master() {
            var data = { 'op': 'get_UIM' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        filluim(msg);
                    }
                    else {
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function filluim(msg) {
            //var data = document.getElementById('ddlUim');
            //var length = data.options.length;
            //document.getElementById('ddlUim').options.length = null;
            //var opt = document.createElement('option');
            //opt.innerHTML = "Select Uim";
            //opt.value = "Select Uim";
            //opt.setAttribute("selected", "selected");
            //opt.setAttribute("disabled", "disabled");
            //opt.setAttribute("class", "dispalynone");
            //data.appendChild(opt);
            //for (var i = 0; i < msg.length; i++) {
            //    if (msg[i].uim != null) {
            //        var option = document.createElement('option');
            //        option.innerHTML = msg[i].uim;
            //        option.value = msg[i].sno;
            //        data.appendChild(option);
            //    }
            //}
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
        function callHandler_nojson_post(d, s, e) {
            $.ajax({
                url: 'FleetManagementHandler.axd',
                type: "POST",
                dataType: "json",
                contentType: false,
                processData: false,
                data: d,
                success: s,
                error: e
            });
        }
        function canceldetails() {
            $("#div_ProductData").show();
            $("#Items_Fillform").hide();
            $('#show_Items_logs').show();
            $("#div_supplier_data").hide();
            $("#divpic").hide();
            forclearall();
        }
        function showdesign() {
            getcode();
            $("#div_ProductData").hide();
            $("#Items_Fillform").show();
            $('#show_Items_logs').hide();
            $("#div_supplier_data").hide();
            $("#divpic").show();
            forclearall();
        }
        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }
        function saveProductDetails() {
            var productname = document.getElementById("txtProductName").value;
            if (productname == "") {

                alert("Enter product Name");
                return false;
            }
            var productcode = document.getElementById("txtProductCode").value;
            if (productcode == "") {

                alert("Enter Product Code");
                return false;
            }
            var sku = document.getElementById("txtSku").value;
            if (sku == "") {
                alert("Enter SKU");
                return false;
            }
            var uim = document.getElementById("ddlUim").value;
            if (uim == "" || uim == "Select Uim") {

                alert("Select uim ");
                return false;
            }
            var ddlsection = document.getElementById('ddlsection').value;
            if (ddlsection == "" || ddlsection == "Select Section") {
                alert("Select section");
                return false;
            }
            var ddlsupplier = document.getElementById('ddlsupplier').value;
            var ddlsubcategary = document.getElementById('ddlsubcategary').value;
            if (ddlsubcategary == "" || ddlsubcategary == "Select SubCategory") {
                alert("select SubCategory Name");
                return false;
            }
            var Price = document.getElementById('txtPrice').value;
            if (Price == "") {

                alert("Enter price ");
                return false;
            }
            var shortname = document.getElementById("txtShortName").value;
            var modifierset = document.getElementById('txtModifierSet').value;
            var ddlbrand = document.getElementById('ddlbrand').value;
            var availablestores = document.getElementById('txtAvailableStores').value;
            //var color = document.getElementById('txtColor').value;
            var itemcode = document.getElementById('txt_itemcode').value;
            if (itemcode == "") {

                alert("Enter itemcode ");
                return false;
            }
            var bin = document.getElementById('txt_bin').value;
            var description = document.getElementById('txtDescript').value;
            var min_stock = document.getElementById("txt_min_stock").value;
            if (min_stock == "") {
                alert("Enter Minimum Stock");
                document.getElementById("txt_min_stock").focus();
                return false;
            }
            var max_stock = document.getElementById("txt_max_stock").value;
            if (max_stock == "") {
                alert("Enter Maximum Stock");
                document.getElementById("txt_max_stock").focus();
                return false;
            }
            var Productid = document.getElementById("lbl_sno").value;
            var btnval = document.getElementById('btn_save').innerHTML;
            var data = { 'op': 'saveBranchProductDetails', 'Name': productname, 'Code': productcode, 'ShortName': shortname, 'SKU': sku, 'Description': description, 'SectionId': ddlsection, 'BrandId': ddlbrand, 'SupplierId': ddlsupplier, 'SubCategoryId': ddlsubcategary, 'Modifierset': modifierset, 'AvailableStores': availablestores, 'uim': uim, 'ProductId': Productid, 'price': Price, 'bin': bin, 'itemcode': itemcode, 'min_stock': min_stock, 'max_stock': max_stock, 'btnVal': btnval };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        get_product_details();
                        forclearall();
                        compiledList = [];
                        compiledList1 = [];
                        $('#div_ProductData').show();
                        $('#Items_Fillform').css('display', 'none');
                        $('#show_Items_logs').css('display', 'block');
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
        function get_Category_details() {
            var data = { 'op': 'get_Category_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillsection(msg);
                    }
                    else {
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function fillsection(msg) {
            //var data = document.getElementById('ddlsection');
            //var length = data.options.length;
            //document.getElementById('ddlsection').options.length = null;
            //var opt = document.createElement('option');
            //opt.innerHTML = "Select Category";
            //opt.value = "Select Category";
            //opt.setAttribute("selected", "selected");
            //opt.setAttribute("disabled", "disabled");
            //opt.setAttribute("class", "dispalynone");
            //data.appendChild(opt);
            //for (var i = 0; i < msg.length; i++) {
            //    if (msg[i].Category != null) {
            //        var option = document.createElement('option');
            //        option.innerHTML = msg[i].Category;
            //        option.value = msg[i].categoryid;
            //        data.appendChild(option);
            //    }
            //}
        }
        function get_Brand_details() {
            var data = { 'op': 'get_Brand_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillbrand(msg);
                    }
                    else {
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function fillbrand(msg) {
            //var data = document.getElementById('ddlbrand');
            //var length = data.options.length;
            //document.getElementById('ddlbrand').options.length = null;
            //var opt = document.createElement('option');
            //opt.innerHTML = "Select Brand";
            //data.appendChild(opt);
            //for (var i = 0; i < msg.length; i++) {
            //    if (msg[i].brandname != null) {
            //        var option = document.createElement('option');
            //        option.innerHTML = msg[i].brandname;
            //        option.value = msg[i].brandid;
            //        data.appendChild(option);
            //    }
            //}
        }
        function get_suplier_details() {
            var data = { 'op': 'get_suplier_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillsupplier(msg);
                    }
                    else {
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function fillsupplier(msg) {
            //var data = document.getElementById('ddlsupplier');
            //var length = data.options.length;
            //document.getElementById('ddlsupplier').options.length = null;
            //var opt = document.createElement('option');
            //opt.innerHTML = "Select Supplier";
            //opt.value = "Select Supplier";
            //opt.setAttribute("selected", "selected");
            //opt.setAttribute("disabled", "disabled");
            //opt.setAttribute("class", "dispalynone");
            //data.appendChild(opt);
            //for (var i = 0; i < msg.length; i++) {
            //    if (msg[i].suppliername != null) {
            //        var option = document.createElement('option');
            //        option.innerHTML = msg[i].suppliername;
            //        option.value = msg[i].supplierid;
            //        data.appendChild(option);
            //    }
            //}
        }
        function get_Sub_Category_details() {
            var data = { 'op': 'get_Sub_Category_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillsubcategory(msg);
                    }
                    else {
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function fillsubcategory(msg) {
            //var data = document.getElementById('ddlsubcategary');
            //var length = data.options.length;
            //document.getElementById('ddlsubcategary').options.length = null;
            //var opt = document.createElement('option');
            //opt.innerHTML = "Select SubCategory";
            //opt.value = "Select SubCategory";
            //opt.setAttribute("selected", "selected");
            //opt.setAttribute("disabled", "disabled");
            //opt.setAttribute("class", "dispalynone");
            //data.appendChild(opt);
            //for (var i = 0; i < msg.length; i++) {
            //    if (msg[i].subcatname != null) {
            //        var option = document.createElement('option');
            //        option.innerHTML = msg[i].subcatname;
            //        option.value = msg[i].subcategoryid;
            //        data.appendChild(option);
            //    }
            //}
        }
        var productdetails = [];
        function get_product_details() {
            var data = { 'op': 'get_branch_product_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        BindGrid(msg);
                        FillProductsData(msg);
                        FillProductsData1(msg);
                        productdetails = msg;
                    }
                    else {
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        function BindGrid(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable" id="example">';
            results += '<thead><tr role="row" class="trbgclrcls"><th scope="col" style="font-weight: bold;">Product Name</th><th scope="col" style="font-weight: bold;">Product Code</th><th scope="col" style="font-weight: bold;">Sub Code</th><th scope="col" style="font-weight: bold;">SKU</th><th scope="col" style="font-weight: bold;">Avail Stores</th><th scope="col" style="font-weight: bold;">Price</th><th scope="col" style="font-weight: bold;">Description</th><th scope="col" style="font-weight: bold;">Image</th><th scope="col" style="font-weight: bold;"></th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            //var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">'; //<td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="Edit" /></td>
                results += '<td scope="row" class="1"><i class="fa fa-cart-plus" aria-hidden="true"></i>&nbsp;<span id="1">' + msg[i].productname + '</span></td>';// style="color:#16bc26"
                results += '<td   style="display : none;"  class="3">' + msg[i].subcatname + '</td>';
                results += '<td   style="display : none;"  class="4">' + msg[i].category + '</td>';
                results += '<td   class="6">' + msg[i].productcode + '</td>';
                results += '<td   class="7">' + msg[i].shortname + '</td>';
                results += '<td   class="5">' + msg[i].sku + '</td>';
                results += '<td   class="9">' + msg[i].moniterqty + '</td>';
                var price = parseFloat(msg[i].price).toFixed(2);
                results += '<td   class="16"><i class="fa fa-fw fa-rupee"></i><span id="16">' + price + '</span></td>';
                results += '<td   class="2">' + msg[i].description + '</td>';
                var rndmnum = Math.floor((Math.random() * 10) + 1);
                var img_url = msg[i].ftplocation + msg[i].imgpath + '?v=' + rndmnum;
                //if (msg[i].imgpath != "") {
                //    results += '<td><img class="img-circle" id="main_img_item" alt="Item Image" src="' + img_url + '" style="width: 30px; height: 30px;" /></td>'
                //}
                //else {
                //    results += '<td><img class="img-circle" id="main_img_item" alt="Item Image" src="Images/dummy_image.jpg" style="width: 30px; height: 30px;" /></td>'
                //}
                if (msg[i].imgpath != "") {
                    results += '<td><img data-imagezoom="true" class="img-circle img-responsive" id="main_img_item" alt="Item Image" src="' + img_url + '" style="width: 30px; height: 30px;" /></td>';
                }
                else {
                    results += '<td><img data-imagezoom="true" class="img-circle img-responsive" id="main_img_item" alt="Item Image" src="Images/dummy_image.jpg" style="width: 30px; height: 30px;" /></td>';
                }
                results += '<td   style="display : none;"class="22">' + msg[i].bin + '</td>';
                results += '<td   style="display : none;"class="23">' + msg[i].itemcode + '</td>';
                results += '<td  style="display : none;" class="10">' + msg[i].color + '</td>';
                results += '<td   style="display : none;" class="8">' + msg[i].modifierset + '</td>';
                results += '<td   style="display : none;" class="11">' + msg[i].uim + '</td>';
                results += '<td   style="display : none;" class="21">' + msg[i].puim + '</td>';
                results += '<td   style="display : none;" class="12">' + msg[i].productid + '</td>';
                results += '<td   style="display : none;" class="13">' + msg[i].brandid + '</td>';
                results += '<td   style="display : none;" class="26">' + msg[i].brandname + '</td>';
                results += '<td   style="display : none;" class="14">' + msg[i].sectionid + '</td>';
                results += '<td   style="display : none;" class="27">' + msg[i].category + '</td>';
                results += '<td   style="display : none;" class="15">' + msg[i].supplierid + '</td>';
                results += '<td   style="display : none;" class="28">' + msg[i].suppliername + '</td>';
                results += '<td   style="display : none;" class="24">' + msg[i].imgpath + '</td>';
                results += '<td   style="display : none;" class="25">' + msg[i].ftplocation + '</td>';
                //results += '<td  style="display : none;" class="17">' + msg[i].specifications + '</td>';
                results += '<td   style="display : none;" class="29">' + msg[i].subcategory + '</td>';
                results += '<td   style="display : none;" class="30">' + msg[i].minstock + '</td>';
                results += '<td   style="display : none;" class="31">' + msg[i].maxstock + '</td>';
                //results += '<td data-title="brandstatus"><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5"  onclick="getme(this)"><span class="glyphicon glyphicon-pencil"></span></button></td>';
                results += '<td data-title="brandstatus"><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"  onclick="getme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td>';
                results += '<td style="display : none;"  class="18">' + msg[i].subcategoryid + '</td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }

            }
            results += '</table></div>';
            $("#div_ProductData").html(results);
        }
        function getme(thisid) {
            scrollTo(0, 0);
            var ProductName = $(thisid).parent().parent().find('#1').html();
            var Description = $(thisid).parent().parent().children('.2').html();
            var subcatname = $(thisid).parent().parent().children('.3').html();
            var Category = $(thisid).parent().parent().children('.4').html();
            var SKU = $(thisid).parent().parent().children('.5').html();
            var ProductCode = $(thisid).parent().parent().children('.6').html();
            var ShortName = $(thisid).parent().parent().children('.7').html();
            var ModifierSet = $(thisid).parent().parent().children('.8').html();
            var moniterqty = $(thisid).parent().parent().children('.9').html();
            var color = $(thisid).parent().parent().children('.10').html();
            var uim = $(thisid).parent().parent().children('.11').html();
            var productid = $(thisid).parent().parent().children('.12').html();
            var Brandid = $(thisid).parent().parent().children('.13').html();
            var sectionid = $(thisid).parent().parent().children('.14').html();
            var supplierid = $(thisid).parent().parent().children('.15').html();
            var price = $(thisid).parent().parent().find('#16').html();
            var subcategoryid = $(thisid).parent().parent().children('.18').html();
            var puim = $(thisid).parent().parent().children('.21').html();
            var bin = $(thisid).parent().parent().children('.22').html();
            var itemcode = $(thisid).parent().parent().children('.23').html();
            var imgpath = $(thisid).parent().parent().children('.24').html();
            var ftplocation = $(thisid).parent().parent().children('.25').html();
            var brandname = $(thisid).parent().parent().children('.26').html();
            var category = $(thisid).parent().parent().children('.27').html();
            var suppliername = $(thisid).parent().parent().children('.28').html();
            var subcategory = $(thisid).parent().parent().children('.29').html();
            var minstock = $(thisid).parent().parent().children('.30').html();
            var maxstock = $(thisid).parent().parent().children('.31').html();

            document.getElementById('txtProductName').value = ProductName;
            document.getElementById('txtDescript').value = Description;
            document.getElementById('txtSku').value = SKU;
            document.getElementById('txt_bin').value = bin;
            document.getElementById('txt_itemcode').value = itemcode;
            document.getElementById('txtProductCode').value = ProductCode;
            document.getElementById('txtShortName').value = ShortName;
            document.getElementById('txtModifierSet').value = ModifierSet;
            document.getElementById('txtAvailableStores').value = moniterqty;
            //document.getElementById('txtColor').value = color;
            document.getElementById('txt_uim').value = uim;
            document.getElementById('ddlUim').value = puim;
            document.getElementById('txtPrice').value = price;
            document.getElementById('txt_category').value = category;
            document.getElementById('txt_brand').value = brandname;
            document.getElementById('txt_supplier').value = suppliername;
            document.getElementById('txt_subcategory').value = subcategory;
            document.getElementById('ddlsection').value = sectionid;
            document.getElementById('ddlbrand').value = Brandid;
            document.getElementById('ddlsupplier').value = supplierid;
            document.getElementById('ddlsubcategary').value = subcategoryid;
            document.getElementById('txt_min_stock').value = minstock;
            document.getElementById('txt_max_stock').value = maxstock;
            document.getElementById('lbl_sno').value = productid;
            var rndmnum = Math.floor((Math.random() * 10) + 1);
            img_url = ftplocation + imgpath + '?v=' + rndmnum;
            if (imgpath != "") {
                $('#main_img').attr('src', img_url).width(200).height(200);
            }
            else {
                $('#main_img').attr('src', 'Images/dummy_image.jpg').width(200).height(200);
            }
            document.getElementById('btn_save').innerHTML = "UPDATE";
            $("#divpic").show();
            $("#div_ProductData").hide();
            $("#Items_Fillform").show();
            $('#show_Items_logs').hide();
            var data = { 'op': 'get_supplier_details_item', 'productid': productid };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fill_supplier_names(msg);
                    }
                    else {
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        function fill_supplier_names(msg) {
            var results = '<div  style="overflow:auto;"><table class="responsive-table" id="tbl_suppliers">';
            results += '<thead><tr style="background:#5aa4d0; color: white; font-weight: bold;"><th style="text-align:center;" scope="col"></th><th style="text-align:center;" scope="col">Suppliers</th><th style="text-align:center;" scope="col">Supplier Image</th><th style="text-align:center;" scope="col"></th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">';
                results += '<td onclick="supplierdetails(\'' + msg[i].supplierid + '\');"><i title="Click Here" class="fa fa-arrow-right"></i></td>';
                results += '<td scope="row" class="1" onclick="supplierdetails(\'' + msg[i].supplierid + '\');" style="text-align:center;"><label id="lbl_suppliername" value="' + msg[i].suppliername + '">' + msg[i].suppliername + '</label></td>';//<i class="fa fa-arrow-circle-right"  aria-hidden="true">
                results += '<td style="display : none;"  class="2"><label id="lbl_supplierid" value="' + msg[i].supplierid + '">' + msg[i].supplierid + '</label></td>';
                results += '<td style="display : none;"  class="3"><label id="lbl_sup_sno" value="' + msg[i].sno + '">' + msg[i].sno + '</label></td>';
                var rndmnum = Math.floor((Math.random() * 10) + 1);
                var img_url = msg[i].ftplocation + msg[i].imgpath + '?v=' + rndmnum;
                if (msg[i].imgpath != "") {
                    results += '<td><img class="center-block img-circle img-thumbnail img-responsive profile-img" id="main_img1" alt="Item Image" src="' + img_url + '" style="border-radius: 5px; width: 150px; height: 75px; border-radius: 10%;" /></td>'
                }
                else {
                    results += '<td><img class="center-block img-circle img-thumbnail img-responsive profile-img" id="main_img1" alt="Item Image" src="Images/dummy_image.jpg" style="border-radius: 5px; width: 150px; height: 75px; border-radius: 10%;" /></td>'
                }
                //results += '<td><input id="btn_poplate" type="button"  onclick="removerow(this)" name="Remove" class="btn btn-primary" value="REMOVE" /></td></tr>';
                results += '<td><span><img src="images/close.png" onclick="removerow_suppliers(this)" style="cursor:pointer;height: 20px;"/></span></td></tr>';

                l = l + 1;
                if (l == 4) {
                    l = 0;
                }

            }
            results += '</table></div>';
            $("#div_supplier_data").html(results);
            $("#div_supplier_data").show();
        }

        function supplierdetails(supplierid) {
            var data = { 'op': 'get_supplier_details_id', 'supplierid': supplierid };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fill_supplier_details(msg);
                    }
                    else {
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        function fill_supplier_details(msg) {
            $('#divMainAddNewRow').css('display', 'block');
            var results = '<div ><table class="responsive-table">';
            results += '<thead><tr><th style="text-align:center;" scope="col">Supplier Name</th><th style="text-align:center;" scope="col">Contact Name</th><th style="text-align:center;" scope="col">Contact Number</th><th style="text-align:center;" scope="col">Email ID</th><th style="text-align:center;" scope="col">Supplier Code</th></tr></thead></tbody>';//<th style="text-align:center;" scope="col">Supplier Address</th>
            var k = 1;
            var l = 0;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];

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
            $("#ShowSupplierData").html(results);
            $("#ShowSupplierData").show();
        }

        function CloseClick() {
            $('#divMainAddNewRow').css('display', 'none');
        }

        function getcode() {
            var data = { 'op': 'get_product_details' };
            var s = function (msg) {
                if (msg) {
                    var availableTags = [];
                    for (i = 0; i < msg.length; i++) {
                        availableTags.push(msg[i].productname);
                    }
                    $("#txtProductName").autocomplete({
                        source: function (req, responseFn) {
                            var re = $.ui.autocomplete.escapeRegex(req.term);
                            var matcher = new RegExp("^" + re, "i");
                            var a = $.grep(availableTags, function (item, index) {
                                return matcher.test(item);
                            });
                            responseFn(a);
                        },
                        autoFocus: true
                    });
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        //var productdetails1 = [];
        //function chanhgeproductname() {
        //    var name = document.getElementById('txtProductName1').value;
        //    var data = { 'op': 'get_branch_product_details_Like', 'name': name };
        //    var s = function (msg) {
        //        if (msg) {
        //            if (msg.length > 0) {
        //                filllikeproduct(msg);

        //            }
        //            else {
        //            }
        //        }
        //        else {
        //        }
        //    };
        //    var e = function (x, h, e) {
        //    }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
        //    callHandler(data, s, e);
        //}
        var compiledList = [];
        function FillProductsData(msg) {
            //var compiledList = [];
            for (var i = 0; i < msg.length; i++) {
                var productname = msg[i].productname;
                compiledList.push(productname);
            }
            $('#txtProductName1').autocomplete({
                source: compiledList,
                change: filllikeproduct,
                autoFocus: true
            });
        }

        function filllikeproduct() {
            scrollTo(0, 0);
            productdetails1 = productdetails;
            var name = document.getElementById('txtProductName1').value;
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable" id="example">';
            results += '<thead><tr role="row" class="trbgclrcls"><th scope="col" style="font-weight: bold;">Product Name</th><th scope="col" style="font-weight: bold;">Product Code</th><th scope="col" style="font-weight: bold;">Sub Code</th><th scope="col" style="font-weight: bold;">SKU</th><th scope="col" style="font-weight: bold;">Avail Stores</th><th scope="col" style="font-weight: bold;">Price</th><th scope="col" style="font-weight: bold;">Description</th><th scope="col" style="font-weight: bold;">Image</th><th scope="col" style="font-weight: bold;"></th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            //var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            for (var i = 0; i < productdetails1.length; i++) {
                if (name == productdetails1[i].productname)
                {
                    results += '<tr style="background-color:' + COLOR[l] + '">'; //<td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="Edit" /></td>
                    results += '<td scope="row" class="1"><i class="fa fa-cart-plus" aria-hidden="true"></i>&nbsp;<span id="1">' + productdetails1[i].productname + '</span></td>';
                    results += '<td   style="display : none;"  class="3">' + productdetails1[i].subcatname + '</td>';
                    results += '<td   style="display : none;"  class="4">' + productdetails1[i].category + '</td>';
                    results += '<td   class="6">' + productdetails1[i].productcode + '</td>';
                    results += '<td   class="7">' + productdetails1[i].shortname + '</td>';
                    results += '<td   class="5">' + productdetails1[i].sku + '</td>';
                    results += '<td   class="9">' + productdetails1[i].moniterqty + '</td>';
                    //results += '<td style="display : none;"  class="10">' + productdetails1[i].color + '</td>';
                    var price = parseFloat(productdetails1[i].price).toFixed(2);
                    results += '<td   class="16"><i class="fa fa-fw fa-rupee"></i><span id="16">' + price + '</span></td>';
                    results += '<td   class="2">' + productdetails1[i].description + '</td>';
                    var rndmnum = Math.floor((Math.random() * 10) + 1);
                    var img_url = productdetails1[i].ftplocation + productdetails1[i].imgpath + '?v=' + rndmnum;
                    //if (productdetails1[i].imgpath != "") {
                    //    results += '<td><img class="img-circle" id="main_img_item" alt="Item Image" src="' + img_url + '" style="width: 30px; height: 30px;" /></td>'
                    //}
                    //else {
                    //    results += '<td><img class="img-circle" id="main_img_item" alt="Item Image" src="Images/dummy_image.jpg" style="width: 30px; height: 30px;" /></td>'
                    //}
                    if (productdetails1[i].imgpath != "") {
                        results += '<td><img data-imagezoom="true" class="img-circle img-responsive" id="main_img_item" alt="Item Image" src="' + img_url + '" style="width: 30px; height: 30px;" /></td>';
                    }
                    else {
                        results += '<td><img data-imagezoom="true" class="img-circle img-responsive" id="main_img_item" alt="Item Image" src="Images/dummy_image.jpg" style="width: 30px; height: 30px;" /></td>';
                    }
                    results += '<td  style="display : none;" class="8">' + productdetails1[i].modifierset + '</td>';
                    results += '<td   style="display : none;" class="11">' + productdetails1[i].uim + '</td>';
                    results += '<td   style="display : none;" class="21">' + productdetails1[i].puim + '</td>';
                    results += '<td   style="display : none;" class="12">' + productdetails1[i].productid + '</td>';
                    results += '<td   style="display : none;" class="13">' + productdetails1[i].brandid + '</td>';
                    results += '<td   style="display : none;" class="14">' + productdetails1[i].sectionid + '</td>';
                    results += '<td   style="display : none;" class="15">' + productdetails1[i].supplierid + '</td>';
                    results += '<td   style="display : none;"class="22">' + productdetails1[i].bin + '</td>';
                    results += '<td   style="display : none;"class="23">' + productdetails1[i].itemcode + '</td>';
                    results += '<td   style="display : none;" class="24">' + productdetails1[i].imgpath + '</td>';
                    results += '<td   style="display : none;" class="25">' + productdetails1[i].ftplocation + '</td>';
                    results += '<td   style="display : none;" class="26">' + productdetails1[i].brandname + '</td>';
                    results += '<td   style="display : none;" class="27">' + productdetails1[i].category + '</td>';
                    results += '<td   style="display : none;" class="28">' + productdetails1[i].suppliername + '</td>';
                    results += '<td   style="display : none;" class="29">' + productdetails1[i].subcategory + '</td>';
                    results += '<td   style="display : none;" class="30">' + productdetails1[i].minstock + '</td>';
                    results += '<td   style="display : none;" class="31">' + productdetails1[i].maxstock + '</td>';
                    //results += '<td data-title="brandstatus"><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5"  onclick="getme(this)"><span class="glyphicon glyphicon-pencil"></span></button></td>';
                    results += '<td data-title="brandstatus"><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"  onclick="getme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td>';
                    results += '<td style="display : none;"  class="18">' + productdetails1[i].subcategoryid + '</td></tr>';

                    l = l + 1;
                    if (l == 4) {
                        l = 0;
                    }
                }
            }
            results += '</table></div>';
            $("#div_ProductData").html(results);
        }
        var compiledList1 = [];
        function FillProductsData1(msg) {
            //var compiledList = [];
            for (var i = 0; i < msg.length; i++) {
                var sku = msg[i].sku;
                compiledList1.push(sku);
            }

            //            $('#txtProductCode1').autocomplete({
            //                source: compiledList1,
            //                change: test2,
            //                autoFocus: true
            //            });
        }

        function forclearall() {
            document.getElementById('txtProductName').value = "";
            document.getElementById('txtProductCode').value = "";
            document.getElementById('txtShortName').value = "";
            document.getElementById('txtSku').value = "";
            document.getElementById('txt_min_stock').value = "";
            document.getElementById('txt_max_stock').value = "";
            document.getElementById('txtDescript').value = "";
            document.getElementById('ddlsection').selectedIndex = 0;
            document.getElementById('ddlbrand').selectedIndex = 0;
            document.getElementById('ddlsupplier').selectedIndex = 0;
            document.getElementById('ddlsubcategary').selectedIndex = 0;
            document.getElementById('txtModifierSet').value = "";
            document.getElementById('txtAvailableStores').value = "";
            document.getElementById('ddlUim').selectedIndex = 0;
            document.getElementById('txtPrice').value = "";
            document.getElementById('txt_itemcode').value = "";
            document.getElementById('txt_bin').value = "";
            document.getElementById('btn_save').innerHTML = "UPDATE";
            $("#lbl_code_error_msg").hide();
            $("#lbl_name_error_msg").hide();
            $("#divpic").hide();
            scrollTo(0, 0);
        }




        function hasExtension(fileName, exts) {
            return (new RegExp('(' + exts.join('|').replace(/\./g, '\\.') + ')$')).test(fileName);
        }

        function readURL(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();

                reader.onload = function (e) {
                    $('#main_img,#img_1').attr('src', e.target.result).width(200).height(200);
                    //                    $('#main_img1,#img_1').attr('src', e.target.result).width(200).height(200);
                };
                reader.readAsDataURL(input.files[0]);
            }
        }
        function getFile() {
            document.getElementById("file").click();
        }
        //----------------> convert base 64 to file
        function dataURItoBlob(dataURI) {
            // convert base64/URLEncoded data component to raw binary data held in a string
            var byteString;
            if (dataURI.split(',')[0].indexOf('base64') >= 0)
                byteString = atob(dataURI.split(',')[1]);
            else
                byteString = unescape(dataURI.split(',')[1]);
            // separate out the mime component
            var mimeString = dataURI.split(',')[0].split(':')[1].split(';')[0];
            // write the bytes of the string to a typed array
            var ia = new Uint8Array(byteString.length);
            for (var i = 0; i < byteString.length; i++) {
                ia[i] = byteString.charCodeAt(i);
            }
            return new Blob([ia], { type: 'image/jpeg' });
        }
        function upload_profile_pic() {
            var dataURL = document.getElementById('main_img').src;
            var div_text = $('#yourBtn').text().trim();
            var blob = dataURItoBlob(dataURL);

            var productid = document.getElementById('lbl_sno').value;
            var Data = new FormData();
            Data.append("op", "Item_pic_files_upload");
            Data.append("productid", productid);
            Data.append("blob", blob);
            var s = function (msg) {
                if (msg) {
                    alert(msg);
                    //                    $('#btn_upload_profilepic').css('display', 'none');
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            callHandler_nojson_post(Data, s, e);
        }


    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Branch Item Master
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operation</a></li>
            <li><a href="#">Branch Item Master</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Branch Item Details
                </h3>
            </div>
            <div class="box-body">
                <div id="show_Items_logs" >
                    <table>
                        <tr>
                            <td>
                             <div class="input-group margin">
                               <input id="txtProductName1" type="text" class="form-control" name="vendorcode"  placeholder="Search Item">
                                   <span class="input-group-btn">
                                     <button type="button" class="btn btn-info btn-flat" style="height: 35px;"><i class="fa fa-search" aria-hidden="true"></i></button>
                                   </span>
                             </div>
                                <%--<input id="txtProductName1" type="text" style="height: 28px; opacity: 1.0; width: 150px;"
                                    class="form-control" name="vendorcode" placeholder="Search Item" />--%>
                            </td>
                           <%-- <td style="width: 35px">
                                OR
                            </td>
                            <td>
                                <input id="txtProductCode1" type="text" style="height: 28px; opacity: 1.0; width: 150px;"
                                    class="form-control" name="vendorcode" placeholder="Search Code" />
                            </td>
                            <td style="width: 10px">
                            </td>--%>
                            <%--<td>
                                <i class="fa fa-search" aria-hidden="true">Search</i>
                            </td>--%>
                            <td style="width: 66%">
                            </td>
                            <%--<td>
                                <input id="btn_addProduct" type="button" name="submit" value='Add Item' class="btn btn-primary"
                                    onclick="showdesign();" />
                            </td>
                            <td style="width: 10px">
                            </td>--%>
                            <td>
                                <%--<asp:Button ID="btnexport" runat="server" Text="Export to Excel" OnClick="btnexport_click" />--%>
                            </td>
                        </tr>
                    </table>
                </div>
                <br />
                <div id="div_ProductData">
                </div>
                </div>
                <div style="width:100%;">
                <table>
                <tr>
                <td style="padding-bottom: 176px;">
                <div id="divpic" class="pictureArea1" style="display:none">
                <table>
                    <tr>
                        <th style="padding-left: 45px;font-size: 20px;">Item Image</th>
                    </tr>
                    <tr>
                        <td style="padding-top: 7px;padding-left: 5px;">
                            <img class="center-block img-circle img-thumbnail img-responsive profile-img" id="main_img"
                            alt="Agent Image" src="Images/dummy_image.jpg" style="border-radius: 5px; width: 200px; height: 200px; border-radius: 50%;" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="photo-edit-admin">
                            <a onclick="getFile();" class="photo-edit-icon-admin" title="Change Profile Picture"
                                data-toggle="modal"  data-target="#photoup"><i style="padding-top: 10px;padding-left: 40px;" class="fa fa-pencil">CHOOSE PHOTO</i></a>
                        </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div id="yourBtn" class="img_btn" onclick="getFile();" style="margin-top: 5px; display: none;">
                            Click to Choose Image
                            </div>
                            <div style="height: 0px; width: 0px; overflow: hidden;">
                                <input id="file" type="file" name="files[]" onchange="readURL(this);">
                            </div>
                            <div>
                                <%--<input type="button" id="btn_upload_profilepic" class="btn btn-primary" onclick="upload_profile_pic();"
                                    style="margin-top: 5px;" value="Upload Item Pic">--%>
                                <div class="input-group" style="padding-top: 10px;padding-left: 33px;">
                                        <div class="input-group-addon">
                                        <span class="glyphicon glyphicon-upload" id="btn_upload_profilepic1" onclick="upload_profile_pic()"></span> <span id="btn_upload_profilepic" onclick="upload_profile_pic()">Upload Item Pic</span>
                                  </div>
                                  </div>
                            </div>
                        </td>
                    </tr>
                </table>
                    </div>
                </td>
                <td style="padding-left:100px;">
                <div id='Items_Fillform' style="display: none;">
                    <table align="center" style="width: 100%;">
                        <tr>
                            <th>
                            </th>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>Name</label><span style="color: red;"></span>
                                <input id="txtProductName" readonly type="text" rows="5" cols="45" class="form-control" name="vendorcode"
                                    placeholder=" Enter Product Name" /><label id="lbl_code_error_msg" class="errormessage">*
                                        Please Enter Item Name</label>
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;">
                                <label>Main Code</label><span style="color: red;"></span>
                                <input id="txtProductCode" readonly type="text" maxlength="45" class="form-control" name="vendorcode"
                                    placeholder=" Enter Product  code" /><label id="Label1" class="errormessage">* Please
                                        Enter Item Code</label>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>Sub Code</label><span style="color: red;"></span>
                                <input id="txtShortName" readonly type="text" maxlength="45" class="form-control" name="vendorcode"
                                    placeholder=" Enter Sub Code" /><label id="Label2" class="errormessage">* Please
                                        Enter Sub Code</label>
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;">
                                <label>SKU</label><span style="color: red;"></span>
                                <input id="txtSku" readonly type="text" maxlength="45" class="form-control" name="vendorcode"
                                    placeholder=" Enter SKU" /><label id="Label3" class="errormessage">* Please
                                        Enter SKU</label>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>UOM</label><span style="color: red;"></span>
                                <%--<select id="ddlUim" class="form-control">
                                    <option placeholder="Select Uom">Select UoM</option>
                                </select>--%>
                                <input type="text" readonly id="txt_uim" class="form-control" name="uim"  />
                                <input type="text" id="ddlUim" class="form-control" style="display:none" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;">
                                <label>Category</label><span style="color: red;"></span>
                                <%--<select id="ddlsection" class="form-control">
                                    <option selected disabled value="Select Category">Select Category</option>
                                </select>--%>
                                <input type="text" readonly id="txt_category" class="form-control" name="category" />
                                <input type="text" id="ddlsection" class="form-control" style="display:none" />
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>Brand</label><span style="color: red;"></span>
                                <%--<select id="ddlbrand" class="form-control">
                                    <option placeholder=" Select Brand"></option>
                                </select>--%>
                                <input type="text" readonly id="txt_brand" class="form-control" name="brand" />
                                <input type="text" id="ddlbrand" class="form-control" style="display:none" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;">
                                <label>Suppliers</label><span style="color: red;"></span>
                                <%--<select id="ddlsupplier" class="form-control">
                                    <option selected disabled value="Select supplier">Select Supplier</option>
                                </select>--%>
                                <input type="text" readonly id="txt_supplier" class="form-control" name="supplier" />
                                <input type="text" id="ddlsupplier" class="form-control" style="display:none" />
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>Sub Category</label><span style="color: red;"></span>
                                <%--<select id="ddlsubcategary" class="form-control">
                                    <option selected disabled value="Select SubCategory">Select Sub Category</option>
                                </select>--%>
                                <input id="txt_subcategory" readonly type="text" class="form-control" name="subcategory" />
                                <input id="ddlsubcategary" type="text" class="form-control" style="display:none" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;">
                                <label>Price</label> <span style="color: red;"></span>
                                <input id="txtPrice" type="text" readonly maxlength="45" class="form-control" name="vendorcode"
                                    placeholder=" Enter Price" onkeypress="return isNumber(event)" /><label id="Label4"
                                        class="errormessage">* Please Enter Price</label>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>Available Stores</label><span style="color: red;"></span>
                                <input id="txtAvailableStores" readonly type="text" maxlength="45" class="form-control" name="vendorcode"
                                    placeholder=" Enter Available Stores" /><label id="Label5" class="errormessage">*
                                        Please Enter AvailableStores</label>
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;">
                                <label>Modifier Set</label> <span style="color: red;"></span>
                                <input id="txtModifierSet" readonly type="text" maxlength="45" class="form-control" name="vendorcode"
                                    placeholder=" Enter Modifier" /><label id="Label6" class="errormessage">*
                                        Please Enter Modifier</label>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>Item Code</label><span style="color: red;"></span>
                                <input type="text" readonly id="txt_itemcode" class="form-control" name="bin" placeholder="enter Item Code" />
                                <label id="lbl_itemcode" class="errormessage">
                                    * Enter Item Code</label>
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;">
                                <label>BIN</label><span style="color: red;"></span>
                                <input type="text" readonly id="txt_bin" class="form-control" name="bin" placeholder="enter bin" />
                                <label id="Label7" class="errormessage">
                                    * Enter BIN</label>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>Minimum Stock</label><span style="color: red;">*</span>
                                <input type="text" id='txt_min_stock' class="form-control" name="min_stock" placeholder="Enter Min Stock" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;">
                                <label>Maximum Stock</label><span style="color: red;">*</span>
                                <input type="text" id='txt_max_stock' class="form-control" name="max_stock" placeholder="Enter Max Stock" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" style="height: 40px;">
                                <label>Description</label><span style="color: red;"></span>
                                <textarea id="txtDescript" rows="4" cols="10" name="PDescription" class="form-control"
                                    placeholder="Enter Description">
                              </textarea>
                                <label id="Label8" class="errormessage">
                                    * Enter Description</label>
                            </td>
                        </tr>
                        <tr style="display: none;">
                            <td>
                                <label id="lbl_sno">
                                </label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="center" style="height: 40px;">
                                <%--<input id="btn_save" type="button" class="btn btn-primary" name="submit" value='UPDATE'
                                    onclick="saveProductDetails()" />
                                <input id='btn_close' type="button" class="btn btn-danger" name="Close" value='Close'
                                    onclick="canceldetails()" />--%>
                                <table>
                                   <tr>
                                    <td>
                                    <div class="input-group">
                                        <div class="input-group-addon">
                                        <span class="glyphicon glyphicon-ok" id="btn_save1" onclick="saveProductDetails()"></span> <span id="btn_save" onclick="saveProductDetails()">UPDATE</span>
                                  </div>
                                  </div>
                                    </td>
                                    <td style="width:10px;"></td>
                                    <td>
                                     <div class="input-group">
                                        <div class="input-group-close">
                                        <span class="glyphicon glyphicon-remove" id='btn_close1' onclick="canceldetails()"></span> <span id='btn_close' onclick="canceldetails()">Close</span>
                                  </div>
                                  </div>
                                    </td>
                                    </tr>
                               </table>
                            </td>
                        </tr>
                    </table>
                </div>
                </td>
                </tr>
                
                </table>
            
                
                </div>
            <div style="width: 76%;padding-left: 311px;display:none" id="div_supplier_data">
                </div>

                <div id="divMainAddNewRow" class="pickupclass" style="text-align: center; height: 100%;
                    width: 100%; position: absolute; display: none; left: 0%; top: 0%; z-index: 99999;
                    background: rgba(192, 192, 192, 0.7);">
                    <div id="divAddNewRow" style="border: 5px solid #A0A0A0; position: absolute; top: 8%;
                        background-color: White; left: 0%; right: 10%; width: 100%;  -webkit-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                        -moz-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65); box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                        border-radius: 10px 10px 10px 10px;">
                        <table align="left" cellpadding="0" cellspacing="0" style="float: left; width: 100%;"
                            id="tableCollectionDetails" class="mainText2" border="1">
                            <tr>
                                <td colspan="2">
                                    <div id="ShowSupplierData">
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
                    <div id="divclose" style="width: 35px; top: 7.5%; right: 0%; position: absolute;
                        z-index: 99999; cursor: pointer;">
                        <img src="Images/Close.png" alt="close" width="100%" height="100%" onclick="CloseClick();" />
                    </div>
                </div>

            </div>
        </div>
    </section>
</asp:Content>
