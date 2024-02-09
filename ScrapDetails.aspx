<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true"
    CodeFile="ScrapDetails.aspx.cs" Inherits="ScrapDetails" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            get_supplier();
            get_productcode();
            get_scrap_material_details();
            get_scrap_sales_details();
            get_section_details();
            var today = new Date();
            var dd = today.getDate();
            var mm = today.getMonth() + 1; //January is 0!
            var yyyy = today.getFullYear();
            if (dd < 10) {
                dd = '0' + dd
            }
            if (mm < 10) {
                mm = '0' + mm
            }
            var hrs = today.getHours();
            var mnts = today.getMinutes();
            $('#txtInvoicedate').val(yyyy + '-' + mm + '-' + dd);
            scrollTo(0, 0);
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

        function showScrapMaterial() {
            forclearall();
            ScrapMaterialFixedRows();
            $("#divScrapSales").css("display", "none");
            $("#divScrapMaterial").css("display", "block");
        }
        function showScrapSales() {
            forclearall1();
            ScrapSalesFixedRows();
            $("#divScrapSales").css("display", "block");
            $("#divScrapMaterial").css("display", "none");
        }
        function showScrapSalesdesign() {
            forclearall1();
            ScrapSalesFixedRows();
            get_productcode();
            $("#grid_ScrapSales").hide();
            $("#fillform_ScrapSales").show();
            $('#show_logs_ScrapSales').hide();
            emptytable = [];
            var today = new Date();
            var dd = today.getDate();
            var mm = today.getMonth() + 1; //January is 0!
            var yyyy = today.getFullYear();
            if (dd < 10) {
                dd = '0' + dd
            }
            if (mm < 10) {
                mm = '0' + mm
            }
            var hrs = today.getHours();
            var mnts = today.getMinutes();
            $('#txtInvoicedate').val(yyyy + '-' + mm + '-' + dd);
            scrollTo(0, 0);
        }
        function cancelScrapSales() {
            $("#grid_ScrapSales").show();
            $("#fillform_ScrapSales").hide();
            $('#show_logs_ScrapSales').show();
            forclearall1();
            emptytable = [];
        }
        function showdesignScrapMaterial() {
            forclearall();
            ScrapMaterialFixedRows();
            $("#grid_ScrapMaterial").hide();
            $("#fillformScrapMaterial").show();
            $('#showlogsScrapMaterial').hide();
            get_productcode();
            emptytable = [];
        }
        function cancelScrapMaterial() {
            forclearall();
            $("#grid_ScrapMaterial").show();
            $("#fillformScrapMaterial").hide();
            $('#showlogsScrapMaterial').show();
            emptytable = [];
        }
        $(document).click(function () {
            $('#ScrapSalestabledetails').on('change', '.clscost', calTotal)
                  .on('change', '.clsQty', calTotal);
            // find the value and calculate it
            function calTotal() {
                var $row = $(this).closest('tr'),
            price = $row.find('.clscost').val(),
            quantity = $row.find('.clsQty').val(),
            total = price * quantity;
                // change the value in total
                $row.find('.clstotal').val(total)
            }
        });

       

        function ScrapSalesFixedRows() {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid"  ID="ScrapSalestabledetails">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Rate</th><th scope="col">Quantity</th><th scope="col">SGST</th><th scope="col">CGST</th><th scope="col">IGST</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 1; i < 11; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;width:40px;" id="txtsno" >' + i + '</td>';
                results += '<td ><input id="txtProductName" type="text" class="clsproductname"   placeholder= "Enter Product Name" style="width:90px;" /><input id="txt_item_state" class="cls_item_state" type="text" style="display:none;" /></td>';
                results += '<td ><input id="txtCost" type="text"  class="clscost"  placeholder= "cost" onkeypress="return isFloat(event)"   style="width:90px;"/></td>'
                results += '<td ><input id="txtQty" type="text"  class="clsQty"  placeholder= "Enter Qty" onkeypress="return isFloat(event)"   style="width:90px;"/></td>';
                results += '<td ><span id="spn_sgst"></span><input id="txtsgst" type="text"  placeholder="SGST %" class="clssgst" readonly onkeypress="return isFloat(event)" style="width:50px;display:none;"/></td>';
                results += '<td ><span id="spn_cgst"></span><input id="txtcgst" type="text"  placeholder="CGST %" class="clscgst" readonly onkeypress="return isFloat(event)" style="width:50px;display:none;"/></td>';
                results += '<td ><span id="spn_igst"></span><input id="txtigst" type="text" class="clsigst" placeholder="IGST %" readonly onkeypress="return isFloat(event)"  style="width:50px;display:none;"/></td>';
                results += '<td style="display:none"><input id="hdnproductsno" type="hidden" /></td>';
                results += '<td data-title="Minus"><span><img src="images/minus.png" onclick="removerow(this)" style="cursor:pointer"/></span></td>';
                results += '<td style="display:none" class="4">' + i + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_ScrapSalesFixedRows").html(results);
        }
        function ScrapMaterialFixedRows() {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid"  ID="ScrapMaterialtabledetails">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Quantity</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 1; i < 11; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;width:40px;" id="txtsno" >' + i + '</td>';
                results += '<td ><input id="txtProductName" type="text" class="clsproductname"   placeholder= "Enter Product Name" style="width:90px;" /></td>';
                results += '<td ><input id="txtQty" type="text"  class="clsQty"  placeholder= "Enter Qty" onkeypress="return isFloat(event)"   style="width:90px;"/></td>';
                results += '<td style="display:none"><input id="hdnproductsno" type="hidden" /></td>';
                results += '<td data-title="Minus"><span><img src="images/minus.png" onclick="removerow(this)" style="cursor:pointer"/></span></td>';
                results += '<td style="display:none" class="4">' + i + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_ScrapMaterialFixedRows").html(results);
        }
        var supperdetails = [];
        function get_supplier() {
            var data = { 'op': 'get_supplier' };
            var s = function (msg) {
                if (msg) {
                    supperdetails = msg;
                    var availableTags = [];
                    for (i = 0; i < msg.length; i++) {
                        availableTags.push(msg[i].name);
                    }
                    $("#txtSuplyname").autocomplete({
                        source: function (req, responseFn) {
                            var re = $.ui.autocomplete.escapeRegex(req.term);
                            var matcher = new RegExp("^" + re, "i");
                            var a = $.grep(availableTags, function (item, index) {
                                return matcher.test(item);
                            });
                            responseFn(a);
                        },
                        change: Getsupplierid,
                        autoFocus: true
                    });
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        function Getsupplierid() {
            var name = document.getElementById('txtSuplyname').value;
            for (var i = 0; i < supperdetails.length; i++) {
                if (name == supperdetails[i].name) {
                    document.getElementById('txtsupid').value = supperdetails[i].supplierid;
                    document.getElementById('txt_sup_state').value = supperdetails[i].stateid;
                }
            }
        }
        function save_scrap_sales_click() {
            var hiddensupplyid = document.getElementById('txtsupid').value;
            var transportname = document.getElementById('txtTransport').value;
            var vehicleno = document.getElementById('txtvehcleno').value;
            var invoicetype = document.getElementById('ddltype').value;
            var invoiceno = document.getElementById('txtInvoiceno').value;
            var invoicedate = document.getElementById('txtInvoicedate').value;
            var remarks = document.getElementById('txt_remarks').value;
            var status = "p";
            var sno = document.getElementById('lbl_sno').value
            if (hiddensupplyid == "") {
                alert("Enter Supplier Name");
                return false;
            }
            if (invoicedate == "") {
                alert("Select  InvoiceDate");
                return false;
            }
            var btnval = document.getElementById('bttn_scrap_sales').innerHTML;
            var fillsales = [];
            $('#ScrapSalestabledetails> tbody > tr').each(function () {
                var txtsno = $(this).find('#txtSno').text();
                var productname = $(this).find('#txtProductName').val();
                var qty = $(this).find('#txtQty').val();
                var cost = $(this).find('#txtCost').val();
                var sgst = $(this).find('#spn_sgst').text();
                var cgst = $(this).find('#spn_cgst').text();
                var igst = $(this).find('#spn_igst').text();
                var subsno = $(this).find('#txt_salessno').val();
                var hdnproductsno = $(this).find('#hdnproductsno').val();
                if (hdnproductsno == "" || hdnproductsno == "0") {
                }
                else {
                    fillsales.push({ 'txtsno': txtsno, 'productname': productname, 'sgst': sgst, 'cgst': cgst, 'igst': igst, 'qty': qty, 'cost': cost, 'subsno': subsno, 'hdnproductsno': hdnproductsno });
                }
            });
            if (fillsales.length == 0) {
                alert("Please Select Product Names");
                return false;
            }
            var Data = { 'op': 'save_scrap_sales_click', 'invoiceno': invoiceno, 'hiddensupplyid': hiddensupplyid, 'invoicedate': invoicedate, 'transportname': transportname, 'invoicetype': invoicetype, 'vehicleno': vehicleno, 'btnval': btnval, 'remarks': remarks, 'sno': sno, 'status': status, 'fillsales': fillsales };
            var s = function (msg) {
                if (msg) {
                    alert(msg);
                    cancelScrapSales();
                    $("#grid_ScrapSales").show();
                    $("#fillform_ScrapSales").hide();
                    $('#show_logs_ScrapSales').show();
                    get_scrap_sales_details();
                }
            }
            var e = function (x, h, e) {
            };
            CallHandlerUsingJson(Data, s, e);
        }
        var filldescrption1 = [];
        function get_productcode() {
            var data = { 'op': 'get_product_details_po' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        filldata(msg);
                        filldescrption1 = msg;
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

        function filldata(msg) {
            var compiledList = [];
            for (var i = 0; i < msg.length; i++) {
                var name = msg[i].productname;
                compiledList.push(name);
            }

            $('.clsproductname').autocomplete({
                source: compiledList,
                change: test4,
                autoFocus: true
            });
        }

        var emptytable4 = [];
        function test4() {
            var sup_state = document.getElementById('txt_sup_state').value;
            var productname = $(this).val();
            var checkflag = true;
            var exists = 0;
            if (emptytable4.indexOf(productname) == -1) {
                for (var i = 0; i < filldescrption1.length; i++) {
                    if (productname == filldescrption1[i].productname) {
                        exists = 1;
                        if (filldescrption1[i].hsn_code != "") {
                            if (filldescrption1[i].igst != "") {
                                $(this).closest('tr').find('#hdnproductsno').val(filldescrption1[i].productid);
                                $(this).closest('tr').find('#txtCost').val(filldescrption1[i].price);
                                var item_state = filldescrption1[i].state;
                                if (sup_state != item_state) {
                                    $(this).closest('tr').find('#txtsgst').val("0");
                                    $(this).closest('tr').find('#txtcgst').val("0");
                                    $(this).closest('tr').find('#txtigst').val(filldescrption1[i].igst);
                                    $(this).closest('tr').find('#spn_sgst').text("0");
                                    $(this).closest('tr').find('#spn_cgst').text("0");
                                    $(this).closest('tr').find('#spn_igst').text(filldescrption1[i].igst);
                                }
                                else {
                                    $(this).closest('tr').find('#txtsgst').val(filldescrption1[i].sgst);
                                    $(this).closest('tr').find('#txtcgst').val(filldescrption1[i].cgst);
                                    $(this).closest('tr').find('#txtigst').val("0");
                                    $(this).closest('tr').find('#spn_sgst').text(filldescrption1[i].sgst);
                                    $(this).closest('tr').find('#spn_cgst').text(filldescrption1[i].cgst);
                                    $(this).closest('tr').find('#spn_igst').text("0");
                                }
                                emptytable4.push(productname);
                            }
                            else {
                                alert("Product without IGST or CGST or SGST cannot be added");
                                $(this).closest('tr').find('#txtDescription').val("");
                                return false;
                            }
                        }
                        else {
                            $(this).closest('tr').find('#hdnproductsno').val(filldescrption1[i].productid);
                            $(this).closest('tr').find('#txtCost').val(filldescrption1[i].price);
                            var item_state = filldescrption1[i].state;
                            if (sup_state != item_state) {
                                $(this).closest('tr').find('#txtsgst').val("0");
                                $(this).closest('tr').find('#txtcgst').val("0");
                                $(this).closest('tr').find('#txtigst').val(filldescrption1[i].igst);
                                $(this).closest('tr').find('#spn_sgst').text("0");
                                $(this).closest('tr').find('#spn_cgst').text("0");
                                $(this).closest('tr').find('#spn_igst').text(filldescrption1[i].igst);
                            }
                            else {
                                $(this).closest('tr').find('#txtsgst').val(filldescrption1[i].sgst);
                                $(this).closest('tr').find('#txtcgst').val(filldescrption1[i].cgst);
                                $(this).closest('tr').find('#txtigst').val("0");
                                $(this).closest('tr').find('#spn_sgst').text(filldescrption1[i].sgst);
                                $(this).closest('tr').find('#spn_cgst').text(filldescrption1[i].cgst);
                                $(this).closest('tr').find('#spn_igst').text("0");
                            }
                            emptytable4.push(productname);
                        }
                    }
                }
                if (exists == 0) {
                    for (var k = 0; k < filldescription3.length; k++) {
                        if (productname == filldescription3[k].productname) {
                            if (filldescription3[k].hsn_code != "") {
                                if (filldescription3[k].igst != "") {
                                    $(this).closest('tr').find('#hdnproductsno').val(filldescription3[k].productid);
                                    $(this).closest('tr').find('#txtCost').val("0");
                                    var item_state = filldescription3[k].state;
                                    if (sup_state != item_state) {
                                        $(this).closest('tr').find('#txtsgst').val("0");
                                        $(this).closest('tr').find('#txtcgst').val("0");
                                        $(this).closest('tr').find('#txtigst').val(filldescription3[k].igst);
                                        $(this).closest('tr').find('#spn_sgst').text("0");
                                        $(this).closest('tr').find('#spn_cgst').text("0");
                                        $(this).closest('tr').find('#spn_igst').text(filldescription3[k].igst);
                                    }
                                    else {
                                        $(this).closest('tr').find('#txtsgst').val(filldescription3[k].sgst);
                                        $(this).closest('tr').find('#txtcgst').val(filldescription3[k].cgst);
                                        $(this).closest('tr').find('#txtigst').val("0");
                                        $(this).closest('tr').find('#spn_sgst').text(filldescription3[k].sgst);
                                        $(this).closest('tr').find('#spn_cgst').text(filldescription3[k].cgst);
                                        $(this).closest('tr').find('#spn_igst').text("0");
                                    }
                                    emptytable4.push(productname);
                                }
                                else {
                                    alert("Product without IGST or CGST or SGST cannot be added");
                                    $(this).closest('tr').find('#txtDescription').val("");
                                    return false;
                                }
                            }
                            else {
                                $(this).closest('tr').find('#hdnproductsno').val(filldescription3[k].productid);
                                $(this).closest('tr').find('#txtCost').val("0");
                                var item_state = filldescription3[k].state;
                                if (sup_state != item_state) {
                                    $(this).closest('tr').find('#txtsgst').val("0");
                                    $(this).closest('tr').find('#txtcgst').val("0");
                                    $(this).closest('tr').find('#txtigst').val(filldescription3[k].igst);
                                    $(this).closest('tr').find('#spn_sgst').text("0");
                                    $(this).closest('tr').find('#spn_cgst').text("0");
                                    $(this).closest('tr').find('#spn_igst').text(filldescription3[k].igst);
                                }
                                else {
                                    $(this).closest('tr').find('#txtsgst').val(filldescription3[k].sgst);
                                    $(this).closest('tr').find('#txtcgst').val(filldescription3[k].cgst);
                                    $(this).closest('tr').find('#txtigst').val("0");
                                    $(this).closest('tr').find('#spn_sgst').text(filldescription3[k].sgst);
                                    $(this).closest('tr').find('#spn_cgst').text(filldescription3[k].cgst);
                                    $(this).closest('tr').find('#spn_igst').text("0");
                                }
                                emptytable4.push(productname);
                                //                            alert("Product cannot be added without HSN CODE");
                                //                            $(this).closest('tr').find('#txtDescription').val("");
                                //                            $(this).closest('tr').find('#txtCode_gst').val("");
                                //                            return false;
                            }
                        }
                    }
                }
            }
            else {
                alert("Product Name already added");
                var empt1 = "";
                $(this).val(empt1);
                $(this).focus();
                return false;
            }
        }











        var emptytable = [];
        function test1() {
            var name = $(this).val();
            var checkflag = true;
            if (emptytable.indexOf(name) == -1) {
                for (var i = 0; i < filldescrption.length; i++) {
                    if (name == filldescrption[i].ItemName) {
                        // $(this).closest('tr').find('#txt_perunitrs').val(filldescrption[i].price);
                        $(this).closest('tr').find('#hdnproductsno').val(filldescrption[i].itemid);
                        emptytable.push(name);
                    }
                }
            }
            else {
                alert("Product Name already added");
                var empt = "";
                $(this).val(empt);
                $(this).focus();
                return false;
            }
        }
        function get_scrap_sales_details() {
            var data = { 'op': 'get_scrap_sales_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillscrapsales(msg);
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
        var scrapsales_sub_list = [];
        function fillscrapsales(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr class="trbgclrcls"><th scope="col">Invoice Date</th><th scope="col">Supplier Name</th><th scope="col">Remarks</th><th scope="col"></th></tr></thead></tbody>';
            var scrapsalesdetails = msg[0].ScrapSalesDetails;
            scrapsales_sub_list = msg[0].SubScrapSalesDetails;

            var k = 1;
            var l = 0;
            //var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];

            for (var i = 0; i < scrapsalesdetails.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">';//<td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="Edit" /></td>
                // results += '<td><input id="btn_Print" type="button"   onclick="printstock(this);"  name="Edit" class="btn btn-primary" value="Print" /></td>'
                results += '<td scope="row" class="1"  >' + scrapsalesdetails[i].invoicedate + '</td>';
                results += '<td data-title="sectionstatus"  class="2">' + scrapsalesdetails[i].suppliername + '</td>';
                results += '<td data-title="sectionstatus" style="text-align:center;" class="3">' + scrapsalesdetails[i].remarks + '</td>';
                results += '<td data-title="sectionstatus" style="display:none;" class="4">' + scrapsalesdetails[i].transportname + '</td>';
                results += '<td data-title="sectionstatus"  style="display:none;" class="5">' + scrapsalesdetails[i].vehicleno + '</td>';
                results += '<td data-title="sectionstatus"  style="display:none;" class="6">' + scrapsalesdetails[i].status + '</td>';
                results += '<td data-title="sectionstatus" style="display:none;" class="7">' + scrapsalesdetails[i].hiddensupplyid + '</td>';
                results += '<td data-title="sectionstatus" style="display:none;" class="8">' + scrapsalesdetails[i].invoicetype + '</td>';
                results += '<td data-title="sectionstatus"  style="display:none;" class="9">' + scrapsalesdetails[i].invoiceno + '</td>';
                results += '<td data-title="brandstatus"><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"  onclick="getme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td>';
                results += '<td data-title="sectionstatus"  style="display:none;" class="10">' + scrapsalesdetails[i].sno + '</td></tr>';

                l = l + 1;
                if (l == 4) {
                    l = 0;
                }

            }
            results += '</table></div>';
            $("#grid_ScrapSales").html(results);
        }
        var sno = 0;
        function getme(thisid) {
            scrollTo(0, 0);
            ScrapSalesFixedRows();
            get_productcode();
            $("#grid_ScrapSales").hide();
            $("#fillform_ScrapSales").show();
            $('#show_logs_ScrapSales').hide();
            var invoicedate2 = $(thisid).parent().parent().children('.1').html();
            var suppliername = $(thisid).parent().parent().children('.2').html();
            var remarks = $(thisid).parent().parent().children('.3').html();
            var transportname = $(thisid).parent().parent().children('.4').html();
            var vehicleno = $(thisid).parent().parent().children('.5').html();
            var status = $(thisid).parent().parent().children('.6').html();
            var hiddensupplyid = $(thisid).parent().parent().children('.7').html();
            var invoicetype = $(thisid).parent().parent().children('.8').html();
            var invoiceno = $(thisid).parent().parent().children('.9').html();
            var sno = $(thisid).parent().parent().children('.10').html();

            var invoicedate1 = invoicedate2.split('-');
            var invoicedate = invoicedate1[2] + '-' + invoicedate1[1] + '-' + invoicedate1[0];

            document.getElementById('txtSuplyname').value = suppliername;
            document.getElementById('txtsupid').value = hiddensupplyid;
            document.getElementById('txtTransport').value = transportname;
            document.getElementById('txtInvoiceno').value = invoiceno;
            document.getElementById('txtInvoicedate').value = invoicedate;
            document.getElementById('txtvehcleno').value = vehicleno;
            document.getElementById('ddltype').value = invoicetype;
            document.getElementById('txt_remarks').value = remarks;
            document.getElementById('lbl_sno').value = sno;
            document.getElementById('bttn_scrap_sales').innerHTML = "Modify";
            var table = document.getElementById("ScrapSalestabledetails");
            var results = '<div  style="overflow:auto;"><table id="ScrapSalestabledetails" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Price</th><th scope="col">Quantity</th><th scope="col">Tax Value</th><th scope="col">Tax Type</th><th scope="col">Freight Amount</th><th scope="col"></th></tr></thead></tbody>';
            var k = 1;
            for (var i = 0; i < scrapsales_sub_list.length; i++) {
                if (sno == scrapsales_sub_list[i].sales_refno) {
                    results += '<tr><td data-title="Sno">' + k + '</td>';
                    results += '<td><input id="txtproductname" class="productcls"   value="' + scrapsales_sub_list[i].productname + '"></td>';
                    results += '<td><input id="txtCost" type="text" style="width:70px;" class="clscost" class="price" value="' + scrapsales_sub_list[i].cost + '"></td>';
                    results += '<td><input id="txtQty" type="text"  class="clsQty"   style="width:50px;"  value="' + scrapsales_sub_list[i].qty + '"></td>';
                    results += '<td><input id="txt_Tax" class="clstax" style="width:50px;" value="' + scrapsales_sub_list[i].taxvalue + '"></td>';
                    //results += '<td data-title="Phosps"><select id="ddltax" class="Taxtypecls" style="width:90px;" ><option value="' + Stocktransfer_sub_list[i].taxvalue + '"></option><option  value="' + Stocktransfer_sub_list[i].taxvalue + '"></option></select></td>';
                    results += '<td><input id="ddltax" class="Taxtypecls" value="' + scrapsales_sub_list[i].taxtype + '"></td>';
                    results += '<td><input id="txt_fright" class="clsfreigtamt" style="width:70px;" value="' + scrapsales_sub_list[i].freightamt + '"></td>';
                    results += '<td style="display:none"><input scope="row" type="hidden" id="txt_salessno" class="8" value="' + scrapsales_sub_list[i].subsno + '"></td>';
                    results += '<td data-title="Minus"><span><img src="images/minus.png" onclick="removerow(this)" style="cursor:pointer"/></span></td>';
                    results += '<td style="display:none"><input id="hdnproductsno"  type="hidden"  class="5" value="' + scrapsales_sub_list[i].hdnproductsno + '"></td></tr>';
                    k++
                }
            }
            results += '</table></div>';
            $("#div_ScrapSalesFixedRows").html(results);
        }

        function forclearall1() {
            document.getElementById('txtSuplyname').value = "";
            document.getElementById('txtsupid').value = "";
            document.getElementById('txtTransport').value = "";
            document.getElementById('txtInvoiceno').value = "";
            document.getElementById('txtInvoicedate').value = "";
            document.getElementById('txtvehcleno').value = "";
            document.getElementById('ddltype').selectedIndex = 0;
            document.getElementById('lbl_sno').value = "";
            document.getElementById('txt_remarks').value = "";
            document.getElementById('bttn_scrap_sales').innerHTML = "save";
            scrollTo(0, 0);
            var empty1 = [];
            var results = '<div  style="overflow:auto;"><table id="ScrapMaterialtabledetails" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Per Unit Rs</th><th scope="col">Quantity</th><th scope="col">Total Cost</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < empty1.length; i++) {
            }
            results += '</table></div>';
            $("#div_ScrapSalesFixedRows").html(results);

        }
        function save_scrap_Material_click() {
            var name = document.getElementById('txtName').value;
            if (name == "") {
                alert("Enter Name");
                return false;
            }
            var sectionname = document.getElementById('ddlname').value;
            if (sectionname == "" || sectionname == "Select Name") {
                alert("Select Section Name");
                return false;
            }
            var remarks = document.getElementById('MaterialRemarks').value;
            var btnval = document.getElementById('btn_scrap_material').innerHTML;
            var sno = document.getElementById('lbl_sno').value;
            var scrmaterial_array = [];
            $('#ScrapMaterialtabledetails> tbody > tr').each(function () {
                var txtsno = $(this).find('#txtSno').text();
                var productname = $(this).find('#txtProductname').val();
                var Quantity = $(this).find('#txtQty').val();
                var sno = $(this).find('#txt_sub_sno').val();
                var smsno = $(this).find('#txt_materialsno').val();
                var hdnproductsno = $(this).find('#hdnproductsno').val();
                if (hdnproductsno == "" || hdnproductsno == "0") {
                }
                else {
                    scrmaterial_array.push({ 'txtsno': txtsno, 'productname': productname, 'qty': Quantity, 'hdnproductsno': hdnproductsno, 'subsno': smsno });
                }
            });
            if (scrmaterial_array.length == 0) {
                alert("Please Select Product Names");
                return false;
            }
            var Data = { 'op': 'save_scrap_Material_click', 'btnval': btnval, 'sectionname': sectionname, 'remarks': remarks, 'name': name, 'sno': sno, 'scrmaterial_array': scrmaterial_array };
            var s = function (msg) {
                if (msg) {
                    alert(msg);
                    $("#grid_ScrapMaterial").show();
                    $("#fillformScrapMaterial").hide();
                    $('#showlogsScrapMaterial').show();
                    get_scrap_material_details();
                    //                    get_productcode();
                    cancelScrapMaterial();
                }
            }
            var e = function (x, h, e) {
            };
            CallHandlerUsingJson(Data, s, e);
        }
        function get_scrap_material_details() {
            var data = { 'op': 'get_scrap_material_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillscrapmaterials(msg);
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

        var submaterial_sub_list = [];
        function fillscrapmaterials(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr class="trbgclrcls"><th scope="col">Name</th><th scope="col">Section Name</th><th scope="col">Remarks</th><th scope="col"></th></tr></thead></tbody>';
            var materialdetails = msg[0].material;
            submaterial_sub_list = msg[0].submaterial;

            var k = 1;
            var l = 0;
            //var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];

            for (var i = 0; i < materialdetails.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">';//<td><input id="btn_poplate" type="button"  onclick="getmematerial(this)" name="submit" class="btn btn-primary" value="Edit" /></td>
                // results += '<td><input id="btn_Print" type="button"   onclick="printstock(this);"  name="Edit" class="btn btn-primary" value="Print" /></td>'
                results += '<td scope="row" class="1" " >' + materialdetails[i].name + '</td>';
                results += '<td data-title="sectionstatus"   class="2">' + materialdetails[i].sectionname + '</td>';
                results += '<td data-title="sectionstatus"  class="3">' + materialdetails[i].remarks + '</td>';
                results += '<td data-title="sectionstatus" style="display:none;" style="text-align:center;" class="4">' + materialdetails[i].sectionid + '</td>';
                results += '<td data-title="sectionstatus"  style="display:none;" class="5">' + materialdetails[i].doe + '</td>';
                results += '<td data-title="brandstatus"><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"  onclick="getmematerial(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td>';
                results += '<td data-title="sectionstatus" style="display:none;" class="6">' + materialdetails[i].sno + '</td></tr>';
                // results += '<td data-title="sectionstatus"  style="display:none;" class="10">' + scrapsalesdetails[i].sno + '</td></tr>';

                l = l + 1;
                if (l == 4) {
                    l = 0;
                }

            }
            results += '</table></div>';
            $("#grid_ScrapMaterial").html(results);
        }
        var sno = 0;
        function getmematerial(thisid) {
            scrollTo(0, 0);
            $("#grid_ScrapMaterial").hide();
            $("#fillformScrapMaterial").show();
            $('#showlogsScrapMaterial').hide();
            get_productcode();
            var name = $(thisid).parent().parent().children('.1').html();
            var sectionname = $(thisid).parent().parent().children('.2').html();
            var remarks = $(thisid).parent().parent().children('.3').html();
            var sectionid = $(thisid).parent().parent().children('.4').html();
            var doe = $(thisid).parent().parent().children('.5').html();
            var sno = $(thisid).parent().parent().children('.6').html();

            document.getElementById('txtName').value = name;
            document.getElementById('ddlname').value = sectionid;
            document.getElementById('MaterialRemarks').value = remarks;
            document.getElementById('lbl_sno').value = sno;
            document.getElementById('btn_scrap_material').innerHTML = "Modify";
            var table = document.getElementById("ScrapMaterialtabledetails");
            var results = '<div  style="overflow:auto;"><table id="ScrapMaterialtabledetails" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Quantity</th><th scope="col"></th></tr></thead></tbody>';
            var k = 1;
            for (var i = 0; i < submaterial_sub_list.length; i++) {
                if (sno == submaterial_sub_list[i].sm_refno) {
                    results += '<tr><td data-title="Sno">' + k + '</td>';
                    results += '<td><input id="txtproductname" class="productcls"   value="' + submaterial_sub_list[i].productname + '"></td>';
                    results += '<td><input id="txtQty" type="text"  class="clsQty"    value="' + submaterial_sub_list[i].qty + '"></td>';
                    results += '<td style="display:none;"><input scope="row" type="hidden" id="txt_materialsno" class="8" value="' + submaterial_sub_list[i].subsno + '"></td>';
                    results += '<td data-title="Minus"><span><img src="images/minus.png" onclick="removerow(this)" style="cursor:pointer"/></span></td>';
                    results += '<td style="display:none;"><input id="hdnproductsno"  type="hidden"  class="5" value="' + submaterial_sub_list[i].hdnproductsno + '"></td></tr>';
                    k++
                }
            }
            results += '</table></div>';
            $("#div_ScrapMaterialFixedRows").html(results);
        }

        function forclearall() {
            document.getElementById('txtName').value = "";
            document.getElementById('MaterialRemarks').value = "";
            document.getElementById('ddlname').selectedIndex = 0;
            document.getElementById('lbl_sno').value = "";
            document.getElementById('btn_scrap_material').innerHTML = "save";
            scrollTo(0, 0);
            var empty = [];
            var results = '<div  style="overflow:auto;"><table id="ScrapMaterialtabledetails" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Per Unit Rs</th><th scope="col">Quantity</th><th scope="col">Total Cost</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < empty.length; i++) {
            }
            results += '</table></div>';
            $("#div_ScrapMaterialFixedRows").html(results);
        }


        function get_section_details() {
            var data = { 'op': 'get_section_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillsections(msg);
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
        function fillsections(msg) {
            var data = document.getElementById('ddlname');
            var length = data.options.length;
            document.getElementById('ddlname').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select Name";
            opt.value = "Select Name";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].sectionname != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].sectionname;
                    option.value = msg[i].SectionId;
                    data.appendChild(option);
                }
            }
        }


    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Scrap Details
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operation</a></li>
            <li><a href="#">Scrap Details</a></li>
        </ol>
    </section>
    <section>
        <section class="content">
            <div class="box box-info">
                <div>
                    <ul class="nav nav-tabs">
                        <li id="id_tab_Personal" class="active"><a data-toggle="tab" href="#" onclick="showScrapMaterial()">
                            <i class="fa fa-street-view"></i>&nbsp;&nbsp;Scrap Material Details</a></li>
                        <li id="id_tab_documents" class=""><a data-toggle="tab" href="#" onclick="showScrapSales()">
                            <i class="fa fa-file-text"></i>&nbsp;&nbsp;Scrap Sales Details</a></li>
                    </ul>
                </div>
                <div id="divScrapMaterial">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Scrap Material Details
                        </h3>
                    </div>
                    <div class="box-body">
                        <div id="showlogsScrapMaterial" align="center">
                            <%--<input id="btn_ScrapMaterial" type="button" name="submit" value='ScrapMaterial' class="btn btn-primary" onclick="showdesignScrapMaterial()" />--%>
                            <div class="input-group" style="padding-left:85%">
                                <div class="input-group-addon">
                                    <span class="glyphicon glyphicon-plus-sign" onclick="showdesignScrapMaterial()"></span> <span id="btn_ScrapMaterial" onclick="showdesignScrapMaterial()">Scrap Material</span>
                                </div>
                            </div>
                        </div>
                        <div id="grid_ScrapMaterial" style="padding-top:2px;">
                        </div>
                        <div id='fillformScrapMaterial' style="display: none;">
                            <table align="center">
                                <tr>
                                    <td style="height: 40px;">
                                        <label>Name</label><span style="color: red;">*</span>
                                    </td>
                                    <td>
                                        <input id="txtName" type="text" class="form-control" name="Transport" placeholder="Enter Transport Name" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>Section Name</label><span style="color: red;">*</span>
                                    </td>
                                    <td>
                                        <select id="ddlname" class="form-control">
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>Remarks</label><span style="color: red;"></span></td>
                                    <td colspan="4">
                                        <textarea id="MaterialRemarks" class="form-control" type="text" rows="3" cols="35"
                                            placeholder="Enter Remarks"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <label id="lbl_sno" style="display: none;">
                                        </label>
                                    </td>
                                    <td style="height: 40px;">
                                        <input id="Hidden1" type="hidden" class="form-control" name="hiddensupplyid" />
                                    </td>
                                </tr>
                            </table>
                            <div id="div_ScrapMaterialFixedRows">
                            </div>
                            <table align="center">
                                <tr>
                                    <td>
                                        <%--<input id="btn_scrap_material" type="button" class="btn btn-primary" name="submit" value='save' onclick="save_scrap_Material_click()" />
                                        <input id='btn_cancel_scrap_Material' type="button" class="btn btn-danger" name="Close" value='Close' onclick="cancelScrapMaterial()" />--%>
                                        <table>
                                           <tr>
                                            <td>
                                            <div class="input-group">
                                                <div class="input-group-addon">
                                                <span class="glyphicon glyphicon-ok" id="btn_scrap_material1" onclick="save_scrap_Material_click()"></span> <span id="btn_scrap_material" onclick="save_scrap_Material_click()">save</span>
                                          </div>
                                          </div>
                                            </td>
                                            <td style="width:10px;"></td>
                                            <td>
                                             <div class="input-group">
                                                <div class="input-group-close">
                                                <span class="glyphicon glyphicon-remove" id='btn_cancel_scrap_Material1' onclick="cancelScrapMaterial()"></span> <span id='btn_cancel_scrap_Material' onclick="cancelScrapMaterial()">Close</span>
                                          </div>
                                          </div>
                                            </td>
                                            </tr>
                                             <input id="txt_sup_state" type="text" style="display:none;" />
                                <input id="txt_sup_gstin" type="text" style="display:none;" />
                                       </table>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
                <div id="divScrapSales" style="display: none;">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Scrap Sales Details
                        </h3>
                    </div>
                    <div class="box-body">
                        <div id="show_logs_ScrapSales" align="center">
                            <%--<input id="btn_ScrapSales" type="button" name="submit" value='ScrapSales' class="btn btn-primary" onclick="showScrapSalesdesign()" />--%>
                            <div class="input-group" style="padding-left:90%">
                                <div class="input-group-addon">
                                    <span class="glyphicon glyphicon-plus-sign" onclick="showScrapSalesdesign()"></span> <span id="btn_ScrapSales" onclick="showScrapSalesdesign()">Scrap Sales</span>
                                </div>
                            </div>
                        </div>
                        <div id="grid_ScrapSales" style="padding-top:2px;">
                        </div>
                        <div id='fillform_ScrapSales' style="display: none;">
                            <table align="center">
                                <tr>
                                    <td style="height: 40px;">
                                        <label>Buyer Name</label><span style="color: red;">*</span>
                                        <input id="txtSuplyname" type="text" class="form-control" name="Transport" placeholder="Enter Buyer Name" />
                                    </td>
                                    <td style="width:5px"></td>
                                    <td style="height: 40px;">
                                        <label>Transport Name:</label><span style="color: red;"></span>
                                        <input id="txtTransport" type="text" class="form-control" name="Transport" placeholder="Enter Transport Name" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>Vehicle Number</label><span style="color: red;"></span>
                                        <input id="txtvehcleno" type="text" class="form-control" placeholder="Enter Vehicle No"
                                            name="Transport" />
                                    </td>
                                    <td style="width:5px"></td>
                                    <td style="height: 40px;">
                                        <label>Select Type</label><span style="color: red;"></span>
                                        <select id="ddltype" class="form-control">
                                            <option value="Invoice">Invoice</option>
                                            <option value="WithOutInvoice">WithOutInvoice</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>Invoice Number</label><span style="color: red;"></span>
                                        <input id="txtInvoiceno" type="text" class="form-control" name="invoiceno" placeholder="Enter Invoice Number" />
                                    </td>
                                    <td style="width:5px"></td>
                                    <td style="height: 40px;">
                                        <label>Invoice Date</label><span style="color: red;">*</span>
                                        <div class="input-group date" style="width:100%;">
                                          <div class="input-group-addon cal">
                                            <i class="fa fa-calendar"></i>
                                          </div>
                                          <input id="txtInvoicedate" type="date" class="form-control" placeholder="Enter InvoiceDate" name="InvoiceDate" />
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" style="height: 40px;">
                                        <label>Remarks</label><span style="color: red;"></span>
                                        <textarea id="txt_remarks" class="form-control" type="text" rows="3" cols="35" placeholder="Enter Remarks"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <label id="lbl_sno" style="display: none;">
                                        </label>
                                    </td>
                                    <td style="height: 40px;">
                                        <input id="txtsupid" type="hidden" class="form-control" name="hiddensupplyid" />
                                    </td>
                                </tr>
                            </table>
                            <div id="div_ScrapSalesFixedRows">
                            </div>
                            <table align="center">
                                <tr>
                                    <td colspan="2" align="center" style="height: 40px;">
                                        <%--<input id="bttn_scrap_sales" type="button" class="btn btn-primary" name="submit" value='save' onclick="save_scrap_sales_click()" />
                                        <input id='btn_cancel_scrap_sales' type="button" class="btn btn-danger" name="Close" value='Close' onclick="cancelScrapSales()" />--%>
                                        <table>
                                           <tr>
                                            <td>
                                            <div class="input-group">
                                                <div class="input-group-addon">
                                                <span class="glyphicon glyphicon-ok" id="bttn_scrap_sales1" onclick="save_scrap_sales_click()"></span> <span id="bttn_scrap_sales" onclick="save_scrap_sales_click()">save</span>
                                          </div>
                                          </div>
                                            </td>
                                            <td style="width:10px;"></td>
                                            <td>
                                             <div class="input-group">
                                                <div class="input-group-close">
                                                <span class="glyphicon glyphicon-remove" id='btn_cancel_scrap_sales1' onclick="cancelScrapSales()"></span> <span id='btn_cancel_scrap_sales' onclick="cancelScrapSales()">Close</span>
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
            </div>
        </section>
    </section>
</asp:Content>
