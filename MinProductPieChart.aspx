<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true" CodeFile="MinProductPieChart.aspx.cs" Inherits="MinProductPieChart" %>
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
           ProductWisePieChart<small>Preview</small>
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
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Product Wise PieChart Details
                </h3>
            </div>
            <div class="box-body">
                <div style="width: 100%;" align="center">
                  <table>
                    <tr>
                       <td style="width: 200px; height: 50px;">
                                <select id="ddlpricetype" class="form-control" onchange="typechnge();">
                                    <option value="Select Type" disabled selected>Select Type</option>
                                    <option value="MinProducts">MinProducts</option>
                                    <option value="MaxProducts">MaxProducts</option>
                                </select>
                            </td>
                      <td id="minid" style="width: 200px; height: 50px;display:none;padding-top:8px;" >
                                <select id="ddltype" class="form-control">
                                    <option value="Select Type" disabled selected>Select Type</option>
                                    <option value="Price">Price</option>
                                    <option value="Quantity">Quantity</option>
                                </select>
                            </td>
                             <td style="width: 6px;">
                            </td>
                       
                         <td id="maxid" style="width: 200px; height: 50px;display:none;padding-top:8px;">
                                <select id="ddlmax" class="form-control">
                                    <option value="Select Type" disabled selected>Select Type</option>
                                    <option value="Quantity">Quantity</option>
                                    <option value="Value">Value</option>
                                </select>
                            </td>
                             </tr>
                    <tr>
                            <%--<td style="width: 90px; height: 50px;">
                            </td>--%>
                            <%--<td style="width: 6px;">
                            </td>--%>
                            <td>
                                <%--<input type="button" id="submit" value="Submit" class="btn btn-success" onclick="Get_Min_Product_wise_pie_chart()" />--%>
                                <div class="input-group">
                                    <div class="input-group-addon" style="background-color:green;border-color:green;">
                                      <span class="glyphicon glyphicon-ok" id="submit1" onclick="Get_Min_Product_wise_pie_chart()"></span> <span id="submit" onclick="Get_Min_Product_wise_pie_chart()">Submit</span>
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
                        <%-- style="background: center no-repeat url('../../content/shared/styles/world-map.png');"--%>
                        <div id="chart">
                        </div>
                    </div>
                <script type="text/javascript">
//                    $(function () {
//                        Get_Min_Product_wise_pie_chart();
                    //                    });
                    function typechnge() {
                        var select = document.getElementById('ddlpricetype').value;

                        if (select == "MinProducts") {
                            $('#minid').css('display', 'block');
                            $('#maxid').css('display', 'none');
                        }
                        if (select == "MaxProducts") {
                            $('#maxid').css('display', 'block');
                            $('#minid').css('display', 'none');
                        }

                    }

                    function Get_Min_Product_wise_pie_chart() {
                        var pricetype = document.getElementById('ddlpricetype').value;
                        var min = document.getElementById('ddltype').value;

                        var max = document.getElementById('ddlmax').value;
                       
                        if (min == "") {
                            alert("Select  type");
                            return false;
                        }

                        if (pricetype == "") {
                            alert("Select  pricetype");
                            return false;
                        }
                        var data = { 'op': 'Get_Min_Product_wise_pie_chart', 'min': min, 'pricetype': pricetype, 'max': max };
                        var s = function (msg) {
                            if (msg) {
                                if (msg == "Session Expired") {
                                    alert(msg);
                                    window.location.assign("Login.aspx");
                                }
                                else {
                                    if (msg.length > 0) {
                                        createpieChart(msg);
                                        creategridview(msg);
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
                        $("#chart").empty();
                        var textname = "";
                        newXarray = [];
                        for (var i = 0; i < databind.length; i++) {
                            newXarray.push({ "category": databind[i].productname, "value": parseFloat(databind[i].StoresValue) });
                        }
                        var Type=document.getElementById('ddltype').value
                        $("#chart").kendoChart({
                            title: {
                                position: "top",
                                text: "Top 10 Minimum -"+Type+" Products",
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
                            seriesColors: ["#C0C0C0", "#FF00FF", "#00FFFF", "#322B2B", "#0000FF", "#00FF00", "#FF0000", "#B43104", "#8A084B", "#0041C2", "#800517", "#1C1715"],
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
                        var PriceType = document.getElementById('ddlpricetype').value;
                        if (PriceType == "MinProducts") {
                            var type = document.getElementById('ddltype').value;
                            if (type == "Price") {
                                var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
                                results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Product Price</th></tr></thead></tbody>';
                                for (var i = 0; i < msg.length; i++) {
                                    results += '<tr><td scope="row" class="1"  style="text-align:center;">' + (i + 1) + '</td>';
                                    results += '<td data-title="Product Name" class="2">' + msg[i].productname + '</td>';
                                    results += '<td data-title="Product Value" class="3">' + msg[i].StoresValue + '</td>';
                                    //results += '<td style="display:none;"><label id="lbl_sno"></label></td>';
                                    results += '</tr>';
                                }
                                results += '</table></div>';
                            }
                            else {
                                var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
                                results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Product Quantity</th></tr></thead></tbody>';
                                for (var i = 0; i < msg.length; i++) {
                                    results += '<tr><td scope="row" class="1"  style="text-align:center;">' + (i + 1) + '</td>';
                                    results += '<td data-title="Product Name" class="2">' + msg[i].productname + '</td>';
                                    results += '<td data-title="Product Quantity" class="3">' + msg[i].StoresValue + '</td>';
                                    //results += '<td style="display:none;"><label id="lbl_sno"></label></td>';
                                    results += '</tr>';
                                }
                                results += '</table></div>';
                            }
                            $("#min_report").html(results);
                        }
                        if (PriceType == "MaxProducts") {
                            var Max = document.getElementById('ddlmax').value;
                            if (Max == "Quantity") {
                                var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
                                results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Product Quantity</th></tr></thead></tbody>';
                                for (var i = 0; i < msg.length; i++) {
                                    results += '<tr><td scope="row" class="1"  style="text-align:center;">' + (i + 1) + '</td>';
                                    results += '<td data-title="Product Name" class="2">' + msg[i].productname + '</td>';
                                    results += '<td data-title="Product Value" class="3">' + msg[i].StoresValue + '</td>';
                                    //results += '<td style="display:none;"><label id="lbl_sno"></label></td>';
                                    results += '</tr>';
                                }
                                results += '</table></div>';
                            }
                            else {
                                var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
                                results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Product Value</th></tr></thead></tbody>';
                                for (var i = 0; i < msg.length; i++) {
                                    results += '<tr><td scope="row" class="1"  style="text-align:center;">' + (i + 1) + '</td>';
                                    results += '<td data-title="Product Name" class="2">' + msg[i].productname + '</td>';
                                    results += '<td data-title="Product Quantity" class="3">' + msg[i].StoresValue + '</td>';
                                    //results += '<td style="display:none;"><label id="lbl_sno"></label></td>';
                                    results += '</tr>';
                                }
                                results += '</table></div>';
                            }
                            $("#min_report").html(results);
                        }
                    }

                        </script>
                    </div>
                <div id="min_report"></div>
            </div>
        </div>
    </section>
</asp:Content>


