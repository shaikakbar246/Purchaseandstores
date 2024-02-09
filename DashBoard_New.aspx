<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true" CodeFile="DashBoard_New.aspx.cs" Inherits="DashBoard_New" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script src="Kendo/jquery.min.js" type="text/javascript"></script>
    <script src="Kendo/kendo.all.min.js" type="text/javascript"></script>
    <link href="Kendo/kendo.common.min.css" rel="stylesheet" type="text/css" />
    <link href="Kendo/kendo.default.min.css" rel="stylesheet" type="text/css" />
    <script src="js/jquery.blockUI.js" type="text/javascript"></script>
    <script src="JSF/jquery.blockUI.js" type="text/javascript"></script>
    <link href="bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            Total_PO();
            Total_MRN();
            Total_Issues();
            //Total_Branch_Transfers();
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

        function Total_PO()
        {
            var data = { 'op': 'get_total_po' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fill_total_po(msg);
                        createbarChart(msg);

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
        function  fill_total_po(msg)
        {
            var total_po_det = msg[0].total_po;
            document.getElementById('spn_total_po').innerHTML = total_po_det;
        }

        function Total_MRN() {
            var data = { 'op': 'get_total_mrn' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fill_total_mrn(msg);
                        

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
        function fill_total_mrn(msg) {
            var total_mrn_det = msg[0].total_mrn;
            document.getElementById('spn_total_mrn').innerHTML = total_mrn_det;
        }

        function Total_Issues() {
            var data = { 'op': 'get_total_issue' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fill_total_issue(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function fill_total_issue(msg) {
            var total_issue_det = msg[0].total_issue;
            document.getElementById('spn_total_issue').innerHTML = total_issue_det;
        }

        //function Total_Branch_Transfers() {
        //    var data = { 'op': 'get_total_branch_transfers' };
        //    var s = function (msg) {
        //        if (msg) {
        //            if (msg.length > 0) {
        //                fill_total_branch_transfers(msg);
        //            }
        //        }
        //        else {
        //        }
        //    };
        //    var e = function (x, h, e) {
        //    }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
        //    callHandler(data, s, e);
        //}
        //function fill_total_branch_transfers(msg) {
        //    var total_branch_transfers_det = msg[0].total_branch_transfers;
        //    document.getElementById('spn_total_branch_transfers').innerHTML = total_branch_transfers_det;
        //}

        var newXarray = [];
        function createbarChart(databind) {
            $("#divbarchart").empty();
            newXarray = [];
            var value = databind[0].total_po;
            var name = databind[0].total_po;
            for (var i = 0; i < name.length; i++) {
                newXarray.push({ "category": name[i], "value": parseFloat(value[i]) });
            }
            $("#divbarchart").kendoChart({
                title: {
                    position: "bottom",
                    text: "Attandance Details",
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
                        template: "#= value #"
                    }
                },
                dataSource: {
                    data: newXarray
                },
                series: [{
                    type: "column",
                    field: "value"
                }],
                categoryAxis: {
                    field: "category"
                },
                tooltip: {
                    visible: true,
                    format: "{0}"
                }
            });

        }


    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <section class="content-header">
        <h1>
            DASHBOARD
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i></a></li>
            <li><a href="#">DASHBOARD</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-body">
             <div id="example" class="k-content absConf">
             <div id="divdashboard">
             <div class="row">
            <div  class="col-lg-3 col-xs-6">
          <!-- small box -->
          <div class="small-box bg-aqua">
            <div class="inner">
            <h3>
               <span id="spn_total_po">0</span><sup style="font-size: 20px"> Po's</sup></h3>
            </div>
            <div class="icon">
              <i class="fa fa-cubes fa-1px"></i>
            </div>
            <a  class="small-box-footer">Total Po's<i class="fa fa-arrow-circle-right"></i></a>
          </div>
          </div>
           <div class="col-lg-3 col-xs-6">
          <!-- small box -->
          <div class="small-box bg-green">
            <div class="inner">
            <h3>
               <span id="spn_total_mrn">0</span><sup style="font-size: 20px"> Mrn"s</sup></h3>
            </div>
            <div class="icon">
              <i class="fa fa-user"></i>
            </div>
            <a  class="small-box-footer">Total MRN's<i class="fa fa-arrow-circle-right"></i></a>
          </div>
          </div>
           <%--<div class="col-lg-3 col-xs-6">
          <!-- small box -->
          <div class="small-box bg-yellow">
            <div class="inner">
            <h3>
               <span id="spn_total_issue">0</span><sup style="font-size: 20px"> Issues</sup></h3>
            </div>
            <div class="icon">
              <i class="fa fa-thumbs-o-up"></i>
            </div>
            <a  class="small-box-footer">Total Issue's<i class="fa fa-arrow-circle-right"></i></a>
          </div>
          </div>--%>
            <div  class="col-lg-3 col-xs-6">
          <!-- small box -->
          <div class="small-box bg-aqua">
            <div class="inner">
            <h3>
               <span id="spn_total_issue">0</span><sup style="font-size: 20px"> Issue's</sup></h3>
            </div>
            <div class="icon">
              <i class="fa fa-cubes fa-1px"></i>
            </div>
            <a  class="small-box-footer">Total Issue's<i class="fa fa-arrow-circle-right"></i></a>
          </div>
          </div>
            <div class="col-lg-3 col-xs-6">
          <!-- small box -->
          <div class="small-box bg-green">
            <div class="inner">
            <h3>
               <span id="spn_total_branch_transfers">0</span><sup style="font-size: 20px"> Branch Transfers</sup></h3>
            </div>
            <div class="icon">
              <i class="fa fa-user"></i>
            </div>
            <a  class="small-box-footer">Total Branch Transfers<i class="fa fa-arrow-circle-right"></i></a>
          </div>
          </div>
        </div>
        <%--<div class="col-lg-3 col-xs-6">
          <!-- small box -->
          <div class="small-box bg-green">
            <div class="inner">
            <h3>
               <span id="spn_total_branch_transfers">0</span><sup style="font-size: 20px"> Branch Transfers</sup></h3>
            </div>
            <div class="icon">
              <i class="fa fa-user"></i>
            </div>
            <a  class="small-box-footer">Total Branch Transfers<i class="fa fa-arrow-circle-right"></i></a>
          </div>
          </div>--%>
         
        </div>
        
           
                <%--<div class="chart-wrapper" style="margin: auto;">
                    <table>
                        <tr>
                            <td id="tdchart">
                                <div id="chart">
                                </div>
                            </td>
                            <td>
                                <div id="divtbldata">
                                </div>
                                <div>
                                    <input id="btn_poplate" type="button" data-toggle="modal" data-target="#myModal"
                                        onclick="viewmore_details()" name="submit" class="btn btn-primary" value="View All Branch Departments" />
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>--%>
            </div>
            </div>
            <div>
            <%--<div class="chart-wrapper" style="margin: auto;">
                    <table>
                        <tr>
                            <td id="td_barchbart">
                                <div id="divbarchart">
                                </div>
                            </td>
                            <td>
                                <div id="divbarchattbl">
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>--%>
            </div>
        </div>
    </section>
</asp:Content>

