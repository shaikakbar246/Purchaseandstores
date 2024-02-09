<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true" CodeFile="Stock_Transfer_Inward_Approval.aspx.cs" Inherits="Stock_Transfer_Inward_Approval" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        $(function () {
            get_approve_Stock_Tranfer_Inward_click();

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
            $('#txt_inward_date').val(yyyy + '-' + mm + '-' + dd);
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

        function get_approve_Stock_Tranfer_Inward_click() {
            var data = { 'op': 'get_approve_Stock_Tranfer_Inward' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fill_st_inward_det(msg);
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

        function fill_st_inward_det(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr class="trbgclrcls"><th scope="col">From Branch</th><th scope="col">Branch Transfer No/Invoice No</th><th scope="col">Branch Transfer Date/Invoice Date</th><th scope="col">Vehicle No</th><th scope="col">Transport Name</th><th scope="col"></th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];

            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">';//<td><input id="btn_poplate" type="button"  onclick="getme(this)" name="Approval" class="btn btn-primary" value="Approval" /></td>
                results += '<td scope="row" class="1" >' + msg[i].barnchname + '</td>';
                results += '<td style="display:none;" class="7" >' + msg[i].frombranch + '</td>';
                results += '<td class="2">' + msg[i].invoiceno + '</td>';
                results += '<td class="3">' + msg[i].invoicedate + '</td>';
                results += '<td class="5">' + msg[i].vehicleno + '</td>';
                results += '<td class="8">' + msg[i].transportname + '</td>';
                results += '<td data-title="brandstatus"><button type="button" title="Click Here To Approve!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 apprvcls"  onclick="getme(this)"><span class="glyphicon glyphicon-thumbs-up" style="top: 0px !important;"></span></button></td>';
                results += '<td data-title="sno" class="6" style="display:none;">' + msg[i].sno + '</td></tr>';
                
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_stocktransfer").html(results);
        }

        function getme(thisid) {
            var branchname = $(thisid).parent().parent().children('.1').html();
            var vehicleno = $(thisid).parent().parent().children('.5').html();
            var sno = $(thisid).parent().parent().children('.6').html();
            var frombranch = $(thisid).parent().parent().children('.7').html();
            var transportname = $(thisid).parent().parent().children('.8').html();
            var inv_date2 = $(thisid).parent().parent().children('.3').html();

            var inv_date1 = inv_date2.split('-');
            var inv_date = inv_date1[2] + '-' + inv_date1[1] + '-' + inv_date1[0];

            document.getElementById('txt_inv_or_bt_date').value = inv_date;
            document.getElementById('txt_frombranch').value = branchname;
            document.getElementById('txt_frombranch_id').value = frombranch;
            document.getElementById('lbl_sno').value = sno;
            document.getElementById('txt_vehicle_no').value = vehicleno;
            document.getElementById('txt_transport_name').value = transportname;

            var data = { 'op': 'get_approve_Stock_Tranfer_Inward_sub', 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fill_st_inward_sub_det(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
            $('#inward_fill_form').css('display', 'block');
            $('#div_stocktransfer').css('display', 'none');
        }

        function fill_st_inward_sub_det(msg) {
            var gst_exists = msg[0].gst_exists;
            if (gst_exists == "0") {
                var results = '<div  style="overflow:initial;"><table id="tabledetails_sub" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
                results += '<thead><tr><th scope="col" style="text-align:center;">Sno</th><th scope="col" style="text-align:center;">Product Name</th><th scope="col" style="text-align:center;">Quantity</th><th scope="col" style="text-align:center;">Price</th><th scope="col" style="text-align:center;">Tax</th><th></th></tr></thead></tbody>';
                var k = 1;
                for (var i = 0; i < msg.length; i++) {
                    results += '<tr><td scope="row" style="text-align:center;">' + k + '</td>';
                    results += '<td  style="display:none;"><span id="spn_productid">' + msg[i].productid + '</span></td>';
                    //results += '<td  style="display:none;"><span id="spn_gst_exists">' + msg[i].gst_exists + '</span></td>';
                    results += '<td ><span id="spn_productname">' + msg[i].productname + '</span></td>';
                    results += '<td data-title="From"><span id="spn_quantity">' + msg[i].quantity + '</span><input id="txt_quantity" readonly class="qty"  name="quantity" onkeypress="return isFloat(event)"  value="' + msg[i].quantity + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;display:none;"></input></td>';
                    results += '<td ><span id="spn_price">' + msg[i].price + '</span><input id="txt_price" readonly class="price"  name="price" onkeypress="return isFloat(event)"  value="' + msg[i].price + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;display:none;"></input></td>';
                    results += '<td ><span id="spn_taxvalue">' + msg[i].taxvalue + '</span><input id="txt_tax" readonly class="tax"  name="tax" onkeypress="return isFloat(event)"  value="' + msg[i].taxvalue + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;display:none;"></input></td>';
                    results += '<td ><span id="spn_tot_amt" class="tot_amt"></span></td>';//<label id="lbl_tot_amt" class="tot_amt"></label>
                    results += '</tr>';
                    k++
                }
                results += '</table></div>';
                $("#div_SectionData").html(results);
                calTotal();
            }
            else {
                var results = '<div  style="overflow:initial;"><table id="tabledetails_sub_gst" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
                results += '<thead><tr><th scope="col" style="text-align:center;">Sno</th><th scope="col" style="text-align:center;">Product Name</th><th scope="col" style="text-align:center;">Quantity</th><th scope="col" style="text-align:center;">Price</th><th scope="col" style="text-align:center;">SGST</th><th scope="col" style="text-align:center;">CGST</th><th scope="col" style="text-align:center;">IGST</th></tr></thead></tbody>';
                var k = 1;
                for (var i = 0; i < msg.length; i++) {
                    results += '<tr><td scope="row" style="text-align:center;">' + k + '</td>';
                    results += '<td  style="display:none;"><span id="spn_productid">' + msg[i].productid + '</span></td>';
                    results += '<td ><span id="spn_productname">' + msg[i].productname + '</span></td>';
                    results += '<td data-title="From"><span id="spn_quantity">' + msg[i].quantity + '</span><input id="txt_quantity" readonly class="qty"  name="quantity" onkeypress="return isFloat(event)"  value="' + msg[i].quantity + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;display:none;"></input></td>';
                    results += '<td ><span id="spn_price">' + msg[i].price + '</span><input id="txt_price" readonly class="price"  name="price" onkeypress="return isFloat(event)"  value="' + msg[i].price + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;display:none;"></input></td>';
                    results += '<td ><span id="spn_sgst">' + msg[i].sgst_per + '</span><input id="txt_sgst" readonly class="sgst"  name="price" onkeypress="return isFloat(event)"  value="' + msg[i].sgst_per + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;display:none;"></input></td>';
                    results += '<td ><span id="spn_cgst">' + msg[i].cgst_per + '</span><input id="txt_cgst" readonly class="cgst"  name="price" onkeypress="return isFloat(event)"  value="' + msg[i].cgst_per + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;display:none;"></input></td>';
                    results += '<td ><span id="spn_igst">' + msg[i].igst_per + '</span><input id="txt_igst" readonly class="igst"  name="price" onkeypress="return isFloat(event)"  value="' + msg[i].igst_per + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;display:none;"></input></td>';
                    results += '<td ><span id="spn_tot_amt" class="tot_amt"></span></td>';//<label id="lbl_tot_amt" class="tot_amt"></label>
                    results += '</tr>';
                    k++;
                }
                results += '</table></div>';
                $("#div_SectionData").html(results);
                calTotal_gst();
            }
        }

        var price = 0, qty = 0, tax = 0, total_amount = 0;
        function calTotal() {
            $('#tabledetails_sub> tbody > tr').each(function () {
                var total = 0, total_amt = 0, tax_amt = 0;
                price = $(this).find('.price').val(),
                qty = $(this).find('.qty').val(),
                total = (parseFloat(price) * parseFloat(qty));
                tax = parseFloat($(this).find('.tax').val());
                tax_amt = (total * tax) / 100 || 0;
                total_amt = total + tax_amt;
                $(this).find('.tot_amt').text(total_amt.toFixed(2));
            });

            clstotalval();
        }

        function clstotalval() {
            var grandtotal = 0; var totalpfamount = 0; total_amount = 0;
            $('.tot_amt').each(function (i, obj) {
                var totamt = $(this).html();

                if (totamt == "" || totamt == "0") {
                }
                else {
                    total_amount += parseFloat(totamt);
                }
            });

            var grandtotal = parseFloat(total_amount);

            document.getElementById('spn_total_amount').innerHTML = grandtotal.toFixed(2);
        }

        function calTotal_gst() {
            $('#tabledetails_sub_gst> tbody > tr').each(function () {
                var total = 0, total_amt = 0, tax_amt = 0;
                price = $(this).find('.price').val(),
                qty = $(this).find('.qty').val(),
                total = (parseFloat(price) * parseFloat(qty));
                tax = parseFloat($(this).find('.tax').val());
                tax_amt = (total * tax) / 100 || 0;
                total_amt = total + tax_amt;
                $(this).find('.tot_amt').text(total_amt.toFixed(2));
            });
            clstotalval_gst();
        }

        function clstotalval_gst() {
            var grandtotal = 0; var totalpfamount = 0; total_amount = 0;
            $('.tot_amt').each(function (i, obj) {
                var totamt = $(this).html();

                if (totamt == "" || totamt == "0") {
                }
                else {
                    total_amount += parseFloat(totamt);
                }
            });

            var grandtotal = parseFloat(total_amount);

            document.getElementById('spn_total_amount').innerHTML = grandtotal.toFixed(2);
        }

        function CloseClick() {
            forclearall();
            $('#inward_fill_form').css('display', 'none');
            $('#div_stocktransfer').css('display', 'block');
        }

        function save_approve_Stock_Tranfer_Inward() {
            var inward_date = document.getElementById('txt_inward_date').value;
            if (inward_date == "")
            {
                alert("Please Enter Inward Date");
                return false;
            }
            var invoice_no = document.getElementById('txt_invoice_no').value;
            if (invoice_no == "") {
                alert("Please Enter Invoice No");
                return false;
            }
            var invoice_date = document.getElementById('txt_invoice_date').value;
            if (invoice_date == "") {
                alert("Please Enter Invoice Date");
                return false;
            }
            var vehicleno = document.getElementById('txt_vehicle_no').value;
            if (vehicleno == "") {
                alert("Please Enter Vehicle No");
                return false;
            }
            var remarks = document.getElementById('txt_remarks').value;
            var sno = document.getElementById('lbl_sno').value;
            var transport_name = document.getElementById('txt_transport_name').value;
            if (transport_name == "") {
                alert("Please Enter Transport Name");
                return false;
            }
            var modeofinward = document.getElementById('slct_mdeofinwrd').value;
            if (modeofinward == "") {
                alert("Please Select Mode of Inward");
                return false;
            }
            var totalamount = document.getElementById('spn_total_amount').innerHTML;

            var inv_or_bt_date = document.getElementById('txt_inv_or_bt_date').value;
            var todaydate = inv_or_bt_date.split('-');
            var date = "2017-07-01".split('-');

            var firstDate = new Date();
            firstDate.setFullYear(todaydate[0], (todaydate[1] - 1), todaydate[2]);
            var secondDate = new Date();
            secondDate.setFullYear(date[0], (date[1] - 1), date[2]);

            var fillitems = [];
            if (firstDate < secondDate) {
                $('#tabledetails_sub> tbody > tr').each(function () {
                    var productname = $(this).find('#spn_productid').text();
                    var PerUnitRs = $(this).find('#spn_price').text()
                    var Quantity = $(this).find('#spn_quantity').text();
                    var tax = $(this).find('#spn_taxvalue').text();
                    var tot_amt = $(this).find('#spn_tot_amt').text();
                    if (productname == "" || productname == "0") {
                    }
                    else {
                        fillitems.push({ 'hdnproductsno': productname, 'PerUnitRs': PerUnitRs, 'quantity': Quantity, 'dis': "", 'disamt': "", 'taxtype': "", 'sgst_per': "", 'cgst_per': "", 'igst_per': "", 'tax': tax, 'ed': "", 'edtax': "", 'totalcost': tot_amt });
                        
                    }
                });
            }
            else {
                $('#tabledetails_sub_gst> tbody > tr').each(function () {
                    var productname = $(this).find('#spn_productid').text();
                    var PerUnitRs = $(this).find('#spn_price').text()
                    var Quantity = $(this).find('#spn_quantity').text();
                    var sgst = $(this).find('#spn_sgst').text();
                    var cgst = $(this).find('#spn_cgst').text();
                    var igst = $(this).find('#spn_igst').text();
                    var tot_amt = $(this).find('#spn_tot_amt').text();
                    if (productname == "" || productname == "0") {
                    }
                    else {
                        fillitems.push({ 'hdnproductsno': productname, 'PerUnitRs': PerUnitRs, 'quantity': Quantity, 'dis': "", 'disamt': "", 'taxtype': "", 'tax': "0", 'ed': "", 'edtax': "", 'sgst_per': sgst, 'cgst_per': cgst, 'igst_per': igst, 'totalcost': tot_amt });
                        
                    }
                });
            }
            if (fillitems.length == 0) {
                alert("Please Select Products");
                return false;
            }
            var btnval = document.getElementById('btn_RaisePO').innerHTML;
            var Data = { 'op': 'save_edit_Inward', 'inwarddate': inward_date, 'inwardamount': totalamount, 'transport': "", 'invoiceno': invoice_no, 'invoicedate': invoice_date, 'dcno': "", 'lrno': "", 'podate': "", 'remarks': remarks, 'stocksno': sno, 'pono': "", 'securityno': "", 'transportname': transport_name, 'vehicleno': vehicleno, 'hiddensupplyid': "1401", 'modeofinward': modeofinward, 'btnval': btnval, 'freigtamt': "", 'pfid': "", 'paymenttype': "", 'rev_chrg': "N", 'fillitems': fillitems };//, 'indentno': indentno
            var s = function (msg) {
                if (msg) {
                    if (msg == "You Dont Have Permission This Date") {
                        alert(msg);
                        return false;
                    }
                    else {
                        alert(msg);
                        forclearall();
                        get_approve_Stock_Tranfer_Inward_click();
                        $('#inward_fill_form').css('display', 'none');
                        $('#div_stocktransfer').css('display', 'block');
                    }
                }
            }
            var e = function (x, h, e) {
            };
            CallHandlerUsingJson(Data, s, e);
        }

        function forclearall() {
            document.getElementById('txt_inward_date').value = "";
            document.getElementById('txt_invoice_no').value = "";
            document.getElementById('txt_invoice_date').value = "";
            document.getElementById('txt_vehicle_no').value = "";
            document.getElementById('txt_remarks').value = "";
            document.getElementById('txt_inv_or_bt_date').value = "";
            document.getElementById('lbl_sno').value = "";
            document.getElementById('txt_transport_name').value = "";
            document.getElementById('slct_mdeofinwrd').selectedIndex = 0;
            document.getElementById('spn_total_amount').innerHTML = "";
            
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
            $('#txt_inward_date').val(yyyy + '-' + mm + '-' + dd);

            var msg = [];
            var results = '<div  style="overflow:initial;"><table id="tabledetails_sub" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr><th scope="col" style="text-align:center;">Sno</th><th scope="col" style="text-align:center;">Product Name</th><th scope="col" style="text-align:center;">Quantity</th><th scope="col" style="text-align:center;">Price</th><th scope="col" style="text-align:center;">Tax</th></tr></thead></tbody>';
            var k = 1;
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td scope="row" style="text-align:center;">' + k + '</td>';
                results += '<td  style="display:none;"><span id="spn_productid">' + msg[i].productid + '</span></td>';
                results += '<td ><span id="spn_productname">' + msg[i].productname + '</span></td>';
                results += '<td data-title="From"><span id="spn_quantity">' + msg[i].quantity + '</span><input id="txt_quantity" readonly class="qty"  name="quantity" onkeypress="return isFloat(event)"  value="' + msg[i].quantity + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;display:none;"></input></td>';
                results += '<td ><span id="spn_price">' + msg[i].price + '</span><input id="txt_price" readonly class="price"  name="price" onkeypress="return isFloat(event)"  value="' + msg[i].price + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;display:none;"></input></td>';
                results += '<td ><span id="spn_taxvalue">' + msg[i].taxvalue + '</span><input id="txt_tax" readonly class="tax"  name="tax" onkeypress="return isFloat(event)"  value="' + msg[i].taxvalue + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;display:none;"></input></td>';
                results += '<td ><span id="spn_tot_amt" class="tot_amt"></span></td>';//<label id="lbl_tot_amt" class="tot_amt"></label>
                results += '</tr>';
                k++
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Stock Transfer Inward Approval<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operations</a></li>
            <li><a href="#">Stock Transfer Inward Approval</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Stock Transfer Inward Approval Details
                </h3>
            </div>
            <div class="box-body">
                <div id="inward_fill_form" style="display:none">
                    <div>
                        <table align="center">
                    <tr>
                            <td><label>Inward Date</label></td>
                            <td style="height: 40px;">
                                <input id="txt_inward_date" type="text" readonly class="form-control" name="inward_date" />
                            </td>
                            <td style="width:5px"></td>
                            <td><label>From Branch</label></td>
                            <td style="height: 40px;">
                                <input id="txt_frombranch" type="text" readonly class="form-control" name="from_branch" />
                                <input id="txt_frombranch_id" type="text" style="display:none" class="form-control" name="from_branch_id" />
                            </td>
                        </tr>
                        <tr>
                            <td><label>Invoice No</label><span style="color: red;">*</span></td>
                            <td style="height: 40px;">
                                <input id="txt_invoice_no" type="text" placeholder="Enter Invoice Number" class="form-control" name="invoice_no" />
                            </td>
                            <td style="width:5px"></td>
                            <td><label>Invoice Date</label><span style="color: red;">*</span></td>
                            <td style="height: 40px;">
                                <input id="txt_invoice_date" type="date" class="form-control" name="invoice_date" />
                            </td>
                        </tr>
                        <tr>
                            <td><label>Vehicle No</label></td>
                            <td style="height: 40px;">
                                <input id="txt_vehicle_no" type="text"  class="form-control" name="vehicle_no" />
                            </td>
                            <td style="width:5px"></td>
                            <td><label>Transport Name</label></td>
                            <td style="height: 40px;">
                                <input id="txt_transport_name" type="text" readonly class="form-control" name="transport_name" />
                            </td>
                        </tr>
                        <tr>
                            <td><label>Mode of Inward</label><span style="color: red;">*</span></td>
                            <td style="height: 40px;">
                                <select id="slct_mdeofinwrd" class="form-control">
                                    <option value="" disabled selected>Select Mode of Inward</option>
                                    <option value="Cash Purchase">CashPurchase</option>
                                    <option value="Credit Purchase">CreditPurchase</option>
                                    <option value="CheckPaid">CheckPaid</option>
                                    <option value="FOC">FOC</option>
                                    <option value="Refurbished">Refurbished</option>
                                    <option value="Warranty">Warranty</option>
                                    <option value="Transported">Transported</option>
                                    <option value="Returnble">Returnble</option>
                                    <option value="AgainstLoan">AgainstLoan</option>
                                    <option value="Repair">Repair</option>
                                    <option value="AuditCorrrection">AuditCorrrection</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td><label>Remarks</label></td>
                            <td colspan="3">
                                <textarea rows="4" cols="30" id="txt_remarks" placeholder="Enter Remarks" class="form-control" name="remarks"></textarea>
                                <input id="txt_inv_or_bt_date" type="date" style="display:none" />
                            </td>
                        </tr>
                        <tr></tr>
                        <tr></tr>
                        <tr></tr>
                        <tr></tr>
                        
                </table>
                    </div>
                    <br />
                    <br />
                    <div id="div_SectionData">
                                </div>
                    <br />
                    <br />
                    <div>
                        <table align="center">
                            <tr>
                                <td><label>Total Amount</label></td>
                                <td><span style="color:red" id="spn_total_amount"></span></td>
                            </tr>
                            <tr></tr>
                            <tr></tr>
                            <tr>
                                <td></td>
                                <td>
                                    <table>
                                       <tr>
                                        <td>
                                        <div class="input-group">
                                            <div class="input-group-addon">
                                            <span class="glyphicon glyphicon-ok" id="btn_RaisePO1" onclick="save_approve_Stock_Tranfer_Inward()"></span> <span id="btn_RaisePO" onclick="save_approve_Stock_Tranfer_Inward()">Save</span>
                                      </div>
                                      </div>
                                        </td>
                                        <td style="width:10px;"></td>
                                        <td>
                                         <div class="input-group">
                                            <div class="input-group-close">
                                            <span class="glyphicon glyphicon-remove" id='close_vehmaster1' onclick="CloseClick();"></span> <span id='close_vehmaster' onclick="CloseClick();">Close</span>
                                      </div>
                                      </div>
                                        </td>
                                        </tr>
                                   </table>
                                </td>
                                
                            </tr>
                            <tr style="display: none;">
                                <td>
                                    <label id="lbl_sno">
                                    </label>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                
                <div id="div_stocktransfer">
                </div>
            </div>
            
        </div>
    </section>
</asp:Content>

