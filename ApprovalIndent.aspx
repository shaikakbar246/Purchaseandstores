<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true" CodeFile="ApprovalIndent.aspx.cs" Inherits="ApprovalIndent" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        $(function () {
            get_Approvel_internal_details();
            scrollTo(0, 0);
        });


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

        function get_Approvel_internal_details() {
            var data = { 'op': 'get_Approvel_internal_details' };
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
        var sub_indent_list = [];
        function filldetails(msg) {
            var results = '<div  style="overflow:auto;"><table class="responsive-table">';
            results += '<thead><tr class="trbgclrcls"><th scope="col" style="text-align:center">Name</th><th scope="col" style="width: 14% !important;">Indent Date</th><th scope="col">Section Name</th><th scope="col">Remarks</th><th scope="col"></th></tr></thead></tbody>';
            var Indentdetailes = msg[0].Indent;
            sub_indent_list = msg[0].SubIndent;
            var k = 1;
            var l = 0;
            //var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            for (var i = 0; i < Indentdetailes.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">';//<td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="For Approval" /></td>
                //results += '<td><button title="Click Here To Approve!" style="border-radius: 100% !important;padding:0px !important;height:30px !important;width:30px !important;" class="btn btn-info btn-outline btn-circle btn-lg m-r-5" onclick="getme(this)"><span class="glyphicon glyphicon-thumbs-up"></span></button></td>';
                //results += '<td data-title="brandstatus"><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5" style="border-radius: 100% !important;padding:0px !important;height:30px !important;width:30px !important;"  onclick="getme(this)"><span class="glyphicon glyphicon-thumbs-up" style="top: 0px !important;"></span></button></td>';
                results += '<td scope="row" class="1">' + Indentdetailes[i].name + '</td>';// style="text-align:center;"
                results += '<td data-title="sectioncolor" class="2">' + Indentdetailes[i].idate + '</td>';
                results += '<td data-title="invoiceno" class="8">' + Indentdetailes[i].sectionname + '</td>';
                results += '<td style="display:none" data-title="sectionstatus" class="3">' + Indentdetailes[i].ddate + '</td>';
                results += '<td data-title="dcno" class="7" style="display:none;">' + Indentdetailes[i].sectionid + '</td>';
                results += '<td style="display:none" class="5">' + Indentdetailes[i].status + '</td>';
                results += '<td  class="4">' + Indentdetailes[i].remarks + '</td>';
                results += '<td data-title="brandstatus"><button type="button" title="Click Here To Approve!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 apprvcls"  onclick="getme(this)"><span class="glyphicon glyphicon-thumbs-up" style="top: 0px !important;"></span></button></td>';
                results += '<td style="display:none" class="6">' + Indentdetailes[i].sno + '</td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_indenttable").html(results);
        }
        var indentsno = 0;
        function getme(thisid) {
            scrollTo(0, 0);
            $('#divMainAddNewRow').css('display', 'block');
            var name = $(thisid).parent().parent().children('.1').html();
            var idate = $(thisid).parent().parent().children('.2').html();
            var ddate = $(thisid).parent().parent().children('.3').html();
            // var entryby = $(thisid).parent().parent().children('.4').html();
            var remarks = $(thisid).parent().parent().children('.4').html();
            var satus = $(thisid).parent().parent().children('.5').html();
            var sno = $(thisid).parent().parent().children('.6').html();
            //var status = "P";
            document.getElementById('spnName').innerHTML = name;
            indentsno = sno;
            var results = '<div  style="overflow:auto;"><table id="tabledetails" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr style="background:#3c8dbc; color: white; font-weight: bold;"><th scope="col" style="text-align:center;">Product Name</th><th scope="col" style="text-align:center;">Qty</th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            for (var i = 0; i < sub_indent_list.length; i++) {
                if (sno == sub_indent_list[i].inword_refno) {
                    results += '<tr style="background-color:' + COLOR[l] + '"><td scope="row" style="display:none" class="1" style="text-align:center;">' + sub_indent_list[i].inword_refno + '</td>';
                    results += '<td  data-title="sectionstatus" class="4">' + sub_indent_list[i].productname + '</td>';
                    results += '<td  data-title="sectionstatus" class="3">' + sub_indent_list[i].qty + '</td>';
                    results += '<td style="display:none" class="4">' + sub_indent_list[i].hdnproductsno + '</td></tr>';
                    k++
                    l = l + 1;
                    if (l == 4) {
                        l = 0;
                    }
                }
            }
            results += '</table></div>';
            $("#div_subindentdetails").html(results);
        }



        function CloseClick() {
            $('#divMainAddNewRow').css('display', 'none');
            scrollTo(0, 0);
        }

   
        function save_approve_indent_click() {
            var data = { 'op': 'save_approve_indent_click', 'indentsno': indentsno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        $('#divMainAddNewRow').css('display', 'none');
                        get_Approvel_internal_details();
                        scrollTo(0, 0);
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



    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Apporval Indent Details<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operations</a></li>
            <li><a href="#">Apporval Indent</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Apporval Indent Details
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
                <div id="div_indenttable">
                </div>
            </div>
            <div id="divMainAddNewRow" class="pickupclass" style="text-align: center; height: 100%;
                width: 100%; position: absolute; display: none; left: 0%; top: -9%; z-index: 99999;
                background: rgba(192, 192, 192, 0.7);">
                <div id="divAddNewRow" style="border: 5px solid #A0A0A0; position: absolute; top: 8%;
                    background-color: White; left: 10%; right: 10%; width: 80%; -webkit-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                    -moz-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65); box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                    border-radius: 10px 10px 10px 10px;">
                    <table align="left" cellpadding="0" cellspacing="0" style="float: left; width: 100%;"
                        id="tableCollectionDetails" class="mainText2" border="1">
                        <tr>
                            <td>
                                <label>Name</label>
                            </td>
                            <td style="height: 40px;">
                                <span id="spnName" class="form-control"></span>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <div id="div_subindentdetails">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <%--<input type="button" class="btn btn-primary" id="btn_RaisePO" value="Approve" onclick="save_approve_indent_click();" />--%>
                                <table align="center">
                                   <tr>
                                    <td>
                                    <div class="input-group">
                                        <div class="input-group-addon">
                                        <span class="glyphicon glyphicon-ok" id="btn_RaisePO1" onclick="save_approve_indent_click()"></span> <span id="btn_RaisePO" onclick="save_approve_indent_click()">Approve</span>
                                  </div>
                                  </div>
                                    </td>
                                    <%--<td style="width:10px;"></td>--%>
                                    
                                    </tr>
                               </table>
                            </td>
                            <td>
                                <%--<input type="button" class="btn btn-danger" id="close_vehmaster" value="Close" onclick="CloseClick();" />--%>
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
                    <img src="Images/Close.png" style="padding-top: 16px;" height="100%" width="100%" alt="close" onclick="CloseClick();" />
                </div>
            </div>
        </div>
    </section>
</asp:Content>


