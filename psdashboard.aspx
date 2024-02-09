<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true" CodeFile="psdashboard.aspx.cs" Inherits="psdashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script src="Kendo/jquery.min.js" type="text/javascript"></script>
    <script src="Kendo/kendo.all.min.js" type="text/javascript"></script>
    <link href="Kendo/kendo.common.min.css" rel="stylesheet" type="text/css" />
    <link href="Kendo/kendo.default.min.css" rel="stylesheet" type="text/css" />
    <script src="JSF/jquery.blockUI.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(function () {
            GetDailyStoresValue();
            GetDailyOutwardValue();
            GetDailyInwardValue();
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
                error: e
            });
        }
        function CallHandlerUsingJson(d, s, e) {
            d = JSON.stringify(d);
            d = d.replace(/&/g, '\uFF06');
            d = d.replace(/#/g, '\uFF03');
            d = d.replace(/\+/g, '\uFF0B');
            d = d.replace(/\=/g, '\uFF1D');
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

        function GetDailyInwardValue() {
            var table1 = document.getElementById("tbl_Inward_value");
            for (var i = table1.rows.length - 1; i > 0; i--) {
                table1.deleteRow(i);
            }
            var data = { 'op': 'GetDailyInwardValue' };
            var s = function (msg) {
                if (msg) {
                    for (var i = 0; i < msg.length; i++) {
                        document.getElementById("lblinwardval").innerHTML = msg[i].InValue;
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

        function GetDailyOutwardValue() {
            var table2 = document.getElementById("tbl_Outward_Value");
            for (var i = table2.rows.length - 1; i > 0; i--) {
                table2.deleteRow(i);
            }
            var data = { 'op': 'GetDailyOutwardValue' };
            var s = function (msg) {
                if (msg) {
                    var j = 1;
                    outtot = "Total";
                    for (var i = 0; i < msg.length; i++) {
                        document.getElementById("lblinwardval").innerHTML = msg[i].OutValue;
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

        function GetDailyStoresValue() {
            var data = { 'op': 'Get_DailyStoresValuechart'};
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        createcolumChart(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        var datainXSeries = 0;
        var datainYSeries = 0;
        var newXarray = [];
        var newYarray = [];
        function createcolumChart(databind) {
            var newYarray = [];
            var newXarray = [];
            if (databind.length > 0) {
                for (var k = 0; k < databind.length; k++) {
                    var BranchName = [];
                    var categoryname = databind[k].Category;
                    var value = databind[k].value;
                    newXarray = categoryname.split(',');
                    for (var i = 0; i < value.length; i++) {
                        newYarray.push({ 'data': value[i].split(',')});
                    }
                }
            }
            var textname = "";
            $("#divcategorywiseval").kendoChart({
                title: {
                    text: textname,
                    color: "#006600",
                    font: "bold italic 18px Arial,Helvetica,sans-serif"
                },
                legend: {
                    position: "bottom"
                },
                chartArea: {
                    background: ""
                },
                seriesDefaults: {
                    type: "column"
                },
                series: [{
                    field: newYarray,
                    colorField: "userColor"
                }],
                series: newYarray,
                categoryAxis: {
                    categories: newXarray
                },
                tooltip: {
                    visible: true,
                    format: "{0}%",
                    template: "#= value #"
                }
            });
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content">
        <div class="row">
            <div class="col-xs-12">
                <!-- interactive chart -->
                <div class="box box-primary">
                    <div class="box-body">
                    <div class="row" >
                            <div class="col-lg-3 col-xs-6">
                                <!-- small box -->
                                <div class="small-box bg-aqua">
                                    <div class="inner">
                                             <h3>
                                             <label id="lblinwardval"  style="font-weight: 500;"></label></h3>
                                        <p>
                                            Daily Inward Value</p>
                                    </div>
                                    <div class="icon">
                                        <i class="ion ion-bag"></i>
                                    </div>
                                    <a href="#" class="small-box-footer"> <i class="fa fa-arrow-circle-right"></i>
                                    </a>
                                </div>
                            </div>
                            <!-- ./col -->
                            <div class="col-lg-3 col-xs-6">
                                <!-- small box -->
                                <div class="small-box bg-green">
                                    <div class="inner">
                                        <h3>
                                            <label id="lblissueval"  style="font-weight: 500;"></label></h3>
                                        <p>
                                           Daily Issue Value</p>
                                    </div>
                                    <div class="icon">
                                        <i class="ion ion-stats-bars"></i>
                                    </div>
                                    <a href="#" class="small-box-footer"> <i class="fa fa-arrow-circle-right"></i>
                                    </a>
                                </div>
                            </div>
                            <!-- ./col -->
                            <div class="col-lg-3 col-xs-6">
                                <!-- small box -->
                                <div class="small-box bg-yellow">
                                    <div class="inner">
                                        <h3>
                                            <label id="lblbtvalue"  style="font-weight: 500;"></label></h3>
                                        <p>
                                            Daily Stock Transfor Value</p>
                                    </div>
                                    <div class="icon">
                                        <i class="ion ion-person-add"></i>
                                    </div>
                                    <a href="#" class="small-box-footer"> <i class="fa fa-arrow-circle-right"></i>
                                    </a>
                                </div>
                            </div>

                            <div class="col-lg-3 col-xs-6">
                                <!-- small box -->
                                <div class="small-box bg-yellow">
                                    <div class="inner">
                                        <h3>
                                            <label id="lblpoval"  style="font-weight: 500;"></label></h3>
                                        <p>
                                            Daily PO Value</p>
                                    </div>
                                    <div class="icon">
                                        <i class="ion ion-person-add"></i>
                                    </div>
                                    <a href="#" class="small-box-footer"> <i class="fa fa-arrow-circle-right"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- /.box-body-->
                </div>
                <!-- /.box -->
            </div>
        </div>
        <div class="row">
            <div class="col-xs-12">
                <!-- interactive chart -->
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <i class="fa fa-bar-chart-o"></i>
                        <h3 class="box-title">
                           Total Store Value(Category Wise)</h3>
                        <div class="box-tools pull-right">
                            <div class="box-tools pull-right">
                                <button class="btn btn-box-tool" data-widget="collapse">
                                    <i class="fa fa-minus"></i>
                                </button>
                                <button class="btn btn-box-tool" data-widget="remove">
                                    <i class="fa fa-times"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="box-body">
                        <div id="divcategorywiseval" style="height: 300px;">
                        </div>
                    </div>
                    <!-- /.box-body-->
                </div>
                <!-- /.box -->
            </div>
        </div>
        
        <!-- /.row -->
    </section>
</asp:Content>