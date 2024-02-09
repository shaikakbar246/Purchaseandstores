<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true"
    CodeFile="MiniMasters.aspx.cs" Inherits="MiniMasters" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        $(function () {
            get_bank_details();
            get_PandF();
            get_TAX();
            get_UIM();
            get_DelivaryTerms();
            get_PaymentDetails();
            get_Brand_details();
            get_Address_details();
            get_statemaster_details();
            showbankmaster();
            scrollTo(0, 0);
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
        function showbankmaster() {
            $("#div_Bankdetails").show();
            $("#div_pf").hide();
            $("#div_tax").hide(); 
            $("#div_UOM").hide();
            $("#div_Delveryterms").hide();
            $('#Div_Payment').hide();
            $('#div_BrandData').hide();
            $('#div_address').hide();
            $("#div_state").hide();
            scrollTo(0, 0);
        }
        function showPFMaster() {
            $("#div_pf").show();
            $("#div_tax").hide();
            $("#div_UOM").hide();
            $("#div_Delveryterms").hide();
            $("#div_Bankdetails").hide();
            $('#Div_Payment').hide();
            $('#div_BrandData').hide();
            $('#div_address').hide();
            $("#div_state").hide();
            scrollTo(0, 0);

        }
        function showTaxmaster() {
            $("#div_tax").show();
            $("#div_Bankdetails").hide();
            $("#div_pf").hide();
            $("#div_UOM").hide();
            $("#div_Delveryterms").hide();
            $('#Div_Payment').hide();
            $('#div_BrandData').hide();
            $('#div_address').hide();
            $("#div_state").hide();
            scrollTo(0, 0);
        }
        function showUommaster() {
            $("#div_UOM").show();
            $("#div_pf").hide();
            $("#div_tax").hide();
            $("#div_Delveryterms").hide(); ;
            $("#div_Bankdetails").hide();
            $('#Div_Payment').hide();
            $('#div_BrandData').hide();
            $('#div_address').hide();
            $("#div_state").hide();
            scrollTo(0, 0);
        }
        function showdeliverterms() {
            $('#div_Delveryterms').show()
            $("#div_Bankdetails").hide();
            $("#div_pf").hide();
            $("#div_tax").hide();
            $("#div_UOM").hide();
            $('#Div_Payment').hide();
            $('#div_BrandData').hide();
            $('#div_address').hide();
            $("#div_state").hide();
            scrollTo(0, 0);
        }

        function showpaymentmasters() {
            $('#Div_Payment').show()
            $("#div_Bankdetails").hide();
            $("#div_pf").hide();
            $("#div_tax").hide();
            $("#div_UOM").hide();
            $("#div_Delveryterms").hide();
            $('#div_BrandData').hide();
            $('#div_address').hide();
            $("#div_state").hide();
            scrollTo(0, 0);
        }

        function showbrandmasters() {

            $('#div_BrandData').show()
            $('#Div_Payment').hide()
            $("#div_Bankdetails").hide();
            $("#div_pf").hide();
            $("#div_tax").hide();
            $("#div_UOM").hide();
            $("#div_Delveryterms").hide();
            $('#div_address').hide();
            $("#div_state").hide();
            scrollTo(0, 0);
        }

        function showaddressmasters() {

            $('#div_address').show()
            $('#div_BrandData').hide()
            $('#Div_Payment').hide()
            $("#div_Bankdetails").hide();
            $("#div_pf").hide();
            $("#div_tax").hide();
            $("#div_UOM").hide();
            $("#div_Delveryterms").hide();
            $("#div_state").hide();
            scrollTo(0, 0);
        }

        function showstatemasters() {

            $('#div_address').hide()
            $('#div_BrandData').hide()
            $('#Div_Payment').hide()
            $("#div_Bankdetails").hide();
            $("#div_pf").hide();
            $("#div_tax").hide();
            $("#div_UOM").hide();
            $("#div_Delveryterms").hide();
            $("#div_state").show();
            scrollTo(0, 0);
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

        function saveBankDetails() {
            var name = document.getElementById('txtBName').value;
            if (name == "") {
                alert("Enter name");
                document.getElementById('txtBName').focus();
                return false;
            }
            var code = document.getElementById('txtBcode').value;
            if (code == "") {
                alert("Enter Code");
                document.getElementById('txtBcode').focus();
                return false;
            }
            var status = document.getElementById('ddlstatus').value;
            var btnval = document.getElementById('btn_save').innerHTML;
            var sno = document.getElementById('lbl_sno').value;
            var data = { 'op': 'saveBankDetails', 'Name': name, 'Code': code, 'Status': status, 'btnVal': btnval, 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        get_bank_details();
                        $('#div_BankData').show();
                        $('#Bankfillform').show();
                        bankforclearall();
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
        function bankforclearall() {
            scrollTo(0, 0);
            document.getElementById('txtBcode').value = "";
            document.getElementById('txtBName').value = "";
            document.getElementById('lbl_sno').value = "";
            document.getElementById('ddlstatus').selectedIndex = 0;
            document.getElementById('btn_save').innerHTML = "save";
            $("#lbl_code_error_msg").hide();
            $("#lbl_name_error_msg").hide();
            get_bank_details();
            $('#div_BankData').show();
            $('#Bankfillform').show();
        }

        function get_bank_details() {
            var data = { 'op': 'get_bank_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillbankdetails(msg);
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

        function fillbankdetails(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable" role="grid">';
            results += '<thead><tr role="row" class="trbgclrcls"><th scope="col">Bank Name</th><th scope="col">Code</th><th scope="col">Status</th><th scope="col" style="font-weight: bold;"></th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">';//<td><input id="btn_poplate" type="button"  onclick="bankgetme(this)" name="submit" class="btn btn-primary" value="Edit" /></td>
                results += '<th scope="row" class="1" >' + msg[i].name + '</th>';
                results += '<td data-title="code" class="2">' + msg[i].code + '</td>';
                results += '<td data-title="status" class="3">' + msg[i].status + '</td>';
                results += '<td data-title="brandstatus"><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"  onclick="bankgetme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td>';
                results += '<td style="display:none" class="4">' + msg[i].sno + '</td></tr>';

                l = l + 1;
                if (l == 4) {
                    l = 0;
                }

            }
            results += '</table></div>';
            $("#div_BankData").html(results);
        }
        function bankgetme(thisid) {
            scrollTo(0, 0);
            var name = $(thisid).parent().parent().children('.1').html();
            var Code = $(thisid).parent().parent().children('.2').html();
            var statuscode = $(thisid).parent().parent().children('.3').html();
            var sno = $(thisid).parent().parent().children('.4').html();

            if (statuscode == "Enabled") {
                status = "0";
            }
            else {
                status = "1";
            }
            document.getElementById('txtBName').value = name;
            document.getElementById('txtBcode').value = Code;
            document.getElementById('btn_save').innerHTML = "Modify";
            document.getElementById('lbl_sno').value = sno;
            document.getElementById('ddlstatus').value = status;
            $("#div_BankData").show();
            $("#Bankfillform").show();
        }


        function savePandF() {
            var pandf = document.getElementById('txtPandF').value;
            if (pandf == "") {
                alert("Enter P and f");
                document.getElementById('txtPandF').focus();
                return false;
            }
            var sno = document.getElementById('lbl_sno').value;
            var status = document.getElementById('ddlstatuspf').value;
            if (status == "") {
                alert("select status");
                document.getElementById('ddlstatuspf').focus();
                return false;
            }
            var btnval = document.getElementById('btn_savepf').innerHTML;
            var data = { 'op': 'savePandF', 'pandf': pandf, 'Status': status, 'btnVal': btnval, 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        pfforclearall();
                        get_PandF();
                        $('#div_PandF').show();
                        $('#div_pf').show();

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

        function get_PandF() {
            var data = { 'op': 'get_PandF' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillpfdetails(msg);
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
        function fillpfdetails(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable" role="grid">';
            results += '<thead><tr role="row" class="trbgclrcls"><th scope="col" style="font-weight: bold;">P&F</th><th scope="col" style="font-weight: bold;">Status</th><th scope="col" style="font-weight: bold;"></th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">';//<td><input id="btn_poplate" type="button"  onclick="pfgetme(this)" name="submit" class="btn btn-primary" value="Edit" /></td>
                results += '<th scope="row" class="1" >' + msg[i].pandf + '</th>';
                results += '<td data-title="uimstatus" class="2">' + msg[i].status + '</td>';
                results += '<td data-title="brandstatus"><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls" onclick="pfgetme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td>';
                results += '<td style="display:none" class="3">' + msg[i].sno + '</td></tr>';

                l = l + 1;
                if (l == 4) {
                    l = 0;
                }

            }
            results += '</table></div>';
            $("#div_PandF").html(results);
        }
        function pfgetme(thisid) {
            scrollTo(0, 0);
            var pandf = $(thisid).parent().parent().children('.1').html();
            var statuscode = $(thisid).parent().parent().children('.2').html();
            var sno = $(thisid).parent().parent().children('.3').html();
            if (statuscode == "Enabled") {

                status = "0";
            }
            else {
                status = "1";
            }

            document.getElementById('ddlstatuspf').value = status;
            document.getElementById('txtPandF').value = pandf;
            document.getElementById('lbl_sno').value = sno;
            document.getElementById('btn_savepf').innerHTML = "Modify";
            $("#div_PandF").show();
            $('#div_pf').show();

        }
        function pfforclearall() {
            scrollTo(0, 0);
            document.getElementById('txtPandF').value = "";
            document.getElementById('ddlstatuspf').selectedIndex = 0;
            document.getElementById('lbl_sno').value = "";
            document.getElementById('btn_savepf').innerHTML = "save";
            $("#lbl_code_error_msg").hide();
            $("#lbl_name_error_msg").hide();
            $("#div_PandF").show();
            $('#div_pf').show();
        }

        function get_radio_value() {
            var inputs = document.getElementsByName("selected");
            for (var i = 0; i < inputs.length; i++) {
                if (inputs[i].checked) {
                    return inputs[i].value;
                }
            }
        }
        function saveTAX() {
            var type = document.getElementById('txtTAX').value;
            if (type == "") {
                alert("Enter type");
                document.getElementById('txtTAX').focus();
                return false;
            }
            var sno = document.getElementById('lbl_sno').value;
            
            var taxtype = get_radio_value();
            if (taxtype == "") {
                alert("Please Select Type");
                return false;
            }

            var flag = document.getElementById('ddlflag').value;
            if (flag == "")
            {
                alert("Please Select the field Flag");
                document.getElementById('ddlflag').focus();
                return false;
            }

            var tax_per = document.getElementById('txt_tax_per').value;
            var btnval = document.getElementById('btn_savetax').innerHTML;
            var data = { 'op': 'saveTAX', 'type': type, 'taxtype': taxtype, 'flag': flag, 'btnVal': btnval, 'sno': sno };//, 'Status': status, 'tax_per': tax_per
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        taxforclearall();
                        get_TAX();
                        $('#grid_Tax').show();
                        $('#div_tax').show();
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

        function get_TAX() {
            var data = { 'op': 'get_tax_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        filltaxdetails(msg);
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
        function filltaxdetails(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable" role="grid">';
            results += '<thead><tr role="row" class="trbgclrcls"><th scope="col" style="font-weight: bold;">TAX</th><th scope="col" style="font-weight: bold;">Status</th><th scope="col" style="font-weight: bold;"></th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">';//<td><input id="btn_poplate" type="button"  onclick="taxgetme(this)" name="submit" class="btn btn-primary" value="Edit" /></td>
                results += '<td scope="row" class="1" >' + msg[i].type + '</td>';
                results += '<td class="5">' + msg[i].flag + '</td>';
                results += '<td style="display:none" class="3">' + msg[i].taxtype + '</td>';
                results += '<td data-title="brandstatus"><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"  onclick="taxgetme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td>';
                results += '<td style="display:none" class="4">' + msg[i].sno + '</td></tr>';

                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#grid_Tax").html(results);
        }
        function taxgetme(thisid) {
            scrollTo(0, 0);
            var type = $(thisid).parent().parent().children('.1').html();
            var taxtype = $(thisid).parent().parent().children('.3').html();
            var sno = $(thisid).parent().parent().children('.4').html();
            var flag = $(thisid).parent().parent().children('.5').html();

            document.getElementById('txtTAX').value = type;
            document.getElementById('rdolst').value = taxtype;
            document.getElementById('ddlflag').value = flag;
            document.getElementById('lbl_sno').value = sno;
            document.getElementById('btn_savetax').innerHTML = "Modify";
            $("#grid_Tax").show();
            $("#div_tax").show();
        }
        function taxforclearall() {
            scrollTo(0, 0);
            document.getElementById('txtTAX').value = "";
            document.getElementById('lbl_sno').value = "";
            document.getElementById('txt_tax_per').value = "";
            document.getElementById('ddlflag').selectedIndex = 0;
            document.getElementById('btn_savetax').innerHTML = "save";
            $("#lbl_code_error_msg").hide();
            $("#lbl_name_error_msg").hide();
            $("#grid_Tax").show();
            $("#div_tax").show();
        }
        function saveUIM() {
            var uim = document.getElementById('txtUIM').value;
            if (uim == "") {
                alert("Enter uim");
                document.getElementById('txtUIM').focus();
                return false;
            }
            var sno = document.getElementById('lbl_sno').value;
            var status = document.getElementById('ddlstatusuim').value;
            if (status == "") {
                alert("select status");
                document.getElementById('ddlstatusuim').focus();
                return false;
            }
            var btnval = document.getElementById('btn_saveuim').innerHTML;
            var data = { 'op': 'saveUIM', 'uim': uim, 'Status': status, 'btnVal': btnval, 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        uimforclearall();
                        get_UIM();
                        $('#grid_uom').show();
                        $('#div_UOM').show;
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

        function get_UIM() {
            var data = { 'op': 'get_UIM' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        filluomdetails(msg);
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
        function filluomdetails(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable" role="grid">';
            results += '<thead><tr role="row" class="trbgclrcls"><th scope="col" style="font-weight: bold;">UOM</th><th scope="col" style="font-weight: bold;">Status</th><th scope="col" style="font-weight: bold;"></th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">';//<td><input id="btn_poplate" type="button"  onclick="uomgetme(this)" name="submit" class="btn btn-primary" value="Edit" /></td>
                results += '<th scope="row" class="1" >' + msg[i].uim + '</th>';
                results += '<td data-title="uimstatus" class="2">' + msg[i].status + '</td>';
                results += '<td data-title="brandstatus"><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls" onclick="uomgetme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td>';
                results += '<td style="display:none" class="3">' + msg[i].sno + '</td></tr>';

                l = l + 1;
                if (l == 4) {
                    l = 0;
                }

            }
            results += '</table></div>';
            $("#grid_uom").html(results);
        }
        function uomgetme(thisid) {
            scrollTo(0, 0);
            var uim = $(thisid).parent().parent().children('.1').html();
            var statuscode = $(thisid).parent().parent().children('.2').html();
            var sno = $(thisid).parent().parent().children('.3').html();
            if (statuscode == "Enabled") {

                status = "0";
            }
            else {
                status = "1";
            }

            document.getElementById('ddlstatusuim').value = status;
            document.getElementById('txtUIM').value = uim;
            document.getElementById('lbl_sno').value = sno;
            document.getElementById('btn_saveuim').innerHTML = "Modify";
            $("#grid_uom").show();
            $("#div_UOM").show();
        }
        function uimforclearall() {
            scrollTo(0, 0);
            document.getElementById('txtUIM').value = "";
            document.getElementById('ddlstatusuim').selectedIndex = 0;
            document.getElementById('lbl_sno').value = "";
            document.getElementById('btn_saveuim').innerHTML = "save";
            $("#lbl_code_error_msg").hide();
            $("#lbl_name_error_msg").hide();
            $("#grid_uom").show();
            $("#div_UOM").show();
        }

        function saveDelivaryTerms() {
            var terms = document.getElementById('txtDelivery').value;
            if (terms == "") {
                alert("Enter Delivery Terms");
                document.getElementById('txtDelivery').focus();
                return false;
            }
            var sno = document.getElementById('lbl_sno').value;
            var btnval = document.getElementById('btn_saveterms').innerHTML;
            var data = { 'op': 'saveDelivaryTerms', 'terms': terms, 'btnVal': btnval, 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        termsforclearall();
                        get_DelivaryTerms();
                        $('#grid_deliveryterms').show();
                        $('#div_Delveryterms').show();
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

        function get_DelivaryTerms() {
            var data = { 'op': 'get_DelivaryTerms' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        filltermsdetails(msg);
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
        function filltermsdetails(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable" role="grid">';
            results += '<thead><tr role="row" class="trbgclrcls"><th scope="col" style="font-weight: bold;">Delivery Terms</th><th scope="col" style="font-weight: bold;"></th></tr></thead></tbody>';

            var k = 1;
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">';//<td><input id="btn_poplate" type="button"  onclick="termsgetme(this)" name="submit" class="btn btn-primary" value="Edit" /></td>
                results += '<td scope="row" class="1" >' + msg[i].terms + '</td>';
                results += '<td style="display:none" class="3" >' + msg[i].branchid + '</td>';
                results += '<td data-title="brandstatus"><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"  onclick="termsgetme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td>';
                results += '<td style="display:none" class="2">' + msg[i].sno + '</td></tr>';

                l = l + 1;
                if (l == 4) {
                    l = 0;
                }

            }
            results += '</table></div>';
            $("#grid_deliveryterms").html(results);
        }
        function termsgetme(thisid) {
            scrollTo(0, 0);
            var terms = $(thisid).parent().parent().children('.1').html();
            var branchid = $(thisid).parent().parent().children('.3').html();
            var sno = $(thisid).parent().parent().children('.2').html();
            document.getElementById('txtDelivery').value = terms;
            document.getElementById('lbl_sno').value = sno;
            document.getElementById('btn_saveterms').innerHTML = "Modify";
            $("#grid_deliveryterms").show();
            $("#div_Delveryterms").show();
        }
        function termsforclearall() {
            scrollTo(0, 0);
            document.getElementById('txtDelivery').value = "";
            document.getElementById('lbl_sno').value = "";
            document.getElementById('btn_saveterms').innerHTML = "save";
            $("#lbl_code_error_msg").hide();
            $("#lbl_name_error_msg").hide();
            $("#grid_deliveryterms").show();
            $("#div_Delveryterms").show();
        }

        function savePayementDetails() {
            var paymenttype = document.getElementById('txtPayment').value;
            if (paymenttype == "") {
                alert("Enter payment type");
                document.getElementById('txtPayment').focus();
                return false;
            }
            var sno = document.getElementById('lbl_sno').value;
            var status = document.getElementById('ddlstatuspayment').value;
            if (status == "") {
                alert("select status");
                document.getElementById('ddlstatuspayment').focus();
                return false;
            }
            var btnval = document.getElementById('btn_savepayment').innerHTML;
            var data = { 'op': 'savePayementDetails', 'paymenttype': paymenttype, 'Status': status, 'btnVal': btnval, 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        paymentforclearall();
                        get_PaymentDetails();
                        $('#Div_Payment').show();
                        $('#grid_payment').show();
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

        function get_PaymentDetails() {
            var data = { 'op': 'get_PaymentDetails' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        filldetails(msg);
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
        function filldetails(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid">';
            results += '<thead><tr role="row" class="trbgclrcls"><th scope="col" style="font-weight: bold;">Payment Type</th><th scope="col" style="font-weight: bold;">Status</th><th scope="col" style="font-weight: bold;"></th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">';//<td><input id="btn_poplate" type="button"  onclick="paymentgetme(this)" name="submit" class="btn btn-primary" value="Edit" /></td>
                results += '<td scope="row" class="1">' + msg[i].paymenttype + '</td>';
                results += '<td data-title="uimstatus" class="2">' + msg[i].status + '</td>';
                results += '<td data-title="brandstatus"><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"  onclick="paymentgetme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td>';
                results += '<td style="display:none" class="3">' + msg[i].sno + '</td></tr>';

                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#grid_payment").html(results);
        }
        function paymentgetme(thisid) {
            scrollTo(0, 0);
            var paymenttype = $(thisid).parent().parent().children('.1').html();
            var statuscode = $(thisid).parent().parent().children('.2').html();
            var sno = $(thisid).parent().parent().children('.3').html();

            if (statuscode == "Enabled") {

                status = "0";
            }
            else {
                status = "1";
            }

            document.getElementById('ddlstatus').value = status;
            document.getElementById('txtPayment').value = paymenttype;
            document.getElementById('lbl_sno').value = sno;
            document.getElementById('btn_savepayment').innerHTML = "Modify";
            $("#Div_Payment").show();
            $("#grid_payment").show();
        }
        function paymentforclearall() {
            scrollTo(0, 0);
            document.getElementById('txtPayment').value = "";
            document.getElementById('ddlstatus').selectedIndex = 0;
            document.getElementById('lbl_sno').value = "";
            document.getElementById('btn_savepayment').innerHTML = "save";
            $("#lbl_code_error_msg").hide();
            $("#lbl_name_error_msg").hide();
            $("#Div_Payment").show();
            $("#grid_payment").show();
        }

        function saveBrandDetails() {
            var brandname = document.getElementById('txtBrandName').value;
            if (brandname == "") {
                alert("Enter Brand Name");
                document.getElementById('txtBrandName').focus();
                return false;
            }
            var barncdid = document.getElementById('lbl_sno').value;
            var status = document.getElementById('ddlbrandstatus').value;
            var btnval = document.getElementById('btn_brandsave').innerHTML;
            var data = { 'op': 'saveBrandDetails', 'Name': brandname, 'Status': status, 'btnVal': btnval, 'barncdid': barncdid };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);

                        get_Brand_details();
                        brandforclearall();
                        $('#div_BrandData').show();
                        $('#grid_BrandData').show();
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

        function get_Brand_details() {
            var data = { 'op': 'get_Brand_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillbranddetails(msg);
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
        function fillbranddetails(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable" role="grid">';
            results += '<thead><tr role="row" class="trbgclrcls"><th scope="col" style="font-weight: bold;">Brand Name</th><th scope="col" style="font-weight: bold;">Status</th><th scope="col" style="font-weight: bold;"></th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">';//<td><input id="btn_poplate" type="button"  onclick="brandgetme(this)" name="submit" class="btn btn-primary" value="Edit" /></td>
                results += '<th scope="row" class="1">' + msg[i].brandname + '</th>';// style="text-align:center;"
                results += '<td data-title="brandstatus" class="2">' + msg[i].status + '</td>';
                results += '<td data-title="brandstatus"><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"  onclick="brandgetme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td>';
                results += '<td style="display:none" class="3">' + msg[i].brandid + '</td></tr>';

                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#grid_BrandData").html(results);
        }
        function brandgetme(thisid) {
            scrollTo(0, 0);
            var BrandName = $(thisid).parent().parent().children('.1').html();
            var statuscode = $(thisid).parent().parent().children('.2').html();
            var brandId = $(thisid).parent().parent().children('.3').html();

            if (statuscode == "Enabled") {

                status = "0";
            }
            else {
                status = "1";
            }


            document.getElementById('ddlbrandstatus').value = status;
            document.getElementById('txtBrandName').value = BrandName;
            document.getElementById('lbl_sno').value = brandId;
            document.getElementById('btn_brandsave').innerHTML = "Modify";
            $("#div_BrandData").show();
            $('#grid_BrandData').show();
        }
        function brandforclearall() {
            scrollTo(0, 0);
            document.getElementById('txtBrandName').value = "";
            document.getElementById('ddlbrandstatus').selectedIndex = 0;
            document.getElementById('lbl_sno').value = "";
            document.getElementById('btn_brandsave').innerHTML = "save";
            $("#lbl_code_error_msg").hide();
            $("#lbl_name_error_msg").hide();
            $("#div_BrandData").show();
            $('#grid_BrandData').show();
        }


        function saveAddressDetails() {
            var Address = document.getElementById('txtAddress').value;
            if (Address == "") {
                alert("EnterAddress");
                document.getElementById('txtAddress').focus();
                return false;
            }
            var sno = document.getElementById('lbl_sno').value;
            var btnval = document.getElementById('btn_saveadress').innerHTML;
            var data = { 'op': 'saveAddressDetails', 'Address': Address, 'btnVal': btnval, 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        Addressforclearall();
                        get_Address_details();
                        $('#div_address').show();
                        $('#grid_Address').show();
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

        function get_Address_details() {
            var data = { 'op': 'get_Address_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillAddressdetails(msg);
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
        function fillAddressdetails(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid">';
            results += '<thead><tr role="row" class="trbgclrcls"><th scope="col" style="font-weight: bold;">Address</th><th scope="col" style="font-weight: bold;"></th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">';//<td><input id="btn_poplate" type="button"  onclick="getaddress(this)" name="submit" class="btn btn-primary" value="Edit" /></td>
                results += '<th scope="row" class="1">' + msg[i].Address + '</th>';// style="text-align:center;"
                results += '<td data-title="brandstatus"><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"  onclick="getaddress(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td>';
                results += '<td style="display:none" class="3">' + msg[i].sno + '</td></tr>';

                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#grid_Address").html(results);
        }
        function getaddress(thisid) {
            scrollTo(0, 0);
            var Address = $(thisid).parent().parent().children('.1').html();
            var sno = $(thisid).parent().parent().children('.3').html();

            document.getElementById('txtAddress').value = Address;
            document.getElementById('lbl_sno').value = sno;
            document.getElementById('btn_saveadress').innerHTML = "Modify";
            $('#div_address').show();
            $('#grid_Address').show();
        }
        function Addressforclearall() {
            scrollTo(0, 0);
            document.getElementById('txtAddress').value = "";
            document.getElementById('lbl_sno').value = "";
            document.getElementById('btn_saveadress').innerHTML = "save";
            $('#div_address').show(); 
            $('#grid_Address').show(); 
        }

        function save_state() {
            var state_name = document.getElementById('txt_state').value;
            if (state_name == "") {
                alert("Enter State Name");
                document.getElementById('txt_state').focus();
                return false;
            }
            var gst_state_code = document.getElementById('txt_gst_state_code').value;
            if (gst_state_code == "")
            {
                alert("Enter GST State Code");
                document.getElementById('txt_gst_state_code').focus();
                return false;
            }
            var ecode = document.getElementById('txt_ecode').value;
            if (ecode == "")
            {
                alert("Enter E_Code");
                document.getElementById('txt_ecode').focus();
                return false;
            }
            var code = document.getElementById('txt_code').value;
            if (code == "")
            {
                alert("Enter State Code");
                document.getElementById('txt_code').focus();
                return false;
            }
            var sno = document.getElementById('lbl_state_sno').value;
            var btnval = document.getElementById('btn_save_state').innerHTML;
            var data = { 'op': 'save_State_Details', 'state_name': state_name, 'ecode': ecode, 'code': code, 'gst_state_code': gst_state_code, 'btnVal': btnval, 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        stateforclearall();
                        get_statemaster_details();
                        $('#div_state').show();
                        $('#div_state_data').show();
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

        function get_statemaster_details() {
            var data = { 'op': 'get_statemaster_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillstatedetails(msg);
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
        function fillstatedetails(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid">';
            results += '<thead><tr role="row" class="trbgclrcls"><th scope="col">State Name</th><th scope="col">GST State Code</th><th scope="col">E Code</th><th scope="col">State Code</th><th scope="col"></th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">';
                results += '<td scope="row" class="1 tdmaincls">' + msg[i].statename + '</td>';
                results += '<td class="2">' + msg[i].gststatecode + '</td>';
                results += '<td class="4">' + msg[i].ecode + '</td>';
                results += '<td class="5">' + msg[i].code + '</td>';
                results += '<td data-title="brandstatus"><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"  onclick="getstatedetails(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td>';
                results += '<td style="display:none" class="3">' + msg[i].sno + '</td></tr>';

                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_state_data").html(results);
        }
        function getstatedetails(thisid) {
            scrollTo(0, 0);
            var statename = $(thisid).parent().parent().children('.1').html();
            var gststatecode = $(thisid).parent().parent().children('.2').html();
            var sno = $(thisid).parent().parent().children('.3').html();
            var ecode = $(thisid).parent().parent().children('.4').html();
            var code = $(thisid).parent().parent().children('.5').html();

            document.getElementById('txt_state').value = statename;
            document.getElementById('txt_gst_state_code').value = gststatecode;
            document.getElementById('txt_ecode').value = ecode;
            document.getElementById('txt_code').value = code;
            document.getElementById('lbl_state_sno').value = sno;
            document.getElementById('btn_save_state').innerHTML = "Modify";
            $('#div_state').show();
            $('#div_state_data').show();
        }
        function stateforclearall() {
            scrollTo(0, 0);
            document.getElementById('txt_state').value = "";
            document.getElementById('txt_gst_state_code').value = "";
            document.getElementById('txt_ecode').value = "";
            document.getElementById('txt_code').value = "";
            document.getElementById('lbl_state_sno').value = "";
            document.getElementById('btn_save_state').innerHTML = "save";
            $('#div_state').show();
            $('#div_state_data').show();
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content">
        <!-- Small boxes (Stat box) -->
        <div class="row">
            <section class="content-header">
                <h1>
                    Mini Masters
                </h1>
                <ol class="breadcrumb">
                    <li><a href="#"><i class="fa fa-dashboard"></i>Operation</a></li>
                    <li><a href="#">Masters</a></li>
                </ol>
            </section>
            <section class="content">
                <div class="box box-info">
                    <div class="box-header with-border">
                    </div>
                    <div class="box-body">
                        <div>
                            <ul class="nav nav-tabs">
                                <li id="id_tab_Personal" class="active"><a data-toggle="tab" href="#" onclick="showbankmaster()">
                                    <i class="fa fa-university" aria-hidden="true"></i>&nbsp;&nbsp;Bank Master</a></li>
                                <li id="id_tab_documents" class=""><a data-toggle="tab" href="#" onclick="showPFMaster()">
                                    <i class="fa fa-truck" aria-hidden="true"></i>&nbsp;&nbsp;P&F Master</a></li>
                                <li id="Li1" class=""><a data-toggle="tab" href="#" onclick="showTaxmaster()"><i
                                    class="fa fa-file-text"></i>&nbsp;&nbsp;Tax Master</a></li>
                                <li id="Li2" class=""><a data-toggle="tab" href="#" onclick="showUommaster()"><i
                                    class="fa fa-file-text"></i>&nbsp;&nbsp;UOM Master</a></li>
                                <li id="Li3" class=""><a data-toggle="tab" href="#" onclick="showdeliverterms()"><i
                                    class="fa fa-file-text"></i>&nbsp;&nbsp;DeliveryTerms</a></li>
                                <li id="Li4" class=""><a data-toggle="tab" href="#" onclick="showpaymentmasters()"><i
                                    class="icon-money"></i>&nbsp;&nbsp;Payment Master</a></li>
                                <li id="Li5" class=""><a data-toggle="tab" href="#" onclick="showbrandmasters()"><i
                                    class="fa fa-file-text"></i>&nbsp;&nbsp;Brand Master</a></li>
                                <li id="Li6" class=""><a data-toggle="tab" href="#" onclick="showaddressmasters()"><i
                                    class="fa fa-file-text"></i>&nbsp;&nbsp;Address Master</a></li>
                                <li id="Li7" class=""><a data-toggle="tab" href="#" onclick="showstatemasters()"><i
                                    class="fa fa-file-text"></i>&nbsp;&nbsp;State Master</a></li>
                            </ul>
                        </div>
                        <div id="div_Bankdetails" style="display: none;">
                            <div class="box-header with-border">
                                <h3 class="box-title">
                                    <i style="padding-right: 5px;" class="fa fa-cog"></i>BankMaster
                                </h3>
                            </div>
                            <div class="box-body">
                                <div id="babkfillform">
                                    <table align="center" style="width: 60%;">
                                        <tr>
                                            <th>
                                            </th>
                                        </tr>
                                        <tr>
                                            <td style="height: 40px;">
                                                <label>Bank Name</label><span style="color: red;">*</span>
                                            </td>
                                            <td>
                                                <input id="txtBName" type="text" maxlength="45" class="form-control" name="vendorcode"
                                                    placeholder="Enter Bank Name" /><label id="lbl_code_error_msg" class="errormessage">* Please
                                                        Enter Name</label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <label>Code</label>
                                            </td>
                                            <td>
                                                <input id="txtBcode" type="text" maxlength="45" class="form-control" name="vendorcode"
                                                    placeholder="Enter Code" /><label id="lbl_code_error_msg" class="errormessage">* Please
                                                        Enter code</label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="height: 40px;">
                                                <label>Status</label><span style="color: red;"></span>
                                            </td>
                                            <td>
                                                <select id="ddlstatus" class="form-control">
                                                    <option value="1">Active</option>
                                                    <option value="0">InActive</option>
                                                </select>
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
                                                        <span class="glyphicon glyphicon-ok" id="btn_save1" onclick="saveBankDetails()"></span> <span id="btn_save" onclick="saveBankDetails()">save</span>
                                                  </div>
                                                  </div>
                                                    </td>
                                                    <td style="width:10px;"></td>
                                                    <td>
                                                     <div class="input-group">
                                                        <div class="input-group-close">
                                                        <span class="glyphicon glyphicon-remove" id='btn_close1' onclick="bankforclearall()"></span> <span id='btn_close' onclick="bankforclearall()">Close</span>
                                                  </div>
                                                  </div>
                                                    </td>
                                                    </tr>
                                               </table>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div id="div_BankData">
                                </div>
                            </div>
                        </div>
                        <div id="div_pf" style="display: none;">
                            <div class="box-header with-border">
                                <h3 class="box-title">
                                    <i style="padding-right: 5px;" class="fa fa-cog"></i>P&F Master
                                </h3>
                            </div>
                            <div class="box-body">
                                <div id="pffillform">
                                    <table align="center" style="width: 60%;">
                                        <tr>
                                            <th>
                                            </th>
                                        </tr>
                                        <tr>
                                            <td style="height: 40px;">
                                                <label>P and F</label><span style="color: red;">*</span>
                                            </td>
                                            <td>
                                                <input id="txtPandF" type="text" maxlength="45" class="form-control" name="vendorcode" onkeypress="return isFloat(event)"
                                                    placeholder="Enter P and F" /><label id="Label1" class="errormessage">* Please Enter
                                                        P and F</label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="height: 40px;">
                                                <label>Status</label><span style="color: red;">*</span>
                                            </td>
                                            <td>
                                                <select id="ddlstatuspf" class="form-control">
                                                    <option value="1">Active</option>
                                                    <option value="0">InActive</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr style="display: none;">
                                            <td>
                                                <label id="Label2">
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
                                                        <span class="glyphicon glyphicon-ok" id="btn_savepf1" onclick="savePandF()"></span> <span id="btn_savepf" onclick="savePandF()">save</span>
                                                  </div>
                                                  </div>
                                                    </td>
                                                    <td style="width:10px;"></td>
                                                    <td>
                                                     <div class="input-group">
                                                        <div class="input-group-close">
                                                        <span class="glyphicon glyphicon-remove" id='btn_closepf1' onclick="pfforclearall()"></span> <span id='btn_closepf' onclick="pfforclearall()">Close</span>
                                                  </div>
                                                  </div>
                                                    </td>
                                                    </tr>
                                               </table>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div id="div_PandF">
                                </div>
                            </div>
                        </div>
                        <div id="div_tax" style="display: none;">
                            <div class="box-header with-border">
                                <h3 class="box-title">
                                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Tax Master
                                </h3>
                            </div>
                            <div class="box-body">
                                <div id="taxfillform">
                                    <table id="rdolst" align="center">
                                        <tr>
                                            <td>
                                                <input id="rdolst_0" type="radio" name="selected" value="Tax" checked="checked" /><label
                                                    for="rdolst_0">Tax
                                                </label>
                                            </td>
                                            <td>
                                                <input id="rdolst_1" type="radio" name="selected" value="ExchangeDuty" /><label for="rdolst_1">ExchangeDuty</label>
                                            </td>
                                        </tr>
                                    </table>
                                    <table align="center" style="width: 60%;">
                                        <tr>
                                            <th>
                                            </th>
                                        </tr>
                                        <tr>
                                        </tr>
                                        <tr>
                                            <td style="height: 40px;">
                                                <label>TAX</label><span style="color: red;">*</span>
                                            </td>
                                            <td>
                                                <input id="txtTAX" type="text" maxlength="45" class="form-control" name="vendorcode"
                                                    placeholder="Enter TAX" /><label id="Label3" class="errormessage">* Please Enter TaX</label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="height: 40px;">
                                                <label>Flag</label><span style="color: red;">*</span>
                                            </td>
                                            <td>
                                                <select id="ddlflag" class="form-control">
                                                    <option value="True">TRUE</option>
                                                    <option value="False">FALSE</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="height:40px">
                                                <label>TAX %</label><span style="color: red;">*</span>
                                            </td>
                                            <td>
                                                <input type="text" id="txt_tax_per" class="form-control" name="tax_per" placeholder="Enter Tax Percentage" />
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
                                                        <span class="glyphicon glyphicon-ok" id="btn_savetax1" onclick="saveTAX()"></span> <span id="btn_savetax" onclick="saveTAX()">save</span>
                                                  </div>
                                                  </div>
                                                    </td>
                                                    <td style="width:10px;"></td>
                                                    <td>
                                                     <div class="input-group">
                                                        <div class="input-group-close">
                                                        <span class="glyphicon glyphicon-remove" id='btn_closetax1' onclick="taxforclearall()"></span> <span id='btn_closetax' onclick="taxforclearall()">Close</span>
                                                  </div>
                                                  </div>
                                                    </td>
                                                    </tr>
                                               </table>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div id="grid_Tax">
                                </div>
                            </div>
                        </div>
                        <div id="div_UOM" style="display: none;">
                            <div class="box-header with-border">
                                <h3 class="box-title">
                                    <i style="padding-right: 5px;" class="fa fa-cog"></i>UOM master
                                </h3>
                            </div>
                            <div class="box-body">
                                <div id="uomfillform">
                                    <table align="center" style="width: 60%;">
                                        <tr>
                                            <th>
                                            </th>
                                        </tr>
                                        <tr>
                                            <td style="height: 40px;">
                                                <label>UOM</label><span style="color: red;">*</span>
                                            </td>
                                            <td>
                                                <input id="txtUIM" type="text" maxlength="45" class="form-control" name="vendorcode"
                                                    placeholder="Enter UOM" /><label id="Label4" class="errormessage">* Please Enter UOM</label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="height: 40px;">
                                                <label>Status</label><span style="color: red;"></span>
                                            </td>
                                            <td>
                                                <select id="ddlstatusuim" class="form-control">
                                                    <option value="1">Active</option>
                                                    <option value="0">InActive</option>
                                                </select>
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
                                                        <span class="glyphicon glyphicon-ok" id="btn_saveuim1" onclick="saveUIM()"></span> <span id="btn_saveuim" onclick="saveUIM()">save</span>
                                                  </div>
                                                  </div>
                                                    </td>
                                                    <td style="width:10px;"></td>
                                                    <td>
                                                     <div class="input-group">
                                                        <div class="input-group-close">
                                                        <span class="glyphicon glyphicon-remove" id='btn_closeuim1' onclick="uimforclearall()"></span> <span id='btn_closeuim' onclick="uimforclearall()">Close</span>
                                                  </div>
                                                  </div>
                                                    </td>
                                                    </tr>
                                               </table>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div id="grid_uom">
                                </div>
                            </div>
                        </div>
                        <div id="div_Delveryterms" style="display: none;">
                            <div class="box-header with-border">
                                <h3 class="box-title">
                                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Delivery Terms
                                </h3>
                            </div>
                            <div class="box-body">
                                <div id="deliverytremsfill">
                                    <table align="center" style="width: 60%;">
                                        <tr>
                                            <th>
                                            </th>
                                        </tr>
                                        <tr>
                                            <td style="height: 40px;">
                                                <label>Delivery Terms</label><span style="color: red;">*</span>
                                            </td>
                                            <td>
                                                <input id="txtDelivery" type="text" maxlength="45" class="form-control" name="vendorcode"
                                                    placeholder="Enter Delivery Terms" /><label id="Label5" class="errormessage">* Please
                                                        Enter Delivary Terms</label>
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
                                                        <span class="glyphicon glyphicon-ok" id="btn_saveterms1" onclick="saveDelivaryTerms()"></span> <span id="btn_saveterms" onclick="saveDelivaryTerms()">save</span>
                                                  </div>
                                                  </div>
                                                    </td>
                                                    <td style="width:10px;"></td>
                                                    <td>
                                                     <div class="input-group">
                                                        <div class="input-group-close">
                                                        <span class="glyphicon glyphicon-remove" id='btn_closeterms1' onclick="termsforclearall()"></span> <span id='btn_closeterms' onclick="termsforclearall()">Close</span>
                                                  </div>
                                                  </div>
                                                    </td>
                                                    </tr>
                                               </table>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div id="grid_deliveryterms">
                                </div>
                            </div>
                        </div>
                        <div id="Div_Payment" style="display: none;">
                            <div class="box-header with-border">
                                <h3 class="box-title">
                                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Payment Details
                                </h3>
                            </div>
                            <div class="box-body">
                                <div id='paymentfillform'>
                                    <table align="center" style="width: 60%;">
                                        <tr>
                                            <th>
                                            </th>
                                        </tr>
                                        <tr>
                                            <td style="height: 40px;">
                                                <label>Enter Payment Type</label><span style="color: red;">*</span>
                                            </td>
                                            <td>
                                                <input id="txtPayment" type="text" maxlength="45" class="form-control" name="vendorcode"
                                                    placeholder="Enter Payment Type" /><label id="Label6" class="errormessage">* Please Enter
                                                        PaymentType</label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="height: 40px;">
                                                <label>Status</label><span style="color: red;">*</span>
                                            </td>
                                            <td>
                                                <select id="ddlstatuspayment" class="form-control">
                                                    <option value="1">Active</option>
                                                    <option value="0">InActive</option>
                                                </select>
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
                                                        <span class="glyphicon glyphicon-ok" id="btn_savepayment1" onclick="savePayementDetails()"></span> <span id="btn_savepayment" onclick="savePayementDetails()">save</span>
                                                  </div>
                                                  </div>
                                                    </td>
                                                    <td style="width:10px;"></td>
                                                    <td>
                                                     <div class="input-group">
                                                        <div class="input-group-close">
                                                        <span class="glyphicon glyphicon-remove" id='btn_closepayment1' onclick="paymentforclearall()"></span> <span id='btn_closepayment' onclick="paymentforclearall()">Close</span>
                                                  </div>
                                                  </div>
                                                    </td>
                                                    </tr>
                                               </table>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div id="grid_payment">
                                </div>
                            </div>
                        </div>
                        <div id="div_BrandData" style="display: none;">
                            <div class="box-header with-border">
                                <h3 class="box-title">
                                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Brand Details
                                </h3>
                            </div>
                            <div class="box-body">
                                <div id='brandfillform'>
                                    <table align="center" style="width: 60%;">
                                        <tr>
                                            <th>
                                            </th>
                                        </tr>
                                        <tr>
                                            <td style="height: 40px;">
                                                <label>Brand Name</label><span style="color: red;">*</span>
                                            </td>
                                            <td>
                                                <input id="txtBrandName" type="text" maxlength="45" class="form-control" name="vendorcode"
                                                    placeholder="Enter Brand Name" /><label id="Label7" class="errormessage">* Please Enter
                                                        BrandName</label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="height: 40px;">
                                                <label>Status</label><span style="color: red;">*</span>
                                            </td>
                                            <td>
                                                <select id="ddlbrandstatus" class="form-control">
                                                    <option value="1">Active</option>
                                                    <option value="0">InActive</option>
                                                </select>
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
                                                        <span class="glyphicon glyphicon-ok" id="btn_brandsave1" onclick="saveBrandDetails()"></span> <span id="btn_brandsave" onclick="saveBrandDetails()">save</span>
                                                  </div>
                                                  </div>
                                                    </td>
                                                    <td style="width:10px;"></td>
                                                    <td>
                                                     <div class="input-group">
                                                        <div class="input-group-close">
                                                        <span class="glyphicon glyphicon-remove" id='Span23' onclick="brandforclearall()"></span> <span id='Span24' onclick="brandforclearall()">Close</span>
                                                  </div>
                                                  </div>
                                                    </td>
                                                    </tr>
                                               </table>
                                            </td>
                                        </tr>
                                    </table>
                                    <div id="grid_BrandData">
                                    </div>
                                </div>
                            </div>
                        </div>
                          <div id="div_address" style="display: none;">
                            <div class="box-header with-border">
                                <h3 class="box-title">
                                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Address Details
                                </h3>
                            </div>
                            <div class="box-body">
                                <div id='Div2'>
                                    <table align="center" style="width: 60%;">
                                        <tr>
                                            <th>
                                            </th>
                                        </tr>
                                            
                                        <tr>
                                            <td style="height: 40px;">
                                                <label>Address</label><span style="color: red;">*</span>
                                            </td>
                                            <td>
                                                <textarea id="txtAddress" rows="3" cols="45" type="text"  class="form-control" name="vendorcode"
                                                    placeholder="Enter Address" ></textarea>
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
                                                        <span class="glyphicon glyphicon-ok" id="btn_saveadress1" onclick="saveAddressDetails()"></span> <span id="btn_saveadress" onclick="saveAddressDetails()">save</span>
                                                  </div>
                                                  </div>
                                                    </td>
                                                    <td style="width:10px;"></td>
                                                    <td>
                                                     <div class="input-group">
                                                        <div class="input-group-close">
                                                        <span class="glyphicon glyphicon-remove" id='Span27' onclick="Addressforclearall()"></span> <span id='Span28' onclick="Addressforclearall()">Close</span>
                                                  </div>
                                                  </div>
                                                    </td>
                                                    </tr>
                                               </table>
                                            </td>
                                        </tr>
                                    </table>
                                    <div id="grid_Address">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div id="div_state" style="display:none;">
                            <div class="box-header with-border">
                                <h3 class="box-title">
                                    <i style="padding-right: 5px;" class="fa fa-cog"></i>State Master
                                </h3>
                            </div>
                            <div class="box-body">
                                <div>
                                    <table align="center" style="width:60%;">
                                        <tr>
                                            <th></th>
                                        </tr>
                                        <tr>
                                            <td style="height:40px;">
                                                <label>State Name</label><span style="color: red;">*</span>
                                            </td>
                                            <td>
                                                <input id="txt_state" type="text" class="form-control" name="state" placeholder="Enter State Name" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="height:40px;">
                                                <label> GST State Code</label><span style="color: red;">*</span>
                                            </td>
                                            <td>
                                                <input id="txt_gst_state_code" type="text" class="form-control" name="gst_state_code" placeholder="Enter GST State Code" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="height: 40px;">
                                                <label>E Code</label><span style="color: red;">*</span>
                                            </td>
                                            <td>
                                                <input id="txt_ecode" type="text" class="form-control" name="ecode" placeholder="Enter E Code" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="height:40px;">
                                                <label>State Code</label><span style="color: red;">*</span>
                                            </td>
                                            <td>
                                                <input id="txt_code" type="text" class="form-control" name="code" placeholder="Enter State Code" />
                                            </td>
                                        </tr>
                                        <tr style="display:none;">
                                            <td>
                                                <label id="lbl_state_sno"></label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" align="center" style="height:40px;">
                                                <table>
                                                   <tr>
                                                    <td>
                                                    <div class="input-group">
                                                        <div class="input-group-addon">
                                                        <span class="glyphicon glyphicon-ok" id="btn_save_state1" onclick="save_state()"></span> <span id="btn_save_state" onclick="save_state()">save</span>
                                                  </div>
                                                  </div>
                                                    </td>
                                                    <td style="width:10px;"></td>
                                                    <td>
                                                     <div class="input-group">
                                                        <div class="input-group-close">
                                                        <span class="glyphicon glyphicon-remove" id='btnclosestate1' onclick="stateforclearall()"></span> <span id='btnclosestate' onclick="stateforclearall()">Close</span>
                                                  </div>
                                                  </div>
                                                    </td>
                                                    </tr>
                                               </table>
                                            </td>
                                        </tr>
                                    </table>
                                    <div id="div_state_data"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
        </div>
    </section>
</asp:Content>
