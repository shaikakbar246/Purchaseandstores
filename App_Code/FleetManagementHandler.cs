using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using System.Data.SqlClient;
using System.Web.Script.Serialization;
using System.Data;
using System.Web.Services;
using System.Net.Mail;
using System.Net;
using System.Text;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Globalization;
using MySql.Data.MySqlClient;

/// <summary>
/// Summary description for FleetManagementHandler
/// </summary>
public class FleetManagementHandler : IHttpHandler, IRequiresSessionState
{
    SqlCommand cmd;
    SalesDBManager vdm = new SalesDBManager();
    MySqlCommand mycmd;
    DBManagerSales vdsm = new DBManagerSales();
    AccessControldbmanger Accescontrol_db = new AccessControldbmanger();
    private SqlDbType sisno;
    public FleetManagementHandler()
    {
        //
        // TODO: Add constructor logic here
        //
    }
    public bool IsReusable
    {
        get { return true; }
    }
    private static string GetJson(object obj)
    {
        JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();
        jsonSerializer.MaxJsonLength = 2147483647;
        return jsonSerializer.Serialize(obj);
    }
    class GetJsonData
    {
        public string op { set; get; }
    }
    //  [WebMethod(Description="Delete Template",BufferResponse=false)]
    public void ProcessRequest(HttpContext context)
    {
        try
        {
            
            string operation = context.Request["op"];
            switch (operation)
            {

                case "Item_pic_files_upload":
                    Item_pic_files_upload(context);
                    break;
                case "Supplier_pic_files_upload":
                    Supplier_pic_files_upload(context);
                    break;
                case "Get__LineChart":
                    Get__LineChart(context);
                    break;
                case "get_Branch_section_supplier_details":
                    get_Branch_section_supplier_details(context);
                    break;
                case "get_purchase_details":
                    get_purchase_details(context);
                    break;
                case "get_purchase_pendingdetails":
                    get_purchase_pendingdetails(context);
                    break;
                case "saveBankDetails":
                    saveBankDetails(context);
                    break;
                case "get_bank_details":
                    get_bank_details(context);
                    break;
                case "saveEmployeDetails":
                    saveEmployeDetails(context);
                    break;
                case "get_Employe_details":
                    get_Employe_details(context);
                    break;
                case "get_Employe_details_name":
                    get_Employe_details_name(context);
                    break;
                case "saveDepartmentdetails":
                    saveDepartmentdetails(context);
                    break;
                case "get_Department_Details":
                    get_Department_Details(context);
                    break;
                case "saveBranchDetails":
                    saveBranchDetails(context);
                    break;
                case "get_Branch_details":
                    get_Branch_details(context);
                    break;
                case "get_Branch_details_id":
                    get_Branch_details_id(context);
                    break;
                case "saveSectionDetails":
                    saveSectionDetails(context);
                    break;
                case "get_section_details":
                    get_section_details(context);
                    break;
                case "saveBrandDetails":
                    saveBrandDetails(context);
                    break;
                case "get_Brand_details":
                    get_Brand_details(context);
                    break;
                case "saveAddressDetails":
                    saveAddressDetails(context);
                    break;
                case "get_Address_details":
                    get_Address_details(context);
                    break;
                case "save_State_Details":
                    save_State_Details(context);
                    break;
                case "get_statemaster_details":
                    get_statemaster_details(context);
                    break;
                case "saveCategoryDetails":
                    saveCategoryDetails(context);
                    break;
                case "get_Category_details":
                    get_Category_details(context);
                    break;
                case "saveSubcategoryDetails":
                    saveSubcategoryDetails(context);
                    break;
                case "get_Sub_Category_details":
                    get_Sub_Category_details(context);
                    break;
                case "get_subcategory_data_catcode":
                    get_subcategory_data_catcode(context);
                    break;
                case "get_suplier_details":
                    get_suplier_details(context);
                    break;
                
                case "saveBranchProductDetails":
                    saveBranchProductDetails(context);
                    break;
                case "get_product_details_Like":
                    get_product_details_Like(context);
                    break;
                case "get_ScrapItem_details_Like":
                    get_ScrapItem_details_Like(context);
                    break;
                case "get_product_details":
                    get_product_details(context);
                    break;
                case "get_product_details_po":
                    get_product_details_po(context);
                    break;
                case "get_product_detail_branch":
                    get_product_detail_branch(context);
                    break;
                case "get_branch_product_details":
                    get_branch_product_details(context);
                    break;
                case "get_branch_product_details_Like":
                    get_branch_product_details_Like(context);
                    break;
                case "get_productissue_details":
                    get_productissue_details(context);
                    break;
                case "get_branchwiseproduct_details":
                    get_branchwiseproduct_details(context);
                    break;
                case "get_products_data_subcatcode":
                    get_products_data_subcatcode(context);
                    break;
                case "get_products_data_subcatcode_zeroqty":
                    get_products_data_subcatcode_zeroqty(context);
                    break;
                case "saveScrapItemDetails":
                    saveScrapItemDetails(context);
                    break;
                case "get_ScrapItem_details":
                    get_ScrapItem_details(context);
                    break;
                case "get_inward_Data":
                    get_inward_Data(context);
                    break;
                case "get_outward_Data":
                    get_outward_Data(context);
                    break;
                case "get_Poraise":
                    get_Poraise(context);
                    break;
                case "approval_pending_podetails_click":
                    approval_pending_podetails_click(context);
                    break;
                case "saveTAX":
                    saveTAX(context);
                    break;
                case "get_TAX":
                    get_TAX(context);
                    break;
                case "get_tax_details":
                    get_tax_details(context);
                    break;
                case "saveUIM":
                    saveUIM(context);
                    break;
                case "get_UIM":
                    get_UIM(context);
                    break;
                case "savePayementDetails":
                    savePayementDetails(context);
                    break;
                case "get_PaymentDetails":
                    get_PaymentDetails(context);
                    break;
                case "savePandF":
                    savePandF(context);
                    break;
                case "get_PandF":
                    get_PandF(context);
                    break;
                case "get_invoice_report":
                    get_invoice_report(context);
                    break;
                case "get_report":
                    get_report(context);
                    break;
                case "get_po_details_click":
                    get_po_details_click(context);
                    break;
                case "get_workOrder_click":
                    get_workOrder_click(context);
                    break;
                case "get_purchase_order_details_click":
                    get_purchase_order_details_click(context);
                    break;
                case "get_purchaseINVOCE_order_details_click":
                    get_purchaseINVOCE_order_details_click(context);
                    break;
                case "get_supplier":
                    get_supplier(context);
                    break;
                case "get_Returnble_Material_details":
                    get_Returnble_Material_details(context);
                    break;
                case "get_Returnable_Material_data":
                    get_Returnable_Material_data(context);
                    break;
                case "get_Returnble_Material_details_Report":
                    get_Returnble_Material_details_Report(context);
                    break;
                case "get_Returnble_Material_Report_SubDetails":
                    get_Returnble_Material_Report_SubDetails(context);
                    break;
                case "get_Approvel_internal_details":
                    get_Approvel_internal_details(context);
                    break;
                case "save_approve_indent_click":
                    save_approve_indent_click(context);
                    break;
                case "get_Stores_details":
                    get_Stores_details(context);
                    break;
                case "get_indent_details_click":
                    get_indent_details_click(context);
                    break;
                case "get_Indent_Sub_details_click":
                    get_Indent_Sub_details_click(context);
                    break;
                case "get_scrap_material_details":
                    get_scrap_material_details(context);
                    break;
                case "get_scrap_sales_details":
                    get_scrap_sales_details(context);
                    break;
                case "get_StockTransfer_details":
                    get_StockTransfer_details(context);
                    break;
                case "get_debitvocher_details":
                    get_debitvocher_details(context);
                    break;
                case "get_Stock_Repair_details":
                    get_Stock_Repair_details(context);
                    break;
                case "get_outward_details_click":
                    get_outward_details_click(context);
                    break;
                case "get_Outward_Sub_details_click":
                    get_Outward_Sub_details_click(context);
                    break;
                case "get_inward_details_click":
                    get_inward_details_click(context);
                    break;
                case "get_inward_Sub_details_click":
                    get_inward_Sub_details_click(context);
                    break;
                case "saveDelivaryTerms":
                    saveDelivaryTerms(context);
                    break;
                case "get_DelivaryTerms":
                    get_DelivaryTerms(context);
                    break;
                case "get_StockTransfer_details_click":
                    get_StockTransfer_details_click(context);
                    break;
                case "get_debitvocher_details_click":
                    get_debitvocher_details_click(context);
                    break;
                case "get_StockTransfer_Sub_details_click":
                    get_StockTransfer_Sub_details_click(context);
                    break;
                case "get_debitvocher_Sub_details_click":
                    get_debitvocher_Sub_details_click(context);
                    break;
                case "get_approve_Stock_Tranfer_click":
                    get_approve_Stock_Tranfer_click(context);
                    break;
                case "get_purchaserOrder_details":
                    get_purchaserOrder_details(context);
                    break;
                case "get_inwardOrder_details":
                    get_inwardOrder_details(context);
                    break;
                case "get_Stock_Opening_Details":
                    get_Stock_Opening_Details(context);
                    break;
                case "get_purchaserOrder_details_inward":
                    get_purchaserOrder_details_inward(context);
                    break;
                case "get_quality_check_inward_number":
                    get_quality_check_inward_number(context);
                    break;
                case "get_StoresItems_details_click":
                    get_StoresItems_details_click(context);
                    break;
                case "Get_DailyStoresValue":
                    Get_DailyStoresValue(context);
                    break;
                case "get_catagirywise_value":
                    get_catagirywise_value(context);
                    break;
                case "get_catagirywise_value_branch":
                    get_catagirywise_value_branch(context);
                    break;
                case "get_category_names":
                    get_category_names(context);
                    break;
                case "GetDailyInwardValue":
                    GetDailyInwardValue(context);
                    break;
                case "GetDailyOutwardValue":
                    GetDailyOutwardValue(context);
                    break;
                case "Get_DailyStoresValuechart":
                    Get_DailyStoresValuechart(context);
                    break;
                case "save_Collection_Details":
                    save_Collection_Details(context);
                    break;
                case "get_collection_details":
                    get_collection_details(context);
                    break;
               
                case "get_Indent_Details_Outward":
                    get_Indent_Details_Outward(context);
                    break;
                case "get_Stores_return_Report_details":
                    get_Stores_return_Report_details(context);
                    break;
                case "get_SubStores_return_Report_details":
                    get_SubStores_return_Report_details(context);
                    break;
              

                

                case "get_Pending_outward_Data":
                    get_Pending_outward_Data(context);
                    break;
                case "get_Pending_inward_Data":
                    get_Pending_inward_Data(context);
                    break;
                case "get_StoresConsumption_Details":
                    get_StoresConsumption_Details(context);
                    break;
                case "subcategoryvalues":
                    subcategoryvalues(context);
                    break;
                case "get_outward_print":
                    get_outward_print(context);
                    break;
                case "get_inward_print":
                    get_inward_print(context);
                    break;
                case "get_stock_print":
                    get_stock_print(context);
                    break;
                case "get_Po_print":
                    get_Po_print(context);
                    break;
                case "purchaseorderproductname":
                    purchaseorderproductname(context);
                    break;
                case "inwarddashboardproductname":
                    inwarddashboardproductname(context);
                    break;
                case "get_inward_DataDashboard":
                    get_inward_DataDashboard(context);
                    break;
                case "issuedashboardproductname":
                    issuedashboardproductname(context);
                    break;
                case "get_issue_DataDashboard":
                    get_issue_DataDashboard(context);
                    break;
                case "get_Po_DataDashboard":
                    get_Po_DataDashboard(context);
                    break;
                case "transferdashboardproductname":
                    transferdashboardproductname(context);
                    break;
                case "get_Transfer_DataDashboard":
                    get_Transfer_DataDashboard(context);
                    break;
                case "get_WorkOrder_details":
                    get_WorkOrder_details(context);
                    break;
                case "get_Sub_workOrder_click":
                    get_Sub_workOrder_click(context);
                    break;
                case "get_scrapsales_Sub_details_Report":
                    get_scrapsales_Sub_details_Report(context);
                    break;
                case "get_scrapsales_details_Report":
                    get_scrapsales_details_Report(context);
                    break;
                case "get_stockrepairReoprt_details":
                    get_stockrepairReoprt_details(context);
                    break;
                case "get_Sub_Stock_Repair_Report":
                    get_Sub_Stock_Repair_Report(context);
                    break;
                case "get_RepairItem_details":
                    get_RepairItem_details(context);
                    break;
                case "saveRepairItemDetails":
                    saveRepairItemDetails(context);
                    break;
                //case "Get_Product_wise_pie_chart":
                //    Get_Product_wise_pie_chart(context);
                //    break;
                case "Get_Po_Pie_chart":
                    Get_Po_Pie_chart(context);
                    break;
                case "Get_Branch_Wise_LineChart":
                    Get_Branch_Wise_LineChart(context);
                    break;
                case "Get_Section_Wise_LineChart":
                    Get_Section_Wise_LineChart(context);
                    break;
                case "Get_Min_Product_wise_pie_chart":
                    Get_Min_Product_wise_pie_chart(context);
                    break;
                case "Get_Supplier_Wise_LineChart":
                    Get_Supplier_Wise_LineChart(context);
                    break;
                case "save_asset_mgm":
                    save_asset_mgm(context);
                    break;
                case "get_asset_mgm":
                    get_asset_mgm(context);
                    break;
                case "get_maintenance_det":
                    get_maintenance_det(context);
                    break;
                case "get_maintenance_det1":
                    get_maintenance_det1(context);
                    break;
                case "get_asset_list":
                    get_asset_list(context);
                    break;
                case "get_quote_prod_Details":
                    get_quote_prod_Details(context);
                    break;
                case "get_quotation_req_det":
                    get_quotation_req_det(context);
                    break;
                case "get_quotation_sub_det":
                    get_quotation_sub_det(context);
                    break;
                case "get_quotation_details_click":
                    get_quotation_details_click(context);
                    break;
                case "get_quotation_req_date":
                    get_quotation_req_date(context);
                    break;
                case "get_vendor_quotation_date":
                    get_vendor_quotation_date(context);
                    break;
                case "get_vendor_quotation_det_click":
                    get_vendor_quotation_det_click(context);
                    break;
                case "Get_Month_Comparison_Chart":
                    Get_Month_Comparison_Chart(context);
                    break;
                case "get_total_po":
                    get_total_po(context);
                    break;
                case "get_total_mrn":
                    get_total_mrn(context);
                    break;
                case "get_total_issue":
                    get_total_issue(context);
                    break;
                case "get_Branch_details_type":
                    get_Branch_details_type(context);
                    break;
                case "btn_Vendor_Details_click":
                    btn_Vendor_Details_click(context);
                    break;
                case "get_Vendor_Data":
                    get_Vendor_Data(context);
                    break;
                case "get_supplier_details_item":
                    get_supplier_details_item(context);
                    break;
                case "get_item_details_supplier":
                    get_item_details_supplier(context);
                    break;
                case "get_Vendor_Quotation_Data_Details":
                    get_Vendor_Quotation_Data_Details(context);
                    break;
                case "get_Indent_Data_Details_PO":
                    get_Indent_Data_Details_PO(context);
                    break;
                case "get_approve_Stock_Tranfer_Inward":
                    get_approve_Stock_Tranfer_Inward(context);
                    break;
                case "get_approve_Stock_Tranfer_Inward_sub":
                    get_approve_Stock_Tranfer_Inward_sub(context);
                    break;
                case "get_product_details_id":
                    get_product_details_id(context);
                    break;
                case "get_lastsixmonthsinward_value":
                    get_lastsixmonthsinward_value(context);
                    break;
                case "get_lastsixmonthsinward_value_branch":
                    get_lastsixmonthsinward_value_branch(context);
                    break;
                case "get_lastsixmonthsoutward_value":
                    get_lastsixmonthsoutward_value(context);
                    break;
                case "get_lastsixmonthsoutward_value_branch":
                    get_lastsixmonthsoutward_value_branch(context);
                    break;
                case "get_productcountdetails":
                    get_productcountdetails(context);
                    break;
                case "get_productcountdetails_branch":
                    get_productcountdetails_branch(context);
                    break;
                case "getallbranchproductdata":
                    getallbranchproductdata(context);
                    break;
                case "save_Supplier_Document_Info":
                    save_Supplier_Document_Info(context);
                    break;
                case "getsupplier_Uploaded_Documents":
                    getsupplier_Uploaded_Documents(context);
                    break;
                case "getallproductsinfo":
                    getallproductsinfo(context);
                    break;
                case "getallproductsinfo_data":
                    getallproductsinfo_data(context);
                    break;
                case "get_Inward_Details_Outward":
                    get_Inward_Details_Outward(context);
                    break;
                case "get_supplier_details_id":
                    get_supplier_details_id(context);
                    break;
                case "get_inward_details_productid":
                    get_inward_details_productid(context);
                    break;
                case "get_product_details_category":
                    get_product_details_category(context);
                    break;
                    //naveen
                case "get_logininfo_details":
                    get_logininfo_details(context);
                    break;
					  //sai
                case "get_employee_details":
                    get_employee_details(context);
                    break;
                case "btn_getlogininfoemployee_details":
                    btn_getlogininfoemployee_details(context);
                    break;
                case "get_projectinfo_detailes":
                    get_projectinfo_detailes(context);
                    break;
                default:
                    var jsonString = String.Empty;
                    context.Request.InputStream.Position = 0;
                    using (var inputStream = new StreamReader(context.Request.InputStream))
                    {
                        jsonString = HttpUtility.UrlDecode(inputStream.ReadToEnd());
                    }
                    if (jsonString != "")
                    {
                        var js = new JavaScriptSerializer();
                        // var title1 = context.Request.Params[1];
                        GetJsonData obj = js.Deserialize<GetJsonData>(jsonString);
                        switch (obj.op)
                        {
                            case "Save_Stock_Closing_Details":
                                Save_Stock_Closing_Details(jsonString, context);
                                break;
                            case "Save_stores_Consumption_Details":
                                Save_stores_Consumption_Details(jsonString, context);
                                break;
                            
                        }
                    }
                    else
                    {
                        var js = new JavaScriptSerializer();
                        var title1 = context.Request.Params[1];
                        GetJsonData obj = js.Deserialize<GetJsonData>(title1);
                        switch (obj.op)
                        {

                            case "saveSuplierDetails":
                                saveSuplierDetails(context);
                                break;
                            case "saveProductDetails":
                                saveProductDetails(context);
                                break;
                            case "save_edit_Inward":
                                save_edit_Inward(context);
                                break;
                            case "save_edit_Outward":
                                save_edit_Outward(context);
                                break;
                            case "save_edit_po_click":
                                save_edit_po_click(context);
                                break;
                            case "save_edit_WorkOrder_click":
                                save_edit_WorkOrder_click(context);
                                break;
                            case "save_Stores_Return":
                                save_Stores_Return(context);
                                break;
                            case "save_Indent":
                                save_Indent(context);
                                break;
                            case "save_scrap_sales_click":
                                save_scrap_sales_click(context);
                                break;
                            case "save_scrap_Material_click":
                                save_scrap_Material_click(context);
                                break;
                            case "save_stock_transfer_click":
                                save_stock_transfer_click(context);
                                break;
                            case "save_debitvocher_click":
                                save_debitvocher_click(context);
                                break;

                            case "get_indent_details_click":
                                get_indent_details_click(context);
                                break;
                            case "save_stock_repair_click":
                                save_stock_repair_click(context);
                                break;
                            case "save_stock_reject_click":
                                save_stock_reject_click(context);
                                break;
                            case "Save_Quality_Check_Product":
                                Save_Quality_Check_Product(context);
                                break;
                            case "saveInternalDetails":
                                saveInternalDetails(context);
                                break;
                            case "save_Verify_Returnble_Material_click":
                                save_Verify_Returnble_Material_click(context);
                                break;

                            case "save_schedule_Details":
                                save_schedule_Details(context);
                                break;

                            case "save_quotation_req_det":
                                save_quotation_req_det(context);
                                break;

                            case "save_vendor_quote":
                                save_vendor_quote(context);
                                break;
                            case "approval_pending_inward_click":
                                approval_pending_inward_click(context);
                                break;
                            case "approval_pending_Outward_click":
                                approval_pending_Outward_click(context);
                                break;
                            case "save_approve_Stock_Tranfer_click":
                                save_approve_Stock_Tranfer_click(context);
                                break;
                            case "approval_pending_StoresReturn_click":
                                approval_pending_StoresReturn_click(context);
                                break;
                            case "save_edit_projectinfo_click":
                                save_edit_projectinfo_click(context);
                                break;
                        }
                    }
                    break;
            }
        }
        catch (Exception ex)
        {
            string response = GetJson(ex.ToString());
            context.Response.Write(response);
        }
    }
    public class shiftdetails
    {
        public string shiftid { get; set; }
        public string shiftname { get; set; }
        public string timings { get; set; }
    }
    public class purchasedetails
    {
        public string sno { get; set; }
        public string name { get; set; }
        public string status { get; set; }
        public string podate { get; set; }
        public string delivarydate { get; set; }
        public string expiredate { get; set; }
        public string warranty { get; set; }
        public string email { get; set; }
        public string ponumber { get; set; }
        public string branchid { get; set; }
    }
    public class StoresReturn
    {
        public string name { get; set; }
        public string entryby { get; set; }
        public string doe { get; set; }
        public string remarks { get; set; }
        public string btnval { get; set; }
        public string sno { get; set; }
        public List<SubStoresReturn> fillitems { get; set; }
        public string productid { get; set; }
        public string qty { get; set; }
        public string price { get; set; }
        public string branchid { get; set; }
        public string streturnsno { get; set; }
        public string status { get; set; }
    }
    public class SubStoresReturn
    {
        public string hdnproductsno { get; set; }
        public string productname { get; set; }
        public string productcode { get; set; }
        public string quantity { get; set; }
        public string PerUnitRs { get; set; }
        public string refno { get; set; }
        public string sno { get; set; }
        public string sstore_refno { get; set; }
        public string sisno { get; set; }
        public SqlDbType branchid { get; set; }
    }

    public class getStoresReturn
    {
        public List<StoresReturn> StoresReturn { get; set; }
        public List<SubStoresReturn> SubStoresReturn { get; set; }
    }

    private void save_Stores_Return(HttpContext context)
    {
        try
        {
            var js = new JavaScriptSerializer();
            var title1 = context.Request.Params[1];
            StoresReturn obj = js.Deserialize<StoresReturn>(title1);
            string name = obj.name;
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string entryby = context.Session["Employ_Sno"].ToString();
            string remarks = obj.remarks;
            string invdate = obj.doe;
            DateTime invoiate = Convert.ToDateTime(invdate);
            string Date = invoiate.ToString("MM-dd-yyyy");
            string sno = obj.sno;
            string btnval = obj.btnval;
            vdm = new SalesDBManager();
            string branchid = context.Session["Po_BranchID"].ToString();
            if (btnval == "Save")
            {
                cmd = new SqlCommand("SELECT  doe FROM producttransactions WHERE (doe = @d1) GROUP BY doe");
                cmd.Parameters.Add("@d1", Date);
                cmd.Parameters.Add("@d2", Date);
                DataTable dtproducttransaction = vdm.SelectQuery(cmd).Tables[0];
                if (dtproducttransaction.Rows.Count == 0)
                {
                    cmd = new SqlCommand("insert into stores_return(name,doe,entryby,remarks,branchid,status) values(@name, @doe,@entryby,@remarks,@branchid,@status)");
                    cmd.Parameters.Add("@name", name);
                    cmd.Parameters.Add("@doe", Date);
                    cmd.Parameters.Add("@entryby", entryby);
                    cmd.Parameters.Add("@remarks", remarks);
                    cmd.Parameters.Add("@status", 'p');
                    cmd.Parameters.Add("@branchid", branchid);
                    vdm.insert(cmd);
                    cmd = new SqlCommand("select MAX(sno) as inward from stores_return");
                    DataTable dtinward = vdm.SelectQuery(cmd).Tables[0];
                    string refno = dtinward.Rows[0]["inward"].ToString();
                    foreach (SubStoresReturn si in obj.fillitems)
                    {
                        if (si.hdnproductsno != "0")
                        {
                            cmd = new SqlCommand("insert into sub_stores_return(productid,quantity,perunit,storesreturn_sno) values(@productid,@qty,@price,@in_refno)");
                            cmd.Parameters.Add("@productid", si.hdnproductsno);
                            cmd.Parameters.Add("@qty", si.quantity);
                            cmd.Parameters.Add("@price", si.PerUnitRs);
                            cmd.Parameters.Add("@in_refno", refno);
                            vdm.insert(cmd);
                            
                        }
                    }
                    string msg = refno + "    Stores return Number successfully Inserted";
                    string Response = GetJson(msg);
                    context.Response.Write(Response);
                }
                else
                {
                    string Response = GetJson("You Dont Have Permission This Date");
                    context.Response.Write(Response);
                }
            }
            else
            {
                cmd = new SqlCommand("SELECT  doe  FROM producttransactions where branchid=@branchid and doe=@Date");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@Date", Date);
                DataTable produtransactiondoe = vdm.SelectQuery(cmd).Tables[0];
                if (produtransactiondoe.Rows.Count != 0)
                {
                    string Response = GetJson("You Dont Have Permission This Date");
                    context.Response.Write(Response);
                }
                else
                {
                    cmd = new SqlCommand("update stores_return set name=@name, doe=@doe,remarks=@remarks where sno=@sno AND branchid=@branchid");
                    cmd.Parameters.Add("@name", name);
                    cmd.Parameters.Add("@doe", Date);
                    cmd.Parameters.Add("@remarks", remarks);
                    cmd.Parameters.Add("@sno", sno);
                    cmd.Parameters.Add("@branchid", branchid);
                    vdm.Update(cmd);
                    foreach (SubStoresReturn si in obj.fillitems)
                    {
                        cmd = new SqlCommand("select * from sub_stores_return where  productid=@productid and storesreturn_sno=@in_refno");
                        cmd.Parameters.Add("@in_refno", sno);
                        cmd.Parameters.Add("@productid", si.hdnproductsno);
                        DataTable dtprev = vdm.SelectQuery(cmd).Tables[0];
                        float prevqty = 0;
                        if (dtprev.Rows.Count > 0)
                        {
                            string amount = dtprev.Rows[0]["quantity"].ToString();
                            float.TryParse(amount, out prevqty);
                        }
                        cmd = new SqlCommand("update sub_stores_return set productid=@productid, quantity=@qty, perunit=@price where storesreturn_sno=@in_refno and sno=@sno ");
                        cmd.Parameters.Add("@productid", si.hdnproductsno);
                        cmd.Parameters.Add("@qty", si.quantity);
                        cmd.Parameters.Add("@price", si.PerUnitRs);
                        cmd.Parameters.Add("@in_refno", sno);
                        cmd.Parameters.Add("@sno", si.sisno);
                        vdm.Update(cmd);
                        //float presentqty = 0;
                        //float.TryParse(si.quantity, out presentqty);
                        //double editqty = 0;
                        //if (presentqty >= prevqty)
                        //{
                        //    editqty = presentqty - prevqty;
                        //    cmd = new SqlCommand("UPDATE productmoniter set qty=qty+@new_quantity where productid=@productid AND branchid=@branchid");
                        //    cmd.Parameters.Add("@productid", si.hdnproductsno);
                        //    cmd.Parameters.Add("@new_quantity", editqty);
                        //    cmd.Parameters.Add("@branchid", branchid);
                        //    vdm.Update(cmd);
                        //}
                        //else
                        //{
                        //    editqty = prevqty - presentqty;
                        //    cmd = new SqlCommand("UPDATE productmoniter set qty=qty-@new_quantity where productid=@productid AND branchid=@branchid");
                        //    cmd.Parameters.Add("@productid", si.hdnproductsno);
                        //    cmd.Parameters.Add("@new_quantity", editqty);
                        //    cmd.Parameters.Add("@branchid", branchid);
                        //    vdm.Update(cmd);
                        //}
                    }
                    string msg = sno + "   Stores Return number successfully updated ";
                    string Response = GetJson(msg);
                    context.Response.Write(Response);
                }
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_Branch_section_supplier_details(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string branchid = context.Session["Po_BranchID"].ToString();
            string type = context.Request["type"];
            if (type == "Branch")
            {
                cmd = new SqlCommand("SELECT branchname,branchid AS id,tino,emailid,phone,address,cstno,stno FROM branchmaster");
            }
            if (type == "Section")
            {
                cmd = new SqlCommand("SELECT name AS branchname, color,sectionid AS id, status FROM sectionmaster where branchid=@branchid");
                cmd.Parameters.Add("@branchid", branchid);
            }
            if (type == "Supplier")
            {
                cmd = new SqlCommand("SELECT name AS branchname,supplierid AS id FROM suppliersdetails WHERE branchid=@branchid");
                cmd.Parameters.Add("@branchid", branchid);
            }

            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<BranchDetalis> EmployeDetalis = new List<BranchDetalis>();
            foreach (DataRow dr in routes.Rows)
            {
                BranchDetalis getbrcdetails = new BranchDetalis();
                getbrcdetails.name = dr["branchname"].ToString();
                getbrcdetails.id = dr["id"].ToString();
                EmployeDetalis.Add(getbrcdetails);
            }
            string response = GetJson(EmployeDetalis);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_Stores_return_Report_details(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string frmdate = context.Request["fromdate"];
            DateTime fromdate = Convert.ToDateTime(frmdate);
            string tdate = context.Request["todate"];
            DateTime todate = Convert.ToDateTime(tdate);
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT sno,name, doe,remarks FROM stores_return WHERE (doe BETWEEN @d1 AND @d2) AND (branchid=@branchid)");
            cmd.Parameters.Add("@d1", GetLowDate(fromdate));
            cmd.Parameters.Add("@d2", GetHighDate(todate));
            cmd.Parameters.Add("@branchid", branchid);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<StoresReturn> strores_return_lst = new List<StoresReturn>();
            foreach (DataRow dr in routes.Rows)
            {
                StoresReturn getStoresReturnDetails = new StoresReturn();
                getStoresReturnDetails.sno = dr["sno"].ToString();
                getStoresReturnDetails.name = dr["name"].ToString();
                getStoresReturnDetails.doe = ((DateTime)dr["doe"]).ToString("dd-MM-yyyy");  //dr["doe"].ToString();
                getStoresReturnDetails.remarks = dr["remarks"].ToString();
                strores_return_lst.Add(getStoresReturnDetails);
            }
            string response = GetJson(strores_return_lst);
            context.Response.Write(response);

        }
        catch
        {
        }
    }

    private void get_SubStores_return_Report_details(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string storesret_sno = context.Request["refdcno"];
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT stores_return.sno, sub_stores_return.sno AS sub_stores_sno, stores_return.name, stores_return.doe, stores_return.remarks, sub_stores_return.quantity, sub_stores_return.perunit, sub_stores_return.productid,sub_stores_return.storesreturn_sno, productmaster.productname, productmaster.productcode FROM stores_return INNER JOIN sub_stores_return ON stores_return.sno = sub_stores_return.storesreturn_sno INNER JOIN productmaster ON sub_stores_return.productid = productmaster.productid where stores_return.sno=@storesret_sno AND stores_return.branchid=@branchid");
            cmd.Parameters.Add("@storesret_sno", storesret_sno);
            cmd.Parameters.Add("@branchid", branchid);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(routes);
            DataTable dtsreturn = view.ToTable(true, "sno", "name", "doe", "remarks");
            DataTable dtssreturn = view.ToTable(true, "sub_stores_sno", "storesreturn_sno", "quantity", "perunit", "productname", "productcode", "productid");
            List<getStoresReturn> storesreturndetails = new List<getStoresReturn>();
            List<StoresReturn> strores_return_lst = new List<StoresReturn>();
            List<SubStoresReturn> sub_strores_return_list = new List<SubStoresReturn>();
            foreach (DataRow dr in dtsreturn.Rows)
            {
                StoresReturn getStoresReturnDetails = new StoresReturn();
                getStoresReturnDetails.sno = dr["sno"].ToString();
                getStoresReturnDetails.name = dr["name"].ToString();
                getStoresReturnDetails.doe = ((DateTime)dr["doe"]).ToString("dd-MM-yyyy");  //dr["doe"].ToString();
                getStoresReturnDetails.remarks = dr["remarks"].ToString();
                strores_return_lst.Add(getStoresReturnDetails);
            }
            foreach (DataRow dr in dtssreturn.Rows)
            {
                SubStoresReturn getindent = new SubStoresReturn();
                getindent.sstore_refno = dr["storesreturn_sno"].ToString();
                getindent.quantity = dr["quantity"].ToString();
                getindent.PerUnitRs = dr["perunit"].ToString();
                getindent.sisno = dr["sub_stores_sno"].ToString();
                getindent.hdnproductsno = dr["productid"].ToString();
                getindent.productname = dr["productname"].ToString();
                getindent.productcode = dr["productcode"].ToString();
                sub_strores_return_list.Add(getindent);
            }
            getStoresReturn getStores = new getStoresReturn();
            getStores.StoresReturn = strores_return_lst;
            getStores.SubStoresReturn = sub_strores_return_list;
            storesreturndetails.Add(getStores);
            string response = GetJson(storesreturndetails);
            context.Response.Write(response);

        }
        catch
        {
        }
    }

    private void get_Stores_details(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT stores_return.sno, sub_stores_return.sno AS sub_stores_sno, stores_return.name, stores_return.doe, stores_return.remarks, sub_stores_return.quantity, sub_stores_return.perunit, sub_stores_return.productid,sub_stores_return.storesreturn_sno, productmaster.productname, productmaster.productcode FROM stores_return INNER JOIN sub_stores_return ON stores_return.sno = sub_stores_return.storesreturn_sno INNER JOIN productmaster ON sub_stores_return.productid = productmaster.productid WHERE (stores_return.branchid=@branchid) AND (status='p')");
            cmd.Parameters.Add("@branchid", branchid);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(routes);
            DataTable dtsreturn = view.ToTable(true, "sno", "name", "doe", "remarks");
            DataTable dtssreturn = view.ToTable(true, "sub_stores_sno", "storesreturn_sno", "quantity", "perunit", "productname", "productcode", "productid");
            List<getStoresReturn> storesreturndetails = new List<getStoresReturn>();
            List<StoresReturn> strores_return_lst = new List<StoresReturn>();
            List<SubStoresReturn> sub_strores_return_list = new List<SubStoresReturn>();
            foreach (DataRow dr in dtsreturn.Rows)
            {
                StoresReturn getStoresReturnDetails = new StoresReturn();
                getStoresReturnDetails.sno = dr["sno"].ToString();
                getStoresReturnDetails.name = dr["name"].ToString();
                getStoresReturnDetails.doe = ((DateTime)dr["doe"]).ToString("dd-MM-yyyy");  //dr["doe"].ToString();
                getStoresReturnDetails.remarks = dr["remarks"].ToString();
                strores_return_lst.Add(getStoresReturnDetails);
            }
            foreach (DataRow dr in dtssreturn.Rows)
            {
                SubStoresReturn getindent = new SubStoresReturn();
                getindent.sstore_refno = dr["storesreturn_sno"].ToString();
                getindent.quantity = dr["quantity"].ToString();
                getindent.PerUnitRs = dr["perunit"].ToString();
                getindent.sisno = dr["sub_stores_sno"].ToString();
                getindent.hdnproductsno = dr["productid"].ToString();
                getindent.productname = dr["productname"].ToString();
                getindent.productcode = dr["productcode"].ToString();
                sub_strores_return_list.Add(getindent);
            }
            getStoresReturn getStores = new getStoresReturn();
            getStores.StoresReturn = strores_return_lst;
            getStores.SubStoresReturn = sub_strores_return_list;
            storesreturndetails.Add(getStores);
            string response = GetJson(storesreturndetails);
            context.Response.Write(response);

        }
        catch
        {
        }
    }

    private void saveInternalDetails(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            var js = new JavaScriptSerializer();
            var title1 = context.Request.Params[1];
            tools_issue_receive obj = js.Deserialize<tools_issue_receive>(title1);
            string name = obj.name;
            string invdate = obj.issudate;
            DateTime invoiate = Convert.ToDateTime(invdate);
            string issueddate = invoiate.ToString("MM-dd-yyyy");
            string type = obj.type;
            string dname = obj.dname;
            string issueremarks = obj.issueremarks;
            string Others = obj.Others;
            string status = obj.status;
            string sno = obj.sno;
            string entryby = context.Session["Employ_Sno"].ToString();
            string branchid = context.Session["Po_BranchID"].ToString();
            string btn_save = obj.btnVal;
            if (btn_save == "Save")
            {
                if (type == "Branch")
                {
                    cmd = new SqlCommand("insert into tools_issue_receive (others,name,issudate,issued_by,branch_id,issueremarks,status,type,branchid ) values (@others,@name,@issudate,@issued_by,@branch_id,@issueremarks,@status,@type,@branchid)");
                    cmd.Parameters.Add("@branchid", branchid);
                    cmd.Parameters.Add("@branch_id", dname);
                    cmd.Parameters.Add("@type", type);
                }
                if (type == "Section")
                {
                    cmd = new SqlCommand("insert into tools_issue_receive (others,name,issudate,section__id,issued_by,issueremarks,status,type,branchid ) values (@others,@name,@issudate,@section__id,@issued_by,@issueremarks,@status,@type,@branchid)");
                    cmd.Parameters.Add("@branchid", branchid);
                    cmd.Parameters.Add("@section__id", dname);
                    cmd.Parameters.Add("@type", type);
                }
                if (type == "Others")
                {
                    cmd = new SqlCommand("insert into tools_issue_receive (others,name,issudate,issued_by,issueremarks,status,type,branchid) values (@others,@name,@issudate,@issued_by,@issueremarks,@status,@type,@branchid)");
                    cmd.Parameters.Add("@branchid", branchid);
                    cmd.Parameters.Add("@type", type);
                }
                cmd.Parameters.Add("@others", Others);
                cmd.Parameters.Add("@name", name);
                cmd.Parameters.Add("@issudate", issueddate);
                cmd.Parameters.Add("@issued_by", entryby);
                cmd.Parameters.Add("@issueremarks", issueremarks);
                cmd.Parameters.Add("@status", status);
                vdm.insert(cmd);
                cmd = new SqlCommand("select MAX(sno) as stcokr  from tools_issue_receive");
                DataTable dtstocks = vdm.SelectQuery(cmd).Tables[0];
                string stock_refno = dtstocks.Rows[0]["stcokr"].ToString();
                foreach (subtools_issue_receive si in obj.fillreturn)
                {
                    if (si.hdnproductsno != "0")
                    {
                        cmd = new SqlCommand("insert into subtools_issue_receive(productid,quantity,r_refno) values(@productid,@quantity,@stock_refno)");
                        cmd.Parameters.Add("@productid", si.hdnproductsno);
                        cmd.Parameters.Add("@quantity", si.quantity);
                        cmd.Parameters.Add("@stock_refno", stock_refno);
                        vdm.insert(cmd);
                        cmd = new SqlCommand("update productmoniter set qty=qty-@quantity where productid=@hdnproductsno AND branchid=@branchid");
                        cmd.Parameters.Add("@branchid", branchid);
                        cmd.Parameters.Add("@quantity", si.quantity);
                        cmd.Parameters.Add("@hdnproductsno", si.hdnproductsno);
                        if (vdm.Update(cmd) == 0)
                        {
                            cmd = new SqlCommand("insert into productmoniter (productid,qty,branchid) values(@productid,@qty,@branchid)");
                            cmd.Parameters.Add("@branchid", branchid);
                            cmd.Parameters.Add("@productid", si.hdnproductsno);
                            cmd.Parameters.Add("@qty", si.quantity);
                            vdm.insert(cmd);
                        }
                    }
                }
                string msg = "Internal successfully saved";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {
                if (type == "Branch")
                {
                    cmd = new SqlCommand("Update tools_issue_receive set  others=@others, name=@name,issudate=@issudate,branch_id=@branch_id,issueremarks=@issueremarks where sno=@sno AND branchid=@branchid");
                    cmd.Parameters.Add("@branchid", branchid);
                    cmd.Parameters.Add("@branch_id", dname);
                    cmd.Parameters.Add("@type", type);
                }
                if (type == "Section")
                {
                    cmd = new SqlCommand("Update tools_issue_receive set  others=@others, name=@name,issudate=@issudate,section__id=@section__id,issueremarks=@issueremarks where sno=@sno AND branchid=@branchid");
                    cmd.Parameters.Add("@branchid", branchid);
                    cmd.Parameters.Add("@section__id", dname);
                    cmd.Parameters.Add("@type", type);
                }
                if (type == "Others")
                {
                    cmd = new SqlCommand("Update tools_issue_receive set  others=@others,name=@name,issudate=@issudate,issueremarks=@issueremarks where sno=@sno AND branchid=@branchid");
                    cmd.Parameters.Add("@branchid", branchid);
                    cmd.Parameters.Add("@type", type);
                }
                cmd.Parameters.Add("@others", Others);
                cmd.Parameters.Add("@name", name);
                cmd.Parameters.Add("@issudate", issueddate);
                cmd.Parameters.Add("@issueremarks", issueremarks);
                cmd.Parameters.Add("@sno", sno);
                vdm.Update(cmd);
                foreach (subtools_issue_receive si in obj.fillreturn)
                {
                    cmd = new SqlCommand("select * from subtools_issue_receive where  productid=@productid and r_refno=@r_refno");
                    cmd.Parameters.Add("@productid", si.hdnproductsno);
                    cmd.Parameters.Add("@r_refno", si.subsno);
                    DataTable dtprev = vdm.SelectQuery(cmd).Tables[0];
                    float prevqty = 0;
                    if (dtprev.Rows.Count > 0)
                    {
                        string amount = dtprev.Rows[0]["quantity"].ToString();
                        float.TryParse(amount, out prevqty);
                    }
                    cmd = new SqlCommand("update subtools_issue_receive set productid=@productid, quantity=@quantity where r_refno=@r_refno and sno=@sno ");
                    cmd.Parameters.Add("@productid", si.hdnproductsno);
                    cmd.Parameters.Add("@quantity", si.quantity);
                    cmd.Parameters.Add("@r_refno", sno);
                    cmd.Parameters.Add("@sno", si.subsno);
                    vdm.Update(cmd);
                    float presentqty = 0;
                    float.TryParse(si.quantity, out presentqty);
                    double editqty = 0;
                    if (presentqty >= prevqty)
                    {
                        editqty = presentqty - prevqty;
                        cmd = new SqlCommand("UPDATE productmoniter set qty=qty-@new_quantity where productid=@productid AND branchid=@branchid");
                        cmd.Parameters.Add("@productid", si.hdnproductsno);
                        cmd.Parameters.Add("@new_quantity", editqty);
                        cmd.Parameters.Add("@branchid", branchid);
                        if (vdm.Update(cmd) == 0)
                        {
                            cmd = new SqlCommand("insert into productmoniter (productid,qty,branchid) values(@productid,@qty,@branchid)");
                            cmd.Parameters.Add("@productid", si.hdnproductsno);
                            cmd.Parameters.Add("@qty", si.quantity);
                            cmd.Parameters.Add("@branchid", branchid);
                            vdm.insert(cmd);
                        }
                    }
                    else
                    {
                        editqty = prevqty - presentqty;
                        cmd = new SqlCommand("UPDATE productmoniter set qty=qty+@new_quantity where productid=@productid AND branchid=@branchid");
                        cmd.Parameters.Add("@productid", si.hdnproductsno);
                        cmd.Parameters.Add("@new_quantity", editqty);
                        cmd.Parameters.Add("@branchid", branchid);
                        if (vdm.Update(cmd) == 0)
                        {
                            cmd = new SqlCommand("insert into productmoniter (productid,qty,branchid) values(@productid,@qty,@branchid)");
                            cmd.Parameters.Add("@productid", si.hdnproductsno);
                            cmd.Parameters.Add("@qty", si.quantity);
                            cmd.Parameters.Add("@branchid", branchid);
                            vdm.insert(cmd);
                        }
                    }
                }
                string msg = "Internal successfully updated";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class subtools_issue_receive
    {
        public string hiddenid { get; set; }
        public string productid { get; set; }
        public string productname { get; set; }
        public string hdnproductsno { get; set; }
        public string sno { get; set; }
        public string quantity { get; set; }
        public string subsno { get; set; }

    }
    public class tools_issue_receive
    {
        public string name { get; set; }
        public string dname { get; set; }
        public string type { get; set; }
        public string hiddenid { get; set; }
        public string hiddenid1 { get; set; }
        public string sectionname { get; set; }
        public string issudate { get; set; }
        public string section { get; set; }
        public string issueremarks { get; set; }
        public string branchname { get; set; }
        public string receiveddate { get; set; }
        public string sno { get; set; }
        public string Others { get; set; }
        public string status { get; set; }
        public string Recieveremarks { get; set; }
        public string btnVal { get; set; }
        public string issued_by { get; set; }
        public List<subtools_issue_receive> fillreturn { get; set; }
    }
    public class ReturnClass
    {
        public List<tools_issue_receive> tools_issue_receive { get; set; }
        public List<subtools_issue_receive> subtools_issue_receive { get; set; }
    }

    private void get_Returnable_Material_data(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT  tools_issue_receive.branch_id, tools_issue_receive.name, tools_issue_receive.issudate, tools_issue_receive.issueremarks, tools_issue_receive.receiveddate,  tools_issue_receive.receivedremarks, tools_issue_receive.issued_by, tools_issue_receive.received_by, tools_issue_receive.status, tools_issue_receive.type,  tools_issue_receive.others, subtools_issue_receive.sno, subtools_issue_receive.quantity, subtools_issue_receive.r_refno, uimmaster.uim,  sectionmaster.name AS sectionname, tools_issue_receive.section__id, branchmaster.branchname, subtools_issue_receive.productid, productmaster.productname,  tools_issue_receive.sno AS Expr1 FROM tools_issue_receive INNER JOIN subtools_issue_receive ON tools_issue_receive.sno = subtools_issue_receive.r_refno INNER JOIN productmaster ON subtools_issue_receive.productid = productmaster.productid INNER JOIN uimmaster ON productmaster.uim = uimmaster.sno LEFT OUTER JOIN sectionmaster ON tools_issue_receive.section__id = sectionmaster.sectionid LEFT OUTER JOIN branchmaster ON tools_issue_receive.branch_id = branchmaster.branchid WHERE (tools_issue_receive.branchid = @branchid) and (tools_issue_receive.issudate BETWEEN @d1 and @d2)");
            cmd.Parameters.Add("@branchid", branchid);
            cmd.Parameters.Add("@d1", GetLowDate(ServerDateCurrentdate).AddDays(-2));
            cmd.Parameters.Add("@d2", GetHighDate(ServerDateCurrentdate));
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(routes);
            DataTable dttools = view.ToTable(true, "Expr1", "branch_id", "name", "issudate", "issueremarks", "receiveddate", "receivedremarks", "issued_by", "received_by", "status", "type", "others", "branchname", "sectionname", "section__id");
            DataTable dtsubtools = view.ToTable(true, "quantity", "sno", "r_refno", "uim", "productname", "productid");
            List<tools_issue_receive> tools_issuelist = new List<tools_issue_receive>();
            List<subtools_issue_receive> subtools_issuelist = new List<subtools_issue_receive>();
            List<ReturnClass> ReturnList = new List<ReturnClass>();
            foreach (DataRow dr in dttools.Rows)
            {
                tools_issue_receive gettoolsissuedetails = new tools_issue_receive();
                gettoolsissuedetails.sno = dr["Expr1"].ToString();
                gettoolsissuedetails.issudate = ((DateTime)dr["issudate"]).ToString("dd-MM-yyyy");  //dr["issudate"].ToString();
                gettoolsissuedetails.name = dr["name"].ToString();
                gettoolsissuedetails.sectionname = dr["sectionname"].ToString();
                gettoolsissuedetails.issued_by = dr["issued_by"].ToString();
                gettoolsissuedetails.issueremarks = dr["issueremarks"].ToString();
                gettoolsissuedetails.status = dr["status"].ToString();
                string type = dr["type"].ToString();
                gettoolsissuedetails.type = type.ToString();
                if (type == "Branch")
                {
                    gettoolsissuedetails.dname = dr["branchname"].ToString();
                    gettoolsissuedetails.hiddenid = dr["branch_id"].ToString();
                }
                if (type == "Section")
                {
                    gettoolsissuedetails.dname = dr["sectionname"].ToString();
                    gettoolsissuedetails.hiddenid = dr["section__id"].ToString();
                }
                if (type == "Others")
                {
                    gettoolsissuedetails.dname = dr["others"].ToString();
                }
                tools_issuelist.Add(gettoolsissuedetails);
            }
            foreach (DataRow drr in dtsubtools.Rows)
            {
                subtools_issue_receive getsubtoolsreceive = new subtools_issue_receive();
                getsubtoolsreceive.sno = drr["sno"].ToString();
                getsubtoolsreceive.subsno = drr["r_refno"].ToString();
                getsubtoolsreceive.productname = drr["productname"].ToString();
                getsubtoolsreceive.quantity = drr["quantity"].ToString();
                getsubtoolsreceive.hdnproductsno = drr["productid"].ToString();
                subtools_issuelist.Add(getsubtoolsreceive);
            }
            ReturnClass getreturndetails = new ReturnClass();
            getreturndetails.tools_issue_receive = tools_issuelist;
            getreturndetails.subtools_issue_receive = subtools_issuelist;
            ReturnList.Add(getreturndetails);
            string response = GetJson(ReturnList);
            context.Response.Write(response);
        }
        catch
        {
        }
    }

    private void get_Returnble_Material_details(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string branchid = context.Session["Po_BranchID"].ToString();
            string refno = context.Request["refno"].ToString();
            if (refno == null)
            {
                cmd = new SqlCommand("SELECT  tools_issue_receive.branch_id, tools_issue_receive.name, tools_issue_receive.issudate, tools_issue_receive.issueremarks, tools_issue_receive.receiveddate,  tools_issue_receive.receivedremarks, tools_issue_receive.issued_by, tools_issue_receive.received_by, tools_issue_receive.status, tools_issue_receive.type,  tools_issue_receive.others, subtools_issue_receive.sno, subtools_issue_receive.quantity, subtools_issue_receive.r_refno, uimmaster.uim,  sectionmaster.name AS sectionname, tools_issue_receive.section__id, branchmaster.branchname, subtools_issue_receive.productid, productmaster.productname,  tools_issue_receive.sno AS Expr1 FROM tools_issue_receive INNER JOIN subtools_issue_receive ON tools_issue_receive.sno = subtools_issue_receive.r_refno INNER JOIN productmaster ON subtools_issue_receive.productid = productmaster.productid INNER JOIN uimmaster ON productmaster.uim = uimmaster.sno LEFT OUTER JOIN sectionmaster ON tools_issue_receive.section__id = sectionmaster.sectionid LEFT OUTER JOIN branchmaster ON tools_issue_receive.branch_id = branchmaster.branchid WHERE (tools_issue_receive.branchid = @branchid)");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@d1", GetLowDate(ServerDateCurrentdate).AddDays(-2));
                cmd.Parameters.Add("@d2", GetHighDate(ServerDateCurrentdate));
            }
            else
            {
                cmd = new SqlCommand("SELECT  tools_issue_receive.branch_id, tools_issue_receive.name, tools_issue_receive.issudate, tools_issue_receive.issueremarks, tools_issue_receive.receiveddate,  tools_issue_receive.receivedremarks, tools_issue_receive.issued_by, tools_issue_receive.received_by, tools_issue_receive.status, tools_issue_receive.type,  tools_issue_receive.others, subtools_issue_receive.sno, subtools_issue_receive.quantity, subtools_issue_receive.r_refno, uimmaster.uim,  sectionmaster.name AS sectionname, tools_issue_receive.section__id, branchmaster.branchname, subtools_issue_receive.productid, productmaster.productname,  tools_issue_receive.sno AS Expr1 FROM tools_issue_receive INNER JOIN subtools_issue_receive ON tools_issue_receive.sno = subtools_issue_receive.r_refno INNER JOIN productmaster ON subtools_issue_receive.productid = productmaster.productid INNER JOIN uimmaster ON productmaster.uim = uimmaster.sno LEFT OUTER JOIN sectionmaster ON tools_issue_receive.section__id = sectionmaster.sectionid LEFT OUTER JOIN branchmaster ON tools_issue_receive.branch_id = branchmaster.branchid WHERE (tools_issue_receive.branchid = @branchid) and (tools_issue_receive.sno=@sno)");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@sno", refno);
            }
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(routes);
            DataTable dttools = view.ToTable(true, "Expr1", "branch_id", "name", "issudate", "issueremarks", "receiveddate", "receivedremarks", "issued_by", "received_by", "status", "type", "others", "branchname", "sectionname", "section__id");
            DataTable dtsubtools = view.ToTable(true, "quantity", "sno", "r_refno", "uim", "productname", "productid");
            List<tools_issue_receive> tools_issuelist = new List<tools_issue_receive>();
            List<subtools_issue_receive> subtools_issuelist = new List<subtools_issue_receive>();
            List<ReturnClass> ReturnList = new List<ReturnClass>();
            foreach (DataRow dr in dttools.Rows)
            {
                tools_issue_receive gettoolsissuedetails = new tools_issue_receive();
                gettoolsissuedetails.sno = dr["Expr1"].ToString();
                gettoolsissuedetails.issudate = ((DateTime)dr["issudate"]).ToString("dd-MM-yyyy");  //dr["issudate"].ToString();
                gettoolsissuedetails.name = dr["name"].ToString();
                gettoolsissuedetails.sectionname = dr["sectionname"].ToString();
                gettoolsissuedetails.issued_by = dr["issued_by"].ToString();
                gettoolsissuedetails.issueremarks = dr["issueremarks"].ToString();
                gettoolsissuedetails.status = dr["status"].ToString();
                string type = dr["type"].ToString();
                gettoolsissuedetails.type = type.ToString();
                if (type == "Branch")
                {
                    gettoolsissuedetails.dname = dr["branchname"].ToString();
                    gettoolsissuedetails.hiddenid = dr["branch_id"].ToString();
                }
                if (type == "Section")
                {
                    gettoolsissuedetails.dname = dr["sectionname"].ToString();
                    gettoolsissuedetails.hiddenid = dr["section__id"].ToString();
                }
                if (type == "Others")
                {
                    gettoolsissuedetails.dname = dr["others"].ToString();
                }
                tools_issuelist.Add(gettoolsissuedetails);
            }
            foreach (DataRow drr in dtsubtools.Rows)
            {
                subtools_issue_receive getsubtoolsreceive = new subtools_issue_receive();
                getsubtoolsreceive.sno = drr["sno"].ToString();
                getsubtoolsreceive.subsno = drr["r_refno"].ToString();
                getsubtoolsreceive.productname = drr["productname"].ToString();
                getsubtoolsreceive.quantity = drr["quantity"].ToString();
                getsubtoolsreceive.hdnproductsno = drr["productid"].ToString();
                subtools_issuelist.Add(getsubtoolsreceive);
            }
            ReturnClass getreturndetails = new ReturnClass();
            getreturndetails.tools_issue_receive = tools_issuelist;
            getreturndetails.subtools_issue_receive = subtools_issuelist;
            ReturnList.Add(getreturndetails);
            string response = GetJson(ReturnList);
            context.Response.Write(response);
        }
        catch
        {
        }
    }

    private void save_Verify_Returnble_Material_click(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            var js = new JavaScriptSerializer();
            var title1 = context.Request.Params[1];
            tools_issue_receive obj = js.Deserialize<tools_issue_receive>(title1);
            string name = obj.name;
            string invdate = obj.issudate;
            DateTime invoiate = Convert.ToDateTime(invdate);
            string issueddate = invoiate.ToString("MM-dd-yyyy");
            string type = obj.type;
            string dname = obj.dname;
            string issueremarks = obj.issueremarks;
            string Others = obj.Others;
            string receiveddate = obj.receiveddate;
            string Recieveremarks = obj.Recieveremarks;
            string status = obj.status;
            string sno = obj.sno;
            string entryby = context.Session["Employ_Sno"].ToString();
            string branchid = context.Session["Po_BranchID"].ToString();
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string issued_by = context.Session["Employ_Sno"].ToString();
            if (type == "Branch")
            {
                cmd = new SqlCommand("Update tools_issue_receive set  receivedremarks=@receivedremarks,receiveddate=@receiveddate,status=@status,others=@others, name=@name,issudate=@issudate,branch_id=@branch_id,issueremarks=@issueremarks where sno=@sno AND branchid=@branchid");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@branch_id", dname);
                cmd.Parameters.Add("@type", type);
            }
            if (type == "Section")
            {
                cmd = new SqlCommand("Update tools_issue_receive set  receivedremarks=@receivedremarks,receiveddate=@receiveddate,status=@status,others=@others, name=@name,issudate=@issudate,section__id=@section__id,issueremarks=@issueremarks where sno=@sno AND branchid=@branchid");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@section__id", dname);
                cmd.Parameters.Add("@type", type);
            }
            if (type == "Others")
            {
                cmd = new SqlCommand("Update tools_issue_receive set  receivedremarks=@receivedremarks,receiveddate=@receiveddate,status=@status,others=@others,name=@name,issudate=@issudate,issueremarks=@issueremarks where sno=@sno AND branchid=@branchid");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@type", type);
            }
            cmd.Parameters.Add("@others", Others);
            cmd.Parameters.Add("@name", name);
            cmd.Parameters.Add("@issudate", issueddate);
            cmd.Parameters.Add("@receiveddate", receiveddate);
            cmd.Parameters.Add("@status", "V");
            cmd.Parameters.Add("@issueremarks", issueremarks);
            cmd.Parameters.Add("@receivedremarks", Recieveremarks);
            cmd.Parameters.Add("@sno", sno);
            vdm.Update(cmd);
            foreach (subtools_issue_receive si in obj.fillreturn)
            {
                cmd = new SqlCommand("select * from subtools_issue_receive where  productid=@productid and r_refno=@r_refno");
                cmd.Parameters.Add("@productid", si.hdnproductsno);
                cmd.Parameters.Add("@r_refno", si.subsno);
                DataTable dtprev = vdm.SelectQuery(cmd).Tables[0];
                float prevqty = 0;
                if (dtprev.Rows.Count > 0)
                {
                    string amount = dtprev.Rows[0]["quantity"].ToString();
                    float.TryParse(amount, out prevqty);
                }
                cmd = new SqlCommand("update subtools_issue_receive set productid=@productid, quantity=@quantity where r_refno=@r_refno and sno=@sno ");
                cmd.Parameters.Add("@productid", si.hdnproductsno);
                cmd.Parameters.Add("@quantity", si.quantity);
                cmd.Parameters.Add("@r_refno", sno);
                cmd.Parameters.Add("@sno", si.subsno);
                vdm.Update(cmd);
                float presentqty = 0;
                float.TryParse(si.quantity, out presentqty);
                double editqty = 0;
                if (presentqty >= prevqty)
                {
                    editqty = presentqty - prevqty;
                    cmd = new SqlCommand("UPDATE productmoniter set qty=qty+@new_quantity where productid=@productid AND branchid=@branchid");
                    cmd.Parameters.Add("@productid", si.hdnproductsno);
                    cmd.Parameters.Add("@new_quantity", editqty);
                    cmd.Parameters.Add("@branchid", branchid);
                    if (vdm.Update(cmd) == 0)
                    {
                        cmd = new SqlCommand("insert into productmoniter (productid,qty,branchid) values(@productid,@qty,@branchid)");
                        cmd.Parameters.Add("@productid", si.hdnproductsno);
                        cmd.Parameters.Add("@qty", si.quantity);
                        cmd.Parameters.Add("@branchid", branchid);
                        vdm.insert(cmd);
                    }
                }
                else
                {
                    editqty = prevqty - presentqty;
                    cmd = new SqlCommand("UPDATE productmoniter set qty=qty-@new_quantity where productid=@productid AND branchid=@branchid");
                    cmd.Parameters.Add("@productid", si.hdnproductsno);
                    cmd.Parameters.Add("@new_quantity", editqty);
                    cmd.Parameters.Add("@branchid", branchid);
                    if (vdm.Update(cmd) == 0)
                    {
                        cmd = new SqlCommand("insert into productmoniter (productid,qty,branchid) values(@productid,@qty,@branchid)");
                        cmd.Parameters.Add("@productid", si.hdnproductsno);
                        cmd.Parameters.Add("@qty", si.quantity);
                        cmd.Parameters.Add("@branchid", branchid);
                        vdm.insert(cmd);
                    }
                }
            }
            string msg = "Returnble Material successfully Verified";
            string Response = GetJson(msg);
            context.Response.Write(Response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_Returnble_Material_details_Report(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string branchid = context.Session["Po_BranchID"].ToString();
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string frmdate = context.Request["fromdate"].ToString();
            DateTime fromdate = Convert.ToDateTime(frmdate);
            string tdate = context.Request["todate"].ToString();
            DateTime todate = Convert.ToDateTime(tdate);
            cmd = new SqlCommand("SELECT  sno, name, issudate, issueremarks, receiveddate, receivedremarks, issued_by, received_by, branch_id, qty, status, section__id, type, others, branchid FROM  tools_issue_receive WHERE (branchid=@branchid) AND (issudate BETWEEN @d1 AND @d2)");
            cmd.Parameters.Add("@branchid", branchid);
            cmd.Parameters.Add("@d1", GetLowDate(fromdate));
            cmd.Parameters.Add("@d2", GetHighDate(todate));
            DataTable dtpo = vdm.SelectQuery(cmd).Tables[0];
            List<tools_issue_receive> retunablelist = new List<tools_issue_receive>();
            foreach (DataRow dr in dtpo.Rows)
            {
                tools_issue_receive getretunableldetails = new tools_issue_receive();
                getretunableldetails.sno = dr["sno"].ToString();
                getretunableldetails.name = dr["name"].ToString();
                getretunableldetails.issudate = ((DateTime)dr["issudate"]).ToString("dd-MM-yyyy"); //dr["issudate"].ToString();
                getretunableldetails.issueremarks = dr["issueremarks"].ToString();
                getretunableldetails.issued_by = dr["issued_by"].ToString();
                getretunableldetails.status = dr["status"].ToString();
                retunablelist.Add(getretunableldetails);
            }
            string response = GetJson(retunablelist);
            context.Response.Write(response);
        }
        catch
        {
        }
    }

    private void get_Returnble_Material_Report_SubDetails(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string branchid = context.Session["Po_BranchID"].ToString();
            string refno = context.Request["refno"].ToString();

            cmd = new SqlCommand("SELECT  tools_issue_receive.branch_id, tools_issue_receive.name, tools_issue_receive.issudate, tools_issue_receive.issueremarks, tools_issue_receive.receiveddate,  tools_issue_receive.receivedremarks, tools_issue_receive.issued_by, tools_issue_receive.received_by, tools_issue_receive.status, tools_issue_receive.type,  tools_issue_receive.others, subtools_issue_receive.sno, subtools_issue_receive.quantity, subtools_issue_receive.r_refno, uimmaster.uim,  sectionmaster.name AS sectionname, tools_issue_receive.section__id, branchmaster.branchname, subtools_issue_receive.productid, productmaster.productname,  tools_issue_receive.sno AS Expr1 FROM tools_issue_receive INNER JOIN subtools_issue_receive ON tools_issue_receive.sno = subtools_issue_receive.r_refno INNER JOIN productmaster ON subtools_issue_receive.productid = productmaster.productid INNER JOIN uimmaster ON productmaster.uim = uimmaster.sno LEFT OUTER JOIN sectionmaster ON tools_issue_receive.section__id = sectionmaster.sectionid LEFT OUTER JOIN branchmaster ON tools_issue_receive.branch_id = branchmaster.branchid WHERE (tools_issue_receive.branchid = @branchid) and (tools_issue_receive.sno=@sno)");
            cmd.Parameters.Add("@branchid", branchid);
            cmd.Parameters.Add("@sno", refno);

            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(routes);
            DataTable dttools = view.ToTable(true, "Expr1", "branch_id", "name", "issudate", "issueremarks", "receiveddate", "receivedremarks", "issued_by", "received_by", "status", "type", "others", "branchname", "sectionname", "section__id");
            DataTable dtsubtools = view.ToTable(true, "quantity", "sno", "r_refno", "uim", "productname", "productid");
            List<tools_issue_receive> tools_issuelist = new List<tools_issue_receive>();
            List<subtools_issue_receive> subtools_issuelist = new List<subtools_issue_receive>();
            List<ReturnClass> ReturnList = new List<ReturnClass>();
            foreach (DataRow dr in dttools.Rows)
            {
                tools_issue_receive gettoolsissuedetails = new tools_issue_receive();
                gettoolsissuedetails.sno = dr["Expr1"].ToString();
                gettoolsissuedetails.issudate = ((DateTime)dr["issudate"]).ToString("dd-MM-yyyy");  //dr["issudate"].ToString();
                gettoolsissuedetails.name = dr["name"].ToString();
                gettoolsissuedetails.sectionname = dr["sectionname"].ToString();
                gettoolsissuedetails.issued_by = dr["issued_by"].ToString();
                gettoolsissuedetails.issueremarks = dr["issueremarks"].ToString();
                gettoolsissuedetails.status = dr["status"].ToString();
                string type = dr["type"].ToString();
                gettoolsissuedetails.type = type.ToString();
                if (type == "Branch")
                {
                    gettoolsissuedetails.dname = dr["branchname"].ToString();
                    gettoolsissuedetails.hiddenid = dr["branch_id"].ToString();
                }
                if (type == "Section")
                {
                    gettoolsissuedetails.dname = dr["sectionname"].ToString();
                    gettoolsissuedetails.hiddenid = dr["section__id"].ToString();
                }
                if (type == "Others")
                {
                    gettoolsissuedetails.dname = dr["others"].ToString();
                }
                tools_issuelist.Add(gettoolsissuedetails);
            }
            foreach (DataRow drr in dtsubtools.Rows)
            {
                subtools_issue_receive getsubtoolsreceive = new subtools_issue_receive();
                getsubtoolsreceive.sno = drr["sno"].ToString();
                getsubtoolsreceive.subsno = drr["r_refno"].ToString();
                getsubtoolsreceive.productname = drr["productname"].ToString();
                getsubtoolsreceive.quantity = drr["quantity"].ToString();
                getsubtoolsreceive.hdnproductsno = drr["productid"].ToString();
                subtools_issuelist.Add(getsubtoolsreceive);
            }
            ReturnClass getreturndetails = new ReturnClass();
            getreturndetails.tools_issue_receive = tools_issuelist;
            getreturndetails.subtools_issue_receive = subtools_issuelist;
            ReturnList.Add(getreturndetails);
            string response = GetJson(ReturnList);
            context.Response.Write(response);
        }
        catch
        {
        }
    }

    private void get_indent_details_click(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string frmdate = context.Request["fromdate"];
            DateTime fromdate = Convert.ToDateTime(frmdate);
            string tdate = context.Request["todate"];
            DateTime todate = Convert.ToDateTime(tdate);
            string BranchID = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT name,i_date, remarks, sno, status  FROM indents WHERE (i_date BETWEEN @d1 AND @d2) AND (branch_id=@branch_id)");
            cmd.Parameters.Add("@branch_id", BranchID);
            cmd.Parameters.Add("@d1", GetLowDate(fromdate));
            cmd.Parameters.Add("@d2", GetHighDate(todate));
            DataTable dtpo = vdm.SelectQuery(cmd).Tables[0];
            List<Indent> Indent = new List<Indent>();
            foreach (DataRow dr in dtpo.Rows)
            {
                Indent getindent = new Indent();
                getindent.sno = dr["sno"].ToString();
                getindent.name = dr["name"].ToString();
                getindent.idate = ((DateTime)dr["i_date"]).ToString("dd-MM-yyyy"); //dr["i_date"].ToString();
                getindent.remarks = dr["remarks"].ToString();
                getindent.status = dr["status"].ToString();
                Indent.Add(getindent);
            }
            string response = GetJson(Indent);
            context.Response.Write(response);
        }
        catch
        {
        }
    }

    private void get_Indent_Sub_details_click(HttpContext context)
    {
        try
        {
            string PoRefNo = context.Request["refdcno"];
            vdm = new SalesDBManager();
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT indents.sno, indent_subtable.sno AS sub_ind_sno, indents.name, indents.i_date, indents.d_date, indents.remarks, indents.status, indents.branch_id,productmaster.productname, productmaster.sku, productmaster.productid, indent_subtable.qty, productmoniter.price, indent_subtable.indentno, sectionmaster.name AS sectionname, indents.sectionid FROM indents INNER JOIN indent_subtable ON indents.sno = indent_subtable.indentno INNER JOIN productmaster ON indent_subtable.productid = productmaster.productid INNER JOIN productmoniter ON productmoniter.productid=indent_subtable.productid INNER JOIN sectionmaster ON indents.sectionid = sectionmaster.sectionid WHERE (indents.sno = @PoRefNo) AND (indents.branch_id = @branchid) AND (productmoniter.branchid = @pbranchid)");
            cmd.Parameters.Add("@branchid", branchid);
            cmd.Parameters.Add("@PoRefNo", PoRefNo);
            cmd.Parameters.Add("@pbranchid", branchid);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(routes);
            DataTable dtindents = view.ToTable(true, "sno", "name", "i_date", "sectionname", "remarks",  "sectionid", "d_date", "status", "branch_id");
            DataTable dtsubindents = view.ToTable(true, "sno", "sub_ind_sno", "qty", "price",  "productname", "indentno", "productid", "sku");
            List<getIndentdata> indentdetails = new List<getIndentdata>();
            List<Indent> indent_lst = new List<Indent>();
            List<SubIndent> sub_indent_list = new List<SubIndent>();
            foreach (DataRow dr in dtindents.Rows)
            {
                Indent getApprovelindentdetails = new Indent();
                getApprovelindentdetails.sno = dr["sno"].ToString();
                getApprovelindentdetails.name = dr["name"].ToString();
                string i_date = dr["i_date"].ToString();
                DateTime dtPlantime = Convert.ToDateTime(i_date);
                string time = dtPlantime.ToString("dd/MM/yyyy HH:mm");
                string[] PlanDateTime = time.Split(' ');
                getApprovelindentdetails.idate = PlanDateTime[0];
                getApprovelindentdetails.itime = PlanDateTime[1]; ;
                getApprovelindentdetails.ddate = dr["d_date"].ToString();
                getApprovelindentdetails.sectionname = dr["sectionname"].ToString();
                getApprovelindentdetails.sectionid = dr["sectionid"].ToString();
                getApprovelindentdetails.status = dr["status"].ToString();
                getApprovelindentdetails.branchid = dr["branch_id"].ToString();
                getApprovelindentdetails.remarks = dr["remarks"].ToString();
                indent_lst.Add(getApprovelindentdetails);
            }
            foreach (DataRow dr in dtsubindents.Rows)
            {
                SubIndent getindent = new SubIndent();
                getindent.sno = dr["sub_ind_sno"].ToString();
                getindent.inword_refno = dr["sno"].ToString();
                getindent.qty = dr["qty"].ToString();
                getindent.price = dr["price"].ToString();
                getindent.hdnproductsno = dr["productid"].ToString();
                getindent.sku = dr["sku"].ToString();
                getindent.inword_refno = dr["indentno"].ToString();
                getindent.productname = dr["productname"].ToString();
                sub_indent_list.Add(getindent);
            }
            getIndentdata getIndentdates = new getIndentdata();
            getIndentdates.Indent = indent_lst;
            getIndentdates.SubIndent = sub_indent_list;
            indentdetails.Add(getIndentdates);
            string response = GetJson(indentdetails);
            context.Response.Write(response);

        }
        catch
        {
        }
    }

    private void save_stock_reject_click(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            var js = new JavaScriptSerializer();
            var title1 = context.Request.Params[1];
            InwardDetails obj = js.Deserialize<InwardDetails>(title1);
            string inwaddate = obj.inwarddate;
            DateTime inwarddate = Convert.ToDateTime(inwaddate);
            string remarks = obj.remarks;
            string btnval = obj.btnval;
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string BranchID = context.Session["Po_BranchID"].ToString();
            string entryby = context.Session["Employ_Sno"].ToString();
            if (btnval == "Save")
            {
                cmd = new SqlCommand("insert into inwardrejectdetails(inwarddate,doe,remarks,branchid,entryby) values(@inwarddate,@doe,@remarks,@branchid,@entryby)");
                cmd.Parameters.Add("@inwarddate", inwarddate);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@remarks", remarks);
                cmd.Parameters.Add("@branchid", BranchID);
                cmd.Parameters.Add("@entryby", entryby);
                vdm.insert(cmd);
                cmd = new SqlCommand("select MAX(sno) as inward  from inwardrejectdetails");
                DataTable dtstocks = vdm.SelectQuery(cmd).Tables[0];
                string in_refno = dtstocks.Rows[0]["inward"].ToString();
                foreach (SubInward si in obj.fillitems)
                {
                    if (si.hdnproductsno != "0")
                    {
                        cmd = new SqlCommand("insert into sub_inwardreject(productid,qty,refno) values(@productid,@qty,@refno)");
                        cmd.Parameters.Add("@productid", si.hdnproductsno);
                        cmd.Parameters.Add("@qty", si.quantity);
                        cmd.Parameters.Add("@refno", in_refno);
                        vdm.insert(cmd);

                        //cmd = new SqlCommand("update productmoniter set qty=qty-@qty where productid=@productid and branchid=@branchid");
                        //cmd.Parameters.Add("@productid", si.hdnproductsno);
                        //cmd.Parameters.Add("@qty", si.quantity);
                        //cmd.Parameters.Add("@branchid", BranchID);
                        //vdm.Update(cmd);
                    }
                }
                string Response = GetJson("successfully inserted ");
                context.Response.Write(Response);
            }
        }
        catch
        {
        }
    }

    public class stockrepairdetails
    {
        public string name { get; set; }
        public string sno { get; set; }
        public string doe { get; set; }
        public string btnval { get; set; }
        public string expdate { get; set; }
        public string remarks { get; set; }
        public string txtsno { get; set; }
        public List<stockrepairsubdetails> fillstock { get; set; }
    }
    public class stockrepairsubdetails
    {
        public string productid { get; set; }
        public string productname { get; set; }
        public string quantity { get; set; }
        public string hdnproductsno { get; set; }
        public string stock_refno { get; set; }
        public string sku { get; set; }
        public string uim { get; set; }
        public string subsno { get; set; }
    }
    public class get_Stockrepair
    {
        public List<stockrepairdetails> stockrepairdetails { get; set; }
        public List<stockrepairsubdetails> stockrepairsubdetails { get; set; }
    }
    private void save_stock_repair_click(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            var js = new JavaScriptSerializer();
            var title1 = context.Request.Params[1];
            stockrepairdetails obj = js.Deserialize<stockrepairdetails>(title1);
            string name = obj.name;
            string sdate = obj.doe;
            string sno = obj.sno;
            DateTime doe = Convert.ToDateTime(sdate);
            string edate = obj.expdate;
            DateTime expdate = Convert.ToDateTime(edate);
            string remarks = obj.remarks;
            string btnval = obj.btnval;
            string branchid = context.Session["Po_BranchID"].ToString();
            if (btnval == "Save")
            {
                cmd = new SqlCommand("insert into stockrepairdetails(name,doe,expdate,remarks,branchid) values(@name,@doe,@expdate,@remarks,@branchid)");
                cmd.Parameters.Add("@name", name);
                cmd.Parameters.Add("@doe", doe);
                cmd.Parameters.Add("@expdate", expdate);
                cmd.Parameters.Add("@remarks", remarks);
                cmd.Parameters.Add("@branchid", branchid);
                vdm.insert(cmd);
                cmd = new SqlCommand("select MAX(sno) as stcokr  from stockrepairdetails");
                DataTable dtstocks = vdm.SelectQuery(cmd).Tables[0];
                string stock_refno = dtstocks.Rows[0]["stcokr"].ToString();
                foreach (stockrepairsubdetails si in obj.fillstock)
                {
                    if (si.hdnproductsno != "0")
                    {
                        cmd = new SqlCommand("insert into stockrepairsubdetails(productid,quantity,stock_refno) values(@productid,@quantity,@stock_refno)");
                        cmd.Parameters.Add("@productid", si.hdnproductsno);
                        cmd.Parameters.Add("@quantity", si.quantity);
                        cmd.Parameters.Add("@stock_refno", stock_refno);
                        vdm.insert(cmd);
                    }
                }
                string Response = GetJson("successfully inserted ");
                context.Response.Write(Response);
            }
            else
            {
                cmd = new SqlCommand("update stockrepairdetails set name=@name,doe=@doe,expdate=@expdate,remarks=@remarks where sno=@sno AND branchid=@branchid");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@name", name);
                cmd.Parameters.Add("@doe", doe);
                cmd.Parameters.Add("@expdate", expdate);
                cmd.Parameters.Add("@remarks", remarks);
                cmd.Parameters.Add("@sno", sno);
                vdm.Update(cmd);
                foreach (stockrepairsubdetails si in obj.fillstock)
                {
                    if (si.hdnproductsno != "0")
                    {
                        cmd = new SqlCommand("update stockrepairsubdetails set productid=@productid,quantity=@quantity where sno=@sno and stock_refno=@stockrefno");
                        cmd.Parameters.Add("@productid", si.hdnproductsno);
                        cmd.Parameters.Add("@quantity", si.quantity);
                        cmd.Parameters.Add("@sno", si.subsno);
                        cmd.Parameters.Add("@stockrefno", sno);
                        if (vdm.Update(cmd) == 0)
                        {
                            cmd = new SqlCommand("insert into stockrepairsubdetails(productid,quantity,stock_refno)values(@hdnproductsno,@quantity,@sno)");
                            cmd.Parameters.Add("@productid", si.hdnproductsno);
                            cmd.Parameters.Add("@quantity", si.quantity);
                            cmd.Parameters.Add("@sno", si.stock_refno);
                            vdm.insert(cmd);
                        }
                    }
                }
                string Response = GetJson("successfully updated");
                context.Response.Write(Response);
            }
        }
        catch
        {

        }
    }

    private void get_Stock_Repair_details(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT stockrepairsubdetails.sno as subsno, stockrepairdetails.sno,stockrepairdetails.name, stockrepairdetails.doe, stockrepairdetails.expdate, stockrepairdetails.remarks,stockrepairsubdetails.stock_refno,  productmaster.productname, productmaster.productid,stockrepairsubdetails.quantity FROM stockrepairdetails INNER JOIN stockrepairsubdetails ON stockrepairdetails.sno = stockrepairsubdetails.stock_refno INNER JOIN productmaster ON stockrepairsubdetails.productid= productmaster.productid where (stockrepairdetails.doe between @d1 and @d2) AND stockrepairdetails.branchid=@branchid");
            cmd.Parameters.Add("@d1", GetLowDate(ServerDateCurrentdate).AddDays(-5));
            cmd.Parameters.Add("@d2", GetHighDate(ServerDateCurrentdate));
            cmd.Parameters.Add("@branchid", branchid);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(routes);
            DataTable dtstock = view.ToTable(true, "sno", "name", "doe", "expdate", "remarks");
            DataTable dtstock_subdetail = view.ToTable(true, "productname", "productid", "quantity", "subsno", "stock_refno");
            List<get_Stockrepair> stockrepairdetail = new List<get_Stockrepair>();
            List<stockrepairdetails> stockRepair_lst = new List<stockrepairdetails>();
            List<stockrepairsubdetails> sub_Stock_Repair_list = new List<stockrepairsubdetails>();
            foreach (DataRow dr in dtstock.Rows)
            {
                stockrepairdetails getstockdetails = new stockrepairdetails();
                getstockdetails.sno = dr["sno"].ToString();
                getstockdetails.name = dr["name"].ToString();
                getstockdetails.doe = ((DateTime)dr["doe"]).ToString("dd-MM-yyyy"); //dr["doe"].ToString();
                getstockdetails.expdate = ((DateTime)dr["expdate"]).ToString("dd-MM-yyyy"); //doedr["expdate"].ToString();
                getstockdetails.remarks = dr["remarks"].ToString();
                stockRepair_lst.Add(getstockdetails);
            }
            foreach (DataRow dr in dtstock_subdetail.Rows)
            {
                stockrepairsubdetails gestocks = new stockrepairsubdetails();
                gestocks.hdnproductsno = dr["productid"].ToString();
                gestocks.productname = dr["productname"].ToString();
                gestocks.quantity = dr["quantity"].ToString();
                gestocks.stock_refno = dr["stock_refno"].ToString();
                gestocks.subsno = dr["subsno"].ToString();
                sub_Stock_Repair_list.Add(gestocks);
            }
            get_Stockrepair get_Stocksrepairs = new get_Stockrepair();
            get_Stocksrepairs.stockrepairdetails = stockRepair_lst;
            get_Stocksrepairs.stockrepairsubdetails = sub_Stock_Repair_list;
            stockrepairdetail.Add(get_Stocksrepairs);
            string response = GetJson(stockrepairdetail);
            context.Response.Write(response);
        }
        catch
        {
        }
    }

    private void get_Sub_Stock_Repair_Report(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string branchid = context.Session["Po_BranchID"].ToString();
            string refno = context.Request["refno"].ToString();
            cmd = new SqlCommand("SELECT  stockrepairdetails.sno,uimmaster.uim, stockrepairdetails.name, stockrepairdetails.doe, stockrepairdetails.expdate, stockrepairdetails.remarks, stockrepairsubdetails.stock_refno,  productmaster.productname, productmaster.productid, stockrepairsubdetails.quantity, productmaster.sku FROM  stockrepairdetails INNER JOIN stockrepairsubdetails ON stockrepairdetails.sno = stockrepairsubdetails.stock_refno INNER JOIN productmaster ON stockrepairsubdetails.productid = productmaster.productid INNER JOIN uimmaster ON productmaster.uim = uimmaster.sno WHERE  (stockrepairdetails.sno =@sno) AND (stockrepairdetails.branchid = @branchid)");
            cmd.Parameters.Add("@sno", refno);
            cmd.Parameters.Add("@branchid", branchid);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(routes);
            DataTable dtstock = view.ToTable(true, "sno", "name", "doe", "expdate", "remarks");
            DataTable dtstock_subdetail = view.ToTable(true, "productname", "productid", "quantity", "sno", "stock_refno", "uim", "sku");
            List<get_Stockrepair> stockrepairdetail = new List<get_Stockrepair>();
            List<stockrepairdetails> stockRepair_lst = new List<stockrepairdetails>();
            List<stockrepairsubdetails> sub_Stock_Repair_list = new List<stockrepairsubdetails>();
            foreach (DataRow dr in dtstock.Rows)
            {
                stockrepairdetails getstockdetails = new stockrepairdetails();
                getstockdetails.sno = dr["sno"].ToString();
                getstockdetails.name = dr["name"].ToString();
                getstockdetails.doe = ((DateTime)dr["doe"]).ToString("dd-MM-yyyy"); //dr["doe"].ToString();
                getstockdetails.expdate = ((DateTime)dr["expdate"]).ToString("dd-MM-yyyy"); //doedr["expdate"].ToString();
                getstockdetails.remarks = dr["remarks"].ToString();
                stockRepair_lst.Add(getstockdetails);
            }
            foreach (DataRow dr in dtstock_subdetail.Rows)
            {
                stockrepairsubdetails gestocks = new stockrepairsubdetails();
                gestocks.hdnproductsno = dr["productid"].ToString();
                gestocks.productname = dr["productname"].ToString();
                gestocks.quantity = dr["quantity"].ToString();
                gestocks.stock_refno = dr["stock_refno"].ToString();
                gestocks.sku = dr["sku"].ToString();
                gestocks.uim = dr["uim"].ToString();
                gestocks.subsno = dr["sno"].ToString();
                sub_Stock_Repair_list.Add(gestocks);
            }
            get_Stockrepair get_Stocksrepairs = new get_Stockrepair();
            get_Stocksrepairs.stockrepairdetails = stockRepair_lst;
            get_Stocksrepairs.stockrepairsubdetails = sub_Stock_Repair_list;
            stockrepairdetail.Add(get_Stocksrepairs);
            string response = GetJson(stockrepairdetail);
            context.Response.Write(response);
        }
        catch
        {
        }
    }

    public class stocktransferdetails
    {
        public string frombranch { get; set; }
        public string tobranch { get; set; }
        public string fromstate { get; set; }
        public string tostate { get; set; }
        public string fromstate_sno { get; set; }
        public string tostate_sno { get; set; }
        public string frombranch_gstin { get; set; }
        public string tobranch_gstin { get; set; }
        public string frombranch_address { get; set; }
        public string tobranch_address { get; set; }
        public string barnchname { get; set; }
        public string transportname { get; set; }
        public string vehicleno { get; set; }
        public string invoicedate { get; set; }
        public string invoicetype { get; set; }
        public string salesinvoicetype { get; set; }
        public string invoiceno { get; set; }
        public string mrnno { get; set; }
        public string bname { get; set; }
        public string sno { get; set; }
        public string stock_sno { get; set; }
        public string status { get; set; }
        public string btnval { get; set; }
        public string doe { get; set; }
        public string remarks { get; set; }
        public string TinNo { get; set; }
        public string Address { get; set; }
        public string State { get; set; }
        public string hdnproductsno { get; set; }
        public string frombranch_statecode { get; set; }
        public string tobranch_statecode { get; set; }
        public string tobranch_type { get; set; }
        public string session_gstin { get; set; }
        public string freight { get; set; }
        public string frombranchname { get; set; }
        public string frombranchcode { get; set; }
        public List<stocktransfersubdetails> filldetails { get; set; }
    }
    public class stocktransfersubdetails
    {
        public string uim { get; set; }
        public string itemcode { get; set; }
        public string productid { get; set; }
        public string productname { get; set; }
        public string quantity { get; set; }
        public string taxtype { get; set; }
        public string taxvalue { get; set; }
        public string freigtamt { get; set; }
        public string invoicedate { get; set; }
        public string invoiceno { get; set; }
        public string invoicetype { get; set; }
        public string price { get; set; }
        public string tax { get; set; }
        public string hdnproductsno { get; set; }
        public string stock_refno { get; set; }
        public string stockrefno { get; set; }
        public string moniterqty { get; set; }
        public string sgst_per { get; set; }
        public string cgst_per { get; set; }
        public string igst_per { get; set; }
        public string hsncode { get; set; }
        public string sno { get; set; }
        public string gst_exists { get; set; }
    }
    public class get_Stock
    {
        public List<stocktransferdetails> stocktransferdetails { get; set; }
        public List<stocktransfersubdetails> stocktransfersubdetails { get; set; }
    }

    private void save_stock_transfer_click(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            vdsm = new DBManagerSales();
            var js = new JavaScriptSerializer();
            var title1 = context.Request.Params[1];
            stocktransferdetails obj = js.Deserialize<stocktransferdetails>(title1);
            string entryby = context.Session["Employ_Sno"].ToString();
            string branchid = context.Session["Po_BranchID"].ToString();
            string branch_id = context.Session["Po_BranchID"].ToString();
            string tobranch = obj.tobranch;
            string transportname = obj.transportname;
            string vehicleno = obj.vehicleno;
            string invoiceno = obj.invoiceno;
            string invdate = obj.invoicedate;
            DateTime invoiate = Convert.ToDateTime(invdate);
            string invoicedate = invoiate.ToString("MM-dd-yyyy");
            string sno = obj.sno;
            string status = obj.status;
            string remarks = obj.remarks;
            string invoicetype = obj.invoicetype;
            string salesinvoicetype = obj.salesinvoicetype;
            string freight = obj.freight;
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string dcdate = ServerDateCurrentdate.ToString("MM/dd/yyyy");
            /// Note : ModuleId=1 for Sales
            ///        ModuleId=2 for Purchase and stores
            ///        ModuleId=3 for Production
            ///        
            ///  company codes SVDS=1
            ///                SVD=2
            ///                SVF=3
            /// </summary>
            /// <param name="sender"></param>
            /// <param name="e"></param>
            string moduleid = "2";
            string companycode = "";
            string statecode = "";
            string tobranchstatecode = "";
            string tobranchcmpcode = "";
            string gstinno = "";
            string whcode = "";
            cmd = new SqlCommand("SELECT  branchmaster.branchid, branchmaster.branchname, branchmaster.GSTIN as gstinnumber, branchmaster.statename, statemaster.gststatecode, statemaster.statename AS gststatename, branchmaster.companycode,branchmaster.whcode FROM   branchmaster INNER JOIN statemaster ON branchmaster.statename = statemaster.sno WHERE (branchmaster.branchid = @tobranchid)");
            cmd.Parameters.Add("@tobranchid", tobranch);
            DataTable dttobranchcodes = vdm.SelectQuery(cmd).Tables[0];
            if (dttobranchcodes.Rows.Count > 0)
            {
                tobranchcmpcode = dttobranchcodes.Rows[0]["companycode"].ToString();
                tobranchstatecode = dttobranchcodes.Rows[0]["gststatecode"].ToString();
            }
            cmd = new SqlCommand("SELECT  branchmaster.branchid, branchmaster.branchname, branchmaster.GSTIN as gstinnumber, branchmaster.statename, statemaster.gststatecode, statemaster.statename AS gststatename, branchmaster.companycode,branchmaster.whcode FROM   branchmaster INNER JOIN statemaster ON branchmaster.statename = statemaster.sno WHERE (branchmaster.branchid = @branchid)");
            cmd.Parameters.Add("@branchid", branchid);
            DataTable dtcodes = vdm.SelectQuery(cmd).Tables[0];
            if (dtcodes.Rows.Count > 0)
            {
                companycode = dtcodes.Rows[0]["companycode"].ToString();
                gstinno = dtcodes.Rows[0]["gstinnumber"].ToString();
                statecode = dtcodes.Rows[0]["gststatecode"].ToString();
                statecode = dtcodes.Rows[0]["gststatecode"].ToString();
                whcode = dtcodes.Rows[0]["whcode"].ToString();
                
            }
            string btnval = obj.btnval;
            if (btnval == "Save")
            {
                cmd = new SqlCommand("SELECT  doe FROM producttransactions WHERE (doe = @d1) GROUP BY doe");
                cmd.Parameters.Add("@d1", invoicedate);
                cmd.Parameters.Add("@d2", invoicedate);
                DataTable dtproducttransaction = vdm.SelectQuery(cmd).Tables[0];
                if (dtproducttransaction.Rows.Count == 0)
                {
                    DateTime dtapril = new DateTime();
                    DateTime dtmarch = new DateTime();
                    int currentyear = ServerDateCurrentdate.Year;
                    int nextyear = ServerDateCurrentdate.Year + 1;
                    if (ServerDateCurrentdate.Month > 3)
                    {
                        string apr = "4/1/" + currentyear;
                        dtapril = DateTime.Parse(apr);
                        string march = "3/31/" + nextyear;
                        dtmarch = DateTime.Parse(march);
                    }
                    if (ServerDateCurrentdate.Month <= 3)
                    {
                        string apr = "4/1/" + (currentyear - 1);
                        dtapril = DateTime.Parse(apr);
                        string march = "3/31/" + (nextyear - 1);
                        dtmarch = DateTime.Parse(march);
                    }
                    string salesinvoiceno = "";
                    string salesstno = "";
                    string transtype = "";
                    cmd = new SqlCommand("SELECT { fn IFNULL(MAX(stock_sno), 0) } + 1 AS stock_sno FROM  stocktransferdetails WHERE (branch_id = @branch_id) AND  (doe between @d1 and @d2)");
                    cmd.Parameters.Add("@branch_id", branchid);
                    cmd.Parameters.Add("@d1", GetLowDate(dtapril));
                    cmd.Parameters.Add("@d2", GetHighDate(dtmarch));
                    DataTable dtstocksno = vdm.SelectQuery(cmd).Tables[0];
                    string stock_sno = dtstocksno.Rows[0]["stock_sno"].ToString();
                    mycmd = new MySqlCommand("SELECT  sno, whcode, companycode FROM branchdata WHERE (whcode = @whcode)");
                    mycmd.Parameters.Add("@whcode", whcode);
                    DataTable dtbranchwhcode = vdsm.SelectQuery(mycmd).Tables[0];
                    string so_branchid = dtbranchwhcode.Rows[0]["sno"].ToString();
                    if (tobranchstatecode == statecode)
                    {
                        if (tobranchcmpcode == companycode)
                        {
                            //stocktransfor number taken from sales 
                            mycmd = new MySqlCommand("SELECT IFNULL(MAX(agentstno), 0) + 1 AS stno FROM  agentst WHERE (soid = @soid) AND (IndDate BETWEEN @d1 AND @d2)");
                            mycmd.Parameters.Add("@soid", so_branchid);
                            mycmd.Parameters.Add("@d1", GetLowDate(dtapril));
                            mycmd.Parameters.Add("@d2", GetHighDate(dtmarch));
                            DataTable dtstno = vdsm.SelectQuery(mycmd).Tables[0];
                            salesstno = dtstno.Rows[0]["stno"].ToString();
                            transtype = "1"; // stock transfor
                            mycmd = new MySqlCommand("insert into  agentst(BranchID,IndDate,agentstno,stateid,companycode,moduleid,doe,soid) values(@BranchID,@IndDate,@agentstno,@stateid,@companycode,@moduleid,@doe,@soid) ");
                            mycmd.Parameters.Add("@BranchID", branchid);
                            mycmd.Parameters.Add("@IndDate", ServerDateCurrentdate);  //server date
                            mycmd.Parameters.Add("@doe", ServerDateCurrentdate);  //server date
                            mycmd.Parameters.Add("@agentstno", salesstno);    //sales stock transfor no
                            mycmd.Parameters.Add("@stateid", statecode);
                            mycmd.Parameters.Add("@companycode", companycode);
                            mycmd.Parameters.Add("@moduleid", moduleid);
                            mycmd.Parameters.Add("@soid", so_branchid);
                            vdsm.insert(mycmd);
                        }
                        else
                        {
                            //dc number taken from sales 

                            if (salesinvoicetype == "NonTaxable")
                            {
                                mycmd = new MySqlCommand("SELECT IFNULL(MAX(agentdcno), 0) + 1 AS dcno FROM  agentdc WHERE (soid = @soid) AND (IndDate BETWEEN @d1 AND @d2)");
                                mycmd.Parameters.Add("@soid", so_branchid);
                                mycmd.Parameters.Add("@d1", GetLowDate(dtapril));
                                mycmd.Parameters.Add("@d2", GetHighDate(dtmarch));
                                DataTable dtdcno = vdsm.SelectQuery(mycmd).Tables[0];
                                salesinvoiceno = dtdcno.Rows[0]["dcno"].ToString();
                                transtype = "0"; // invoice
                                mycmd = new MySqlCommand("insert into  agentdc(BranchID,IndDate,agentdcno,soid,stateid,companycode,moduleid,doe) values(@BranchID,@IndDate,@agentdcno,@soid,@stateid,@companycode,@moduleid,@doe) ");
                                mycmd.Parameters.Add("@BranchID", branchid);
                                mycmd.Parameters.Add("@IndDate", ServerDateCurrentdate);  //server date
                                mycmd.Parameters.Add("@doe", ServerDateCurrentdate);  //server date
                                mycmd.Parameters.Add("@agentdcno", salesinvoiceno);    //sales dc no
                                mycmd.Parameters.Add("@soid", so_branchid);
                                mycmd.Parameters.Add("@stateid", statecode);
                                mycmd.Parameters.Add("@companycode", companycode);
                                mycmd.Parameters.Add("@moduleid", moduleid);
                                vdsm.insert(mycmd);
                            }
                            else
                            {
                                mycmd = new MySqlCommand("SELECT IFNULL(MAX(agentdcno), 0) + 1 AS dcno FROM  agenttaxdc WHERE (soid = @soid) AND (IndDate BETWEEN @d1 AND @d2)");
                                mycmd.Parameters.Add("@soid", so_branchid);
                                mycmd.Parameters.Add("@d1", GetLowDate(dtapril));
                                mycmd.Parameters.Add("@d2", GetHighDate(dtmarch));
                                DataTable dtdcno = vdsm.SelectQuery(mycmd).Tables[0];
                                salesinvoiceno = dtdcno.Rows[0]["dcno"].ToString();
                                transtype = "0"; // invoice
                                mycmd = new MySqlCommand("insert into  agenttaxdc(BranchID,IndDate,agentdcno,soid,stateid,companycode,moduleid,doe) values(@BranchID,@IndDate,@agentdcno,@soid,@stateid,@companycode,@moduleid,@doe) ");
                                mycmd.Parameters.Add("@BranchID", branchid);
                                mycmd.Parameters.Add("@IndDate", ServerDateCurrentdate);  //server date
                                mycmd.Parameters.Add("@doe", ServerDateCurrentdate);  //server date
                                mycmd.Parameters.Add("@agentdcno", salesinvoiceno);    //sales dc no
                                mycmd.Parameters.Add("@soid", so_branchid);
                                mycmd.Parameters.Add("@stateid", statecode);
                                mycmd.Parameters.Add("@companycode", companycode);
                                mycmd.Parameters.Add("@moduleid", moduleid);
                                vdsm.insert(mycmd);
                            }
                        }
                    }
                    else
                    {
                        if (salesinvoicetype == "NonTaxable")
                        {
                            //dc number taken from sales 
                            mycmd = new MySqlCommand("SELECT IFNULL(MAX(agentdcno), 0) + 1 AS dcno FROM  agentdc WHERE (soid = @soid) AND (IndDate BETWEEN @d1 AND @d2)");
                            mycmd.Parameters.Add("@soid", so_branchid);
                            mycmd.Parameters.Add("@d1", GetLowDate(dtapril));
                            mycmd.Parameters.Add("@d2", GetHighDate(dtmarch));
                            DataTable dtdcno = vdsm.SelectQuery(mycmd).Tables[0];
                            salesinvoiceno = dtdcno.Rows[0]["dcno"].ToString();
                            transtype = "0"; // invoice
                            mycmd = new MySqlCommand("insert into  agentdc(BranchID,IndDate,agentdcno,soid,stateid,companycode,moduleid,doe) values(@BranchID,@IndDate,@agentdcno,@soid,@stateid,@companycode,@moduleid,@doe) ");
                            mycmd.Parameters.Add("@BranchID", branchid);
                            mycmd.Parameters.Add("@IndDate", ServerDateCurrentdate);  //server date
                            mycmd.Parameters.Add("@doe", ServerDateCurrentdate);  //server date
                            mycmd.Parameters.Add("@agentdcno", salesinvoiceno);    //sales dc no
                            mycmd.Parameters.Add("@soid", so_branchid);
                            mycmd.Parameters.Add("@stateid", statecode);
                            mycmd.Parameters.Add("@companycode", companycode);
                            mycmd.Parameters.Add("@moduleid", moduleid);
                            vdsm.insert(mycmd);
                        }
                        else
                        {
                            //dc number taken from sales 
                            mycmd = new MySqlCommand("SELECT IFNULL(MAX(agentdcno), 0) + 1 AS dcno FROM  agenttaxdc WHERE (soid = @soid) AND (IndDate BETWEEN @d1 AND @d2)");
                            mycmd.Parameters.Add("@soid", so_branchid);
                            mycmd.Parameters.Add("@d1", GetLowDate(dtapril));
                            mycmd.Parameters.Add("@d2", GetHighDate(dtmarch));
                            DataTable dtdcno = vdsm.SelectQuery(mycmd).Tables[0];
                            salesinvoiceno = dtdcno.Rows[0]["dcno"].ToString();
                            transtype = "0"; // invoice
                            mycmd = new MySqlCommand("insert into  agenttaxdc(BranchID,IndDate,agentdcno,soid,stateid,companycode,moduleid,doe) values(@BranchID,@IndDate,@agentdcno,@soid,@stateid,@companycode,@moduleid,@doe) ");
                            mycmd.Parameters.Add("@BranchID", branchid);
                            mycmd.Parameters.Add("@IndDate", ServerDateCurrentdate);  //server date
                            mycmd.Parameters.Add("@doe", ServerDateCurrentdate);  //server date
                            mycmd.Parameters.Add("@agentdcno", salesinvoiceno);    //sales dc no
                            mycmd.Parameters.Add("@soid", so_branchid);
                            mycmd.Parameters.Add("@stateid", statecode);
                            mycmd.Parameters.Add("@companycode", companycode);
                            mycmd.Parameters.Add("@moduleid", moduleid);
                            vdsm.insert(mycmd);
                        }
                    }
                    //end
                    cmd = new SqlCommand("insert into stocktransferdetails(invoicetype,invoicedate,invoiceno,tobranch,branchid,entryby,doe,transportname,vehicleno,status,remarks,branch_id, stock_sno,freight,tobranchinwardstatus,salesinvoiceno,salesstno,transtype) values(@invoicetype,@invoicedate,@invoiceno,@frombranch,@branchid,@entryby,@doe,@transportname,@vehicleno,@status,@remarks,@branch_id,@stock_sno,@freight,'P',@salesinvoiceno,@salesstno,@transtype)");
                    cmd.Parameters.Add("@frombranch", tobranch);
                    cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                    cmd.Parameters.Add("@entryby", entryby);
                    cmd.Parameters.Add("@branchid", branchid);
                    cmd.Parameters.Add("@invoicetype", invoicetype);
                    cmd.Parameters.Add("@invoiceno", invoiceno);
                    cmd.Parameters.Add("@invoicedate", invoicedate);
                    cmd.Parameters.Add("@transportname", transportname);
                    cmd.Parameters.Add("@vehicleno", vehicleno);
                    cmd.Parameters.Add("@status", status);
                    cmd.Parameters.Add("@remarks", remarks);
                    cmd.Parameters.Add("@branch_id", branch_id);
                    cmd.Parameters.Add("@stock_sno", stock_sno);
                    cmd.Parameters.Add("@freight", freight);
                    cmd.Parameters.Add("@salesinvoiceno", salesinvoiceno);     //sales dc no
                    cmd.Parameters.Add("@salesstno", salesstno);     //sales dc no
                    cmd.Parameters.Add("@transtype", transtype);     //sales dc no
                    vdm.insert(cmd);
                    cmd = new SqlCommand("select MAX(sno) as stcok  from stocktransferdetails");
                    DataTable dtstock = vdm.SelectQuery(cmd).Tables[0];
                    string stock_refno = dtstock.Rows[0]["stcok"].ToString();
                    foreach (stocktransfersubdetails si in obj.filldetails)
                    {
                        if (si.hdnproductsno != "0")
                        {
                            if (si.sgst_per == null)
                            {
                                if (si.taxtype == null)
                                {
                                    cmd = new SqlCommand("insert into stocktransfersubdetails(productid,price,quantity,stock_refno) values(@productid,@price,@quantity,@stock_refno)");
                                    cmd.Parameters.Add("@productid", si.hdnproductsno);
                                    cmd.Parameters.Add("@price", si.price);
                                    cmd.Parameters.Add("@quantity", si.quantity);
                                    cmd.Parameters.Add("@stock_refno", stock_refno);
                                    vdm.insert(cmd);
                                }
                                else
                                {
                                    cmd = new SqlCommand("insert into stocktransfersubdetails(taxtype,taxvalue,productid,price,quantity,stock_refno) values(@taxtype,@taxvalue,@productid,@price,@quantity,@stock_refno)");
                                    cmd.Parameters.Add("@taxtype", si.taxtype);
                                    cmd.Parameters.Add("@taxvalue", si.taxvalue);
                                    cmd.Parameters.Add("@productid", si.hdnproductsno);
                                    cmd.Parameters.Add("@price", si.price);
                                    cmd.Parameters.Add("@quantity", si.quantity);
                                    cmd.Parameters.Add("@stock_refno", stock_refno);
                                    vdm.insert(cmd);
                                }
                            }
                            else
                            {
                                cmd = new SqlCommand("insert into stocktransfersubdetails(productid,price,quantity,stock_refno,sgst,cgst,igst) values(@productid,@price,@quantity,@stock_refno,@sgst,@cgst,@igst)");
                                cmd.Parameters.Add("@productid", si.hdnproductsno);
                                cmd.Parameters.Add("@price", si.price);
                                cmd.Parameters.Add("@quantity", si.quantity);
                                cmd.Parameters.Add("@stock_refno", stock_refno);
                                cmd.Parameters.Add("@igst", si.igst_per);
                                cmd.Parameters.Add("@cgst", si.cgst_per);
                                cmd.Parameters.Add("@sgst", si.sgst_per);
                                vdm.insert(cmd);
                            }
                        }
                    }
                    string msg = stock_refno + "  successfully inserted";
                    string Response = GetJson(msg);
                    context.Response.Write(Response);
                }
                else
                {
                    string Response = GetJson("You Dont Have Permission This Date");
                    context.Response.Write(Response);
                }
            }
            else
            {
                cmd = new SqlCommand("SELECT  doe  FROM producttransactions where branchid=@branchid and doe=@invoicedate");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@invoicedate", invoicedate);
                DataTable produtransactiondoe = vdm.SelectQuery(cmd).Tables[0];
                if (produtransactiondoe.Rows.Count != 0)
                {
                    string Response = GetJson("You Dont Have Permission This Date");
                    context.Response.Write(Response);
                }
                else
                {
                    cmd = new SqlCommand("update stocktransferdetails set freight=@freight,invoicetype=@invoicetype,invoicedate=@invoicedate,invoiceno=@invoiceno, tobranch=@tobranch,doe=@doe,transportname=@transportname,vehicleno=@vehicleno,remarks=@remarks where sno=@sno AND branch_id=@branch_id");
                    cmd.Parameters.Add("@invoicetype", invoicetype);
                    cmd.Parameters.Add("@tobranch", tobranch);
                    cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                    cmd.Parameters.Add("@invoiceno", invoiceno);
                    cmd.Parameters.Add("@invoicedate", invoicedate);
                    cmd.Parameters.Add("@transportname", transportname);
                    cmd.Parameters.Add("@vehicleno", vehicleno);
                    cmd.Parameters.Add("@sno", sno);
                    cmd.Parameters.Add("@remarks", remarks);
                    cmd.Parameters.Add("@branch_id", branch_id);
                    cmd.Parameters.Add("@freight", freight);
                    vdm.Update(cmd);
                    foreach (stocktransfersubdetails si in obj.filldetails)
                    {
                        if (si.hdnproductsno != "0")
                        {

                            cmd = new SqlCommand("select * from stocktransfersubdetails where  productid=@productid and sno=@sno");
                            cmd.Parameters.Add("@productid", si.hdnproductsno);
                            cmd.Parameters.Add("@sno", si.stockrefno);
                            DataTable dtprev = vdm.SelectQuery(cmd).Tables[0];
                            float prevqty = 0;
                            if (dtprev.Rows.Count > 0)
                            {
                                string amount = dtprev.Rows[0]["quantity"].ToString();
                                float.TryParse(amount, out prevqty);
                            }
                            if (si.sgst_per == null)
                            {
                                if (si.taxtype == null)
                                {
                                    cmd = new SqlCommand("update stocktransfersubdetails set productid=@productid,quantity=@quantity where stock_refno=@storefsno and sno=@sno");
                                    cmd.Parameters.Add("@productid", si.hdnproductsno);
                                    cmd.Parameters.Add("@quantity", si.quantity);
                                    cmd.Parameters.Add("@storefsno", sno);
                                    cmd.Parameters.Add("@sno", si.stockrefno);
                                    if (vdm.Update(cmd) == 0)
                                    {
                                        cmd = new SqlCommand("insert into stocktransfersubdetails(taxtype,taxvalue,productid,price,quantity,stock_refno) values(@taxtype,@taxvalue,@productid,@price,@quantity,@stock_refno)");
                                        cmd.Parameters.Add("@taxtype", si.taxtype);
                                        cmd.Parameters.Add("@taxvalue", si.taxvalue);
                                        cmd.Parameters.Add("@productid", si.hdnproductsno);
                                        cmd.Parameters.Add("@price", si.price);
                                        cmd.Parameters.Add("@quantity", si.quantity);
                                        cmd.Parameters.Add("@stock_refno", sno);
                                        vdm.insert(cmd);
                                    }
                                }
                                else
                                {
                                    cmd = new SqlCommand("update stocktransfersubdetails set price=@rs,taxtype=@taxtype,taxvalue=@taxvalue,productid=@productid,quantity=@quantity,freigtamt=@freigtamt where stock_refno=@storefsno and sno=@sno");
                                    cmd.Parameters.Add("@taxtype", si.taxtype);
                                    cmd.Parameters.Add("@taxvalue", si.taxvalue);
                                    cmd.Parameters.Add("@productid", si.hdnproductsno);
                                    cmd.Parameters.Add("@quantity", si.quantity);
                                    cmd.Parameters.Add("@rs", si.price);
                                    cmd.Parameters.Add("@storefsno", sno);
                                    cmd.Parameters.Add("@sno", si.stockrefno);
                                    cmd.Parameters.Add("@freigtamt", si.freigtamt);
                                    if (vdm.Update(cmd) == 0)
                                    {
                                        cmd = new SqlCommand("insert into stocktransfersubdetails(taxtype,taxvalue,productid,price,quantity,stock_refno) values(@taxtype,@taxvalue,@productid,@price,@quantity,@stock_refno)");
                                        cmd.Parameters.Add("@taxtype", si.taxtype);
                                        cmd.Parameters.Add("@taxvalue", si.taxvalue);
                                        cmd.Parameters.Add("@productid", si.hdnproductsno);
                                        cmd.Parameters.Add("@price", si.price);
                                        cmd.Parameters.Add("@quantity", si.quantity);
                                        cmd.Parameters.Add("@stock_refno", sno);
                                        vdm.insert(cmd);
                                    }
                                }
                            }
                            else
                            {
                                cmd = new SqlCommand("update stocktransfersubdetails set price=@stprice, productid=@productid,quantity=@quantity,igst=@igst,cgst=@cgst,sgst=@sgst where stock_refno=@storefsno and sno=@sno");
                                cmd.Parameters.Add("@productid", si.hdnproductsno);
                                cmd.Parameters.Add("@quantity", si.quantity);
                                cmd.Parameters.Add("@igst", si.igst_per);
                                cmd.Parameters.Add("@cgst", si.cgst_per);
                                cmd.Parameters.Add("@sgst", si.sgst_per);
                                cmd.Parameters.Add("@stprice", si.price);
                                cmd.Parameters.Add("@storefsno", sno);
                                cmd.Parameters.Add("@sno", si.stockrefno);
                                if (vdm.Update(cmd) == 0)
                                {
                                    cmd = new SqlCommand("insert into stocktransfersubdetails(productid,price,quantity,stock_refno,sgst,cgst,igst) values(@productid,@price,@quantity,@stock_refno,@sgst,@cgst,@igst)");
                                    cmd.Parameters.Add("@productid", si.hdnproductsno);
                                    cmd.Parameters.Add("@price", si.price);
                                    cmd.Parameters.Add("@quantity", si.quantity);
                                    cmd.Parameters.Add("@igst", si.igst_per);
                                    cmd.Parameters.Add("@cgst", si.cgst_per);
                                    cmd.Parameters.Add("@sgst", si.sgst_per);
                                    cmd.Parameters.Add("@stock_refno", sno);
                                    vdm.insert(cmd);
                                }
                            }
                        }
                    }
                    string msg = sno + "Stock Transfer Number  successfully Updated";
                    string Response = GetJson(msg);
                    context.Response.Write(Response);
                }
            }
        }
        catch
        {

        }
    }

    private void get_StockTransfer_details(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string julydt = "07/01/2017";
            DateTime gst_dt = Convert.ToDateTime(julydt);
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT  branchmaster_1.statename as branchstate,stocktransferdetails.freight,stocktransfersubdetails.igst,stocktransfersubdetails.cgst,stocktransfersubdetails.sgst,productmoniter.qty AS moniterqty,stocktransferdetails.remarks,stocktransfersubdetails.taxtype,stocktransferdetails.invoiceno,stocktransferdetails.invoicedate,stocktransfersubdetails.price, stocktransfersubdetails.taxvalue,stocktransferdetails.invoicetype,stocktransferdetails.transportname,stocktransferdetails.vehicleno,stocktransfersubdetails.freigtamt,stocktransferdetails.sno as refno,stocktransfersubdetails.sno, branchmaster_1.branchname AS Expr1, productmaster.productname, productmaster.itemcode, stocktransferdetails.tobranch, stocktransfersubdetails.quantity, stocktransfersubdetails.productid, stocktransferdetails.doe,stocktransfersubdetails.stock_refno AS subrefno FROM  stocktransferdetails INNER JOIN stocktransfersubdetails ON stocktransferdetails.sno = stocktransfersubdetails.stock_refno INNER JOIN   branchmaster AS branchmaster_1 ON stocktransferdetails.tobranch = branchmaster_1.branchid INNER JOIN productmaster ON stocktransfersubdetails.productid = productmaster.productid INNER JOIN productmoniter ON productmoniter.productid= stocktransfersubdetails.productid WHERE (stocktransferdetails.invoicedate BETWEEN  @d1 AND  @d2) AND (stocktransferdetails.branch_id=@branchid) AND (productmoniter.branchid=@branchid) and stocktransferdetails.status='P' ORDER BY stocktransferdetails.invoicedate");
            cmd.Parameters.Add("@d1", GetLowDate(ServerDateCurrentdate).AddDays(-60));
            cmd.Parameters.Add("@d2", GetHighDate(ServerDateCurrentdate));
            cmd.Parameters.Add("@branchid", branchid);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(routes);
            DataTable dtstock = view.ToTable(true, "refno", "tobranch", "remarks", "branchstate", "freight", "invoicetype", "invoiceno", "invoicedate", "transportname", "vehicleno", "Expr1");
            DataTable dtstock_subdetails = view.ToTable(true, "sno", "moniterqty", "subrefno", "freigtamt", "taxtype", "taxvalue", "invoicedate", "price", "productid", "productname", "itemcode", "quantity", "igst", "cgst", "sgst");
            List<get_Stock> stockdetails = new List<get_Stock>();
            List<stocktransferdetails> stock_lst = new List<stocktransferdetails>();
            List<stocktransfersubdetails> Stocktransfer_sub_list = new List<stocktransfersubdetails>();
            foreach (DataRow dr in dtstock.Rows)
            {
                stocktransferdetails getstockdetails = new stocktransferdetails();
                getstockdetails.tobranch = dr["tobranch"].ToString();
                getstockdetails.tostate = dr["branchstate"].ToString();
                getstockdetails.invoicetype = dr["invoicetype"].ToString();
                getstockdetails.transportname = dr["transportname"].ToString();
                getstockdetails.invoiceno = dr["invoiceno"].ToString();
                getstockdetails.invoicedate = ((DateTime)dr["invoicedate"]).ToString("dd-MM-yyyy"); //dr["podate"].ToString();
                getstockdetails.vehicleno = dr["vehicleno"].ToString();
                getstockdetails.remarks = dr["remarks"].ToString();
                getstockdetails.bname = dr["Expr1"].ToString();
                getstockdetails.sno = dr["refno"].ToString();
                getstockdetails.freight = dr["freight"].ToString();
                stock_lst.Add(getstockdetails);
            }
            foreach (DataRow dr in dtstock_subdetails.Rows)
            {
                stocktransfersubdetails gestocks = new stocktransfersubdetails();
                //string invoicedate1 = "7/17/2017 12:00:00 AM";//((DateTime)dr["invoicedate"]).ToString();
                string invoicedate1 = ((DateTime)dr["invoicedate"]).ToString();
                DateTime invoicedate = Convert.ToDateTime(invoicedate1);
                if (invoicedate < gst_dt)
                {
                    gestocks.taxtype = dr["taxtype"].ToString();
                    gestocks.taxvalue = dr["taxvalue"].ToString();
                }
                else
                {
                    gestocks.sgst_per = dr["sgst"].ToString();
                    gestocks.cgst_per = dr["cgst"].ToString();
                    gestocks.igst_per = dr["igst"].ToString();
                }
                gestocks.sno = dr["subrefno"].ToString();
                gestocks.itemcode = dr["itemcode"].ToString();
                gestocks.hdnproductsno = dr["productid"].ToString();
                gestocks.productname = dr["productname"].ToString();
                gestocks.freigtamt = dr["freigtamt"].ToString();
                gestocks.price = dr["price"].ToString();
                gestocks.moniterqty = dr["moniterqty"].ToString();
                gestocks.quantity = dr["quantity"].ToString();
                gestocks.stockrefno = dr["sno"].ToString();
                Stocktransfer_sub_list.Add(gestocks);
            }
            get_Stock get_Stocks = new get_Stock();
            get_Stocks.stocktransferdetails = stock_lst;
            get_Stocks.stocktransfersubdetails = Stocktransfer_sub_list;
            stockdetails.Add(get_Stocks);
            string response = GetJson(stockdetails);
            context.Response.Write(response);
        }
        catch
        {
        }
    }


    private void save_debitvocher_click(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            vdsm = new DBManagerSales();
            var js = new JavaScriptSerializer();
            var title1 = context.Request.Params[1];
            stocktransferdetails obj = js.Deserialize<stocktransferdetails>(title1);
            string entryby = context.Session["Employ_Sno"].ToString();
            string branchid = context.Session["Po_BranchID"].ToString();
            string branch_id = context.Session["Po_BranchID"].ToString();
            string tobranch = obj.tobranch;
            string transportname = obj.transportname;
            string vehicleno = obj.vehicleno;
            string invoiceno = obj.invoiceno;
            string mrnno = obj.mrnno;
            string invdate = obj.invoicedate;
            DateTime invoiate = Convert.ToDateTime(invdate);
            string invoicedate = invoiate.ToString("MM-dd-yyyy");
            string sno = obj.sno;
            string status = obj.status;
            string remarks = obj.remarks;
            string invoicetype = obj.invoicetype;
            string freight = obj.freight;
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string dcdate = ServerDateCurrentdate.ToString("MM/dd/yyyy");
            /// Note : ModuleId=1 for Sales
            ///        ModuleId=2 for Purchase and stores
            ///        ModuleId=3 for Production
            ///        
            ///  company codes SVDS=1
            ///                SVD=2
            ///                SVF=3
            /// </summary>
            /// <param name="sender"></param>
            /// <param name="e"></param>
            string moduleid = "2";
            string companycode = "";
            string statecode = "";
            string tobranchstatecode = "";
            string tobranchcmpcode = "";
            string gstinno = "";
            string whcode = "";
            cmd = new SqlCommand("SELECT  branchmaster.branchid, branchmaster.branchname, branchmaster.GSTIN as gstinnumber, branchmaster.statename, statemaster.gststatecode, statemaster.statename AS gststatename, branchmaster.companycode,branchmaster.whcode FROM   branchmaster INNER JOIN statemaster ON branchmaster.statename = statemaster.sno WHERE (branchmaster.branchid = @tobranchid)");
            cmd.Parameters.Add("@tobranchid", tobranch);
            DataTable dttobranchcodes = vdm.SelectQuery(cmd).Tables[0];
            if (dttobranchcodes.Rows.Count > 0)
            {
                tobranchcmpcode = dttobranchcodes.Rows[0]["companycode"].ToString();
                tobranchstatecode = dttobranchcodes.Rows[0]["gststatecode"].ToString();
            }
            cmd = new SqlCommand("SELECT  branchmaster.branchid, branchmaster.branchname, branchmaster.GSTIN as gstinnumber, branchmaster.statename, statemaster.gststatecode, statemaster.statename AS gststatename, branchmaster.companycode,branchmaster.whcode FROM   branchmaster INNER JOIN statemaster ON branchmaster.statename = statemaster.sno WHERE (branchmaster.branchid = @branchid)");
            cmd.Parameters.Add("@branchid", branchid);
            DataTable dtcodes = vdm.SelectQuery(cmd).Tables[0];
            if (dtcodes.Rows.Count > 0)
            {
                companycode = dtcodes.Rows[0]["companycode"].ToString();
                gstinno = dtcodes.Rows[0]["gstinnumber"].ToString();
                statecode = dtcodes.Rows[0]["gststatecode"].ToString();
                statecode = dtcodes.Rows[0]["gststatecode"].ToString();
                whcode = dtcodes.Rows[0]["whcode"].ToString();

            }
            string btnval = obj.btnval;
            if (btnval == "Save")
            {
                cmd = new SqlCommand("SELECT  doe FROM producttransactions WHERE (doe = @d1) GROUP BY doe");
                cmd.Parameters.Add("@d1", invoicedate);
                cmd.Parameters.Add("@d2", invoicedate);
                DataTable dtproducttransaction = vdm.SelectQuery(cmd).Tables[0];
                if (dtproducttransaction.Rows.Count == 0)
                {
                    DateTime dtapril = new DateTime();
                    DateTime dtmarch = new DateTime();
                    int currentyear = ServerDateCurrentdate.Year;
                    int nextyear = ServerDateCurrentdate.Year + 1;
                    if (ServerDateCurrentdate.Month > 3)
                    {
                        string apr = "4/1/" + currentyear;
                        dtapril = DateTime.Parse(apr);
                        string march = "3/31/" + nextyear;
                        dtmarch = DateTime.Parse(march);
                    }
                    if (ServerDateCurrentdate.Month <= 3)
                    {
                        string apr = "4/1/" + (currentyear - 1);
                        dtapril = DateTime.Parse(apr);
                        string march = "3/31/" + (nextyear - 1);
                        dtmarch = DateTime.Parse(march);
                    }
                    string salesinvoiceno = "";
                    string salesstno = "";
                    string transtype = "";
                    cmd = new SqlCommand("SELECT { fn IFNULL(MAX(stock_sno), 0) } + 1 AS stock_sno FROM  debitvocherdetails WHERE (branch_id = @branch_id) AND  (doe between @d1 and @d2)");
                    cmd.Parameters.Add("@branch_id", branchid);
                    cmd.Parameters.Add("@d1", GetLowDate(dtapril));
                    cmd.Parameters.Add("@d2", GetHighDate(dtmarch));
                    DataTable dtstocksno = vdm.SelectQuery(cmd).Tables[0];
                    string stock_sno = dtstocksno.Rows[0]["stock_sno"].ToString();
                    mycmd = new MySqlCommand("SELECT  sno, whcode, companycode FROM branchdata WHERE (whcode = @whcode)");
                    mycmd.Parameters.Add("@whcode", whcode);
                    DataTable dtbranchwhcode = vdsm.SelectQuery(mycmd).Tables[0];
                    string so_branchid = dtbranchwhcode.Rows[0]["sno"].ToString();
                    if (tobranchstatecode == statecode)
                    {
                        if (tobranchcmpcode == companycode)
                        {
                            //stocktransfor number taken from sales 
                            mycmd = new MySqlCommand("SELECT IFNULL(MAX(agentstno), 0) + 1 AS stno FROM  agentst WHERE (soid = @soid) AND (IndDate BETWEEN @d1 AND @d2)");
                            mycmd.Parameters.Add("@soid", so_branchid);
                            mycmd.Parameters.Add("@d1", GetLowDate(dtapril));
                            mycmd.Parameters.Add("@d2", GetHighDate(dtmarch));
                            DataTable dtstno = vdsm.SelectQuery(mycmd).Tables[0];
                            salesstno = dtstno.Rows[0]["stno"].ToString();
                            transtype = "1"; // stock transfor
                            //mycmd = new MySqlCommand("insert into  agentst(BranchID,IndDate,agentstno,stateid,companycode,moduleid,doe,soid) values(@BranchID,@IndDate,@agentstno,@stateid,@companycode,@moduleid,@doe,@soid) ");
                            //mycmd.Parameters.Add("@BranchID", branchid);
                            //mycmd.Parameters.Add("@IndDate", ServerDateCurrentdate);  //server date
                            //mycmd.Parameters.Add("@doe", ServerDateCurrentdate);  //server date
                            //mycmd.Parameters.Add("@agentstno", salesstno);    //sales stock transfor no
                            //mycmd.Parameters.Add("@stateid", statecode);
                            //mycmd.Parameters.Add("@companycode", companycode);
                            //mycmd.Parameters.Add("@moduleid", moduleid);
                            //mycmd.Parameters.Add("@soid", so_branchid);
                            //vdsm.insert(mycmd);
                        }
                        else
                        {
                            //dc number taken from sales 
                            //mycmd = new MySqlCommand("SELECT IFNULL(MAX(agentdcno), 0) + 1 AS dcno FROM  agentdc WHERE (soid = @soid) AND (IndDate BETWEEN @d1 AND @d2)");
                            //mycmd.Parameters.Add("@soid", so_branchid);
                            //mycmd.Parameters.Add("@d1", GetLowDate(dtapril));
                            //mycmd.Parameters.Add("@d2", GetHighDate(dtmarch));
                            //DataTable dtdcno = vdsm.SelectQuery(mycmd).Tables[0];
                            //salesinvoiceno = dtdcno.Rows[0]["dcno"].ToString();
                            //transtype = "0"; // invoice
                            //mycmd = new MySqlCommand("insert into  agentdc(BranchID,IndDate,agentdcno,soid,stateid,companycode,moduleid,doe) values(@BranchID,@IndDate,@agentdcno,@soid,@stateid,@companycode,@moduleid,@doe) ");
                            //mycmd.Parameters.Add("@BranchID", branchid);
                            //mycmd.Parameters.Add("@IndDate", ServerDateCurrentdate);  //server date
                            //mycmd.Parameters.Add("@doe", ServerDateCurrentdate);  //server date
                            //mycmd.Parameters.Add("@agentdcno", salesinvoiceno);    //sales dc no
                            //mycmd.Parameters.Add("@soid", so_branchid);
                            //mycmd.Parameters.Add("@stateid", statecode);
                            //mycmd.Parameters.Add("@companycode", companycode);
                            //mycmd.Parameters.Add("@moduleid", moduleid);
                            //vdsm.insert(mycmd);
                        }
                    }
                    else
                    {
                        //dc number taken from sales 
                        //mycmd = new MySqlCommand("SELECT IFNULL(MAX(agentdcno), 0) + 1 AS dcno FROM  agentdc WHERE (soid = @soid) AND (IndDate BETWEEN @d1 AND @d2)");
                        //mycmd.Parameters.Add("@soid", so_branchid);
                        //mycmd.Parameters.Add("@d1", GetLowDate(dtapril));
                        //mycmd.Parameters.Add("@d2", GetHighDate(dtmarch));
                        //DataTable dtdcno = vdsm.SelectQuery(mycmd).Tables[0];
                        //salesinvoiceno = dtdcno.Rows[0]["dcno"].ToString();
                        //transtype = "0"; // invoice
                        //mycmd = new MySqlCommand("insert into  agentdc(BranchID,IndDate,agentdcno,soid,stateid,companycode,moduleid,doe) values(@BranchID,@IndDate,@agentdcno,@soid,@stateid,@companycode,@moduleid,@doe) ");
                        //mycmd.Parameters.Add("@BranchID", branchid);
                        //mycmd.Parameters.Add("@IndDate", ServerDateCurrentdate);  //server date
                        //mycmd.Parameters.Add("@doe", ServerDateCurrentdate);  //server date
                        //mycmd.Parameters.Add("@agentdcno", salesinvoiceno);    //sales dc no
                        //mycmd.Parameters.Add("@soid", so_branchid);
                        //mycmd.Parameters.Add("@stateid", statecode);
                        //mycmd.Parameters.Add("@companycode", companycode);
                        //mycmd.Parameters.Add("@moduleid", moduleid);
                        //vdsm.insert(mycmd);
                    }
                    //end
                    cmd = new SqlCommand("insert into debitvocherdetails(invoicetype,invoicedate,invoiceno,tobranch,branchid,entryby,doe,transportname,vehicleno,status,remarks,branch_id, stock_sno,freight,tobranchinwardstatus,salesinvoiceno,salesstno,transtype) values(@invoicetype,@invoicedate,@invoiceno,@frombranch,@branchid,@entryby,@doe,@transportname,@vehicleno,@status,@remarks,@branch_id,@stock_sno,@freight,'P',@salesinvoiceno,@salesstno,@transtype)");
                    cmd.Parameters.Add("@frombranch", tobranch);
                    cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                    cmd.Parameters.Add("@entryby", entryby);
                    cmd.Parameters.Add("@branchid", branchid);
                    cmd.Parameters.Add("@invoicetype", invoicetype);
                    cmd.Parameters.Add("@invoiceno", invoiceno);
                    cmd.Parameters.Add("@invoicedate", invoicedate);
                    cmd.Parameters.Add("@transportname", transportname);
                    cmd.Parameters.Add("@vehicleno", vehicleno);
                    cmd.Parameters.Add("@status", status);
                    cmd.Parameters.Add("@remarks", remarks);
                    cmd.Parameters.Add("@branch_id", branch_id);
                    cmd.Parameters.Add("@stock_sno", stock_sno);
                    cmd.Parameters.Add("@freight", freight);
                    cmd.Parameters.Add("@salesinvoiceno", salesinvoiceno);     //sales dc no
                    cmd.Parameters.Add("@salesstno", salesstno);     //sales dc no
                    cmd.Parameters.Add("@transtype", transtype);     //sales dc no
                    vdm.insert(cmd);
                    cmd = new SqlCommand("select MAX(sno) as stcok  from debitvocherdetails");
                    DataTable dtstock = vdm.SelectQuery(cmd).Tables[0];
                    string stock_refno = dtstock.Rows[0]["stcok"].ToString();
                    foreach (stocktransfersubdetails si in obj.filldetails)
                    {
                        if (si.hdnproductsno != "0")
                        {
                            if (si.sgst_per == null)
                            {
                                if (si.taxtype == null)
                                {
                                    cmd = new SqlCommand("insert into debitvocherdsubdetails(productid,price,quantity,stock_refno) values(@productid,@price,@quantity,@stock_refno)");
                                    cmd.Parameters.Add("@productid", si.hdnproductsno);
                                    cmd.Parameters.Add("@price", si.price);
                                    cmd.Parameters.Add("@quantity", si.quantity);
                                    cmd.Parameters.Add("@stock_refno", stock_refno);
                                    vdm.insert(cmd);
                                }
                                else
                                {
                                    cmd = new SqlCommand("insert into debitvocherdsubdetails(taxtype,taxvalue,productid,price,quantity,stock_refno) values(@taxtype,@taxvalue,@productid,@price,@quantity,@stock_refno)");
                                    cmd.Parameters.Add("@taxtype", si.taxtype);
                                    cmd.Parameters.Add("@taxvalue", si.taxvalue);
                                    cmd.Parameters.Add("@productid", si.hdnproductsno);
                                    cmd.Parameters.Add("@price", si.price);
                                    cmd.Parameters.Add("@quantity", si.quantity);
                                    cmd.Parameters.Add("@stock_refno", stock_refno);
                                    vdm.insert(cmd);
                                }
                            }
                            else
                            {
                                cmd = new SqlCommand("insert into debitvocherdsubdetails(productid,price,quantity,stock_refno,sgst,cgst,igst) values(@productid,@price,@quantity,@stock_refno,@sgst,@cgst,@igst)");
                                cmd.Parameters.Add("@productid", si.hdnproductsno);
                                cmd.Parameters.Add("@price", si.price);
                                cmd.Parameters.Add("@quantity", si.quantity);
                                cmd.Parameters.Add("@stock_refno", stock_refno);
                                cmd.Parameters.Add("@igst", si.igst_per);
                                cmd.Parameters.Add("@cgst", si.cgst_per);
                                cmd.Parameters.Add("@sgst", si.sgst_per);
                                vdm.insert(cmd);
                            }
                        }
                    }
                    string msg = stock_refno + "  successfully inserted";
                    string Response = GetJson(msg);
                    context.Response.Write(Response);
                }
                else
                {
                    string Response = GetJson("You Dont Have Permission This Date");
                    context.Response.Write(Response);
                }
            }
            else
            {
               
              
            }
        }
        catch
        {

        }
    }

    private void get_debitvocher_details(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string julydt = "07/01/2017";
            DateTime gst_dt = Convert.ToDateTime(julydt);
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT  branchmaster_1.statename as branchstate,debitvocherdetails.freight,debitvocherdsubdetails.igst,debitvocherdsubdetails.cgst,debitvocherdsubdetails.sgst,productmoniter.qty AS moniterqty,debitvocherdetails.remarks,debitvocherdsubdetails.taxtype,debitvocherdetails.invoiceno,debitvocherdetails.invoicedate,debitvocherdsubdetails.price, debitvocherdsubdetails.taxvalue,debitvocherdetails.invoicetype,debitvocherdetails.transportname,debitvocherdetails.vehicleno,debitvocherdsubdetails.freigtamt,debitvocherdetails.sno as refno,debitvocherdsubdetails.sno, branchmaster_1.branchname AS Expr1, productmaster.productname, productmaster.itemcode, debitvocherdetails.tobranch, debitvocherdsubdetails.quantity, debitvocherdsubdetails.productid, debitvocherdetails.doe,debitvocherdsubdetails.stock_refno AS subrefno FROM  debitvocherdetails INNER JOIN debitvocherdsubdetails ON debitvocherdetails.sno = debitvocherdsubdetails.stock_refno INNER JOIN   branchmaster AS branchmaster_1 ON debitvocherdetails.tobranch = branchmaster_1.branchid INNER JOIN productmaster ON debitvocherdsubdetails.productid = productmaster.productid INNER JOIN productmoniter ON productmoniter.productid= debitvocherdsubdetails.productid WHERE (debitvocherdetails.invoicedate BETWEEN  @d1 AND  @d2) AND (debitvocherdetails.branch_id=@branchid) AND (productmoniter.branchid=@branchid) and debitvocherdetails.status='P' ORDER BY debitvocherdetails.invoicedate");
            cmd.Parameters.Add("@d1", GetLowDate(ServerDateCurrentdate).AddDays(-60));
            cmd.Parameters.Add("@d2", GetHighDate(ServerDateCurrentdate));
            cmd.Parameters.Add("@branchid", branchid);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(routes);
            DataTable dtstock = view.ToTable(true, "refno", "tobranch", "remarks", "branchstate", "freight", "invoicetype", "invoiceno", "invoicedate", "transportname", "vehicleno", "Expr1");
            DataTable dtstock_subdetails = view.ToTable(true, "sno", "moniterqty", "subrefno", "freigtamt", "taxtype", "taxvalue", "invoicedate", "price", "productid", "productname", "itemcode", "quantity", "igst", "cgst", "sgst");
            List<get_Stock> stockdetails = new List<get_Stock>();
            List<stocktransferdetails> stock_lst = new List<stocktransferdetails>();
            List<stocktransfersubdetails> Stocktransfer_sub_list = new List<stocktransfersubdetails>();
            foreach (DataRow dr in dtstock.Rows)
            {
                stocktransferdetails getstockdetails = new stocktransferdetails();
                getstockdetails.tobranch = dr["tobranch"].ToString();
                getstockdetails.tostate = dr["branchstate"].ToString();
                getstockdetails.invoicetype = dr["invoicetype"].ToString();
                getstockdetails.transportname = dr["transportname"].ToString();
                getstockdetails.invoiceno = dr["invoiceno"].ToString();
                getstockdetails.invoicedate = ((DateTime)dr["invoicedate"]).ToString("dd-MM-yyyy"); //dr["podate"].ToString();
                getstockdetails.vehicleno = dr["vehicleno"].ToString();
                getstockdetails.remarks = dr["remarks"].ToString();
                getstockdetails.bname = dr["Expr1"].ToString();
                getstockdetails.sno = dr["refno"].ToString();
                getstockdetails.freight = dr["freight"].ToString();
                stock_lst.Add(getstockdetails);
            }
            foreach (DataRow dr in dtstock_subdetails.Rows)
            {
                stocktransfersubdetails gestocks = new stocktransfersubdetails();
                //string invoicedate1 = "7/17/2017 12:00:00 AM";//((DateTime)dr["invoicedate"]).ToString();
                string invoicedate1 = ((DateTime)dr["invoicedate"]).ToString();
                DateTime invoicedate = Convert.ToDateTime(invoicedate1);
                if (invoicedate < gst_dt)
                {
                    gestocks.taxtype = dr["taxtype"].ToString();
                    gestocks.taxvalue = dr["taxvalue"].ToString();
                }
                else
                {
                    gestocks.sgst_per = dr["sgst"].ToString();
                    gestocks.cgst_per = dr["cgst"].ToString();
                    gestocks.igst_per = dr["igst"].ToString();
                }
                gestocks.sno = dr["subrefno"].ToString();
                gestocks.itemcode = dr["itemcode"].ToString();
                gestocks.hdnproductsno = dr["productid"].ToString();
                gestocks.productname = dr["productname"].ToString();
                gestocks.freigtamt = dr["freigtamt"].ToString();
                gestocks.price = dr["price"].ToString();
                gestocks.moniterqty = dr["moniterqty"].ToString();
                gestocks.quantity = dr["quantity"].ToString();
                gestocks.stockrefno = dr["sno"].ToString();
                Stocktransfer_sub_list.Add(gestocks);
            }
            get_Stock get_Stocks = new get_Stock();
            get_Stocks.stocktransferdetails = stock_lst;
            get_Stocks.stocktransfersubdetails = Stocktransfer_sub_list;
            stockdetails.Add(get_Stocks);
            string response = GetJson(stockdetails);
            context.Response.Write(response);
        }
        catch
        {
        }
    }


    private void get_approve_Stock_Tranfer_click(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string julydt = "07/01/2017";
            DateTime gst_dt = Convert.ToDateTime(julydt);
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT  stocktransfersubdetails.igst,stocktransfersubdetails.cgst,stocktransfersubdetails.sgst,stocktransferdetails.remarks,stocktransfersubdetails.taxtype,stocktransferdetails.invoiceno,stocktransferdetails.invoicedate,stocktransfersubdetails.price, stocktransfersubdetails.taxvalue,stocktransferdetails.invoicetype,stocktransferdetails.transportname,stocktransferdetails.vehicleno,stocktransfersubdetails.freigtamt,stocktransferdetails.sno as refno,stocktransfersubdetails.sno, branchmaster_1.branchname AS Expr1, productmaster.productname, stocktransferdetails.tobranch, stocktransfersubdetails.quantity, stocktransfersubdetails.productid, stocktransferdetails.doe,stocktransfersubdetails.stock_refno AS subrefno FROM  stocktransferdetails INNER JOIN stocktransfersubdetails ON stocktransferdetails.sno = stocktransfersubdetails.stock_refno INNER JOIN   branchmaster AS branchmaster_1 ON stocktransferdetails.tobranch = branchmaster_1.branchid INNER JOIN productmaster ON stocktransfersubdetails.productid = productmaster.productid  WHERE (stocktransferdetails.status='p') AND (stocktransferdetails.invoicedate BETWEEN  @d1 AND  @d2) AND (stocktransferdetails.branch_id=@branchid)");
            cmd.Parameters.Add("@d1", GetLowDate(ServerDateCurrentdate).AddDays(-60));
            cmd.Parameters.Add("@d2", GetHighDate(ServerDateCurrentdate));
            cmd.Parameters.Add("@branchid", branchid);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(routes);
            DataTable dtstock = view.ToTable(true, "invoiceno", "invoicedate", "refno", "tobranch", "invoicetype", "transportname", "vehicleno", "Expr1");
            DataTable dtstock_subdetails = view.ToTable(true, "sno", "invoicedate", "taxtype", "igst", "cgst", "sgst", "taxvalue", "freigtamt", "refno", "productid", "productname", "quantity");
            List<get_Stock> stockdetails = new List<get_Stock>();
            List<stocktransferdetails> stock_lst = new List<stocktransferdetails>();
            List<stocktransfersubdetails> Stocktransfer_sub_list = new List<stocktransfersubdetails>();
            foreach (DataRow dr in dtstock.Rows)
            {
                stocktransferdetails getstockdetails = new stocktransferdetails();
                getstockdetails.frombranch = dr["tobranch"].ToString();
                getstockdetails.invoicetype = dr["invoicetype"].ToString();
                getstockdetails.transportname = dr["transportname"].ToString();
                getstockdetails.invoiceno = dr["invoiceno"].ToString();
                getstockdetails.invoicedate = ((DateTime)dr["invoicedate"]).ToString("yyyy-MM-dd");
                getstockdetails.vehicleno = dr["vehicleno"].ToString();
                getstockdetails.status = "P";
                getstockdetails.bname = dr["Expr1"].ToString();
                getstockdetails.sno = dr["refno"].ToString();
                stock_lst.Add(getstockdetails);
            }
            foreach (DataRow dr in dtstock_subdetails.Rows)
            {
                stocktransfersubdetails gestocks = new stocktransfersubdetails();
                string inwarddate1 = ((DateTime)dr["invoicedate"]).ToString();
                //string inwarddate1 = "7/17/2017 12:00:00 AM";
                DateTime inwarddate = Convert.ToDateTime(inwarddate1);
                if (inwarddate < gst_dt)
                {
                    gestocks.taxtype = dr["taxtype"].ToString();
                    gestocks.taxvalue = dr["taxvalue"].ToString();
                }
                else
                {
                    gestocks.sgst_per = dr["sgst"].ToString();
                    gestocks.cgst_per = dr["cgst"].ToString();
                    gestocks.igst_per = dr["igst"].ToString();
                }

                gestocks.sno = dr["sno"].ToString();
                gestocks.hdnproductsno = dr["productid"].ToString();
                gestocks.productname = dr["productname"].ToString();
                gestocks.freigtamt = dr["freigtamt"].ToString();
                gestocks.quantity = dr["quantity"].ToString();
                gestocks.stock_refno = dr["refno"].ToString();
                Stocktransfer_sub_list.Add(gestocks);
            }
            get_Stock get_Stocks = new get_Stock();
            get_Stocks.stocktransferdetails = stock_lst;
            get_Stocks.stocktransfersubdetails = Stocktransfer_sub_list;
            stockdetails.Add(get_Stocks);
            string response = GetJson(stockdetails);
            context.Response.Write(response);
        }
        catch
        {
        }
    }
    private void save_approve_Stock_Tranfer_click(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            vdm = new SalesDBManager();
            var js = new JavaScriptSerializer();
            var title1 = context.Request.Params[1];
            stocktransferdetails obj = js.Deserialize<stocktransferdetails>(title1);
            string entryby = context.Session["Employ_Sno"].ToString();
            string branchid = context.Session["Po_BranchID"].ToString();
            string branch_id = context.Session["Po_BranchID"].ToString();
            string stocksno = obj.stock_sno;
            cmd = new SqlCommand("update stocktransferdetails set status=@status where sno=@stocksno AND branch_id=@branch_id");
            cmd.Parameters.Add("@date", ServerDateCurrentdate);
            cmd.Parameters.Add("@status", "A");
            cmd.Parameters.Add("@stocksno", stocksno);
            cmd.Parameters.Add("@branch_id", branchid);
            vdm.Update(cmd);
            foreach (stocktransfersubdetails si in obj.filldetails)
            {
                if (si.quantity == null)
                {
                }
                else
                {
                    if (si.hdnproductsno != "0")
                    {

                        cmd = new SqlCommand("SELECT   productid, qty, price, branchid, minstock, maxstock FROM productmoniter  where  branchid=@branchid And  productid=@hdnproductsno");
                        cmd.Parameters.Add("@hdnproductsno", si.hdnproductsno);
                        cmd.Parameters.Add("@branchid", branchid);
                        DataTable dtproductqty = vdm.SelectQuery(cmd).Tables[0];
                        string moniterqty = dtproductqty.Rows[0]["qty"].ToString();
                        double oppqty = 0; double currentqty = 0;
                        double.TryParse(moniterqty, out oppqty);
                        double.TryParse(si.quantity, out currentqty);
                        if (oppqty >= currentqty)
                        {
                            cmd = new SqlCommand("update productmoniter set qty=qty-@quantity where productid=@hdnproductsno");
                            cmd.Parameters.Add("@quantity", si.quantity);
                            cmd.Parameters.Add("@hdnproductsno", si.hdnproductsno);
                        }
                        if (vdm.Update(cmd) == 0)
                        {
                            cmd = new SqlCommand("insert into productmoniter (productid,qty) values(@productid,@qty)");
                            cmd.Parameters.Add("@productid", si.hdnproductsno);
                            cmd.Parameters.Add("@qty", si.quantity);
                            vdm.insert(cmd);
                        }
                    }
                }
            }
            string msg = " Stock Transfer Details successfully Approved";
            string Response = GetJson(msg);
            context.Response.Write(Response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);

        }
    }

    private void get_StockTransfer_details_click(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string tobranchid = context.Request["branchid"];
            string strfromdate = context.Request["fromdate"];
            string strtodate = context.Request["todate"];
            DateTime dtfrom = Convert.ToDateTime(strfromdate);
            DateTime dtto = Convert.ToDateTime(strtodate);
            string branchid = context.Session["Po_BranchID"].ToString();
            if (tobranchid != "Select Branch Name")
            {
                cmd = new SqlCommand("SELECT stocktransferdetails.transportname, stocktransferdetails.stock_sno, stocktransferdetails.invoicetype, stocktransferdetails.invoiceno, stocktransferdetails.invoicedate, stocktransferdetails.vehicleno, stocktransferdetails.sno AS refno, branchmaster.branchname AS tobranch, stocktransferdetails.tobranch AS Expr1, stocktransferdetails.status FROM stocktransferdetails INNER JOIN branchmaster ON stocktransferdetails.tobranch = branchmaster.branchid WHERE (stocktransferdetails.invoicedate BETWEEN @d1 AND @d2) AND (stocktransferdetails.branch_id=@branch_id) AND (stocktransferdetails.tobranch=@tobranch) ORDER BY stocktransferdetails.invoicedate");
                cmd.Parameters.Add("@tobranch", tobranchid);
            }
            else
            {
                cmd = new SqlCommand("SELECT stocktransferdetails.transportname, stocktransferdetails.stock_sno, stocktransferdetails.invoicetype, stocktransferdetails.invoiceno, stocktransferdetails.invoicedate, stocktransferdetails.vehicleno, stocktransferdetails.sno AS refno, branchmaster.branchname AS tobranch, stocktransferdetails.tobranch AS Expr1, stocktransferdetails.status FROM stocktransferdetails INNER JOIN branchmaster ON stocktransferdetails.tobranch = branchmaster.branchid WHERE (stocktransferdetails.invoicedate BETWEEN @d1 AND @d2) AND (stocktransferdetails.branch_id=@branch_id) ORDER BY stocktransferdetails.invoicedate");
            }
            cmd.Parameters.Add("@d1", GetLowDate(dtfrom));
            cmd.Parameters.Add("@d2", GetHighDate(dtto));
            cmd.Parameters.Add("@branch_id", branchid);
            DataTable dtstock = vdm.SelectQuery(cmd).Tables[0];
            List<stocktransferdetails> stock_lst = new List<stocktransferdetails>();
            foreach (DataRow dr in dtstock.Rows)
            {
                stocktransferdetails getstockdetails = new stocktransferdetails();
                getstockdetails.tobranch = dr["tobranch"].ToString();
                getstockdetails.invoicetype = dr["invoicetype"].ToString();
                getstockdetails.transportname = dr["transportname"].ToString();
                getstockdetails.status = dr["status"].ToString();
                getstockdetails.vehicleno = dr["vehicleno"].ToString();
                getstockdetails.doe = ((DateTime)dr["invoicedate"]).ToString("dd-MM-yyyy"); //dr["invoicedate"].ToString();
                getstockdetails.sno = dr["refno"].ToString();
                getstockdetails.stock_sno = dr["stock_sno"].ToString();
                stock_lst.Add(getstockdetails);
            }
            string response = GetJson(stock_lst);
            context.Response.Write(response);
        }
        catch
        {
        }
    }

    private void get_StockTransfer_Sub_details_click(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string julydt = "07/01/2017";
            DateTime gst_dt = Convert.ToDateTime(julydt);
            string refdcno = context.Request["refdcno"].ToString();
            string refdcno1 = context.Request["refdcno1"].ToString();
            string branchid = context.Session["Po_BranchID"].ToString();
            string Add_ress = context.Session["Address"].ToString();
            string state = context.Session["stateid"].ToString();
            string session_gstin = context.Session["gstin"].ToString();

            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            DateTime dtapril = new DateTime();
            DateTime dtmarch = new DateTime();
            int currentyear = ServerDateCurrentdate.Year;
            int nextyear = ServerDateCurrentdate.Year + 1;
            int currntyearnum = 0;
            int nextyearnum = 0;
            if (ServerDateCurrentdate.Month > 3)
            {
                string apr = "4/1/" + currentyear;
                dtapril = DateTime.Parse(apr);
                string march = "3/31/" + nextyear;
                dtmarch = DateTime.Parse(march);
                currntyearnum = currentyear;
                nextyearnum = nextyear;
            }
            if (ServerDateCurrentdate.Month <= 3)
            {
                string apr = "4/1/" + (currentyear - 1);
                dtapril = DateTime.Parse(apr);
                string march = "3/31/" + (nextyear - 1);
                dtmarch = DateTime.Parse(march);
                currntyearnum = currentyear - 1;
                nextyearnum = nextyear - 1;
            }
            if (refdcno != "")
            {
                cmd = new SqlCommand("SELECT uimmaster.uim, stocktransferdetails.salesinvoiceno,stocktransferdetails.salesstno, stocktransferdetails.stock_sno,stocktransferdetails.freight,statemaster.sno as statesno,branchmaster_1.type,branchmaster_1.address,branchmaster_1.GSTIN,statemaster.statename as tostate,statemaster.gststatecode as stateid,stocktransfersubdetails.igst,stocktransfersubdetails.cgst,stocktransfersubdetails.sgst,productmaster.HSNcode,productmaster.itemcode,stocktransferdetails.remarks,stocktransferdetails.transportname,stocktransferdetails.invoicetype,stocktransferdetails.invoiceno,stocktransferdetails.invoicedate,stocktransferdetails.vehicleno,stocktransfersubdetails.price,stocktransfersubdetails.taxvalue,stocktransfersubdetails.taxtype,stocktransfersubdetails.freigtamt,stocktransferdetails.sno as refno,branchmaster_1.tino,stocktransfersubdetails.sno, branchmaster_1.branchname AS Expr1, productmaster.productname, stocktransferdetails.tobranch, stocktransfersubdetails.quantity, stocktransfersubdetails.stock_refno, stocktransfersubdetails.productid, stocktransferdetails.doe, branchmaster_1.statename,statemaster.code AS statecode FROM  stocktransferdetails INNER JOIN stocktransfersubdetails ON stocktransferdetails.sno = stocktransfersubdetails.stock_refno INNER JOIN branchmaster AS branchmaster_1 ON stocktransferdetails.tobranch = branchmaster_1.branchid INNER JOIN productmaster ON stocktransfersubdetails.productid = productmaster.productid LEFT OUTER JOIN statemaster ON branchmaster_1.statename = statemaster.sno LEFT OUTER JOIN uimmaster ON uimmaster.sno = productmaster.uim WHERE (stocktransferdetails.sno =@refdcno) AND (stocktransferdetails.branch_id=@branch_id)");
                cmd.Parameters.Add("@refdcno", refdcno);
                cmd.Parameters.Add("@branch_id", branchid);
            }
            else
            {
                cmd = new SqlCommand("SELECT uimmaster.uim, stocktransferdetails.salesinvoiceno, stocktransferdetails.salesstno, stocktransferdetails.stock_sno,stocktransferdetails.freight,statemaster.sno as statesno,branchmaster_1.type,branchmaster_1.address,branchmaster_1.GSTIN,statemaster.statename as tostate,statemaster.gststatecode as stateid,stocktransfersubdetails.igst,stocktransfersubdetails.cgst,stocktransfersubdetails.sgst,productmaster.HSNcode,productmaster.itemcode,stocktransferdetails.remarks,stocktransferdetails.transportname,stocktransferdetails.invoicetype,stocktransferdetails.invoiceno,stocktransferdetails.invoicedate,stocktransferdetails.vehicleno,stocktransfersubdetails.price,stocktransfersubdetails.taxvalue,stocktransfersubdetails.taxtype,stocktransfersubdetails.freigtamt,stocktransferdetails.sno as refno,stocktransfersubdetails.sno,branchmaster_1.tino, branchmaster_1.branchname AS Expr1, productmaster.productname, stocktransferdetails.tobranch, stocktransfersubdetails.quantity, stocktransfersubdetails.stock_refno, stocktransfersubdetails.productid, stocktransferdetails.doe, branchmaster_1.statename,statemaster.code AS statecode FROM  stocktransferdetails INNER JOIN stocktransfersubdetails ON stocktransferdetails.sno = stocktransfersubdetails.stock_refno  INNER JOIN branchmaster AS branchmaster_1 ON stocktransferdetails.tobranch = branchmaster_1.branchid INNER JOIN productmaster ON stocktransfersubdetails.productid = productmaster.productid LEFT OUTER JOIN statemaster ON branchmaster_1.statename = statemaster.sno LEFT OUTER JOIN uimmaster ON uimmaster.sno = productmaster.uim WHERE (stocktransferdetails.sno =@refdcno) AND (stocktransferdetails.branch_id=@branch_id)");
                cmd.Parameters.Add("@refdcno", refdcno1);
                cmd.Parameters.Add("@branch_id", branchid);
            }
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(routes);
            DataTable dtstock = view.ToTable(true, "statecode", "salesinvoiceno", "salesstno", "statesno", "GSTIN", "stock_sno", "address", "refno", "freight", "type", "remarks", "tobranch", "transportname", "tostate", "stateid", "vehicleno", "invoiceno", "invoicedate", "Expr1", "tino", "igst");
            DataTable dtstock_subdetails = view.ToTable(true, "sno", "uim", "taxvalue", "taxtype", "itemcode", "invoiceno", "invoicetype", "invoicedate", "freigtamt", "refno", "price", "productid", "productname", "quantity", "igst", "cgst", "sgst", "HSNcode");
            List<get_Stock> stockdetails = new List<get_Stock>();
            List<stocktransferdetails> stock_lst = new List<stocktransferdetails>();
            List<stocktransfersubdetails> Stocktransfer_sub_list = new List<stocktransfersubdetails>();
            cmd = new SqlCommand("select statemaster.sno,statemaster.code AS statecode,statemaster.gststatecode,statemaster.statename,branchmaster.GSTIN,branchmaster.address,branchmaster.branchname,branchmaster.branchcode from statemaster INNER JOIN branchmaster ON statemaster.sno = branchmaster.statename WHERE branchmaster.branchid = @branch_id");
            cmd.Parameters.Add("@branch_id", branchid);
            DataTable dt_branch = vdm.SelectQuery(cmd).Tables[0];
            string fromstate = dt_branch.Rows[0]["statename"].ToString();
            string frombranch_gstin = dt_branch.Rows[0]["GSTIN"].ToString();
            string frombranch_address = dt_branch.Rows[0]["address"].ToString();
            string frombranch_stateid = dt_branch.Rows[0]["gststatecode"].ToString();
            string frombranch_statesno = dt_branch.Rows[0]["sno"].ToString();
            string frombranch_name = dt_branch.Rows[0]["branchname"].ToString();
            string frombranch_statecode = dt_branch.Rows[0]["statecode"].ToString();
            string frombranchcode = dt_branch.Rows[0]["branchcode"].ToString();
            foreach (DataRow dr in dtstock.Rows)
            {
                stocktransferdetails getstockdetails = new stocktransferdetails();
                getstockdetails.tobranch = dr["tobranch"].ToString();
                getstockdetails.transportname = dr["transportname"].ToString();
                getstockdetails.invoicedate = ((DateTime)dr["invoicedate"]).ToString("dd-MM-yyyy");
                getstockdetails.vehicleno = dr["vehicleno"].ToString();
                getstockdetails.remarks = dr["remarks"].ToString();
                getstockdetails.TinNo = dr["tino"].ToString();
                getstockdetails.bname = dr["Expr1"].ToString();
                getstockdetails.sno = dr["refno"].ToString();
                getstockdetails.fromstate = fromstate;
                getstockdetails.frombranch_gstin = frombranch_gstin;
                getstockdetails.frombranch_address = frombranch_address;
                getstockdetails.Address = Add_ress;
                getstockdetails.State = state;
                getstockdetails.fromstate_sno = frombranch_statesno;
                getstockdetails.session_gstin = session_gstin;
                getstockdetails.tobranch_gstin = dr["GSTIN"].ToString();
                getstockdetails.tostate = dr["tostate"].ToString();
                getstockdetails.tobranch_address = dr["address"].ToString();
                getstockdetails.frombranch_statecode = frombranch_statecode;
                getstockdetails.tobranch_statecode = dr["stateid"].ToString();
                getstockdetails.tostate_sno = dr["statesno"].ToString();
                getstockdetails.tobranch_type = dr["type"].ToString();
                getstockdetails.freight = dr["freight"].ToString();
                
                
                string type = dr["salesinvoiceno"].ToString();
                string INVtype = "";
                int igtax = 0;
                int.TryParse(dr["igst"].ToString(), out igtax);

               
                if (type == "0")
                {
                    type = dr["salesstno"].ToString();
                    INVtype = "0";
                }
                string newreceipt = "0";
                int countdc = 0;
                int.TryParse(type, out countdc);
                if (countdc < 10)
                {
                    newreceipt = "000" + countdc;
                }
                if (countdc >= 10 && countdc <= 99)
                {
                    newreceipt = "00" + countdc;
                }
                if (countdc >= 99 && countdc <= 999)
                {
                    newreceipt = "0" + countdc;
                }
                if (countdc > 999)
                {
                    newreceipt = "" + countdc;
                }
                string stnumber = "";
                string strdate = "04/01/2018";
                DateTime dtinvoice = Convert.ToDateTime(dr["invoicedate"]);
                DateTime dtfrom = Convert.ToDateTime(strdate);
                if (dtinvoice > dtfrom)
                {

                }
                if (INVtype == "0")
                {
                    stnumber = frombranchcode + "/" + dtapril.ToString("yy") + "-" + dtmarch.ToString("yy") + "/" + newreceipt;
                }
                else
                {
                    if (igtax > 0)
                    {
                        stnumber = frombranchcode + "/" + dtapril.ToString("yy") + "-" + dtmarch.ToString("yy") + "T/" + newreceipt;
                    }
                    else
                    {
                        stnumber = frombranchcode + "/" + dtapril.ToString("yy") + "-" + dtmarch.ToString("yy") + "N/" + newreceipt;
                    }
                }
                getstockdetails.stock_sno = stnumber;
                getstockdetails.invoiceno = dr["invoiceno"].ToString();
                getstockdetails.frombranchname = frombranch_name;
                stock_lst.Add(getstockdetails);
            }
            foreach (DataRow dr in dtstock_subdetails.Rows)
            {
                stocktransfersubdetails gestocks = new stocktransfersubdetails();
                string st_date1 = ((DateTime)dr["invoicedate"]).ToString();
                DateTime st_date = Convert.ToDateTime(st_date1);
                if (st_date < gst_dt)
                {
                    gestocks.taxtype = dr["taxtype"].ToString();
                    gestocks.taxvalue = dr["taxvalue"].ToString();
                    gestocks.gst_exists = "0";
                }
                else
                {
                    gestocks.sgst_per = dr["sgst"].ToString();
                    gestocks.cgst_per = dr["cgst"].ToString();
                    gestocks.igst_per = dr["igst"].ToString();
                    gestocks.hsncode = dr["HSNcode"].ToString();
                    gestocks.gst_exists = "1";
                }
                gestocks.sno = dr["sno"].ToString();
                gestocks.itemcode = dr["itemcode"].ToString();
                gestocks.uim = dr["uim"].ToString();
                gestocks.hdnproductsno = dr["productid"].ToString();
                gestocks.productname = dr["productname"].ToString();
                gestocks.price = dr["price"].ToString();
                gestocks.invoicedate = ((DateTime)dr["invoicedate"]).ToString("dd-MM-yyyy");
                gestocks.invoicetype = dr["invoicetype"].ToString();
                gestocks.freigtamt = dr["freigtamt"].ToString();
                gestocks.quantity = dr["quantity"].ToString();
                gestocks.stock_refno = dr["refno"].ToString();
                Stocktransfer_sub_list.Add(gestocks);
            }
            get_Stock get_Stocks = new get_Stock();
            get_Stocks.stocktransferdetails = stock_lst;
            get_Stocks.stocktransfersubdetails = Stocktransfer_sub_list;
            stockdetails.Add(get_Stocks);
            string response = GetJson(stockdetails);
            context.Response.Write(response);
        }
        catch
        {
        }
    }


    private void get_debitvocher_details_click(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string tobranchid = context.Request["branchid"];
            string strfromdate = context.Request["fromdate"];
            string strtodate = context.Request["todate"];
            DateTime dtfrom = Convert.ToDateTime(strfromdate);
            DateTime dtto = Convert.ToDateTime(strtodate);
            string branchid = context.Session["Po_BranchID"].ToString();
            if (tobranchid != "Select Branch Name")
            {
                cmd = new SqlCommand("SELECT debitvocherdetails.transportname, debitvocherdetails.stock_sno, debitvocherdetails.invoicetype, debitvocherdetails.invoiceno, debitvocherdetails.invoicedate, debitvocherdetails.vehicleno, debitvocherdetails.sno AS refno, branchmaster.branchname AS tobranch, debitvocherdetails.tobranch AS Expr1, debitvocherdetails.status, debitvocherdetails.mrnno FROM debitvocherdetails INNER JOIN branchmaster ON debitvocherdetails.tobranch = branchmaster.branchid WHERE (debitvocherdetails.invoicedate BETWEEN @d1 AND @d2) AND (debitvocherdetails.branch_id=@branch_id) AND (debitvocherdetails.tobranch=@tobranch) ORDER BY debitvocherdetails.invoicedate");
                cmd.Parameters.Add("@tobranch", tobranchid);
            }
            else
            {
                cmd = new SqlCommand("SELECT debitvocherdetails.transportname, debitvocherdetails.stock_sno, debitvocherdetails.invoicetype, debitvocherdetails.invoiceno, debitvocherdetails.invoicedate, debitvocherdetails.vehicleno, debitvocherdetails.sno AS refno, branchmaster.branchname AS tobranch, debitvocherdetails.tobranch AS Expr1, debitvocherdetails.status, debitvocherdetails.mrnno FROM debitvocherdetails INNER JOIN branchmaster ON debitvocherdetails.tobranch = branchmaster.branchid WHERE (debitvocherdetails.invoicedate BETWEEN @d1 AND @d2) AND (debitvocherdetails.branch_id=@branch_id) ORDER BY debitvocherdetails.invoicedate");
            }
            cmd.Parameters.Add("@d1", GetLowDate(dtfrom));
            cmd.Parameters.Add("@d2", GetHighDate(dtto));
            cmd.Parameters.Add("@branch_id", branchid);
            DataTable dtstock = vdm.SelectQuery(cmd).Tables[0];
            List<stocktransferdetails> stock_lst = new List<stocktransferdetails>();
            foreach (DataRow dr in dtstock.Rows)
            {
                stocktransferdetails getstockdetails = new stocktransferdetails();
                getstockdetails.tobranch = dr["tobranch"].ToString();
                getstockdetails.invoicetype = dr["invoicetype"].ToString();
                getstockdetails.transportname = dr["transportname"].ToString();
                getstockdetails.status = dr["status"].ToString();
                getstockdetails.vehicleno = dr["vehicleno"].ToString();
                getstockdetails.doe = ((DateTime)dr["invoicedate"]).ToString("dd-MM-yyyy"); //dr["invoicedate"].ToString();
                getstockdetails.sno = dr["refno"].ToString();
                getstockdetails.stock_sno = dr["stock_sno"].ToString();
                stock_lst.Add(getstockdetails);
            }
            string response = GetJson(stock_lst);
            context.Response.Write(response);
        }
        catch
        {
        }
    }


    private void get_debitvocher_Sub_details_click(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string julydt = "07/01/2017";
            DateTime gst_dt = Convert.ToDateTime(julydt);
            string refdcno = context.Request["refdcno"].ToString();
            string refdcno1 = context.Request["refdcno1"].ToString();
            string branchid = context.Session["Po_BranchID"].ToString();
            string Add_ress = context.Session["Address"].ToString();
            string state = context.Session["stateid"].ToString();
            string session_gstin = context.Session["gstin"].ToString();

            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            DateTime dtapril = new DateTime();
            DateTime dtmarch = new DateTime();
            int currentyear = ServerDateCurrentdate.Year;
            int nextyear = ServerDateCurrentdate.Year + 1;
            int currntyearnum = 0;
            int nextyearnum = 0;
            if (ServerDateCurrentdate.Month > 3)
            {
                string apr = "4/1/" + currentyear;
                dtapril = DateTime.Parse(apr);
                string march = "3/31/" + nextyear;
                dtmarch = DateTime.Parse(march);
                currntyearnum = currentyear;
                nextyearnum = nextyear;
            }
            if (ServerDateCurrentdate.Month <= 3)
            {
                string apr = "4/1/" + (currentyear - 1);
                dtapril = DateTime.Parse(apr);
                string march = "3/31/" + (nextyear - 1);
                dtmarch = DateTime.Parse(march);
                currntyearnum = currentyear - 1;
                nextyearnum = nextyear - 1;
            }
            if (refdcno != "")
            {
                cmd = new SqlCommand("SELECT uimmaster.uim, debitvocherdetails.salesinvoiceno,debitvocherdetails.salesstno, debitvocherdetails.stock_sno,debitvocherdetails.freight,statemaster.sno as statesno,branchmaster_1.type,branchmaster_1.address,branchmaster_1.GSTIN,statemaster.statename as tostate,statemaster.gststatecode as stateid,debitvocherdsubdetails.igst,debitvocherdsubdetails.cgst,debitvocherdsubdetails.sgst,productmaster.HSNcode,productmaster.itemcode,debitvocherdetails.remarks,debitvocherdetails.transportname,debitvocherdetails.invoicetype,debitvocherdetails.invoiceno,debitvocherdetails.invoicedate,debitvocherdetails.vehicleno,debitvocherdsubdetails.price,debitvocherdsubdetails.taxvalue,debitvocherdsubdetails.taxtype,debitvocherdsubdetails.freigtamt,debitvocherdetails.sno as refno,branchmaster_1.tino,debitvocherdsubdetails.sno, branchmaster_1.branchname AS Expr1, productmaster.productname, debitvocherdetails.tobranch, debitvocherdsubdetails.quantity, debitvocherdsubdetails.stock_refno, debitvocherdsubdetails.productid, debitvocherdetails.doe, branchmaster_1.statename,statemaster.code AS statecode FROM  debitvocherdetails INNER JOIN debitvocherdsubdetails ON debitvocherdetails.sno = debitvocherdsubdetails.stock_refno INNER JOIN branchmaster AS branchmaster_1 ON debitvocherdetails.tobranch = branchmaster_1.branchid INNER JOIN productmaster ON debitvocherdsubdetails.productid = productmaster.productid LEFT OUTER JOIN statemaster ON branchmaster_1.statename = statemaster.sno LEFT OUTER JOIN uimmaster ON uimmaster.sno = productmaster.uim WHERE (debitvocherdetails.sno =@refdcno) AND (debitvocherdetails.branch_id=@branch_id)");
                cmd.Parameters.Add("@refdcno", refdcno);
                cmd.Parameters.Add("@branch_id", branchid);
            }
            else
            {
                cmd = new SqlCommand("SELECT uimmaster.uim, debitvocherdetails.salesinvoiceno, debitvocherdetails.salesstno, debitvocherdetails.stock_sno,debitvocherdetails.freight,statemaster.sno as statesno,branchmaster_1.type,branchmaster_1.address,branchmaster_1.GSTIN,statemaster.statename as tostate,statemaster.gststatecode as stateid,debitvocherdsubdetails.igst,debitvocherdsubdetails.cgst,debitvocherdsubdetails.sgst,productmaster.HSNcode,productmaster.itemcode,debitvocherdetails.remarks,debitvocherdetails.transportname,debitvocherdetails.invoicetype,debitvocherdetails.invoiceno,debitvocherdetails.invoicedate,debitvocherdetails.vehicleno,debitvocherdsubdetails.price,debitvocherdsubdetails.taxvalue,debitvocherdsubdetails.taxtype,debitvocherdsubdetails.freigtamt,debitvocherdetails.sno as refno,debitvocherdsubdetails.sno,branchmaster_1.tino, branchmaster_1.branchname AS Expr1, productmaster.productname, debitvocherdetails.tobranch, debitvocherdsubdetails.quantity, debitvocherdsubdetails.stock_refno, debitvocherdsubdetails.productid, debitvocherdetails.doe, branchmaster_1.statename,statemaster.code AS statecode FROM  debitvocherdetails INNER JOIN debitvocherdsubdetails ON debitvocherdetails.sno = debitvocherdsubdetails.stock_refno  INNER JOIN branchmaster AS branchmaster_1 ON debitvocherdetails.tobranch = branchmaster_1.branchid INNER JOIN productmaster ON debitvocherdsubdetails.productid = productmaster.productid LEFT OUTER JOIN statemaster ON branchmaster_1.statename = statemaster.sno LEFT OUTER JOIN uimmaster ON uimmaster.sno = productmaster.uim WHERE (debitvocherdetails.sno =@refdcno) AND (debitvocherdetails.branch_id=@branch_id)");
                cmd.Parameters.Add("@refdcno", refdcno1);
                cmd.Parameters.Add("@branch_id", branchid);
            }
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(routes);
            DataTable dtstock = view.ToTable(true, "statecode", "salesinvoiceno", "salesstno", "statesno", "GSTIN", "stock_sno", "address", "refno", "freight", "type", "remarks", "tobranch", "transportname", "tostate", "stateid", "vehicleno", "invoiceno", "invoicedate", "Expr1", "tino", "igst");
            DataTable dtstock_subdetails = view.ToTable(true, "sno", "uim", "taxvalue", "taxtype", "itemcode", "invoiceno", "invoicetype", "invoicedate", "freigtamt", "refno", "price", "productid", "productname", "quantity", "igst", "cgst", "sgst", "HSNcode");
            List<get_Stock> stockdetails = new List<get_Stock>();
            List<stocktransferdetails> stock_lst = new List<stocktransferdetails>();
            List<stocktransfersubdetails> Stocktransfer_sub_list = new List<stocktransfersubdetails>();
            cmd = new SqlCommand("select statemaster.sno,statemaster.code AS statecode,statemaster.gststatecode,statemaster.statename,branchmaster.GSTIN,branchmaster.address,branchmaster.branchname,branchmaster.branchcode from statemaster INNER JOIN branchmaster ON statemaster.sno = branchmaster.statename WHERE branchmaster.branchid = @branch_id");
            cmd.Parameters.Add("@branch_id", branchid);
            DataTable dt_branch = vdm.SelectQuery(cmd).Tables[0];
            string fromstate = dt_branch.Rows[0]["statename"].ToString();
            string frombranch_gstin = dt_branch.Rows[0]["GSTIN"].ToString();
            string frombranch_address = dt_branch.Rows[0]["address"].ToString();
            string frombranch_stateid = dt_branch.Rows[0]["gststatecode"].ToString();
            string frombranch_statesno = dt_branch.Rows[0]["sno"].ToString();
            string frombranch_name = dt_branch.Rows[0]["branchname"].ToString();
            string frombranch_statecode = dt_branch.Rows[0]["statecode"].ToString();
            string frombranchcode = dt_branch.Rows[0]["branchcode"].ToString();
            foreach (DataRow dr in dtstock.Rows)
            {
                stocktransferdetails getstockdetails = new stocktransferdetails();
                getstockdetails.tobranch = dr["tobranch"].ToString();
                getstockdetails.transportname = dr["transportname"].ToString();
                getstockdetails.invoicedate = ((DateTime)dr["invoicedate"]).ToString("dd-MM-yyyy");
                getstockdetails.vehicleno = dr["vehicleno"].ToString();
                getstockdetails.remarks = dr["remarks"].ToString();
                getstockdetails.TinNo = dr["tino"].ToString();
                getstockdetails.bname = dr["Expr1"].ToString();
                getstockdetails.sno = dr["refno"].ToString();
                getstockdetails.fromstate = fromstate;
                getstockdetails.frombranch_gstin = frombranch_gstin;
                getstockdetails.frombranch_address = frombranch_address;
                getstockdetails.Address = Add_ress;
                getstockdetails.State = state;
                getstockdetails.fromstate_sno = frombranch_statesno;
                getstockdetails.session_gstin = session_gstin;
                getstockdetails.tobranch_gstin = dr["GSTIN"].ToString();
                getstockdetails.tostate = dr["tostate"].ToString();
                getstockdetails.tobranch_address = dr["address"].ToString();
                getstockdetails.frombranch_statecode = frombranch_statecode;
                getstockdetails.tobranch_statecode = dr["stateid"].ToString();
                getstockdetails.tostate_sno = dr["statesno"].ToString();
                getstockdetails.tobranch_type = dr["type"].ToString();
                getstockdetails.freight = dr["freight"].ToString();


                string type = dr["stock_sno"].ToString();
                string INVtype = "";
                int igtax = 0;
                int.TryParse(dr["igst"].ToString(), out igtax);

               
                if (type == "0")
                {
                    type = dr["stock_sno"].ToString();
                    INVtype = "0";
                }
                string newreceipt = "0";
                int countdc = 0;
                int.TryParse(type, out countdc);
                if (countdc < 10)
                {
                    newreceipt = "000" + countdc;
                }
                if (countdc >= 10 && countdc <= 99)
                {
                    newreceipt = "00" + countdc;
                }
                if (countdc >= 99 && countdc <= 999)
                {
                    newreceipt = "0" + countdc;
                }
                if (countdc > 999)
                {
                    newreceipt = "" + countdc;
                }
                string stnumber = "";
                string strdate = "04/01/2018";
                DateTime dtinvoice = Convert.ToDateTime(dr["invoicedate"]);
                DateTime dtfrom = Convert.ToDateTime(strdate);
                if (dtinvoice > dtfrom)
                {

                }
                if (INVtype == "0")
                {
                    stnumber = frombranchcode + "/" + dtapril.ToString("yy") + "-" + dtmarch.ToString("yy") + "/" + newreceipt;
                }
                else
                {
                    if (igtax > 0)
                    {
                        stnumber = frombranchcode + "/" + dtapril.ToString("yy") + "-" + dtmarch.ToString("yy") + "T/" + newreceipt;
                    }
                    else
                    {
                        stnumber = frombranchcode + "/" + dtapril.ToString("yy") + "-" + dtmarch.ToString("yy") + "N/" + newreceipt;
                    }
                }
                getstockdetails.stock_sno = stnumber;
                getstockdetails.invoiceno = dr["invoiceno"].ToString();
                getstockdetails.frombranchname = frombranch_name;
                stock_lst.Add(getstockdetails);
            }
            foreach (DataRow dr in dtstock_subdetails.Rows)
            {
                stocktransfersubdetails gestocks = new stocktransfersubdetails();
                string st_date1 = ((DateTime)dr["invoicedate"]).ToString();
                DateTime st_date = Convert.ToDateTime(st_date1);
                if (st_date < gst_dt)
                {
                    gestocks.taxtype = dr["taxtype"].ToString();
                    gestocks.taxvalue = dr["taxvalue"].ToString();
                    gestocks.gst_exists = "0";
                }
                else
                {
                    gestocks.sgst_per = dr["sgst"].ToString();
                    gestocks.cgst_per = dr["cgst"].ToString();
                    gestocks.igst_per = dr["igst"].ToString();
                    gestocks.hsncode = dr["HSNcode"].ToString();
                    gestocks.gst_exists = "1";
                }
                gestocks.sno = dr["sno"].ToString();
                gestocks.itemcode = dr["itemcode"].ToString();
                gestocks.uim = dr["uim"].ToString();
                gestocks.hdnproductsno = dr["productid"].ToString();
                gestocks.productname = dr["productname"].ToString();
                gestocks.price = dr["price"].ToString();
                gestocks.invoicedate = ((DateTime)dr["invoicedate"]).ToString("dd-MM-yyyy");
                gestocks.invoicetype = dr["invoicetype"].ToString();
                gestocks.freigtamt = dr["freigtamt"].ToString();
                gestocks.quantity = dr["quantity"].ToString();
                gestocks.stock_refno = dr["refno"].ToString();
                Stocktransfer_sub_list.Add(gestocks);
            }
            get_Stock get_Stocks = new get_Stock();
            get_Stocks.stocktransferdetails = stock_lst;
            get_Stocks.stocktransfersubdetails = Stocktransfer_sub_list;
            stockdetails.Add(get_Stocks);
            string response = GetJson(stockdetails);
            context.Response.Write(response);
        }
        catch
        {
        }
    }



    private void save_approve_indent_click(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string indentsno = context.Request["indentsno"];
            string entryby = context.Session["Employ_Sno"].ToString();
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("update indents set d_date=@date,status=@status where branch_id=@branchid AND sno=@indentno");
            cmd.Parameters.Add("@date", ServerDateCurrentdate);
            cmd.Parameters.Add("@status", "V");
            cmd.Parameters.Add("@indentno", indentsno);
            cmd.Parameters.Add("@branchid", branchid);
            vdm.Update(cmd);
            string msg = " Indent successfully Approved";
            string Response = GetJson(msg);
            context.Response.Write(Response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void save_scrap_sales_click(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            var js = new JavaScriptSerializer();
            var title1 = context.Request.Params[1];
            ScrapSalesDetails obj = js.Deserialize<ScrapSalesDetails>(title1);
            string entryby = context.Session["Employ_Sno"].ToString();
            string branchid = context.Session["Po_BranchID"].ToString();
            string hiddensupplyid = obj.hiddensupplyid;
            string transportname = obj.transportname;
            string vehicleno = obj.vehicleno;
            string invoiceno = obj.invoiceno;
            string invdate = obj.invoicedate;
            DateTime invoiate = Convert.ToDateTime(invdate);
            string invoicedate = invoiate.ToString("MM-dd-yyyy");
            string sno = obj.sno;
            string status = obj.status;
            string remarks = obj.remarks;
            string invoicetype = obj.invoicetype;
            DateTime doe = DateTime.Now;
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string btnval = obj.btnval;
            if (btnval == "save")
            {
                cmd = new SqlCommand("insert into scrapsales(invoicetype,invoicedate,invoiceno,branchid,entryby,doe,transportname,vehicleno,status,remarks,supplierid) values(@invoicetype,@invoicedate,@invoiceno,@branchid,@entryby,@doe,@transportname,@vehicleno,@status,@remarks,@supplierid)");
                cmd.Parameters.Add("@supplierid", hiddensupplyid);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@entryby", entryby);
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@invoicetype", invoicetype);
                cmd.Parameters.Add("@invoiceno", invoiceno);
                cmd.Parameters.Add("@invoicedate", invoicedate);
                cmd.Parameters.Add("@transportname", transportname);
                cmd.Parameters.Add("@vehicleno", vehicleno);
                cmd.Parameters.Add("@status", status);
                cmd.Parameters.Add("@remarks", remarks);
                vdm.insert(cmd);
                cmd = new SqlCommand("select MAX(sno) as salessno  from scrapsales");
                DataTable dtsales = vdm.SelectQuery(cmd).Tables[0];
                string salesrefno = dtsales.Rows[0]["salessno"].ToString();
                foreach (SubScrapSalesDetails si in obj.fillsales)
                {
                    if (si.hdnproductsno != "0")
                    {
                        cmd = new SqlCommand("insert into subscrapsales(igst,cgst,sgst,productid,price,qty,branchid,sales_refno) values(@taxtype,@taxvalue,@freigtamt,@productid,@price,@qty,@branchid,@sales_refno)");
                        cmd.Parameters.Add("@taxtype", si.igst);
                        cmd.Parameters.Add("@taxvalue", si.cgst);
                        cmd.Parameters.Add("@freigtamt", si.sgst);
                        cmd.Parameters.Add("@productid", si.hdnproductsno);
                        cmd.Parameters.Add("@price", si.cost);
                        cmd.Parameters.Add("@qty", si.qty);
                        cmd.Parameters.Add("@branchid", branchid);
                        cmd.Parameters.Add("@sales_refno", salesrefno);
                        vdm.insert(cmd);
                    }
                }
                string msg = "successfully Inserted";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {
                cmd = new SqlCommand("update scrapsales set invoicetype=@invoicetype,invoicedate=@invoicedate,invoiceno=@invoiceno,supplierid=@supplierid,doe=@doe,transportname=@transportname,vehicleno=@vehicleno,remarks=@remarks,entryby=@entryby where sno=@sno AND branchid=@branchid");
                cmd.Parameters.Add("@supplierid", hiddensupplyid);
                cmd.Parameters.Add("@doe", doe);
                cmd.Parameters.Add("@entryby", entryby);
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@invoicetype", invoicetype);
                cmd.Parameters.Add("@invoiceno", invoiceno);
                cmd.Parameters.Add("@invoicedate", invoicedate);
                cmd.Parameters.Add("@transportname", transportname);
                cmd.Parameters.Add("@vehicleno", vehicleno);
                cmd.Parameters.Add("@sno", sno);
                cmd.Parameters.Add("@remarks", remarks);
                vdm.Update(cmd);
                foreach (SubScrapSalesDetails si in obj.fillsales)
                {
                    if (si.hdnproductsno != "0")
                    {
                        cmd = new SqlCommand("update subscrapsales set taxtype=@taxtype,taxvalue=@taxvalue,productid=@productid,price=@price,qty=@qty,freightamt=@freigtamt where sales_refno=@sales_refno and sno=@sno");
                        cmd.Parameters.Add("@taxtype", si.taxtype);
                        cmd.Parameters.Add("@taxvalue", si.taxvalue);
                        cmd.Parameters.Add("@freigtamt", si.freightamt);
                        cmd.Parameters.Add("@productid", si.hdnproductsno);
                        cmd.Parameters.Add("@price", si.cost);
                        cmd.Parameters.Add("@qty", si.qty);
                        cmd.Parameters.Add("@branchid", branchid);
                        cmd.Parameters.Add("@sales_refno", sno);
                        cmd.Parameters.Add("@sno", si.subsno);
                        vdm.insert(cmd);
                    }
                }
                string msg = "successfully updated";
                string Response = GetJson(msg);
                context.Response.Write(Response);

            }
        }
        catch
        {

        }
    }

    public class SubScrapSalesDetails
    {
        public string sno { get; set; }
        public string productname { get; set; }
        public string cost { get; set; }
        public string qty { get; set; }
        public string uim { get; set; }
        public string totalcost { get; set; }
        public string doe { get; set; }
        public string productid { get; set; }
        public string hdnproductsno { get; set; }
        public string freightamt { get; set; }
        public string taxtype { get; set; }
        public string scrapprice { get; set; }
        public string taxvalue { get; set; }
        public string subsno { get; set; }
        public string sales_refno { get; set; }
        public string cgst { get; set; }
        public string igst { get; set; }
        public string sgst { get; set; }
        public string sgstvalue { get; set; }
        public string cgstvalue { get; set; }
        public string igstvalue { get; set; }
        public string totalvalue { get; set; }
    }

    public class ScrapSalesDetails
    {
        public string branchname { get; set; }
        public string transportname { get; set; }
        public string vehicleno { get; set; }
        public string invoicedate { get; set; }
        public string invoicetype { get; set; }
        public string invoiceno { get; set; }
        public string bname { get; set; }
        public string sno { get; set; }
        public string entryby { get; set; }
        public string suppliername { get; set; }
        public string status { get; set; }
        public string hiddensupplyid { get; set; }
        public string remarks { get; set; }
        public string btnval { get; set; }
        public string doe { get; set; }


        public string tostate { get; set; }
        public string fromstate_sno { get; set; }
        public string tostate_sno { get; set; }
        public string frombranch_gstin { get; set; }
        public string tobranch_gstin { get; set; }
        public string frombranch_address { get; set; }
        public string tobranch_address { get; set; }
        public string fromstate { get; set; }
        public string Address { get; set; }
        public string session_gstin { get; set; }
        public string State { get; set; }
        public List<SubScrapSalesDetails> fillsales { get; set; }
    }
    public class getScrapSales
    {
        public List<ScrapSalesDetails> ScrapSalesDetails { get; set; }
        public List<SubScrapSalesDetails> SubScrapSalesDetails { get; set; }
    }
    private void get_scrapsales_Sub_details_Report(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string refdcno = context.Request["refdcno"];
            string branchid = context.Session["Po_BranchID"].ToString();
            string Add_ress = context.Session["Address"].ToString();
            string state = context.Session["stateid"].ToString();
            string session_gstin = context.Session["gstin"].ToString();
            //  cmd = new SqlCommand(" SELECT subscrapsales.productid, suppliersdetails.name, scrapitemdetails.itemname, uimmaster.uim, scrapitemdetails.price, scrapitemdetails.branchid, scrapsales.transportname, scrapsales.invoicetype, scrapsales.status, scrapsales.vehicleno, scrapsales.invoiceno, scrapsales.invoicedate, scrapsales.remarks,scrapsales.branchid AS Expr1, scrapsales.entryby, scrapsales.doe, subscrapsales.qty, subscrapsales.price AS scrapprice, subscrapsales.sales_refno,subscrapsales.taxvalue, subscrapsales.freightamt, subscrapsales.taxtype, subscrapsales.doe AS Expr3, scrapsales.sno, branchmaster.branchname FROM scrapsales INNER JOIN subscrapsales ON scrapsales.sno = subscrapsales.sales_refno INNER JOIN scrapitemdetails ON subscrapsales.productid = scrapitemdetails.sno INNER JOIN suppliersdetails ON scrapsales.supplierid = suppliersdetails.supplierid INNER JOIN uimmaster ON scrapitemdetails.uom = uimmaster.sno INNER JOIN branchmaster ON scrapsales.branchid = branchmaster.branchid WHERE (scrapsales.branchid = @branchid) AND (scrapsales.sno = @refdcno)");
            cmd = new SqlCommand("SELECT  subscrapsales.productid, scrapsales.branchid, subscrapsales.igst, subscrapsales.cgst, subscrapsales.sgst, productmaster.productname, suppliersdetails.name, uimmaster.uim, scrapsales.transportname, scrapsales.invoicetype, scrapsales.status, scrapsales.vehicleno, scrapsales.invoiceno, scrapsales.invoicedate, scrapsales.remarks, scrapsales.branchid AS Expr1, scrapsales.entryby, scrapsales.doe, subscrapsales.qty, subscrapsales.price AS scrapprice, subscrapsales.sales_refno, subscrapsales.taxvalue, subscrapsales.freightamt, subscrapsales.taxtype, subscrapsales.doe AS Expr3, scrapsales.sno, branchmaster.branchname FROM scrapsales INNER JOIN subscrapsales ON scrapsales.sno = subscrapsales.sales_refno INNER JOIN suppliersdetails ON scrapsales.supplierid = suppliersdetails.supplierid INNER JOIN branchmaster ON scrapsales.branchid = branchmaster.branchid INNER JOIN productmaster ON subscrapsales.productid = productmaster.productid INNER JOIN uimmaster ON productmaster.uim = uimmaster.sno WHERE (scrapsales.branchid = @branchid) AND (scrapsales.sno = @refdcno)");
            cmd.Parameters.Add("@refdcno", refdcno);
            cmd.Parameters.Add("@branchid", branchid);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(routes);
            DataTable dtpo = view.ToTable(true, "name", "branchid", "transportname", "invoicetype", "status", "vehicleno", "invoiceno", "invoicedate", "remarks", "branchname");
            DataTable dtpurchase_subdetails = view.ToTable(true, "sales_refno", "sno", "productid", "productname", "uim", "qty", "taxtype", "scrapprice", "taxvalue", "freightamt", "cgst", "sgst", "igst");
            List<getScrapSales> getscraplist = new List<getScrapSales>();
            List<ScrapSalesDetails> getScrapSalesDetailslist = new List<ScrapSalesDetails>();
            List<SubScrapSalesDetails> gerSubScrapSalesDetailslist = new List<SubScrapSalesDetails>();
            cmd = new SqlCommand("select statemaster.sno,statemaster.gststatecode,statemaster.statename,branchmaster.GSTIN,branchmaster.address,branchmaster.branchname from statemaster INNER JOIN branchmaster ON statemaster.sno = branchmaster.statename WHERE branchmaster.branchid = @branch_id");
            cmd.Parameters.Add("@branch_id", branchid);
            DataTable dt_branch = vdm.SelectQuery(cmd).Tables[0];
            string fromstate = dt_branch.Rows[0]["statename"].ToString();
            string frombranch_gstin = dt_branch.Rows[0]["GSTIN"].ToString();
            string frombranch_address = dt_branch.Rows[0]["address"].ToString();
            string frombranch_statecode = dt_branch.Rows[0]["gststatecode"].ToString();
            string frombranch_statesno = dt_branch.Rows[0]["sno"].ToString();
            string frombranch_name = dt_branch.Rows[0]["branchname"].ToString();
            foreach (DataRow dr in dtpo.Rows)
            {
                ScrapSalesDetails getscrapobj = new ScrapSalesDetails();
                getscrapobj.suppliername = dr["name"].ToString();
                getscrapobj.invoicedate = ((DateTime)dr["invoicedate"]).ToString("dd-MM-yyyy"); //dr["podate"].ToString();
                getscrapobj.transportname = dr["transportname"].ToString();
                getscrapobj.branchname = dr["branchname"].ToString();
                getscrapobj.invoicetype = dr["invoicetype"].ToString();
                getscrapobj.invoiceno = dr["invoiceno"].ToString();
                getscrapobj.remarks = dr["remarks"].ToString();
                getscrapobj.fromstate = fromstate;
                getscrapobj.frombranch_gstin = frombranch_gstin;
                getscrapobj.frombranch_address = frombranch_address;
                getscrapobj.Address = Add_ress;
                getscrapobj.State = state;
                getscrapobj.fromstate_sno = frombranch_statesno;
                getscrapobj.session_gstin = session_gstin;
                getScrapSalesDetailslist.Add(getscrapobj);
            }
            foreach (DataRow dr in dtpurchase_subdetails.Rows)
            {
                SubScrapSalesDetails getsubscrapobj = new SubScrapSalesDetails();
                getsubscrapobj.productname = dr["productname"].ToString();
                getsubscrapobj.uim = dr["uim"].ToString();
                getsubscrapobj.cost = dr["scrapprice"].ToString();
                getsubscrapobj.qty = dr["qty"].ToString();
                double qty = Convert.ToDouble(dr["qty"].ToString());
                double scrapprice = Convert.ToDouble(dr["scrapprice"].ToString());
                double taxblevalue = qty * scrapprice;
                double igst = 0;
                double.TryParse(dr["igst"].ToString(), out igst);
                double cgst = 0;
                double.TryParse(dr["cgst"].ToString(), out cgst);
                double sgst = 0;
                double.TryParse(dr["sgst"].ToString(), out sgst);
                double igstvalue = 0;
                double cgstvalue = 0;
                double sgstvalue = 0;
                if (igst != 0)
                {
                    igstvalue = (taxblevalue * igst) / 100;
                }
                else
                {
                    cgstvalue = (taxblevalue * cgst) / 100;
                    sgstvalue = (taxblevalue * sgst) / 100;
                }
                double totalvalue = taxblevalue + igstvalue + sgstvalue + cgstvalue;
                getsubscrapobj.taxtype = dr["taxtype"].ToString();
                getsubscrapobj.scrapprice = dr["scrapprice"].ToString();
                getsubscrapobj.taxvalue = dr["taxvalue"].ToString();
                getsubscrapobj.freightamt = dr["freightamt"].ToString();
                getsubscrapobj.igst = dr["igst"].ToString();
                getsubscrapobj.cgst = dr["cgst"].ToString();
                getsubscrapobj.sgst = dr["sgst"].ToString();
                getsubscrapobj.igstvalue = igstvalue.ToString();
                getsubscrapobj.cgstvalue = cgstvalue.ToString();
                getsubscrapobj.sgstvalue = sgstvalue.ToString();
                getsubscrapobj.totalvalue = totalvalue.ToString();
                gerSubScrapSalesDetailslist.Add(getsubscrapobj);
            }
            getScrapSales getScrapSalesOBJ = new getScrapSales();
            getScrapSalesOBJ.ScrapSalesDetails = getScrapSalesDetailslist;
            getScrapSalesOBJ.SubScrapSalesDetails = gerSubScrapSalesDetailslist;
            getscraplist.Add(getScrapSalesOBJ);
            string response = GetJson(getscraplist);
            context.Response.Write(response);
        }
        catch
        {
        }
    }
    private void get_scrapsales_details_Report(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string fromdate = context.Request["fromdate"];
            string todate = context.Request["todate"];
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT  suppliersdetails.name,  scrapitemdetails.branchid, scrapsales.transportname, scrapsales.invoicetype, scrapsales.status, scrapsales.vehicleno, scrapsales.invoiceno, scrapsales.invoicedate, scrapsales.remarks,scrapsales.branchid AS Expr1, scrapsales.entryby, scrapsales.doe, subscrapsales.sales_refno,subscrapsales.taxvalue, subscrapsales.freightamt, subscrapsales.taxtype, subscrapsales.doe AS Expr3, scrapsales.sno, branchmaster.branchname FROM scrapsales INNER JOIN subscrapsales ON scrapsales.sno = subscrapsales.sales_refno INNER JOIN scrapitemdetails ON subscrapsales.productid = scrapitemdetails.sno INNER JOIN suppliersdetails ON scrapsales.supplierid = suppliersdetails.supplierid INNER JOIN uimmaster ON scrapitemdetails.uom = uimmaster.sno INNER JOIN branchmaster ON scrapsales.branchid = branchmaster.branchid WHERE (scrapsales.branchid = @branchid) AND (scrapsales.invoicedate between @d1 and @d2)");
            cmd.Parameters.Add("@d1", fromdate);
            cmd.Parameters.Add("@d2", todate);
            cmd.Parameters.Add("@branchid", branchid);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(routes);
            DataTable dtpo = view.ToTable(true, "name", "sno", "branchid", "transportname", "invoicetype", "status", "vehicleno", "invoiceno", "invoicedate", "remarks", "branchname");
            List<ScrapSalesDetails> getScrapSalesDetailslist = new List<ScrapSalesDetails>();
            foreach (DataRow dr in dtpo.Rows)
            {
                ScrapSalesDetails getscrapobj = new ScrapSalesDetails();
                getscrapobj.suppliername = dr["name"].ToString();
                getscrapobj.invoicedate = ((DateTime)dr["invoicedate"]).ToString("dd-MM-yyyy"); //dr["podate"].ToString();
                getscrapobj.transportname = dr["transportname"].ToString();
                getscrapobj.branchname = dr["branchname"].ToString();
                getscrapobj.invoicetype = dr["invoicetype"].ToString();
                getscrapobj.invoiceno = dr["invoiceno"].ToString();
                getscrapobj.remarks = dr["remarks"].ToString();
                getscrapobj.sno = dr["sno"].ToString();
                getScrapSalesDetailslist.Add(getscrapobj);
            }
            string response = GetJson(getScrapSalesDetailslist);
            context.Response.Write(response);
        }
        catch
        {
        }
    }

    public class Materialdetails
    {
        public string sno { get; set; }
        public string productname { get; set; }
        public string price { get; set; }
        public string qty { get; set; }
        public string totalcost { get; set; }
        public string doe { get; set; }
        public string productid { get; set; }
        public string hdnproductsno { get; set; }
        public string subsno { get; set; }
        public string sm_refno { get; set; }
    }
    public class scrapmaterialdetails
    {
        public string sectionname { get; set; }
        public string sectionid { get; set; }
        public string remarks { get; set; }
        public string name { get; set; }
        public string branchid { get; set; }
        public string entryby { get; set; }
        public string btnval { get; set; }
        public string doe { get; set; }
        public string sno { get; set; }
        public List<Materialdetails> scrmaterial_array { get; set; }
    }
    public class get_scrap_material
    {
        public List<scrapmaterialdetails> material { get; set; }
        public List<Materialdetails> submaterial { get; set; }
    }
    private void save_scrap_Material_click(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            var js = new JavaScriptSerializer();
            var title1 = context.Request.Params[1];
            scrapmaterialdetails obj = js.Deserialize<scrapmaterialdetails>(title1);
            string entryby = context.Session["Employ_Sno"].ToString();
            string branchid = context.Session["Po_BranchID"].ToString();
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string sectionname = obj.sectionname;
            string remarks = obj.remarks;
            string name = obj.name;
            string sno = obj.sno;
            string btnval = obj.btnval;
            if (btnval == "save")
            {
                cmd = new SqlCommand("insert into scrapmaterial(sectionid,name,doe,remarks,entry_by,branchid) values(@sectionid,@name,@doe,@remarks,@entry_by,@branchid)");
                cmd.Parameters.Add("@sectionid", sectionname);
                cmd.Parameters.Add("@name", name);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@remarks", remarks);
                cmd.Parameters.Add("@entry_by", entryby);
                cmd.Parameters.Add("@branchid", branchid);
                vdm.insert(cmd);
                cmd = new SqlCommand("select MAX(sno) as smateralsno  from scrapmaterial");
                DataTable dtsales = vdm.SelectQuery(cmd).Tables[0];
                string smatrefno = dtsales.Rows[0]["smateralsno"].ToString();
                foreach (Materialdetails si in obj.scrmaterial_array)
                {
                    if (si.hdnproductsno != "0")
                    {
                        cmd = new SqlCommand("insert into subscrapmaterial(productid,qty,branchid,entry_by,doe,sm_refno) values(@productid,@qty,@branchid,@entry_by,@doe,@sno)");
                        cmd.Parameters.Add("@productid", si.hdnproductsno);
                        cmd.Parameters.Add("@qty", si.qty);
                        cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                        cmd.Parameters.Add("@entry_by", entryby);
                        cmd.Parameters.Add("@branchid", branchid);
                        cmd.Parameters.Add("@sno", smatrefno);
                        vdm.insert(cmd);
                    }
                }
                string msg = "successfully Inserted";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {
                cmd = new SqlCommand("update scrapmaterial set sectionid=@sectionid,name=@name,doe=@doe,remarks=@remarks,entry_by=@entry_by,branchid=@branchid where sno=@sno and branchid=@branchid");
                cmd.Parameters.Add("@sectionid", sectionname);
                cmd.Parameters.Add("@name", name);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@remarks", remarks);
                cmd.Parameters.Add("@entry_by", entryby);
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@sno", sno);

                vdm.Update(cmd);
                foreach (Materialdetails si in obj.scrmaterial_array)
                {
                    cmd = new SqlCommand("update subscrapmaterial set productid=@productid, qty=@qty where sm_refno=@sm_refno and sno=@sno and branchid=@branchid");
                    cmd.Parameters.Add("@productid", si.hdnproductsno);
                    cmd.Parameters.Add("@qty", si.qty);
                    cmd.Parameters.Add("@sm_refno", sno);
                    cmd.Parameters.Add("@sno", si.subsno);
                    cmd.Parameters.Add("@branchid", branchid);
                    vdm.Update(cmd);
                }
                string msg = "successfully updated ";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    private void get_scrap_material_details(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT scrapmaterial.sectionid, scrapmaterial.sno, scrapmaterial.name, scrapmaterial.doe, scrapmaterial.remarks, scrapmaterial.entry_by, scrapmaterial.branchid, subscrapmaterial.productid, subscrapmaterial.sno AS subsno, subscrapmaterial.sm_refno, subscrapmaterial.qty, sectionmaster.name AS sectionname, scrapitemdetails.itemname FROM  subscrapmaterial INNER JOIN scrapmaterial ON subscrapmaterial.sm_refno = scrapmaterial.sno INNER JOIN sectionmaster ON scrapmaterial.sectionid = sectionmaster.sectionid INNER JOIN scrapitemdetails ON subscrapmaterial.productid = scrapitemdetails.sno WHERE (scrapmaterial.branchid = @branchid)");
            cmd.Parameters.Add("@branchid", branchid);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(routes);
            DataTable dtmateria = view.ToTable(true, "sno", "sectionid", "name", "entry_by", "doe", "remarks", "branchid", "sectionname");
            DataTable dtsubmateria = view.ToTable(true, "subsno", "productid", "sm_refno", "itemname", "qty");
            List<get_scrap_material> getscrapmateriallst = new List<get_scrap_material>();
            List<scrapmaterialdetails> scrapmateriallst = new List<scrapmaterialdetails>();
            List<Materialdetails> subMateriallst = new List<Materialdetails>();

            foreach (DataRow dr in dtmateria.Rows)
            {
                scrapmaterialdetails materialsobj = new scrapmaterialdetails();
                materialsobj.doe = ((DateTime)dr["doe"]).ToString("yyyy-MM-dd");//dr["inwarddate"].ToString();
                materialsobj.name = dr["name"].ToString();
                materialsobj.sectionid = dr["sectionid"].ToString();
                materialsobj.entryby = dr["entry_by"].ToString();
                materialsobj.sno = dr["sno"].ToString();
                materialsobj.sectionname = dr["sectionname"].ToString();
                materialsobj.branchid = dr["branchid"].ToString();
                materialsobj.remarks = dr["remarks"].ToString();
                scrapmateriallst.Add(materialsobj);
            }
            foreach (DataRow dr in dtsubmateria.Rows)
            {
                Materialdetails submaterialobj = new Materialdetails();
                submaterialobj.hdnproductsno = dr["productid"].ToString();
                submaterialobj.productname = dr["itemname"].ToString();
                double quantity = Convert.ToDouble(dr["qty"].ToString());
                quantity = Math.Round(quantity, 2);
                submaterialobj.qty = quantity.ToString();
                submaterialobj.subsno = dr["subsno"].ToString();
                submaterialobj.sm_refno = dr["sm_refno"].ToString();
                subMateriallst.Add(submaterialobj);
            }
            get_scrap_material getscrapmaterialobj = new get_scrap_material();
            getscrapmaterialobj.material = scrapmateriallst;
            getscrapmaterialobj.submaterial = subMateriallst;
            getscrapmateriallst.Add(getscrapmaterialobj);
            string response = GetJson(getscrapmateriallst);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_scrap_sales_details(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT scrapsales.sno, suppliersdetails.name, scrapitemdetails.itemname, subscrapsales.sno AS subsno, subscrapsales.productid, subscrapsales.qty, subscrapsales.price, subscrapsales.sales_refno, scrapsales.supplierid, scrapsales.transportname, scrapsales.invoicetype, scrapsales.status, scrapsales.vehicleno, scrapsales.invoiceno, scrapsales.invoicedate, scrapsales.remarks, scrapsales.branchid, scrapsales.entryby, scrapsales.doe AS maindoe, subscrapsales.taxtype, subscrapsales.taxvalue, subscrapsales.freightamt FROM subscrapsales INNER JOIN scrapsales ON subscrapsales.sales_refno = scrapsales.sno INNER JOIN scrapitemdetails ON subscrapsales.productid = scrapitemdetails.sno INNER JOIN suppliersdetails ON scrapsales.supplierid = suppliersdetails.supplierid WHERE (scrapsales.branchid = @branchid)");
            cmd.Parameters.Add("@branchid", branchid);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(routes);
            DataTable dtSales = view.ToTable(true, "sno", "name", "maindoe", "branchid", "entryby", "invoiceno", "invoicedate", "vehicleno", "status", "supplierid", "invoicetype", "transportname", "remarks");
            DataTable dtsubSales = view.ToTable(true, "subsno", "productid", "sales_refno", "itemname", "qty", "taxtype", "taxvalue", "freightamt", "price");
            List<getScrapSales> getScrapSaleslist = new List<getScrapSales>();
            List<ScrapSalesDetails> scrapsalesdetailslist = new List<ScrapSalesDetails>();
            List<SubScrapSalesDetails> subscrapsalesdetailslist = new List<SubScrapSalesDetails>();
            foreach (DataRow dr in dtSales.Rows)
            {
                ScrapSalesDetails scrapsalesobj = new ScrapSalesDetails();
                scrapsalesobj.doe = ((DateTime)dr["maindoe"]).ToString("yyyy-MM-dd");//dr["inwarddate"].ToString();
                scrapsalesobj.suppliername = dr["name"].ToString();
                scrapsalesobj.invoicedate = ((DateTime)dr["invoicedate"]).ToString("dd-MM-yyyy");//dr["invoicedate"].ToString();
                scrapsalesobj.transportname = dr["transportname"].ToString();
                scrapsalesobj.entryby = dr["entryby"].ToString();
                scrapsalesobj.sno = dr["sno"].ToString();
                scrapsalesobj.vehicleno = dr["vehicleno"].ToString();
                scrapsalesobj.status = dr["status"].ToString();
                scrapsalesobj.hiddensupplyid = dr["supplierid"].ToString();
                scrapsalesobj.invoicetype = dr["invoicetype"].ToString();
                scrapsalesobj.remarks = dr["remarks"].ToString();
                scrapsalesobj.invoiceno = dr["invoiceno"].ToString();
                scrapsalesdetailslist.Add(scrapsalesobj);
            }
            foreach (DataRow dr in dtsubSales.Rows)
            {
                SubScrapSalesDetails subscrapsalesobj = new SubScrapSalesDetails();
                subscrapsalesobj.hdnproductsno = dr["productid"].ToString();
                subscrapsalesobj.productname = dr["itemname"].ToString();
                double quantity = Convert.ToDouble(dr["qty"].ToString());
                quantity = Math.Round(quantity, 2);
                subscrapsalesobj.qty = quantity.ToString();
                subscrapsalesobj.cost = dr["price"].ToString();
                subscrapsalesobj.taxtype = dr["taxtype"].ToString();
                subscrapsalesobj.taxvalue = dr["taxvalue"].ToString();
                subscrapsalesobj.freightamt = dr["freightamt"].ToString();
                subscrapsalesobj.subsno = dr["subsno"].ToString();
                subscrapsalesobj.sales_refno = dr["sales_refno"].ToString();
                subscrapsalesdetailslist.Add(subscrapsalesobj);
            }
            getScrapSales getScrapSalesobj = new getScrapSales();
            getScrapSalesobj.ScrapSalesDetails = scrapsalesdetailslist;
            getScrapSalesobj.SubScrapSalesDetails = subscrapsalesdetailslist;
            getScrapSaleslist.Add(getScrapSalesobj);
            string response = GetJson(getScrapSaleslist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_purchase_order_details_click(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string julydt = "07/01/2017";
            string fromstate = "";
            DateTime gst_dt = Convert.ToDateTime(julydt);
            string PoRefNo = context.Request["refdcno"];
            string PoRefNo1 = context.Request["refdcno1"];
            string branchid = context.Session["Po_BranchID"].ToString();
            string Add_ress = context.Session["Address"].ToString();
            string session_gstin = context.Session["gstin"].ToString();
            cmd = new SqlCommand("SELECT statemaster.statename, branchmaster.branchname FROM  branchmaster  INNER JOIN  statemaster ON branchmaster.statename = statemaster.sno where branchmaster.branchid=@bid");
            cmd.Parameters.Add("@bid", branchid);
            DataTable dtfrombranch = vdm.SelectQuery(cmd).Tables[0];
            if (dtfrombranch.Rows.Count > 0)
            {
                fromstate = dtfrombranch.Rows[0]["statename"].ToString();
            }

            vdm = new SalesDBManager();
            if (PoRefNo != null)
            {
                cmd = new SqlCommand("SELECT taxmaster.type, statemaster.statename, po_entrydetailes.branchid,po_entrydetailes.reversecharge,suppliersdetails.stateid,productmaster.HSNcode,po_sub_detailes.igst,po_sub_detailes.cgst,po_sub_detailes.sgst,po_entrydetailes.transportcharge,po_entrydetailes.addressid,suppliersdetails.description AS SupplierRemarks,productmaster.description AS productdescription, po_entrydetailes.pricebasis, po_entrydetailes.ponumber, po_entrydetailes.pfid, pandf.pandf AS pf, suppliersdetails.warrantytype,po_sub_detailes.edtax, po_sub_detailes.code, suppliersdetails.insuranceamount, paymentmaster.paymenttype, deliveryterms.deliveryterms AS terms, productmaster.productname, uimmaster.uim, suppliersdetails.insurance, po_entrydetailes.quotationno, po_entrydetailes.remarks, suppliersdetails.warranty, po_entrydetailes.quotationdate, po_entrydetailes.shortname, po_entrydetailes.podate, po_entrydetailes.poamount, po_entrydetailes.name, po_entrydetailes.delivarydate, po_entrydetailes.freigtamt, suppliersdetails.mobileno, suppliersdetails.phoneno, suppliersdetails.emailid, suppliersdetails.zipcode AS TinNo, suppliersdetails.GSTIN, po_sub_detailes.qty, po_sub_detailes.description, po_sub_detailes.sno, po_sub_detailes.free, po_sub_detailes.cost, po_sub_detailes.taxtype, po_sub_detailes.ed, po_sub_detailes.dis, po_sub_detailes.disamt, po_sub_detailes.po_refno, po_sub_detailes.tax,suppliersdetails.street1, suppliersdetails.city, suppliersdetails.state, suppliersdetails.country, suppliersdetails.zipcode, suppliersdetails.contactnumber, po_entrydetailes.billaddressid, addressdetails.address AS deliveryaddress, addressdetails_1.address AS billingaddress FROM po_entrydetailes INNER JOIN po_sub_detailes ON po_entrydetailes.sno = po_sub_detailes.po_refno INNER JOIN productmaster ON po_sub_detailes.productsno = productmaster.productid INNER JOIN suppliersdetails ON po_entrydetailes.supplierid = suppliersdetails.supplierid INNER JOIN deliveryterms ON deliveryterms.sno = po_entrydetailes.deliverytermsid INNER JOIN paymentmaster ON paymentmaster.sno = po_entrydetailes.paymentid LEFT OUTER JOIN addressdetails ON po_entrydetailes.addressid = addressdetails.sno LEFT OUTER JOIN addressdetails AS addressdetails_1 ON po_entrydetailes.billaddressid = addressdetails_1.sno LEFT OUTER JOIN  pandf ON pandf.sno = po_entrydetailes.pfid LEFT OUTER JOIN uimmaster ON uimmaster.sno = productmaster.uim LEFT OUTER JOIN taxmaster ON po_sub_detailes.taxtype = taxmaster.sno LEFT OUTER JOIN statemaster ON suppliersdetails.stateid = statemaster.sno WHERE (po_entrydetailes.sno = @PoRefNo) AND (po_entrydetailes.branchid = @branchid) and (po_sub_detailes.qty > 0)");
                cmd.Parameters.Add("@PoRefNo", PoRefNo);
                cmd.Parameters.Add("@branchid", branchid);
            }
            else
            {
                cmd = new SqlCommand("SELECT taxmaster.type, statemaster.statename, po_entrydetailes.branchid,po_entrydetailes.reversecharge,suppliersdetails.state,productmaster.HSNcode,po_sub_detailes.igst,po_sub_detailes.cgst,po_sub_detailes.sgst,po_entrydetailes.transportcharge,po_entrydetailes.addressid,suppliersdetails.description AS SupplierRemarks,productmaster.description AS productdescription, po_entrydetailes.pricebasis, po_entrydetailes.ponumber, po_entrydetailes.pfid, pandf.pandf AS pf, suppliersdetails.warrantytype,po_sub_detailes.edtax, po_sub_detailes.code, suppliersdetails.insuranceamount, paymentmaster.paymenttype, deliveryterms.deliveryterms AS terms, productmaster.productname, uimmaster.uim, suppliersdetails.insurance, po_entrydetailes.quotationno, po_entrydetailes.remarks, suppliersdetails.warranty, po_entrydetailes.quotationdate, po_entrydetailes.shortname, po_entrydetailes.podate, po_entrydetailes.poamount, po_entrydetailes.name, po_entrydetailes.delivarydate, po_entrydetailes.freigtamt, suppliersdetails.mobileno, suppliersdetails.phoneno, suppliersdetails.emailid, suppliersdetails.zipcode AS TinNo, suppliersdetails.GSTIN, po_sub_detailes.qty, po_sub_detailes.description, po_sub_detailes.sno, po_sub_detailes.free, po_sub_detailes.cost, po_sub_detailes.taxtype, po_sub_detailes.ed, po_sub_detailes.dis, po_sub_detailes.disamt, po_sub_detailes.po_refno, po_sub_detailes.tax,suppliersdetails.street1, suppliersdetails.city, suppliersdetails.state, suppliersdetails.country, suppliersdetails.zipcode, suppliersdetails.contactnumber, po_entrydetailes.billaddressid, addressdetails.address AS deliveryaddress, addressdetails_1.address AS billingaddress FROM po_entrydetailes INNER JOIN po_sub_detailes ON po_entrydetailes.sno = po_sub_detailes.po_refno INNER JOIN productmaster ON po_sub_detailes.productsno = productmaster.productid INNER JOIN suppliersdetails ON po_entrydetailes.supplierid = suppliersdetails.supplierid INNER JOIN deliveryterms ON deliveryterms.sno = po_entrydetailes.deliverytermsid INNER JOIN paymentmaster ON paymentmaster.sno = po_entrydetailes.paymentid LEFT OUTER JOIN addressdetails ON po_entrydetailes.addressid = addressdetails.sno LEFT OUTER JOIN addressdetails AS addressdetails_1 ON po_entrydetailes.billaddressid = addressdetails_1.sno LEFT OUTER JOIN  pandf ON pandf.sno = po_entrydetailes.pfid LEFT OUTER JOIN uimmaster ON uimmaster.sno = productmaster.uim LEFT OUTER JOIN taxmaster ON po_sub_detailes.taxtype = taxmaster.sno LEFT OUTER JOIN statemaster ON suppliersdetails.stateid = statemaster.sno  WHERE (po_entrydetailes.sno = @PoRefNo) AND (po_entrydetailes.branchid = @branchid) and (po_sub_detailes.qty > 0)");// INNER JOIN branchmaster on branchmaster.branchid = po_entrydetailes.branchid
                cmd.Parameters.Add("@PoRefNo", PoRefNo1);
                cmd.Parameters.Add("@branchid", branchid);
            }
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(routes);
            DataTable dtpo = view.ToTable(true, "reversecharge", "branchid", "deliveryaddress", "billingaddress", "ponumber", "warranty", "statename", "remarks", "pricebasis", "contactnumber", "warrantytype", "insuranceamount", "po_refno", "terms", "paymenttype", "quotationno", "quotationdate", "insurance", "street1", "city", "shortname", "podate", "poamount", "name", "delivarydate", "mobileno", "phoneno", "emailid", "TinNo", "GSTIN");
            DataTable dtpurchase_subdetails = view.ToTable(true, "transportcharge", "freigtamt", "HSNcode", "pfid", "pf", "sno", "productdescription", "productname", "code", "uim", "description", "podate", "qty", "free", "cost", "ed", "edtax", "taxtype", "dis", "disamt", "tax", "type", "igst", "cgst", "sgst", "po_refno");
            List<get_purchase> purchasedetails = new List<get_purchase>();
            List<podetails> po_lst = new List<podetails>();
            List<subpurchasedetails> purchase_sub_list = new List<subpurchasedetails>();
            string branch_id = dtpo.Rows[0]["branchid"].ToString();
            cmd = new SqlCommand("select branchmaster.branchname,branchmaster.address,branchmaster.phone,branchmaster.emailid,branchmaster.GSTIN,statemaster.statename from branchmaster INNER JOIN statemaster ON statemaster.sno=branchmaster.statename WHERE branchmaster.branchid=@branchid");
            cmd.Parameters.Add("@branchid", branch_id);
            DataTable dt_branch = vdm.SelectQuery(cmd).Tables[0];
            string frombranchname = dt_branch.Rows[0]["branchname"].ToString();
            string frombranchaddress = dt_branch.Rows[0]["address"].ToString();
            string frombranchphone = dt_branch.Rows[0]["phone"].ToString();
            string frombranchemail = dt_branch.Rows[0]["emailid"].ToString();
            string frombranchgstin = dt_branch.Rows[0]["GSTIN"].ToString();
            string frombranchstate = dt_branch.Rows[0]["statename"].ToString();
            foreach (DataRow dr in dtpo.Rows)
            {
                podetails getpurchasedetails = new podetails();

                getpurchasedetails.pricebasis = dr["pricebasis"].ToString();
                getpurchasedetails.deliveryaddress = dr["deliveryaddress"].ToString();
                getpurchasedetails.warranytype = dr["warrantytype"].ToString();
                getpurchasedetails.warranty = dr["warranty"].ToString();
                getpurchasedetails.billingaddress = dr["billingaddress"].ToString();
                getpurchasedetails.shortname = dr["shortname"].ToString();
                getpurchasedetails.podate = ((DateTime)dr["podate"]).ToString("dd/MM/yyyy"); //dr["podate"].ToString();
                getpurchasedetails.poamount = dr["poamount"].ToString();
                getpurchasedetails.name = dr["name"].ToString();
                string address = dr["street1"].ToString() + "," + dr["city"].ToString();
                getpurchasedetails.delivarydate = ((DateTime)dr["delivarydate"]).ToString("dd/MM/yyyy"); //dr["delivarrydate"].ToString();
                getpurchasedetails.fromstate = fromstate.ToString();
                getpurchasedetails.mobile = dr["mobileno"].ToString();
                getpurchasedetails.telphone = dr["phoneno"].ToString();
                getpurchasedetails.email = dr["emailid"].ToString();
                getpurchasedetails.contactnumber = dr["contactnumber"].ToString();
                getpurchasedetails.payment = dr["paymenttype"].ToString();
                getpurchasedetails.terms = dr["terms"].ToString();
                getpurchasedetails.insuranceamount = dr["insuranceamount"].ToString();
                getpurchasedetails.SupplierRemarks = dr["remarks"].ToString();
                getpurchasedetails.insurence = dr["insurance"].ToString();
                getpurchasedetails.vattin = dr["TinNo"].ToString();
                getpurchasedetails.pono = dr["po_refno"].ToString();
                getpurchasedetails.ponumber = dr["ponumber"].ToString();
                getpurchasedetails.address = address;
                getpurchasedetails.Add_ress = Add_ress;
                getpurchasedetails.supplierstate = dr["statename"].ToString();
                getpurchasedetails.suppliergstin = dr["GSTIN"].ToString();
                getpurchasedetails.quotationno = dr["quotationno"].ToString();
                getpurchasedetails.quotationdate = ((DateTime)dr["quotationdate"]).ToString("dd/MM/yyyy");
                getpurchasedetails.session_gstin = session_gstin;
                getpurchasedetails.rev_chrg = dr["reversecharge"].ToString();
                getpurchasedetails.branchname = frombranchname;
                getpurchasedetails.branchaddress = frombranchaddress;
                getpurchasedetails.branchphone = frombranchphone;
                getpurchasedetails.branchemail = frombranchemail;
                getpurchasedetails.branchgstin = frombranchgstin;
                getpurchasedetails.branchstate = frombranchstate;
                po_lst.Add(getpurchasedetails);
            }
            foreach (DataRow dr in dtpurchase_subdetails.Rows)
            {
                subpurchasedetails getroutes = new subpurchasedetails();
                string podate1 = ((DateTime)dr["podate"]).ToString();
                //string podate1 = "7/17/2017 12:00:00 AM";
                DateTime podate = Convert.ToDateTime(podate1);
                if (podate < gst_dt)
                {
                    getroutes.ed = dr["ed"].ToString();
                    getroutes.taxtype = dr["type"].ToString();
                    getroutes.tax = dr["tax"].ToString();
                    getroutes.edtax = dr["edtax"].ToString();
                    getroutes.gst_exists = "0";
                }
                else
                {
                    getroutes.sgst_per = dr["sgst"].ToString();
                    getroutes.cgst_per = dr["cgst"].ToString();
                    getroutes.igst_per = dr["igst"].ToString();
                    getroutes.hsn_code = dr["HSNcode"].ToString();
                    getroutes.gst_exists = "1";
                }
                getroutes.code = dr["code"].ToString();
                getroutes.productdescription = dr["productdescription"].ToString();
                getroutes.uim = dr["uim"].ToString();
                getroutes.sno = dr["sno"].ToString();
                getroutes.description = dr["description"].ToString();
                getroutes.qty = dr["qty"].ToString();
                getroutes.free = dr["free"].ToString();
                getroutes.cost = dr["cost"].ToString();
                getroutes.dis = dr["dis"].ToString();
                getroutes.pfid = dr["pfid"].ToString();
                getroutes.pfamount = dr["pf"].ToString();
                getroutes.disamt = dr["disamt"].ToString();
                getroutes.pono = dr["po_refno"].ToString();
                getroutes.freigntamt = dr["freigtamt"].ToString();
                getroutes.transcharge = dr["transportcharge"].ToString();
                purchase_sub_list.Add(getroutes);
            }
            get_purchase get_purchases = new get_purchase();
            get_purchases.podetails = po_lst;
            get_purchases.subpurchasedetails = purchase_sub_list;
            purchasedetails.Add(get_purchases);
            string response = GetJson(purchasedetails);
            context.Response.Write(response);
        }
        catch
        {
        }
    }

    private void get_purchaseINVOCE_order_details_click(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string PoRefNo = context.Request["refdcno"];
            string PoRefNo1 = context.Request["refdcno1"];
            string branchid = context.Session["Po_BranchID"].ToString();
            string Add_ress = context.Session["Address"].ToString();
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            vdm = new SalesDBManager();
            int currentmonth = ServerDateCurrentdate.Month;
            int nextyear = ServerDateCurrentdate.Year + 1;
            string dt = "6/30/2017";
            DateTime dtjune = Convert.ToDateTime(dt);
            if (PoRefNo != "")
            {
                cmd = new SqlCommand("SELECT po_entrydetailes.transportcharge,po_entrydetailes.addressid,suppliersdetails.description AS SupplierRemarks,productmaster.description AS productdescription, po_entrydetailes.pricebasis, po_entrydetailes.ponumber, po_entrydetailes.pfid, pandf.pandf AS pf, suppliersdetails.warrantytype,po_sub_detailes.edtax, po_sub_detailes.code, suppliersdetails.insuranceamount, paymentmaster.paymenttype, deliveryterms.deliveryterms AS terms, productmaster.productname, uimmaster.uim, suppliersdetails.insurance, po_entrydetailes.quotationno, po_entrydetailes.remarks, suppliersdetails.warranty, po_entrydetailes.quotationdate, po_entrydetailes.shortname, po_entrydetailes.podate, po_entrydetailes.poamount, po_entrydetailes.name, po_entrydetailes.delivarydate, po_entrydetailes.freigtamt, suppliersdetails.mobileno, suppliersdetails.phoneno, suppliersdetails.emailid, suppliersdetails.zipcode AS TinNo, po_sub_detailes.qty, po_sub_detailes.description, po_sub_detailes.sno, po_sub_detailes.free, po_sub_detailes.cost, po_sub_detailes.taxtype, po_sub_detailes.ed, po_sub_detailes.dis, po_sub_detailes.disamt, po_sub_detailes.po_refno, po_sub_detailes.tax,suppliersdetails.street1, suppliersdetails.city, suppliersdetails.state, suppliersdetails.country, suppliersdetails.zipcode, suppliersdetails.contactnumber, po_entrydetailes.billaddressid, addressdetails.address AS deliveryaddress, addressdetails_1.address AS billingaddress FROM po_entrydetailes INNER JOIN po_sub_detailes ON po_entrydetailes.sno = po_sub_detailes.po_refno INNER JOIN productmaster ON po_sub_detailes.productsno = productmaster.productid INNER JOIN suppliersdetails ON po_entrydetailes.supplierid = suppliersdetails.supplierid INNER JOIN deliveryterms ON deliveryterms.sno = po_entrydetailes.deliverytermsid INNER JOIN paymentmaster ON paymentmaster.sno = po_entrydetailes.paymentid LEFT OUTER JOIN addressdetails ON po_entrydetailes.addressid = addressdetails.sno LEFT OUTER JOIN addressdetails AS addressdetails_1 ON po_entrydetailes.billaddressid = addressdetails_1.sno LEFT OUTER JOIN  pandf ON pandf.sno = po_entrydetailes.pfid LEFT OUTER JOIN uimmaster ON uimmaster.sno = productmaster.uim WHERE (po_entrydetailes.sno = @PoRefNo) AND (po_entrydetailes.branchid = @branchid) and (po_sub_detailes.qty > 0)");
                cmd.Parameters.Add("@PoRefNo", PoRefNo);
                cmd.Parameters.Add("@branchid", branchid);
            }
            else
            {
                cmd = new SqlCommand("SELECT po_entrydetailes.transportcharge,po_entrydetailes.addressid,suppliersdetails.description AS SupplierRemarks,productmaster.description AS productdescription, po_entrydetailes.pricebasis, po_entrydetailes.ponumber, po_entrydetailes.pfid, pandf.pandf AS pf, suppliersdetails.warrantytype,po_sub_detailes.edtax, po_sub_detailes.code, suppliersdetails.insuranceamount, paymentmaster.paymenttype, deliveryterms.deliveryterms AS terms, productmaster.productname, uimmaster.uim, suppliersdetails.insurance, po_entrydetailes.quotationno, po_entrydetailes.remarks, suppliersdetails.warranty, po_entrydetailes.quotationdate, po_entrydetailes.shortname, po_entrydetailes.podate, po_entrydetailes.poamount, po_entrydetailes.name, po_entrydetailes.delivarydate, po_entrydetailes.freigtamt, suppliersdetails.mobileno, suppliersdetails.phoneno, suppliersdetails.emailid, suppliersdetails.zipcode AS TinNo, po_sub_detailes.qty, po_sub_detailes.description, po_sub_detailes.sno, po_sub_detailes.free, po_sub_detailes.cost, po_sub_detailes.taxtype, po_sub_detailes.ed, po_sub_detailes.dis, po_sub_detailes.disamt, po_sub_detailes.po_refno, po_sub_detailes.tax,suppliersdetails.street1, suppliersdetails.city, suppliersdetails.state, suppliersdetails.country, suppliersdetails.zipcode, suppliersdetails.contactnumber, po_entrydetailes.billaddressid, addressdetails.address AS deliveryaddress, addressdetails_1.address AS billingaddress FROM po_entrydetailes INNER JOIN po_sub_detailes ON po_entrydetailes.sno = po_sub_detailes.po_refno INNER JOIN productmaster ON po_sub_detailes.productsno = productmaster.productid INNER JOIN suppliersdetails ON po_entrydetailes.supplierid = suppliersdetails.supplierid INNER JOIN deliveryterms ON deliveryterms.sno = po_entrydetailes.deliverytermsid INNER JOIN paymentmaster ON paymentmaster.sno = po_entrydetailes.paymentid LEFT OUTER JOIN addressdetails ON po_entrydetailes.addressid = addressdetails.sno LEFT OUTER JOIN addressdetails AS addressdetails_1 ON po_entrydetailes.billaddressid = addressdetails_1.sno LEFT OUTER JOIN  pandf ON pandf.sno = po_entrydetailes.pfid LEFT OUTER JOIN uimmaster ON uimmaster.sno = productmaster.uim WHERE (po_entrydetailes.sno = @PoRefNo) AND (po_entrydetailes.branchid = @branchid) and (po_sub_detailes.qty > 0)");
                cmd.Parameters.Add("@PoRefNo", PoRefNo1);
                cmd.Parameters.Add("@branchid", branchid);
            }
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(routes);
            DataTable dtpo = view.ToTable(true, "deliveryaddress", "billingaddress", "ponumber", "warranty", "remarks", "pricebasis", "contactnumber", "warrantytype", "insuranceamount", "po_refno", "terms", "paymenttype", "quotationno", "quotationdate", "insurance", "street1", "city", "shortname", "podate", "poamount", "name", "delivarydate", "mobileno", "phoneno", "emailid", "TinNo");
            DataTable dtpurchase_subdetails = view.ToTable(true, "transportcharge", "freigtamt", "pfid", "pf", "sno", "productdescription", "productname", "code", "uim", "description", "qty", "free", "cost", "ed", "edtax", "taxtype", "dis", "disamt", "tax", "po_refno", "podate");
            List<get_purchase> purchasedetails = new List<get_purchase>();
            List<podetails> po_lst = new List<podetails>();
            List<subpurchasedetails> purchase_sub_list = new List<subpurchasedetails>();
            foreach (DataRow dr in dtpo.Rows)
            {
                podetails getpurchasedetails = new podetails();
                getpurchasedetails.pricebasis = dr["pricebasis"].ToString();
                getpurchasedetails.deliveryaddress = dr["deliveryaddress"].ToString();
                getpurchasedetails.warranytype = dr["warrantytype"].ToString();
                getpurchasedetails.warranty = dr["warranty"].ToString();
                getpurchasedetails.billingaddress = dr["billingaddress"].ToString();
                getpurchasedetails.shortname = dr["shortname"].ToString();
                getpurchasedetails.podate = ((DateTime)dr["podate"]).ToString("dd/MM/yyyy"); //dr["podate"].ToString();
                getpurchasedetails.poamount = dr["poamount"].ToString();
                getpurchasedetails.name = dr["name"].ToString();
                string address = dr["street1"].ToString() + "," + dr["city"].ToString();
                getpurchasedetails.delivarydate = ((DateTime)dr["delivarydate"]).ToString("dd/MM/yyyy"); //dr["delivarrydate"].ToString();

                getpurchasedetails.mobile = dr["mobileno"].ToString();
                getpurchasedetails.telphone = dr["phoneno"].ToString();
                getpurchasedetails.email = dr["emailid"].ToString();
                getpurchasedetails.contactnumber = dr["contactnumber"].ToString();
                getpurchasedetails.payment = dr["paymenttype"].ToString();
                getpurchasedetails.terms = dr["terms"].ToString();
                getpurchasedetails.insuranceamount = dr["insuranceamount"].ToString();
                getpurchasedetails.SupplierRemarks = dr["remarks"].ToString();
                getpurchasedetails.insurence = dr["insurance"].ToString();
                getpurchasedetails.vattin = dr["TinNo"].ToString();
                getpurchasedetails.pono = dr["po_refno"].ToString();
                getpurchasedetails.ponumber = dr["ponumber"].ToString();
                getpurchasedetails.address = address;
                getpurchasedetails.Add_ress = Add_ress;
                getpurchasedetails.quotationno = dr["quotationno"].ToString();
                getpurchasedetails.quotationdate = ((DateTime)dr["quotationdate"]).ToString("dd/MM/yyyy");
                po_lst.Add(getpurchasedetails);
            }
            foreach (DataRow dr in dtpurchase_subdetails.Rows)
            {
                subpurchasedetails getroutes = new subpurchasedetails();
                string podate = dr["podate"].ToString();
                //string podate = "07/01/2017";
                DateTime dtpodate = Convert.ToDateTime(podate);
                if (dtpodate > dtjune)
                {
                    getroutes.cgstpercentage = "2.5";
                    getroutes.sgstpercentage = "2.5";
                    getroutes.igstpercentage = "0";
                }
                else
                {
                    getroutes.taxtype = dr["taxtype"].ToString();
                    getroutes.tax = dr["tax"].ToString();
                    getroutes.ed = dr["ed"].ToString();
                    getroutes.edtax = dr["edtax"].ToString();
                }
                getroutes.code = dr["code"].ToString();
                getroutes.productdescription = dr["productdescription"].ToString();
                getroutes.uim = dr["uim"].ToString();
                getroutes.sno = dr["sno"].ToString();
                getroutes.description = dr["description"].ToString();
                getroutes.qty = dr["qty"].ToString();
                getroutes.free = dr["free"].ToString();
                getroutes.cost = dr["cost"].ToString();
                getroutes.dis = dr["dis"].ToString();
                getroutes.pfid = dr["pfid"].ToString();
                getroutes.pfamount = dr["pf"].ToString();
                getroutes.disamt = dr["disamt"].ToString();
                getroutes.pono = dr["po_refno"].ToString();
                getroutes.freigntamt = dr["freigtamt"].ToString();
                getroutes.transcharge = dr["transportcharge"].ToString();
                purchase_sub_list.Add(getroutes);
            }
            get_purchase get_purchases = new get_purchase();
            get_purchases.podetails = po_lst;
            get_purchases.subpurchasedetails = purchase_sub_list;
            purchasedetails.Add(get_purchases);
            string response = GetJson(purchasedetails);
            context.Response.Write(response);
        }
        catch
        {
        }
    }

    private void get_Sub_workOrder_click(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string julydt = "07/01/2017";
            DateTime gst_dt = Convert.ToDateTime(julydt);
            string PoRefNo = context.Request["refdcno"];
            string PoRefNo1 = context.Request["refdcno1"];
            string branchid = context.Session["Po_BranchID"].ToString();
            vdm = new SalesDBManager();
            if (PoRefNo != "")
            {
                cmd = new SqlCommand("SELECT branchmaster.branchname,branchmaster.phone,branchmaster.emailid as branch_emailid,statemaster.statename as sup_statename,branchmaster.address,branchmaster.GSTIN,productmaster.HSNcode,branchmaster.statename,suppliersdetails.stateid as sup_stateid,suppliersdetails.GSTIN as sup_gstin,productmaster.igst,productmaster.cgst,productmaster.sgst,workordersubdetails.services,workorderdetails.addressid,suppliersdetails.description AS SupplierRemarks,productmaster.description AS productdescription, workorderdetails.pricebasis, workorderdetails.ponumber, workorderdetails.pfid, pandf.pandf AS pf, suppliersdetails.warrantytype,workordersubdetails.edtax, workordersubdetails.code, suppliersdetails.insuranceamount, paymentmaster.paymenttype, deliveryterms.deliveryterms AS terms, productmaster.productname, uimmaster.uim, suppliersdetails.insurance, workorderdetails.quotationno, workorderdetails.remarks, suppliersdetails.warranty, workorderdetails.quotationdate, workorderdetails.shortname, workorderdetails.podate, workorderdetails.poamount, workorderdetails.name, workorderdetails.delivarydate, workorderdetails.freigtamt, suppliersdetails.mobileno, suppliersdetails.phoneno, suppliersdetails.emailid, suppliersdetails.zipcode AS TinNo, workordersubdetails.qty, workordersubdetails.description, workordersubdetails.sno, workordersubdetails.free, workordersubdetails.cost, workordersubdetails.taxtype, workordersubdetails.ed, workordersubdetails.dis, workordersubdetails.disamt, workordersubdetails.po_refno, workordersubdetails.tax,suppliersdetails.street1, suppliersdetails.city, suppliersdetails.state, suppliersdetails.country, suppliersdetails.zipcode, suppliersdetails.contactnumber, workorderdetails.billaddressid, addressdetails.address AS deliveryaddress, addressdetails_1.address AS billingaddress FROM workorderdetails INNER JOIN workordersubdetails ON workorderdetails.sno = workordersubdetails.po_refno INNER JOIN productmaster ON workordersubdetails.productsno = productmaster.productid INNER JOIN suppliersdetails ON workorderdetails.supplierid = suppliersdetails.supplierid INNER JOIN deliveryterms ON deliveryterms.sno = workorderdetails.deliverytermsid INNER JOIN paymentmaster ON paymentmaster.sno = workorderdetails.paymentid LEFT OUTER JOIN addressdetails ON workorderdetails.addressid = addressdetails.sno LEFT OUTER JOIN addressdetails AS addressdetails_1 ON workorderdetails.billaddressid = addressdetails_1.sno LEFT OUTER JOIN  pandf ON pandf.sno = workorderdetails.pfid LEFT OUTER JOIN uimmaster ON uimmaster.sno = productmaster.uim INNER JOIN branchmaster ON workorderdetails.branchid = branchmaster.branchid INNER JOIN statemaster ON suppliersdetails.stateid = statemaster.sno WHERE (workorderdetails.sno = @PoRefNo) AND (workorderdetails.branchid = @branchid)");
                cmd.Parameters.Add("@PoRefNo", PoRefNo);
                cmd.Parameters.Add("@branchid", branchid);
            }
            else
            {
                cmd = new SqlCommand("SELECT branchmaster.branchname,branchmaster.phone,branchmaster.emailid as branch_emailid,statemaster.statename as sup_statename,branchmaster.address,branchmaster.GSTIN,productmaster.HSNcode,branchmaster.statename,suppliersdetails.stateid as sup_stateid,suppliersdetails.GSTIN as sup_gstin,productmaster.igst,productmaster.cgst,productmaster.sgst,workordersubdetails.services,workorderdetails.addressid,suppliersdetails.description AS SupplierRemarks,productmaster.description AS productdescription, workorderdetails.pricebasis, workorderdetails.ponumber, workorderdetails.pfid, pandf.pandf AS pf, suppliersdetails.warrantytype,workordersubdetails.edtax, workordersubdetails.code, suppliersdetails.insuranceamount, paymentmaster.paymenttype, deliveryterms.deliveryterms AS terms, productmaster.productname, uimmaster.uim, suppliersdetails.insurance, workorderdetails.quotationno, workorderdetails.remarks, suppliersdetails.warranty, workorderdetails.quotationdate, workorderdetails.shortname, workorderdetails.podate, workorderdetails.poamount, workorderdetails.name, workorderdetails.delivarydate, workorderdetails.freigtamt, suppliersdetails.mobileno, suppliersdetails.phoneno, suppliersdetails.emailid, suppliersdetails.zipcode AS TinNo, po_sub_detailes.qty, workordersubdetails.description, workordersubdetails.sno, workordersubdetails.free, workordersubdetails.cost, workordersubdetails.taxtype, workordersubdetails.ed, workordersubdetails.dis, workordersubdetails.disamt, workordersubdetails.po_refno, workordersubdetails.tax,suppliersdetails.street1, suppliersdetails.city, suppliersdetails.state, suppliersdetails.country, suppliersdetails.zipcode, suppliersdetails.contactnumber, workorderdetails.billaddressid, addressdetails.address AS deliveryaddress, addressdetails_1.address AS billingaddress FROM workorderdetails INNER JOIN workordersubdetails ON workorderdetails.sno = workordersubdetails.po_refno INNER JOIN productmaster ON workordersubdetails.productsno = productmaster.productid INNER JOIN suppliersdetails ON workorderdetails.supplierid = suppliersdetails.supplierid INNER JOIN deliveryterms ON deliveryterms.sno = workorderdetails.deliverytermsid INNER JOIN paymentmaster ON paymentmaster.sno = workorderdetails.paymentid LEFT OUTER JOIN addressdetails ON workorderdetails.addressid = addressdetails.sno LEFT OUTER JOIN addressdetails AS addressdetails_1 ON workorderdetails.billaddressid = addressdetails_1.sno LEFT OUTER JOIN  pandf ON pandf.sno = workorderdetails.pfid LEFT OUTER JOIN uimmaster ON uimmaster.sno = productmaster.uim INNER JOIN branchmaster ON workorderdetails.branchid = branchmaster.branchid INNER JOIN statemaster ON suppliersdetails.stateid = statemaster.sno WHERE (workorderdetails.sno = @PoRefNo) AND (workorderdetails.branchid = @branchid)");
                cmd.Parameters.Add("@PoRefNo", PoRefNo1);
                cmd.Parameters.Add("@branchid", branchid);
            }
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(routes);
            DataTable dtworkorder = view.ToTable(true, "deliveryaddress", "branchname", "sup_gstin", "sup_statename", "branch_emailid", "phone", "address", "GSTIN", "statename", "sup_stateid", "billingaddress", "ponumber", "warranty", "SupplierRemarks", "pricebasis", "contactnumber", "warrantytype", "insuranceamount", "po_refno", "terms", "paymenttype", "quotationno", "quotationdate", "insurance", "street1", "city", "shortname", "podate", "poamount", "name", "delivarydate", "freigtamt", "mobileno", "phoneno", "emailid", "TinNo");
            DataTable dtsubworkorder = view.ToTable(true, "pfid", "services", "pf", "podate", "HSNcode", "sno", "igst", "cgst", "sgst", "productdescription", "productname", "code", "uim", "description", "qty", "free", "cost", "ed", "edtax", "taxtype", "dis", "disamt", "tax", "po_refno");
            List<get_workorder> get_workorder_List = new List<get_workorder>();
            List<workorder> workorder_lst = new List<workorder>();
            List<subworkorder> subworkorder_list = new List<subworkorder>();
            string supplier_stateid = "";
            string branch_stateid = "";
            cmd = new SqlCommand("select statename from statemaster where sno=@sno");
            cmd.Parameters.Add("@sno", dtworkorder.Rows[0]["statename"].ToString());
            DataTable dt_state = vdm.SelectQuery(cmd).Tables[0];
            string branch_statename = dt_state.Rows[0]["statename"].ToString();
            foreach (DataRow dr in dtworkorder.Rows)
            {
                workorder getworkorderdetails = new workorder();
                getworkorderdetails.branchname = dr["branchname"].ToString();
                getworkorderdetails.branch_phone = dr["phone"].ToString();
                getworkorderdetails.branch_emailid = dr["branch_emailid"].ToString();
                getworkorderdetails.branch_statename = branch_statename;
                getworkorderdetails.branch_address = dr["address"].ToString();
                getworkorderdetails.branch_gstin = dr["GSTIN"].ToString();
                getworkorderdetails.pricebasis = dr["pricebasis"].ToString();
                getworkorderdetails.deliveryaddress = dr["deliveryaddress"].ToString();
                getworkorderdetails.warranytype = dr["warrantytype"].ToString();
                getworkorderdetails.warranty = dr["warranty"].ToString();
                getworkorderdetails.billingaddress = dr["billingaddress"].ToString();
                getworkorderdetails.shortname = dr["shortname"].ToString();
                getworkorderdetails.podate = ((DateTime)dr["podate"]).ToString("dd/MM/yyyy"); //dr["podate"].ToString();
                getworkorderdetails.poamount = dr["poamount"].ToString();
                getworkorderdetails.name = dr["name"].ToString();
                string address = dr["street1"].ToString() + "," + dr["city"].ToString();
                getworkorderdetails.delivarydate = ((DateTime)dr["delivarydate"]).ToString("dd/MM/yyyy"); //dr["delivarrydate"].ToString();
                getworkorderdetails.freigntamt = dr["freigtamt"].ToString();
                getworkorderdetails.mobile = dr["mobileno"].ToString();
                getworkorderdetails.telphone = dr["phoneno"].ToString();
                getworkorderdetails.email = dr["emailid"].ToString();
                getworkorderdetails.contactnumber = dr["contactnumber"].ToString(); 
                getworkorderdetails.payment = dr["paymenttype"].ToString();
                getworkorderdetails.terms = dr["terms"].ToString();
                getworkorderdetails.insuranceamount = dr["insuranceamount"].ToString();
                getworkorderdetails.SupplierRemarks = dr["SupplierRemarks"].ToString();
                getworkorderdetails.insurence = dr["insurance"].ToString();
                getworkorderdetails.vattin = dr["TinNo"].ToString();
                getworkorderdetails.pono = dr["po_refno"].ToString();
                getworkorderdetails.ponumber = dr["ponumber"].ToString();
                getworkorderdetails.address = address;
                getworkorderdetails.quotationno = dr["quotationno"].ToString();
                getworkorderdetails.quotationdate = ((DateTime)dr["quotationdate"]).ToString("dd/MM/yyyy");
                supplier_stateid = dr["sup_stateid"].ToString();
                branch_stateid = dr["statename"].ToString();
                getworkorderdetails.sup_stateid = dr["sup_stateid"].ToString();
                getworkorderdetails.sup_gstin = dr["sup_gstin"].ToString();
                getworkorderdetails.sup_statename = dr["sup_statename"].ToString();
                workorder_lst.Add(getworkorderdetails);
            }
            foreach (DataRow dr in dtsubworkorder.Rows)
            {
                subworkorder getsubworkorder = new subworkorder();
                string podate1 = ((DateTime)dr["podate"]).ToString();
                //string podate1 = "7/17/2017 12:00:00 AM";
                DateTime podate = Convert.ToDateTime(podate1);
                if (podate < gst_dt)
                {
                    getsubworkorder.ed = dr["ed"].ToString();
                    getsubworkorder.edtax = dr["edtax"].ToString();
                    getsubworkorder.taxtype = dr["taxtype"].ToString();
                    getsubworkorder.tax = dr["tax"].ToString();
                    getsubworkorder.gst_exists = "0";
                }
                else
                {
                    if (branch_stateid == supplier_stateid)
                    {
                        getsubworkorder.sgst = dr["sgst"].ToString();
                        getsubworkorder.cgst = dr["cgst"].ToString();
                        getsubworkorder.igst = "0";
                    }
                    else
                    {
                        getsubworkorder.sgst = "0";
                        getsubworkorder.cgst = "0";
                        getsubworkorder.igst = dr["igst"].ToString();
                    }
                    getsubworkorder.hsncode = dr["HSNcode"].ToString();
                    getsubworkorder.gst_exists = "1";
                }
                getsubworkorder.code = dr["code"].ToString();
                getsubworkorder.productdescription = dr["productdescription"].ToString();
                getsubworkorder.uim = dr["uim"].ToString();
                getsubworkorder.sno = dr["sno"].ToString();
                getsubworkorder.description = dr["description"].ToString();
                getsubworkorder.qty = dr["qty"].ToString();
                getsubworkorder.free = dr["free"].ToString();
                getsubworkorder.cost = dr["cost"].ToString();
                getsubworkorder.dis = dr["dis"].ToString();
                getsubworkorder.pfid = dr["pfid"].ToString();
                getsubworkorder.pfamount = dr["pf"].ToString();
                getsubworkorder.disamt = dr["disamt"].ToString();
                getsubworkorder.services = dr["services"].ToString();
                getsubworkorder.pono = dr["po_refno"].ToString();
                subworkorder_list.Add(getsubworkorder);
            }
            get_workorder get_workorder_obj = new get_workorder();
            get_workorder_obj.workorderdetails = workorder_lst;
            get_workorder_obj.subworkorderdetails = subworkorder_list;
            get_workorder_List.Add(get_workorder_obj);
            string response = GetJson(get_workorder_List);
            context.Response.Write(response);
        }
        catch
        {
        }
    }

    private void get_po_details_click(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string frmdate = context.Request["fromdate"];
            DateTime fromdate = Convert.ToDateTime(frmdate);
            string tdate = context.Request["todate"];
            DateTime todate = Convert.ToDateTime(tdate);
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT  podate, poamount,ponumber, name, warranty, status, delivarydate,sno FROM po_entrydetailes WHERE (podate BETWEEN @d1 AND @d2) AND (branchid=@branchid)");
            cmd.Parameters.Add("@d1", GetLowDate(fromdate));
            cmd.Parameters.Add("@d2", GetHighDate(todate));
            cmd.Parameters.Add("@branchid", branchid);
            DataTable dtpo = vdm.SelectQuery(cmd).Tables[0];
            List<purchasedetails> UIMDetails = new List<purchasedetails>();
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            DateTime dtapril = new DateTime();
            DateTime dtmarch = new DateTime();
            foreach (DataRow dr in dtpo.Rows)
            {
                purchasedetails getuim = new purchasedetails();
                getuim.sno = dr["sno"].ToString();
                getuim.name = dr["name"].ToString();
                getuim.podate = ((DateTime)dr["podate"]).ToString("dd-MM-yyyy"); //dr["podate"].ToString();
                DateTime dt_po = Convert.ToDateTime(dr["podate"].ToString());
                int currentyear = dt_po.Year;
                int nextyear = dt_po.Year + 1;
                int currntyearnum = 0;
                int nextyearnum = 0;
                if (dt_po.Month > 3)
                {
                    string apr = "4/1/" + currentyear;
                    dtapril = DateTime.Parse(apr);
                    string march = "3/31/" + nextyear;
                    dtmarch = DateTime.Parse(march);
                    currntyearnum = currentyear;
                    nextyearnum = nextyear;
                }
                if (dt_po.Month <= 3)
                {
                    string apr = "4/1/" + (currentyear - 1);
                    dtapril = DateTime.Parse(apr);
                    string march = "3/31/" + (nextyear - 1);
                    dtmarch = DateTime.Parse(march);
                    currntyearnum = currentyear - 1;
                    nextyearnum = nextyear - 1;
                }
                getuim.status = dr["status"].ToString();
                getuim.delivarydate = ((DateTime)dr["delivarydate"]).ToString("dd-MM-yyyy"); //dr["delivarydate"].ToString();
                string ponumber = "";
                if (branchid == "2")
                {
                    ponumber = "PBK/PO" + dtapril.ToString("yy") + "-" + dtmarch.ToString("yy") + "/" + dr["ponumber"].ToString();
                }
                else if (branchid == "4")
                {
                    ponumber = "CHN/PO" + dtapril.ToString("yy") + "-" + dtmarch.ToString("yy") + "/" + dr["ponumber"].ToString();
                }
                else if (branchid == "35")
                {
                    ponumber = "MNPK/PO" + dtapril.ToString("yy") + "-" + dtmarch.ToString("yy") + "/" + dr["ponumber"].ToString();
                }
                else if (branchid == "1040")
                {
                    ponumber = "KPM/PO" + dtapril.ToString("yy") + "-" + dtmarch.ToString("yy") + "/" + dr["ponumber"].ToString();
                }
                else if (branchid == "1")
                {
                    ponumber = "KVL/PO" + dtapril.ToString("yy") + "-" + dtmarch.ToString("yy") + "/" + dr["ponumber"].ToString();
                }
                else
                {
                    ponumber = "PO/" + dtapril.ToString("yy") + "-" + dtmarch.ToString("yy") + "/" + dr["ponumber"].ToString();
                }
                
                getuim.ponumber = ponumber.ToString();
                getuim.warranty = dr["warranty"].ToString();
                getuim.branchid = branchid;
                UIMDetails.Add(getuim);
            }
            string response = GetJson(UIMDetails);
            context.Response.Write(response);
        }
        catch
        {
        }
    }
    private void get_workOrder_click(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string frmdate = context.Request["fromdate"];
            DateTime fromdate = Convert.ToDateTime(frmdate);
            string tdate = context.Request["todate"];
            DateTime todate = Convert.ToDateTime(tdate);
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT  podate, poamount,ponumber, name,  status, delivarydate,sno FROM workorderdetails WHERE (podate BETWEEN @d1 AND @d2) AND (branchid=@branchid)");
            cmd.Parameters.Add("@d1", GetLowDate(fromdate));
            cmd.Parameters.Add("@d2", GetHighDate(todate));
            cmd.Parameters.Add("@branchid", branchid);
            DataTable dtpo = vdm.SelectQuery(cmd).Tables[0];
            List<workorder> workorderDetails = new List<workorder>();
            foreach (DataRow dr in dtpo.Rows)
            {
                workorder getworkorderreport = new workorder();
                getworkorderreport.sno = dr["sno"].ToString();
                getworkorderreport.name = dr["name"].ToString();
                getworkorderreport.podate = ((DateTime)dr["podate"]).ToString("dd-MM-yyyy"); //dr["podate"].ToString();
                getworkorderreport.status = dr["status"].ToString();
                getworkorderreport.delivarydate = ((DateTime)dr["delivarydate"]).ToString("dd-MM-yyyy"); //dr["delivarydate"].ToString();
                getworkorderreport.ponumber = dr["ponumber"].ToString();
                workorderDetails.Add(getworkorderreport);
            }
            string response = GetJson(workorderDetails);
            context.Response.Write(response);
        }
        catch
        {
        }
    }


    private void approval_pending_podetails_click(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string pono = context.Request["pono"];
            string status = context.Request["status"];
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("update po_entrydetailes set status=@status where sno=@pono AND branchid=@branchid");
            cmd.Parameters.Add("@branchid", branchid);
            cmd.Parameters.Add("@pono", pono);
            cmd.Parameters.Add("@status", status);
            vdm.Update(cmd);
            string msg = "purchase order successfully Approved";
            string Response = GetJson(msg);
            context.Response.Write(Response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    private void saveUIM(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string uim = context.Request["uim"];
            string status = context.Request["Status"];
            string btnSave = context.Request["btnVal"];
            string branchid = context.Session["Po_BranchID"].ToString();
            if (btnSave == "save")
            {
                cmd = new SqlCommand("insert into uimmaster (uim,status,branchid) values (@uim,@status,@branchid)");
                cmd.Parameters.Add("@uim", uim);
                cmd.Parameters.Add("@status", status);
                cmd.Parameters.Add("@branchid", branchid);
                vdm.insert(cmd);
                string Response = GetJson("UOM successfully Inserted");
                context.Response.Write(Response);
            }
            else
            {
                string sno = context.Request["sno"];

                cmd = new SqlCommand("Update uimmaster set  uim=@uim,status=@status where sno=@sno AND branchid=@branchid ");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@uim", uim);
                cmd.Parameters.Add("@status", status);
                cmd.Parameters.Add("@sno", sno);
                vdm.Update(cmd);
                string response = GetJson("UOM successfully updated");
                context.Response.Write(response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public class UIMDetails
    {
        public string uim { get; set; }
        public string status { get; set; }
        public string sno { get; set; }
    }
    private void get_UIM(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT uim,status,sno FROM uimmaster");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<UIMDetails> UIMDetails = new List<UIMDetails>();
            foreach (DataRow dr in routes.Rows)
            {
                UIMDetails getuim = new UIMDetails();
                getuim.uim = dr["uim"].ToString();
                var status = dr["status"].ToString();
                if (status == "True")
                {
                    getuim.status = "Active";
                }
                if (status == "False")
                {
                    getuim.status = "InActive";
                }
                getuim.sno = dr["sno"].ToString();
                UIMDetails.Add(getuim);
            }
            string response = GetJson(UIMDetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    private void savePandF(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string pandf = context.Request["pandf"];
            string status = context.Request["Status"];
            string btnSave = context.Request["btnVal"];
            string branchid = context.Session["Po_BranchID"].ToString();
            if (btnSave == "save")
            {
                cmd = new SqlCommand("insert into pandf (pandf,status,branchid) values (@pandf,@status,@branchid)");
                cmd.Parameters.Add("@pandf", pandf);
                cmd.Parameters.Add("@status", status);
                cmd.Parameters.Add("@branchid", branchid);
                vdm.insert(cmd);
                string Response = GetJson(" p and f successfully Inserted");
                context.Response.Write(Response);
            }
            else
            {
                string sno = context.Request["sno"];
                cmd = new SqlCommand("Update pandf set  pandf=@pandf,status=@status where sno=@sno AND branchid=@branchid");
                cmd.Parameters.Add("@pandf", pandf);
                cmd.Parameters.Add("@status", status);
                cmd.Parameters.Add("@sno", sno);
                cmd.Parameters.Add("@branchid", branchid);
                vdm.Update(cmd);
                string response = GetJson("P and f successfully updated");
                context.Response.Write(response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public class PandFDetails
    {
        public string pandf { get; set; }
        public string status { get; set; }
        public string sno { get; set; }

    }
    private void get_PandF(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT pandf,status,sno FROM pandf");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<PandFDetails> PandFDetails = new List<PandFDetails>();
            foreach (DataRow dr in routes.Rows)
            {
                PandFDetails getpandf = new PandFDetails();
                getpandf.pandf = dr["pandf"].ToString();
                var status = dr["status"].ToString();
                if (status == "True")
                {
                    getpandf.status = "Active";
                }
                if (status == "False")
                {
                    getpandf.status = "InActive";
                }
                getpandf.sno = dr["sno"].ToString();
                PandFDetails.Add(getpandf);
            }
            string response = GetJson(PandFDetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }


    private void saveDelivaryTerms(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string terms = context.Request["terms"];
            string btnSave = context.Request["btnVal"];
            string branchid = context.Session["Po_BranchID"].ToString();
            if (btnSave == "save")
            {
                cmd = new SqlCommand("insert into deliveryterms (deliveryterms,branchid) values (@terms,@branchid)");
                cmd.Parameters.Add("@terms", terms);
                cmd.Parameters.Add("@branchid", branchid);
                vdm.insert(cmd);
                string Response = GetJson("Delivery Terms successfully Inserted");
                context.Response.Write(Response);
            }
            else
            {
                string sno = context.Request["sno"];
                cmd = new SqlCommand("Update deliveryterms set  deliveryterms=@terms where sno=@sno AND branchid=@branchid");
                cmd.Parameters.Add("@terms", terms);
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@sno", sno);
                vdm.Update(cmd);
                string response = GetJson("Delivery Terms successfully updated");
                context.Response.Write(response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public class DelivaryTerms
    {
        public string terms { get; set; }
        public string branchid { get; set; }
        public string sno { get; set; }

    }
    private void get_DelivaryTerms(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT deliveryterms,sno,branchid FROM deliveryterms");
            cmd.Parameters.Add("@branchid", branchid);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<DelivaryTerms> DelivaryTerms = new List<DelivaryTerms>();
            foreach (DataRow dr in routes.Rows)
            {
                DelivaryTerms getterms = new DelivaryTerms();
                getterms.terms = dr["deliveryterms"].ToString();
                getterms.branchid = dr["branchid"].ToString();
                getterms.sno = dr["sno"].ToString();
                DelivaryTerms.Add(getterms);
            }
            string response = GetJson(DelivaryTerms);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public void savePayementDetails(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string paymenttype = context.Request["paymenttype"];
            string status = context.Request["Status"];
            string branchid = context.Session["Po_BranchID"].ToString();
            string btnSave = context.Request["btnVal"];
            if (btnSave == "save")
            {
                cmd = new SqlCommand("insert into paymentmaster (paymenttype,status,branchid) values (@paymenttype,@status,@branchid)");
                cmd.Parameters.Add("@paymenttype", paymenttype);
                cmd.Parameters.Add("@status", status);
                cmd.Parameters.Add("@branchid", branchid);
                vdm.insert(cmd);
                string Response = GetJson("paymenttype successfully Inserted");
                context.Response.Write(Response);
            }
            else
            {
                string sno = context.Request["sno"];
                cmd = new SqlCommand("Update paymentmaster set  paymenttype=@paymenttype,status=@status where sno=@sno AND branchid=@branchid");
                cmd.Parameters.Add("@paymenttype", paymenttype);
                cmd.Parameters.Add("@status", status);
                cmd.Parameters.Add("@sno", sno);
                cmd.Parameters.Add("@branchid", branchid);
                vdm.Update(cmd);
                string response = GetJson("paymenttype successfully updated");
                context.Response.Write(response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public class PaymentDetails
    {
        public string paymenttype { get; set; }
        public string status { get; set; }
        public string sno { get; set; }
    }
    private void get_PaymentDetails(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT paymenttype,status,sno FROM paymentmaster");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<PaymentDetails> PaymentDetails = new List<PaymentDetails>();
            foreach (DataRow dr in routes.Rows)
            {
                PaymentDetails getpayment = new PaymentDetails();
                getpayment.paymenttype = dr["paymenttype"].ToString();
                var status = dr["status"].ToString();
                if (status == "True")
                {
                    getpayment.status = "Active";
                }
                if (status == "False")
                {
                    getpayment.status = "InActive";
                }
                getpayment.sno = dr["sno"].ToString();
                PaymentDetails.Add(getpayment);
            }
            string response = GetJson(PaymentDetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    private void saveTAX(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string type = context.Request["type"];
            string taxtype = context.Request["taxtype"];
            string btnSave = context.Request["btnVal"];
            string flag = context.Request["flag"];
            string branchid = context.Session["Po_BranchID"].ToString();
            if (btnSave == "save")
            {
                cmd = new SqlCommand("insert into taxmaster (type,taxtype,branchid,flag) values (@type,@taxtype,@branchid,@flag)");//,status,@status
                cmd.Parameters.Add("@type", type);
                cmd.Parameters.Add("@taxtype", taxtype);
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@flag", flag);
                vdm.insert(cmd);
                string Response = GetJson(" TAX succefully Inserted");
                context.Response.Write(Response);
            }
            else
            {
                string sno = context.Request["sno"];
                cmd = new SqlCommand("Update taxmaster set  flag=@flag,type=@type,taxtype=@taxtype where sno=@sno AND branchid=@branchid");//,status=@status
                cmd.Parameters.Add("@type", type);
                cmd.Parameters.Add("@taxtype", taxtype);
                cmd.Parameters.Add("@sno", sno);
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@flag", flag);
                vdm.Update(cmd);
                string response = GetJson("Tax succefully updated");
                context.Response.Write(response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public class TAXDetails
    {
        public string taxtype { get; set; }
        public string type { get; set; }
        public string sno { get; set; }
        public string status { get; set; }
        public string flag { get; set; }
    }
    private void get_TAX(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT type,status, taxtype,sno,flag FROM taxmaster where flag='True'");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<TAXDetails> TAXDetails = new List<TAXDetails>();
            foreach (DataRow dr in routes.Rows)
            {
                TAXDetails gettax = new TAXDetails();
                gettax.type = dr["type"].ToString();
                var status = dr["status"].ToString();
                if (status == "True")
                {
                    gettax.status = "Active";
                }
                if (status == "False")
                {
                    gettax.status = "InActive";
                }
                gettax.taxtype = dr["taxtype"].ToString();
                gettax.sno = dr["sno"].ToString();
                gettax.flag = dr["flag"].ToString();
                TAXDetails.Add(gettax);
            }
            string response = GetJson(TAXDetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    private void get_tax_details(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT type,status, taxtype,sno,flag FROM taxmaster");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<TAXDetails> TAXDetails = new List<TAXDetails>();
            foreach (DataRow dr in routes.Rows)
            {
                TAXDetails gettax = new TAXDetails();
                gettax.type = dr["type"].ToString();
                var status = dr["status"].ToString();
                if (status == "True")
                {
                    gettax.status = "Active";
                }
                if (status == "False")
                {
                    gettax.status = "InActive";
                }
                gettax.taxtype = dr["taxtype"].ToString();
                gettax.sno = dr["sno"].ToString();
                gettax.flag = dr["flag"].ToString();
                TAXDetails.Add(gettax);
            }
            string response = GetJson(TAXDetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    private void saveSectionDetails(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string name = context.Request["Name"];
            string status = context.Request["Status"];
            string btnSave = context.Request["btnVal"];
            string branchid = context.Session["Po_BranchID"].ToString();
            if (btnSave == "Save")
            {
                cmd = new SqlCommand("insert into sectionmaster (name,status,branchid) values (@name,@status,@branchid)");//,color,@color
                cmd.Parameters.Add("@name", name);
                cmd.Parameters.Add("@status", status);
                cmd.Parameters.Add("@branchid", branchid);
                vdm.insert(cmd);
                string Response = GetJson("Section Details are Successfully Inserted");
                context.Response.Write(Response);
            }
            else
            {
                string sectionid = context.Request["sectionid"];
                cmd = new SqlCommand("Update SectionMaster set  name=@name,status=@status where branchid=@branchid AND sectionid=@sectionid");//,color=@color
                cmd.Parameters.Add("@name", name);
                cmd.Parameters.Add("@status", status);
                cmd.Parameters.Add("@sectionid", sectionid);
                cmd.Parameters.Add("@branchid", branchid);
                vdm.Update(cmd);
                string response = GetJson("Section Details are successfully Updated");
                context.Response.Write(response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public class SectionMaster
    {
        public string sectionname { get; set; }
        public string Color { get; set; }
        public string SectionId { get; set; }
        public string status { get; set; }
        public string Sectioncode { get; set; }
    }
    private void get_section_details(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT name, color, sectionid,  sec_code, status FROM sectionmaster where branchid=@branchid");
            cmd.Parameters.Add("@branchid", branchid);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<SectionMaster> SectionMaster = new List<SectionMaster>();
            foreach (DataRow dr in routes.Rows)
            {
                SectionMaster getsectiondetails = new SectionMaster();
                getsectiondetails.sectionname = dr["name"].ToString();
                getsectiondetails.Color = dr["color"].ToString();
                var status = dr["status"].ToString();
                if (status == "True")
                {
                    getsectiondetails.status = "Active";
                }
                if (status == "False")
                {
                    getsectiondetails.status = "InActive";
                }
                getsectiondetails.SectionId = dr["sectionid"].ToString();
                getsectiondetails.Sectioncode = dr["sectionid"].ToString();
                SectionMaster.Add(getsectiondetails);
            }
            string response = GetJson(SectionMaster);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    private void saveBrandDetails(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string brandname = context.Request["Name"];
            string status = context.Request["Status"];
            string createdby = context.Session["Employ_Sno"].ToString();
            DateTime createdon = DateTime.Now;
            string btnSave = context.Request["btnVal"];
            string branchid = context.Session["Po_BranchID"].ToString();
            if (btnSave == "save")
            {
                cmd = new SqlCommand("insert into branddetails (brandname,status,createdby,createdon,branchid) values (@brandname,@status,@createdby,@createdon,@branchid)");
                cmd.Parameters.Add("@brandname", brandname);
                cmd.Parameters.Add("@status", status);
                cmd.Parameters.Add("@createdby", createdby);
                cmd.Parameters.Add("@createdon", createdon);
                cmd.Parameters.Add("@branchid", branchid);
                vdm.insert(cmd);
                string Response = GetJson("Brand Details Are succefully Inserted");
                context.Response.Write(Response);
            }
            else
            {
                string barncdid = context.Request["barncdid"];
                cmd = new SqlCommand("Update branddetails set  brandname=@brandname,status=@status where brandid=@brandid AND branchid=@branchid");
                cmd.Parameters.Add("@brandname", brandname);
                cmd.Parameters.Add("@status", status);
                cmd.Parameters.Add("@brandid", barncdid);
                cmd.Parameters.Add("@branchid", branchid);
                vdm.Update(cmd);
                string response = GetJson("Brand Details Are Successfully updated");
                context.Response.Write(response);
            }
        }

        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public class BrandDetails
    {
        public string brandname { get; set; }
        public string status { get; set; }
        public string brandid { get; set; }
    }
    private void get_Brand_details(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT brandname,status,brandid FROM branddetails");
            cmd.Parameters.Add("@branchid", branchid);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<BrandDetails> BrandDetails = new List<BrandDetails>();
            foreach (DataRow dr in routes.Rows)
            {
                BrandDetails getbranddetails = new BrandDetails();
                getbranddetails.brandname = dr["brandname"].ToString();
                var status = dr["status"].ToString();
                if (status == "True")
                {
                    getbranddetails.status = "Active";
                }
                if (status == "False")
                {
                    getbranddetails.status = "InActive";
                }
                getbranddetails.brandid = dr["brandid"].ToString();
                BrandDetails.Add(getbranddetails);
            }
            string response = GetJson(BrandDetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void saveAddressDetails(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string Address = context.Request["Address"];
            string createdby = context.Session["Employ_Sno"].ToString();
            DateTime createdon = DateTime.Now;
            string btnSave = context.Request["btnVal"];
            string branchid = context.Session["Po_BranchID"].ToString();
            if (btnSave == "save")
            {
                cmd = new SqlCommand("insert into addressdetails (address,branchid) values (@address,@branchid)");
                cmd.Parameters.Add("@Address", Address);
                cmd.Parameters.Add("@branchid", branchid);
                vdm.insert(cmd);
                string Response = GetJson("Address Details Are succefully Inserted");
                context.Response.Write(Response);
            }
            else
            {
                string sno = context.Request["sno"];
                cmd = new SqlCommand("Update addressdetails set  address=@address where sno=@sno AND branchid=@branchid");
                cmd.Parameters.Add("@Address", Address);
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@sno", sno);
                vdm.Update(cmd);
                string response = GetJson("Address Details Are Successfully updated");
                context.Response.Write(response);
            }
        }

        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class AddressDetails
    {
        public string type { get; set; }
        public string Address { get; set; }
        public string sno { get; set; }
        public string addresstype { get; set; }
    }

    private void get_Address_details(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT address,sno FROM addressdetails");
            cmd.Parameters.Add("@branchid", branchid);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<AddressDetails> AddressDetails = new List<AddressDetails>();
            foreach (DataRow dr in routes.Rows)
            {
                AddressDetails getAddress = new AddressDetails();
                getAddress.Address = dr["address"].ToString();
                getAddress.sno = dr["sno"].ToString();
                AddressDetails.Add(getAddress);
            }
            string response = GetJson(AddressDetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void save_State_Details(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string state_name = context.Request["state_name"];
            string gst_state_code = context.Request["gst_state_code"];
            string ecode = context.Request["ecode"];
            string code = context.Request["code"];
            string createdby = context.Session["Employ_Sno"].ToString();
            DateTime createdon = DateTime.Now;
            string btnSave = context.Request["btnVal"];
            string branchid = context.Session["Po_BranchID"].ToString();
            if (btnSave == "save")
            {
                cmd = new SqlCommand("insert into statemaster (statename,gststatecode,ecode,code) values (@state_name,@gst_state_code,@ecode,@code)");
                cmd.Parameters.Add("@state_name", state_name);
                cmd.Parameters.Add("@gst_state_code", gst_state_code);
                cmd.Parameters.Add("@ecode", ecode);
                cmd.Parameters.Add("@code", code);
                vdm.insert(cmd);
                string Response = GetJson("New State Details Are succefully Inserted");
                context.Response.Write(Response);
            }
            else
            {
                string sno = context.Request["sno"];
                cmd = new SqlCommand("Update statemaster set  ecode=@ecode,code=@code,statename=@state_name,gststatecode=@gst_state_code where sno=@sno");
                cmd.Parameters.Add("@state_name", state_name);
                cmd.Parameters.Add("@gst_state_code", gst_state_code);
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@ecode", ecode);
                cmd.Parameters.Add("@code", code);
                cmd.Parameters.Add("@sno", sno);
                vdm.Update(cmd);
                string response = GetJson("State Details Are Successfully updated");
                context.Response.Write(response);
            }
        }

        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class StateDetails
    {
        public string statename { get; set; }
        public string gststatecode { get; set; }
        public string ecode { get; set; }
        public string code { get; set; }
        public string sno { get; set; }
    }

    private void get_statemaster_details(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT sno,code,ecode,statename,gststatecode FROM statemaster");
            cmd.Parameters.Add("@branchid", branchid);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<StateDetails> state_details = new List<StateDetails>();
            foreach (DataRow dr in routes.Rows)
            {
                StateDetails state = new StateDetails();
                state.statename = dr["statename"].ToString();
                state.gststatecode = dr["gststatecode"].ToString();
                state.ecode = dr["ecode"].ToString();
                state.code = dr["code"].ToString();
                state.sno = dr["sno"].ToString();
                state_details.Add(state);
            }
            string response = GetJson(state_details);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void saveCategoryDetails(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string category = context.Request["Name"];
            string categoryid = context.Request["CategoryID"];
            string status = context.Request["Status"];
            string cat_code = context.Request["cat_code"];
            string createdby = context.Session["Employ_Sno"].ToString();
            DateTime createdon = DateTime.Now;
            string btnSave = context.Request["btnVal"];
            string branchid = context.Session["Po_BranchID"].ToString();
            if (btnSave == "Save")
            {
                cmd = new SqlCommand("insert into categorymaster (category,status,cat_code,createdby,createdon,branchid) values (@category,@status,@cat_code,@createdby,@createdon,@branchid)");
                cmd.Parameters.Add("@category", category);
                cmd.Parameters.Add("@status", status);
                cmd.Parameters.Add("@cat_code", cat_code);
                cmd.Parameters.Add("@createdby", createdby);
                cmd.Parameters.Add("@createdon", createdon);
                cmd.Parameters.Add("@branchid", branchid);
                vdm.insert(cmd);
                string Response = GetJson("category master details are successfully Inserted");
                context.Response.Write(Response);
            }
            else
            {
                string Categoryid = context.Request["categoryid"];
                cmd = new SqlCommand("Update categorymaster set  category=@category,status=@status,cat_code=@cat_code where categoryid=@categoryid AND branchid=@branchid");
                cmd.Parameters.Add("@category", category);
                cmd.Parameters.Add("@status", status);
                cmd.Parameters.Add("@cat_code", cat_code);
                cmd.Parameters.Add("@categoryid", categoryid);
                cmd.Parameters.Add("@branchid", branchid);
                vdm.Update(cmd);
                string response = GetJson("category master details are successfully Updated");
                context.Response.Write(response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class CategoryMaster
    {
        public string Category { get; set; }
        public string status { get; set; }
        public string categoryid { get; set; }
        public string cat_code { get; set; }
    }

    private void get_Category_details(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT category,status,cat_code,categoryid FROM categorymaster");
            cmd.Parameters.Add("@branchid", branchid);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<CategoryMaster> CategoryMaster = new List<CategoryMaster>();
            foreach (DataRow dr in routes.Rows)
            {
                CategoryMaster getcategorydetails = new CategoryMaster();
                getcategorydetails.Category = dr["category"].ToString();
                var status = dr["status"].ToString();
                if (status == "True")
                {
                    getcategorydetails.status = "Active";
                }
                if (status == "False")
                {
                    getcategorydetails.status = "InActive";
                }
                getcategorydetails.categoryid = dr["categoryid"].ToString();
                getcategorydetails.cat_code = dr["cat_code"].ToString();
                CategoryMaster.Add(getcategorydetails);

            }
            string response = GetJson(CategoryMaster);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void saveSubcategoryDetails(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string categoryid = context.Request["CategoryId"];
            string subcategoryname = context.Request["SubCategory"];
            string sub_cat_code = context.Request["sub_cat_code"];
            string status = context.Request["Status"];
            string branchid = context.Session["Po_BranchID"].ToString();
            string LedgerName = context.Request["LedgerName"].ToString();
            string ledgerCode = context.Request["ledgerCode"].ToString();
            string createdby = context.Session["Employ_Sno"].ToString();
            DateTime createdon = DateTime.Now;
            string btnSave = context.Request["btnVal"];
            if (btnSave == "Save")
            {
                cmd = new SqlCommand("insert into subcategorymaster (categoryid,subcategoryname,sub_cat_code,status,createdby,createdon,branchid,ledgername,ledgercode ) values (@categoryid,@subcategoryname,@sub_cat_code,@status,@createdby,@createdon,@branchid,@ledgername,@ledgercode)");
                cmd.Parameters.Add("@categoryid", categoryid);
                cmd.Parameters.Add("@subcategoryname", subcategoryname);
                cmd.Parameters.Add("@sub_cat_code", sub_cat_code);
                cmd.Parameters.Add("@status", status);
                cmd.Parameters.Add("@createdby", createdby);
                cmd.Parameters.Add("@createdon", createdon);
                cmd.Parameters.Add("@ledgername", LedgerName);
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@ledgerCode", ledgerCode);
                vdm.insert(cmd);
                string msg = "Sub category successfully saved";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {
                string Subcategoryid = context.Request["Subcategoryid"];
                cmd = new SqlCommand("Update subcategorymaster set ledgerCode=@ledgerCode, subcategoryname=@subcategoryname,ledgername=@ledgername,sub_cat_code=@sub_cat_code,categoryid=@categoryid,status=@status where subcategoryid=@subcategoryid AND branchid=@branchid");
                cmd.Parameters.Add("@subcategoryname", subcategoryname);
                cmd.Parameters.Add("@status", status);
                cmd.Parameters.Add("@sub_cat_code", sub_cat_code);
                cmd.Parameters.Add("@subcategoryid", Subcategoryid);
                cmd.Parameters.Add("@categoryid", categoryid);
                cmd.Parameters.Add("@ledgername", LedgerName);
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@ledgerCode", ledgerCode);
                vdm.Update(cmd);
                string msg = "Sub category successfully updated";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class sub_catdetails
    {
        public string subcategoryid { get; set; }
        public string subcatname { get; set; }
        public string status { get; set; }
        public string Categoryid { get; set; }
        public string Category { get; set; }
        public string sub_cat_code { get; set; }
        public string cat_code { get; set; }
        public string LedgerName { get; set; }
        public string ledgerCode { get; set; }
        public string sapcode { get; set; }
    }

    private void get_Sub_Category_details(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT  categorymaster.categoryid, categorymaster.category, categorymaster.cat_code,subcategorymaster.ledgerCode,subcategorymaster.ledgername,subcategorymaster.sub_cat_code, subcategorymaster.subcategoryid, subcategorymaster.categoryid AS Expr1,subcategorymaster.subcategoryname, subcategorymaster.status FROM  categorymaster INNER JOIN subcategorymaster ON categorymaster.categoryid = subcategorymaster.categoryid");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<sub_catdetails> sub_catdetails = new List<sub_catdetails>();
            foreach (DataRow dr in routes.Rows)
            {
                sub_catdetails categorydetails = new sub_catdetails();
                categorydetails.Category = dr["category"].ToString();
                categorydetails.subcatname = dr["subcategoryname"].ToString();
                categorydetails.LedgerName = dr["ledgername"].ToString();
                categorydetails.ledgerCode = dr["ledgerCode"].ToString();
                var status = dr["status"].ToString();
                if (status == "True")
                {
                    categorydetails.status = "Active";
                }
                if (status == "False")
                {
                    categorydetails.status = "InActive";
                }
                categorydetails.cat_code = dr["cat_code"].ToString();
                categorydetails.Categoryid = dr["categoryid"].ToString();
                categorydetails.sub_cat_code = dr["sub_cat_code"].ToString();
                categorydetails.subcategoryid = dr["subcategoryid"].ToString();
                sub_catdetails.Add(categorydetails);
            }
            string response = GetJson(sub_catdetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_subcategory_data_catcode(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string catcode = context.Request["catcode"];
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT  categorymaster.categoryid, categorymaster.category, categorymaster.cat_code,subcategorymaster.ledgerCode,subcategorymaster.ledgername,subcategorymaster.sub_cat_code, subcategorymaster.subcategoryid, subcategorymaster.categoryid AS Expr1,subcategorymaster.subcategoryname, subcategorymaster.status FROM  categorymaster INNER JOIN subcategorymaster ON categorymaster.categoryid = subcategorymaster.categoryid  WHERE  subcategorymaster.branchid=@branchid AND categorymaster.cat_code=@catcode");
            cmd.Parameters.Add("@catcode", catcode);
            cmd.Parameters.Add("@branchid", branchid);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<sub_catdetails> sub_catdetails = new List<sub_catdetails>();
            foreach (DataRow dr in routes.Rows)
            {
                sub_catdetails categorydetails = new sub_catdetails();
                categorydetails.Category = dr["category"].ToString();
                categorydetails.subcatname = dr["subcategoryname"].ToString();
                categorydetails.LedgerName = dr["ledgername"].ToString();
                categorydetails.ledgerCode = dr["ledgerCode"].ToString();
                var status = dr["status"].ToString();
                if (status == "True")
                {
                    categorydetails.status = "Active";
                }
                if (status == "False")
                {
                    categorydetails.status = "InActive";
                }
                categorydetails.cat_code = dr["cat_code"].ToString();
                categorydetails.Categoryid = dr["categoryid"].ToString();
                categorydetails.sub_cat_code = dr["sub_cat_code"].ToString();
                categorydetails.subcategoryid = dr["subcategoryid"].ToString();
                sub_catdetails.Add(categorydetails);
            }
            string response = GetJson(sub_catdetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void saveSuplierDetails(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            var js = new JavaScriptSerializer();
            var title1 = context.Request.Params[1];
            supplierdetails obj = js.Deserialize<supplierdetails>(title1);
            string name = obj.suppliername;
            string description = obj.description;
            string companyname = obj.companyname;
            string contactname = obj.contactname;
            string street1 = obj.street1;
            string contactnumber = obj.contactnumber;
            string city = obj.city;
            string state = obj.state;
            string country = obj.country;
            string zipcode = obj.zipcode;
            string mobileno = obj.mobileno;
            string emailid = obj.emailid;
            string websiteurl = obj.websiteurl;
            string status = obj.status;
            string gst_no = obj.gst_no;
            string gst_type = obj.gst_type;
            string pan_no = obj.pan_no;
            string insurecetype = obj.insurecetype;
            string insurence = obj.insurence;
            string warranytype = obj.warranytype;
            string warranty = obj.warranty;
            string vendor_cd = obj.vendorcode;
            string bank_acc_no = obj.bank_acc_no;
            string bank_ifsc = obj.bank_ifsc;
            string branchid = context.Session["Po_BranchID"].ToString();
            string emp_sno = context.Session["Employ_Sno"].ToString();
            string createdby = context.Session["Employ_Sno"].ToString();
            DateTime createdon = DateTime.Now;
            string btnSave = obj.btnVal;
            if (btnSave == "Save")
            {
                cmd = new SqlCommand("insert into suppliersdetails (insurance,insuranceamount,warrantytype,warranty,name,description,companyname,contactname,street1,city,stateid,country,zipcode,mobileno,emailid,websiteurl,status,createdby,createdon,contactnumber,branchid,suppliercode,GSTIN,regtype,panno,bankaccountno,bankifsccode ) values (@insurecetype,@insurence,@warranytype,@warranty,@name,@description,@companyname,@contactname,@street1,@city,@state,@country,@zipcode,@mobileno,@emailid,@websiteurl,@status,@createdby,@createdon,@contactnumber,@branchid,@vendor_cd,@gst_no,@gst_type,@pan_no,@bank_acc_no,@bank_ifsc)");
                cmd.Parameters.Add("@name", name);
                cmd.Parameters.Add("@description", description);
                cmd.Parameters.Add("@companyname", companyname);
                cmd.Parameters.Add("@contactname", contactname);
                cmd.Parameters.Add("@street1", street1);
                cmd.Parameters.Add("@contactnumber", contactnumber);
                cmd.Parameters.Add("@city", city);
                cmd.Parameters.Add("@state", state);
                cmd.Parameters.Add("@country", country);
                cmd.Parameters.Add("@zipcode", zipcode);
                cmd.Parameters.Add("@mobileno", mobileno);
                cmd.Parameters.Add("@emailid", emailid);
                cmd.Parameters.Add("@websiteurl", websiteurl);
                cmd.Parameters.Add("@status", status);
                cmd.Parameters.Add("@createdby", createdby);
                cmd.Parameters.Add("@createdon", createdon);
                cmd.Parameters.Add("@insurecetype", insurecetype);
                cmd.Parameters.Add("@insurence", insurence);
                cmd.Parameters.Add("@warranytype", warranytype);
                cmd.Parameters.Add("@warranty", warranty);
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@vendor_cd", vendor_cd);
                cmd.Parameters.Add("@gst_no", gst_no);
                cmd.Parameters.Add("@gst_type", gst_type);
                cmd.Parameters.Add("@pan_no", pan_no);
                cmd.Parameters.Add("@bank_acc_no", bank_acc_no);
                cmd.Parameters.Add("@bank_ifsc", bank_ifsc);
                vdm.insert(cmd);

                cmd = new SqlCommand("select max(supplierid) as supplierid from suppliersdetails");
                DataTable dt_supplierid = vdm.SelectQuery(cmd).Tables[0];
                string sup_id = dt_supplierid.Rows[0]["supplierid"].ToString();

                foreach (items_supplier dr in obj.product_ids)
                {
                    cmd = new SqlCommand("select itemid,supplierid,sno from itemsupplierdetails where itemid=@itemid and supplierid=@supplierid");
                    cmd.Parameters.Add("@itemid", dr.productid);
                    cmd.Parameters.Add("@supplierid", sup_id);
                    DataTable dt_det = vdm.SelectQuery(cmd).Tables[0];

                    if (dt_det.Rows.Count > 0)
                    {

                    }
                    else
                    {
                        cmd = new SqlCommand("insert into itemsupplierdetails(itemid,supplierid,doe,createdby) values (@itemid,@supplierid,@doe,@createdby)");
                        cmd.Parameters.Add("@itemid", dr.productid);
                        cmd.Parameters.Add("@supplierid", sup_id);
                        cmd.Parameters.Add("@doe", createdon);
                        cmd.Parameters.Add("@createdby", emp_sno);
                        vdm.insert(cmd);
                    }
                }

                string msg = " supplietDetails are successfully saved";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {
                string suplierid = obj.supplierid;
                cmd = new SqlCommand("Update suppliersdetails set suppliercode=@vendor_cd,contactnumber=@contactnumber,insuranceamount=@insuranceamount,insurance=@insurance,warrantytype=@warrantytype,warranty=@warranty,name=@name,description=@description,companyname=@companyname,contactname=@contactname,street1=@street1,city=@city,stateid=@state,country=@country,zipcode=@zipcode,mobileno=@mobileno,emailid=@emailid,websiteurl=@websiteurl,status=@status,createdby=@createdby,createdon=@createdon,GSTIN=@gst_no,regtype=@gst_type,panno=@pan_no,bankaccountno=@bank_acc_no,bankifsccode=@bank_ifsc where supplierid=@supplierid");
                cmd.Parameters.Add("@name", name);
                cmd.Parameters.Add("@description", description);
                cmd.Parameters.Add("@companyname", companyname);
                cmd.Parameters.Add("@contactname", contactname);
                cmd.Parameters.Add("@street1", street1);
                cmd.Parameters.Add("@contactnumber", contactnumber);
                cmd.Parameters.Add("@city", city);
                cmd.Parameters.Add("@state", state);
                cmd.Parameters.Add("@country", country);
                cmd.Parameters.Add("@zipcode", zipcode);
                cmd.Parameters.Add("@mobileno", mobileno);
                cmd.Parameters.Add("@emailid", emailid);
                cmd.Parameters.Add("@websiteurl", websiteurl);
                cmd.Parameters.Add("@status", status);
                cmd.Parameters.Add("@supplierid", suplierid);
                cmd.Parameters.Add("@createdby", createdby);
                cmd.Parameters.Add("@createdon", createdon);
                cmd.Parameters.Add("@insurance", insurecetype);
                cmd.Parameters.Add("@insuranceamount", insurence);
                cmd.Parameters.Add("@warrantytype", warranytype);
                cmd.Parameters.Add("@warranty", warranty);
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@vendor_cd", vendor_cd);
                cmd.Parameters.Add("@gst_no", gst_no);
                cmd.Parameters.Add("@gst_type", gst_type);
                cmd.Parameters.Add("@pan_no", pan_no);
                cmd.Parameters.Add("@bank_acc_no", bank_acc_no);
                cmd.Parameters.Add("@bank_ifsc", bank_ifsc);
                vdm.Update(cmd);

                cmd = new SqlCommand("Delete from itemsupplierdetails where  supplierid=@supid");
                cmd.Parameters.Add("@supid", suplierid);
                vdm.Delete(cmd);

                foreach (items_supplier dr in obj.product_ids)
                {

                    cmd = new SqlCommand("update itemsupplierdetails set itemid=@itemid where sno=@sno and supplierid=@supplierid");
                    cmd.Parameters.Add("@itemid", dr.productid);
                    cmd.Parameters.Add("@supplierid", suplierid);
                    cmd.Parameters.Add("@sno", dr.item_sno);
                    if (vdm.Update(cmd) == 0)
                    {
                        cmd = new SqlCommand("select itemid,supplierid,sno from itemsupplierdetails where itemid=@itemid and supplierid=@supplierid");
                        cmd.Parameters.Add("@itemid", dr.productid);
                        cmd.Parameters.Add("@supplierid", suplierid);
                        DataTable dt_det = vdm.SelectQuery(cmd).Tables[0];

                        if (dt_det.Rows.Count > 0)
                        {

                        }
                        else
                        {
                            cmd = new SqlCommand("insert into itemsupplierdetails(itemid,supplierid,doe,createdby) values (@itemid,@supplierid,@doe,@createdby)");
                            cmd.Parameters.Add("@itemid", dr.productid);
                            cmd.Parameters.Add("@supplierid", suplierid);
                            cmd.Parameters.Add("@doe", createdon);
                            cmd.Parameters.Add("@createdby", emp_sno);
                            vdm.insert(cmd);
                        }
                    }

                }

                string msg = "Supplier Details successfully updated";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class supplierdetails
    {
        public string suppliername { get; set; }
        public string description { get; set; }
        public string companyname { get; set; }
        public string contactname { get; set; }
        public string street1 { get; set; }
        public string contactnumber { get; set; }
        public string city { get; set; }
        public string state { get; set; }
        public string country { get; set; }
        public string zipcode { get; set; }
        public string mobileno { get; set; }
        public string emailid { get; set; }
        public string websiteurl { get; set; }
        public string status { get; set; }
        public string supplierid { get; set; }
        public string insurecetype { get; set; }
        public string insurence { get; set; }
        public string warranytype { get; set; }
        public string warranty { get; set; }
        public string vendorcode { get; set; }
        public string imgpath { get; set; }
        public string ftplocation { get; set; }
        public string btnVal { get; set; }
        public string gst_no { get; set; }
        public string gst_type { get; set; }
        public string pan_no { get; set; }
        public string bank_acc_no { get; set; }
        public string bank_ifsc { get; set; }
        public List<items_supplier> product_ids { get; set; }
    }

    public class items_supplier
    {
        public string suppliername { get; set; }
        public string supplierid { get; set; }
        public string productid { get; set; }
        public string productname { get; set; }
        public string item_sno { get; set; }
    }

    private void get_suplier_details(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT bankifsccode,bankaccountno,GSTIN,regtype,panno,supplierphoto,contactnumber,insurance,insuranceamount,warrantytype,warranty,name,description,companyname,contactname,street1,city,stateid,country,zipcode,mobileno,emailid,websiteurl,status,supplierid,suppliercode FROM suppliersdetails");
            cmd.Parameters.Add("@branchid", branchid);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<supplierdetails> supplierdetails = new List<supplierdetails>();
            foreach (DataRow dr in routes.Rows)
            {
                supplierdetails getsupplier = new supplierdetails();
                getsupplier.suppliername = dr["name"].ToString();
                getsupplier.description = dr["description"].ToString();
                getsupplier.companyname = dr["companyname"].ToString();
                getsupplier.contactname = dr["contactname"].ToString();
                getsupplier.street1 = dr["street1"].ToString();
                getsupplier.city = dr["city"].ToString();
                getsupplier.state = dr["stateid"].ToString();
                getsupplier.country = dr["country"].ToString();
                getsupplier.zipcode = dr["zipcode"].ToString();
                getsupplier.mobileno = dr["mobileno"].ToString();
                getsupplier.emailid = dr["emailid"].ToString();
                getsupplier.websiteurl = dr["websiteurl"].ToString();
                getsupplier.insurecetype = dr["insurance"].ToString();
                getsupplier.insurence = dr["insuranceamount"].ToString();
                getsupplier.warranytype = dr["warrantytype"].ToString();
                getsupplier.contactnumber = dr["contactnumber"].ToString();
                getsupplier.warranty = dr["warranty"].ToString();
                var status = dr["status"].ToString();
                if (status == "True")
                {
                    getsupplier.status = "Active";
                }
                if (status == "False")
                {
                    getsupplier.status = "InActive";
                }
                getsupplier.supplierid = dr["supplierid"].ToString();
                getsupplier.imgpath = dr["supplierphoto"].ToString();
                getsupplier.vendorcode = dr["suppliercode"].ToString();
                getsupplier.gst_no = dr["GSTIN"].ToString();
                getsupplier.gst_type = dr["regtype"].ToString();
                getsupplier.pan_no = dr["panno"].ToString();
                getsupplier.bank_acc_no = dr["bankaccountno"].ToString();
                getsupplier.bank_ifsc = dr["bankifsccode"].ToString();
                getsupplier.ftplocation = "ftp://182.18.138.228/PURCHASE/";
                supplierdetails.Add(getsupplier);
            }
            string response = GetJson(supplierdetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void saveProductDetails(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            var js = new JavaScriptSerializer();
            var title1 = context.Request.Params[1];
            ProductDetails obj = js.Deserialize<ProductDetails>(title1);
            string branchid = context.Session["Po_BranchID"].ToString();
            string emp_sno = context.Session["Employ_Sno"].ToString();
            string Productid = obj.productid;
            string productname = obj.productname;
            string productcode = obj.productcode;
            string bin = obj.bin;
            string hsn_code = obj.hsn_code;
            string igst = obj.igst;
            string cgst = obj.cgst;
            string sgst = obj.sgst;
            string gst_tax_cat = obj.gst_tax_cat;
            string itemcode = obj.itemcode;
            string shortname = obj.shortname;
            string sku = obj.sku;
            string description = obj.description;
            string sectionid = obj.sectionid;
            if (sectionid == "Select Section")
            {
                sectionid = "0";
            }

            string brandid = obj.brandid;
            if (brandid == "Select Brand")
            {
                brandid = "0";
            }
            string supplierid = obj.supplierid;
            if (supplierid == "Select Supplier")
            {
                supplierid = "0";
            }
            string subcategoryid = obj.subcategoryid;
            if (subcategoryid == "Select SubCategory")
            {
                subcategoryid = "0";
            }
            string modifierset = obj.modifierset;
            string availablestores = obj.availablestores;
            string uim = obj.uim;
            if (uim == "Select Uim")
            {
                uim = "0";
            }
            string price = obj.price;
            string createdby = context.Session["Employ_Sno"].ToString();
            DateTime createdon = DateTime.Now;
            string btnSave = obj.btnVal;
            if (btnSave == "save")
            {
                cmd = new SqlCommand("insert into productmaster (productname,productcode,sub_cat_code,sku,description,sectionid,brandid,supplierid,subcategoryid,modifierset,availablestores,uim,createdby,createdon,price,branchid,itemcode,bin,HSNcode,IGST,CGST,SGST,gsttaxcategory,categoryid ) values (@productname,@productcode,@sub_cat_code,@sku,@description,@sectionid,@brandid,@supplierid,@subcategoryid,@modifierset,@availablestores,@uim,@createdby,@createdon,@price,@branchid,@itemcode,@bin,@hsn_code,@igst,@cgst,@sgst,@gst_tax_cat,@categoryid)");//,color,@color
                cmd.Parameters.Add("@productname", productname);
                cmd.Parameters.Add("@productcode", productcode);
                cmd.Parameters.Add("@sub_cat_code", shortname);
                cmd.Parameters.Add("@sku", sku);
                cmd.Parameters.Add("@description", description);
                cmd.Parameters.Add("@sectionid", sectionid);
                cmd.Parameters.Add("@brandid", brandid);
                cmd.Parameters.Add("@supplierid", supplierid);
                cmd.Parameters.Add("@subcategoryid", subcategoryid);
                cmd.Parameters.Add("@modifierset", modifierset);
                cmd.Parameters.Add("@availablestores", availablestores);
                cmd.Parameters.Add("@price", price);
                cmd.Parameters.Add("@uim", uim);
                cmd.Parameters.Add("@bin", bin);
                cmd.Parameters.Add("@itemcode", itemcode);
                cmd.Parameters.Add("@createdby", createdby);
                cmd.Parameters.Add("@createdon", createdon);
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@hsn_code", hsn_code);
                cmd.Parameters.Add("@igst", igst);
                cmd.Parameters.Add("@cgst", cgst);
                cmd.Parameters.Add("@sgst", sgst);
                cmd.Parameters.Add("@gst_tax_cat", gst_tax_cat);
                cmd.Parameters.Add("@categoryid", sectionid);
                vdm.insert(cmd);

                cmd = new SqlCommand("Select max(productid) as maxno from productmaster WHERE branchid=@branchid");
                cmd.Parameters.Add("@branchid", branchid);
                DataTable dtroutes = vdm.SelectQuery(cmd).Tables[0];
                if (dtroutes.Rows.Count > 0)
                {
                    string maxno = dtroutes.Rows[0]["maxno"].ToString();
                    foreach (Product_supplier dr in obj.suppliers)
                    {
                        cmd = new SqlCommand("select itemid,supplierid,sno from itemsupplierdetails where itemid=@itemid and supplierid=@supplierid");
                        cmd.Parameters.Add("@itemid", maxno);
                        cmd.Parameters.Add("@supplierid", dr.supplierid);
                        DataTable dt_det = vdm.SelectQuery(cmd).Tables[0];

                        if (dt_det.Rows.Count > 0)
                        {

                        }
                        else
                        {
                            cmd = new SqlCommand("insert into itemsupplierdetails(itemid,supplierid,doe,createdby) values (@itemid,@supplierid,@doe,@createdby)");
                            cmd.Parameters.Add("@itemid", maxno);
                            cmd.Parameters.Add("@supplierid", dr.supplierid);
                            cmd.Parameters.Add("@doe", createdon);
                            cmd.Parameters.Add("@createdby", emp_sno);
                            vdm.insert(cmd);
                        }
                    }

                    cmd = new SqlCommand("Update productmoniter set qty=qty+@qty where productid=@productid AND branchid=@branchid");
                    cmd.Parameters.Add("@qty", availablestores);
                    cmd.Parameters.Add("@productid", maxno);
                    cmd.Parameters.Add("@branchid", branchid);
                    if (vdm.Update(cmd) == 0)
                    {
                        cmd = new SqlCommand("Insert INTO productmoniter(productid, qty, branchid) values (@productid, @qty, @branchid)");
                        cmd.Parameters.Add("@qty", availablestores);
                        cmd.Parameters.Add("@productid", maxno);
                        cmd.Parameters.Add("@branchid", branchid);
                        vdm.insert(cmd);
                    }
                }
                string msg = "Product Details  are successfully saved";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {
                cmd = new SqlCommand("select * from productmoniter where  productid=@productid AND branchid=@branchid");
                cmd.Parameters.Add("@productid", Productid);
                cmd.Parameters.Add("@branchid", branchid);
                DataTable dtprev = vdm.SelectQuery(cmd).Tables[0];
                float prevqty = 0;
                if (dtprev.Rows.Count > 0)
                {
                    string amount = dtprev.Rows[0]["qty"].ToString();
                    float.TryParse(amount, out prevqty);
                }

                cmd = new SqlCommand("Update productmaster set productname=@productname,productcode=@productcode,sub_cat_code=@sub_cat_code,sku=@sku,description=@description,sectionid=@sectionid,brandid=@brandid,price=@price,supplierid=@supplierid,subcategoryid=@subcategoryid,modifierset=@modifierset,availablestores=@availablestores,uim=@uim,bin=@bin,itemcode=@itemcode,HSNcode=@hsn_code,IGST=@igst,CGST=@cgst,SGST=@sgst,gsttaxcategory=@gst_tax_cat where productid=@productid");//,color=@color
                cmd.Parameters.Add("@productname", productname);
                cmd.Parameters.Add("@productcode", productcode);
                cmd.Parameters.Add("@sub_cat_code", shortname);
                cmd.Parameters.Add("@sku", sku);
                cmd.Parameters.Add("@description", description);
                cmd.Parameters.Add("@sectionid", sectionid);
                cmd.Parameters.Add("@brandid", brandid);
                cmd.Parameters.Add("@price", price);
                cmd.Parameters.Add("@supplierid", supplierid);
                cmd.Parameters.Add("@subcategoryid", subcategoryid);
                cmd.Parameters.Add("@modifierset", modifierset);
                cmd.Parameters.Add("@availablestores", availablestores);
                cmd.Parameters.Add("@uim", uim);
                cmd.Parameters.Add("@bin", bin);
                cmd.Parameters.Add("@itemcode", itemcode);
                cmd.Parameters.Add("@productid", Productid);
                cmd.Parameters.Add("@hsn_code", hsn_code);
                cmd.Parameters.Add("@igst", igst);
                cmd.Parameters.Add("@cgst", cgst);
                cmd.Parameters.Add("@sgst", sgst);
                cmd.Parameters.Add("@gst_tax_cat", gst_tax_cat);
                
                if (vdm.Update(cmd) == 0)
                {
                    cmd = new SqlCommand("insert into productmaster (productname,productcode,sub_cat_code,sku,description,sectionid,brandid,supplierid,subcategoryid,modifierset,availablestores,uim,createdby,createdon,price,branchid,itemcode,bin ) values (@productname,@productcode,@sub_cat_code,@sku,@description,@sectionid,@brandid,@supplierid,@subcategoryid,@modifierset,@availablestores,@uim,@createdby,@createdon,@price,@branchid,@itemcode,@bin)");//,color,@color
                    cmd.Parameters.Add("@productname", productname);
                    cmd.Parameters.Add("@productcode", productcode);
                    cmd.Parameters.Add("@sub_cat_code", shortname);
                    cmd.Parameters.Add("@sku", sku);
                    cmd.Parameters.Add("@description", description);
                    cmd.Parameters.Add("@sectionid", sectionid);
                    cmd.Parameters.Add("@brandid", brandid);
                    cmd.Parameters.Add("@supplierid", supplierid);
                    cmd.Parameters.Add("@subcategoryid", subcategoryid);
                    cmd.Parameters.Add("@modifierset", modifierset);
                    cmd.Parameters.Add("@availablestores", availablestores);
                    cmd.Parameters.Add("@price", price);
                    cmd.Parameters.Add("@uim", uim);
                    cmd.Parameters.Add("@bin", bin);
                    cmd.Parameters.Add("@itemcode", itemcode);
                    cmd.Parameters.Add("@branchid", branchid);
                    vdm.insert(cmd);
                }

                foreach (Product_supplier dr in obj.suppliers)
                {
                    cmd = new SqlCommand("update itemsupplierdetails set itemid=@itemid,supplierid=@supplierid where sno=@sno");
                    cmd.Parameters.Add("@itemid", Productid);
                    cmd.Parameters.Add("@supplierid", dr.supplierid);
                    cmd.Parameters.Add("@sno", dr.sno);
                    if (vdm.Update(cmd) == 0)
                    {
                        cmd = new SqlCommand("select itemid,supplierid,sno from itemsupplierdetails where itemid=@itemid and supplierid=@supplierid");
                        cmd.Parameters.Add("@itemid", Productid);
                        cmd.Parameters.Add("@supplierid", dr.supplierid);
                        DataTable dt_det = vdm.SelectQuery(cmd).Tables[0];
                        if (dt_det.Rows.Count > 0)
                        {

                        }
                        else
                        {
                            cmd = new SqlCommand("insert into itemsupplierdetails(itemid,supplierid,doe,createdby) values (@itemid,@supplierid,@doe,@createdby)");
                            cmd.Parameters.Add("@itemid", Productid);
                            cmd.Parameters.Add("@supplierid", dr.supplierid);
                            cmd.Parameters.Add("@doe", createdon);
                            cmd.Parameters.Add("@createdby", emp_sno);
                            vdm.insert(cmd);
                        }
                    }
                }

                //float presentqty = 0;
                //float.TryParse(availablestores, out presentqty);
                //double editqty = 0;
                //if (presentqty >= prevqty)
                //{
                //    editqty = presentqty - prevqty;
                //    cmd = new SqlCommand("UPDATE productmoniter set qty=qty+@new_quantity where productid=@productid AND branchid=@branchid");
                //    cmd.Parameters.Add("@productid", Productid);
                //    cmd.Parameters.Add("@new_quantity", editqty);
                //    cmd.Parameters.Add("@branchid", branchid);

                //    if (vdm.Update(cmd) == 0)
                //    {
                //        cmd = new SqlCommand("insert into productmoniter (productid,qty,branchid) values(@productid,@qty,@branchid)");
                //        cmd.Parameters.Add("@productid", Productid);
                //        cmd.Parameters.Add("@qty", availablestores);
                //        cmd.Parameters.Add("@branchid", branchid);
                //        vdm.insert(cmd);
                //    }
                //}
                //else
                //{
                //    editqty = prevqty - presentqty;
                //    cmd = new SqlCommand("UPDATE productmoniter set qty=qty-@new_quantity where productid=@productid AND branchid=@branchid");
                //    cmd.Parameters.Add("@productid", Productid);
                //    cmd.Parameters.Add("@new_quantity", editqty);
                //    cmd.Parameters.Add("@branchid", branchid);
                //    if (vdm.Update(cmd) == 0)
                //    {
                //        cmd = new SqlCommand("insert into productmoniter (productid,qty,branchid) values(@productid,@qty,@branchid)");
                //        cmd.Parameters.Add("@productid", Productid);
                //        cmd.Parameters.Add("@qty", availablestores);
                //        cmd.Parameters.Add("@branchid", branchid);
                //        vdm.insert(cmd);
                //    }

                //}
                string msg = "Product Details successfully updated";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private bool UploadpicToFTP(HttpPostedFile fileToUpload, string filename)
    {
        // Get the object used to communicate with the server.
        string uploadUrl = "ftp://182.18.138.228/PURCHASE/";
        // string fileName = fileToUpload.FileName;
        try
        {
            FtpWebRequest del_request = (FtpWebRequest)WebRequest.Create(uploadUrl + @"/" + filename);
            del_request.Credentials = new NetworkCredential("ftpuser", "ftpuser@123");
            del_request.Method = WebRequestMethods.Ftp.DeleteFile;
            FtpWebResponse delete_response = (FtpWebResponse)del_request.GetResponse();
            Console.WriteLine("Delete status: {0}", delete_response.StatusDescription);
            delete_response.Close();
        }
        catch
        {
        }
        FtpWebRequest request = (FtpWebRequest)WebRequest.Create(uploadUrl + @"/" + filename);
        request.Credentials = new NetworkCredential("ftpvys", "Vyshnavi123");
        request.Method = WebRequestMethods.Ftp.UploadFile;
        byte[] fileContents = null;
        using (var binaryReader = new BinaryReader(fileToUpload.InputStream))
        {
            fileContents = binaryReader.ReadBytes(fileToUpload.ContentLength);
        }
        request.ContentLength = fileContents.Length;
        Stream requestStream = request.GetRequestStream();
        requestStream.Write(fileContents, 0, fileContents.Length);
        requestStream.Close();
        FtpWebResponse response = (FtpWebResponse)request.GetResponse();
        response.Close();
        return true;
    }

    private void saveScrapItemDetails(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string branchid = context.Session["Po_BranchID"].ToString();
            string Productid = context.Request["ProductId"];
            string productname = context.Request["ScrapItemName"];
            string productcode = context.Request["MainCode"];
            string sku = context.Request["SKU"];
            string description = context.Request["Description"];
            string categoryid = context.Request["categoryid"];
            string subcategoryid = context.Request["subcategoryid"];
            string uim = context.Request["uim"];
            if (uim == "Select Uim")
            {
                uim = "0";
            }
            string price = context.Request["price"];
            string subcode = context.Request["subcode"];
            string createdby = context.Session["Employ_Sno"].ToString();
            DateTime createdon = DateTime.Now;
            string btnSave = context.Request["btnVal"];
            if (btnSave == "save")
            {
                cmd = new SqlCommand("insert into scrapitemdetails (itemname,itemcode,sku,description,categoryid,uom,price,branchid,subcatid,subcode) values (@itemname,@itemcode,@sku,@description,@categoryid,@uim,@price,@branchid,@subcategoryid,@subcode)");
                cmd.Parameters.Add("@itemname", productname);
                cmd.Parameters.Add("@itemcode", productcode);
                cmd.Parameters.Add("@sku", sku);
                cmd.Parameters.Add("@description", description);
                cmd.Parameters.Add("@categoryid", categoryid);
                cmd.Parameters.Add("@subcode", subcode);
                cmd.Parameters.Add("@price", price);
                cmd.Parameters.Add("@uim", uim);
                cmd.Parameters.Add("@subcategoryid", subcategoryid);
                cmd.Parameters.Add("@branchid", branchid);
                vdm.insert(cmd);
                string msg = "Scrap Item Details are successfully saved";
                string Response = GetJson(msg);
                context.Response.Write(Response);

            }
            else
            {
                cmd = new SqlCommand("Update scrapitemdetails set itemname=@itemname,subcode=@subcode,subcatid=@subcategoryid,itemcode=@itemcode,sku=@sku,description=@description,categoryid=@categoryid,uom=@uom,price=@price,branchid=@branchid where sno=@productid AND  branchid=@branchid");
                cmd.Parameters.Add("@itemname", productname);
                cmd.Parameters.Add("@itemcode", productcode);
                cmd.Parameters.Add("@sku", sku);
                cmd.Parameters.Add("@description", description);
                cmd.Parameters.Add("@categoryid", categoryid);
                cmd.Parameters.Add("@subcategoryid", subcategoryid);
                cmd.Parameters.Add("@price", price);
                cmd.Parameters.Add("@uom", uim);
                cmd.Parameters.Add("@subcode", subcode);
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@productid", Productid);
                if (vdm.Update(cmd) == 0)
                {
                    cmd = new SqlCommand("insert into scrapitemdetails (itemname,itemcode,sku,description,categoryid,uom,price,branchid,subcatid,subcode) values (@itemname,@itemcode,@sku,@description,@categoryid,@uim,@price,@branchid,@subcategoryid,@subcode)");
                    cmd.Parameters.Add("@itemname", productname);
                    cmd.Parameters.Add("@itemcode", productcode);
                    cmd.Parameters.Add("@sku", sku);
                    cmd.Parameters.Add("@description", description);
                    cmd.Parameters.Add("@categoryid", categoryid);
                    cmd.Parameters.Add("@subcategoryid", subcategoryid);
                    cmd.Parameters.Add("@price", price);
                    cmd.Parameters.Add("@uim", uim);
                    cmd.Parameters.Add("@subcode", subcode);
                    cmd.Parameters.Add("@branchid", branchid);
                    cmd.Parameters.Add("@branchid", branchid);
                    vdm.insert(cmd);
                }
                string msg = "Scrap Item Details successfully updated";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class ScrapItemDetails
    {
        public string ItemName { get; set; }
        public string description { get; set; }
        public string sku { get; set; }
        public string category { get; set; }
        public string Itemcode { get; set; }
        public string availablestores { get; set; }
        public string uom { get; set; }
        public string price { get; set; }
        public string moniterqty { get; set; }
        public string puom { get; set; }
        public string categoryid { get; set; }
        public string itemid { get; set; }
        public string availablestores1 { get; set; }
        public string subcategoryid { get; set; }
        public string subcode { get; set; }
    }

    private void get_ScrapItem_details(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT scrapitemdetails.itemname,scrapitemdetails.sno,scrapitemdetails.subcatid,scrapitemdetails.subcode, scrapitemdetails.itemcode, scrapitemdetails.sku, scrapitemdetails.description, scrapitemdetails.categoryid, scrapitemdetails.uom,scrapitemdetails.price, scrapitemdetails.branchid, uimmaster.uim, uimmaster.sno AS puim FROM uimmaster INNER JOIN scrapitemdetails ON uimmaster.sno = scrapitemdetails.uom where scrapitemdetails.branchid=@branchid");
            cmd.Parameters.Add("@branchid", branchid);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<ScrapItemDetails> ScrapItemDetailslist = new List<ScrapItemDetails>();
            foreach (DataRow dr in routes.Rows)
            {
                ScrapItemDetails getScrapItemDetails = new ScrapItemDetails();
                getScrapItemDetails.ItemName = dr["itemname"].ToString();
                getScrapItemDetails.Itemcode = dr["itemcode"].ToString();
                getScrapItemDetails.sku = dr["sku"].ToString();
                getScrapItemDetails.description = dr["description"].ToString();
                getScrapItemDetails.categoryid = dr["categoryid"].ToString();
                getScrapItemDetails.subcategoryid = dr["subcatid"].ToString();
                getScrapItemDetails.subcode = dr["subcode"].ToString();
                getScrapItemDetails.uom = dr["uom"].ToString();
                getScrapItemDetails.puom = dr["puim"].ToString();
                getScrapItemDetails.price = dr["price"].ToString();
                getScrapItemDetails.itemid = dr["sno"].ToString();
                ScrapItemDetailslist.Add(getScrapItemDetails);
            }
            string response = GetJson(ScrapItemDetailslist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class ProductDetails
    {
        public string productname { get; set; }
        public string description { get; set; }
        public string subcatname { get; set; }
        public string sku { get; set; }
        public string category { get; set; }
        public string subcategory { get; set; }
        public string productcode { get; set; }
        public string shortname { get; set; }
        public string modifierset { get; set; }
        public string availablestores { get; set; }
        public string color { get; set; }
        public string uim { get; set; }
        public string bin { get; set; }
        public string itemcode { get; set; }
        public string subcategoryid { get; set; }
        public string brandid { get; set; }
        public string brandname { get; set; }
        public string supplierid { get; set; }
        public string price { get; set; }
        public string moniterqty { get; set; }
        public string puim { get; set; }
        public string sectionid { get; set; }
        public string productid { get; set; }
        public string suppliername { get; set; }
        public string availablestores1 { get; set; }
        public string imgpath { get; set; }
        public string ftplocation { get; set; }
        public string minstock { get; set; }
        public string maxstock { get; set; }
        public string btnVal { get; set; }
        public string hsn_code { get; set; }
        public string sgst { get; set; }
        public string cgst { get; set; }
        public string igst { get; set; }
        public string sno { get; set; }
        public string state { get; set; }
        public List<Product_supplier> suppliers { get; set; }
        public string morestockcount { get; set; }
        public string productcount { get; set; }
        public string lowstockcount { get; set; }
        public string zerostockcount { get; set; }
        public string gst_tax_cat { get; set; }
        public string gstprice { get; set; }

        
    }

	public class Product_supplier
    {
        public string suppliername { get; set; }
        public string supplierid { get; set; }
        public string productid { get; set; }
        public string sno { get; set; }
        public string imgpath { get; set; }
        public string ftplocation { get; set; }

    }

    private void get_product_details(HttpContext context)
    {
        try
        {
            DataTable dtproducts = new DataTable();
            vdm = new SalesDBManager();
            string branchid = context.Session["Po_BranchID"].ToString();
            if (context.Session["Productdata"] == null)
            {
                cmd = new SqlCommand("SELECT productmaster.gsttaxcategory, productmaster.HSNcode, productmaster.IGST, productmaster.CGST, productmaster.SGST, productmaster.imgpath,productmaster.itemcode, productmaster.bin, productmaster.productid, productmaster.subcategoryid, productmoniter.qty, productmoniter.branchid, productmaster.productname, productmaster.productcode, productmaster.sub_cat_code, productmaster.sku, productmaster.description, productmaster.sectionid, productmaster.brandid, productmaster.supplierid, productmaster.modifierset, uimmaster.uim, productmaster.availablestores, productmaster.color, productmaster.uim AS puim, productmoniter.price FROM  productmaster LEFT OUTER JOIN   productmoniter ON productmaster.productid = productmoniter.productid LEFT OUTER JOIN uimmaster ON uimmaster.sno = productmaster.uim");
                cmd.Parameters.Add("@bid", branchid);
                dtproducts = vdm.SelectQuery(cmd).Tables[0];
            }
            else
            {
                context.Session["Productdata"] = dtproducts;
            }
            cmd = new SqlCommand("select statename from branchmaster where branchid=@bid");
            cmd.Parameters.Add("@bid", branchid);
            DataTable dt_branch = vdm.SelectQuery(cmd).Tables[0];
            string state = dt_branch.Rows[0]["statename"].ToString();
            List<ProductDetails> ProductDetails = new List<ProductDetails>();
            foreach (DataRow dr in dtproducts.Rows)
            {
                string bid = dr["branchid"].ToString();
                ProductDetails getproductdetails = new ProductDetails();
                getproductdetails.productname = dr["productname"].ToString();
                getproductdetails.productcode = dr["productcode"].ToString();
                getproductdetails.shortname = dr["sub_cat_code"].ToString();
                getproductdetails.sku = dr["sku"].ToString();
                getproductdetails.bin = dr["bin"].ToString();
                getproductdetails.itemcode = dr["itemcode"].ToString();
                getproductdetails.description = dr["description"].ToString();
                getproductdetails.sectionid = dr["sectionid"].ToString();
                getproductdetails.brandid = dr["brandid"].ToString();
                getproductdetails.supplierid = dr["supplierid"].ToString();
                getproductdetails.sectionid = dr["sectionid"].ToString();
                getproductdetails.modifierset = dr["modifierset"].ToString();
                string qty = dr["qty"].ToString();
                double quantity = 0;
                if (qty == "0" || qty == "")
                {
                    getproductdetails.moniterqty = quantity.ToString();
                }
                else
                {
                    quantity = Convert.ToDouble(dr["qty"].ToString());
                    quantity = Math.Round(quantity, 2);
                    getproductdetails.moniterqty = quantity.ToString();
                }
                
                getproductdetails.availablestores1 = dr["availablestores"].ToString();
                getproductdetails.color = dr["color"].ToString();
                getproductdetails.uim = dr["uim"].ToString();
                getproductdetails.puim = dr["puim"].ToString();
                getproductdetails.price = dr["price"].ToString();
                getproductdetails.productid = dr["productid"].ToString();
                getproductdetails.subcategoryid = dr["subcategoryid"].ToString();
				getproductdetails.imgpath = dr["imgpath"].ToString();
                getproductdetails.hsn_code = dr["HSNcode"].ToString();
                getproductdetails.igst = dr["IGST"].ToString();
                getproductdetails.cgst = dr["CGST"].ToString();
                getproductdetails.sgst = dr["SGST"].ToString();
                getproductdetails.gst_tax_cat = dr["gsttaxcategory"].ToString();
                getproductdetails.state = state;
                getproductdetails.ftplocation = "ftp://182.18.138.228/PURCHASE/";
                ProductDetails.Add(getproductdetails);
            }
            string response = GetJson(ProductDetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_product_details_po(HttpContext context)
    {
        try
        {
            DataTable dtproducts = new DataTable();
            vdm = new SalesDBManager();
            string branchid = context.Session["Po_BranchID"].ToString();
            if (context.Session["Productdata"] == null)
            {
                cmd = new SqlCommand("SELECT productmaster.productname, productmaster.gsttaxcategory, productmaster.HSNcode, productmaster.IGST, productmaster.CGST, productmaster.SGST, productmaster.imgpath,productmaster.itemcode, productmaster.bin, productmaster.productid, productmaster.subcategoryid, productmaster.productcode, productmaster.sub_cat_code, productmaster.sku, productmaster.description, productmaster.sectionid, productmaster.brandid, productmaster.supplierid, productmaster.modifierset, uimmaster.uim, productmaster.availablestores, productmaster.color, productmaster.uim AS puim FROM productmaster LEFT OUTER JOIN uimmaster ON uimmaster.sno = productmaster.uim");
                cmd.Parameters.Add("@bid", branchid);
                dtproducts = vdm.SelectQuery(cmd).Tables[0];
            }
            else
            {
                context.Session["Productdata"] = dtproducts;
            }
            cmd = new SqlCommand("select statename from branchmaster where branchid=@bid");
            cmd.Parameters.Add("@bid", branchid);
            DataTable dt_branch = vdm.SelectQuery(cmd).Tables[0];
            string state = dt_branch.Rows[0]["statename"].ToString();
            List<ProductDetails> ProductDetails = new List<ProductDetails>();
            foreach (DataRow dr in dtproducts.Rows)
            {
                ProductDetails getproductdetails = new ProductDetails();
                getproductdetails.productname = dr["productname"].ToString();
                getproductdetails.productcode = dr["productcode"].ToString();
                getproductdetails.shortname = dr["sub_cat_code"].ToString();
                getproductdetails.sku = dr["sku"].ToString();
                getproductdetails.bin = dr["bin"].ToString();
                getproductdetails.itemcode = dr["itemcode"].ToString();
                getproductdetails.description = dr["description"].ToString();
                getproductdetails.sectionid = dr["sectionid"].ToString();
                getproductdetails.brandid = dr["brandid"].ToString();
                getproductdetails.supplierid = dr["supplierid"].ToString();
                getproductdetails.sectionid = dr["sectionid"].ToString();
                getproductdetails.modifierset = dr["modifierset"].ToString();
                getproductdetails.availablestores1 = dr["availablestores"].ToString();
                getproductdetails.color = dr["color"].ToString();
                getproductdetails.uim = dr["uim"].ToString();
                getproductdetails.puim = dr["puim"].ToString();
                getproductdetails.productid = dr["productid"].ToString();
                getproductdetails.subcategoryid = dr["subcategoryid"].ToString();
                getproductdetails.imgpath = dr["imgpath"].ToString();
                getproductdetails.hsn_code = dr["HSNcode"].ToString();
                getproductdetails.igst = dr["IGST"].ToString();
                getproductdetails.cgst = dr["CGST"].ToString();
                getproductdetails.sgst = dr["SGST"].ToString();
                getproductdetails.gst_tax_cat = dr["gsttaxcategory"].ToString();
                getproductdetails.state = state;
                getproductdetails.ftplocation = "ftp://182.18.138.228/PURCHASE/";
                ProductDetails.Add(getproductdetails);
            }
            string response = GetJson(ProductDetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_product_detail_branch(HttpContext context)
    {
        try
        {
            DataTable dtproducts = new DataTable();
            vdm = new SalesDBManager();
            string branchid = context.Session["Po_BranchID"].ToString();
            if (context.Session["Productdata"] == null)
            {
                cmd = new SqlCommand("SELECT productmaster.gsttaxcategory, productmaster.HSNcode, productmaster.IGST, productmaster.CGST, productmaster.SGST, productmaster.itemcode, productmaster.imgpath, productmaster.bin, productmaster.productid, productmaster.subcategoryid, productmaster.productname, productmaster.productcode, productmaster.sub_cat_code, productmaster.sku, productmaster.description, productmaster.sectionid, productmaster.brandid, productmaster.supplierid, productmaster.modifierset, uimmaster.uim, productmaster.availablestores, productmaster.color, productmaster.uim AS puim FROM  productmaster LEFT OUTER JOIN uimmaster ON uimmaster.sno = productmaster.uim");
                cmd.Parameters.Add("@bid", branchid);
                dtproducts = vdm.SelectQuery(cmd).Tables[0];
            }
            else
            {
                context.Session["Productdata"] = dtproducts;
            }
            cmd = new SqlCommand("select statename from branchmaster where branchid=@bid");
            cmd.Parameters.Add("@bid", branchid);
            DataTable dt_branch = vdm.SelectQuery(cmd).Tables[0];
            string state = dt_branch.Rows[0]["statename"].ToString();
            List<ProductDetails> ProductDetails = new List<ProductDetails>();
            foreach (DataRow dr in dtproducts.Rows)
            {
                //string bid = dr["branchid"].ToString();
                string productid = dr["productid"].ToString();
                cmd = new SqlCommand("Select productmoniter.qty,productmoniter.price from productmoniter where productmoniter.branchid = @branchid and productmoniter.productid = @productid");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@productid", productid);
                DataTable dt_product_moniter = vdm.SelectQuery(cmd).Tables[0];

                ProductDetails getproductdetails = new ProductDetails();
                getproductdetails.productname = dr["productname"].ToString();
                getproductdetails.productcode = dr["productcode"].ToString();
                getproductdetails.productid = dr["productid"].ToString();
                getproductdetails.shortname = dr["sub_cat_code"].ToString();
                getproductdetails.sku = dr["sku"].ToString();
                getproductdetails.bin = dr["bin"].ToString();
                getproductdetails.itemcode = dr["itemcode"].ToString();
                getproductdetails.description = dr["description"].ToString();
                getproductdetails.sectionid = dr["sectionid"].ToString();
                getproductdetails.brandid = dr["brandid"].ToString();
                getproductdetails.supplierid = dr["supplierid"].ToString();
                getproductdetails.sectionid = dr["sectionid"].ToString();
                getproductdetails.modifierset = dr["modifierset"].ToString();
                string qty = dt_product_moniter.Rows[0]["qty"].ToString(); //dr["qty"].ToString();
                double quantity = 0;
                if (qty == "0" || qty == "")
                {
                    getproductdetails.moniterqty = quantity.ToString();
                }
                else
                {
                    quantity = Convert.ToDouble(dt_product_moniter.Rows[0]["qty"].ToString());
                    quantity = Math.Round(quantity, 2);
                    getproductdetails.moniterqty = quantity.ToString();
                }
                getproductdetails.availablestores1 = dr["availablestores"].ToString();
                getproductdetails.color = dr["color"].ToString();
                getproductdetails.uim = dr["uim"].ToString();
                getproductdetails.puim = dr["puim"].ToString();
                getproductdetails.price = dt_product_moniter.Rows[0]["price"].ToString(); //dr["price"].ToString();
                getproductdetails.subcategoryid = dr["subcategoryid"].ToString();
                getproductdetails.hsn_code = dr["HSNcode"].ToString();
                getproductdetails.igst = dr["IGST"].ToString();
                getproductdetails.cgst = dr["CGST"].ToString();
                getproductdetails.sgst = dr["SGST"].ToString();
                getproductdetails.gst_tax_cat = dr["gsttaxcategory"].ToString();
                getproductdetails.state = state;
                getproductdetails.imgpath = dr["imgpath"].ToString();
                getproductdetails.ftplocation = "ftp://182.18.138.228/PURCHASE/";
                ProductDetails.Add(getproductdetails);
            }
            string response = GetJson(ProductDetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_productissue_details(HttpContext context)
    {
        try
        {
            DataTable dtproducts = new DataTable();
            vdm = new SalesDBManager();
            string branchid = context.Session["Po_BranchID"].ToString();
            if (context.Session["Productdata"] == null)
            {
                cmd = new SqlCommand("SELECT productmaster.gsttaxcategory, productmaster.HSNcode, productmaster.IGST, productmaster.CGST, productmaster.SGST, productmaster.itemcode, productmaster.imgpath, productmaster.bin, productmaster.productid, productmaster.subcategoryid, productmoniter.qty, productmoniter.branchid, productmaster.productname, productmaster.productcode, productmaster.sub_cat_code, productmaster.sku, productmaster.description, productmaster.sectionid, productmaster.brandid, productmaster.supplierid, productmaster.modifierset, uimmaster.uim, productmaster.availablestores, productmaster.color, productmaster.uim AS puim, productmoniter.price FROM  productmaster LEFT OUTER JOIN   productmoniter ON productmaster.productid = productmoniter.productid LEFT OUTER JOIN uimmaster ON uimmaster.sno = productmaster.uim WHERE productmoniter.branchid=@bid ORDER BY productmaster.productid");
                cmd.Parameters.Add("@bid", branchid);
                dtproducts = vdm.SelectQuery(cmd).Tables[0];
            }
            else
            {
                context.Session["Productdata"] = dtproducts;
            }
            cmd = new SqlCommand("select statename from branchmaster where branchid=@bid");
            cmd.Parameters.Add("@bid", branchid);
            DataTable dt_branch = vdm.SelectQuery(cmd).Tables[0];
            string state = dt_branch.Rows[0]["statename"].ToString();
            List<ProductDetails> ProductDetails = new List<ProductDetails>();
            foreach (DataRow dr in dtproducts.Rows)
            {
                string bid = dr["branchid"].ToString();
                ProductDetails getproductdetails = new ProductDetails();
                getproductdetails.productname = dr["productname"].ToString();
                getproductdetails.productcode = dr["productcode"].ToString();
                getproductdetails.shortname = dr["sub_cat_code"].ToString();
                getproductdetails.sku = dr["sku"].ToString();
                getproductdetails.bin = dr["bin"].ToString();
                getproductdetails.itemcode = dr["itemcode"].ToString();
                getproductdetails.description = dr["description"].ToString();
                getproductdetails.sectionid = dr["sectionid"].ToString();
                getproductdetails.brandid = dr["brandid"].ToString();
                getproductdetails.supplierid = dr["supplierid"].ToString();
                getproductdetails.sectionid = dr["sectionid"].ToString();
                getproductdetails.modifierset = dr["modifierset"].ToString();

                string qty = dr["qty"].ToString();
                double quantity = 0;
                if (qty == "0" || qty == "")
                {
                    getproductdetails.moniterqty = quantity.ToString();
                    //double rate = 0;
                    //String unitprice = dr["price"].ToString();
                    //double Igst = 0; double Igstamount = 0;
                    //double totRate = 0;
                    //double.TryParse(dr["IGST"].ToString(), out Igst);
                    //double.TryParse(unitprice, out rate);
                    //double toatalamt = rate * quantity;
                    //Igstamount = (toatalamt * Igst) / 100;
                    //Igstamount = Math.Round(Igstamount, 2);
                    //double PAmount = toatalamt + Igstamount;//+ cgstamount + sgstamount + pfamount;
                    //double total = PAmount;// + frie + trans;
                    //double actualrate = total / quantity;
                    //double Vatrate = Math.Round(actualrate, 2);
                    getproductdetails.price = dr["price"].ToString();
                }
                else
                {
                    quantity = Convert.ToDouble(dr["qty"].ToString());
                    quantity = Math.Round(quantity, 2);
                    getproductdetails.moniterqty = quantity.ToString();
                    double rate = 0;
                    String unitprice = dr["price"].ToString();
                    double Igst = 0; double Igstamount = 0;
                    double totRate = 0;
                    double.TryParse(dr["IGST"].ToString(), out Igst);
                    double.TryParse(unitprice, out rate);
                    double toatalamt = rate * quantity;
                    Igstamount = (toatalamt * Igst) / 100;
                    Igstamount = Math.Round(Igstamount, 2);
                    double PAmount = toatalamt + Igstamount;//+ cgstamount + sgstamount + pfamount;
                    double total = PAmount;// + frie + trans;
                    double actualrate = total / quantity;
                    double Vatrate = Math.Round(actualrate, 2);
                    getproductdetails.price = Vatrate.ToString();
                }
                getproductdetails.availablestores1 = dr["availablestores"].ToString();
                getproductdetails.color = dr["color"].ToString();
                getproductdetails.uim = dr["uim"].ToString();
                getproductdetails.puim = dr["puim"].ToString();
                getproductdetails.productid = dr["productid"].ToString();
                getproductdetails.subcategoryid = dr["subcategoryid"].ToString();
                getproductdetails.hsn_code = dr["HSNcode"].ToString();
                getproductdetails.igst = dr["IGST"].ToString();
                getproductdetails.cgst = dr["CGST"].ToString();
                getproductdetails.sgst = dr["SGST"].ToString();

                getproductdetails.gst_tax_cat = dr["gsttaxcategory"].ToString();
                //getproductdetails.price = dr["price"].ToString();
                getproductdetails.state = state;
                getproductdetails.imgpath = dr["imgpath"].ToString();
                getproductdetails.ftplocation = "ftp://182.18.138.228/PURCHASE/";
                ProductDetails.Add(getproductdetails);
            }

            string response = GetJson(ProductDetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_branchwiseproduct_details(HttpContext context)
    {
        try
        {
            DataTable dtproducts = new DataTable();
            vdm = new SalesDBManager();
            string branchid = context.Session["Po_BranchID"].ToString();
            if (context.Session["Productdata"] == null)
            {
                cmd = new SqlCommand("SELECT productmaster.gsttaxcategory, productmaster.HSNcode, productmaster.IGST, productmaster.CGST, productmaster.SGST, productmaster.imgpath, productmaster.itemcode, productmaster.bin, productmaster.productid, productmaster.subcategoryid, productmoniter.qty, productmaster.productname, productmaster.productcode, productmaster.sub_cat_code, productmaster.sku, productmaster.description, productmaster.sectionid, productmaster.brandid, productmaster.supplierid, productmaster.modifierset, uimmaster.uim, productmaster.availablestores, productmaster.color, productmaster.uim AS puim, productmoniter.price FROM  productmaster LEFT OUTER JOIN   productmoniter ON productmaster.productid = productmoniter.productid LEFT OUTER JOIN uimmaster ON uimmaster.sno = productmaster.uim WHERE productmoniter.branchid=@bid");
                cmd.Parameters.Add("@bid", branchid);
                dtproducts = vdm.SelectQuery(cmd).Tables[0];
            }
            else
            {
                context.Session["Productdata"] = dtproducts;
            }
            cmd = new SqlCommand("select statename from branchmaster where branchid=@bid");
            cmd.Parameters.Add("@bid", branchid);
            DataTable dt_branch = vdm.SelectQuery(cmd).Tables[0];
            string branch_state = dt_branch.Rows[0]["statename"].ToString();
            List<ProductDetails> ProductDetails = new List<ProductDetails>();
            foreach (DataRow dr in dtproducts.Rows)
            {
                ProductDetails getproductdetails = new ProductDetails();
                getproductdetails.productname = dr["productname"].ToString();
                getproductdetails.productcode = dr["productcode"].ToString();
                getproductdetails.shortname = dr["sub_cat_code"].ToString();
                getproductdetails.sku = dr["sku"].ToString();
                getproductdetails.bin = dr["bin"].ToString();
                getproductdetails.itemcode = dr["itemcode"].ToString();
                getproductdetails.description = dr["description"].ToString();
                getproductdetails.sectionid = dr["sectionid"].ToString();
                getproductdetails.brandid = dr["brandid"].ToString();
                getproductdetails.supplierid = dr["supplierid"].ToString();
                getproductdetails.sectionid = dr["sectionid"].ToString();
                getproductdetails.modifierset = dr["modifierset"].ToString();
                string qty = dr["qty"].ToString();
                double quantity = 0;
                if (qty == "0" || qty == "")
                {
                    getproductdetails.moniterqty = quantity.ToString();
                }
                else
                {
                    quantity = Convert.ToDouble(dr["qty"].ToString());
                    quantity = Math.Round(quantity, 2);
                    getproductdetails.moniterqty = quantity.ToString();
                }
                getproductdetails.availablestores1 = dr["availablestores"].ToString();
                getproductdetails.color = dr["color"].ToString();
                getproductdetails.uim = dr["uim"].ToString();
                getproductdetails.puim = dr["puim"].ToString();
                getproductdetails.price = dr["price"].ToString();
                getproductdetails.productid = dr["productid"].ToString();
                getproductdetails.subcategoryid = dr["subcategoryid"].ToString();
                getproductdetails.hsn_code = dr["HSNcode"].ToString();
                getproductdetails.igst = dr["IGST"].ToString();
                getproductdetails.cgst = dr["CGST"].ToString();
                getproductdetails.sgst = dr["SGST"].ToString();
                getproductdetails.gst_tax_cat = dr["gsttaxcategory"].ToString();
                getproductdetails.imgpath = dr["imgpath"].ToString();
                getproductdetails.state = branch_state;
                getproductdetails.ftplocation = "ftp://182.18.138.228/PURCHASE/";
                ProductDetails.Add(getproductdetails);
            }
            string response = GetJson(ProductDetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_products_data_subcatcode(HttpContext context)
    {
        try
        {
            DataTable dtproducts = new DataTable();
            vdm = new SalesDBManager();
            string sub_cat_code = context.Request["sub_cat_code"];
            string cat_code = context.Request["cat_code"];
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT productmoniter.minstock,productmoniter.maxstock,suppliersdetails.name,categorymaster.category,productmaster.gsttaxcategory, productmaster.HSNcode, productmaster.IGST, productmaster.CGST, productmaster.SGST, productmaster.imgpath, productmaster.itemcode, productmaster.bin, productmaster.productid, productmaster.subcategoryid, productmoniter.qty, productmaster.productname, productmaster.productcode, productmaster.sub_cat_code, productmaster.sku, productmaster.description, productmaster.sectionid, productmaster.brandid, productmaster.supplierid, productmaster.modifierset, uimmaster.uim, productmaster.availablestores, productmaster.color, productmaster.uim AS puim, productmoniter.price FROM  productmaster LEFT OUTER JOIN   productmoniter ON productmaster.productid = productmoniter.productid LEFT OUTER JOIN categorymaster ON categorymaster.cat_code = productmaster.productcode LEFT OUTER JOIN uimmaster ON uimmaster.sno = productmaster.uim LEFT OUTER JOIN suppliersdetails ON suppliersdetails.supplierid = productmaster.supplierid WHERE productmoniter.branchid=@bid AND productmaster.productcode = @cat_code AND productmaster.sub_cat_code = @sub_cat_code");// AND (productmoniter.qty > 0)
            cmd.Parameters.Add("@bid", branchid);
            cmd.Parameters.Add("@sub_cat_code", sub_cat_code);
            cmd.Parameters.Add("@cat_code", cat_code);
            dtproducts = vdm.SelectQuery(cmd).Tables[0];
            cmd = new SqlCommand("select statename from branchmaster where branchid=@bid");
            cmd.Parameters.Add("@bid", branchid);
            DataTable dt_branch = vdm.SelectQuery(cmd).Tables[0];
            string branch_state = dt_branch.Rows[0]["statename"].ToString();
            List<ProductDetails> ProductDetails = new List<ProductDetails>();
            foreach (DataRow dr in dtproducts.Rows)
            {
                ProductDetails getproductdetails = new ProductDetails();
                getproductdetails.productname = dr["productname"].ToString();
                getproductdetails.productcode = dr["productcode"].ToString();
                getproductdetails.shortname = dr["sub_cat_code"].ToString();
                getproductdetails.sku = dr["sku"].ToString();
                getproductdetails.bin = dr["bin"].ToString();
                getproductdetails.itemcode = dr["itemcode"].ToString();
                getproductdetails.description = dr["description"].ToString();
                getproductdetails.sectionid = dr["sectionid"].ToString();
                getproductdetails.brandid = dr["brandid"].ToString();
                getproductdetails.supplierid = dr["supplierid"].ToString();
                getproductdetails.sectionid = dr["sectionid"].ToString();
                getproductdetails.modifierset = dr["modifierset"].ToString();
                string qty = dr["qty"].ToString();
                double quantity = 0;
                if (qty == "0" || qty == "")
                {
                    getproductdetails.moniterqty = quantity.ToString();
                }
                else
                {
                    quantity = Convert.ToDouble(dr["qty"].ToString());
                    quantity = Math.Round(quantity, 2);
                    getproductdetails.moniterqty = quantity.ToString();
                }
                getproductdetails.availablestores1 = dr["availablestores"].ToString();
                getproductdetails.color = dr["color"].ToString();
                getproductdetails.uim = dr["uim"].ToString();
                getproductdetails.puim = dr["puim"].ToString();
                getproductdetails.price = dr["price"].ToString();
                getproductdetails.productid = dr["productid"].ToString();
                getproductdetails.subcategoryid = dr["subcategoryid"].ToString();
                getproductdetails.hsn_code = dr["HSNcode"].ToString();
                getproductdetails.igst = dr["IGST"].ToString();
                getproductdetails.cgst = dr["CGST"].ToString();
                getproductdetails.sgst = dr["SGST"].ToString();
                getproductdetails.gst_tax_cat = dr["gsttaxcategory"].ToString();
                getproductdetails.imgpath = dr["imgpath"].ToString();
                getproductdetails.state = branch_state;
                getproductdetails.category = dr["category"].ToString();
                getproductdetails.suppliername = dr["name"].ToString();
                getproductdetails.minstock = dr["minstock"].ToString();
                getproductdetails.maxstock = dr["maxstock"].ToString();
                getproductdetails.ftplocation = "ftp://182.18.138.228/PURCHASE/";
                ProductDetails.Add(getproductdetails);
            }
            string response = GetJson(ProductDetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_products_data_subcatcode_zeroqty(HttpContext context)
    {
        try
        {
            DataTable dtproducts = new DataTable();
            vdm = new SalesDBManager();
            string sub_cat_code = context.Request["sub_cat_code"];
            string cat_code = context.Request["cat_code"];
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT productmoniter.minstock,productmoniter.maxstock,suppliersdetails.name,categorymaster.category,productmaster.gsttaxcategory, productmaster.HSNcode, productmaster.IGST, productmaster.CGST, productmaster.SGST, productmaster.imgpath, productmaster.itemcode, productmaster.bin, productmaster.productid, productmaster.subcategoryid, productmoniter.qty, productmaster.productname, productmaster.productcode, productmaster.sub_cat_code, productmaster.sku, productmaster.description, productmaster.sectionid, productmaster.brandid, productmaster.supplierid, productmaster.modifierset, uimmaster.uim, productmaster.availablestores, productmaster.color, productmaster.uim AS puim, productmoniter.price FROM  productmaster LEFT OUTER JOIN   productmoniter ON productmaster.productid = productmoniter.productid LEFT OUTER JOIN categorymaster ON categorymaster.cat_code = productmaster.productcode LEFT OUTER JOIN uimmaster ON uimmaster.sno = productmaster.uim LEFT OUTER JOIN suppliersdetails ON suppliersdetails.supplierid = productmaster.supplierid WHERE productmoniter.branchid=@bid AND productmaster.productcode = @cat_code AND productmaster.sub_cat_code = @sub_cat_code AND (productmoniter.qty <> 0)");// 
            cmd.Parameters.Add("@bid", branchid);
            cmd.Parameters.Add("@sub_cat_code", sub_cat_code);
            cmd.Parameters.Add("@cat_code", cat_code);
            dtproducts = vdm.SelectQuery(cmd).Tables[0];
            cmd = new SqlCommand("select statename from branchmaster where branchid=@bid");
            cmd.Parameters.Add("@bid", branchid);
            DataTable dt_branch = vdm.SelectQuery(cmd).Tables[0];
            string branch_state = dt_branch.Rows[0]["statename"].ToString();
            List<ProductDetails> ProductDetails = new List<ProductDetails>();
            foreach (DataRow dr in dtproducts.Rows)
            {
                ProductDetails getproductdetails = new ProductDetails();
                getproductdetails.productname = dr["productname"].ToString();
                getproductdetails.productcode = dr["productcode"].ToString();
                getproductdetails.shortname = dr["sub_cat_code"].ToString();
                getproductdetails.sku = dr["sku"].ToString();
                getproductdetails.bin = dr["bin"].ToString();
                getproductdetails.itemcode = dr["itemcode"].ToString();
                getproductdetails.description = dr["description"].ToString();
                getproductdetails.sectionid = dr["sectionid"].ToString();
                getproductdetails.brandid = dr["brandid"].ToString();
                getproductdetails.supplierid = dr["supplierid"].ToString();
                getproductdetails.sectionid = dr["sectionid"].ToString();
                getproductdetails.modifierset = dr["modifierset"].ToString();
                string qty = dr["qty"].ToString();
                double quantity = 0;
                if (qty == "0" || qty == "")
                {
                    getproductdetails.moniterqty = quantity.ToString();
                }
                else
                {
                    quantity = Convert.ToDouble(dr["qty"].ToString());
                    quantity = Math.Round(quantity, 2);
                    getproductdetails.moniterqty = quantity.ToString();
                }
                getproductdetails.availablestores1 = dr["availablestores"].ToString();
                getproductdetails.color = dr["color"].ToString();
                getproductdetails.uim = dr["uim"].ToString();
                getproductdetails.puim = dr["puim"].ToString();
                getproductdetails.price = dr["price"].ToString();
                getproductdetails.productid = dr["productid"].ToString();
                getproductdetails.subcategoryid = dr["subcategoryid"].ToString();
                getproductdetails.hsn_code = dr["HSNcode"].ToString();
                getproductdetails.igst = dr["IGST"].ToString();
                getproductdetails.cgst = dr["CGST"].ToString();
                getproductdetails.sgst = dr["SGST"].ToString();
                getproductdetails.gst_tax_cat = dr["gsttaxcategory"].ToString();
                getproductdetails.imgpath = dr["imgpath"].ToString();
                getproductdetails.state = branch_state;
                getproductdetails.category = dr["category"].ToString();
                getproductdetails.suppliername = dr["name"].ToString();
                getproductdetails.minstock = dr["minstock"].ToString();
                getproductdetails.maxstock = dr["maxstock"].ToString();
                getproductdetails.ftplocation = "ftp://182.18.138.228/PURCHASE/";
                ProductDetails.Add(getproductdetails);
            }
            string response = GetJson(ProductDetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_product_details_Like(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string name = context.Request["name"];
            string sku = context.Request["sku"];
            string branchid = context.Session["Po_BranchID"].ToString();
            if (name != null)
            {
                cmd = new SqlCommand("SELECT suppliersdetails.name,productmaster.imgpath, productmaster.itemcode, productmaster.bin, productmaster.productid, productmaster.subcategoryid, productmoniter.qty, productmoniter.branchid, productmaster.productname, productmaster.productcode, productmaster.sub_cat_code, productmaster.sku, productmaster.description, productmaster.sectionid, productmaster.brandid, productmaster.supplierid, productmaster.modifierset,  uimmaster.uim, productmaster.availablestores, productmaster.color, productmaster.uim AS puim, productmoniter.price, categorymaster.category, subcategorymaster.subcategoryname,  branddetails.brandname FROM productmaster INNER JOIN subcategorymaster ON productmaster.subcategoryid = subcategorymaster.subcategoryid INNER JOIN categorymaster ON subcategorymaster.categoryid = categorymaster.categoryid INNER JOIN branddetails ON productmaster.brandid = branddetails.brandid LEFT OUTER JOIN productmoniter ON productmaster.productid = productmoniter.productid LEFT OUTER JOIN uimmaster ON uimmaster.sno = productmaster.uim INNER JOIN suppliersdetails ON productmaster.supplierid = suppliersdetails.supplierid where productmoniter.branchid=@bid and (productmaster.productname LIKE '%'+ @name +'%')");
                cmd.Parameters.Add("@name", name);
                cmd.Parameters.Add("@bid", branchid);
            }
            else if (sku != null)
            {
                cmd = new SqlCommand("SELECT suppliersdetails.name,productmaster.imgpath, productmaster.itemcode, productmaster.bin, productmaster.productid, productmaster.subcategoryid, productmoniter.qty, productmoniter.branchid, productmaster.productname, productmaster.productcode, productmaster.sub_cat_code, productmaster.sku, productmaster.description, productmaster.sectionid, productmaster.brandid, productmaster.supplierid, productmaster.modifierset,  uimmaster.uim, productmaster.availablestores, productmaster.color, productmaster.uim AS puim, productmoniter.price, categorymaster.category, subcategorymaster.subcategoryname,  branddetails.brandname FROM productmaster INNER JOIN subcategorymaster ON productmaster.subcategoryid = subcategorymaster.subcategoryid INNER JOIN categorymaster ON subcategorymaster.categoryid = categorymaster.categoryid INNER JOIN branddetails ON productmaster.brandid = branddetails.brandid LEFT OUTER JOIN productmoniter ON productmaster.productid = productmoniter.productid LEFT OUTER JOIN uimmaster ON uimmaster.sno = productmaster.uim INNER JOIN suppliersdetails ON productmaster.supplierid = suppliersdetails.supplierid where productmoniter.branchid=@bid and (productmaster.sku = @sku)");
                cmd.Parameters.Add("@sku", sku);
                cmd.Parameters.Add("@bid", branchid);
            }
            
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<ProductDetails> ProductDetails = new List<ProductDetails>();
            foreach (DataRow dr in routes.Rows)
            {
                ProductDetails getproductdetails = new ProductDetails();
                getproductdetails.productname = dr["productname"].ToString();
                getproductdetails.productcode = dr["productcode"].ToString();
                getproductdetails.shortname = dr["sub_cat_code"].ToString();
                getproductdetails.sku = dr["sku"].ToString();
                getproductdetails.description = dr["description"].ToString();
                getproductdetails.sectionid = dr["sectionid"].ToString();
                getproductdetails.brandid = dr["brandid"].ToString();
                getproductdetails.supplierid = dr["supplierid"].ToString();
                getproductdetails.bin = dr["bin"].ToString();
                getproductdetails.itemcode = dr["itemcode"].ToString();
                getproductdetails.sectionid = dr["sectionid"].ToString();
                getproductdetails.modifierset = dr["modifierset"].ToString();
                double quantity = Convert.ToDouble(dr["qty"].ToString());
                quantity = Math.Round(quantity, 2);
                getproductdetails.moniterqty = quantity.ToString();
                getproductdetails.availablestores1 = dr["availablestores"].ToString();
                getproductdetails.color = dr["color"].ToString();
                getproductdetails.uim = dr["uim"].ToString();
                getproductdetails.puim = dr["puim"].ToString();
                getproductdetails.price = dr["price"].ToString();
                getproductdetails.productid = dr["productid"].ToString();
                getproductdetails.subcategoryid = dr["subcategoryid"].ToString();
                getproductdetails.brandname = dr["brandname"].ToString();
                getproductdetails.suppliername = dr["name"].ToString();
                getproductdetails.subcategory = dr["subcategoryname"].ToString();
                getproductdetails.category = dr["category"].ToString();
                getproductdetails.imgpath = dr["imgpath"].ToString();
                getproductdetails.ftplocation = "ftp://182.18.138.228/PURCHASE/";
                ProductDetails.Add(getproductdetails);
            }
            string response = GetJson(ProductDetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_ScrapItem_details_Like(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string name = context.Request["name"];
            cmd = new SqlCommand("SELECT scrapitemdetails.itemname,scrapitemdetails.sno, scrapitemdetails.itemcode, scrapitemdetails.sku, scrapitemdetails.description, scrapitemdetails.categoryid, scrapitemdetails.uom,scrapitemdetails.price, scrapitemdetails.branchid, uimmaster.uim, uimmaster.sno AS puim FROM uimmaster INNER JOIN scrapitemdetails ON uimmaster.sno = scrapitemdetails.uom where (scrapitemdetails.itemname LIKE '%'+ @name +'%')");
            cmd.Parameters.Add("@name", name);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<ScrapItemDetails> ScrapItemDetailslist = new List<ScrapItemDetails>();
            foreach (DataRow dr in routes.Rows)
            {
                ScrapItemDetails getScrapItemDetails = new ScrapItemDetails();
                getScrapItemDetails.ItemName = dr["itemname"].ToString();
                getScrapItemDetails.Itemcode = dr["itemcode"].ToString();
                getScrapItemDetails.sku = dr["sku"].ToString();
                getScrapItemDetails.description = dr["description"].ToString();
                getScrapItemDetails.categoryid = dr["categoryid"].ToString();
                getScrapItemDetails.uom = dr["uom"].ToString();
                getScrapItemDetails.puom = dr["puim"].ToString();
                getScrapItemDetails.price = dr["price"].ToString();
                getScrapItemDetails.itemid = dr["sno"].ToString();
                ScrapItemDetailslist.Add(getScrapItemDetails);
            }

            string response = GetJson(ScrapItemDetailslist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public class Indent
    {
        public string name { get; set; }
        public string entryby { get; set; }
        public string remarks { get; set; }
        public string btnval { get; set; }
        public string ddate { get; set; }
        public string idate { get; set; }
        public string sectionid { get; set; }
        public string itime { get; set; }
        public string status { get; set; }
        public string sectionname { get; set; }
        public string sno { get; set; }
        public List<SubIndent> fillindent { get; set; }
        public string productid { get; set; }
        public string qty { get; set; }
        public string branchid { get; set; }
    }
    public class SubIndent
    {
        public string hdnproductsno { get; set; }
        public string productname { get; set; }
        public string productid { get; set; }
        public string sku { get; set; }
        public string uim { get; set; }
        public string uom { get; set; }
        public string qty { get; set; }
        public string status { get; set; }
        public string price { get; set; }
        public string totalcost { get; set; }
        public string sisno { get; set; }
        public string refno { get; set; }
        public string sno { get; set; }
        public string inword_refno { get; set; }
        public string remarks { get; set; }
        public SqlDbType branchid { get; set; }
        public string availqty { get; set; }
    }
    public class productIndent
    {
        public string productid { get; set; }
        public string qty { get; set; }
        public string price { get; set; }
        public string branchid { get; set; }
    }
    public class getIndentdata
    {
        public List<Indent> Indent { get; set; }
        public List<SubIndent> SubIndent { get; set; }
    }
    private void save_Indent(HttpContext context)
    {
        try
        {
            var js = new JavaScriptSerializer();
            var title1 = context.Request.Params[1];
            Indent obj = js.Deserialize<Indent>(title1);
            string name = obj.name;
            string indate = obj.idate;
            DateTime idate = Convert.ToDateTime(indate);
            string entryby = context.Session["Employ_Sno"].ToString();
            string remarks = obj.remarks;
            string sectionname = obj.sectionname;
            string btnval = obj.btnval;
            string sno = obj.sno;
            vdm = new SalesDBManager();
            string branchid = context.Session["Po_BranchID"].ToString();
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            if (btnval == "Save")
            {
                cmd = new SqlCommand("insert into indents(name,i_date,status,entry_by,remarks,branch_id,sectionid) values(@name, @idate,@status,@entryby,@remarks,@branchid,@sectionid)");
                cmd.Parameters.Add("@name", name);
                cmd.Parameters.Add("@idate", ServerDateCurrentdate);
                cmd.Parameters.Add("@status", "P");
                cmd.Parameters.Add("@entryby", entryby);
                cmd.Parameters.Add("@remarks", remarks);
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@sectionid", sectionname);
                vdm.insert(cmd);
                cmd = new SqlCommand("select MAX(sno) as ind from indents");
                DataTable dtindent = vdm.SelectQuery(cmd).Tables[0];
                string refno = dtindent.Rows[0]["ind"].ToString();
                foreach (SubIndent si in obj.fillindent)
                {
                    if (si.hdnproductsno != "0")
                    {
                        cmd = new SqlCommand("insert into indent_subtable(productid,qty,status,indentno) values(@productid,@qty,@status,@in_refno)");//,price  ,@price
                        cmd.Parameters.Add("@productid", si.hdnproductsno);
                        cmd.Parameters.Add("@qty", si.qty);
                        cmd.Parameters.Add("@status", "P");
                        cmd.Parameters.Add("@in_refno", refno);
                        vdm.insert(cmd);
                    }
                }
                string msg = "successfully Inserted";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {
                cmd = new SqlCommand("update indents set name=@name,sectionid=@sectionid,i_date=@idate,status=@status,remarks=@remarks where sno=@sno AND branch_id=@branchid");
                cmd.Parameters.Add("@name", name);
                cmd.Parameters.Add("@idate", idate);
                cmd.Parameters.Add("@status", "P");
                cmd.Parameters.Add("@remarks", remarks);
                cmd.Parameters.Add("@sno", sno);
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@sectionid", sectionname);
                vdm.Update(cmd);
                foreach (SubIndent si in obj.fillindent)
                {
                    cmd = new SqlCommand("update indent_subtable set productid=@productid, qty=@qty, status=@status where indentno=@in_refno and sno=@sno ");//, price=@price
                    cmd.Parameters.Add("@productid", si.hdnproductsno);
                    cmd.Parameters.Add("@qty", si.qty);
                    cmd.Parameters.Add("@status", "P");
                    cmd.Parameters.Add("@in_refno", sno);
                    cmd.Parameters.Add("@sno", si.sisno);
                    vdm.Update(cmd);
                }
                string msg = "successfully updated ";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_Approvel_internal_details(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT productmoniter.qty as availableqty, indents.sno, indents.sectionid, indent_subtable.sno AS sub_ind_sno, indents.name, indents.i_date, indents.d_date, indents.remarks, indents.status,indents.branch_id, productmaster.productname, productmaster.productid, indent_subtable.qty, indent_subtable.price, sectionmaster.name AS sectionname FROM indents INNER JOIN indent_subtable ON indents.sno = indent_subtable.indentno INNER JOIN productmaster ON indent_subtable.productid = productmaster.productid INNER JOIN sectionmaster ON indents.sectionid = sectionmaster.sectionid INNER JOIN productmoniter ON productmaster.productid = productmoniter.productid WHERE (indents.status = 'P') AND (indents.branch_id = @branchid) AND (productmoniter.branchid = @branchid)");
            cmd.Parameters.Add("@branchid", branchid);
            cmd.Parameters.Add("@d1", GetLowDate(ServerDateCurrentdate).AddDays(-5));
            cmd.Parameters.Add("@d2", GetHighDate(ServerDateCurrentdate));
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(routes);
            DataTable dtindents = view.ToTable(true, "sno", "name", "i_date", "sectionname", "sectionid", "d_date", "remarks", "status", "branch_id");
            DataTable dtsubindents = view.ToTable(true, "sno", "sub_ind_sno", "qty", "availableqty", "productname", "price", "productid");
            List<getIndentdata> indentdetails = new List<getIndentdata>();
            List<Indent> indent_lst = new List<Indent>();
            List<SubIndent> sub_indent_list = new List<SubIndent>();
            foreach (DataRow dr in dtindents.Rows)
            {
                Indent getApprovelindentdetails = new Indent();
                getApprovelindentdetails.sno = dr["sno"].ToString();
                getApprovelindentdetails.name = dr["name"].ToString();
                getApprovelindentdetails.idate = ((DateTime)dr["i_date"]).ToString("dd-MM-yyyy"); // dr["i_date"].ToString();
                getApprovelindentdetails.ddate = dr["d_date"].ToString();
                getApprovelindentdetails.remarks = dr["remarks"].ToString();
                getApprovelindentdetails.status = "Pending";
                getApprovelindentdetails.branchid = dr["branch_id"].ToString();
                getApprovelindentdetails.sectionid = dr["sectionid"].ToString();
                getApprovelindentdetails.sectionname = dr["sectionname"].ToString();
                indent_lst.Add(getApprovelindentdetails);
            }
            foreach (DataRow dr in dtsubindents.Rows)
            {
                SubIndent getindent = new SubIndent();
                getindent.sno = dr["sub_ind_sno"].ToString();
                getindent.inword_refno = dr["sno"].ToString();
                getindent.qty = dr["qty"].ToString();
                getindent.availqty = dr["availableqty"].ToString();
                getindent.price = dr["price"].ToString();
                getindent.hdnproductsno = dr["productid"].ToString();
                getindent.productname = dr["productname"].ToString();
                sub_indent_list.Add(getindent);
            }
            getIndentdata getIndentdates = new getIndentdata();
            getIndentdates.Indent = indent_lst;
            getIndentdates.SubIndent = sub_indent_list;
            indentdetails.Add(getIndentdates);
            string response = GetJson(indentdetails);
            context.Response.Write(response);

        }
        catch
        {
        }
    }

    private void get_Indent_Details_Outward(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string indentsno = context.Request["sno"].ToString();
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT indents.sno, indent_subtable.sno AS sub_ind_sno, indents.name, indents.i_date, indents.d_date, indents.remarks, indents.branch_id, uimmaster.uim, productmaster.productname, productmaster.uim as uom, productmaster.sku, productmaster.productid, indent_subtable.qty ,indent_subtable.price FROM indents INNER JOIN indent_subtable ON indents.sno = indent_subtable.indentno INNER JOIN productmaster ON    productmaster.productid  = indent_subtable.productid INNER JOIN uimmaster on productmaster.uim=uimmaster.sno where indents.sno=@indentsno AND indents.status='V' AND indents.branch_id=@branchid");
            cmd.Parameters.Add("@indentsno", indentsno);
            cmd.Parameters.Add("@branchid", branchid);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(routes);
            DataTable dtindents = view.ToTable(true, "sno", "name", "i_date", "d_date", "remarks", "branch_id");
            DataTable dtsubindents = view.ToTable(true, "sno", "sub_ind_sno", "qty", "productname", "productid", "sku", "uim", "uom", "price");
            List<getIndentdata> indentdetails = new List<getIndentdata>();
            List<Indent> indent_lst = new List<Indent>();
            List<SubIndent> sub_indent_list = new List<SubIndent>();
            foreach (DataRow dr in dtindents.Rows)
            {
                Indent getApprovelindentdetails = new Indent();
                getApprovelindentdetails.sno = dr["sno"].ToString();
                getApprovelindentdetails.name = dr["name"].ToString();
                getApprovelindentdetails.idate = ((DateTime)dr["i_date"]).ToString("yyyy-MM-dd"); // dr["i_date"].ToString();
                getApprovelindentdetails.ddate = dr["d_date"].ToString();
                getApprovelindentdetails.remarks = dr["remarks"].ToString();
                getApprovelindentdetails.branchid = dr["branch_id"].ToString();
                indent_lst.Add(getApprovelindentdetails);
            }
            foreach (DataRow dr in dtsubindents.Rows)
            {
                SubIndent getindent = new SubIndent();
                getindent.sno = dr["sub_ind_sno"].ToString();
                getindent.inword_refno = dr["sno"].ToString();
                getindent.qty = dr["qty"].ToString();
                getindent.price = dr["price"].ToString();
                getindent.hdnproductsno = dr["productid"].ToString();
                getindent.productname = dr["productname"].ToString();
                getindent.sku = dr["sku"].ToString();
                getindent.uim = dr["uim"].ToString();
                getindent.uom = dr["uom"].ToString();
                sub_indent_list.Add(getindent);
            }
            getIndentdata getIndentdates = new getIndentdata();
            getIndentdates.Indent = indent_lst;
            getIndentdates.SubIndent = sub_indent_list;
            indentdetails.Add(getIndentdates);
            string response = GetJson(indentdetails);
            context.Response.Write(response);

        }
        catch
        {
        }
    }

    public class InwardDetails  //new
    {
        public string inwarddate { get; set; }
        public string inwardno { get; set; }
        public string invoiceno { get; set; }
        public string invoicedate { get; set; }
        public string dcno { get; set; }
        public string lrno { get; set; }
        public string supplierid { get; set; }
        public string podate { get; set; }
        public string indentno { get; set; }
        public string remarks { get; set; }
        public string pono { get; set; }
        public string name { get; set; }
        public string securityno { get; set; }
        public string transportname { get; set; }
        public string freigtamt { get; set; }
        public string vehicleno { get; set; }
        public string uimid { get; set; }
        public string status { get; set; }
        public string modeofinward { get; set; }
        public string transport { get; set; }
        public string btnval { get; set; }
        public string sno { get; set; }
        public string hiddensupplyid { get; set; }
        public List<SubInward> fillitems { get; set; }
        public string productid { get; set; }
        public string pfid { get; set; }
        public string qty { get; set; }
        public string price { get; set; }
        public string mrnno { get; set; }
        public string inwardamount { get; set; }
        public string inwardsno { get; set; }
        public string doorno { get; set; }
        public string paymenttype { get; set; }
        public string stocksno { get; set; }
        public string rev_chrg { get; set; }

    }
    public class SubInward //new
    {
        public string ed { get; set; }
        public string dis { get; set; }
        public string disamt { get; set; }
        public string tax { get; set; }
        public string taxtype { get; set; }
        public string taxname { get; set; }
        public string edname { get; set; }
        public string edtype { get; set; }
        public string pfamount { get; set; }
        public string edtax { get; set; }
        public string hdnproductsno { get; set; }
        public string productcode { get; set; }
        public string productname { get; set; }
        public string quantity { get; set; }
        public string PerUnitRs { get; set; }
        public string totalcost { get; set; }
        public string refno { get; set; }
        public string sisno { get; set; }
        public string sno { get; set; }
        public string uim { get; set; }
        public string sgst_per { get; set; }
        public string cgst_per { get; set; }
        public string igst_per { get; set; }
        public string hsn_code { get; set; }
        public string inword_refno { get; set; }
        public string gst_exists { get; set; }
        public SqlDbType branchid { get; set; }
        public string gstprice { get; set; }
    }
    public class productmoniter //new
    {
        public string productid { get; set; }
        public string productname { get; set; }
        public string qty { get; set; }
        public string price { get; set; }
        public string branchid { get; set; }
        public string doe { get; set; }
        public string value { get; set; }

    }
    public class getInwardData  //new
    {
        public List<InwardDetails> InwardDetails { get; set; }
        public List<SubInward> SubInward { get; set; }
    }
    private void save_edit_Inward(HttpContext context)  //new
    {
        try
        {
            var js = new JavaScriptSerializer();
            var title1 = context.Request.Params[1];
            InwardDetails obj = js.Deserialize<InwardDetails>(title1);
            string stocksno = obj.stocksno;
            if (stocksno != "0")
            {
                cmd = new SqlCommand("update stocktransferdetails set tobranchinwardstatus=@sts where sno=@stsno");
                cmd.Parameters.Add("@sts", "C");
                cmd.Parameters.Add("@stsno", stocksno);
                vdm.Update(cmd);
            }
            string invoiceno = obj.invoiceno;
            string dcno = obj.dcno;
            string lrno = obj.lrno;
            string podate = obj.podate;
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string createdby = context.Session["Employ_Sno"].ToString();
            string indate = obj.inwarddate;
            DateTime inwdate = Convert.ToDateTime(indate);
            string inwarddate = inwdate.ToString("MM-dd-yyyy");
            string invdate = obj.invoicedate;
            DateTime invoiate = Convert.ToDateTime(invdate);
            string invoicedate = invoiate.ToString("MM-dd-yyyy");
            if (podate == "null")
            {
                podate = invoicedate;
            }
            string remarks = obj.remarks;
            string pono = obj.pono;
            string sno = obj.sno;
            string securityno = obj.securityno;
            string transportname = obj.transportname;
            string vehicleno = obj.vehicleno;
            string modeofinward = obj.modeofinward;
            string transport = obj.transport;
            string inwardamount = obj.inwardamount;
            string paymenttype = obj.paymenttype;
            if (modeofinward == "Select Mode of Inward")
            {
                modeofinward = "0";
            }
            string freigtamt = obj.freigtamt;
            string hiddensupplyid = obj.hiddensupplyid;
            string rev_chrg = obj.rev_chrg;
            string btnval = obj.btnval;
            vdm = new SalesDBManager();
            string branchid = context.Session["Po_BranchID"].ToString();
            string pfid1 = "";
            pfid1 = obj.pfid;
            int pfvalue = 0;
            int.TryParse(obj.pfid, out pfvalue);
            if (pfvalue > 0)
            {
                cmd = new SqlCommand("SELECT sno FROM pandf WHERE (pandf = @pandf)");
                cmd.Parameters.Add("@pandf", obj.pfid);
                DataTable dtpf = vdm.SelectQuery(cmd).Tables[0];
                if (dtpf.Rows.Count > 0)
                {
                    pfid1 = dtpf.Rows[0]["sno"].ToString();
                }
            }
            else
            {
                //cmd = new SqlCommand("SELECT sno FROM pandf WHERE (pandf = @pandf)");
                //cmd.Parameters.Add("@pandf", obj.pfid);
                //DataTable dtpf = vdm.SelectQuery(cmd).Tables[0];
                pfid1 = "2";
            }
            if (btnval == "Save")
            {
                DateTime dtapril = new DateTime();
                DateTime dtmarch = new DateTime();
                int currentyear = ServerDateCurrentdate.Year;
                int nextyear = ServerDateCurrentdate.Year + 1;
                if (ServerDateCurrentdate.Month > 3)
                {
                    string apr = "4/1/" + currentyear;
                    dtapril = DateTime.Parse(apr);
                    string march = "3/31/" + nextyear;
                    dtmarch = DateTime.Parse(march);
                }
                if (ServerDateCurrentdate.Month <= 3)
                {
                    string apr = "4/1/" + (currentyear - 1);
                    dtapril = DateTime.Parse(apr);
                    string march = "3/31/" + (nextyear - 1);
                    dtmarch = DateTime.Parse(march);
                }
                cmd = new SqlCommand("SELECT { fn IFNULL(MAX(mrnno), 0) } + 1 AS Sno FROM  inwarddetails WHERE (branchid = @branchid) and (inwarddate between @d1 and @d2) ");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@d1", GetLowDate(dtapril));
                cmd.Parameters.Add("@d2", GetHighDate(dtmarch));
                DataTable dtMrn = vdm.SelectQuery(cmd).Tables[0];
                string mrnno = dtMrn.Rows[0]["Sno"].ToString();
                cmd = new SqlCommand("insert into inwarddetails(inwarddate,invoiceno,invoicedate,dcno,lrno,supplierid,podate,remarks,securityno,transportname,vehicleno,modeofinward,pono,status,mrnno,branchid,freigtamt,transportcharge,inwardamount,pfid, paymentid,reversecharge,createddate,createdby) values(@inwarddate,@invoiceno,@invoicedate,@dcno,@lrno,@supplierid,@podate,@remarks,@securityno,@transportname,@vehicleno,@modeofinward,@pono,@status,@mrnno,@branchid,@freigtamt,@transportcharge,@inwardamount,@pfid, @paymenttype,@reversecharge,@doe,@createdby)");//indentno,@indentno,
                cmd.Parameters.Add("@inwarddate", inwdate);
                cmd.Parameters.Add("@invoiceno", invoiceno);
                cmd.Parameters.Add("@invoicedate", invoicedate);
                cmd.Parameters.Add("@dcno", dcno);
                cmd.Parameters.Add("@lrno", lrno);
                cmd.Parameters.Add("@supplierid", hiddensupplyid);
                cmd.Parameters.Add("@podate", podate);
                cmd.Parameters.Add("@remarks", remarks);
                cmd.Parameters.Add("@modeofinward", modeofinward);
                cmd.Parameters.Add("@securityno", securityno);
                cmd.Parameters.Add("@transportname", transportname);
                cmd.Parameters.Add("@pono", pono);
                cmd.Parameters.Add("@status", 'P');
                cmd.Parameters.Add("@vehicleno", vehicleno);
                cmd.Parameters.Add("@mrnno", mrnno);
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@freigtamt", freigtamt);
                cmd.Parameters.Add("@transportcharge", transport);
                cmd.Parameters.Add("@inwardamount", inwardamount);
                cmd.Parameters.Add("@pfid", pfid1);
                cmd.Parameters.Add("@paymenttype", paymenttype);
                cmd.Parameters.Add("@reversecharge", rev_chrg);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@createdby", createdby);
                vdm.insert(cmd);
                cmd = new SqlCommand("select MAX(sno) as inward from inwarddetails");
                DataTable dtinward = vdm.SelectQuery(cmd).Tables[0];
                string refno = dtinward.Rows[0]["inward"].ToString();
                foreach (SubInward si in obj.fillitems)
                {
                    if (si.hdnproductsno != "0")
                    {
                        string temptax = si.taxtype;
                        string temped = si.ed;
                        if (si.sgst_per == "")
                        {
                            if (pono != "")
                            {
                                cmd = new SqlCommand("SELECT sno FROM taxmaster WHERE (type = @type)");
                                cmd.Parameters.Add("@type", si.taxtype);
                                cmd.Parameters.Add("@branchid", branchid);
                                DataTable dttax = vdm.SelectQuery(cmd).Tables[0];
                                temptax = dttax.Rows[0]["sno"].ToString();
                                cmd = new SqlCommand("SELECT sno FROM taxmaster WHERE (type = @type)");
                                cmd.Parameters.Add("@type", si.ed);
                                cmd.Parameters.Add("@branchid", branchid);
                                DataTable dtedtax = vdm.SelectQuery(cmd).Tables[0];
                                temped = dtedtax.Rows[0]["sno"].ToString();
                            }
                            if (temptax == null)
                            {
                                si.taxtype = "0";
                                si.ed = "0";
                                si.dis = "0";
                                si.disamt = "0";
                                si.tax = "0";
                                si.edtax = "0";
                            }
                            else
                            {

                            }
                        }

                        cmd = new SqlCommand("insert into subinwarddetails(productid,quantity,perunit,taxtype,ed,dis,disamt,tax,edtax,totalcost,in_refno,igst,cgst,sgst) values(@productid,@quantity,@perunit,@taxtype,@ed,@dis,@disamt,@tax,@edtax,@totalcost,@in_refno,@igst,@cgst,@sgst)");
                        cmd.Parameters.Add("@productid", si.hdnproductsno);
                        cmd.Parameters.Add("@quantity", si.quantity);
                        cmd.Parameters.Add("@taxtype", temptax);
                        cmd.Parameters.Add("@ed", temped);
                        cmd.Parameters.Add("@dis", si.dis);
                        cmd.Parameters.Add("@disamt", si.disamt);
                        cmd.Parameters.Add("@tax", si.tax);
                        cmd.Parameters.Add("@edtax", si.edtax);
                        cmd.Parameters.Add("@perunit", si.PerUnitRs);
                        cmd.Parameters.Add("@totalcost", si.totalcost);
                        cmd.Parameters.Add("@in_refno", refno);
                        cmd.Parameters.Add("@igst", si.igst_per);
                        cmd.Parameters.Add("@cgst", si.cgst_per);
                        cmd.Parameters.Add("@sgst", si.sgst_per);
                        vdm.insert(cmd);
                    }
                }
                string msg = mrnno + "   Inward Number successfully Inserted";
                string Response = GetJson(msg);
                context.Response.Write(Response);
                
            }
            else
            {
                cmd = new SqlCommand("SELECT  doe  FROM producttransactions where branchid=@branchid and doe=@inwarddate");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@inwarddate", inwarddate);
                DataTable produtransactiondoe = vdm.SelectQuery(cmd).Tables[0];
                if (produtransactiondoe.Rows.Count != 0)
                {
                    string Response = GetJson("You Dont Have Permission This Date");
                    context.Response.Write(Response);
                }
                else
                {
                    cmd = new SqlCommand("update inwarddetails set reversecharge=@reversecharge,inwardamount=@inwardamount,pono=@pono,freigtamt=@freigtamt,transportcharge=@transportcharge,inwarddate=@inwarddate,invoiceno=@invoiceno,invoicedate=@invoicedate,dcno=@dcno,lrno=@lrno,supplierid=@supplierid,podate=@podate,remarks=@remarks,securityno=@securityno,transportname=@transportname,vehicleno=@vehicleno,modeofinward=@modeofinward where branchid=@branchid AND sno=@sno");//indentno=@indentno,
                    cmd.Parameters.Add("@inwarddate", inwarddate);
                    cmd.Parameters.Add("@invoiceno", invoiceno);
                    cmd.Parameters.Add("@invoicedate", invoicedate);
                    cmd.Parameters.Add("@dcno", dcno);
                    cmd.Parameters.Add("@lrno", lrno);
                    cmd.Parameters.Add("@supplierid", hiddensupplyid);
                    cmd.Parameters.Add("@podate", podate);
                    cmd.Parameters.Add("@remarks", remarks);
                    cmd.Parameters.Add("@pono", pono);
                    cmd.Parameters.Add("@modeofinward", modeofinward);
                    cmd.Parameters.Add("@securityno", securityno);
                    cmd.Parameters.Add("@transportname", transportname);
                    cmd.Parameters.Add("@vehicleno", vehicleno);
                    cmd.Parameters.Add("@branchid", branchid);
                    cmd.Parameters.Add("@sno", sno);
                    cmd.Parameters.Add("@freigtamt", freigtamt);
                    cmd.Parameters.Add("@transportcharge", transport);
                    cmd.Parameters.Add("@inwardamount", inwardamount);
                    cmd.Parameters.Add("@reversecharge", rev_chrg);
                    vdm.Update(cmd);
                    foreach (SubInward si in obj.fillitems)
                    {
                        cmd = new SqlCommand("select * from subinwarddetails where  productid=@productid and sno=@sno");
                        cmd.Parameters.Add("@productid", si.hdnproductsno);
                        cmd.Parameters.Add("@sno", si.sisno);
                        DataTable dtprev = vdm.SelectQuery(cmd).Tables[0];
                        float prevqty = 0;
                        if (dtprev.Rows.Count > 0)
                        {
                            string amount = dtprev.Rows[0]["quantity"].ToString();
                            float.TryParse(amount, out prevqty);
                        }
                        string temptax = si.taxtype;
                        if (temptax == null)
                        {
                            si.taxtype = "0";
                            si.ed = "0";
                            si.dis = "0";
                            si.disamt = "0";
                            si.tax = "0";
                            si.edtax = "0";
                        }
                        else
                        {
                        }
                        cmd = new SqlCommand("update subinwarddetails set productid=@productid, quantity=@quantity, perunit=@perunit,dis=@dis,disamt=@disamt,taxtype=@taxtype,ed=@ed,tax=@tax,edtax=@edtax,totalcost=@totalcost,igst=@igst,cgst=@cgst,sgst=@sgst where in_refno=@in_refno and sno=@sno ");
                        cmd.Parameters.Add("@productid", si.hdnproductsno);
                        cmd.Parameters.Add("@quantity", si.quantity);
                        cmd.Parameters.Add("@taxtype", si.taxtype);
                        cmd.Parameters.Add("@ed", si.ed);
                        cmd.Parameters.Add("@dis", si.dis);
                        cmd.Parameters.Add("@disamt", si.disamt);
                        cmd.Parameters.Add("@tax", si.tax);
                        cmd.Parameters.Add("@edtax", si.edtax);
                        cmd.Parameters.Add("@perunit", si.PerUnitRs);
                        cmd.Parameters.Add("@totalcost", si.totalcost);
                        cmd.Parameters.Add("@in_refno", sno);
                        cmd.Parameters.Add("@sno", si.sisno);
                        cmd.Parameters.Add("@igst", si.igst_per);
                        cmd.Parameters.Add("@cgst", si.cgst_per);
                        cmd.Parameters.Add("@sgst", si.sgst_per);
                        if (vdm.Update(cmd) == 0)
                        {
                            cmd = new SqlCommand("insert into subinwarddetails(productid,quantity,perunit,totalcost,dis,disamt,taxtype,ed,tax,edtax,in_refno,igst,cgst,sgst) values(@productid,@quantity,@perunit,@totalcost,@dis,@disamt,@taxtype,@ed,@tax,@edtax,@in_refno,@igst,@cgst,@sgst)");
                            cmd.Parameters.Add("@productid", si.hdnproductsno);
                            cmd.Parameters.Add("@quantity", si.quantity);
                            cmd.Parameters.Add("@taxtype", si.taxtype);
                            cmd.Parameters.Add("@ed", si.ed);
                            cmd.Parameters.Add("@dis", si.dis);
                            cmd.Parameters.Add("@disamt", si.disamt);
                            cmd.Parameters.Add("@tax", si.tax);
                            cmd.Parameters.Add("@edtax", si.edtax);
                            cmd.Parameters.Add("@perunit", si.PerUnitRs);
                            cmd.Parameters.Add("@totalcost", si.totalcost);
                            cmd.Parameters.Add("@in_refno", sno);
                            cmd.Parameters.Add("@igst", si.igst_per);
                            cmd.Parameters.Add("@cgst", si.cgst_per);
                            cmd.Parameters.Add("@sgst", si.sgst_per);
                            vdm.insert(cmd);
                        }
                        float presentqty = 0;
                        float.TryParse(si.quantity, out presentqty);
                        double editqty = 0;
                        
                    }
                    string msg = "Inward Number successfully updated";
                    string Response = GetJson(msg);
                    context.Response.Write(Response);
                }
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    } //new
    private void get_inward_Data(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string julydt = "07/01/2017";
            DateTime gst_dt = Convert.ToDateTime(julydt);
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT  inwarddetails.reversecharge, pandf.pandf, inwarddetails.pfid, inwarddetails.inwardamount, uimmaster.uim, inwarddetails.transportcharge, inwarddetails.mrnno, inwarddetails.freigtamt, inwarddetails.sno, inwarddetails.pono,inwarddetails.inwarddate, inwarddetails.invoiceno, inwarddetails.invoicedate, inwarddetails.dcno, inwarddetails.lrno, inwarddetails.supplierid, inwarddetails.podate, inwarddetails.remarks, inwarddetails.securityno, inwarddetails.transportname, inwarddetails.vehicleno, inwarddetails.modeofinward, subinwarddetails.sno AS Expr1, subinwarddetails.productid, subinwarddetails.quantity, subinwarddetails.perunit, subinwarddetails.totalcost, suppliersdetails.name, suppliersdetails.supplierid AS Expr2, productmaster.productname, productmaster.productcode, subinwarddetails.taxtype AS tax, taxmaster_1.type as taxname, taxmaster.type as edname, subinwarddetails.ed,subinwarddetails.dis, subinwarddetails.disamt, subinwarddetails.tax AS taxtype, subinwarddetails.edtax AS edtype, subinwarddetails.igst, subinwarddetails.sgst, subinwarddetails.cgst FROM inwarddetails INNER JOIN subinwarddetails ON inwarddetails.sno = subinwarddetails.in_refno LEFT OUTER JOIN suppliersdetails ON inwarddetails.supplierid = suppliersdetails.supplierid LEFT OUTER JOIN productmaster ON subinwarddetails.productid = productmaster.productid LEFT OUTER JOIN taxmaster AS taxmaster_1 ON subinwarddetails.taxtype = taxmaster_1.sno LEFT OUTER JOIN taxmaster ON subinwarddetails.ed = taxmaster.sno LEFT OUTER JOIN uimmaster ON uimmaster.sno = productmaster.uim LEFT OUTER JOIN pandf ON pandf.sno = inwarddetails.pfid WHERE  (inwarddetails.inwarddate BETWEEN @d1 AND @d2) AND (inwarddetails.branchid = @branchid) AND (inwarddetails.status = 'p') ORDER BY inwarddetails.inwarddate");//, inwarddetails.indentno
            cmd.Parameters.Add("@d1", GetLowDate(ServerDateCurrentdate).AddDays(-25));
            cmd.Parameters.Add("@d2", GetHighDate(ServerDateCurrentdate));
            cmd.Parameters.Add("@branchid", branchid);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(routes);
            DataTable dtinward = view.ToTable(true, "sno", "inwardamount", "reversecharge", "pandf", "modeofinward", "transportcharge", "freigtamt", "mrnno", "securityno", "transportname", "pono", "vehicleno", "name", "inwarddate", "invoiceno", "invoicedate", "dcno", "lrno", "supplierid", "podate", "remarks");//, "indentno"
            DataTable dtsubinward = view.ToTable(true, "sno", "igst", "cgst", "sgst", "productid", "productcode", "Expr1", "uim", "productname", "quantity", "perunit", "totalcost", "disamt", "dis", "inwarddate", "edtype", "ed", "edname", "taxname", "taxtype", "tax");
            List<getInwardData> getInwarddetails = new List<getInwardData>();
            List<InwardDetails> inwardlist = new List<InwardDetails>();
            List<SubInward> subinwardlist = new List<SubInward>();
            foreach (DataRow dr in dtinward.Rows)
            {
                InwardDetails getInward = new InwardDetails();
                getInward.inwarddate = ((DateTime)dr["inwarddate"]).ToString("dd-MM-yyyy");//dr["inwarddate"].ToString();
                getInward.invoiceno = dr["invoiceno"].ToString();
                getInward.invoicedate = ((DateTime)dr["invoicedate"]).ToString("dd-MM-yyyy");//dr["invoicedate"].ToString();
                getInward.dcno = dr["dcno"].ToString();
                getInward.lrno = dr["lrno"].ToString();
                getInward.hiddensupplyid = dr["supplierid"].ToString();
                getInward.name = dr["name"].ToString();
                string date = dr["podate"].ToString();
                if (date != "")
                {
                    getInward.podate = ((DateTime)dr["podate"]).ToString("dd-MM-yyyy"); //dr["podate"].ToString();//((DateTime)dr["podate"]).ToString("yyyy-MM-dd"); 
                }
                getInward.inwardamount = dr["inwardamount"].ToString();
                getInward.modeofinward = dr["modeofinward"].ToString();
                getInward.securityno = dr["securityno"].ToString();
                getInward.transport = dr["transportcharge"].ToString();
                getInward.transportname = dr["transportname"].ToString();
                getInward.freigtamt = dr["freigtamt"].ToString();
                getInward.vehicleno = dr["vehicleno"].ToString();
                getInward.remarks = dr["remarks"].ToString();
                getInward.pono = dr["pono"].ToString();
                getInward.sno = dr["sno"].ToString();
                getInward.mrnno = dr["mrnno"].ToString();
                getInward.pfid = dr["pandf"].ToString();
                getInward.rev_chrg = dr["reversecharge"].ToString();
                inwardlist.Add(getInward);
            }
            foreach (DataRow dr in dtsubinward.Rows)
            {
                SubInward getsubinward = new SubInward();
                string inwarddate1 = ((DateTime)dr["inwarddate"]).ToString();
                //string inwarddate1 = "7/17/2017 12:00:00 AM";
                DateTime inwarddate = Convert.ToDateTime(inwarddate1);
                if (inwarddate < gst_dt)
                {
                    getsubinward.edtype = dr["edtype"].ToString();
                    getsubinward.ed = dr["ed"].ToString();
                    getsubinward.taxtype = dr["taxtype"].ToString();
                    getsubinward.taxname = dr["taxname"].ToString();
                    getsubinward.edname = dr["edname"].ToString();
                    getsubinward.tax = dr["tax"].ToString();
                    getsubinward.gst_exists = "0";
                }
                else
                {
                    getsubinward.sgst_per = dr["sgst"].ToString();
                    getsubinward.cgst_per = dr["cgst"].ToString();
                    getsubinward.igst_per = dr["igst"].ToString();
                    getsubinward.gst_exists = "1";
                }
                getsubinward.hdnproductsno = dr["productid"].ToString();
                getsubinward.productname = dr["productname"].ToString();
                getsubinward.productcode = dr["productcode"].ToString();
                double quantity = Convert.ToDouble(dr["quantity"].ToString());
                quantity = Math.Round(quantity, 2);
                getsubinward.quantity = quantity.ToString();
                getsubinward.uim = dr["uim"].ToString();
                getsubinward.PerUnitRs = dr["perunit"].ToString();
                getsubinward.totalcost = dr["totalcost"].ToString();
                getsubinward.sisno = dr["Expr1"].ToString();
                getsubinward.disamt = dr["disamt"].ToString();
                getsubinward.dis = dr["dis"].ToString();
                getsubinward.inword_refno = dr["sno"].ToString();
                subinwardlist.Add(getsubinward);
            }
            getInwardData getInwadDatas = new getInwardData();
            getInwadDatas.InwardDetails = inwardlist;
            getInwadDatas.SubInward = subinwardlist;
            getInwarddetails.Add(getInwadDatas);
            string response = GetJson(getInwarddetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }//new 

    public class InwardDashboard
    {
        public string inwarddate { get; set; }
        public string sno { get; set; }
        public string mrnno { get; set; }
        public string invoicedate { get; set; }
        public string suppliername { get; set; }
        public string pono { get; set; }
        public string sectionname { get; set; }
        public string branchname { get; set; }
        public string invoiceno { get; set; }
        public string podate { get; set; }
        public string ponumber { get; set; }
        public string status { get; set; }
    }
     



    private void get_inward_DataDashboard(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            DateTime prvdate = ServerDateCurrentdate.AddDays(-1);
            string branchid = context.Session["Po_BranchID"].ToString();
            //cmd = new SqlCommand("select * from inwarddetails");
            //DataTable inroutes = vdm.SelectQuery(cmd).Tables[0];

            cmd = new SqlCommand("SELECT inwarddetails.status, inwarddetails.inwarddate, inwarddetails.sno, inwarddetails.mrnno, suppliersdetails.name FROM  inwarddetails LEFT OUTER JOIN  suppliersdetails ON inwarddetails.supplierid = suppliersdetails.supplierid WHERE (inwarddetails.inwarddate BETWEEN @d1 AND @d2) AND (inwarddetails.branchid = @branchid)");
            cmd.Parameters.Add("@branchid", branchid);
            cmd.Parameters.Add("@d1", GetLowDate(prvdate));
            cmd.Parameters.Add("@d2", GetHighDate(ServerDateCurrentdate));
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<InwardDashboard> InwardDashboardlist = new List<InwardDashboard>();
            foreach (DataRow dr in routes.Rows)
            {
                InwardDashboard getInwardDashboard = new InwardDashboard();
                getInwardDashboard.inwarddate = ((DateTime)dr["inwarddate"]).ToString("yyyy-MM-dd");//dr["inwarddate"].ToString();
                getInwardDashboard.sno = dr["sno"].ToString();
                getInwardDashboard.suppliername = dr["name"].ToString();
                getInwardDashboard.mrnno = dr["mrnno"].ToString();
                getInwardDashboard.status = dr["status"].ToString();
                InwardDashboardlist.Add(getInwardDashboard);
            }
            string response = GetJson(InwardDashboardlist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);

        }
    }
    private void get_issue_DataDashboard(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT sectionmaster.name, outwarddetails.inwarddate, outwarddetails.sno FROM outwarddetails INNER JOIN  sectionmaster ON outwarddetails.section_id = sectionmaster.sectionid  WHERE  (outwarddetails.inwarddate BETWEEn @d1 AND @d2) AND (outwarddetails.branchid=@branchid)");
            cmd.Parameters.Add("@d1", GetLowDate(ServerDateCurrentdate).AddDays(-1));
            cmd.Parameters.Add("@d2", GetHighDate(ServerDateCurrentdate));
            cmd.Parameters.Add("@branchid", branchid);

            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<InwardDashboard> InwardDashboardlist = new List<InwardDashboard>();
            foreach (DataRow dr in routes.Rows)
            {
                InwardDashboard getInwardDashboard = new InwardDashboard();
                getInwardDashboard.inwarddate = ((DateTime)dr["inwarddate"]).ToString("dd-MM-yyyy");//dr["inwarddate"].ToString();
                getInwardDashboard.sno = dr["sno"].ToString();
                getInwardDashboard.sectionname = dr["name"].ToString();
                InwardDashboardlist.Add(getInwardDashboard);
            }
            string response = GetJson(InwardDashboardlist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);

        }
    }
    private void issuedashboardproductname(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string sno = context.Request["sno"];
            DataTable Report = new DataTable();
            DateTime doe = SalesDBManager.GetTime(vdm.conn);
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT productmaster.productname, (suboutwarddetails.quantity *suboutwarddetails.perunit) AS VALUE, suboutwarddetails.quantity, suboutwarddetails.perunit FROM  outwarddetails INNER JOIN suboutwarddetails ON outwarddetails.sno = suboutwarddetails.in_refno INNER JOIN productmaster ON suboutwarddetails.productid = productmaster.productid WHERE (suboutwarddetails.in_refno = @sno) AND (outwarddetails.branchid=@branchid) AND (suboutwarddetails.quantity > 0)");
            cmd.Parameters.Add("@sno", sno);
            cmd.Parameters.Add("@branchid", branchid);
            DataTable dttotalinward = vdm.SelectQuery(cmd).Tables[0];
            List<dailyinwardlistclass> daily_inward_list = new List<dailyinwardlistclass>();
            foreach (DataRow dr in dttotalinward.Rows)
            {
                dailyinwardlistclass getinwardtotal = new dailyinwardlistclass();
                double value = Convert.ToDouble(dr["VALUE"].ToString());
                getinwardtotal.price = dr["perunit"].ToString();
                getinwardtotal.qty = dr["quantity"].ToString();
                value = Math.Round(value, 2);
                getinwardtotal.StoresValue = value.ToString();
                getinwardtotal.productname = dr["productname"].ToString();
                daily_inward_list.Add(getinwardtotal);
            }
            string response = GetJson(daily_inward_list);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    private void get_Transfer_DataDashboard(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT branchmaster.branchname, stocktransferdetails.sno, stocktransferdetails.invoiceno, stocktransferdetails.invoicedate FROM stocktransferdetails INNER JOIN  branchmaster ON stocktransferdetails.tobranch = branchmaster.branchid  WHERE  (stocktransferdetails.invoicedate BETWEEn @d1 AND @d2) AND (stocktransferdetails.branch_id=@branchid)");
            cmd.Parameters.Add("@d1", GetLowDate(ServerDateCurrentdate).AddDays(-1));
            cmd.Parameters.Add("@d2", GetHighDate(ServerDateCurrentdate));
            cmd.Parameters.Add("@branchid", branchid);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<InwardDashboard> InwardDashboardlist = new List<InwardDashboard>();
            foreach (DataRow dr in routes.Rows)
            {
                InwardDashboard getInwardDashboard = new InwardDashboard();
                getInwardDashboard.invoicedate = ((DateTime)dr["invoicedate"]).ToString("dd-MM-yyyy");//dr["inwarddate"].ToString();
                getInwardDashboard.sno = dr["sno"].ToString();
                getInwardDashboard.branchname = dr["branchname"].ToString();
                getInwardDashboard.invoiceno = dr["invoiceno"].ToString();
                InwardDashboardlist.Add(getInwardDashboard);
            }
            string response = GetJson(InwardDashboardlist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);

        }
    }

    private void transferdashboardproductname(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string sno = context.Request["sno"];
            DataTable Report = new DataTable();
            DateTime doe = SalesDBManager.GetTime(vdm.conn);
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT productmaster.productname, (stocktransfersubdetails.quantity *stocktransfersubdetails.price) AS VALUE, stocktransfersubdetails.quantity, stocktransfersubdetails.price FROM  stocktransferdetails INNER JOIN stocktransfersubdetails ON stocktransferdetails.sno = stocktransfersubdetails.stock_refno INNER JOIN productmaster ON stocktransfersubdetails.productid = productmaster.productid WHERE (stocktransfersubdetails.stock_refno = @sno) AND (stocktransferdetails.branchid=@branchid)");
            cmd.Parameters.Add("@sno", sno);
            cmd.Parameters.Add("@branchid", branchid);
            DataTable dttotalinward = vdm.SelectQuery(cmd).Tables[0];
            List<dailyinwardlistclass> daily_inward_list = new List<dailyinwardlistclass>();
            foreach (DataRow dr in dttotalinward.Rows)
            {
                dailyinwardlistclass getinwardtotal = new dailyinwardlistclass();
                double value = Convert.ToDouble(dr["VALUE"].ToString());
                getinwardtotal.price = dr["price"].ToString();
                getinwardtotal.qty = dr["quantity"].ToString();
                value = Math.Round(value, 2);
                getinwardtotal.StoresValue = value.ToString();
                getinwardtotal.productname = dr["productname"].ToString();
                daily_inward_list.Add(getinwardtotal);
            }
            string response = GetJson(daily_inward_list);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    private void get_Po_DataDashboard(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT po_entrydetailes.status, po_entrydetailes.sno, po_entrydetailes.ponumber, po_entrydetailes.podate, po_entrydetailes.supplierid, suppliersdetails.name FROM po_entrydetailes INNER JOIN  suppliersdetails ON po_entrydetailes.supplierid = suppliersdetails.supplierid  WHERE  (po_entrydetailes.podate BETWEEn @d1 AND @d2) AND (po_entrydetailes.branchid=@branchid)");
            cmd.Parameters.Add("@d1", GetLowDate(ServerDateCurrentdate).AddDays(-1));
            cmd.Parameters.Add("@d2", GetHighDate(ServerDateCurrentdate));
            cmd.Parameters.Add("@branchid", branchid);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<InwardDashboard> InwardDashboardlist = new List<InwardDashboard>();
            foreach (DataRow dr in routes.Rows)
            {
                InwardDashboard getInwardDashboard = new InwardDashboard();
                getInwardDashboard.podate = ((DateTime)dr["podate"]).ToString("dd-MM-yyyy");//dr["inwarddate"].ToString();
                getInwardDashboard.sno = dr["sno"].ToString();
                getInwardDashboard.suppliername = dr["name"].ToString();
                getInwardDashboard.ponumber = dr["ponumber"].ToString();
                getInwardDashboard.status = dr["status"].ToString();
                InwardDashboardlist.Add(getInwardDashboard);
            }
            string response = GetJson(InwardDashboardlist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);

        }
    }
    string tempval; string tempmrn; double frie = 0;
    double trans = 0;
    private void get_Pending_inward_Data(HttpContext context)
    {
        try
        {

            vdm = new SalesDBManager();
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string julydt = "07/01/2017";
            DateTime gst_dt = Convert.ToDateTime(julydt);
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT   subinwarddetails.igst, subinwarddetails.cgst, subinwarddetails.sgst, inwarddetails.doorno, inwarddetails.mrnno, inwarddetails.sno, inwarddetails.pono, inwarddetails.inwarddate, inwarddetails.invoiceno, inwarddetails.invoicedate, inwarddetails.dcno, inwarddetails.lrno, inwarddetails.supplierid, inwarddetails.podate, inwarddetails.indentno, inwarddetails.remarks, inwarddetails.securityno, inwarddetails.transportname, inwarddetails.vehicleno, inwarddetails.modeofinward, subinwarddetails.sno AS Expr1, subinwarddetails.productid, subinwarddetails.quantity, subinwarddetails.perunit, subinwarddetails.totalcost, suppliersdetails.name, suppliersdetails.supplierid AS Expr2, productmaster.productname, productmaster.productcode, pandf.pandf, inwarddetails.transportcharge, inwarddetails.freigtamt FROM  inwarddetails INNER JOIN subinwarddetails ON inwarddetails.sno = subinwarddetails.in_refno INNER JOIN suppliersdetails ON inwarddetails.supplierid = suppliersdetails.supplierid INNER JOIN productmaster ON subinwarddetails.productid = productmaster.productid INNER JOIN pandf ON inwarddetails.pfid = pandf.sno WHERE (inwarddetails.status = 'P') AND (inwarddetails.branchid = @branchid) AND (inwarddetails.inwarddate BETWEEN @d1 AND @d2) ORDER BY inwarddetails.inwarddate");
            cmd.Parameters.Add("@branchid", branchid);
            cmd.Parameters.Add("@d1", GetLowDate(ServerDateCurrentdate).AddDays(-45));
            cmd.Parameters.Add("@d2", GetHighDate(ServerDateCurrentdate));
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(routes);
            DataTable dtinward = view.ToTable(true, "mrnno", "sno", "modeofinward", "securityno", "transportname", "pono", "vehicleno", "name", "inwarddate", "invoiceno", "invoicedate", "dcno", "lrno", "supplierid", "podate", "indentno", "remarks", "doorno");
            DataTable dtsubinward = view.ToTable(true, "pandf", "mrnno", "freigtamt", "sno", "sgst", "cgst", "igst", "productid", "productcode", "Expr1", "productname", "quantity", "inwarddate", "perunit", "totalcost", "transportcharge");
            List<getInwardData> getInwarddetails = new List<getInwardData>();
            List<InwardDetails> inwardlist = new List<InwardDetails>();
            List<SubInward> subinwardlist = new List<SubInward>();
            foreach (DataRow dr in dtinward.Rows)
            {
                InwardDetails getInward = new InwardDetails();
                getInward.inwarddate = ((DateTime)dr["inwarddate"]).ToString("yyyy-MM-dd");//dr["inwarddate"].ToString();
                getInward.invoiceno = dr["invoiceno"].ToString();
                getInward.invoicedate = ((DateTime)dr["invoicedate"]).ToString("yyyy-MM-dd");//dr["invoicedate"].ToString();
                getInward.dcno = dr["dcno"].ToString();
                getInward.lrno = dr["lrno"].ToString();
                getInward.hiddensupplyid = dr["supplierid"].ToString();
                getInward.name = dr["name"].ToString();
                string date = dr["podate"].ToString();
                if (date != "")
                {
                    getInward.podate = ((DateTime)dr["podate"]).ToString("yyyy-MM-dd"); //dr["podate"].ToString();//((DateTime)dr["podate"]).ToString("yyyy-MM-dd"); 
                }
                getInward.indentno = dr["indentno"].ToString();
                getInward.modeofinward = dr["modeofinward"].ToString();
                getInward.securityno = dr["securityno"].ToString();
                getInward.transportname = dr["transportname"].ToString();
                getInward.vehicleno = dr["vehicleno"].ToString();
                getInward.mrnno = dr["mrnno"].ToString();
                getInward.remarks = dr["remarks"].ToString();
                getInward.pono = dr["pono"].ToString();
                getInward.sno = dr["sno"].ToString();
                getInward.doorno = dr["doorno"].ToString();
                inwardlist.Add(getInward);
            }

            foreach (DataRow dr in dtsubinward.Rows)
            {
                SubInward getsubinward = new SubInward();
                string inwarddate1 = ((DateTime)dr["inwarddate"]).ToString();

                //string inwarddate1 = "7/17/2017 12:00:00 AM";
                DateTime inwarddate = Convert.ToDateTime(inwarddate1);
                if (inwarddate < gst_dt)
                {

                }
                else
                {
                    getsubinward.sgst_per = dr["sgst"].ToString();
                    getsubinward.cgst_per = dr["cgst"].ToString();
                    getsubinward.igst_per = dr["igst"].ToString();
                }
                getsubinward.hdnproductsno = dr["productid"].ToString();
                getsubinward.productname = dr["productname"].ToString();
                getsubinward.productcode = dr["productcode"].ToString();
                double quantity = Convert.ToDouble(dr["quantity"].ToString());
                quantity = Math.Round(quantity, 2);
                getsubinward.quantity = quantity.ToString();
                
                getsubinward.PerUnitRs = dr["perunit"].ToString();
                getsubinward.totalcost = dr["totalcost"].ToString();
                getsubinward.sisno = dr["Expr1"].ToString();
                getsubinward.inword_refno = dr["sno"].ToString();
                subinwardlist.Add(getsubinward);
            }
            getInwardData getInwadDatas = new getInwardData();
            getInwadDatas.InwardDetails = inwardlist;
            getInwadDatas.SubInward = subinwardlist;
            getInwarddetails.Add(getInwadDatas);
            string response = GetJson(getInwarddetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    private void Save_Quality_Check_Product(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            var js = new JavaScriptSerializer();
            var title1 = context.Request.Params[1];
            InwardDetails obj = js.Deserialize<InwardDetails>(title1);
            string inwarddate = obj.inwarddate;
            string inwardno = obj.inwardno;
            string remarks = obj.remarks;
            string btnval = obj.btnval;
            string entryby = context.Session["Employ_Sno"].ToString();
            string branchid = context.Session["Po_BranchID"].ToString();
            if (btnval == "Save")
            {
                cmd = new SqlCommand("insert into qualitycheck(inwardnumber,inwarddate,remarks,entryby,branchid) values(@inwardnumber,@inwarddate,@remarks,@entryby,@branchid)");
                cmd.Parameters.Add("@inwardnumber", inwardno);
                cmd.Parameters.Add("@inwarddate", inwarddate);
                cmd.Parameters.Add("@remarks", remarks);
                cmd.Parameters.Add("@entryby", entryby);
                cmd.Parameters.Add("@branchid", branchid);
                vdm.insert(cmd);
                cmd = new SqlCommand("select MAX(sno) as qualitysno  from qualitycheck");
                DataTable dtquality = vdm.SelectQuery(cmd).Tables[0];
                string refno = dtquality.Rows[0]["qualitysno"].ToString();
                foreach (SubInward si in obj.fillitems)
                {
                    if (si.hdnproductsno != "0")
                    {
                        cmd = new SqlCommand("insert into subqualitycheck(productid,qty,quality_refno) values(@productid,@qty,@quality_refno)");
                        cmd.Parameters.Add("@productid", si.hdnproductsno);
                        cmd.Parameters.Add("@qty", si.quantity);
                        cmd.Parameters.Add("@quality_refno", refno);
                        vdm.insert(cmd);
                        cmd = new SqlCommand("update subinwarddetails set status=@status where productid=@productid and in_refno=@inwardno");
                        cmd.Parameters.Add("@productid", si.hdnproductsno);
                        cmd.Parameters.Add("@status", "A");
                        cmd.Parameters.Add("@inwardno", inwardno);
                        vdm.Update(cmd);
                    }
                }
                string Response = GetJson("successfully inserted ");
                context.Response.Write(Response);
            }
        }
        catch
        {
        }
    }

    private void get_quality_check_inward_number(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string sno = context.Request["sno"].ToString();
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT inwarddetails.sno, inwarddetails.pono,inwarddetails.inwarddate, inwarddetails.invoiceno, inwarddetails.invoicedate, inwarddetails.dcno, inwarddetails.lrno, inwarddetails.supplierid, inwarddetails.podate, inwarddetails.indentno, inwarddetails.remarks, inwarddetails.securityno, inwarddetails.transportname, inwarddetails.vehicleno,inwarddetails.modeofinward, subinwarddetails.sno AS Expr1, subinwarddetails.productid,  subinwarddetails.quantity, subinwarddetails.perunit, subinwarddetails.totalcost, suppliersdetails.name, suppliersdetails.supplierid, productmaster.productname, productmaster.productcode FROM inwarddetails INNER JOIN subinwarddetails ON inwarddetails.sno = subinwarddetails.in_refno INNER JOIN suppliersdetails ON inwarddetails.supplierid = suppliersdetails.supplierid INNER JOIN productmaster ON subinwarddetails.productid = productmaster.productid  WHERE (inwarddetails.sno =@sno) AND (inwarddetails.branchid=@branchid)");
            cmd.Parameters.Add("@sno", @sno);
            cmd.Parameters.Add("@branchid", branchid);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(routes);
            DataTable dtinward = view.ToTable(true, "sno", "modeofinward", "securityno", "transportname", "pono", "vehicleno", "name", "inwarddate", "invoiceno", "invoicedate", "dcno", "lrno", "supplierid", "podate", "indentno", "remarks");
            DataTable dtsubinward = view.ToTable(true, "sno", "productid", "productcode", "Expr1", "productname", "quantity", "perunit", "totalcost");
            List<getInwardData> getInwarddetails = new List<getInwardData>();
            List<InwardDetails> inwardlist = new List<InwardDetails>();
            List<SubInward> subinwardlist = new List<SubInward>();
            foreach (DataRow dr in dtinward.Rows)
            {
                InwardDetails getInward = new InwardDetails();
                getInward.inwarddate = ((DateTime)dr["inwarddate"]).ToString("yyyy-MM-dd");//dr["inwarddate"].ToString();
                getInward.invoiceno = dr["invoiceno"].ToString();
                getInward.invoicedate = ((DateTime)dr["invoicedate"]).ToString("yyyy-MM-dd");//dr["invoicedate"].ToString();
                getInward.dcno = dr["dcno"].ToString();
                getInward.lrno = dr["lrno"].ToString();
                getInward.hiddensupplyid = dr["supplierid"].ToString();
                getInward.name = dr["name"].ToString();
                getInward.podate = ((DateTime)dr["podate"]).ToString("yyyy-MM-dd"); //dr["podate"].ToString();//((DateTime)dr["podate"]).ToString("yyyy-MM-dd"); 
                getInward.indentno = dr["indentno"].ToString();
                getInward.modeofinward = dr["modeofinward"].ToString();
                getInward.securityno = dr["securityno"].ToString();
                getInward.transportname = dr["transportname"].ToString();
                getInward.vehicleno = dr["vehicleno"].ToString();
                getInward.remarks = dr["remarks"].ToString();
                getInward.pono = dr["pono"].ToString();
                getInward.sno = dr["sno"].ToString();
                inwardlist.Add(getInward);
            }
            foreach (DataRow dr in dtsubinward.Rows)
            {
                SubInward getsubinward = new SubInward();
                getsubinward.hdnproductsno = dr["productid"].ToString();
                getsubinward.productname = dr["productname"].ToString();
                getsubinward.productcode = dr["productcode"].ToString();
                getsubinward.quantity = dr["quantity"].ToString();
                getsubinward.PerUnitRs = dr["perunit"].ToString();
                getsubinward.totalcost = dr["totalcost"].ToString();
                getsubinward.sisno = dr["Expr1"].ToString();
                getsubinward.inword_refno = dr["sno"].ToString();
                subinwardlist.Add(getsubinward);
            }
            getInwardData getInwadDatas = new getInwardData();
            getInwadDatas.InwardDetails = inwardlist;
            getInwadDatas.SubInward = subinwardlist;
            getInwarddetails.Add(getInwadDatas);
            string response = GetJson(getInwarddetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);

        }
    }

    public class BranchDetalis
    {
        public string branchname { get; set; }
        public string branchid { get; set; }
        public string tinno { get; set; }
        public string emailid { get; set; }
        public string Phone { get; set; }
        public string address { get; set; }
        public string cstno { get; set; }
        public string stno { get; set; }
        public string type { get; set; }
        public string warehouse { get; set; }
        public string tally_branch { get; set; }
        public string id { get; set; }
        public string name { get; set; }
        public string gst_no { get; set; }
        public string gst_reg_type { get; set; }
        public string state { get; set; }
        public string fromstate { get; set; }
        public string frombranch { get; set; }
        public string sno { get; set; }
        public string btnVal { get; set; }
    }
    private void saveBranchDetails(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string mainbranch = context.Session["mainbranch"].ToString();
            string branchname = context.Request["branchname"];
            string tinno = context.Request["tinno"];
            string emailid = context.Request["emailid"];
            string Phone = context.Request["Phone"];
            string address = context.Request["address"];
            string cstno = context.Request["cstno"];
            string stno = context.Request["stno"];
            string type = context.Request["type"];
            string warehouse = context.Request["warehouse"];
            string tally_branch = context.Request["tally_branch"];
            string acc_branch = context.Request["acc_branch"];
            string btnSave = context.Request["btnVal"];
            string branchid = context.Request["branchid"];
            string statename = context.Request["statename"];
            string gst_reg_type = context.Request["gst_reg_type"];
            string gstin = context.Request["gstin"];
            
            if (btnSave == "save")
            {
                cmd = new SqlCommand("insert into branchmaster (branchname,tino,emailid,phone,address,cstno,stno,whcode,tbranchname,type,GSTIN,statename,regtype,accledgername) values (@branchname,@tinno,@emailid,@phone,@address,@cstno,@stno,@warehouse,@tally_branch,@type,@gstin,@statename,@gst_reg_type,@accledgername)");
                cmd.Parameters.Add("@branchname", branchname);
                cmd.Parameters.Add("@tinno", tinno);
                cmd.Parameters.Add("@emailid", emailid);
                cmd.Parameters.Add("@phone", Phone);
                cmd.Parameters.Add("@address", address);
                cmd.Parameters.Add("@cstno", cstno);
                cmd.Parameters.Add("@stno", stno);
                cmd.Parameters.Add("@type", type);
                cmd.Parameters.Add("@warehouse", warehouse);
                cmd.Parameters.Add("@tally_branch", tally_branch);
                cmd.Parameters.Add("@statename", statename);
                cmd.Parameters.Add("@gst_reg_type", gst_reg_type);
                cmd.Parameters.Add("@gstin", gstin);
                cmd.Parameters.Add("@accledgername", acc_branch);
                vdm.insert(cmd);

                cmd = new SqlCommand("SELECT { fn IFNULL(MAX(branchid), 0) } AS branchid FROM  branchmaster");
                DataTable dt_branch = vdm.SelectQuery(cmd).Tables[0];
                string subbranchid = dt_branch.Rows[0]["branchid"].ToString();

                cmd = new SqlCommand("insert into branchmapping(subbranch,mainbranch) values (@subbranch,@mainbranch)");
                cmd.Parameters.Add("@subbranch", subbranchid);
                cmd.Parameters.Add("@mainbranch", mainbranch);
                vdm.insert(cmd);

                string msg = "Branch details successfully Saved";
                string response = GetJson(msg);
                context.Response.Write(response);
            }
            else
            {
                cmd = new SqlCommand("Update branchmaster set  branchname=@branchname,tino=@tinno,emailid=@emailid,phone=@phone,address=@address,cstno=@cstno,stno=@stno,whcode=@warehouse,tbranchname=@tally_branch,type=@type,GSTIN=@gstin,statename=@statename,regtype=@gst_reg_type,accledgername=@accledgername where branchid=@branchid ");
                cmd.Parameters.Add("@branchname", branchname);
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@tinno", tinno);
                cmd.Parameters.Add("@emailid", emailid);
                cmd.Parameters.Add("@phone", Phone);
                cmd.Parameters.Add("@address", address);
                cmd.Parameters.Add("@cstno", cstno);
                cmd.Parameters.Add("@stno", stno);
                cmd.Parameters.Add("@type", type);
                cmd.Parameters.Add("@warehouse", warehouse);
                cmd.Parameters.Add("@tally_branch", tally_branch);
                cmd.Parameters.Add("@statename", statename);
                cmd.Parameters.Add("@gst_reg_type", gst_reg_type);
                cmd.Parameters.Add("@gstin", gstin);
                cmd.Parameters.Add("@accledgername", acc_branch);
                vdm.Update(cmd);
                string msg = "Branch details successfully Updated";
                string response = GetJson(msg);
                context.Response.Write(response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_Branch_details(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string branchid = context.Session["Po_BranchID"].ToString();
            string mainbranch = context.Session["mainbranch"].ToString();
            cmd = new SqlCommand("SELECT bam.GSTIN,bam.statename,bam.regtype,bam.branchname,bam.branchid,bam.tino,bam.emailid,bam.phone,bam.address,bam.cstno,bam.stno,bam.whcode,bam.tbranchname,bam.type FROM branchmaster bam INNER JOIN branchmapping BM ON BM.subbranch = bam.branchid WHERE BM.mainbranch=@mbid");
            cmd.Parameters.Add("@mbid", mainbranch);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<BranchDetalis> EmployeDetalis = new List<BranchDetalis>();
            foreach (DataRow dr in routes.Rows)
            {
                BranchDetalis getbrcdetails = new BranchDetalis();
                getbrcdetails.branchname = dr["branchname"].ToString();
                getbrcdetails.branchid = dr["branchid"].ToString();
                getbrcdetails.tinno = dr["tino"].ToString();
                getbrcdetails.emailid = dr["emailid"].ToString();
                getbrcdetails.Phone = dr["phone"].ToString();
                getbrcdetails.address = dr["address"].ToString();
                getbrcdetails.cstno = dr["cstno"].ToString();
                getbrcdetails.stno = dr["stno"].ToString();
                getbrcdetails.type = dr["type"].ToString();
                getbrcdetails.warehouse = dr["whcode"].ToString();
                getbrcdetails.tally_branch = dr["tbranchname"].ToString();
                getbrcdetails.gst_no = dr["GSTIN"].ToString();
                getbrcdetails.gst_reg_type = dr["regtype"].ToString();
                getbrcdetails.state = dr["statename"].ToString();
                EmployeDetalis.Add(getbrcdetails);
            }
            string response = GetJson(EmployeDetalis);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_Branch_details_id(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string branchid = context.Session["Po_BranchID"].ToString();
            string branchname = context.Request["branchname"].ToString();
            cmd = new SqlCommand("SELECT bam.branchname,bam.branchid,bam.tino,bam.emailid,bam.phone,bam.address,bam.cstno,bam.stno,bam.whcode,bam.tbranchname,bam.type FROM branchmaster bam INNER JOIN branchmapping BM ON BM.subbranch = bam.branchid WHERE BM.mainbranch=@mbid AND bam.branchname=@branchname");
            cmd.Parameters.Add("@mbid", branchid);
            cmd.Parameters.Add("@branchname", branchname);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<BranchDetalis> EmployeDetalis = new List<BranchDetalis>();
            foreach (DataRow dr in routes.Rows)
            {
                BranchDetalis getbrcdetails = new BranchDetalis();
                getbrcdetails.branchname = dr["branchname"].ToString();
                getbrcdetails.branchid = dr["branchid"].ToString();
                getbrcdetails.tinno = dr["tino"].ToString();
                getbrcdetails.emailid = dr["emailid"].ToString();
                getbrcdetails.Phone = dr["phone"].ToString();
                getbrcdetails.address = dr["address"].ToString();
                getbrcdetails.cstno = dr["cstno"].ToString();
                getbrcdetails.stno = dr["stno"].ToString();
                getbrcdetails.type = dr["type"].ToString();
                getbrcdetails.warehouse = dr["whcode"].ToString();
                getbrcdetails.tally_branch = dr["tbranchname"].ToString();
                EmployeDetalis.Add(getbrcdetails);
            }
            string response = GetJson(EmployeDetalis);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_Branch_details_type(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string branchid = context.Session["Po_BranchID"].ToString();
            string branch_type = context.Request["branch_type"].ToString();
            if (branch_type != "")
            {
                cmd = new SqlCommand("SELECT GSTIN,branchname,branchid,tino,emailid,phone,address,cstno,stno,whcode,tbranchname,type,statename FROM branchmaster ");
                cmd.Parameters.Add("@branch_type", branch_type);
            }
            else
            {
                cmd = new SqlCommand("SELECT GSTIN,branchname,branchid,tino,emailid,phone,address,cstno,stno,whcode,tbranchname,type,statename FROM branchmaster ");
            }
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<BranchDetalis> EmployeDetalis = new List<BranchDetalis>();
            cmd = new SqlCommand("select statemaster.sno,branchmaster.branchid from statemaster INNER JOIN branchmaster ON statemaster.sno=branchmaster.statename WHERE branchmaster.branchid=@bid");
            cmd.Parameters.Add("@bid", branchid);
            DataTable dt_branch = vdm.SelectQuery(cmd).Tables[0];
            string fromstate = dt_branch.Rows[0]["sno"].ToString();
            foreach (DataRow dr in routes.Rows)
            {
                BranchDetalis getbrcdetails = new BranchDetalis();
                getbrcdetails.branchname = dr["branchname"].ToString();
                getbrcdetails.branchid = dr["branchid"].ToString();
                getbrcdetails.tinno = dr["tino"].ToString();
                getbrcdetails.emailid = dr["emailid"].ToString();
                getbrcdetails.Phone = dr["phone"].ToString();
                getbrcdetails.address = dr["address"].ToString();
                getbrcdetails.cstno = dr["cstno"].ToString();
                getbrcdetails.stno = dr["stno"].ToString();
                getbrcdetails.type = dr["type"].ToString();
                getbrcdetails.warehouse = dr["whcode"].ToString();
                getbrcdetails.tally_branch = dr["tbranchname"].ToString();
                getbrcdetails.state = dr["statename"].ToString();
                getbrcdetails.fromstate = fromstate;
                getbrcdetails.gst_no = dr["GSTIN"].ToString();
                EmployeDetalis.Add(getbrcdetails);
            }
            string response = GetJson(EmployeDetalis);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void saveEmployeDetails(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string EmployeName = context.Request["EmployeName"];
            string Userid = context.Request["Userid"];
            string password = context.Request["password"];
            string E_Mail = context.Request["E_Mail"];
            string Phone = context.Request["Phone"];
            string BranchType = context.Request["BranchType"];
            string Department = context.Request["Department"];
            string LevelType = context.Request["LevelType"];
            string btnSave = context.Request["btnVal"];
            if (btnSave == "save")
            {
                cmd = new SqlCommand("insert into employe_details (employename,userid,password,emailid,phone,leveltype,departmentid,branchid) values (@employename,@userid,@password,@emailid,@phone,@leveltype,@department,@branchtype)");
                cmd.Parameters.Add("@employename", EmployeName);
                cmd.Parameters.Add("@userid", Userid);
                cmd.Parameters.Add("@password", password);
                cmd.Parameters.Add("@emailid", E_Mail);
                cmd.Parameters.Add("@phone", Phone);
                cmd.Parameters.Add("@branchtype", BranchType);
                cmd.Parameters.Add("@leveltype", LevelType);
                cmd.Parameters.Add("@department", Department);
                vdm.insert(cmd);
                string Response = GetJson("Employee Successfully saved");
                context.Response.Write(Response);
            }
            else
            {
                string sno = context.Request["sno"];
                cmd = new SqlCommand("Update employe_details set  employename=@employename,userid=@userid,password=@password ,emailid=@emailid, phone=@phone,branchid=@branchtype, leveltype=@leveltype,departmentid =@department where sno=@sno");
                cmd.Parameters.Add("@sno", sno);
                cmd.Parameters.Add("@employename", EmployeName);
                cmd.Parameters.Add("@userid", Userid);
                cmd.Parameters.Add("@password", password);
                cmd.Parameters.Add("@emailid", E_Mail);
                cmd.Parameters.Add("@phone", Phone);
                cmd.Parameters.Add("@branchtype", BranchType);
                cmd.Parameters.Add("@leveltype", LevelType);
                cmd.Parameters.Add("@department", Department);
                vdm.Update(cmd);
                string response = GetJson("Employee Details Successfully Updated");
                context.Response.Write(response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class EmployeDetalis
    {
        public string EmployeName { get; set; }
        public string Userid { get; set; }
        public string password { get; set; }
        public string E_Mail { get; set; }
        public string Phone { get; set; }
        public string BranchType { get; set; }
        public string LevelType { get; set; }
        public string departmentid { get; set; }
        public string sno { get; set; }
        public string branchid { get; set; }
        public string departmentname { get; set; }
        public string btnVal { get; set; }
    }

    private void get_Employe_details(HttpContext context)
    {
        try
        {
            string branchid = context.Session["Po_BranchID"].ToString();
            vdm = new SalesDBManager();
            cmd = new SqlCommand("SELECT employe_details.sno,employe_details.employename,departmentmaster.department,employe_details.userid,employe_details.password,employe_details.branchid,employe_details.emailid,employe_details.phone,branchmaster.branchname,employe_details.leveltype,employe_details.departmentid FROM employe_details INNER JOIN  branchmaster ON employe_details.branchid=branchmaster.branchid INNER JOIN departmentmaster ON departmentmaster.sno=employe_details.departmentid WHERE branchmaster.branchid=@branchid");
            cmd.Parameters.Add("@branchid", branchid);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<EmployeDetalis> EmployeDetalis = new List<EmployeDetalis>();
            foreach (DataRow dr in routes.Rows)
            {
                EmployeDetalis getempdetails = new EmployeDetalis();
                getempdetails.sno = dr["sno"].ToString();
                getempdetails.EmployeName = dr["employename"].ToString();
                getempdetails.branchid = dr["branchid"].ToString();
                getempdetails.Userid = dr["userid"].ToString();
                getempdetails.password = dr["password"].ToString();
                getempdetails.E_Mail = dr["emailid"].ToString();
                getempdetails.Phone = dr["phone"].ToString();
                getempdetails.BranchType = dr["branchname"].ToString();
                getempdetails.LevelType = dr["leveltype"].ToString();
                getempdetails.departmentid = dr["departmentid"].ToString();
                getempdetails.departmentname = dr["department"].ToString();
                EmployeDetalis.Add(getempdetails);
            }
            string response = GetJson(EmployeDetalis);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }

    }

    private void get_Employe_details_name(HttpContext context)
    {
        try
        {
            string branchid = context.Session["Po_BranchID"].ToString();
            string emp_name = context.Request["emp_name"].ToString();
            vdm = new SalesDBManager();
            cmd = new SqlCommand("SELECT employe_details.sno,employe_details.employename,departmentmaster.department,employe_details.userid,employe_details.password,employe_details.branchid,employe_details.emailid,employe_details.phone,branchmaster.branchname,employe_details.leveltype,employe_details.departmentid FROM employe_details INNER JOIN  branchmaster ON employe_details.branchid=branchmaster.branchid INNER JOIN departmentmaster ON departmentmaster.sno=employe_details.departmentid WHERE branchmaster.branchid=@branchid AND employe_details.employename=@emp_name");
            cmd.Parameters.Add("@branchid", branchid);
            cmd.Parameters.Add("@emp_name", emp_name);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<EmployeDetalis> EmployeDetalis = new List<EmployeDetalis>();
            foreach (DataRow dr in routes.Rows)
            {
                EmployeDetalis getempdetails = new EmployeDetalis();
                getempdetails.sno = dr["sno"].ToString();
                getempdetails.EmployeName = dr["employename"].ToString();
                getempdetails.branchid = dr["branchid"].ToString();
                getempdetails.Userid = dr["userid"].ToString();
                getempdetails.password = dr["password"].ToString();
                getempdetails.E_Mail = dr["emailid"].ToString();
                getempdetails.Phone = dr["phone"].ToString();
                getempdetails.BranchType = dr["branchname"].ToString();
                getempdetails.LevelType = dr["leveltype"].ToString();
                getempdetails.departmentid = dr["departmentid"].ToString();
                getempdetails.departmentname = dr["department"].ToString();
                EmployeDetalis.Add(getempdetails);
            }
            string response = GetJson(EmployeDetalis);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void saveDepartmentdetails(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string department = context.Request["department"];
            string status = context.Request["status"];
            string btnSave = context.Request["btnVal"];
            string branchid = context.Session["Po_BranchID"].ToString();
            if (btnSave == "Save")
            {
                cmd = new SqlCommand("insert into departmentmaster (department,status,branchid) values (@department,@status,@branchid)");
                cmd.Parameters.Add("@branchid", branchid);

                cmd.Parameters.Add("@department", department);
                cmd.Parameters.Add("@status", status);
                vdm.insert(cmd);
                string Response = GetJson("Department Details successfully Inserted");
                context.Response.Write(Response);
            }
            else
            {
                string sno = context.Request["sno"];
                cmd.Parameters.Add("@branchid", branchid);
                cmd = new SqlCommand("Update departmentmaster set  department=@department, status=@status where sno=@sno AND branchid=@branchid");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@department", department);
                cmd.Parameters.Add("@status", status);
                cmd.Parameters.Add("@sno", sno);
                vdm.Update(cmd);
                string response = GetJson("Department Details successfully updated");
                context.Response.Write(response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class Department
    {
        public string department { get; set; }
        public string status { get; set; }
        public string sno { get; set; }
    }

    private void get_Department_Details(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT department,status,sno FROM departmentmaster");// WHERE branchid=@branchid
            cmd.Parameters.Add("@branchid", branchid);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<Department> DepartmentList = new List<Department>();
            foreach (DataRow dr in routes.Rows)
            {
                Department getdepartment = new Department();
                getdepartment.department = dr["department"].ToString();
                var status = dr["status"].ToString();
                if (status == "True")
                {
                    getdepartment.status = "Active";
                }
                if (status == "False")
                {
                    getdepartment.status = "InActive";
                }
                getdepartment.sno = dr["sno"].ToString();
                DepartmentList.Add(getdepartment);
            }
            string response = GetJson(DepartmentList);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void saveBankDetails(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string name = context.Request["Name"];
            string code = context.Request["Code"];
            string status = context.Request["Status"];
            DateTime createdon = DateTime.Now;
            string btnSave = context.Request["btnVal"];
            string branchid = context.Session["Po_BranchID"].ToString();
            if (btnSave == "save")
            {
                cmd = new SqlCommand("insert into bankmaster (bankname,code,status,branchid) values (@bankname,@code,@status,@branchid)");
                cmd.Parameters.Add("@bankname", name);
                cmd.Parameters.Add("@code", code);
                cmd.Parameters.Add("@status", status);
                cmd.Parameters.Add("@branchid", branchid);

                vdm.insert(cmd);
                string msg = "Bank details successfully saved";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {
                string sno = context.Request["sno"];
                cmd = new SqlCommand("Update bankmaster set  code=@code,status=@status,bankname=@bankname where sno=@sno AND branchid=@branchid");
                cmd.Parameters.Add("@bankname", name);
                cmd.Parameters.Add("@code", code);
                cmd.Parameters.Add("@status", status);
                cmd.Parameters.Add("@sno", sno);
                cmd.Parameters.Add("@branchid", branchid);
                vdm.Update(cmd);
                string msg = "Bank details are Successfully updated";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class BankMaster
    {
        public string name { get; set; }
        public string Code { get; set; }
        public string sno { get; set; }
        public string status { get; set; }
        public string code { get; set; }
    }

    private void get_bank_details(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT sno,bankname, code, status FROM bankmaster");// WHERE branchid=@branchid
            cmd.Parameters.Add("@branchid", branchid);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<BankMaster> bankMasterlist = new List<BankMaster>();
            foreach (DataRow dr in routes.Rows)
            {
                BankMaster getbankdetails = new BankMaster();
                getbankdetails.name = dr["bankname"].ToString();
                getbankdetails.code = dr["code"].ToString();
                var status = dr["status"].ToString();
                if (status == "True")
                {
                    getbankdetails.status = "Active";
                }
                if (status == "False")
                {
                    getbankdetails.status = "InActive";
                }
                getbankdetails.sno = dr["sno"].ToString();
                bankMasterlist.Add(getbankdetails);
            }
            string response = GetJson(bankMasterlist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class porise
    {
        public string productcode { get; set; }
        public string productname { get; set; }
        public string productid { get; set; }
        public string price { get; set; }

    }
    private void get_Poraise(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT productcode,productid,productname,price From productmaster");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<porise> porise = new List<porise>();
            foreach (DataRow dr in routes.Rows)
            {
                porise getsectiondetails = new porise();
                getsectiondetails.productcode = dr["productcode"].ToString();
                getsectiondetails.productname = dr["productname"].ToString();
                getsectiondetails.price = dr["price"].ToString();
                getsectiondetails.productid = dr["productid"].ToString();
                porise.Add(getsectiondetails);
            }
            string response = GetJson(porise);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);

        }
    }
    public class supplername
    {
        public string name { get; set; }
        public string supplierid { get; set; }
        public string mobileno { get; set; }
        public string emailid { get; set; }
        public string companyname { get; set; }
        public string tinno { get; set; }
        public string street1 { get; set; }
        public string contactname { get; set; }
        public string gstin { get; set; }
        public string panno { get; set; }
        public string gst_reg_type { get; set; }
        public string state { get; set; }
        public string stateid { get; set; }
    }
    private void get_supplier(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT stateid,state,GSTIN,regtype,panno,name,supplierid,mobileno,emailid,companyname,zipcode,street1,contactname  From  suppliersdetails");
            cmd.Parameters.Add("@branchid", branchid);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<supplername> porise = new List<supplername>();
            foreach (DataRow dr in routes.Rows)
            {
                supplername getsectiondetails = new supplername();
                getsectiondetails.supplierid = dr["supplierid"].ToString();
                getsectiondetails.name = dr["name"].ToString();
                getsectiondetails.mobileno = dr["mobileno"].ToString();
                getsectiondetails.emailid = dr["emailid"].ToString();
                getsectiondetails.companyname = dr["companyname"].ToString();
                getsectiondetails.tinno = dr["zipcode"].ToString();
                getsectiondetails.street1 = dr["street1"].ToString();
                getsectiondetails.contactname = dr["contactname"].ToString();
                getsectiondetails.gstin = dr["GSTIN"].ToString();
                getsectiondetails.gst_reg_type = dr["regtype"].ToString();
                getsectiondetails.panno = dr["panno"].ToString();
                getsectiondetails.state = dr["state"].ToString();
                getsectiondetails.stateid = dr["stateid"].ToString();
                porise.Add(getsectiondetails);
            }
            string response = GetJson(porise);
            context.Response.Write(response);
        }
        catch
        {
        }
    }
    private DateTime GetLowDate(DateTime dt)
    {
        double Hour, Min, Sec;
        DateTime DT = DateTime.Now;
        DT = dt;
        Hour = -dt.Hour;
        Min = -dt.Minute;
        Sec = -dt.Second;
        DT = DT.AddHours(Hour);
        DT = DT.AddMinutes(Min);
        DT = DT.AddSeconds(Sec);
        return DT;
    }
    private DateTime GetHighDate(DateTime dt)
    {
        double Hour, Min, Sec;
        DateTime DT = DateTime.Now;
        Hour = 23 - dt.Hour;
        Min = 59 - dt.Minute;
        Sec = 59 - dt.Second;
        DT = dt;
        DT = DT.AddHours(Hour);
        DT = DT.AddMinutes(Min);
        DT = DT.AddSeconds(Sec);
        return DT;
    }
    private void get_invoice_report(HttpContext context)
    {
        try
        {

            vdm = new SalesDBManager();
            string fdate = context.Request["fromdate"];
            DateTime fromdate = Convert.ToDateTime(fdate);
            string tdate = context.Request["todate"];
            DateTime todate = Convert.ToDateTime(tdate);
            cmd = new SqlCommand("SELECT po_entrydetailes.code, po_entrydetailes.podate, po_entrydetailes.poamount, po_entrydetailes.name, po_entrydetailes.delivarydate, po_entrydetailes.expiredate, po_entrydetailes.mobile, po_sub_detailes.code, po_sub_detailes.description, po_sub_detailes.sno, po_sub_detailes.taxtype,  po_sub_detailes.po_refno FROM po_entrydetailes INNER JOIN po_sub_detailes ON po_entrydetailes.sno = po_sub_detailes.po_refno  where  (po_entrydetailes.podate between @d1 and @d2)");
            cmd.Parameters.Add("@d1", GetLowDate(fromdate));
            cmd.Parameters.Add("@d2", GetHighDate(todate));
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(routes);
            DataTable dtpo = view.ToTable(true, "po_refno", "code", "podate", "poamount", "name", "delivarydate", "expiredate", "mobile");
            DataTable dtpurchase_subdetails = view.ToTable(true, "sno", "code", "description", "taxtype", "po_refno");
            List<get_purchase> purchasedetails = new List<get_purchase>();
            List<podetails> po_lst = new List<podetails>();
            List<subpurchasedetails> purchase_sub_list = new List<subpurchasedetails>();
            foreach (DataRow dr in dtpo.Rows)
            {
                podetails getpurchasedetails = new podetails();
                getpurchasedetails.code = dr["code"].ToString();
                getpurchasedetails.podate = ((DateTime)dr["podate"]).ToString("yyyy-MM-dd"); //dr["podate"].ToString();
                getpurchasedetails.poamount = dr["poamount"].ToString();
                getpurchasedetails.name = dr["name"].ToString();
                getpurchasedetails.delivarydate = ((DateTime)dr["delivarydate"]).ToString("yyyy-MM-dd"); //dr["delivarrydate"].ToString();
                getpurchasedetails.expiredate = ((DateTime)dr["expiredate"]).ToString("yyyy-MM-dd"); //dr[""].ToString();
                getpurchasedetails.mobile = dr["mobile"].ToString();
                getpurchasedetails.pono = dr["po_refno"].ToString();
                po_lst.Add(getpurchasedetails);
            }
            foreach (DataRow dr in dtpurchase_subdetails.Rows)
            {
                subpurchasedetails getroutes = new subpurchasedetails();
                getroutes.code = dr["code"].ToString();
                getroutes.sno = dr["sno"].ToString();
                getroutes.description = dr["description"].ToString();
                getroutes.taxtype = dr["taxtype"].ToString();
                getroutes.pono = dr["po_refno"].ToString();
                purchase_sub_list.Add(getroutes);
            }
            get_purchase get_purchases = new get_purchase();
            get_purchases.podetails = po_lst;
            get_purchases.subpurchasedetails = purchase_sub_list;
            purchasedetails.Add(get_purchases);
            string response = GetJson(purchasedetails);
            context.Response.Write(response);
        }
        catch
        {
        }
    }
    private void get_report(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string po_refno = context.Request["po_refno"];
            cmd = new SqlCommand(" SElECT po_entrydetailes.code, po_entrydetailes.shortname, po_entrydetailes.podate, po_entrydetailes.poamount, po_entrydetailes.name,  po_entrydetailes.delivarydate, po_entrydetailes.expiredate,  po_entrydetailes.freigtamt, po_entrydetailes.mobile, po_entrydetailes.telphone, po_entrydetailes.vattin, po_sub_detailes.code AS Expr1, po_sub_detailes.qty, po_sub_detailes.description, po_sub_detailes.sno, po_sub_detailes.free, po_sub_detailes.cost, po_sub_detailes.ed, po_sub_detailes.taxtype, po_sub_detailes.dis, po_sub_detailes.disamt, po_sub_detailes.po_refno, po_sub_detailes.tax FROM po_entrydetailes INNER JOIN po_sub_detailes ON po_entrydetailes.sno = po_sub_detailes.po_refno where  po_sub_detailes.po_refno=@po_refno");
            cmd.Parameters.Add("@po_refno", po_refno);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(routes);
            DataTable dtpo = view.ToTable(true, "po_refno", "code", "shortname", "podate", "poamount", "name", "delivarydate", "expiredate", "freigtamt", "mobile", "telphone", "vattin");
            DataTable dtpurchase_subdetails = view.ToTable(true, "sno", "code", "description", "qty", "free", "cost", "taxtype", "ed", "dis", "disamt", "tax", "po_refno");
            List<get_purchase> purchasedetails = new List<get_purchase>();
            List<podetails> po_lst = new List<podetails>();
            List<subpurchasedetails> purchase_sub_list = new List<subpurchasedetails>();
            foreach (DataRow dr in dtpo.Rows)
            {
                podetails getpurchasedetails = new podetails();
                getpurchasedetails.code = dr["code"].ToString();
                getpurchasedetails.podate = ((DateTime)dr["podate"]).ToString("yyyy-MM-dd"); //dr["podate"].ToString();
                getpurchasedetails.poamount = dr["poamount"].ToString();
                getpurchasedetails.name = dr["name"].ToString();
                getpurchasedetails.delivarydate = ((DateTime)dr["delivarydate"]).ToString("yyyy-MM-dd"); //dr["delivarrydate"].ToString();
                getpurchasedetails.expiredate = ((DateTime)dr["expiredate"]).ToString("yyyy-MM-dd"); //dr[""].ToString();
                getpurchasedetails.mobile = dr["mobile"].ToString();
                getpurchasedetails.pono = dr["po_refno"].ToString();
                po_lst.Add(getpurchasedetails);
            }
            foreach (DataRow dr in dtpurchase_subdetails.Rows)
            {
                subpurchasedetails getroutes = new subpurchasedetails();
                getroutes.code = dr["code"].ToString();
                getroutes.sno = dr["sno"].ToString();
                getroutes.description = dr["description"].ToString();
                getroutes.taxtype = dr["taxtype"].ToString();
                getroutes.pono = dr["po_refno"].ToString();
                purchase_sub_list.Add(getroutes);
            }
            get_purchase get_purchases = new get_purchase();
            get_purchases.podetails = po_lst;
            get_purchases.subpurchasedetails = purchase_sub_list;
            purchasedetails.Add(get_purchases);
            string response = GetJson(purchasedetails);
            context.Response.Write(response);
        }
        catch
        {
        }
    }
    public class podetails
    {
        public string code { get; set; }
        public string indent_no { get; set; }
        public string pono { get; set; }
        public string shortname { get; set; }
        public string podate { get; set; }
        public string poamount { get; set; }
        public string name { get; set; }
        public string delivarydate { get; set; }
        public string expiredate { get; set; }
        public string freigntamt { get; set; }
        public string mobile { get; set; }
        public string fromstate { get; set; }
        public string telphone { get; set; }
        public string vattin { get; set; }
        public string email { get; set; }
        public string address { get; set; }
        public string quotationno { get; set; }
        public string others { get; set; }
        public string terms { get; set; }
        public string pf { get; set; }
        public string ttax { get; set; }
        public string payment { get; set; }
        public string insurence { get; set; }
        public string insurecetype { get; set; }
        public string vatamount { get; set; }
        public string insuranceamount { get; set; }
        public string remarks { get; set; }
        public string warranty { get; set; }
        public string warranytype { get; set; }
        public string quotationdate { get; set; }
        public string status { get; set; }
        public string deliveryterms { get; set; }
        public string pandf { get; set; }
        public string paymenttype { get; set; }
        public string hiddensupplyid { get; set; }
        public string inwardno { get; set; }
        public string inwarddate { get; set; }
        public string invoiceno { get; set; }
        public string invoicedate { get; set; }
        public string disamt { get; set; }
        public string mrnno { get; set; }
        public string otp { get; set; }
        public string TinNo { get; set; }
        public string contactnumber { get; set; }
        public string pricebasis { get; set; }
        public string billingaddress { get; set; }
        public string ponumber { get; set; }
        public string addressid { get; set; }
        public string deliveryaddress { get; set; }
        public string SupplierRemarks { get; set; }
        public string modeofinward { get; set; }
        public string inwardamount { get; set; }
        public string Add_ress { get; set; }
        public string transport_charges { get; set; }
        public List<subpurchasedetails> Purchase_subarray { get; set; }
        public string btnval { get; set; }
        public string branchid { get; set; }
        public string supplierstate { get; set; }
        public string suppliername { get; set; }
        public string supplierid { get; set; }
        public string suppliergstin { get; set; }
        public string branchstate { get; set; }
        public string branchname { get; set; }
        public string branchgstin { get; set; }
        public string branchaddress { get; set; }
        public string branchemail { get; set; }
        public string branchphone { get; set; }
        public string session_gstin { get; set; }
        public string sup_bank_acc_no { get; set; }
        public string sup_bank_ifsc_code { get; set; }
        public string gstnno { get; set; }
        public string rev_chrg { get; set; }
        
    }
    public class subpurchasedetails
    {
        public string sno { get; set; }
        public string code { get; set; }
        public string itemcode { get; set; }
        public string description { get; set; }
        public string productamount { get; set; }
        public string qty { get; set; }
        public string cost { get; set; }
        public string free { get; set; }
        public string ed { get; set; }
        public string dis { get; set; }
        public string disamt { get; set; }
        public string tax { get; set; }
        public string sgst { get; set; }
        public string cgst { get; set; }
        public string igst { get; set; }
        public string hsn_code { get; set; }
        public string productname { get; set; }
        public string taxtype { get; set; }
        public string ttype { get; set; }
        public string pfamount { get; set; }
        public string edtax { get; set; }
        public string pfid { get; set; }
        public string uim { get; set; }
        public string vatamount { get; set; }
        public string totalcost { get; set; }
        public string status { get; set; }
        public string inwardno { get; set; }
        public string invoicedate { get; set; }
        public string invoiceno { get; set; }
        public string inwarddate { get; set; }
        public string remarks { get; set; }
        public string hdnproductsno { get; set; }
        public string pono { get; set; }
        public string ddltype { get; set; }
        public string productdescription { get; set; }
        public string mrnno { get; set; }
        public string transcharge { get; set; }
        public string freigntamt { get; set; }
        public string transport { get; set; }
        public string sgst_per { get; set; }
        public string cgst_per { get; set; }
        public string igst_per { get; set; }
        public string sgst_amt { get; set; }
        public string cgst_amt { get; set; }
        public string igst_amt { get; set; }
        public string sgstpercentage { get; set; }
        public string cgstpercentage { get; set; }
        public string igstpercentage { get; set; }
        public string gst_exists { get; set; }
    }

    public class get_purchase
    {
        public List<podetails> podetails { get; set; }
        public List<subpurchasedetails> subpurchasedetails { get; set; }
    }
    private void save_edit_po_click(HttpContext context)
    {
        try
        {
            var js = new JavaScriptSerializer();
            var title1 = context.Request.Params[1];
            podetails obj = js.Deserialize<podetails>(title1);
            string shortname = obj.shortname.TrimEnd();
            string name = obj.name.TrimEnd();
            string poamount = obj.poamount;
            string indent_no = obj.indent_no;
            if (indent_no == "" || indent_no == null)
            {
                indent_no = "0";
            }
            string transport_charges = obj.transport_charges;
            string ddate = obj.delivarydate;
            DateTime delivarydate = Convert.ToDateTime(ddate);
            string ftamt = obj.freigntamt;
            float freigntamt = 0;
            float.TryParse(ftamt, out freigntamt);
            string PONo = obj.pono;
            string pricebasis = obj.pricebasis;
            string quotationno = obj.quotationno;
            string payment = obj.payment;
            if (payment == "select payment")
            {
                payment = "0";
            }
            string pf = obj.pf;
            if (pf == "select pf")
            {
                pf = "0";
            }
            string terms = obj.terms;
            if (terms == "select terms")
            {
                terms = "0";
            }
            string address = obj.address;
            string billingaddress = obj.billingaddress;
            string remarks = obj.remarks;
            string disamt = obj.disamt;
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string createdby = context.Session["Employ_Sno"].ToString();
            DateTime quotationdate = ServerDateCurrentdate;
            string qdate = obj.quotationdate;
            if (qdate == "")
            {
                quotationdate = ServerDateCurrentdate;
            }
            else
            {
                quotationdate = Convert.ToDateTime(qdate);
            }
            string hiddensupplyid = obj.hiddensupplyid;
            string rev_chrg = obj.rev_chrg;
            string btnval = obj.btnval;
            string status = obj.status;

            string alphabets = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            string small_alphabets = "abcdefghijklmnopqrstuvwxyz";
            string numbers = "1234567890";

            string characters = numbers;
            int length = 8;
            string otp = string.Empty;
            for (int i = 0; i < length; i++)
            {
                string character = string.Empty;
                do
                {
                    int index = new Random().Next(0, characters.Length);
                    character = characters.ToCharArray()[index].ToString();
                } while (otp.IndexOf(character) != -1);
                otp += character;
            }
            string branchid = context.Session["Po_BranchID"].ToString();
            vdm = new SalesDBManager();
            if (btnval == "Raise")
            {
                DateTime dtapril = new DateTime();
                DateTime dtmarch = new DateTime();
                int currentyear = ServerDateCurrentdate.Year;
                int nextyear = ServerDateCurrentdate.Year + 1;
                if (ServerDateCurrentdate.Month > 3)
                {
                    string apr = "4/1/" + currentyear;
                    dtapril = DateTime.Parse(apr);
                    string march = "3/31/" + nextyear;
                    dtmarch = DateTime.Parse(march);
                }
                if (ServerDateCurrentdate.Month <= 3)
                {
                    string apr = "4/1/" + (currentyear - 1);
                    dtapril = DateTime.Parse(apr);
                    string march = "3/31/" + (nextyear - 1);
                    dtmarch = DateTime.Parse(march);
                }
                cmd = new SqlCommand("SELECT { fn IFNULL(MAX(ponumber), 0) } + 1 AS Sno FROM  po_entrydetailes WHERE (branchid = @branchid) AND (PODate between @d1 and @d2) ");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@d1", GetLowDate(dtapril));
                cmd.Parameters.Add("@d2", GetHighDate(dtmarch));
                DataTable dtPO = vdm.SelectQuery(cmd).Tables[0];
                string ponumber = dtPO.Rows[0]["Sno"].ToString();
                cmd = new SqlCommand("insert into po_entrydetailes (pricebasis,remarks,shortname,podate,poamount,name,delivarydate,freigtamt,quotationno,quotationdate,supplierid,status,pfid,deliverytermsid,paymentid,otp,ponumber,branchid,addressid,billaddressid,transportcharge,indentno,reversecharge,createddate,createdby)values (@pricebasis,@remarks,@shortname,@podate,@poamount,@name,@delivarydate,@freigntamt,@quotationno,@quotationdate,@hiddensupplyid,@status,@pf,@terms,@payment,@otp,@ponumber,@branchid,@address,@billaddressid,@transport_charges,@indent_no,@reversecharge,@doe,@createdby)");
                cmd.Parameters.Add("@billaddressid", billingaddress);
                cmd.Parameters.Add("@remarks", remarks);
                cmd.Parameters.Add("@address", address);
                cmd.Parameters.Add("@ShortName", shortname);
                cmd.Parameters.Add("@PODate", ServerDateCurrentdate);
                cmd.Parameters.Add("@POAmount", poamount);
                cmd.Parameters.Add("@name", name);
                cmd.Parameters.Add("@Delivarydate", delivarydate);
                cmd.Parameters.Add("@FreigntAmt", freigntamt);
                cmd.Parameters.Add("@pricebasis", pricebasis);
                cmd.Parameters.Add("@quotationno", quotationno);
                cmd.Parameters.Add("@ponumber", ponumber);
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@payment", payment);
                cmd.Parameters.Add("@pf", pf);
                cmd.Parameters.Add("@terms", terms);
                cmd.Parameters.Add("@quotationdate", quotationdate);
                cmd.Parameters.Add("@hiddensupplyid", hiddensupplyid);
                cmd.Parameters.Add("@status", status);
                cmd.Parameters.Add("@otp", otp);
                cmd.Parameters.Add("@transport_charges", transport_charges);
                cmd.Parameters.Add("@indent_no", indent_no);
                cmd.Parameters.Add("@reversecharge", rev_chrg);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@createdby", createdby);
                vdm.insert(cmd);
                cmd = new SqlCommand("select MAX(sno) as poinfo from po_entrydetailes");
                DataTable dtpo = vdm.SelectQuery(cmd).Tables[0];
                string refno = dtpo.Rows[0]["poinfo"].ToString();
                foreach (subpurchasedetails o in obj.Purchase_subarray)
                {
                    if (o.code != "" && o.code != null)
                    {
                        cmd = new SqlCommand("insert into po_sub_detailes(productamount,code,description,qty,cost,dis,disamt,taxtype,ed,tax,edtax,productsno,po_refno,igst,cgst,sgst)values(@productamount,@code,@description,@qty,@cost,@dis,@disamt,@taxtype,@ed,@tax,@edtax,@hdnproductsno,@po_refno,@igst,@cgst,@sgst)");
                        cmd.Parameters.Add("@code", o.code);
                        cmd.Parameters.Add("@description", o.description);
                        cmd.Parameters.Add("@qty", o.qty);
                        cmd.Parameters.Add("@cost", o.cost);
                        cmd.Parameters.Add("@taxtype", o.taxtype);
                        cmd.Parameters.Add("@ed", o.ed);
                        cmd.Parameters.Add("@dis", o.dis);
                        cmd.Parameters.Add("@disamt", o.disamt);
                        cmd.Parameters.Add("@tax", o.tax);
                        cmd.Parameters.Add("@edtax", o.edtax);
                        cmd.Parameters.Add("@productamount", o.productamount);
                        cmd.Parameters.Add("@hdnproductsno", o.hdnproductsno);
                        cmd.Parameters.Add("@po_refno", refno);
                        cmd.Parameters.Add("@igst", o.igst);
                        cmd.Parameters.Add("@cgst", o.cgst);
                        cmd.Parameters.Add("@sgst", o.sgst);
                        vdm.insert(cmd);
                    }
                }
                string msg = ponumber + " PO Number Details Successfully Inserted";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {
                cmd = new SqlCommand("update po_entrydetailes set reversecharge=@reversecharge,billaddressid=@billaddressid,transportcharge=@transport_charges,freigtamt=@freigtamt,addressid=@address,pricebasis=@pricebasis,remarks=@remarks,shortname=@shortname,poamount=@poamount,name=@name,delivarydate=@delivarydate,quotationno=@quotationno,paymentid=@payment,quotationdate=@quotationdate,deliverytermsid=@terms,pfid=@pf ,supplierid=@hiddensupplyid where sno=@po_refno AND branchid=@branchid");
                cmd.Parameters.Add("@billaddressid", billingaddress);
                cmd.Parameters.Add("@remarks", remarks);
                cmd.Parameters.Add("@address", address);
                cmd.Parameters.Add("@shortname", shortname);
                cmd.Parameters.Add("@poamount", poamount);
                cmd.Parameters.Add("@name", name);
                cmd.Parameters.Add("@delivarydate", delivarydate);
                cmd.Parameters.Add("@freigtamt", freigntamt);
                cmd.Parameters.Add("@quotationno", quotationno);
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@pricebasis", pricebasis);
                cmd.Parameters.Add("@pf", pf);
                cmd.Parameters.Add("@terms", terms);
                cmd.Parameters.Add("@payment", payment);
                cmd.Parameters.Add("@quotationdate", quotationdate);
                cmd.Parameters.Add("@hiddensupplyid", hiddensupplyid);
                cmd.Parameters.Add("@transport_charges", transport_charges);
                cmd.Parameters.Add("@po_refno", PONo.Trim());
                cmd.Parameters.Add("@reversecharge", rev_chrg);
                vdm.Update(cmd);
                cmd = new SqlCommand("delete from po_sub_detailes where po_refno=@refno");
                cmd.Parameters.Add("@refno", PONo);
                vdm.Delete(cmd);
                foreach (subpurchasedetails o in obj.Purchase_subarray)
                {
                    if (o.code != "" && o.code != null)
                    {
                        cmd = new SqlCommand("update po_sub_detailes set productamount=@productamount,code=@code,description=@description,qty=@qty,cost=@cost,dis=@dis,disamt=@disamt,taxtype=@taxtype,ed=@ed,tax=@tax,edtax=@edtax,productsno=@hdnproductsno,igst=@igst,cgst=@cgst,sgst=@sgst where po_refno=@po_refno and sno=@sno");
                        cmd.Parameters.Add("@code", o.code);
                        cmd.Parameters.Add("@description", o.description);
                        cmd.Parameters.Add("@qty", o.qty);
                        cmd.Parameters.Add("@cost", o.cost);
                        cmd.Parameters.Add("@ed", o.ed);
                        cmd.Parameters.Add("@taxtype", o.taxtype);
                        cmd.Parameters.Add("@dis", o.dis);
                        cmd.Parameters.Add("@disamt", o.disamt);
                        cmd.Parameters.Add("@tax", o.tax);
                        cmd.Parameters.Add("@edtax", o.edtax);
                        cmd.Parameters.Add("@productamount", o.productamount);
                        cmd.Parameters.Add("@hdnproductsno", o.hdnproductsno);
                        cmd.Parameters.Add("@po_refno", PONo);
                        cmd.Parameters.Add("@sno", o.sno);
                        cmd.Parameters.Add("@igst", o.igst);
                        cmd.Parameters.Add("@cgst", o.cgst);
                        cmd.Parameters.Add("@sgst", o.sgst);
                        if (vdm.Update(cmd) == 0)
                        {
                            cmd = new SqlCommand("insert into po_sub_detailes(productamount,code,description,qty,cost,disamt,dis,taxtype,ed,edtax,tax,productsno,po_refno,igst,cgst,sgst)values(@productamount,@code,@description,@qty,@cost,@disamt,@dis,@taxtype,@ed, @edtax, @tax,@hdnproductsno,@po_refno,@igst,@cgst,@sgst)");
                            cmd.Parameters.Add("@code", o.code);
                            cmd.Parameters.Add("@description", o.description);
                            cmd.Parameters.Add("@qty", o.qty);
                            cmd.Parameters.Add("@cost", o.cost);
                            cmd.Parameters.Add("@taxtype", o.taxtype);
                            cmd.Parameters.Add("@ed", o.ed);
                            cmd.Parameters.Add("@dis", o.dis);
                            cmd.Parameters.Add("@disamt", o.disamt);
                            cmd.Parameters.Add("@tax", o.tax);
                            cmd.Parameters.Add("@edtax", o.edtax);
                            cmd.Parameters.Add("@productamount", o.productamount);
                            cmd.Parameters.Add("@hdnproductsno", o.hdnproductsno);
                            cmd.Parameters.Add("@po_refno", PONo);
                            cmd.Parameters.Add("@igst", o.igst);
                            cmd.Parameters.Add("@cgst", o.cgst);
                            cmd.Parameters.Add("@sgst", o.sgst);
                            vdm.insert(cmd);
                        }
                    }
                }
                string msg = PONo + "    PO Number Details Successfully Updated";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    private void get_purchase_details(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string julydt = "07/01/2017";
            DateTime gst_dt = Convert.ToDateTime(julydt);
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT po_sub_detailes.dis, po_entrydetailes.reversecharge, po_sub_detailes.disamt, po_entrydetailes.billaddressid, po_entrydetailes.transportcharge, po_entrydetailes.addressid, po_entrydetailes.pricebasis, po_entrydetailes.ponumber, uimmaster.uim, po_sub_detailes.code, po_entrydetailes.remarks, po_entrydetailes.pfid, po_entrydetailes.indentno, po_entrydetailes.deliverytermsid, po_entrydetailes.paymentid, paymentmaster.paymenttype AS payment, pandf.pandf AS pf, deliveryterms.deliveryterms AS terms, po_entrydetailes.shortname, po_entrydetailes.podate, po_entrydetailes.poamount, po_entrydetailes.name, po_entrydetailes.delivarydate, po_entrydetailes.freigtamt, po_entrydetailes.quotationno, po_entrydetailes.quotationdate, po_entrydetailes.supplierid, po_sub_detailes.qty, po_sub_detailes.description, po_sub_detailes.sno, po_sub_detailes.free, po_sub_detailes.productamount, po_sub_detailes.cost, po_sub_detailes.taxtype, po_sub_detailes.ed, po_sub_detailes.edtax, po_sub_detailes.disamt AS Expr1, po_sub_detailes.productsno, po_sub_detailes.po_refno, po_sub_detailes.tax, po_sub_detailes.igst, po_sub_detailes.cgst, po_sub_detailes.sgst FROM uimmaster INNER JOIN productmaster ON uimmaster.sno = productmaster.uim INNER JOIN po_entrydetailes INNER JOIN po_sub_detailes ON po_entrydetailes.sno = po_sub_detailes.po_refno INNER JOIN paymentmaster ON po_entrydetailes.paymentid = paymentmaster.sno INNER JOIN deliveryterms ON po_entrydetailes.deliverytermsid = deliveryterms.sno INNER JOIN suppliersdetails ON po_entrydetailes.supplierid = suppliersdetails.supplierid ON productmaster.productid = po_sub_detailes.productsno LEFT OUTER JOIN pandf ON po_entrydetailes.pfid = pandf.sno LEFT OUTER JOIN addressdetails ON addressdetails.sno = po_entrydetailes.sno WHERE (po_entrydetailes.branchid = @branchid) and (po_entrydetailes.status='P') ");
            cmd.Parameters.Add("@d1", GetLowDate(ServerDateCurrentdate).AddDays(-70));
            cmd.Parameters.Add("@d2", GetHighDate(ServerDateCurrentdate));
            cmd.Parameters.Add("@branchid", branchid);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(routes);
            DataTable dtpo = view.ToTable(true, "reversecharge", "indentno", "billaddressid", "addressid", "remarks", "ponumber", "pricebasis", "po_refno", "pfid", "deliverytermsid", "paymentid", "shortname", "podate", "poamount", "name", "delivarydate", "freigtamt", "transportcharge", "quotationno", "quotationdate", "payment", "terms", "pf", "supplierid");
            DataTable dtpurchase_subdetails = view.ToTable(true, "uim", "dis", "disamt", "productamount", "code", "sno", "description", "qty", "free", "cost", "ed", "taxtype", "tax", "igst", "cgst", "sgst", "edtax", "productsno", "podate", "po_refno");
            List<get_purchase> purchasedetails = new List<get_purchase>();
            List<podetails> po_lst = new List<podetails>();
            List<subpurchasedetails> purchase_sub_list = new List<subpurchasedetails>();
            foreach (DataRow dr in dtpo.Rows)
            {
                podetails getpurchasedetails = new podetails();
                getpurchasedetails.billingaddress = dr["billaddressid"].ToString();
                getpurchasedetails.indent_no = dr["indentno"].ToString();
                getpurchasedetails.remarks = dr["remarks"].ToString();
                getpurchasedetails.addressid = dr["addressid"].ToString();
                getpurchasedetails.shortname = dr["shortname"].ToString();
                getpurchasedetails.podate = ((DateTime)dr["podate"]).ToString("dd-MM-yyyy"); //dr["podate"].ToString();
                getpurchasedetails.poamount = dr["poamount"].ToString();
                getpurchasedetails.name = dr["name"].ToString();
                getpurchasedetails.delivarydate = ((DateTime)dr["delivarydate"]).ToString("dd-MM-yyyy"); //dr["delivarrydate"].ToString();
                getpurchasedetails.freigntamt = dr["freigtamt"].ToString();
                getpurchasedetails.pricebasis = dr["pricebasis"].ToString();
                getpurchasedetails.quotationno = dr["quotationno"].ToString();
                getpurchasedetails.payment = dr["paymentid"].ToString();
                getpurchasedetails.terms = dr["deliverytermsid"].ToString();
                getpurchasedetails.pf = dr["pfid"].ToString();
                getpurchasedetails.transport_charges = dr["transportcharge"].ToString();
                getpurchasedetails.ponumber = dr["ponumber"].ToString();
                getpurchasedetails.quotationdate = ((DateTime)dr["quotationdate"]).ToString("dd-MM-yyyy");
                getpurchasedetails.hiddensupplyid = dr["supplierid"].ToString();
                getpurchasedetails.pono = dr["po_refno"].ToString();
                getpurchasedetails.rev_chrg = dr["reversecharge"].ToString();
                po_lst.Add(getpurchasedetails);
            }
            foreach (DataRow dr in dtpurchase_subdetails.Rows)
            {
                subpurchasedetails getroutes = new subpurchasedetails();
                string podate1 = ((DateTime)dr["podate"]).ToString();
                //string podate1 = "7/17/2017 12:00:00 AM";
                DateTime podate = Convert.ToDateTime(podate1);
                if (podate < gst_dt)
                {
                    getroutes.ed = dr["ed"].ToString();
                    getroutes.taxtype = dr["taxtype"].ToString();
                    getroutes.tax = dr["tax"].ToString();
                    getroutes.edtax = dr["edtax"].ToString();
                    getroutes.gst_exists = "0";
                }
                else
                {
                    getroutes.sgst_per = dr["sgst"].ToString();
                    getroutes.cgst_per = dr["cgst"].ToString();
                    getroutes.igst_per = dr["igst"].ToString();
                    getroutes.gst_exists = "1";
                }
                getroutes.uim = dr["uim"].ToString();
                getroutes.code = dr["code"].ToString();
                getroutes.sno = dr["sno"].ToString();
                getroutes.description = dr["description"].ToString();
                getroutes.qty = dr["qty"].ToString();
                getroutes.free = dr["free"].ToString();
                getroutes.cost = dr["cost"].ToString();
                getroutes.dis = dr["dis"].ToString();
                getroutes.productamount = dr["productamount"].ToString();
                getroutes.disamt = dr["disamt"].ToString();
                getroutes.hdnproductsno = dr["productsno"].ToString();
                getroutes.pono = dr["po_refno"].ToString();
                purchase_sub_list.Add(getroutes);
            }
            get_purchase get_purchases = new get_purchase();
            get_purchases.podetails = po_lst;
            get_purchases.subpurchasedetails = purchase_sub_list;
            purchasedetails.Add(get_purchases);
            string response = GetJson(purchasedetails);
            context.Response.Write(response);
        }
        catch
        {
        }
    }

    private void Item_pic_files_upload(HttpContext context)
    {
        try
        {
            string branchid = context.Session["Po_BranchID"].ToString();
            if (context.Request.Files.Count > 0)
            {
                string productid = context.Request["productid"];
                if (productid != "" && productid != null && productid != "0")
                {
                    cmd = new SqlCommand("select productname,itemcode from productmaster where productid=@productid");
                    cmd.Parameters.Add("@productid", productid);
                    DataTable dt_productname = vdm.SelectQuery(cmd).Tables[0];
                    string productname = dt_productname.Rows[0]["productname"].ToString();
                    string itemcode = dt_productname.Rows[0]["itemcode"].ToString();
                    HttpFileCollection files = context.Request.Files;
                    for (int i = 0; i < files.Count; i++)
                    {
                        HttpPostedFile file = files[i];
                        string[] extension = file.FileName.Split('.');
                        string upload_filename = "itemid_" + productid + "_" + itemcode + "_branchid_" + branchid + ".jpeg";// +extension[extension.Length - 1];
                        if (UploadpicToFTP(file, upload_filename))
                        {
                            cmd = new SqlCommand("update productmaster  set imgpath=@imagepath where  productid=@productid");
                            cmd.Parameters.Add("@productid", productid);
                            cmd.Parameters.Add("@imagepath", upload_filename);
                            vdm.Update(cmd);
                        }
                    }
                    context.Response.ContentType = "text/plain";
                    string msg = "File Uploaded Successfully!";
                    string Response = GetJson(msg);
                    context.Response.Write(Response);
                }
            }
        }
        catch
        {
        }
    }

    private void Supplier_pic_files_upload(HttpContext context)
    {
        try
        {
            string branchid = context.Session["Po_BranchID"].ToString();
            if (context.Request.Files.Count > 0)
            {
                string supplierid = context.Request["supplierid"];
                if (supplierid != "" && supplierid != null && supplierid != "0")
                {
                    cmd = new SqlCommand("select name,suppliercode from suppliersdetails where supplierid=@supplierid");
                    cmd.Parameters.Add("@supplierid", supplierid);
                    DataTable dt_suppliers = vdm.SelectQuery(cmd).Tables[0];
                    string suppliername = dt_suppliers.Rows[0]["name"].ToString();
                    string suppliercode = dt_suppliers.Rows[0]["suppliercode"].ToString();
                    HttpFileCollection files = context.Request.Files;
                    for (int i = 0; i < files.Count; i++)
                    {
                        HttpPostedFile file = files[i];
                        string[] extension = file.FileName.Split('.');
                        string upload_filename = "supplierId_" + supplierid + "_" + suppliercode + "_branchid_" + branchid + ".jpeg";// +extension[extension.Length - 1];
                        if (UploadpicToFTP(file, upload_filename))
                        {
                            cmd = new SqlCommand("update suppliersdetails  set supplierphoto=@imagepath where  supplierid=@supplierid");
                            cmd.Parameters.Add("@supplierid", supplierid);
                            cmd.Parameters.Add("@imagepath", upload_filename);
                            vdm.Update(cmd);
                        }
                    }
                    context.Response.ContentType = "text/plain";
                    string msg = "File Uploaded Successfully!";
                    string Response = GetJson(msg);
                    context.Response.Write(Response);
                }
            }
        }
        catch
        {
        }
    }

    public class workorder
    {
        public string branch_address { get; set; }
        public string branch_gstin { get; set; }
        public string branch_phone { get; set; }
        public string branch_emailid { get; set; }
        public string branch_statename { get; set; }
        public string branchname { get; set; }
        public string code { get; set; }
        public string pono { get; set; }
        public string shortname { get; set; }
        public string podate { get; set; }
        public string poamount { get; set; }
        public string name { get; set; }
        public string delivarydate { get; set; }
        public string expiredate { get; set; }
        public string freigntamt { get; set; }
        public string mobile { get; set; }
        public string telphone { get; set; }
        public string vattin { get; set; }
        public string email { get; set; }
        public string address { get; set; }
        public string quotationno { get; set; }
        public string others { get; set; }
        public string terms { get; set; }
        public string pf { get; set; }
        public string ttax { get; set; }
        public string payment { get; set; }
        public string insurence { get; set; }
        public string insurecetype { get; set; }
        public string vatamount { get; set; }
        public string insuranceamount { get; set; }
        public string remarks { get; set; }
        public string warranty { get; set; }
        public string warranytype { get; set; }
        public string quotationdate { get; set; }
        public string status { get; set; }
        public string deliveryterms { get; set; }
        public string pandf { get; set; }
        public string paymenttype { get; set; }
        public string hiddensupplyid { get; set; }
        public string inwardno { get; set; }
        public string inwarddate { get; set; }
        public string invoiceno { get; set; }
        public string invoicedate { get; set; }
        public string disamt { get; set; }
        public string mrnno { get; set; }
        public string otp { get; set; }
        public string TinNo { get; set; }
        public string contactnumber { get; set; }
        public string pricebasis { get; set; }
        public string billingaddress { get; set; }
        public string ponumber { get; set; }
        public string addressid { get; set; }
        public string deliveryaddress { get; set; }
        public string SupplierRemarks { get; set; }
        public string sup_stateid { get; set; }
        public string sup_gstin { get; set; }
        public string sup_statename { get; set; }
        public string sno { get; set; }
        public List<subworkorder> WorkOrder_array { get; set; }
        public string btnval { get; set; }
    }

    public class subworkorder
    {
        public string services { get; set; }
        public string sno { get; set; }
        public string code { get; set; }
        public string description { get; set; }
        public string productamount { get; set; }
        public string qty { get; set; }
        public string cost { get; set; }
        public string free { get; set; }
        public string ed { get; set; }
        public string dis { get; set; }
        public string disamt { get; set; }
        public string igst { get; set; }
        public string cgst { get; set; }
        public string sgst { get; set; }
        public string hsncode { get; set; }
        public string gst_exists { get; set; }
        public string tax { get; set; }
        public string productname { get; set; }
        public string taxtype { get; set; }
        public string ttype { get; set; }
        public string pfamount { get; set; }
        public string edtax { get; set; }
        public string pfid { get; set; }
        public string uim { get; set; }
        public string vatamount { get; set; }
        public string totalcost { get; set; }
        public string status { get; set; }
        public string inwardno { get; set; }
        public string invoiceno { get; set; }
        public string inwarddate { get; set; }
        public string remarks { get; set; }
        public string hdnproductsno { get; set; }
        public string pono { get; set; }
        public string ddltype { get; set; }
        public string productdescription { get; set; }
    }

    public class get_workorder
    {
        public List<workorder> workorderdetails { get; set; }
        public List<subworkorder> subworkorderdetails { get; set; }
    }

    private void save_edit_WorkOrder_click(HttpContext context)
    {
        try
        {
            var js = new JavaScriptSerializer();
            var title1 = context.Request.Params[1];
            workorder obj = js.Deserialize<workorder>(title1);
            string shortname = obj.shortname.TrimEnd();
            string name = obj.name.TrimEnd();
            string poamount = obj.poamount;
            string ddate = obj.delivarydate;
            DateTime delivarydate = Convert.ToDateTime(ddate);
            string ftamt = obj.freigntamt;
            float freigntamt = 0;
            float.TryParse(ftamt, out freigntamt);
            string PONo = obj.pono;
            string pricebasis = obj.pricebasis;
            string quotationno = obj.quotationno;
            string payment = obj.payment;
            if (payment == "select payment")
            {
                payment = "0";
            }
            string pf = obj.pf;
            if (pf == "select pf")
            {
                pf = "0";
            }
            string terms = obj.terms;
            if (terms == "select terms")
            {
                terms = "0";
            }
            string address = obj.address;
            string billingaddress = obj.billingaddress;
            string remarks = obj.remarks;
            string disamt = obj.disamt;
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            DateTime quotationdate = ServerDateCurrentdate;
            string qdate = obj.quotationdate;
            if (qdate == "")
            {
                quotationdate = ServerDateCurrentdate;
            }
            else
            {
                quotationdate = Convert.ToDateTime(qdate);
            }
            string hiddensupplyid = obj.hiddensupplyid;
            string btnval = obj.btnval;
            string status = obj.status;

            string alphabets = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            string small_alphabets = "abcdefghijklmnopqrstuvwxyz";
            string numbers = "1234567890";

            string characters = numbers;
            int length = 8;
            string otp = string.Empty;
            for (int i = 0; i < length; i++)
            {
                string character = string.Empty;
                do
                {
                    int index = new Random().Next(0, characters.Length);
                    character = characters.ToCharArray()[index].ToString();
                } while (otp.IndexOf(character) != -1);
                otp += character;
            }
            string branchid = context.Session["Po_BranchID"].ToString();

            vdm = new SalesDBManager();
            if (btnval == "Raise")
            {
                cmd = new SqlCommand("SELECT { fn IFNULL(MAX(ponumber), 0) } + 1 AS Sno FROM  workorderdetails WHERE (branchid = @branchid)");
                cmd.Parameters.Add("@branchid", branchid);
                DataTable dtratechart = vdm.SelectQuery(cmd).Tables[0];
                string ponumber = dtratechart.Rows[0]["Sno"].ToString();
                cmd = new SqlCommand("insert into workorderdetails (pricebasis,remarks,shortname,podate,poamount,name,delivarydate,freigtamt,quotationno,quotationdate,supplierid,status,pfid,deliverytermsid,paymentid,otp,ponumber,branchid,addressid,billaddressid)values (@pricebasis,@remarks,@shortname,@podate,@poamount,@name,@delivarydate,@freigntamt,@quotationno,@quotationdate,@hiddensupplyid,@status,@pf,@terms,@payment,@otp,@ponumber,@branchid,@address,@billaddressid)");
                cmd.Parameters.Add("@billaddressid", billingaddress);
                cmd.Parameters.Add("@remarks", remarks);
                cmd.Parameters.Add("@address", address);
                cmd.Parameters.Add("@ShortName", shortname);
                cmd.Parameters.Add("@PODate", ServerDateCurrentdate);
                cmd.Parameters.Add("@POAmount", poamount);
                cmd.Parameters.Add("@name", name);
                cmd.Parameters.Add("@Delivarydate", delivarydate);
                cmd.Parameters.Add("@FreigntAmt", freigntamt);
                cmd.Parameters.Add("@pricebasis", pricebasis);
                cmd.Parameters.Add("@quotationno", quotationno);
                cmd.Parameters.Add("@ponumber", ponumber);
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@payment", payment);
                cmd.Parameters.Add("@pf", pf);
                cmd.Parameters.Add("@terms", terms);
                cmd.Parameters.Add("@quotationdate", quotationdate);
                cmd.Parameters.Add("@hiddensupplyid", hiddensupplyid);
                cmd.Parameters.Add("@status", status);
                cmd.Parameters.Add("@otp", otp);
                vdm.insert(cmd);
                cmd = new SqlCommand("select MAX(sno) as poinfo from workorderdetails");
                DataTable dtpo = vdm.SelectQuery(cmd).Tables[0];
                string refno = dtpo.Rows[0]["poinfo"].ToString();
                foreach (subworkorder o in obj.WorkOrder_array)
                {
                    if (o.code != "" && o.code != null)
                    {
                        cmd = new SqlCommand("insert into workordersubdetails(productamount,code,description,qty,cost,dis,disamt,taxtype,ed,tax,edtax,productsno,po_refno,services)values(@productamount,@code,@description,@qty,@cost,@dis,@disamt,@taxtype,@ed,@tax,@edtax,@hdnproductsno,@po_refno,@services)");
                        cmd.Parameters.Add("@code", o.code);
                        cmd.Parameters.Add("@description", o.description);
                        cmd.Parameters.Add("@qty", o.qty);
                        cmd.Parameters.Add("@services", o.services);
                        cmd.Parameters.Add("@cost", o.cost);
                        cmd.Parameters.Add("@taxtype", o.taxtype);
                        cmd.Parameters.Add("@ed", o.ed);
                        cmd.Parameters.Add("@dis", o.dis);
                        cmd.Parameters.Add("@disamt", o.disamt);
                        cmd.Parameters.Add("@tax", o.tax);
                        cmd.Parameters.Add("@edtax", o.edtax);
                        cmd.Parameters.Add("@productamount", o.productamount);
                        cmd.Parameters.Add("@hdnproductsno", o.hdnproductsno);
                        cmd.Parameters.Add("@po_refno", refno);
                        vdm.insert(cmd);
                    }
                }
                string msg = ponumber + " WO Number Details Successfully Inserted";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {
                cmd = new SqlCommand("update workorderdetails set billaddressid=@billaddressid,freigtamt=@freigtamt,addressid=@address,pricebasis=@pricebasis,remarks=@remarks,shortname=@shortname,podate=@podate,poamount=@poamount,name=@name,delivarydate=@delivarydate,quotationno=@quotationno,paymentid=@payment,quotationdate=@quotationdate,deliverytermsid=@terms,pfid=@pf ,supplierid=@hiddensupplyid where sno=@po_refno AND branchid=@branchid");
                cmd.Parameters.Add("@billaddressid", billingaddress);
                cmd.Parameters.Add("@remarks", remarks);
                cmd.Parameters.Add("@address", address);

                cmd.Parameters.Add("@shortname", shortname);
                cmd.Parameters.Add("@podate", ServerDateCurrentdate);
                cmd.Parameters.Add("@poamount", poamount);
                cmd.Parameters.Add("@name", name);
                cmd.Parameters.Add("@delivarydate", delivarydate);
                cmd.Parameters.Add("@freigtamt", freigntamt);
                cmd.Parameters.Add("@quotationno", quotationno);
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@pricebasis", pricebasis);
                cmd.Parameters.Add("@pf", pf);
                cmd.Parameters.Add("@terms", terms);
                cmd.Parameters.Add("@payment", payment);
                cmd.Parameters.Add("@quotationdate", quotationdate);
                cmd.Parameters.Add("@hiddensupplyid", hiddensupplyid);
                cmd.Parameters.Add("@po_refno", PONo.Trim());
                vdm.Update(cmd);
                foreach (subworkorder o in obj.WorkOrder_array)
                {
                    if (o.code != "" && o.code != null)
                    {
                        cmd = new SqlCommand("update workordersubdetails set services=@services,productamount=@productamount,code=@code,description=@description,qty=@qty,cost=@cost,dis=@dis,disamt=@disamt,taxtype=@taxtype,ed=@ed,tax=@tax,edtax=@edtax,productsno=@hdnproductsno where po_refno=@po_refno and sno=@sno");
                        cmd.Parameters.Add("@code", o.code);
                        cmd.Parameters.Add("@description", o.description);
                        cmd.Parameters.Add("@qty", o.qty);
                        cmd.Parameters.Add("@services", o.services);
                        cmd.Parameters.Add("@cost", o.cost);
                        cmd.Parameters.Add("@ed", o.ed);
                        cmd.Parameters.Add("@taxtype", o.taxtype);
                        cmd.Parameters.Add("@dis", o.dis);
                        cmd.Parameters.Add("@disamt", o.disamt);
                        cmd.Parameters.Add("@tax", o.tax);
                        cmd.Parameters.Add("@edtax", o.edtax);
                        cmd.Parameters.Add("@productamount", o.productamount);
                        cmd.Parameters.Add("@hdnproductsno", o.hdnproductsno);
                        cmd.Parameters.Add("@po_refno", PONo);
                        cmd.Parameters.Add("@sno", o.sno);
                        if (vdm.Update(cmd) == 0)
                        {
                            cmd = new SqlCommand("insert into workordersubdetails(productamount,code,description,qty,cost,disamt,dis,taxtype,ed,edtax,tax,productsno,po_refno)values(@productamount,@code,@description,@qty,@cost,@disamt,@dis,@taxtype,@ed,@tax,@edtax,@hdnproductsno,@po_refno)");
                            cmd.Parameters.Add("@code", o.code);
                            cmd.Parameters.Add("@description", o.description);
                            cmd.Parameters.Add("@qty", o.qty);
                            cmd.Parameters.Add("@cost", o.cost);
                            cmd.Parameters.Add("@taxtype", o.taxtype);
                            cmd.Parameters.Add("@ed", o.ed);
                            cmd.Parameters.Add("@dis", o.dis);
                            cmd.Parameters.Add("@disamt", o.disamt);
                            cmd.Parameters.Add("@tax", o.tax);
                            cmd.Parameters.Add("@edtax", o.edtax);
                            cmd.Parameters.Add("@productamount", o.productamount);
                            cmd.Parameters.Add("@hdnproductsno", o.hdnproductsno);
                            cmd.Parameters.Add("@po_refno", PONo);
                            vdm.insert(cmd);
                        }
                    }
                }
                string msg = PONo + "    WO Number Details Successfully Updated";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_WorkOrder_details(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string julydt = "07/01/2017";
            DateTime gst_dt = Convert.ToDateTime(julydt);
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT workorderdetails.branchid, suppliersdetails.stateid, productmaster.HSNcode, productmaster.sgst, productmaster.cgst, productmaster.igst, workordersubdetails.dis,workordersubdetails.services, workordersubdetails.disamt, workorderdetails.billaddressid, workorderdetails.addressid, workorderdetails.pricebasis, workorderdetails.ponumber, uimmaster.uim, workordersubdetails.code, workorderdetails.remarks, workorderdetails.pfid, workorderdetails.deliverytermsid, workorderdetails.paymentid, paymentmaster.paymenttype AS payment, pandf.pandf AS pf, deliveryterms.deliveryterms AS terms, workorderdetails.shortname, workorderdetails.podate, workorderdetails.poamount, workorderdetails.name, workorderdetails.delivarydate, workorderdetails.freigtamt, workorderdetails.quotationno, workorderdetails.quotationdate, workorderdetails.supplierid, workordersubdetails.qty, workordersubdetails.description, workordersubdetails.sno, workordersubdetails.free, workordersubdetails.productamount, workordersubdetails.cost, workordersubdetails.taxtype, workordersubdetails.ed, workordersubdetails.edtax, workordersubdetails.disamt AS Expr1, workordersubdetails.productsno, workordersubdetails.po_refno, workordersubdetails.tax FROM uimmaster INNER JOIN productmaster ON uimmaster.sno = productmaster.uim INNER JOIN workorderdetails INNER JOIN workordersubdetails ON workorderdetails.sno = workordersubdetails.po_refno INNER JOIN paymentmaster ON workorderdetails.paymentid = paymentmaster.sno INNER JOIN deliveryterms ON workorderdetails.deliverytermsid = deliveryterms.sno INNER JOIN suppliersdetails ON workorderdetails.supplierid = suppliersdetails.supplierid ON productmaster.productid = workordersubdetails.productsno LEFT OUTER JOIN pandf ON workorderdetails.pfid = pandf.sno LEFT OUTER JOIN addressdetails ON addressdetails.sno = workorderdetails.sno WHERE (workorderdetails.branchid = @branchid) ");
            cmd.Parameters.Add("@branchid", branchid);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(routes);
            DataTable dtworkorder = view.ToTable(true, "billaddressid", "addressid", "remarks", "branchid", "ponumber", "pricebasis", "po_refno", "pfid", "deliverytermsid", "paymentid", "shortname", "podate", "poamount", "name", "delivarydate", "freigtamt", "quotationno", "quotationdate", "payment", "terms", "pf", "supplierid");
            DataTable dtsubworkorder = view.ToTable(true, "uim", "dis", "disamt", "productamount", "services", "stateid", "code", "sno", "description", "qty", "free", "cost", "sgst", "cgst", "igst", "HSNcode", "ed", "taxtype", "tax", "edtax", "podate", "productsno", "po_refno");
            List<get_workorder> get_workorder_List = new List<get_workorder>();
            List<workorder> workorder_lst = new List<workorder>();
            List<subworkorder> subworkorder_list = new List<subworkorder>();
            cmd = new SqlCommand("select statename from branchmaster where branchid = @branchid");
            cmd.Parameters.Add("@branchid", branchid);
            DataTable dt_branch = vdm.SelectQuery(cmd).Tables[0];
            string branch_stateid = dt_branch.Rows[0]["statename"].ToString();
            foreach (DataRow dr in dtworkorder.Rows)
            {
                workorder getworkorderdetails = new workorder();
                getworkorderdetails.billingaddress = dr["billaddressid"].ToString();
                getworkorderdetails.remarks = dr["remarks"].ToString();
                getworkorderdetails.addressid = dr["addressid"].ToString();
                getworkorderdetails.shortname = dr["shortname"].ToString();
                getworkorderdetails.podate = ((DateTime)dr["podate"]).ToString("dd-MM-yyyy"); //dr["podate"].ToString();
                getworkorderdetails.poamount = dr["poamount"].ToString();
                getworkorderdetails.name = dr["name"].ToString();
                getworkorderdetails.delivarydate = ((DateTime)dr["delivarydate"]).ToString("dd-MM-yyyy"); //dr["delivarrydate"].ToString();
                getworkorderdetails.freigntamt = dr["freigtamt"].ToString();
                getworkorderdetails.pricebasis = dr["pricebasis"].ToString();
                getworkorderdetails.quotationno = dr["quotationno"].ToString();
                getworkorderdetails.payment = dr["paymentid"].ToString();
                getworkorderdetails.terms = dr["deliverytermsid"].ToString();
                getworkorderdetails.pf = dr["pfid"].ToString();
                getworkorderdetails.ponumber = dr["ponumber"].ToString();
                getworkorderdetails.quotationdate = ((DateTime)dr["quotationdate"]).ToString("dd-MM-yyyy");
                getworkorderdetails.hiddensupplyid = dr["supplierid"].ToString();
                getworkorderdetails.pono = dr["po_refno"].ToString();
                workorder_lst.Add(getworkorderdetails);
            }
            foreach (DataRow dr in dtsubworkorder.Rows)
            {
                subworkorder getsubworkorder = new subworkorder();
                string podate1 = ((DateTime)dr["podate"]).ToString();
                //string podate1 = "7/17/2017 12:00:00 AM";
                DateTime podate = Convert.ToDateTime(podate1);
                if (podate < gst_dt)
                {
                    getsubworkorder.ed = dr["ed"].ToString();
                    getsubworkorder.taxtype = dr["taxtype"].ToString();
                    getsubworkorder.tax = dr["tax"].ToString();
                    getsubworkorder.edtax = dr["edtax"].ToString();
                    getsubworkorder.gst_exists = "0";
                }
                else
                {
                    if (branch_stateid == dr["stateid"].ToString())
                    {
                        getsubworkorder.sgst = dr["sgst"].ToString();
                        getsubworkorder.cgst = dr["cgst"].ToString();
                        getsubworkorder.igst = "0";
                    }
                    else
                    {
                        getsubworkorder.sgst = "0";
                        getsubworkorder.cgst = "0";
                        getsubworkorder.igst = dr["igst"].ToString();
                    }
                    getsubworkorder.hsncode = dr["HSNcode"].ToString();
                    getsubworkorder.gst_exists = "1";
                }
                getsubworkorder.uim = dr["uim"].ToString();
                getsubworkorder.code = dr["code"].ToString();
                getsubworkorder.sno = dr["sno"].ToString();
                getsubworkorder.services = dr["services"].ToString();
                getsubworkorder.description = dr["description"].ToString();
                getsubworkorder.qty = dr["qty"].ToString();
                getsubworkorder.free = dr["free"].ToString();
                getsubworkorder.cost = dr["cost"].ToString();
                getsubworkorder.dis = dr["dis"].ToString();
                getsubworkorder.productamount = dr["productamount"].ToString();
                getsubworkorder.disamt = dr["disamt"].ToString();
                getsubworkorder.hdnproductsno = dr["productsno"].ToString();
                getsubworkorder.pono = dr["po_refno"].ToString();
                subworkorder_list.Add(getsubworkorder);
            }
            get_workorder get_workorder_obj = new get_workorder();
            get_workorder_obj.workorderdetails = workorder_lst;
            get_workorder_obj.subworkorderdetails = subworkorder_list;
            get_workorder_List.Add(get_workorder_obj);
            string response = GetJson(get_workorder_List);
            context.Response.Write(response);
        }
        catch
        {
        }
    }

    private void get_purchaserOrder_details(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string pono = context.Request["pono"].ToString();
            cmd = new SqlCommand("SELECT inwarddetails.remarks, inwarddetails.sno AS inwardsno, inwarddetails.invoiceno, inwarddetails.inwarddate, po_sub_detailes.productsno, po_entrydetailes.pfid, pandf.pandf AS pf, suppliersdetails.warrantytype, po_sub_detailes.edtax, po_sub_detailes.code, suppliersdetails.insuranceamount, paymentmaster.paymenttype, deliveryterms.deliveryterms AS terms, productmaster.productname,uimmaster.uim,po_entrydetailes.code AS code1,suppliersdetails.insurance,po_entrydetailes.quotationno,po_entrydetailes.remarks,po_entrydetailes.warranty,po_entrydetailes.quotationdate, po_entrydetailes.shortname, po_entrydetailes.podate, po_entrydetailes.poamount, po_entrydetailes.name, po_entrydetailes.delivarydate, po_entrydetailes.freigtamt, suppliersdetails.mobileno, suppliersdetails.phoneno,suppliersdetails.emailid, suppliersdetails.zipcode, po_sub_detailes.qty, po_sub_detailes.description, po_sub_detailes.sno, po_sub_detailes.free, po_sub_detailes.cost, po_sub_detailes.taxtype, po_sub_detailes.ed, po_sub_detailes.disamt, po_sub_detailes.po_refno, po_sub_detailes.tax, suppliersdetails.street1,suppliersdetails.city, suppliersdetails.state, suppliersdetails.country  FROM po_entrydetailes INNER JOIN po_sub_detailes ON po_entrydetailes.sno = po_sub_detailes.po_refno INNER JOIN suppliersdetails ON po_entrydetailes.supplierid = suppliersdetails.supplierid INNER JOIN productmaster ON po_sub_detailes.sno=productmaster.productid INNER JOIN deliveryterms ON deliveryterms.sno=po_entrydetailes.deliverytermsid INNER JOIN paymentmaster ON paymentmaster.sno=po_entrydetailes.paymentid LEFT OUTER JOIN pandf ON pandf.sno=po_entrydetailes.pfid INNER JOIN uimmaster ON uimmaster.sno=productmaster.uim INNER JOIN subinwarddetails ON subinwarddetails.productid=po_sub_detailes.productsno INNER JOIN inwarddetails ON inwarddetails.sno=subinwarddetails.in_refno  WHERE  (inwarddetails.sno = @PoRefNo )");
            cmd.Parameters.Add("@PoRefNo", pono);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(routes);
            DataTable dtpo = view.ToTable(true, "vatamount", "warrantytype", "insuranceamount", "po_refno", "code1", "terms", "paymenttype", "quotationno", "quotationdate", "insurance", "street1", "city", "shortname", "podate", "poamount", "name", "delivarydate", "freigtamt", "mobileno", "phoneno", "emailid", "zipcode");
            DataTable dtpurchase_subdetails = view.ToTable(true, "remarks", "inwardsno", "invoiceno", "inwarddate", "productsno", "pfid", "pf", "sno", "productname", "code", "uim", "description", "qty", "free", "cost", "ed", "edtax", "taxtype", "disamt", "tax", "po_refno");
            List<get_purchase> purchasedetails = new List<get_purchase>();
            List<podetails> po_lst = new List<podetails>();
            List<subpurchasedetails> purchase_sub_list = new List<subpurchasedetails>();
            foreach (DataRow dr in dtpo.Rows)
            {
                podetails getpurchasedetails = new podetails();
                getpurchasedetails.warranytype = dr["warrantytype"].ToString();
                getpurchasedetails.code = dr["code1"].ToString();
                getpurchasedetails.shortname = dr["shortname"].ToString();
                getpurchasedetails.podate = ((DateTime)dr["podate"]).ToString("dd/MM/yyyy"); //dr["podate"].ToString();
                getpurchasedetails.poamount = dr["poamount"].ToString();
                getpurchasedetails.name = dr["name"].ToString();
                string address = dr["street1"].ToString() + "," + dr["city"].ToString();
                getpurchasedetails.delivarydate = ((DateTime)dr["delivarydate"]).ToString("dd/MM/yyyy"); //dr["delivarrydate"].ToString();
                getpurchasedetails.freigntamt = dr["freigtamt"].ToString();
                getpurchasedetails.mobile = dr["mobileno"].ToString();
                getpurchasedetails.telphone = dr["phoneno"].ToString();
                getpurchasedetails.email = dr["emailid"].ToString();
                getpurchasedetails.payment = dr["paymenttype"].ToString();
                getpurchasedetails.terms = dr["terms"].ToString();
                getpurchasedetails.insurecetype = dr["insuranceamount"].ToString();
                getpurchasedetails.insurence = dr["insurance"].ToString();
                getpurchasedetails.vattin = dr["zipcode"].ToString();
                getpurchasedetails.pono = dr["po_refno"].ToString();
                getpurchasedetails.vatamount = dr["vatamount"].ToString();
                getpurchasedetails.address = address;
                getpurchasedetails.quotationno = dr["quotationno"].ToString(); ;
                getpurchasedetails.quotationdate = ((DateTime)dr["quotationdate"]).ToString("dd/MM/yyyy");
                po_lst.Add(getpurchasedetails);
            }
            foreach (DataRow dr in dtpurchase_subdetails.Rows)
            {
                subpurchasedetails getroutes = new subpurchasedetails();
                getroutes.code = dr["code"].ToString();
                getroutes.uim = dr["uim"].ToString();
                getroutes.sno = dr["sno"].ToString();
                getroutes.description = dr["description"].ToString();
                getroutes.qty = dr["qty"].ToString();
                getroutes.free = dr["free"].ToString();
                getroutes.cost = dr["cost"].ToString();
                getroutes.ed = dr["ed"].ToString();
                getroutes.edtax = dr["edtax"].ToString();
                getroutes.pfid = dr["pfid"].ToString();
                getroutes.pfamount = dr["pf"].ToString();
                getroutes.disamt = dr["disamt"].ToString();
                getroutes.taxtype = dr["taxtype"].ToString();
                getroutes.tax = dr["tax"].ToString();
                getroutes.hdnproductsno = dr["productsno"].ToString();
                getroutes.inwardno = dr["inwardsno"].ToString();
                getroutes.remarks = dr["remarks"].ToString();
                getroutes.invoiceno = dr["invoiceno"].ToString();
                getroutes.inwarddate = dr["inwarddate"].ToString();
                getroutes.pono = dr["po_refno"].ToString();
                purchase_sub_list.Add(getroutes);
            }
            get_purchase get_purchases = new get_purchase();
            get_purchases.podetails = po_lst;
            get_purchases.subpurchasedetails = purchase_sub_list;
            purchasedetails.Add(get_purchases);
            string response = GetJson(purchasedetails);
            context.Response.Write(response);
        }
        catch
        {
        }
    }
    private void get_inwardOrder_details(HttpContext context) //new
    {
        try
        {
            vdm = new SalesDBManager();
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string julydt = "07/01/2017";
            DateTime gst_dt = Convert.ToDateTime(julydt);
            string inwardrefno = context.Request["pono"].ToString();
            string branchid = context.Session["Po_BranchID"].ToString();
            string Add_ress = context.Session["Address"].ToString();
            string session_gstin = context.Session["gstin"].ToString();
            if (inwardrefno != "")
            {
                cmd = new SqlCommand("SELECT  po_entrydetailes.ponumber,po_entrydetailes.podate,inwarddetails.status,po_entrydetailes.reversecharge,suppliersdetails.bankaccountno,suppliersdetails.bankifsccode,state_sup.statename as sup_state,suppliersdetails.GSTIN as sup_gstin,suppliersdetails.stateid as sup_stateid,productmaster.HSNcode,subinwarddetails.igst,subinwarddetails.cgst,subinwarddetails.sgst,pandf.pandf, paymentmaster.paymenttype, inwarddetails.pfid, inwarddetails.inwardamount, inwarddetails.transportcharge,inwarddetails.modeofinward, inwarddetails.mrnno, inwarddetails.pono, inwarddetails.sno AS inwardno, inwarddetails.status, inwarddetails.inwarddate,inwarddetails.invoiceno, inwarddetails.invoicedate, inwarddetails.dcno, inwarddetails.lrno, inwarddetails.supplierid, inwarddetails.podate, inwarddetails.indentno, inwarddetails.remarks, inwarddetails.pono AS Expr1, inwarddetails.inwardno AS Expr2, inwarddetails.transportname, inwarddetails.vehicleno,inwarddetails.modeofinward AS Expr3, inwarddetails.securityno, subinwarddetails.productid, subinwarddetails.quantity, subinwarddetails.perunit, subinwarddetails.totalcost, subinwarddetails.in_refno, subinwarddetails.status AS Expr4, productmaster.productname, productmaster.sku, productmaster.itemcode,productmaster.productcode, suppliersdetails.name, suppliersdetails.street1, suppliersdetails.city, suppliersdetails.state, uimmaster.uim, suppliersdetails.country, suppliersdetails.zipcode, taxmaster.type AS taxtype,taxmaster_1.type AS ed, subinwarddetails.tax, subinwarddetails.edtax, subinwarddetails.disamt, subinwarddetails.dis, inwarddetails.freigtamt FROM inwarddetails INNER JOIN subinwarddetails ON inwarddetails.sno = subinwarddetails.in_refno INNER JOIN productmaster ON productmaster.productid = subinwarddetails.productid INNER JOIN suppliersdetails ON suppliersdetails.supplierid = inwarddetails.supplierid LEFT OUTER JOIN taxmaster ON subinwarddetails.taxtype = taxmaster.sno LEFT OUTER JOIN taxmaster AS taxmaster_1 ON subinwarddetails.tax = taxmaster_1.sno LEFT OUTER JOIN uimmaster ON uimmaster.sno = productmaster.uim LEFT OUTER JOIN pandf on pandf.sno=inwarddetails.pfid LEFT OUTER JOIN po_entrydetailes on po_entrydetailes.sno = inwarddetails.pono LEFT OUTER JOIN paymentmaster ON paymentmaster.sno = po_entrydetailes.paymentid LEFT OUTER JOIN statemaster as state_sup ON state_sup.sno=suppliersdetails.stateid WHERE (inwarddetails.sno = @PoRefNo) AND (inwarddetails.branchid = @branchid)");
                cmd.Parameters.Add("@PoRefNo", inwardrefno);
                cmd.Parameters.Add("@branchid", branchid);
            }
            else
            {
                cmd = new SqlCommand("SELECT  po_entrydetailes.ponumber,po_entrydetailes.podate,inwarddetails.status,po_entrydetailes.reversecharge,suppliersdetails.bankaccountno,suppliersdetails.bankifsccode,state_sup.statename as sup_state,suppliersdetails.GSTIN as sup_gstin,suppliersdetails.stateid as sup_stateid,productmaster.HSNcode,subinwarddetails.igst,subinwarddetails.cgst,subinwarddetails.sgst,pandf.pandf, inwarddetails.pfid, inwarddetails.inwardamount, inwarddetails.transportcharge,inwarddetails.modeofinward, inwarddetails.mrnno, inwarddetails.pono, inwarddetails.sno AS inwardno, inwarddetails.status, inwarddetails.inwarddate,inwarddetails.invoiceno, inwarddetails.invoicedate, inwarddetails.dcno, inwarddetails.lrno, inwarddetails.supplierid, inwarddetails.podate, inwarddetails.indentno, inwarddetails.remarks, inwarddetails.pono AS Expr1, inwarddetails.inwardno AS Expr2, inwarddetails.transportname, inwarddetails.vehicleno,inwarddetails.modeofinward AS Expr3, inwarddetails.securityno, subinwarddetails.productid, subinwarddetails.quantity, subinwarddetails.perunit, subinwarddetails.totalcost, subinwarddetails.in_refno, subinwarddetails.status AS Expr4, productmaster.productname, productmaster.sku, productmaster.itemcode,productmaster.productcode, suppliersdetails.name, suppliersdetails.street1, suppliersdetails.city, suppliersdetails.state, uimmaster.uim, suppliersdetails.country, suppliersdetails.zipcode, taxmaster.type AS taxtype,taxmaster_1.type AS ed subinwarddetails.tax, subinwarddetails.edtax, subinwarddetails.disamt, subinwarddetails.dis, inwarddetails.freigtamt FROM inwarddetails INNER JOIN subinwarddetails ON inwarddetails.sno = subinwarddetails.in_refno INNER JOIN productmaster ON productmaster.productid = subinwarddetails.productid INNER JOIN suppliersdetails ON suppliersdetails.supplierid = inwarddetails.supplierid LEFT OUTER JOIN taxmaster ON subinwarddetails.taxtype = taxmaster.sno LEFT OUTER JOIN taxmaster AS taxmaster_1 ON subinwarddetails.tax = taxmaster_1.sno LEFT OUTER JOIN uimmaster ON uimmaster.sno = productmaster.uim LEFT OUTER JOIN pandf on pandf.sno=inwarddetails.pfid LEFT OUTER JOIN statemaster as state_sup ON state_sup.sno=suppliersdetails.stateid WHERE (inwarddetails.sno = @PoRefNo) AND (inwarddetails.branchid = @branchid)");
                cmd.Parameters.Add("@PoRefNo", inwardrefno);
                cmd.Parameters.Add("@branchid", branchid);
            }
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(routes);
            DataTable dtpo = view.ToTable(true, "mrnno", "ponumber", "podate", "status", "reversecharge", "sup_gstin", "sup_state", "bankaccountno", "bankifsccode", "inwardamount", "paymenttype", "inwardno", "pono", "modeofinward", "inwarddate", "zipcode", "invoiceno", "invoicedate", "remarks", "name", "street1", "city");
            DataTable dtpurchase_subdetails = view.ToTable(true, "pandf", "pfid", "productname", "transportcharge", "inwardno", "status", "inwarddate", "productid", "quantity", "perunit", "totalcost", "sku", "itemcode", "productcode", "uim", "remarks", "taxtype", "ed", "tax", "igst", "cgst", "sgst", "HSNcode", "edtax", "disamt", "dis", "freigtamt");
            List<get_purchase> purchasedetails = new List<get_purchase>();
            List<podetails> po_lst = new List<podetails>();
            List<subpurchasedetails> purchase_sub_list = new List<subpurchasedetails>();
            cmd = new SqlCommand("select statemaster.statename,branchmaster.branchname,branchmaster.GSTIN from statemaster INNER JOIN branchmaster on statemaster.sno=branchmaster.statename WHERE branchmaster.branchid=@branchid");
            cmd.Parameters.Add("@branchid", branchid);
            DataTable dt_state = vdm.SelectQuery(cmd).Tables[0];
            string purchasedstate = dt_state.Rows[0]["statename"].ToString();
            string branchname = dt_state.Rows[0]["branchname"].ToString();
            string gstin = dt_state.Rows[0]["GSTIN"].ToString();
            DateTime dtapril = new DateTime();
            DateTime dtmarch = new DateTime();
            foreach (DataRow dr in dtpo.Rows)
            {
                podetails getpurchasedetails = new podetails();
                DateTime dt_inw = Convert.ToDateTime(dr["inwarddate"].ToString());
                int currentyear = dt_inw.Year;
                int nextyear = dt_inw.Year + 1;
                int currntyearnum = 0;
                int nextyearnum = 0;
                if (dt_inw.Month > 3)
                {
                    string apr = "4/1/" + currentyear;
                    dtapril = DateTime.Parse(apr);
                    string march = "3/31/" + nextyear;
                    dtmarch = DateTime.Parse(march);
                    currntyearnum = currentyear;
                    nextyearnum = nextyear;
                }
                if (dt_inw.Month <= 3)
                {
                    string apr = "4/1/" + (currentyear - 1);
                    dtapril = DateTime.Parse(apr);
                    string march = "3/31/" + (nextyear - 1);
                    dtmarch = DateTime.Parse(march);
                    currntyearnum = currentyear - 1;
                    nextyearnum = nextyear - 1;
                }
                string mrnnumber = "";
                if (branchid == "2")
                {
                    mrnnumber = "PBK/MRN/" + dtapril.ToString("yy") + "-" + dtmarch.ToString("yy") + "/" + dr["mrnno"].ToString();
                }
                else if (branchid == "4")
                {
                    mrnnumber = "CHN/MRN/" + dtapril.ToString("yy") + "-" + dtmarch.ToString("yy") + "/" + dr["mrnno"].ToString();
                }
                else if (branchid == "35")
                {
                    mrnnumber = "MNPK/MRN/" + dtapril.ToString("yy") + "-" + dtmarch.ToString("yy") + "/" + dr["mrnno"].ToString();
                }
                else if (branchid == "1040")
                {
                    mrnnumber = "KPM/MRN/" + dtapril.ToString("yy") + "-" + dtmarch.ToString("yy") + "/" + dr["mrnno"].ToString();
                }
                else
                {
                    mrnnumber = "MRN/" + dtapril.ToString("yy") + "-" + dtmarch.ToString("yy") + "/" + dr["mrnno"].ToString();
                }
                getpurchasedetails.mrnno = mrnnumber.ToString();
                getpurchasedetails.pono = dr["pono"].ToString();
                getpurchasedetails.TinNo = dr["zipcode"].ToString();
                getpurchasedetails.modeofinward = dr["modeofinward"].ToString();
                getpurchasedetails.inwardno = dr["inwardno"].ToString();
                getpurchasedetails.inwarddate = ((DateTime)dr["inwarddate"]).ToString("dd/MM/yyyy");
                getpurchasedetails.invoiceno = dr["invoiceno"].ToString();
                getpurchasedetails.invoicedate = ((DateTime)dr["invoicedate"]).ToString("dd/MM/yyyy");
                getpurchasedetails.remarks = dr["remarks"].ToString();
                string address = dr["street1"].ToString() + "," + dr["city"].ToString(); //+ "," + dr["zipcode"].ToString();
                getpurchasedetails.name = dr["name"].ToString();
                getpurchasedetails.inwardamount = dr["inwardamount"].ToString();
                getpurchasedetails.paymenttype = dr["paymenttype"].ToString();
                getpurchasedetails.supplierstate = dr["sup_state"].ToString();
                getpurchasedetails.suppliergstin = dr["sup_gstin"].ToString();
                getpurchasedetails.sup_bank_acc_no = dr["bankaccountno"].ToString();
                getpurchasedetails.sup_bank_ifsc_code = dr["bankifsccode"].ToString();
                getpurchasedetails.branchstate = purchasedstate;
                getpurchasedetails.address = address;
                getpurchasedetails.Add_ress = Add_ress;
                getpurchasedetails.branchname = branchname;
                getpurchasedetails.branchgstin = gstin;
                getpurchasedetails.session_gstin = session_gstin;
                getpurchasedetails.rev_chrg = dr["reversecharge"].ToString();
                getpurchasedetails.status = dr["status"].ToString();
                getpurchasedetails.podate = dr["podate"].ToString();
                po_lst.Add(getpurchasedetails);
            }
            foreach (DataRow dr in dtpurchase_subdetails.Rows)
            {
                subpurchasedetails getroutes = new subpurchasedetails();
                string inwarddate1 = ((DateTime)dr["inwarddate"]).ToString();
                //string inwarddate1 = "7/17/2017 12:00:00 AM";
                DateTime inwarddate = Convert.ToDateTime(inwarddate1);
                if (inwarddate < gst_dt)
                {
                    getroutes.ed = dr["ed"].ToString();
                    getroutes.edtax = dr["edtax"].ToString();
                    getroutes.taxtype = dr["taxtype"].ToString();
                    getroutes.tax = dr["tax"].ToString();
                    getroutes.gst_exists = "0";
                }
                else
                {
                    getroutes.sgst_per = dr["sgst"].ToString();
                    getroutes.cgst_per = dr["cgst"].ToString();
                    getroutes.igst_per = dr["igst"].ToString();
                    getroutes.hsn_code = dr["HSNcode"].ToString();
                    getroutes.gst_exists = "1";
                }
                getroutes.uim = dr["uim"].ToString();
                getroutes.code = dr["sku"].ToString();
                getroutes.itemcode = dr["sku"].ToString();
                getroutes.status = dr["status"].ToString();
                getroutes.sno = dr["productid"].ToString();
                getroutes.description = dr["productname"].ToString();
                getroutes.qty = dr["quantity"].ToString();
                getroutes.cost = dr["perunit"].ToString();
                getroutes.productname = dr["productname"].ToString();
                getroutes.totalcost = dr["totalcost"].ToString();
                getroutes.dis = dr["dis"].ToString();
                getroutes.disamt = dr["disamt"].ToString();
                getroutes.freigntamt = dr["freigtamt"].ToString();
                getroutes.transport = dr["transportcharge"].ToString();
                getroutes.pfamount = dr["pandf"].ToString();
                purchase_sub_list.Add(getroutes);
            }
            get_purchase get_purchases = new get_purchase();
            get_purchases.podetails = po_lst;
            get_purchases.subpurchasedetails = purchase_sub_list;
            purchasedetails.Add(get_purchases);
            string response = GetJson(purchasedetails);
            context.Response.Write(response);

        }
        catch
        {
        }
    }

    private void get_purchaserOrder_details_inward(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string julydt = "07/01/2017";
            DateTime gst_dt = Convert.ToDateTime(julydt);
            string pono = context.Request["pono"].ToString();
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT suppliersdetails.name,po_sub_detailes.igst,po_sub_detailes.cgst,po_sub_detailes.sgst,suppliersdetails.state,branchmaster.statename,po_sub_detailes.dis, po_sub_detailes.disamt, po_entrydetailes.paymentid, po_entrydetailes.supplierid, po_entrydetailes.branchid, po_entrydetailes.podate, po_entrydetailes.ponumber,po_entrydetailes.transportcharge,po_entrydetailes.poamount, uimmaster.uim, po_sub_detailes.code, pandf.pandf AS pf, po_entrydetailes.freigtamt, po_sub_detailes.qty, po_sub_detailes.description, po_sub_detailes.sno, po_sub_detailes.free, po_sub_detailes.productamount, po_sub_detailes.cost, po_sub_detailes.disamt AS Expr1, po_sub_detailes.productsno, po_sub_detailes.po_refno, po_sub_detailes.edtax AS edamount, po_sub_detailes.tax AS taxamount, taxmaster_1.type AS edtype, taxmaster.type AS taxtype, po_entrydetailes.poamount, po_entrydetailes.podate FROM uimmaster INNER JOIN productmaster ON uimmaster.sno = productmaster.uim INNER JOIN po_entrydetailes INNER JOIN po_sub_detailes ON po_entrydetailes.sno = po_sub_detailes.po_refno INNER JOIN suppliersdetails ON po_entrydetailes.supplierid = suppliersdetails.supplierid ON productmaster.productid = po_sub_detailes.productsno LEFT OUTER JOIN taxmaster ON po_sub_detailes.taxtype = taxmaster.sno LEFT OUTER JOIN taxmaster AS taxmaster_1 ON po_sub_detailes.ed = taxmaster_1.sno LEFT OUTER JOIN pandf ON po_entrydetailes.pfid = pandf.sno INNER JOIN branchmaster ON po_entrydetailes.branchid=branchmaster.branchid WHERE (po_entrydetailes.branchid = @branchid) AND (po_entrydetailes.sno = @PoRefNo) AND (po_entrydetailes.status ='A')");
            cmd.Parameters.Add("@branchid", branchid);
            cmd.Parameters.Add("@PoRefNo", pono);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(routes);
            DataTable dtpo = view.ToTable(true, "po_refno", "pf", "freigtamt", "name", "supplierid", "poamount", "transportcharge", "paymentid", "state", "statename");
            DataTable dtpurchase_subdetails = view.ToTable(true, "uim", "igst", "cgst", "sgst", "dis", "disamt", "productamount", "sno", "podate", "description", "qty", "free", "cost", "edamount", "taxtype", "taxamount", "edtype", "productsno", "po_refno");
            List<get_purchase> purchasedetails = new List<get_purchase>();
            List<podetails> po_lst = new List<podetails>();
            List<subpurchasedetails> purchase_sub_list = new List<subpurchasedetails>();
            foreach (DataRow dr in dtpo.Rows)
            {
                podetails getpurchasedetails = new podetails();
                getpurchasedetails.pf = dr["pf"].ToString();
                getpurchasedetails.freigntamt = dr["freigtamt"].ToString();
                getpurchasedetails.transport_charges = dr["transportcharge"].ToString();
                getpurchasedetails.pono = dr["po_refno"].ToString();
                getpurchasedetails.poamount = dr["poamount"].ToString();
                getpurchasedetails.paymenttype = dr["paymentid"].ToString();
                getpurchasedetails.supplierstate = dr["state"].ToString();
                getpurchasedetails.branchstate = dr["statename"].ToString();
                getpurchasedetails.suppliername = dr["name"].ToString();
                getpurchasedetails.supplierid = dr["supplierid"].ToString();
                po_lst.Add(getpurchasedetails);
            }
            foreach (DataRow dr in dtpurchase_subdetails.Rows)
            {
                subpurchasedetails getroutes = new subpurchasedetails();
                string podate1 = ((DateTime)dr["podate"]).ToString();
                //string podate1 = "7/17/2017 12:00:00 AM";
                DateTime podate = Convert.ToDateTime(podate1);
                if (podate < gst_dt)
                {
                    getroutes.taxtype = dr["taxtype"].ToString();
                    getroutes.ed = dr["edtype"].ToString();
                    getroutes.tax = dr["taxamount"].ToString();
                    getroutes.edtax = dr["edamount"].ToString();
                    getroutes.gst_exists = "0";
                }
                else
                {
                    getroutes.sgst_per = dr["sgst"].ToString();
                    getroutes.cgst_per = dr["cgst"].ToString();
                    getroutes.igst_per = dr["igst"].ToString();
                    getroutes.gst_exists = "1";
                }
                getroutes.uim = dr["uim"].ToString();
                getroutes.sno = dr["sno"].ToString();
                getroutes.description = dr["description"].ToString();
                getroutes.qty = dr["qty"].ToString();
                getroutes.free = dr["free"].ToString();
                getroutes.cost = dr["cost"].ToString();
                getroutes.dis = dr["dis"].ToString();
                getroutes.productamount = dr["productamount"].ToString();
                getroutes.disamt = dr["disamt"].ToString();
                getroutes.hdnproductsno = dr["productsno"].ToString();
                getroutes.pono = dr["po_refno"].ToString();
                purchase_sub_list.Add(getroutes);
            }
            get_purchase get_purchases = new get_purchase();
            get_purchases.podetails = po_lst;
            get_purchases.subpurchasedetails = purchase_sub_list;
            purchasedetails.Add(get_purchases);
            string response = GetJson(purchasedetails);
            context.Response.Write(response);
        }
        catch
        {
        }
    }

    private void get_purchase_pendingdetails(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string julydt = "07/01/2017";
            DateTime gst_dt = Convert.ToDateTime(julydt);
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT po_sub_detailes.igst,po_sub_detailes.cgst,po_sub_detailes.sgst,taxmaster_1.type as ed,taxmaster.type as taxtype,po_entrydetailes.addressid,po_sub_detailes.dis,po_entrydetailes.warrantytype,po_entrydetailes.pricebasis,po_sub_detailes.code, po_entrydetailes.remarks, po_entrydetailes.warranty, po_entrydetailes.paymentid AS payment, po_entrydetailes.pfid AS pf, po_entrydetailes.deliverytermsid AS terms,po_entrydetailes.shortname, po_entrydetailes.podate, po_entrydetailes.poamount, po_entrydetailes.name, po_entrydetailes.delivarydate,  po_entrydetailes.freigtamt,  po_entrydetailes.quotationno, po_entrydetailes.quotationdate, po_entrydetailes.insurance, po_entrydetailes.insuranceamount, po_entrydetailes.paymentid, po_entrydetailes.pfid, po_entrydetailes.deliverytermsid, po_entrydetailes.supplierid, po_sub_detailes.qty, po_sub_detailes.description, po_sub_detailes.sno, po_sub_detailes.free, po_sub_detailes.cost, po_sub_detailes.taxtype as taxtypeid, po_sub_detailes.ed as edtypeid, po_sub_detailes.edtax,  po_sub_detailes.disamt, po_sub_detailes.productsno, po_sub_detailes.po_refno, po_sub_detailes.tax, paymentmaster.paymenttype, deliveryterms.deliveryterms, pandf.pandf FROM  po_entrydetailes INNER JOIN po_sub_detailes ON po_entrydetailes.sno = po_sub_detailes.po_refno INNER JOIN productmaster ON productmaster.productid = po_sub_detailes.productsno  INNER JOIN  paymentmaster ON po_entrydetailes.paymentid = paymentmaster.sno INNER JOIN deliveryterms ON po_entrydetailes.deliverytermsid = deliveryterms.sno INNER JOIN pandf ON po_entrydetailes.pfid = pandf.sno LEFT OUTER JOIN taxmaster ON po_sub_detailes.taxtype = taxmaster.sno LEFT OUTER JOIN taxmaster AS taxmaster_1 ON po_sub_detailes.ed = taxmaster_1.sno WHERE (po_entrydetailes.status = 'P') AND (po_entrydetailes.branchid=@branchid) ORDER BY po_entrydetailes.sno desc");
            cmd.Parameters.AddWithValue("@branchid", branchid);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(routes);
            DataTable dtpo = view.ToTable(true, "addressid", "remarks", "pricebasis", "paymenttype", "pandf", "deliveryterms", "warrantytype", "warranty", "po_refno", "shortname", "podate", "poamount", "name", "delivarydate", "freigtamt", "quotationno", "quotationdate", "payment", "terms", "pf", "insurance", "insuranceamount", "supplierid");
            DataTable dtpurchase_subdetails = view.ToTable(true, "sno", "code", "sgst", "cgst", "igst", "description", "qty", "dis", "free", "cost", "ed", "taxtype", "tax", "edtax", "productsno", "podate", "disamt", "po_refno");
            List<get_purchase> purchasedetails = new List<get_purchase>();
            List<podetails> po_lst = new List<podetails>();
            List<subpurchasedetails> purchase_sub_list = new List<subpurchasedetails>();
            foreach (DataRow dr in dtpo.Rows)
            {
                podetails getpurchasedetails = new podetails();
                getpurchasedetails.warranytype = dr["warrantytype"].ToString();
                getpurchasedetails.addressid = dr["addressid"].ToString();
                getpurchasedetails.remarks = dr["remarks"].ToString();
                getpurchasedetails.warranty = dr["warranty"].ToString();
                getpurchasedetails.pricebasis = dr["pricebasis"].ToString();
                getpurchasedetails.shortname = dr["shortname"].ToString();
                getpurchasedetails.podate = ((DateTime)dr["podate"]).ToString("dd-MM-yyyy"); //dr["podate"].ToString();
                getpurchasedetails.poamount = dr["poamount"].ToString();
                getpurchasedetails.name = dr["name"].ToString();
                getpurchasedetails.delivarydate = ((DateTime)dr["delivarydate"]).ToString("dd-MM-yyyy"); //dr["delivarrydate"].ToString();
                getpurchasedetails.freigntamt = dr["freigtamt"].ToString();
                getpurchasedetails.quotationno = dr["quotationno"].ToString();
                getpurchasedetails.payment = dr["payment"].ToString();
                getpurchasedetails.terms = dr["terms"].ToString();
                getpurchasedetails.paymenttype = dr["paymenttype"].ToString();
                getpurchasedetails.deliveryterms = dr["deliveryterms"].ToString();
                getpurchasedetails.pandf = dr["pandf"].ToString();
                getpurchasedetails.pf = dr["pf"].ToString();
                getpurchasedetails.insurence = dr["insurance"].ToString();
                getpurchasedetails.insurecetype = dr["insuranceamount"].ToString();
                getpurchasedetails.quotationdate = ((DateTime)dr["quotationdate"]).ToString("dd-MM-yyyy");
                getpurchasedetails.hiddensupplyid = dr["supplierid"].ToString();
                getpurchasedetails.pono = dr["po_refno"].ToString();
                po_lst.Add(getpurchasedetails);
            }
            foreach (DataRow dr in dtpurchase_subdetails.Rows)
            {
                subpurchasedetails getroutes = new subpurchasedetails();
                string podate1 = ((DateTime)dr["podate"]).ToString();
                //string podate1 = "7/17/2017 12:00:00 AM";
                DateTime podate = Convert.ToDateTime(podate1);
                if (podate < gst_dt)
                {
                    getroutes.ed = dr["ed"].ToString();
                    getroutes.taxtype = dr["taxtype"].ToString();
                    getroutes.tax = dr["tax"].ToString();
                    getroutes.edtax = dr["edtax"].ToString();
                    getroutes.gst_exists = "0";
                }
                else
                {
                    getroutes.sgst_per = dr["sgst"].ToString();
                    getroutes.cgst_per = dr["cgst"].ToString();
                    getroutes.igst_per = dr["igst"].ToString();
                    getroutes.gst_exists = "1";
                }
                getroutes.code = dr["code"].ToString();
                getroutes.sno = dr["sno"].ToString();
                getroutes.description = dr["description"].ToString();
                getroutes.qty = dr["qty"].ToString();
                getroutes.free = dr["free"].ToString();
                getroutes.cost = dr["cost"].ToString();
                getroutes.dis = dr["dis"].ToString();
                getroutes.disamt = dr["disamt"].ToString();
                getroutes.hdnproductsno = dr["productsno"].ToString();
                getroutes.pono = dr["po_refno"].ToString();
                purchase_sub_list.Add(getroutes);
            }
            get_purchase get_purchases = new get_purchase();
            get_purchases.podetails = po_lst;
            get_purchases.subpurchasedetails = purchase_sub_list;
            purchasedetails.Add(get_purchases);
            string response = GetJson(purchasedetails);
            context.Response.Write(response);
        }
        catch
        {
        }
    }

    public class inwardsno
    {
        public string sno { get; set; }
    }
    private void get_inward_print(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            List<inwardsno> inwardlist = new List<inwardsno>();
            inwardsno getinwardsno = new inwardsno();
            context.Session["InSno"] = context.Request["sno"].ToString(); ;
            getinwardsno.sno = context.Session["InSno"].ToString();
            inwardlist.Add(getinwardsno);
            string response = GetJson(inwardlist);
            context.Response.Write(response);
        }
        catch
        {
        }
    }

    public class outwardsno
    {
        public string sno { get; set; }
    }

    private void get_outward_print(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            List<outwardsno> outwardlist = new List<outwardsno>();
            outwardsno getoutwardsno = new outwardsno();
            context.Session["OutSno"] = context.Request["sno"].ToString(); ;
            getoutwardsno.sno = context.Session["OutSno"].ToString();
            outwardlist.Add(getoutwardsno);
            string response = GetJson(outwardlist);
            context.Response.Write(response);
        }
        catch
        {
        }
    }

    public class stocksno
    {
        public string sno { get; set; }
    }

    private void get_stock_print(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            List<stocksno> stocklist = new List<stocksno>();
            stocksno getstocksno = new stocksno();
            context.Session["StockSno"] = context.Request["sno"].ToString(); ;
            getstocksno.sno = context.Session["StockSno"].ToString();
            stocklist.Add(getstocksno);
            string response = GetJson(stocklist);
            context.Response.Write(response);
        }
        catch
        {
        }
    }
    public class posno
    {
        public string sno { get; set; }
    }

    private void get_Po_print(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            List<posno> posnolist = new List<posno>();
            posno getposno = new posno();
            context.Session["POSno"] = context.Request["sno"].ToString(); ;
            getposno.sno = context.Session["POSno"].ToString();
            posnolist.Add(getposno);
            string response = GetJson(posnolist);
            context.Response.Write(response);
        }
        catch
        {
        }
    }


    public class OutwardDetails
    {
        public string inwardno { get; set; }
        public string inwarddate { get; set; }
        public string invoicedate { get; set; }
        public string dcno { get; set; }
        public string lrno { get; set; }
        public string remarks { get; set; }
        public string pono { get; set; }
        public string name { get; set; }
        public string btnval { get; set; }
        public string sno { get; set; }
        public string modeofoutward { get; set; }
        public string indentno { get; set; }
        public string issueno { get; set; }
        public string hiddenid { get; set; }
        public string status { get; set; }
        public string outwardsno { get; set; }
        public string type { get; set; }
        public List<SubOutward> fillitems { get; set; }
    }
    public class SubOutward
    {
        public string productname { get; set; }
        public string productcode { get; set; }
        public string quantity { get; set; }
        public string moniterqty { get; set; }
        public string PerUnitRs { get; set; }
        public string totalcost { get; set; }
        public string uim { get; set; }
        public string status { get; set; }
        public string hdnproductsno { get; set; }
        public string sisno { get; set; }
        public string refno { get; set; }
        public string sno { get; set; }
        public string inword_refno { get; set; }
    }
    public class getOutwardData
    {
        public List<OutwardDetails> OutwardDetails { get; set; }
        public List<SubOutward> SubOutward { get; set; }
    }
    private void save_edit_Outward(HttpContext context)
    {
        try
        {
            var js = new JavaScriptSerializer();
            var title1 = context.Request.Params[1];
            OutwardDetails obj = js.Deserialize<OutwardDetails>(title1);
            string invdate = obj.inwarddate;
            DateTime invoiate = Convert.ToDateTime(invdate);
            string inwarddate = invoiate.ToString("MM-dd-yyyy");
            string remarks = obj.remarks;
            string sno = obj.sno;

            string modeofoutward = obj.modeofoutward;
            string indentno = obj.indentno;
            string msg = "";
            string Response = String.Empty;
            string name = obj.name;
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string createdby = context.Session["Employ_Sno"].ToString();
            if (modeofoutward == "Select Mode of Issue")
            {
                modeofoutward = "0";
            }
            string btnval = obj.btnval;
            string branchid = context.Session["Po_BranchID"].ToString();
            vdm = new SalesDBManager();
            if (btnval == "Save")
            {
                cmd = new SqlCommand("SELECT  doe FROM producttransactions WHERE (doe = @d1) GROUP BY doe");
                cmd.Parameters.Add("@d1", inwarddate);
                cmd.Parameters.Add("@d2", inwarddate);
                DataTable dtproducttransaction = vdm.SelectQuery(cmd).Tables[0];
                if (dtproducttransaction.Rows.Count == 0)
                {

                    DateTime dtapril = new DateTime();
                    DateTime dtmarch = new DateTime();
                    int currentyear = ServerDateCurrentdate.Year;
                    int nextyear = ServerDateCurrentdate.Year + 1;
                    if (ServerDateCurrentdate.Month > 3)
                    {
                        string apr = "4/1/" + currentyear;
                        dtapril = DateTime.Parse(apr);
                        string march = "3/31/" + nextyear;
                        dtmarch = DateTime.Parse(march);
                    }
                    if (ServerDateCurrentdate.Month <= 3)
                    {
                        string apr = "4/1/" + (currentyear - 1);
                        dtapril = DateTime.Parse(apr);
                        string march = "3/31/" + (nextyear - 1);
                        dtmarch = DateTime.Parse(march);
                    }
                    cmd = new SqlCommand("SELECT { fn IFNULL(MAX(issueno), 0) } + 1 AS Issueno FROM  outwarddetails WHERE (branchid = @branchid) and (inwarddate between @d1 and @d2)");
                    cmd.Parameters.Add("@branchid", branchid);
                    cmd.Parameters.Add("@d1", GetLowDate(dtapril));
                    cmd.Parameters.Add("@d2", GetHighDate(dtmarch));
                    DataTable dtratechart = vdm.SelectQuery(cmd).Tables[0];
                    string issueno = dtratechart.Rows[0]["Issueno"].ToString();
                    cmd = new SqlCommand("insert into outwarddetails(modeofoutward,inwarddate,indentno,remarks,section_id,status,branchid,issueno,createddate,createdby) values(@modeofoutward,@inwarddate,@indentno,@remarks,@section_id,@status,@branchid,@issueno,@doe,@createdby)");
                    cmd.Parameters.Add("@branchid", branchid);
                    cmd.Parameters.Add("@section_id", name);
                    cmd.Parameters.Add("@modeofoutward", modeofoutward);
                    cmd.Parameters.Add("@inwarddate", inwarddate);
                    cmd.Parameters.Add("@indentno", indentno);
                    cmd.Parameters.Add("@remarks", remarks);
                    cmd.Parameters.Add("@status", 'P');
                    cmd.Parameters.Add("@issueno", issueno);
                    cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                    cmd.Parameters.Add("@createdby", createdby);
                    vdm.insert(cmd);
                    cmd = new SqlCommand("select MAX(sno) as outward from outwarddetails");
                    DataTable dtoutward = vdm.SelectQuery(cmd).Tables[0];
                    string refno = dtoutward.Rows[0]["outward"].ToString();
                    foreach (SubOutward si in obj.fillitems)
                    {
                        if (si.hdnproductsno != "0")
                        {
                            cmd = new SqlCommand("insert into suboutwarddetails(productid,quantity,perunit,totalcost,in_refno) values(@productid,@quantity,@perunit,@totalcost,@in_refno)");
                            cmd.Parameters.Add("@productid", si.hdnproductsno);
                            cmd.Parameters.Add("@quantity", si.quantity);
                            cmd.Parameters.Add("@perunit", si.PerUnitRs);
                            cmd.Parameters.Add("@totalcost", si.totalcost);
                            cmd.Parameters.Add("@in_refno", refno);
                            vdm.insert(cmd);
                        }
                    }
                    msg = issueno + "Outward Number successfully  Inserted";
                    Response = GetJson(msg);
                    context.Response.Write(Response);
                }
                else
                {
                    Response = GetJson("You Dont Have Permission This Date");
                    context.Response.Write(Response);
                }
            }
            else
            {
                cmd = new SqlCommand("SELECT  doe  FROM producttransactions where branchid=@branchid and doe=@inwarddate");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@inwarddate", inwarddate);
                DataTable produtransactiondoe = vdm.SelectQuery(cmd).Tables[0];
                if (produtransactiondoe.Rows.Count != 0)
                {
                    Response = GetJson("You Dont Have Permission This Date");
                    context.Response.Write(Response);
                }
                else
                {
                    cmd = new SqlCommand("update outwarddetails set modeofoutward=@modeofoutward,inwarddate=@inwarddate,indentno=@indentno,section_id=@section_id,remarks=@remarks where sno=@sno AND branchid=@branchid");
                    cmd.Parameters.Add("@section_id", name);
                    cmd.Parameters.Add("@modeofoutward", modeofoutward);
                    cmd.Parameters.Add("@inwarddate", inwarddate);
                    cmd.Parameters.Add("@indentno", indentno);
                    cmd.Parameters.Add("@remarks", remarks);
                    cmd.Parameters.Add("@sno", sno);
                    cmd.Parameters.Add("@branchid", branchid);
                    vdm.Update(cmd);
                    foreach (SubOutward si in obj.fillitems)
                    {
                        cmd = new SqlCommand("select * from suboutwarddetails where  productid=@productid and sno=@sno");
                        cmd.Parameters.Add("@productid", si.hdnproductsno);
                        cmd.Parameters.Add("@sno", si.sisno);
                        DataTable dtprev = vdm.SelectQuery(cmd).Tables[0];
                        float prevqty = 0;
                        if (dtprev.Rows.Count > 0)
                        {
                            string amount = dtprev.Rows[0]["quantity"].ToString();
                            float.TryParse(amount, out prevqty);
                        }
                        cmd = new SqlCommand("update suboutwarddetails set productid=@productid, quantity=@quantity, perunit=@perunit, totalcost=@totalcost where in_refno=@in_refno and sno=@sno ");
                        cmd.Parameters.Add("@productid", si.hdnproductsno);
                        cmd.Parameters.Add("@quantity", si.quantity);
                        cmd.Parameters.Add("@perunit", si.PerUnitRs);
                        cmd.Parameters.Add("@totalcost", si.totalcost);
                        cmd.Parameters.Add("@in_refno", sno);
                        cmd.Parameters.Add("@sno", si.sisno);
                        if (vdm.Update(cmd) == 0)
                        {
                            cmd = new SqlCommand("insert into suboutwarddetails(productid,quantity,perunit,totalcost,in_refno) values(@productid,@quantity,@perunit,@totalcost,@in_refno)");
                            cmd.Parameters.Add("@productid", si.hdnproductsno);
                            cmd.Parameters.Add("@quantity", si.quantity);
                            cmd.Parameters.Add("@perunit", si.PerUnitRs);
                            cmd.Parameters.Add("@totalcost", si.totalcost);
                            cmd.Parameters.Add("@in_refno", sno);
                            vdm.insert(cmd);
                        }
                    }
                    msg = sno + "   OutwardWard Number successfully updated";
                    Response = GetJson(msg);
                    context.Response.Write(Response);
                }
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    private void get_outward_Data(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT productmoniter.qty AS moniterqty, outwarddetails.sno,outwarddetails.modeofoutward,outwarddetails.indentno, outwarddetails.issueno, outwarddetails.inwarddate,uimmaster.uim, productmaster.productname, productmaster.productcode, outwarddetails.dcno, outwarddetails.branch_id, outwarddetails.section_id,  outwarddetails.remarks, suboutwarddetails.sno AS Expr1, suboutwarddetails.productid, suboutwarddetails.quantity, suboutwarddetails.perunit, suboutwarddetails.totalcost, suboutwarddetails.in_refno,  sectionmaster.name FROM outwarddetails INNER JOIN suboutwarddetails ON outwarddetails.sno = suboutwarddetails.in_refno INNER JOIN productmaster ON suboutwarddetails.productid = productmaster.productid LEFT OUTER JOIN sectionmaster ON outwarddetails.section_id = sectionmaster.sectionid INNER JOIN productmoniter ON productmoniter.productid= suboutwarddetails.productid LEFT OUTER JOIN  uimmaster ON  uimmaster.sno=productmaster.uim WHERE (outwarddetails.status='P') and (outwarddetails.inwarddate BETWEEn @d1 AND @d2) AND (productmoniter.branchid=@branchid)  ORDER BY outwarddetails.inwarddate");
            cmd.Parameters.Add("@d1", GetLowDate(ServerDateCurrentdate).AddDays(-10));
            cmd.Parameters.Add("@d2", GetHighDate(ServerDateCurrentdate));
            cmd.Parameters.Add("@branchid", branchid);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(routes);
            DataTable dtoutward = view.ToTable(true, "sno", "modeofoutward", "section_id", "name", "inwarddate", "indentno", "issueno", "remarks");
            DataTable dtsuboutward = view.ToTable(true, "moniterqty", "productid", "Expr1", "productcode", "quantity", "uim", "perunit", "totalcost", "in_refno", "productname");
            List<getOutwardData> getOutwarddetails = new List<getOutwardData>();
            List<OutwardDetails> outwardlist = new List<OutwardDetails>();
            List<SubOutward> suboutwardlist = new List<SubOutward>();
            foreach (DataRow dr in dtoutward.Rows)
            {
                OutwardDetails getoutward = new OutwardDetails();
                getoutward.modeofoutward = dr["modeofoutward"].ToString();
                getoutward.inwarddate = ((DateTime)dr["inwarddate"]).ToString("dd-MM-yyyy");//dr["inwarddate"].ToString();//((DateTime)dr["inwarddate"]).ToString("yyyy-MM-dd");
                getoutward.indentno = dr["indentno"].ToString();
                getoutward.issueno = dr["issueno"].ToString();
                getoutward.remarks = dr["remarks"].ToString();
                getoutward.sno = dr["sno"].ToString();
                getoutward.name = dr["name"].ToString();
                getoutward.hiddenid = dr["section_id"].ToString();
                outwardlist.Add(getoutward);
            }
            foreach (DataRow dr in dtsuboutward.Rows)
            {
                SubOutward getsuboutward = new SubOutward();
                getsuboutward.productname = dr["productname"].ToString();
                getsuboutward.productcode = dr["productcode"].ToString();
                getsuboutward.hdnproductsno = dr["productid"].ToString();
                getsuboutward.quantity = dr["quantity"].ToString();
                getsuboutward.PerUnitRs = dr["perunit"].ToString();
                getsuboutward.totalcost = dr["totalcost"].ToString();
                double moniterqty = Convert.ToDouble(dr["moniterqty"].ToString());
                moniterqty = Math.Round(moniterqty, 2);
                getsuboutward.moniterqty = moniterqty.ToString();
                getsuboutward.uim = dr["uim"].ToString();
                getsuboutward.sisno = dr["Expr1"].ToString();
                getsuboutward.inword_refno = dr["in_refno"].ToString();
                suboutwardlist.Add(getsuboutward);
            }
            getOutwardData getoutwadDatas = new getOutwardData();
            getoutwadDatas.OutwardDetails = outwardlist;
            getoutwadDatas.SubOutward = suboutwardlist;
            getOutwarddetails.Add(getoutwadDatas);
            string response = GetJson(getOutwarddetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    private void get_Pending_outward_Data(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT outwarddetails.issueno,outwarddetails.sno,outwarddetails.modeofoutward,outwarddetails.indentno, outwarddetails.inwarddate,uimmaster.uim, productmaster.productname, productmaster.productcode, outwarddetails.branch_id, outwarddetails.section_id, outwarddetails.remarks, suboutwarddetails.sno AS Expr1, suboutwarddetails.productid, suboutwarddetails.quantity, suboutwarddetails.perunit, suboutwarddetails.totalcost, suboutwarddetails.in_refno,  sectionmaster.name  FROM outwarddetails INNER JOIN suboutwarddetails ON outwarddetails.sno = suboutwarddetails.in_refno INNER JOIN productmaster ON suboutwarddetails.productid = productmaster.productid LEFT OUTER JOIN sectionmaster ON outwarddetails.section_id = sectionmaster.sectionid LEFT OUTER JOIN  uimmaster ON  uimmaster.sno=productmaster.uim WHERE outwarddetails.status='P' AND outwarddetails.branchid=@branchid AND outwarddetails.inwarddate BETWEEN @d1 and @d2 ORDER BY outwarddetails.inwarddate ");
            cmd.Parameters.Add("@branchid", branchid);
            if (branchid == "35")
            {
                cmd.Parameters.Add("@d1", GetLowDate(ServerDateCurrentdate).AddDays(-30));
            }
            else
            {
                cmd.Parameters.Add("@d1", GetLowDate(ServerDateCurrentdate).AddDays(-30));
            }
            cmd.Parameters.Add("@d2", GetHighDate(ServerDateCurrentdate));
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(routes);
            DataTable dtoutward = view.ToTable(true, "sno", "issueno", "modeofoutward", "section_id", "name", "inwarddate", "indentno", "remarks");
            DataTable dtsuboutward = view.ToTable(true, "productid", "Expr1", "productcode", "quantity", "uim", "perunit", "totalcost", "in_refno", "productname");
            List<getOutwardData> getOutwarddetails = new List<getOutwardData>();
            List<OutwardDetails> outwardlist = new List<OutwardDetails>();
            List<SubOutward> suboutwardlist = new List<SubOutward>();
            foreach (DataRow dr in dtoutward.Rows)
            {
                OutwardDetails getoutward = new OutwardDetails();
                getoutward.modeofoutward = dr["modeofoutward"].ToString();
                getoutward.inwarddate = ((DateTime)dr["inwarddate"]).ToString("dd-MM-yyyy");//dr["inwarddate"].ToString();//((DateTime)dr["inwarddate"]).ToString("yyyy-MM-dd");
                getoutward.indentno = dr["indentno"].ToString();
                getoutward.remarks = dr["remarks"].ToString();
                getoutward.sno = dr["sno"].ToString();
                getoutward.name = dr["name"].ToString();
                getoutward.hiddenid = dr["section_id"].ToString();
                getoutward.issueno = dr["issueno"].ToString();
                outwardlist.Add(getoutward);
            }
            foreach (DataRow dr in dtsuboutward.Rows)
            {
                SubOutward getsuboutward = new SubOutward();
                getsuboutward.productname = dr["productname"].ToString();
                getsuboutward.productcode = dr["productcode"].ToString();
                getsuboutward.hdnproductsno = dr["productid"].ToString();
                getsuboutward.quantity = dr["quantity"].ToString();
                getsuboutward.PerUnitRs = dr["perunit"].ToString();
                getsuboutward.totalcost = dr["totalcost"].ToString();
                getsuboutward.uim = dr["uim"].ToString();
                getsuboutward.sisno = dr["Expr1"].ToString();
                getsuboutward.inword_refno = dr["in_refno"].ToString();
                suboutwardlist.Add(getsuboutward);
            }
            getOutwardData getoutwadDatas = new getOutwardData();
            getoutwadDatas.OutwardDetails = outwardlist;
            getoutwadDatas.SubOutward = suboutwardlist;
            getOutwarddetails.Add(getoutwadDatas);
            string response = GetJson(getOutwarddetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }



    public int productid { get; set; }
    public SqlDbType uim { get; set; }

    private void get_outward_details_click(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string frmdate = context.Request["fromdate"];
            DateTime fromdate = Convert.ToDateTime(frmdate);
            string tdate = context.Request["todate"];
            DateTime todate = Convert.ToDateTime(tdate);
            string branchid = context.Session["Po_BranchID"].ToString();
            string type1 = context.Request["type"];
            if (type1 == "p")
            {
                cmd = new SqlCommand("SELECT sno,inwarddate, status, remarks,pono,section_id  FROM outwarddetails WHERE inwarddate BETWEEN @d1 AND @d2 AND status=@type AND branchid=@branchid order by inwarddate");
                cmd.Parameters.Add("@d1", GetLowDate(fromdate));
                cmd.Parameters.Add("@d2", GetHighDate(todate));
                cmd.Parameters.Add("@type", type1);
                cmd.Parameters.Add("@branchid", branchid);
            }
            if (type1 == "A")
            {
                cmd = new SqlCommand("SELECT sno,inwarddate, status, remarks,pono,section_id  FROM outwarddetails WHERE  inwarddate BETWEEN @d1 AND @d2 AND status=@type AND branchid=@branchid  order by inwarddate");
                cmd.Parameters.Add("@d1", GetLowDate(fromdate));
                cmd.Parameters.Add("@d2", GetHighDate(todate));
                cmd.Parameters.Add("@type", type1);
                cmd.Parameters.Add("@branchid", branchid);
            }
            DataTable dtpo = vdm.SelectQuery(cmd).Tables[0];
            List<OutwardDetails> outward = new List<OutwardDetails>();
            foreach (DataRow dr in dtpo.Rows)
            {
                OutwardDetails geoutward = new OutwardDetails();
                geoutward.sno = dr["sno"].ToString();
                geoutward.inwarddate = ((DateTime)dr["inwarddate"]).ToString("dd-MM-yyyy"); //dr["inwarddate"].ToString();
                geoutward.remarks = dr["remarks"].ToString();
                geoutward.pono = dr["pono"].ToString();
                geoutward.status = dr["status"].ToString();
                outward.Add(geoutward);
            }
            string response = GetJson(outward);
            context.Response.Write(response);
        }
        catch
        {
        }
    }

    private void get_inward_details_click(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string frmdate = context.Request["fromdate"];
            DateTime fromdate = Convert.ToDateTime(frmdate);
            string tdate = context.Request["todate"];
            DateTime todate = Convert.ToDateTime(tdate);
            string type = context.Request["type"];
            string branchid = context.Session["Po_BranchID"].ToString();
            if (type == "p")
            {

                cmd = new SqlCommand("SELECT sno,inwarddate,mrnno, invoiceno, dcno,status,lrno,remarks,pono,invoicedate,podate FROM inwarddetails WHERE (inwarddate BETWEEN @d1 AND @d2) AND (status=@type) AND (branchid=@branchid)  order by inwarddate");
                cmd.Parameters.Add("@d1", GetLowDate(fromdate));
                cmd.Parameters.Add("@d2", GetHighDate(todate));
                cmd.Parameters.Add("@type", type);
                cmd.Parameters.Add("@branchid", branchid);
            }
            if (type == "A")
            {

                cmd = new SqlCommand("SELECT sno,inwarddate,mrnno, invoiceno, dcno,status,lrno,remarks,pono,invoicedate,podate FROM inwarddetails WHERE (inwarddate BETWEEN @d1 AND @d2) AND (status=@type) AND (branchid=@branchid)  order by inwarddate");
                cmd.Parameters.Add("@d1", GetLowDate(fromdate));
                cmd.Parameters.Add("@d2", GetHighDate(todate));
                cmd.Parameters.Add("@type", type);
                cmd.Parameters.Add("@branchid", branchid);

            }
            DataTable dtpo = vdm.SelectQuery(cmd).Tables[0];
            List<InwardDetails> inward = new List<InwardDetails>();
            foreach (DataRow dr in dtpo.Rows)
            {
                InwardDetails geinward = new InwardDetails();
                geinward.sno = dr["sno"].ToString();
                geinward.inwarddate = ((DateTime)dr["inwarddate"]).ToString("dd-MM-yyyy"); //dr["inwarddate"].ToString();
                geinward.invoiceno = dr["invoiceno"].ToString();
                geinward.dcno = dr["dcno"].ToString();
                geinward.lrno = dr["lrno"].ToString();
                geinward.remarks = dr["remarks"].ToString();
                geinward.pono = dr["pono"].ToString();
                geinward.mrnno = dr["mrnno"].ToString();
                geinward.status = dr["status"].ToString();
                geinward.invoicedate = dr["invoicedate"].ToString();
                geinward.podate = dr["podate"].ToString();
                inward.Add(geinward);
            }
            string response = GetJson(inward);
            context.Response.Write(response);
        }
        catch
        {
        }
    }

    private void get_inward_Sub_details_click(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string PoRefNo = context.Request["refdcno"];
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            cmd = new SqlCommand("SELECT inwarddetails.sno, inwarddetails.inwarddate, inwarddetails.invoiceno, inwarddetails.invoicedate, inwarddetails.dcno, inwarddetails.lrno, inwarddetails.supplierid, inwarddetails.podate, inwarddetails.indentno, inwarddetails.remarks, inwarddetails.pono, subinwarddetails.sno AS Expr1, subinwarddetails.productid,  subinwarddetails.quantity, subinwarddetails.perunit, subinwarddetails.totalcost, suppliersdetails.name, suppliersdetails.supplierid, productmaster.productname, productmaster.productcode FROM inwarddetails INNER JOIN subinwarddetails ON inwarddetails.sno = subinwarddetails.in_refno INNER JOIN suppliersdetails ON inwarddetails.supplierid = suppliersdetails.supplierid INNER JOIN productmaster ON subinwarddetails.productid = productmaster.productid WHERE (inwarddetails.sno = @PoRefNo) ");
            cmd.Parameters.Add("@PoRefNo", PoRefNo);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(routes);
            DataTable dtinward = view.ToTable(true, "sno", "name", "inwarddate", "invoiceno", "invoicedate", "dcno", "lrno", "supplierid", "podate", "indentno", "remarks", "pono");
            DataTable dtsubinward = view.ToTable(true, "sno", "productid", "productcode", "Expr1", "productname", "quantity", "perunit", "totalcost");
            List<getInwardData> getInwarddetails = new List<getInwardData>();
            List<InwardDetails> inwardlist = new List<InwardDetails>();
            List<SubInward> subinwardlist = new List<SubInward>();
            foreach (DataRow dr in dtinward.Rows)
            {
                InwardDetails getInward = new InwardDetails();
                getInward.inwarddate = ((DateTime)dr["inwarddate"]).ToString("yyyy-MM-dd");//dr["inwarddate"].ToString();
                getInward.invoiceno = dr["invoiceno"].ToString();
                getInward.invoicedate = ((DateTime)dr["invoicedate"]).ToString("yyyy-MM-dd");//dr["invoicedate"].ToString();
                getInward.dcno = dr["dcno"].ToString();
                getInward.lrno = dr["lrno"].ToString();
                getInward.hiddensupplyid = dr["supplierid"].ToString();
                getInward.name = dr["name"].ToString();
                getInward.podate = ((DateTime)dr["podate"]).ToString("yyyy-MM-dd"); //dr["podate"].ToString();//((DateTime)dr["podate"]).ToString("yyyy-MM-dd"); 
                getInward.indentno = dr["indentno"].ToString();
                getInward.remarks = dr["remarks"].ToString();
                getInward.pono = dr["pono"].ToString();
                getInward.sno = dr["sno"].ToString();
                inwardlist.Add(getInward);
            }
            foreach (DataRow dr in dtsubinward.Rows)
            {
                SubInward getsubinward = new SubInward();
                getsubinward.hdnproductsno = dr["productid"].ToString();
                getsubinward.productname = dr["productname"].ToString();
                getsubinward.productcode = dr["productcode"].ToString();
                getsubinward.quantity = dr["quantity"].ToString();
                getsubinward.PerUnitRs = dr["perunit"].ToString();
                getsubinward.totalcost = dr["totalcost"].ToString();
                getsubinward.sisno = dr["Expr1"].ToString();
                getsubinward.inword_refno = dr["sno"].ToString();
                subinwardlist.Add(getsubinward);
            }
            getInwardData getInwadDatas = new getInwardData();
            getInwadDatas.InwardDetails = inwardlist;
            getInwadDatas.SubInward = subinwardlist;
            getInwarddetails.Add(getInwadDatas);
            string response = GetJson(getInwarddetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);

        }
    }

    private void get_Outward_Sub_details_click(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string sno = context.Request["refdcno"].ToString();
            string sno1 = context.Request["refdcno1"].ToString();
            string branchid = context.Session["Po_BranchID"].ToString();
            if (sno != "")
            {
                cmd = new SqlCommand("SELECT outwarddetails.sno,productmaster.sku, outwarddetails.inwarddate, outwarddetails.issueno, outwarddetails.status, productmaster.productname, outwarddetails.section_id,  outwarddetails.remarks, outwarddetails.pono, suboutwarddetails.sno AS Expr1, suboutwarddetails.productid, suboutwarddetails.quantity, suboutwarddetails.perunit, suboutwarddetails.totalcost, suboutwarddetails.in_refno,uimmaster.uim,  sectionmaster.name FROM outwarddetails INNER JOIN suboutwarddetails ON outwarddetails.sno = suboutwarddetails.in_refno INNER JOIN productmaster ON suboutwarddetails.productid = productmaster.productid LEFT OUTER JOIN sectionmaster ON outwarddetails.section_id = sectionmaster.sectionid LEFT OUTER JOIN  uimmaster ON  uimmaster.sno=productmaster.uim WHERE (outwarddetails.sno = @outRefNo) AND (outwarddetails.branchid=@branchid)");
                cmd.Parameters.Add("@outRefNo", sno);
                cmd.Parameters.Add("@branchid", branchid);
            }
            else
            {
                cmd = new SqlCommand("SELECT outwarddetails.sno,productmaster.sku, outwarddetails.inwarddate, outwarddetails.issueno, outwarddetails.status, productmaster.productname, outwarddetails.section_id, outwarddetails.remarks, outwarddetails.pono, suboutwarddetails.sno AS Expr1, suboutwarddetails.productid, suboutwarddetails.quantity, suboutwarddetails.perunit, suboutwarddetails.totalcost, suboutwarddetails.in_refno,uimmaster.uim,  sectionmaster.name FROM outwarddetails INNER JOIN suboutwarddetails ON outwarddetails.sno = suboutwarddetails.in_refno INNER JOIN productmaster ON suboutwarddetails.productid = productmaster.productid LEFT OUTER JOIN sectionmaster ON outwarddetails.section_id = sectionmaster.sectionid LEFT OUTER JOIN  uimmaster ON  uimmaster.sno=productmaster.uim WHERE (outwarddetails.sno = @outRefNo) AND (outwarddetails.branchid=@branchid)");
                cmd.Parameters.Add("@outRefNo", sno1);
                cmd.Parameters.Add("@branchid", branchid);
            }
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(routes);
            DataTable dtoutward = view.ToTable(true, "sno", "issueno", "section_id", "name", "inwarddate", "remarks", "pono");
            DataTable dtsuboutward = view.ToTable(true, "uim", "productid", "sku", "Expr1", "status", "quantity", "perunit", "totalcost", "in_refno", "productname");
            List<getOutwardData> getOutwarddetails = new List<getOutwardData>();
            List<OutwardDetails> outwardlist = new List<OutwardDetails>();
            List<SubOutward> suboutwardlist = new List<SubOutward>();
            DateTime dtapril = new DateTime();
            DateTime dtmarch = new DateTime();
            foreach (DataRow dr in dtoutward.Rows)
            {
                OutwardDetails getoutward = new OutwardDetails();
                getoutward.inwarddate = ((DateTime)dr["inwarddate"]).ToString("dd-MM-yyyy");//dr["inwarddate"].ToString();//((DateTime)dr["inwarddate"]).ToString("yyyy-MM-dd");
                DateTime dt_iss = Convert.ToDateTime(dr["inwarddate"].ToString());
                int currentyear = dt_iss.Year;
                int nextyear = dt_iss.Year + 1;
                int currntyearnum = 0;
                int nextyearnum = 0;
                if (dt_iss.Month > 3)
                {
                    string apr = "4/1/" + currentyear;
                    dtapril = DateTime.Parse(apr);
                    string march = "3/31/" + nextyear;
                    dtmarch = DateTime.Parse(march);
                    currntyearnum = currentyear;
                    nextyearnum = nextyear;
                }
                if (dt_iss.Month <= 3)
                {
                    string apr = "4/1/" + (currentyear - 1);
                    dtapril = DateTime.Parse(apr);
                    string march = "3/31/" + (nextyear - 1);
                    dtmarch = DateTime.Parse(march);
                    currntyearnum = currentyear - 1;
                    nextyearnum = nextyear - 1;
                }
                getoutward.remarks = dr["remarks"].ToString();
                getoutward.pono = dr["pono"].ToString();
                getoutward.sno = dr["sno"].ToString();
                string issuenumber = "";
                if (branchid == "2")
                {
                    issuenumber = "PBK/O" + dtapril.ToString("yy") + "-" + dtmarch.ToString("yy") + "/" + dr["issueno"].ToString();
                }
                else if (branchid == "4")
                {
                    issuenumber = "CHN/O" + dtapril.ToString("yy") + "-" + dtmarch.ToString("yy") + "/" + dr["issueno"].ToString();
                }
                else if (branchid == "35")
                {
                    issuenumber = "MNPK/O" + dtapril.ToString("yy") + "-" + dtmarch.ToString("yy") + "/" + dr["issueno"].ToString();
                }
                else if (branchid == "1040")
                {
                    issuenumber = "KPM/O" + dtapril.ToString("yy") + "-" + dtmarch.ToString("yy") + "/" + dr["issueno"].ToString();
                }
                else
                {
                    issuenumber = "OUT/" + dtapril.ToString("yy") + "-" + dtmarch.ToString("yy") + "/" + dr["issueno"].ToString();
                }
                getoutward.issueno = issuenumber.ToString(); //dr["issueno"].ToString();
                getoutward.name = dr["name"].ToString();
                getoutward.hiddenid = dr["section_id"].ToString();
                outwardlist.Add(getoutward);
            }
            foreach (DataRow dr in dtsuboutward.Rows)
            {
                SubOutward getsuboutward = new SubOutward();
                getsuboutward.productname = dr["productname"].ToString();
                getsuboutward.productcode = dr["sku"].ToString();
                getsuboutward.hdnproductsno = dr["productid"].ToString();
                getsuboutward.quantity = dr["quantity"].ToString();
                getsuboutward.PerUnitRs = dr["perunit"].ToString();
                getsuboutward.uim = dr["uim"].ToString();
                getsuboutward.status = dr["status"].ToString();
                getsuboutward.totalcost = dr["totalcost"].ToString();
                getsuboutward.sisno = dr["Expr1"].ToString();
                getsuboutward.inword_refno = dr["in_refno"].ToString();
                suboutwardlist.Add(getsuboutward);
            }
            getOutwardData getoutwadDatas = new getOutwardData();
            getoutwadDatas.OutwardDetails = outwardlist;
            getoutwadDatas.SubOutward = suboutwardlist;
            getOutwarddetails.Add(getoutwadDatas);
            string response = GetJson(getOutwarddetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);

        }
    }

    private void get_Stock_Opening_Details(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string branchid = context.Session["Po_BranchID"].ToString();
            string category = context.Request["category"].ToString();
            cmd = new SqlCommand("SELECT productmaster.productid, productmaster.productname, productmoniter.price, productmoniter.qty FROM productmaster INNER JOIN  productmoniter ON productmaster.productid =productmoniter.productid WHERE productmoniter.branchid =@branchid and productmaster.productcode=@categoryid ORDER BY productmaster.productid");
            cmd.Parameters.Add("@branchid", branchid);
            cmd.Parameters.Add("@categoryid", category);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<productmoniter> productmoniterlist = new List<productmoniter>();
            foreach (DataRow dr in routes.Rows)
            {
                productmoniter getstockdetailes = new productmoniter();
                getstockdetailes.productname = dr["productname"].ToString();
                if (dr["productid"].ToString() == "5290")
                {
                    getstockdetailes.price = dr["productname"].ToString();
                }
                getstockdetailes.price = dr["price"].ToString();
                string itemprice = dr["price"].ToString();
                string CPRICE = "0";
                if (itemprice == "" || itemprice == null)
                {
                    CPRICE = "0";
                }
                else
                {
                    CPRICE = dr["price"].ToString();
                }
                double price = Convert.ToDouble(CPRICE);
                double quantity = Convert.ToDouble(dr["qty"].ToString());
                quantity = Math.Round(quantity, 2);
                getstockdetailes.qty = quantity.ToString();
                getstockdetailes.productid = dr["productid"].ToString();
                double value = quantity * price;
                getstockdetailes.value = value.ToString();
                productmoniterlist.Add(getstockdetailes);
            }
            string response = GetJson(productmoniterlist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class stockclosing
    {
        public string sno { get; set; }
        public string productname { get; set; }
        public string price { get; set; }
        public string oppbal { get; set; }
        public string inward { get; set; }
        public string outward { get; set; }
        public string qty { get; set; }
        public string clobal { get; set; }
        public string totalcost { get; set; }
        public string doe { get; set; }
        public string productid { get; set; }
        public string transfer { get; set; }
        public string hdnproductsno { get; set; }

    }
    public class stockclosingdetails
    {
        public string btnval { get; set; }
        public string doe { get; set; }
        public List<stockclosing> fillstockclosing { get; set; }
    }
    private void Save_Stock_Closing_Details(string jsonString, HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            var js = new JavaScriptSerializer();
            stockclosingdetails obj = js.Deserialize<stockclosingdetails>(jsonString);
            string entryby = context.Session["Employ_Sno"].ToString();
            string branchid = context.Session["Po_BranchID"].ToString();
            string doe = obj.doe;
            string btnval = obj.btnval;
            if (btnval == "Save")
            {
                foreach (stockclosing si in obj.fillstockclosing)
                {
                    cmd = new SqlCommand("insert into stockclosingdetails(productid,qty,price,entryby,doe,branchid) values(@productid,@qty,@price,@entryby,@doe,@branchid)");
                    cmd.Parameters.Add("@productid", si.productid);
                    cmd.Parameters.Add("@qty", si.qty);
                    cmd.Parameters.Add("@doe", doe);
                    cmd.Parameters.Add("@price", si.price);
                    cmd.Parameters.Add("@entryby", entryby);
                    cmd.Parameters.Add("@branchid", branchid);
                    vdm.insert(cmd);
                    cmd = new SqlCommand("UPDATE productmoniter SET qty=@pqty, price=@tprice where branchid=@bid AND productid=@pid");
                    cmd.Parameters.Add("@pid", si.productid);
                    cmd.Parameters.Add("@pqty", si.qty);
                    cmd.Parameters.Add("@tprice", si.price);
                    cmd.Parameters.Add("@bid", branchid);
                    if (vdm.Update(cmd) == 0)
                    {
                        cmd = new SqlCommand("insert into productmoniter (productid, qty, price, branchid) values(@ipid,@iqty,@iprice,@ibid)");
                        cmd.Parameters.Add("@ipid", si.productid);
                        cmd.Parameters.Add("@iqty", si.qty);
                        cmd.Parameters.Add("@iprice", si.price);
                        cmd.Parameters.Add("@ibid", branchid);
                        vdm.insert(cmd);
                    }
                }
                string msg = "Stock Closed successfully";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }

        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);

        }
    }

    private void get_Stock_Closing_Details(HttpContext context)
    {
        try
        {
            string doe = context.Request["refdcno"];
            vdm = new SalesDBManager();
            cmd = new SqlCommand("SELECT  productid,doe,qty,price,sno,productname FROM producttransactions where doe=@doe");
            cmd.Parameters.Add("@doe", doe);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<stockclosing> stockclosinglst = new List<stockclosing>();
            foreach (DataRow dr in routes.Rows)
            {
                stockclosing getstockclosing = new stockclosing();
                getstockclosing.sno = dr["sno"].ToString();
                getstockclosing.doe = dr["doe"].ToString();
                double quantity = Convert.ToDouble(dr["qty"].ToString());
                quantity = Math.Round(quantity, 2);
                getstockclosing.qty = quantity.ToString();
                getstockclosing.price = dr["price"].ToString();
                getstockclosing.productname = dr["productname"].ToString();
                getstockclosing.hdnproductsno = dr["productid"].ToString();
                stockclosinglst.Add(getstockclosing);
            }
            string response = GetJson(stockclosinglst);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);

        }
    }
    public class Storeslist
    {
        public string qty { get; set; }
        public string name { get; set; }
        public string price { get; set; }
        public string Value { get; set; }
        public string sno { get; set; }
        public string productname { get; set; }
    }
    private void get_StoresItems_details_click(HttpContext context)
    {
        try
        {
            string stores = context.Request["stores"];
            string branchid = context.Session["Po_BranchID"].ToString();
            vdm = new SalesDBManager();
            if (stores == "Category")
            {

                cmd = new SqlCommand("SELECT SUM(productmaster.price*productmoniter.qty) AS Value, productmaster.price,productmoniter.qty,categorymaster.category AS Type,productmaster.productname FROM productmaster INNER JOIN subcategorymaster ON  productmaster.subcategoryid=subcategorymaster.subcategoryid INNER JOIN productmoniter ON productmoniter.productid=productmaster.productid LEFT OUTER JOIN categorymaster ON categorymaster.categoryid=subcategorymaster.subcategoryid WHERE productmaster.branchid=@branchid  GROUP BY productmaster.price,productmoniter.qty,categorymaster.category,productmaster.productname ");
                cmd.Parameters.Add("@branchid", branchid);
            }
            if (stores == "SubCategory")
            {
                cmd = new SqlCommand("SELECT SUM(productmaster.price*productmoniter.qty) AS Value, productmaster.price,productmoniter.qty,subcategorymaster.subcategoryname AS Type,productmaster.productname FROM productmaster INNER JOIN subcategorymaster ON  productmaster.subcategoryid=subcategorymaster.subcategoryid  INNER JOIN productmoniter ON productmoniter.productid=productmaster.productid WHERE productmaster.branchid=@branchid GROUP BY productmaster.price,productmoniter.qty,subcategorymaster.subcategoryname,productmaster.productname ");
                cmd.Parameters.Add("@branchid", branchid);
            }
            if (stores == "Item")
            {
                cmd = new SqlCommand("SELECT SUM(productmaster.price*productmoniter.qty) AS Value, productmaster.price,productmoniter.qty,productmaster.productname AS Type,productmaster.productname FROM productmaster INNER JOIN  productmoniter ON productmoniter.productid=productmaster.productid WHERE productmaster.branchid=@branchid GROUP BY productmaster.price,productmoniter.qty,productmaster.productname ");
                cmd.Parameters.Add("@branchid", branchid);
            }
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<Storeslist> Storeslist = new List<Storeslist>();
            foreach (DataRow dr in routes.Rows)
            {
                Storeslist getstoresitems = new Storeslist();
                string Name = dr["Type"].ToString();
                getstoresitems.name = dr["Type"].ToString();
                getstoresitems.price = dr["price"].ToString();
                getstoresitems.qty = dr["qty"].ToString();
                getstoresitems.Value = dr["Value"].ToString();
                getstoresitems.productname = dr["productname"].ToString();
                Storeslist.Add(getstoresitems);
            }
            string response = GetJson(Storeslist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);

        }
    }


    public class dailyinwardlistclass
    {
        public string inwardno { get; set; }
        public string InValue { get; set; }
        public string OutValue { get; set; }
        public string StoresValue { get; set; }
        public string category { get; set; }
        public string cat_code { get; set; }
        public string productname { get; set; }
        public string price { get; set; }
        public string qty { get; set; }
        public string aprovecount { get; set; }
        public string pendcount { get; set; }
        public string totalcount { get; set; }
        public string category1 { get; set; }
        public string Approvepos { get; set; }
        public string pendingpos { get; set; }
        public string TotalPos { get; set; }
        public string productid { get; set; }
        public string minstock { get; set; }
        public string maxstock { get; set; }
    }
    private void GetDailyInwardValue(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            DataTable Report = new DataTable();
            DateTime serverdate = SalesDBManager.GetTime(vdm.conn);
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT SUM(subinwarddetails.quantity*subinwarddetails.perunit) AS VALUE FROM inwarddetails INNER JOIN subinwarddetails ON inwarddetails.sno = subinwarddetails.in_refno WHERE  (inwarddetails.branchid=@branchid) AND (inwarddetails.inwarddate BETWEEN @d1 and @d2)");
            cmd.Parameters.Add("@branchid", branchid);
            cmd.Parameters.Add("@d1", GetLowDate(serverdate).AddDays(-1));
            cmd.Parameters.Add("@d2", GetHighDate(serverdate));
            DataTable dttotalinward = vdm.SelectQuery(cmd).Tables[0];
            List<dailyinwardlistclass> daily_inward_list = new List<dailyinwardlistclass>();
            foreach (DataRow dr in dttotalinward.Rows)
            {
                dailyinwardlistclass getinwardtotal = new dailyinwardlistclass();
                string sumval = dr["VALUE"].ToString();
                getinwardtotal.InValue = sumval;
                daily_inward_list.Add(getinwardtotal);
            }
            string response = GetJson(daily_inward_list);
            context.Response.Write(response);

        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);

        }

    }

    private void GetDailyOutwardValue(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            DataTable Report = new DataTable();
            DateTime doe = SalesDBManager.GetTime(vdm.conn);
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT SUM(suboutwarddetails.quantity*suboutwarddetails.perunit) AS VALUE FROM outwarddetails INNER JOIN suboutwarddetails ON outwarddetails.sno = suboutwarddetails.in_refno WHERE (outwarddetails.inwarddate BETWEEN @d1 AND @d2) AND (outwarddetails.branchid=@branchid)");
            cmd.Parameters.Add("@branchid", branchid);
            cmd.Parameters.Add("@d1", GetLowDate(doe).AddDays(-1));
            cmd.Parameters.Add("@d2", GetHighDate(doe));
            DataTable dttotalinward = vdm.SelectQuery(cmd).Tables[0];
            List<dailyinwardlistclass> daily_inward_list = new List<dailyinwardlistclass>();
            foreach (DataRow dr in dttotalinward.Rows)
            {
                dailyinwardlistclass getinwardtotal = new dailyinwardlistclass();
                getinwardtotal.OutValue = dr["VALUE"].ToString();
                daily_inward_list.Add(getinwardtotal);
            }
            string response = GetJson(daily_inward_list);
            context.Response.Write(response);

        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void Get_DailyStoresValue(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            DataTable Report = new DataTable();
            DateTime doe = SalesDBManager.GetTime(vdm.conn);
            DateTime dtFromdate = Convert.ToDateTime(doe);
            DateTime dtTodate = Convert.ToDateTime(doe);
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT   products.VALUE, products.productcode, categorymaster.category, categorymaster.cat_code FROM (SELECT productmaster.productcode, SUM(productmoniter.qty * productmoniter.price) AS VALUE FROM   productmaster INNER JOIN productmoniter ON productmaster.productid = productmoniter.productid  WHERE        (productmoniter.branchid = @branchid)  GROUP BY productmaster.productcode) AS products INNER JOIN categorymaster ON categorymaster.cat_code = products.productcode");
            cmd.Parameters.Add("@branchid", branchid);
            cmd.Parameters.Add("@d1", GetLowDate(dtFromdate));
            cmd.Parameters.Add("@d2", GetHighDate(dtTodate));
            DataTable dttotalinward = vdm.SelectQuery(cmd).Tables[0];
            List<dailyinwardlistclass> daily_inward_list = new List<dailyinwardlistclass>();
            foreach (DataRow dr in dttotalinward.Rows)
            {
                dailyinwardlistclass getinwardtotal = new dailyinwardlistclass();
                getinwardtotal.cat_code = dr["cat_code"].ToString();
                double value = Convert.ToDouble(dr["VALUE"].ToString());
                value = Math.Round(value, 2);
                getinwardtotal.StoresValue = value.ToString();
                getinwardtotal.category = dr["category"].ToString();
                daily_inward_list.Add(getinwardtotal);
            }
            string response = GetJson(daily_inward_list);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class PieValues
    {
        public List<string> RouteName { get; set; }
        public List<string> Amount { get; set; }
        public List<string> DeliveryQty { get; set; }
        public List<string> AverageyQty { get; set; }
        public List<string> catcode { get; set; }
        public string totalqty { get; set; }
        public string branchid { get; set; }
    }

    public class lineValues
    {
        public List<string> RouteName { get; set; }
        public List<string> Amount { get; set; }
        public List<string> DeliveryQty { get; set; }
        public List<string> AverageyQty { get; set; }
        public List<string> wastage { get; set; }
        public string totalqty { get; set; }
    }
    public class outValues
    {
        public List<string> RouteName { get; set; }
        public List<string> Amount { get; set; }
        public List<string> DeliveryQty { get; set; }
        public List<string> AverageyQty { get; set; }
        public List<string> wastage { get; set; }
        public string totalqty { get; set; }
    }

    private void get_catagirywise_value(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            DataTable Report = new DataTable();
            DateTime doe = SalesDBManager.GetTime(vdm.conn);
            DateTime dtFromdate = Convert.ToDateTime(doe);
            DateTime dtTodate = Convert.ToDateTime(doe);

            //string branch_id = context.Session["Po_BranchID"].ToString();
            string branchid = context.Request["branch"];
            
            if (branchid == null || branchid == "")
            {
                branchid = context.Session["Po_BranchID"].ToString();
            }
            if (branchid == "All")
            {
                cmd = new SqlCommand("SELECT products.VALUE, products.productcode, categorymaster.category, categorymaster.cat_code FROM (SELECT productmaster.productcode, SUM(productmoniter.qty * productmoniter.price) AS VALUE FROM   productmaster INNER JOIN productmoniter ON productmaster.productid = productmoniter.productid  GROUP BY productmaster.productcode) AS products INNER JOIN categorymaster ON categorymaster.cat_code = products.productcode");
            }
            else
            {
                cmd = new SqlCommand("SELECT   products.VALUE, products.productcode, categorymaster.category, categorymaster.cat_code FROM (SELECT productmaster.productcode, SUM(productmoniter.qty * productmoniter.price) AS VALUE FROM   productmaster INNER JOIN productmoniter ON productmaster.productid = productmoniter.productid  WHERE        (productmoniter.branchid = @branchid)  GROUP BY productmaster.productcode) AS products INNER JOIN categorymaster ON categorymaster.cat_code = products.productcode");
                cmd.Parameters.Add("@branchid", branchid);
            }
            cmd.Parameters.Add("@d1", GetLowDate(dtFromdate));
            cmd.Parameters.Add("@d2", GetHighDate(dtTodate));
            DataTable dttotalinward = vdm.SelectQuery(cmd).Tables[0];
            List<PieValues> lPieValueslist = new List<PieValues>();
            List<string> catcodelist = new List<string>();
            List<string> categoryList = new List<string>();
            List<string> valueList = new List<string>();
            if (dttotalinward.Rows.Count > 0)
            {
                foreach (DataRow dr in dttotalinward.Rows)
                {
                    dailyinwardlistclass getinwardtotal = new dailyinwardlistclass();
                    string catcode = dr["cat_code"].ToString();
                    string value = dr["VALUE"].ToString();
                    double catvalue = Convert.ToDouble(value);
                    catvalue = Math.Round(catvalue, 2);
                    string catgvalue = catvalue.ToString();
                    string categoryname = dr["category"].ToString();

                    categoryList.Add(categoryname);
                    valueList.Add(catgvalue);
                    catcodelist.Add(catcode);
                }
            }
            PieValues GetPieValues = new PieValues();
            GetPieValues.RouteName = categoryList;
            GetPieValues.Amount = valueList;
            GetPieValues.catcode = catcodelist;
            GetPieValues.branchid = branchid;
            lPieValueslist.Add(GetPieValues);
            string response = GetJson(lPieValueslist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_catagirywise_value_branch(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            DataTable Report = new DataTable();
            DateTime doe = SalesDBManager.GetTime(vdm.conn);
            DateTime dtFromdate = Convert.ToDateTime(doe);
            DateTime dtTodate = Convert.ToDateTime(doe);
            string branch_id = context.Session["Po_BranchID"].ToString();
            string branchid = context.Request["branch"];
            if (branchid == null || branchid == "")
            {
                branchid = context.Session["Po_BranchID"].ToString();
            }
            if (branchid == "All")
            {
                cmd = new SqlCommand("SELECT   products.VALUE, products.productcode, categorymaster.category, categorymaster.cat_code FROM (SELECT productmaster.productcode, SUM(productmoniter.qty * productmoniter.price) AS VALUE FROM   productmaster INNER JOIN productmoniter ON productmaster.productid = productmoniter.productid  GROUP BY productmaster.productcode) AS products INNER JOIN categorymaster ON categorymaster.cat_code = products.productcode");
            }
            else
            {
                cmd = new SqlCommand("SELECT   products.VALUE, products.productcode, categorymaster.category, categorymaster.cat_code FROM (SELECT productmaster.productcode, SUM(productmoniter.qty * productmoniter.price) AS VALUE FROM   productmaster INNER JOIN productmoniter ON productmaster.productid = productmoniter.productid  WHERE        (productmoniter.branchid = @branchid)  GROUP BY productmaster.productcode) AS products INNER JOIN categorymaster ON categorymaster.cat_code = products.productcode");
                cmd.Parameters.Add("@branchid", branchid);
            }
           
           // cmd.Parameters.Add("@branchid", branchid);
            cmd.Parameters.Add("@d1", GetLowDate(dtFromdate));
            cmd.Parameters.Add("@d2", GetHighDate(dtTodate));
            DataTable dttotalinward = vdm.SelectQuery(cmd).Tables[0];
            List<PieValues> lPieValueslist = new List<PieValues>();
            List<string> catcodelist = new List<string>();
            List<string> categoryList = new List<string>();
            List<string> valueList = new List<string>();
            if (dttotalinward.Rows.Count > 0)
            {
                foreach (DataRow dr in dttotalinward.Rows)
                {
                    dailyinwardlistclass getinwardtotal = new dailyinwardlistclass();
                    string catcode = dr["cat_code"].ToString();
                    string catvalue = dr["VALUE"].ToString();
                    string categoryname = dr["category"].ToString();
                    categoryList.Add(categoryname);
                    valueList.Add(catvalue);
                    catcodelist.Add(catcode);
                }
            }
            PieValues GetPieValues = new PieValues();
            GetPieValues.RouteName = categoryList;
            GetPieValues.Amount = valueList;
            GetPieValues.catcode = catcodelist;
            GetPieValues.branchid = branch_id;
            lPieValueslist.Add(GetPieValues);
            string response = GetJson(lPieValueslist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_category_names(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            DataTable Report = new DataTable();
            DateTime doe = SalesDBManager.GetTime(vdm.conn);
            DateTime dtFromdate = Convert.ToDateTime(doe);
            DateTime dtTodate = Convert.ToDateTime(doe);
            //string branch_id = context.Session["Po_BranchID"].ToString();
            string branchid = context.Request["branch"];
            if (branchid == null || branchid == "")
            {
                branchid = context.Session["Po_BranchID"].ToString();
            }
            cmd = new SqlCommand("SELECT   products.VALUE, products.productcode, categorymaster.category, categorymaster.cat_code FROM (SELECT productmaster.productcode, SUM(productmoniter.qty * productmoniter.price) AS VALUE FROM   productmaster INNER JOIN productmoniter ON productmaster.productid = productmoniter.productid  WHERE        (productmoniter.branchid = @branchid)  GROUP BY productmaster.productcode) AS products INNER JOIN categorymaster ON categorymaster.cat_code = products.productcode");
            cmd.Parameters.Add("@branchid", branchid);
            cmd.Parameters.Add("@d1", GetLowDate(dtFromdate));
            cmd.Parameters.Add("@d2", GetHighDate(dtTodate));
            DataTable dttotalinward = vdm.SelectQuery(cmd).Tables[0];
            List<PieValues> lPieValueslist = new List<PieValues>();
            List<string> catcodelist = new List<string>();
            List<string> categoryList = new List<string>();
            List<string> valueList = new List<string>();
            if (dttotalinward.Rows.Count > 0)
            {
                foreach (DataRow dr in dttotalinward.Rows)
                {
                    dailyinwardlistclass getinwardtotal = new dailyinwardlistclass();
                    string catcode = dr["cat_code"].ToString();
                    string catvalue = dr["VALUE"].ToString();
                    string categoryname = dr["category"].ToString();

                    categoryList.Add(categoryname);
                    valueList.Add(catvalue);
                    catcodelist.Add(catcode);
                }
            }
            PieValues GetPieValues = new PieValues();
            GetPieValues.RouteName = categoryList;
            GetPieValues.Amount = valueList;
            GetPieValues.catcode = catcodelist;
            GetPieValues.branchid = branchid;
            lPieValueslist.Add(GetPieValues);
            string response = GetJson(lPieValueslist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class DailyStoresValuechart
    {
        public string Category { get; set; }
        public List<string> value { get; set; }
    }
    private void Get_DailyStoresValuechart(HttpContext context)
    {
        vdm = new SalesDBManager();
        List<DailyStoresValuechart> lPieValueslist = new List<DailyStoresValuechart>();
        DailyStoresValuechart GetPieValues = new DailyStoresValuechart();
        List<string> Categorylist = new List<string>();
        List<string> valuelist = new List<string>();
        vdm = new SalesDBManager();
        DataTable Report = new DataTable();
        DateTime doe = SalesDBManager.GetTime(vdm.conn);
        DateTime dtFromdate = Convert.ToDateTime(doe);
        DateTime dtTodate = Convert.ToDateTime(doe);
        string categoryname = "";
        string categoryvalue = "";
        string branchid = context.Session["Po_BranchID"].ToString();
        cmd = new SqlCommand(" SELECT  categorymaster.cat_code, SUM(productmoniter.qty * productmoniter.price) AS VALUE, categorymaster.category FROM  productmaster INNER JOIN categorymaster ON productmaster.productcode = categorymaster.cat_code INNER JOIN   productmoniter ON productmaster.productid = productmoniter.productid WHERE categorymaster.branchid=@branchid  GROUP BY categorymaster.cat_code, categorymaster.category");
        cmd.Parameters.Add("@branchid", branchid);
        cmd.Parameters.Add("@d1", GetLowDate(dtFromdate));
        cmd.Parameters.Add("@d2", GetHighDate(dtTodate));
        DataTable dttotalinward = vdm.SelectQuery(cmd).Tables[0];
        if (dttotalinward.Rows.Count > 0)
        {
            foreach (DataRow dr in dttotalinward.Rows)
            {
                string quntity = dr["VALUE"].ToString();
                if (quntity == "")
                {
                    quntity = "0";
                }
                string category = dr["category"].ToString();
                categoryvalue += quntity + ",";
                categoryname  += category + ",";
            }
            categoryvalue = categoryvalue.Substring(0, categoryvalue.Length - 1);
            categoryname = categoryname.Substring(0, categoryname.Length - 1);
            valuelist.Add(categoryvalue);
            GetPieValues.Category = categoryname;
            GetPieValues.value = valuelist;
            lPieValueslist.Add(GetPieValues);
        }
        string errresponse = GetJson(lPieValueslist);
        context.Response.Write(errresponse);
    }
   
    public class BranchlineChart
    {
        public string Month { get; set; }
        public string branchname { get; set; }
        public string StoresValue { get; set; }
        public string branchid { get; set; }
    }

    private void Get__LineChart(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            DataTable Report = new DataTable();
            DateTime doe = SalesDBManager.GetTime(vdm.conn);

            string id = context.Request["id"];
            string fromyear = context.Request["fromyear"];
            string toyear = context.Request["toyear"];
            string mymonth = context.Request["mymonth"];
            string tomonth = context.Request["tomonth"];

            int FromYear = 0;
            int.TryParse(fromyear, out FromYear);
            int ToYear = 0;
            int.TryParse(toyear, out ToYear);
            int Month = 0;
            int.TryParse(mymonth, out Month);
            int ToMonth = 0;
            int.TryParse(tomonth, out ToMonth);
            int fromdays = DateTime.DaysInMonth(FromYear, Month);
            int todays = DateTime.DaysInMonth(ToYear, ToMonth);
            string dtFromdate = mymonth + "/" + 1 + "/" + FromYear;
            string dtTodate = mymonth + "/" + fromdays + "/" + ToYear;
            string dtdate = tomonth + "/" + 1 + "/" + FromYear;
            string dttdate = tomonth + "/" + todays + "/" + ToYear;
            DateTime fromdate = Convert.ToDateTime(dtFromdate);
            DateTime todate = Convert.ToDateTime(dttdate);
            string branchid = context.Session["Po_BranchID"].ToString();
            string type = context.Request["type"];
            if (type == "Branch")
            {
                cmd = new SqlCommand("SELECT  UPPER(LEFT(DATENAME(MONTH, ff.invoicedate), 3)) AS Month, branchid.branchname AS name, SUM(ff.value) AS value FROM (SELECT invoicedate, tobranch, value FROM (SELECT stocktrans.invoicedate, stocktrans.tobranch, stocktrans.sno, stocktrans2.value, stocktrans2.stock_refno FROM (SELECT TOP (100) PERCENT invoicedate, tobranch, sno FROM  stocktransferdetails WHERE (invoicedate BETWEEN @d1 AND @d2) AND (tobranch = @tobranch) GROUP BY invoicedate, tobranch, sno ORDER BY invoicedate) AS stocktrans LEFT OUTER JOIN  (SELECT SUM(quantity * price) AS value, stock_refno FROM stocktransfersubdetails GROUP BY stock_refno) AS stocktrans2 ON stocktrans.sno = stocktrans2.stock_refno) AS dd GROUP BY invoicedate, tobranch, value) AS ff LEFT OUTER JOIN (SELECT  branchname, branchid FROM  branchmaster GROUP BY branchname, branchid) AS branchid ON ff.tobranch = branchid.branchid GROUP BY branchid.branchname, MONTH(ff.invoicedate), DATENAME(MONTH, ff.invoicedate)");
                cmd.Parameters.Add("@d1", GetLowDate(fromdate));
                cmd.Parameters.Add("@tobranch", id);
                cmd.Parameters.Add("@d2", GetHighDate(todate));
            }
            if (type == "Supplier")
            {
                cmd = new SqlCommand("SELECT UPPER(LEFT(DATENAME(MONTH, ff.inwarddate), 3)) AS Month, section.name, SUM(ff.value) AS value FROM (SELECT inwarddate, supplierid, value FROM (SELECT outward1.inwarddate, outward1.supplierid, outward1.sno, outward2.value, outward2.in_refno FROM (SELECT TOP (100) PERCENT inwarddate, supplierid, sno FROM inwarddetails WHERE  (inwarddate BETWEEN @d1 AND @d2) AND (supplierid = @supplierid) GROUP BY inwarddate, supplierid, sno ORDER BY inwarddate) AS outward1 LEFT OUTER JOIN (SELECT SUM(quantity * perunit) AS value, in_refno FROM suboutwarddetails GROUP BY in_refno) AS outward2 ON outward1.sno = outward2.in_refno) AS dd GROUP BY inwarddate, supplierid, value) AS ff LEFT OUTER JOIN (SELECT  name, supplierid FROM  suppliersdetails GROUP BY name, supplierid) AS section ON ff.supplierid = section.supplierid GROUP BY section.name, MONTH(ff.inwarddate), DATENAME(MONTH, ff.inwarddate)");
                cmd.Parameters.Add("@d1", GetLowDate(fromdate));
                cmd.Parameters.Add("@supplierid", id);
                cmd.Parameters.Add("@d2", GetHighDate(todate));
            }
            if (type == "Section")
            {
                cmd = new SqlCommand("SELECT   UPPER(LEFT(DATENAME(MONTH, ff.inwarddate), 3)) AS Month, section.name, SUM(ff.value) AS value FROM (SELECT inwarddate, section_id, value FROM (SELECT outward1.inwarddate, outward1.section_id, outward1.sno, outward2.value, outward2.in_refno FROM (SELECT TOP (100) PERCENT inwarddate, section_id, sno FROM outwarddetails WHERE (inwarddate BETWEEN @d1 AND @d2) AND (section_id = @section_id) GROUP BY inwarddate, section_id, sno ORDER BY inwarddate) AS outward1 LEFT OUTER JOIN (SELECT SUM(quantity * perunit) AS value, in_refno FROM suboutwarddetails GROUP BY in_refno) AS outward2 ON outward1.sno = outward2.in_refno) AS dd GROUP BY inwarddate, section_id, value) AS ff LEFT OUTER JOIN (SELECT name, sectionid FROM sectionmaster GROUP BY name, sectionid) AS section ON ff.section_id = section.sectionid GROUP BY section.name, MONTH(ff.inwarddate), DATENAME(MONTH, ff.inwarddate)");
                cmd.Parameters.Add("@d1", GetLowDate(fromdate));
                cmd.Parameters.Add("@section_id", id);
                cmd.Parameters.Add("@d2", GetHighDate(todate));
            }
            if (type == "All")
            {
                cmd = new SqlCommand("SELECT UPPER(LEFT(DATENAME([MONTH], inwarddate), 3)) AS Month, SUM(value) AS value FROM (SELECT inwarddate, supplierid, value FROM (SELECT outward1.inwarddate, outward1.supplierid, outward1.sno, outward2.value, outward2.in_refno FROM (SELECT TOP (100) PERCENT inwarddate, supplierid, sno FROM inwarddetails WHERE (inwarddate BETWEEN @d1 AND @d2) GROUP BY inwarddate, supplierid, sno ORDER BY inwarddate) AS outward1 LEFT OUTER JOIN (SELECT SUM(ROUND(quantity * perunit, 2)) AS value, in_refno FROM subinwarddetails GROUP BY in_refno) AS outward2 ON outward1.sno = outward2.in_refno) AS dd GROUP BY inwarddate, supplierid, value) AS ff GROUP BY MONTH(inwarddate), DATENAME([MONTH], inwarddate)");
                cmd.Parameters.Add("@d1", GetLowDate(fromdate));
                cmd.Parameters.Add("@d2", GetHighDate(todate));
            }
            DataTable dttotalinward = vdm.SelectQuery(cmd).Tables[0];
            List<BranchlineChart> BranchlineChartlist = new List<BranchlineChart>();
            string Mon = ""; string mon1 = ""; string Res = "";
            string Bran = ""; string bran1 = ""; string Res1 = "";
            string Val = ""; string val1 = ""; string Res2 = "";
            foreach (DataRow dr in dttotalinward.Rows)
            {

                mon1 = dr["Month"].ToString();
                if (type == "All")
                {
                    bran1 = "";
                }
                else
                {
                    bran1 = dr["name"].ToString();
                }
                val1 = dr["value"].ToString();
                Res += mon1 + ",";
                Res2 += val1 + ",";
                if (Bran == bran1)
                {
                    int count2 = 0;
                }
                else
                {
                    Res1 += "Amount" + ",";
                    Bran = bran1;
                }
            }
            BranchlineChart getbranchline = new BranchlineChart();
            getbranchline.Month = Res.ToString();
            getbranchline.StoresValue = Res2.Substring(0, Res2.Length - 1);// Res2.ToString();

            if (Res1 != "")
            {
                getbranchline.branchname = Res1.Substring(0, Res1.Length - 1);
            }
            else
            {
                Res1 += "Amount";
                getbranchline.branchname = Res1;
            }
            getbranchline.branchid = bran1;
            BranchlineChartlist.Add(getbranchline);
            string response = GetJson(BranchlineChartlist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void Get_Branch_Wise_LineChart(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            DataTable Report = new DataTable();
            DateTime doe = SalesDBManager.GetTime(vdm.conn);

            string branch_id = context.Request["branchid"];
            string year = context.Request["year"];
            string mymonth = context.Request["mymonth"];
            string tomonth = context.Request["tomonth"];

            int Year = 0;
            int.TryParse(year, out Year);
            int Month = 0;
            int.TryParse(mymonth, out Month);

            int ToMonth = 0;
            int.TryParse(tomonth, out ToMonth);

            int fromdays = DateTime.DaysInMonth(Year, Month);
            int todays = DateTime.DaysInMonth(Year, ToMonth);
            string dtFromdate = mymonth + "/" + 1 + "/" + year;
            string dtTodate = mymonth + "/" + fromdays + "/" + year;

            string dtdate = tomonth + "/" + 1 + "/" + year;
            string dttdate = tomonth + "/" + todays + "/" + year;

            DateTime fromdate = Convert.ToDateTime(dtFromdate);
            DateTime todate = Convert.ToDateTime(dttdate);
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT  UPPER(LEFT(DATENAME(MONTH, ff.invoicedate), 3)) AS Month, branchid.branchname, SUM(ff.value) AS value FROM (SELECT invoicedate, tobranch, value FROM (SELECT stocktrans.invoicedate, stocktrans.tobranch, stocktrans.sno, stocktrans2.value, stocktrans2.stock_refno FROM (SELECT TOP (100) PERCENT invoicedate, tobranch, sno FROM  stocktransferdetails WHERE (invoicedate BETWEEN @d1 AND @d2) AND (tobranch = @tobranch) GROUP BY invoicedate, tobranch, sno ORDER BY invoicedate) AS stocktrans LEFT OUTER JOIN  (SELECT SUM(quantity * price) AS value, stock_refno FROM stocktransfersubdetails GROUP BY stock_refno) AS stocktrans2 ON stocktrans.sno = stocktrans2.stock_refno) AS dd GROUP BY invoicedate, tobranch, value) AS ff LEFT OUTER JOIN (SELECT  branchname, branchid FROM  branchmaster GROUP BY branchname, branchid) AS branchid ON ff.tobranch = branchid.branchid GROUP BY branchid.branchname, MONTH(ff.invoicedate), DATENAME(MONTH, ff.invoicedate)");
            cmd.Parameters.Add("@d1", GetLowDate(fromdate));
            cmd.Parameters.Add("@tobranch", branch_id);
            cmd.Parameters.Add("@d2", GetHighDate(todate));
            DataTable dttotalinward = vdm.SelectQuery(cmd).Tables[0];
            List<BranchlineChart> BranchlineChartlist = new List<BranchlineChart>();
            string Mon = ""; string mon1 = ""; string Res = "";
            string Bran = ""; string bran1 = ""; string Res1 = "";
            string Val = ""; string val1 = ""; string Res2 = "";
            foreach (DataRow dr in dttotalinward.Rows)
            {

                mon1 = dr["Month"].ToString();
                bran1 = dr["branchname"].ToString();
                val1 = dr["value"].ToString();
                Res += mon1 + ",";
                Res2 += val1 + ",";
                if (Bran == bran1)
                {
                    int count2 = 0;
                }
                else
                {
                    Res1 += "Amount" + ",";
                    Bran = bran1;
                }
            }
            BranchlineChart getbranchline = new BranchlineChart();
            getbranchline.Month = Res.ToString();
            getbranchline.StoresValue = Res2.Substring(0, Res2.Length - 1);// Res2.ToString();
            getbranchline.branchname = Res1.Substring(0, Res1.Length - 1);//Res1.ToString();
            getbranchline.branchid = bran1;
            BranchlineChartlist.Add(getbranchline);
            string response = GetJson(BranchlineChartlist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void Get_Section_Wise_LineChart(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            DataTable Report = new DataTable();
            DateTime doe = SalesDBManager.GetTime(vdm.conn);
            string sectionid = context.Request["sectionid"];
            string year = context.Request["year"];
            string mymonth = context.Request["mymonth"];
            string tomonth = context.Request["tomonth"];
            int Year = 0;
            int.TryParse(year, out Year);
            int Month = 0;
            int.TryParse(mymonth, out Month);
            int ToMonth = 0;
            int.TryParse(tomonth, out ToMonth);
            int fromdays = DateTime.DaysInMonth(Year, Month);
            int todays = DateTime.DaysInMonth(Year, ToMonth);
            string dtFromdate = mymonth + "/" + 1 + "/" + year;
            string dtTodate = mymonth + "/" + fromdays + "/" + year;
            string dtdate = tomonth + "/" + 1 + "/" + year;
            string dttdate = tomonth + "/" + todays + "/" + year;
            DateTime fromdate = Convert.ToDateTime(dtFromdate);
            DateTime todate = Convert.ToDateTime(dttdate);
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT   UPPER(LEFT(DATENAME(MONTH, ff.inwarddate), 3)) AS Month, section.name, SUM(ff.value) AS value FROM (SELECT inwarddate, section_id, value FROM (SELECT outward1.inwarddate, outward1.section_id, outward1.sno, outward2.value, outward2.in_refno FROM (SELECT TOP (100) PERCENT inwarddate, section_id, sno FROM outwarddetails WHERE (inwarddate BETWEEN @d1 AND @d2) AND (section_id = @section_id) GROUP BY inwarddate, section_id, sno ORDER BY inwarddate) AS outward1 LEFT OUTER JOIN (SELECT SUM(quantity * perunit) AS value, in_refno FROM suboutwarddetails GROUP BY in_refno) AS outward2 ON outward1.sno = outward2.in_refno) AS dd GROUP BY inwarddate, section_id, value) AS ff LEFT OUTER JOIN (SELECT name, sectionid FROM sectionmaster GROUP BY name, sectionid) AS section ON ff.section_id = section.sectionid GROUP BY section.name, MONTH(ff.inwarddate), DATENAME(MONTH, ff.inwarddate)");
            cmd.Parameters.Add("@d1", GetLowDate(fromdate));
            cmd.Parameters.Add("@section_id", sectionid);
            cmd.Parameters.Add("@d2", GetHighDate(todate));
            DataTable dttotalinward = vdm.SelectQuery(cmd).Tables[0];
            List<BranchlineChart> BranchlineChartlist = new List<BranchlineChart>();
            string Mon = ""; string mon1 = ""; string Res = "";
            string Bran = ""; string bran1 = ""; string Res1 = "";
            string Val = ""; string val1 = ""; string Res2 = ""; string Value = "";
            foreach (DataRow dr in dttotalinward.Rows)
            {
                mon1 = dr["Month"].ToString();
                bran1 = dr["name"].ToString();
                val1 = dr["value"].ToString();
                Res += mon1 + ",";
                Res2 += val1 + ",";
                if (Bran == bran1)
                {
                    int count2 = 0;
                }
                else
                {
                    Res1 += "Amount" + ",";
                    Bran = bran1;
                }
            }
            BranchlineChart getbranchline = new BranchlineChart();
            getbranchline.Month = Res.ToString();
            getbranchline.StoresValue = Res2.Substring(0, Res2.Length - 1);
            getbranchline.branchname = Res1.Substring(0, Res1.Length - 1);
            getbranchline.branchid = bran1;
            BranchlineChartlist.Add(getbranchline);
            string response = GetJson(BranchlineChartlist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void Get_Supplier_Wise_LineChart(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            DataTable Report = new DataTable();
            DateTime doe = SalesDBManager.GetTime(vdm.conn);

            string supplierid = context.Request["supplierid"];
            string year = context.Request["year"];
            string mymonth = context.Request["mymonth"];
            string tomonth = context.Request["tomonth"];

            int Year = 0;
            int.TryParse(year, out Year);
            int Month = 0;
            int.TryParse(mymonth, out Month);

            int ToMonth = 0;
            int.TryParse(tomonth, out ToMonth);

            int fromdays = DateTime.DaysInMonth(Year, Month);
            int todays = DateTime.DaysInMonth(Year, ToMonth);
            string dtFromdate = mymonth + "/" + 1 + "/" + year;
            string dtTodate = mymonth + "/" + fromdays + "/" + year;

            string dtdate = tomonth + "/" + 1 + "/" + year;
            string dttdate = tomonth + "/" + todays + "/" + year;

            DateTime fromdate = Convert.ToDateTime(dtFromdate);
            DateTime todate = Convert.ToDateTime(dttdate);
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT        UPPER(LEFT(DATENAME(MONTH, ff.inwarddate), 3)) AS Month, section.name, SUM(ff.value) AS value FROM (SELECT inwarddate, supplierid, value FROM (SELECT outward1.inwarddate, outward1.supplierid, outward1.sno, outward2.value, outward2.in_refno FROM (SELECT TOP (100) PERCENT inwarddate, supplierid, sno FROM inwarddetails WHERE  (inwarddate BETWEEN @d1 AND @d2) AND (supplierid = @supplierid) GROUP BY inwarddate, supplierid, sno ORDER BY inwarddate) AS outward1 LEFT OUTER JOIN (SELECT SUM(quantity * perunit) AS value, in_refno FROM suboutwarddetails GROUP BY in_refno) AS outward2 ON outward1.sno = outward2.in_refno) AS dd GROUP BY inwarddate, supplierid, value) AS ff LEFT OUTER JOIN (SELECT  name, supplierid FROM  suppliersdetails GROUP BY name, supplierid) AS section ON ff.supplierid = section.supplierid GROUP BY section.name, MONTH(ff.inwarddate), DATENAME(MONTH, ff.inwarddate)");
            cmd.Parameters.Add("@d1", GetLowDate(fromdate));
            cmd.Parameters.Add("@supplierid", supplierid);
            cmd.Parameters.Add("@d2", GetHighDate(todate));
            DataTable dttotalinward = vdm.SelectQuery(cmd).Tables[0];
            List<BranchlineChart> BranchlineChartlist = new List<BranchlineChart>();
            string Mon = ""; string mon1 = ""; string Res = "";
            string Bran = ""; string bran1 = ""; string Res1 = "";
            string Val = ""; string val1 = ""; string Res2 = "";
            foreach (DataRow dr in dttotalinward.Rows)
            {
                mon1 = dr["Month"].ToString();
                bran1 = dr["name"].ToString();
                val1 = dr["value"].ToString();
                Res += mon1 + ",";

                Res2 += val1 + ",";
                if (Bran == bran1)
                {
                    int count2 = 0;
                }
                else
                {
                    Res1 += "Amount" + ",";
                    Bran = bran1;
                }
            }
            BranchlineChart getbranchline = new BranchlineChart();
            getbranchline.Month = Res.ToString();
            getbranchline.StoresValue = Res2.Substring(0, Res2.Length - 1);// Res2.ToString();
            getbranchline.branchid = bran1;
            getbranchline.branchname = Res1.Substring(0, Res1.Length - 1);//Res1.ToString();
            BranchlineChartlist.Add(getbranchline);
            string response = GetJson(BranchlineChartlist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void Get_Min_Product_wise_pie_chart(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            DataTable Report = new DataTable();
            DateTime doe = SalesDBManager.GetTime(vdm.conn);
            string type = context.Request["type"];
            string branchid = context.Session["Po_BranchID"].ToString();
            string pricetype = context.Request["pricetype"];
            string min = context.Request["min"];
            string max = context.Request["max"];

            if (pricetype == "MinProducts")
            {

                if (min == "Price")
                {
                    cmd = new SqlCommand("SELECT  TOP (10) productmaster.productname, MIN(productmaster.price) AS Value FROM productmaster INNER JOIN productmoniter ON productmaster.productid = productmoniter.productid where productmaster.branchid=@branchid GROUP BY productmaster.productname ");
                    cmd.Parameters.Add("@branchid", branchid);
                }
                if (min == "Quantity")
                {
                    cmd = new SqlCommand("SELECT  TOP (10) productmaster.productname, MIN(productmoniter.qty) AS Value FROM productmaster INNER JOIN productmoniter ON productmaster.productid = productmoniter.productid where productmaster.branchid=@branchid GROUP BY productmaster.productname ");
                    cmd.Parameters.Add("@branchid", branchid);
                }
            }
            if (pricetype == "MaxProducts")
            {
                if (max == "Quantity")
                {
                    cmd = new SqlCommand("SELECT  TOP (10) productmaster.productname, productmoniter.qty As Value FROM productmaster INNER JOIN productmoniter ON productmaster.productid = productmoniter.productid where productmaster.branchid=@branchid ORDER BY productmoniter.qty DESC");
                    cmd.Parameters.Add("@branchid", branchid);
                }
                if (max == "Value")
                {
                    cmd = new SqlCommand("SELECT  TOP (10) productmaster.productname,(productmaster.price* productmoniter.qty)  as Value FROM productmaster INNER JOIN productmoniter ON productmaster.productid = productmoniter.productid where productmaster.branchid=@branchid ORDER BY productmoniter.qty DESC");
                    cmd.Parameters.Add("@branchid", branchid);
                }
            }
            DataTable dttotalinward = vdm.SelectQuery(cmd).Tables[0];
            List<dailyinwardlistclass> daily_inward_list = new List<dailyinwardlistclass>();
            foreach (DataRow dr in dttotalinward.Rows)
            {
                dailyinwardlistclass getinwardtotal = new dailyinwardlistclass();
                getinwardtotal.productname = dr["productname"].ToString();
                double value = Convert.ToDouble(dr["Value"].ToString());
                value = Math.Round(value, 2);
                getinwardtotal.StoresValue = value.ToString();
                daily_inward_list.Add(getinwardtotal);
            }
            string response = GetJson(daily_inward_list);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class Popiechartclass
    {

        public List<string> Totalpos { get; set; }
        public List<string> Postatus { get; set; }

    }

    private void Get_Po_Pie_chart(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            DataTable Report = new DataTable();
            DateTime doe = SalesDBManager.GetTime(vdm.conn);
            string type = context.Request["type"];
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT  t1.Approval, t1.status, T2.PENDING, T2.status AS status1 FROM  (SELECT COUNT(ponumber) AS Approval, status FROM po_entrydetailes WHERE (status = 'A') GROUP BY status) AS t1 LEFT OUTER JOIN (SELECT COUNT(ponumber) AS PENDING, status FROM  po_entrydetailes AS po_entrydetailes_1 WHERE (status = 'P') GROUP BY status) AS T2 ON t1.Approval >= 0");
            cmd.Parameters.Add("@branchid", branchid);
            DataTable dttotalinward = vdm.SelectQuery(cmd).Tables[0];
            string totapos = "";
            List<Popiechartclass> Popiechartclasslist = new List<Popiechartclass>();
            List<string> pendinglist = new List<string>();
            List<string> approvelist = new List<string>();
            foreach (DataRow dr in dttotalinward.Rows)
            {
                int count = 0;
                string status = dr["status"].ToString();
                string status1 = dr["status1"].ToString();
                if (status == "A")
                {
                    pendinglist.Add(dr["Approval"].ToString());
                    string category = "Approval PO's";
                    approvelist.Add(category);
                }
                if (status1 == "P")
                {
                    pendinglist.Add(dr["PENDING"].ToString());
                    string category = "Pending PO's";
                    approvelist.Add(category);
                }
                if (count == 0)
                {
                    double value1 = Convert.ToDouble(dr["Approval"].ToString());
                    double value = Convert.ToDouble(dr["PENDING"].ToString());
                    value = Math.Round(value, 2);
                    double Value = value1 + value;
                    pendinglist.Add(Value.ToString());
                    string category = "Total PO's";
                    approvelist.Add(category);
                }
                Popiechartclass obj1 = new Popiechartclass();
                obj1.Totalpos = pendinglist;
                obj1.Postatus = approvelist;
                Popiechartclasslist.Add(obj1);
            }
            string response = GetJson(Popiechartclasslist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void subcategoryvalues(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string category = context.Request["category"];
            string branchid = context.Request["branch"];
            if (branchid == null)
            { 
                branchid = context.Session["Po_BranchID"].ToString();
            }
            DataTable Report = new DataTable();
            DateTime doe = SalesDBManager.GetTime(vdm.conn);
            cmd = new SqlCommand("SELECT  SUM(productmoniter.qty * productmoniter.price) AS VALUE, productmoniter.qty, productmoniter.minstock, productmoniter.maxstock, productmaster.productname, productmoniter.price, productmaster.productid FROM  productmaster INNER JOIN  categorymaster ON productmaster.productcode = categorymaster.cat_code INNER JOIN productmoniter ON productmaster.productid = productmoniter.productid WHERE (categorymaster.cat_code = @category) AND (productmoniter.branchid=@branchid) AND (productmoniter.qty > 0) GROUP BY productmoniter.qty, productmaster.productname, productmoniter.price, productmaster.productid, productmoniter.minstock, productmoniter.maxstock");
            cmd.Parameters.Add("@branchid", branchid);
            cmd.Parameters.Add("@category", category);
            DataTable dttotalinward = vdm.SelectQuery(cmd).Tables[0];
            List<dailyinwardlistclass> daily_inward_list = new List<dailyinwardlistclass>();
            foreach (DataRow dr in dttotalinward.Rows)
            {
                dailyinwardlistclass getinwardtotal = new dailyinwardlistclass();
                string val = dr["value"].ToString();
                string pri = dr["price"].ToString();
                if (pri != "0" || pri != "")
                {
                    double value = Convert.ToDouble(dr["value"].ToString());
                    double qty = Convert.ToDouble(dr["qty"].ToString());
                    double price = Convert.ToDouble(dr["price"].ToString());

                    value = Math.Round(value, 2);
                    qty = Math.Round(qty, 2);
                    price = Math.Round(price, 2);

                    getinwardtotal.price = price.ToString();
                    getinwardtotal.qty = qty.ToString();
                    getinwardtotal.StoresValue = value.ToString();
                    getinwardtotal.productname = dr["productname"].ToString();
                    getinwardtotal.productid = dr["productid"].ToString();
                    getinwardtotal.minstock = dr["minstock"].ToString();
                    getinwardtotal.maxstock = dr["maxstock"].ToString();
                    daily_inward_list.Add(getinwardtotal);
                }
            }
            string response = GetJson(daily_inward_list);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void purchaseorderproductname(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string pono = context.Request["psno"];
            DataTable Report = new DataTable();
            DateTime doe = SalesDBManager.GetTime(vdm.conn);
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT  (po_sub_detailes.qty*po_sub_detailes.cost) AS VALUE,po_sub_detailes.qty,po_sub_detailes.cost, po_sub_detailes.description FROM po_entrydetailes INNER JOIN po_sub_detailes ON po_entrydetailes.sno = po_sub_detailes.po_refno INNER JOIN productmaster ON productmaster.productid=po_sub_detailes.productsno   WHERE (po_entrydetailes.sno=@pono) AND (po_entrydetailes.branchid=@branchid) AND (po_sub_detailes.qty > 0)");
            cmd.Parameters.Add("@pono", pono);
            cmd.Parameters.Add("@branchid", branchid);
            DataTable dttotalinward = vdm.SelectQuery(cmd).Tables[0];
            List<dailyinwardlistclass> daily_inward_list = new List<dailyinwardlistclass>();
            foreach (DataRow dr in dttotalinward.Rows)
            {
                dailyinwardlistclass getinwardtotal = new dailyinwardlistclass();
                double value = Convert.ToDouble(dr["VALUE"].ToString());
                getinwardtotal.price = dr["cost"].ToString();
                getinwardtotal.qty = dr["qty"].ToString();
                value = Math.Round(value, 2);
                getinwardtotal.StoresValue = value.ToString();
                getinwardtotal.productname = dr["description"].ToString();
                daily_inward_list.Add(getinwardtotal);
            }
            string response = GetJson(daily_inward_list);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void inwarddashboardproductname(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string sno = context.Request["sno"];
            DataTable Report = new DataTable();
            DateTime doe = SalesDBManager.GetTime(vdm.conn);
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT productmaster.productname, (subinwarddetails.quantity *subinwarddetails.perunit) AS VALUE, subinwarddetails.quantity, subinwarddetails.perunit FROM  inwarddetails INNER JOIN subinwarddetails ON inwarddetails.sno = subinwarddetails.in_refno INNER JOIN productmaster ON subinwarddetails.productid = productmaster.productid WHERE (subinwarddetails.in_refno = @sno) AND inwarddetails.branchid=@branchid AND subinwarddetails.quantity > 0");
            cmd.Parameters.Add("@branchid", branchid);
            cmd.Parameters.Add("@sno", sno);
            DataTable dttotalinward = vdm.SelectQuery(cmd).Tables[0];
            List<dailyinwardlistclass> daily_inward_list = new List<dailyinwardlistclass>();
            foreach (DataRow dr in dttotalinward.Rows)
            {
                dailyinwardlistclass getinwardtotal = new dailyinwardlistclass();
                double value = Convert.ToDouble(dr["VALUE"].ToString());
                getinwardtotal.price = dr["perunit"].ToString();
                getinwardtotal.qty = dr["quantity"].ToString();
                value = Math.Round(value, 2);
                getinwardtotal.StoresValue = value.ToString();
                getinwardtotal.productname = dr["productname"].ToString();
                daily_inward_list.Add(getinwardtotal);
            }
            string response = GetJson(daily_inward_list);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void save_Collection_Details(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string supplier = context.Request["ddlsupplier"];
            string date = context.Request["date"];
            string payment = context.Request["payment"];
            string amount = context.Request["amount"];
            string remarks = context.Request["remarks"];
            string btnSave = context.Request["btnVal"];
            string branchid = context.Session["Po_BranchID"].ToString();
            if (btnSave == "Save")
            {
                cmd = new SqlCommand("insert into collections (supplierid,date,paymenttype,amount,remarks,branchid) values (@supplier,@date,@payment,@amount,@remarks,@branchid)");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@supplier", supplier);
                cmd.Parameters.Add("@date", date);
                cmd.Parameters.Add("@payment", payment);
                cmd.Parameters.Add("@amount", amount);
                cmd.Parameters.Add("@remarks", remarks);
                vdm.insert(cmd);
                string Response = GetJson("Collections Details are Successfully Inserted");
                context.Response.Write(Response);
            }
            else
            {
                string sno = context.Request["sno"];
                cmd = new SqlCommand("Update collections set supplierid=@supplier,date=@date,paymenttype=@payment,amount=@amount,remarks=@remarks where branchid=@branchid AND sno=@sno");
                cmd.Parameters.Add("@branchid", branchid);

                cmd.Parameters.Add("@supplier", supplier);
                cmd.Parameters.Add("@date", date);
                cmd.Parameters.Add("@payment", payment);
                cmd.Parameters.Add("@amount", amount);
                cmd.Parameters.Add("@remarks", remarks);
                cmd.Parameters.Add("@sno", sno);
                vdm.Update(cmd);
                string response = GetJson("Collections Details are successfully Updated");
                context.Response.Write(response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class collectionclass
    {
        public string suppliername { get; set; }
        public string date { get; set; }
        public string payment { get; set; }
        public string amount { get; set; }
        public string sno { get; set; }
        public string supplierid { get; set; }
        public string remarks { get; set; }

    }
    private void get_collection_details(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT suppliersdetails.name, collections.supplierid, collections.date,collections.paymenttype,collections.amount,collections.remarks,collections.sno FROM collections INNER JOIN suppliersdetails ON collections.supplierid=suppliersdetails.supplierid  WHERE collections.branchid=@branchid");
            cmd.Parameters.Add("@branchid", branchid);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<collectionclass> collectionlist = new List<collectionclass>();
            foreach (DataRow dr in routes.Rows)
            {
                collectionclass getcollectiondetails = new collectionclass();
                getcollectiondetails.date = dr["date"].ToString();
                getcollectiondetails.suppliername = dr["name"].ToString();
                getcollectiondetails.payment = dr["paymenttype"].ToString();
                getcollectiondetails.amount = dr["amount"].ToString();
                getcollectiondetails.remarks = dr["remarks"].ToString();
                getcollectiondetails.sno = dr["sno"].ToString();
                getcollectiondetails.supplierid = dr["supplierid"].ToString();
                collectionlist.Add(getcollectiondetails);
            }
            string response = GetJson(collectionlist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void approval_pending_inward_click(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            var js = new JavaScriptSerializer();
            var title1 = context.Request.Params[1];
            InwardDetails obj = js.Deserialize<InwardDetails>(title1);
            string inwardsno = obj.inwardsno;
            string branchid = context.Session["Po_BranchID"].ToString();
            string status = obj.status;
            if (status == "A")
            {
                foreach (SubInward si in obj.fillitems)
                {
                    if (si.hdnproductsno != "0")
                    {
                       // PerUnitRs
                        double opval = 0;
                        double price = 0;
                        string cost = "";
                        cmd = new SqlCommand("SELECT qty, price FROM productmoniter WHERE productid=@pmid and branchid=@bid");
                        cmd.Parameters.Add("@pmid", si.hdnproductsno);
                        cmd.Parameters.Add("@bid", branchid);
                        DataTable dtopening = vdm.SelectQuery(cmd).Tables[0];
                        if (dtopening.Rows.Count > 0)
                        {
                            foreach (DataRow dr in dtopening.Rows)
                            {
                                if (branchid == "4")
                                {
                                    string opvalue = dr["qty"].ToString();
                                    opval = Convert.ToDouble(opvalue);
                                    cost = dr["price"].ToString();
                                    if (cost != "")
                                    {
                                        if (opval > 0)
                                        {
                                            price = Convert.ToDouble(cost);
                                        }
                                        else
                                        {
                                            price = Convert.ToDouble(si.PerUnitRs);
                                        }
                                    }
                                    else
                                    {
                                        price = Convert.ToDouble(si.PerUnitRs);
                                    }
                                }
                                else
                                {
                                    string opvalue = dr["qty"].ToString();
                                    opval = Convert.ToDouble(opvalue);
                                    cost = dr["price"].ToString();
                                    if (cost != "")
                                    {
                                        if (opval > 0)
                                        {
                                            price = Convert.ToDouble(cost);
                                            if (price > 0)
                                            {

                                            }
                                            else
                                            {
                                                price = Convert.ToDouble(si.PerUnitRs);
                                            }
                                        }
                                        else
                                        {
                                            price = Convert.ToDouble(si.PerUnitRs);
                                        }
                                    }
                                    else
                                    {
                                        cost = si.PerUnitRs;
                                        if (opval > 0)
                                        {
                                            price = Convert.ToDouble(cost);
                                        }
                                        else
                                        {
                                            price = Convert.ToDouble(si.PerUnitRs);
                                        }
                                    }
                                }
                            }
                        }
                        cmd = new SqlCommand("update productmoniter set qty=qty+@quantity, price=@price where productid=@hdnproductsno and branchid=@branchid");
                        cmd.Parameters.Add("@quantity", si.quantity);
                        cmd.Parameters.Add("@hdnproductsno", si.hdnproductsno);
                        cmd.Parameters.Add("@price", price);
                        cmd.Parameters.Add("@branchid", branchid);
                        if (vdm.Update(cmd) == 0)
                        {
                            cmd = new SqlCommand("insert into productmoniter (productid, qty, price, branchid) values(@productid,@qty,@price,@bid)");
                            cmd.Parameters.Add("@productid", si.hdnproductsno);
                            cmd.Parameters.Add("@qty", si.quantity);
                            cmd.Parameters.Add("@price", si.PerUnitRs);
                            cmd.Parameters.Add("@bid", branchid);
                            vdm.insert(cmd);
                        }
                        if (branchid == "2")
                        {
                            cmd = new SqlCommand("update productmaster set availablestores=availablestores+@qty where productid=@pid");
                            cmd.Parameters.Add("@qty", si.quantity);
                            cmd.Parameters.Add("@pid", si.hdnproductsno);
                            vdm.Update(cmd);
                        }
                    }
                }
                cmd = new SqlCommand("update inwarddetails set status=@status where sno=@inwardsno AND branchid=@branchid");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@inwardsno", inwardsno);
                cmd.Parameters.Add("@status", status);
                vdm.Update(cmd);
            }
            string msg = "Inward Order Details successfully Updated";
            string Response = GetJson(msg);
            context.Response.Write(Response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);

        }

    }

    private void approval_pending_Outward_click(HttpContext context)
    {
        try
        {
            //string msg = ""; string Response = "";
            vdm = new SalesDBManager();
            string outwardsno = context.Request["outwardsno"];
            vdm = new SalesDBManager();
            var js = new JavaScriptSerializer();
            var title1 = context.Request.Params[1];
            OutwardDetails obj = js.Deserialize<OutwardDetails>(title1);
            string inwardsno = obj.outwardsno;
            string branchid = context.Session["Po_BranchID"].ToString();
            string status = obj.status;
            cmd = new SqlCommand("update outwarddetails set status=@status where sno=@inwardsno AND branchid=@branchid");
            cmd.Parameters.Add("@branchid", branchid);
            cmd.Parameters.Add("@inwardsno", inwardsno);
            cmd.Parameters.Add("@status", status);
            vdm.Update(cmd);
            if (status == "A")
            {
                foreach (SubOutward si in obj.fillitems)
                {
                    if (si.hdnproductsno != "0")
                    {
                        cmd = new SqlCommand("SELECT   productid, qty, price, branchid, minstock, maxstock FROM productmoniter  where  branchid=@branchid And  productid=@hdnproductsno");
                        cmd.Parameters.Add("@hdnproductsno", si.hdnproductsno);
                        cmd.Parameters.Add("@branchid", branchid);
                        DataTable dtproductqty = vdm.SelectQuery(cmd).Tables[0];
                        string moniterqty = dtproductqty.Rows[0]["qty"].ToString();
                        double oppqty = 0; double currentqty = 0;
                        double.TryParse(moniterqty, out oppqty);
                        double.TryParse(si.quantity, out currentqty);
                        if (oppqty >= currentqty)
                        {
                            cmd = new SqlCommand("update productmoniter set qty=qty-@quantity where productid=@hdnproductsno AND branchid=@branchid");
                            cmd.Parameters.Add("@quantity", si.quantity);
                            cmd.Parameters.Add("@hdnproductsno", si.hdnproductsno);
                            cmd.Parameters.Add("@branchid", branchid);
                            vdm.Update(cmd);
                        }
                        else
                        {

                        }
                    }
                }
            }
            string msg = "Product Issue order successfully Approved";
            string Response = GetJson(msg);
            context.Response.Write(Response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);

        }
    }

    private void approval_pending_StoresReturn_click(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            var js = new JavaScriptSerializer();
            var title1 = context.Request.Params[1];
            StoresReturn obj = js.Deserialize<StoresReturn>(title1);
            string status = obj.status;
            string streturnsno = obj.streturnsno;
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string entryby = context.Session["Employ_Sno"].ToString();
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("update stores_return set status=@status where sno=@streturnsno AND branchid=@branchid");
            cmd.Parameters.Add("@branchid", branchid);
            cmd.Parameters.Add("@streturnsno", streturnsno);
            cmd.Parameters.Add("@status", status);
            vdm.Update(cmd);
            foreach (SubStoresReturn si in obj.fillitems)
            {
                if (si.hdnproductsno != "0")
                {

                    cmd = new SqlCommand("SELECT   productid, qty, price, branchid, minstock, maxstock FROM productmoniter  where  branchid=@branchid And  productid=@hdnproductsno");
                    cmd.Parameters.Add("@hdnproductsno", si.hdnproductsno);
                    cmd.Parameters.Add("@branchid", branchid);
                    DataTable dtproductqty = vdm.SelectQuery(cmd).Tables[0];
                    string moniterqty = dtproductqty.Rows[0]["qty"].ToString();
                    double oppqty = 0; double currentqty = 0;
                    double.TryParse(moniterqty, out oppqty);
                    double.TryParse(si.quantity, out currentqty);
                    cmd = new SqlCommand("update productmoniter set qty=qty+@quantity where productid=@hdnproductsno AND branchid=@branchid");
                    cmd.Parameters.Add("@quantity", si.quantity);
                    cmd.Parameters.Add("@hdnproductsno", si.hdnproductsno);
                    cmd.Parameters.Add("@branchid", branchid);
                    if (vdm.Update(cmd) == 0)
                    {
                        cmd = new SqlCommand("insert into productmoniter (productid,qty,branchid) values(@productid,@qty,@branchid)");
                        cmd.Parameters.Add("@productid", si.hdnproductsno);
                        cmd.Parameters.Add("@qty", si.quantity);
                        cmd.Parameters.Add("@branchid", branchid);
                        vdm.insert(cmd);
                    }
                }
            }
            string msg = "Stores Return Details order successfully Approved";
            string Response = GetJson(msg);
            context.Response.Write(Response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);

        }
    }

    private void get_StoresConsumption_Details(HttpContext context)
    {
        try
        {
            string doe = context.Request["doe"];
            DateTime dtDOE = Convert.ToDateTime(doe);
            string dtdate1 = dtDOE.AddDays(-1).ToString();
            vdm = new SalesDBManager();
            List<stockclosing> storesconsumptionclosinglst = new List<stockclosing>();
            cmd = new SqlCommand("SELECT productid, productname,price FROM productmaster");
            DataTable dtproducts = vdm.SelectQuery(cmd).Tables[0];
            cmd = new SqlCommand("SELECT producttransactions.productid,producttransactions.sno,productmaster.productname,producttransactions.price,producttransactions.qty  FROM producttransactions INNER JOIN  productmaster ON productmaster.productid =producttransactions.productid  where producttransactions.doe BETWEEN  @d1 AND @d2");
            cmd.Parameters.Add("@d1", GetLowDate(dtDOE).AddDays(-1));
            cmd.Parameters.Add("@d2", GetHighDate(dtDOE).AddDays(-1));
            DataTable dtproducttransaction = vdm.SelectQuery(cmd).Tables[0];
            if (dtproducttransaction.Rows.Count > 0)
            {
                cmd = new SqlCommand("SELECT SUM(subinwarddetails.quantity) AS inwardqty,SUM(subinwarddetails.quantity*subinwarddetails.perunit) AS inwardvalue,subinwarddetails.perunit,productmaster.productid, productmaster.productname, inwarddetails.inwarddate AS inwarddate  FROM inwarddetails INNER JOIN subinwarddetails ON inwarddetails.sno = subinwarddetails.in_refno INNER JOIN productmaster ON subinwarddetails.productid = productmaster.productid WHERE  (inwarddetails.inwarddate BETWEEN  @d1 AND @d2) AND (subinwarddetails.quantity>0)  GROUP BY productmaster.productname,productmaster.productid, inwarddetails.inwarddate,subinwarddetails.perunit");
                cmd.Parameters.Add("@d1", GetLowDate(dtDOE));
                cmd.Parameters.Add("@d2", GetHighDate(dtDOE));
                DataTable dtinward = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT SUM(suboutwarddetails.quantity) AS issueqty,SUM(suboutwarddetails.quantity*suboutwarddetails.perunit) AS outwardvalue,productmaster.productid, productmaster.productname, outwarddetails.inwarddate AS outwarddate FROM outwarddetails INNER JOIN suboutwarddetails ON outwarddetails.sno = suboutwarddetails.in_refno INNER JOIN productmaster ON suboutwarddetails.productid = productmaster.productid WHERE  (outwarddetails.inwarddate BETWEEN  @d1 AND @d2) AND (suboutwarddetails.quantity>0) GROUP BY productmaster.productname,productmaster.productid, outwarddetails.inwarddate,suboutwarddetails.perunit");
                cmd.Parameters.Add("@d1", GetLowDate(dtDOE));
                cmd.Parameters.Add("@d2", GetHighDate(dtDOE));
                DataTable dtoutward = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT SUM(stocktransfersubdetails.quantity) AS transferqty,SUM(stocktransfersubdetails.quantity*stocktransfersubdetails.price) AS transfervalue,productmaster.productid, productmaster.productname, stocktransferdetails.doe,stocktransfersubdetails.price  FROM stocktransferdetails INNER JOIN stocktransfersubdetails ON stocktransferdetails.sno = stocktransfersubdetails.stock_refno INNER JOIN productmaster ON stocktransfersubdetails.productid = productmaster.productid WHERE  (stocktransferdetails.invoicedate  BETWEEN  @d1 AND @d2) AND (stocktransfersubdetails.quantity>0) GROUP BY productmaster.productname,productmaster.productid,stocktransferdetails.doe,stocktransfersubdetails.price");
                cmd.Parameters.Add("@d1", GetLowDate(dtDOE));
                cmd.Parameters.Add("@d2", GetHighDate(dtDOE));
                DataTable dttransfer = vdm.SelectQuery(cmd).Tables[0];
                foreach (DataRow dr in dtproducts.Rows)
                {
                    stockclosing getstoresconsumptionclosing = new stockclosing();
                    getstoresconsumptionclosing.sno = dr["productid"].ToString();
                    getstoresconsumptionclosing.productname = dr["productname"].ToString();
                    double oppqty = 0;
                    double oppprice = 0;
                    double inwardqty = 0;
                    double inwardvalue = 0;
                    double issueqty = 0;
                    double issuevalue = 0;
                    double transferqty = 0;
                    double transfervalue = 0;
                    double price = 0;//
                    double inwardprice = 0;//
                    double openingvalue = 0;
                    foreach (DataRow drin in dtproducttransaction.Select("productid='" + dr["productid"].ToString() + "'"))
                    {
                        double.TryParse(drin["qty"].ToString(), out oppqty);
                        double.TryParse(drin["price"].ToString(), out oppprice);
                        openingvalue = oppqty * oppprice;
                    }
                    foreach (DataRow drin in dtinward.Select("productid='" + dr["productid"].ToString() + "'"))
                    {
                        double.TryParse(drin["inwardqty"].ToString(), out inwardqty);
                        double.TryParse(drin["inwardvalue"].ToString(), out inwardvalue);
                    }
                    foreach (DataRow drout in dtoutward.Select("productid='" + dr["productid"].ToString() + "'"))
                    {
                        double.TryParse(drout["issueqty"].ToString(), out issueqty);
                        double.TryParse(drout["outwardvalue"].ToString(), out issuevalue);
                    }
                    foreach (DataRow drtransfer in dttransfer.Select("productid='" + dr["productid"].ToString() + "'"))
                    {
                        double.TryParse(drtransfer["transferqty"].ToString(), out transferqty);
                        double.TryParse(drtransfer["transfervalue"].ToString(), out transfervalue);
                    }
                    double oppandinward = 0; double oppandinawradvalue = 0;
                    oppandinward = oppqty + inwardqty;
                    oppandinawradvalue = openingvalue + inwardvalue;
                    double outwardqty = 0; double outandtransvalue = 0;
                    outwardqty = issueqty + transferqty;
                    outandtransvalue = issuevalue + transfervalue;
                    double closingqty = 0; double closingvalue = 0;
                    closingqty = oppandinward - outwardqty;
                    closingvalue = oppandinawradvalue - outandtransvalue;
                    if (closingvalue > 0 && closingqty > 0)
                    {
                        price = closingvalue / closingqty;
                    }
                    if (closingvalue < 0 && closingqty < 0)
                    {
                        price = oppprice;
                    }
                    else
                    {
                        if (closingvalue == 0 || closingqty == 0)
                        {
                            price = 0;
                        }
                    }
                    double Price1 = 0;
                    double.TryParse(price.ToString(), out Price1);
                    Price1 = Math.Round(Price1, 2);
                    getstoresconsumptionclosing.price = Price1.ToString();//
                    getstoresconsumptionclosing.oppbal = oppqty.ToString();
                    getstoresconsumptionclosing.inward = inwardqty.ToString();
                    getstoresconsumptionclosing.outward = issueqty.ToString();
                    getstoresconsumptionclosing.transfer = transferqty.ToString();
                    getstoresconsumptionclosing.clobal = closingqty.ToString();
                    getstoresconsumptionclosing.productid = dr["productid"].ToString();
                    storesconsumptionclosinglst.Add(getstoresconsumptionclosing);
                }
                string response = GetJson(storesconsumptionclosinglst);
                context.Response.Write(response);
            }
            else
            {
                string response = GetJson("Close previous day transaction");
                context.Response.Write(response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public class StoresConsumption
    {
        public string sno { get; set; }
        public string productname { get; set; }
        public string price { get; set; }
        public string qty { get; set; }
        public string totalcost { get; set; }
        public string doe { get; set; }
        public string productid { get; set; }
        public string hdnproductsno { get; set; }
    }
    public class StoresConsumptionDetails
    {
        public string btnval { get; set; }
        public string doe { get; set; }
        public List<StoresConsumption> fillstoresconsumption { get; set; }
    }
    private void Save_stores_Consumption_Details(string jsonString, HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            var js = new JavaScriptSerializer();
            StoresConsumptionDetails obj = js.Deserialize<StoresConsumptionDetails>(jsonString);
            string entryby = context.Session["Employ_Sno"].ToString();
            string branchid = context.Session["Po_BranchID"].ToString();
            string doe = obj.doe;
            DateTime dtdoe = Convert.ToDateTime(doe);
            string btnval = obj.btnval;
            if (btnval == "Save")
            {
                foreach (StoresConsumption si in obj.fillstoresconsumption)
                {
                    double qty = 0;
                    double.TryParse(si.qty, out qty);
                    cmd = new SqlCommand("insert into producttransactions(productid,qty,price,entryby,doe,branchid) values(@productid,@qty,@price,@entryby,@doe,@branchid)");
                    cmd.Parameters.Add("@productid", si.productid);
                    cmd.Parameters.Add("@qty", si.qty);
                    cmd.Parameters.Add("@doe", dtdoe);
                    cmd.Parameters.Add("@price", si.price);
                    cmd.Parameters.Add("@entryby", entryby);
                    cmd.Parameters.Add("@branchid", branchid);
                    vdm.insert(cmd);
                }
                string msg = "successfully Inserted";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public class StockRepair
    {
        public string sno { set; get; }
        public string name { set; get; }
        public string expdate { set; get; }
        public string remarks { set; get; }
        public string doe { set; get; }

    }
    private void get_stockrepairReoprt_details(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string frmdate = context.Request["fromdate"];
            DateTime fromdate = Convert.ToDateTime(frmdate);
            string tdate = context.Request["todate"];
            DateTime todate = Convert.ToDateTime(tdate);
            string branchid = context.Session["Po_BranchID"].ToString();
            string type1 = context.Request["type"];
            cmd = new SqlCommand("SELECT  sno, name, expdate, remarks, doe FROM  stockrepairdetails WHERE  (branchid = @branchid) AND (doe BETWEEN @d1 AND @d2) ORDER BY expdate");
            cmd.Parameters.Add("@d1", GetLowDate(fromdate));
            cmd.Parameters.Add("@d2", GetHighDate(todate));
            cmd.Parameters.Add("@branchid", branchid);
            DataTable dtpo = vdm.SelectQuery(cmd).Tables[0];
            List<StockRepair> repair = new List<StockRepair>();
            foreach (DataRow dr in dtpo.Rows)
            {
                StockRepair geoutward = new StockRepair();
                geoutward.sno = dr["sno"].ToString();
                geoutward.name = dr["name"].ToString();
                geoutward.expdate = ((DateTime)dr["expdate"]).ToString("dd-MM-yyyy"); //dr["expdate"].ToString();
                geoutward.remarks = dr["remarks"].ToString();
                geoutward.doe = ((DateTime)dr["doe"]).ToString("dd-MM-yyyy"); //dr["doe"].ToString();
                repair.Add(geoutward);
            }
            string response = GetJson(repair);
            context.Response.Write(response);
        }
        catch
        {
        }
    }
    private void saveRepairItemDetails(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string branchid = context.Session["Po_BranchID"].ToString();
            string Productid = context.Request["ProductId"];
            string productname = context.Request["RepairItemName"];
            string productcode = context.Request["MainCode"];
            string sku = context.Request["SKU"];
            string description = context.Request["Description"];
            string categoryid = context.Request["categoryid"];
            string subcategoryid = context.Request["subcategoryid"];
            string uim = context.Request["uim"];
            if (uim == "Select Uim")
            {
                uim = "0";
            }
            string price = context.Request["price"];
            string subcode = context.Request["subcode"];
            string createdby = context.Session["Employ_Sno"].ToString();
            DateTime createdon = DateTime.Now;
            string btnSave = context.Request["btnVal"];
            if (btnSave == "save")
            {
                cmd = new SqlCommand("insert into Repairdetails (itemname,itemcode,sku,description,categoryid,uom,price,branchid,subcatid,subcode) values (@itemname,@itemcode,@sku,@description,@categoryid,@uim,@price,@branchid,@subcategoryid,@subcode)");
                cmd.Parameters.Add("@itemname", productname);
                cmd.Parameters.Add("@itemcode", productcode);
                cmd.Parameters.Add("@sku", sku);
                cmd.Parameters.Add("@description", description);
                cmd.Parameters.Add("@categoryid", categoryid);
                cmd.Parameters.Add("@subcode", subcode);
                cmd.Parameters.Add("@price", price);
                cmd.Parameters.Add("@uim", uim);
                cmd.Parameters.Add("@subcategoryid", subcategoryid);
                cmd.Parameters.Add("@branchid", branchid);
                vdm.insert(cmd);
                string msg = "Repair Item Details are successfully saved";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {
                cmd = new SqlCommand("Update Repairdetails set itemname=@itemname,subcode=@subcode,subcatid=@subcategoryid,itemcode=@itemcode,sku=@sku,description=@description,categoryid=@categoryid,uom=@uom,price=@price,branchid=@branchid where sno=@sno AND  branchid=@branchid");
                cmd.Parameters.Add("@itemname", productname);
                cmd.Parameters.Add("@itemcode", productcode);
                cmd.Parameters.Add("@sku", sku);
                cmd.Parameters.Add("@description", description);
                cmd.Parameters.Add("@categoryid", categoryid);
                cmd.Parameters.Add("@subcategoryid", subcategoryid);
                cmd.Parameters.Add("@price", price);
                cmd.Parameters.Add("@uom", uim);
                cmd.Parameters.Add("@subcode", subcode);
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@sno", Productid);
                string msg = "Repair Item Details successfully updated";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public class RepairItemDetails
    {
        public string ItemName { get; set; }
        public string description { get; set; }
        public string sku { get; set; }
        public string category { get; set; }
        public string Itemcode { get; set; }
        public string availablestores { get; set; }
        public string uom { get; set; }
        public string price { get; set; }
        public string moniterqty { get; set; }
        public string puom { get; set; }
        public string categoryid { get; set; }
        public string itemid { get; set; }
        public string availablestores1 { get; set; }
        public string subcategoryid { get; set; }
        public string subcode { get; set; }
    }

    private void get_RepairItem_details(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT Repairdetails.itemname,Repairdetails.sno,Repairdetails.subcatid,Repairdetails.subcode, Repairdetails.itemcode, Repairdetails.sku, Repairdetails.description, Repairdetails.categoryid, Repairdetails.uom,Repairdetails.price, Repairdetails.branchid, uimmaster.uim, uimmaster.sno AS puim FROM uimmaster INNER JOIN Repairdetails ON uimmaster.sno = Repairdetails.uom where Repairdetails.branchid=@branchid");
            cmd.Parameters.Add("@branchid", branchid);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<RepairItemDetails> RepairItemDetailslist = new List<RepairItemDetails>();
            foreach (DataRow dr in routes.Rows)
            {
                RepairItemDetails getRepairItemDetails = new RepairItemDetails();
                getRepairItemDetails.ItemName = dr["itemname"].ToString();
                getRepairItemDetails.Itemcode = dr["itemcode"].ToString();
                getRepairItemDetails.sku = dr["sku"].ToString();
                getRepairItemDetails.description = dr["description"].ToString();
                getRepairItemDetails.categoryid = dr["categoryid"].ToString();
                getRepairItemDetails.subcategoryid = dr["subcatid"].ToString();
                getRepairItemDetails.subcode = dr["subcode"].ToString();
                getRepairItemDetails.uom = dr["uom"].ToString();
                getRepairItemDetails.puom = dr["puim"].ToString();
                getRepairItemDetails.price = dr["price"].ToString();
                getRepairItemDetails.itemid = dr["sno"].ToString();
                RepairItemDetailslist.Add(getRepairItemDetails);
            }
            string response = GetJson(RepairItemDetailslist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void save_asset_mgm(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string branchid = context.Session["Po_BranchID"].ToString();
            string entryby = context.Session["Employ_Sno"].ToString();
            string asset_name = context.Request["asset_name"];
            string War_lic = context.Request["War_lic"];
            string asset_code = context.Request["asset_code"];
            string slct_type = context.Request["slct_type"];
            string slct_maintain = context.Request["slct_maintain"];
            string status = context.Request["status"];
            string purcharse_dt = context.Request["purcharse_dt"];
            string delivery_dt = context.Request["delivery_dt"];
            string main_loc = context.Request["main_loc"];
            string install_dt = context.Request["install_dt"];
            string sub_loc = context.Request["sub_loc"];
            string install_by = context.Request["install_by"];
            string cust_po = context.Request["cust_po"];
            string price = context.Request["price"];
            string depr = context.Request["depr"];
            string sku = context.Request["sku"];
            string notes = context.Request["notes"];
            string serial = context.Request["serial"];
            string model = context.Request["model"];
            string vendor = context.Request["vendor"];
            string sno = context.Request["sno"];
            string createdby = context.Session["Employ_Sno"].ToString();
            DateTime createdon = DateTime.Now;
            string btnSave = context.Request["btn_save"];
            if (btnSave == "Save")
            {
                if (slct_type == "Computers")
                {
                    string mother_board = context.Request["mother_board"];
                    string processor = context.Request["processor"];
                    string ram = context.Request["ram"];
                    string hard_disk = context.Request["hard_disk"];
                    string dvd_writer = context.Request["dvd_writer"];
                    string cabinet = context.Request["cabinet"];
                    string key_board = context.Request["key_board"];
                    string mouse = context.Request["mouse"];
                    string monitor = context.Request["monitor"];
                    string connectivity = context.Request["connectivity"];
                    string brand = context.Request["brand"];
                    string os = context.Request["os"];
                    string antivirus = context.Request["antivirus"];
                    string smps = context.Request["smps"];
                    string printer = context.Request["printer"];

                    cmd = new SqlCommand("insert into asset_details (assetname,assetcode,licexpdate,purchasedate,deliverydate,installdate,status,categeory,locationid,deptid,vendorid,serialno,modelno,installby,depretiation_per,sku,remarks,price,pono,entryby,branchid,maintenancetype,motherboard,processor,ram,harddisk,dvdwriter,cabinet,keyboard,mouse,monitor,connectivity,brand,os,antivirus,smps,printer) values (@asset_name,@asset_code,@War_lic,@purcharse_dt,@delivery_dt,@install_dt,@status,@slct_type,@main_loc,@sub_loc,@vendor,@serial,@model,@install_by,@depr,@sku,@notes,@price,@cust_po,@entryby,@branchid,@slct_maintain,@mother_board,@processor,@ram,@hard_disk,@dvd_writer,@cabinet,@key_board,@mouse,@monitor,@connectivity,@brand,@os,@antivirus,@smps,@printer)");
                    cmd.Parameters.Add("@asset_name", asset_name);
                    cmd.Parameters.Add("@War_lic", War_lic);
                    cmd.Parameters.Add("@sku", sku);
                    cmd.Parameters.Add("@asset_code", asset_code);
                    cmd.Parameters.Add("@slct_type", slct_type);
                    cmd.Parameters.Add("@slct_maintain", slct_maintain);
                    cmd.Parameters.Add("@status", status);
                    cmd.Parameters.Add("@price", price);
                    cmd.Parameters.Add("@purcharse_dt", purcharse_dt);
                    cmd.Parameters.Add("@delivery_dt", delivery_dt);
                    cmd.Parameters.Add("@main_loc", main_loc);
                    cmd.Parameters.Add("@install_dt", install_dt);
                    cmd.Parameters.Add("@sub_loc", sub_loc);
                    cmd.Parameters.Add("@install_by", install_by);
                    cmd.Parameters.Add("@cust_po", cust_po);
                    cmd.Parameters.Add("@depr", depr);
                    cmd.Parameters.Add("@notes", notes);
                    cmd.Parameters.Add("@serial", serial);
                    cmd.Parameters.Add("@model", model);
                    cmd.Parameters.Add("@vendor", vendor);
                    cmd.Parameters.Add("@branchid", branchid);
                    cmd.Parameters.Add("@entryby", entryby);
                    cmd.Parameters.Add("@mother_board", mother_board);
                    cmd.Parameters.Add("@processor", processor);
                    cmd.Parameters.Add("@ram", ram);
                    cmd.Parameters.Add("@hard_disk", hard_disk);
                    cmd.Parameters.Add("@dvd_writer", dvd_writer);
                    cmd.Parameters.Add("@cabinet", cabinet);
                    cmd.Parameters.Add("@key_board", key_board);
                    cmd.Parameters.Add("@mouse", mouse);
                    cmd.Parameters.Add("@monitor", monitor);
                    cmd.Parameters.Add("@connectivity", connectivity);
                    cmd.Parameters.Add("@brand", brand);
                    cmd.Parameters.Add("@os", os);
                    cmd.Parameters.Add("@antivirus", antivirus);
                    cmd.Parameters.Add("@smps", smps);
                    cmd.Parameters.Add("@printer", printer);
                    vdm.insert(cmd);
                }
                else
                {
                    cmd = new SqlCommand("insert into asset_details (assetname,assetcode,licexpdate,purchasedate,deliverydate,installdate,status,categeory,locationid,deptid,vendorid,serialno,modelno,installby,depretiation_per,sku,remarks,price,pono,entryby,branchid,maintenancetype) values (@asset_name,@asset_code,@War_lic,@purcharse_dt,@delivery_dt,@install_dt,@status,@slct_type,@main_loc,@sub_loc,@vendor,@serial,@model,@install_by,@depr,@sku,@notes,@price,@cust_po,@entryby,@branchid,@slct_maintain)");
                    cmd.Parameters.Add("@asset_name", asset_name);
                    cmd.Parameters.Add("@War_lic", War_lic);
                    cmd.Parameters.Add("@sku", sku);
                    cmd.Parameters.Add("@asset_code", asset_code);
                    cmd.Parameters.Add("@slct_type", slct_type);
                    cmd.Parameters.Add("@slct_maintain", slct_maintain);
                    cmd.Parameters.Add("@status", status);
                    cmd.Parameters.Add("@price", price);
                    cmd.Parameters.Add("@purcharse_dt", purcharse_dt);
                    cmd.Parameters.Add("@delivery_dt", delivery_dt);
                    cmd.Parameters.Add("@main_loc", main_loc);
                    cmd.Parameters.Add("@install_dt", install_dt);
                    cmd.Parameters.Add("@sub_loc", sub_loc);
                    cmd.Parameters.Add("@install_by", install_by);
                    cmd.Parameters.Add("@cust_po", cust_po);
                    cmd.Parameters.Add("@depr", depr);
                    cmd.Parameters.Add("@notes", notes);
                    cmd.Parameters.Add("@serial", serial);
                    cmd.Parameters.Add("@model", model);
                    cmd.Parameters.Add("@vendor", vendor);
                    cmd.Parameters.Add("@branchid", branchid);
                    cmd.Parameters.Add("@entryby", entryby);
                    vdm.insert(cmd);
                }
                string msg = "Asset Details  are successfully saved";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {
                if (slct_type == "Computers")
                {
                    string mother_board = context.Request["mother_board"];
                    string processor = context.Request["processor"];
                    string ram = context.Request["ram"];
                    string hard_disk = context.Request["hard_disk"];
                    string dvd_writer = context.Request["dvd_writer"];
                    string cabinet = context.Request["cabinet"];
                    string key_board = context.Request["key_board"];
                    string mouse = context.Request["mouse"];
                    string monitor = context.Request["monitor"];
                    string connectivity = context.Request["connectivity"];
                    string brand = context.Request["brand"];
                    string os = context.Request["os"];
                    string antivirus = context.Request["antivirus"];
                    string smps = context.Request["smps"];
                    string printer = context.Request["printer"];

                    cmd = new SqlCommand("Update asset_details set assetname=@asset_name,licexpdate=@War_lic,sku=@sku,assetcode=@asset_code,categeory=@slct_type,status=@status,purchasedate=@purcharse_dt,deliverydate=@delivery_dt,locationid=@main_loc,installdate=@install_dt,deptid=@sub_loc,installby=@install_by,pono=@cust_po,price=@price,depretiation_per=@depr,remarks=@notes,serialno=@serial,modelno=@model,vendorid=@vendor,branchid=@branchid,maintenancetype=@slct_maintain,motherboard=@mother_board,processor=@processor,ram=@ram,harddisk=@hard_disk,dvdwriter=@dvd_writer,cabinet=@cabinet,keyboard=@key_board,mouse=@mouse,monitor=@monitor,connectivity=@connectivity,brand=@brand,os=@os,antivirus=@antivirus,smps=@smps,printer=@printer where sno=@sno AND  branchid=@branchid");
                    cmd.Parameters.Add("@asset_name", asset_name);
                    cmd.Parameters.Add("@War_lic", War_lic);
                    cmd.Parameters.Add("@sku", sku);
                    cmd.Parameters.Add("@asset_code", asset_code);
                    cmd.Parameters.Add("@slct_type", slct_type);
                    cmd.Parameters.Add("@slct_maintain", slct_maintain);
                    cmd.Parameters.Add("@status", status);
                    cmd.Parameters.Add("@purcharse_dt", purcharse_dt);
                    cmd.Parameters.Add("@delivery_dt", delivery_dt);
                    cmd.Parameters.Add("@main_loc", main_loc);
                    cmd.Parameters.Add("@install_dt", install_dt);
                    cmd.Parameters.Add("@sub_loc", sub_loc);
                    cmd.Parameters.Add("@install_by", install_by);
                    cmd.Parameters.Add("@cust_po", cust_po);
                    cmd.Parameters.Add("@price", price);
                    cmd.Parameters.Add("@depr", depr);
                    cmd.Parameters.Add("@notes", notes);
                    cmd.Parameters.Add("@serial", serial);
                    cmd.Parameters.Add("@model", model);
                    cmd.Parameters.Add("@vendor", vendor);
                    cmd.Parameters.Add("@branchid", branchid);
                    cmd.Parameters.Add("@sno", sno);
                    cmd.Parameters.Add("@mother_board", mother_board);
                    cmd.Parameters.Add("@processor", processor);
                    cmd.Parameters.Add("@ram", ram);
                    cmd.Parameters.Add("@hard_disk", hard_disk);
                    cmd.Parameters.Add("@dvd_writer", dvd_writer);
                    cmd.Parameters.Add("@cabinet", cabinet);
                    cmd.Parameters.Add("@key_board", key_board);
                    cmd.Parameters.Add("@mouse", mouse);
                    cmd.Parameters.Add("@monitor", monitor);
                    cmd.Parameters.Add("@connectivity", connectivity);
                    cmd.Parameters.Add("@brand", brand);
                    cmd.Parameters.Add("@os", os);
                    cmd.Parameters.Add("@antivirus", antivirus);
                    cmd.Parameters.Add("@smps", smps);
                    cmd.Parameters.Add("@printer", printer);
                    vdm.Update(cmd);
                }
                else
                {
                    cmd = new SqlCommand("Update asset_details set assetname=@asset_name,licexpdate=@War_lic,sku=@sku,assetcode=@asset_code,categeory=@slct_type,status=@status,purchasedate=@purcharse_dt,deliverydate=@delivery_dt,locationid=@main_loc,installdate=@install_dt,deptid=@sub_loc,installby=@install_by,pono=@cust_po,price=@price,depretiation_per=@depr,remarks=@notes,serialno=@serial,modelno=@model,vendorid=@vendor,branchid=@branchid,maintenancetype=@slct_maintain where sno=@sno AND  branchid=@branchid");
                    cmd.Parameters.Add("@asset_name", asset_name);
                    cmd.Parameters.Add("@War_lic", War_lic);
                    cmd.Parameters.Add("@sku", sku);
                    cmd.Parameters.Add("@asset_code", asset_code);
                    cmd.Parameters.Add("@slct_type", slct_type);
                    cmd.Parameters.Add("@slct_maintain", slct_maintain);
                    cmd.Parameters.Add("@status", status);
                    cmd.Parameters.Add("@purcharse_dt", purcharse_dt);
                    cmd.Parameters.Add("@delivery_dt", delivery_dt);
                    cmd.Parameters.Add("@main_loc", main_loc);
                    cmd.Parameters.Add("@install_dt", install_dt);
                    cmd.Parameters.Add("@sub_loc", sub_loc);
                    cmd.Parameters.Add("@install_by", install_by);
                    cmd.Parameters.Add("@cust_po", cust_po);
                    cmd.Parameters.Add("@price", price);
                    cmd.Parameters.Add("@depr", depr);
                    cmd.Parameters.Add("@notes", notes);
                    cmd.Parameters.Add("@serial", serial);
                    cmd.Parameters.Add("@model", model);
                    cmd.Parameters.Add("@vendor", vendor);
                    cmd.Parameters.Add("@branchid", branchid);
                    cmd.Parameters.Add("@sno", sno);
                    vdm.Update(cmd);
                }
                string msg = "Asset Details successfully updated";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public class asset_Det
    {
        public string asset_name { get; set; }
        public string asset_code { get; set; }
        public string War_lic { get; set; }
        public string purcharse_dt { get; set; }
        public string delivery_dt { get; set; }
        public string install_dt { get; set; }
        public string status { get; set; }
        public string slct_type { get; set; }
        public string slct_maintain { get; set; }
        public string main_loc { get; set; }
        public string loc_id { get; set; }
        public string sku { get; set; }
        public string sub_loc { get; set; }
        public string deptid { get; set; }
        public string vendor { get; set; }
        public string vendor_id { get; set; }
        public string serial { get; set; }
        public string model { get; set; }
        public string install_by { get; set; }
        public string depr { get; set; }
        public string notes { get; set; }
        public string price { get; set; }
        public string cust_po { get; set; }
        public string entryby { get; set; }
        public string branchid { get; set; }
        public string sno { get; set; }
        public string mother_board { get; set; }
        public string processor { get; set; }
        public string ram { get; set; }
        public string hard_disk { get; set; }
        public string dvd_writer { get; set; }
        public string cabinet { get; set; }
        public string key_board { get; set; }
        public string mouse { get; set; }
        public string monitor { get; set; }
        public string connectivity { get; set; }
        public string brand { get; set; }
        public string os { get; set; }
        public string antivirus { get; set; }
        public string smps { get; set; }
        public string printer { get; set; }
    }

    private void get_asset_mgm(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            cmd = new SqlCommand("SELECT asset_details.assetname, asset_details.maintenancetype, asset_details.assetcode, asset_details.locationid, asset_details.deptid, asset_details.vendorid, asset_details.licexpdate, asset_details.purchasedate, asset_details.deliverydate, asset_details.installdate, asset_details.status, asset_details.categeory, asset_details.serialno, asset_details.modelno, asset_details.installby, asset_details.depretiation_per, asset_details.sku, asset_details.remarks, asset_details.price, asset_details.pono, asset_details.entryby, asset_details.branchid, asset_details.sno, asset_details.motherboard, asset_details.processor, asset_details.ram, asset_details.harddisk, asset_details.dvdwriter, asset_details.cabinet, asset_details.keyboard, asset_details.mouse, asset_details.monitor, asset_details.connectivity, asset_details.brand, asset_details.os, asset_details.antivirus, asset_details.smps, asset_details.printer, branchmaster.branchname, departmentmaster.department, suppliersdetails.name FROM asset_details INNER JOIN branchmaster ON asset_details.locationid = branchmaster.branchid INNER JOIN departmentmaster ON asset_details.deptid = departmentmaster.sno INNER JOIN suppliersdetails ON asset_details.vendorid = suppliersdetails.supplierid");
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<asset_Det> RepairItemDetailslist = new List<asset_Det>();
            foreach (DataRow dr in routes.Rows)
            {
                asset_Det getRepairItemDetails = new asset_Det();
                getRepairItemDetails.asset_name = dr["assetname"].ToString();
                getRepairItemDetails.asset_code = dr["assetcode"].ToString();
                getRepairItemDetails.sku = dr["sku"].ToString();
                getRepairItemDetails.War_lic = ((DateTime)dr["licexpdate"]).ToString("dd-MM-yyyy");
                getRepairItemDetails.purcharse_dt = ((DateTime)dr["purchasedate"]).ToString("dd-MM-yyyy");
                getRepairItemDetails.delivery_dt = ((DateTime)dr["deliverydate"]).ToString("dd-MM-yyyy");
                getRepairItemDetails.install_dt = ((DateTime)dr["installdate"]).ToString("dd-MM-yyyy");
                var status = dr["status"].ToString();
                if (status == "1")
                {
                    getRepairItemDetails.status = "Active";
                }
                if (status == "0")
                {
                    getRepairItemDetails.status = "InActive";
                }
                getRepairItemDetails.slct_type = dr["categeory"].ToString();
                getRepairItemDetails.slct_maintain = dr["maintenancetype"].ToString();
                getRepairItemDetails.loc_id = dr["locationid"].ToString();
                getRepairItemDetails.main_loc = dr["branchname"].ToString();
                getRepairItemDetails.deptid = dr["deptid"].ToString();
                getRepairItemDetails.sub_loc = dr["department"].ToString();
                getRepairItemDetails.vendor_id = dr["vendorid"].ToString();
                getRepairItemDetails.vendor = dr["name"].ToString();
                getRepairItemDetails.serial = dr["serialno"].ToString();
                getRepairItemDetails.model = dr["modelno"].ToString();
                getRepairItemDetails.install_by = dr["installby"].ToString();
                getRepairItemDetails.depr = dr["depretiation_per"].ToString();
                getRepairItemDetails.notes = dr["remarks"].ToString();
                getRepairItemDetails.price = dr["price"].ToString();
                getRepairItemDetails.cust_po = dr["pono"].ToString();
                getRepairItemDetails.entryby = dr["entryby"].ToString();
                getRepairItemDetails.branchid = dr["branchid"].ToString();
                getRepairItemDetails.sno = dr["sno"].ToString();
                getRepairItemDetails.mother_board = dr["motherboard"].ToString();
                getRepairItemDetails.processor = dr["processor"].ToString();
                getRepairItemDetails.ram = dr["ram"].ToString();
                getRepairItemDetails.hard_disk = dr["harddisk"].ToString();
                getRepairItemDetails.dvd_writer = dr["dvdwriter"].ToString();
                getRepairItemDetails.cabinet = dr["cabinet"].ToString();
                getRepairItemDetails.key_board = dr["keyboard"].ToString();
                getRepairItemDetails.mouse = dr["mouse"].ToString();
                getRepairItemDetails.monitor = dr["monitor"].ToString();
                getRepairItemDetails.connectivity = dr["connectivity"].ToString();
                getRepairItemDetails.brand = dr["brand"].ToString();
                getRepairItemDetails.os = dr["os"].ToString();
                getRepairItemDetails.antivirus = dr["antivirus"].ToString();
                getRepairItemDetails.smps = dr["smps"].ToString();
                getRepairItemDetails.printer = dr["printer"].ToString();
                RepairItemDetailslist.Add(getRepairItemDetails);
            }
            string response = GetJson(RepairItemDetailslist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class maintenance_det
    {
        public string asset_name { get; set; }
        public string asset_code { get; set; }
        public string install_dt { get; set; }
        public string sno { get; set; }
    }

    private void get_maintenance_det(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string location = context.Request["location"];
            string department = context.Request["department"];
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT sno, assetname, assetcode, installdate FROM asset_details WHERE (locationid=@location) AND (deptid=@department)");
            cmd.Parameters.Add("@location", location);
            cmd.Parameters.Add("@department", department);
            DataTable dtpo = vdm.SelectQuery(cmd).Tables[0];
            List<maintenance_det> workorderDetails = new List<maintenance_det>();
            foreach (DataRow dr in dtpo.Rows)
            {
                maintenance_det getworkorderreport = new maintenance_det();
                getworkorderreport.sno = dr["sno"].ToString();
                getworkorderreport.asset_name = dr["assetname"].ToString();
                getworkorderreport.asset_code = dr["assetcode"].ToString();
                getworkorderreport.install_dt = ((DateTime)dr["installdate"]).ToString("dd-MM-yyyy");
                workorderDetails.Add(getworkorderreport);
            }
            string response = GetJson(workorderDetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class maintenance_det1
    {
        public string assetid { get; set; }
        public string statringmonth { get; set; }
        public string nextmaintananceschedule { get; set; }
        public string sno { get; set; }
    }

    private void get_maintenance_det1(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string location = context.Request["location"];
            string department = context.Request["department"];
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT  sno,assetid, statringmonth,nextmaintananceschedule FROM preventive_asset_maintanance_schedule WHERE (branchid=@location) AND (deptid=@department)");
            cmd.Parameters.Add("@location", location);
            cmd.Parameters.Add("@department", department);
            DataTable dtpo = vdm.SelectQuery(cmd).Tables[0];
            List<maintenance_det1> workorderDetails = new List<maintenance_det1>();
            foreach (DataRow dr in dtpo.Rows)
            {
                maintenance_det1 getworkorderreport = new maintenance_det1();
                getworkorderreport.assetid = dr["assetid"].ToString();
                getworkorderreport.nextmaintananceschedule = dr["nextmaintananceschedule"].ToString();
                getworkorderreport.statringmonth = ((DateTime)dr["statringmonth"]).ToString("dd-MM-yyyy");
                getworkorderreport.sno = dr["sno"].ToString();
                workorderDetails.Add(getworkorderreport);
            }
            string response = GetJson(workorderDetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void save_schedule_Details(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            var js = new JavaScriptSerializer();
            var title1 = context.Request.Params[1];
            preventive_maintenance_det obj = js.Deserialize<preventive_maintenance_det>(title1);
            string entryby = context.Session["Employ_Sno"].ToString();
            string branchid = context.Session["Po_BranchID"].ToString();
            string btn_save = obj.btn_save;
            string createdby = context.Session["Employ_Sno"].ToString();
            DateTime createdon = DateTime.Now;
            if (btn_save == "Save")
            {
                foreach (prevent_Det si in obj.DataTable)
                {
                    string asset_id = si.asset_id;
                    int van = Convert.ToInt32(asset_id);
                    if (van >= 1)
                    {
                        string statring_month = si.s_schd;
                        string nextmaintananceschedule = si.n_schd;
                        cmd = new SqlCommand("Update preventive_schedule set statringmonth=@statring_month,nextmaintananceschedule=@next_mntc_sche where assetid=@asset_id");
                        cmd.Parameters.Add("@asset_id", asset_id);
                        cmd.Parameters.Add("@statring_month", statring_month);
                        cmd.Parameters.Add("@next_mntc_sche", nextmaintananceschedule);
                        vdm.Update(cmd);
                        if (vdm.Update(cmd) == 0)
                        {
                            cmd = new SqlCommand("insert into preventive_schedule (assetid,statringmonth,nextmaintananceschedule) values (@asset_id,@statring_month,@next_mntc_sche)");
                            cmd.Parameters.Add("@asset_id", asset_id);
                            cmd.Parameters.Add("@statring_month", statring_month);
                            cmd.Parameters.Add("@next_mntc_sche", nextmaintananceschedule);
                            vdm.insert(cmd);
                        }
                    }
                }
                string msg = "Details  are successfully saved";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class preventive_maintenance_det
    {
        public string btn_save { get; set; }
        public List<prevent_Det> DataTable { get; set; }
    }

    public class prevent_Det
    {
        public string asset_id { get; set; }
        public string s_schd { get; set; }
        public string n_schd { get; set; }
    }
    public class asset_list
    {
        public string asset_name { get; set; }
        public string asset_code { get; set; }
        public string purchase_dt { get; set; }
        public string maintain_type { get; set; }
        public string price { get; set; }
        public string sno { get; set; }
    }

    private void get_asset_list(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string location = context.Request["location"];
            string department = context.Request["department"];
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT  assetname, assetcode, purchasedate, maintenancetype, price FROM asset_details WHERE (locationid=@location) AND (deptid=@department)");
            cmd.Parameters.Add("@location", location);
            cmd.Parameters.Add("@department", department);
            DataTable dtpo = vdm.SelectQuery(cmd).Tables[0];
            List<asset_list> workorderDetails = new List<asset_list>();
            foreach (DataRow dr in dtpo.Rows)
            {
                asset_list getworkorderreport = new asset_list();
                getworkorderreport.asset_name = dr["assetname"].ToString();
                getworkorderreport.asset_code = dr["assetcode"].ToString();
                getworkorderreport.purchase_dt = ((DateTime)dr["purchasedate"]).ToString("dd-MM-yyyy");
                getworkorderreport.maintain_type = dr["maintenancetype"].ToString();
                getworkorderreport.price = dr["price"].ToString();
                workorderDetails.Add(getworkorderreport);
            }
            string response = GetJson(workorderDetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void save_quotation_req_det(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            var js = new JavaScriptSerializer();
            var title1 = context.Request.Params[1];
            quo_req_det obj = js.Deserialize<quo_req_det>(title1);
            string sup_name = obj.sup_name;
            string indent_ref = obj.indent_ref;
            DateTime quo_dt = Convert.ToDateTime(obj.quo_dt);
            string sno = obj.sno;
            string entryby = context.Session["Employ_Sno"].ToString();
            string branchid = context.Session["Po_BranchID"].ToString();
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            cmd = new SqlCommand("select supplierid from suppliersdetails where name=@sup_name ");
            cmd.Parameters.Add("@sup_name", sup_name);
            DataTable routes2 = vdm.SelectQuery(cmd).Tables[0];
            string sup_id = routes2.Rows[0]["supplierid"].ToString();
            string btn_save = obj.btn_save;
            if (btn_save == "Save")
            {
                cmd = new SqlCommand("select MAX(quotationno) AS quotationno from quotation_request ");
                DataTable routes1 = vdm.SelectQuery(cmd).Tables[0];
                string quotano = routes1.Rows[0]["quotationno"].ToString();
                int quotationno;
                if (quotano == "")//DBNull.Value.Equals(quotano) routes1.Rows.Count==0
                {
                    quotationno = 1;
                }
                else
                {
                    int quotano1 = Convert.ToInt32(quotano);
                    quotationno = quotano1 + 1;
                }
                cmd = new SqlCommand("insert into quotation_request (indentno,quotationno,suplierid,quotationdate,branchid,doe,entryby,entrydate) values (@indent_ref,@quotationno,@sup_id,@quo_dt,@branchid,@doe,@entryby,@entrydate)");
                cmd.Parameters.Add("@indent_ref", indent_ref);
                cmd.Parameters.Add("@quotationno", quotationno);
                cmd.Parameters.Add("@sup_id", sup_id);
                cmd.Parameters.Add("@quo_dt", quo_dt);
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@entryby", entryby);
                cmd.Parameters.Add("@entrydate", ServerDateCurrentdate);
                vdm.insert(cmd);
                cmd = new SqlCommand("select MAX(sno) AS sno from quotation_request ");
                DataTable routes = vdm.SelectQuery(cmd).Tables[0];
                string refno = routes.Rows[0]["sno"].ToString();//tax_gl_code
                foreach (quo_prod_det si in obj.DataTable)
                {
                    string prod_id = si.prod_id;
                    string qty = si.qty;
                    cmd = new SqlCommand("insert into quotation_req_subdetails (productid,qty,quotation_refno) values (@prod_id, @qty, @refno)");
                    cmd.Parameters.Add("@prod_id", prod_id);
                    cmd.Parameters.Add("@qty", qty);
                    cmd.Parameters.Add("@refno", refno);
                    cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                    vdm.insert(cmd);
                }
                string msg = "Quotation successfully saved Request for Quotation No. is " + quotationno;
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {
                cmd = new SqlCommand("UPDATE quotation_request SET indentno=@indent_ref,suplierid=@sup_id,quotationdate=@quo_dt,modifiedby=@modifiedby,modifieddate=@modifieddate WHERE sno=@sno");
                cmd.Parameters.Add("@indent_ref", indent_ref);
                cmd.Parameters.Add("@sup_id", sup_id);
                cmd.Parameters.Add("@quo_dt", quo_dt);
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@modifiedby", entryby);
                cmd.Parameters.Add("@modifieddate", ServerDateCurrentdate);
                cmd.Parameters.Add("@sno", sno);
                vdm.Update(cmd);
                foreach (quo_prod_det si in obj.DataTable)
                {
                    string prod_id = si.prod_id;
                    string qty = si.qty;
                    string Sno = si.sno;
                    cmd = new SqlCommand("update quotation_req_subdetails set productid=@prod_id, qty=@qty where sno=@sno");
                    cmd.Parameters.Add("@prod_id", prod_id);
                    cmd.Parameters.Add("@qty", qty);
                    cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                    cmd.Parameters.Add("@sno", Sno);
                    if (vdm.Update(cmd) == 0)
                    {
                        cmd = new SqlCommand("insert into quotation_req_subdetails (productid,qty,quotation_refno) values (@prod_id, @qty, @refno)");
                        cmd.Parameters.Add("@prod_id", prod_id);
                        cmd.Parameters.Add("@qty", qty);
                        cmd.Parameters.Add("@refno", sno);
                        cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                        vdm.insert(cmd);
                    }
                }
                string msg = "successfully Updated";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }

        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class quo_req_det
    {
        public string quo_no { get; set; }
        public string sup_name { get; set; }
        public string sup_id { get; set; }
        public string indent_ref { get; set; }
        public string quo_dt { get; set; }
        public string Add_ress { get; set; }
        public string street1 { get; set; }
        public string street2 { get; set; }
        public string city { get; set; }
        public string state { get; set; }
        public string sno { get; set; }
        public string btn_save { get; set; }
        public List<quo_prod_det> DataTable { get; set; }
    }

    public class quo_prod_det
    {
        public string prod_id { get; set; }
        public string prod_code { get; set; }
        public string sku { get; set; }
        public string prod_name { get; set; }
        public string desc { get; set; }
        public string uom { get; set; }
        public string uom1 { get; set; }
        public string qty { get; set; }
        public string refno { get; set; }
        public string sno { get; set; }
    }

    public class quotation_det
    {
        public List<quo_req_det> DataTable { get; set; }
        public List<quo_prod_det> DataTable1 { get; set; }
    }

    private void get_quotation_indent(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string indent_ref = context.Request["indent_ref"].ToString();
            cmd = new SqlCommand("SELECT i.qty,i.productid,p.productname,p.sku,p.uim as uom,u.uim from indent_subtable i join productmaster p on p.productid=i.productid join uimmaster u on u.sno=p.uim where indentno=@indent_ref");
            cmd.Parameters.Add("@indent_ref", indent_ref);
            DataTable dtpo = vdm.SelectQuery(cmd).Tables[0];
            List<quo_prod_det> workorderDetails = new List<quo_prod_det>();
            foreach (DataRow dr in dtpo.Rows)
            {
                quo_prod_det getworkorderreport = new quo_prod_det();
                getworkorderreport.prod_name = dr["productname"].ToString();
                getworkorderreport.desc = dr["productname"].ToString();
                getworkorderreport.qty = dr["qty"].ToString();
                getworkorderreport.sku = dr["sku"].ToString();
                getworkorderreport.uom = dr["uim"].ToString();
                getworkorderreport.uom1 = dr["uom"].ToString();
                getworkorderreport.prod_id = dr["productid"].ToString();
                workorderDetails.Add(getworkorderreport);
            }
            string response = GetJson(workorderDetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_quotation_req_det(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT qr.sno,qr.indentno,qr.quotationno,qr.quotationdate,qr.suplierid,s.name from quotation_request qr join suppliersdetails s on s.supplierid=qr.suplierid");
            DataTable dtpo = vdm.SelectQuery(cmd).Tables[0];
            List<quo_req_det> workorderDetails = new List<quo_req_det>();
            foreach (DataRow dr in dtpo.Rows)
            {
                quo_req_det getworkorderreport = new quo_req_det();
                getworkorderreport.sno = dr["sno"].ToString();
                string indentno=dr["indentno"].ToString();
                if (indentno == "0")
                {
                    getworkorderreport.indent_ref = "";
                }
                else {
                    getworkorderreport.indent_ref = dr["indentno"].ToString();
                }
                getworkorderreport.quo_no = dr["quotationno"].ToString();
                getworkorderreport.sup_name = dr["name"].ToString();
                getworkorderreport.quo_dt = ((DateTime)dr["quotationdate"]).ToString("dd-MM-yyyy");
                getworkorderreport.sup_id = dr["suplierid"].ToString();
                workorderDetails.Add(getworkorderreport);
            }
            string response = GetJson(workorderDetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_quotation_sub_det(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string refno = context.Request["refno"];
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT  qs.sno,qs.productid,p.productname,p.sku,u.uim,p.uim as uim1,qs.qty,qs.quotation_refno FROM quotation_req_subdetails qs join productmaster p on p.productid=qs.productid join uimmaster u on u.sno=p.uim WHERE quotation_refno=@refno");
            cmd.Parameters.Add("refno", refno);
            DataTable dtpo = vdm.SelectQuery(cmd).Tables[0];
            List<quo_prod_det> workorderDetails = new List<quo_prod_det>();
            foreach (DataRow dr in dtpo.Rows)
            {
                quo_prod_det getworkorderreport = new quo_prod_det();
                getworkorderreport.prod_name = dr["productname"].ToString();
                getworkorderreport.prod_id = dr["productid"].ToString();
                getworkorderreport.desc = dr["productname"].ToString();
                getworkorderreport.uom = dr["uim"].ToString();
                getworkorderreport.uom1 = dr["uim1"].ToString();
                getworkorderreport.qty = dr["qty"].ToString();
                getworkorderreport.sku = dr["sku"].ToString();
                getworkorderreport.refno = dr["quotation_refno"].ToString();
                getworkorderreport.sno = dr["sno"].ToString();
                workorderDetails.Add(getworkorderreport);
            }
            string response = GetJson(workorderDetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }



    private void get_quotation_req_date(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string from_date = context.Request["from_date"].ToString();
            string to_date = context.Request["to_date"].ToString();
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT qr.sno,qr.quotationno,qr.quotationdate,qr.suplierid,s.name from quotation_request qr join suppliersdetails s on s.supplierid=qr.suplierid where (qr.quotationdate BETWEEN @from_date AND @to_date)");
            cmd.Parameters.Add("@from_date", from_date);
            cmd.Parameters.Add("@to_date", to_date);
            DataTable dtpo = vdm.SelectQuery(cmd).Tables[0];
            List<quo_req_det> workorderDetails = new List<quo_req_det>();
            foreach (DataRow dr in dtpo.Rows)
            {
                quo_req_det getworkorderreport = new quo_req_det();
                getworkorderreport.sno = dr["sno"].ToString();
                getworkorderreport.quo_no = dr["quotationno"].ToString();
                getworkorderreport.sup_name = dr["name"].ToString();
                getworkorderreport.quo_dt = ((DateTime)dr["quotationdate"]).ToString("dd-MM-yyyy");
                getworkorderreport.sup_id = dr["suplierid"].ToString();
                workorderDetails.Add(getworkorderreport);
            }
            string response = GetJson(workorderDetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_quote_prod_Details(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string branchid = context.Session["Po_BranchID"].ToString();
            string rfq_no = context.Request["rfq_no"];

            cmd = new SqlCommand("select statename from branchmaster where branchid=@bid");
            cmd.Parameters.Add("@bid", branchid);
            DataTable dt_branch = vdm.SelectQuery(cmd).Tables[0];
            string state = dt_branch.Rows[0]["statename"].ToString();

            cmd = new SqlCommand("SELECT  quotationno FROM vendor_quotationdetails WHERE (quotationno = @quotationno )");
            cmd.Parameters.Add("@quotationno", rfq_no);
            DataTable dtqut = vdm.SelectQuery(cmd).Tables[0];
            if (dtqut.Rows.Count != 0)
            {
                cmd = new SqlCommand("SELECT suppliersdetails.stateid,productmaster.SGST, productmaster.CGST, productmaster.IGST, vendor_quotationdetails.sno AS vsno, vendor_quotationdetails.quotationno, vendor_quotationdetails.supplierid, vendor_quotationdetails.quotationdate, vendor_quotationdetails.branchid, vendor_quotationdetails.doe, vendor_quotationdetails.entryby, vendor_quotationdetails.modifiedby, vendor_quotationdetails.modifieddate, vendor_quotationdetails.pricebasis, vendor_quotationdetails.paymentmode, vendor_quotationdetails.despatchmode, vendor_quotationdetails.deliveryterms, vendor_quotationdetails.frieght, vendor_quotationdetails.transport, vendor_quotationdetails.insurance, vendor_quotationdetails.others, vendor_quotationdetails.billingto, vendor_quotationdetails.shipto, vendor_quotationdetails.pandf, vendor_quotationdetails.vqno, vendor_qtion_subdetails.sno AS vsubsno, vendor_qtion_subdetails.productid, vendor_qtion_subdetails.qty, vendor_qtion_subdetails.price, vendor_qtion_subdetails.vendorqtionrefno, vendor_qtion_subdetails.description, vendor_qtion_subdetails.uom, vendor_qtion_subdetails.discountpercentage, vendor_qtion_subdetails.discountamount, vendor_qtion_subdetails.taxtype, vendor_qtion_subdetails.taxpercentage, vendor_qtion_subdetails.exchangeduty, vendor_qtion_subdetails.edtaxpercentage, suppliersdetails.name, productmaster.productname, productmaster.sku, uimmaster.uim FROM vendor_quotationdetails INNER JOIN vendor_qtion_subdetails ON vendor_quotationdetails.sno = vendor_qtion_subdetails.vendorqtionrefno INNER JOIN suppliersdetails ON vendor_quotationdetails.supplierid = suppliersdetails.supplierid INNER JOIN productmaster ON vendor_qtion_subdetails.productid = productmaster.productid INNER JOIN uimmaster ON vendor_qtion_subdetails.uom = uimmaster.sno WHERE (vendor_quotationdetails.quotationno = @quo_no)");
                cmd.Parameters.Add("@quo_no", rfq_no);
                DataTable routes = vdm.SelectQuery(cmd).Tables[0];
                DataView view = new DataView(routes);
                DataTable dtvendor = view.ToTable(true, "paymentmode", "despatchmode", "deliveryterms", "frieght", "stateid", "transport", "insurance", "others", "billingto", "shipto", "pandf", "quotationno", "quotationdate", "supplierid", "name", "vqno", "vsno", "pricebasis");//"vendor_quotationno", "vendor_quotationdate", 
                DataTable dtvendor_subdetails = view.ToTable(true, "productname", "sku", "SGST", "CGST", "IGST", "stateid", "vsubsno", "discountamount", "discountpercentage", "taxtype", "taxpercentage", "exchangeduty", "edtaxpercentage", "qty", "price", "vendorqtionrefno", "description", "uim", "uom", "productid");
                List<vendor_det> vendor_list = new List<vendor_det>();
                List<vendor_quo_det> vendor_quo_list = new List<vendor_quo_det>();
                List<vendor_prod_det> vendor_prod_list = new List<vendor_prod_det>();
                foreach (DataRow dr in dtvendor.Rows)
                {
                    vendor_quo_det getpurchasedetails = new vendor_quo_det();
                    getpurchasedetails.quo_no = dr["quotationno"].ToString();
                    getpurchasedetails.payment_type = dr["paymentmode"].ToString();
                    getpurchasedetails.dispatch_mode = dr["despatchmode"].ToString();
                    getpurchasedetails.delivery_terms = dr["deliveryterms"].ToString();
                    getpurchasedetails.freight_amt = dr["frieght"].ToString();
                    getpurchasedetails.transport_chrgs = dr["transport"].ToString();
                    getpurchasedetails.insurance_chrgs = dr["insurance"].ToString();
                    getpurchasedetails.other_chrgs = dr["others"].ToString();
                    getpurchasedetails.billing_addr = dr["billingto"].ToString();
                    getpurchasedetails.delivery_addr = dr["shipto"].ToString();
                    getpurchasedetails.pandf = dr["pandf"].ToString();
                    getpurchasedetails.sup_name = dr["name"].ToString();
                    getpurchasedetails.sup_id = dr["supplierid"].ToString();
                    getpurchasedetails.sup_state = dr["stateid"].ToString();
                    getpurchasedetails.price_basis = dr["pricebasis"].ToString();
                    getpurchasedetails.vendor_quo_no = dr["vqno"].ToString();
                    getpurchasedetails.sno = dr["vsno"].ToString();
                    getpurchasedetails.quo_dt = ((DateTime)dr["quotationdate"]).ToString("yyyy-MM-dd");
                    vendor_quo_list.Add(getpurchasedetails);
                }
                foreach (DataRow dr in dtvendor_subdetails.Rows)
                {
                    vendor_prod_det getroutes = new vendor_prod_det();
                    getroutes.prod_name = dr["productname"].ToString();
                    getroutes.prod_id = dr["productid"].ToString();
                    getroutes.desc = dr["description"].ToString();
                    getroutes.price = dr["price"].ToString();
                    getroutes.dis_per = dr["discountpercentage"].ToString();
                    getroutes.dis_amt = dr["discountamount"].ToString();
                    getroutes.tax_type = dr["taxtype"].ToString();
                    getroutes.tax_per = dr["taxpercentage"].ToString();
                    getroutes.ed = dr["exchangeduty"].ToString();
                    getroutes.ed_tax_per = dr["edtaxpercentage"].ToString();
                    getroutes.uom = dr["uom"].ToString();
                    getroutes.uim = dr["uim"].ToString();
                    getroutes.sku = dr["sku"].ToString();
                    getroutes.qty = dr["qty"].ToString();
                    string sup_state = dr["stateid"].ToString();
                    if (state == sup_state)
                    {
                        getroutes.sgst = dr["SGST"].ToString();
                        getroutes.cgst = dr["CGST"].ToString();
                        getroutes.igst = "0";
                    }
                    else {
                        getroutes.sgst = "0";
                        getroutes.cgst = "0";
                        getroutes.igst = dr["IGST"].ToString();
                    }
                    getroutes.sno = dr["vsubsno"].ToString();
                    getroutes.refno = dr["vendorqtionrefno"].ToString();
                    vendor_prod_list.Add(getroutes);
                }
                vendor_det get_vendor_det = new vendor_det();
                get_vendor_det.DataTable = vendor_quo_list;
                get_vendor_det.DataTable1 = vendor_prod_list;
                vendor_list.Add(get_vendor_det);
                string response = GetJson(vendor_list);
                context.Response.Write(response);
            }
            else
            {
                cmd = new SqlCommand("SELECT p.SGST,p.CGST,p.IGST,sd.stateid,sd.name,q.quotationdate,q.suplierid,p.productname,p.sku,p.uim as uom,u.uim,p.price,qs.productid, qs.qty from quotation_req_subdetails qs join quotation_request q on qs.quotation_refno=q.sno join productmaster p on p.productid=qs.productid join uimmaster u on u.sno=p.uim join suppliersdetails sd on sd.supplierid=q.suplierid where q.quotationno=@quo_no");
                cmd.Parameters.Add("@quo_no", rfq_no);
                DataTable routes = vdm.SelectQuery(cmd).Tables[0];
                DataView view = new DataView(routes);
                DataTable dtvendor = view.ToTable(true, "quotationdate", "suplierid", "name");
                DataTable dtvendor_subdetails = view.ToTable(true, "productname", "stateid", "sku", "SGST", "CGST", "IGST", "qty", "price", "uom", "uim", "productid");
                List<vendor_det> vendor_list = new List<vendor_det>();
                List<vendor_quo_det> vendor_quo_list = new List<vendor_quo_det>();
                List<vendor_prod_det> vendor_prod_list = new List<vendor_prod_det>();
                foreach (DataRow dr in dtvendor.Rows)
                {
                    vendor_quo_det getpurchasedetails = new vendor_quo_det();
                    getpurchasedetails.sup_name = dr["name"].ToString();
                    getpurchasedetails.sup_id = dr["suplierid"].ToString();
                    getpurchasedetails.quo_dt = ((DateTime)dr["quotationdate"]).ToString("yyyy-MM-dd");
                    vendor_quo_list.Add(getpurchasedetails);
                }
                foreach (DataRow dr in dtvendor_subdetails.Rows)
                {
                    vendor_prod_det getroutes = new vendor_prod_det();
                    getroutes.prod_name = dr["productname"].ToString();
                    getroutes.prod_id = dr["productid"].ToString();
                    getroutes.price = dr["price"].ToString();
                    getroutes.uom = dr["uom"].ToString();
                    getroutes.uim = dr["uim"].ToString();
                    getroutes.sku = dr["sku"].ToString();
                    getroutes.qty = dr["qty"].ToString();
                    string sup_state = dr["stateid"].ToString();
                    if (state == sup_state)
                    {
                        getroutes.sgst = dr["SGST"].ToString();
                        getroutes.cgst = dr["CGST"].ToString();
                        getroutes.igst = "0";
                    }
                    else
                    {
                        getroutes.sgst = "0";
                        getroutes.cgst = "0";
                        getroutes.igst = dr["IGST"].ToString();
                    }
                    //getroutes.sgst = dr["SGST"].ToString();
                    //getroutes.cgst = dr["CGST"].ToString();
                    //getroutes.igst = dr["IGST"].ToString();
                    vendor_prod_list.Add(getroutes);
                }
                vendor_det get_vendor_det = new vendor_det();
                get_vendor_det.DataTable = vendor_quo_list;
                get_vendor_det.DataTable1 = vendor_prod_list;
                vendor_list.Add(get_vendor_det);
                string response = GetJson(vendor_list);
                context.Response.Write(response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_quotation_details_click(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string QuoRefNo = context.Request["refdcno"];
            string branchid = context.Session["Po_BranchID"].ToString();
            string Add_ress = context.Session["Address"].ToString();
            vdm = new SalesDBManager();
            cmd = new SqlCommand("SELECT qr.sno,qr.quotationno,qr.quotationdate,qr.suplierid,s.name,s.street1,s.street2,s.city,s.state,qs.productid,p.productname,p.sku,p.description,u.uim,p.uim as uim1,qs.qty,qs.quotation_refno from quotation_request qr join quotation_req_subdetails qs on qr.sno=qs.quotation_refno join suppliersdetails s on s.supplierid=qr.suplierid join productmaster p on p.productid=qs.productid join uimmaster u on u.sno=p.uim where qr.quotationno=@QuoRefNo");
            cmd.Parameters.Add("@QuoRefNo", QuoRefNo);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(routes);
            DataTable dtpo = view.ToTable(true, "quotationno", "quotationdate", "name", "suplierid", "street1", "street2", "city", "state");
            DataTable dtpurchase_subdetails = view.ToTable(true, "productname", "sku", "description", "productid", "uim", "uim1", "qty", "quotation_refno");
            List<quotation_det> quo_det = new List<quotation_det>();
            List<quo_req_det> quo_req = new List<quo_req_det>();
            List<quo_prod_det> quo_prod = new List<quo_prod_det>();
            foreach (DataRow dr in dtpo.Rows)
            {
                quo_req_det getpurchasedetails = new quo_req_det();
                getpurchasedetails.quo_no = dr["quotationno"].ToString();
                getpurchasedetails.sup_name = dr["name"].ToString();
                getpurchasedetails.sup_id = dr["suplierid"].ToString();
                getpurchasedetails.street1 = dr["street1"].ToString();
                getpurchasedetails.street2 = dr["street2"].ToString();
                getpurchasedetails.city = dr["city"].ToString();
                getpurchasedetails.state = dr["state"].ToString();
                getpurchasedetails.quo_dt = ((DateTime)dr["quotationdate"]).ToString("dd/MM/yyyy");
                getpurchasedetails.Add_ress = Add_ress;
                quo_req.Add(getpurchasedetails);
            }
            foreach (DataRow dr in dtpurchase_subdetails.Rows)
            {
                quo_prod_det getroutes = new quo_prod_det();
                getroutes.prod_name = dr["productname"].ToString();
                getroutes.prod_code = dr["sku"].ToString();
                getroutes.desc = dr["description"].ToString();
                getroutes.prod_id = dr["productid"].ToString();
                getroutes.uom = dr["uim"].ToString();
                getroutes.uom1 = dr["uim1"].ToString();
                getroutes.qty = dr["qty"].ToString();
                getroutes.refno = dr["quotation_refno"].ToString();
                quo_prod.Add(getroutes);
            }
            quotation_det get_purchases = new quotation_det();
            get_purchases.DataTable = quo_req;
            get_purchases.DataTable1 = quo_prod;
            quo_det.Add(get_purchases);
            string response = GetJson(quo_det);
            context.Response.Write(response);
        }
        catch
        {
        }
    }

    private void save_vendor_quote(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            var js = new JavaScriptSerializer();
            var title1 = context.Request.Params[1];
            vendor_quo_det obj = js.Deserialize<vendor_quo_det>(title1);
            string dispatch_mode = obj.dispatch_mode;
            string sup_name = obj.sup_name;
            string quotationno = obj.rfq_no;
            string pandf = obj.pandf;
            string freight_amt = obj.freight_amt;
            string transport_chrgs = obj.transport_chrgs;
            string delivery_terms = obj.delivery_terms;
            string payment_type = obj.payment_type;
            string delivery_addr = obj.delivery_addr;
            string billing_addr = obj.billing_addr;
            string insurance_chrgs = obj.insurance_chrgs;
            string other_chrgs = obj.other_chrgs;
            string ven_quo_no = obj.ven_quo_no;
            string price_basis = obj.price_basis;
            DateTime quo_dt = Convert.ToDateTime(obj.quo_dt);
            string sno = obj.sno;
            string entryby = context.Session["Employ_Sno"].ToString();
            string branchid = context.Session["Po_BranchID"].ToString();
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string btn_save = obj.btn_save;
            if (btn_save == "Save")
            {
                cmd = new SqlCommand("insert into vendor_quotationdetails (vqno,quotationno,supplierid,quotationdate,branchid,doe,entryby,pricebasis,paymentmode,despatchmode,deliveryterms,shipto,billingto,pandf,frieght,transport,insurance,others) values (@ven_quo_no,@quotationno,@sup_id,@quo_dt,@branchid,@doe,@entryby,@price_basis,@payment_type,@dispatch_mode,@delivery_terms,@delivery_addr,@billing_addr,@pandf,@freight_amt,@transport_chrgs,@insurance_chrgs,@other_chrgs)");
                cmd.Parameters.Add("@quotationno", quotationno);
                cmd.Parameters.Add("@ven_quo_no", ven_quo_no);
                cmd.Parameters.Add("@sup_id", sup_name);
                cmd.Parameters.Add("@quo_dt", quo_dt);
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@price_basis", price_basis);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@entryby", entryby);
                cmd.Parameters.Add("@payment_type", payment_type);
                cmd.Parameters.Add("@delivery_terms", delivery_terms);
                cmd.Parameters.Add("@delivery_addr", delivery_addr);
                cmd.Parameters.Add("@billing_addr", billing_addr);
                cmd.Parameters.Add("@pandf", pandf);
                cmd.Parameters.Add("@dispatch_mode", dispatch_mode);
                cmd.Parameters.Add("@freight_amt", freight_amt);
                cmd.Parameters.Add("@transport_chrgs", transport_chrgs);
                cmd.Parameters.Add("@insurance_chrgs", insurance_chrgs);
                cmd.Parameters.Add("@other_chrgs", other_chrgs);
                vdm.insert(cmd);
                cmd = new SqlCommand("select MAX(sno) AS sno from vendor_quotationdetails ");
                DataTable routes = vdm.SelectQuery(cmd).Tables[0];
                string refno = routes.Rows[0]["sno"].ToString();//tax_gl_code
                foreach (vendor_prod_det si in obj.DataTable)
                {
                    string prod_id = si.prod_id;
                    if (prod_id != null)
                    {
                        string qty = si.qty;
                        string price = si.price;
                        string dis_per = si.dis_per;
                        string dis_amt = si.dis_amt;
                        //string tax_type = si.tax_type;
                        //if (tax_type == null)
                        //{
                        //    tax_type = "";
                        //}
                        //string tax_per = si.tax_per;
                        //string ed = si.ed;
                        //if (ed == null)
                        //{
                        //    ed = "";
                        //}
                        //string ed_tax_per = si.ed_tax_per;
                        string desc = si.desc;
                        string uom = si.uom;
                        string Sno = si.sno;
                        cmd = new SqlCommand("insert into vendor_qtion_subdetails (productid,qty,price,vendorqtionrefno,discountpercentage,discountamount,description,uom) values (@prod_code, @qty, @price, @refno, @dis_per, @dis_amt, @desc, @uom)");
                        cmd.Parameters.Add("@prod_code", prod_id);
                        cmd.Parameters.Add("@qty", qty);
                        cmd.Parameters.Add("@desc", desc);
                        cmd.Parameters.Add("@uom", uom);
                        cmd.Parameters.Add("@price", price);
                        cmd.Parameters.Add("@dis_per", dis_per);
                        cmd.Parameters.Add("@dis_amt", dis_amt);
                        //cmd.Parameters.Add("@tax_type", tax_type);
                        //cmd.Parameters.Add("@tax_per", tax_per);
                        //cmd.Parameters.Add("@ed_tax_per", ed_tax_per);
                        //cmd.Parameters.Add("@ed", ed);
                        cmd.Parameters.Add("@refno", refno);
                        cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                        //cmd.Parameters.Add("@sgst", sgst);
                        //cmd.Parameters.Add("@cgst", cgst);
                        //cmd.Parameters.Add("@igst", igst);
                        vdm.insert(cmd);
                    }
                }
                string msg = "successfully saved";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
            else
            {
                cmd = new SqlCommand("UPDATE vendor_quotationdetails SET supplierid=@sup_id,quotationdate=@quo_dt,modifiedby=@modifiedby,modifieddate=@modifieddate,pricebasis=@price_basis,paymentmode=@payment_type,despatchmode=@dispatch_mode,deliveryterms=@delivery_terms,shipto=@delivery_addr,billingto=@billing_addr,pandf=@pandf,frieght=@freight_amt,transport=@transport_chrgs,insurance=@insurance_chrgs,others=@other_chrgs WHERE sno=@sno");
                cmd.Parameters.Add("@sup_id", sup_name);
                cmd.Parameters.Add("@quo_dt", quo_dt);
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                cmd.Parameters.Add("@modifiedby", entryby);
                cmd.Parameters.Add("@price_basis", price_basis);
                cmd.Parameters.Add("@modifieddate", ServerDateCurrentdate);
                cmd.Parameters.Add("@sno", sno);
                cmd.Parameters.Add("@payment_type", payment_type);
                cmd.Parameters.Add("@delivery_terms", delivery_terms);
                cmd.Parameters.Add("@delivery_addr", delivery_addr);
                cmd.Parameters.Add("@billing_addr", billing_addr);
                cmd.Parameters.Add("@pandf", pandf);
                cmd.Parameters.Add("@dispatch_mode", dispatch_mode);
                cmd.Parameters.Add("@freight_amt", freight_amt);
                cmd.Parameters.Add("@transport_chrgs", transport_chrgs);
                cmd.Parameters.Add("@insurance_chrgs", insurance_chrgs);
                cmd.Parameters.Add("@other_chrgs", other_chrgs);
                vdm.Update(cmd);
                foreach (vendor_prod_det si in obj.DataTable)
                {
                    string prod_id = si.prod_id;
                    if (prod_id != null)
                    {
                        string qty = si.qty;
                        string price = si.price;
                        string dis_per = si.dis_per;
                        string dis_amt = si.dis_amt;
                        //string tax_type = si.tax_type;
                        //string tax_per = si.tax_per;
                        //string ed = si.ed;
                        //string ed_tax_per = si.ed_tax_per;
                        string desc = si.desc;
                        string uom = si.uom;
                        string Sno = si.sno;
                        cmd = new SqlCommand("update vendor_qtion_subdetails set productid=@prod_code, qty=@qty, price=@price, description=@desc, uom=@uom, vendorqtionrefno=@refno, discountpercentage=@dis_per, discountamount=@dis_amt where sno=@sno");//, freightamount=@freight, taxtype=@tax_type, taxpercentage=@tax_per, edtaxpercentage=@ed_tax_per, exchangeduty=@ed
                        cmd.Parameters.Add("@prod_code", prod_id);
                        cmd.Parameters.Add("@qty", qty);
                        cmd.Parameters.Add("@desc", desc);
                        cmd.Parameters.Add("@uom", uom);
                        cmd.Parameters.Add("@price", price);
                        cmd.Parameters.Add("@dis_per", dis_per);
                        cmd.Parameters.Add("@dis_amt", dis_amt);
                        //cmd.Parameters.Add("@tax_type", tax_type);
                        //cmd.Parameters.Add("@tax_per", tax_per);
                        //cmd.Parameters.Add("@ed_tax_per", ed_tax_per);
                        //cmd.Parameters.Add("@ed", ed);
                        cmd.Parameters.Add("@sno", Sno);
                        cmd.Parameters.Add("@refno", sno);
                        cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                        if (vdm.Update(cmd) == 0)
                        {
                            cmd = new SqlCommand("insert into vendor_qtion_subdetails (productid,qty,price,vendorqtionrefno,discountpercentage,discountamount,description,uom) values (@prod_code, @qty, @price, @refno, @dis_per, @dis_amt, @desc, @uom)");
                            cmd.Parameters.Add("@prod_code", prod_id);
                            cmd.Parameters.Add("@qty", qty);
                            cmd.Parameters.Add("@desc", desc);
                            cmd.Parameters.Add("@uom", uom);
                            cmd.Parameters.Add("@price", price);
                            cmd.Parameters.Add("@dis_per", dis_per);
                            cmd.Parameters.Add("@dis_amt", dis_amt);
                            //cmd.Parameters.Add("@tax_type", tax_type);
                            //cmd.Parameters.Add("@tax_per", tax_per);
                            //cmd.Parameters.Add("@ed_tax_per", ed_tax_per);
                            //cmd.Parameters.Add("@ed", ed);
                            cmd.Parameters.Add("@refno", sno);
                            cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                        }
                    }

                }
                string msg = "successfully Updated";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }

        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class vendor_quo_det
    {
        public string sup_id { get; set; }
        public string sup_name { get; set; }
        public string sup_state { get; set; }
        public string sup_comp_name { get; set; }
        public string price_basis { get; set; }
        public string rfq_no { get; set; }
        public string quo_no { get; set; }
        public string ven_quo_no { get; set; }
        public string pandf { get; set; }
        public string freight_amt { get; set; }
        public string transport_chrgs { get; set; }
        public string delivery_terms { get; set; }
        public string payment_type { get; set; }
        public string delivery_addr { get; set; }
        public string billing_addr { get; set; }
        public string insurance_chrgs { get; set; }
        public string other_chrgs { get; set; }
        public string quo_dt { get; set; }
        public string indent_no { get; set; }
        public string vendor_quo_no { get; set; }
        public string vendor_date { get; set; }
        public string vendor_quo_dt { get; set; }
        public string sno { get; set; }
        public string dispatch_mode { get; set; }
        public string Add_ress { get; set; }
        public string doe { get; set; }
        public string btn_save { get; set; }
        public List<vendor_prod_det> DataTable { get; set; }
    }

    public class vendor_prod_det
    {
        public string prod_id { get; set; }
        public string desc { get; set; }
        public string pandf { get; set; }
        public string uom { get; set; }
        public string uim { get; set; }
        public string price { get; set; }
        public string dis_per { get; set; }
        public string dis_amt { get; set; }
        public string tax_type { get; set; }
        public string tax_type_id { get; set; }
        public string tax_per { get; set; }
        public string freight { get; set; }
        public string transport { get; set; }
        public string ed { get; set; }
        public string ed_id { get; set; }
        public string ed_tax_per { get; set; }
        public string qty { get; set; }
        public string sno { get; set; }
        public string refno { get; set; }
        public string sku { get; set; }
        public string sgst { get; set; }
        public string cgst { get; set; }
        public string igst { get; set; }
        public string hsncode { get; set; }
        public string gst_exists { get; set; }
        public string prod_name { get; set; }
    }

    public class vendor_det
    {
        public List<vendor_quo_det> DataTable { get; set; }
        public List<vendor_prod_det> DataTable1 { get; set; }
    }
    private void btn_Vendor_Details_click(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string quote_date = context.Request["quote_date"].ToString();
            string indent_no = context.Request["indent_no"].ToString();
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT s.name,q.quotationno,q.suplierid,q.indentno,q.quotationdate from quotation_request q join suppliersdetails s on s.supplierid=q.suplierid where q.quotationdate=@quote_date AND q.indentno=@indent_no");
            cmd.Parameters.Add("@indent_no", indent_no);
            cmd.Parameters.Add("@quote_date", quote_date);
            DataTable dtpo = vdm.SelectQuery(cmd).Tables[0];
            List<vendor_quo_det> workorderDetails = new List<vendor_quo_det>();
            foreach (DataRow dr in dtpo.Rows)
            {
                vendor_quo_det getworkorderreport = new vendor_quo_det();
                getworkorderreport.quo_no = dr["quotationno"].ToString();
                getworkorderreport.sup_name = dr["name"].ToString();
                getworkorderreport.quo_dt = ((DateTime)dr["quotationdate"]).ToString("yyyy-MM-dd");
                getworkorderreport.sup_id = dr["suplierid"].ToString();
                getworkorderreport.indent_no = dr["indentno"].ToString();
                workorderDetails.Add(getworkorderreport);
            }
            string response = GetJson(workorderDetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_Vendor_Data(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string quote_date = context.Request["quote_date"].ToString();
            string indent_no = context.Request["indent_no"].ToString();
            string branchid = context.Session["Po_BranchID"].ToString();
            string sup_id = context.Request["sup_id"].ToString();
            cmd = new SqlCommand("select sup.name,addr.address,ed.taxtype as edtype,tm.taxtype,vq.despatchmode,addr1.address as address1,pm.productname,pay.paymenttype,dt.deliveryterms,pf.pandf,vq.quotationno,vq.quotationdate,vq.supplierid,vq.pricebasis,vq.frieght,vq.transport,vq.insurance,vq.others,vq.pandf,vsq.productid,vsq.qty,vsq.taxtype,vsq.price,vsq.discountamount,vsq.discountpercentage,vsq.taxpercentage,vsq.edtaxpercentage from vendor_quotationdetails vq join vendor_qtion_subdetails vsq on vq.sno=vsq.vendorqtionrefno join pandf pf on vq.pandf=pf.sno join suppliersdetails sup on vq.supplierid=sup.supplierid join paymentmaster pay on vq.paymentmode=pay.sno join deliveryterms dt on vq.deliveryterms=dt.sno join addressdetails addr on vq.billingto=addr.sno join addressdetails as addr1 on vq.shipto=addr1.sno join productmaster pm on vsq.productid=pm.productid join taxmaster tm on vsq.taxtype=tm.sno join taxmaster as ed on vsq.exchangeduty=ed.sno join quotation_request qr on vq.quotationno=qr.quotationno where vq.supplierid=@sup_id AND vq.quotationdate=@quote_date AND qr.indentno=@indentno");
            cmd.Parameters.Add("@indentno", indent_no);
            cmd.Parameters.Add("@quote_date", quote_date);
            cmd.Parameters.Add("@sup_id", sup_id);
            DataTable dtpo = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(dtpo);
            DataTable dtvendor = view.ToTable(true, "address", "address1", "paymenttype", "despatchmode", "deliveryterms", "frieght", "transport", "insurance", "others", "pandf", "quotationno", "quotationdate", "supplierid", "name", "pricebasis");//"vendor_quotationno", "vendor_quotationdate",  "vsno",
            DataTable dtvendor_subdetails = view.ToTable(true, "productname", "discountamount", "discountpercentage", "taxtype", "taxpercentage", "edtype", "edtaxpercentage", "qty", "price", "productid");
            List<vendor_det> vendor_list = new List<vendor_det>();
            List<vendor_quo_det> vendor_quo_list = new List<vendor_quo_det>();
            List<vendor_prod_det> vendor_prod_list = new List<vendor_prod_det>();
            foreach (DataRow dr in dtvendor.Rows)
            {
                vendor_quo_det getworkorderreport = new vendor_quo_det();
                getworkorderreport.billing_addr = dr["address"].ToString();
                getworkorderreport.delivery_addr = dr["address1"].ToString();
                getworkorderreport.quo_no = dr["quotationno"].ToString();
                getworkorderreport.sup_name = dr["name"].ToString();
                getworkorderreport.payment_type = dr["paymenttype"].ToString();
                getworkorderreport.dispatch_mode = dr["despatchmode"].ToString();
                getworkorderreport.delivery_terms = dr["deliveryterms"].ToString();
                getworkorderreport.freight_amt = dr["frieght"].ToString();
                getworkorderreport.transport_chrgs = dr["transport"].ToString();
                getworkorderreport.insurance_chrgs = dr["insurance"].ToString();
                getworkorderreport.other_chrgs = dr["others"].ToString();
                getworkorderreport.quo_dt = ((DateTime)dr["quotationdate"]).ToString("yyyy-MM-dd");
                getworkorderreport.sup_id = dr["supplierid"].ToString();
                getworkorderreport.price_basis = dr["pricebasis"].ToString();
                getworkorderreport.pandf = dr["pandf"].ToString();
                vendor_quo_list.Add(getworkorderreport);
            }
            foreach (DataRow dr in dtvendor_subdetails.Rows)
            {
                vendor_prod_det getworkorderreport = new vendor_prod_det();
                getworkorderreport.prod_name = dr["productname"].ToString();
                getworkorderreport.dis_amt = dr["discountamount"].ToString();
                getworkorderreport.dis_per = dr["discountpercentage"].ToString();
                getworkorderreport.tax_type = dr["taxtype"].ToString();
                getworkorderreport.tax_per = dr["taxpercentage"].ToString();
                getworkorderreport.ed = dr["edtype"].ToString();
                getworkorderreport.ed_tax_per = dr["edtaxpercentage"].ToString();
                getworkorderreport.qty = dr["qty"].ToString();
                getworkorderreport.price = dr["price"].ToString();
                getworkorderreport.prod_id = dr["productid"].ToString();
                vendor_prod_list.Add(getworkorderreport);
            }
            vendor_det get_vendor_det = new vendor_det();
            get_vendor_det.DataTable = vendor_quo_list;
            get_vendor_det.DataTable1 = vendor_prod_list;
            vendor_list.Add(get_vendor_det);
            string response = GetJson(vendor_list);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_vendor_quotation_date(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string from_date = context.Request["from_date"].ToString();
            string to_date = context.Request["to_date"].ToString();
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT vq.sno,vq.quotationno,sd.name,vq.supplierid,vq.quotationdate from vendor_quotationdetails vq join suppliersdetails sd on sd.supplierid=vq.supplierid where (vq.quotationdate BETWEEN @from_date AND @to_date)");
            cmd.Parameters.Add("@from_date", from_date);
            cmd.Parameters.Add("@to_date", to_date);
            DataTable dtpo = vdm.SelectQuery(cmd).Tables[0];
            List<vendor_quo_det> workorderDetails = new List<vendor_quo_det>();
            foreach (DataRow dr in dtpo.Rows)
            {
                vendor_quo_det getworkorderreport = new vendor_quo_det();
                getworkorderreport.sno = dr["sno"].ToString();
                getworkorderreport.quo_no = dr["quotationno"].ToString();
                getworkorderreport.sup_name = dr["name"].ToString();
                getworkorderreport.quo_dt = ((DateTime)dr["quotationdate"]).ToString("dd-MM-yyyy");
                getworkorderreport.sup_id = dr["supplierid"].ToString();
                workorderDetails.Add(getworkorderreport);
            }
            string response = GetJson(workorderDetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_vendor_quotation_det_click(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string julydt = "07/01/2017";
            DateTime gst_dt = Convert.ToDateTime(julydt);
            string QuoRefNo = context.Request["refdcno"];
            string branchid = context.Session["Po_BranchID"].ToString();
            string Add_ress = context.Session["Address"].ToString();
            vdm = new SalesDBManager();
            cmd = new SqlCommand("SELECT sd.stateid,pm.sgst,pm.cgst,pm.igst,pm.HSNcode,pf.pandf,vq.sno,vq.doe,vq.frieght,vq.vqno,vq.transport,vq.quotationno,sd.name,vq.supplierid,vq.quotationdate,pm.productname,vs.productid,vs.qty,vs.price,vs.description,u.uim,vs.uom,vs.discountpercentage,vs.discountamount,vs.taxtype,vs.taxpercentage,vs.exchangeduty,vs.edtaxpercentage,vs.vendorqtionrefno from vendor_quotationdetails vq inner join vendor_qtion_subdetails vs on vq.sno=vs.vendorqtionrefno join suppliersdetails sd on sd.supplierid=vq.supplierid inner join productmaster pm on pm.productid=vs.productid left outer join uimmaster u on u.sno=vs.uom left outer join pandf pf on vq.pandf=pf.sno where (vq.quotationno=@QuoRefNo) and (vq.branchid=@branchid)");
            cmd.Parameters.Add("@QuoRefNo", QuoRefNo);
            cmd.Parameters.Add("@branchid", branchid);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(routes);
            DataTable dtpo = view.ToTable(true, "vqno", "stateid", "quotationdate", "name", "supplierid");
            DataTable dtpurchase_subdetails = view.ToTable(true, "frieght", "transport", "pandf", "doe", "HSNcode", "sgst", "cgst", "igst", "productname", "productid", "description", "price", "uom", "uim", "qty", "discountpercentage", "discountamount", "taxtype", "taxpercentage", "exchangeduty", "edtaxpercentage", "vendorqtionrefno");
            List<vendor_det> ven_det = new List<vendor_det>();
            List<vendor_quo_det> ven_req = new List<vendor_quo_det>();
            List<vendor_prod_det> ven_prod = new List<vendor_prod_det>();
            cmd = new SqlCommand("select statename from branchmaster where branchid=@branchid");
            cmd.Parameters.Add("@branchid", branchid);
            DataTable dt_branch = vdm.SelectQuery(cmd).Tables[0];
            string branch_state = dt_branch.Rows[0]["statename"].ToString();
            string sup_stateid = "";
            foreach (DataRow dr in dtpo.Rows)
            {
                vendor_quo_det getpurchasedetails = new vendor_quo_det();
                getpurchasedetails.quo_no = dr["vqno"].ToString();
                getpurchasedetails.sup_name = dr["name"].ToString();
                getpurchasedetails.sup_id = dr["supplierid"].ToString();
                getpurchasedetails.quo_dt = ((DateTime)dr["quotationdate"]).ToString("dd/MM/yyyy");
                sup_stateid = dr["stateid"].ToString();
                getpurchasedetails.Add_ress = Add_ress;
                ven_req.Add(getpurchasedetails);
            }
            foreach (DataRow dr in dtpurchase_subdetails.Rows)
            {
                vendor_prod_det getroutes = new vendor_prod_det();
                string doe1 = ((DateTime)dr["doe"]).ToString();
                //string podate1 = "7/17/2017 12:00:00 AM";
                DateTime doe = Convert.ToDateTime(doe1);
                if (doe < gst_dt)
                {
                    getroutes.ed = dr["exchangeduty"].ToString();
                    getroutes.ed_tax_per = dr["edtaxpercentage"].ToString();
                    getroutes.tax_type = dr["taxtype"].ToString();
                    getroutes.tax_per = dr["taxpercentage"].ToString();
                    getroutes.gst_exists = "0";
                }
                else
                {
                    if (branch_state == sup_stateid)
                    {
                        getroutes.sgst = dr["sgst"].ToString();
                        getroutes.cgst = dr["cgst"].ToString();
                        getroutes.igst = "0";
                    }
                    else
                    {
                        getroutes.sgst = "0";
                        getroutes.cgst = "0";
                        getroutes.igst = dr["igst"].ToString();
                    }
                    getroutes.hsncode = dr["HSNcode"].ToString();
                    getroutes.gst_exists = "1";
                }
                getroutes.prod_name = dr["productname"].ToString();
                getroutes.prod_id = dr["productid"].ToString();
                getroutes.desc = dr["description"].ToString();
                getroutes.price = dr["price"].ToString();
                getroutes.dis_per = dr["discountpercentage"].ToString();
                getroutes.dis_amt = dr["discountamount"].ToString();
                getroutes.pandf = dr["pandf"].ToString();
                getroutes.freight = dr["frieght"].ToString();
                getroutes.transport = dr["transport"].ToString();
                getroutes.uom = dr["uom"].ToString();
                getroutes.uim = dr["uim"].ToString();
                getroutes.qty = dr["qty"].ToString();
                getroutes.refno = dr["vendorqtionrefno"].ToString();
                ven_prod.Add(getroutes);
            }
            vendor_det get_purchases = new vendor_det();
            get_purchases.DataTable = ven_req;
            get_purchases.DataTable1 = ven_prod;
            ven_det.Add(get_purchases);
            string response = GetJson(ven_det);
            context.Response.Write(response);
        }
        catch
        {
        }
    }

    public class MonthWiseChart
    {
        public string Month { get; set; }
        public string StoresValue { get; set; }
        public string branchid { get; set; }
    }

    private void Get_Month_Comparison_Chart(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            DataTable Report = new DataTable();
            DateTime doe = SalesDBManager.GetTime(vdm.conn);
            string fromyear = context.Request["fromyear"];
            string toyear = context.Request["toyear"];
            string mymonth = context.Request["mymonth"];
            string tomonth = context.Request["tomonth"];
            int FromYear = 0;
            int.TryParse(fromyear, out FromYear);
            int ToYear = 0;
            int.TryParse(toyear, out ToYear);
            int Month = 0;
            int.TryParse(mymonth, out Month);
            int ToMonth = 0;
            int.TryParse(tomonth, out ToMonth);
            int fromdays = DateTime.DaysInMonth(FromYear, Month);
            int todays = DateTime.DaysInMonth(ToYear, ToMonth);
            string dtFromdate = mymonth + "/" + 1 + "/" + FromYear;
            string dtTodate = mymonth + "/" + fromdays + "/" + ToYear;
            string dtdate = tomonth + "/" + 1 + "/" + FromYear;
            string dttdate = tomonth + "/" + todays + "/" + ToYear;
            DateTime fromdate = Convert.ToDateTime(dtFromdate);
            DateTime todate = Convert.ToDateTime(dttdate);
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT UPPER(LEFT(DATENAME(MONTH, po.podate), 3)) AS Month FROM po_entrydetailes po join po_sub_detailes pos on po.sno=pos.po_refno where po.branchid=branchid AND (po.podate BETWEEN @d1 AND @d2) ");
            cmd.Parameters.Add("@d1", GetLowDate(fromdate));
            cmd.Parameters.Add("@d2", GetHighDate(todate));
            DataTable dttotalinward = vdm.SelectQuery(cmd).Tables[0];
            List<MonthWiseChart> MonthWiseChartlist = new List<MonthWiseChart>();
            string mon1 = ""; string Res = ""; string Res1 = "";
            string val1 = ""; string Res2 = "";
            foreach (DataRow dr in dttotalinward.Rows)
            {
                mon1 = dr["Month"].ToString();
                val1 = dr["value"].ToString();
                Res += mon1 + ",";
                Res2 += val1 + ",";
                Res1 += "Amount" + ",";
            }
            MonthWiseChart getlinechart = new MonthWiseChart();
            getlinechart.Month = Res.ToString();
            getlinechart.StoresValue = Res2.Substring(0, Res2.Length - 1);// Res2.ToString();
            MonthWiseChartlist.Add(getlinechart);
            string response = GetJson(MonthWiseChartlist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class Total_Count
    {
        public string total_po { get; set; }
        public string total_mrn { get; set; }
        public string total_issue { get; set; }
    }

    private void get_total_po(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string podate = (Convert.ToDateTime(ServerDateCurrentdate)).ToString("yyyy-MM-dd");
            cmd = new SqlCommand("SELECT COUNT(sno) AS number FROM po_entrydetailes where podate=@date");
            cmd.Parameters.Add("@date", podate);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<Total_Count> ProductDetails = new List<Total_Count>();
            foreach (DataRow dr in routes.Rows)
            {
                Total_Count getproductdetails = new Total_Count();
                getproductdetails.total_po = dr["number"].ToString();
                ProductDetails.Add(getproductdetails);
            }
            string response = GetJson(ProductDetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_total_mrn(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string mrndate = (Convert.ToDateTime(ServerDateCurrentdate)).ToString("MM/dd/yyyy");
            cmd = new SqlCommand("SELECT COUNT(sno) AS number FROM inwarddetails where inwarddate=@date");
            cmd.Parameters.Add("@date", mrndate);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<Total_Count> ProductDetails = new List<Total_Count>();
            foreach (DataRow dr in routes.Rows)
            {
                Total_Count getproductdetails = new Total_Count();
                getproductdetails.total_mrn = dr["number"].ToString();
                ProductDetails.Add(getproductdetails);
            }
            string response = GetJson(ProductDetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_total_issue(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string mrndate = (Convert.ToDateTime(ServerDateCurrentdate)).ToString("MM/dd/yyyy");
            cmd = new SqlCommand("SELECT COUNT(sno) AS number FROM outwarddetails where inwarddate=@date");
            cmd.Parameters.Add("@date", mrndate);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<Total_Count> ProductDetails = new List<Total_Count>();
            foreach (DataRow dr in routes.Rows)
            {
                Total_Count getproductdetails = new Total_Count();
                getproductdetails.total_mrn = dr["number"].ToString();
                ProductDetails.Add(getproductdetails);
            }
            string response = GetJson(ProductDetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_total_branch_transfers(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string mrndate = (Convert.ToDateTime(ServerDateCurrentdate)).ToString("MM/dd/yyyy");
            cmd = new SqlCommand("SELECT COUNT(sno) AS number FROM outwarddetails where inwarddate=@date");
            cmd.Parameters.Add("@date", mrndate);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<Total_Count> ProductDetails = new List<Total_Count>();
            foreach (DataRow dr in routes.Rows)
            {
                Total_Count getproductdetails = new Total_Count();
                getproductdetails.total_mrn = dr["number"].ToString();
                ProductDetails.Add(getproductdetails);
            }
            string response = GetJson(ProductDetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_supplier_details_item(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string productid = context.Request["productid"];
            cmd = new SqlCommand("SELECT itemsupplierdetails.sno, itemsupplierdetails.itemid, itemsupplierdetails.supplierid, itemsupplierdetails.doe, itemsupplierdetails.createdby, suppliersdetails.name, suppliersdetails.supplierphoto FROM itemsupplierdetails INNER JOIN suppliersdetails ON itemsupplierdetails.supplierid = suppliersdetails.supplierid WHERE (itemsupplierdetails.itemid = @productid)");
            cmd.Parameters.Add("@productid", productid);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<Product_supplier> ProductDetails = new List<Product_supplier>();
            foreach (DataRow dr in routes.Rows)
            {
                Product_supplier getproductdetails = new Product_supplier();
                getproductdetails.sno = dr["sno"].ToString();
                getproductdetails.supplierid = dr["supplierid"].ToString();
                getproductdetails.suppliername = dr["name"].ToString();
                getproductdetails.productid = dr["itemid"].ToString();
                getproductdetails.imgpath = dr["supplierphoto"].ToString();
                getproductdetails.ftplocation = "ftp://182.18.138.228/PURCHASE/"; 
                ProductDetails.Add(getproductdetails);
            }
            string response = GetJson(ProductDetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_item_details_supplier(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string supplierid = context.Request["suplierid"];
            cmd = new SqlCommand("SELECT itemsupplierdetails.sno, itemsupplierdetails.itemid, itemsupplierdetails.supplierid, itemsupplierdetails.doe, itemsupplierdetails.createdby, productmaster.productname, productmaster.sku, productmaster.uim AS puim, uimmaster.uim, categorymaster.category, subcategorymaster.subcategoryname, productmaster.imgpath FROM itemsupplierdetails INNER JOIN productmaster ON itemsupplierdetails.itemid = productmaster.productid INNER JOIN uimmaster ON productmaster.uim = uimmaster.sno LEFT OUTER JOIN categorymaster ON productmaster.sectionid = categorymaster.categoryid LEFT OUTER JOIN subcategorymaster ON productmaster.subcategoryid = subcategorymaster.subcategoryid WHERE (itemsupplierdetails.supplierid = @supplierid)");
            cmd.Parameters.Add("@supplierid", supplierid);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<ProductDetails> ProductDetails = new List<ProductDetails>();
            foreach (DataRow dr in routes.Rows)
            {
                ProductDetails getproductdetails = new ProductDetails();
                getproductdetails.supplierid = dr["supplierid"].ToString();
                getproductdetails.productname = dr["productname"].ToString();
                getproductdetails.productid = dr["itemid"].ToString();
                getproductdetails.uim = dr["uim"].ToString();
                getproductdetails.sku = dr["sku"].ToString();
                getproductdetails.category = dr["category"].ToString();
                getproductdetails.subcatname = dr["subcategoryname"].ToString();
                getproductdetails.sno = dr["sno"].ToString();
                getproductdetails.imgpath = dr["imgpath"].ToString();
                getproductdetails.ftplocation = "ftp://182.18.138.228/PURCHASE/";
                ProductDetails.Add(getproductdetails);
            }
            string response = GetJson(ProductDetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_Vendor_Quotation_Data_Details(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string ven_quo_no = context.Request["ven_quo_no"].ToString();
            cmd = new SqlCommand("select sup.companyname,uimmaster.uim,vsq.uom,sup.name,vq.doe,vq.shipto,vq.billingto,vq.paymentmode,pm.sku,vq.deliveryterms AS deliveryterms_id,addr.address,ed.type as edtype,tm.type as taxtype,vq.despatchmode,addr1.address as address1,pm.productname,pay.paymenttype,dt.deliveryterms,pf.pandf,vq.quotationno,vq.quotationdate,vq.supplierid,vq.pricebasis,vq.frieght,vq.transport,vq.insurance,vq.others,vq.pandf as pandf_id,vsq.productid,vsq.qty,vsq.taxtype as taxtype_id,vsq.exchangeduty,vsq.price,vsq.discountamount,vsq.discountpercentage,vsq.taxpercentage,vsq.edtaxpercentage from vendor_quotationdetails vq join vendor_qtion_subdetails vsq on vq.sno=vsq.vendorqtionrefno left outer join pandf pf on vq.pandf=pf.sno inner join suppliersdetails sup on vq.supplierid=sup.supplierid join paymentmaster pay on vq.paymentmode=pay.sno join deliveryterms dt on vq.deliveryterms=dt.sno join addressdetails addr on vq.billingto=addr.sno join addressdetails as addr1 on vq.shipto=addr1.sno join productmaster pm on vsq.productid=pm.productid left outer join taxmaster tm on vsq.taxtype=tm.sno left outer join taxmaster as ed on vsq.exchangeduty=ed.sno join quotation_request qr on vq.quotationno=qr.quotationno INNER JOIN uimmaster ON vsq.uom = uimmaster.sno where vq.vqno=@ven_quo_no");
            cmd.Parameters.Add("@ven_quo_no", ven_quo_no);
            DataTable dtpo = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(dtpo);
            DataTable dtvendor = view.ToTable(true, "address", "address1", "billingto", "doe", "shipto", "paymenttype", "paymentmode", "despatchmode", "deliveryterms", "deliveryterms_id", "frieght", "transport", "insurance", "others", "pandf", "pandf_id", "quotationno", "quotationdate", "supplierid", "companyname", "name", "pricebasis");//"vendor_quotationno", "vendor_quotationdate",  "vsno",
            DataTable dtvendor_subdetails = view.ToTable(true, "productname", "discountamount", "discountpercentage", "taxtype", "taxtype_id", "exchangeduty", "sku", "uim", "uom", "taxpercentage", "edtype", "edtaxpercentage", "qty", "price", "productid");
            List<vendor_det> vendor_list = new List<vendor_det>();
            List<vendor_quo_det> vendor_quo_list = new List<vendor_quo_det>();
            List<vendor_prod_det> vendor_prod_list = new List<vendor_prod_det>();
            foreach (DataRow dr in dtvendor.Rows)
            {
                vendor_quo_det getworkorderreport = new vendor_quo_det();
                getworkorderreport.billing_addr = dr["billingto"].ToString();
                getworkorderreport.delivery_addr = dr["shipto"].ToString();
                getworkorderreport.quo_no = dr["quotationno"].ToString();
                getworkorderreport.doe = ((DateTime)dr["doe"]).ToString("yyyy-MM-dd");
                getworkorderreport.sup_id = dr["supplierid"].ToString();
                getworkorderreport.sup_name = dr["name"].ToString();
                getworkorderreport.sup_comp_name = dr["companyname"].ToString();
                getworkorderreport.payment_type = dr["paymentmode"].ToString();
                getworkorderreport.dispatch_mode = dr["despatchmode"].ToString();
                getworkorderreport.delivery_terms = dr["deliveryterms_id"].ToString();
                getworkorderreport.freight_amt = dr["frieght"].ToString();
                getworkorderreport.transport_chrgs = dr["transport"].ToString();
                getworkorderreport.insurance_chrgs = dr["insurance"].ToString();
                getworkorderreport.other_chrgs = dr["others"].ToString();
                getworkorderreport.quo_dt = ((DateTime)dr["quotationdate"]).ToString("yyyy-MM-dd");
                getworkorderreport.sup_id = dr["supplierid"].ToString();
                getworkorderreport.price_basis = dr["pricebasis"].ToString();
                getworkorderreport.pandf = dr["pandf_id"].ToString();
                vendor_quo_list.Add(getworkorderreport);
            }
            foreach (DataRow dr in dtvendor_subdetails.Rows)
            {
                vendor_prod_det getworkorderreport = new vendor_prod_det();
                getworkorderreport.prod_name = dr["productname"].ToString();
                getworkorderreport.dis_amt = dr["discountamount"].ToString();
                getworkorderreport.dis_per = dr["discountpercentage"].ToString();
                getworkorderreport.tax_type = dr["taxtype"].ToString();
                getworkorderreport.tax_type_id = dr["taxtype_id"].ToString();
                getworkorderreport.ed_id = dr["exchangeduty"].ToString();
                getworkorderreport.tax_per = dr["taxpercentage"].ToString();
                getworkorderreport.ed = dr["edtype"].ToString();
                getworkorderreport.ed_tax_per = dr["edtaxpercentage"].ToString();
                getworkorderreport.qty = dr["qty"].ToString();
                getworkorderreport.price = dr["price"].ToString();
                getworkorderreport.prod_id = dr["productid"].ToString();
                getworkorderreport.sku = dr["sku"].ToString();
                getworkorderreport.uim = dr["uim"].ToString();
                getworkorderreport.uom = dr["uom"].ToString();
                vendor_prod_list.Add(getworkorderreport);
            }
            vendor_det get_vendor_det = new vendor_det();
            get_vendor_det.DataTable = vendor_quo_list;
            get_vendor_det.DataTable1 = vendor_prod_list;
            vendor_list.Add(get_vendor_det);
            string response = GetJson(vendor_list);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_Indent_Data_Details_PO(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string indent_no = context.Request["indent_no"].ToString();
            cmd = new SqlCommand("SELECT productmaster.uim, uimmaster.uim AS uom, indents.sno, indents.name, indents.i_date, indents.d_date, indents.entry_by, indents.remarks, indents.status, indents.branch_id, indents.branchid, indents.sectionid, indent_subtable.sno AS subsno, indent_subtable.indentno, indent_subtable.qty, indent_subtable.delivaryqty, indent_subtable.status AS sub_status, indent_subtable.price, indent_subtable.productid, productmaster.productname, productmaster.sku FROM indents INNER JOIN indent_subtable ON indents.sno = indent_subtable.indentno INNER JOIN productmaster ON indent_subtable.productid = productmaster.productid INNER JOIN uimmaster ON productmaster.uim = uimmaster.sno WHERE (indents.sno = @indent_no) AND (indents.status = 'V')");
            cmd.Parameters.Add("@indent_no", indent_no);
            DataTable dtpo = vdm.SelectQuery(cmd).Tables[0];
            List<vendor_prod_det> vendor_prod_list = new List<vendor_prod_det>();
            foreach (DataRow dr in dtpo.Rows)
            {
                vendor_prod_det getworkorderreport = new vendor_prod_det();
                getworkorderreport.prod_name = dr["productname"].ToString();
                getworkorderreport.qty = dr["qty"].ToString();
                getworkorderreport.prod_id = dr["productid"].ToString();
                getworkorderreport.sku = dr["sku"].ToString();
                getworkorderreport.uim = dr["uim"].ToString();
                getworkorderreport.uom = dr["uom"].ToString();
                vendor_prod_list.Add(getworkorderreport);
            }
            string response = GetJson(vendor_prod_list);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    //veer

    private void get_branch_product_details(HttpContext context)
    {
        try
        {
            DataTable dtproducts = new DataTable();
            vdm = new SalesDBManager();
            string branchid = context.Session["Po_BranchID"].ToString();
            if (context.Session["Productdata"] == null)
            {
                cmd = new SqlCommand("SELECT suppliersdetails.name,productmaster.imgpath, productmaster.itemcode, productmaster.bin, productmaster.productid, productmaster.subcategoryid, productmoniter.qty, productmoniter.branchid, productmaster.productname, productmaster.productcode, productmaster.sub_cat_code, productmaster.sku, productmaster.description, productmaster.sectionid, productmaster.brandid, productmaster.supplierid, productmaster.modifierset,  uimmaster.uim, productmaster.availablestores, productmaster.color, productmaster.uim AS puim, productmoniter.price, categorymaster.category, subcategorymaster.subcategoryname,  branddetails.brandname, productmoniter.minstock, productmoniter.maxstock FROM productmaster INNER JOIN categorymaster ON productmaster.sectionid = categorymaster.categoryid INNER JOIN subcategorymaster ON productmaster.subcategoryid = subcategorymaster.subcategoryid INNER JOIN branddetails ON productmaster.brandid = branddetails.brandid LEFT OUTER JOIN productmoniter ON productmaster.productid = productmoniter.productid LEFT OUTER JOIN uimmaster ON uimmaster.sno = productmaster.uim INNER JOIN suppliersdetails ON productmaster.supplierid = suppliersdetails.supplierid where productmoniter.branchid=@bid");
                cmd.Parameters.Add("@bid", branchid);
                dtproducts = vdm.SelectQuery(cmd).Tables[0];
            }
            else
            {
                context.Session["Productdata"] = dtproducts;
            }
            List<ProductDetails> ProductDetails = new List<ProductDetails>();
            foreach (DataRow dr in dtproducts.Rows)
            {
                string bid = dr["branchid"].ToString();
                ProductDetails getproductdetails = new ProductDetails();
                getproductdetails.productname = dr["productname"].ToString();
                getproductdetails.productcode = dr["productcode"].ToString();
                getproductdetails.shortname = dr["sub_cat_code"].ToString();
                getproductdetails.sku = dr["sku"].ToString();
                getproductdetails.bin = dr["bin"].ToString();
                getproductdetails.itemcode = dr["itemcode"].ToString();
                getproductdetails.description = dr["description"].ToString();
                getproductdetails.sectionid = dr["sectionid"].ToString();
                getproductdetails.brandid = dr["brandid"].ToString();
                getproductdetails.supplierid = dr["supplierid"].ToString();
                getproductdetails.brandname = dr["brandname"].ToString();
                getproductdetails.suppliername = dr["name"].ToString();
                getproductdetails.subcategory = dr["subcategoryname"].ToString();
                getproductdetails.category = dr["category"].ToString();
                getproductdetails.modifierset = dr["modifierset"].ToString();
                string qty = dr["qty"].ToString();
                double quantity = 0;
                if (qty == "0" || qty == "")
                {
                    getproductdetails.moniterqty = quantity.ToString();
                }
                else
                {
                    quantity = Convert.ToDouble(dr["qty"].ToString());
                    quantity = Math.Round(quantity, 2);
                    getproductdetails.moniterqty = quantity.ToString();
                }
                getproductdetails.availablestores1 = dr["availablestores"].ToString();
                getproductdetails.color = dr["color"].ToString();
                getproductdetails.uim = dr["uim"].ToString();
                getproductdetails.puim = dr["puim"].ToString();
                getproductdetails.price = dr["price"].ToString();
                getproductdetails.productid = dr["productid"].ToString();
                getproductdetails.subcategoryid = dr["subcategoryid"].ToString();
                getproductdetails.minstock = dr["minstock"].ToString();
                getproductdetails.maxstock = dr["maxstock"].ToString();
                getproductdetails.imgpath = dr["imgpath"].ToString();
                getproductdetails.ftplocation = "ftp://182.18.138.228/PURCHASE/";
                ProductDetails.Add(getproductdetails);
            }
            string response = GetJson(ProductDetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_branch_product_details_Like(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string name = context.Request["name"];
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT suppliersdetails.name,productmaster.imgpath, productmaster.itemcode, productmaster.bin, productmaster.productid, productmaster.subcategoryid, productmoniter.qty, productmoniter.branchid, productmaster.productname, productmaster.productcode, productmaster.sub_cat_code, productmaster.sku, productmaster.description, productmaster.sectionid, productmaster.brandid, productmaster.supplierid, productmaster.modifierset,  uimmaster.uim, productmaster.availablestores, productmaster.color, productmaster.uim AS puim, productmoniter.price, categorymaster.category, subcategorymaster.subcategoryname,  branddetails.brandname, productmoniter.minstock, productmoniter.maxstock FROM productmaster INNER JOIN categorymaster ON productmaster.sectionid = categorymaster.categoryid INNER JOIN subcategorymaster ON productmaster.subcategoryid = subcategorymaster.subcategoryid INNER JOIN branddetails ON productmaster.brandid = branddetails.brandid LEFT OUTER JOIN productmoniter ON productmaster.productid = productmoniter.productid LEFT OUTER JOIN uimmaster ON uimmaster.sno = productmaster.uim INNER JOIN suppliersdetails ON productmaster.supplierid = suppliersdetails.supplierid where productmoniter.branchid=@bid and (productmaster.productname LIKE '%'+ @name +'%')");
            cmd.Parameters.Add("@name", name);
            cmd.Parameters.Add("@bid", branchid);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<ProductDetails> ProductDetails = new List<ProductDetails>();
            foreach (DataRow dr in routes.Rows)
            {
                ProductDetails getproductdetails = new ProductDetails();
                getproductdetails.productname = dr["productname"].ToString();
                getproductdetails.productcode = dr["productcode"].ToString();
                getproductdetails.shortname = dr["sub_cat_code"].ToString();
                getproductdetails.sku = dr["sku"].ToString();
                getproductdetails.description = dr["description"].ToString();
                getproductdetails.sectionid = dr["sectionid"].ToString();
                getproductdetails.brandid = dr["brandid"].ToString();
                getproductdetails.supplierid = dr["supplierid"].ToString();
                getproductdetails.bin = dr["bin"].ToString();
                getproductdetails.itemcode = dr["itemcode"].ToString();
                getproductdetails.sectionid = dr["sectionid"].ToString();
                getproductdetails.modifierset = dr["modifierset"].ToString();
                double quantity = Convert.ToDouble(dr["qty"].ToString());
                quantity = Math.Round(quantity, 2);
                getproductdetails.moniterqty = quantity.ToString();
                getproductdetails.availablestores1 = dr["availablestores"].ToString();
                getproductdetails.color = dr["color"].ToString();
                getproductdetails.uim = dr["uim"].ToString();
                getproductdetails.puim = dr["puim"].ToString();
                getproductdetails.price = dr["price"].ToString();
                getproductdetails.productid = dr["productid"].ToString();
                getproductdetails.subcategoryid = dr["subcategoryid"].ToString();
                getproductdetails.brandname = dr["brandname"].ToString();
                getproductdetails.suppliername = dr["name"].ToString();
                getproductdetails.subcategory = dr["subcategoryname"].ToString();
                getproductdetails.category = dr["category"].ToString();
                getproductdetails.minstock = dr["minstock"].ToString();
                getproductdetails.maxstock = dr["maxstock"].ToString();
                getproductdetails.imgpath = dr["imgpath"].ToString();
                getproductdetails.ftplocation = "ftp://182.18.138.228/PURCHASE/";
                ProductDetails.Add(getproductdetails);
            }
            string response = GetJson(ProductDetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }


    private void saveBranchProductDetails(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string max_stock = context.Request["max_stock"];
            string min_stock = context.Request["min_stock"];
            string productid = context.Request["ProductId"];
            string branchid = context.Session["Po_BranchID"].ToString();
            string btnSave = context.Request["btnVal"];
            cmd = new SqlCommand("update productmoniter set minstock=@min_stock,maxstock=@max_stock where productid=@productid and branchid=@branchid");
            cmd.Parameters.Add("@max_stock", max_stock);
            cmd.Parameters.Add("@min_stock", min_stock);
            cmd.Parameters.Add("@productid", productid);
            cmd.Parameters.Add("@branchid", branchid);
            vdm.Update(cmd);
            string msg = "Minimum and Maximum stock updated successfully";
            string Response = GetJson(msg);
            context.Response.Write(Response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    

    private void get_approve_Stock_Tranfer_Inward(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT stocktransferdetails.sno, stocktransferdetails.frombranch, stocktransferdetails.tobranch, stocktransferdetails.doe, stocktransferdetails.entryby, stocktransferdetails.branchid, stocktransferdetails.transportname, stocktransferdetails.invoicetype, stocktransferdetails.status, stocktransferdetails.vehicleno, stocktransferdetails.invoiceno, stocktransferdetails.invoicedate, stocktransferdetails.remarks, stocktransferdetails.branch_id, stocktransferdetails.stock_sno, branchmaster.branchname FROM stocktransferdetails INNER JOIN branchmaster ON stocktransferdetails.branch_id = branchmaster.branchid WHERE (stocktransferdetails.status = 'A') AND (stocktransferdetails.tobranch = @branchid) AND (stocktransferdetails.tobranchinwardstatus='P')");
            cmd.Parameters.Add("@branchid", branchid);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<stocktransferdetails> ST_Details = new List<stocktransferdetails>();
            foreach (DataRow dr in routes.Rows)
            {
                stocktransferdetails get_details = new stocktransferdetails();
                get_details.invoiceno = dr["invoiceno"].ToString();
                get_details.invoicedate = ((DateTime)dr["invoicedate"]).ToString("dd-MM-yyyy"); //dr["invoicedate"].ToString();
                get_details.remarks = dr["remarks"].ToString();
                get_details.vehicleno = dr["vehicleno"].ToString();
                get_details.frombranch = dr["frombranch"].ToString();
                get_details.barnchname = dr["branchname"].ToString();
                get_details.transportname = dr["transportname"].ToString();
                get_details.sno = dr["sno"].ToString();
                ST_Details.Add(get_details);
            }
            string response = GetJson(ST_Details);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_approve_Stock_Tranfer_Inward_sub(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string julydt = "07/01/2017";
            DateTime gst_dt = Convert.ToDateTime(julydt);
            string branchid = context.Session["Po_BranchID"].ToString();
            string sno = context.Request["sno"];
            cmd = new SqlCommand("SELECT stocktransferdetails.invoicedate, stocktransfersubdetails.igst, stocktransfersubdetails.sgst, stocktransfersubdetails.cgst, stocktransfersubdetails.productid, stocktransfersubdetails.quantity, stocktransfersubdetails.remarks, stocktransfersubdetails.taxtype, stocktransfersubdetails.taxvalue, stocktransfersubdetails.price, productmaster.productname FROM stocktransfersubdetails INNER JOIN stocktransferdetails ON stocktransfersubdetails.stock_refno = stocktransferdetails.sno INNER JOIN productmaster ON stocktransfersubdetails.productid = productmaster.productid WHERE (stocktransfersubdetails.quantity > 0) AND (stocktransfersubdetails.stock_refno = @sno)");
            cmd.Parameters.Add("@sno", sno);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<stocktransfersubdetails> ST_Product_Details = new List<stocktransfersubdetails>();
            foreach (DataRow dr in routes.Rows)
            {
                stocktransfersubdetails get_details = new stocktransfersubdetails();
                string invoicedate1 = ((DateTime)dr["invoicedate"]).ToString();
                //string inwarddate1 = "7/17/2017 12:00:00 AM";
                DateTime invoicedate = Convert.ToDateTime(invoicedate1);
                if (invoicedate < gst_dt)
                {
                    get_details.taxtype = dr["taxtype"].ToString();
                    get_details.taxvalue = dr["taxvalue"].ToString();
                    get_details.gst_exists = "0";
                }
                else
                {
                    get_details.sgst_per = dr["sgst"].ToString();
                    get_details.cgst_per = dr["cgst"].ToString();
                    get_details.igst_per = dr["igst"].ToString();
                    get_details.gst_exists = "1";
                }
                get_details.productid = dr["productid"].ToString();
                get_details.productname = dr["productname"].ToString();
                get_details.quantity = dr["quantity"].ToString();
                get_details.price = dr["price"].ToString();
                ST_Product_Details.Add(get_details);
            }
            string response = GetJson(ST_Product_Details);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void save_Supplier_Document_Info(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            if (context.Request.Files.Count > 0)
            {
                string supplierid = context.Request["supplierid"];
                string suppliername = context.Request["suppliername"];
                string documenttype = context.Request["documenttype"];
                string sno = context.Request["sno"];
                if (sno == null)
                {
                    sno = "";
                }
                string branchid = context.Session["Po_BranchID"].ToString();
                string entryby = context.Session["Employ_Sno"].ToString();

                cmd = new SqlCommand("select name,suppliercode from suppliersdetails where supplierid=@supplierid");
                cmd.Parameters.Add("@supplierid", supplierid);
                DataTable dt_suppliers = vdm.SelectQuery(cmd).Tables[0];
                string suppliercode = dt_suppliers.Rows[0]["suppliercode"].ToString();

                

                HttpFileCollection files = context.Request.Files;
                DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
                for (int i = 0; i < files.Count; i++)
                {
                    cmd = new SqlCommand("select path,documenttype from supplierdocuments where supplierid=@supplierid");
                    cmd.Parameters.Add("@supplierid", supplierid);
                    DataTable dt_doc = vdm.SelectQuery(cmd).Tables[0];
                    int count = dt_doc.Rows.Count;

                    HttpPostedFile file = files[i];
                    string upload_filename = "";
                    string[] extension = file.FileName.Split('.');
                    if (extension[1] == "pdf")
                    {
                        //upload_filename = "supplierid_" + supplierid + "_" + suppliercode + "_" + documenttype + "_branchid_" + branchid + ".pdf";// +extension[extension.Length - 1];
                        upload_filename = suppliercode + "_" + documenttype + "_" + (count + 1).ToString() + ".pdf";
                    }
                    else
                    {
                        //upload_filename = "supplierid_" + supplierid + "_" + suppliercode + "_" + documenttype + "_branchid_" + branchid + ".jpeg";
                        upload_filename = suppliercode + "_" + documenttype + "_" + (count + 1).ToString() + ".jpeg";
                    }

                    if (UploadpicToFTP(file, upload_filename))
                    {
                        cmd = new SqlCommand("update  supplierdocuments set supplierid=@supplierid,documenttype=@documenttype,path=@documentpath where sno=@sno");
                        cmd.Parameters.Add("@supplierid", supplierid);
                        cmd.Parameters.Add("@documentpath", upload_filename);
                        cmd.Parameters.Add("@documenttype", documenttype);
                        cmd.Parameters.Add("@sno", sno);
                        if (vdm.Update(cmd) == 0)
                        {
                            cmd = new SqlCommand("insert into supplierdocuments (supplierid,documenttype,path,createdby,date) values (@supplierid,@documenttype,@documentpath,@entryby,@date)");
                            cmd.Parameters.Add("@supplierid", supplierid);
                            cmd.Parameters.Add("@documentpath", upload_filename);
                            cmd.Parameters.Add("@documenttype", documenttype);
                            cmd.Parameters.Add("@date", ServerDateCurrentdate);
                            cmd.Parameters.Add("@entryby", entryby);
                            vdm.insert(cmd);
                        }
                    }
                }
                string response = GetJson("File Uploaded Successfully!");
                context.Response.Write(response);
            }
        }
        catch (Exception ex)
        {
            string response = GetJson(ex.Message);
            context.Response.Write(response);
        }
    }

    public class supplier_documents
    {
        public string sno { get; set; }
        public string documenttype { get; set; }
        public string path { get; set; }
        public string supplierid { get; set; }
        public string suppliername { get; set; }
        public string ftplocation { get; set; }
    }

    private void getsupplier_Uploaded_Documents(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string branchid = context.Session["Po_BranchID"].ToString();
            string supplierid = context.Request["supplierid"];
            cmd = new SqlCommand("SELECT supplierdocuments.sno, supplierdocuments.documenttype, supplierdocuments.path, supplierdocuments.supplierid, supplierdocuments.createdby, supplierdocuments.[date], suppliersdetails.name FROM supplierdocuments INNER JOIN suppliersdetails ON supplierdocuments.supplierid = suppliersdetails.supplierid WHERE supplierdocuments.supplierid=@supplierid");
            cmd.Parameters.Add("@supplierid", supplierid);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<supplier_documents> sup_doc_Details = new List<supplier_documents>();
            foreach (DataRow dr in routes.Rows)
            {
                supplier_documents get_details = new supplier_documents();
                get_details.sno = dr["sno"].ToString();
                get_details.documenttype = dr["documenttype"].ToString();
                get_details.path = dr["path"].ToString();
                get_details.supplierid = dr["supplierid"].ToString();
                get_details.suppliername = dr["name"].ToString();
                get_details.ftplocation = "ftp://182.18.138.228:21/PURCHASE/";
                sup_doc_Details.Add(get_details);
            }
            string response = GetJson(sup_doc_Details);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_product_details_id(HttpContext context)
    {
        try
        {
            DataTable dtproducts = new DataTable();
            vdm = new SalesDBManager();
            string branchid = context.Session["Po_BranchID"].ToString();
            string productid = context.Request["productid"];
            //cmd = new SqlCommand("SELECT productmaster.imgpath, productmaster.itemcode, productmaster.bin, productmaster.productid, productmoniter.qty, productmoniter.branchid, productmaster.productname, productmaster.productcode, productmaster.sub_cat_code, productmaster.sku, productmaster.description, productmaster.sectionid, productmaster.brandid, productmaster.supplierid, productmaster.modifierset, uimmaster.uim, productmaster.availablestores, productmaster.color, productmaster.uim AS puim, productmoniter.price, categorymaster.category, subcategorymaster.subcategoryname, suppliersdetails.name FROM productmaster INNER JOIN categorymaster ON productmaster.sectionid = categorymaster.categoryid INNER JOIN subcategorymaster ON productmaster.subcategoryid = subcategorymaster.subcategoryid LEFT OUTER JOIN productmoniter ON productmaster.productid = productmoniter.productid LEFT OUTER JOIN suppliersdetails ON productmaster.supplierid = suppliersdetails.supplierid LEFT OUTER JOIN uimmaster ON uimmaster.sno = productmaster.uim WHERE (productmoniter.branchid = @bid) AND (productmaster.productid = @productid)");
            cmd = new SqlCommand("SELECT productmaster.imgpath, productmaster.itemcode, productmaster.bin, productmaster.productid, productmoniter.qty, productmoniter.branchid, productmaster.productname, productmaster.productcode, productmaster.sub_cat_code, productmaster.sku, productmaster.description, productmaster.sectionid, productmaster.brandid, productmaster.supplierid, productmaster.modifierset, uimmaster.uim, productmaster.availablestores, productmaster.color, productmaster.uim AS puim, productmoniter.price, categorymaster.category, subcategorymaster.subcategoryname, suppliersdetails.name FROM productmaster INNER JOIN subcategorymaster ON productmaster.subcategoryid = subcategorymaster.subcategoryid INNER JOIN categorymaster ON subcategorymaster.categoryid = categorymaster.categoryid LEFT OUTER JOIN productmoniter ON productmaster.productid = productmoniter.productid LEFT OUTER JOIN suppliersdetails ON productmaster.supplierid = suppliersdetails.supplierid LEFT OUTER JOIN uimmaster ON uimmaster.sno = productmaster.uim WHERE (productmoniter.branchid = @bid) AND (productmaster.productid = @productid)");
            cmd.Parameters.Add("@bid", branchid);
            cmd.Parameters.Add("@productid", productid);
            dtproducts = vdm.SelectQuery(cmd).Tables[0];
            List<ProductDetails> ProductDetails = new List<ProductDetails>();
            foreach (DataRow dr in dtproducts.Rows)
            {
                string bid = dr["branchid"].ToString();
                ProductDetails getproductdetails = new ProductDetails();
                getproductdetails.productname = dr["productname"].ToString();
                getproductdetails.productcode = dr["productcode"].ToString();
                getproductdetails.shortname = dr["sub_cat_code"].ToString();
                getproductdetails.sku = dr["sku"].ToString();
                getproductdetails.bin = dr["bin"].ToString();
                getproductdetails.itemcode = dr["itemcode"].ToString();
                getproductdetails.description = dr["description"].ToString();
                getproductdetails.sectionid = dr["sectionid"].ToString();
                getproductdetails.brandid = dr["brandid"].ToString();
                getproductdetails.supplierid = dr["supplierid"].ToString();
                getproductdetails.category = dr["category"].ToString();
                getproductdetails.modifierset = dr["modifierset"].ToString();
                
                string qty = dr["qty"].ToString();
                double quantity = 0;
                if (qty == "0" || qty == "")
                {
                    getproductdetails.moniterqty = quantity.ToString();
                }
                else
                {
                    quantity = Convert.ToDouble(dr["qty"].ToString());
                    quantity = Math.Round(quantity, 2);
                    getproductdetails.moniterqty = quantity.ToString();
                }
                getproductdetails.availablestores1 = dr["availablestores"].ToString();
                getproductdetails.color = dr["color"].ToString();
                getproductdetails.uim = dr["uim"].ToString();
                getproductdetails.puim = dr["puim"].ToString();
                getproductdetails.price = dr["price"].ToString();
                getproductdetails.productid = dr["productid"].ToString();
                
                getproductdetails.subcatname = dr["subcategoryname"].ToString();
                getproductdetails.suppliername = dr["name"].ToString();
                getproductdetails.imgpath = dr["imgpath"].ToString();
                getproductdetails.ftplocation = "ftp://182.18.138.228/PURCHASE/";
                ProductDetails.Add(getproductdetails);
            }
            string response = GetJson(ProductDetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_lastsixmonthsinward_value(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            DataTable Report = new DataTable();
            DateTime doe = SalesDBManager.GetTime(vdm.conn);
            int month = doe.Month;
            int dateday = 1;
            int year = doe.Year;
            string mnth = month.ToString();
            string day = dateday.ToString();
            string yr = year.ToString();
            string cdate = mnth + "/" + day + "/" + year;
            DateTime dtFromdate = Convert.ToDateTime(cdate);
            DateTime dtTodate = Convert.ToDateTime(doe);
            string branchid = context.Request["branch"];
            if (branchid == null || branchid == "")
            { 
                branchid = context.Session["Po_BranchID"].ToString();
            }
            cmd = new SqlCommand("SELECT  MONTH, qtyvalue  FROM (SELECT MONTH(inwarddetails.inwarddate) AS MONTH, SUM(subinwarddetails.quantity * subinwarddetails.perunit) AS qtyvalue FROM    inwarddetails INNER JOIN subinwarddetails ON inwarddetails.sno = subinwarddetails.in_refno WHERE (inwarddetails.branchid = @branchid) AND (inwarddetails.inwarddate BETWEEN @d1 AND @d2) GROUP BY MONTH(inwarddetails.inwarddate)) AS intbl ORDER BY MONTH");            
            cmd.Parameters.Add("@branchid", branchid);
            cmd.Parameters.Add("@d1", GetLowDate(dtFromdate).AddMonths(-4));
            cmd.Parameters.Add("@d2", GetHighDate(dtTodate));
            DataTable dttotalinward = vdm.SelectQuery(cmd).Tables[0];
            List<lineValues> lPieValueslist = new List<lineValues>();
            List<string> categoryList = new List<string>();
            List<string> valueList = new List<string>();
            if (dttotalinward.Rows.Count > 0)
            {
                foreach (DataRow dr in dttotalinward.Rows)
                {
                    string catvalue = dr["qtyvalue"].ToString();
                    string categoryname = dr["MONTH"].ToString();
                    string mn = dr["MONTH"].ToString();
                    int monthname = Convert.ToInt32(mn);
                    string monthName = CultureInfo.CurrentCulture.DateTimeFormat.GetAbbreviatedMonthName(monthname);
                    categoryList.Add(monthName);
                    valueList.Add(catvalue);
                }
            }
            lineValues GetlineValues = new lineValues();
            GetlineValues.RouteName = categoryList;
            GetlineValues.Amount = valueList;
            lPieValueslist.Add(GetlineValues);
            string response = GetJson(lPieValueslist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_lastsixmonthsinward_value_branch(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            DataTable Report = new DataTable();
            DateTime doe = SalesDBManager.GetTime(vdm.conn);
            int month = doe.Month;
            int dateday = 1;
            int year = doe.Year;
            string mnth = month.ToString();
            string day = dateday.ToString();
            string yr = year.ToString();
            string cdate = mnth + "/" + day + "/" + year;
            DateTime dtFromdate = Convert.ToDateTime(cdate);
            DateTime dtTodate = Convert.ToDateTime(doe);
            string branchid = context.Request["branch"];
            if (branchid == "All")
            {
                cmd = new SqlCommand("SELECT  MONTH, qtyvalue  FROM (SELECT MONTH(inwarddetails.inwarddate) AS MONTH, SUM(subinwarddetails.quantity * subinwarddetails.perunit) AS qtyvalue FROM    inwarddetails INNER JOIN subinwarddetails ON inwarddetails.sno = subinwarddetails.in_refno WHERE  (inwarddetails.inwarddate BETWEEN @d1 AND @d2) GROUP BY MONTH(inwarddetails.inwarddate)) AS intbl ORDER BY MONTH");
                cmd.Parameters.Add("@d1", GetLowDate(dtFromdate).AddMonths(-4));
                cmd.Parameters.Add("@d2", GetHighDate(dtTodate));
            }
            else
            {
                cmd = new SqlCommand("SELECT  MONTH, qtyvalue  FROM (SELECT MONTH(inwarddetails.inwarddate) AS MONTH, SUM(subinwarddetails.quantity * subinwarddetails.perunit) AS qtyvalue FROM    inwarddetails INNER JOIN subinwarddetails ON inwarddetails.sno = subinwarddetails.in_refno WHERE (inwarddetails.branchid = @branchid) AND (inwarddetails.inwarddate BETWEEN @d1 AND @d2) GROUP BY MONTH(inwarddetails.inwarddate)) AS intbl ORDER BY MONTH");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@d1", GetLowDate(dtFromdate).AddMonths(-4));
                cmd.Parameters.Add("@d2", GetHighDate(dtTodate));
            }
            DataTable dttotalinward = vdm.SelectQuery(cmd).Tables[0];
            List<lineValues> lPieValueslist = new List<lineValues>();
            List<string> categoryList = new List<string>();
            List<string> valueList = new List<string>();
            if (dttotalinward.Rows.Count > 0)
            {
                foreach (DataRow dr in dttotalinward.Rows)
                {
                    string catvalue = dr["qtyvalue"].ToString();
                    string categoryname = dr["MONTH"].ToString();
                    string mn = dr["MONTH"].ToString();
                    int monthname = Convert.ToInt32(mn);
                    string monthName = CultureInfo.CurrentCulture.DateTimeFormat.GetAbbreviatedMonthName(monthname);
                    categoryList.Add(monthName);
                    valueList.Add(catvalue);
                }
            }
            lineValues GetlineValues = new lineValues();
            GetlineValues.RouteName = categoryList;
            GetlineValues.Amount = valueList;
            lPieValueslist.Add(GetlineValues);
            string response = GetJson(lPieValueslist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_lastsixmonthsoutward_value(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            DataTable Report = new DataTable();
            DateTime doe = SalesDBManager.GetTime(vdm.conn);
            int month = doe.Month;
            int dateday = 1;
            int year = doe.Year;
            string mnth = month.ToString();
            string day = dateday.ToString();
            string yr = year.ToString();
            string cdate = mnth + "/" + day + "/" + year;
            DateTime dtFromdate = Convert.ToDateTime(cdate);
            DateTime dtTodate = Convert.ToDateTime(doe);
            string branchid = context.Request["branch"];
            if (branchid == null || branchid == "")
            {
                branchid = context.Session["Po_BranchID"].ToString();
            }
            cmd = new SqlCommand("SELECT MONTH, qtyvalue FROM (SELECT MONTH(outwarddetails.inwarddate) AS MONTH, SUM(suboutwarddetails.quantity * suboutwarddetails.perunit) AS qtyvalue  FROM  outwarddetails INNER JOIN suboutwarddetails ON outwarddetails.sno = suboutwarddetails.in_refno WHERE  (outwarddetails.inwarddate BETWEEN @d1 AND @d2) AND (outwarddetails.branchid = @branchid) GROUP BY MONTH(outwarddetails.inwarddate)) AS derivedtbl_1 ORDER BY MONTH");
            cmd.Parameters.Add("@branchid", branchid);
            cmd.Parameters.Add("@d1", GetLowDate(dtFromdate).AddMonths(-4));
            cmd.Parameters.Add("@d2", GetHighDate(dtTodate));
            DataTable dttotalinward = vdm.SelectQuery(cmd).Tables[0];
            List<outValues> lPieValueslist = new List<outValues>();
            List<string> categoryList = new List<string>();
            List<string> valueList = new List<string>();
            if (dttotalinward.Rows.Count > 0)
            {
                foreach (DataRow dr in dttotalinward.Rows)
                {
                    string catvalue = dr["qtyvalue"].ToString();
                    string mn = dr["MONTH"].ToString();
                    int monthname = Convert.ToInt32(mn);
                    string monthName = CultureInfo.CurrentCulture.DateTimeFormat.GetAbbreviatedMonthName(monthname);
                    categoryList.Add(monthName);
                    valueList.Add(catvalue);
                }
            }
            outValues GetoutValues = new outValues();
            GetoutValues.RouteName = categoryList;
            GetoutValues.Amount = valueList;
            lPieValueslist.Add(GetoutValues);
            string response = GetJson(lPieValueslist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_lastsixmonthsoutward_value_branch(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            DataTable Report = new DataTable();
            DateTime doe = SalesDBManager.GetTime(vdm.conn);
            int month = doe.Month;
            int dateday = 1;
            int year = doe.Year;
            string mnth = month.ToString();
            string day = dateday.ToString();
            string yr = year.ToString();
            string cdate = mnth + "/" + day + "/" + year;
            DateTime dtFromdate = Convert.ToDateTime(cdate);
            DateTime dtTodate = Convert.ToDateTime(doe);
            string branchid = context.Request["branch"];
            if (branchid == "All")
            {
                cmd = new SqlCommand("SELECT MONTH, qtyvalue FROM (SELECT MONTH(outwarddetails.inwarddate) AS MONTH, SUM(suboutwarddetails.quantity * suboutwarddetails.perunit) AS qtyvalue  FROM  outwarddetails INNER JOIN suboutwarddetails ON outwarddetails.sno = suboutwarddetails.in_refno WHERE  (outwarddetails.inwarddate BETWEEN @d1 AND @d2)  GROUP BY MONTH(outwarddetails.inwarddate)) AS derivedtbl_1 ORDER BY MONTH");
                cmd.Parameters.Add("@d1", GetLowDate(dtFromdate).AddMonths(-4));
                cmd.Parameters.Add("@d2", GetHighDate(dtTodate));
            }
            else
            {
                cmd = new SqlCommand("SELECT MONTH, qtyvalue FROM (SELECT MONTH(outwarddetails.inwarddate) AS MONTH, SUM(suboutwarddetails.quantity * suboutwarddetails.perunit) AS qtyvalue  FROM  outwarddetails INNER JOIN suboutwarddetails ON outwarddetails.sno = suboutwarddetails.in_refno WHERE  (outwarddetails.inwarddate BETWEEN @d1 AND @d2) AND (outwarddetails.branchid = @branchid) GROUP BY MONTH(outwarddetails.inwarddate)) AS derivedtbl_1 ORDER BY MONTH");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@d1", GetLowDate(dtFromdate).AddMonths(-4));
                cmd.Parameters.Add("@d2", GetHighDate(dtTodate));
            }
            DataTable dttotalinward = vdm.SelectQuery(cmd).Tables[0];
            List<outValues> lPieValueslist = new List<outValues>();
            List<string> categoryList = new List<string>();
            List<string> valueList = new List<string>();
            if (dttotalinward.Rows.Count > 0)
            {
                foreach (DataRow dr in dttotalinward.Rows)
                {
                    string catvalue = dr["qtyvalue"].ToString();
                    string mn = dr["MONTH"].ToString();
                    int monthname = Convert.ToInt32(mn);
                    string monthName = CultureInfo.CurrentCulture.DateTimeFormat.GetAbbreviatedMonthName(monthname);
                    categoryList.Add(monthName);
                    valueList.Add(catvalue);
                }
            }
            outValues GetoutValues = new outValues();
            GetoutValues.RouteName = categoryList;
            GetoutValues.Amount = valueList;
            lPieValueslist.Add(GetoutValues);
            string response = GetJson(lPieValueslist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_productcountdetails(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            DataTable Report = new DataTable();
            DateTime doe = SalesDBManager.GetTime(vdm.conn);
            string branchid = context.Request["branch"];
            if (branchid == null || branchid == "")
            {
                branchid = context.Session["Po_BranchID"].ToString();
            }
            cmd = new SqlCommand("SELECT COUNT(*) AS productcount FROM productmaster INNER JOIN  productmoniter ON productmaster.productid = productmoniter.productid WHERE (productmoniter.branchid = @branchid)");
            cmd.Parameters.Add("@branchid", branchid);
            DataTable dtproductcount = vdm.SelectQuery(cmd).Tables[0];


            cmd = new SqlCommand("SELECT COUNT(*) AS productcount FROM productmaster INNER JOIN  productmoniter ON productmaster.productid = productmoniter.productid WHERE (productmoniter.branchid = @branchid) AND (productmoniter.qty < productmoniter.minstock) AND (productmoniter.qty > 0)");
            cmd.Parameters.Add("@branchid", branchid);
            DataTable dtlowstockproduct = vdm.SelectQuery(cmd).Tables[0];


            cmd = new SqlCommand("SELECT COUNT(*) AS productcount FROM productmaster INNER JOIN  productmoniter ON productmaster.productid = productmoniter.productid WHERE (productmoniter.branchid = @branchid) AND (productmoniter.qty = '0')");
            cmd.Parameters.Add("@branchid", branchid);
            DataTable dtZEROstockproduct = vdm.SelectQuery(cmd).Tables[0];


            cmd = new SqlCommand("SELECT COUNT(*) AS productcount FROM productmaster INNER JOIN  productmoniter ON productmaster.productid = productmoniter.productid WHERE (productmoniter.branchid = @branchid) AND (productmoniter.qty > productmoniter.maxstock) AND (productmoniter.qty > 0)");
            cmd.Parameters.Add("@branchid", branchid);
            DataTable dtMOREproductcount = vdm.SelectQuery(cmd).Tables[0];

            List<ProductDetails> ProductDetails = new List<ProductDetails>();
            
            ProductDetails getproductdetails = new ProductDetails();
            if (dtproductcount.Rows.Count > 0)
            {
                string count = dtproductcount.Rows[0]["productcount"].ToString();
                getproductdetails.productcount = count;
            }
            if (dtlowstockproduct.Rows.Count > 0)
            {
                string lowcount = dtlowstockproduct.Rows[0]["productcount"].ToString();
                getproductdetails.lowstockcount = lowcount;
            }
            if (dtZEROstockproduct.Rows.Count > 0)
            {
                string zerocount = dtZEROstockproduct.Rows[0]["productcount"].ToString();
                getproductdetails.zerostockcount = zerocount;
            }
            if (dtMOREproductcount.Rows.Count > 0)
            {
                string morecount = dtMOREproductcount.Rows[0]["productcount"].ToString();
                getproductdetails.morestockcount = morecount;
            }
            ProductDetails.Add(getproductdetails);
            string response = GetJson(ProductDetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_productcountdetails_branch(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            DataTable Report = new DataTable();
            DateTime doe = SalesDBManager.GetTime(vdm.conn);
            string branchid = context.Request["branch"];
            if (branchid == null || branchid == "All")
            {
                cmd = new SqlCommand("SELECT COUNT(*) AS productcount FROM productmaster INNER JOIN  productmoniter ON productmaster.productid = productmoniter.productid");
            }
            else
            {
                cmd = new SqlCommand("SELECT COUNT(*) AS productcount FROM productmaster INNER JOIN  productmoniter ON productmaster.productid = productmoniter.productid WHERE (productmoniter.branchid = @branchid)");
                cmd.Parameters.Add("@branchid", branchid);
            }
            DataTable dtproductcount = vdm.SelectQuery(cmd).Tables[0];

            if (branchid == null || branchid == "All")
            {
                cmd = new SqlCommand("SELECT COUNT(*) AS productcount FROM productmaster INNER JOIN  productmoniter ON productmaster.productid = productmoniter.productid WHERE (productmoniter.qty < productmoniter.minstock) AND (productmoniter.qty > 0)");
            }
            else
            {
                cmd = new SqlCommand("SELECT COUNT(*) AS productcount FROM productmaster INNER JOIN  productmoniter ON productmaster.productid = productmoniter.productid WHERE (productmoniter.branchid = @branchid) AND (productmoniter.qty < productmoniter.minstock) AND (productmoniter.qty > 0)");
                cmd.Parameters.Add("@branchid", branchid);
            }
            DataTable dtlowstockproduct = vdm.SelectQuery(cmd).Tables[0];
            if (branchid == null || branchid == "All")
            {
                cmd = new SqlCommand("SELECT COUNT(*) AS productcount FROM productmaster INNER JOIN  productmoniter ON productmaster.productid = productmoniter.productid WHERE (productmoniter.qty = 0)");
            }
            else
            {
                cmd = new SqlCommand("SELECT COUNT(*) AS productcount FROM productmaster INNER JOIN  productmoniter ON productmaster.productid = productmoniter.productid WHERE (productmoniter.branchid = @branchid) AND (productmoniter.qty = 0)");
                cmd.Parameters.Add("@branchid", branchid);
            }
            DataTable dtZEROstockproduct = vdm.SelectQuery(cmd).Tables[0];

            if (branchid == null || branchid == "All")
            {
                cmd = new SqlCommand("SELECT COUNT(*) AS productcount FROM productmaster INNER JOIN  productmoniter ON productmaster.productid = productmoniter.productid WHERE (productmoniter.qty > productmoniter.maxstock) AND (productmoniter.qty > 0)");
            }
            else
            {
                cmd = new SqlCommand("SELECT COUNT(*) AS productcount FROM productmaster INNER JOIN  productmoniter ON productmaster.productid = productmoniter.productid WHERE (productmoniter.branchid = @branchid) AND (productmoniter.qty > productmoniter.maxstock) AND (productmoniter.qty > 0)");
                cmd.Parameters.Add("@branchid", branchid);
            }
            
            DataTable dtMOREproductcount = vdm.SelectQuery(cmd).Tables[0];

            List<ProductDetails> ProductDetails = new List<ProductDetails>();

            ProductDetails getproductdetails = new ProductDetails();
            if (dtproductcount.Rows.Count > 0)
            {
                string count = dtproductcount.Rows[0]["productcount"].ToString();
                getproductdetails.productcount = count;
            }
            if (dtlowstockproduct.Rows.Count > 0)
            {
                string lowcount = dtlowstockproduct.Rows[0]["productcount"].ToString();
                getproductdetails.lowstockcount = lowcount;
            }
            if (dtZEROstockproduct.Rows.Count > 0)
            {
                string zerocount = dtZEROstockproduct.Rows[0]["productcount"].ToString();
                getproductdetails.zerostockcount = zerocount;
            }
            if (dtMOREproductcount.Rows.Count > 0)
            {
                string morecount = dtMOREproductcount.Rows[0]["productcount"].ToString();
                getproductdetails.morestockcount = morecount;
            }
            ProductDetails.Add(getproductdetails);
            string response = GetJson(ProductDetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class Product_branch_data
    {
        public string category { get; set; }
        public string itemcode { get; set; }
        public string sku { get; set; }
        public string uim { get; set; }
        public string suppliername { get; set; }
        public string subcategory { get; set; }
        public string productid { get; set; }
        public string productname { get; set; }
        public string punabaka_qty { get; set; }
        public string chennai_qty { get; set; }
        public string manapakkam_qty { get; set; }
        public string kuppam_qty { get; set; }
    }

    private void getallbranchproductdata(HttpContext context)
    {
        try
        {
            DataTable dtproducts = new DataTable();
            vdm = new SalesDBManager();
            //cmd = new SqlCommand("select productid from productmaster");
            //DataTable dt_products = vdm.SelectQuery(cmd).Tables[0];
            string product_id = context.Request["productid"];
            cmd = new SqlCommand("SELECT suppliersdetails.name, uimmaster.uim, productmaster.itemcode, productmaster.sku, productmaster.productname, productmoniter.qty, productmoniter.branchid, subcategorymaster.subcategoryname, categorymaster.category FROM productmaster INNER JOIN productmoniter ON productmaster.productid = productmoniter.productid INNER JOIN subcategorymaster ON productmaster.subcategoryid = subcategorymaster.subcategoryid INNER JOIN categorymaster ON subcategorymaster.categoryid = categorymaster.categoryid LEFT OUTER JOIN uimmaster ON productmaster.uim = uimmaster.sno LEFT OUTER JOIN suppliersdetails ON productmaster.supplierid = suppliersdetails.supplierid WHERE (productmaster.productid = @productid)");
            cmd.Parameters.Add("@productid", product_id);
            dtproducts = vdm.SelectQuery(cmd).Tables[0];
            DataTable dt_punabaka = new DataTable();
            DataTable dt_chennai = new DataTable();
            DataTable dt_manapakkam = new DataTable();
            DataTable dt_kuppam = new DataTable();

            List<Product_branch_data> ProductDetails = new List<Product_branch_data>();
            //foreach (DataRow dr in dt_products.Rows)
            //{
            Product_branch_data data = new Product_branch_data();
            //string productid = dr["productid"].ToString();
            //cmd = new SqlCommand("SELECT suppliersdetails.name, uimmaster.uim, productmaster.itemcode, productmaster.sku, productmaster.productname, productmoniter.qty, productmoniter.branchid, subcategorymaster.subcategoryname, categorymaster.category FROM productmaster INNER JOIN productmoniter ON productmaster.productid = productmoniter.productid INNER JOIN subcategorymaster ON productmaster.subcategoryid = subcategorymaster.subcategoryid INNER JOIN categorymaster ON subcategorymaster.categoryid = categorymaster.categoryid LEFT OUTER JOIN uimmaster ON productmaster.uim = uimmaster.sno LEFT OUTER JOIN suppliersdetails ON productmaster.supplierid = suppliersdetails.supplierid WHERE (productmaster.productid = @productid)");
            //cmd.Parameters.Add("@productid", productid);
            //dtproducts = vdm.SelectQuery(cmd).Tables[0];
            //if (dtproducts.Rows.Count > 0)
            //{
            data.productname = dtproducts.Rows[0]["productname"].ToString();
            data.uim = dtproducts.Rows[0]["uim"].ToString();
            data.category = dtproducts.Rows[0]["category"].ToString();
            data.subcategory = dtproducts.Rows[0]["subcategoryname"].ToString();
            data.itemcode = dtproducts.Rows[0]["itemcode"].ToString();
            data.sku = dtproducts.Rows[0]["sku"].ToString();
            data.suppliername = dtproducts.Rows[0]["name"].ToString();
            DataRow[] pun_qty = dtproducts.Select("branchid='2'");
            if (pun_qty.Length > 0)
            {
                DataTable punabaka_data = pun_qty.CopyToDataTable();

                data.punabaka_qty = punabaka_data.Rows[0]["qty"].ToString();
            }
            else
            {
                data.punabaka_qty = "NOT YET USED";
            }

            DataRow[] chn_qty = dtproducts.Select("branchid='4'");
            if (chn_qty.Length > 0)
            {
                DataTable chennai_data = chn_qty.CopyToDataTable();
                data.chennai_qty = chennai_data.Rows[0]["qty"].ToString();
            }
            else
            {
                data.chennai_qty = "NOT YET USED";
            }

            DataRow[] mpk_qty = dtproducts.Select("branchid='35'");
            if (mpk_qty.Length > 0)
            {
                DataTable manapakkam_data = mpk_qty.CopyToDataTable();
                data.manapakkam_qty = manapakkam_data.Rows[0]["qty"].ToString();
            }
            else
            {
                data.manapakkam_qty = "NOT YET USED";
            }

            DataRow[] kpm_qty = dtproducts.Select("branchid='1040'");
            if (kpm_qty.Length > 0)
            {
                DataTable kuppam_data = kpm_qty.CopyToDataTable();
                data.kuppam_qty = kuppam_data.Rows[0]["qty"].ToString();
            }
            else
            {
                data.kuppam_qty = "NOT YET USED";
            }
            ProductDetails.Add(data);
            //    }
            //}
            string response = GetJson(ProductDetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void getallproductsinfo_data(HttpContext context)
    {

        try
        {
            DataTable dtproducts = new DataTable();
            vdm = new SalesDBManager();
            string productid = context.Request["productid"];
            string branchid = context.Request["branch"];
            if (branchid == null)
            {
                branchid = context.Session["Po_BranchID"].ToString();
            }
            //cmd = new SqlCommand("SELECT productmaster.productid, productmaster.productname, productmaster.sku, productmaster.description, productmaster.itemcode, categorymaster.category, subcategorymaster.subcategoryname, uimmaster.uim, suppliersdetails.name FROM productmaster INNER JOIN categorymaster ON productmaster.prodctcode = categorymaster.cat_code INNER JOIN subcategorymaster ON (productmaster.sub_cat_code = subcategorymaster.sub_cat_code AND categorymaster.categoryid = subcategorymaster.categoryid) INNER JOIN uimmaster ON productmaster.uim = uimmaster.sno INNER JOIN suppliersdetails ON productmaster.supplierid = suppliersdetails.supplierid ORDER BY categorymaster.cat_code");
            cmd = new SqlCommand("SELECT productmaster.supplierid, productmaster.productid, productmaster.productname, productmaster.sku, productmaster.description, productmaster.itemcode, categorymaster.category, subcategorymaster.subcategoryname, uimmaster.uim,  suppliersdetails.name FROM productmaster INNER JOIN subcategorymaster ON productmaster.subcategoryid = subcategorymaster.subcategoryid INNER JOIN categorymaster ON subcategorymaster.categoryid = categorymaster.categoryid INNER JOIN uimmaster ON productmaster.uim = uimmaster.sno LEFT OUTER JOIN suppliersdetails ON productmaster.supplierid = suppliersdetails.supplierid ORDER BY categorymaster.categoryid");
            //cmd = new SqlCommand("SELECT productmoniter.minstock, productmoniter.maxstock, productmaster.imgpath, productmaster.itemcode, productmaster.bin, productmaster.productid, productmoniter.qty, productmoniter.branchid, productmaster.productname, productmaster.productcode, productmaster.sub_cat_code, productmaster.sku, productmaster.description, productmaster.sectionid, productmaster.brandid, productmaster.supplierid, productmaster.modifierset, uimmaster.uim, productmaster.availablestores, productmaster.color, productmaster.uim AS puim, productmoniter.price, categorymaster.category, suppliersdetails.name, categorymaster.cat_code FROM  productmaster INNER JOIN  categorymaster ON productmaster.productcode = categorymaster.cat_code INNER JOIN productmoniter ON productmaster.productid = productmoniter.productid LEFT OUTER JOIN suppliersdetails ON productmaster.supplierid = suppliersdetails.supplierid LEFT OUTER JOIN uimmaster ON uimmaster.sno = productmaster.uim GROUP BY productmaster.imgpath, productmaster.itemcode, productmaster.bin, productmaster.productid, productmoniter.qty, productmoniter.branchid, productmaster.productname, productmaster.productcode, productmaster.sub_cat_code, productmaster.sku, productmaster.description, productmaster.sectionid, productmaster.brandid, productmaster.supplierid, productmaster.modifierset, uimmaster.uim, productmaster.availablestores, productmaster.color, productmaster.uim, productmoniter.price, categorymaster.category, suppliersdetails.name, productmoniter.minstock, productmoniter.maxstock,categorymaster.cat_code ORDER BY categorymaster.cat_code,productmoniter.qty asc");//, subcategorymaster.subcategoryname     WHERE (productmoniter.branchid=@bid)
            //cmd.Parameters.Add("@bid", branchid);
            dtproducts = vdm.SelectQuery(cmd).Tables[0];
            List<ProductDetails> ProductDetails = new List<ProductDetails>();
            foreach (DataRow dr in dtproducts.Rows)
            {
                ProductDetails getproductdetails = new ProductDetails();
                getproductdetails.productname = dr["productname"].ToString();
                getproductdetails.sku = dr["sku"].ToString();
                getproductdetails.itemcode = dr["itemcode"].ToString();
                getproductdetails.description = dr["description"].ToString();
                getproductdetails.suppliername = dr["name"].ToString();
                getproductdetails.category = dr["category"].ToString();
                getproductdetails.subcatname = dr["subcategoryname"].ToString();
                getproductdetails.uim = dr["uim"].ToString();
                getproductdetails.productid = dr["productid"].ToString();
                getproductdetails.supplierid = dr["supplierid"].ToString();
                ProductDetails.Add(getproductdetails);
            }
            string response = GetJson(ProductDetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void getallproductsinfo(HttpContext context)
    {

        try
        {
            DataTable dtproducts = new DataTable();
            vdm = new SalesDBManager();
            string productid = context.Request["productid"];
            string branchid = context.Request["branch"];
            if (branchid == null)
            {
                branchid = context.Session["Po_BranchID"].ToString();
            }
            if (branchid == "All")
            {
                cmd = new SqlCommand("SELECT productmoniter.minstock, productmoniter.maxstock, productmaster.imgpath, productmaster.itemcode, productmaster.bin, productmaster.productid, productmoniter.qty, productmoniter.branchid, productmaster.productname, productmaster.productcode, productmaster.sub_cat_code, productmaster.sku, productmaster.description, productmaster.sectionid, productmaster.brandid, productmaster.supplierid, productmaster.modifierset, uimmaster.uim, productmaster.availablestores, productmaster.color, productmaster.uim AS puim, productmoniter.price, categorymaster.category, suppliersdetails.name, categorymaster.cat_code FROM  productmaster INNER JOIN  categorymaster ON productmaster.productcode = categorymaster.cat_code INNER JOIN productmoniter ON productmaster.productid = productmoniter.productid LEFT OUTER JOIN suppliersdetails ON productmaster.supplierid = suppliersdetails.supplierid LEFT OUTER JOIN uimmaster ON uimmaster.sno = productmaster.uim  GROUP BY productmaster.imgpath, productmaster.itemcode, productmaster.bin, productmaster.productid, productmoniter.qty, productmoniter.branchid, productmaster.productname, productmaster.productcode, productmaster.sub_cat_code, productmaster.sku, productmaster.description, productmaster.sectionid, productmaster.brandid, productmaster.supplierid, productmaster.modifierset, uimmaster.uim, productmaster.availablestores, productmaster.color, productmaster.uim, productmoniter.price, categorymaster.category, suppliersdetails.name, productmoniter.minstock, productmoniter.maxstock,categorymaster.cat_code ORDER BY categorymaster.cat_code,productmoniter.qty asc");//, subcategorymaster.subcategoryname
            }
            else
            {
                cmd = new SqlCommand("SELECT productmoniter.minstock, productmoniter.maxstock, productmaster.imgpath, productmaster.itemcode, productmaster.bin, productmaster.productid, productmoniter.qty, productmoniter.branchid, productmaster.productname, productmaster.productcode, productmaster.sub_cat_code, productmaster.sku, productmaster.description, productmaster.sectionid, productmaster.brandid, productmaster.supplierid, productmaster.modifierset, uimmaster.uim, productmaster.availablestores, productmaster.color, productmaster.uim AS puim, productmoniter.price, categorymaster.category, suppliersdetails.name, categorymaster.cat_code FROM  productmaster INNER JOIN  categorymaster ON productmaster.productcode = categorymaster.cat_code INNER JOIN productmoniter ON productmaster.productid = productmoniter.productid LEFT OUTER JOIN suppliersdetails ON productmaster.supplierid = suppliersdetails.supplierid LEFT OUTER JOIN uimmaster ON uimmaster.sno = productmaster.uim WHERE (productmoniter.branchid=@bid) GROUP BY productmaster.imgpath, productmaster.itemcode, productmaster.bin, productmaster.productid, productmoniter.qty, productmoniter.branchid, productmaster.productname, productmaster.productcode, productmaster.sub_cat_code, productmaster.sku, productmaster.description, productmaster.sectionid, productmaster.brandid, productmaster.supplierid, productmaster.modifierset, uimmaster.uim, productmaster.availablestores, productmaster.color, productmaster.uim, productmoniter.price, categorymaster.category, suppliersdetails.name, productmoniter.minstock, productmoniter.maxstock,categorymaster.cat_code ORDER BY categorymaster.cat_code,productmoniter.qty asc");//, subcategorymaster.subcategoryname
                cmd.Parameters.Add("@bid", branchid);
            }
            dtproducts = vdm.SelectQuery(cmd).Tables[0];
            List<ProductDetails> ProductDetails = new List<ProductDetails>();
            foreach (DataRow dr in dtproducts.Rows)
            {
                string bid = dr["branchid"].ToString();
                ProductDetails getproductdetails = new ProductDetails();
                getproductdetails.productname = dr["productname"].ToString();
                getproductdetails.productcode = dr["productcode"].ToString();
                getproductdetails.shortname = dr["sub_cat_code"].ToString();
                getproductdetails.sku = dr["sku"].ToString();
                getproductdetails.bin = dr["bin"].ToString();
                getproductdetails.itemcode = dr["itemcode"].ToString();
                getproductdetails.description = dr["description"].ToString();
                getproductdetails.sectionid = dr["sectionid"].ToString();
                getproductdetails.brandid = dr["brandid"].ToString();
                getproductdetails.supplierid = dr["supplierid"].ToString();
                getproductdetails.category = dr["category"].ToString();
                getproductdetails.modifierset = dr["modifierset"].ToString();
                string qty = dr["qty"].ToString();
                double quantity = 0;
                if (qty == "0" || qty == "")
                {
                    getproductdetails.moniterqty = quantity.ToString();
                }
                else
                {
                    quantity = Convert.ToDouble(dr["qty"].ToString());
                    quantity = Math.Round(quantity, 2);
                    getproductdetails.moniterqty = quantity.ToString();
                }
                getproductdetails.availablestores1 = dr["availablestores"].ToString();
                getproductdetails.color = dr["color"].ToString();
                getproductdetails.uim = dr["uim"].ToString();
                getproductdetails.puim = dr["puim"].ToString();
                getproductdetails.price = dr["price"].ToString();
                getproductdetails.productid = dr["productid"].ToString();
                getproductdetails.suppliername = dr["name"].ToString();
                getproductdetails.minstock = dr["minstock"].ToString();
                getproductdetails.maxstock = dr["maxstock"].ToString();
                getproductdetails.imgpath = dr["imgpath"].ToString();
                getproductdetails.ftplocation = "ftp://182.18.138.228/PURCHASE/";
                ProductDetails.Add(getproductdetails);
            }
            string response = GetJson(ProductDetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class Inward_Issue //new
    {
        public string productid { get; set; }
        public string productname { get; set; }
        public string quantity { get; set; }
        public string PerUnitRs { get; set; }
        public string uim { get; set; }
        public string uom { get; set; }
    }

    private void get_Inward_Details_Outward(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string inward_no = context.Request["inward_no"].ToString();
            string branchid = context.Session["Po_BranchID"].ToString();
            cmd = new SqlCommand("SELECT productmaster.productname, subinwarddetails.productid, productmoniter.qty, uimmaster.uim, productmaster.uim AS puim, productmoniter.price FROM uimmaster INNER JOIN productmaster INNER JOIN subinwarddetails INNER JOIN inwarddetails ON subinwarddetails.in_refno = inwarddetails.sno ON productmaster.productid = subinwarddetails.productid ON uimmaster.sno = productmaster.uim INNER JOIN productmoniter ON subinwarddetails.productid = productmoniter.productid WHERE (inwarddetails.mrnno = @mrnno) AND (inwarddetails.branchid = @branchid) AND (productmoniter.branchid = @branch_id)");
            cmd.Parameters.Add("@mrnno", inward_no);
            cmd.Parameters.Add("@branchid", branchid);
            cmd.Parameters.Add("@branch_id", branchid);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<Inward_Issue> sub_inward_list = new List<Inward_Issue>();
            foreach (DataRow dr in routes.Rows)
            {
                Inward_Issue sub_inward_det = new Inward_Issue();
                sub_inward_det.productname = dr["productname"].ToString();
                sub_inward_det.productid = dr["productid"].ToString();
                string qty = dr["qty"].ToString();
                double quantity = 0;
                if (qty == "0" || qty == "")
                {
                    sub_inward_det.quantity = quantity.ToString();
                }
                else
                {
                    quantity = Convert.ToDouble(dr["qty"].ToString());
                    quantity = Math.Round(quantity, 2);
                    sub_inward_det.quantity = quantity.ToString();
                }
                sub_inward_det.uim = dr["uim"].ToString();
                sub_inward_det.uom = dr["puim"].ToString();
                sub_inward_det.PerUnitRs = dr["price"].ToString();
                sub_inward_list.Add(sub_inward_det);
            }

            string response = GetJson(sub_inward_list);
            context.Response.Write(response);

        }
        catch
        {
        }
    }

    private void get_supplier_details_id(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            string branchid = context.Session["Po_BranchID"].ToString();
            string supplierid = context.Request["supplierid"].ToString();
            cmd = new SqlCommand("SELECT supplierphoto,contactnumber,insurance,insuranceamount,warrantytype,warranty,name,description,companyname,contactname,street1,city,state,country,zipcode,mobileno,emailid,websiteurl,status,supplierid,suppliercode FROM suppliersdetails WHERE supplierid=@supplierid");
            cmd.Parameters.Add("@supplierid", supplierid);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<supplierdetails> supplierdetails = new List<supplierdetails>();
            foreach (DataRow dr in routes.Rows)
            {
                supplierdetails getsupplier = new supplierdetails();
                getsupplier.suppliername = dr["name"].ToString();
                getsupplier.description = dr["description"].ToString();
                getsupplier.companyname = dr["companyname"].ToString();
                getsupplier.contactname = dr["contactname"].ToString();
                getsupplier.street1 = dr["street1"].ToString();
                getsupplier.city = dr["city"].ToString();
                getsupplier.state = dr["state"].ToString();
                getsupplier.country = dr["country"].ToString();
                getsupplier.zipcode = dr["zipcode"].ToString();
                getsupplier.mobileno = dr["mobileno"].ToString();
                getsupplier.emailid = dr["emailid"].ToString();
                getsupplier.websiteurl = dr["websiteurl"].ToString();
                getsupplier.insurecetype = dr["insurance"].ToString();
                getsupplier.insurence = dr["insuranceamount"].ToString();
                getsupplier.warranytype = dr["warrantytype"].ToString();
                getsupplier.contactnumber = dr["contactnumber"].ToString();
                getsupplier.warranty = dr["warranty"].ToString();
                var status = dr["status"].ToString();
                if (status == "True")
                {
                    getsupplier.status = "Active";
                }
                if (status == "False")
                {
                    getsupplier.status = "InActive";
                }
                getsupplier.supplierid = dr["supplierid"].ToString();
                getsupplier.imgpath = dr["supplierphoto"].ToString();
                getsupplier.vendorcode = dr["suppliercode"].ToString();
                getsupplier.ftplocation = "ftp://182.18.138.228/PURCHASE/";
                supplierdetails.Add(getsupplier);
            }
            string response = GetJson(supplierdetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_inward_details_productid(HttpContext context)
    {
        try
        {
            vdm = new SalesDBManager();
            DateTime ServerDateCurrentdate = SalesDBManager.GetTime(vdm.conn);
            string branchid = context.Session["Po_BranchID"].ToString();
            string productid = context.Request["productid"].ToString();
            cmd = new SqlCommand("SELECT TOP (2) subinwarddetails.quantity, inwarddetails.inwarddate, productmaster.productname, subinwarddetails.perunit, subinwarddetails.productid FROM inwarddetails INNER JOIN subinwarddetails ON inwarddetails.sno = subinwarddetails.in_refno INNER JOIN productmaster ON subinwarddetails.productid = productmaster.productid WHERE (subinwarddetails.productid = @productid) AND (inwarddetails.branchid = @branchid) ORDER BY inwarddetails.sno DESC");
            cmd.Parameters.Add("@productid", productid);
            cmd.Parameters.Add("@branchid", branchid);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            List<SubInward> subinwardlist = new List<SubInward>();
            foreach (DataRow dr in routes.Rows)
            {
                SubInward getsubinward = new SubInward();
                getsubinward.hdnproductsno = dr["productid"].ToString();
                getsubinward.productname = dr["productname"].ToString();
                double quantity = Convert.ToDouble(dr["quantity"].ToString());
                quantity = Math.Round(quantity, 2);
                getsubinward.quantity = quantity.ToString();
                getsubinward.PerUnitRs = dr["perunit"].ToString();
                getsubinward.inword_refno = ((DateTime)dr["inwarddate"]).ToString("dd-MM-yyyy"); //dr["inwarddate"].ToString();
                subinwardlist.Add(getsubinward);
            }
            string response = GetJson(subinwardlist);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_product_details_category(HttpContext context)
    {
        try
        {
            DataTable dtproducts = new DataTable();
            vdm = new SalesDBManager();
            string branchid = context.Session["Po_BranchID"].ToString();
            string categoryid = context.Request["categoryid"];
            cmd = new SqlCommand("SELECT productmaster.imgpath, productmaster.itemcode, productmaster.bin, productmaster.productid, productmoniter.qty, productmoniter.branchid, productmaster.productname, productmaster.productcode, productmaster.sub_cat_code, productmaster.sku, productmaster.description, productmaster.sectionid, productmaster.brandid, productmaster.supplierid, productmaster.modifierset, uimmaster.uim, productmaster.availablestores, productmaster.color, productmaster.uim AS puim, productmoniter.price, categorymaster.category, subcategorymaster.subcategoryname, suppliersdetails.name FROM productmaster INNER JOIN subcategorymaster ON productmaster.subcategoryid = subcategorymaster.subcategoryid INNER JOIN categorymaster ON subcategorymaster.categoryid = categorymaster.categoryid LEFT OUTER JOIN productmoniter ON productmaster.productid = productmoniter.productid LEFT OUTER JOIN suppliersdetails ON productmaster.supplierid = suppliersdetails.supplierid LEFT OUTER JOIN uimmaster ON uimmaster.sno = productmaster.uim WHERE (productmoniter.branchid = @bid) AND (productmaster.sectionid = @categoryid)");
            cmd.Parameters.Add("@bid", branchid);
            cmd.Parameters.Add("@categoryid", categoryid);
            dtproducts = vdm.SelectQuery(cmd).Tables[0];
            List<ProductDetails> ProductDetails = new List<ProductDetails>();
            foreach (DataRow dr in dtproducts.Rows)
            {
                string bid = dr["branchid"].ToString();
                ProductDetails getproductdetails = new ProductDetails();
                getproductdetails.productname = dr["productname"].ToString();
                getproductdetails.productcode = dr["productcode"].ToString();
                getproductdetails.shortname = dr["sub_cat_code"].ToString();
                getproductdetails.sku = dr["sku"].ToString();
                getproductdetails.bin = dr["bin"].ToString();
                getproductdetails.itemcode = dr["itemcode"].ToString();
                getproductdetails.description = dr["description"].ToString();
                getproductdetails.sectionid = dr["sectionid"].ToString();
                getproductdetails.brandid = dr["brandid"].ToString();
                getproductdetails.supplierid = dr["supplierid"].ToString();
                getproductdetails.category = dr["category"].ToString();
                getproductdetails.modifierset = dr["modifierset"].ToString();
                string qty = dr["qty"].ToString();
                double quantity = 0;
                if (qty == "0" || qty == "")
                {
                    getproductdetails.moniterqty = quantity.ToString();
                }
                else
                {
                    quantity = Convert.ToDouble(dr["qty"].ToString());
                    quantity = Math.Round(quantity, 2);
                    getproductdetails.moniterqty = quantity.ToString();
                }
                getproductdetails.availablestores1 = dr["availablestores"].ToString();
                getproductdetails.color = dr["color"].ToString();
                getproductdetails.uim = dr["uim"].ToString();
                getproductdetails.puim = dr["puim"].ToString();
                getproductdetails.price = dr["price"].ToString();
                getproductdetails.productid = dr["productid"].ToString();
               
                getproductdetails.subcatname = dr["subcategoryname"].ToString();
                getproductdetails.suppliername = dr["name"].ToString();
                getproductdetails.imgpath = dr["imgpath"].ToString();
                getproductdetails.ftplocation = "ftp://182.18.138.228/PURCHASE/";
                ProductDetails.Add(getproductdetails);
            }
            string response = GetJson(ProductDetails);
            context.Response.Write(response);
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    public class loginDetails //new
    {
        public string sno { get; set; }
        public string employename { get; set; }
        public string userid { get; set; }
        public string leveltype { get; set; }
        public string uim { get; set; }
        public string uom { get; set; }
    }

    private void get_logininfo_details(HttpContext context)
    {
        try
        {
            DataTable dtlogininfos = new DataTable();
            vdm = new SalesDBManager();
            cmd = new SqlCommand("SELECT sno, employename, userid, password, emailid, phone, branchtype, leveltype, departmentid, branchid, hempid, loginflag FROM  employe_details");
            dtlogininfos = vdm.SelectQuery(cmd).Tables[0];
            List<loginDetails> loginDetails = new List<loginDetails>();
            foreach (DataRow dr in dtlogininfos.Rows)
            {
                string bid = dr["branchid"].ToString();
                loginDetails getloginDetails = new loginDetails();
                
                string qty = dr["qty"].ToString();
                double quantity = 0;
                
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }
    public class employeedetails
    {
        public string sno { get; set; }
        public string employeename { get; set; }
        public string logintime { get; set; }
        public string logouttime { get; set; }
        public string ipaddress { get; set; }
        public string devicetype { get; set; }
        public string leveltype { get; set; }
        public string loginstatus { get; set; }
        public string sessiontimeout { get; set; }
    }
    private void get_employee_details(HttpContext context)
    {
        string BranchID = context.Session["Po_BranchID"].ToString();
        cmd = new SqlCommand("SELECT  sno, employename, emailid, phone, branchtype, leveltype, departmentid, branchid, loginflag, userid, password FROM  employe_details WHERE branchid=@branchid ");
        cmd.Parameters.Add("@branchid", BranchID);
        DataTable dtemployee = vdm.SelectQuery(cmd).Tables[0];
        List<employeedetails> emloyeeedetalis = new List<employeedetails>();
        if (dtemployee.Rows.Count > 0)
        {
            foreach (DataRow dr in dtemployee.Rows)
            {
                employeedetails details = new employeedetails();
                details.sno = dr["sno"].ToString();
                details.employeename = dr["employename"].ToString();
                details.leveltype = dr["leveltype"].ToString();
                string status = dr["loginflag"].ToString();
                if (status == "False")
                {
                    status = "InActive";
                }
                if (status == "True")
                {
                    status = "Active";
                }
                details.loginstatus = status;
                emloyeeedetalis.Add(details);
            }
            string response = GetJson(emloyeeedetalis);
            context.Response.Write(response);
        }
    }
    private void btn_getlogininfoemployee_details(HttpContext context)
    {
        string BranchID = context.Session["Po_BranchID"].ToString();
        string employeeid = context.Request["employeeid"];
        string fromdate = context.Request["fromdate"];
        string todate = context.Request["todate"];
        string date = context.Request["date"];
        DateTime dtfromdate = Convert.ToDateTime(fromdate);
        DateTime dttodate = Convert.ToDateTime(todate);
        DateTime dtdate = Convert.ToDateTime(date);
        if (employeeid == "" || employeeid == null)
        {
            cmd = new SqlCommand("SELECT  employe_details.sno, employe_details.employename, logininfo.logintime, logininfo.logouttime, logininfo.ipaddress, logininfo.devicetype, employe_details.branchid FROM  employe_details INNER JOIN logininfo ON employe_details.sno = logininfo.userid WHERE  (employe_details.branchid = @branchid) AND (logininfo.logintime BETWEEN @d1 AND @d2)");
            cmd.Parameters.Add("@d1", GetLowDate(dtdate));
            cmd.Parameters.Add("@d2", GetHighDate(dtdate));
            cmd.Parameters.Add("@branchid", BranchID);
        }
        else
        {
            cmd = new SqlCommand("SELECT  employe_details.sno, employe_details.employename, logininfo.logintime, logininfo.logouttime, logininfo.ipaddress, logininfo.devicetype, employe_details.branchid FROM  employe_details INNER JOIN logininfo ON employe_details.sno = logininfo.userid WHERE (employe_details.branchid = @branchid) AND (logininfo.logintime BETWEEN @d1 AND @d2) AND (employe_details.sno = @userid)");
            cmd.Parameters.Add("@userid", employeeid);
            cmd.Parameters.Add("@d1", GetLowDate(dtfromdate));
            cmd.Parameters.Add("@d2", GetHighDate(dttodate));
            cmd.Parameters.Add("@branchid", BranchID);
        }
        DataTable dtloginfo = vdm.SelectQuery(cmd).Tables[0];
        List<employeedetails> emloyeeedetalis = new List<employeedetails>();
        if (dtloginfo.Rows.Count > 0)
        {
            foreach (DataRow dr in dtloginfo.Rows)
            {
                employeedetails details = new employeedetails();
                details.sno = dr["sno"].ToString();
                details.employeename = dr["employename"].ToString();
                details.logintime = dr["logintime"].ToString();
                details.logouttime = dr["logouttime"].ToString();
                details.ipaddress = dr["ipaddress"].ToString();
                details.devicetype = dr["devicetype"].ToString();
                emloyeeedetalis.Add(details);
            }
            string response = GetJson(emloyeeedetalis);
            context.Response.Write(response);
        }
    }


    public class projectdetails
    {
        public string sno { get; set; }
        public string projectname { get; set; }
        public string remarks { get; set; }
        public string deescription { get; set; }
        public string startingdate { get; set; }
        public string approvedby { get; set; }
        public string exicuationtime { get; set; }
        public string budjet { get; set; }
        public string btnval { get; set; }
        public string description { get; set; }
        public List<subprojectdetails> project_array { get; set; }

    }
    public class subprojectdetails
    {
        public string sno { get; set; }
        public string itemdetails { get; set; }
        public string description { get; set; }
        public string cost { get; set; }
        public string qty { get; set; }
    }

    public class get_projectdetails
    {
        public List<projectdetails> projectinfodetails { get; set; }
        public List<subprojectdetails> subprojectinfodetails { get; set; }
    }


    private void save_edit_projectinfo_click(HttpContext context)
    {
        try
        {
            var js = new JavaScriptSerializer();
            var title1 = context.Request.Params[1];
            projectdetails obj = js.Deserialize<projectdetails>(title1);
            string projectname = obj.projectname;
            string description = obj.deescription;
            string startingdate = obj.startingdate;
            string approvedby = obj.approvedby;
            string remarks = obj.remarks;
            string execuitiontime = obj.exicuationtime;
            string budjet = obj.budjet;
            string btnval = obj.btnval;
            DateTime dtstartdate = Convert.ToDateTime(startingdate);
            vdm = new SalesDBManager();
            if (btnval == "Raise")
            {
                cmd = new SqlCommand("insert into projectinfo_detailes (projectname,description,startingdate,approvedby,remarks, execuitiontime, budjet) values (@projectname,@description,@startingdate,@approvedby,@remarks,@execuitiontime,@budjet)");
                cmd.Parameters.Add("@projectname", projectname);
                cmd.Parameters.Add("@description", description);
                cmd.Parameters.Add("@startingdate", startingdate);
                cmd.Parameters.Add("@approvedby", approvedby);
                cmd.Parameters.Add("@remarks", remarks);
                cmd.Parameters.Add("@execuitiontime", execuitiontime);
                cmd.Parameters.Add("@budjet", budjet);
                vdm.insert(cmd);
                cmd = new SqlCommand("select MAX(projectid) as poinfo from projectinfo_detailes");
                DataTable dtpo = vdm.SelectQuery(cmd).Tables[0];
                string refno = dtpo.Rows[0]["poinfo"].ToString();
                foreach (subprojectdetails o in obj.project_array)
                {
                    if (o.itemdetails != "" && o.itemdetails != null)
                    {
                        cmd = new SqlCommand("insert into project_sub_detailes(refno, itemstobeneeded, description, qty, price)values(@refno, @itemdetails,@description, @qty, @price)");
                        cmd.Parameters.Add("@refno", refno);
                        cmd.Parameters.Add("@itemdetails", o.itemdetails);
                        cmd.Parameters.Add("@description", o.description);
                        cmd.Parameters.Add("@qty", o.qty);
                        cmd.Parameters.Add("@price", o.cost);
                        vdm.insert(cmd);
                    }
                }
                string msg = " Project Details Successfully Added";
                string Response = GetJson(msg);
                context.Response.Write(Response);
            }
        }
        catch (Exception ex)
        {
            string Response = GetJson(ex.Message);
            context.Response.Write(Response);
        }
    }

    private void get_projectinfo_detailes(HttpContext context)
    {
        cmd = new SqlCommand("SELECT projectinfo_detailes.projectname, projectinfo_detailes.startingdate, projectinfo_detailes.execuitiontime, projectinfo_detailes.budjet, projectinfo_detailes.approvedby,  projectinfo_detailes.description  FROM  project_sub_detailes INNER JOIN projectinfo_detailes ON project_sub_detailes.refno = projectinfo_detailes.projectid");
        DataTable dtprojectdetails = vdm.SelectQuery(cmd).Tables[0];
        List<projectdetails> projectdetails = new List<projectdetails>();
        if (dtprojectdetails.Rows.Count > 0)
        {
            foreach (DataRow dr in dtprojectdetails.Rows)
            {
                projectdetails details = new projectdetails();
               // details.sno = dr["sno"].ToString();
                details.projectname = dr["projectname"].ToString();
                details.startingdate = dr["startingdate"].ToString();
                details.exicuationtime = dr["execuitiontime"].ToString();
                details.budjet = dr["budjet"].ToString();
                details.approvedby = dr["approvedby"].ToString();
                details.description = dr["description"].ToString();
                projectdetails.Add(details);
            }
            string response = GetJson(projectdetails);
            context.Response.Write(response);
        }
    }
}







    





                

   