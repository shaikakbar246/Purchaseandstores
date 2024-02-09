<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true"
    CodeFile="Internaluse.aspx.cs" Inherits="Internaluse" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        $(function () {
            get_section_details();
            get_Poraise();
            getcode();
            get_internal_details();
        });
        function canceldetails() {
            $("#div_SectionData").show();
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
        function canceldetails() {
            $("#div_SectionData").show();
            $("#fillform").hide();
            $('#showlogs').show();
            forclearall();

        }
        function saveInternalDetails() {
            var name = document.getElementById('txtName').value;
            var date = document.getElementById('txtDate').value;
            var section = document.getElementById('ddlsection').value;
            var productname = document.getElementById('txtproductname').value;
            var hiddeproductid = document.getElementById('txtprductid').value;
            var issueremarks = document.getElementById('txtremarks').value;
            if (name == "") {

                alert("Enter  Name");
                return false;
            }
            //var sectionid = document.getElementById('lbl_sno').value;
            var sno = document.getElementById('lbl_sno').value;
            var btnval = document.getElementById('btn_save').value;
            var status = "P";
            var data = { 'op': 'saveInternalDetails', 'name': name, 'date': date, 'section': section, 'productname': productname, 'hiddeproductid': hiddeproductid, 'btnVal': btnval, 'status': status, 'sno': sno, 'issueremarks': issueremarks };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        get_internal_details();
                        $('#div_SectionData').show();
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
            $("#div_SectionData").hide();
            $("#fillform").show();
            $('#showlogs').hide();
            forclearall();
        }
        function forclearall() {
            document.getElementById('txtName').value = "";
            document.getElementById('txtDate').value = "";
            document.getElementById('ddlsection').selectedIndex = 0;
            document.getElementById('txtproductname').value = "";
            document.getElementById('lbl_sno').value = "";
            document.getElementById('txtremarks').value = "";
            document.getElementById('btn_save').value = "Save";
            $("#lbl_code_error_msg").hide();
            $("#lbl_name_error_msg").hide();
        }

        function get_section_details() {
            var data = { 'op': 'get_section_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillsection(msg);
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

        function fillsection(msg) {
            var data = document.getElementById('ddlsection');
            var length = data.options.length;
            document.getElementById('ddlsection').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select Section";
            opt.value = "Select Section";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].sectionname != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].sectionname;
                    option.value = msg[i].SectionId;
                    data.appendChild(option);
                }
            }
        }
        var productdetails = [];
        function getcode() {
            var data = { 'op': 'get_Poraise' };
            var s = function (msg) {
                if (msg) {
                    productdetails = msg;
                    var availableTags = [];
                    for (i = 0; i < msg.length; i++) {
                        availableTags.push(msg[i].productname);
                    }
                    $("#txtproductname").autocomplete({
                        source: function (req, responseFn) {
                            var re = $.ui.autocomplete.escapeRegex(req.term);
                            var matcher = new RegExp("^" + re, "i");
                            var a = $.grep(availableTags, function (item, index) {
                                return matcher.test(item);
                            });
                            responseFn(a);
                        },
                        change: productchange,
                        autoFocus: true
                    });
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        function productchange() {
            var name = document.getElementById('txtproductname').value;
            for (var i = 0; i < productdetails.length; i++) {
                if (name == productdetails[i].productname) {
                    document.getElementById('txtprductid').value = productdetails[i].productid;
                }
            }
        }
        function get_Poraise() {
            var data = { 'op': 'get_Poraise' };
            var s = function (msg) {
                if (msg) {
                    if (msg.i > 0) {
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
        function get_internal_details() {
            var data = { 'op': 'get_internal_details' };
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
            results += '<thead><tr><th scope="col"></th><th scope="col">Name</th><th scope="col">Date</th><th scope="col">section</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="Enable" /></td>';
                results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].name + '</th>';
                results += '<td data-title="sectioncolor" class="2">' + msg[i].date + '</td>';
                results += '<td data-title="sectionstatus" class="3">' + msg[i].section + '</td>';
                results += '<td style="display:none" class="4">' + msg[i].productname + '</td>';
                results += '<td style="display:none" class="5">' + msg[i].sno + '</td>';
                results += '<td style="display:none" class="6">' + msg[i].issueremarks + '</td>';
                results += '<td style="display:none" class="7">' + msg[i].hiddeproductid + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
        }
        function getme(thisid) {
            var name = $(thisid).parent().parent().children('.1').html();
            var date = $(thisid).parent().parent().children('.2').html();
            var section = $(thisid).parent().parent().children('.3').html();
            var productname = $(thisid).parent().parent().children('.4').html();
            var hiddeproductid = $(thisid).parent().parent().children('.7').html();
            var sno = $(thisid).parent().parent().children('.5').html();
            var issueremarks = $(thisid).parent().parent().children('.6').html();
            document.getElementById('txtName').value = name;
            document.getElementById('txtDate').value = date;
            document.getElementById('ddlsection').value = section;
            document.getElementById('txtproductname').value = productname;
            document.getElementById('txtremarks').value = issueremarks;
            document.getElementById('txtprductid').value = hiddeproductid;
            document.getElementById('lbl_sno').value = sno;
            document.getElementById('btn_save').value = "Modify";
            $("#div_SectionData").hide();
            $("#fillform").show();
            $('#showlogs').hide();
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Internal Use
        </h1>
   <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operation</a></li>
            <li><a href="#">Internal Use</a></li>
        </ol> 
  </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Internal Use Details
                </h3>
            </div>
            <div class="box-body">
                <div id="showlogs" align="center">
                    <input id="btn_addNewSection" type="button" name="submit" value='AddNewSection' class="btn btn-primary" onclick="showdesign()" />
                </div>
                <div id="div_SectionData">

                </div>
           
                <div id='fillform' style="display: none;">
                   <table align="center" style="width: 60%;">
                        <tr>
                            <th>
                            </th>
                        </tr>
                        <tr>
                            <td style="height:40px;">
                             Name<span style="color: red;">*</span>
                            </td>
                            <td>
                                <input id="txtName" type="text" maxlength="45" class="form-control" name="vendorcode"
                                    placeholder="Enter  Name"/><label id="lbl_code_error_msg" class="errormessage">* Please Enter
                                        Name</label>
                            </td>
                        </tr>
                      <tr>
                            <td style="height:40px;">
                             date<span style="color: red;">*</span>     
                            </td>
                            <td>
                            <input type="date" id='txtDate'/>
                                
                            </td>
                      </tr>
                      <tr>
                             <td style="height:40px;">
                                    Section<span style="color: red;">*</span>
                              </td>
                               <td>
                                  <select id="ddlsection" class="form-control">
                                      <option selected disabled value="Select Section">Select Section</option>    
                                   </select>
                               </td>
                      </tr>
                    
                      <tr>
                           <td style="height:40px;">
                             Product Name<span style="color: red;">*</span>
                            </td>
                            <td>
                                <input id="txtproductname" type="text" maxlength="45" class="form-control" name="vendorcode"
                                    placeholder="Enter  Product"/><label id="Label2" class="errormessage">* Please Enter
                                        Product</label>
                            </td>  
                      </tr>
                      <tr>
                           <td style="height:40px;">
                             Remarks<span style="color: red;">*</span>
                            </td>
                            <td>
                                <input id="txtremarks" type="text" maxlength="45" class="form-control" name="vendorcode"
                                    placeholder="Enter  Product"/><label id="Label1" class="errormessage">* Please Enter
                                        Remarks</label>
                            </td>  
                      </tr>
                      <tr style="display:none;">
                        <td >
                        <label id="lbl_sno"></label>
                        </td>
                          <td style="height: 40px;">
                                <input id="txtprductid" type="hidden" class="form-control" name="hiddeproductid" />
                            </td>
                        </tr>
                      <tr>
                           <td colspan="2" align="center" style="height:40px;">
                              <input id="btn_save" type="button" class="btn btn-primary" name="submit" value='save' onclick="saveInternalDetails()" />
                               <input id='btn_close' type="button" class="btn btn-danger" name="Close" value='Close' onclick="canceldetails()" />
                            </td>    
                      </tr>                  
                 </table>
              </div>
           </div> 
        </div>           
   </section>
</asp:Content>
