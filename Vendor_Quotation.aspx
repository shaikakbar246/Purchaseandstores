<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true"
    CodeFile="Vendor_Quotation.aspx.cs" Inherits="Vendor_Quotation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            $('#div_save_display').css('display', 'none');
            get_supplier();
            get_TAX();
            get_PandF();
            get_PaymentDetails();
            get_Address();
            get_DelivaryTerms();
            //get_supplier1();
            //GetFixedrows();
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

        var supperdetails = [];
        function get_supplier() {
            var data = { 'op': 'get_supplier' };
            var s = function (msg) {
                if (msg) {
                    supperdetails = msg;
                    var availableTags = [];
                    for (var i = 0; i < msg.length; i++) {
                        var name = msg[i].name;
                        availableTags.push(name);
                    }
                    $('#txt_sup').autocomplete({
                        source: availableTags,
                        change: supplierchange,
                        autoFocus: true
                    });
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        function supplierchange() {
            var name = document.getElementById('txt_sup').value;
            for (var i = 0; i < supperdetails.length; i++) {
                if (name == supperdetails[i].name) {
                    document.getElementById('txt_sup_id').value = supperdetails[i].supplierid;
                    //document.getElementById('txt_gl_sno').value = supperdetails[i].sno;
                }
            }
        }

        function get_PandF() {
            var data = { 'op': 'get_PandF' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillpf(msg);
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
        function fillpf(msg) {
            var data = document.getElementById('slct_pandf');
            var length = data.options.length;
            document.getElementById('slct_pandf').options.length = null;
            var opt = document.createElement('option');
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].pandf != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].pandf;
                    option.value = msg[i].sno;
                    data.appendChild(option);
                }
            }
        }

        function get_Address() {
            var data = { 'op': 'get_Address_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillDelivaryAddress(msg);
                        fillBillingAddress(msg);
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

        function fillDelivaryAddress(msg) {
            var data = document.getElementById('slct_delivery_addr');
            var length = data.options.length;
            document.getElementById('slct_delivery_addr').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "select Delivery Address";
            opt.value = "";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].Address != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].Address;
                    option.value = msg[i].sno;
                    data.appendChild(option);
                }
            }
        }

        function fillBillingAddress(msg) {
            var data = document.getElementById('slct_billing_addr');
            var length = data.options.length;
            document.getElementById('slct_billing_addr').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "select Billing Address";
            opt.value = "";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].Address != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].Address;
                    option.value = msg[i].sno;
                    data.appendChild(option);
                }
            }
        }

        function get_DelivaryTerms() {
            var data = { 'op': 'get_DelivaryTerms' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillterms(msg);
                    }
                    else {
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

        function fillterms(msg) {
            var data = document.getElementById('slct_deliveryterms');
            var length = data.options.length;
            document.getElementById('slct_deliveryterms').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "select Delivery Terms";
            opt.value = "";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].terms != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].terms;
                    option.value = msg[i].sno;
                    data.appendChild(option);
                }
            }
        }

        function get_PaymentDetails() {
            var data = { 'op': 'get_PaymentDetails' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillpayment(msg);
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

        function fillpayment(msg) {
            var data = document.getElementById('slct_payment_type');
            var length = data.options.length;
            document.getElementById('slct_payment_type').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "select payment";
            opt.value = "";
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].paymenttype != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].paymenttype;
                    option.value = msg[i].sno;
                    data.appendChild(option);
                }
            }
        }

        var TAX_Types = [];
        function get_TAX() {
            var data = { 'op': 'get_TAX' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillTax(msg);
                        fillED(msg);
                        TAX_Types = msg;
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
        function fillTax(msg) {
            $('.Taxtypecls').each(function () {
                var taxtype = $(this);
                taxtype[0].options.length = null;
                var opt = document.createElement('option');
                opt.innerHTML = "SELECT";
                opt.value = "";
                opt.setAttribute("selected", "selected");
                opt.setAttribute("disabled", "disabled");
                opt.setAttribute("class", "dispalynone");
                taxtype[0].appendChild(opt);
                for (var i = 0; i < msg.length; i++) {
                    if (msg[i].type != null) {
                        if (msg[i].taxtype == "Tax") {
                            var option = document.createElement('option');
                            option.innerHTML = msg[i].type;
                            option.value = msg[i].sno;
                            taxtype[0].appendChild(option);
                        }
                    }
                }
            });
        }

        function fillED(msg) {
            $('.edcls').each(function () {
                var ed = $(this);
                ed[0].options.length = null;
                for (var i = 0; i < msg.length; i++) {
                    if (msg[i].type != null) {
                        if (msg[i].taxtype == "ExchangeDuty") {
                            var option = document.createElement('option');
                            option.innerHTML = msg[i].type;
                            option.value = msg[i].sno;
                            ed[0].appendChild(option);
                        }
                    }
                }
            });
        }
        $(document).click(function () {
            $('#tabledetails').on('change', '.cls_qty', calTotal)
            $('#tabledetails').on('change', '.cls_rate', calTotal)
            $('#tabledetails').on('change', '.cls_dis_per', calTotal)
        });
        var totalpoval = 0;
        function clstotalval(totalpoval) {
            var totaamount = 0; var totalpfamount = 0;
            var totlclass = totalpoval; //$(this).html();
            if (totlclass == "" || totlclass == "0") {
            }
            else {
                totaamount += parseFloat(totlclass);
            }
            var totalamount1 = parseFloat(totaamount) + parseFloat(fright) + parseFloat(transport_chrgs) + parseFloat(insurance_chrgs) + parseFloat(other_chrgs);
            var grandtotal = parseFloat(totalamount1);
            document.getElementById('txt_total_amount').value = grandtotal.toFixed(2);
        }
        var total;
        var totaldis;
        var edval;
        var totalpoamount;
        var sum;
        var discount;
        var disper;
        var totalval;
        var totaldisamount;
        var tax = "";
        var totaltax = "";
        var edper = "";
        var edtotalval = "";
        var totalpoval = "";
        var totalclsval;
        var Discount = 0;
        var fright = 0;
        var transport_chrgs = 0;
        var insurance_chrgs = 0;
        var other_chrgs = 0;
        var pf = 0;
        var pfamt = 0;
        var discount1 = 0;
        var Discountedpf = 0;
        var pf1 = 0;
        var price = 0;
        var quantity = 0;
        var tpfamt = 0;
        var free = 0;
        var tpfamt1 = 0;
        function calTotal() {
            var $row = $(this).closest('tr'),
            price = $row.find('.cls_rate').val(),
            quantity = $row.find('.cls_qty').val(),
            sum = quantity;
            discount1 = sum * price || 0;
            disper = $row.find('.cls_dis_per').val(),
            totalval = parseFloat(discount1) * (disper) / 100 || 0;;
            discount = discount1 - totalval;
            $row.find('.cls_disamt').val(totalval);
            $row.find('#spn_dis_amt').text(totalval);
            pf = document.getElementById("slct_pandf");
            pf1 = pf.options[pf.selectedIndex].text;
            tpfamt = parseFloat(pf1) / 100;
            tpfamt1 = parseFloat(discount) * (tpfamt) || 0;
            sgstper = $row.find('#spn_sgst').text();
            sgstamt = ((discount + tpfamt1) * parseFloat(sgstper)) / 100;
            cgstper = $row.find('#spn_cgst').text();
            cgstamt = ((discount + tpfamt1) * parseFloat(cgstper)) / 100;
            igstper = $row.find('#spn_igst').text();
            igstamt = ((discount + tpfamt1) * parseFloat(igstper)) / 100;
            fright = document.getElementById('txt_freight').value || 0;
            transport_chrgs = document.getElementById('txt_transport_chrgs').value || 0;
            insurance_chrgs = document.getElementById('txt_insurance_chrgs').value || 0;
            other_chrgs = document.getElementById('txt_other_chrgs').value || 0;
            totalpoval = parseFloat(igstamt) + parseFloat(sgstamt) + parseFloat(cgstamt) + parseFloat(tpfamt1) + parseFloat(discount);
            clstotalval(totalpoval);
        }
        var vendor_prod_det = [];
        function btn_schedule_Details_click() {
            var rfq_no = document.getElementById('txt_rfq_no').value;
            if (rfq_no == "") {
                alert("Enter Quotation No");
                return false;
            }
            var data = { 'op': 'get_quote_prod_Details', 'rfq_no': rfq_no }; //, 'sup_name': sup_name
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        clear_vendor_quo();
                        document.getElementById('txt_rfq_no').value = rfq_no;
                        var vendor_quo_det = msg[0].DataTable;
                        vendor_prod_det = msg[0].DataTable1;
                        scrollTo(0, 0);
                        if (vendor_quo_det.length != 0 && vendor_prod_det.length != 0) {
                            if (vendor_quo_det[0].price_basis != null) {// || vendor_prod_det != ""
                                filldetails2(vendor_quo_det);
                                filldetails(vendor_prod_det);
                            }
                            else {
                                filldetails3(vendor_quo_det);
                                filldetails(vendor_prod_det);
                            }
                        }
                        else {
                            alert("No Data Found");
                            document.getElementById('txt_rfq_no').value = "";
                            return false;
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
            clearDet();
            //get_TAX();
        }

        function filldetails2(msg) {
            var price_basis = msg[0].price_basis;
            var sno = msg[0].sno;
            document.getElementById('txt_ven_quo_no').value = msg[0].vendor_quo_no;
            document.getElementById('txt_sup').value = msg[0].sup_name;
            document.getElementById('txt_sup_id').value = msg[0].sup_id;
            document.getElementById('txt_quo_dt').value = msg[0].quo_dt;
            document.getElementById('slct_pandf').value = msg[0].pandf;
            document.getElementById('txt_freight').value = msg[0].freight_amt;
            document.getElementById('txt_transport_chrgs').value = msg[0].transport_chrgs;
            document.getElementById('slct_deliveryterms').value = msg[0].delivery_terms;
            document.getElementById('slct_payment_type').value = msg[0].payment_type;
            document.getElementById('slct_delivery_addr').value = msg[0].delivery_addr;
            document.getElementById('slct_billing_addr').value = msg[0].billing_addr;
            document.getElementById('slct_dispatchmode').value = msg[0].dispatch_mode;
            document.getElementById('txt_insurance_chrgs').value = msg[0].insurance_chrgs;
            document.getElementById('txt_other_chrgs').value = msg[0].other_chrgs;
            document.getElementById('slct_price_basis').value = price_basis;
            document.getElementById('lbl_sno').value = sno;
        }

        function filldetails3(msg) {
            var quo_dt = msg[0].quo_dt;
            var sup_name = msg[0].sup_name;
            var sup_id = msg[0].sup_id;
            var sno = msg[0].sno;
            document.getElementById('txt_sup').value = sup_name;
            document.getElementById('txt_sup_id').value = sup_id;
            document.getElementById('txt_quo_dt').value = quo_dt;
            document.getElementById('lbl_sno').value = sno;
        }
        var sno_list = [];
        var sub_sno = "";
        function filldetails(msg) {
            $('#totalamount').css('display', 'block');
            $('#div_save_display').css('display', 'block');
            pf = document.getElementById("slct_pandf");
            pf1 = pf.options[pf.selectedIndex].text;
            var total_amount = 0;
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Code</th><th scope="col">Description</th><th scope="col">UOM</th><th scope="col">Quantity</th><th scope="col">Rate</th><th scope="col">Dis%</th><th scope="col">Dis Amt</th><th scope="col">SGST %</th><th scope="col">CGST %</th><th scope="col">IGST %</th></tr></thead></tbody>';
            if (msg[0].dis_per != null) {
                sno_list = [];
                var j = 1;
                for (var i = 0; i < msg.length; i++) {
                    sub_sno = msg[i].sno;
                    results += '<tr><td scope="row" class="1"  style="text-align:center;">' + (i + 1) + '</td>'; //onchange="cal_total(this);"
                    results += '<td data-title="" class="2"><span id="spn_prod_code">' + msg[i].sku + '</span></td>';
                    results += '<td style="display:none;"><input type="text" id="txt_pid_sno" value="' + msg[i].prod_id + '"></input></td>';
                    results += '<td data-title="" class="3"><span id="spn_desc">' + msg[i].prod_name + '</span></td>';
                    results += '<td data-title="" class="4"><span id="spn_uom">' + msg[i].uim + '</span></td>';
                    results += '<td style="display:none;" data-title="" class="4"><input type="text" id="txt_uom_sno" readonly="readonly" class="cls_uom" value="' + msg[i].uom + '"></input></td>';
                    results += '<td data-title="" class="5"><input type="text" id="txt_qty" onkeypress="return isFloat(event)" class="cls_qty" style="width:100%" value="' + msg[i].qty + '"></input></td>';
                    results += '<td data-title="" class="6"><input type="text" id="txt_rate" onkeypress="return isFloat(event)" class="cls_rate" style="width:80px" value="' + parseFloat(msg[i].price).toFixed(2) + '"></input></td>';
                    var prod_qty = parseFloat(msg[i].qty);
                    var price = parseFloat(msg[i].price);
                    var prod_cost = (prod_qty * price);
                    results += '<td data-title="" class="7"><input type="text" id="txt_dis_per" onkeypress="return isFloat(event)" class="cls_dis_per" style="width:60px" value="' + msg[i].dis_per + '" placeholder="Discount %" ></input></td>';
                    results += '<td data-title="" class="8"><span id="spn_dis_amt">' + parseFloat(msg[i].dis_amt).toFixed(2) + '</span><input type="text" id="txt_dis_amt" onkeypress="return isFloat(event)" class="cls_disamt" value="' + parseFloat(msg[i].dis_amt).toFixed(2) + '" placeholder="Discount Amount" style="display:none" ></input></td>';
                    var taxable1 = prod_cost - parseFloat(msg[i].dis_amt) || 0;
                    var pfamount = (taxable1 * parseFloat(pf1)) / 100;
                    var taxable = taxable1 + pfamount;
                    results += '<td><span id="spn_sgst">' + msg[i].sgst + '</span></td>';
                    results += '<td><span id="spn_cgst">' + msg[i].cgst + '</span></td>';
                    results += '<td><span id="spn_igst">' + msg[i].igst + '</span></td>';
                    var sgstamt = (taxable * parseFloat(msg[i].sgst)) / 100;
                    var cgstamt = (taxable * parseFloat(msg[i].cgst)) / 100;
                    var igstamt = (taxable * parseFloat(msg[i].igst)) / 100;
                    var prod_amt = taxable + sgstamt + cgstamt + igstamt;
                    results += '<td style="display:none;"><input id="txt_sno" value="' + msg[i].sno + '" type="text" class="form-control"></input></td>';
                    results += '</tr>';
                    var fright = 0, transport_chrgs = 0, insurance_chrgs = 0, other_chrgs = 0;
                    if (j == 1) {
                        fright = parseFloat(document.getElementById('txt_freight').value) || 0;
                        transport_chrgs = parseFloat(document.getElementById('txt_transport_chrgs').value) || 0;
                        insurance_chrgs = parseFloat(document.getElementById('txt_insurance_chrgs').value) || 0;
                        other_chrgs = parseFloat(document.getElementById('txt_other_chrgs').value) || 0;
                        total_amount += prod_amt + fright + transport_chrgs + insurance_chrgs + other_chrgs;
                    }
                    else {
                        //fright = 0, transport_chrgs = 0, insurance_chrgs = 0, other_chrgs = 0;
                        total_amount += prod_amt;
                    }
                    j++;
                }
                document.getElementById('txt_total_amount').value = total_amount;
                document.getElementById('btn_save').innerHTML = "Modify";
                results += '</table></div>';
                $("#div_ven_quo").html(results);
            }
            else {
                for (var i = 0; i < msg.length; i++) {
                    results += '<tr><td scope="row" class="1"  style="text-align:center;">' + (i + 1) + '</td>';
                    results += '<td data-title="" class="2"><span id="spn_prod_code">' + msg[i].sku + '</span></td>';
                    results += '<td style="display:none;"><input type="text" id="txt_pid_sno" value="' + msg[i].prod_id + '"></input></td>';
                    results += '<td data-title="" class="3"><span id="spn_desc">' + msg[i].prod_name + '</span></td>';
                    results += '<td data-title="" class="4"><span id="spn_uom">' + msg[i].uim + '</span></td>';
                    results += '<td style="display:none;" data-title="" class="4"><input type="text" id="txt_uom_sno" readonly="readonly" class="cls_uom" value="' + msg[i].uom + '"></input></td>';
                    results += '<td data-title="" class="5"><input type="text" id="txt_qty" onkeypress="return isFloat(event)" class="cls_qty" style="width:100%" value="' + msg[i].qty + '"></input></td>';
                    results += '<td data-title="" class="6"><input type="text" id="txt_rate" onkeypress="return isFloat(event)" class="cls_rate" style="width:80px" value="' + parseFloat(msg[i].price).toFixed(2) + '"></input></td>';
                    results += '<td data-title="" class="7"><input type="text" id="txt_dis_per" onkeypress="return isFloat(event)" class="cls_dis_per" style="width:60px" placeholder="Discount %" ></input></td>';
                    results += '<td data-title="" class="8"><span id="spn_dis_amt"></span><input type="text" id="txt_dis_amt" onkeypress="return isFloat(event)" class="cls_disamt" placeholder="Discount Amount" style="display:none" ></input></td>';
                    results += '<td><span id="spn_sgst">' + msg[i].sgst + '</span></td>';
                    results += '<td><span id="spn_cgst">' + msg[i].cgst + '</span></td>';
                    results += '<td><span id="spn_igst">' + msg[i].igst + '</span></td>';
                    results += '<td style="display:none;"><input id="txt_sno" type="text" class="form-control"></input></td>';
                    results += '</tr>';
                }
                document.getElementById('btn_save').innerHTML = "Save";
                results += '</table></div>';
                $("#div_ven_quo").html(results);
            }
        }

        function gettaxtypevalues(sno, vendor_prod_det) {
            $('.Taxtypecls').each(function () {
                var taxtype = $(this);
                taxtype[0].options.length = null;
                for (var i = 0; i < TAX_Types.length; i++) {
                    if (TAX_Types[i].type != null) {
                        if (TAX_Types[i].taxtype == "Tax") {
                            var option = document.createElement('option');
                            option.innerHTML = TAX_Types[i].type;
                            option.value = TAX_Types[i].sno;
                            taxtype[0].appendChild(option);
                        }
                    }
                }
            });
            var i = 0;
            $('.Taxtypecls').each(function () {
                var ddltax_type = $(this);
                //for (var i = 0; i < vendor_prod_det.length; i++) {
                $(this).val(vendor_prod_det[i].tax_type);
                i++;
                //}
            });
        }

        function getedtypevalues(sno, vendor_prod_det) {
            $('.edcls').each(function () {
                var taxtype = $(this);
                taxtype[0].options.length = null;
                for (var i = 0; i < TAX_Types.length; i++) {
                    if (TAX_Types[i].type != null) {
                        if (TAX_Types[i].taxtype == "ExchangeDuty") {
                            var option = document.createElement('option');
                            option.innerHTML = TAX_Types[i].type;
                            option.value = TAX_Types[i].sno;
                            taxtype[0].appendChild(option);
                        }
                    }
                }
            });

            var i = 0;
            $('.edcls').each(function () {
                var ddltax_type = $(this);
                $(this).val(vendor_prod_det[i].ed);
                i++;
            });
        }

        var DataTable;
        function removerow(thisid) {
            $(thisid).parents('tr').remove();
        }
        var replaceHtmlEntites = (function () {
            return function (s) {
                return (s.replace(translate_re, function (match, entity) {
                    return translate[entity];
                }));
            }
        })();

        function save_vendor_quo() {
            var DataTable = [];
            var count = 0;
            var rows = $("#tabledetails tr:gt(0)");
            var rowsno = 1;

            $(rows).each(function (i, obj) {
                sno = $(this).find('#txt_sno').val();
                prod_id = $(this).find('#txt_pid_sno').val();
                desc = $(this).find('#span_desc').text();
                uom = $(this).find('#txt_uom_sno').val();
                qty = $(this).find('#txt_qty').val();
                price = $(this).find('#txt_rate').val();
                dis_per = $(this).find('#txt_dis_per').val();
                dis_amt = $(this).find('#txt_dis_amt').val();
                sgst = $(this).find('#spn_sgst').text();
                cgst = $(this).find('#spn_cgst').text();
                igst = $(this).find('#spn_igst').text();
                var abc = [];
                //var abc = { sno: sno, prod_id: prod_id, desc: desc, uom: uom, qty: qty, price: price, dis_per: dis_per, dis_amt: dis_amt, tax_type: tax_type, tax_per: tax_per, ed: ed, ed_tax_per: ed_tax_per }; //, freight: freight
                if (prod_id == "" || prod_id == "0" || prod_id == "undefined" || prod_id == 0 || prod_id == null) {
                }
                else {
                    abc = { sno: sno, prod_id: prod_id, desc: desc, uom: uom, qty: qty, price: price, dis_per: dis_per, dis_amt: dis_amt, sgst: sgst, cgst: cgst, igst: igst, tax_type: "", tax_per: "0", ed: "", ed_tax_per: "0" }; //, freight: freight
                    DataTable.push(abc);
                }
            });
            var sup_name = document.getElementById('txt_sup').value;
            var sup_id = document.getElementById('txt_sup_id').value;
            if (sup_name == "" || sup_id == "") {
                alert("Enter Supplier Name");
                return false;
            }
            var rfq_no = document.getElementById('txt_rfq_no').value;
            if (rfq_no == "") {
                alert("Enter Quotation No");
                return false;
            }
            var quo_dt = document.getElementById('txt_quo_dt').value;
            if (quo_dt == "") {
                alert("Enter Quotation Date");
                return false;
            }
            var ven_quo_no = document.getElementById('txt_ven_quo_no').value;
            if (ven_quo_no == "") {
                alert("Enter Vendor Quotation No");
                return false;
            }
            var pandf = document.getElementById('slct_pandf').value;
            var freight_amt = document.getElementById('txt_freight').value;
            var transport_chrgs = document.getElementById('txt_transport_chrgs').value;
            var price_basis = document.getElementById('slct_price_basis').value;
            if (price_basis == "") {
                alert("select Price Basis");
                return false;
            }
            var delivery_terms = document.getElementById('slct_deliveryterms').value;
            if (delivery_terms == "") {
                alert("select delivery terms");
                return false;
            }
            var payment_type = document.getElementById('slct_payment_type').value;
            if (payment_type == "") {
                alert("select payment type");
                return false;
            }
            var delivery_addr = document.getElementById('slct_delivery_addr').value;
            if (delivery_addr == "") {
                alert("select delivery address");
                return false;
            }
            var billing_addr = document.getElementById('slct_billing_addr').value;
            if (billing_addr == "") {
                alert("select billing address");
                return false;
            }
            var dispatch_mode = document.getElementById('slct_dispatchmode').value;
            if (dispatch_mode == "") {
                alert("select Dispatch Mode");
                return false;
            }
            var insurance_chrgs = document.getElementById('txt_insurance_chrgs').value;
            var other_chrgs = document.getElementById('txt_other_chrgs').value;
            //var vendor_date = document.getElementById('txt_date').value;
            var btn_save = document.getElementById('btn_save').innerHTML;
            var sno = document.getElementById('lbl_sno').value;

            var data = { 'op': 'save_vendor_quote', 'sno': sno, 'sup_name': sup_id, 'ven_quo_no': ven_quo_no, 'rfq_no': rfq_no, 'quo_dt': quo_dt, 'pandf': pandf, 'freight_amt': freight_amt, 'transport_chrgs': transport_chrgs, 'delivery_terms': delivery_terms, 'payment_type': payment_type, 'delivery_addr': delivery_addr, 'billing_addr': billing_addr, 'insurance_chrgs': insurance_chrgs, 'other_chrgs': other_chrgs, 'price_basis': price_basis, 'dispatch_mode': dispatch_mode, 'DataTable': DataTable, 'btn_save': btn_save };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        clear_vendor_quo();
                        //get_TAX();
                        $("#tabledetails").css("display", "none");
                        $('#totalamount').css('display', 'none');
                        $('#div_save_display').css('display', 'none');
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

        function clear_vendor_quo() {
            //document.getElementById('txt_comp').value = "";
            document.getElementById('txt_sup').value = "";
            document.getElementById('txt_rfq_no').value = "";
            document.getElementById('txt_quo_dt').value = "";
            document.getElementById('txt_total_amount').value = "";
            document.getElementById('slct_pandf').selectedIndex = 0;
            document.getElementById('txt_freight').value = "";
            document.getElementById('slct_dispatchmode').selectedIndex = 0;
            document.getElementById('txt_transport_chrgs').value = "";
            document.getElementById('slct_deliveryterms').selectedIndex = 0;
            document.getElementById('slct_payment_type').selectedIndex = 0;
            document.getElementById('slct_delivery_addr').selectedIndex = 0;
            document.getElementById('slct_billing_addr').selectedIndex = 0;
            document.getElementById('txt_insurance_chrgs').value = "";
            document.getElementById('txt_other_chrgs').value = "";
            document.getElementById('txt_ven_quo_no').value = "";
            document.getElementById('slct_price_basis').selectedIndex = 0;
            clearDet();
            $("#tabledetails").css("display", "none");
            $('#totalamount').css('display', 'none');
            $('#div_save_display').css('display', 'none');
            scrollTo(0, 0);
            //clearDet();
        }

        function clearDet() {
            var msg = [];
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Code</th><th scope="col">Quantity</th><th scope="col">Price</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td scope="row" class="1"  style="text-align:center;">' + (i + 1) + '</td>';
                results += '<td data-title="" class="2"><span id="spn_prod_code">' + msg[i].sku + '</span></td>';
                results += '<td style="display:none;"><input type="text" id="txt_pid_sno" value="' + msg[i].prod_id + '"></input></td>';
                results += '<td data-title="" class="3"><span id="spn_desc">' + msg[i].prod_name + '</span></td>';
                results += '<td data-title="" class="4"><span id="spn_uom">' + msg[i].uim + '</span></td>';
                results += '<td data-title="" class="5"><input type="text" id="txt_qty" class="cls_qty" value="' + msg[i].qty + '"></input></td>';
                results += '<td data-title="" class="6"><input type="text" id="txt_rate" class="cls_rate" value="' + msg[i].price + '"></input></td>';
                results += '<td data-title="" class="7"><input type="text" id="txt_dis_per" onkeypress="return isFloat(event)" class="cls_dis_per" placeholder="Discount %" onchange="cal_dis_amt(this);" ></input></td>';
                results += '<td data-title="" class="8"><input type="text" id="txt_dis_amt" onkeypress="return isFloat(event)" class="cls_disamt" placeholder="Discount Amount" ></input></td>';
                results += '<td data-title="" class="9"><select id="slct_tax_type" class="Taxtypecls"></select></td>';
                results += '<td data-title="" class="10"><input type="text" id="txt_tax_per" onkeypress="return isFloat(event)" placeholder="TAX %" class="cls_tax_per"></input></td>';
                results += '<td data-title="" class="11"><input type="text" id="txt_freight" onkeypress="return isFloat(event)" placeholder="Freight Amount" class="cls_freight"></input></td>';
                results += '<td data-title="" class="12"><select id="slct_ed" class="edcls"></select></td>';
                results += '<td data-title="" class="13"><input type="text" id="txt_ed_tax_per" onkeypress="return isFloat(event)" placeholder="ED TAX %" class="cls_ed_tax_per"></input></td>';

                results += '<td style="display:none;"><input id="txt_sno" type="text" class="form-control"></input></td>';
                results += '</tr>';
            }
            //results += '<tr><td></td><td></td><td><input type="button" id="btn_save" value="Save" class="btn btn-success" onclick="save_schedule_Details_click();"></input></td></tr>';
            results += '</table></div>';
            $("#div_ven_quo").html(results);
            //get_TAX();
            document.getElementById('txt_total_amount').value = "";
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            VENDOR QUOTATION
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i></a></li>
            <li><a href="#">VENDOR QUOTATION</a></li>
        </ol>
    </section>
    <section class="content">
            <div class="box box-info">
                <div id="div_Account">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>VENDOR QUOTATION
                        </h3>
                    </div>
                    <div class="box-body">
                        <div id="div_Emp">
                        </div>
                        <div id='fillform'>
                            <table>
                                <tr>
                                    <th>
                                    </th>
                                </tr>
                                <tr>
                                    <td style="height: 40px;padding-left:16%">
                                        <label>
                                            RFQ No</label><span style="color: red;">*</span>
                                        <input id="txt_rfq_no" class="form-control" placeholder="Enter Request for Quotation No" onkeypress="return isNumber(event)" onchange="btn_schedule_Details_click();" type="text"  name="quo_no"/>
                                    </td>
                                    <td style="width: 20px"></td>
                                    <td style="height: 40px;padding-right:16%;">
                                        <label>
                                            Supplier Name</label><span style="color: red;">*</span>
                                        <input id="txt_sup" class="form-control" placeholder="Enter Supplier Name" type="text"  name="sup_name"/>
                                        <input id="txt_sup_id" class="form-control" style="display:none" type="text"  name="sup_id"/>
                                    </td>
                                </tr>
                                <tr>
                                <td style="height: 40px;padding-left:16%">
                                        <label>
                                            Quotation Date</label><span style="color: red;">*</span>
                                    <div class="input-group date" style="width:100%;">
                                      <div class="input-group-addon cal">
                                        <i class="fa fa-calendar"></i>
                                      </div>
                                      <input id="txt_quo_dt" class="form-control" type="date" name="quo_dt"/>
                                    </div>
                                       
                                    </td>
                                     <td style="width: 20px"></td>
                                      <td style="height: 40px;padding-right:16%;">
                                        <label>
                                            Vendor Quotation no</label><span style="color: red;">*</span>
                                        <input id="txt_ven_quo_no" type="text" class="form-control" placeholder="Enter Vendor Quotation No" name="ven_quo_no"/>
                                    </td>
                                    
                                </tr>
                                <tr>
                                    <td style="height: 40px;padding-left:16%">
                                        <label>
                                            Freight Amount</label>
                                        <input id="txt_freight" class="form-control" onkeypress="return isFloat(event)" onchange="calTotal();" placeholder="Enter Freight Amount" type="text"  name="freight"/>
                                    </td>
                                    <td style="width:20px;"></td>
                                    <td style="height: 40px;padding-right:16%;">
                                        <label>
                                            Transport Charges</label>
                                        <input id="txt_transport_chrgs" class="form-control" onchange="calTotal();" onkeypress="return isFloat(event)" type="text" placeholder="Enter Transport Charges" name="transport_chrgs"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;padding-left:16%">
                                        <label>
                                            Price Basis</label>
                                        <select id="slct_price_basis" class="form-control">
                                            <option value="">SELECT</option>
                                            <option value="Ex-factary">Ex-factory</option>
                                            <option value="Ex-OurLocation">Ex-OurLocation</option>
                                        </select>
                                    </td>
                                    <td style="width: 20px"></td>
                                    <td style="height: 40px;padding-right:16%;">
                                        <label>
                                            Delivery Terms</label><span style="color: red;">*</span>
                                        <select id="slct_deliveryterms" class="form-control">
                                        </select>
                                    </td>
                                    
                                </tr>
                                <tr>
                                <td style="height: 40px;padding-left:16%">
                                        <label>
                                            Payment Type</label><span style="color: red;">*</span>
                                        <select id="slct_payment_type" class="form-control">
                                        </select>
                                    </td>
                                     <td style="width: 20px"></td>
                                     <td style="height: 40px;padding-right:16%;">
                                        <label>Delivery Address</label><span style="color: red;">*</span>
                                        <select id="slct_delivery_addr" class="form-control">
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;padding-left:16%">
                                        <label>Billing Address</label><span style="color: red;">*</span>
                                        <select id="slct_billing_addr" class="form-control">
                                        </select>
                                    </td>
                                 
                                   
                                    
                                </tr>
                                <tr>
                                 <td style="height: 40px;padding-left:16%">
                                        <label>
                                            Mode of Dispatch</label><span style="color: red;">*</span>
                                        <select id="slct_dispatchmode" class="form-control">
                                            <option value="">SELECT</option>
                                            <option value="BY_ROAD">BY ROAD</option>
                                            <option value="OTHER_TRANSPORT">OTHER TRANSPORT</option>
                                        </select>
                                    </td>
                                       <td style="width: 20px"></td>
                                        <td style="height: 40px;padding-right:16%;">
                                        <label>
                                            P and F</label>
                                        <select id="slct_pandf" class="form-control" onchange="calTotal();"></select>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;padding-left:16%">
                                        <label>
                                            Insurance Charges</label>
                                        <input id="txt_insurance_chrgs" class="form-control" onchange="calTotal();" placeholder="Enter Insurance Charges" type="text" onkeypress="return isFloat(event)" name="insurance_chrgs"/>
                                    </td>
                                    <td style="width: 20px"></td>
                                    <td style="height: 40px;padding-right:16%;">
                                        <label>
                                            Other Charges</label>
                                        <input id="txt_other_chrgs" class="form-control" onchange="calTotal();" placeholder="Enter Other Charges" type="text" onkeypress="return isFloat(event)" name="other_chrgs"/>
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
                            </table>
                            <br />
                            <div id="div_ven_quo">
                            </div>
                            <br />
                            <div>
                                <table id="totalamount" style="display:none">
                                    <tr>
                                        <td>
                                            <label>Total Amount</label>
                                        </td>
                                        <td style="width: 5px"></td>
                                        <td>
                                            <input type="text" id="txt_total_amount" class="form-control" />
                                        </td>
                                    </tr>
                                </table>
                                <table align="center">
                                    <tr>
                                    <td>
                                    </td>
                                    <%--<td style="height: 40px;">
                                        <input id="btn_save" type="button" class="btn btn-primary" name="submit" value="Save"
                                            onclick="save_vendor_quo();"/>
                                    </td>
                                        <td style="width: 5px"></td>
                                    <td>
                                        <input id="btn_clear" type="button" class="btn btn-danger" name="submit" value="RESET"
                                            onclick="clear_vendor_quo();"/>
                                    </td>--%>
                                    <td>
                                        <table>
                                           <tr>
                                            <td>
                                            <div class="input-group" id="div_save_display">
                                                <div class="input-group-addon">
                                                <span class="glyphicon glyphicon-ok" id="btn_save1" onclick="save_vendor_quo()"></span> <span id="btn_save" onclick="save_vendor_quo()">Save</span>
                                          </div>
                                          </div>
                                            </td>
                                            <td style="width:10px;"></td>
                                            <td>
                                             <div class="input-group">
                                                <div class="input-group-close">
                                                <span class="glyphicon glyphicon-remove" id='btn_close1' onclick="clear_vendor_quo()"></span> <span id='btn_close' onclick="clear_vendor_quo()">RESET</span>
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
            </div>
        </section>
</asp:Content>
