<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true"
    CodeFile="CategoryPieChart.aspx.cs" Inherits="CategoryPieChart" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script src="Kendo/jquery.min.js" type="text/javascript"></script>
    <script src="Kendo/kendo.all.min.js" type="text/javascript"></script>
    <link href="Kendo/kendo.common.min.css" rel="stylesheet" type="text/css" />
    <link href="Kendo/kendo.default.min.css" rel="stylesheet" type="text/css" />
    <script src="js/jquery.blockUI.js" type="text/javascript"></script>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
           CategoryWisePieChart<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Chart Reports</a></li>
            <li><a href="#">CategoryWisePieChart Chart</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>CategoryWisePieChart Details
                </h3>
            </div>
            <div class="box-body">
                <div style="width: 100%;" align="center">
                    <table>
                    <tr>
                      <td style="width: 200px; height: 50px;padding-top:25px;">
                                <select id="ddltype" class="form-control">
                                    <option value="Select Type" disabled selected>Select Type</option>
                                    <option value="Quantity">Quantity</option>
                                    <option value="Value">Value</option>
                                </select>
                            </td>
                             <td style="width: 6px;">
                            </td>
                            <td style="width: 90px; height: 50px;">
                                <label><span>From Date</span></label>
                                <input type="date" id="txtFromdate" class="form-control" />
                            </td>
                            <td style="width: 6px;">
                            </td>
                            <td style="width: 90px; height: 50px;">
                                <label><span>To Date</span></label>
                                <input type="date" id="txtTodate" class="form-control" />
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 90px; height: 50px;">
                            </td>
                            <td style="width: 6px;">
                            </td>
                            <td>
                                <%--<input type="button" id="submit" value="Submit" class="btn btn-success" onclick="Get_DailyStoresValue()" />--%>
                                <div class="input-group">
                                    <div class="input-group-addon" style="background-color:green;border-color:green;">
                                      <span class="glyphicon glyphicon-ok" id="submit1" onclick="Get_DailyStoresValue()"></span> <span id="submit" onclick="Get_DailyStoresValue()">Submit</span>
                                    </div>
                                </div>
                            </td>
                        </tr>

                    </table>
                    <span id="lblmsg" class="lblmsg"></span>
                </div>
                <br />
              <div id="example" class="k-content">
                    <div class="chart-wrapper">
                        <div id="CategoryPie_Chart">
                        </div>
                    </div>
                <script type="text/javascript">
                    function Get_DailyStoresValue() {
                        var txtFromdate = document.getElementById('txtFromdate').value;
                        var txtTodate = document.getElementById('txtTodate').value;
                        var type = document.getElementById('ddltype').value;
                        if (txtFromdate == "") {
                            alert("Select start date");
                            return false;
                        }
                        var data = { 'op': 'Get_DailyStoresValue', 'startDate': txtFromdate, 'enddate': txtTodate, 'type': type };
                        var s = function (msg) {
                            if (msg) {
                                if (msg == "Session Expired") {
                                    alert(msg);
                                    window.location.assign("Login.aspx");
                                }
                                else {
                                    if (msg.length > 0) {
                                        createpieChart(msg);
                                    }
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
                    var newXarray = [];
                    function createpieChart(databind) {
                        $("#CategoryPie_Chart").empty();
                        var textname = "";
                        newXarray = [];
                        for (var i = 0; i < databind.length; i++) {
                            newXarray.push({ "category": databind[i].category, "value": parseFloat(databind[i].StoresValue) });
                        }
                        var Cat = document.getElementById('ddltype').value;
                        $("#CategoryPie_Chart").kendoChart({
                            title: {
                                position: "top",
                                text: "Category wise-" + Cat + "", 
                                color: "#006600",
                                font: "bold italic 18px Arial,Helvetica,sans-serif"
                            },
                            legend: {
                                visible: false
                            },
                            chartArea: {
                                background: ""
                            },
                            seriesDefaults: {
                                labels: {
                                    visible: true,
                                    background: "transparent",
                                    template: "#= category #:#= value#"
                                }
                            },
                            dataSource: {
                                data: newXarray
                            },
                            series: [{
                                type: "pie",
                                field: "value",
                                categoryField: "category"
                            }],
                            seriesColors: ["#C0C0C0", "#FF00FF", "#00FFFF", "#322B2B", "#0000FF", "#00FF00", "#FF0000", "#B43104", "#8A084B", "#0041C2", "#800517", "#1C1715", "#008B00", "#8B8386", "#FFDEAD", "#8B2500", "#8B475D"],
                            tooltip: {
                                visible: true,
                                format: "{0}"
                            }
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
                        </script>
                    </div>
            </div>
        </div>
    </section>
</asp:Content>
