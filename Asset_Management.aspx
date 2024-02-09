<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true" CodeFile="Asset_Management.aspx.cs" Inherits="Asset_Management" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        $(function () {
            $("#comp_det").css("display", "none");
            scrollTo(0, 0);
            get_Branch_loc();
            get_asset_mgm();
            get_sub_Dept();
            get_vendor_det();
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

        function get_Branch_loc() {
            var data = { 'op': 'get_Branch_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillpartytypedetails(msg);
                        //fillpartytypedetails1(msg);
                        //short_desc = msg;
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
        function fillpartytypedetails(msg) {
            var data = document.getElementById('slct_main_loc');
            var length = data.options.length;
            document.getElementById('slct_main_loc').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "SELECT LOCATION";
            opt.value = "SELECT LOCATION";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "displaynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].branchname != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].branchname;
                    option.value = msg[i].branchid;
                    data.appendChild(option);
                }
            }
        }

        function get_sub_Dept() {
            var data = { 'op': 'get_Department_Details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fill_dept_details(msg);
                        //fillpartytypedetails1(msg);
                        //short_desc = msg;
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
        function fill_dept_details(msg) {
            var data = document.getElementById('slct_sub_loc');
            var length = data.options.length;
            document.getElementById('slct_sub_loc').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "SELECT LOCATION";
            opt.value = "SELECT LOCATION";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "displaynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].department != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].department;
                    option.value = msg[i].sno;
                    data.appendChild(option);
                }
            }
        }

        function get_vendor_det() {
            var data = { 'op': 'get_suplier_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fill_vendor_details(msg);
                        //fillpartytypedetails1(msg);
                        //short_desc = msg;
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
        function fill_vendor_details(msg) {
            var data = document.getElementById('slct_vendor');
            var length = data.options.length;
            document.getElementById('slct_vendor').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "SELECT VENDOR";
            opt.value = "SELECT VENDOR";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "displaynone");
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

        function computer_det()
        {
            var com_data = document.getElementById('slct_type').value;
            if (com_data == "Computers") {
                $("#comp_det").css("display", "block");
            }
            else {
                $("#comp_det").css("display", "none");
            }
        }

        function save_asset_mgm() {
            var asset_name = document.getElementById("txt_asset_name").value;
            if (asset_name == "") {

                alert("Enter asset Name");
                return false;
            }
            var War_lic = document.getElementById("txt_War_lic").value;
            if (War_lic == "") {

                alert("Enter Warranty/License");
                return false;
            }
            var asset_code = document.getElementById("txt_asset_code").value;
            if (asset_code == "") {

                alert("Enter asset code");
                return false;
            }
            var slct_type = document.getElementById("slct_type").value;
            if (slct_type == "" || slct_type == "Select type") {
                alert("Select the field Type");
                return false;
            } 
            var slct_maintain = document.getElementById("slct_maintain").value;
            if (slct_maintain == "" || slct_maintain == "Select type") {
                alert("Select the field Maintenance Type");
                return false;
            }
            var status = document.getElementById("slct_status").value;
            if (status == "" || status == "Select") {

                alert("Select the field status ");
                return false;
            }
            var purcharse_dt = document.getElementById('txt_purcharse_dt').value;
            if (purcharse_dt == "") {
                alert("Enter purchase date");
                return false;
            }
            //var remarks = document.getElementById('txt_remarks').value;
            //if (remarks == "") {
            //    alert("Enter Remarks");
            //    return false;
            //}
            var delivery_dt = document.getElementById('txt_delivery_dt').value;
            if (delivery_dt == "") {
                alert("Enter Delivery Date ");
                return false;
            }
            var main_loc = document.getElementById('slct_main_loc').value;
            if (main_loc == "" || main_loc == "SELECT LOCATION") {
                alert("Select Main Location");
                return false;
            }
            var install_dt = document.getElementById('txt_install_dt').value;
            if (install_dt == "") {
                alert("Enter Installed Date ");
                return false;
            }
            var sub_loc = document.getElementById('slct_sub_loc').value;
            if (sub_loc == "" || sub_loc == "SELECT LOCATION") {
                alert("Select Sub Location");
                return false;
            }
            var install_by = document.getElementById('txt_install_by').value;
            if (install_by == "") {
                alert("Enter Installed By field");
                return false;
            }
            var cust_po = document.getElementById('txt_cust_po').value;
            if (cust_po == "") {
                alert("Enter Customer PO ");
                return false;
            }
            var price = document.getElementById('txt_price').value;
            if (price == "") {
                alert("Enter Price ");
                return false;
            }
            var depr = document.getElementById('txt_depr').value;
            if (depr == "") {
                alert("Enter Depreciation ");
                return false;
            }
            //var barcode = document.getElementById('txt_barcode').value;
            //if (barcode == "") {
            //    alert("Enter Barcode ");
            //    return false;
            //}
            var sku = document.getElementById('txt_sku').value;
            if (sku == "") {
                alert("Enter SKU ");
                return false;
            }
            var notes = document.getElementById('txt_notes').value;
            if (notes == "") {
                alert("Enter notes");
                return false;
            }
            var serial = document.getElementById('txt_serial').value;
            if (serial == "") {
                alert("Enter Serial No ");
                return false;
            }
            var model = document.getElementById('txt_model').value;
            if (model == "") {
                alert("Enter Model No ");
                return false;
            }
            var vendor = document.getElementById('slct_vendor').value;
            if (vendor == "" || vendor == "SELECT VENDOR") {
                alert("Select Vendor Name ");
                return false;
            }
            var sno = document.getElementById("lbl_sno").value;
            var btn_save = document.getElementById('btn_save').innerHTML;
            if (slct_type == "Computers") {
                var mother_board = document.getElementById('comp_mb').value;
                if (mother_board == "") {
                    alert("Enter Mother Board Name ");
                    return false;
                }
                var processor = document.getElementById('comp_pcr').value;
                if (processor == "") {
                    alert("Enter processor Name ");
                    return false;
                }
                var ram = document.getElementById('comp_ram').value;
                if (ram == "") {
                    alert("Enter RAM Details ");
                    return false;
                }
                var hard_disk = document.getElementById('comp_hd').value;
                if (hard_disk == "") {
                    alert("Enter Hard Disk Details ");
                    return false;
                }
                var dvd_writer = document.getElementById('comp_dvd').value;
                if (dvd_writer == "") {
                    alert("Enter DVD_Writer Details ");
                    return false;
                }
                var cabinet = document.getElementById('comp_cab').value;
                if (cabinet == "") {
                    alert("Enter Cabinet Details ");
                    return false;
                }
                var key_board = document.getElementById('comp_kd').value;
                if (key_board == "") {
                    alert("Enter Key Board Details ");
                    return false;
                }
                var mouse = document.getElementById('comp_mou').value;
                if (mouse == "") {
                    alert("Enter Mouse Name ");
                    return false;
                }
                var monitor = document.getElementById('comp_mon').value;
                if (monitor == "") {
                    alert("Enter Monitor Name ");
                    return false;
                }
                var connectivity = document.getElementById('comp_con').value;
                if (connectivity == "") {
                    alert("Enter Connectivity ");
                    return false;
                }
                var brand = document.getElementById('comp_brand').value;
                if (model == "") {
                    alert("Enter Brand ");
                    return false;
                }
                var os = document.getElementById('comp_os').value;
                if (os == "") {
                    alert("Enter Operating System ");
                    return false;
                }
                var antivirus = document.getElementById('comp_av').value;
                if (antivirus == "") {
                    alert("Enter Antivirus Name ");
                    return false;
                }
                var smps = document.getElementById('comp_smps').value;
                if (smps == "") {
                    alert("Enter SMPS Name ");
                    return false;
                }
                var printer = document.getElementById('comp_print').value;
                if (printer == "") {
                    alert("Enter Printer Name ");
                    return false;
                }
                var data = { 'op': 'save_asset_mgm', 'sno': sno, 'asset_name': asset_name, 'War_lic': War_lic, 'asset_code': asset_code, 'slct_type': slct_type, 'slct_maintain': slct_maintain, 'status': status, 'purcharse_dt': purcharse_dt, 'delivery_dt': delivery_dt, 'main_loc': main_loc, 'install_dt': install_dt, 'sub_loc': sub_loc, 'install_by': install_by, 'cust_po': cust_po, 'price': price, 'depr': depr, 'sku': sku, 'notes': notes, 'serial': serial, 'model': model, 'vendor': vendor, 'mother_board': mother_board, 'processor': processor, 'ram': ram, 'hard_disk': hard_disk, 'dvd_writer': dvd_writer, 'cabinet': cabinet, 'key_board': key_board, 'mouse': mouse, 'monitor': monitor, 'connectivity': connectivity, 'brand': brand, 'os': os, 'antivirus': antivirus, 'smps': smps, 'printer': printer, 'btn_save': btn_save };
            }
            else {
                var data = { 'op': 'save_asset_mgm', 'sno': sno, 'asset_name': asset_name, 'War_lic': War_lic, 'asset_code': asset_code, 'slct_type': slct_type, 'slct_maintain': slct_maintain, 'status': status, 'purcharse_dt': purcharse_dt, 'delivery_dt': delivery_dt, 'main_loc': main_loc, 'install_dt': install_dt, 'sub_loc': sub_loc, 'install_by': install_by, 'cust_po': cust_po, 'price': price, 'depr': depr, 'sku': sku, 'notes': notes, 'serial': serial, 'model': model, 'vendor': vendor, 'btn_save': btn_save };
            }
            
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        get_asset_mgm();
                        clear_asset_mgm();

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

        function get_asset_mgm() {
            var data = { 'op': 'get_asset_mgm' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fill_creditnote_tbl1(msg);

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

        function fill_creditnote_tbl1(msg) {
            var l = 0;
            //var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr class="trbgclrcls"><th scope="col"></th><th scope="col">Asset Name</th><th scope="col">War/Lic Exp. Date</th><th scope="col">Asset Code</th><th scope="col">Purchase Date</th><th scope="col">Type</th><th scope="col">Delivery Date</th><th scope="col">Main Location</th><th scope="col">Department</th><th scope="col">Installed Date</th><th scope="col">Installed By</th><th scope="col">Price</th><th scope="col">Maintenance Type</th><th scope="col">Status</th></tr></thead></tbody>';
            //if (comp_data == "Computers") {
                for (var i = 0; i < msg.length; i++) {
                    results += '<tr style="background-color:' + COLOR[l] + '">';//<td><input id="btn_poplate" type="button"  onclick="update1(this)" name="Edit" class="btn btn-primary" value="Edit" /></td>
                    results += '<td data-title="brandstatus"><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"  onclick="update1(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td>';
                    results += '<td data-title="Asset Name" class="1" >' + msg[i].asset_name + '</td>';
                    results += '<td data-title="War/Lic Exp. Date" class="2">' + msg[i].War_lic + '</td>';
                    results += '<td data-title="Asset Code" class="3">' + msg[i].asset_code + '</td>';
                    results += '<td data-title="Purchase Date" class="4">' + msg[i].purcharse_dt + '</td>';
                    results += '<td data-title="Type" class="5">' + msg[i].slct_type + '</td>';
                    
                    results += '<td data-title="Delivery Date" class="7">' + msg[i].delivery_dt + '</td>';
                    results += '<td data-title="Main Location" class="8">' + msg[i].main_loc + '</td>';
                    results += '<td  data-title="Department" class="11">' + msg[i].sub_loc + '</td>';
                    results += '<td style="display:none;" data-title="Main Location" class="23">' + msg[i].loc_id + '</td>';
                    results += '<td data-title="Installed Date" class="10">' + msg[i].install_dt + '</td>';
                    
                    results += '<td style="display:none;" data-title="Sub Location" class="24">' + msg[i].deptid + '</td>';
                    results += '<td  data-title="Installed By" class="12">' + msg[i].install_by + '</td>';
                    results += '<td data-title="Price" class="14">' + msg[i].price + '</td>';
                    results += '<td data-title="Maitenance Type" class="26">' + msg[i].slct_maintain + '</td>';
                    results += '<td  data-title="Status" class="6">' + msg[i].status + '</td>';
                    results += '<td style="display:none;" data-title="Customer PO" class="13">' + msg[i].cust_po + '</td>';
                    
                    results += '<td style="display:none;" data-title="Depreciation %" class="15">' + msg[i].depr + '</td>';
                    //results += '<td data-title="BarCode" class="16">' + msg[i].status + '</td>';
                    results += '<td style="display:none;" data-title="SKU" class="17">' + msg[i].sku + '</td>';
                    results += '<td style="display:none;" data-title="Vendor" class="18">' + msg[i].vendor + '</td>';
                    results += '<td  style="display:none;" data-title="Vendor" class="25">' + msg[i].vendor_id + '</td>';
                    results += '<td style="display:none;" data-title="Serial" class="19">' + msg[i].serial + '</td>';
                    results += '<td style="display:none;" data-title="Model" class="20">' + msg[i].model + '</td>';
                    results += '<td style="display:none;" data-title="Notes" class="21">' + msg[i].notes + '</td>';
                    results += '<td  style="display:none;" class="27">' + msg[i].mother_board + '</td>';
                    results += '<td  style="display:none;" class="28">' + msg[i].processor + '</td>';
                    results += '<td  style="display:none;" class="29">' + msg[i].ram + '</td>';
                    results += '<td  style="display:none;" class="30">' + msg[i].hard_disk + '</td>';
                    results += '<td  style="display:none;" class="31">' + msg[i].dvd_writer + '</td>';
                    results += '<td  style="display:none;" class="32">' + msg[i].cabinet + '</td>';
                    results += '<td  style="display:none;" class="33">' + msg[i].key_board + '</td>';
                    results += '<td  style="display:none;" class="34">' + msg[i].mouse + '</td>';
                    results += '<td  style="display:none;" class="35">' + msg[i].monitor + '</td>';
                    results += '<td  style="display:none;" class="36">' + msg[i].connectivity + '</td>';
                    results += '<td  style="display:none;" class="37">' + msg[i].brand + '</td>';
                    results += '<td  style="display:none;" class="38">' + msg[i].os + '</td>';
                    results += '<td  style="display:none;" class="39">' + msg[i].antivirus + '</td>';
                    results += '<td  style="display:none;" class="40">' + msg[i].smps + '</td>';
                    results += '<td  style="display:none;" class="41">' + msg[i].printer + '</td>';
                    results += '<td style="display:none;" data-title="sno" class="22">' + msg[i].sno + '</td></tr>';
                    l = l + 1;
                    if (l == 4) {
                        l = 0;
                    }
                }
            results += '</table></div>';
            $("#div_asset_mgm").html(results);
        }

        function update1(thisid) {
            scrollTo(0, 0);
            var asset_name = $(thisid).parent().parent().children('.1').html();
            var War_lic2 = $(thisid).parent().parent().children('.2').html();
            var War_lic1 = War_lic2.split('-');
            var War_lic = War_lic1[2] + '-' + War_lic1[1] + '-' + War_lic1[0];
            var asset_code = $(thisid).parent().parent().children('.3').html();
            var purcharse_dt2 = $(thisid).parent().parent().children('.4').html();
            var purcharse_dt1 = purcharse_dt2.split('-');
            var purcharse_dt = purcharse_dt1[2] + '-' + purcharse_dt1[1] + '-' + purcharse_dt1[0];
            var slct_type = $(thisid).parent().parent().children('.5').html(); //.toString[mm / dd / yyyy]
            if (slct_type == "Computers") {
                $("#comp_det").css("display", "block");
            }
            else {
                $("#comp_det").css("display", "none");
            }
            var slct_maintain = $(thisid).parent().parent().children('.26').html();
            var statuscode = $(thisid).parent().parent().children('.6').html();
            var delivery_dt2 = $(thisid).parent().parent().children('.7').html();
            var delivery_dt1 = delivery_dt2.split('-');
            var delivery_dt = delivery_dt1[2] + '-' + delivery_dt1[1] + '-' + delivery_dt1[0];
            var main_loc = $(thisid).parent().parent().children('.8').html();
            //var status = $(thisid).parent().parent().children('.9').html();
            var install_dt2 = $(thisid).parent().parent().children('.10').html();
            var install_dt1 = install_dt2.split('-');
            var install_dt = install_dt1[2] + '-' + install_dt1[1] + '-' + install_dt1[0];
            var sub_loc = $(thisid).parent().parent().children('.11').html();
            var install_by = $(thisid).parent().parent().children('.12').html();
            var cust_po = $(thisid).parent().parent().children('.13').html();
            var price = $(thisid).parent().parent().children('.14').html();
            var depr = $(thisid).parent().parent().children('.15').html();
            //var sno = $(thisid).parent().parent().children('.16').html();
            var sku = $(thisid).parent().parent().children('.17').html();
            var vendor = $(thisid).parent().parent().children('.18').html();
            var serial = $(thisid).parent().parent().children('.19').html();
            var model = $(thisid).parent().parent().children('.20').html();
            var notes = $(thisid).parent().parent().children('.21').html();
            var loc_id = $(thisid).parent().parent().children('.23').html();
            var deptid = $(thisid).parent().parent().children('.24').html();
            var vendor_id = $(thisid).parent().parent().children('.25').html();
            var mother_board = $(thisid).parent().parent().children('.27').html();
            var processor = $(thisid).parent().parent().children('.28').html();
            var ram = $(thisid).parent().parent().children('.29').html();
            var hard_disk = $(thisid).parent().parent().children('.30').html();
            var dvd_writer = $(thisid).parent().parent().children('.31').html();
            var cabinet = $(thisid).parent().parent().children('.32').html();
            var key_board = $(thisid).parent().parent().children('.33').html();
            var mouse = $(thisid).parent().parent().children('.34').html();
            var monitor = $(thisid).parent().parent().children('.35').html();
            var connectivity = $(thisid).parent().parent().children('.36').html();
            var brand = $(thisid).parent().parent().children('.37').html();
            var os = $(thisid).parent().parent().children('.38').html();
            var antivirus = $(thisid).parent().parent().children('.39').html();
            var smps = $(thisid).parent().parent().children('.40').html();
            var printer = $(thisid).parent().parent().children('.41').html();
            var sno = $(thisid).parent().parent().children('.22').html();

            if (statuscode == "InActive") {

                status = "0";
            }
            else {
                status = "1";
            }

            document.getElementById('txt_asset_name').value = asset_name;
            document.getElementById('txt_War_lic').value = War_lic;
            document.getElementById('txt_asset_code').value = asset_code;
            document.getElementById('txt_purcharse_dt').value = purcharse_dt;
            document.getElementById('slct_type').value = slct_type; 
            document.getElementById('slct_maintain').value = slct_maintain;
            document.getElementById('slct_status').value = status;
            document.getElementById('txt_delivery_dt').value = delivery_dt;
            document.getElementById('slct_main_loc').value = loc_id;
            document.getElementById('txt_install_dt').value = install_dt;
            document.getElementById('slct_sub_loc').value = deptid;
            document.getElementById('txt_install_by').value = install_by;
            document.getElementById('txt_cust_po').value = cust_po;
            document.getElementById('txt_price').value = price;
            document.getElementById('txt_depr').value = depr;
            document.getElementById('txt_sku').value = sku;
            document.getElementById('slct_vendor').value = vendor_id;
            document.getElementById('txt_serial').value = serial;
            document.getElementById('txt_model').value = model;
            document.getElementById('txt_notes').value = notes;
            document.getElementById('lbl_sno').value = sno;
            document.getElementById('comp_mb').value = mother_board;
            document.getElementById('comp_pcr').value = processor;
            document.getElementById('comp_ram').value = ram;
            document.getElementById('comp_hd').value = hard_disk;
            document.getElementById('comp_dvd').value = dvd_writer;
            document.getElementById('comp_cab').value = cabinet;
            document.getElementById('comp_kd').value = key_board;
            document.getElementById('comp_mou').value = mouse;
            document.getElementById('comp_mon').value = monitor;
            document.getElementById('comp_con').value = connectivity;
            document.getElementById('comp_brand').value = brand;
            document.getElementById('comp_os').value = os;
            document.getElementById('comp_av').value = antivirus;
            document.getElementById('comp_smps').value = smps;
            document.getElementById('comp_print').value = printer;
            document.getElementById('btn_save').innerHTML = "Modify";

        }

        function clear_asset_mgm() {
            scrollTo(0, 0);
            document.getElementById('txt_asset_name').value = "";
            document.getElementById('txt_War_lic').value = "";
            document.getElementById('txt_asset_code').value = "";
            document.getElementById('txt_purcharse_dt').value = "";
            document.getElementById('slct_type').selectedIndex = 0;
            document.getElementById('slct_maintain').selectedIndex = 0;
            document.getElementById('slct_status').selectedIndex = 0;
            //document.getElementById('txt_remarks').value = "";
            document.getElementById('txt_delivery_dt').value = "";
            document.getElementById('slct_main_loc').selectedIndex = 0;
            document.getElementById('txt_install_dt').value = "";
            document.getElementById('slct_sub_loc').selectedIndex = 0;
            document.getElementById('txt_install_by').value = "";
            document.getElementById('txt_cust_po').value = "";
            document.getElementById('txt_price').value = "";
            document.getElementById('txt_depr').value = "";
            //document.getElementById('txt_barcode').value = "";
            document.getElementById('txt_sku').value = "";
            document.getElementById('slct_vendor').selectedIndex = 0;
            document.getElementById('txt_serial').value = "";
            document.getElementById('txt_model').value = "";
            document.getElementById('txt_notes').value = "";
            document.getElementById('comp_mb').value = "";
            document.getElementById('comp_pcr').value = "";
            document.getElementById('comp_ram').value = "";
            document.getElementById('comp_hd').value = "";
            document.getElementById('comp_dvd').value = "";
            document.getElementById('comp_cab').value = "";
            document.getElementById('comp_kd').value = "";
            document.getElementById('comp_mou').value = "";
            document.getElementById('comp_mon').value = "";
            document.getElementById('comp_con').value = "";
            document.getElementById('comp_brand').value = "";
            document.getElementById('comp_os').value = "";
            document.getElementById('comp_av').value = "";
            document.getElementById('comp_smps').value = "";
            document.getElementById('comp_print').value = "";
            document.getElementById('btn_save').innerHTML = "Save";
            $("#comp_det").css("display", "none");
            //$("#lbl_code_error_msg").hide();
            //$("#lbl_name_error_msg").hide();
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            ASSET MANAGEMENT
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i></a></li>
            <li><a href="#">ASSET MANAGEMENT</a></li>
        </ol>
    </section>
    <section class="content">
            <div class="box box-info">
                <div id="div_Account">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>ASSET MANAGEMENT
                        </h3>
                    </div>
                    <div class="box-body">
                        <div id="div_Emp">
                        </div>
                        <div>
                        <div id='fillform' style="float:left;width:25%">
                            <table >
                                <tr>
                                    <th>
                                    </th>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            Asset Name</label>
                                        <input id="txt_asset_name" class="form-control" placeholder="Enter Asset Name" type="text"  name="asset_name"/>
                                    </td>
                                    <td style="width:5px;"></td>
                                    <td style="height: 40px;">
                                        <label>
                                            wrnty/lic.exp.date</label>
                                        <div class="input-group date">
                                          <div class="input-group-addon cal">
                                            <i class="fa fa-calendar"></i>
                                          </div>
                                          <input id="txt_War_lic" class="form-control" type="date" name="war_lic"/>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            Asset Code
                                        </label>
                                        <input id="txt_asset_code" class="form-control" placeholder="Enter Asset Code" type="text" name="asset_code"/>
                                    </td>
                                    <td style="width:5px;"></td>
                                     <td style="height: 40px;">
                                        <label>
                                            Delivery Date
                                        </label>
                                        <div class="input-group date">
                                          <div class="input-group-addon cal">
                                            <i class="fa fa-calendar"></i>
                                          </div>
                                          <input id="txt_delivery_dt" class="form-control" type="date" name="delivery_dt"/>
                                        </div>
                                    </td>
                               
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                           Asset Type
                                        </label>
                                        <select id="slct_type" class="form-control" onchange="computer_det();">
                                            <option value="">Select type</option>
                                            <option value="Electrical">Electrical</option>
                                            <option value="Mechanical">Mechanical</option>
                                            <option value="Computers">Computers</option>
                                            <option value="Civil">Civil</option>
                                            <option value="IT">IT</option>
                                            <option value="Furinture">Furinture</option>
                                            <option value="Electronics">Electronics</option>
                                        </select>
                                    </td>
                                    <td style="width:5px;"></td>
                                    <td style="height: 40px;">
                                        <label>
                                            Maintenance Type
                                        </label>
                                        <select id="slct_maintain" class="form-control">
                                            <option value="Select type">Select type</option>
                                            <option value="Predictive">Predictive</option>
                                            <option value="Preventive">Preventive</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            Status
                                        </label>
                                        <select id="slct_status" class="form-control">
                                            <option value="Select">Select</option>
                                            <option value="1">ACTIVE</option>
                                            <option value="0">INACTIVE</option>
                                        </select>
                                    </td>
                                    <td style="width:5px;"></td>
                                    <td style="height: 40px;">
                                        <label>
                                            Purchase Date
                                        </label>
                                        <div class="input-group date">
                                          <div class="input-group-addon cal">
                                            <i class="fa fa-calendar"></i>
                                          </div>
                                          <input id="txt_purcharse_dt" class="form-control" type="date" name="purchase_dt"/>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            Main Location
                                        </label>
                                        <select id="slct_main_loc" class="form-control">
                                            <option value="Select Loc">Select Loc</option>
                                        </select>
                                    </td>
                                    <td style="width:5px;"></td>
                                    <td style="height: 40px;">
                                        <label>
                                            Installed Date
                                        </label>
                                        <div class="input-group date">
                                          <div class="input-group-addon cal">
                                            <i class="fa fa-calendar"></i>
                                          </div>
                                          <input id="txt_install_dt" class="form-control" type="date" name="install_dt"/>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            Sub Location
                                        </label>
                                        <select id="slct_sub_loc" class="form-control">
                                            <option value="Select Loc">Select Loc</option>
                                        </select>
                                    </td>
                                    <td style="width:5px;"></td>
                                    <td style="height: 40px;">
                                        <label>
                                            Installed By
                                        </label>
                                        <input id="txt_install_by" class="form-control" placeholder="Enter Installed By" type="text" name="install_by"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            Customer PO
                                        </label>
                                        <input id="txt_cust_po" class="form-control" placeholder="Enter Customer PO" type="text" name="cust_po"/>
                                    </td>
                                    <td style="width:5px;"></td>
                                    <td style="height: 40px;">
                                        <label>
                                            Price
                                        </label>
                                        <input id="txt_price" class="form-control" placeholder="Enter Price" type="text" onkeypress="return isFloat(event)" name="price"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            Depreciation %
                                        </label>
                                        <input id="txt_depr" class="form-control" placeholder="Enter Depreciation %" type="text" onkeypress="return isFloat(event)" name="depreciation"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            SKU
                                        </label>
                                        <input id="txt_sku" class="form-control" placeholder="Enter SKU" type="text" name="sku"/>
                                    </td>
                                    <td style="width:5px;"></td>
                                    <td style="height: 40px;">
                                        <label>
                                            Vendor Name</label>
                                        <select id="slct_vendor" class="form-control">
                                            <option value="Select Vendor">Select Vendor</option>
                                        </select>
                                    </td>
                                </tr>
                               
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            Serial No</label>
                                        <input id="txt_serial" class="form-control" placeholder="Enter Serial No" type="text" />
                                    </td>
                                    <td style="width:5px;"></td>
                                    <td style="height: 40px;">
                                        <label>
                                            Model No</label>
                                        <input id="txt_model" class="form-control" placeholder="Enter Model No" type="text" />
                                    </td>
                                </tr>
                                 <tr >
                                     <td colspan="2" style="height: 40px;">
                                        <label>
                                            Remarks
                                        </label>
                                        <textarea id="txt_notes" rows="3" cols="50" placeholder="Remarks"></textarea>
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
                                        <%--<input id="btn_save" type="button" class="btn btn-primary" name="submit" value="Save" onclick="save_asset_mgm();"/>
                                        <input id="btn_clear" type="button" class="btn btn-danger" name="submit" value="RESET" onclick="clear_asset_mgm();"/>--%>
                                        <table>
                                           <tr>
                                            <td>
                                            <div class="input-group">
                                                <div class="input-group-addon">
                                                <span class="glyphicon glyphicon-ok" id="btn_save1" onclick="save_asset_mgm()"></span> <span id="btn_save" onclick="save_asset_mgm()">Save</span>
                                          </div>
                                          </div>
                                            </td>
                                            <td style="width:10px;"></td>
                                            <td>
                                             <div class="input-group">
                                                <div class="input-group-close">
                                                <span class="glyphicon glyphicon-remove" id='btn_clear1' onclick="clear_asset_mgm()"></span> <span id='btn_clear' onclick="clear_asset_mgm()">RESET</span>
                                          </div>
                                          </div>
                                            </td>
                                            </tr>
                                       </table>
                                    </td>
                                </tr>
                            </table>
                            </div>
                            <div id="comp_det" style= "float:right;width:20%">
                                <table>
                                
                                    <tr>
                                     <td style="height: 40px;">
                                        <label>
                                            Mother Board
                                        </label>
                                        <input type="text" id="comp_mb" placeholder="Enter Mother Board Name" class="form-control" />
                                    </td>
                                    </tr>

                                    <tr>
                                     <td style="height: 40px;">
                                        <label>
                                            Processor
                                        </label>
                                        <input type="text" id="comp_pcr" placeholder="Enter Processor Name" class="form-control" />
                                    </td>
                                    </tr>
                                    
                                    <tr>
                                     <td style="height: 40px;">
                                        <label>
                                            RAM
                                        </label>
                                        <input type="text" id="comp_ram" placeholder="Enter RAM" class="form-control" />
                                    </td>
                                    </tr>

                                    <tr>
                                     <td style="height: 40px;">
                                        <label>
                                            HARD DISK
                                        </label>
                                        <input type="text" id="comp_hd" placeholder="Enter Hard Disk Name" class="form-control" />
                                    </td>
                                    </tr>

                                    <tr>
                                     <td style="height: 40px;">
                                        <label>
                                            DVD Writer
                                        </label>
                                        <input type="text" id="comp_dvd" placeholder="Enter DVD Writer Name" class="form-control" />
                                    </td>
                                    </tr>

                                    <tr>
                                     <td style="height: 40px;">
                                        <label>
                                            Cabinet
                                        </label>
                                        <input type="text" id="comp_cab" placeholder="Enter Cabinet Name" class="form-control" />
                                    </td>
                                    </tr>

                                    <tr>
                                     <td style="height: 40px;">
                                        <label>
                                            Key Board
                                        </label>
                                        <input type="text" id="comp_kd" placeholder="Enter KeyBoard Name" class="form-control" />
                                    </td>
                                    </tr>

                                    <tr>
                                     <td style="height: 40px;">
                                        <label>
                                            Mouse
                                        </label>
                                        <input type="text" id="comp_mou" placeholder="Enter Mouse Name" class="form-control" />
                                    </td>
                                    </tr>

                                    <tr>
                                     <td style="height: 40px;">
                                        <label>
                                            Monitor
                                        </label>
                                        <input type="text" id="comp_mon" placeholder="Enter Moniter Name" class="form-control" />
                                    </td>
                                    </tr>

                                    <tr>
                                     <td style="height: 40px;">
                                        <label>
                                            Connectivity
                                        </label>
                                        <input type="text" id="comp_con" placeholder="Enter Connectivity Name" class="form-control" />
                                    </td>
                                    </tr>

                                    <tr>
                                     <td style="height: 40px;">
                                        <label>
                                            Brand
                                        </label>
                                        <input type="text" id="comp_brand" placeholder="Enter Brand Name" class="form-control" />
                                    </td>
                                    </tr>

                                    <tr>
                                     <td style="height: 40px;">
                                        <label>
                                            Operating System
                                        </label>
                                        <input type="text" id="comp_os" placeholder="Enter OS Name" class="form-control" />
                                    </td>
                                    </tr>

                                    <tr>
                                     <td style="height: 40px;">
                                        <label>
                                            Anti Virus
                                        </label>
                                        <input type="text" id="comp_av" placeholder="Enter Anti Virus Name" class="form-control" />
                                    </td>
                                    </tr>

                                    <tr>
                                     <td style="height: 40px;">
                                        <label>
                                            SMPS
                                        </label>
                                        <input type="text" id="comp_smps" placeholder="Enter SMPS Name" class="form-control" />
                                    </td>
                                    </tr>

                                    <tr>
                                     <td style="height: 40px;">
                                        <label>
                                            Printer
                                        </label>
                                        <input type="text" id="comp_print" placeholder="Enter Printer Name" class="form-control" />
                                    </td>
                                    </tr>
                                </table>
                            </div>
                            
                            </div>
                           
                        </div>
                    <div id="div_asset_mgm">
                            </div>
                    </div>
        </section>
</asp:Content>

