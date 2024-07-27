﻿using CodeToCure_MVC.Models;
using Data.DataAccess;
using Data.Dtos;
using Data.Models;
using Microsoft.AspNetCore.Html;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.AspNetCore.SignalR;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Services.PatientReportServices;
using System.Web;
using static CodeToCure_MVC.Models.ModalDtos;
using static CodeToCure_MVC.Models.MVCAppEnum;
using static Data.Dtos.CustomClasses;

namespace CodeToCure_MVC.Controllers
{
    public class PatientReportController : Controller
    {
        #region Constructor
        private IConfiguration _config;
        private IHttpContextAccessor _httpContextAccessor;
        private readonly bool issinglesignon;
        private PublicClaimObjects? _PublicClaimObjects;
        private readonly string _bodystring = "";
        private readonly IPatientReportService srv;
        public PatientReportController(IConfiguration config, IHttpContextAccessor httpContextAccessor, IPatientReportService srv)
        {
            this._config = config;
            this._httpContextAccessor = httpContextAccessor;
            this._bodystring = StaticPublicObjects.ado.GetRequestBodyString().Result;
            this.issinglesignon = StaticPublicObjects.ado.GetIsSingleSignOn();
            this._PublicClaimObjects = StaticPublicObjects.ado.GetPublicClaimObjects();
            this.srv = srv;
        }
        #endregion Constructor

        public IActionResult Index()
        {
            ViewBag.UserName = _PublicClaimObjects.username;
            ViewBag.GUID = Guid.NewGuid().ToString().ToLower();
            return View();
        }

        [HttpPost]
        public IActionResult GetFilterData_PatientReport_List([FromBody] ReportParams _ReportParams)
        {
            ReportResponse reportResponse = new ReportResponse();
            try
            {
                List<Dynamic_SP_Params> List_Dynamic_SP_Params = new List<Dynamic_SP_Params>();
                ModalFunctions.GetKendoFilter(ref _ReportParams, ref List_Dynamic_SP_Params, _PublicClaimObjects, true);

                List<P_Get_PatientReport_List> ResultList = StaticPublicObjects.ado.P_Get_Generic_List_SP<P_Get_PatientReport_List>("P_Get_PatientReport_List", ref List_Dynamic_SP_Params);

                reportResponse.TotalRowCount = ModalFunctions.GetValueFromReturnParameter<long>(List_Dynamic_SP_Params, "TotalRowCount", typeof(long));
                reportResponse.ResultData = ResultList;
                reportResponse.response_code = true;
            }
            catch (Exception ex)
            {
                StaticPublicObjects.logFile.ErrorLog(FunctionName: "GetFilterData_PatientReport_List", SmallMessage: ex.Message, Message: ex.ToString());
                reportResponse.TotalRowCount = 0;
                reportResponse.ResultData = null;
                reportResponse.response_code = false;
            }
            return Globals.GetAjaxJsonReturn(reportResponse);
        }
        [HttpPost]
        public IActionResult GetFilterData_ReportTemplate_List([FromBody] ReportParams _ReportParams)
        {
            ReportResponse reportResponse = new ReportResponse();
            try
            {
                List<Dynamic_SP_Params> List_Dynamic_SP_Params = new List<Dynamic_SP_Params>();
                ModalFunctions.GetKendoFilter(ref _ReportParams, ref List_Dynamic_SP_Params, _PublicClaimObjects, true);

                List<P_Get_PatientReport_List> ResultList = StaticPublicObjects.ado.P_Get_Generic_List_SP<P_Get_PatientReport_List>("P_Get_ReportTemplate_List", ref List_Dynamic_SP_Params);

                reportResponse.TotalRowCount = ModalFunctions.GetValueFromReturnParameter<long>(List_Dynamic_SP_Params, "TotalRowCount", typeof(long));
                reportResponse.ResultData = ResultList;
                reportResponse.response_code = true;
            }
            catch (Exception ex)
            {
                StaticPublicObjects.logFile.ErrorLog(FunctionName: "GetFilterData_ReportTemplate_List", SmallMessage: ex.Message, Message: ex.ToString());
                reportResponse.TotalRowCount = 0;
                reportResponse.ResultData = null;
                reportResponse.response_code = false;
            }
            return Globals.GetAjaxJsonReturn(reportResponse);
        }


        [HttpPost]
        public ActionResult AddOrEdit_PatientReport([FromBody] string Json)
        {
            P_ReturnMessage_Result response = srv.P_AddOrEdit_Patient_Report(Json);
            if (response.ReturnCode == false)
                StaticPublicObjects.logFile.ErrorLog(FunctionName: "AddOrEdit_PatientReport", SmallMessage: response.ReturnText!, Message: response.ReturnText!);
            return Content(JsonConvert.SerializeObject(response));
        }
        [HttpPost]
        public ActionResult Remove_PatientReport([FromBody] string Ery_PR_ID)
        {
            int PR_ID = Crypto.DecryptNumericToStringWithOutNull(Ery_PR_ID);
            P_ReturnMessage_Result response = StaticPublicObjects.ado.P_SP_Remove_Generic_Result("T_Patient_Report", "PR_ID", PR_ID);
            if (response.ReturnCode == false)
                StaticPublicObjects.logFile.ErrorLog(FunctionName: "Remove_PatientReport", SmallMessage: response.ReturnText!, Message: response.ReturnText!);
            return Content(JsonConvert.SerializeObject(response));
        }
        [HttpPost]
        public ActionResult IsTemplate_PatientReport([FromBody] string Ery_PR_ID)
        {
            int PR_ID = Crypto.DecryptNumericToStringWithOutNull(Ery_PR_ID);
            P_ReturnMessage_Result response = srv.P_PatientReport_IsTemplate(PR_ID);
            if (response.ReturnCode == false)
                StaticPublicObjects.logFile.ErrorLog(FunctionName: "IsTemplate_PatientReport", SmallMessage: response.ReturnText!, Message: response.ReturnText!);
            return Content(JsonConvert.SerializeObject(response));
        }


        [HttpPost]
        public async Task<IActionResult> DownloadPatientReport([FromBody] string Ery_PR_ID)
        {
            int PR_ID = Crypto.DecryptNumericToStringWithOutNull(Ery_PR_ID);

            if (PR_ID == 0)
            {
                PR_ID = 1;
            }
            string htmlContent = await srv.GetPatientReportHTML(PR_ID);
            byte[] pdf = await srv.CreatePatientReportPDF(htmlContent);
            string base64Pdf = Convert.ToBase64String(pdf);
            return Content(JsonConvert.SerializeObject(base64Pdf));
            //return File(pdf, "application/pdf", "PatientReport.pdf");
        }

        [HttpPost]
        public IActionResult GetAddEditPatientReportModal([FromBody] JObject request)
        {
            var htmlString = "";
            string? Ery_PR_ID = "";
            bool? IsTemplate = false;
            if (request is not null)
            {
                Ery_PR_ID = request["Ery_PR_ID"]?.ToString();
                IsTemplate = Convert.ToBoolean(request["IsTemplate"]);
            }
            int Modal_ID = Crypto.DecryptNumericToStringWithOutNull(Ery_PR_ID);


            var objInvoice = srv.S_Invoice_List_Str();
            List<SelectDropDownList>? InvoiceList = objInvoice.Drop_List;
            var invoiceOptions = objInvoice.Drop_Options;

            var objRT = srv.S_Report_Template_List_Str(Modal_ID);
            List<SelectDropDownList>? RTList = objRT.Drop_List;
            var rtOptions = objRT.Drop_Options;

            P_Get_Patient_Report_Detail Patient_Report_Detail = new P_Get_Patient_Report_Detail();
            if (Modal_ID > 0)
            {
                Patient_Report_Detail = srv.P_Get_Patient_Report_Detail(Modal_ID);
            }

            var DefaultRowHeadHtml = GetTableRowHtml(0, 0, "", false, true, false);
            var DefaultRowBodyHtml = GetTableRowHtml(0, 0, "", "", false, false);



            if (Modal_ID > 0)
            {
                var invoiceSelectedOption = string.Join("", InvoiceList!.Select(x => $"<option value='{x.code}' {(Convert.ToInt32(x.code) == Patient_Report_Detail.InvoiceNo ? "selected" : "")}>{x.name}</option>"));
                var rtSelectedOption = string.Join("", RTList!.Select(x => $"<option value='{x.code}' {(Convert.ToInt32(x.code) == Patient_Report_Detail.RT_ID ? "selected" : "")}>{x.name}</option>"));

                htmlString += "<input type='text' class='form-control d-none' id='PR_ID' value='" + Modal_ID + "'>";
                htmlString += "<div class='row'>";
                htmlString += "<div class='col-lg-6 col-md-6 col-sm-6 mb-3'>";
                htmlString += "<select id='selectInvoice' class='control-select form-control select2 w-100' type='text' required>";
                htmlString += "<option value='' selected>Select Inovice</option>";
                if (IsTemplate == true)
                {
                    htmlString += invoiceOptions;
                }
                else
                {
                    htmlString += invoiceSelectedOption;
                }
                htmlString += "</select>";
                htmlString += "</div>";
                htmlString += "<div class='col-lg-6 col-md-6 col-sm-6 mb-3'>";
                htmlString += "<select id='selectRT_ID' class='control-select form-control select2 w-100' type='text' required>";
                htmlString += "<option value='' selected>Select Report Template</option>";
                htmlString += rtSelectedOption;
                htmlString += "</select>";
                htmlString += "</div>";
                htmlString += "</div>";

                htmlString += "<div class='row'>";
                htmlString += "<div class='col-lg-4 col-md-4 col-sm-4'>";
                htmlString += "<div class='form-floating mb-3'>";
                htmlString += "<input type='text' class='form-control' id='ReportTitle' placeholder='Report Title' value='" + Patient_Report_Detail.Report_Title + "'>";
                htmlString += "<label for='ReportTitle'>Report Title</label>";
                htmlString += "</div>";
                htmlString += "</div>";
                htmlString += "<div class='col-lg-4 col-md-4 col-sm-4'>";
                htmlString += "<div class='form-floating mb-3'>";
                htmlString += "<input type='text' class='form-control' id='ViralStatus' placeholder='Viral Status' value='" + Patient_Report_Detail.ViralStatus + "'>";
                htmlString += "<label for='ViralStatus'>Viral Status</label>";
                htmlString += "</div>";
                htmlString += "</div>";
                htmlString += "<div class='col-lg-4 col-md-4 col-sm-4'>";
                htmlString += "<div class='form-floating mb-3'>";
                htmlString += "<input type='text' class='form-control' id='Indication' placeholder='Indication' value='" + Patient_Report_Detail.Indication + "'>";
                htmlString += "<label for='Indication'>Indication</label>";
                htmlString += "</div>";
                htmlString += "</div>";
                htmlString += "</div>";
            }
            else
            {
                htmlString += "<div class='row'>";
                htmlString += "<div class='col-lg-6 col-md-6 col-sm-6 mb-3'>";
                htmlString += "<select id='selectInvoice' class='control-select form-control select2 w-100' type='text' required>";
                htmlString += "<option value='' selected>Select Inovice</option>";
                htmlString += invoiceOptions;
                htmlString += "</select>";
                htmlString += "</div>";
                htmlString += "<div class='col-lg-6 col-md-6 col-sm-6 mb-3'>";
                htmlString += "<select id='selectRT_ID' class='control-select form-control select2 w-100' type='text' required>";
                htmlString += "<option value='' selected>Select Report Template</option>";
                htmlString += rtOptions;
                htmlString += "</select>";
                htmlString += "</div>";
                htmlString += "</div>";

                htmlString += "<div class='row'>";                
                htmlString += "<div class='col-lg-4 col-md-4 col-sm-4'>";
                htmlString += "<div class='form-floating mb-3'>";
                htmlString += "<input type='text' class='form-control' id='ReportTitle' placeholder='Report Title'>";
                htmlString += "<label for='ReportTitle'>Report Title</label>";
                htmlString += "</div>";
                htmlString += "</div>";
                htmlString += "<div class='col-lg-4 col-md-4 col-sm-4'>";
                htmlString += "<div class='form-floating mb-3'>";
                htmlString += "<input type='text' class='form-control' id='ViralStatus' placeholder='Viral Status'>";
                htmlString += "<label for='ViralStatus'>Viral Status</label>";
                htmlString += "</div>";
                htmlString += "</div>";
                htmlString += "<div class='col-lg-4 col-md-4 col-sm-4'>";
                htmlString += "<div class='form-floating mb-3'>";
                htmlString += "<input type='text' class='form-control' id='Indication' placeholder='Indication'>";
                htmlString += "<label for='Indication'>Indication</label>";
                htmlString += "</div>";
                htmlString += "</div>";
                htmlString += "</div>";
            }

            htmlString += "<hr/>";
            htmlString += "<h5 class='mb-3'>Add Report Header Section</h5>";

            htmlString += "<div id='tblHeaderSection' class='table-responsive'>";
            htmlString += "<table class='table table-striped custom-table'>";
            htmlString += "<thead>";
            htmlString += "<tr>";
            htmlString += "<th class='text-center'>Actions</th>";
            htmlString += "<th class='text-center'>#</th>";
            htmlString += "<th class='text-center'>Header Text</th>";
            htmlString += "<th class='text-center'>Header Value</th>";
            htmlString += "</tr>";
            htmlString += "</thead>";
            htmlString += "<tbody>";

            if (Modal_ID > 0)
            {
                if (Patient_Report_Detail.Patient_Report_Section_Header is not null || Patient_Report_Detail.Patient_Report_Section_Header!.Count() > 0)
                {
                    foreach (var item in Patient_Report_Detail.Patient_Report_Section_Header!.Select((value, index) => new { value, index }))
                    {

                        bool showRemoveButton = item.index > 0 || Patient_Report_Detail.Patient_Report_Section_Header!.Count > 1;
                        htmlString += DefaultRowHeadHtml;
                        htmlString += GetTableRowHtml(item.index + 1, item.value.PRD_ID, item.value.Report_Header_Text!, item.value.Report_Header_Value!, true, showRemoveButton);
                    }
                }
            }
            else
            {
                htmlString += DefaultRowHeadHtml;
                htmlString += GetTableRowHtml(1, 0, "", false, true, false);
            }

            htmlString += "</tbody>";
            htmlString += "</table>";
            htmlString += "</div>";

            htmlString += "<hr/>";
            htmlString += "<h5>Add Report Body Section</h5>";

            htmlString += "<div id='tblBodySection' class='table-responsive'>";
            htmlString += "<table class='table table-striped custom-table'>";
            htmlString += "<thead>";
            htmlString += "<tr>";
            htmlString += "<th class='text-center'>Actions</th>";
            htmlString += "<th class='text-center'>#</th>";
            htmlString += "<th class='text-center'>Body Text</th>";
            htmlString += "<th class='text-center'>Body Value</th>";
            htmlString += "</tr>";
            htmlString += "</thead>";
            htmlString += "<tbody>";

            if (Modal_ID > 0)
            {
                if (Patient_Report_Detail.Patient_Report_Section_Body is not null || Patient_Report_Detail.Patient_Report_Section_Body!.Count() > 0)
                {
                    foreach (var item in Patient_Report_Detail.Patient_Report_Section_Body!.Select((value, index) => new { value, index }))
                    {
                        bool showRemoveButton = item.index > 0 || Patient_Report_Detail.Patient_Report_Section_Body!.Count > 1;
                        htmlString += DefaultRowBodyHtml;
                        htmlString += GetTableRowHtml(item.index + 1, item.value.PRD_ID, item.value.Report_Body_Text!, item.value.Report_Body_Value!, false, showRemoveButton);
                    }
                }
            }
            else
            {
                htmlString += DefaultRowBodyHtml;
                htmlString += GetTableRowHtml(1, 0, "", "", false, true);
            }

            htmlString += "</tbody>";
            htmlString += "</table>";
            htmlString += "</div>";

            return Content(JsonConvert.SerializeObject(htmlString));
        }
        public string GetTableRowHtml(int RowID = 0, int PRD_ID = 0, string text = "", object value = null!, bool IsTable_Row_Head = false, bool isRemoveBtn = false)
        {
            var Html = "<tr id='" + (IsTable_Row_Head ? "Header" : "Body") + "Row_" + RowID + "' style='" + (RowID == 0 ? "display:none;" : "") + "'>";
            Html += "<td style='width:10%'>";
            Html += "<div class='center-me' style='height: 38px;'>";
            Html += "<a id='btnAddNewRow" + (IsTable_Row_Head ? "Header" : "Body") + "_" + RowID + "' class='btn text-success p-0' onclick='" + (IsTable_Row_Head ? "AddNewRowReportHeader();" : "AddNewRowReportBody();") + "'><i class='fa fa-plus-circle'></i></a>";
            Html += "<a id='btnRemoveRow" + (IsTable_Row_Head ? "Header" : "Body") + "_" + RowID + "' class='btn text-danger p-0 btnRemoveRow' " + (isRemoveBtn ? "" : "style='display:none;'") + " onclick='RemoveTableRow(this);'><i class='fa fa-trash'></i></a>";
            Html += "</div>";
            Html += "</td>";
            Html += "<td style='width:10%; padding:10px;' id='RowNumber" + (IsTable_Row_Head ? "Header" : "Body") + "_" + RowID + "' class='text-center rowNo'>" + RowID + "</td>";
            Html += "<td style='width:0%; padding:10px;' id='PRD_ID_" + (IsTable_Row_Head ? "Header" : "Body") + "_" + RowID + "' class='text-center d-none'>" + PRD_ID + "</td>";
            Html += "<td style='width:30%;'>";
            Html += "<input type='text' class='form-control' id='" + (IsTable_Row_Head ? "Header" : "Body") + "Text_" + RowID + "' placeholder='" + (IsTable_Row_Head ? "Header Text" : "Body Text") + "' " + (text != "" ? "value= '" + text + "'" : "") + ">";
            Html += "</td>";
            Html += "<td class='text-center' style='width:30%'>";
            if (IsTable_Row_Head)
            {
                Html += "<label class='custom_check'>";
                Html += "<input id='HeaderValue_" + RowID + "' type='checkbox' " + (value.Equals(true) ? "checked" : "") + ">";
                Html += "<span class='checkmark'></span>";
                Html += "</label>";
            }
            else
            {
                Html += "<input type='text' class='form-control' id='BodyValue_" + RowID + "' placeholder='Body Value' " + (value.ToString() != "" ? "value= '" + value.ToString() + "'" : "") + ">";
            }
            Html += "</td>";
            Html += "</tr>";
            return Html;
        }


        public IActionResult PdfHtml1()
        {
            return View();
        }
        public IActionResult PdfHtml2()
        {
            return View();
        }
    }
}