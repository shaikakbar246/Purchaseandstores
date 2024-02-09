<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true" CodeFile="Quotation_Request_Report.aspx.cs" Inherits="Quotation_Request_Report" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .container
        {
            max-width: 100%;
        }
        th
        {
            text-align: center;
        }
    </style>
    <script type="text/javascript">
        function CallPrint(strid) {
            var divToPrint = document.getElementById(strid);
            var newWin = window.open('', 'Print-Window', 'width=400,height=400,top=100,left=100');
            newWin.document.open();
            newWin.document.write('<html><body   onload="window.print()">' + divToPrint.innerHTML + '</body></html>');
            newWin.document.close();
        }
    </script>
    <script type="text/javascript">
        $(function () {
            scrollTo(0, 0);
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

        function btn_Quotation_Details_click() {
            var from_date = document.getElementById('txt_from').value;
            if (from_date == "")
            {
                alert("Enter From Date");
                return false;
            }
            var to_date = document.getElementById('txt_to').value;
            if (to_date == "") {
                alert("Enter To Date");
                return false;
            }
            var data = { 'op': 'get_quotation_req_date', 'from_date': from_date, 'to_date': to_date };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fill_quotation_det(msg);

                    }
                    else
                    {
                        fill_quotation_det(msg);
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

        function fill_quotation_det(msg) {
            if (msg.length > 0) {
                var l = 0;
                var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
                var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
                results += '<thead><tr style="background:#3c8dbc; color: white; font-weight: bold;"><th scope="col"></th><th scope="col">Quotation No</th><th scope="col">Quotation Date</th><th scope="col">Supplier Name</th></tr></thead></tbody>';
                for (var i = 0; i < msg.length; i++) {
                    results += '<tr style="background-color:' + COLOR[l] + '">';//<td><input id="btn_print" type="button"  onclick="printclick(this)" name="Print" class="btn btn-primary" value="Print" /></td>
                    results += '<td data-title="brandstatus"><button type="button" title="Click Here To Print!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 printcls"  onclick="printclick(this)"><span class="glyphicon glyphicon-print" style="top: 0px !important;"></span></button></td>';
                    results += '<td data-title="Quotation No" class="1" >' + msg[i].quo_no + '</td>';
                    results += '<td data-title="Quotation Date" class="2">' + msg[i].quo_dt + '</td>';
                    results += '<td data-title="Supplier Name" class="3">' + msg[i].sup_name + '</td>';
                    results += '<td style="display:none;" data-title="Supplier Name" class="4">' + msg[i].sup_id + '</td>';
                    results += '<td style="display:none;" data-title="sno" class="11">' + msg[i].sno + '</td></tr>';
                    l = l + 1;
                    if (l == 4) {
                        l = 0;
                    }
                }
                results += '</table></div>';
                $("#div_quotation_det").html(results);
            }
            else {
                msg = "NO DATA FOUND";
                results = msg.fontcolor("red");
                $("#div_quotation_det").html(results);
            }
        }
        function printclick(thisid) {
            var refdcno = $(thisid).parent().parent().children('.1').html();
            var date = new Date();
            var data = { 'op': 'get_quotation_details_click', 'refdcno': refdcno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        $('#divPrint').css('display', 'block');
                        $('#Button2').css('display', 'block');
                        var quo_req_det = msg[0].DataTable;
                        var quo_prod_det = msg[0].DataTable1;
                        document.getElementById('spn_quo_no').innerHTML = quo_req_det[0].quo_no;
                        document.getElementById('spnAddress').innerHTML = quo_req_det[0].Add_ress;
                        document.getElementById('spn_sup_name').innerHTML = quo_req_det[0].sup_name;
                        document.getElementById('spn_sup_str1').innerHTML = quo_req_det[0].street1;
                        document.getElementById('spn_sup_str2').innerHTML = quo_req_det[0].street2;
                        document.getElementById('spn_sup_city').innerHTML = quo_req_det[0].city;
                        document.getElementById('spn_sup_state').innerHTML = quo_req_det[0].state;
                        document.getElementById('spn_date').innerHTML = (date.getDate() < 10 ? '0' : '') + date.getDate() + "-" + (date.getMonth() < 10 ? '0' : '') + (date.getMonth() + 1) + "-" + date.getFullYear();
                        fill_quotation_details(quo_prod_det);
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
        function fill_quotation_details(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" border="2" style="width:100%;">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Product Code</th><th scope="col">Description</th><th scope="col">UOM</th><th scope="col">Required Qty</th></tr></thead></tbody>';
            var j = 1;
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><th scope="row" class="1" style="text-align:center;">' + (i + 1) + '</th>';
                results += '<td data-title="Product Name" style="text-align:center;" class="2">' + msg[i].prod_name + '</td>';
                results += '<td data-title="Product Code" style="text-align:center;" class="5">' + msg[i].prod_code + '</td>';
                results += '<td data-title="Description" style="text-align:center;" class="6">' + msg[i].desc + '</td>';
                results += '<td data-title="UOM" class="3" style="text-align:center;">' + msg[i].uom + '</td>';
                results += '<td data-title="Required Qty" style="text-align:center;" class="4">' + msg[i].qty + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_itemdetails").html(results);
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <section class="content-header">
        <h1>
            Quotation Request Report
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i></a></li>
            <li><a href="#">Quotation Request Report</a></li>
        </ol>
    </section>
    <section class="content">
            <div class="box box-info">
                <div id="div_Account">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Quotation Request Report
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
                                            From Date
                                        </label>
                                    </td>
                                    <td>
                                        <input type="date" id="txt_from" class="form-control" name="from_date" />
                                    </td>
                                    <td style="width:5px;"></td>
                                    <td style="height: 40px;">
                                        <label>
                                            To Date
                                        </label>
                                    </td>
                                    <td>
                                        <input type="date" id="txt_to" class="form-control" name="to_date" />
                                    </td>
                                     <td style="width:5px;"></td>
                                    <td style="height: 40px;">
                                        <div class="input-group">
                                            <div class="input-group-addon">
                                                <span class="glyphicon glyphicon-flash" onclick="btn_Quotation_Details_click();"></span> <span id="btn_generate" onclick="btn_Quotation_Details_click();">Generate</span>
                                            </div>
                                        </div>
                                    </td>
                                    
                                </tr>
                            </table>
                            <div id="div_quotation_det">
                            </div>
                        </div>
                    </div>
                    <div id="divPrint" style="display: none;">
                <div >
                    <div style="width: 13%; float: right;">
                        <img src="Images/Vyshnavilogo.png" alt="Vyshnavi" width="100px" height="72px" />
                        <br />
                    </div>
                    <div>
                        <div style="font-family: Arial; font-size: 14px; font-weight: bold; color: Black;">
                            <span>Sri Vyshnavi Dairy Specialities (P) Ltd </span>
                            <br />
                        </div>
                        <div style="width:33%;">
                        <span id="spnAddress" style="font-size: 14px;"></span>
                        </div>
                    </div>
                    <div align="center" style="border-bottom: 1px solid gray; border-top: 1px solid gray;">
                        <span style="font-size: 18px; font-weight: bold;">REQUEST FOR QUOTATION</span>
                    </div>
                    <div style="width: 100%;">
                        
                        <table style="width: 100%;">
                            <tr>

                                <td >
                                    <label style="font-size: 16px"><b>
                            Quotation No:</b></label>
                                    <span id="spn_quo_no"></span>
                                </td>
                                </tr>
                            <tr>
                                <td><label style="font-size: 16px"><b>
                            Date:</b></label><span id="spn_date"></span></td>
                                
                            </tr>
                        </table>
                    </div>
                    <div style="text-align: center; border-top: 1px solid gray;">
                        <br />
                    </div>
                    <table><tr><td><label style="font-size: 16px"><b>
                            Mr/Mrs:</b></label><span id="spn_sup_name" style="font-weight:bold"></span></td></tr></table>
                    
                    <span id="spn_sup_str1"></span><span id="spn_sup_str2"></span>
                    <br />
                    <span id="spn_sup_city"></span>
                    <br />
                    <span id="spn_sup_state"></span>
                    <br />
                    <label style="font-size: 16px"><b>
                        Dear Sir/Madam,</b>
                    </label>
                    <br />
                    <label style="font-size: 16px"><b>
                        Subject : Request for Quotation,</b>
                    </label>
                    <div style="text-align: center;">
                        We here by requesting the Quotation of following items with your Terms and Conditions:
                    </div>
                    <div id="div_itemdetails">
                    </div>
                    Please note that it is not a Order. It is an enquiry. Do not supply materials based on this enquiry. Please prefer to give quote for  Energy saving items if available in the market. <br />   <br />
                    
                    Thanks & Regards<br />   <br />
                    for SRI VYSHNAVI DAIRY SPECIALITIES PVT LTD., <br />   <br /> <br />   <br />
                    K.R.Gupta<br />   <br />
                    Manager(Stores & Purchase),Sri Vyshnavi Dairy Specialties Pvt Ltd,<br />Ph : 7729995606, <br />E- mail ID: purchase@vyshnavi.in; <br />gupta@vyshnavi.in                <br /> <br /><br />
                    <table style="width: 100%;">
                        <tr>
                            <td style="width: 25%;">
                                <span style="font-weight: bold; font-size: 12px;">MANAGER(Stores&Purchase)</span>
                            </td>
                            <td style="width: 25%;">
                                <span style="font-weight: bold; font-size: 12px;">GENERAL MANAGER</span>
                            </td>
                            <td style="width: 25%;">
                                <span style="font-weight: bold; font-size: 12px;">DIRECTOR</span>
                            </td>
                        </tr>
                    </table>    
                </div>
                         </div>
                <table align="center"><tr><td>
                <div class="input-group" id="Button2" style="display:none">
                    <div class="input-group-addon">
                        <span class="glyphicon glyphicon-print" onclick="javascript: CallPrint('divPrint');"></span> <span id="Span1" onclick="javascript: CallPrint('divPrint');">Print</span>
                    </div>
                </div> 
                </td></tr></table>
                </div>
            </div>
        </section>
</asp:Content>

