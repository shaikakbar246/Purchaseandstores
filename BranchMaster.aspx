<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true"
    CodeFile="BranchMaster.aspx.cs" Inherits="BranchMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            get_Branch_details();
            get_branchnames();
            get_statemaster_det();
            $('#tblbranchdata').DataTable({
                "paging": false,
                "lengthChange": false,
                "searching": false,
                "ordering": true,
                "info": true,
                "autoWidth": false
            });
        });
        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }
        function ValidateAlpha(evt) {
            var keyCode = (evt.which) ? evt.which : evt.keyCode
            if ((keyCode < 65 || keyCode > 90) && (keyCode < 97 || keyCode > 123) && keyCode != 32)

                return false;
            return true;
        }
        function validationemail() {
            var x = document.getElementById("txtMail").value;
            var atpos = x.indexOf("@");
            var dotpos = x.lastIndexOf(".");
            if (atpos < 1 || dotpos < atpos + 2 || dotpos + 2 >= x.length) {
                alert("Not a valid e-mail address");
            }
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
        function cancelbranchdetails() {
            $("#div_BranchData").show();
            $("#Branch_fillform").hide();
            $('#showlogs').show();
            forclearall();
            scrollTo(0, 0);
        }
        function saveBranchDetails() {
            var branchname = document.getElementById('txtBrcName').value;
            var tinno = document.getElementById('txtTin').value;
            var Phone = document.getElementById('txtPhnNO').value;
            var emailid = document.getElementById('txtMail').value;
            var address = document.getElementById('txtAdrs').value;
            var cstno = document.getElementById('txtCst').value;
            var stno = document.getElementById('txtStNO').value;
            var type = document.getElementById('slct_type').value;
            var warehouse = document.getElementById('txt_warehouse').value;
            var tally_branch = document.getElementById('txt_tally_branch').value;
            var acc_branch = document.getElementById('txt_acc_branch').value;
            var branchid = document.getElementById('lbl_sno').value;
            var btnval = document.getElementById('btn_save').innerHTML;
            if (branchname == "") {
                alert("Enter branchname name");
                document.getElementById("txtBrcName").focus();
                return false;
            }
            if (tinno == "") {
                alert("Enter  tinno");
                document.getElementById("txtTin").focus();
                return false;
            }

            //if (emailid == "") {
            //    alert("Enter Section emailid");
            //    document.getElementById("txtMail").focus();
            //    return false;
            //}

            //var atpos = emailid.indexOf("@");
            //var dotpos = emailid.lastIndexOf(".");
            //if (atpos < 1 || dotpos < atpos + 2 || dotpos + 2 >= emailid.length) {
            //    alert("enter valid e-mail address");
            //    document.getElementById("txtMail").focus();
            //    return false;
            //}

            if (cstno == "") {
                alert("Enter Section cstno");
                document.getElementById("txtCst").focus();
                return false;
            }

            if (type == "") {
                alert("Select Branch Type");
                document.getElementById("slct_type").focus();
                return false;
            }

            if (warehouse == "") {
                alert("Enter warehouse code");
                return false;
            }

            var statename = document.getElementById('slct_state_name').value;
            if (statename == "")
            {
                alert("Select State Name");
                return false;
            }
            var gst_reg_type = document.getElementById('slct_gst_reg_type').value;
            if (gst_reg_type == "")
            {
                alert("Select GST Registration Type");
                return false;
            }
            var gstin = document.getElementById('txt_gstin').value;
            if (gstin == "")
            {
                alert("Enter GSTIN No");
                return false;
            }

            var data = { 'op': 'saveBranchDetails', 'branchname': branchname, 'branchid': branchid, 'tinno': tinno, 'Phone': Phone, 'emailid': emailid, 'address': address, 'cstno': cstno, 'stno': stno, 'type': type, 'warehouse': warehouse, 'tally_branch': tally_branch, 'acc_branch': acc_branch, 'statename': statename, 'gst_reg_type': gst_reg_type, 'gstin': gstin, 'btnVal': btnval };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        forclearall();
                        get_Branch_details();
                        $('#div_BranchData').show();
                        $('#Branch_fillform').css('display', 'none');
                        $('#showlogs').css('display', 'block');
                        scrollTo(0, 0);
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
        function forclearall() {
            document.getElementById('txtBrcName').value = "";
            document.getElementById('txt_branch_search').value = "";
            document.getElementById('txt_branch_searchid').value = "";
            document.getElementById('txtTin').value = "";
            document.getElementById('txtPhnNO').value = "";
            document.getElementById('txtMail').value = "";
            document.getElementById('txtAdrs').value = "";
            document.getElementById('txtCst').value = "";
            document.getElementById('txtStNO').value = "";
            document.getElementById('slct_type').selectedIndex = 0;
            document.getElementById('txt_warehouse').value = "";
            document.getElementById('txt_tally_branch').value = "";
            document.getElementById('slct_state_name').selectedIndex = 0;
            document.getElementById('slct_gst_reg_type').selectedIndex = 0;
            document.getElementById('txt_gstin').value = "";
            document.getElementById('btn_save').value = "save";
            get_Branch_details();
        }
        function showbranchdesign() {
            $("#div_BranchData").hide();
            $("#Branch_fillform").show();
            $('#showlogs').hide();
            forclearall();
            scrollTo(0, 0);
        }

        function get_Branch_details() {
            var data = { 'op': 'get_Branch_details' };
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
            scrollTo(0, 0);
            var results = '<div class="col-md-12"><table id="tblbranchdata" class="table table-bordered table-hover dataTable" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr role="row" class="trbgclrcls"><th scope="col" class="thcls">Branch Name </th><th scope="col" class="thcls">Tin No</th><th scope="col" class="thcls">Branch Type</th><th scope="col" class="thcls">WH Code</th><th scope="col" class="thcls">Tally Branch Name</th><th></th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">';
                results += '<td  scope="row" class="1 tdmaincls">' + msg[i].branchname + '</td>';// style="font-weight: 600;"
                results += '<td data-title="brandstatus" style="display:none" class="2">' + msg[i].branchid + '</td>';
                results += '<td data-title="brandstatus" class="3">' + msg[i].tinno + '</td>';
                results += '<td data-title="brandstatus"style="display:none" class="4">' + msg[i].Phone + '</td>';
                results += '<td data-title="brandstatus" style="display:none"class="6">' + msg[i].address + '</td>';
                results += '<td data-title="brandstatus" style="display:none" class="7">' + msg[i].cstno + '</td>';
                results += '<td data-title="brandstatus" class="11"><span class="glyphicon glyphicon-th-list" style="color: cadetblue;"></span> <span id="11">' + msg[i].type + '</span></td>';
                results += '<td data-title="brandstatus" class="9">' + msg[i].warehouse + '</td>';
                results += '<td data-title="brandstatus" class="10">' + msg[i].tally_branch + '</td>';
                results += '<td data-title="brandstatus"><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"  onclick="getme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td>';
                results += '<td style="display:none" class="5">' + msg[i].emailid + '</td>';
                results += '<td style="display:none" class="12">' + msg[i].gst_no + '</td>';
                results += '<td style="display:none" class="13">' + msg[i].gst_reg_type + '</td>';
                results += '<td style="display:none" class="14">' + msg[i].state + '</td>';
                results += '<td style="display:none" class="8">' + msg[i].stno + '</td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_BranchData").html(results);
        }

        function getme(thisid) {
            scrollTo(0, 0);
            var branchname = $(thisid).parent().parent().children('.1').html();
            var branchid = $(thisid).parent().parent().children('.2').html();
            var tinno = $(thisid).parent().parent().children('.3').html();
            var Phone = $(thisid).parent().parent().children('.4').html();
            var emailid = $(thisid).parent().parent().children('.5').html();
            var address = $(thisid).parent().parent().children('.6').html();
            var cstno = $(thisid).parent().parent().children('.7').html();
            var stno = $(thisid).parent().parent().children('.8').html();
            var warehouse = $(thisid).parent().parent().children('.9').html();
            var tally_branch = $(thisid).parent().parent().children('.10').html();
            var type = $(thisid).parent().parent().find('#11').html();
            var gst_no = $(thisid).parent().parent().children('.12').html();
            var gst_reg_type = $(thisid).parent().parent().children('.13').html();
            var state = $(thisid).parent().parent().children('.14').html();

            document.getElementById('txtBrcName').value = branchname;
            document.getElementById('txtTin').value = tinno;
            document.getElementById('txtPhnNO').value = Phone;
            document.getElementById('txtMail').value = emailid;
            document.getElementById('txtAdrs').value = address;
            document.getElementById('txtCst').value = cstno;
            document.getElementById('txtStNO').value = stno;
            document.getElementById('txt_warehouse').value = warehouse;
            document.getElementById('slct_type').value = type;
            document.getElementById('txt_tally_branch').value = tally_branch;
            document.getElementById('lbl_sno').value = branchid;
            document.getElementById('slct_state_name').value = state;
            document.getElementById('slct_gst_reg_type').value = gst_reg_type;
            document.getElementById('txt_gstin').value = gst_no;
            document.getElementById('btn_save').innerHTML = "Modify";
            $("#div_BranchData").hide();
            $("#Branch_fillform").show();
            $('#showlogs').hide();

        }

        var branchnames = [];
        function get_branchnames() {
            var data = { 'op': 'get_Branch_details' };
            var s = function (msg) {
                if (msg) {
                    branchnames = msg;
                    var availableTags = [];
                    for (var i = 0; i < msg.length; i++) {
                        var branchname = msg[i].branchname;
                        availableTags.push(branchname);
                    }
                    $('#txt_branch_search').autocomplete({
                        source: availableTags,
                        change: branchnamechange,
                        autoFocus: true
                    });
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        function branchnamechange() {
            var name = document.getElementById('txt_branch_search').value;
            for (var i = 0; i < branchnames.length; i++) {
                if (name == branchnames[i].branchname) {
                    document.getElementById('txt_branch_searchid').value = branchnames[i].branchid;
                }
            }
        }

        function branch_det_byname() {
            var branchname = document.getElementById('txt_branch_search').value;
            if (branchname == "") {
                var data = { 'op': 'get_Branch_details' };
            }
            else {
                var data = { 'op': 'get_Branch_details_id', 'branchname': branchname };
            }
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

        function get_statemaster_det() {
            var data = { 'op': 'get_statemaster_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        FillStateNames(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        function FillStateNames(msg) {
            var data = document.getElementById('slct_state_name');
            var length = data.options.length;
            document.getElementById('slct_state_name').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select State";
            opt.value = "";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].statename != null) {
                    if (msg[i].statename != "All")
                    {
                        if (msg[i].statename != "Nil")
                        {
                            var option = document.createElement('option');
                            option.innerHTML = msg[i].statename;
                            option.value = msg[i].sno;
                            data.appendChild(option);
                        }
                    }
                }
            }
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Branch Master
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operation</a></li>
            <li><a href="#">Branch Master</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Branch Details
                </h3>
            </div>
            <div class="box-body">
                <div id="showlogs"><%-- align="center"--%>
                    <table>
                        <tr>
                            <td>

                            <div class="input-group margin">
                              <input id="txt_branch_search" type="text" class="form-control" name="branch_search" onchange="branch_det_byname();" placeholder="Enter Branch Name">
                              <input id="txt_branch_searchid" type="text" style="display:none" class="form-control" name="branch_searchid" />
                                  <span class="input-group-btn">
                                    <button type="button" class="btn btn-info btn-flat" style="height: 35px;"><i class="fa fa-search" aria-hidden="true"></i></button>
                                  </span>
                            </div>


                                   
                            </td>
                           <td style="width: 66%">
                            </td>
                            <td>

                            <div class="input-group" style="padding-right: 16px;">
                                <div class="input-group-addon">
                                <span class="glyphicon glyphicon-plus-sign" onclick="showbranchdesign()"></span> <span onclick="showbranchdesign()">Add Branch</span>
                          </div>
                          </div>
                            </td>
                     </tr>
                    </table>
                </div>
                
                <div id="div_BranchData">
                </div>
                <div id='Branch_fillform' style="display: none;">
                    <table align="center">
                        <tr>
                            <td style="height: 40px;">
                                <label>
                                    Branch Name</label><span style="color: red;">*</span>
                                <input id="txtBrcName" type="text" name="CustomerFName" class="form-control" placeholder="Enter Branch Name" onkeypress="return ValidateAlpha(event);"/>
                            </td>
                             <td style="width:2%;"></td>
                            <td>
                               <label>
                                    Tin No</label><span style="color: red;">*</span>
                                <input id="txtTin" type="text" name="CustomerCode" class="form-control" placeholder="Enter TIN Number" onkeypress="return isNumber(event)"/>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>
                                    Phone No</label>
                                <input id="txtPhnNO" type="text" name="CCName" class="form-control"  placeholder="Enter Phone Number"  onkeypress="return isNumber(event)"/>
                            </td>
                             <td></td>
                            <td>
                                <label>
                                    Email Id</label><span style="color: red;">*</span>
                                <input id="txtMail" type="text" name="CMailID" class="form-control" placeholder="Enter Email"/><%-- onchange="validationemail();"--%>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Address</label>
                                <input id="txtAdrs" type="text" name="CMobileNumber" class="form-control"  placeholder="Enter Address"/>
                            </td>
                             <td></td>
                            <td>
                                <label>
                                    CST NO</label><span style="color: red;">*</span>
                                <input id="txtCst" type="text" name="CustomerE_Mail" class="form-control" placeholder="Enter CST NO"/>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>
                                    ST NO</label>
                                <input id="txtStNO" type="text" name="CMobileNumber" class="form-control" placeholder="Enter ST NO"/>
                            </td>
                              <td></td>
                            <td style="height: 40px;">
                                <label>
                                    Branch Type</label><span style="color: red;">*</span>
                                <select id="slct_type" class="form-control">
                                    <option value="">SELECT TYPE</option>
                                    <option value="Inter Branch">Inter Branch</option>
                                    <option value="Other Branch">Other Branch</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>
                                    WH Code</label><span style="color: red;">*</span>
                                <input id="txt_warehouse" type="text" name="warehouse" class="form-control" placeholder="Enter WH CODE"/>
                            </td>
                             <td></td>
                            <td style="height: 40px;">
                                <label>
                                    Tally Branch Name</label>
                                <input id="txt_tally_branch" type="text" name="tally_branch" class="form-control" placeholder="Enter Tally Branch Name"/>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>GST Reg Type</label><span style="color: red;">*</span>
                                <select id="slct_gst_reg_type" class="form-control">
                                    <option value="Casual Taxable Person">Casual Taxable Person</option>
                                    <option value="Composition Levy">Composition Levy</option>
                                    <option value="Government Department or PSU">Government Department or PSU</option>
                                    <option value="Non Resident Taxable Person">Non Resident Taxable Person</option>
                                    <option value="Regular/TDS/ISD">Regular/TDS/ISD</option>
                                    <option value="UN Agency or Embassy">UN Agency or Embassy</option>
                                </select>
                            </td>
                            <td></td>
                            <td>
                                <label>GSTIN</label><span style="color: red;">*</span>
                                <input id="txt_gstin" class="form-control" name="gstin" type="text" placeholder="Enter GSTIN No" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>State Name</label><span style="color: red;">*</span>
                                <select id="slct_state_name" class="form-control"></select>
                            </td>
                            <td></td>
                             <td style="height: 40px;">
                                <label>
                                    Accounts ledger</label>
                                <input id="txt_acc_branch" type="text" name="acc_branch" class="form-control" placeholder="Enter Accounts ledger"/>
                            </td>
                        </tr>
                        <tr style="display:none;">
                            <td>
                                <label id="lbl_sno"  >
                                </label>
                            </td>
                        </tr>
                    </table>
                    <table align="center">
                        <tr>
                        
                            <td align="center" style="height: 40px;">
                            <table>
                            <tr>
                            <td>
                            <div class="input-group">
                                <div class="input-group-addon">
                                <span class="glyphicon glyphicon-ok" id="btn_save1" onclick="saveBranchDetails()"></span> <span id="btn_save" onclick="saveBranchDetails()">save</span>
                          </div>
                          </div>
                            </td>
                            <td style="width:10px;"></td>
                            <td>
                             <div class="input-group">
                                <div class="input-group-close">
                                <span class="glyphicon glyphicon-remove" id='btn_close1' onclick="cancelbranchdetails()"></span> <span id='btn_close' onclick="cancelbranchdetails()">Close</span>
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
        
    </section>
</asp:Content>
