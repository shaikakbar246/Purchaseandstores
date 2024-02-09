<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true" CodeFile="POPieChart.aspx.cs" Inherits="POPieChart" %>

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
           Purchase Order PieChart<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Chart Reports</a></li>
            <li><a href="#">Pie Chart</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Purchase Order PieChart
                </h3>
            </div>
            <div class="box-body">
                <div style="width: 100%;" align="center">
                    <span id="lblmsg" class="lblmsg"></span>
                </div>
                <br />
              <div id="example" class="k-content">
                    <div class="chart-wrapper">
                        <div id="chart">
                        </div>
                    </div>
                <script type="text/javascript">
                    $(function () {
                        Get_DailyStoresValue();
                    });
                    function Get_DailyStoresValue() {
                        var data = { 'op': 'Get_Po_Pie_chart' };
                        var s = function (msg) {
                            if (msg) {
                                if (msg == "Session Expired") {
                                    alert(msg);
                                    window.location.assign("Login.aspx");
                                }
                                else {
                                    if (msg.length > 0) {
                                        createpieChart(msg);
                                        //creategridview(msg);
                                        createtablegridview(msg);
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
                        newXarray = [];
                        $("#chart").empty();
                        var textname = "";
                        var status = databind[0].Postatus;
                        var pocount = databind[0].Totalpos;
                        for (var i = 0; i < pocount.length; i++) {
                            newXarray.push({ "category": status[i], "value": parseFloat(pocount[i]) });
                        }

//                        for (var i = 0; i < databind.length; i++) {
//                            newXarray.push({ "category": databind[i].Postatus, "value":databind[i].Totalpos });
//                        }
                        $("#chart").kendoChart({
                            title: {
                                position: "top",
                                text: "Purchase Order PieChart",
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
                            seriesColors: ["#3275a8",  "#FFA500", "#A52A2A", "#FF7F50", "#00FF00", "#808000", "#0041C2", "#800517", "#1C1715"],
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

                    function creategridview(msg) {
                        //var type = document.getElementById('ddltype').value;
                        //if (type == "Value") {
                            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
                            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Product Value</th></tr></thead></tbody>';
                            for (var i = 0; i < msg.length; i++) {
                                results += '<tr><td scope="row" class="1"  style="text-align:center;">' + (i + 1) + '</td>';
                                results += '<td data-title="Product Name" class="2">' + msg[i].productname + '</td>';
                                results += '<td data-title="Product Value" class="3">' + msg[i].StoresValue + '</td>';
                                //results += '<td style="display:none;"><label id="lbl_sno"></label></td>';
                                results += '</tr>';
                            }
                            results += '</table></div>';
                        //}
                        $("#pogrid_report").html(results);
                    }
                    function createtablegridview(msg) {
                        var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
                        results += '<thead><tr><th scope="col">Po Status</th><th scope="col">Total POs</th></tr></thead></tbody>';
                        //var k = 1;
                        for (var i = 0; i < msg.length; i++) {
                            for (var k = 0; k < msg[i].Postatus.length; k++)
                            {
                                //results += '<tr><td scope="row" class="1"  style="text-align:center;">' + (i + 1) + '</td>';
                                results += '<td data-title="Product Name" class="2">' + msg[i].Postatus[k] + '</td>';
                                results += '<td data-title="Product Value" class="3">' + msg[i].Totalpos[k] + '</td>';
                                //results += '<td style="display:none;"><label id="lbl_sno"></label></td>';
                                //k++;
                                results += '</tr>';
                            }
                            
                        }
                        results += '</table></div>';
                        
                        $("#pogrid_report").html(results);
                    }
                        </script>
                    </div>
                    <div id="pogrid_report"></div>
            </div>
        </div>
    </section>
</asp:Content>
