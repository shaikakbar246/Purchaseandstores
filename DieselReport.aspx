<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true"
    CodeFile="DieselReport.aspx.cs" Inherits="DieselReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        function CallPrint(strid) {
            var divToPrint = document.getElementById(strid);
            var newWin = window.open('', 'Print-Window', 'width=400,height=400,top=100,left=100');
            newWin.document.open();
            newWin.document.write('<html><body   onload="window.print()">' + divToPrint.innerHTML + '</body></html>');
            newWin.document.close();
        }
        
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:UpdateProgress ID="updateProgress1" runat="server">
        <ProgressTemplate>
            <div style="position: fixed; text-align: center; height: 100%; width: 100%; top: 0;
                right: 0; left: 0; z-index: 9999; background-color: #FFFFFF; opacity: 0.7;">
                <asp:Image ID="imgUpdateProgress" runat="server" ImageUrl="thumbnails/loading.gif"
                    Style="padding: 10px; position: absolute; top: 40%; left: 40%; z-index: 99999;" />
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
    <section class="content-header">
        <h1>
            Diesel Report<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operations</a></li>
            <li><a href="#">Vehicle Report</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Diesel Report Details
                </h3>
            </div>
            <div class="box-body" >
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <table align="center">
                <tr>
                    <td style="width: 350PX;">
                        <asp:Label ID="Label1" Font-Bold="true" runat="server" Text="Label">Vehicle Number</asp:Label>&nbsp;
                        <asp:DropDownList ID="ddlagentname" runat="server" CssClass="form-control">
                        </asp:DropDownList>
                    </td>
                    <td style="width:6px;"></td>
                    <td>
                        <asp:Label ID="Label2" Font-Bold="true" runat="server" Text="Label">From Date</asp:Label>&nbsp;
                        <asp:TextBox ID="txtFromdate" runat="server" CssClass="txtinputCss"></asp:TextBox>
                        <asp:CalendarExtender ID="enddate_CalendarExtender" runat="server" Enabled="True"
                            TargetControlID="txtFromdate" Format="dd-MM-yyyy HH:mm">
                        </asp:CalendarExtender>
                    </td>
                      <td style="width:6px;"></td>
                    <td>
                        <asp:Label ID="Label3" Font-Bold="true" runat="server" Text="Label">To Date</asp:Label>&nbsp;
                        <asp:TextBox ID="txtTodate" runat="server" CssClass="txtinputCss"></asp:TextBox>
                        <asp:CalendarExtender ID="CalendarExtender1" runat="server" Enabled="True" TargetControlID="txtTodate"
                            Format="dd-MM-yyyy HH:mm">
                        </asp:CalendarExtender>
                    </td>
                      <td style="width:6px;"></td>
                    <td style="padding-top:20px">
                        <asp:Button ID="btnGenerate" Text="Generate" runat="server" OnClientClick="OrderValidate();"
                            class="aspbutton" OnClick="btnGenerate_Click" />
                    </td>
                    <td>
                        <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="~/exporttoxl.aspx">Export to XL</asp:HyperLink>
                    </td>
                </tr>
            </table>
            <asp:Panel ID="pvisible" runat="server" Visible="false">
             <div id="divPrint">
                <div style="width: 100%;">
                    <div style="width: 13%; float: left;">
                        <img src="Images/Vyshnavilogo.png" alt="Vyshnavi" width="120px" height="82px" />
                    </div>
                    <div align="center">
                        <asp:Label ID="lblTitle" runat="server" Font-Bold="true" Font-Size="20px" ForeColor="#0252aa"
                            Text=""></asp:Label>
                        <br />
                        <asp:Label ID="lblAddress" runat="server" Font-Bold="true" Font-Size="12px" ForeColor="#0252aa"
                            Text=""></asp:Label>
                        <br />
                    </div>
                    <div  align="center">
                        <span style="font-size: 18px; font-weight: bold; color: #0252aa;">Diesel Report</span><br />
                        <div>
                        </div>
                    </div>
                </div>
                <div>
                <asp:Panel ID="pnlOpp" runat="server" Visible="false">
                Opp Bal <asp:Label ID="lblOppBal" runat="server" ForeColor="Red" Font-Bold="true" Font-Size="18px"
                        Text=""></asp:Label>
                </asp:Panel>
                    <asp:GridView ID="grdReports" runat="server" ForeColor="White" Width="100%" CssClass="gridcls"
                        GridLines="Both" Font-Bold="true">
                        <EditRowStyle BackColor="#999999" />
                        <FooterStyle BackColor="Gray" Font-Bold="False" ForeColor="White" />
                        <HeaderStyle BackColor="#f4f4f4" Font-Bold="False" ForeColor="Black" Font-Italic="False"
                            Font-Names="Raavi" Font-Size="Small" />
                        <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                        <RowStyle BackColor="#ffffff" ForeColor="#333333" HorizontalAlign="Center" />
                        <AlternatingRowStyle HorizontalAlign="Center" />
                        <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                    </asp:GridView>
                        <asp:Panel ID="pnlClo" runat="server" Visible="false">
                Clo Bal    <asp:Label ID="lblCloBal" runat="server" ForeColor="Red" Text=""></asp:Label>
                </asp:Panel>
                </div>
                <br />
                 <table style="width: 100%;">
                            <tr>
                                <td style="width: 33%;">
                                    <span style="font-weight: bold; font-size: 12px;">INCHARGE SIGNATURE</span>
                                </td>
                              <td style="width: 33%;">
                                    <span style="font-weight: bold; font-size: 12px;">ACCOUNTS DEPARTMENT</span>
                                </td>
                                <td style="width: 33%;">
                                    <span style="font-weight: bold; font-size: 12px;">AUTHORISED SIGNATURE</span>
                                </td>
                            </tr>
                        </table>
                <br />
                </div>
                  <asp:Button ID="btnPrint" runat="Server" CssClass="btn btn-primary"  OnClientClick="javascript:CallPrint('divPrint');" Text="Print" />&nbsp&nbsp&nbsp&nbsp&nbsp
                  
                  <asp:Button ID="btnUpdate" runat="Server" CssClass="btn btn-primary" OnClick="btnUpdate_Click" Text="Update"/>
            </asp:Panel>
            
                <asp:Label ID="lblmsg" runat="server" Text="" ForeColor="Red" Font-Size="20px"></asp:Label>

        </ContentTemplate>
    </asp:UpdatePanel>
    </div>
    </div>
    </section>
</asp:Content>
