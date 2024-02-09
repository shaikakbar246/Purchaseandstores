<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true" CodeFile="SAP_Consumptionrpt.aspx.cs" Inherits="SAP_Consumptionrpt" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
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
        function exportfn() {
            window.location = "exporttoxl.aspx";
        }

        //------------>Prevent Backspace<--------------------//
        $(document).unbind('keydown').bind('keydown', function (event) {
            var doPrevent = false;
            if (event.keyCode === 8) {
                var d = event.srcElement || event.target;
                if ((d.tagName.toUpperCase() === 'INPUT' && (d.type.toUpperCase() === 'TEXT' || d.type.toUpperCase() === 'PASSWORD'))
            || d.tagName.toUpperCase() === 'TEXTAREA') {
                    doPrevent = d.readOnly || d.disabled;
                } else {
                    doPrevent = true;
                }
            }

            if (doPrevent) {
                event.preventDefault();
            }
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:UpdateProgress ID="updateProgress1" runat="server">
        <ProgressTemplate>
            <div style="position: fixed; text-align: center; height: 100%; width: 100%; top: 0;
                right: 0; left: 0; z-index: 9999999; background-color: #FFFFFF; opacity: 0.7;">
                <br />
                <asp:Image ID="imgUpdateProgress" runat="server" ImageUrl="thumbnails/loading.gif"
                    AlternateText="Loading ..." ToolTip="Loading ..." Style="padding: 10px; position: absolute;
                    top: 35%; left: 40%;" />
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
    <asp:UpdatePanel ID="updPanel" runat="server">
        <ContentTemplate>
            <section class="content-header">
                <h1>
                        SAP Branch Transfer Report<small>Preview</small>
                </h1>
                <ol class="breadcrumb">
                    <li><a href="#"><i class="fa fa-dashboard"></i>Reports</a></li>
                    <li><a href="#">  SAP Branch Transfer Report</a></li>
                </ol>
            </section>
            <section class="content">
                <div class="box box-info">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i> SAP Branch Transfer Report
                        </h3>
                    </div>
                    <div class="box-body">
                        
                            <div align="center">
                            <table>
                                <tr>
                                 <td>
                                        <asp:Label ID="Label2" runat="server" Text="Label">Type</asp:Label>&nbsp;
                                        <asp:DropDownList ID="ddltype" runat="server"  CssClass="form-control"> <%--OnTextChanged="type_change();"--%>
                                        </asp:DropDownList>
                                    </td>   
                                 <td style="width:6px;"></td>
                                    <td id="branch_type">
                                        <asp:Label ID="Label1" runat="server" Text="Label">Branch Type</asp:Label>&nbsp;
                                        <asp:DropDownList ID="ddlbranchname" runat="server" CssClass="form-control">
                                        </asp:DropDownList>
                                    </td>
                                <td style="width:6px;"></td>
                                    <td>
                                        <asp:Label ID="lblfrom_date" runat="server" Text="Label">From Date</asp:Label>&nbsp;
                                        <asp:TextBox ID="dtp_FromDate" runat="server" CssClass="form-control"></asp:TextBox>
                                        <asp:CalendarExtender ID="enddate_CalendarExtender" runat="server" Enabled="True"
                                            TargetControlID="dtp_FromDate" Format="dd-MM-yyyy HH:mm">
                                        </asp:CalendarExtender>
                                    </td>
                                <td style="width:6px;"></td>
                                   
                                <td style="width:6px;"></td>
                                    <td style="padding-top:36px">
                                        <asp:Button ID="Button2" runat="server" Text="GENERATE" CssClass="aspbutton"
                                            OnClick="btn_Generate_Click" /><br />
                                        
                                    </td>
                                    
                                    
                                </tr>
                            </table>
                            <asp:Panel ID="hidepanel" runat="server" Visible='false'>
                                <div id="divPrint">
                                    <div style="width: 100%;">
                                        <div style="width: 13%; float: left;">
                                            <img src="Images/Vyshnavilogo.png" alt="Vyshnavi" width="120px" height="82px" />
                                        </div>
                                        <div align="center">
                                            <span align="center" style="font-size: 18px; font-weight: bold; color: #0252aa;"> GOODS Issue(Consumption) Report</span><br />
                                        </div>
                                        <br />
                                        <table style="width: 80%">
                                            <tr>
                                                </td>
                                                <td>
                                                    From Date
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblFromDate" runat="server" Text="" ForeColor="Red"></asp:Label>
                                                </td>
                                                <td>
                                                    To date:
                                                </td>
                                                <td>
                                                    <asp:Label ID="lbltodate" runat="server" Text="" ForeColor="Red"></asp:Label>
                                                </td>
                                            </tr>
                                        </table>
                                        <div>
                                <asp:GridView ID="grdReports" runat="server" ForeColor="White" Width="100%" CssClass="gridcls"
                                    GridLines="Both" Font-Bold="true" Font-Size="Smaller" OnRowDataBound="grdReports_RowDataBound" OnDataBinding="gvMenu_DataBinding">
                                    <EditRowStyle BackColor="#999999" />
                                    <FooterStyle BackColor="Gray" Font-Bold="False" ForeColor="White" />
                                    <HeaderStyle BackColor="#f4f4f4" Font-Bold="False" ForeColor="Black" Font-Italic="False"
                                        Font-Names="Raavi" />
                                    <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                                    <RowStyle BackColor="#ffffff" ForeColor="#333333" HorizontalAlign="Center" />
                                    <AlternatingRowStyle HorizontalAlign="Center" />
                                    <SelectedRowStyle BackColor="#E2DED6" ForeColor="#333333" />
                                </asp:GridView>
                                <%--<asp:GridView ID="grdReports_punabaka" runat="server" ForeColor="White" Width="100%" CssClass="gridcls"
                                    GridLines="Both" Font-Bold="true" Font-Size="Smaller" OnRowDataBound="grdReports_RowDataBound_punabaka" OnDataBinding="gvMenu_DataBinding_punabaka">
                                    <EditRowStyle BackColor="#999999" />
                                    <FooterStyle BackColor="Gray" Font-Bold="False" ForeColor="White" />
                                    <HeaderStyle BackColor="#f4f4f4" Font-Bold="False" ForeColor="Black" Font-Italic="False"
                                        Font-Names="Raavi" />
                                    <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                                    <RowStyle BackColor="#ffffff" ForeColor="#333333" HorizontalAlign="Center" />
                                    <AlternatingRowStyle HorizontalAlign="Center" />
                                    <SelectedRowStyle BackColor="#E2DED6" ForeColor="#333333" />
                                </asp:GridView>--%>
                                        </div>
                                        <br />
                                    </div>
                                </div>
                                <br />
                                <br />
                                <asp:Button ID="btnPrint" runat="Server" CssClass="btn btn-primary" OnClientClick="javascript:CallPrint('divPrint');"
                                    Text="Print" />&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp<asp:Button ID="btn_save" runat="server" Text="Save" CssClass="btn btn-primary" OnClick="BtnSave_Click" />&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp<asp:Button ID="btnexport" runat="server" Text="Export to Excel" OnClick="btnexport_click" />
                            </asp:Panel>
                            <asp:Label ID="lblmsg" runat="server" Text="" ForeColor="Red" Font-Size="20px"></asp:Label>
                        </div>
                        <%--</div>--%>
                        
                    </div>
                </div>
            </section>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>

