<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true"
    CodeFile="StockClosing.aspx.cs" Inherits="StockClosing" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        $(function () {
            get_Category_details();
            scrollTo(0, 0);
            var today = new Date();
            var dd = today.getDate();
            var mm = today.getMonth() + 1; //January is 0!
            var yyyy = today.getFullYear(); 
            if (dd < 10) {
                dd = '0' + dd
            }
            if (mm < 10) {
                mm = '0' + mm
            }
            var hrs = today.getHours();
            var mnts = today.getMinutes();
            $('#txtClosingdate').val(yyyy + '-' + mm + '-' + dd);
        });
        function CallHandlerUsingJson_POST(d, s, e) {
            d = JSON.stringify(d);
            d = encodeURIComponent(d);
            $.ajax({
                type: "POST",
                url: "FleetManagementHandler.axd",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                data: d,
                async: true,
                cache: true,
                success: s,
                error: e
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

        function get_Stock_Opening_Details() {
            var category = document.getElementById('ddlcategory').value;
            var data = { 'op': 'get_Stock_Opening_Details', 'category':category };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillstockopening(msg);
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
        function fillstockopening(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr class="trbgclrcls"><th scope="col">Product Name</th><th scope="col">Qty</th><th scope="col">Price</th><th scope="col">Value</th></tr></thead></tbody>';

            var k = 1;
            var l = 0;
            //var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '"><td data-title="From" style="display:none;"><input id="txtProductname" class="productcls" name="code" readonly value="' + msg[i].productname + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                results += '<td data-title="From">' + msg[i].productname + '</td>';
                results += '<td data-title="From"><input class="3" id="txtqty"  name="description" class="clsdesc" value="' + msg[i].qty + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                results += '<td data-title="From"><input class="clscost" id="txtCost"  name="cost"  value="' + msg[i].price + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                results += '<td data-title="From">' + msg[i].value + '</td>';
                results += '<td style="display:none;"><input class="3" id="hdnproductsno" type="hidden"  name="hdnproductsno" value="' + msg[i].productid + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td></tr>';

                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
        }

         var fillstockclosing = [];
         function Save_Stock_Closing_Details() {
             var btnval = document.getElementById('btn_save').innerHTML;
             var doe = document.getElementById('txtClosingdate').value;
             $('#tabledetails> tbody > tr').each(function () {
                 var productname = $(this).find('#txtProductname').val();
                 var qty = $(this).find('#txtqty').val();
                 var price = $(this).find('#txtCost').val();
                 var hdnproductsno = $(this).find('#hdnproductsno').val();
                 if (hdnproductsno == "" || hdnproductsno == "0" && qty == "" || qty == "0") {
                 }
                 else {

                     fillstockclosing.push({ 'productname': productname, 'qty': qty, 'price': price, 'productid': hdnproductsno });
                 }
             });
             var Data = { 'op': 'Save_Stock_Closing_Details', 'doe': doe, 'btnval': btnval, 'fillstockclosing': fillstockclosing };
             var s = function (msg) {
                 if (msg) {
                     alert(msg);
                     get_Stock_Closing_Details();
                     scrollTo(0, 0);
                 }
             }
             var e = function (x, h, e) {
             };
             CallHandlerUsingJson_POST(Data, s, e);
         }
         function Categorychange() {
             get_Stock_Opening_Details();
             scrollTo(0, 0);
         }
         function get_Stock_Closing_Details() {
             var doe = document.getElementById('txtClosingdate').value;
             var data = { 'op': 'get_Stock_Closing_Details', 'doe':doe };
             var s = function (msg) {
                 if (msg) {
                     if (msg.length > 0) {
                        //fillstockclosing(msg);
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
         function fillstockclosing(msg) {
             var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
             results += '<thead><tr><th scope="col">Product Name</th><th scope="col">Qty</th><th scope="col">Price</th></tr></thead></tbody>';
             var k = 1;
             var l = 0;
             var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
           
             for (var i = 0; i < msg.length; i++) {
                 results += '<tr style="background-color:' + COLOR[l] + '"><td data-title="From" style="display:none;"><input id="txtProductname" class="productcls" name="code" readonly value="' + msg[i].productname + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                 results += '<td data-title="From">' + msg[i].productname + '</td>';
                 results += '<td data-title="From"><input class="3" id="txtqty"  name="description" class="clsdesc" value="' + msg[i].qty + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                 results += '<td data-title="From"><input class="clscost" id="txtCost"  name="cost"  value="' + msg[i].price + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                 //results += '<td data-title="From"><input  id="txtDate" name="date" class="clsdate" value="' + msg[i].doe + '" onkeypress="return isFloat(event)"  style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></td>';
                 results += '<td data-title="From"><input class="3" id="hdnproductsno" type="hidden"  name="hdnproductsno" value="' + msg[i].productid + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td></tr>';

                 l = l + 1;
                 if (l == 4) {
                     l = 0;
                 }
             }
             results += '</table></div>';
             $("#div_SectionData").html(results);
         }

         function get_Category_details() {
             var data = { 'op': 'get_Category_details' };
             var s = function (msg) {
                 if (msg) {
                     if (msg.length > 0) {
                         fillcategiry(msg);
                     }
                     else {
                     }
                 }
                 else {
                 }
             };
             var e = function (x, h, e) {
             }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
             callHandler(data, s, e);
         }
         function fillcategiry(msg) {
             var data = document.getElementById('ddlcategory');
             var length = data.options.length;
             document.getElementById('ddlcategory').options.length = null;
             var opt = document.createElement('option');
             opt.innerHTML = "Select Category";
             opt.value = "Select Category";
             opt.setAttribute("selected", "selected");
             opt.setAttribute("disabled", "disabled");
             opt.setAttribute("class", "dispalynone");
             data.appendChild(opt);
             for (var i = 0; i < msg.length; i++) {
                 if (msg[i].Category != null) {
                     var option = document.createElement('option');
                     option.innerHTML = msg[i].Category;
                     option.value = msg[i].cat_code;
                     data.appendChild(option);
                 }
             }
         }

         function CallHandlerUsingJson_POST(d, s, e) {
             d = JSON.stringify(d);
             //    d = d.replace(/&/g, '\uFF06');
             //    d = d.replace(/#/g, '\uFF03');
             //    d = d.replace(/\+/g, '\uFF0B');
             //    d = d.replace(/\=/g, '\uFF1D');
             d = encodeURIComponent(d);
             $.ajax({
                 type: "POST",
                 url: "FleetManagementHandler.axd",
                 dataType: "json",
                 contentType: "application/json; charset=utf-8",
                 data: d,
                 async: true,
                 cache: true,
                 success: s,
                 error: e
             });
         }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Stock Closing <small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operations</a></li>
            <li><a href="#">Stock Closing</a></li>
        </ol>
    </section>
    <section class="content">
     <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Stock Closing  Details
                </h3>
            </div>
        <div class="box-body">
            <div id="showlogs" align="center">
                <table>
                    <tr>
                             <td style="height: 40px;">
                                <label>Category</label><span style="color: red;">*</span>
                            </td>
                            <td>
                                <select id="ddlcategory" class="form-control" onchange="Categorychange();">
                                    <option selected disabled value="Select Category">Select Category</option>
                                </select>
                            </td>
                        <td style="width:6px;"></td>
                        <td>
                            <label>
                                Select Date</label>
                        </td>
                        <td>
                            <input id="txtClosingdate" type="date" class="form-control" name="ClosingDate" />
                        </td>
                        <td style="width:6px;"></td>
                        <%--<td>
                            <input id="add_Stock" type="button" name="submit" value='GENARATE' class="btn btn-primary" onclick="get_Stock_Closing_Details();"/>
                        </td>--%>
                    </tr>
                </table>
            </div>
            <%-- <div id="div_stocktransfer">
                </div>--%>
            <div id="div_SectionData">
            </div>
            <div id='fillform'>
                <div>
                    <table align="center">
                        <tr>
                            <td>
                                <%--<input type="button" class="btn btn-primary" id="btn_save" value="Save" onclick="Save_Stock_Closing_Details();" />
                                <input type="button" class="btn btn-danger" id="close_vehmaster" value="Close" />--%>
                                <table>
                                   <tr>
                                    <td>
                                    <div class="input-group">
                                        <div class="input-group-addon">
                                        <span class="glyphicon glyphicon-ok" id="btn_save1" onclick="Save_Stock_Closing_Details()"></span> <span id="btn_save" onclick="Save_Stock_Closing_Details()">Save</span>
                                  </div>
                                  </div>
                                    </td>
                                    <td style="width:10px;"></td>
                                    <td>
                                     <div class="input-group">
                                        <div class="input-group-close">
                                        <span class="glyphicon glyphicon-remove" id='close_vehmaster1'></span> <span id='close_vehmaster'>Close</span>
                                  </div>
                                  </div>
                                    </td>
                                    </tr>
                               </table>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
        <%-- </div>--%>
        </div>
        
    </section>
</asp:Content>
