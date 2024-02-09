<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true" CodeFile="RepairMaster.aspx.cs" Inherits="RepairMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type='text/javascript'>
        $(function ()
        {
            get_RepairItem_details();
            get_Category_details();
            get_uim_master();
            get_Sub_Category_details();
            scrollTo(0, 0);
        });
        function get_uim_master()
        {
            var data = { 'op': 'get_UIM' };
            var s = function (msg)
            {
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
            var e = function (x, h, e)
            {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function filluim(msg)
        {
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

        function get_Sub_Category_details()
        {
            var data = { 'op': 'get_Sub_Category_details' };
            var s = function (msg)
            {
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
            var e = function (x, h, e)
            {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function fillsubcategory(msg)
        {
            var data = document.getElementById('ddlsubcategary');
            var length = data.options.length;
            document.getElementById('ddlsubcategary').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select Sub Category";
            opt.value = "Select Sub Category";
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

        function callHandler(d, s, e)
        {
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
        function canceldetails()
        {
            $("#div_Repair_ProductsData").show();
            $("#Repair_FillForm").hide();
            $('#Show_Repair_Logs').show();
            forclearall();
        }
        function Show_Repair_Design()
        {
            getcode();
            $("#div_Repair_ProductsData").hide();
            $("#Repair_FillForm").show();
            $('#Show_Repair_Logs').hide();
            forclearall();
        }
        function isNumber(evt)
        {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }
        function saveRepairItemDetails()
        {
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
            var subcode = document.getElementById("txtSubCode").value;
            if (subcode == "") {
                alert("Enter subcode");
                document.getElementById("txtSubCode").focus();
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
            var ddlcategory = document.getElementById('ddlcategory').value;
            if (ddlcategory == "" || ddlcategory == "Select Section") {
                alert("Select section");
                document.getElementById('ddlcategory').focus();
                return false;
            }
            var ddlsubcategary = document.getElementById('ddlsubcategary').value;
            if (ddlsubcategary == "" || ddlsubcategary == "Select Sub Category") {
                alert("select SubCategory Name");
                document.getElementById('ddlsubcategary').focus();
                return false;
            }
            var Price = document.getElementById('txtPrice').value;
            if (Price == "") {
                alert("Enter price");
                document.getElementById('txtPrice').focus();
                return false;
            }
            var description = document.getElementById('txtDescript').value;
            var Productid = document.getElementById("lbl_sno").value;
            var btnval = document.getElementById('btn_save').innerHTML;
            var data = { 'op': 'saveRepairItemDetails', 'RepairItemName': productname, 'MainCode': productcode, 'SKU': sku, 'Description': description, 'categoryid': ddlcategory, 'subcategoryid': ddlsubcategary, 'subcode': subcode, 'uim': uim, 'ProductId': Productid, 'price': Price, 'btnVal': btnval };
            var s = function (msg)
            {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        forclearall();
                        get_RepairItem_details();
                        $('#div_Repair_ProductsData').show();
                        $('#Repair_FillForm').css('display', 'none');
                        $('#Show_Repair_Logs').css('display', 'block');
                    }
                }
                else {
                }
            };
            var e = function (x, h, e)
            {
            };

            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function get_Category_details()
        {
            var data = { 'op': 'get_Category_details' };
            var s = function (msg)
            {
                if (msg) {
                    if (msg.length > 0) {
                        fillCategory(msg);
                    }
                    else {
                    }
                }
                else {
                }
            };
            var e = function (x, h, e)
            {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function fillCategory(msg)
        {
            var data = document.getElementById('ddlcategory');
            var length = data.options.length;
            document.getElementById('ddlcategory').options.length = null;
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
        var productdetails = [];
        function get_RepairItem_details()
        {
            var data = { 'op': 'get_RepairItem_details' };
            var s = function (msg)
            {
                if (msg) {
                    if (msg.length > 0) {
                        BindGrid(msg);
                        filldata(msg);
                        filldata1(msg);
                        productdetails = msg;

                    }
                    else {
                    }
                }
                else {
                }
            };
            var e = function (x, h, e)
            {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function BindGrid(msg)
        {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable" role="grid" id="example">';
            results += '<thead><tr role="row" class="trbgclrcls"><th scope="col" style="font-weight: bold;">Product Name</th><th scope="col" style="font-weight: bold;">Product Code</th><th scope="col" style="font-weight: bold;">Sub Code</th><th scope="col" style="font-weight: bold;">SKU</th><th scope="col" style="font-weight: bold;">Price</th><th scope="col" style="font-weight: bold;">Description</th><th scope="col" style="font-weight: bold;"></th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            //var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">'; //<td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="Edit" /></td>
                results += '<td class="1">' + msg[i].ItemName + '</td>';
                results += '<td   style="display : none;"  class="4">' + msg[i].category + '</td>';
                results += '<td   class="6">' + msg[i].Itemcode + '</td>';
                results += '<td   class="9">' + msg[i].subcode + '</td>';
                results += '<td   class="5">' + msg[i].sku + '</td>';
                var price = parseFloat(msg[i].price).toFixed(2);
                results += '<td   class=""><i class="fa fa-fw fa-rupee"></i>&nbsp;<span id="16">' + price + '</span></td>';
                results += '<td   class="2">' + msg[i].description + '</td>';
                results += '<td   style="display : none;" class="11">' + msg[i].uom + '</td>';
                results += '<td   style="display : none;" class="21">' + msg[i].puom + '</td>';
                results += '<td   style="display : none;" class="12">' + msg[i].itemid + '</td>';
                results += '<td   style="display : none;" class="13">' + msg[i].subcategoryid + '</td>';
                //results += '<td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5"  onclick="getme(this)"><span class="glyphicon glyphicon-pencil"></span></button></td>';
                results += '<td data-title="brandstatus"><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"  onclick="getme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td>';
                results += '<td   style="display : none;" class="14">' + msg[i].categoryid + '</td><tr>';
                //results += '<td  style="display : none;" class="17">' + msg[i].specifications + '</td>';

                l = l + 1;
                if (l == 4) {
                    l = 0;
                }

            }
            results += '</table></div>';
            $("#div_Repair_ProductsData").html(results);
        }
        function getme(thisid)
        {
            scrollTo(0, 0);
            var ProductName = $(thisid).parent().parent().children('.1').html();
            var Description = $(thisid).parent().parent().children('.2').html();
            var Category = $(thisid).parent().parent().children('.4').html();
            var SKU = $(thisid).parent().parent().children('.5').html();
            var ProductCode = $(thisid).parent().parent().children('.6').html();
            var subcode = $(thisid).parent().parent().children('.9').html();
            var uim = $(thisid).parent().parent().children('.11').html();
            var productid = $(thisid).parent().parent().children('.12').html();
            var categoryid = $(thisid).parent().parent().children('.14').html();
            var price = $(thisid).parent().parent().find('#16').html();
            var subcategoryid = $(thisid).parent().parent().children('.13').html();
            var puim = $(thisid).parent().parent().children('.21').html();

            document.getElementById('txtProductName').value = ProductName;
            document.getElementById('txtDescript').value = Description;
            document.getElementById('txtSku').value = SKU;
            document.getElementById('txtProductCode').value = ProductCode;
            document.getElementById('ddlsubcategary').value = subcategoryid;
            document.getElementById('txtSubCode').value = subcode;
            document.getElementById('ddlUim').value = puim;
            document.getElementById('txtPrice').value = price;
            document.getElementById('ddlcategory').value = categoryid;
            document.getElementById('lbl_sno').value = productid;
            document.getElementById('btn_save').innerHTML = "Modify";
            $("#div_Repair_ProductsData").hide();
            $("#Repair_FillForm").show();
            $('#Show_Repair_Logs').hide();
        }

        function getcode()
        {
            var data = { 'op': 'get_RepairItem_details' };
            var s = function (msg)
            {
                if (msg) {
                    var availableTags = [];
                    for (i = 0; i < msg.length; i++) {
                        availableTags.push(msg[i].ItemName);
                    }
                    $("#txtProductName").autocomplete({
                        source: function (req, responseFn)
                        {
                            var re = $.ui.autocomplete.escapeRegex(req.term);
                            var matcher = new RegExp("^" + re, "i");
                            var a = $.grep(availableTags, function (item, index)
                            {
                                return matcher.test(item);
                            });
                            responseFn(a);
                        },
                        autoFocus: true
                    });
                }
            }
            var e = function (x, h, e)
            {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        var RepairItemdetails1 = [];
        function chanhgeproductname()
        {
            var name = document.getElementById('txtProductName1').value;
            var data = { 'op': 'get_RepairItem_details_Like', 'name': name };
            var s = function (msg)
            {
                if (msg) {
                    if (msg.length > 0) {
                        filllikeproduct(msg);

                    }
                    else {
                    }
                }
                else {
                }
            };
            var e = function (x, h, e)
            {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        var compiledList = [];
        function filldata(msg)
        {
            //var compiledList = [];
            for (var i = 0; i < msg.length; i++) {
                var productname = msg[i].ItemName;
                compiledList.push(productname);
            }

            $('#txtProductName1').autocomplete({
                source: compiledList,
                change: chanhgeproductname,
                autoFocus: true
            });
        }

        function filllikeproduct(msg)
        {
            //            document.getElementById('txtProductName1').value = msg[0].productname;
            //            var name = document.getElementById('txtProductName1').value;
            productdetails1 = msg;
            //            if (name == "") {
            var results = '<div  style="overflow:auto;"><table class="responsive-table" id="example">';
            results += '<thead><tr><th scope="col"></th><th scope="col">ProductName</th><th scope="col">productcode</th><th scope="col">SubCode</th><th scope="col">SKU</th><th scope="col">availablestores</th><th scope="col">Price</th><th scope="col">Description</th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];

            for (var i = 0; i < RepairItemdetails1.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '"><td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
                results += '<th scope="row" class="1" style="text-align:center;">' + RepairItemdetails1[i].ItemName + '</th>';
                results += '<td   style="display : none;"  class="4">' + RepairItemdetails1[i].category + '</td>';
                results += '<td   class="6">' + RepairItemdetails1[i].Itemcode + '</td>';
                results += '<td   class="5">' + RepairItemdetails1[i].sku + '</td>';
                results += '<td   class="9">' + RepairItemdetails1[i].subcategoryid + '</td>';
                results += '<td   class="16">' + RepairItemdetails1[i].price + '</td>';
                results += '<td   class="2">' + RepairItemdetails1[i].description + '</td>';
                results += '<td   style="display : none;" class="11">' + productdetails1[i].uom + '</td>';
                results += '<td   style="display : none;" class="12">' + productdetails1[i].itemid + '</td>';
                results += '<td style="display : none;"  class="18">' + productdetails1[i].subcode + '</td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_Repair_ProductsData").html(results);
        }
        var compiledList1 = [];
        function filldata1(msg)
        {
            //var compiledList = [];
            for (var i = 0; i < msg.length; i++) {
                var sku = msg[i].sku;
                compiledList1.push(sku);
            }

            $('#txtProductCode1').autocomplete({
                source: compiledList1,
                change: test2,
                autoFocus: true
            });
        }

        function test2()
        {
            document.getElementById('txtProductCode1').value = msg[0].sku;
            var sku = document.getElementById('txtProductName1').value;
            if (sku == "") {
                var results = '<div  style="overflow:auto;"><table class="responsive-table" id="example">';
                results += '<thead><tr><th scope="col"></th><th scope="col">ProductName</th><th scope="col">productcode</th><th scope="col">SubCode</th><th scope="col">SKU</th><th scope="col">availablestores</th><th scope="col">Price</th><th scope="col">Description</th></tr></thead></tbody>';

                var k = 1;
                var l = 0;
                var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];

                for (var i = 0; i < RepairItemdetails.length; i++) {
                    results += '<tr style="background-color:' + COLOR[l] + '"><td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
                    results += '<th scope="row" class="1" style="text-align:center;">' + RepairItemdetails[i].ItemName + '</th>';
                    results += '<td   style="display : none;"  class="4">' + RepairItemdetails[i].category + '</td>';
                    results += '<td   class="6">' + RepairItemdetails[i].Itemcode + '</td>';
                    results += '<td   class="5">' + RepairItemdetails[i].sku + '</td>';
                    results += '<td   class="9">' + RepairItemdetails[i].subcategoryid + '</td>';
                    results += '<td   class="16">' + RepairItemdetails[i].subcode + '</td>';
                    results += '<td   class="16">' + RepairItemdetails[i].price + '</td>';
                    results += '<td   class="2">' + RepairItemdetails[i].description + '</td>';
                    results += '<td   style="display : none;" class="11">' + RepairItemdetails[i].uom + '</td>';
                    results += '<td   style="display : none;" class="12">' + RepairItemdetails[i].itemid + '</td><tr>';

                    l = l + 1;
                    if (l == 4) {
                        l = 0;
                    }


                }
                results += '</table></div>';

            }
            else {
                var results = '<div  style="overflow:auto;"><table class="responsive-table" id="example">';
                results += '<thead><tr><th scope="col"></th><th scope="col">ProductName</th><th scope="col">productcode</th><th scope="col">SubCode</th><th scope="col">SKU</th><th scope="col">availablestores</th><th scope="col">Price</th><th scope="col">Description</th></tr></thead></tbody>';

                var k = 1;
                var l = 0;
                var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];

                for (var i = 0; i < RepairItemdetails.length; i++) {
                    if (sku == RepairItemdetails[i].sku) {
                        results += '<tr style="background-color:' + COLOR[l] + '"><td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
                        results += '<th scope="row" class="1" style="text-align:center;">' + RepairItemdetails[i].ItemName + '</th>';
                        results += '<td   style="display : none;"  class="4">' + RepairItemdetails[i].category + '</td>';
                        results += '<td   class="6">' + RepairItemdetails[i].Itemcode + '</td>';
                        results += '<td   class="5">' + RepairItemdetails[i].sku + '</td>';
                        results += '<td   class="9">' + RepairItemdetails[i].subcategoryid + '</td>';
                        results += '<td   class="16">' + RepairItemdetails[i].price + '</td>';
                        results += '<td   class="2">' + RepairItemdetails[i].description + '</td>';
                        results += '<td   class="2">' + RepairItemdetails[i].subcode + '</td>';
                        results += '<td   style="display : none;" class="11">' + RepairItemdetails[i].uom + '</td>';
                        results += '<td   style="display : none;" class="12">' + RepairItemdetails[i].itemid + '</td><tr>';

                        l = l + 1;
                        if (l == 4) {
                            l = 0;
                        }


                    }
                }
                results += '</table></div>';
            }
            $("#div_Repair_ProductsData").html(results);

        }

        function forclearall()
        {
            document.getElementById('txtProductName').value = "";
            document.getElementById('txtProductCode').value = "";
            document.getElementById('txtSku').value = "";
            document.getElementById('txtDescript').value = "";
            document.getElementById('ddlcategory').selectedIndex = 0;
            document.getElementById('ddlsubcategary').selectedIndex = "";
            document.getElementById('ddlUim').selectedIndex = 0;
            document.getElementById('txtSubCode').value = "";
            document.getElementById('txtPrice').value = "";
            document.getElementById('btn_save').innerHTML = "save";
            $("#lbl_code_error_msg").hide();
            $("#lbl_name_error_msg").hide();
            scrollTo(0, 0);
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<section class="content-header">
        <h1>
          Repair Item Master
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operation</a></li>
            <li><a href="#">Repair Item Master</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Repair Item Details
                </h3>
            </div>
            <div class="box-body">
                <div id="Show_Repair_Logs" align="center">
                    <%--<table>
                            <tr>
                            <td>
                                <input id="btn_addRepairProduct" type="button" name="submit" value='Add Repair Item' class="btn btn-primary"
                                    onclick="Show_Repair_Design();" />
                            </td>
                            <td style="width: 10px">
                            </td>
                        </tr>
                    </table>--%>
                    <div id="show_department" class="input-group" style="padding-left:87%;">
                      <div class="input-group-addon">
                          <span class="glyphicon glyphicon-plus-sign" onclick="Show_Repair_Design()"></span> <span onclick="Show_Repair_Design()">Add Repair Item</span>
                      </div>
                    </div>
                    <div id="div_Repair_ProductsData" style="padding-top:2px;">
                    </div>
                </div>
                <div id='Repair_FillForm' style="display: none;">
                    <table align="center" style="width: 60%;">
                        <tr>
                            <th>
                            </th>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                               <label>Repair Item Name</label><span style="color: red;">*</span>
                                <input id="txtProductName" type="text" maxlength="45" class="form-control" name="vendorcode"
                                    placeholder=" Enter Repair Item Name" /><label id="lbl_code_error_msg" class="errormessage">*
                                        Please Enter Repair Item Name</label>
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;">
                                <label>Main Code</label><span style="color: red;">*</span>
                                <input id="txtProductCode" type="text" maxlength="45" class="form-control" name="vendorcode"
                                    placeholder=" Enter Product Code" /><label id="Label1" class="errormessage">* Please
                                        Enter Item Code</label>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>Category</label><span style="color: red;">*</span>
                                <select id="ddlcategory" class="form-control">
                                    <option selected disabled value="Select Category">Select Category</option>
                                </select>
                            </td>
                             <td style="width: 5px;">
                            </td>
                            <td style="height: 40px;">
                                <label>SKU</label><span style="color: red;">*</span>
                                <input id="txtSku" type="text" maxlength="45" class="form-control" name="vendorcode"
                                    placeholder=" Enter SKU" /><label id="Label2" class="errormessage">* Please
                                        Enter SKU</label>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>Sub Category</label><span style="color: red;">*</span>
                                <select id="ddlsubcategary" class="form-control">
                                    <option selected disabled value="Select Sub Category">Select Sub Category</option>
                                </select>
                            </td>
                            <td style="width: 5px;">
                            </td>
                             <td style="height: 40px;">
                                <label>Sub Code</label><span style="color: red;"></span>
                                <input id="txtSubCode" type="text" maxlength="45" class="form-control" name="vendorcode"
                                    placeholder=" Enter Sub Code" /><label id="Label5" class="errormessage">* Please
                                        Enter Sub Code</label>
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
                                <label>Price</label><span style="color: red;">*</span>
                                <input id="txtPrice" type="text" maxlength="45" class="form-control" name="vendorcode"
                                    placeholder=" Enter Price" onkeypress="return isNumber(event)" /><label id="Label4"
                                        class="errormessage">* Please Enter Price</label>
                            </td>
                        </tr>
                         <tr>
                            <td colspan="4" style="height: 40px;">
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
                            <td colspan="2" align="center" style="height: 40px;padding-left: 20%;">
                                <%--<input id="btn_save" type="button" class="btn btn-primary" name="submit" value='save'
                                    onclick="saveRepairItemDetails()" />
                                <input id='btn_close' type="button" class="btn btn-danger" name="Close" value='Close'
                                    onclick="canceldetails()" />--%>
                                <table>
                                   <tr>
                                    <td>
                                    <div class="input-group">
                                        <div class="input-group-addon">
                                        <span class="glyphicon glyphicon-ok" id="btn_save1" onclick="saveRepairItemDetails()"></span> <span id="btn_save" onclick="saveRepairItemDetails()">save</span>
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
            </div>
        </div>
    </section>
</asp:Content>

