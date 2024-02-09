<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true" CodeFile="Asset_List.aspx.cs" Inherits="Asset_List" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script type="text/javascript">
        $(function () {
            scrollTo(0, 0);
            get_Branch_loc();
            get_sub_Dept();
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

        function get_Branch_loc() {
            var data = { 'op': 'get_Branch_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillpartytypedetails(msg);
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
            var data = document.getElementById('slct_loc');
            var length = data.options.length;
            document.getElementById('slct_loc').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "SELECT LOCATION";
            opt.value = "";
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
            var data = document.getElementById('slct_dept');
            var length = data.options.length;
            document.getElementById('slct_dept').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "SELECT DEPARTMENT";
            opt.value = "";
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

        function btn_asset_Details_click() {
            var location = document.getElementById('slct_loc').value;
            var department = document.getElementById('slct_dept').value;
            if (location == "") {
                alert("Please select location");
                return false;
            }
            if (department == "") {
                alert("Please select department");
                return false;
            }
            var data = { 'op': 'get_asset_list', 'location': location, 'department': department };
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
            clearDet();
        }
        function filldetails(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr class="trbgclrcls"><th scope="col">Sno</th><th scope="col">Asset Name</th><th scope="col">Asset Code</th><th scope="col">Purchase Date</th><th scope="col">Maintenance Type</th><th scope="col">Price</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td scope="row" class="1"  style="text-align:center;">' + (i + 1) + '</td>';
                results += '<td data-title="Asset Name" class="2">' + msg[i].asset_name + '</td>';
                results += '<td data-title="Asset Code" class="3">' + msg[i].asset_code + '</td>';
                results += '<td data-title="Purchase Date" class="4">' + msg[i].purchase_dt + '</td>';
                results += '<td data-title="Maintenance Type" class="5">' + msg[i].maintain_type + '</td>';
                results += '<td data-title="Price" class="6">' + msg[i].price + '</td>';
                //results += '<td style="display:none;"><label id="lbl_sno"></label></td>';
                results += '</tr>';
            }
            results += '</table></div>';
            $("#div_asset_list").html(results);
        }

        function clearDet() {
            var msg = [];
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Asset Name</th><th scope="col">Asset Code</th><th scope="col">Purchase Date</th><th scope="col">Maintenance Type</th><th scope="col">Price</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td scope="row" class="1"  style="text-align:center;">' + (i + 1) + '</td>';
                results += '<td data-title="Asset Name" class="2">' + msg[i].asset_name + '</td>';
                results += '<td data-title="Asset Code" class="3">' + msg[i].asset_code + '</td>';
                results += '<td data-title="Purchase Date" class="4">' + msg[i].purchase_dt + '</td>';
                results += '<td data-title="Maintenance Type" class="5">' + msg[i].maintain_type + '</td>';
                results += '<td data-title="Price" class="6">' + msg[i].price + '</td>';
                //results += '<td style="display:none;"><label id="lbl_sno"></label></td>';
                results += '<td><input type="button" id="btn_save" value="Save" onclick="save_schedule_Details_click();"></input></td>';
                results += '</tr>';
            }
            results += '</table></div>';
            $("#div_asset_list").html(results);
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <section class="content-header">
        <h1>
            Asset List Details
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i></a></li>
            <li><a href="#">Asset List Details</a></li>
        </ol>
    </section>
    <section class="content">
            <div class="box box-info">
                <div id="div_Account">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Asset List Details
                        </h3>
                    </div>
                    <div class="box-body">
                        <div id="div_Emp">
                        </div>
                        <div id='fillform'>
                            <table align="center">
                                <tr>
                                    <th>
                                    </th>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                        <label>
                                            Location
                                        </label>
                                    </td>
                                    <td>
                                        <select id="slct_loc" class="form-control">
                                            <option value="Select type">Select type</option>
                                        </select>
                                    </td>
                                    <td style="width:5px;"></td>
                                    <td style="height: 40px;">
                                        <label>
                                            Department
                                        </label>
                                    </td>
                                    <td>
                                        <select id="slct_dept" class="form-control">
                                            <option value="Select">Select</option>
                                        </select>
                                    </td>
                                     <td style="width:5px;"></td>
                                    <td style="height: 40px;">
                                        <%--<input id="btn_generate" type="button" class="btn btn-primary" name="submit" value="Generate" onclick="btn_asset_Details_click();" />--%>
                                        <div class="input-group">
                                            <div class="input-group-addon">
                                                <span class="glyphicon glyphicon-flash" onclick="btn_asset_Details_click();"></span> <span id="btn_generate" onclick="btn_asset_Details_click();">Generate</span>
                                            </div>
                                        </div>
                                    </td>
                                    
                                </tr>
                            </table>
                            <div id="div_asset_list">
                            </div>
                        </div>
                    </div>
        </section>
</asp:Content>

