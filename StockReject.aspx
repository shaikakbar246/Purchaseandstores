<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true" CodeFile="StockReject.aspx.cs" Inherits="StockReject" %>

<asp:Content ID="Content3" ContentPlaceHolderID="head" Runat="Server">
<link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
    $(function () {
        // get_Branch_details();
//        GetFixedrows();
        get_productcode();
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

    function canceldetails() {
        $("#div_stockreject").show();
        $("#fillform").hide();
        // $('#showlogs').show();
        //forclearall();

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
    function ponumber(txt_pono) {
        var pono = document.getElementById('txt_pono').value;
        var data = { 'op': 'get_purchaserOrder_details', 'pono': pono };
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
        var po_subdetails = msg[0].subpurchasedetails;
        var podetails = msg[0].podetails;
        //datatable = msg;
        var pono = document.getElementById('txtinwardno').value;
        var results = '<div  style="overflow:auto;"><table ID="tabledetails" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" >';
        results += '<thead><tr><th scope="col">Sno</th><th scope="col">Productname</th><th scope="col">Per Unit Rs</th><th scope="col">Quantity</th><th scope="col">Total Cost</th><th scope="col"></th></tr></thead></tbody>';
        var p = 1;
        for (var i = 0; i < podetails.length; i++) {
            if (pono == podetails[i].pono) {
                document.getElementById('txt_podate').value = podetails[i].podate;

                for (var i = 0; i < po_subdetails.length; i++) {
                    results += '<tr><td data-title="Sno" class="1">' + p + '</td>';
                    results += '<th data-title="From"><input id="txtProductname" readonly class="productcls"  name="productname" value="' + po_subdetails[i].description + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<th data-title="From"><input class="price" id="txt_perunitrs" name="PerUnitRs" onkeypress="return isFloat(event)" readonly value="' + po_subdetails[i].cost + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<th data-title="From"><input class="quantity"  id="txt_quantity" onkeypress="return isFloat(event)" name="Quantity" value="' + po_subdetails[i].qty + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<th data-title="From"><input class="Total" id="txtTotal" onkeypress="return isFloat(event)" name="Quantity" value="' + po_subdetails[i].qty * po_subdetails[i].cost + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<th data-title="From"><input class="5" id="hdnproductsno" type="hidden" name="hdnproductsno" value="' + po_subdetails[i].hdnproductsno + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input>';
                    results += '<td data-title="Minus"><input id="btn_poplate" type="button"  onclick="removerow1(this)" name="Edit" class="btn btn-primary" value="Remove" /></td>';
                    results += '<td style="display:none" class="6">' + i + '</td></tr>';
                    p++;
                }
            }
        }
        results += '</table></div>';
        $("#div_stockreject").html(results);
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

    var fillitems = [];
    function save_stock_reject_click() {
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
        $('#tabledetails1> tbody > tr').each(function () {
            var txtsno = $(this).find('#txtSno').text();
            var productname = $(this).find('#txtproductname').val();
            var quantity = $(this).find('#txt_quantity').val();
            var sno = $(this).find('#txt_sub_sno').val();
            //var hiddeproductid = document.getElementById('txtprductid').value;
            var hdnproductsno = $(this).find('#hdnproductsno').val();
            if (hdnproductsno == "" || hdnproductsno == "0") {
            }
            else {
                fillitems.push({ 'txtsno': txtsno, 'productname': productname, 'quantity': quantity, 'hdnproductsno': hdnproductsno });
            }
        });
        if (fillitems.length == 0) {
            alert("Please Select Product Names");
            return false;
        }
        var Data = { 'op': 'save_stock_reject_click', 'inwardno': inwardno, 'inwarddate': inwarddate, 'remarks': remarks, 'btnval': btnval, 'fillitems': fillitems };
        var s = function (msg) {
            if (msg) {
                alert(msg);
                $('#div_stockreject').css('display', 'block');
                $('#fillform').css('display', 'none');
                GetFixedrows();
                get_productcode();
                //forclearall();
            }
        }
        var e = function (x, h, e) {
        };
        CallHandlerUsingJson(Data, s, e);
    }
    
    </script>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<section class="content-header">
        <h1>
            InwardReject
        </h1>
   <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operation</a></li>
            <li><a href="#">InwardReject </a></li>
        </ol> 
  </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>InwardReject  Details
                </h3>
            </div>
            <div class="box-body">
                   <table align="center" style="width: 60%;">
                        <tr>
                            <td style="height:40px;">
                             Inwardno<span style="color: red;">*</span>
                            </td>
                            <td>
                                <input id="txtinwardno" type="text" maxlength="45" class="form-control" name="vendorcode"
                                    placeholder="Enter  Number"/><label id="lbl_code_error_msg" class="errormessage">* Please Enter
                                        number</label>
                            </td>
                        </tr>
                      <tr>
                            <td style="height:40px;">
                            Inward date<span style="color: red;">*</span>     
                            </td>
                            <td>
                            <input type="date" id='txtinwardDate'  class="form-control"/>
                                
                            </td>
                      </tr>
                    
                      <tr>
                           <td style="height:40px;">
                             Remarks<span style="color: red;">*</span>
                            </td>
                            <td>
                              <textarea id="txtremarks" class="form-control" type="text" rows="4" cols="45" placeholder="Enter Remarks"></textarea>
                            </td>  
                      </tr>


                      <tr style="display:none;">
                        <td >
                        <label id="lbl_sno"></label>
                        </td>
                          <td style="height: 40px;">
                                <input id="txtprductid" type="hidden" class="form-control" name="hiddeproductid" />
                            </td>
                        </tr>
                        </table>
                <div id="div_stockreject">
                </div>
                <div id='fillform' style="display: none;">
                    </div>
                    <div>
                    <table align="center">
                        <tr>
                            <td>
                                <input type="button" class="btn btn-primary" id="btn_save" value="Save" onclick="save_stock_reject_click();" />
                                <input type="button" class="btn btn-danger" id="close_stock_sales" value="Close" onclick="canceldetails()" />
                            </td>
                        </tr>
                    </table>
                    </div>  
              </div>
              </div>
   </section>
</asp:Content>




