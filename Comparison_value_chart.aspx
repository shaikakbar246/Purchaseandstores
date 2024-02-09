<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true" CodeFile="Comparison_value_chart.aspx.cs" Inherits="Comparison_value_chart" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script src="Kendo/jquery.min.js" type="text/javascript"></script>
    <script src="Kendo/kendo.all.min.js" type="text/javascript"></script>
    <link href="Kendo/kendo.common.min.css" rel="stylesheet" type="text/css" />
    <link href="Kendo/kendo.default.min.css" rel="stylesheet" type="text/css" />
    <script src="js/jquery.blockUI.js" type="text/javascript"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <section class="content-header">
        <h1>
           CategoryWisePieChart<small>Preview</small>
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
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Pie Chart Details
                </h3>
            </div>
            <div class="box-body">
                <div style="width: 100%;" align="center">
                    <table>
                    <tr>
                    <%--<td style="width: 200px; height: 50px;">
                          <select id="ddltype" class="form-control" onchange="selectedchange();">
                                    <option selected disabled value="Select branch">Select Type</option>
                                    <option value="Branch">Branch</option>
                                    <option value="Section">Section</option>
                                     <option value="Supplier">Supplier</option>
                                </select>
                                 </td>
                    <td style="width: 200px; height: 50px;">
                          <select id="ddlfrombranch" class="form-control">
                                    <option selected disabled value="Select branch">Select branch</option>
                                </select>
                                 </td>--%>
                             <%--<td style="width: 6px;">
                            </td>--%>
                          <td style="width: 90px; height: 50px;">
                                <span>Year</span>
                                <select id="ddlfromyear" class="form-control">
                                    <option value="Select Year" disabled selected>Select Year</option>
                                     <option value="2016">2016</option>
                                    <option value="2017">2017</option>
                                     <option value="2018">2018</option>
                                    <option value="2019">2019</option>
                                </select>
                            </td>
                            <td style="width: 6px;">
                            </td>
                            <td style="width: 90px; height: 50px;">
                                <span>From Month</span>
                                <select id="ddlfrommonth" class="form-control">
                              <option value="Select FromMonth" disabled selected>Select FromMonth</option>
                                    <option value="1">January</option>
                                    <option value="2">February</option>
                                     <option value="3">March</option>
                                    <option value="4">April</option>
                                     <option value="5">May</option>
                                    <option value="6">June</option>
                                     <option value="7">July</option>
                                    <option value="8">August</option>
                                     <option value="9">September</option>
                                     <option value="10">October</option>
                                    <option value="11">November</option>
                                     <option value="12">December</option>
                                      </select>
                            </td>
                            <td style="width: 6px;">
                            </td>
                                <td style="width: 90px; height: 50px;">
                                <span>Year</span>
                                <select id="ddltoyear" class="form-control">
                                    <option value="Select Year" disabled selected>Select Year</option>
                                     <option value="2016">2016</option>
                                    <option value="2017">2017</option>
                                     <option value="2018">2018</option>
                                    <option value="2019">2019</option>
                                </select>
                            </td>

                             <td style="width: 6px;">
                            </td>
                           <td style="width: 90px; height: 50px;">
                                <span>To Month</span>
                                <select id="ddltomonth" class="form-control">
                              <option value="Select ToMonth" disabled selected>Select ToMonth</option>
                                    <option value="1">January</option>
                                    <option value="2">February</option>
                                     <option value="3">March</option>
                                    <option value="4">April</option>
                                     <option value="5">May</option>
                                    <option value="6">June</option>
                                     <option value="7">July</option>
                                    <option value="8">August</option>
                                     <option value="9">September</option>
                                     <option value="10">October</option>
                                    <option value="11">November</option>
                                     <option value="12">December</option>
                                     </select>
                            </td>
                        <%--</tr>
                        <tr>
                            <td style="width: 90px; height: 50px;">
                            </td>--%>
                            <td style="width: 6px;">
                            </td>
                            <td>
                                <input type="button" id="submit" value="Submit" class="btn btn-success" onclick="Get_Month_Comparison_Chart()" />
                            </td>
                        </tr>

                    </table>
                    <span id="lblmsg" class="lblmsg"></span>
                </div>
                <br />
              <div id="example" class="k-content">
                    <div class="chart-wrapper">
                        <div id="ComparisonLinechart">
                        </div>
                    </div>
                <script type="text/javascript">

                    //function selectedchange() {
                    //    var type = document.getElementById('ddltype').value;
                    //    var data = { 'op': 'get_Branch_section_supplier_details', 'type': type };
                    //    var s = function (msg) {
                    //        if (msg) {
                    //            if (msg.length > 0) {
                    //                fillbranche(msg)
                    //            }
                    //        }
                    //        else {
                    //        }
                    //    };
                    //    var e = function (x, h, e) {
                    //    };
                    //    $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
                    //    callHandler(data, s, e);
                    //}


                    //function fillbranche(msg) {
                    //    var data = document.getElementById('ddlfrombranch');
                    //    var length = data.options.length;
                    //    document.getElementById('ddlfrombranch').options.length = null;
                    //    var opt = document.createElement('option');
                    //    opt.innerHTML = "Select Name";
                    //    opt.value = "Select Name";
                    //    opt.setAttribute("selected", "selected");
                    //    opt.setAttribute("disabled", "disabled");
                    //    opt.setAttribute("class", "dispalynone");
                    //    data.appendChild(opt);
                    //    for (var i = 0; i < msg.length; i++) {
                    //        if (msg[i].name != null) {
                    //            var option = document.createElement('option');
                    //            option.innerHTML = msg[i].name;
                    //            option.value = msg[i].id;
                    //            data.appendChild(option);
                    //        }
                    //    }
                    //}
                    function Get_Month_Comparison_Chart() {
                        var toyear = document.getElementById('ddltoyear').value;
                        var fromyear = document.getElementById('ddlfromyear').value;
                        var mymonth = document.getElementById('ddlfrommonth').value;
                        var tomonth = document.getElementById('ddltomonth').value;
                        //var branchid = document.getElementById('ddlfrombranch').value
                        //var type = document.getElementById('ddltype').value;
                        var data = { 'op': 'Get_Month_Comparison_Chart', 'toyear': toyear, 'fromyear': fromyear, 'mymonth': mymonth, 'tomonth': tomonth };//, 'id': branchid , 'type': type
                        var s = function (msg) {
                            if (msg) {
                                if (msg == "Session Expired") {
                                    alert(msg);
                                    window.location.assign("Login.aspx");
                                }
                                else {
                                    if (msg.length > 0) {
                                        lineChart(msg);
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
                    var datainXSeries = 0;
                    var datainYSeries = 0;
                    var newXarray = [];
                    var newYarray = [];
                    function lineChart(databind) {
                        var newYarray = [];
                        var newXarray = [];
                        var branch = databind[0].branchid;
                        for (var k = 0; k < databind.length; k++) {
                            //var BranchName = [];
                            var IndentDate = databind[k].Month;
                            //var DeliveryQty = databind[k].branchname;
                            var Status = databind[k].StoresValue;
                            newXarray = IndentDate.split(',');
                            for (var i = 0; i < databind.length; i++) {
                                newYarray.push({ 'data': databind[i].StoresValue.split(',') });//, 'name': databind[i].branchname.split(',')
                            }
                        }
                        $("#ComparisonLinechart").kendoChart({
                            title: {
                                //text: "" + branch + "- Month Wise Comparison",
                                //color: "#006600",
                                //font: "bold italic 18px Arial,Helvetica,sans-serif"
                            },
                            legend: {
                                position: "bottom"
                            },
                            chartArea: {
                                background: ""
                            },
                            seriesDefaults: {
                                type: "line",
                                style: "smooth"
                            },
                            series: newYarray,
                            valueAxis: {
                                labels: {
                                    format: "{0}"
                                },
                                line: {
                                    visible: false
                                },
                                axisCrossingValue: -10
                            },
                            categoryAxis: {
                                categories: newXarray,
                                majorGridLines: {
                                    visible: false
                                },
                                labels: {
                                    rotation: 65
                                }
                            },
                            tooltip: {
                                visible: true,
                                format: "{0}%",
                                template: "#= series.name #: #= value #"
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

