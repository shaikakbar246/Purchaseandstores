<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true"
    CodeFile="ReturnableMaterial.aspx.cs" Inherits="MaterialInternaluse" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            //  get_purchase_details();
            GetFixedrows();
            get_Branch_details();
            get_section_details();
            get_productcode();
            get_Returnble_Material_details();

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
            scrollTo(0, 0);
        });
        function canceldetails() {
            $("#div_Returnable").show();
            $("#Returnable_FillForm").hide();
            $('#showlogs').show();
            forclearall();

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
        function canceldetails() {
            $("#div_Returnable").show();
            $("#Returnable_FillForm").hide();
            $('#showlogs').show();
            forclearall();
        }
        function GetFixedrows() {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="returntabledetails">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Quantity</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 1; i < 11; i++) {
                results += '<tr><td scope="row" class="1" id="txtsno">' + i + '</td>';
                results += '<td ><input id="txtproductname" type="text" class="clsproduct" placeholder= "Enter Product" style="width:90px;" /></td>';
                results += '<td ><input id="txt_quantity" type="text" class="quantity" placeholder="Enter Qty"  style="width:90px;"/></td>';
                results += '<td style="display:none"><input id="hdnproductsno" type="hidden" /></td>';
                results += '<td data-title="Minus"><span><img src="images/minus.png" onclick="removerow(this)" style="cursor:pointer"/></span></td>';
                results += '<td style="display:none" class="4">' + i + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_Returnable_Products").html(results);
        }

        function Save_ReturnableMaterial() {
            var name = document.getElementById('txtName').value;
            var issudate = document.getElementById('txtDate').value;
            var ddltype = document.getElementById('ddltype').value;
            var ddlname = document.getElementById('ddlname').value;
            var others = document.getElementById('browserother').value;
            var issueremarks = document.getElementById('txtremarks').value;
            if (name == "") {

                alert("Enter  Name");
                return false;
            }
            if (issueremarks == "") {

                alert("Enter  issueremarks");
                return false;
            }
            var sno = document.getElementById('lbl_sno').value;
            var btnval = document.getElementById('btn_save').innerHTML;
            var status = "P";
            var fillreturn = [];
            $('#returntabledetails> tbody > tr').each(function () {
                var txtsno = $(this).find('#txtSno').text();
                var productname = $(this).find('#txtproductname').val();
                var qty = $(this).find('#txt_quantity').val();
                var subsno = $(this).find('#txt_sub_sno').val();
                var hdnproductsno = $(this).find('#hdnproductsno').val();
                if (hdnproductsno == "" || hdnproductsno == "0") {
                }
                else {
                    fillreturn.push({ 'txtsno': txtsno, 'productname': productname, 'quantity': qty, 'hdnproductsno': hdnproductsno, 'subsno': subsno });
                }
            });
            if (fillreturn.length == 0) {
                alert("Please Select Product Names");
                return false;
            }
            var Data = { 'op': 'saveInternalDetails', 'others': others, 'name': name, 'type': ddltype, 'dname': ddlname, 'issudate': issudate, 'btnVal': btnval, 'status': status, 'sno': sno, 'issueremarks': issueremarks, 'fillreturn': fillreturn };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        GetFixedrows();
                        get_Returnble_Material_details();
                        $('#div_Returnable').show();
                        $('#Returnable_FillForm').css('display', 'none');
                        $('#showlogs').css('display', 'block');
                        forclearall();
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            CallHandlerUsingJson(Data, s, e);
        }

        function Show_Returnable_Design() {
            $("#div_Returnable").hide();
            $("#Returnable_FillForm").show();
            $('#showlogs').hide();
            scrollTo(0, 0);
            // forclearall();
        }
        function forclearall() {
            document.getElementById('txtName').value = "";
            document.getElementById('txtDate').value = "";
            document.getElementById('ddlname').selectedIndex = 0;
            document.getElementById('ddltype').selectedIndex = 0;
            document.getElementById('lbl_sno').value = "";
            document.getElementById('txtremarks').value = "";

            document.getElementById('btn_save').innerHTML = "Save";
            $("#lbl_code_error_msg").hide();
            $("#lbl_name_error_msg").hide();
            scrollTo(0, 0);
        }

        function ddltypechange() {
            var type = document.getElementById('ddltype').value
            if (type == "Branch") {
                get_Branch_details();
            }
            if (type == "Section") {
                get_section_details();
            }

            if (type == "Others") {
                //            $('#browserother').css('display', 'table-row');
                //            $('#ddlname').css('display', 'none');
                $('#browserother').show();
                $('#ddlname').hide();
            }
            else {
                $('#browserother').hide();
                $('#ddlname').show();
                //            $('#browserother').css('display', 'none');
                //            $('#ddlname').css('display', 'table-row');
            }
        }


        function get_Branch_details() {
            var data = { 'op': 'get_Branch_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillbranches(msg);
                        //fillbranches1(msg);
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
        function fillbranches(msg) {
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
                if (msg[i].branchname != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].branchname;
                    option.value = msg[i].branchid;
                    data.appendChild(option);
                }

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
        function get_productcode() {
            var data = { 'op': 'get_branchwiseproduct_details' };
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
                var productname = msg[i].productname;
                compiledList.push(productname);
            }

            $('.clsproduct').autocomplete({
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
                        $(this).closest('tr').find('#hdnproductsno').val(filldescrption[i].productid);
                        emptytable.push(name);
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
        //    var productdetails = [];
        //    function getcode() {
        //        var data = { 'op': 'get_Poraise' };
        //        var s = function (msg) {
        //            if (msg) {
        //                productdetails = msg;
        //                var availableTags = [];
        //                for (i = 0; i < msg.length; i++) {
        //                    availableTags.push(msg[i].productname);
        //                }
        //                $(".clsproduct").autocomplete({
        //                    source: function (req, responseFn) {
        //                        var re = $.ui.autocomplete.escapeRegex(req.term);
        //                        var matcher = new RegExp("^" + re, "i");
        //                        var a = $.grep(availableTags, function (item, index) {
        //                            return matcher.test(item);
        //                        });
        //                        responseFn(a);
        //                    },
        //                    change: productchange,
        //                    autoFocus: true
        //                });
        //            }
        //        }
        //        var e = function (x, h, e) {
        //            alert(e.toString());
        //        };
        //        callHandler(data, s, e);
        //    }
        //    function productchange() {
        //        var name = document.getElementById('txtproductname').value;
        //        for (var i = 0; i < productdetails.length; i++) {
        //            if (name == productdetails[i].productname) {
        //                document.getElementById('txtprductid').value = productdetails[i].productid;
        //            }
        //        }
        //    }

        function get_Poraise() {
            var data = { 'op': 'get_Poraise' };
            var s = function (msg) {
                if (msg) {
                    if (msg.i > 0) {
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


        function get_Returnble_Material_details() {
            var data = { 'op': 'get_Returnable_Material_data' };
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
        var retundetails = [];
        var sub_returndetails = [];
        function filldetails(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" >';
            results += '<thead><tr class="trbgclrcls"><th scope="col">Name</th><th scope="col">Issued Date</th><th scope="col">Issue Remarks</th><th scope="col"></th></tr></thead></tbody>';
            retundetails = msg[0].tools_issue_receive;
            sub_returndetails = msg[0].subtools_issue_receive;
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            for (var i = 0; i < retundetails.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">';//<td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="Edit" /></td>
                results += '<th scope="row" class="1" style="text-align:center;">' + retundetails[i].name + '</th>';
                results += '<td style="display:none" class="3">' + retundetails[i].dname + '</td>';
                //            results += '<td  class="4">' + msg[i].productname + '</td>';
                results += '<td data-title="issudate" class="2">' + retundetails[i].issudate + '</td>';
                results += '<td style="display:none" class="5">' + retundetails[i].sno + '</td>';
                results += '<td  class="6">' + retundetails[i].issueremarks + '</td>';
                results += '<td style="display:none" class="9">' + retundetails[i].type + '</td>';
                results += '<td style="display:none" class="10">' + retundetails[i].Others + '</td>';
                results += '<td data-title="brandstatus"><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"  onclick="getme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td>';
                results += '<td style="display:none"  style="sectionname" class="8">' + retundetails[i].hiddenid + '</td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_Returnable").html(results);
        }
        function getme(thisid) {
            scrollTo(0, 0);
            ddltypechange();
            var name = $(thisid).parent().parent().children('.1').html();
            var issudate2 = $(thisid).parent().parent().children('.2').html();
            var dname = $(thisid).parent().parent().children('.3').html();
            //        var productname = $(thisid).parent().parent().children('.4').html();
            var hiddeproductid = $(thisid).parent().parent().children('.7').html();
            var sno = $(thisid).parent().parent().children('.5').html();
            var hiddenid = $(thisid).parent().parent().children('.8').html();
            var Others = $(thisid).parent().parent().children('.10').html();
            var issueremarks = $(thisid).parent().parent().children('.6').html();
            var type = $(thisid).parent().parent().children('.9').html();
            //        var qty = $(thisid).parent().parent().children('.11').html();

            if (type == "Others") {
                $('#browserother').show();
                $('#ddlname').hide();
            }
            else {
                $('#browserother').hide();
                $('#ddlname').show();
                if (type == "Branch") {
                    get_Branch_details();
                }
                else if (type == "Section") {
                    get_section_details();
                }
            }

            var issudate1 = issudate2.split('-');
            var issudate = issudate1[2] + '-' + issudate1[1] + '-' + issudate1[0];

            document.getElementById('ddltype').value = type;
            if (type == "Others") {
                document.getElementById("browserother").value = dname;
            }
            else {
                if (type == "Branch") {
                    document.getElementById("ddlname").value = hiddenid
                }
                else if (type == "Section") {
                    document.getElementById("ddlname").value = hiddenid
                }
            }
            //document.getElementById('ddlname').value = hiddenid;
            //        document.getElementById('txtQuantity').value = qty;
            document.getElementById('txtName').value = name;
            document.getElementById('txtDate').value = issudate;
            //        document.getElementById('txtproductname').value = productname;
            document.getElementById('txtremarks').value = issueremarks;
            document.getElementById('txtprductid').value = hiddeproductid;
            document.getElementById('lbl_sno').value = sno;
            document.getElementById('btn_save').innerHTML = "Modify";
            $("#div_Returnable").hide();
            $("#Returnable_FillForm").show();
            $('#showlogs').hide();
            var table = document.getElementById("tabledetails");
            var results = '<div  style="overflow:auto;"><table id="returntabledetails" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Qty</th><th scope="col"></th></tr></thead></tbody>';
            var k = 1;
            for (var i = 0; i < sub_returndetails.length; i++) {
                if (sno == sub_returndetails[i].subsno) {
                    results += '<tr><td data-title="Sno" class="1">' + k + '</td>';
                    results += '<th data-title="From"><input id="txtproductname" readonly class="clsproduct"  name="productname" value="' + sub_returndetails[i].productname + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<th data-title="From"><input class="quantity" id="txt_quantity" onkeypress="myFunction()" name="Quantity" value="' + sub_returndetails[i].quantity + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<th data-title="From"><input class="6" id="hdnproductsno" type="hidden" name="hdnproductsno" value="' + sub_returndetails[i].hdnproductsno + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input>';
                    results += '<th style="display:none"><input class="7" id="txt_sub_sno" type="hidden" name="subsno" value="' + sub_returndetails[i].sno + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input>';
                    results += '<td data-title="Minus"><span><img src="images/minus.png" onclick="removerow(this)" style="cursor:pointer"/></span></td>';
                    results += '<th data-title="From" style="display:none"><input class="7" id="txt_sub_sno" name="txt_sub_sno" value="' + sub_returndetails[i].sno + '"style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td></tr>';
                    k++;
                }
            }
            results += '</table></div>';
            $("#div_Returnable_Products").html(results);
        }
        function removerow(thisid) {
            $(thisid).parents('tr').remove();
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Returnable Material
        </h1>
   <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operation</a></li>
            <li><a href="#"> Returnable Material</a></li>
        </ol> 
  </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i> Returnable Material Details
                </h3>
            </div>
            <div class="box-body">
                <div id="showlogs" align="center">
                    <%--<input id="btn_Returnable" type="button" name="submit" value='Returnable Material' class="btn btn-primary" onclick="Show_Returnable_Design()" />--%>
                    <div class="input-group" style="padding-left:84%">
                        <div class="input-group-addon">
                            <span class="glyphicon glyphicon-plus-sign" onclick="Show_Returnable_Design()"></span> <span id="btn_Returnable" onclick="Show_Returnable_Design()" >Returnable Material</span>
                        </div>
                    </div>
                </div>
                <div id="div_Returnable" style="padding-top:2px;">
                </div>
                <div id='Returnable_FillForm' style="display: none;">
                   <table align="center" style="width: 60%;">
                        <tr>
                            <th>
                            </th>
                        </tr>
                        <tr>
                            <td style="height:40px;">
                             <label>Name</label><span style="color: red;">*</span>
                            </td>
                            <td>
                                <input id="txtName" type="text"  class="form-control" name="vendorcode"
                                    placeholder="Enter  Name" onKeyPress="return ValidateAlpha(event);"/><label id="lbl_code_error_msg" class="errormessage">* Please Enter
                                        Name</label>
                            </td>
                            <td style="width:5px"></td>
                            <td style="height:40px;">
                             <label>Date</label><span style="color: red;">*</span>     
                            </td>
                            <td>
                                <div class="input-group date" style="width:100%;">
                                  <div class="input-group-addon cal">
                                    <i class="fa fa-calendar"></i>
                                  </div>
                                  <input id="txtDate" type="date"  name="Date" class="form-control"/>
                                </div>
                            </td>
                      </tr>
                       <tr>
                            <td style="height:40px;">
                               <label>Type</label><span style="color: red;">*</span>     
                            </td>
                            <td style="height: 40px;">
                                <select id="ddltype" class="form-control"  onchange="ddltypechange();">
                                    <option value="Select Type" disabled selected>Select Type</option>
                                    <option value="Branch">Branch</option>
                                    <option value="Section">Section</option>
                                    <option value="Others">Others</option>
                                </select>
                         
                            </td>
                            <td style="width:5px"></td>
                            <td style="height:40px;">
                             <label>Name</label><span style="color: red;">*</span>     
                            </td>
                            <td style="height: 40px;">
                                <select id="ddlname" class="form-control">
                                </select>
                                <input id="browserother" name="Other Browser" class="form-control" type="text" placeholder="Enter Others"  style="display:none;" />
                            </td>
                            <td>
                            </td>
                        </tr>
                      <tr>
                           <td style="height:40px;">
                             <label>Remarks</label><span style="color: red;"></span>
                            </td>
                            <td colspan="4">
                                <textarea id="txtremarks" class="form-control" type="text" rows="4" cols="45" placeholder="Enter Remarks Specification"></textarea>
                            </td>  
                      </tr>
                      <tr style="display:none;">
                        <td >
                        <label id="lbl_sno"></label>
                        </td>
                          <td style="height: 40px;">
                                <input id="txtprductid" type="hidden" class="form-control" name="hiddeproductid" />
                            </td>
                            <td style="height: 40px;">
                            <input id="txtsupid" type="hidden" class="form-control" name="hiddensupplyid" />
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
                            <div id="div_Returnable_Products">
                            </div>
                        </div>
                    </div>
                    <div id="">
                    </div>
                    <table align="center">
                      <tr>
                           <td colspan="2" align="center" style="height:40px;">
                                <%--<input id="btn_save" type="button" class="btn btn-primary" name="submit" value='Save' onclick="Save_ReturnableMaterial()" />
                                <input id='btn_close' type="button" class="btn btn-danger" name="Close" value='Close' onclick="canceldetails()" />--%>
                                <table>
                                   <tr>
                                    <td>
                                    <div class="input-group">
                                        <div class="input-group-addon">
                                        <span class="glyphicon glyphicon-ok" id="btn_save1" onclick="Save_ReturnableMaterial()"></span> <span id="btn_save" onclick="Save_ReturnableMaterial()">Save</span>
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
           </div> 
        </div>           
   </section>
</asp:Content>
