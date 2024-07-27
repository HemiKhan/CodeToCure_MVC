using Data.Dtos;
using Data.Models;

namespace Services.PatientReportServices
{
    public interface IPatientReportService
    {
        public Task<string> GetPatientReportHTML(int PatientReportID);
        public Task<byte[]> CreatePatientReportPDF(string PatientContantHtml);
        public P_ReturnMessage_Result P_AddOrEdit_Patient_Report(string Json);
        public P_ReturnMessage_Result P_PatientReport_IsTemplate(int PR_ID);
        public P_Get_Patient_Report_Detail P_Get_Patient_Report_Detail(int PR_ID);
        public List<Patient_Report_Section_Header> S_Report_Header_List(int PR_ID);
        public List<Patient_Report_Section_Body> S_Report_Body_List(int PR_ID);
        public S_Dropdown_List_Str Get_DropdownHtmlStringList(string query, List<Dynamic_SP_Params>? parms = null);
        public S_Dropdown_List_Str S_Report_Template_List_Str(int PR_ID = 0);
        public S_Dropdown_List_Str S_Invoice_List_Str();
    }
}
