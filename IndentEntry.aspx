<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true"
    CodeFile="IndentEntry.aspx.cs" Inherits="IndentEntry" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            $('#add_Indent').click(function () {
                $('#Indent_fillform').css('display', 'block');
                $('#showlogs').css('display', 'none');
                $('#div_editIndent').hide();
                GetFixedrows();
                get_productcode();
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
                $('#txt_inwarddate').val(yyyy + '-' + mm + '-' + dd);
                scrollTo(0, 0);

            });
            $('#Close_Indent').click(function () {
                $('#Indent_fillform').css('display', 'none');
                $('#showlogs').css('display', 'block');
                $('#div_editIndent').show();
                forclearall();
                emptytable = [];
            });
            get_Approvel_internal_details();
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
            $('#txt_inwarddate').val(yyyy + '-' + mm + '-' + dd);
            emptytable = [];
            scrollTo(0, 0);
        });
        function isFloat(evt) {
            var charCode = (event.which) ? event.which : event.keyCode;
            if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            else {
              
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
        function ValidateAlpha(evt) {
            var keyCode = (evt.which) ? evt.which : evt.keyCode
            if ((keyCode < 65 || keyCode > 90) && (keyCode < 97 || keyCode > 123) && keyCode != 32)

                return false;
            return true;
        }
        function isFloat(evt) {
            var charCode = (event.which) ? event.which : event.keyCode;
            if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            else {
                var parts = evt.srcElement.value.split('.');
                if (parts.length > 1 && charCode == 46)
                    return false;
                return true;

            }
        }
        function GetFixedrows() {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Avail Quantity</th><th scope="col">Quantity</th></tr></thead></tbody>';//<th scope="col">Totalcost</th>
            for (var i = 1; i < 2; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + i + '</td>';
                results += '<td ><input id="txtProductname" type="text" class="productcls"  placeholder= "Enter Product Name"/></td>';
                results += '<td ><span id="spn_avail_qty"></span><input id="txt_avail_qty" style="display:none" class="avail_qty" type="text" placeholder= "Available Stores" onkeypress="return isFloat(event)" readonly/></td>';
                results += '<td ><input id="txt_quantity" type="text" class="quantity" placeholder= "Enter Qty" onkeypress="return isFloat(event)"/></td>';// onchange="qtychage(this);"
                results += '<td style="display:none;"><input id="hdnproductsno" type="hidden" /></td>';
                results += '<td><span><img src="images/minus.png" onclick="removerow(this)" style="cursor:pointer"/></span></td>';
                results += '<td style="display:none" class="4">' + i + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_ProductsData").html(results);
        }
        var DataTable;
        function barcode() {
            get_productcode();
            DataTable = [];
            var rows = $("#tabledetails tr:gt(0)");
            var txtsno = 0;
            var rowsno = 1;
            $(rows).each(function (i, obj) {
                if ($(this).find('#txtProductname').val() != "") {
                    txtsno = rowsno;
                    productname = $(this).find('#txtProductname').val();
                    avail_qty = $(this).find('#txt_avail_qty').val();
                    Quantity = $(this).find('#txt_quantity').val();
                    sisno = $(this).find('#subsno').val();
                    hdnproductsno = $(this).find('#hdnproductsno').val();
                    DataTable.push({ Sno: txtsno, productname: productname, avail_qty: avail_qty, Quantity: Quantity, hdnproductsno: hdnproductsno });//, TotalCost: TotalCost
                    rowsno++;
                }
            });
            var productname = 0;
            var avail_qty = 0;
            var Quantity = 0;
            var status = 0;
            var sisno = 0;
            var hdnproductsno = 0;
            var Sno = parseInt(txtsno) + 1;
            DataTable.push({ Sno: Sno, productname: productname, avail_qty: avail_qty, Quantity: Quantity, hdnproductsno: hdnproductsno });//, TotalCost: TotalCost
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Avail Quantity</th><th scope="col">Quantity</th></tr></thead></tbody>';//<th scope="col">TotalCost</th>
            for (var i = 0; i < DataTable.length; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + DataTable[i].Sno + '</td>';
                results += '<td ><input id="txtProductname" type="text" class="productcls" value="' + DataTable[i].productname + '"/></td>';
                results += '<td ><span id="spn_avail_qty">' + DataTable[i].avail_qty + '</span><input id="txt_avail_qty" type="text" class="avail_qty" readonly  style="display:none" value="' + DataTable[i].avail_qty + '"/></td>';
                results += '<td ><input id="txt_quantity" type="text" class="quantity"  onkeypress="myFunction()"  value="' + DataTable[i].Quantity + '"/></td>';
                results += '<td style="display:none"><input id="hdnproductsno" type="hidden" value="' + DataTable[i].hdnproductsno + '"/></td>';
                results += '<td><span><img src="images/minus.png" onclick="removerow(this)" style="cursor:pointer"/></span></td>';
                results += '<td style="display:none" class="4">' + i + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_ProductsData").html(results);
        }

        $(document).click(function () {
            $('#tabledetails').on('change', '.price', calTotal)
                  .on('change', '.quantity', calTotal);
            function calTotal() {
                var $row = $(this).closest('tr'),
            price = $row.find('.price').val(),
            quantity = $row.find('.quantity').val(),
            total = price * quantity;
            
                $row.find('.Total').val(total)
            }

        });
        var DataTable;
        function removerow(thisid) {
            $(thisid).parents('tr').remove();
        }
        function save_Indent() {
            var idate = document.getElementById('txt_inwarddate').value;
            var name = document.getElementById('txt_Name').value;
            var remarks = document.getElementById('txt_remarks').value;
            var sno = document.getElementById('lbl_sno').value;
            var btnval = document.getElementById('btn_RaisePO').innerHTML;
            var sectionname = document.getElementById('ddlname').value;
            if (sectionname == "") {
                alert("Select Section Name");
                return false;
            }
            if (idate == "") {
                alert("Enter I_date");
                return false;
            }
            if (name == "") {
                alert("Enter Name");
                return false;
            }

            if (remarks == "") {
                alert("Enter Remarks");
                return false;
            }
            var fillindent = [];
            $('#tabledetails> tbody > tr').each(function () {
                var txtsno = $(this).find('#txtSno').text();
                var productname = $(this).find('#txtProductname').val();
                var avail_qty = $(this).find('#txt_avail_qty').val();
                var Quantity = $(this).find('#txt_quantity').val();
                var sisno = $(this).find('#subsno').val();
                var sno = $(this).find('#txt_sub_sno').val();
                var hdnproductsno = $(this).find('#hdnproductsno').val();
                if (hdnproductsno == "" || hdnproductsno == "0") {
                }
                else {

                    fillindent.push({ 'txtsno': txtsno, 'productname': productname, 'avail_qty': avail_qty, 'qty': Quantity, 'hdnproductsno': hdnproductsno, 'sisno': sisno });//, 'price': PerUnitRs
                }
            });
            if (fillindent.length == 0) {
                alert("Please Select Product Names");
                return false;
            }
            var Data = { 'op': 'save_Indent', 'idate': idate, 'name': name, 'sectionname': sectionname, 'remarks': remarks, 'btnval': btnval, 'sno': sno, 'fillindent': fillindent };
            var s = function (msg) {
                if (msg) {
                    alert(msg);
                    forclearall();
                    get_Approvel_internal_details();
                    $('#Indent_fillform').css('display', 'none');
                    $('#showlogs').css('display', 'block');
                    $('#div_editIndent').show();
                }
            }
            var e = function (x, h, e) {
            };
            CallHandlerUsingJson(Data, s, e);
        }
        function get_Approvel_internal_details() {
            var data = { 'op': 'get_Approvel_internal_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillIndent(msg);
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

        var indent_subdetails = [];
        function fillIndent(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr class="trbgclrcls"><th scope="col">Name</th><th scope="col">MRF Date</th><th scope="col">Section Name</th><th scope="col">Remarks</th><th scope="col"></th></tr></thead></tbody>';
            indent_subdetails = msg[0].SubIndent;
            var indent = msg[0].Indent;
            var k = 1;
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            for (var i = 0; i < indent.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">';//<td><input id="btn_poplate" type="button"  onclick="update(this)" name="Edit" class="btn btn-primary" value="Edit" /></td>
                results += '<td data-title="inwardno" class="1">' + indent[i].name + '</td>';
                results += '<td data-title="invoiceno" class="2" style="width:83px">' + indent[i].idate + '</td>';
                results += '<td data-title="invoiceno" class="8">' + indent[i].sectionname + '</td>';
                results += '<td data-title="inwarddate" style="display:none;" class="3">' + indent[i].ddate + '</td>';
                results += '<td data-title="invoicedate"  class="4">' + indent[i].remarks + '</td>';
                results += '<td data-title="dcno" class="5" style="display:none;">' + indent[i].status + '</td>';
                results += '<td data-title="dcno" class="6" style="display:none;">' + indent[i].sectionid + '</td>';
                results += '<td data-title="brandstatus"><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"  onclick="update(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td>';
                results += '<td data-title="name" class="7" style="display:none;" >' + indent[i].sno + '</td></tr>';

                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_editIndent").html(results);
        }
        var sno = 0;
        function update(thisid) {
            scrollTo(0, 0);
            $('#Indent_fillform').css('display', 'block');
            $('#showlogs').css('display', 'none');
            $('#div_editIndent').hide();
            get_productcode();
            var name = $(thisid).parent().parent().children('.1').html();
            var idate2 = $(thisid).parent().parent().children('.2').html();
            var ddate = $(thisid).parent().parent().children('.3').html();
            var remarks = $(thisid).parent().parent().children('.4').html();
            var status = $(thisid).parent().parent().children('.5').html();
            var sectionid = $(thisid).parent().parent().children('.6').html();
            var sno = $(thisid).parent().parent().children('.7').html();

            var idate1 = idate2.split('-');
            var idate = idate1[2] + '-' + idate1[1] + '-' + idate1[0];

            document.getElementById('txt_Name').value = name;
            document.getElementById('ddlname').value = sectionid;
            document.getElementById('txt_inwarddate').value = idate;
            document.getElementById('txt_remarks').value = remarks;
            document.getElementById('lbl_sno').value = sno;
            document.getElementById('btn_RaisePO').innerHTML = "Modify";
            var table = document.getElementById("tabledetails");
            var results = '<div  style="overflow:auto;"><table ID="tabledetails" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" >';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Quantity</th></tr></thead></tbody>';//<th scope="col">Price</th>
            var k = 1;
            for (var i = 0; i < indent_subdetails.length; i++) {
                if (sno == indent_subdetails[i].inword_refno) {
                    results += '<tr><td data-title="Sno" class="1">' + k + '</td>';
                    results += '<td data-title="From"><span id="spn_Productname">' + indent_subdetails[i].productname + '</span><input id="txtProductname" class="productcls" readonly name="productname" value="' + indent_subdetails[i].productname + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;display:none;"></input></td>';
                    results += '<td style="display:none;"><input id="txt_avail_qty" type="text"  class="avail_qty" readonly  value="' + indent_subdetails[i].availqty + '"/></td>';
                    results += '<td data-title="From"><input id="txt_quantity" class="quantity"  name="quantity" placeholder="Enter Quantity" onkeypress="return isFloat(event)" value="' + indent_subdetails[i].qty + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<td data-title="From" style="display:none"><input class="6" id="hdnproductsno" type="hidden" name="hdnproductsno" value="' + indent_subdetails[i].hdnproductsno + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input>';
                    results += '<td data-title="From" style="display:none"><input class="7" id="subsno" type="hidden" name="subsno" value="' + indent_subdetails[i].sno + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input>';
                    results += '<td data-title="From"  style="display:none;"><input class="7" id="txt_sub_sno" name="txt_sub_sno" value="' + indent_subdetails[i].inword_refno + '"style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td></tr>';
                    k++;
                }
            }
            results += '</table></div>';
            $("#div_ProductsData").html(results);
        }
        var filldescrption = [];
        function get_productcode() {
            var data = { 'op': 'get_productissue_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {

                        filldata(msg);
                        filldescrption = msg;
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

            $('.productcls').autocomplete({
                source: compiledList,
                change: test1,
                autoFocus: true
            });
        }
        var emptytable = [];
        function test1() {
            var name = $(this).val();
            var checkflag = true;
            if (emptytable.indexOf(name) == -1) {
                for (var i = 0; i < filldescrption.length; i++) {
                    if (name == filldescrption[i].productname) {
                        $(this).closest('tr').find('#txt_avail_qty').val(filldescrption[i].moniterqty);
                        $(this).closest('tr').find('#spn_avail_qty').text(filldescrption[i].moniterqty);
                        $(this).closest('tr').find('#hdnproductsno').val(filldescrption[i].productid);
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

        function myFunction() {
            if (event.keyCode == 46 || event.keyCode == 110 || event.keyCode == 8 || event.keyCode == 9 || event.keyCode == 27 || event.keyCode == 13 || event.keyCode == 190 ||
            // Allow: Ctrl+A
            (event.keyCode == 65 && event.ctrlKey === true) ||
            // Allow: home, end, left, right
            (event.keyCode >= 35 && event.keyCode <= 39)) {
                // let it happen, don't do anything
                return;
            }
            else {
                // Ensure that it is a number and stop the keypress
                if (event.shiftKey || (event.keyCode < 48 || event.keyCode > 57) && (event.keyCode < 96 || event.keyCode > 105)) {
                    event.preventDefault();
                }
            }
        }
        function forclearall() {
            document.getElementById('txt_inwarddate').value = "";
            document.getElementById('txt_Name').value = "";
            document.getElementById('txt_remarks').value = "";
            document.getElementById('btn_RaisePO').innerHTML = "Save";
            var empty = [];
            var results = '<div  style="overflow:auto;"><table id="tabledetails" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Avail Quantity</th><th scope="col">Quantity</th><th scope="col">Total Cost</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < empty.length; i++) {
            }
            results += '</table></div>';
            $("#div_ProductsData").html(results);
            scrollTo(0, 0);
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Material Requisition Details<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operations</a></li>
            <li><a href="#">Material Requisition</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Material Requisition Details
                </h3>
            </div>
            <div class="box-body">
                <div id="showlogs" align="center">
                    <div class="input-group" style="padding-left:89%">
                        <div class="input-group-addon">
                            <span class="glyphicon glyphicon-plus-sign"></span> <span id="add_Indent">Add Indent</span>
                        </div>
                    </div>
                </div>
                <div id="div_editIndent" style="padding-top:2px;">
                </div>
                <div id='Indent_fillform' style="display: none;">
                    <table align="center" style="width:72%;">
                        <tr>
                            <td>
                                <label>
                                    Indent Name</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_Name" class="form-control" type="text" placeholder="Enter Indent Name" />
                            </td>
                            <td style="width:2%;"></td>
                            <td>
                                <label>
                                   MRF Date</label>
                            </td>
                            <td style="height: 40px;">
                                <div class="input-group date">
                                  <div class="input-group-addon cal">
                                    <i class="fa fa-calendar"></i>
                                  </div>
                                  <input id="txt_inwarddate" type="date" class="form-control" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Section Name
                                </label>
                            </td>
                            <td style="height: 40px;">
                                <select id="ddlname" class="form-control">
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Remarks</label>
                            </td>
                            <td colspan="4">
                                <textarea id="txt_remarks" class="form-control" type="text" rows="3" cols="35" placeholder="Enter Remarks"></textarea>
                            </td>
                            <td>
                                <label id="lbl_sno" style="display: none;">
                                </label>
                            </td>
                        </tr>
                    </table>
                    <br />
                    <div class="box box-info">
                        <div class="box-header with-border">
                            <h3 class="box-title">
                                <i style="padding-right: 5px;" class="fa fa-list"></i>Select Product(s)
                            </h3>
                        </div>
                        <div class="box-body">
                            <div id="div_ProductsData">
                            </div>
                            <div id="">
                            </div>
                            <table>
                                <tr>
                                    <td>
                                    </td>
                                    <td style="height: 40px;">
                                        <div class="input-group" style="padding-right: 16px;">
                                            <div class="input-group-addon">
                                                <span class="glyphicon glyphicon-plus-sign" onclick="barcode()"></span> <span onclick="barcode()">ADD NEW ROW</span>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    <table align="center">
                        <tr>
                            <td>
                                <table>
                                   <tr>
                                    <td>
                                    <div class="input-group">
                                        <div class="input-group-addon">
                                            <span class="glyphicon glyphicon-ok" id="btn_RaisePO1" onclick="save_Indent()"></span> <span id="btn_RaisePO" onclick="save_Indent()">Save</span>
                                        </div>
                                    </div>
                                    </td>
                                    <td style="width:10px;"></td>
                                    <td>
                                     <div class="input-group">
                                        <div class="input-group-close">
                                        <span class="glyphicon glyphicon-remove" id='Close_Indent1'></span> <span id='Close_Indent'>Close</span>
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
