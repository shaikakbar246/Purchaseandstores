<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true"
    CodeFile="ItemMaster.aspx.cs" Inherits="ProductMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script src="js1/imagezoom.js"></script>
    <link href="http://www.jqueryscript.net/css/jquerysctipttop.css" rel="stylesheet"
        type="text/css">
    <script src="Barcode/jquery-barcode.js" type="text/javascript"></script>
    <style type="text/css">
        .container
        {
            max-width: 100%;
        }
        th
        {
            text-align: center;
        }
        #config
        {
            overflow: auto;
            margin-bottom: 10px;
        }
        .config
        {
            float: left;
            width: 200px;
            height: 250px;
            border: 1px solid #000;
            margin-left: 10px;
        }
        .config .title
        {
            font-weight: bold;
            text-align: center;
        }
        .config .barcode2D, #miscCanvas
        {
            display: none;
        }
        #submit
        {
            clear: both;
        }
        #barcodeTarget, #canvasTarget
        {
            margin-top: 20px;
        }
    </style>
    <script type='text/javascript'>
        $(function () {
            get_Sub_Category_details();
            get_Brand_details();
            get_Category_details();
            get_suplier_details();
            get_product_details();
            get_uim_master();
            // getcode();
            scrollTo(0, 0);
            $('input[name=btype]').click(function () {
                if ($(this).attr('id') == 'datamatrix') showConfig2D(); else showConfig1D();
            });
            $('input[name=renderer]').click(function () {
                if ($(this).attr('id') == 'canvas') $('#miscCanvas').show(); else $('#miscCanvas').hide();
            });
        });
        function isFloat(evt) {
            var charCode = (event.which) ? event.which : event.keyCode;
            if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            else {
                //if dot sign entered more than once then don't allow to enter dot sign again. 46 is the code for dot sign
                var parts = evt.srcElement.value.split('.');
                if (parts.length > 1 && charCode == 46)
                    return false;
                return true;
            }
        }
        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }
        function ValidateAlpha(evt) {
            var keyCode = (evt.which) ? evt.which : evt.keyCode
            if ((keyCode < 65 || keyCode > 90) && (keyCode < 97 || keyCode > 123) && keyCode != 32)

                return false;
            return true;
        }
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
            var data = document.getElementById('ddlUim');
            var length = data.options.length;
            document.getElementById('ddlUim').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select Uim";
            opt.value = "Select Uim";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].uim != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].uim;
                    option.value = msg[i].sno;
                    data.appendChild(option);
                }
            }
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
        function canceldetails() {
            $("#div_ProductData").show();
            $("#Items_Fillform").hide();
            $("#divpic").hide();
            $('#show_Items_logs').show();
            $("#div_supplier_data").hide();
            $("#divpic").hide();
            forclearall();
            var source = "Images/dummy_image.jpg";
            $("#main_img").attr("src", source);
            clear_image_grid();
        }
        function showdesign() {
            forclearall();

            $("#div_ProductData").hide();
            $("#Items_Fillform").show();
            $("#divpic").show();
            $('#show_Items_logs').hide();
            $("#div_supplier_data").hide();
            $("#divpic").show();
            scrollTo(0, 0);
        }
        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }
        var supplier_ids = [];
        function saveProductDetails() {
            var productname = document.getElementById("txtProductName").value;
            if (productname == "") {
                alert("Enter product Name");
                document.getElementById("txtProductName").focus();
                return false;
            }
            var productcode = document.getElementById("txtProductCode").value;
            if (productcode == "") {
                alert("Enter Product Code");
                document.getElementById("txtProductCode").focus();
                return false;
            }
            var sku = document.getElementById("txtSku").value;
            if (sku == "") {
                alert("Enter SKU");
                document.getElementById("txtSku").focus();
                return false;
            }
            var uim = document.getElementById("ddlUim").value;
            if (uim == "" || uim == "Select Uim") {
                alert("Select uim ");
                document.getElementById("ddlUim").focus();
                return false;
            }
            var ddlsection = document.getElementById('ddlsection').value;
            if (ddlsection == "" || ddlsection == "Select Section") {
                alert("Select section");
                document.getElementById("ddlsection").focus();
                return false;
            }
            var ddlsupplier = document.getElementById('ddlsupplier').value;
            var ddlsubcategary = document.getElementById('ddlsubcategary').value;
            if (ddlsubcategary == "" || ddlsubcategary == "Select SubCategory") {
                alert("select SubCategory Name");
                document.getElementById("ddlsubcategary").focus();
                return false;
            }
            var Price = document.getElementById('txtPrice').value;
            if (Price == "") {
                alert("Enter price ");
                document.getElementById("txtPrice").focus();
                return false;
            }
            var shortname = document.getElementById("txtShortName").value;
            var modifierset = document.getElementById('txtModifierSet').value;
            var ddlbrand = document.getElementById('ddlbrand').value;
            var availablestores = document.getElementById('txtAvailableStores').value;
            var itemcode = document.getElementById('txt_itemcode').value;
            if (itemcode == "") {
                alert("Enter Item Code ");
                document.getElementById('txt_itemcode').focus();
                return false;
            }
            var bin = document.getElementById('txt_bin').value;
            var hsn_code = document.getElementById('txt_hsn_code').value;
            if (hsn_code == "") {
                alert("Enter HSN Code");
                return false;
            }
            var igst = document.getElementById('slct_igst').value;
            if (igst == "") {
                alert("Enter IGST %");
                return false;
            }
            var cgst = document.getElementById('txt_cgst').value;
            if (cgst == "") {
                alert("Enter CGST %");
                return false;
            }
            var sgst = document.getElementById('txt_sgst').value;
            if (sgst == "") {
                alert("Enter SGST %");
                return false;
            }
            var description = document.getElementById('txtDescript').value;
            var gst_tax_cat = document.getElementById('slct_gst_tax_cat').value;
            var Productid = document.getElementById("lbl_sno").value;

            $('#tbl_suppliers> tbody > tr').each(function () {
                var sup_id = $(this).find('#lbl_supplierid').text();
                var sno = $(this).find('#lbl_sup_sno').text();
                if (sup_id == "" || sup_id == "0") {
                }
                else {
                    supplier_ids.push({ supplierid: sup_id, sno: sno });
                }
            });

            if (supplier_ids.length == 0) {
                alert("Please Add Suppliers");
                return false;
            }

            var btnval = document.getElementById('btn_save').innerHTML;
            var data = { 'op': 'saveProductDetails', 'productname': productname, 'gst_tax_cat': gst_tax_cat, 'productcode': productcode, 'shortname': shortname, 'sku': sku, 'description': description, 'sectionid': ddlsection, 'brandid': ddlbrand, 'supplierid': ddlsupplier, 'subcategoryid': ddlsubcategary, 'modifierset': modifierset, 'availablestores': availablestores, 'uim': uim, 'productid': Productid, 'price': Price, 'bin': bin, 'itemcode': itemcode, 'hsn_code': hsn_code, 'igst': igst, 'cgst': cgst, 'sgst': sgst, 'suppliers': supplier_ids, 'btnVal': btnval };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        get_product_details();
                        forclearall();
                        compiledList = [];
                        compiledList1 = [];
                        suppliers = [];
                        $('#div_ProductData').show();
                        $('#Items_Fillform').css('display', 'none');
                        $("#divpic").hide();
                        $('#show_Items_logs').css('display', 'block');
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };

            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            CallHandlerUsingJson(data, s, e);
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
            var data = document.getElementById('ddlsection');
            var length = data.options.length;
            document.getElementById('ddlsection').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select Category";
            opt.value = "Select Category";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].Category != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].Category;
                    option.value = msg[i].categoryid;
                    data.appendChild(option);
                }
            }
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
            var data = document.getElementById('ddlbrand');
            var length = data.options.length;
            document.getElementById('ddlbrand').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select Brand";
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].brandname != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].brandname;
                    option.value = msg[i].brandid;
                    data.appendChild(option);
                }
            }
        }

        var supplier_det = [];
        function get_suplier_details() {
            var data = { 'op': 'get_suplier_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillsupplier(msg);
                        supplier_det = msg;
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
            var data = document.getElementById('ddlsupplier');
            var length = data.options.length;
            document.getElementById('ddlsupplier').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select Supplier";
            opt.value = "Select Supplier";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].suppliername != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].suppliername;
                    option.value = msg[i].supplierid;
                    data.appendChild(option);
                }
            }
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
            var data = document.getElementById('ddlsubcategary');
            var length = data.options.length;
            document.getElementById('ddlsubcategary').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select SubCategory";
            opt.value = "Select SubCategory";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].subcatname != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].subcatname;
                    option.value = msg[i].subcategoryid;
                    data.appendChild(option);
                }
            }
        }
        var productdetails = [];
        function get_product_details() {
            var data = { 'op': 'get_productissue_details' }; //get_product_detail_branch
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
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable" role="grid">';
            results += '<thead><tr class="trbgclrcls"><th scope="col" style="font-weight: bold; width:27%;">Item Name</th><th scope="col" style="font-weight: bold;">Main Code</th><th scope="col" style="font-weight: bold;">Sub Code</th><th scope="col" style="font-weight: bold;">Item Code</th><th scope="col" style="font-weight: bold;">Quantity</th><th scope="col" style="font-weight: bold;">Price</th><th scope="col">Image</th><th scope="col"></th></tr></thead></tbody>';
            var k = 1;
            var l = 0;

            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">';
                results += '<td   class="1"><i class="fa fa-cart-plus" aria-hidden="true"></i>&nbsp;<label id="1">' + msg[i].productname + '</label></td>';
                results += '<td   style="display : none;"  class="3">' + msg[i].subcatname + '</td>';
                results += '<td   style="display : none;"  class="4">' + msg[i].category + '</td>';
                results += '<td   class="6">' + msg[i].productcode + '</td>';
                results += '<td   class="7">' + msg[i].shortname + '</td>';
                results += '<td   class="5">' + msg[i].sku + '</td>';
                results += '<td   class="9">' + msg[i].moniterqty + '</td>';
                var price = parseFloat(msg[i].price).toFixed(2);
                results += '<td   class="16"><i class="fa fa-fw fa-rupee"></i><span id="16">' + msg[i].price + '</span></td>';
                results += '<td   style="display : none;" class="2">' + msg[i].description + '</td>';
                var rndmnum = Math.floor((Math.random() * 10) + 1);
                var img_url = msg[i].ftplocation + msg[i].imgpath + '?v=' + rndmnum;
                if (msg[i].imgpath != "") {
                    results += '<td><img data-imagezoom="true" class="img-circle img-responsive" id="main_img_item" alt="Item Image" src="' + img_url + '" style="width: 30px; height: 30px;" /></td>';
                }
                else {
                    results += '<td><img data-imagezoom="true" class="img-circle img-responsive" id="main_img_item" alt="Item Image" src="Images/dummy_image.jpg" style="width: 30px; height: 30px;" /></td>';
                }
                results += '<td data-title="brandstatus"><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"  onclick="getme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td>';
                results += '<td   style="display : none;"class="22">' + msg[i].bin + '</td>';
                results += '<td   style="display : none;"class="23">' + msg[i].itemcode + '</td>';
                results += '<td   style="display : none;" class="8">' + msg[i].modifierset + '</td>';
                results += '<td   style="display : none;" class="11">' + msg[i].uim + '</td>';
                results += '<td   style="display : none;" class="21">' + msg[i].puim + '</td>';
                results += '<td   style="display : none;" class="12">' + msg[i].productid + '</td>';
                results += '<td   style="display : none;" class="13">' + msg[i].brandid + '</td>';
                results += '<td   style="display : none;" class="14">' + msg[i].sectionid + '</td>';
                results += '<td   style="display : none;" class="15">' + msg[i].supplierid + '</td>';
                results += '<td   style="display : none;" class="24">' + msg[i].imgpath + '</td>';
                results += '<td   style="display : none;" class="25">' + msg[i].ftplocation + '</td>';
                results += '<td   style="display : none;" class="26">' + msg[i].hsn_code + '</td>';
                results += '<td   style="display : none;" class="27">' + msg[i].igst + '</td>';
                results += '<td   style="display : none;" class="28">' + msg[i].cgst + '</td>';
                results += '<td   style="display : none;" class="29">' + msg[i].sgst + '</td>';
                results += '<td   style="display : none;" class="30">' + msg[i].gst_tax_cat + '</td>';
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
            var hsn_code = $(thisid).parent().parent().children('.26').html();
            var igst = $(thisid).parent().parent().children('.27').html();
            var cgst = $(thisid).parent().parent().children('.28').html();
            var sgst = $(thisid).parent().parent().children('.29').html();
            var gst_tax_cat = $(thisid).parent().parent().children('.30').html();
            generateBarcode(SKU);
            document.getElementById('txtProductName').value = ProductName;
            document.getElementById('txtDescript').value = Description;
            document.getElementById('txtSku').value = SKU;
            document.getElementById('txt_bin').value = bin;
            document.getElementById('txt_itemcode').value = itemcode;
            document.getElementById('txtProductCode').value = ProductCode;
            document.getElementById('txtShortName').value = ShortName;
            document.getElementById('txtModifierSet').value = ModifierSet;
            document.getElementById('txtAvailableStores').value = moniterqty;
            document.getElementById('ddlUim').value = puim;
            document.getElementById('txtPrice').value = price;
            document.getElementById('ddlsection').value = sectionid;
            document.getElementById('ddlbrand').value = Brandid;
            document.getElementById('ddlsupplier').value = supplierid;
            document.getElementById('ddlsubcategary').value = subcategoryid;
            document.getElementById('txt_hsn_code').value = hsn_code;
            document.getElementById('slct_igst').value = igst;
            document.getElementById('txt_cgst').value = cgst;
            document.getElementById('txt_sgst').value = sgst;
            document.getElementById('slct_gst_tax_cat').value = gst_tax_cat;
            document.getElementById('lbl_sno').value = productid;
            var rndmnum = Math.floor((Math.random() * 10) + 1);
            img_url = ftplocation + imgpath + '?v=' + rndmnum;
            if (imgpath != "") {
                $('#main_img').attr('src', img_url).width(200).height(200);
            }
            else {
                $('#main_img').attr('src', 'Images/dummy_image.jpg').width(200).height(200);
            }
            document.getElementById('btn_save').innerHTML = "Modify";
            $("#divpic").show();
            $("#div_ProductData").hide();
            $("#Items_Fillform").show();
            $("#divpic").show();
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
            var results = '<div ><table class="responsive-table" id="tbl_suppliers">'; // style="overflow:auto;"
            results += '<thead><tr style="background:#5aa4d0; color: white; font-weight: bold;"><th style="text-align:center;" scope="col"></th><th style="text-align:center;" scope="col">Suppliers</th><th style="text-align:center;" scope="col">Supplier Image</th><th style="text-align:center;" scope="col"></th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">';
                results += '<td onclick="supplierdetails(\'' + msg[i].supplierid + '\');"><i title="Click Here" class="fa fa-arrow-right"></i></td>';
                results += '<td scope="row" class="1" onclick="supplierdetails(\'' + msg[i].supplierid + '\');" style="text-align:center;"><label id="lbl_suppliername" value="' + msg[i].suppliername + '">' + msg[i].suppliername + '</label></td>'; //<i class="fa fa-arrow-circle-right"  aria-hidden="true">
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
            var results = '<div><table class="responsive-table">'; // style="width: 126% !important;"
            results += '<thead><tr><th style="text-align:center;">Supplier Name</th><th style="text-align:center;">Contact Name</th><th style="text-align:center;">Contact Number</th><th style="text-align:center;">Email ID</th><th style="text-align:center;">Supplier Code</th></tr></thead></tbody>'; //<th style="text-align:center;" scope="col">Supplier Address</th>
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

        var compiledList = [];
        function FillProductsData(msg) {
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
            if (name != "") {
                var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable" role="grid" id="example">';
                results += '<thead><tr class="trbgclrcls"><th scope="col" style="font-weight: bold;">Item Name</th><th scope="col" style="font-weight: bold;">Main Code</th><th scope="col" style="font-weight: bold;">Sub Code</th><th scope="col" style="font-weight: bold;">SKU</th><th scope="col" style="font-weight: bold;">Avail Stores</th><th scope="col" style="font-weight: bold;">Price</th><th scope="col" style="font-weight: bold;">Item Image</th><th></th></tr></thead></tbody>';
                var k = 1;
                var l = 0;
                var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
                for (var i = 0; i < productdetails1.length; i++) {
                    if (name == productdetails1[i].productname) {
                        results += '<tr style="background-color:' + COLOR[l] + '">';
                        results += '<td scope="row" class="1"><i class="fa fa-cart-plus" aria-hidden="true"></i>&nbsp;<label style="font-weight:700px" id="1">' + productdetails1[i].productname + '</label></td>';
                        results += '<td   style="display : none;"  class="3">' + productdetails1[i].subcatname + '</td>';
                        results += '<td   style="display : none;"  class="4">' + productdetails1[i].category + '</td>';
                        results += '<td   class="6">' + productdetails1[i].productcode + '</td>';
                        results += '<td   class="7">' + productdetails1[i].shortname + '</td>';
                        results += '<td   class="5">' + productdetails1[i].sku + '</td>';
                        results += '<td   class="9">' + productdetails1[i].moniterqty + '</td>';

                        results += '<td class="16"><i class="fa fa-fw fa-rupee"></i>&nbsp;<span id="16">' + productdetails1[i].price + '</span></td>';
                        results += '<td style="display : none;" class="2">' + productdetails1[i].description + '</td>';
                        var rndmnum = Math.floor((Math.random() * 10) + 1);
                        var img_url = productdetails1[i].ftplocation + productdetails1[i].imgpath + '?v=' + rndmnum;
                        if (productdetails1[i].imgpath != "") {
                            results += '<td><img data-imagezoom="true" class="img-circle img-responsive" id="main_img_item" alt="Item Image" src="' + img_url + '" style="width: 30px; height: 30px;" /></td>';
                        }
                        else {
                            results += '<td><img data-imagezoom="true" class="img-circle img-responsive" id="main_img_item" alt="Item Image" src="Images/dummy_image.jpg" style="width: 30px; height: 30px;" /></td>';
                        }
                        results += '<td data-title="brandstatus"><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"  onclick="getme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td>';
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
                        results += '<td   style="display : none;" class="26">' + productdetails1[i].hsn_code + '</td>';
                        results += '<td   style="display : none;" class="27">' + productdetails1[i].igst + '</td>';
                        results += '<td   style="display : none;" class="28">' + productdetails1[i].cgst + '</td>';
                        results += '<td   style="display : none;" class="29">' + productdetails1[i].sgst + '</td>';
                        results += '<td   style="display : none;" class="30">' + productdetails1[i].gst_tax_cat + '</td>';
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
            else {
                var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable" role="grid" id="example">';
                results += '<thead><tr class="trbgclrcls"><th scope="col" style="font-weight: bold;">Item Name</th><th scope="col" style="font-weight: bold;">Main Code</th><th scope="col" style="font-weight: bold;">Sub Code</th><th scope="col" style="font-weight: bold;">SKU</th><th scope="col" style="font-weight: bold;">Avail Stores</th><th scope="col" style="font-weight: bold;">Price</th><th scope="col" style="font-weight: bold;">Item Image</th><th></th></tr></thead></tbody>';
                var k = 1;
                var l = 0;
                var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
                for (var i = 0; i < productdetails1.length; i++) {
                    results += '<tr style="background-color:' + COLOR[l] + '">';
                    results += '<td scope="row" class="1"><i class="fa fa-cart-plus" aria-hidden="true"></i>&nbsp;<label style="font-weight:700px" id="1">' + productdetails1[i].productname + '</label></td>';
                    results += '<td   style="display : none;"  class="3">' + productdetails1[i].subcatname + '</td>';
                    results += '<td   style="display : none;"  class="4">' + productdetails1[i].category + '</td>';
                    results += '<td   class="6">' + productdetails1[i].productcode + '</td>';
                    results += '<td   class="7">' + productdetails1[i].shortname + '</td>';
                    results += '<td   class="5">' + productdetails1[i].sku + '</td>';
                    results += '<td   class="9">' + productdetails1[i].moniterqty + '</td>';

                    results += '<td   class="16"><i class="fa fa-fw fa-rupee"></i>&nbsp;<span id="16">' + productdetails1[i].price + '</span></td>';
                    results += '<td  style="display : none;" class="2">' + productdetails1[i].description + '</td>';
                    var rndmnum = Math.floor((Math.random() * 10) + 1);
                    var img_url = productdetails1[i].ftplocation + productdetails1[i].imgpath + '?v=' + rndmnum;
                    if (productdetails1[i].imgpath != "") {
                        results += '<td><img data-imagezoom="true" class="img-circle img-responsive" id="main_img_item" alt="Item Image" src="' + img_url + '" style="width: 30px; height: 30px;" /></td>';
                    }
                    else {
                        results += '<td><img data-imagezoom="true" class="img-circle img-responsive" id="main_img_item" alt="Item Image" src="Images/dummy_image.jpg" style="width: 30px; height: 30px;" /></td>';
                    }
                    results += '<td data-title="brandstatus"><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"  onclick="getme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td>';
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
                    results += '<td   style="display : none;" class="26">' + productdetails1[i].hsn_code + '</td>';
                    results += '<td   style="display : none;" class="27">' + productdetails1[i].igst + '</td>';
                    results += '<td   style="display : none;" class="28">' + productdetails1[i].cgst + '</td>';
                    results += '<td   style="display : none;" class="29">' + productdetails1[i].sgst + '</td>';
                    results += '<td   style="display : none;" class="30">' + productdetails1[i].gst_tax_cat + '</td>';
                    results += '<td style="display : none;"  class="18">' + productdetails1[i].subcategoryid + '</td></tr>';
                    l = l + 1;
                    if (l == 4) {
                        l = 0;
                    }
                }
                results += '</table></div>';
                $("#div_ProductData").html(results);
            }
        }
        var compiledList1 = [];
        function FillProductsData1(msg) {
            for (var i = 0; i < msg.length; i++) {
                var sku = msg[i].sku;
                compiledList1.push(sku);
            }

            $('#txtProductCode1').autocomplete({
                source: compiledList1,
                change: filllikeproduct1,
                autoFocus: true
            });
        }

        function filllikeproduct1() {
            scrollTo(0, 0);
            productdetails1 = productdetails;
            var sku = document.getElementById('txtProductCode1').value;
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable" role="grid" id="example">';
            results += '<thead><tr class="trbgclrcls"><th scope="col" style="font-weight: bold;">Product Name</th><th scope="col" style="font-weight: bold;">Product Code</th><th scope="col" style="font-weight: bold;">Sub Code</th><th scope="col" style="font-weight: bold;">SKU</th><th scope="col" style="font-weight: bold;">Avail Stores</th><th scope="col" style="font-weight: bold;">Price</th><th scope="col" style="font-weight: bold;">Description</th><th scope="col" style="font-weight: bold;">Image</th><th></th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            for (var i = 0; i < productdetails1.length; i++) {
                if (sku == productdetails1[i].sku) {
                    results += '<tr style="background-color:' + COLOR[l] + '">';
                    results += '<td scope="row" class="1"><i class="fa fa-cart-plus" aria-hidden="true"></i>&nbsp;<label id="1">' + productdetails1[i].productname + '</label></td>';
                    results += '<td   style="display : none;"  class="3">' + productdetails1[i].subcatname + '</td>';
                    results += '<td   style="display : none;"  class="4">' + productdetails1[i].category + '</td>';
                    results += '<td   class="6">' + productdetails1[i].productcode + '</td>';
                    results += '<td   class="7">' + productdetails1[i].shortname + '</td>';
                    results += '<td   class="5">' + productdetails1[i].sku + '</td>';
                    results += '<td   class="9">' + productdetails1[i].moniterqty + '</td>';

                    results += '<td style="display : none;"  class="10">' + productdetails1[i].color + '</td>';
                    results += '<td   class="16"><i class="fa fa-fw fa-rupee"></i>&nbsp;<span id="16">' + productdetails1[i].price + '</span></td>';
                    results += '<td   class="2">' + productdetails1[i].description + '</td>';
                    var rndmnum = Math.floor((Math.random() * 10) + 1);
                    var img_url = productdetails1[i].ftplocation + productdetails1[i].imgpath + '?v=' + rndmnum;
                    if (productdetails1[i].imgpath != "") {
                        results += '<td><img data-imagezoom="true" class="img-circle img-responsive" id="main_img_item" alt="Item Image" src="' + img_url + '" style="width: 30px; height: 30px;" /></td>';
                    }
                    else {
                        results += '<td><img data-imagezoom="true" class="img-circle img-responsive" id="main_img_item" alt="Item Image" src="Images/dummy_image.jpg" style="width: 30px; height: 30px;" /></td>';
                    }
                    results += '<td data-title="brandstatus"><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls" onclick="getme(this)"><span class="glyphicon glyphicon-pencil"></span></button></td>';
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

        function forclearall() {
            document.getElementById('txtProductName').value = "";
            document.getElementById('txtProductCode').value = "";
            document.getElementById('txtShortName').value = "";
            document.getElementById('txtSku').value = "";
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
            document.getElementById('txt_hsn_code').value = "";
            document.getElementById('slct_igst').selectedIndex = 0;
            document.getElementById('txt_cgst').value = "";
            document.getElementById('txt_sgst').value = "";
            document.getElementById('slct_gst_tax_cat').selectedIndex = 0;
            document.getElementById('btn_save').innerHTML = "save";
            $("#lbl_code_error_msg").hide();
            $("#lbl_name_error_msg").hide();
            $("#div_supplier_data").hide();
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
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            callHandler_nojson_post(Data, s, e);
        }

        function removerow(thisid) {
            $(thisid).parents('tr').remove();
        }

        var suppliers = [];
        function Btn_AddClick() {
            var exists = 0;

            suppliers = [];
            $('#tbl_suppliers> tbody > tr').each(function () {
                var supplierid = $(this).find('#lbl_supplierid').text();
                var suppliername = $(this).find('#lbl_suppliername').text();
                var sno = $(this).find('#lbl_sup_sno').text();
                if (supplierid == "" || supplierid == "0") {
                }
                else {
                    suppliers.push({ suppliername: suppliername, supplierid: supplierid, sno: sno });
                }
            });

            var suppliername1 = document.getElementById('ddlsupplier');
            var suppliername = suppliername1.options[suppliername1.selectedIndex].innerHTML;
            var supplierid = document.getElementById('ddlsupplier').value;
            var sno1 = "";
            if (supplierid == "") {
                alert("Please Select Supplier");
                return false;
            }
            for (var i = 0; i < suppliers.length; i++) {
                if (supplierid == suppliers[i].supplierid) {
                    exists = 1;
                }
            }
            if (exists == 1) {
                alert("supplier already added");
                return false;
            }
            else if (exists == 0) {
                suppliers.push({ suppliername: suppliername, supplierid: supplierid, sno: sno1 }); //, sno: sno
            }

            var results = '<div ><table class="responsive-table" id="tbl_suppliers">'; // style="overflow:auto;"
            results += '<thead><tr style="background:#5aa4d0; color: white; font-weight: bold;"><th style="text-align:center;" scope="col"></th><th style="text-align:center;" scope="col">Suppliers</th><th style="text-align:center;" scope="col">Supplier Image</th><th style="text-align:center;" scope="col"></th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];

            for (var i = 0; i < suppliers.length; i++) {
                for (var k = 0; k < supplier_det.length; k++) {
                    if (suppliers[i].supplierid == supplier_det[k].supplierid) {
                        results += '<tr style="background-color:' + COLOR[l] + '">';
                        results += '<td onclick="supplierdetails(\'' + suppliers[i].supplierid + '\');"><i class="fa fa-arrow-right"></i></td>';
                        results += '<td scope="row" class="1"  onclick="supplierdetails(\'' + suppliers[i].supplierid + '\');" style="text-align:center;"><label id="lbl_suppliername" value="' + suppliers[i].suppliername + '">' + suppliers[i].suppliername + '</label></td>';
                        results += '<td style="display : none;"  class="2"><label id="lbl_supplierid" value="' + suppliers[i].supplierid + '">' + suppliers[i].supplierid + '</label></td>';
                        results += '<td style="display : none;"  class="3"><label id="lbl_sup_sno" value="' + suppliers[i].sno + '">' + suppliers[i].sno + '</label></td>';
                        var rndmnum = Math.floor((Math.random() * 10) + 1);
                        var img_url = supplier_det[k].ftplocation + supplier_det[k].imgpath + '?v=' + rndmnum;
                        if (supplier_det[k].imgpath != "") {
                            results += '<td><img class="center-block img-circle img-thumbnail img-responsive profile-img" id="main_img1" alt="Item Image" src="' + img_url + '" style="border-radius: 5px; width: 150px; height: 75px; border-radius: 10%;" /></td>'
                        }
                        else {
                            results += '<td><img class="center-block img-circle img-thumbnail img-responsive profile-img" id="main_img1" alt="Item Image" src="Images/dummy_image.jpg" style="border-radius: 5px; width: 150px; height: 75px; border-radius: 10%;" /></td>'
                        }
                        results += '<td><span><img src="images/close.png" onclick="removerow_suppliers(this)" style="cursor:pointer;height: 20px;"/></span></td></tr>';

                        l = l + 1;
                        if (l == 4) {
                            l = 0;
                        }
                    }
                }

            }
            results += '</table></div>';
            $("#div_supplier_data").html(results);
            $("#div_supplier_data").show();

        }

        function removerow_suppliers(thisid) {
            $(thisid).parents('tr').remove();

            suppliers = [];
            $('#tbl_suppliers> tbody > tr').each(function () {
                var supplierid = $(this).find('#lbl_supplierid').text();
                var suppliername = $(this).find('#lbl_suppliername').text();
                var sno = $(this).find('#lbl_sup_sno').text();
                if (supplierid == "" || supplierid == "0") {
                }
                else {
                    suppliers.push({ suppliername: suppliername, supplierid: supplierid, sno: sno });
                }
            });
        }

        function clear_image_grid() {
            var suppliers = [];
            var supplier_det = [];
            var results = '<div ><table class="responsive-table" id="tbl_suppliers">'; // style="overflow:auto;"
            results += '<thead><tr style="background:#5aa4d0; color: white; font-weight: bold;"><th style="text-align:center;" scope="col">Suppliers</th><th style="text-align:center;" scope="col">Supplier Image</th><th style="text-align:center;" scope="col"></th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];

            for (var i = 0; i < suppliers.length; i++) {
                for (var k = 0; k < supplier_det.length; k++) {
                    if (suppliers[i].supplierid == supplier_det[k].supplierid) {
                        results += '<tr style="background-color:' + COLOR[l] + '">';
                        results += '<th scope="row" class="1" style="text-align:center;"><label id="lbl_suppliername" value="' + suppliers[i].suppliername + '">' + suppliers[i].suppliername + '</label></th>';
                        results += '<td style="display : none;"  class="2"><label id="lbl_supplierid" value="' + suppliers[i].supplierid + '">' + suppliers[i].supplierid + '</label></td>';
                        results += '<td style="display : none;"  class="3"><label id="lbl_sup_sno" value="' + suppliers[i].sno + '">' + suppliers[i].sno + '</label></td>';
                        var rndmnum = Math.floor((Math.random() * 10) + 1);
                        var img_url = supplier_det[k].ftplocation + supplier_det[k].imgpath + '?v=' + rndmnum;
                        if (supplier_det[k].imgpath != "") {
                            results += '<td><img class="center-block img-circle img-thumbnail img-responsive profile-img" id="main_img1" alt="Item Image" src="' + img_url + '" style="border-radius: 5px; width: 150px; height: 75px; border-radius: 10%;" /></td>'
                        }
                        else {
                            results += '<td><img class="center-block img-circle img-thumbnail img-responsive profile-img" id="main_img1" alt="Item Image" src="Images/dummy_image.jpg" style="border-radius: 5px; width: 150px; height: 75px; border-radius: 10%;" /></td>'
                        }
                        results += '<td><span><img src="images/close.png" onclick="removerow_suppliers(this)" style="cursor:pointer;height: 20px;"/></span></td></tr>';

                        l = l + 1;
                        if (l == 4) {
                            l = 0;
                        }
                    }
                }

            }
            results += '</table></div>';
            $("#div_supplier_data").html(results);
        }

        function calc_gst() {
            var igst = document.getElementById('slct_igst').value;
            var cgst = parseFloat(igst) / 2;
            document.getElementById('txt_cgst').value = cgst;
            document.getElementById('txt_sgst').value = cgst;
        }


        function generateBarcode(barname) {
            var Beforevalue = barname;
            var value = Beforevalue;
            var btype = $("input[name=btype]:checked").val();
            var renderer = $("input[name=renderer]:checked").val();
            var quietZone = false;
            if ($("#quietzone").is(':checked') || $("#quietzone").attr('checked')) {
                quietZone = true;
            }
            var settings = {
                output: renderer,
                bgColor: $("#bgColor").val(),
                color: $("#color").val(),
                barWidth: $("#barWidth").val(),
                barHeight: $("#barHeight").val(),
                moduleSize: $("#moduleSize").val(),
                posX: $("#posX").val(),
                posY: $("#posY").val(),
                addQuietZone: $("#quietZoneSize").val()
            };
            if ($("#rectangular").is(':checked') || $("#rectangular").attr('checked')) {
                value = { code: value, rect: true };
            }
            if (renderer == 'canvas') {
                clearCanvas();
                $("#barcodeTarget").hide();
                $("#canvasTarget").show().barcode(value, btype, settings);
            } else {
                $("#canvasTarget").hide();
                $("#barcodeTarget").html("").show().barcode(value, btype, settings);
            }
            // document.getElementById('lblbarcode').innerHTML = value;
        }

        function showConfig1D() {
            $('.config .barcode1D').show();
            $('.config .barcode2D').hide();
        }

        function showConfig2D() {
            $('.config .barcode1D').hide();
            $('.config .barcode2D').show();
        }

        function clearCanvas() {
            var canvas = $('#canvasTarget').get(0);
            var ctx = canvas.getContext('2d');
            ctx.lineWidth = 1;
            ctx.lineCap = 'butt';
            ctx.fillStyle = '#FFFFFF';
            ctx.strokeStyle = '#000000';
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            ctx.strokeRect(0, 0, canvas.width, canvas.height);
        }

        
  

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Item Master
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operation</a></li>
            <li><a href="#">Item Master</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Item Details
                </h3>
            </div>
            <div class="box-body">
                <div id="show_Items_logs" align="center">
                    <table>
                        <tr>
                            <td>
                             <div class="input-group margin">
                               <input id="txtProductName1" type="text" class="form-control" name="vendorcode"  placeholder="Search Item" style="width:250px;">
                                   <span class="input-group-btn">
                                     <button type="button" class="btn btn-info btn-flat" style="height: 35px;"><i class="fa fa-search" aria-hidden="true"></i></button>
                                   </span>
                             </div>
                               
                            </td>
                           
                            <td style="width: 52%">
                            </td>
                            <td>
                             <div id="sub_Category_FillForms" class="input-group">
                                <div class="input-group-addon">
                                <span class="glyphicon glyphicon-plus-sign" onclick="showdesign()"></span> <span style="cursor:pointer" title="Click Here to Add Item" onclick="showdesign()">Add Item</span>
                          </div>
                          </div>
                            </td>
                            <td style="width: 10px">
                            </td>
                            <td>
                                <asp:Button ID="btnexport" runat="server" Text="Export to Excel" OnClick="btnexport_click" />
                            </td>
                        </tr>
                    </table>
                </div>
                <div id="div_ProductData">
                </div>
                
                </div>
                <div class="row" id="divpic" style="display:none;">
                        <div class="col-sm-12 col-xs-12">
                            <div class="well panel panel-default" style="padding: 0px;">
                                <div class="panel-body">
                                    <div class="row">
                                        <div class="col-sm-4" style="width: 100%;">
                                            <div class="row">
                                                <div class="col-xs-12 col-sm-3 text-center">
                                                    <div class="pictureArea1">
                                                        <img class="center-block img-circle img-thumbnail img-responsive profile-img" id="main_img" src="Images/dummy_image.jpg" alt="your image" style="border-radius: 50%; width: 165px; height: 210px;">
                                                        
                                                        <div class="photo-edit-admin">
                                                            <a onclick="getFile();" class="photo-edit-icon-admin"  title="Change Item Picture" data-toggle="modal" data-target="#photoup"><i class="fa fa-pencil">
                                                               CHOOSE PHOTO </i></a>
                                                        </div>

                                                        <div id="Div1" class="img_btn" onclick="getFile();" style="margin-top: 5px; display: none;">
                                                            Click to Choose Image
                                                        </div>
                                                         <div style="height: 0px; width: 0px; overflow: hidden;">
                                <input id="file" type="file" name="files[]" onchange="readURL(this);">
                            </div>
                                                        <div>
                                                       <div class="input-group" style="padding-top:12px;padding-left:40px">
                                                       <div class="input-group-addon" style="width:10px;">
                                                        <span class="glyphicon glyphicon-upload" id="btn_upload_profilepic1" onclick="upload_profile_pic()"></span> <span id="btn_upload_profilepic" onclick="upload_profile_pic()">Upload Item Pic</span>
                                                       </div>
                                                       </div>
                                                      </div>


                                                     
                                                    </div>
                                                </div>
                                                
                                                <!--/col-->
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>



            
                <div style="width:100%;padding-top:20px;">
                <table style="width:100%;">
                <tr>
                <td style="padding-bottom: 176px;">
                
                </td>
                <td>
                <div id='Items_Fillform' style="display: none;">
                <div style="float: right;">
                                        <div id="barcodeTarget" class="barcodeTarget">
                                        </div>
                                        <canvas id="canvasTarget" width="150" height="150">
                                        </canvas>
                                    </div>
                    <table align="center">
                        
                        <tr>
                            <td style="height: 40px;width: 45%;">
                                <label>Name</label><span style="color: red;">*</span>
                                <input id="txtProductName" type="text" style="text-transform:capitalize;" rows="5" cols="45" class="form-control" name="vendorcode"
                                    placeholder=" Enter Product Name" /><label id="lbl_code_error_msg" class="errormessage">*
                                        Please Enter Item Name</label>
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;">
                               <label>Main Code</label><span style="color: red;">*</span>
                                <input id="txtProductCode" type="text" maxlength="45" class="form-control" onkeypress="return isNumber(event)" name="vendorcode"
                                    placeholder=" Enter Product  code" /><label id="Label1" class="errormessage">* Please
                                        Enter Item Code</label>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>Sub Code</label><span style="color: red;"></span>
                                <input id="txtShortName" type="text" maxlength="45" onkeypress="return isNumber(event)" class="form-control" name="vendorcode"
                                    placeholder=" Enter Sub Code" /><label id="Label2" class="errormessage">* Please
                                        Enter Sub Code</label>
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;">
                                <label>SKU</label><span style="color: red;">*</span>
                                <input id="txtSku" type="text" maxlength="45" class="form-control" name="vendorcode"
                                    placeholder=" Enter SKU" /><label id="lbl_code_error_msg" class="errormessage">* Please
                                        Enter SKU</label>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>UOM</label><span style="color: red;">*</span>
                                <select id="ddlUim" class="form-control">
                                    <option placeholder="Select Uom">Select UoM</option>
                                </select>
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;">
                                <label>Category</label><span style="color: red;">*</span>
                                <select id="ddlsection" class="form-control">
                                    <option selected disabled value="Select Category">Select Category</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>Brand</label><span style="color: red;"></span>
                                <select id="ddlbrand" class="form-control">
                                    <option placeholder=" Select Brand"></option>
                                </select>
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;">
                                <label>Suppliers</label><span style="color: red;"></span>
                                <select id="ddlsupplier" class="form-control">
                                    <option selected disabled value="Select supplier">Select Supplier</option>
                                </select>
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;padding-top: 25px;">
                                <input type="button" id="btn_add_supplier" style="width: 30px;height: 30px;padding: 0px 0; border-radius: 15px;text-align: center;font-size: 21px; font-weight:bold; line-height: 1.428571429;" value="+" class="btn btn-primary"  onclick="Btn_AddClick();" />
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>Sub Category</label><span style="color: red;">*</span>
                                <select id="ddlsubcategary" class="form-control">
                                    <option selected disabled value="Select SubCategory">Select Sub Category</option>
                                </select>
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;">
                                <label>Price</label> <span style="color: red;">*</span>
                                <input id="txtPrice" type="text" maxlength="45" class="form-control" name="vendorcode"
                                    placeholder=" Enter Price" onkeypress="return isNumber(event)" /><label id="lbl_code_error_msg"
                                        class="errormessage">* Please Enter Price</label>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>Avail Stores</label><span style="color: red;"></span>
                                <input id="txtAvailableStores" type="text" maxlength="45" class="form-control" onkeypress="return isFloat(event)" name="vendorcode"
                                    placeholder=" Enter Avail Stores" /><label id="lbl_code_error_msg" class="errormessage">*
                                        Please Enter AvailableStores</label>
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;">
                                <label>Modifier Set</label> <span style="color: red;"></span>
                                <input id="txtModifierSet" type="text" maxlength="45" class="form-control" name="vendorcode"
                                    placeholder=" Enter Modifier" /><label id="lbl_code_error_msg" class="errormessage">*
                                        Please Enter Modifier</label>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>Item Code</label><span style="color: red;">*</span>
                                <input type="text" id="txt_itemcode" class="form-control" name="bin" placeholder="Enter Item Code" />
                                <label id="lbl_itemcode" class="errormessage">
                                    * Enter Item Code</label>
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;">
                                <label>BIN</label><span style="color: red;"></span>
                                <input type="text" id="txt_bin" class="form-control" name="bin" placeholder="Enter BIN" />
                                <label id="Label4" class="errormessage">
                                    * Enter BIN</label>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>GST Tax Category</label>
                                <select id="slct_gst_tax_cat" class="form-control">
                                    <option value="1">Regular</option>
                                    <option value="2">Nil Rated</option>
                                    <option value="3">Exempt</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>HSN Code</label><span style="color: red;">*</span>
                                <input type="text" id='txt_hsn_code' class="form-control" name="hsn_code" placeholder="Enter HSN Code" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td>
                                <label>IGST</label><span style="color: red;">*</span>
                                <select id="slct_igst" class="form-control" onchange="calc_gst()">
                                    <option disabled value="">SELECT</option>
                                    <option value="0">0</option>
                                    <option value="3">3</option>
                                    <option value="5">5</option>
                                    <option value="12">12</option>
                                    <option value="18">18</option>
                                    <option value="28">28</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>CGST</label><span style="color: red;">*</span>
                                <input type="text" id="txt_cgst" class="form-control" readonly name="cgst" placeholder="CGST %" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td>
                                <label>SGST</label><span style="color: red;">*</span>
                                <input type="text" id="txt_sgst" class="form-control" readonly name="sgst" placeholder="SGST %" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3" style="height: 40px;">
                                <label>Description</label><span style="color: red;"></span>
                                <textarea id="txtDescript" rows="4" cols="10" name="PDescription" class="form-control"
                                    placeholder="Enter Description">
                              </textarea>
                                <label id="Label3" class="errormessage">
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
                                <table>
                                   <tr>
                                    <td>
                                    <div class="input-group">
                                        <div class="input-group-addon">
                                        <span class="glyphicon glyphicon-ok" id="btn_save1" onclick="saveProductDetails()"></span> <span id="btn_save" onclick="saveProductDetails()">save</span>
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
            <div id="config" style="display: none;">
        <input type="radio" name="btype" id="code128" checked="checked" value="code128">
    </div>
        </div>
    </section>
</asp:Content>
