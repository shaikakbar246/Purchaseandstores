<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true"
    CodeFile="Suplier.aspx.cs" Inherits="Suplier" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script src="js1/imagezoom.js"></script>
    <script type="text/javascript">

        $(function () {
            get_suplier_details();
            get_product_details();
            get_category_data();
            get_statemaster_det();
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
            forclearall();
            $("#div_SuplierData").show();
            $("#fillform").hide();
            $("#div_sup_data").hide();
            $("#divpic").hide();
            $("#div_sup_doc").hide();
            $("#divpic").hide();
            $('#div_product_data').hide();
            $('#showlogs').show();
            products = [];
        }
        function showdesign() {
            forclearall();
            $("#div_SuplierData").hide();
            $("#div_sup_data").show();
            $("#divpic").show();
            $("#div_sup_doc").hide();
            $("#fillform").show();
            $("#divpic").show();
            $('#showlogs').hide();
            $('#div_product_data').hide();
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
        function saveSuplierDetails() {

            var name = document.getElementById('txtSuplierName').value;
            if (name == "") {
                alert("Enter Suplier Name");
                document.getElementById("txtSuplierName").focus();
                return false;
            }
            var description = document.getElementById('txtDescript').value;

            var companyname = document.getElementById('txtCompanyName').value;
            if (companyname == "") {
                alert("Enter Company Name");
                document.getElementById("txtCompanyName").focus();
                return false;
            }
            var contactname = document.getElementById('txtContactName').value;
            if (contactname == "") {
                alert("Enter Contact Number");
                document.getElementById("txtContactName").focus();
                return false;
            }
            var street1 = document.getElementById('txtStreet').value;
            if (street1 == "") {
                alert("Enter Street");
                document.getElementById("txtStreet").focus();
                return false;
            }

            var insurence = document.getElementById('txtinsurence').value;
            var insurecetype = document.getElementById('ddlinsurnce').value;
            var warranytype = document.getElementById('ddlwarrenty').value;
            var warranty = document.getElementById('txtwarrenty').value;
            var city = document.getElementById('txtCity').value;
            var state = document.getElementById('slct_state_name').value;
            var country = document.getElementById('txtCountry').value;
            if (country == "") {
                alert("Enter Country Name");
                document.getElementById('txtCountry').focus();
                return false;
            }
            var zipcode = document.getElementById('txtZipcode').value;
            //            if (country == "") {

            //                alert("Enter Country Name");
            //                return false;
            //            }


            var contactnumber = document.getElementById('txtContactNumber').value;
            var mobileno = document.getElementById('txtMobileNum').value;
            if (mobileno.length != 10)
            {
                alert("Mobile Number Should contain 10 digits");
                document.getElementById('txtMobileNum').focus();
                return false;
            }
            var emailid = document.getElementById('txtEmail').value;
            var websiteurl = document.getElementById('txtWebsite').value;
            var status = document.getElementById('ddlStatus').value;
            var vendor_cd = document.getElementById('txt_vendor_cd').value;
            //if (vendor_cd == "") {
            //    alert("Enter Vendor ID");
            //    return false;
            //}
            var gst_no = document.getElementById('txt_gst_no').value;
            if (gst_no == "") {
                alert("Enter GST No");
                document.getElementById('txt_gst_no').focus();
                return false;
            }
            var gst_type = document.getElementById('slct_gst_reg_type').value;
            if (gst_type == "") {
                alert("Select GST Type");
                document.getElementById('slct_gst_reg_type').focus();
                return false;
            }
            var pan_no = document.getElementById('txt_pan_no').value;
            var bank_acc_no = document.getElementById('txt_bank_acc').value;
            if (bank_acc_no == "")
            {
                alert("Enter Supplier Bank Account No");
                document.getElementById('txt_bank_acc').focus();
                return false;
            }
            var bank_ifsc = document.getElementById('txt_bank_ifsc').value;
            if (bank_ifsc == "") {
                alert("Enter Supplier Bank Ifsc Code");
                document.getElementById('txt_bank_ifsc').focus();
                return false;
            }
            var product_ids = [];
            $('#example_items> tbody > tr').each(function () {
                var productid = $(this).find('#lbl_productid').text();
                var item_sno = $(this).find('#lbl_item_sno').text();
                if (productid == "" || productid == "0") {
                }
                else {
                    product_ids.push({ item_sno: item_sno, productid: productid });
                }
            });

            if (product_ids.length == 0) {
                alert("Please add items");
                return false;
            }

            var btnval = document.getElementById('btn_save').innerHTML;
            var suplierid = document.getElementById('lbl_sno').value;
            var data = { 'op': 'saveSuplierDetails', 'insurecetype': insurecetype, 'insurence': insurence, 'warranytype': warranytype, 'warranty': warranty, 'suppliername': name, 'description': description, 'companyname': companyname, 'contactname': contactname, 'street1': street1, 'city': city, 'state': state, 'country': country, 'zipcode': zipcode, 'mobileno': mobileno, 'emailid': emailid, 'websiteurl': websiteurl, 'status': status, 'btnVal': btnval, 'supplierid': suplierid, 'vendorcode': vendor_cd, 'contactnumber': contactnumber, 'gst_no': gst_no, 'gst_type': gst_type, 'pan_no': pan_no, 'bank_acc_no': bank_acc_no, 'bank_ifsc': bank_ifsc, 'product_ids': product_ids };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        get_suplier_details();
                        forclearall();
                        compiledList = [];
                        $('#div_SuplierData').show();
                        $("#div_sup_data").hide();
                        $("#divpic").hide();
                        $("#div_sup_doc").hide();
                        $('#fillform').css('display', 'none');
                        $('#showlogs').css('display', 'block');
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
        function get_suplier_details() {
            var data = { 'op': 'get_suplier_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        filldetails(msg);
                        forclearall();
                        filldetails1(msg);
                        supplierdetails = msg;
                        filldetails2(msg);
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

        var compiledList = [];
        function filldetails1(msg) {
            for (var i = 0; i < msg.length; i++) {
                var suppliername = msg[i].suppliername;
                compiledList.push(suppliername);
            }

            $('#txtName').autocomplete({
                source: compiledList,
                change: test1,
                autoFocus: true
            });
        }

        function test1() {
            scrollTo(0, 0);
            var name = document.getElementById('txtName').value;
            if (name == "") {
                var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable" id="example">';
                results += '<thead><tr role="row" class="trbgclrcls"><th scope="col" style="font-weight: bold;">Supplier Name</th><th scope="col" style="font-weight: bold;">Contact Number</th><th scope="col" style="font-weight: bold;">Street1</th><th scope="col" style="font-weight: bold;">Mobile No</th><th scope="col" style="font-weight: bold;">Email Id</th><th scope="col" style="font-weight: bold;">Status</th><th scope="col" style="font-weight: bold;">Image</th><th scope="col" style="font-weight: bold;"></th></tr></thead></tbody>';

                var k = 1;
                var l = 0;
                var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
                for (var i = 0; i < supplierdetails.length; i++) {
                    results += '<tr style="background-color:' + COLOR[l] + '">'; //<td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="Edit" /></td>
                    results += '<td scope="row" class="1" style="text-align:center;"><i class="fa fa-user" aria-hidden="true"></i>&nbsp;&nbsp;<label id="1">' + supplierdetails[i].suppliername + '</label></td>';
                    results += '<td style="display:none" class="2">' + supplierdetails[i].description + '</td>';
                    results += '<td style="display:none" class="3">' + supplierdetails[i].companyname + '</td>';
                    results += '<td data-title="contactName" class="4"><i class="fa fa-mobile fa-2x" aria-hidden="true"></i>&nbsp;&nbsp;<span id="4">' + supplierdetails[i].contactname + '</span></td>';
                    
                    results += '<td data-title="street1" class="5">' + supplierdetails[i].street1 + '</td>';
                    results += '<td style="display:none" class="21">' + supplierdetails[i].contactnumber + '</td>';
                    results += '<td style="display:none" class="7">' + supplierdetails[i].city + '</td>';
                    results += '<td style="display:none" class="8">' + supplierdetails[i].state + '</td>';
                    results += '<td style="display:none" class="9">' + supplierdetails[i].country + '</td>';
                    results += '<td style="display:none" class="10">' + supplierdetails[i].zipcode + '</td>';
                    results += '<td data-title="mobileno" class="12"><i class="fa fa-mobile fa-2x" aria-hidden="true"></i>&nbsp;&nbsp;<span id="12">' + supplierdetails[i].mobileno + '</span></td>';
                    results += '<td data-title="emailid" class="13"><i class="fa fa-envelope" aria-hidden="true"></i>&nbsp;&nbsp;<span id="13">' + supplierdetails[i].emailid + '</span></td>';
                    results += '<td data-title="status" class="14">' + supplierdetails[i].status + '</td>';
                    results += '<td style="display:none" class="15">' + supplierdetails[i].websiteurl + '</td>';
                    results += '<td style="display:none" class="17">' + supplierdetails[i].insurence + '</td>';
                    results += '<td style="display:none" class="18">' + supplierdetails[i].insurecetype + '</td>';
                    results += '<td data-title="status"  style="display:none" class="19">' + supplierdetails[i].warranytype + '</td>';
                    results += '<td style="display:none" class="20">' + supplierdetails[i].warranty + '</td>';
                    results += '<td   style="display : none;" class="23">' + supplierdetails[i].imgpath + '</td>';
                    results += '<td   style="display : none;" class="24">' + supplierdetails[i].ftplocation + '</td>';
                    results += '<td style="display:none" class="22">' + supplierdetails[i].vendorcode + '</td>';
                    results += '<td style="display : none;" class="25">' + supplierdetails[i].gst_no + '</td>';
                    results += '<td style="display : none;" class="26">' + supplierdetails[i].gst_type + '</td>';
                    results += '<td style="display : none;" class="27">' + supplierdetails[i].pan_no + '</td>';
                    results += '<td style="display : none;" class="28">' + supplierdetails[i].bank_acc_no + '</td>';
                    results += '<td style="display : none;" class="29">' + supplierdetails[i].bank_ifsc + '</td>';
                    var rndmnum = Math.floor((Math.random() * 10) + 1);
                    var img_url = supplierdetails[i].ftplocation + supplierdetails[i].imgpath + '?v=' + rndmnum;
                    if (supplierdetails[i].imgpath != "") {
                        results += '<td style="cursor:pointer;"><img data-imagezoom="true" class="img-circle img-responsive" id="main_img_sup" alt="Item Image" src="' + img_url + '" style="width: 30px; height: 30px;cursor:pointer;" /></td>';// class="center-block img-circle img-thumbnail img-responsive profile-img"
                    }
                    else {
                        results += '<td style="cursor:pointer;"><img data-imagezoom="true" class="img-circle img-responsive" id="main_img_sup" alt="Item Image" src="Images/dummy_image.jpg" style="width: 30px; height: 30px;cursor:pointer;" /></td>';//class="center-block img-circle img-thumbnail img-responsive profile-img"
                    }
                    results += '<td data-title="brandstatus"><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"  onclick="getme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td>';
                    results += '<td style="display:none" class="16">' + supplierdetails[i].supplierid + '</td></tr>';
                    l = l + 1;
                    if (l == 4) {
                        l = 0;
                    }
                }
                results += '</table></div>';
                document.getElementById('txtName').value = "";
            }
            else {
                var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable" id="example">';
                results += '<thead><tr role="row" class="trbgclrcls"><th scope="col" style="font-weight: bold;">Supplier Name</th><th scope="col" style="font-weight: bold;">Contact Number</th><th scope="col" style="font-weight: bold;">Street1</th><th scope="col" style="font-weight: bold;">Mobile No</th><th scope="col" style="font-weight: bold;">Email Id</th><th scope="col" style="font-weight: bold;">Status</th><th scope="col" style="font-weight: bold;">Image</th><th scope="col" style="font-weight: bold;"></th></tr></thead></tbody>';
                var k = 1;
                var l = 0;
                var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
                for (var i = 0; i < supplierdetails.length; i++) {
                    if (name == supplierdetails[i].suppliername) {
                        results += '<tr style="background-color:' + COLOR[l] + '">'; //<td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="Edit" /></td>
                        results += '<td scope="row" class="1" style="text-align:center;font-weight: bold;"><i class="fa fa-user" aria-hidden="true"></i>&nbsp;&nbsp;<label id="1">' + supplierdetails[i].suppliername + '</label></td>';
                        results += '<td style="display:none" class="2">' + supplierdetails[i].description + '</td>';
                        results += '<td style="display:none" class="3">' + supplierdetails[i].companyname + '</td>';
                        results += '<td data-title="contactName" class="4"><i class="fa fa-mobile fa-2x" aria-hidden="true"></i>&nbsp;&nbsp;<span id="4">' + supplierdetails[i].contactname + '</span></td>';
                        
                        results += '<td data-title="street1" class="5">' + supplierdetails[i].street1 + '</td>';
                        results += '<td style="display:none" class="7">' + supplierdetails[i].city + '</td>';
                        results += '<td style="display:none" class="8">' + supplierdetails[i].state + '</td>';
                        results += '<td style="display:none" class="9">' + supplierdetails[i].country + '</td>';
                        results += '<td style="display:none" class="10">' + supplierdetails[i].zipcode + '</td>';
                        results += '<td style="display:none" class="21">' + supplierdetails[i].contactnumber + '</td>';
                        results += '<td data-title="mobileno" class="12"><i class="fa fa-mobile fa-2x" aria-hidden="true"></i>&nbsp;&nbsp;<span id="12">' + supplierdetails[i].mobileno + '</span></td>';
                        results += '<td data-title="emailid" class="13"><i class="fa fa-envelope" aria-hidden="true"></i>&nbsp;&nbsp;<span id="13">' + supplierdetails[i].emailid + '</span></td>';
                        results += '<td data-title="status" class="14">' + supplierdetails[i].status + '</td>';
                        results += '<td style="display:none" class="15">' + supplierdetails[i].websiteurl + '</td>';
                        results += '<td style="display:none"" class="17">' + supplierdetails[i].insurence + '</td>';
                        results += '<td style="display:none" class="18">' + supplierdetails[i].insurecetype + '</td>';
                        results += '<td style="display:none" class="19">' + supplierdetails[i].warranytype + '</td>';
                        results += '<td style="display:none" class="20">' + supplierdetails[i].warranty + '</td>';
                        results += '<td   style="display : none;" class="23">' + supplierdetails[i].imgpath + '</td>';
                        results += '<td   style="display : none;" class="24">' + supplierdetails[i].ftplocation + '</td>';
                        results += '<td style="display:none" class="22">' + supplierdetails[i].vendorcode + '</td>';
                        results += '<td style="display : none;" class="25">' + supplierdetails[i].gst_no + '</td>';
                        results += '<td style="display : none;" class="26">' + supplierdetails[i].gst_type + '</td>';
                        results += '<td style="display : none;" class="27">' + supplierdetails[i].pan_no + '</td>';
                        results += '<td style="display : none;" class="28">' + supplierdetails[i].bank_acc_no + '</td>';
                        results += '<td style="display : none;" class="29">' + supplierdetails[i].bank_ifsc + '</td>';
                        var rndmnum = Math.floor((Math.random() * 10) + 1);
                        var img_url = supplierdetails[i].ftplocation + supplierdetails[i].imgpath + '?v=' + rndmnum;
                        if (supplierdetails[i].imgpath != "") {
                            results += '<td style="cursor:pointer;"><img data-imagezoom="true" class="img-circle img-responsive" id="main_img_sup" alt="Item Image" src="' + img_url + '" style="width: 30px; height: 30px;cursor:pointer;" /></td>';// class="center-block img-circle img-thumbnail img-responsive profile-img"
                        }
                        else {
                            results += '<td style="cursor:pointer;"><img data-imagezoom="true" class="img-circle img-responsive" id="main_img_sup" alt="Item Image" src="Images/dummy_image.jpg" style="width: 30px; height: 30px;cursor:pointer;" /></td>';//class="center-block img-circle img-thumbnail img-responsive profile-img"
                        }
                        results += '<td data-title="brandstatus"><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls" onclick="getme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td>';
                        results += '<td style="display:none" class="16">' + supplierdetails[i].supplierid + '</td></tr>';

                        l = l + 1;
                        if (l == 4) {
                            l = 0;
                        }
                    }
                }
                results += '</table></div>';
            }
            $("#div_SuplierData").html(results);
           
            forclearall();
        }


        function forclearall() {
            document.getElementById('txtSuplierName').value = "";
            document.getElementById('txtDescript').value = "";
            document.getElementById('txtCompanyName').value = "";
            document.getElementById('txtContactName').value = "";
            document.getElementById('txtStreet').value = "";
            document.getElementById('txtCity').value = "";
            document.getElementById('slct_state_name').selectedIndex = 0;
            document.getElementById('txtCountry').value = "";
            document.getElementById('txtZipcode').value = "";
            document.getElementById('txtContactNumber').value = "";
            document.getElementById('txtMobileNum').value = "";
            document.getElementById('txtEmail').value = "";
            document.getElementById('txtWebsite').value = "";
            document.getElementById('ddlwarrenty').selectedIndex = 0;
            document.getElementById('txtwarrenty').value = "";
            document.getElementById('ddlinsurnce').selectedIndex = 0;
            document.getElementById('txtinsurence').value = "";
            document.getElementById('txt_vendor_cd').value = "";
            document.getElementById('slct_suppliers').selectedIndex = 0;
            document.getElementById('txt_gst_no').value = "";
            document.getElementById('txt_pan_no').value = "";
            document.getElementById('slct_gst_reg_type').selectedIndex = 0;
            document.getElementById('slct_document_type').selectedIndex = 0;
            document.getElementById('txt_bank_acc').value = "";
            document.getElementById('txt_bank_ifsc').value = "";
            document.getElementById('txtName').value = "";
            document.getElementById('FileUpload1').value = "";
            $('#main_img').attr('src', 'Images/dummy_image.jpg').width(200).height(200);
            document.getElementById('btn_save').innerHTML = "Save";
            document.getElementById('lbl_doc_id').value = "";
            $("#div_documents_table").html("");
            $("#lbl_code_error_msg").hide();
            $("#lbl_name_error_msg").hide();
            scrollTo(0, 0);
        }
        function filldetails(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable">';
            results += '<thead><tr role="row" class="trbgclrcls"><th scope="col" style="font-weight: bold;">Supplier Name</th><th scope="col" style="font-weight: bold;">Street1</th><th scope="col" style="font-weight: bold;">Mobile No</th><th scope="col" style="font-weight: bold;">Email Id</th><th scope="col" style="font-weight: bold;">Status</th><th scope="col" style="font-weight: bold;">Image</th><th scope="col"></th></tr></thead></tbody>';

            var k = 1;
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">';
                results += '<td class="1"><i class="fa fa-user" aria-hidden="true"></i>&nbsp;&nbsp;<label id="1">' + msg[i].suppliername + '</label></td>';
                results += '<td style="display:none" class="2">' + msg[i].description + '</td>';
                results += '<td style="display:none" class="3">' + msg[i].companyname + '</td>';
                results += '<td style="display:none" class="4"><i class="fa fa-phone fa-2x" aria-hidden="true"></i>&nbsp;&nbsp;<span id="4">' + msg[i].contactname + '</span></td>';
                
                results += '<td data-title="street1" class="5">' + msg[i].street1 + '</td>';
                results += '<td style="display:none" class="7">' + msg[i].city + '</td>';
                results += '<td style="display:none" class="8">' + msg[i].state + '</td>';
                results += '<td style="display:none" class="9">' + msg[i].country + '</td>';
                results += '<td style="display:none" class="10">' + msg[i].zipcode + '</td>';
                results += '<td style="display:none" class="21">' + msg[i].contactnumber + '</td>';
                results += '<td data-title="mobileno" class="12"><i class="fa fa-phone" aria-hidden="true"></i>&nbsp;&nbsp;<span id="12">' + msg[i].mobileno + '</span></td>';
                results += '<td data-title="emailid" class="13"><i class="fa fa-envelope-o" aria-hidden="true"></i>&nbsp;&nbsp;<span id="13">' + msg[i].emailid + '</span></td>';
                results += '<td data-title="status" class="14">' + msg[i].status + '</td>';
                results += '<td style="display:none" class="15">' + msg[i].websiteurl + '</td>';

                results += '<td style="display:none" class="17">' + msg[i].insurence + '</td>';
                results += '<td style="display:none" class="18">' + msg[i].insurecetype + '</td>';
                results += '<td style="display:none" class="19">' + msg[i].warranytype + '</td>';
                results += '<td style="display:none" class="20">' + msg[i].warranty + '</td>';
                results += '<td style="display : none;" class="23">' + msg[i].imgpath + '</td>';
                results += '<td style="display : none;" class="24">' + msg[i].ftplocation + '</td>';
                results += '<td style="display : none;" class="25">' + msg[i].gst_no + '</td>';
                results += '<td style="display : none;" class="26">' + msg[i].gst_type + '</td>';
                results += '<td style="display : none;" class="27">' + msg[i].pan_no + '</td>';
                results += '<td style="display : none;" class="28">' + msg[i].bank_acc_no + '</td>';
                results += '<td style="display : none;" class="29">' + msg[i].bank_ifsc + '</td>';
                results += '<td style="display:none" class="22">' + msg[i].vendorcode + '</td>';
                var rndmnum = Math.floor((Math.random() * 10) + 1);
                var img_url = msg[i].ftplocation + msg[i].imgpath + '?v=' + rndmnum;
                if (msg[i].imgpath != "") {
				    results += '<td><img data-imagezoom="true" class="img-circle img-responsive" id="main_img_sup" alt="Item Image" src="' + img_url + '" style="width: 30px; height: 30px;" /></td>';// class="center-block img-circle img-thumbnail img-responsive profile-img"
                }
                else {
				    results += '<td><img data-imagezoom="true" class="img-circle img-responsive" id="main_img_sup" alt="Item Image" src="Images/dummy_image.jpg" style="width: 30px; height: 30px;" /></td>';//class="center-block img-circle img-thumbnail img-responsive profile-img"
                }
                results += '<td data-title="brandstatus"><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls" onclick="getme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td>';
                results += '<td style="display:none" class="16">' + msg[i].supplierid + '</td></tr>';

                l = l + 1;
                if (l == 4) {
                    l = 0;
                }

            }
            results += '</table></div>';
            $("#div_SuplierData").html(results);
        }
        function getme(thisid) {
            scrollTo(0, 0);
            var Name = $(thisid).parent().parent().find('#1').html();
            var Description = $(thisid).parent().parent().children('.2').html();
            var Companyname = $(thisid).parent().parent().children('.3').html();
            var ContactName = $(thisid).parent().parent().find('#4').html();
            var Street1 = $(thisid).parent().parent().children('.5').html();
            var Street2 = $(thisid).parent().parent().children('.6').html();
            var City = $(thisid).parent().parent().children('.7').html();
            var State = $(thisid).parent().parent().children('.8').html();
            var Country = $(thisid).parent().parent().children('.9').html();
            var Zipcode = $(thisid).parent().parent().children('.10').html();
            var MobileNo = $(thisid).parent().parent().find('#12').html();
            var EmailId = $(thisid).parent().parent().find('#13').html();
            var Status = $(thisid).parent().parent().children('.14').html();
            var WebsiteUrl = $(thisid).parent().parent().children('.15').html();
            var suplierid = $(thisid).parent().parent().children('.16').html();
            var insurence = $(thisid).parent().parent().children('.17').html();
            var insurecetype = $(thisid).parent().parent().children('.18').html();
            var warranytype = $(thisid).parent().parent().children('.19').html();
            var warranty = $(thisid).parent().parent().children('.20').html();
            var contactnumber = $(thisid).parent().parent().children('.21').html();
            var vendor_cd = $(thisid).parent().parent().children('.22').html();
            var imgpath = $(thisid).parent().parent().children('.23').html();
            var ftplocation = $(thisid).parent().parent().children('.24').html();
            var gst_no = $(thisid).parent().parent().children('.25').html();
            var gst_type = $(thisid).parent().parent().children('.26').html();
            var pan_no = $(thisid).parent().parent().children('.27').html();
            var bank_acc_no = $(thisid).parent().parent().children('.28').html();
            var bank_ifsc = $(thisid).parent().parent().children('.29').html();

            getsupplier_Uploaded_Documents(suplierid);
            document.getElementById('lbl_sno').value = suplierid;
            document.getElementById('slct_suppliers').value = suplierid;
            document.getElementById('txtSuplierName').value = Name;
            document.getElementById('txtCompanyName').value = Companyname;
            document.getElementById('txtContactName').value = ContactName;
            document.getElementById('txtMobileNum').value = MobileNo;
            document.getElementById('txtDescript').value = Description;
            document.getElementById('txtStreet').value = Street1;
            document.getElementById('txtCity').value = City;
            document.getElementById('slct_state_name').value = State;
            document.getElementById('txtCountry').value = Country;
            document.getElementById('txtZipcode').value = Zipcode;
            document.getElementById('txtContactNumber').value = contactnumber;
            document.getElementById('txt_bank_acc').value = bank_acc_no;
            document.getElementById('txt_bank_ifsc').value = bank_ifsc;
            document.getElementById('txtWebsite').value = WebsiteUrl;
            document.getElementById('txtEmail').value = EmailId;
            document.getElementById('ddlwarrenty').value = warranytype;
            document.getElementById('txtwarrenty').value = warranty;
            document.getElementById('ddlinsurnce').value = insurecetype;
            document.getElementById('txtinsurence').value = insurence;
            document.getElementById('txt_vendor_cd').value = vendor_cd;
            document.getElementById('txt_gst_no').value = gst_no;
            document.getElementById('slct_gst_reg_type').value = gst_type;
            document.getElementById('txt_pan_no').value = pan_no;
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
            $("#div_SuplierData").hide();
            $("#div_sup_data").show();
            $("#divpic").show();
            $("#fillform").show();
            $('#showlogs').hide();
            var data = { 'op': 'get_item_details_supplier', 'suplierid': suplierid };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fill_product_names(msg);
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

        function fill_product_names(msg) {
            var results = '<div ><table class="responsive-table" id="example_items">';// style="overflow:auto;"
            results += '<thead><tr role="row" style="background:#5aa4d0; color: white; font-weight: bold;"><th style="text-align:center;" scope="col">Item Name</th><th style="text-align:center;" scope="col">SKU</th><th style="text-align:center;" scope="col">UOM</th><th style="text-align:center;" scope="col">Item Image</th><th style="text-align:center;" scope="col"></th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];

            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">';
                results += '<td scope="row" class="1" onclick="productdetails(\'' + msg[i].productid + '\');" style="text-align:center;"><label id="lbl_productname" value="' + msg[i].productname + '">' + msg[i].productname + '</label></td>';
                results += '<td scope="row" class="2" style="text-align:center;"><label id="lbl_sku" value="' + msg[i].sku + '">' + msg[i].sku + '</label></td>';
                results += '<td scope="row" class="3" style="text-align:center;"><label id="lbl_uim" value="' + msg[i].uim + '">' + msg[i].uim + '</label></td>';
                results += '<td style="display : none;"  class="2"><label id="lbl_productid" value="' + msg[i].productid + '">' + msg[i].productid + '</label></td>';
                var rndmnum = Math.floor((Math.random() * 10) + 1);
                var img_url = msg[i].ftplocation + msg[i].imgpath + '?v=' + rndmnum;
                if (msg[i].imgpath != "") {
                    results += '<td><img class="center-block img-circle img-thumbnail img-responsive profile-img" id="main_img1" alt="Item Image" src="' + img_url + '" style="border-radius: 5px; width: 150px; height: 75px; border-radius: 10%;" /></td>'
                }
                else {
                    results += '<td><img class="center-block img-circle img-thumbnail img-responsive profile-img" id="main_img1" alt="Item Image" src="Images/dummy_image.jpg" style="border-radius: 5px; width: 150px; height: 75px; border-radius: 10%;" /></td>'
                }
                results += '<td style="display : none;"  class="2"><label id="lbl_item_sno" value="' + msg[i].sno + '">' + msg[i].sno + '</label></td>';
                results += '<td><span><img src="images/close.png" onclick="removerow_items(this)" style="cursor:pointer;height:20px;"/></span></td></tr>';

                l = l + 1;
                if (l == 4) {
                    l = 0;
                }

            }
            results += '</table></div>';
            $("#div_product_data").html(results);
            $('#div_product_data').show();
        }

        function removerow_items1(thisid) {
            $(thisid).parents('tr').remove();

            product_ids = [];
            $('#example_items> tbody > tr').each(function () {
                var productid = $(this).find('#lbl_productid').text();
                var item_sno = $(this).find('#lbl_item_sno').text();
                if (productid == "" || productid == "0") {
                }
                else {
                    product_ids.push({ item_sno: item_sno, productid: productid });
                }
            });
        }

        function productdetails(productid) {
            var data = { 'op': 'get_product_details_id', 'productid': productid };
            var s = function (msg) {
                if (msg) {
                    if (msg) {
                        $('#divMainAddNewRow1').css('display', 'none');
                        fillproductdetails(msg);
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

        function fillproductdetails(msg) {
            $('#divMainAddNewRow1').css('display', 'block');
            j = 1;
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr style="background: #5aa4d0;"><th style="text-align:center;" scope="col">Sno</th><th style="text-align:center;" scope="col">Item Name</th><th style="text-align:center;" scope="col">UOM</th><th style="text-align:center;" scope="col">Product Code</th><th style="text-align:center;" scope="col">Category</th><th style="text-align:center;" scope="col">Sub Category</th><th style="text-align:center;" scope="col">SKU</th><th style="text-align:center;" scope="col">Supplier Name</th><th style="text-align:center;" scope="col">Item Code</th></tr></thead></tbody>';

            var k = 1;
            var l = 0;
            //var COLOR = ["##87CEEB", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '"><th scope="row" class="1" style="text-align:center;">' + j + '</th>';
                results += '<td class="2">' + msg[i].productname + '</td>';
                results += '<td class="3">' + msg[i].uim + '</td>';
                results += '<td class="4">' + msg[i].productcode + '</td>';
                results += '<td class="5">' + msg[i].category + '</td>';
                results += '<td class="6">' + msg[i].subcatname + '</td>';
                results += '<td class="7">' + msg[i].sku + '</td>';
                results += '<td class="8">' + msg[i].suppliername + '</td>';
                results += '<td class="9" >' + msg[i].itemcode + '</td><tr>';

                j++;
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }

            }
            results += '</table></div>';
            $("#div_productdetails").html(results);
        }

        function supplier_image_upload() {
            var fileUpload = document.getElementById('fu_sup_image');
            if (typeof (FileReader) != "undefined") {
                var dvPreview = document.getElementById("div_supplier_image");
                dvPreview.innerHTML = "";
                var regex = /^([a-zA-Z0-9\s_\\.\-:])+(.jpg|.jpeg|.gif|.png|.bmp)$/;
                for (var i = 0; i < fileUpload.files.length; i++) {
                    var file = fileUpload.files[i];
                    if (regex.test(file.name.toLowerCase())) {
                        var reader = new FileReader();
                        reader.onload = function (e) {
                            var img = document.createElement("IMG");
                            img.height = "100";
                            img.width = "100";
                            img.src = e.target.result;
                            dvPreview.appendChild(img);
                        }
                        reader.readAsDataURL(file);
                    } else {
                        alert(file.name + " is not a valid image file.");
                        dvPreview.innerHTML = "";
                        return false;
                    }
                }
            } else {
                alert("This browser does not support HTML5 FileReader.");
            }
        }

        function readURL_supplierimage(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();

                reader.onload = function (e) {
                    $('#img_supplier').attr('src', e.target.result).width(155).height(200);
                    //                    $('#img_1').css('display', 'inline');
                };
                reader.readAsDataURL(input.files[0]);
            }
        }

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

            var supplierid = document.getElementById('lbl_sno').value;
            var Data = new FormData();
            Data.append("op", "Supplier_pic_files_upload");
            Data.append("supplierid", supplierid);
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

        function hasExtension(fileName, exts) {
            return (new RegExp('(' + exts.join('|').replace(/\./g, '\\.') + ')$')).test(fileName);
        }

        function readURL(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();

                reader.onload = function (e) {
                    $('#main_img,#img_1').attr('src', e.target.result).width(200).height(200);
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

        

        var product_details = [];
        function get_product_details() {
            var data = { 'op': 'get_productissue_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        product_details = msg;
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

        

        var products = [];
        function get_product_det() {

            products = [];
            $('#example_items> tbody > tr').each(function () {
                var productid = $(this).find('#lbl_productid').text();
                var productname = $(this).find('#lbl_productname').text();
                var sno = $(this).find('#lbl_item_sno').text();
                if (productid == "" || productid == "0") {
                }
                else {
                    products.push({ productname: productname, productid: productid, sno: sno });
                }
            });

            var exists = 0;
            var sno1 = "";
            var productname1 = document.getElementById('slct_product');
            var productname = productname1.options[productname1.selectedIndex].innerHTML;
            var productid = document.getElementById("slct_product").value;
            if (productid == "") {
                alert("Please Select Product");
                return false;
            }
            for (var i = 0; i < products.length; i++) {
                if (productid == products[i].productid) {
                    exists = 1;
                }
            }
            if (exists == 1) {
                alert("Product already added");
                return false;
            }
            else if (exists == 0) {
                products.push({ productname: productname, productid: productid, sno: sno1 });
            }

            var results = '<div ><table class="responsive-table" id="example_items">';// style="overflow:auto;"
            results += '<thead><tr role="row" style="background:#5aa4d0; color: white; font-weight: bold;"><th style="text-align:center;" scope="col">Item Name</th><th style="text-align:center;" scope="col">SKU</th><th style="text-align:center;" scope="col">UOM</th><th style="text-align:center;" scope="col">Item Image</th><th style="text-align:center;" scope="col"></th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            for (var k = 0; k < products.length; k++) {
                for (var i = 0; i < product_details.length; i++) {
                    if (products[k].productid == product_details[i].productid) {
                        results += '<tr style="background-color:' + COLOR[l] + '">';
                        results += '<td scope="row" class="1" onclick="productdetails(\'' + product_details[i].productid + '\');" style="text-align:center;"><label id="lbl_productname" value="' + product_details[i].productname + '">' + product_details[i].productname + '</label></td>';
                        results += '<td scope="row" class="2" style="text-align:center;"><label id="lbl_sku" value="' + product_details[i].sku + '">' + product_details[i].sku + '</label></td>';
                        results += '<td scope="row" class="3" style="text-align:center;"><label id="lbl_uim" value="' + product_details[i].uim + '">' + product_details[i].uim + '</label></td>';
                        results += '<td style="display : none;"  class="2"><label id="lbl_productid" value="' + product_details[i].productid + '">' + product_details[i].productid + '</label></td>';
                        var rndmnum = Math.floor((Math.random() * 10) + 1);
                        var img_url = product_details[i].ftplocation + product_details[i].imgpath + '?v=' + rndmnum;
                        if (product_details[i].imgpath != "") {
                            results += '<td><img class="center-block img-circle img-thumbnail img-responsive profile-img" id="main_img1" alt="Item Image" src="' + img_url + '" style="border-radius: 5px; width: 150px; height: 75px; border-radius: 10%;" /></td>'
                        }
                        else {
                            results += '<td><img class="center-block img-circle img-thumbnail img-responsive profile-img" id="main_img1" alt="Item Image" src="Images/dummy_image.jpg" style="border-radius: 5px; width: 150px; height: 75px; border-radius: 10%;" /></td>'
                        }
                        results += '<td style="display : none;"  class="2"><label id="lbl_item_sno" value="' + products[k].sno + '">' + products[k].sno + '</label></td>';
                        results += '<td><span><img src="images/close.png" onclick="removerow_items(this)" style="cursor:pointer;height:20px;"/></span></td></tr>';

                        l = l + 1;
                        if (l == 4) {
                            l = 0;
                        }
                    }

                }
            }
            results += '</table></div>';
            $("#div_product_data").html(results);
            $('#div_product_data').show();
        }

        function removerow_items(thisid) {
            $(thisid).parents('tr').remove();

            products = [];
            $('#example_items> tbody > tr').each(function () {
                var productid = $(this).find('#lbl_productid').text();
                var productname = $(this).find('#lbl_productname').text();
                var sno = $(this).find('#lbl_item_sno').text();
                if (productid == "" || productid == "0") {
                }
                else {
                    products.push({ productname: productname, productid: productid, sno: sno });
                }
            });
        }

        function removerow(thisid) {
            $(thisid).parents('tr').remove();
        }

        function getFile_doc() {
            document.getElementById("FileUpload1").click();
        }
        function readURL_doc(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.readAsDataURL(input.files[0]);
                document.getElementById("FileUpload_div").innerHTML = input.files[0].name;
            }
        }
        function upload_Supplier_Document_Info() {
            var supplierid = document.getElementById('slct_suppliers').value;
            var doc_sno = document.getElementById('lbl_doc_id').value;
            var suppliername = document.getElementById('slct_suppliers').selectedOptions[0].innerText;
            var documenttype = document.getElementById('slct_document_type').value;
            if (supplierid == null || supplierid == "") {
                document.getElementById("slct_supplier").focus();
                alert("Please select Supplier");
                return false;
            }
            if (documenttype == null || documenttype == "") {
                alert("Please select Document Type");
                return false;
            }
            var Data = new FormData();
            Data.append("op", "save_Supplier_Document_Info");
            Data.append("supplierid", supplierid);
            Data.append("suppliername", suppliername);
            Data.append("documenttype", documenttype);
            Data.append("sno", doc_sno);
            var fileUpload = $("#FileUpload1").get(0);
            var files = fileUpload.files;
            for (var i = 0; i < files.length; i++) {
                Data.append(files[i].name, files[i]);
            }

            var s = function (msg) {
                if (msg) {
                    alert(msg);
                    get_suplier_details();
                    forclearall();
                    compiledList = [];
                    $('#div_SuplierData').show();
                    $("#div_sup_data").hide();
                    $("#divpic").hide();
                    $("#div_sup_doc").hide();
                    $('#fillform').css('display', 'none');
                    $('#showlogs').css('display', 'block');
                }
            };
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler_nojson_post(Data, s, e);
        }

        function getsupplier_Uploaded_Documents(supplierid)
        {
            var data = { 'op': 'getsupplier_Uploaded_Documents', 'supplierid': supplierid };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillsupplier_Uploaded_Documents(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        function fillsupplier_Uploaded_Documents(msg)
        {
            document.getElementById('slct_suppliers').value = msg[0].supplierid;
            document.getElementById('slct_document_type').value = msg[0].documenttype;
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col" style="text-align:center">Supplier Name</th><th scope="col" style="text-align:center">Document Name</th><th scope="col">Document</th><th scope="col">Download</th></tr></thead></tbody>';
            var k = 1;
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td>' + k + '</td>';
                var rndmnum = Math.floor((Math.random() * 10) + 1);
                var path2 = msg[i].path;
                var path1 = path2.split('.');
                var img_url = msg[i].ftplocation + msg[i].path + '?v=' + rndmnum;
                results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].suppliername + '</th>';
                results += '<td data-title="Code" class="2">' + msg[i].documenttype + '</td>';
                if (path1[1] == "pdf")
                {
                    if (img_url != "") {
                        results += '<td data-title="brandstatus" class="2"><iframe src=' + img_url + ' style="width:400px; height:400px;" frameborder="0"></iframe><img src=' + img_url + '  style="cursor:pointer;height:400px;width:400px;border-radius: 5px;display:none;"/></td>';
                    }
                    else {
                        results += '<td data-title="brandstatus" class="2"><img src="Images/dummy_image.jpg"  style="cursor:pointer;height:400px;width:400px;border-radius: 5px;"/></td>';
                    }
                }
                else if (path1[1] == "jpeg")
                {
                    if (img_url != "") {
                        results += '<td data-title="brandstatus" class="2"><img src=' + img_url + '  style="cursor:pointer;height:400px;width:400px;border-radius: 5px;"/></td>';
                    }
                    else {
                        results += '<td data-title="brandstatus" class="2"><img src="Images/dummy_image.jpg"  style="cursor:pointer;height:400px;width:400px;border-radius: 5px;"/></td>';
                    }
                }
                
                results += '<th scope="row" class="1" ><a  target="_blank" href=' + img_url + '><i class="fa fa-download" aria-hidden="true"></i> Download</a></th>';
                results += '<td style="display:none" class="4">' + msg[i].supplierid + '</td>';
                results += '</tr>';
                k++;
            }
            results += '</table></div>';
            $("#div_documents_table").html(results);
        }


        function filldetails2(msg) {
            var data = document.getElementById('slct_suppliers');
            var length = data.options.length;
            document.getElementById('slct_suppliers').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select Supplier";
            opt.value = "Select Supplier";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].supplierid != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].suppliername;
                    option.value = msg[i].supplierid;
                    data.appendChild(option);
                }
            }
        }

        function change_details()
        {
            $("#div_SuplierData").hide();
            $("#div_sup_doc").hide();
            $("#fillform").show();
            $("#divpic").show();
            $('#showlogs').hide();
            $('#div_product_data').show();
            //scrollTo(0, 0);
        }

        function change_Documents()
        {
            $("#div_SuplierData").hide();
            $("#div_sup_doc").show();
            $("#fillform").hide();
            $("#divpic").show();
            $('#showlogs').hide();
            $('#div_product_data').hide();
            //scrollTo(0, 0);
        }

        function get_category_data()
        {
            var data = { 'op': 'get_Category_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillcategorydata(msg);
                    }
                    else {
                        msg = [];
                        fillcategorydata(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        function fillcategorydata(msg) {
            var data = document.getElementById('slct_item_cat');
            var length = data.options.length;
            document.getElementById('slct_item_cat').options.length = null;
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

        function get_product_details_category()
        {
            var categoryid = document.getElementById("slct_item_cat").value;
            var data = { 'op': 'get_product_details_category', 'categoryid': categoryid };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        FillProductsNames(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        function FillProductsNames(msg) {
            var data = document.getElementById('slct_product');
            var length = data.options.length;
            document.getElementById('slct_product').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select Product";
            opt.value = "";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].productname != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].productname;
                    option.value = msg[i].productid;
                    data.appendChild(option);
                }
            }
        }

        function get_statemaster_det()
        {
            var data = { 'op': 'get_statemaster_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        FillStateNames(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        function FillStateNames(msg) {
            var data = document.getElementById('slct_state_name');
            var length = data.options.length;
            document.getElementById('slct_state_name').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select State";
            opt.value = "";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].statename != null) {
                    if (msg[i].statename != "All")
                    {
                        if (msg[i].statename != "Nil")
                        {
                            var option = document.createElement('option');
                            option.innerHTML = msg[i].statename;
                            option.value = msg[i].sno;
                            data.appendChild(option);
                        }
                    }
                }
            }
        }

        function CloseClick_prod_det_close() {
            $('#divMainAddNewRow1').css('display', 'none');
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Supplier Details
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operation</a></li>
            <li><a href="#">Supplier Master</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Supplier details
                </h3>
            </div>
            <div class="box-body">
                <div id="showlogs" align="center">
                    <table>
                        <tr>
                            <td>
                             <div class="input-group margin">
                               <input id="txtName" type="text" class="form-control" name="vendorcode"  placeholder="Search Supplier Name" />
                                   <span class="input-group-btn">
                                     <button type="button" class="btn btn-info btn-flat" style="height: 35px;"><i class="fa fa-search" aria-hidden="true"></i></button>
                                   </span>
                             </div>
                                
                            </td>
                          
                            <td style="width: 66%;">
                            </td>
                            <td>
                                <div id="sub_Category_FillForms" class="input-group">
                                    <div class="input-group-addon">
                                        <span class="glyphicon glyphicon-plus-sign" onclick="showdesign()"></span> <span style="cursor:pointer" title="Click Here to Add Supplier" onclick="showdesign()">Add Supplier</span>
                                    </div>
                              </div>
                            </td>
                        </tr>
                    </table>
                </div>
                <div id="div_SuplierData">
                </div>
                <div id="divpic" class="pictureArea1" style="display: none;padding-bottom: 52px;">
                        <table>
                            <tr>
                                <th style="padding-left: 40px;font-size: 20px;">Supplier Image</th>
                            </tr>
                            <tr>
                                <td style="padding-top:7px">
                                    <img class="center-block img-circle img-thumbnail img-responsive profile-img" id="main_img"
                                    alt="Agent Image" src="Images/dummy_image.jpg" style="border-radius: 5px; width: 200px; height: 200px; border-radius: 50%;" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="photo-edit-admin">
                                    <a onclick="getFile();" class="photo-edit-icon-admin" title="Change Profile Picture"
                                        data-toggle="modal"  data-target="#photoup"><i style="padding-left: 40px;padding-top: 10px;" class="fa fa-pencil">CHOOSE PHOTO</i></a>
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
                                    <div class="input-group" style="padding-left: 40px;padding-top: 10px;">
                                        <div class="input-group-addon">
                                        <span class="glyphicon glyphicon-upload" id="btn_upload_profilepic1" onclick="upload_profile_pic()"></span> <span id="btn_upload_profilepic" onclick="upload_profile_pic()">Upload Photo</span>
                                  </div>
                                  </div>
                                </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                <div id="div_sup_data" style="display:none">
                    <div>
                        <ul class="nav nav-tabs">
                            <li id="id_tab_Personal" class="active"><a data-toggle="tab" href="#" onclick="change_details()">
                                <i class="fa fa-street-view"></i>&nbsp;&nbsp;Supplier Details</a></li>
                            <li id="id_tab_documents" class=""><a data-toggle="tab" href="#" onclick="change_Documents()">
                                <i class="fa fa-file-text"></i>&nbsp;&nbsp;Supplier Documents</a></li>
                        </ul>
                    </div>
                    <div id="div_sup_det">
                    <table align="center">
                    <tr>
                    <td>
                    
                    </td>
                    <td>
                    <div id='fillform' style="display: none;">
                        <table align="center" style="width:100%;">
                            <tr>
                                <th>
                                </th>
                            </tr>
                            <tr>
                                <td style="height: 40px;">
                                    <label>Name</label><span style="color: red;">*</span>
                                    <input id="txtSuplierName" type="text" style="text-transform:capitalize;" maxlength="45" class="form-control" name="vendorcode"
                                        placeholder=" Enter Name" onkeypress="return ValidateAlpha(event);" /><label id="lbl_code_error_msg"
                                            class="errormessage">* Please Enter Name</label>
                                </td>
                                <td style="width: 5px;">
                                </td>
                                <td style="height: 40px;">
                                    <label>Company Name</label><span style="color: red;">*</span>
                                    <input id="txtCompanyName" type="text" style="text-transform:capitalize;" maxlength="45" class="form-control" name="vendorcode"
                                        placeholder=" Enter Company Name" onkeypress="return ValidateAlpha(event);" /><label
                                            id="Label5" class="errormessage">* Enter Company name</label>
                                </td>
                                
                            </tr>
                            <tr>
                                <td style="height: 40px;">
                                    <label>Enter City Name</label><span style="color: red;"></span>
                                    <input id="txtCity" type="text" maxlength="45" class="form-control" name="vendorcode"
                                        placeholder=" Enter City Name" onkeypress="return ValidateAlpha(event);" /><label
                                            id="Label8" class="errormessage">* Enter City Name</label>
                                </td>
                                <td style="width: 5px;">
                                </td>
                                <td style="height: 40px;">
                                    <label>Enter State Name</label><span style="color: red;">*</span>
                                    <select id="slct_state_name" class="form-control"></select>
                                </td>
                                
                            </tr>
                            <tr>
                                <td style="height: 40px;">
                                    <label>Country Name</label><span style="color: red;">*</span>
                                    <input id="txtCountry" type="text" maxlength="45" class="form-control" name="vendorcode"
                                        placeholder="Enter Contry Name" /><label id="Label1" class="errormessage">* Please Enter
                                            Country Name</label>
                                </td>
                                <td style="width: 5px;">
                                </td>
                                <td style="height: 40px;">
                                    <label>Enter Street</label><span style="color: red;">*</span>
                                    <input id="txtStreet" type="text" rows="5" cols="45" class="form-control" name="vendorcode"
                                        placeholder=" Enter Street" /><label id="Label7" class="errormessage">* Enter Street</label>
                                </td>
                            </tr>
                            <tr>
                                <td style="height: 40px;">
                                    <label>Contact Name</label><span style="color: red;">*</span>
                                    <input id="txtContactNumber" type="text" rows="5" cols="45" class="form-control" name="vendorcode"
                                        placeholder="Enter Contact Name" onkeypress="return ValidateAlpha(event);" /><label
                                            id="Label10" class="errormessage">* Please Enter ContactName</label>
                                </td>
                                <td style="width: 5px;">
                                </td>
                                <td style="height: 40px;">
                                    <label>Contact Number</label><span style="color: red;">*</span>
                                    <input id="txtContactName" type="text" maxlength="45" class="form-control" name="vendorcode"
                                        placeholder="Enter Contact Number" onkeypress="return isNumber(event)" /><label id="Label2"
                                            class="errormessage">* Please Enter Contact Number</label>
                                </td>
                            </tr>
                            <tr>
                                <td style="height: 40px;">
                                    <label>Mobile Number</label><span style="color: red;"></span>
                                    <input id="txtMobileNum" type="text" maxlength="45" class="form-control" name="vendorcode"
                                        placeholder=" Enter Mobile Number" onkeypress="return isNumber(event)" /><label id="Label11"
                                            class="errormessage">* Enter Mobile Number</label>
                                </td>
                                <td style="width: 5px;">
                                </td>
                                <td style="height: 40px;">
                                    <label>E-mail ID</label><span style="color: red;"></span>
                                    <input id="txtEmail" type="text" maxlength="45" class="form-control" name="vendorcode"
                                        placeholder="Enter Email Id" /><label id="Label3" class="errormessage">* Please Enter
                                            E-MailID</label>
                                </td>
                            </tr>
                            <tr>
                                <td style="height: 40px;">
                                    <label>WebSite URL</label><span style="color: red;"></span>
                                    <input id="txtWebsite" type="text" maxlength="45" class="form-control" name="vendorcode"
                                        placeholder=" Enter WebSite URL" /><label id="Label9" class="errormessage">* Enter WebSite</label>
                                </td>
                                <td style="width: 5px;">
                                </td>
                                <td style="height: 40px;">
                                    <label>Tin Number</label><span style="color: red;"></span>
                                    <input id="txtZipcode" type="text" maxlength="45" class="form-control" name="vendorcode"
                                        placeholder=" Enter Tin Number" onkeypress="return isNumber(event)" /><label id="Label6"
                                            class="errormessage">* Enter Tin Number</label>
                                </td>
                            </tr>
                            <tr>
                                <td style="height: 40px;">
                                    <label>Status</label><span style="color: red;"></span>
                                    <select id="ddlStatus" class="form-control">
                                        <option value="1">Active</option>
                                        <option value="0">InActive</option>
                                    </select>
                                </td>
                                <td style="width: 5px;">
                                </td>
                                <td style="height: 40px;">
                                    <label>Warranty Type</label><span style="color: red;"></span>
                                    <select id="ddlwarrenty" class="form-control">
                                        <option value="NO">NO</option>
                                        <option value="YES">YES</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td style="height: 40px;">
                                    <label>Warranty</label><span style="color: red;"></span>
                                    <input id="txtwarrenty" type="text" class="form-control" name="warrenty" placeholder="Enter  Warranty" />
                                </td>
                                <td style="width: 5px;">
                                </td>
                                <td style="height: 40px;">
                                    <label>Insurance</label><span style="color: red;"></span>
                                    <select id="ddlinsurnce" class="form-control" onchange="ddlfinancechange();">
                                        <option value="NO">NO</option>
                                        <option value="YES">YES</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td style="height: 40px;">
                                    <label>Insurance Amount</label><span style="color: red;"></span>
                                    <input id="txtinsurence" type="text" class="form-control" name="Address" placeholder="Enter Insurance Amount"
                                        onkeypress="return isNumber(event)" />
                                </td>
                                <td style="width: 5px;">
                                </td>
                                <td style="height: 40px;">
                                    <label>Supplier Code</label><span style="color: red;">*</span>
                                    <input id="txt_vendor_cd" type="text" class="form-control" name="Vendor_ID" placeholder="Enter Vendor Code" />
                                </td>
                            </tr>
                            <tr>
                                <td style="height: 40px;">
                                    <label>Product Category</label>
                                    <select id="slct_item_cat" class="form-control" onchange="get_product_details_category();"></select>
                                </td>
                                <td style="width: 5px;">
                                </td>
                                <td style="height: 40px;">
                                    <label>Products</label><span style="color: red;"></span>
                                    <select id="slct_product" class="form-control"></select><%-- style="width:120px;"--%>
                                </td>
                                <td style="height: 40px;padding-top: 24px;">
                                <div class="input-group">
                                <div class="input-group-addon">
                                        <span class="glyphicon glyphicon-plus-sign" onclick="get_product_det()"></span>
                                    </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td style="height: 40px;">
                                    <label>GST Reg Type</label><span style="color: red;">*</span>
                                    <select id="slct_gst_reg_type" class="form-control">
                                        <option value="Casual Taxable Person">Casual Taxable Person</option>
                                        <option value="Composition Levy">Composition Levy</option>
                                        <option value="Government Department or PSU">Government Department or PSU</option>
                                        <option value="Non Resident Taxable Person">Non Resident Taxable Person</option>
                                        <option value="Regular/TDS/ISD">Regular/TDS/ISD</option>
                                        <option value="UN Agency or Embassy">UN Agency or Embassy</option>
                                    </select>
                                </td>
                                <td style="width: 5px;">
                                </td>
                                <td style="height: 40px;">
                                    <label>GST No</label><span style="color: red;">*</span>
                                    <input type="text" id="txt_gst_no" name="gst_no" class="form-control" placeholder="Enter GST No" />
                                </td>
                            </tr>
                            <tr>
                                <td style="height: 40px;">
                                    <label>Bank Account No</label><span style="color: red;">*</span>
                                    <input id="txt_bank_acc" type="text" name="bank_acc_no" class="form-control" placeholder="Enter Bank Account No" />
                                </td>
                                <td style="width: 5px;"></td>
                                <td style="height: 40px;">
                                    <label>Bank Ifsc Code</label><span style="color: red;">*</span>
                                    <input id="txt_bank_ifsc" type="text" name="bank_ifsc" class="form-control" placeholder="Enter Bank Ifsc Code" />
                                </td>
                            </tr>
                            <tr>
                                <td style="height: 40px;">
                                    <label>PAN No</label>
                                    <input id="txt_pan_no" type="text" name="pan_no" class="form-control" placeholder="Enter PAN No" />
                                </td>
                                <td style="width: 5px;"></td>
                                
                            </tr>
                            <tr>
                                <td colspan="4" style="height: 40px;">
                                    <label>Description</label><span style="color: red;"></span>
                                    <textarea id="txtDescript" rows="4" cols="10" name="PDescription" class="form-control"
                                        placeholder=" Enter Description">
                                  </textarea>
                                    <label id="Label4" class="errormessage">
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
                                            <span class="glyphicon glyphicon-ok" id="btn_save1" onclick="saveSuplierDetails()"></span> <span id="btn_save" onclick="saveSuplierDetails()">save</span>
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
                    <div style="width:70%;display:none; padding-left:25%;display:none" id="div_product_data"></div>
            </div>
                <div id="div_sup_doc" style="display:none">
                    <div>
                        <div class="box-header with-border">
                            <h3 class="box-title">
                                <i style="padding-right: 5px;" class="fa fa-cog"></i>Supplier Files Upload
                            </h3>
                        </div>
                        <div class="box-body">
                            <div class="row">
                                <div class="col-sm-4">
                                      <table>
                                            <tr>
                                                <td><label>Supplier</label>
                                                    <select id="slct_suppliers" class="form-control"></select>
                                                </td>
                                            </tr>
                                      </table>                      
                                </div>
                                <div class="col-sm-4" >
                                      <table>
                                          <tr>
                                              <td><label>Document Type</label>
                                                  <select id="slct_document_type" class="form-control">
                                                      <option value="">Select Document Type</option>
                                                      <option value="VisitingCard">Visiting Card</option>
                                                      <option value="Brochure">Brochure</option>
                                                      <option value="document1">document1</option>
                                                  </select>
                                              </td>
                                          </tr>
                                          <tr style="display:none">
                                              <td>
                                                  <label id="lbl_doc_id"></label>
                                              </td>
                                          </tr>
                                      </table>                      
                                </div>
                                <div class="col-sm-4">
                                    <table class="table table-bordered table-striped">
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <div id="FileUpload_div" class="img_btn" onclick="getFile_doc()" style="height: 50px;
                                                        width: 100%">
                                                        Choose Document To Upload
                                                    </div>
                                                    <div style="height: 0px; width: 0px; overflow: hidden;">
                                                        <input id="FileUpload1" type="file" name="files[]" onchange="readURL_doc(this);" />
                                                    </div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                                <div class="col-sm-4">
                                    <table>
                                       <tr>
                                        <td>
                                        <div class="input-group">
                                            <div class="input-group-addon">
                                            <span class="glyphicon glyphicon-upload" id="btn_upload_document1" onclick="upload_Supplier_Document_Info()"></span> <span id="btn_upload_document" onclick="upload_Supplier_Document_Info()">UPLOAD</span>
                                      </div>
                                      </div>
                                        </td>
                                        <td style="width:10px;"></td>
                                        <td>
                                         <div class="input-group">
                                            <div class="input-group-close">
                                            <span class="glyphicon glyphicon-remove" id='Span3' onclick="canceldetails()"></span> <span id='Span4' onclick="canceldetails()">Close</span>
                                      </div>
                                      </div>
                                        </td>
                                        </tr>
                                   </table>
                                </div>
                            </div>
                    
                        </div>
                    </div>
                    <div id="div_documents_table"></div>
                </div>
            </div>
            <div id="divMainAddNewRow1" class="pickupclass" style="text-align: center; height: 100%;
                                width: 100%; position: absolute; display: none; left: 0%; top: 0%; z-index: 99999;
                                background: rgba(192, 192, 192, 0.7);">
                                <div id="div2" style="border: 5px solid #A0A0A0; position: absolute; top: 8%;
                                    background-color: White; left: 10%; right: 10%; width: 85%; -webkit-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                                    -moz-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65); box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                                    border-radius: 10px 10px 10px 10px;">
                                    <table align="left" cellpadding="0" cellspacing="0" style="float: left; width: 100%;"
                                        id="table1" class="mainText3" border="1">
                                        <tr>
                                            <td colspan="2">
                                                <div id="div_productdetails">
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <input type="button" class="btn btn-danger" id="btn_prod_det_close" value="Close" onclick="CloseClick_prod_det_close();" />
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div id="div_prod_det_close" style="width: 35px; top: 7.5%; right: 10%; position: absolute;
                                    z-index: 99999; cursor: pointer;">
                                    <img src="Images/Close.png" alt="close" width="100%" height="100%" onclick="CloseClick_prod_det_close();" />
                                </div>
                            </div>
    </section>
</asp:Content>
