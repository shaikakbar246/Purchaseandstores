<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true" CodeFile="logininforpt.aspx.cs" Inherits="logininforpt" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        $(function () {
          
        });
        function showlogininfo() {
            $("#div_logininfo").show();
            $("#div_loginrpt").hide();
        }
        function showloginrpt() {
            $("#div_logininfo").hide();
            $("#div_loginrpt").show();
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

       
        function get_logininfo_details() {
            var data = { 'op': 'get_logininfo_details' };
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
            results += '<thead><tr role="row" style="background:#5aa4d0; color: white; font-weight: bold;"><th scope="col">Bank Name</th><th scope="col">Code</th><th scope="col">Status</th><th scope="col" style="font-weight: bold;"></th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            //var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">'; //<td><input id="btn_poplate" type="button"  onclick="bankgetme(this)" name="submit" class="btn btn-primary" value="Edit" /></td>
                results += '<th scope="row" class="1" >' + msg[i].name + '</th>';
                results += '<td data-title="code" class="2">' + msg[i].code + '</td>';
                results += '<td data-title="status" class="3">' + msg[i].status + '</td>';
                //results += '<td data-title="brandstatus"><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5"  onclick="bankgetme(this)"><span class="glyphicon glyphicon-pencil"></span></button></td>';
                results += '<td data-title="brandstatus"><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5" style="background: #f44336 !important;border-radius: 100% !important;padding:0px !important;height:30px !important;width:30px !important;color: #ffffff !important;border-color: #f44336 !important;"  onclick="bankgetme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td>';
                results += '<td style="display:none" class="4">' + msg[i].sno + '</td></tr>';

                l = l + 1;
                if (l == 4) {
                    l = 0;
                }

            }
            results += '</table></div>';
            $("#div_BankData").html(results);
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
                                <li id="id_tab_Personal" class="active"><a data-toggle="tab" href="#" onclick="showlogininfo()">
                                    <i class="fa fa-university" aria-hidden="true"></i>&nbsp;&nbsp;User Login Info</a></li>
                                <li id="id_tab_documents" class=""><a data-toggle="tab" href="#" onclick="showloginrpt()">
                                    <i class="fa fa-truck" aria-hidden="true"></i>&nbsp;&nbsp;Login Report</a></li>
                            </ul>
                        </div>
                        <div id="div_logininfo" style="display: none;">
                            <div class="box-header with-border">
                                <h3 class="box-title">
                                    <i style="padding-right: 5px;" class="fa fa-cog"></i>User Login Info
                                </h3>
                            </div>
                            <div class="box-body">
                                <div id="div_BankData">
                                </div>
                            </div>
                        </div>
                        <div id="div_loginrpt" style="display: none;">
                            <div class="box-header with-border">
                                <h3 class="box-title">
                                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Login Report
                                </h3>
                            </div>
                            <div class="box-body">
                                <div id="pffillform">
                                    <table align="center" style="width: 60%;">
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
                                    </table>
                                </div>
                                <div id="div_logininforpt">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
        </div>
    </section>
</asp:Content>

