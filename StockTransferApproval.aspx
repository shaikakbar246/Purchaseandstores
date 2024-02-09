<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true" CodeFile="StockTransferApproval.aspx.cs" Inherits="StockTransferApproval" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    $(function () {
        get_approve_Stock_Tranfer_click();
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
    
    function get_approve_Stock_Tranfer_click() {
     var data = { 'op': 'get_approve_Stock_Tranfer_click' };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    fillStockTransfer(msg);
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
    var Stocktransfer_sub_list = [];
    function fillStockTransfer(msg) {
        var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
        results += '<thead><tr class="trbgclrcls"><th scope="col">To Branch</th><th scope="col">Invoice No</th><th scope="col">Invoice Date</th><th scope="col"></th></tr></thead></tbody>';
        var stocktransferdetails = msg[0].stocktransferdetails;
        Stocktransfer_sub_list = msg[0].stocktransfersubdetails;

        var k = 1;
        var l = 0;
        var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];

        for (var i = 0; i < stocktransferdetails.length; i++) {
            results += '<tr style="background-color:' + COLOR[l] + '">';//<td><input id="btn_poplate" type="button"  onclick="getme(this)" name="Approval" class="btn btn-primary" value="Approval" /></td>
            results += '<th scope="row" class="1" style="display:none;" >' + stocktransferdetails[i].frombranch + '</th>';
            results += '<td data-title="sectionstatus"  style="display:none;" class="2">' + stocktransferdetails[i].tobranch + '</td>';
            results += '<td data-title="sectionstatus" style="display:none;" class="3">' + stocktransferdetails[i].barnchname + '</td>';
            results += '<td data-title="sectionstatus" class="4">' + stocktransferdetails[i].bname + '</td>';
            results += '<td data-title="sectionstatus"  style="display:none;" class="6">' + stocktransferdetails[i].transportname + '</td>';
            results += '<td data-title="sectionstatus"  style="display:none;" class="7">' + stocktransferdetails[i].vehicleno + '</td>';
            results += '<td data-title="sectionstatus" class="10">' + stocktransferdetails[i].invoiceno + '</td>';
            results += '<td data-title="sectionstatus" class="9">' + stocktransferdetails[i].invoicedate + '</td>';
            results += '<td data-title="sectionstatus"  style="display:none;" class="8">' + stocktransferdetails[i].status + '</td>';
            results += '<td data-title="sectionstatus"  style="display:none;" class="9">' + stocktransferdetails[i].invoicetype + '</td>';
            results += '<td data-title="brandstatus"><button type="button" title="Click Here To Approve!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 apprvcls"  onclick="getme(this)"><span class="glyphicon glyphicon-thumbs-up" style="top: 0px !important;"></span></button></td>';
            results += '<td data-title="sno" class="5" style="display:none;">' + stocktransferdetails[i].sno + '</td></tr>';
            l = l + 1;
            if (l == 4) {
                l = 0;
            }
        }
        results += '</table></div>';
        $("#div_stocktransfer").html(results);
    }
    var stocksno = 0;
    function getme(thisid) {
        scrollTo(0, 0);
        $('#divMainAddNewRow').css('display', 'block');
        var frombranch = $(thisid).parent().parent().children('.1').html();
        var tobranch = $(thisid).parent().parent().children('.2').html();
        var transportname = $(thisid).parent().parent().children('.6').html();
        var vehicleno = $(thisid).parent().parent().children('.7').html();
        var invoicetype = $(thisid).parent().parent().children('.9').html();
        var sno = $(thisid).parent().parent().children('.5').html();
        var status = $(thisid).parent().parent().children('.8').html();
        document.getElementById('lbl_sno').value = sno;

        stocksno = sno; 
        var table = document.getElementById("tabledetails");
        var results = '<div  style="overflow:initial;"><table id="tabledetails" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
        results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Quantity</th></tr></thead></tbody>';
        var k = 1;
        for (var i = 0; i < Stocktransfer_sub_list.length; i++) {
            if (sno == Stocktransfer_sub_list[i].stock_refno) {
                results += '<tr><td scope="row" style="display:none" class="1">' + Stocktransfer_sub_list[i].stock_refno + '</td>';
                results += '<td  data-title="sectionstatus" class="1">' + Stocktransfer_sub_list[i].sno + '</td>';
                results += '<td  data-title="sectionstatus" class="2">' + Stocktransfer_sub_list[i].productname + '</td>';
                results += '<th data-title="From"><span id="spn_quantity">' + Stocktransfer_sub_list[i].quantity + '</span><input id="txt_quantity" readonly class="quantity"  name="quantity" onkeypress="return isFloat(event)"  value="' + Stocktransfer_sub_list[i].quantity + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;display:none;"></input></td>';
                results += '<td  style="display:none;" class="clstax">' + Stocktransfer_sub_list[i].taxvalue + '</td>';
                results += '<td style="display:none;" class="Taxtypecls">' + Stocktransfer_sub_list[i].taxtype + '</td>';
                results += '<td style="display:none;" class="clsfreigtamt">' + Stocktransfer_sub_list[i].freigtamt + '</td>';
                results += '<th data-title="From"><input class="6" id="hdnproductsno" readonly type="hidden" name="hdnproductsno" value="' + Stocktransfer_sub_list[i].hdnproductsno + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input>';
                results += '</tr>';
                k++
            }
        }
        results += '</table></div>';
        $("#div_SectionData").html(results);
    }

    function CloseClick() {
        $('#divMainAddNewRow').css('display', 'none');
        scrollTo(0, 0);
    }
    function save_approve_Stock_Tranfer_click() {
        var filldetails = [];
        $('#tabledetails> tbody > tr').each(function () {
            var quantity = $(this).find('#txt_quantity').val();
            var hdnproductsno = $(this).find('#hdnproductsno').val();
            if (hdnproductsno == "" || hdnproductsno == "0") {
            }
            else {
                filldetails.push({ 'quantity': quantity, 'hdnproductsno': hdnproductsno });
            }
        });
        if (filldetails.length == 0) {
            alert("Please Select Product Names");
            return false;
        }
        var data = { 'op': 'save_approve_Stock_Tranfer_click', 'stock_sno': stocksno, 'filldetails': filldetails };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    alert(msg);
                    $('#divMainAddNewRow').css('display', 'none');
                    get_approve_Stock_Tranfer_click();
                    scrollTo(0, 0);
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
 </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
 <section class="content-header">
        <h1>
            Apporval  Outward Entry Details<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operations</a></li>
            <li><a href="#">Apporval  Outward </a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Apporval  Outward Entry Details
                </h3>
            </div>
            <div class="box-body">
                <table>
                    <tr style="display: none;">
                        <td>
                            <label id="lbl_sno">
                            </label>
                        </td>
                    </tr>
                </table>
                <div id="div_stocktransfer">
                </div>
            </div>
            <div id="divMainAddNewRow" class="pickupclass" style="text-align: center; height: 100%;
                width: 100%; position: absolute; display: none; left: 0%; top: 0%; z-index: 99999;
                background: rgba(192, 192, 192, 0.7);">
                <div id="divAddNewRow" style="border: 5px solid #A0A0A0; position: absolute; top: 8%;
                    background-color: White; left: 10%; right: 10%; width: 80%; -webkit-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                    -moz-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65); box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                    border-radius: 10px 10px 10px 10px;">
                    <table align="left" cellpadding="0" cellspacing="0" style="float: left; width: 100%;"
                        id="tableCollectionDetails" class="mainText2" border="1">
                        <tr>
                            <td colspan="2">
                                <div id="div_SectionData">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <table align="center">
                                   <tr>
                                    <td>
                                    <div class="input-group">
                                        <div class="input-group-addon">
                                            <span class="glyphicon glyphicon-ok" id="btn_RaisePO1" onclick="save_approve_Stock_Tranfer_click()"></span> <span id="btn_RaisePO" onclick="save_approve_Stock_Tranfer_click()">Approve</span>
                                        </div>
                                    </div>
                                    </td>
                                    </tr>
                               </table>
                            </td>
                            <td>
                                <table align="center">
                                   <tr>
                                    <td>
                                     <div class="input-group">
                                        <div class="input-group-close">
                                            <span class="glyphicon glyphicon-remove" id='close_vehmaster1' onclick="CloseClick()"></span> <span id='close_vehmaster' onclick="CloseClick()">Close</span>
                                        </div>
                                    </div>
                                    </td>
                                    </tr>
                               </table>
                            </td>
                        </tr>
                    </table>
                </div>
                <div id="divclose" style="width: 35px; top: 7.5%; right: 10%; position: absolute;
                    z-index: 99999; cursor: pointer;">
                    <img src="Images/Close.png" height="100%" width="100%" alt="close" onclick="CloseClick();" />
                </div>
            </div>
        </div>
    </section>
</asp:Content>

