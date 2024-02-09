<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true" CodeFile="StoresConsumption.aspx.cs" Inherits="StoresConsumption" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
  <script type="text/javascript">
//      $(function () {
//          get_Stock_Opening_Details();
//      });
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
      var fillstoresconsumption = [];
      function Save_stores_Consumption_Details() {
          fillstoresconsumption = [];
          var btnval = document.getElementById('btn_save').value;
          var doe = document.getElementById('txtdate').value;
          $('#tabledetails> tbody > tr').each(function () {
              var qty = $(this).find('#txtqty').val();
              var price = $(this).find('#txtCost').val();
              var hdnproductsno = $(this).find('#hdnproductsno').val();
              if (hdnproductsno == "" || hdnproductsno == "0" && qty == "" || qty == "0") {
              }
              else {
                  fillstoresconsumption.push({ 'qty': qty, 'price': price, 'productid': hdnproductsno });
              }
          });
          var Data = { 'op': 'Save_stores_Consumption_Details', 'doe': doe, 'btnval': btnval, 'fillstoresconsumption': fillstoresconsumption };
          var s = function (msg) {
              if (msg) {
                  alert(msg);
              }
          }
          var e = function (x, h, e) {
          };
          CallHandlerUsingJson_POST(Data, s, e);
      }
      function get_StoresConsumption_Details() {
          var doe = document.getElementById('txtdate').value;
          var data = { 'op': 'get_StoresConsumption_Details', 'doe': doe };
          var s = function (msg) {
              if (msg) {
                  if (msg == "Close previous day transaction") {
                      alert(msg);
                      return false;
                  }
                  else {
                      if (msg.length > 0) {
                          fillstockclosing(msg);
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
      function fillstockclosing(msg) {
          var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
          results += '<thead><tr><th scope="col">ProductName</th><th scope="col">Opp bal</th><th scope="col">Inward</th><th scope="col">Outward</th><th scope="col">Transfer</th><th scope="col">Clo Bal</th><th scope="col">Price</th></tr></thead></tbody>';
          for (var i = 0; i < msg.length; i++) {
              results += '<tr><td data-title="From">' + msg[i].productname + ' </td>';
              results += '<td data-title="From">' + msg[i].oppbal + ' </td>';
              results += '<td data-title="From">' + msg[i].inward + ' </td>';
              results += '<td data-title="From">' + msg[i].outward + ' </td>';
              results += '<td data-title="From">' + msg[i].transfer + ' </td>';
              results += '<td data-title="From"><input class="3" id="txtqty" readonly name="description" class="clsdesc" value="' + msg[i].clobal + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
              results += '<td data-title="From"><input class="clscost" id="txtCost" readonly name="cost"  value="' + msg[i].price + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></td>';
              //results += '<td data-title="From"><input  id="txtDate" name="date" class="clsdate" value="' + msg[i].doe + '" onkeypress="return isFloat(event)"  style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></td>';
              results += '<td data-title="From"><input class="3" id="hdnproductsno" type="hidden"  name="hdnproductsno" value="' + msg[i].productid + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td></tr>';
          }
          results += '</table></div>';
          $("#div_SectionData").html(results);
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
            Stores Consumption <small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operations</a></li>
            <li><a href="#">Stores Consumption</a></li>
        </ol>
    </section>
    <section class="content">
     <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Stores Consumption  Details
                </h3>
            </div>
        <div class="box-body">
            <div id="showlogs" align="center">
                <table>
                    <tr>
                        <td>
                            <label>
                                Select Date</label>
                        </td>
                        <td>
                            <input id="txtdate" type="date" class="form-control" name="ClosingDate"/>
                        </td>
                        <td style="width:6px;"></td>
                        <td>
                            <input id="add_Stock" type="button" name="submit" value='GENARATE' class="btn btn-primary" onclick="get_StoresConsumption_Details();"/>
                        </td>
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
                                <input type="button" class="btn btn-primary" id="btn_save" value="Save" onclick="Save_stores_Consumption_Details();" />
                                <input type="button" class="btn btn-danger" id="close_vehmaster" value="Close" />
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
