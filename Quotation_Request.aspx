<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true"
    CodeFile="Quotation_Request.aspx.cs" Inherits="Quotation_Request" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
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
            get_quotation_req_det();
            get_supplier1();
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
        function ValidateAlpha(evt) {
            var keyCode = (evt.which) ? evt.which : evt.keyCode
            if ((keyCode < 65 || keyCode > 90) && (keyCode < 97 || keyCode > 123) && keyCode != 32)

                return false;
            return true;
        }
        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }

        var supperdetails1 = [];
        function get_supplier1() {
            var data = { 'op': 'get_supplier' };
            var s = function (msg) {
                if (msg) {
                    supperdetails = msg;
                    var availableTags = [];
                    for (i = 0; i < msg.length; i++) {
                        availableTags.push(msg[i].name);
                    }
                    $("#txt_sup").autocomplete({
                        source: function (req, responseFn) {
                            var re = $.ui.autocomplete.escapeRegex(req.term);
                            var matcher = new RegExp("^" + re, "i");
                            var a = $.grep(availableTags, function (item, index) {
                                return matcher.test(item);
                            });
                            responseFn(a);
                        },
                        //change: ravi,
                        autoFocus: true
                    });
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }

        function save_quotation_req() {
            var DataTable = [];
            $('#tabledetails> tbody > tr').each(function () {
                prod_code = $(this).find('#txt_prod').val();
                prod_id = $(this).find('#txt_prod_id').val();
                desc = $(this).find('#txt_desc').val();
                uom = $(this).find('#spn_uom').text();
                qty = $(this).find('#txt_qty').val();
                sno = $(this).find('#txt_sno').val();
                var abc = { prod_code: prod_code, prod_id: prod_id, desc: desc, uom: uom, qty: qty, sno: sno };
                if (prod_code == "" || prod_code == "0") {
                }
                else {
                    var abc = { prod_code: prod_code, prod_id: prod_id, desc: desc, uom: uom, qty: qty, sno: sno };
                    DataTable.push(abc);
                }
            });

            var indent_ref = document.getElementById('txt_indent_ref').value;
            if (document.getElementById('rdo_indent').checked == true) {
                if (indent_ref == "" || indent_ref == "0") {
                    alert("Enter indent reference Number");
                    return false;
                }
            }
            else if (document.getElementById('rdo_no_indent').checked == true) {
                
            }
            
            var sup_name = document.getElementById('txt_sup').value;
            if (sup_name == "") {
                alert("Enter Supplier Name");
                return false;
            }
            var quo_dt = document.getElementById('txt_quo_dt').value;
            if (quo_dt == "") {
                alert("Enter Quotation Date");
                return false;
            }
            if (DataTable.length < 1) {
                alert("Please Enter Product Details or Please Enter existing Indent Reference Number");
                return false;
            }
            var btn_save = document.getElementById('btn_save').innerHTML;
            var sno = document.getElementById('lbl_sno').value;
            var data = { 'op': 'save_quotation_req_det', 'sno': sno, 'sup_name': sup_name, 'indent_ref': indent_ref, 'quo_dt': quo_dt, 'DataTable': DataTable, 'btn_save': btn_save };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        clear_quotation_req();
                        get_quotation_req_det();

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
        function get_quotation_req_det() {
            var data = { 'op': 'get_quotation_req_det' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fill_quotation_det(msg);

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

        function fill_quotation_det(msg) {
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr class="trbgclrcls"><th scope="col">Quotation No</th><th scope="col">Quotation Date</th><th scope="col">Supplier Name</th><th scope="col">Indent No</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">';//<td><input id="btn_poplate" type="button"  onclick="update1(this)" name="Edit" class="btn btn-primary" value="Edit" /></td>
                results += '<td data-title="Quotation No" class="1" style="text-align:center;" >' + msg[i].quo_no + '</td>';
                results += '<td data-title="Quotation Date" class="2">' + msg[i].quo_dt + '</td>';
                results += '<td data-title="Supplier Name" class="3" style="text-align:center;">' + msg[i].sup_name + '</td>';
                results += '<td data-title="Supplier Name" class="5">' + msg[i].indent_ref + '</td>';
                results += '<td style="display:none;" data-title="Supplier Name" class="4">' + msg[i].sup_id + '</td>';
                results += '<td data-title="brandstatus"><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"  onclick="update1(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td>';
                results += '<td style="display:none;" data-title="sno" class="11">' + msg[i].sno + '</td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_quo_req").html(results);
        }

        function update1(thisid) {
            scrollTo(0, 0);
            document.getElementById('txt_indent_ref').readOnly = true;
            var quo_no = $(thisid).parent().parent().children('.1').html();
            var quo_dt2 = $(thisid).parent().parent().children('.2').html();
            var sup_name = $(thisid).parent().parent().children('.3').html();
            var sup_id = $(thisid).parent().parent().children('.4').html();
            var indent_ref = $(thisid).parent().parent().children('.5').html();
            var sno = $(thisid).parent().parent().children('.11').html();

            if (indent_ref == "") {
                $("#lbl_indent").css("display", "none");
                $("#txt_indent_ref").css("display", "none");
                $("#div_insert_row").css("display", "block");
                $("#btn_insert").css("display", "block");
                document.getElementById('rdo_no_indent').checked = true;
                document.getElementById('rdo_indent').checked = false;
            }
            else {
                document.getElementById('txt_indent_ref').value = indent_ref;
                document.getElementById('rdo_no_indent').checked = false;
                document.getElementById('rdo_indent').checked = true;
                $("#lbl_indent").css("display", "block");
                $("#txt_indent_ref").css("display", "block");
                $("#div_insert_row").css("display", "block");
                $("#btn_insert").css("display", "none");
            }

            var quo_dt1 = quo_dt2.split('-');
            var quo_dt = quo_dt1[2] + '-' + quo_dt1[1] + '-' + quo_dt1[0];

            document.getElementById('txt_quo_no').value = quo_no;
            document.getElementById('txt_quo_dt').value = quo_dt;
            document.getElementById('txt_sup').value = sup_name;
            document.getElementById('txt_sup_id').value = sup_id;
            document.getElementById('lbl_sno').value = sno;
            document.getElementById('btn_save').innerHTML = "Modify";
            var data = { 'op': 'get_quotation_sub_det', 'refno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fill_quotation_sub_det(msg);

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

        function fill_quotation_sub_det(msg) {
            $("#product_det").css("display", "block");
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr><th scope="col"></th><th scope="col">Product Code</th><th scope="col">Description</th><th scope="col">UOM</th><th scope="col">Quantity</th><th scope="col"></th></tr></thead></tbody>';
            for (var k = 0; k < msg.length; k++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + (k + 1) + '</td>';
                results += '<td ><span id="spn_prod">' + msg[k].sku + '</span><input id="txt_prod" type="text" placeholder="Enter Product Code" class="codecls" readonly style="width:135px;display:none;"   value="' + msg[k].sku + '"/></td>';
                results += '<td style="display:none;" ><input id="txt_prod_id" type="text" class="2"  style="width:135px;" value="' + msg[k].prod_id + '" /></td>';
                results += '<td ><span id="spn_desc">' + msg[k].desc + '</span><input id="txt_desc" type="text" placeholder="Enter Description" readonly class="clsdesc" style="width:135px;display:none;" value="' + msg[k].desc + '"/></td>';
                results += '<td ><span id="spn_uom">' + msg[k].uom + '</span><input id="txt_uom" type="text" placeholder="Enter UOM" readonly readonly="readonly" class="form-control" style="width:135px;display:none;" value="' + msg[k].uom + '"/></td>';
                results += '<td style="display:none;"><input id="txt_uom_sno" type="text" placeholder="Enter UOM" readonly="readonly" class="form-control" style="width:135px;" value="' + msg[k].uom1 + '"/></td>';
                results += '<td ><span id="spn_qty">' + msg[k].qty + '</span><input id="txt_qty" type="text" placeholder="Enter Quantity" readonly class="form-control" onkeypress="return isNumber(event)" style="width:135px;display:none;" value="' + msg[k].qty + '"/></td>';
                results += '<td data-title="From"><input class="form-control" type="hidden"  id="txt_sno"  name="" value="' + msg[k].sno + '" ></input></td></tr>';
            }
            results += '</table></div>';
            $("#div_insert_row").html(results);
        }

        function clear_quotation_req() {
            document.getElementById('txt_indent_ref').value = "";
            document.getElementById('txt_sup').value = "";
            document.getElementById('txt_quo_dt').value = "";
            document.getElementById('txt_indent_ref').readOnly = false;
            document.getElementById('btn_save').innerHTML = "Save";
            $("#lbl_indent").css("display", "block");
            $("#txt_indent_ref").css("display", "block");
            $("#div_insert_row").css("display", "none");
            $("#btn_insert").css("display", "none");
            document.getElementById('rdo_indent').checked = true;
            $("#product_det").css("display", "none");
            $("#tabledetails").css("display", "none");
            scrollTo(0, 0);
        }
        function indentnumber(txt_indentnumber) {
            $("#product_det").css("display", "block");
            var sno = document.getElementById('txt_indent_ref').value;
            var data = { 'op': 'get_Indent_Details_Outward', 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {

                        fillproductdetails(msg);

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

        function fillproductdetails(msg) {
            var SubIndentdetails = msg[0].SubIndent;
            var IndentDetails = msg[0].Indent;
            $("#div_insert_row").css("display", "block");
            var sno = document.getElementById('txt_indent_ref').value;
            var results = '<div  style="overflow:auto;"><table ID="tabledetails" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" >';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Code</th><th scope="col">Description</th><th scope="col">UOM</th><th scope="col">Quantity</th><th scope="col"></th></tr></thead></tbody>';
            var p = 1;
            for (var i = 0; i < IndentDetails.length; i++) {
                if (sno == IndentDetails[i].sno) {
                    for (var i = 0; i < SubIndentdetails.length; i++) {

                        results += '<tr><td data-title="Sno" class="1">' + p + '</td>';
                        results += '<td data-title="From"><span id="spn_prod">' + SubIndentdetails[i].sku + '</span><input id="txt_prod" readonly class="productcls" readonly name="productname" value="' + SubIndentdetails[i].sku + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;display:none;"></input></td>';
                        results += '<td style="display:none;" ><input id="txt_prod_id" type="text" class="2"  style="width:135px;" value="' + SubIndentdetails[i].hdnproductsno + '" /></td>';
                        results += '<td data-title="From"><span id="spn_desc">' + SubIndentdetails[i].productname + '</span><input class="desc" id="txt_desc" name="desc" readonly onkeypress="return isFloat(event)"  value="' + SubIndentdetails[i].productname + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;display:none;"></input></td>';
                        results += '<td data-title="From"><span id="spn_uom">' + SubIndentdetails[i].uim + '</span><input class="uom"  id="txt_uom" onkeypress="return isFloat(event)" readonly name="uom" value="' + SubIndentdetails[i].uim + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;display:none;"></input></td>';
                        results += '<td style="display:none;"><input id="txt_uom_sno" type="text" placeholder="Enter UOM" readonly="readonly" class="form-control" style="width:135px;" value="' + SubIndentdetails[i].uom + '"/></td>';
                        results += '<td data-title="From"><span id="spn_qty">' + SubIndentdetails[i].qty + '</span><input class="quantity" id="txt_qty" onkeypress="return isFloat(event)" name="Quantity" readonly value="' + SubIndentdetails[i].qty + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;display:none;"></input></td>';
                        results += '<td data-title="From"><input class="5" id="txt_sno" type="hidden" name="hdnproductsno" value="' + SubIndentdetails[i].sno + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td></tr>';
                        p++;
                    }
                }
            }
            results += '</table></div>';
            $("#div_insert_row").html(results);
        }

        var DataTable;
        function removerow(thisid) {
            $(thisid).parents('tr').remove();
        }

        function radio_checked() {
            if (document.getElementById('rdo_indent').checked == true) {
                clear_quotation_req();
                document.getElementById('rdo_indent').checked = true;
                $("#lbl_indent").css("display", "block");
                $("#txt_indent_ref").css("display", "block");
                $("#div_insert_row").css("display", "none");
                $("#btn_insert").css("display", "none");
            }
            else if (document.getElementById('rdo_no_indent').checked == true) {
                clear_quotation_req();
                document.getElementById('rdo_no_indent').checked = true;
                $("#lbl_indent").css("display", "none");
                $("#txt_indent_ref").css("display", "none");
                $("#div_insert_row").css("display", "block");
                $("#btn_insert").css("display", "block");
                GetFixedrows();
                get_productcode();
                emptytable = [];
                emptytable1 = [];
            }
        }
        
        function GetFixedrows() {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Code</th><th scope="col">Description</th><th scope="col">UOM</th><th scope="col">Quantity</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 1; i < 2; i++) {
                results += '<tr><td data-title="Sno" class="1">' + i + '</td>';
                results += '<td><input id="txt_prod"  class="productcls"  name="productname" placeholder="Enter Product Code" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                results += '<td style="display:none;" ><input id="txt_prod_id" type="text" class="2"  style="width:135px;" /></td>';
                results += '<td><input class="desc" id="txt_desc" name="desc" placeholder="Enter Product Description" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                results += '<td><span class="uom"  id="spn_uom" placeholder="Enter UOM" onkeypress="return isFloat(event)" readonly name="uom" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></span></td>';
                results += '<td style="display:none;"><input id="txt_uom_sno" type="text" placeholder="Enter UOM" readonly="readonly" class="form-control" style="width:135px;" /></td>';
                results += '<td><input class="quantity" placeholder="Enter Quanity" id="txt_qty" onkeypress="return isFloat(event)" name="Quantity"  style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                results += '<td><input class="5" id="txt_sno" type="hidden" name="sno" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                results += '<td><span><img src="images/minus.png" onclick="removerow(this)" style="cursor:pointer"/></span></td></tr>';
            }
            results += '</table></div>';
            $("#div_insert_row").html(results);
        }

        var DataTable;
        function insertrow() {
            DataTable = [];
            get_productcode();
            var prod = 0;
            var prod_id = 0;
            var desc = 0;
            var uom = 0;
            var uom_sno = 0;
            var qty = 0;
            var sno = 0;
            var txtsno = 0;

            var rows = $("#tabledetails tr:gt(0)");
            var rowsno = 1;
            $(rows).each(function (i, obj) {
                if ($(this).find('#txt_prod').val() != "") {
                    txtsno = rowsno;
                    prod = $(this).find('#txt_prod').val();
                    prod_id = $(this).find('#txt_prod_id').val();
                    desc = $(this).find('#txt_desc').val();
                    uom = $(this).find('#spn_uom').text();
                    uom_sno = $(this).find('#txt_uom_sno').val();
                    qty = $(this).find('#txt_qty').val();
                    sno = $(this).find('#txt_sno').val();
                    DataTable.push({ Sno: txtsno, prod: prod, prod_id: prod_id, desc: desc, uom: uom, uom_sno: uom_sno, qty: qty, sno: sno });
                    rowsno++;

                }
            });
            prod = 0;
            prod_id = 0;
            desc = 0;
            uom = 0;
            uom_sno = 0;
            qty = 0;
            sno = 0;
            var Sno = parseInt(txtsno) + 1;
            DataTable.push({ Sno: Sno, prod: prod, prod_id: prod_id, desc: desc, uom: uom, uom_sno: uom_sno, qty: qty, sno: sno });
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Code</th><th scope="col">Description</th><th scope="col">UOM</th><th scope="col">Quantity</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < DataTable.length; i++) {
                results += '<tr><td data-title="Sno" class="1">' + DataTable[i].Sno + '</td>';
                results += '<td><input id="txt_prod" placeholder="Enter Product Code" class="productcls" value="' + DataTable[i].prod + '" name="productname" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                results += '<td style="display:none;" ><input id="txt_prod_id" value="' + DataTable[i].prod_id + '" type="text" class="2"  style="width:135px;" /></td>';
                results += '<td><input class="desc" id="txt_desc" placeholder="Enter Product Description" name="desc"  value="' + DataTable[i].desc + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                results += '<td><span class="uom"  id="spn_uom" onkeypress="return isFloat(event)" readonly name="uom" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;">' + DataTable[i].uom + '</span></td>';
                results += '<td style="display:none;"><input id="txt_uom_sno" value="' + DataTable[i].uom_sno + '" type="text" placeholder="Enter UOM" readonly="readonly" class="form-control" style="width:135px;" /></td>';
                results += '<td><input class="quantity" placeholder="Enter Quantity" id="txt_qty" value="' + DataTable[i].qty + '" onkeypress="return isFloat(event)" name="Quantity"  style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                results += '<td><input class="5" id="txt_sno" value="' + DataTable[i].sno + '" type="hidden" name="sno" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                results += '<td><span><img src="images/minus.png" onclick="removerow(this)" style="cursor:pointer"/></span></td></tr>';
            }
            results += '</table></div>';
            $("#div_insert_row").html(results);
        }

        var filldescrption = [];
        var filldescrption1 = [];
        function get_productcode() {
            var data = { 'op': 'get_productissue_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        filldata(msg);
                        filldata1(msg);
                        filldescrption = msg;
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
                var sku = msg[i].sku;
                compiledList.push(sku);
            }

            $('.productcls').autocomplete({
                source: compiledList,
                change: test1,
                autoFocus: true
            });
        }
        var emptytable = [];
        function test1() {
            var sku = $(this).val();
            var checkflag = true;
            if (emptytable.indexOf(sku) == -1) {
                for (var i = 0; i < filldescrption.length; i++) {
                    if (sku == filldescrption[i].sku) {
                        $(this).closest('tr').find('#txt_desc').val(filldescrption[i].productname);
                        $(this).closest('tr').find('#txt_prod_id').val(filldescrption[i].productid);
                        $(this).closest('tr').find('#spn_uom').text(filldescrption[i].uim);
                        $(this).closest('tr').find('#txt_uom_sno').val(filldescrption[i].puim);
                        emptytable.push(sku);
                    }
                }
            }
            else {
                alert("Product Code already added");
                var empt = "";
                $(this).val(empt);
                $(this).focus();
                return false;
            }
        }

        function filldata1(msg) {
            var compiledList = [];
            for (var i = 0; i < msg.length; i++) {
                var productname = msg[i].productname;
                compiledList.push(productname);
            }

            $('.desc').autocomplete({
                source: compiledList,
                change: test2,
                autoFocus: true
            });
        }
        var emptytable1 = [];
        function test2() {
            var desc = $(this).val();
            var checkflag = true;
            if (emptytable1.indexOf(desc) == -1) {
                for (var i = 0; i < filldescrption1.length; i++) {
                    if (desc == filldescrption1[i].productname) {
                        $(this).closest('tr').find('#txt_prod_id').val(filldescrption1[i].productid);
                        $(this).closest('tr').find('#txt_prod').val(filldescrption1[i].sku);
                        $(this).closest('tr').find('#spn_uom').text(filldescrption1[i].uim);
                        $(this).closest('tr').find('#txt_uom_sno').val(filldescrption[i].puim);
                        emptytable1.push(desc);
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

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            REQUEST FOR QUOTATION
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i></a></li>
            <li><a href="#">REQUEST FOR QUOTATION</a></li>
        </ol>
    </section>
    <section class="content">
            <div class="box box-info">
                <div id="div_Account">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>REQUEST FOR QUOTATION
                        </h3>
                    </div>
                    <div class="box-body">
                        <div id="div_Emp">
                        </div>
                        <div id='fillform'>
                            <table align="center">
                                <tr>
                                    <th>
                                    </th>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                                <input id="rdo_indent" type="radio" name="selected" value="1" onclick="radio_checked();" checked="checked" />
                                                with Indent
                                                <input id="rdo_no_indent" type="radio" name="selected" value="0" onclick="radio_checked();" />
                                                without Indent
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label id="lbl_indent">
                                            Indent Refno<span style="color: red;">*</span></label>
                                    </td>
                                    <td style="height: 40px;">
                                        <input id="txt_indent_ref" class="form-control" placeholder="Enter Indent Refno" type="text"  name="indent_ref" onchange="indentnumber(this);" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            Supplier Name</label><span style="color: red;">*</span>
                                    </td>
                                    <td style="height: 40px;">
                                        <input id="txt_sup" class="form-control" placeholder="Enter Supplier Name" type="text"  name="sup_name"/>
                                        <input id="txt_sup_id" class="form-control" style="display:none" type="text"  name="sup_id"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            Quotation Date</label><span style="color: red;">*</span>
                                    </td>
                                    <td>
                                    <div class="input-group date">
                              <div class="input-group-addon cal">
                                <i class="fa fa-calendar"></i>
                              </div>
                             <input id="txt_quo_dt" class="form-control" type="date" name="quo_dt"/>
                                       
                            </div>
                                         <input id="txt_quo_no" style="display:none" class="form-control" type="text" name="quo_no"/>
                                    </td>
                                </tr>
                            </table>
                            
                            <div>
                            <table id="product_det" style="display:none">
                                 <tr>
                                    <td>
                                    <label>
                                        Product Details : </label>
                                </td>
                                </tr>
                            </table>
                            <div id="div_insert_row">
                            </div>
                            </div>
                            <table id="btn_insert" style="display:none">
                                <tr>
                                    <td>
                                        <div class="input-group" style="padding-right: 16px;">
                                            <div class="input-group-addon">
                                                <span class="glyphicon glyphicon-plus-sign" onclick="insertrow()"></span> <span onclick="insertrow()">ADD NEW ROW</span>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </table>

                            <table align="center">
                            <tr hidden>
                                <td>
                                    <label id="lbl_sno">
                                    </label>
                                </td>
                            </tr>
                                <tr>
                                 <td>
                                    </td>
                                    <td style="height: 40px;">
                                        <table>
                                           <tr>
                                            <td>
                                            <div class="input-group">
                                                <div class="input-group-addon">
                                                <span class="glyphicon glyphicon-ok" id="btn_save1" onclick="save_quotation_req()"></span> <span id="btn_save" onclick="save_quotation_req()">Save</span>
                                          </div>
                                          </div>
                                            </td>
                                            <td style="width:10px;"></td>
                                            <td>
                                             <div class="input-group">
                                                <div class="input-group-close">
                                                <span class="glyphicon glyphicon-remove" id='btn_clear1' onclick="clear_quotation_req()"></span> <span id='btn_clear' onclick="clear_quotation_req()">RESET</span>
                                          </div>
                                          </div>
                                            </td>
                                            </tr>
                                       </table>
                                    </td>
                                </tr>
                            </table>
                            <div id="div_quo_req">
                            </div>
                        </div>
                    </div>
                    
                </div>
            </div>

        </section>
</asp:Content>
