<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true"
    CodeFile="PurchaseOrder.aspx.cs" Inherits="PurchaseOrder" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            $('#btn_addDept').click(function () {
                $('#PurchaseOrder_FillForm').css('display', 'block');
                $('#showlogs').css('display', 'none');
                $('#div_POData').hide();
                $('#newrow').css('display', 'block');
                get_TAX();
                get_DelivaryTerms();
                get_PaymentDetails();
                get_PandF();
                get_productcode();
                get_productcode1();
                get_supplier();
                GetFixedrows();
                get_Address();
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
                $('#txtDelivaryDate').val(yyyy + '-' + mm + '-' + dd);
                $('#txtPoDate').val(yyyy + '-' + mm + '-' + dd);
                $('#txtExipredate').val(yyyy + '-' + mm + '-' + dd);
                $('#txtQtnDate').val(yyyy + '-' + mm + '-' + dd);
                scrollTo(0, 0);
            });
            $('#close_vehmaster').click(function () {
                $('#PurchaseOrder_FillForm').css('display', 'none');
                $('#showlogs').css('display', 'block');
                $('#div_POData').show();
                forclearall();
                emptytable3 = [];
                emptytable4 = [];
            });
            get_purchaseorder_details();
            get_DelivaryTerms();
            get_PaymentDetails();
            get_TAX();
            get_PandF();
            forclearall();
            get_Address();
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
            $('#txtDelivaryDate').val(yyyy + '-' + mm + '-' + dd);
            $('#txtPoDate').val(yyyy + '-' + mm + '-' + dd);
            $('#txtExipredate').val(yyyy + '-' + mm + '-' + dd);
            $('#txtQtnDate').val(yyyy + '-' + mm + '-' + dd);
            today_date = yyyy + '-' + mm + '-' + dd;
            emptytable3 = [];
            emptytable4 = [];
            scrollTo(0, 0);
        });
        var today_date = "";
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

        var supperdetails = [];
        function get_supplier() {
            var data = { 'op': 'get_supplier' };
            var s = function (msg) {
                if (msg) {
                    supperdetails = msg;
                    var availableTags = [];
                    for (i = 0; i < msg.length; i++) {
                        availableTags.push(msg[i].companyname);
                    }
                    $("#txtshortName").autocomplete({
                        source: function (req, responseFn) {
                            var re = $.ui.autocomplete.escapeRegex(req.term);
                            var matcher = new RegExp("^" + re, "i");
                            var a = $.grep(availableTags, function (item, index) {
                                return matcher.test(item);
                            });
                            responseFn(a);
                        },
                        change: ravi,
                        autoFocus: true
                    });
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        function ravi() {
            var name = document.getElementById('txtshortName').value;
            for (var i = 0; i < supperdetails.length; i++) {
                if (name == supperdetails[i].companyname) {
                    if (supperdetails[i].stateid != "") {
                        document.getElementById('txtName').value = supperdetails[i].name;
                        document.getElementById('txt_sup_state').value = supperdetails[i].stateid;
                        document.getElementById('txtsupid').value = supperdetails[i].supplierid;
                        if (supperdetails[i].gstin != "") {
                            document.getElementById('txt_sup_gstin').value = supperdetails[i].gstin;
                            document.getElementById('txt_rev_chrg').value = "N";
                        }
                        else {
                            document.getElementById('txt_sup_gstin').value = "";
                            document.getElementById('txt_rev_chrg').value = "Y";
                        }
                    }
                    else {
                        alert("Please Update Supplier State");
                        document.getElementById('txtName').value = "";
                        document.getElementById('txtshortName').value = "";
                        return;
                    }
                }
            }
        }
        function GetFixedrows() {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails_gst">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Code</th><th scope="col">Description</th><th scope="col">UOM</th><th scope="col">Qty</th><th scope="col">Rate</th><th scope="col">Dis %</th><th scope="col">Dis Amt</th><th scope="col">Taxable Value</th><th scope="col">SGST %</th><th scope="col">CGST %</th><th scope="col">IGST %</th><th scope="col"></th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 1; i < 11; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;width:40px;" id="txtsno" >' + i + '</td>';
                results += '<td ><input id="txtCode_gst" type="text" class="codecls_gst"   placeholder= "Select Product Name" style="width:90px;" /></td>';
                results += '<td ><input id="txtDescription" type="text" class="clsdesc_gst"  placeholder= "Select Description"  style="width:90px;"/><input id="txt_item_state" class="cls_item_state" type="text" style="display:none;" /></td>';
                results += '<td ><span id="spn_uim"></span><input id="txtUom" type="text"  class="clsUom"  placeholder="UOM" onkeypress="return isFloat(event)" class="form-control"  style="width:50px;display:none;"/></td>';
                results += '<td ><input id="txtQty" type="text"  class="clsQty_gst"  placeholder= "Enter Qty" onkeypress="return isFloat(event)"   style="width:60px;"/></td>';
                results += '<td ><input id="txtCost" type="text"  class="clscost"  placeholder= "Cost" onkeypress="return isFloat(event)"   style="width:50px;"/></td>';
                results += '<td ><input id="txtDis" type="text" class="clsdis_gst"  placeholder= "Dis" onkeypress="return isFloat(event)" style="width:50px;"/></td>';
                results += '<td ><span id="spn_dis_amt"></span><input id="txtDisAmt" type="text" class="clsdisamt_gst"  placeholder= "Dis Amt" onkeypress="return isFloat(event)" style="width:60px;display:none;"/></td>';
                results += '<td ><span id="spn_taxable"></span><input id="txt_taxable" type="text"  placeholder="Taxable Value" class="clstaxable" onkeypress="return isFloat(event)" style="width:50px;display:none;"/></td>';
                results += '<td ><span id="spn_sgst"></span><input id="txtsgst" type="text"  placeholder="SGST %" class="clssgst" readonly onkeypress="return isFloat(event)" style="width:50px;display:none;"/></td>';
                results += '<td ><span id="spn_cgst"></span><input id="txtcgst" type="text"  placeholder="CGST %" class="clscgst" readonly onkeypress="return isFloat(event)" style="width:50px;display:none;"/></td>';
                results += '<td ><span id="spn_igst"></span><input id="txtigst" type="text" class="clsigst" placeholder="IGST %" readonly onkeypress="return isFloat(event)"  style="width:50px;display:none;"/></td>';
                results += '<td ><span id="txttotal"  class="clstotal_gst"  onkeypress="return isFloat(event)"  style="width:500px;"></td>';
                results += '<td style="display:none"><input id="hdnproductsno" type="hidden" /></td>';
                results += '<td data-title="Minus"><span><img src="images/minus.png" onclick="removerow_product(this)" style="cursor:pointer"/></span></td>';
                results += '<td style="display:none;" class="4">' + i + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
        }

        $(document).click(function () {
            $('#tabledetails_gst').on('change', '.clsQty_gst', calTotal_gst)
            $('#tabledetails_gst').on('change', '.clscost', calTotal_gst)
            $('#tabledetails_gst').on('change', '.clssgst', calTotal_gst)
            $('#tabledetails_gst').on('change', '.clsdis_gst', calTotal_gst)
            $('#tabledetails_gst').on('change', '.clscgst', calTotal_gst)
            $('#tabledetails_gst').on('change', '.clsigst', calTotal_gst)
            $('#tabledetails_gst').on('change', '.clstotal_gst', calTotal_gst)
        });

        var sgstval = 0;
        var sgsttax = 0;
        var sgst = 0;
        var cgstval = 0;
        var cgsttax = 0;
        var cgst = 0;
        var igstval = 0;
        var igsttax = 0;
        var igst = 0;
        var gst = 0;
        function calTotal_gst() {
            var rev_chrg = document.getElementById('txt_rev_chrg').value;
            var $row = $(this).closest('tr'),
            price = $row.find('.clscost').val(),
            quantity = $row.find('.clsQty_gst').val(),
            sum = quantity;
            discount1 = sum * price;
            disper = $row.find('.clsdis_gst').val(),
            totalval = parseFloat(discount1) * (disper) / 100 || 0; ;
            discount = discount1 - totalval;
            $row.find('.clsdisamt_gst').val(totalval);
            $row.find('#spn_dis_amt').text(totalval);
            pf = document.getElementById("ddlpf");
            pf1 = pf.options[pf.selectedIndex].text;
            pfamt = pf1;
            tpfamt = parseFloat(pfamt) / 100;
            tpfamt1 = parseFloat(discount) * (tpfamt) || 0;
            Discountedpf = tpfamt1 + discount;
            $row.find('.clstaxable').val(Discountedpf);
            $row.find('#spn_taxable').text(Discountedpf.toFixed(2));
            sgstval = $row.find('.clssgst').val(),
            sgsttax = parseFloat(sgstval) / 100;
            sgst = parseFloat(Discountedpf) * (sgsttax) || 0;
            cgstval = $row.find('.clscgst').val(),
            cgsttax = parseFloat(cgstval) / 100;
            cgst = parseFloat(Discountedpf) * (cgsttax) || 0;

            igstval = $row.find('.clsigst').val(),
            igsttax = parseFloat(igstval) / 100;
            igst = parseFloat(Discountedpf) * (igsttax) || 0;

            gst = sgst + cgst + igst;
            fright = parseFloat(document.getElementById('txtFrAmt').value) || 0;
            transport_chrgs = parseFloat(document.getElementById('txt_transport').value) || 0;

            if (rev_chrg == "Y") {
                totalpoval = parseFloat(Discountedpf);
            }
            else if (rev_chrg == "N") {
                totalpoval = gst + parseFloat(Discountedpf);
            }
            else {
                totalpoval = gst + parseFloat(Discountedpf);
            }
            $row.find('.clstotal_gst').html(parseFloat(totalpoval).toFixed(2));
            clstotalval_gst();
        }

        function clstotalval_gst() {
            var totaamount = 0; var totalpfamount = 0;
            var freightamount = parseFloat(document.getElementById('txtFrAmt').value) || 0;
            var transportamount = parseFloat(document.getElementById('txt_transport').value) || 0;
            $('.clstotal_gst').each(function (i, obj) {
                var totlclass = $(this).html();

                if (totlclass == "" || totlclass == "0") {
                }
                else {
                    totaamount += parseFloat(totlclass);
                }
            });

            //var transport_tax = (transportamount1 * 18) / 100;
            //var transportamount = transportamount1 + transport_tax;
            var totalamount1 = parseFloat(totaamount) + freightamount + transportamount;
            var grandtotal = parseFloat(totalamount1);
            var grandtotal1 = grandtotal.toFixed(2);
            var diff = 0;
            if (grandtotal > grandtotal1) {
                diff = grandtotal - grandtotal1;
            }
            else {
                diff = grandtotal1 - grandtotal;
            }
            document.getElementById('spn_totalpoamt').innerHTML = grandtotal;
            document.getElementById('spn_roundoff').innerHTML = diff;
            document.getElementById('txtPoamount').innerHTML = grandtotal1;
        }

        var DataTable;
        var sub_sno = "";
        function insertrow() {
            var todaydate = today_date.split('-');
            var date = "2017-07-01".split('-');

            var firstDate = new Date();
            firstDate.setFullYear(todaydate[0], (todaydate[1] - 1), todaydate[2]);
            var secondDate = new Date();
            secondDate.setFullYear(date[0], (date[1] - 1), date[2]);

            if (firstDate < secondDate) {
                get_productcode();
                get_productcode1();
                get_supplier();
                DataTable = [];
                calTotal();
                clstotalval();
                var txtsno = 0;
                var code = 0;
                var description = 0;
                var qty = 0;
                var cost = 0;
                var free = 0;
                var taxtype = 0;
                var ed = 0;
                var sno = 0;
                var uim = 0;
                var tax = 0;
                var edtax = 0;
                var productamount = 0;
                var hdnproductsno = 0;
                var rows = $("#tabledetails tr:gt(0)");
                var rowsno = 1;
                $(rows).each(function (i, obj) {
                    if ($(this).find('#txtCode').val() != "") {
                        txtsno = rowsno;
                        code = $(this).find('#txtCode').val();
                        description = $(this).find('#txtDescription').val();
                        qty = $(this).find('#txtQty').val();
                        cost = $(this).find('#txtCost').val();
                        uim = $(this).find('#txtUom').val();
                        taxtype = $(this).find('#ddlTaxtype').val();
                        ed = $(this).find('#ddlEd').val();
                        dis = $(this).find('#txtDis').val();
                        disamt = $(this).find('#spn_dis_amt').text();
                        tax = $(this).find('#txtTax').val();
                        edtax = $(this).find('#txtEdtax').val();
                        productamount = $(this).find('#txttotal').text();
                        hdnproductsno = $(this).find('#hdnproductsno').val();
                        sno = $(this).find('#txt_sub_sno').val();
                        DataTable.push({ Sno: txtsno, code: code, description: description, uim: uim, qty: qty, cost: cost, taxtype: taxtype, dis: dis, disamt: disamt, ed: ed, tax: tax, edtax: edtax, hdnproductsno: hdnproductsno, productamount: productamount, sno: sno });
                        rowsno++;

                    }
                });
                code = 0;
                description = 0;
                qty = 0;
                cost = 0;
                free = 0;
                taxtype = 0;
                ed = 0;
                uim = 0;
                disamt = 0;
                dis = 0;
                tax = 0;
                sno = 0;
                edtax = 0;
                productamount = 0;
                hdnproductsno = 0;
                var Sno = parseInt(txtsno) + 1;
                DataTable.push({ Sno: Sno, code: code, description: description, uim: uim, qty: qty, cost: cost, taxtype: taxtype, ed: ed, dis: dis, disamt: disamt, tax: tax, edtax: edtax, hdnproductsno: hdnproductsno, productamount: productamount, sno: sno });
                var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
                results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Code</th><th scope="col">Description</th><th scope="col">UOM</th><th scope="col">Qty</th><th scope="col">Rate</th><th scope="col">Dis%</th><th scope="col">Dis Amt</th><th scope="col">Tax Type</th><th scope="col">Tax%</th><th scope="col">ED</th><th scope="col">ED Tax%</th><th scope="col"></th></tr></thead></tbody>';
                for (var i = 0; i < DataTable.length; i++) {
                    sub_sno = DataTable[i].sno;
                    results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + DataTable[i].Sno + '</td>';
                    results += '<td ><input id="txtCode" type="text" class="codecls"  style="width:90px;" onkeypress="return isFloat(event)"  value="' + DataTable[i].code + '"/></td>';
                    results += '<td ><input id="txtDescription" type="text" class="clsdesc" style="width:90px;" value="' + DataTable[i].description + '"/></td><input id="txt_item_state" class="cls_item_state" type="text" style="display:none;" />';
                    results += '<td ><span id="spn_uim">' + DataTable[i].uim + '</span><input id="txtUom" type="text" class="clsUom"  onkeypress="return isFloat(event)" style="width:50px;display:none;" value="' + DataTable[i].uim + '"/></td>';
                    results += '<td ><input id="txtQty" type="text" class="clsQty"  onkeypress="return isFloat(event)" style="width:60px;" value="' + DataTable[i].qty + '"/></td>';
                    results += '<td ><input id="txtCost" type="text" class="clscost"  onkeypress="return isFloat(event)" style="width:50px;" value="' + DataTable[i].cost + '"/></td>';
                    results += '<td ><input id="txtDis" type="text" class="clsdis" style="width:50px;" onkeypress="return isFloat(event)" value="' + DataTable[i].dis + '"/></td>';
                    results += '<td ><span id="spn_dis_amt">' + DataTable[i].disamt + '</span><input id="txtDisAmt" type="text" class="clsdisamt" style="width:50px;display:none;" onkeypress="return isFloat(event)" value="' + DataTable[i].disamt + '"/></td>';
                    results += '<td><select id="ddlTaxtype"  class="Taxtypecls" style="width:90px; value="' + DataTable[i].taxtype + '"/></td>';
                    results += '<td ><input id="txtTax" type="text" class="clstax"  style="width:50px;" onkeypress="return isFloat(event)" value="' + DataTable[i].tax + '"/></td>';
                    results += '<td ><select id="ddlEd" type="text" class="edcls" style="width:90px;" value="' + DataTable[i].ed + '"/></td>';
                    results += '<td ><input id="txtEdtax" type="text" class="clsed"  style="width:50px;" onkeypress="return isFloat(event)" value="' + DataTable[i].edtax + '"/></td>';
                    results += '<td><span id="txttotal"  class="clstotal"  onkeypress="return isFloat(event)"style="width:500px;">' + DataTable[i].productamount + '</span></td>';
                    results += '<td style="display:none"><input id="hdnproductsno" type="hidden" value="' + DataTable[i].hdnproductsno + '"/></td>';
                    results += '<td data-title="Minus"><span><img src="images/minus.png" onclick="removerow(this)" style="cursor:pointer"/></span></td>';
                    results += '<td data-title="From" style="display:none"><input class="14" id="txt_sub_sno" name="txt_sub_sno" value="' + DataTable[i].sno + '"style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<td style="display:none;" class="4">' + i + '</td></tr>';
                }
                results += '</table></div>';
                $("#div_SectionData").html(results);
                gettaxtypevalues1(sub_sno, DataTable);
                getedtypevalues1(sub_sno, DataTable);
            }
            else {//gst
                get_productcode();
                get_productcode1();
                get_supplier();
                DataTable = [];
                DataTable1 = [];
                var txtsno = 0;
                var code = 0;
                var description = 0;
                var qty = 0;
                var cost = 0;
                var hsn = 0;
                var taxabale = 0;
                var sno = 0;
                var uim = 0;
                var sgst_per = 0;
                var sgst_amt = 0;
                var cgst_per = 0;
                var cgst_amt = 0;
                var igst_per = 0;
                var igst_amt = 0;
                var productamount = 0;
                var hdnproductsno = 0;
                var rows = $("#tabledetails_gst tr:gt(0)");
                var rowsno = 1;
                $(rows).each(function (i, obj) {
                    if ($(this).find('#txtCode_gst').val() != "" || $(this).find('#txtCode_gst').val() != undefined || $(this).find('#txtCode_gst').val() != "0" || $(this).find('#txtCode_gst').val() != 0) {
                        txtsno = rowsno;
                        code = $(this).find('#txtCode_gst').val();
                        description = $(this).find('#txtDescription').val();
                        qty = $(this).find('#txtQty').val();
                        hsn = $(this).find('#txthsn').val();
                        cost = $(this).find('#txtCost').val();
                        uim = $(this).find('#txtUom').val();
                        taxable = $(this).find('#txt_taxable').val();
                        dis = $(this).find('#txtDis').val();
                        disamt = $(this).find('#spn_dis_amt').text();
                        sgst_per = $(this).find('#txtsgst').val();
                        sgst_amt = $(this).find('#txtsgst_amt').val();
                        cgst_per = $(this).find('#txtcgst').val();
                        cgst_amt = $(this).find('#txtcgst_amt').val();
                        igst_per = $(this).find('#txtigst').val();
                        igst_amt = $(this).find('#txtigst_amt').val();
                        productamount = $(this).find('#txttotal').text();
                        hdnproductsno = $(this).find('#hdnproductsno').val();
                        sno = $(this).find('#txt_sub_sno').val();
                        DataTable1.push({ Sno: txtsno, code: code, hsn: hsn, taxable: taxable, description: description, uim: uim, qty: qty, cost: cost, dis: dis, disamt: disamt, sgst_per: sgst_per, sgst_amt: sgst_amt, cgst_per: cgst_per, cgst_amt: cgst_amt, igst_per: igst_per, igst_amt: igst_amt, hdnproductsno: hdnproductsno, productamount: productamount, sno: sno });
                        rowsno++;

                    }
                });
                for (var i = 0; i < DataTable1.length; i++) {
                    var code_check = DataTable1[i].code;
                    if (code_check != "") {
                        DataTable.push({ Sno: DataTable1[i].Sno, code: DataTable1[i].code, hsn: DataTable1[i].hsn, taxable: DataTable1[i].taxable, description: DataTable1[i].description, uim: DataTable1[i].uim, qty: DataTable1[i].qty, cost: DataTable1[i].cost, dis: DataTable1[i].dis, disamt: DataTable1[i].disamt, sgst_per: DataTable1[i].sgst_per, sgst_amt: DataTable1[i].sgst_amt, cgst_per: DataTable1[i].cgst_per, cgst_amt: DataTable1[i].cgst_amt, igst_per: DataTable1[i].igst_per, igst_amt: DataTable1[i].igst_amt, hdnproductsno: DataTable1[i].hdnproductsno, productamount: DataTable1[i].productamount, sno: DataTable1[i].sno });
                    }
                }
                code = 0;
                description = 0;
                qty = 0;
                cost = 0;
                hsn = 0;
                taxabale = 0;
                uim = 0;
                disamt = 0;
                dis = 0;
                sgst_per = 0;
                sgst_amt = 0;
                cgst_per = 0;
                cgst_amt = 0;
                igst_per = 0;
                igst_amt = 0;
                taxable = 0;
                sno = 0;
                productamount = 0;
                hdnproductsno = 0;
                var Sno = parseInt(txtsno) + 1;
                DataTable.push({ Sno: Sno, code: code, hsn: hsn, taxable: taxable, description: description, uim: uim, qty: qty, cost: cost, dis: dis, disamt: disamt, sgst_per: sgst_per, sgst_amt: sgst_amt, cgst_per: cgst_per, cgst_amt: cgst_amt, igst_per: igst_per, igst_amt: igst_amt, hdnproductsno: hdnproductsno, productamount: productamount, sno: sno });
                var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails_gst">';
                results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Code</th><th scope="col">Description</th><th scope="col">UOM</th><th scope="col">Qty</th><th scope="col">Rate</th><th scope="col">Dis %</th><th scope="col">Dis Amt</th><th scope="col">Taxable Value</th><th scope="col">SGST %</th><th scope="col">CGST %</th><th scope="col">IGST %</th><th scope="col"></th><th scope="col"></th></tr></thead></tbody>';
                for (var i = 0; i < DataTable.length; i++) {
                    results += '<tr><td scope="row" class="1" style="text-align:center;width:40px;" id="txtsno" >' + (i + 1) + '</td>';
                    results += '<td ><input id="txtCode_gst" type="text" class="codecls_gst" value="' + DataTable[i].code + '" placeholder= "Select Product Name" style="width:90px;" /></td>';
                    results += '<td ><input id="txtDescription" type="text" class="clsdesc_gst" value="' + DataTable[i].description + '" placeholder= "Select Description"  style="width:90px;"/><input id="txt_item_state" class="cls_item_state" type="text" style="display:none;" /></td>';
                    results += '<td ><span id="spn_uim">' + DataTable[i].uim + '</span><input id="txtUom" type="text" value="' + DataTable[i].uim + '" class="clsUom"  placeholder="UOM" onkeypress="return isFloat(event)" class="form-control"  style="width:50px;display:none;"/></td>'
                    results += '<td ><input id="txtQty" type="text"  class="clsQty_gst" value="' + DataTable[i].qty + '" placeholder= "Enter Qty" onkeypress="return isFloat(event)"   style="width:60px;"/></td>';
                    results += '<td ><input id="txtCost" type="text"  class="clscost" value="' + DataTable[i].cost + '" placeholder= "Cost" onkeypress="return isFloat(event)"   style="width:50px;"/></td>'
                    results += '<td ><input id="txtDis" type="text" class="clsdis_gst" value="' + DataTable[i].dis + '" placeholder= "Dis" onkeypress="return isFloat(event)" style="width:50px;"/></td>';
                    results += '<td ><span id="spn_dis_amt">' + DataTable[i].disamt + '</span><input id="txtDisAmt" type="text" class="clsdisamt_gst" value="' + DataTable[i].disamt + '" placeholder= "Dis Amt" onkeypress="return isFloat(event)" style="width:60px;display:none"/></td>';
                    results += '<td ><span id="spn_taxable">' + DataTable[i].taxable + '</span><input id="txt_taxable" type="text"  placeholder="Taxable Value" value="' + DataTable[i].taxable + '" class="clstaxable" onkeypress="return isFloat(event)" style="width:50px;display:none;"/></td>';
                    results += '<td ><span id="spn_sgst">' + DataTable[i].sgst_per + '</span><input id="txtsgst" type="text"  placeholder="SGST %" readonly class="clssgst" value="' + DataTable[i].sgst_per + '" onkeypress="return isFloat(event)" style="width:50px;display:none;"/></td>';
                    results += '<td ><span id="spn_cgst">' + DataTable[i].cgst_per + '</span><input id="txtcgst" type="text"  placeholder="CGST %" readonly class="clscgst" value="' + DataTable[i].cgst_per + '" onkeypress="return isFloat(event)" style="width:50px;display:none;"/></td>';
                    results += '<td ><span id="spn_igst">' + DataTable[i].igst_per + '</span><input id="txtigst" type="text" class="clsigst" placeholder="IGST %" readonly onkeypress="return isFloat(event)" value="' + DataTable[i].igst_per + '" style="width:50px;display:none;"/></td>';
                    results += '<td ><span id="txttotal"  class="clstotal_gst"  onkeypress="return isFloat(event)" style="width:500px;">' + DataTable[i].productamount + '</span></td>';
                    results += '<td style="display:none"><input id="hdnproductsno" value="' + DataTable[i].hdnproductsno + '" type="hidden" /></td>';
                    results += '<td data-title="From" style="display:none"><input class="14" id="txt_sub_sno" name="txt_sub_sno" value="' + DataTable[i].sno + '"style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<td data-title="Minus"><span><img src="images/minus.png" onclick="removerow_product(this)" style="cursor:pointer"/></span></td>';
                    results += '<td style="display:none;" class="4">' + (i + 1) + '</td></tr>';
                }
                results += '</table></div>';
                $("#div_SectionData").html(results);
            }
        }

        function gettaxtypevalues1(sub_sno, DataTable) {
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
                $(this).val(DataTable[i].taxtype);
                i++;
            });
        }

        function getedtypevalues1(sub_sno, DataTable) {
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
                $(this).val(DataTable[i].ed);
                i++;
            });
        }

        var DataTable;
        function removerow(thisid) {
            $(thisid).parents('tr').remove();
        }
        function removerow_product(thisid) {
            $(thisid).parents('tr').remove();

            emptytable4 = [];
            $('#tabledetails_gst> tbody > tr').each(function () {
                var productname = $(this).find('#txtDescription').val();
                emptytable4.push(productname);
            });
            emptytable3 = [];
            $('#tabledetails_gst> tbody > tr').each(function () {
                var sku = $(this).find('#txtCode_gst').val();
                emptytable4.push(sku);
            });
        }
        var replaceHtmlEntites = (function () {
            return function (s) {
                return (s.replace(translate_re, function (match, entity) {
                    return translate[entity];
                }));
            }
        })();
        function save_edit_podetails_click() {
            var todaydate = today_date.split('-');
            var date = "2017-07-01".split('-');

            var firstDate = new Date();
            var secondDate = new Date();

            var PONo = document.getElementById('lblsno').value;
            var name = document.getElementById('txtName').value;
            var shortname = document.getElementById('txtshortName').value;
            var poamount = document.getElementById('txtPoamount').innerHTML;
            var delivarydate = document.getElementById('txtDelivaryDate').value;
            var freigtamt = document.getElementById('txtFrAmt').value;
            var billingaddress = document.getElementById('ddlAddress1').value;
            var address = document.getElementById('ddlAddress').value;
            var pf = document.getElementById('ddlpf').value;
            var terms = document.getElementById('ddlterms').value;
            var transport_charges = document.getElementById('txt_transport').value;
            var pricebasis = document.getElementById('ddlprice').value;
            var remarks = document.getElementById('txtRemarks').value;
            var payment = document.getElementById('ddlpayment').value;
            var quotationno = document.getElementById('txtQutn').value;
            var quotationdate = document.getElementById('txtQtnDate').value;
            var hiddensupplyid = document.getElementById('txtsupid').value;
            var btnval = document.getElementById('btn_RaisePO').innerHTML;
            if (btnval == "Modify") {
                var podate1 = document.getElementById('txt_podate').value;
                var podate = podate1.split('-');
                firstDate.setFullYear(podate[0], (podate[1] - 1), podate[2]);
                secondDate.setFullYear(date[0], (date[1] - 1), date[2]);
            }
            else {
                firstDate.setFullYear(todaydate[0], (todaydate[1] - 1), todaydate[2]);
                secondDate.setFullYear(date[0], (date[1] - 1), date[2]);
            }
            var status = "P";
            if (name == "") {
                alert("Enter  Supplier Name");
                return false;
            }
            if (shortname == "") {
                alert("Enter  CompanyName");
                return false;
            }
            if (delivarydate == "") {
                alert("Select  Delivarydate");
                return false;
            }
            var rev_chrg = document.getElementById('txt_rev_chrg').value;
            var purchage_array = [];
            if (firstDate < secondDate) {
                $('#tabledetails> tbody > tr').each(function () {
                    var txtsno = $(this).find('#txtSno').text();
                    var code = $(this).find('#txtCode').val();
                    var description = $(this).find('#txtDescription').val();
                    var qty = $(this).find('#txtQty').val();
                    var cost = $(this).find('#txtCost').val();
                    var taxtype = $(this).find('#ddlTaxtype').val();
                    var ed = $(this).find('#ddlEd').val();
                    var dis = $(this).find('#txtDis').val();
                    var disamt = $(this).find('#spn_dis_amt').text();
                    var tax = $(this).find('#txtTax').val();
                    var edtax = $(this).find('#txtEdtax').val();
                    var sgst = $(this).find('#spn_sgst').text();
                    var cgst = $(this).find('#spn_cgst').text();
                    var igst = $(this).find('#spn_igst').text();
                    var productamount = $(this).find('#txttotal').text();
                    var sno = $(this).find('#txt_sub_sno').val();
                    var hdnproductsno = $(this).find('#hdnproductsno').val();
                    if (hdnproductsno == "" || hdnproductsno == "0") {
                    }
                    else {
                        purchage_array.push({ 'txtsno': txtsno, 'code': code, 'description': description, 'qty': qty, 'cost': cost, 'dis': dis, 'disamt': disamt, 'taxtype': taxtype, 'ed': ed, 'tax': tax, 'edtax': edtax, 'sgst': "0", 'cgst': "0", 'igst': "0", 'sno': sno, 'hdnproductsno': hdnproductsno, 'productamount': productamount });
                    }
                });
            }
            else {
                $('#tabledetails_gst> tbody > tr').each(function () {
                    var txtsno = $(this).find('#txtSno').text();
                    var code = $(this).find('#txtCode_gst').val();
                    var description = $(this).find('#txtDescription').val();
                    var qty = $(this).find('#txtQty').val();
                    var cost = $(this).find('#txtCost').val();
                    var taxtype = $(this).find('#ddlTaxtype').val();
                    var ed = $(this).find('#ddlEd').val();
                    var dis = $(this).find('#txtDis').val();
                    var disamt = $(this).find('#spn_dis_amt').text();
                    var tax = $(this).find('#txtTax').val();
                    var edtax = $(this).find('#txtEdtax').val();
                    var sgst = $(this).find('#spn_sgst').text();
                    var cgst = $(this).find('#spn_cgst').text();
                    var igst = $(this).find('#spn_igst').text();
                    var productamount = $(this).find('#txttotal').text();
                    var sno = $(this).find('#txt_sub_sno').val();
                    var hdnproductsno = $(this).find('#hdnproductsno').val();
                    if (hdnproductsno == "" || hdnproductsno == "0") {
                    }
                    else {
                        purchage_array.push({ 'txtsno': txtsno, 'code': code, 'description': description, 'qty': qty, 'cost': cost, 'dis': dis, 'disamt': disamt, 'taxtype': "", 'ed': "", 'tax': "0", 'edtax': "0", 'sgst': sgst, 'cgst': cgst, 'igst': igst, 'sno': sno, 'hdnproductsno': hdnproductsno, 'productamount': productamount });
                    }
                });
            }
            
            var Data = { 'op': 'save_edit_po_click', 'rev_chrg': rev_chrg, 'remarks': remarks, 'pono': PONo, 'shortname': shortname, 'poamount': poamount, 'name': name, 'delivarydate': delivarydate, 'terms': terms, 'pf': pf, 'freigntamt': freigtamt, 'quotationno': quotationno, 'quotationdate': quotationdate, 'payment': payment, 'hiddensupplyid': hiddensupplyid, 'btnval': btnval, 'status': status, 'pricebasis': pricebasis, 'address': address, 'billingaddress': billingaddress, 'transport_charges': transport_charges, 'Purchase_subarray': purchage_array };
            var s = function (msg) {
                if (msg) {
                    alert(msg);
                    get_purchaseorder_details();
                    $('#PurchaseOrder_FillForm').css('display', 'none');
                    $('#showlogs').css('display', 'block');
                    $('#div_POData').show();
                    forclearall();
                }
            }
            var e = function (x, h, e) {
            };
            CallHandlerUsingJson(Data, s, e);
        }
        function get_purchaseorder_details() {
            var data = { 'op': 'get_purchase_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillpurchase_details(msg);
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
        var purchase_sub_list = [];
        function fillpurchase_details(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr class="trbgclrcls"><th scope="col">Ref NO</th><th scope="col">Po No</th><th scope="col">Supplier Name</th><th scope="col">Po Date</th><th scope="col"></th><th scope="col"></th></tr></thead></tbody>';
            var po = msg[0].podetails;
            purchase_sub_list = msg[0].subpurchasedetails;
            var k = 1;
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            for (var i = 0; i < po.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">';
                results += '<td class="12"  onclick="subpurchaseproduct(\'' + po[i].pono + '\');">' + po[i].pono + '</td>';
                results += '<td data-title="podate" class="5">' + po[i].ponumber + '</td>';
                results += '<td data-title="name" class="1">' + po[i].name + '</td>';
                results += '<td data-title="delivarydate" style="display:none;" class="3">' + po[i].delivarydate + '</td>';
                results += '<td data-title="expiredate" class="4">' + po[i].podate + '</td>';
                results += '<td data-title="poamount" style="display:none;" class="6">' + po[i].poamount + '</td>';
                results += '<td data-title="shortname" class="7" style="display:none;">' + po[i].shortname + '</td>';
                results += '<td data-title="freigntamt" class="8" style="display:none;">' + po[i].freigntamt + '</td>';
                results += '<td data-title="freigntamt" class="29" style="display:none;">' + po[i].transport_charges + '</td>';
                results += '<td data-title="email" class="14" style="display:none;">' + po[i].billingaddress + '</td>';
                results += '<td data-title="address" class="15" style="display:none;">' + po[i].addressid + '</td>';
                results += '<td data-title="quotationno" class="16" style="display:none;">' + po[i].quotationno + '</td>';
                results += '<td data-title="quotationdate" class="17" style="display:none;">' + po[i].quotationdate + '</td>';
                results += '<td data-title="quotationdate" class="22" style="display:none;">' + po[i].payment + '</td>';
                results += '<td data-title="quotationdate" class="20" style="display:none;">' + po[i].terms + '</td>';
                results += '<td data-title="quotationdate" class="21" style="display:none;">' + po[i].pf + '</td>';
                results += '<td data-title="quotationdate" class="26" style="display:none;">' + po[i].remarks + '</td>';
                results += '<td data-title="quotationdate" class="27" style="display:none;">' + po[i].pricebasis + '</td>';
                results += '<td data-title="quotationdate" class="30" style="display:none;">' + po[i].rev_chrg + '</td>';
                results += '<td data-title="brandstatus"><button type="button" title="Click Here To Print!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 printcls"  onclick="prntPo(this)"><span class="glyphicon glyphicon-print" style="top: 0px !important;"></span></button></td>'; // class="btn btn-info btn-outline btn-circle btn-lg m-r-5"
                results += '<td data-title="brandstatus"><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"  onclick="getpurchasevalues(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td>';
                results += '<td data-title="hiddensupplyid" class="18" style="display:none;">' + po[i].hiddensupplyid + '</td>';
                results += '<td data-title="sno" class="13" style="display:none;">' + po[i].sno + '</td></tr>';

                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }

            results += '</table></div>';
            $("#div_POData").html(results);
        }
        var sno = 0;
        function getpurchasevalues(thisid) {
            scrollTo(0, 0);
            get_supplier();
            get_productcode();
            clstotalval();
            calTotal();
            $('#PurchaseOrder_FillForm').css('display', 'block');
            $('#showlogs').css('display', 'none');
            $('#div_POData').hide();
            $('#newrow').css('display', 'block');
            var name = $(thisid).parent().parent().children('.1').html();
            var delivarydate2 = $(thisid).parent().parent().children('.3').html();
            var poamount = $(thisid).parent().parent().children('.6').html();
            var shortname = $(thisid).parent().parent().children('.7').html();
            var freigntamt = $(thisid).parent().parent().children('.8').html();
            var transport_charges = $(thisid).parent().parent().children('.29').html();
            var PONo = $(thisid).parent().parent().children('.12').html();
            var sno = $(thisid).parent().parent().children('.13').html();
            var billingaddress = $(thisid).parent().parent().children('.14').html();
            var address = $(thisid).parent().parent().children('.15').html();
            var quotationno = $(thisid).parent().parent().children('.16').html();
            var quotationdate2 = $(thisid).parent().parent().children('.17').html();
            var terms = $(thisid).parent().parent().children('.20').html();
            var pf = $(thisid).parent().parent().children('.21').html();
            var payment = $(thisid).parent().parent().children('.22').html();
            var remarks = $(thisid).parent().parent().children('.26').html();
            var pricebasis = $(thisid).parent().parent().children('.27').html();
            var hiddensupplyid = $(thisid).parent().parent().children('.18').html();
            var podate2 = $(thisid).parent().parent().children('.4').html();
            var rev_chrg = $(thisid).parent().parent().children('.30').html();

            var delivarydate1 = delivarydate2.split('-');
            var delivarydate = delivarydate1[2] + '-' + delivarydate1[1] + '-' + delivarydate1[0];

            var quotationdate1 = quotationdate2.split('-');
            var quotationdate = quotationdate1[2] + '-' + quotationdate1[1] + '-' + quotationdate1[0];

            var podate1 = podate2.split('-');
            var podate = podate1[2] + '-' + podate1[1] + '-' + podate1[0];

            document.getElementById('txtName').value = name;
            document.getElementById('lblsno').value = PONo;
            document.getElementById('txtshortName').value = shortname;
            document.getElementById('txtPoamount').innerHTML = poamount;
            document.getElementById('txtDelivaryDate').value = delivarydate;
            document.getElementById('ddlAddress').value = address;
            document.getElementById('ddlAddress1').value = billingaddress;
            document.getElementById('txtFrAmt').value = freigntamt;
            document.getElementById('txt_transport').value = transport_charges;
            document.getElementById('txtQutn').value = quotationno;
            document.getElementById('ddlterms').value = terms;
            document.getElementById('ddlpf').value = pf;
            document.getElementById('ddlprice').value = pricebasis;
            document.getElementById('txtRemarks').value = remarks;
            document.getElementById('txtQtnDate').value = quotationdate;
            document.getElementById('ddlpayment').value = payment;
            document.getElementById('txtsupid').value = hiddensupplyid;

            document.getElementById('txt_rev_chrg').value = rev_chrg;
            document.getElementById('txt_podate').value = podate;
            document.getElementById('btn_RaisePO').innerHTML = "Modify";
            var table = document.getElementById("tabledetails");
            ravi();
            var todaydate = podate.split('-');
            var date = "2017-07-01".split('-');

            var firstDate = new Date();
            firstDate.setFullYear(todaydate[0], (todaydate[1] - 1), todaydate[2]);
            var secondDate = new Date();
            secondDate.setFullYear(date[0], (date[1] - 1), date[2]);
            if (firstDate >= secondDate) {
                var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails_gst">';
                results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Code</th><th scope="col">Description</th><th scope="col">UOM</th><th scope="col">Qty</th><th scope="col">Rate</th><th scope="col">Dis %</th><th scope="col">Dis Amt</th><th scope="col">Taxable Value</th><th scope="col">SGST %</th><th scope="col">CGST %</th><th scope="col">IGST %</th><th scope="col"></th><th scope="col"></th></tr></thead></tbody>';
                var pandf = document.getElementById("ddlpf");
                var pandf1 = pandf.options[pandf.selectedIndex].text;
                var total_po_amount = 0;
                for (var i = 0; i < purchase_sub_list.length; i++) {
                    if (PONo == purchase_sub_list[i].pono) {
                        results += '<tr><td scope="row" class="1" style="text-align:center;width:40px;" id="txtsno" >' + (i + 1) + '</td>';
                        results += '<td ><input id="txtCode_gst" type="text" class="codecls_gst" value="' + purchase_sub_list[i].code + '" placeholder= "Select Product Name" style="width:90px;" /></td>';
                        results += '<td ><input id="txtDescription" type="text" class="clsdesc_gst" value="' + purchase_sub_list[i].description + '" placeholder= "Select Description"  style="width:90px;"/><input id="txt_item_state" class="cls_item_state" type="text" style="display:none;" /></td>';
                        results += '<td ><span id="spn_uim">' + purchase_sub_list[i].uim + '</span><input id="txtUom" type="text" value="' + purchase_sub_list[i].uim + '" class="clsUom"  placeholder="UOM" onkeypress="return isFloat(event)" class="form-control"  style="width:50px;display:none;"/></td>'
                        results += '<td ><input id="txtQty" type="text"  class="clsQty_gst" value="' + purchase_sub_list[i].qty + '" placeholder= "Enter Qty" onkeypress="return isFloat(event)"   style="width:60px;"/></td>';
                        results += '<td ><input id="txtCost" type="text"  class="clscost" value="' + purchase_sub_list[i].cost + '" placeholder= "Cost" onkeypress="return isFloat(event)"   style="width:50px;"/></td>';
                        results += '<td ><input id="txtDis" type="text" class="clsdis_gst" value="' + purchase_sub_list[i].dis + '" placeholder= "Dis" onkeypress="return isFloat(event)" style="width:50px;"/></td>';
                        var disc = parseFloat(purchase_sub_list[i].dis);
                        var quantity = parseFloat(purchase_sub_list[i].qty);
                        var rs = parseFloat(purchase_sub_list[i].cost);
                        var qty_cost = quantity * rs;
                        var disc_amt = (qty_cost * disc) / 100 || 0;
                        results += '<td ><span id="spn_dis_amt">' + disc_amt + '</span><input id="txtDisAmt" type="text" class="clsdisamt_gst" value="' + disc_amt + '" placeholder= "Dis Amt" onkeypress="return isFloat(event)" style="width:60px;display:none"/></td>';
                        var amount_after_disc = qty_cost - disc_amt;
                        var tpandfamt = parseFloat(pandf1) / 100;
                        var tpandfamt1 = parseFloat(amount_after_disc) * (tpandfamt) || 0;
                        var taxable = tpandfamt1 + amount_after_disc;
                        results += '<td ><span id="spn_taxable">' + taxable + '</span><input id="txt_taxable" type="text"  placeholder="Taxable Value" value="' + taxable + '" class="clstaxable" onkeypress="return isFloat(event)" style="width:50px;display:none;"/></td>';
                        results += '<td ><span id="spn_sgst">' + purchase_sub_list[i].sgst_per + '</span><input id="txtsgst" type="text"  placeholder="SGST %" class="clssgst" readonly value="' + purchase_sub_list[i].sgst_per + '" onkeypress="return isFloat(event)" style="width:50px;display:none;"/></td>';
                        var sgst_amount = taxable * (parseFloat(purchase_sub_list[i].sgst_per)) / 100;
                        results += '<td ><span id="spn_cgst">' + purchase_sub_list[i].cgst_per + '</span><input id="txtcgst" type="text"  placeholder="CGST %" class="clscgst" readonly value="' + purchase_sub_list[i].cgst_per + '" onkeypress="return isFloat(event)" style="width:50px;display:none;"/></td>';
                        var cgst_amount = taxable * (parseFloat(purchase_sub_list[i].cgst_per)) / 100;
                        if (purchase_sub_list[i].sgst_per != "" || purchase_sub_list[i].cgst_per != "") {
                            $(".clsigst").prop("readonly", true);
                        }
                        else {
                            $(".clsigst").prop("readonly", false);
                        }
                        results += '<td ><span id="spn_igst">' + purchase_sub_list[i].igst_per + '</span><input id="txtigst" type="text" class="clsigst" placeholder="IGST %" readonly onkeypress="return isFloat(event)" value="' + purchase_sub_list[i].igst_per + '" style="width:50px;display:none;"/></td>';
                        var igst_amount = taxable * (parseFloat(purchase_sub_list[i].igst_per)) / 100;
                        if (purchase_sub_list[i].igst_per != "") {
                            $(".clssgst").prop("readonly", true);
                            $(".clscgst").prop("readonly", true);
                        }
                        else {
                            $(".clssgst").prop("readonly", false);
                            $(".clscgst").prop("readonly", false);
                        }
                        var product_amount = 0;
                        if (rev_chrg == "Y") {
                            product_amount = taxable;
                        }
                        else if (rev_chrg == "N") {
                            product_amount = taxable + sgst_amount + cgst_amount + igst_amount;
                        }
                        else {
                            product_amount = taxable + sgst_amount + cgst_amount + igst_amount;
                        }
                        total_po_amount += parseFloat(product_amount);
                        results += '<td ><span id="txttotal"  class="clstotal_gst"  onkeypress="return isFloat(event)" value="' + product_amount + '" style="width:500px;"></td>';
                        results += '<td style="display:none"><input id="hdnproductsno" value="' + purchase_sub_list[i].hdnproductsno + '" type="hidden" /></td>';
                        results += '<td data-title="From" style="display:none"><input class="14" id="txt_sub_sno" name="txt_sub_sno" value="' + purchase_sub_list[i].sno + '"style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                        results += '<td data-title="Minus"><span><img src="images/minus.png" onclick="removerow_product(this)" style="cursor:pointer"/></span></td>';
                        results += '<td style="display:none;" class="4">' + (i + 1) + '</td></tr>';
                    }
                }
                results += '</table></div>';
                $("#div_SectionData").html(results);
                var freightamount = parseFloat(freigntamt) || 0;
                var transportamount = parseFloat(transport_charges) || 0;
                total_po_amount = total_po_amount + freightamount + transportamount;
                var grandtotal1 = total_po_amount.toFixed(2);
                var diff = 0;
                if (total_po_amount > grandtotal1) {
                    diff = total_po_amount - grandtotal1;
                }
                else {
                    diff = grandtotal1 - total_po_amount;
                }
                document.getElementById('spn_totalpoamt').innerHTML = total_po_amount;
                document.getElementById('spn_roundoff').innerHTML = diff;
                document.getElementById("txtPoamount").innerHTML = grandtotal1;
            }
            else {
                var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
                results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Code</th><th scope="col">Description</th><th scope="col">UOM</th><th scope="col">Qty</th><th scope="col">Rate</th><th scope="col">Dis%</th><th scope="col">Dis Amt</th><th scope="col">Tax Type</th><th scope="col">Tax%</th><th scope="col">ED</th><th scope="col">ED Tax%</th><th scope="col"></th></tr></thead></tbody>';
                var k = 1;
                for (var i = 0; i < purchase_sub_list.length; i++) {
                    if (PONo == purchase_sub_list[i].pono) {
                        results += '<tr><td data-title="Sno" class="1">' + k + '</td>';
                        results += '<td data-title="From"><input id="txtCode" class="codecls" name="code" readonly value="' + purchase_sub_list[i].code + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                        results += '<td data-title="From"><input class="3" id="txtDescription"  name="description" readonly class="clsdesc" value="' + purchase_sub_list[i].description + '" style="width:90px; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                        results += '<td data-title="From"><span id="spn_uim">' + purchase_sub_list[i].uim + '</span><input  class="clsUom" id="txtUom" name="cost"  value="' + purchase_sub_list[i].uim + '" onkeypress="return isFloat(event)" style="width:60px; font-size:12px;padding: 0px 5px;height:30px;display:none"></td>';
                        results += '<td data-title="From"><input class="clsQty" id="txtQty"  name="qty"  value="' + purchase_sub_list[i].qty + '" onkeypress="return isFloat(event)" style="width:60px; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                        results += '<td data-title="From"><input  class="clscost" id="txtCost" name="cost"  value="' + parseFloat(purchase_sub_list[i].cost).toFixed(2) + '" onkeypress="return isFloat(event)" style="width:60px; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                        results += '<td data-title="From"><input  id="txtDis" name="dis" class="clsdis" value="' + purchase_sub_list[i].dis + '" onkeypress="return isFloat(event)"  style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                        results += '<td data-title="From"><span id="spn_dis_amt">' + parseFloat(purchase_sub_list[i].disamt).toFixed(2) + '</span><input  id="txtDisAmt" class="clsdisamt" name="disamt" value="' + parseFloat(purchase_sub_list[i].disamt).toFixed(2) + '" onkeypress="return isFloat(event)" style="width:60px;display:none; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                        results += '<td data-title="From"><select id="ddlTaxtype" class="Taxtypecls" name="taxtype"   value="' + purchase_sub_list[i].taxtype + '"  style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></select></td>';
                        results += '<td data-title="From"><input  id="txtTax" class="clstax"  name="tax" value="' + purchase_sub_list[i].tax + '" onkeypress="return isFloat(event)" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                        results += '<td data-title="From"><select id="ddlEd" class="edcls"  name="ed"  value="' + purchase_sub_list[i].ed + '"  style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></select></td>';
                        results += '<td data-title="From"><input  id="txtEdtax" name="edtax" class="clsed" value="' + purchase_sub_list[i].edtax + '" onkeypress="return isFloat(event)" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                        results += '<td><span id="txttotal"  class="clstotal"  onkeypress="return isFloat(event)"style="width:500px;">' + parseFloat(purchase_sub_list[i].productamount).toFixed(2) + '</span></td>';
                        results += '<td style="display:none" data-title="From"><input class="13" id="hdnproductsno" type="hidden" name="hdnproductsno" value="' + purchase_sub_list[i].hdnproductsno + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                        results += '<td data-title="Minus"><span><img src="images/minus.png" onclick="removerow(this)" style="cursor:pointer"/></span></td>';
                        results += '<td data-title="From" style="display:none"><input class="14" id="txt_sub_sno" name="txt_sub_sno" value="' + purchase_sub_list[i].sno + '"style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td></tr>';
                        k++;
                    }
                }
                results += '</table></div>';
                $("#div_SectionData").html(results);
                gettaxtypevalues(PONo, purchase_sub_list);
                getedtypevalues(PONo, purchase_sub_list);
            }
        }

        function gettaxtypevalues(PONo, purchase_sub_list) {
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
                $(this).val(purchase_sub_list[i].taxtype);
                i++;
            });
        }

        function getedtypevalues(PONo, purchase_sub_list) {
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
                $(this).val(purchase_sub_list[i].ed);
                i++;
            });
        }

        function fillcategoryvalues(msg) {
            $('#divMainAddNewRow').css('display', 'block');
            $('#hiddeninward').css('display', 'none');
            $('#hiddenoutward').css('display', 'none');
            j = 1;
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr></th><th scope="col">Sno</th><th scope="col">ProductName</th><th scope="col">Price</th><th scope="col">Quantity</th><th scope="col">Value</th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '"><th scope="row" class="1" style="text-align:center;">' + j + '</th>';
                results += '<td data-title="inwarddate" class="2">' + msg[i].productname + '</td>';
                results += '<td data-title="inwarddate" class="3">' + msg[i].price + '</td>';
                results += '<td data-title="inwarddate" class="4">' + msg[i].qty + '</td>';
                results += '<td data-title="invoicedate" class="tammountcls" >' + msg[i].StoresValue + '</td><tr>';
                j++;

                l = l + 1;
                if (l == 4) {
                    l = 0;
                }

            }
            results += '<tr><th scope="row" class="1" style="text-align:center;"></th>';
            results += '<td data-title="brandstatus" class="badge bg-yellow">Total</td>';
            results += '<td data-title="brandstatus" class="3"></td>';
            results += '<td data-title="brandstatus" class="4"></td>';
            results += '<td data-title="brandstatus" class="5"><span id="totalcls" class="badge bg-yellow"></span></td></tr>';
            results += '</table></div>';
            $("#ShowCategoryData").html(results);
            GettotalclsCal();
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
            scrollTo(0, 0);
        }
        function subpurchaseproduct(pono) {
            var pono;
            var data = { 'op': 'purchaseorderproductname', 'psno': pono };
            var s = function (msg) {
                if (msg) {
                    if (msg) {
                        $('#divMainAddNewRow').css('display', 'none');
                        fillcategoryvalues(msg);
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

        function prntPo(thisid) {
            var psno = $(thisid).parent().parent().children('.12').html();
            var data = { 'op': 'get_Po_print', 'sno': psno };
            var s = function (msg) {
                if (msg) {
                    window.open("POReport.aspx", "_self");
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
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
        function clstotalval() {
            var totaamount = 0; var totalpfamount = 0;
            $('.clstotal').each(function (i, obj) {
                var totlclass = $(this).html();

                if (totlclass == "" || totlclass == "0") {
                }
                else {
                    totaamount += parseFloat(totlclass);
                }
            });

            var totalamount1 = parseFloat(totaamount) + parseFloat(fright) + parseFloat(transport_chrgs);
            var grandtotal = parseFloat(totalamount1);
            var grandtotal1 = grandtotal.toFixed(2);
            var diff = 0;
            if (grandtotal > grandtotal1) {
                diff = grandtotal - grandtotal1;
            }
            else {
                diff = grandtotal1 - grandtotal;
            }
            document.getElementById('spn_totalpoamt').innerHTML = grandtotal.toFixed(2);
            document.getElementById('spn_roundoff').innerHTML = diff.toFixed(2);
            document.getElementById('txtPoamount').innerHTML = grandtotal1;
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
           price = $row.find('.clscost').val(),
           quantity = $row.find('.clsQty').val(),
            sum = quantity;
            discount1 = sum * price;
            disper = $row.find('.clsdis').val(),
            totalval = parseFloat(discount1) * (disper) / 100 || 0; ;
            discount = discount1 - totalval;
            $row.find('.clsdisamt').val(totalval);
            $row.find('#spn_dis_amt').text(totalval);
            pf = document.getElementById("ddlpf");
            pf1 = pf.options[pf.selectedIndex].text;
            pfamt = pf1;
            tpfamt = parseFloat(pfamt) / 100;
            tpfamt1 = parseFloat(discount) * (tpfamt) || 0;

            edval = $row.find('.clsed').val(),
            edper = parseFloat(edval) / 100;
            edtotalval = (discount * edper) || 0;
            Discountedpf = tpfamt1 + edtotalval + discount;
            tax1 = $row.find('.clstax').val(),
            tax = parseFloat(tax1) / 100;
            totaltax = parseFloat(Discountedpf) * (tax) || 0;
            fright = document.getElementById('txtFrAmt').value || 0;
            transport_chrgs = document.getElementById('txt_transport').value || 0;

            if (edtotalval == 0 || totaltax == 0) {
                if (discount == 0) {
                    $row.find('.clstotal').html(parseFloat(Discountedpf).toFixed(2));
                }
                else {
                    if (totaltax == 0) {
                        $row.find('.clstotal').html(parseFloat(Discountedpf).toFixed(2));
                    }
                    else {
                        var withtaxval = parseFloat(totaltax) + parseFloat(Discountedpf);
                        $row.find('.clstotal').html(parseFloat(withtaxval).toFixed(2));
                    }
                }
            }
            else {
                totalpoval = parseFloat(edtotalval) + parseFloat(totaltax) + parseFloat(tpfamt1) + parseFloat(discount);
                $row.find('.clstotal').html(parseFloat(totalpoval).toFixed(2));
            }
            clstotalval();
        }
        $(document).click(function () {
            $('#tabledetails').on('change', '.clsQty', calTotal)
            $('#tabledetails').on('change', '.clscost', calTotal)
            $('#tabledetails').on('change', '.clsfree', calTotal)
            $('#tabledetails').on('change', '.clsdis', calTotal)
            $('#tabledetails').on('change', '.clstax', calTotal)
            $('#tabledetails').on('change', '.clsed', calTotal)
            $('#tabledetails').on('change', '.clstotal', calTotal)
        });
        function fillpayment(msg) {
            var data = document.getElementById('ddlpayment');
            var length = data.options.length;
            document.getElementById('ddlpayment').options.length = null;
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].paymenttype != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].paymenttype;
                    option.value = msg[i].sno;
                    data.appendChild(option);
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
            var data = document.getElementById('ddlpf');
            var length = data.options.length;
            document.getElementById('ddlpf').options.length = null;
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
            var data = document.getElementById('ddlAddress');
            var length = data.options.length;
            document.getElementById('ddlAddress').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "select Delivary Address";
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
            var data = document.getElementById('ddlAddress1');
            var length = data.options.length;
            document.getElementById('ddlAddress1').options.length = null;
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
            var data = document.getElementById('ddlterms');
            var length = data.options.length;
            document.getElementById('ddlterms').options.length = null;
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].terms != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].terms;
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
        var filldescrption = [];
        var filldescrption1 = [];
        var filldescription2 = [];
        var filldescription3 = [];
        function get_productcode() {
            var data = { 'op': 'get_product_details_po' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        //filldata(msg);
                        //filldata1(msg);
                        filldata4(msg);
                        filldata3(msg);
                        filldescription2 = msg;
                        filldescription3 = msg;
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

        function get_productcode1() {
            var data = { 'op': 'get_branchwiseproduct_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
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
        function filldata3(msg) {
            var compiledList = [];
            for (var i = 0; i < msg.length; i++) {
                var sku = msg[i].sku;
                compiledList.push(sku);
            }

            $('.codecls_gst').autocomplete({
                source: compiledList,
                change: test3,
                autoFocus: true
            });
        }
        var emptytable3 = [];
        function test3() {
            var sup_state = document.getElementById('txt_sup_state').value;
            //if (sup_state == "")
            //{
            //    alert("Update the Supplier with State");
            //    $('#txtCode_gst').val("");
            //    emptytable3 = [];
            //    return false;
            //}
            var rev_charge_status = document.getElementById('txt_rev_chrg').value;
            var sku = $(this).val();
            var checkflag = true;
            var exists = 0;
            if (emptytable3.indexOf(sku) == -1) {
                for (var i = 0; i < filldescrption.length; i++) {
                    if (sku == filldescrption[i].sku) {
                        exists = 1;
                        if (filldescrption[i].hsn_code != "") {
                            if (filldescrption[i].igst != "") {
                                $(this).closest('tr').find('#txtDescription').val(filldescrption[i].productname);
                                $(this).closest('tr').find('#txtCost').val(filldescrption[i].price);
                                $(this).closest('tr').find('#txtUom').val(filldescrption[i].uim);
                                $(this).closest('tr').find('#spn_uim').text(filldescrption[i].uim);
                                $(this).closest('tr').find('#hdnproductsno').val(filldescrption[i].productid);
                                var item_state = filldescrption[i].state;
                                if (sup_state != item_state) {
                                    $(this).closest('tr').find('#txtsgst').val("0");
                                    $(this).closest('tr').find('#txtcgst').val("0");
                                    $(this).closest('tr').find('#txtigst').val(filldescrption[i].igst);
                                    $(this).closest('tr').find('#spn_sgst').text("0");
                                    $(this).closest('tr').find('#spn_cgst').text("0");
                                    $(this).closest('tr').find('#spn_igst').text(filldescrption[i].igst);
                                }
                                else {
                                    $(this).closest('tr').find('#txtsgst').val(filldescrption[i].sgst);
                                    $(this).closest('tr').find('#txtcgst').val(filldescrption[i].cgst);
                                    $(this).closest('tr').find('#txtigst').val("0");
                                    $(this).closest('tr').find('#spn_sgst').text(filldescrption[i].sgst);
                                    $(this).closest('tr').find('#spn_cgst').text(filldescrption[i].cgst);
                                    $(this).closest('tr').find('#spn_igst').text("0");
                                }
                                emptytable3.push(sku);
                            }
                            else {
                                alert("Product without IGST or CGST or SGST cannot be added");
                                $(this).closest('tr').find('#txtDescription').val("");
                                $(this).closest('tr').find('#txtCode_gst').val("");
                                return false;
                            }
                        }
                        else {
                            $(this).closest('tr').find('#txtDescription').val(filldescrption[i].productname);
                            $(this).closest('tr').find('#txtCost').val(filldescrption[i].price);
                            $(this).closest('tr').find('#txtUom').val(filldescrption[i].uim);
                            $(this).closest('tr').find('#spn_uim').text(filldescrption[i].uim);
                            $(this).closest('tr').find('#hdnproductsno').val(filldescrption[i].productid);
                            var item_state = filldescrption[i].state;
                            if (sup_state != item_state) {
                                $(this).closest('tr').find('#txtsgst').val("0");
                                $(this).closest('tr').find('#txtcgst').val("0");
                                $(this).closest('tr').find('#txtigst').val(filldescrption[i].igst);
                                $(this).closest('tr').find('#spn_sgst').text("0");
                                $(this).closest('tr').find('#spn_cgst').text("0");
                                $(this).closest('tr').find('#spn_igst').text(filldescrption[i].igst);
                            }
                            else {
                                $(this).closest('tr').find('#txtsgst').val(filldescrption[i].sgst);
                                $(this).closest('tr').find('#txtcgst').val(filldescrption[i].cgst);
                                $(this).closest('tr').find('#txtigst').val("0");
                                $(this).closest('tr').find('#spn_sgst').text(filldescrption[i].sgst);
                                $(this).closest('tr').find('#spn_cgst').text(filldescrption[i].cgst);
                                $(this).closest('tr').find('#spn_igst').text("0");
                            }
                            emptytable3.push(sku);
                        }
                    }
                }
                if (exists == 0) {
                    for (var k = 0; k < filldescription2.length; k++) {
                        if (sku == filldescription2[k].sku) {
                            if (filldescription2[k].hsn_code != "") {
                                if (filldescription2[k].igst != "") {
                                    $(this).closest('tr').find('#txtDescription').val(filldescription2[k].productname);
                                    $(this).closest('tr').find('#txtCost').val("0");
                                    $(this).closest('tr').find('#txtUom').val(filldescription2[k].uim);
                                    $(this).closest('tr').find('#spn_uim').text(filldescription2[k].uim);
                                    $(this).closest('tr').find('#hdnproductsno').val(filldescription2[k].productid);
                                    var item_state = filldescription2[k].state;
                                    if (sup_state != item_state) {
                                        $(this).closest('tr').find('#txtsgst').val("0");
                                        $(this).closest('tr').find('#txtcgst').val("0");
                                        $(this).closest('tr').find('#txtigst').val(filldescription2[k].igst);
                                        $(this).closest('tr').find('#spn_sgst').text("0");
                                        $(this).closest('tr').find('#spn_cgst').text("0");
                                        $(this).closest('tr').find('#spn_igst').text(filldescription2[k].igst);
                                    }
                                    else {
                                        $(this).closest('tr').find('#txtsgst').val(filldescription2[k].sgst);
                                        $(this).closest('tr').find('#txtcgst').val(filldescription2[k].cgst);
                                        $(this).closest('tr').find('#txtigst').val("0");
                                        $(this).closest('tr').find('#spn_sgst').text(filldescription2[k].sgst);
                                        $(this).closest('tr').find('#spn_cgst').text(filldescription2[k].cgst);
                                        $(this).closest('tr').find('#spn_igst').text("0");
                                    }
                                    emptytable3.push(sku);
                                }
                                else {
                                    alert("Product without IGST or CGST or SGST cannot be added");
                                    $(this).closest('tr').find('#txtDescription').val("");
                                    $(this).closest('tr').find('#txtCode_gst').val("");
                                    return false;
                                }
                            }
                            else {
                                $(this).closest('tr').find('#txtDescription').val(filldescription2[k].productname);
                                $(this).closest('tr').find('#txtCost').val("0");
                                $(this).closest('tr').find('#txtUom').val(filldescription2[k].uim);
                                $(this).closest('tr').find('#spn_uim').text(filldescription2[k].uim);
                                $(this).closest('tr').find('#hdnproductsno').val(filldescription2[k].productid);
                                var item_state = filldescription2[k].state;
                                if (sup_state != item_state) {
                                    $(this).closest('tr').find('#txtsgst').val("0");
                                    $(this).closest('tr').find('#txtcgst').val("0");
                                    $(this).closest('tr').find('#txtigst').val(filldescription2[k].igst);
                                    $(this).closest('tr').find('#spn_sgst').text("0");
                                    $(this).closest('tr').find('#spn_cgst').text("0");
                                    $(this).closest('tr').find('#spn_igst').text(filldescription2[k].igst);
                                }
                                else {
                                    $(this).closest('tr').find('#txtsgst').val(filldescription2[k].sgst);
                                    $(this).closest('tr').find('#txtcgst').val(filldescription2[k].cgst);
                                    $(this).closest('tr').find('#txtigst').val("0");
                                    $(this).closest('tr').find('#spn_sgst').text(filldescription2[k].sgst);
                                    $(this).closest('tr').find('#spn_cgst').text(filldescription2[k].cgst);
                                    $(this).closest('tr').find('#spn_igst').text("0");
                                }
                                //$(this).closest('tr').find('#txthsn').val(filldescrption[i].hsn_code);
                                //$(this).closest('tr').find('#spn_hsn').text(filldescrption[i].hsn_code);
                                emptytable3.push(sku);
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
                alert("Product Code already added");
                var empt = "";
                $(this).val(empt);
                $(this).focus();
                return false;
            }
        }
        function filldata4(msg) {
            var compiledList = [];
            for (var i = 0; i < msg.length; i++) {
                var productname = msg[i].productname;
                compiledList.push(productname);
            }

            $('.clsdesc_gst').autocomplete({
                source: compiledList,
                change: test4,
                autoFocus: true
            });
        }
        var emptytable4 = [];
        function test4() {
            var sup_state = document.getElementById('txt_sup_state').value;
            var rev_charge_status = document.getElementById('txt_rev_chrg').value;
            var productname = $(this).val();
            var checkflag = true;
            var exists = 0;
            if (emptytable4.indexOf(productname) == -1) {
                for (var i = 0; i < filldescrption1.length; i++) {
                    if (productname == filldescrption1[i].productname) {
                        exists = 1;
                        if (filldescrption1[i].hsn_code != "") {
                            if (filldescrption1[i].igst != "") {
                                $(this).closest('tr').find('#txtCode_gst').val(filldescrption1[i].sku);
                                $(this).closest('tr').find('#hdnproductsno').val(filldescrption1[i].productid);
                                $(this).closest('tr').find('#txtUom').val(filldescrption1[i].uim);
                                $(this).closest('tr').find('#spn_uim').text(filldescrption1[i].uim);
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
                                $(this).closest('tr').find('#txtCode_gst').val("");
                                return false;
                            }
                        }
                        else {
                            $(this).closest('tr').find('#txtCode_gst').val(filldescrption1[i].sku);
                            $(this).closest('tr').find('#hdnproductsno').val(filldescrption1[i].productid);
                            $(this).closest('tr').find('#txtUom').val(filldescrption1[i].uim);
                            $(this).closest('tr').find('#spn_uim').text(filldescrption1[i].uim);
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
                            //                            alert("Product cannot be added without HSN CODE");
                            //                            $(this).closest('tr').find('#txtDescription').val("");
                            //                            $(this).closest('tr').find('#txtCode_gst').val("");
                            //                            return false;
                        }
                    }
                }
                if (exists == 0) {
                    for (var k = 0; k < filldescription3.length; k++) {
                        if (productname == filldescription3[k].productname) {
                            if (filldescription3[k].hsn_code != "") {
                                if (filldescription3[k].igst != "") {
                                    $(this).closest('tr').find('#txtCode_gst').val(filldescription3[k].sku);
                                    $(this).closest('tr').find('#hdnproductsno').val(filldescription3[k].productid);
                                    $(this).closest('tr').find('#txtUom').val(filldescription3[k].uim);
                                    $(this).closest('tr').find('#spn_uim').text(filldescription3[k].uim);
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
                                    $(this).closest('tr').find('#txtCode_gst').val("");
                                    return false;
                                }
                            }
                            else {
                                $(this).closest('tr').find('#txtCode_gst').val(filldescription3[k].sku);
                                $(this).closest('tr').find('#hdnproductsno').val(filldescription3[k].productid);
                                $(this).closest('tr').find('#txtUom').val(filldescription3[k].uim);
                                $(this).closest('tr').find('#spn_uim').text(filldescription3[k].uim);
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
        function forclearall() {
            document.getElementById('txtName').value = "";
            document.getElementById('txtshortName').value = "";
            document.getElementById('txtDelivaryDate').value = "";
            document.getElementById('txtPoamount').innerHTML = "";
            document.getElementById('spn_totalpoamt').innerHTML = "";
            document.getElementById('spn_roundoff').innerHTML = "";
            document.getElementById('txtFrAmt').value = "";
            document.getElementById('txt_transport').value = "";
            document.getElementById('txtQutn').value = "";
            document.getElementById('txtQtnDate').value = "";
            document.getElementById('txtRemarks').value = "";
            document.getElementById('txtsupid').value = "";
            document.getElementById('ddlpayment').selectedIndex = 0;
            document.getElementById('ddlprice').selectedIndex = 0;
            document.getElementById('ddlterms').selectedIndex = 0;
            document.getElementById('ddlpf').selectedIndex = 0;
            document.getElementById('txt_rev_chrg').value = "";
            document.getElementById('btn_RaisePO').innerHTML = "Raise";
            var empty = [];
            var results = '<div  style="overflow:auto;"><table id="tabledetails" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Per Unit Rs</th><th scope="col">Quantity</th><th scope="col">Total Cost</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < empty.length; i++) {
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
            scrollTo(0, 0);
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

        function transtaxcal() {
            var transport1 = parseFloat(document.getElementById('txt_transport').value);
            var trans_tax = (transport1 * 18) / 100;
            var transport = transport1 + trans_tax;
            document.getElementById('spn_trans_tax').innerHTML = "Transport Charges with 18% :" + transport;
        }

    </script>
</asp:Content>
<asp:content id="Content2" contentplaceholderid="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Purchase Order <small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operations</a></li>
            <li><a href="#">Purchase Order</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Purchase Order Details
                </h3>
            </div>
            <div class="box-body">
                <div id="showlogs" align="center">
                    <%--<input id="btn_addDept" type="button" name="submit" value='Add PO' class="btn btn-primary" />--%>
                    <div class="input-group" style="padding-left:90%">
                        <div class="input-group-addon">
                            <span class="glyphicon glyphicon-plus-sign"></span> <span id="btn_addDept">Add PO</span>
                        </div>
                    </div>
                </div>
                <div id="div_POData" style="padding-top:2px;">
                </div>
                <div id='PurchaseOrder_FillForm' style="display: none;">
                    <table align="center" style="width:74%;">
                        <tr>
                            <td>
                                <label>
                                    Company Name</label><span style="color: red;">*</span>
                                <input id="txtshortName" type="text" class="form-control" name="ShortName" placeholder="Enter Company Name" />
                            </td>
                            <td style="width:2%;"></td>
                            <td style="height: 40px;"><%--width:14%;--%>
                                <label>
                                    Name</label><span style="color: red;">*</span>
                                <input id="txtName" type="text" class="form-control" placeholder="Enter Supplier Name"
                                    onkeypress="return ValidateAlpha(event);" />
                                <input id="txt_sup_state" type="text" style="display:none;" />
                                <input id="txt_sup_gstin" type="text" style="display:none;" />
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>
                                    Delivery Date</label><span style="color: red;">*</span>
                                <div class="input-group date">
                                  <div class="input-group-addon cal">
                                    <i class="fa fa-calendar"></i>
                                  </div>
                                 <input type="date" class="form-control" id="txtDelivaryDate" name="Date" />
                                </div>
                            </td>
                            <td style="width:2%;"></td>
                            <td style="height: 40px;">
                                <label>
                                    P and F</label>
                                <select id="ddlpf" class="form-control" onchange="calTotal_gst();">
                                    <option selected disabled value="select pf" >select pf</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>
                                    Freight Amount</label>
                                <input id="txtFrAmt" type="text" class="form-control" name="FreAmount" onkeypress="return isFloat(event)" placeholder="Enter  Freight Amount" onchange="calTotal_gst();" />
                            </td>
                            <td style="width:2%;"></td>
                            <td style="height: 40px;">
                                <label>
                                    Quotation</label>
                                <input id="txtQutn" type="text" class="form-control" name="quotation" placeholder="Enter Quotation" />
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>
                                    Quotation Date</label>
                                <div class="input-group date">
                                  <div class="input-group-addon cal">
                                    <i class="fa fa-calendar"></i>
                                  </div>
                                 <input id="txtQtnDate" type="date" class="form-control" name="QuotationDate" placeholder="Enter  QuotationDate" />
                                </div>
                            </td>
                            <td style="width:2%;">
                            </td>
                            <td style="height: 40px;">
                                <label>
                                    Delivary Terms</label>
                                <select id="ddlterms" class="form-control">
                                    <option selected disabled value="select terms">select terms</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>
                                    Payment Type</label>
                                <select id="ddlpayment" class="form-control">
                                    <option selected disabled value="select payment">select payment</option>
                                </select>
                            </td>
                            <td style="width:2%;"></td>
                            <td style="height: 40px;">
                                <label>
                                    Price Basis</label>
                                <select id="ddlprice" class="form-control">
                                    <option value="Ex-factary">Ex-factary</option>
                                    <option value="Ex-OurLocation">Ex-OurLocation</option>
                                    <option value="Actuals">Actuals</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>
                                   Delivary Address</label>
                                <select id="ddlAddress" class="form-control">
                                    <option selected disabled value="select DelivaryAddress" >select DelivaryAddress</option>
                                </select>
                            </td>
                            <td style="width:2%;"></td>
                            <td style="height: 40px;">
                                <label>
                                   Billing Address</label>
                                <select id="ddlAddress1" class="form-control">
                                    <option selected disabled value="select BillingAddress" >select BillingAddress</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                   Transport Charges</label>
                                <input id="txt_transport" type="text" class="form-control" name="transport_charges" onkeypress="return isFloat(event)" placeholder="Enter Transport Charges" onchange="calTotal_gst();" /><%--transtaxcal();--%>
                            </td>
                            <td style="width:2%;"></td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <input id="txtsupid" type="hidden" class="form-control" name="hiddensupplyid" hidden />
                            </td>
                        </tr>
                         <tr>
                            <td style="height: 40px;">
                                <input id="lblsno" type="hidden" class="form-control" hidden />
                            </td>
                            <td>
                                <input id="txt_rev_chrg" type="text" style="display:none;" />
                                <input id="txt_podate" type="date" style="display:none;" />
                            </td>
                        </tr>
                    </table>
                    <div class="box box-info">
                        <div class="box-header with-border">
                            <h3 class="box-title">
                                <i style="padding-right: 5px;" class="fa fa-list"></i>Select Product(s)
                            </h3>
                        </div>
                        <div class="box-body">
                            <div id="div_SectionData">
                            </div>
                        </div>
                    </div>
                    <table id="newrow">
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
                    <table align="center" id="po">
                        <tr>
                            <td>
                                <label>
                                    PO Amount</label>
                            </td>
                            <td>
                                <span id="spn_totalpoamt" style="width: 500px; color: Red; font-weight: bold; font-size: 25px;"></span>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>Round off Difference Amount</label>
                            </td>
                            <td>
                                <span id="spn_roundoff" style="width: 500px; color: Red; font-weight: bold; font-size: 25px;"></span>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>Total PO Amount</label>
                            </td>
                            <td>
                                <span id="txtPoamount" type="text" style="width: 500px; color: Red; font-weight: bold;
                                    font-size: 25px;" class="clspomount" name="PoAmount" onkeypress="return isFloat(event)"
                                    placeholder="Enter PO Amount"></span>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Remarks</label>
                            </td>
                            <td style="width: 420px;">
                                <textarea id="txtRemarks" rows="4" cols="10" name="Remarks" class="form-control"
                                    placeholder="Enter Remarks">
                              </textarea>
                            </td>
                        </tr>
                    </table>
                    
                    <div id="">
                    </div>
                    <table align="center">
                        <tr>
                            <td>
                                <table>
                                   <tr>
                                    <td>
                                    <div class="input-group">
                                        <div class="input-group-addon">
                                        <span class="glyphicon glyphicon-ok" id="btn_RaisePO1" onclick="save_edit_podetails_click()"></span> <span id="btn_RaisePO" onclick="save_edit_podetails_click()">Raise</span>
                                  </div>
                                  </div>
                                    </td>
                                    <td style="width:10px;"></td>
                                    <td>
                                     <div class="input-group">
                                        <div class="input-group-close">
                                        <span class="glyphicon glyphicon-remove" id='close_vehmaster1'></span> <span id='close_vehmaster'>Close</span>
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
         <div id="divMainAddNewRow" class="pickupclass" style="text-align: center; height: 100%;
             width: 100%; position: absolute; display: none; left: 0%; top: 0%; z-index: 99999;
             background: rgba(192, 192, 192, 0.7);">
             <div id="divAddNewRow" style="border: 5px solid #A0A0A0; position: absolute; top: 8%;
                 background-color: White; left: 10%; right: 10%; width: 80%; height: 100%; -webkit-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
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
                             <table align="center">
                                   <tr>
                                    <td>
                                     <div class="input-group">
                                        <div class="input-group-close">
                                        <span class="glyphicon glyphicon-remove" onclick="CloseClick();" id='Span3'></span> <span id='Span4' onclick="CloseClick();">Close</span>
                                  </div>
                                  </div>
                                    </td>
                                    </tr>
                               </table>
                         </td>
                     </tr>
                 </table>
             </div>
             <div id="divclose" style="width: 35px; top: 7.5%; right: 8%; position: absolute;
                 z-index: 99999; cursor: pointer;">
                 <img src="Images/Close.png" alt="close" style="width: 33px;height: 33px;" onclick="CloseClick();" />
             </div>
         </div>
        </div>
    </section>
</asp:content>
