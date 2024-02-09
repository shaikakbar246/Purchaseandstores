<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true"
    CodeFile="QualityCheck.aspx.cs" Inherits="QualityCheck" %>

<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        
        $(function () {
            scrollTo(0, 0);
            $('#add_Inward').click(function () {
                $('#QualityCheck_fillform').css('display', 'block');
                $('#showlogs').css('display', 'none');
                $('#div_QualityCheck').hide();
                scrollTo(0, 0);
            });
            $('#close_stock_sales').click(function () {
                $('#QualityCheck_fillform').css('display', 'none');
                $('#showlogs').css('display', 'block');
                $('#div_QualityCheck').show();
                scrollTo(0, 0);
            });
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
            $('#txtinwardDate').val(yyyy + '-' + mm + '-' + dd);
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
        function inwardnumber(txtinwardno) {
            var sno = document.getElementById('txtinwardno').value;
            var data = { 'op': 'get_quality_check_inward_number', 'sno': sno };
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
            //barcode();
            var inward_sub = msg[0].SubInward;
            var inward = msg[0].InwardDetails;
            //datatable = msg;
            var sno = document.getElementById('txtinwardno').value;
            var results = '<div  style="overflow:auto;"><table ID="tabledetails" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" id= tabledetails >';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Quantity</th></tr></thead></tbody>';
            var j = 1;
            for (var i = 0; i < inward.length; i++) {
                if (sno == inward[i].sno) {
                    document.getElementById('txtinwardDate').value = inward[i].inwarddate;
                    for (var i = 0; i < inward_sub.length; i++) {
                        results += '<tr><td data-title="Sno" class="1">' + j + '</td>';
                        results += '<th data-title="From"><input id="txtProductname" readonly class="productcls"  name="productname" value="' + inward_sub[i].productname + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                        results += '<th data-title="From"><input class="quantity"  id="txt_quantity" onkeypress="return isFloat(event)" name="Quantity" value="' + inward_sub[i].quantity + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                        results += '<th data-title="From"><input class="5" id="hdnproductsno" type="hidden" name="hdnproductsno" value="' + inward_sub[i].hdnproductsno + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input>';
                        results += '<td style="display:none" class="6">' + i + '</td></tr>';
                        j++;
                    }
                }
            }
            results += '</table></div>';
            $("#Quality_Products").html(results);
        }

//        var productdetails = [];
//        function get_productcode() {
//            var data = { 'op': 'get_Poraise' };
//            var s = function (msg) {
//                if (msg) {
//                    if (msg.length > 0) {
//                        productdetails = msg;
//                        filldata(msg);
//                    }
//                    else {
//                    }
//                }
//                else {
//                }
//            };
//            var e = function (x, h, e) {
//            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
//            callHandler(data, s, e);
//        }

//        function filldata(msg) {
//            var compiledList = [];
//            for (var i = 0; i < msg.length; i++) {
//                var name = msg[i].productname;
//                compiledList.push(name);
//            }

//            $('.productcls').autocomplete({
//                source: compiledList,
//                change: productchange,
//                autoFocus: true
//            });
//        }
//        var emptytable = [];
//        function productchange() {
//            var name = $(this).val();
//            var checkflag = true;
//            if (emptytable.indexOf(name) == -1) {
//                for (var i = 0; i < productdetails.length; i++) {
//                    if (name == productdetails[i].productname) {
//                        $(this).closest('tr').find('#hdnproductsno').val(productdetails[i].productid);
//                        emptytable.push(name);
//                    }
//                }
//            }
//            else {
//                alert("Product Name already added");
//                var empt = "";
//                $(this).val(empt);
//                $(this).focus();
//                return false;
//            }
//        }

        var fillitems = [];
        function Save_Quality_Check_Product() {
            var inwardno = document.getElementById('txtinwardno').value;
            var inwarddate = document.getElementById('txtinwardDate').value;
            var remarks = document.getElementById('txtremarks').value;
            if (inwardno == "") {
                alert("Please select  inwardno");
                return false;
            }
            if (inwarddate == "") {
                alert("Please select inwarddate");
                return false;
            }
            var btnval = document.getElementById('btn_save').value;
            $('#tabledetails> tbody > tr').each(function () {
                var txtsno = $(this).find('#txtSno').text();
                var productname = $(this).find('#txtproductname').val();
                var quantity = $(this).find('#txt_quantity').val();
                //var sno = $(this).find('#txt_sub_sno').val();
                //var hiddeproductid = document.getElementById('txtprductid').value;
                var hdnproductsno = $(this).find('#hdnproductsno').val();
                if (hdnproductsno == "" || hdnproductsno == "0") {
                }
                else {
                    fillitems.push({ 'txtsno': txtsno, 'productname': productname, 'quantity': quantity, 'hdnproductsno': hdnproductsno });
                }
            });
            
            var Data = { 'op': 'Save_Quality_Check_Product', 'inwardno': inwardno, 'inwarddate': inwarddate, 'remarks': remarks, 'btnval': btnval, 'fillitems': fillitems };
            var s = function (msg) {
                if (msg) {
                    alert(msg);
                    $('#Quality_Products').css('display', 'block');
                    $('#fillform').css('display', 'none');
                    scrollTo(0, 0);
                }
            }
            var e = function (x, h, e) {
            };
            CallHandlerUsingJson(Data, s, e);
        }
    
    </script>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Quality Check
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operation</a></li>
            <li><a href="#">Quality Check </a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Quality Check Details
                </h3>
            </div>
            <div class="box-body">
                <div id="showlogs" align="center">
                    <%--<input id="add_Inward" type="button" name="submit" value='Quality Check' class="btn btn-primary" />--%>
                    <div class="input-group" style="padding-left:88%">
                        <div class="input-group-addon">
                            <span class="glyphicon glyphicon-plus-sign"></span> <span id="add_Inward">Quality Check</span>
                        </div>
                    </div>
                </div>
                <div id="div_QualityCheck">
                </div>
                <div id='QualityCheck_fillform' style="display: none;">
                    <table align="center" style="width: 60%;">
                        <tr>
                            <td style="height: 40px;">
                                <label>Inward No</label><span style="color: red;">*</span>
                            </td>
                            <td>
                                <input id="txtinwardno" type="text"  class="form-control" name="vendorcode"
                                    placeholder="Enter Inward Number" onchange="inwardnumber(this);" /><label id="lbl_code_error_msg" class="errormessage">*
                                        Please Enter number</label>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>Inward Date</label><span style="color: red;">*</span>
                            </td>
                            <td>
                                <div class="input-group date" style="width:100%;">
                                  <div class="input-group-addon cal">
                                    <i class="fa fa-calendar"></i>
                                  </div>
                                  <input  id='txtinwardDate' type="date"  class="form-control" />
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
                            <td>
                                <label id="lbl_sno">
                                </label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txtprductid" type="hidden" class="form-control" name="hiddeproductid" />
                            </td>
                        </tr>
                    </table>
                    <div id="Quality_Products">
                    </div>
                    <br />
                    <table align="center">
                        <tr>
                            <td>
                                <%--<input type="button" class="btn btn-primary" id="btn_save" value="Save" onclick="Save_Quality_Check_Product();" />
                                <input type="button" class="btn btn-danger" id="close_stock_sales" value="Close"
                                    onclick="canceldetails()" />--%>
                                <table>
                                   <tr>
                                    <td>
                                    <div class="input-group">
                                        <div class="input-group-addon">
                                        <span class="glyphicon glyphicon-ok" id="btn_save1" onclick="Save_Quality_Check_Product()"></span> <span id="btn_save" onclick="Save_Quality_Check_Product()">Save</span>
                                  </div>
                                  </div>
                                    </td>
                                    <td style="width:10px;"></td>
                                    <td>
                                     <div class="input-group">
                                        <div class="input-group-close">
                                        <span class="glyphicon glyphicon-remove" id='close_stock_sales1' onclick="canceldetails()"></span> <span onclick="canceldetails()" id='close_stock_sales'>Close</span>
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
