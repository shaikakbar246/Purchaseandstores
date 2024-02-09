<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true"
    CodeFile="Collections.aspx.cs" Inherits="Collections" %>

<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        $(function () {
            get_collection_details();
            get_suplier_details();

            var today = new Date();
            var dd = today.getDate();
            var mm = today.getMonth() + 1;
            var yyyy = today.getFullYear();
            if (dd < 10) {
                dd = '0' + dd
            }
            if (mm < 10) {
                mm = '0' + mm
            }
            var hrs = today.getHours();
            var mnts = today.getMinutes();
            $('#txtDate').val(yyyy + '-' + mm + '-' + dd + 'T' + hrs + ':' + mnts);
        });
        function canceldetails() {
            $("#div_collectiondata").show();
            $("#fillform").hide();
            $('#showlogs').show();
            forclearall();

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

        function saveCollectionDetails() {

            var ddlsupplier = document.getElementById('ddlsupplier').value;
            if (ddlsupplier == "" || ddlsupplier == "Select Supplier") {
                alert("Select Supplier Name");
                return false;
            }
            var date = document.getElementById('txtDate').value;
            var payment = document.getElementById('paymenttype').value;
            var amount = document.getElementById('txtAmount').value;
            var remarks = document.getElementById('txtremarks').value;

            var sno = document.getElementById('lbl_sno').value;
            var btnval = document.getElementById('btn_save').value;

            var data = { 'op': 'save_Collection_Details', 'ddlsupplier': ddlsupplier, 'date': date, 'payment': payment, 'amount': amount, 'remarks': remarks, 'btnVal': btnval, 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        get_collection_details();
                        $('#div_collectiondata').show();
                        $('#fillform').css('display', 'none');
                        $('#showlogs').css('display', 'block');
                        forclearall();
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

        function showdesign() {
            $("#div_collectiondata").hide();
            $("#fillform").show();
            $('#showlogs').hide();

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
            $('#txtDate').val(yyyy + '-' + mm + '-' + dd + 'T' + hrs + ':' + mnts);
            forclearall();
        }
        function forclearall() {
            document.getElementById('txtDate').value = "";
            document.getElementById('ddlsupplier').selectedIndex = 0;
            document.getElementById('paymenttype').selectedIndex = 0;
            document.getElementById('txtAmount').value = "";

            document.getElementById('txtremarks').value = "";
            document.getElementById('btn_save').value = "Save";
            $("#lbl_code_error_msg").hide();
            $("#lbl_name_error_msg").hide();
        }

        function get_suplier_details() {
            var data = { 'op': 'get_suplier_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillsupplier(msg);
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
        function fillsupplier(msg) {
            var data = document.getElementById('ddlsupplier');
            var length = data.options.length;
            document.getElementById('ddlsupplier').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select Supplier";
            opt.value = "Select Supplier";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].suppliername != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].suppliername;
                    option.value = msg[i].supplierid;
                    data.appendChild(option);
                }
            }
        }
        function get_collection_details() {
            var data = { 'op': 'get_collection_details' };
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
        }
        function filldetails(msg) {
            var results = '<div  style="overflow:auto;"><table class="responsive-table">';
            results += '<thead><tr><th scope="col"></th><th scope="col">Supplier Name</th><th scope="col">Date</th><th scope="col">Amount</th></tr></thead></tbody>';

            var k = 1;
            var l = 0;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '"><td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
                results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].suppliername + '</th>';
                results += '<td data-title="sectioncolor" class="2">' + msg[i].date + '</td>';
                results += '<td data-title="sectionstatus" style="display:none" class="3">' + msg[i].payment + '</td>';
                results += '<td  class="4">' + msg[i].amount + '</td>';
                results += '<td style="display:none" class="5">' + msg[i].sno + '</td>';
                results += '<td data-title="sectioncolor" style="display:none"  class="6">' + msg[i].supplierid + '</td>';
                results += '<td style="display:none" class="7">' + msg[i].remarks + '</td></tr>';

                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_collectiondata").html(results);
        }
        function getme(thisid) {
            var suppliername = $(thisid).parent().parent().children('.1').html();
            var date = $(thisid).parent().parent().children('.2').html();
            var payment = $(thisid).parent().parent().children('.3').html();
            var amount = $(thisid).parent().parent().children('.4').html();
            var supplierid = $(thisid).parent().parent().children('.6').html();
            var sno = $(thisid).parent().parent().children('.5').html();
            var remarks = $(thisid).parent().parent().children('.7').html();
            document.getElementById('paymenttype').value = payment;
            document.getElementById('txtDate').value = date;
            document.getElementById('ddlsupplier').value = supplierid;
            document.getElementById('txtAmount').value = amount;
            document.getElementById('txtremarks').value = remarks;
            document.getElementById('lbl_sno').value = sno;
            document.getElementById('btn_save').value = "Modify";
            $("#div_collectiondata").hide();
            $("#fillform").show();
            $('#showlogs').hide();
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Collections  Details
        </h1>
   <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operation</a></li>
            <li><a href="#">Collections  Details</a></li>
        </ol> 
  </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Collections  Details
                </h3>
            </div>
            <div class="box-body">
                <div id="showlogs" align="center">
                    <input id="btn_addcollection" type="button" name="submit" value='Add Collections' class="btn btn-primary" onclick="showdesign()" />
                </div>
                <div id="div_collectiondata">

                </div>
           
                <div id='fillform' style="display: none;">
                   <table align="center" style="width: 60%;">
                        <tr>
                            <th>
                            </th>
                        </tr>
                        <tr>
                             <td style="height:40px;">
                                    SupplierName<span style="color: red;">*</span>
                              </td>
                               <td>
                                  <select id="ddlsupplier" class="form-control">
                                      <option selected disabled value="Select SupplierName">Select SupplierName</option>    
                                   </select>
                               </td>
                      </tr>
                       <tr>
                            <td style="height:40px;">
                             date<span style="color: red;">*</span>     
                            </td>
                            <td>
                            <input  id='txtDate' class="form-control" type="datetime-local"/>
                            </td>
                      </tr>
                        <tr>
                            <td style="height:40px;">
                             PaymentType<span style="color: red;">*</span>
                            </td>
                           <td style="height: 40px;">
                                <select id="paymenttype" class="form-control">
                                    <option value="Select PaymentType" disabled selected>Select PaymentType</option>
                                    <option value="Reciept">Reciept</option>
                                    <option value="Payment">Payment</option>
                                </select>
                            </td>
                        </tr>
                      <tr>
                           <td style="height:40px;">
                            Amount<span style="color: red;">*</span>
                            </td>
                            <td>
                                <input id="txtAmount" type="text" maxlength="45" class="form-control" name="Amount"
                                    placeholder="Enter  Amount"/><label id="Label2" class="errormessage">* Please Enter
                                        Amount</label>
                            </td>  
                      </tr>
                      <tr>
                           <td style="height:40px;">
                             Remarks<span style="color: red;">*</span>
                            </td>
                            <td>
                                <TEXTAREA id="txtremarks" type="text" maxlength="45" class="form-control" name="remarks"
                                    placeholder="Enter  Remarks"></TEXTAREA><label id="Label1" class="errormessage">* Please Enter
                                        Remarks</label>
                            </td>  
                      </tr>
                      <tr style="display:none;">
                        <td >
                        <label id="lbl_sno"></label>
                        </td>
                        </tr>
                      <tr>
                           <td colspan="2" align="center" style="height:40px;">
                              <input id="btn_save" type="button" class="btn btn-primary" name="submit" value='save' onclick="saveCollectionDetails()" />
                               <input id='btn_close' type="button" class="btn btn-danger" name="Close" value='Close' onclick="canceldetails()" />
                            </td>    
                      </tr>                  
                 </table>
              </div>
           </div> 
        </div>           
   </section>
</asp:Content>
