<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true" CodeFile="Preventive_Maintenance_Schedule.aspx.cs" Inherits="Preventive_Maintenance_Schedule" %>

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
        

        function get_schedule_Details() {
            var data = { 'op': 'get_schedule_Details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        filldetails1(msg);
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

        function filldetails1(msg) {
            var l = 0;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Location</th><th scope="col">Department</th><th scope="col">Asset Code</th><th scope="col">Starting Month of Maintenance Schedule</th><th scope="col">Next Maintenance Schedule</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<td data-title="Location" class="1" >' + msg[i].branch_id + '</td>';
                results += '<td data-title="Department" class="2">' + msg[i].dept_id + '</td>';
                results += '<td data-title="Asset Code" class="3">' + msg[i].asset_id + '</td>';
                results += '<td data-title="Starting Month of Maintenance Schedule" class="4">' + msg[i].statring_month + '</td>';
                results += '<td data-title="Next Maintenance Schedule" class="5">' + msg[i].nextmaintananceschedule + '</td>';
                results += '<td style="display:none;" data-title="sno" class="6">' + msg[i].sno + '</td></tr>';
                results += '<td style="display:none;" data-title="" class="7">' + msg[i].branch_id1 + '</td></tr>';
                results += '<td style="display:none;" data-title="" class="8">' + msg[i].dept_id1 + '</td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_prevent_maint").html(results);
        }

        function save_schedule_Details_click() {
            var DataTable = [];
            var count = 0;
            var rows = $("#tabledetails tr:gt(0)");
            var rowsno = 1;
            $(rows).each(function (i, obj) {
                asset_id = $(this).find('#txt_asset_code').val();
                s_schd = $(this).find('#txt_start_schd').val();
                n_schd = $(this).find('#next_mntc_sche').val();
                var abc = { asset_id: asset_id, s_schd: s_schd, n_schd: n_schd };
                if (asset_id == "" || asset_id == "0" || asset_id == "undefined" || asset_id == 0) {
                }
                else {
                    var abc = { asset_id: asset_id, s_schd: s_schd, n_schd: n_schd };
                    DataTable.push(abc);
                }
            });
            var location = document.getElementById('slct_loc').value;
            var department = document.getElementById('slct_dept').value;
            var sno = document.getElementById('lbl_sno').value;
            var btn_save = document.getElementById('btn_save').value;
            var data = { 'op': 'save_schedule_Details', 'DataTable': DataTable, 'btn_save': btn_save };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
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
        function btn_schedule_Details_click() {
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
            var data = { 'op': 'get_maintenance_det', 'location': location, 'department': department };
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
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr class="trbgclrcls"><th scope="col">Sno</th><th scope="col">Asset Name</th><th scope="col">Asset Code</th><th scope="col">Starting Month Schedule</th><th scope="col">Next Schedule</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td scope="row" class="1"  style="text-align:center;">' + (i + 1) + '</td>';
                results += '<td data-title="Asset Name" class="2">' + msg[i].asset_name + '</td>';
                results += '<td data-title="Asset Code" class="3">' + msg[i].asset_code + '</td>';
                results += '<td data-title="Assetid" style="display:none;" class="3"><input type="text" id="txt_asset_code" value="' + msg[i].sno + '"></input></td>';
                results += '<td data-title="Starting Month of Maintenance Schedule" class="4"><input type="date" id="txt_start_schd" value="' + msg[i].install_dt + '"></input></td>';
                results += '<td data-title="Next Maintenance Schedule" class="5">'
                results += '<select id="next_mntc_sche">';
                results += '<option value="Select">Select</option>';
                results += '<option value="Daily">Daily</option>';
                results += '<option value="Weekly">Weekly</option>';
                results += '<option value="Every 3 Months">Every 3 Months</option>';
                results += '<option value="Every 500 hours">Every 500 hours</option>';
                results += '<option value="Every 1500 hours">Every 1500 hours</option>';
                results += '</select></td>';
                results += '<td style="display:none;"><label id="lbl_sno"></label></td>';
                results += '</tr>';
            }
            results += '<tr><td></td><td></td><td><input type="button" id="btn_save" value="Save" class="btn btn-success" onclick="save_schedule_Details_click();"></input></td></tr>';
            results += '</table></div>';
            $("#div_prevent_maint").html(results);
        }

        function clearDet() {
            scrollTo(0, 0);
            var msg = [];
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Asset Name</th><th scope="col">Asset Code</th><th scope="col">Starting Month Schedule</th><th scope="col">Next Schedule</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td scope="row" class="1"  style="text-align:center;">' + (i + 1) + '</td>';
                results += '<td data-title="Asset Name" class="2">' + msg[i].asset_name + '</td>';
                results += '<td data-title="Asset Code" class="3"><input type="text" id="txt_asset_code" value="' + msg[i].asset_code + '</td>';
                results += '<td data-title="Starting Month of Maintenance Schedule" class="4"><input type="date" id="txt_start_schd" value="' + msg[i].install_dt + '"></input></td>';
                results += '<td data-title="Next Maintenance Schedule" class="5">'
                results += '<select id="next_mntc_sche">';
                results += '<option value="Select">Select</option>';
                results += '<option value="Daily">Daily</option>';
                results += '<option value="Weekly">Weekly</option>';
                results += '<option value="Every 3 Months">Every 3 Months</option>';
                results += '<option value="Every 500 hours">Every 500 hours</option>';
                results += '<option value="Every 1500 hours">Every 1500 hours</option>';
                results += '</select></td>';
                results += '<td style="display:none;"><label id="lbl_sno"></label></td>';
                results += '</tr>';
            }
            results += '<tr><td></td><td></td><td><input type="button" id="btn_save" value="Save" class="btn btn-success" onclick="save_schedule_Details_click();"></input></td></tr>';
            results += '</table></div>';
            $("#div_prevent_maint").html(results);
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <section class="content-header">
        <h1>
            Preventive Maintenance Schedule
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i></a></li>
            <li><a href="#">Preventive Maintenance Schedule</a></li>
        </ol>
    </section>
    <section class="content">
            <div class="box box-info">
                <div id="div_Account">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Preventive Maintenance Schedule
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
                                        <div class="input-group">
                                            <div class="input-group-addon">
                                                <span class="glyphicon glyphicon-flash" onclick="btn_schedule_Details_click();"></span> <span id="btn_generate" onclick="btn_schedule_Details_click();">Generate</span>
                                            </div>
                                        </div>
                                    </td>
                                    
                                </tr>
                                </table>
                            <div id="div_prevent_maint">
                            </div>
                        </div>
                    </div>
        </section>
</asp:Content>

