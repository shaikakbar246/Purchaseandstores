<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true"
    CodeFile="StockRepair.aspx.cs" Inherits="StockRepair" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">

        $(function () {
            $('#btn_addDept').click(function () {
                $('#fillform').css('display', 'block');
                $('#showlogs').css('display', 'none');
                $('#div_stockrepair').hide();
                GetFixedrows();
                get_productcode();
                //get_Poraise();
                scrollTo(0, 0);
            });
            $('#close_vehmaster').click(function () {
                $('#fillform').css('display', 'none');
                $('#showlogs').css('display', 'block');
                $('#div_stockrepair').show();
                forclearall();
            });
            get_Stock_Repair_details();
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
            $('#txtDate').val(yyyy + '-' + mm + '-' + dd);
            $('#txtEdate').val(yyyy + '-' + mm + '-' + dd);
            scrollTo(0, 0);
            emptytable = [];
        });

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
        function GetFixedrows() {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr><th scope="col" style="text-align:center;">Sno</th><th scope="col">Product Name</th><th scope="col">Quantity</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 1; i < 11; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + i + '</td>';
                results += '<td ><input id="txtproductname" type="text" class="productcls" placeholder= "Enter Product" style="width:90px;" /></td>';
                results += '<td ><input id="txt_quantity" type="text" class="quantity" placeholder="Enter Qty" onkeypress="return isFloat(event)" style="width:90px;"/></td>';
                results += '<td style="display:none"><input id="hdnproductsno" type="hidden" /></td>';
                results += '<td data-title="Minus"><span><img src="images/minus.png" onclick="removerow(this)" style="cursor:pointer"/></span></td>';
                //results += '<th ><input id="txtEd" type="text" calss="form-control" style="width:50px;"/></th>';
                results += '<td style="display:none" class="4">' + i + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
        }
        function removerow(thisid) {
            $(thisid).parents('tr').remove();
        }
        var productdetails = [];
        function get_productcode() {
            var data = { 'op': 'get_Poraise' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        productdetails = msg;
                        filldata(msg);
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
                change: productchange,
                autoFocus: true
            });
        }
        var emptytable = [];
        function productchange() {
            var name = $(this).val();
            var checkflag = true;
            if (emptytable.indexOf(name) == -1) {
                for (var i = 0; i < productdetails.length; i++) {
                    if (name == productdetails[i].productname) {
                        $(this).closest('tr').find('#hdnproductsno').val(productdetails[i].productid);
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
        var fillstock = [];
        function save_stock_repair_click() {
            var name = document.getElementById('txtName').value;
            var doe = document.getElementById('txtDate').value;
            var expdate = document.getElementById('txtEdate').value;
            var remarks = document.getElementById('txtremarks').value;
            if (name == "") {
                alert("Please select  name");
                return false;
            }
            if (doe == "") {
                alert("Please select doe");
                return false;
            }
            if (expdate == "") {
                alert("Please select expdate");
                return false;
            }
            var btnval = document.getElementById('btn_save').innerHTML;
            var sno = document.getElementById('lbl_sno').value;
            $('#tabledetails> tbody > tr').each(function ()
            {
                var txtsno = $(this).find('#txtSno').text();
                var productname = $(this).find('#txtproductname').val();
                var quantity = $(this).find('#txt_quantity').val();
                var subsno = $(this).find('#txt_sub_sno').val();
                var hdnproductsno = $(this).find('#hdnproductsno').val();
                if (hdnproductsno == "" || hdnproductsno == "0") {
                }
                else {
                    fillstock.push({ 'txtsno': txtsno, 'productname': productname, 'quantity': quantity, 'hdnproductsno': hdnproductsno, 'subsno': subsno });
                }
            });
            if (fillstock.length == 0) {
                alert("Please Select Product Names");
                return false;
            }
            var Data = { 'op': 'save_stock_repair_click', 'name': name, 'doe': doe, 'expdate': expdate, 'remarks': remarks, 'btnval': btnval, 'fillstock': fillstock,'sno':sno };
            var s = function (msg) {
                if (msg) {
                    alert(msg);
                    get_Stock_Repair_details();
                    $('#div_stockrepair').css('display', 'block');
                    $('#fillform').css('display', 'none');
                    GetFixedrows();
                    get_productcode();
                    forclearall();
                }
            }
            var e = function (x, h, e) {
            };
            CallHandlerUsingJson(Data, s, e);
        }
        function get_Stock_Repair_details() {
            var data = { 'op': 'get_Stock_Repair_details' };
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
        var sub_Stock_Repair_list = [];
        function filldetails(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" >';
            results += '<thead><tr class="trbgclrcls"><th scope="col">Name</th><th scope="col">Doe</th><th scope="col">Expected Date</th><th scope="col">Remarks</th><th scope="col"></th></tr></thead></tbody>';
            var stockrepairdetailes = msg[0].stockrepairdetails;
            sub_Stock_Repair_list = msg[0].stockrepairsubdetails;
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            for (var i = 0; i < stockrepairdetailes.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">';//<td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="EDIT" /></td>
                results += '<td scope="row" class="1" style="text-align:center;">' + stockrepairdetailes[i].name + '</td>';
                results += '<td data-title="sectioncolor" class="2">' + stockrepairdetailes[i].doe + '</td>';
                results += '<td data-title="sectionstatus" class="3">' + stockrepairdetailes[i].expdate + '</td>';
                //results += '<td style="display:none" class="4">' + msg[i].entryby + '</td>';
                results += '<td  class="4">' + stockrepairdetailes[i].remarks + '</td>';
                results += '<td data-title="brandstatus"><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls" style="background: #f44336 !important;border-radius: 100% !important;padding:0px !important;height:30px !important;width:30px !important;color: #ffffff !important;border-color: #f44336 !important;"  onclick="getme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td>';
                results += '<td style="display:none" class="5">' + stockrepairdetailes[i].sno + '</td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_stockrepair").html(results);
        }
        function getme(thisid) {
            scrollTo(0, 0);
            $('#fillform').css('display', 'block');
            $('#showlogs').css('display', 'none')
            $('#div_stockrepair').hide();
            var name = $(thisid).parent().parent().children('.1').html();
            var doe2 = $(thisid).parent().parent().children('.2').html();
            var expdate2 = $(thisid).parent().parent().children('.3').html();
            var remarks = $(thisid).parent().parent().children('.4').html();
            var sno = $(thisid).parent().parent().children('.5').html();

            var doe1 = doe2.split('-');
            var doe = doe1[2] + '-' + doe1[1] + '-' + doe1[0];

            var expdate1 = expdate2.split('-');
            var expdate = expdate1[2] + '-' + expdate1[1] + '-' + expdate1[0];

            document.getElementById('txtName').value = name;
            document.getElementById('txtDate').value = doe;
            document.getElementById('txtEdate').value = expdate;
            document.getElementById('txtremarks').value = remarks;
            document.getElementById('lbl_sno').value = sno;
            document.getElementById('btn_save').innerHTML = "Modify";
            var table = document.getElementById("tabledetails");
            var results = '<div  style="overflow:auto;"><table id="tabledetails" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr><th scope="col" style="text-align:center;">Sno</th><th scope="col">Product Name</th><th scope="col">Quantity</th><th scope="col"></th></tr></thead></tbody>';
            var k = 1;
            for (var i = 0; i < sub_Stock_Repair_list.length; i++) {
                if (sno == sub_Stock_Repair_list[i].stock_refno) {
                    results += '<tr><td data-title="Sno" class="1">' + k + '</td>';
                    results += '<th data-title="From"><input id="txtproductname" readonly class="productcls"  name="productname" value="' + sub_Stock_Repair_list[i].productname + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<th data-title="From"><input class="quantity" id="txt_quantity" onkeypress="myFunction()" name="Quantity" value="' + sub_Stock_Repair_list[i].quantity + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<th style="display:none"><input class="6" id="hdnproductsno" type="hidden" name="hdnproductsno" value="' + sub_Stock_Repair_list[i].hdnproductsno + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input>';
                    //results += '<th data-title="From"><input class="7" id="txt_sub_sno" type="hidden" name="subsno" value="' + sub_Stock_Repair_list[i].subsno + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input>';
                    results += '<td data-title="Minus"><span><img src="images/minus.png" onclick="removerow(this)" style="cursor:pointer"/></span></td>';
                    results += '<th data-title="From" style="display:none"><input class="7" id="txt_sub_sno" name="txt_sub_sno" value="' + sub_Stock_Repair_list[i].subsno + '"style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td></tr>';
                    k++;
                }
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
        }
        function forclearall() {
            scrollTo(0, 0);
            document.getElementById('txtName').value = "";
            document.getElementById('txtDate').value = "";
            document.getElementById('txtEdate').value = "";
            document.getElementById('txtremarks').value = "";
            document.getElementById('btn_save').innerHTML = "Save";
            //get_purchaseorder_details();
        }
    
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Stock Repair
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operation</a></li>
            <li><a href="#">Stock Repair </a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Stock Repair Details
                </h3>
            </div>
            <div class="box-body">
                <div id="showlogs" align="center">
                    <%--<input id="btn_addDept" type="button" name="submit" value='Stock Repair' class="btn btn-primary" />--%>
                    <div class="input-group" style="padding-left:88%">
                        <div class="input-group-addon">
                            <span class="glyphicon glyphicon-plus-sign"></span> <span id="btn_addDept">Stock Repair</span>
                        </div>
                    </div>
                </div>
                <div id="div_stockrepair" style="padding-top:2px;">
                </div>
                <div id='fillform' style="display: none;">
                    <table align="center" style="width: 60%;">
                        <tr>
                            <td style="height: 40px;">
                                <label>Name</label><span style="color: red;">*</span>
                            </td>
                            <td>
                                <input id="txtName" type="text" maxlength="45" class="form-control" name="vendorcode"
                                    placeholder="Enter  Name" onkeypress="return ValidateAlpha(event);" /><label id="lbl_code_error_msg"
                                        class="errormessage">* Please Enter Name</label>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>Date</label><span style="color: red;">*</span>
                            </td>
                            <td>
                                <div class="input-group date" style="width:100%;">
                                  <div class="input-group-addon cal">
                                    <i class="fa fa-calendar"></i>
                                  </div>
                                  <input type="date" id='txtDate' class="form-control" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>Expected Date</label><span style="color: red;">*</span>
                            </td>
                            <td>
                                <div class="input-group date" style="width:100%;">
                                  <div class="input-group-addon cal">
                                    <i class="fa fa-calendar"></i>
                                  </div>
                                  <input type="date" id='txtEdate' class="form-control" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>Remarks</label><span style="color: red;"></span>
                            </td>
                            <td>
                                <textarea id="txtremarks" class="form-control" type="text" rows="4" cols="45" placeholder="Enter Remarks"></textarea>
                            </td>
                        </tr>
                        <tr style="display: none;">
                            <td style="height: 40px;">
                                <input id="txtprductid" type="hidden" class="form-control" name="hiddeproductid" />
                            </td>
                        </tr>
                    </table>
                    <br />
                    <label id="lbl_sno" style="display: none;">
                    </label>
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
                    <div id="">
                    </div>
                    <table align="center">
                        <tr>
                            <td>
                                <%--<input type="button" class="btn btn-primary" id="btn_save" value="Save" onclick="save_stock_repair_click();" />
                                <input type="button" class="btn btn-danger" id="close_vehmaster" value="Close" />--%>
                                <table>
                                   <tr>
                                    <td>
                                    <div class="input-group">
                                        <div class="input-group-addon">
                                        <span class="glyphicon glyphicon-ok" id="btn_save1" onclick="save_stock_repair_click()"></span> <span id="btn_save" onclick="save_stock_repair_click()">Save</span>
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
    </section>
</asp:Content>
