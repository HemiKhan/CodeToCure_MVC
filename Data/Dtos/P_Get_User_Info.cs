using Data.DataAccess;
using Swashbuckle.AspNetCore.Annotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;
using System.Text.Json.Serialization;

namespace Data.Dtos
{
    public class P_Get_User_Info : P_Get_User_Info_SP
    {
        public string ip_address { get; set; } = "";
        public Int64 local_timezoneoffset { get; set; } = 0;
        public int local_timezone { get; set; } = 0;
        public string local_timezonename { get; set; } = "";
        public bool issecureconnection { get; set; } = false;
        public string browser { get; set; } = "";
        public bool ismobiledevice { get; set; } = false;
        public string userremotedomain { get; set; } = "";
        public int applicable_tz_id { get; set; } = 0;
        public Int64 applicable_offset { get; set; } = 0;
        public string applicable_timezonename { get; set; } = "";
    }

    public class P_Get_User_Info_SP
    {
        public int User_ID { get; set; }
        public int App_ID { get; set; }
        public string? App_Name { get; set; } = "";
        public string? UserName { get; set; } = "";
        public string? Email { get; set; } = "";
        public string? FullName { get; set; } = "";
        public string? FirstName { get; set; } = "";
        public string? LastName { get; set; } = "";
        public string? UserType { get; set; } = "";
        public string? Department { get; set; } = "";
        public string? Designation { get; set; } = "";
        public string? PasswordExpiryDateTime { get; set; } = "";
        public bool IsBlocked { get; set; } = false;
        public bool IsAdmin { get; set; } = false;
        public int RoleID { get; set; } = 0;
        public bool IsGroupRoleID { get; set; } = false;
        [JsonIgnore]
        [IgnoreDataMember]
        [NotMapped]
        public string encrypted_key { get; set; } = "";
    }

    //public class P_Get_User_Info_SP
    //{
    //    private int _User_ID = 0;
    //    [SwaggerSchema(Nullable = false)]
    //    public int User_ID
    //    {
    //        get
    //        {
    //            return this._User_ID;
    //        }
    //        set
    //        {
    //            this._User_ID = (Globals.ConvertDBNulltoNullIfExistsInt(value) == null ? 0 : value);
    //        }
    //    }
    //    private string _UserName = "";
    //    [SwaggerSchema(Nullable = false)]
    //    public string UserName
    //    {
    //        get
    //        {
    //            return this._UserName;
    //        }
    //        set
    //        {
    //            this._UserName = (Globals.ConvertDBNulltoNullIfExistsString(value) == null ? "" : value.ToUpper());
    //        }
    //    }
    //    private string _FullName = "";
    //    [SwaggerSchema(Nullable = false)]
    //    public string FullName
    //    {
    //        get
    //        {
    //            return this._FullName;
    //        }
    //        set
    //        {
    //            this._FullName = (Globals.ConvertDBNulltoNullIfExistsString(value) == null ? "" : value);
    //        }
    //    }
    //    private string _Designation = "";
    //    [SwaggerSchema(Nullable = false)]
    //    public string Designation
    //    {
    //        get
    //        {
    //            return this._Designation;
    //        }
    //        set
    //        {
    //            this._Designation = (Globals.ConvertDBNulltoNullIfExistsString(value) == null ? "" : value);
    //        }
    //    }
    //    private int _DepartmentID = 0;
    //    [SwaggerSchema(Nullable = false)]
    //    public int DepartmentID
    //    {
    //        get
    //        {
    //            return this._DepartmentID;
    //        }
    //        set
    //        {
    //            this._DepartmentID = (Globals.ConvertDBNulltoNullIfExistsInt(value) == null ? 0 : value);
    //        }
    //    }
    //    private string _DepartmentName = "";
    //    [SwaggerSchema(Nullable = false)]
    //    public string DepartmentName
    //    {
    //        get
    //        {
    //            return this._DepartmentName;
    //        }
    //        set
    //        {
    //            this._DepartmentName = (Globals.ConvertDBNulltoNullIfExistsString(value) == null ? "" : value);
    //        }
    //    }
    //    private bool _IsAdmin = false;
    //    [SwaggerSchema(Nullable = false)]
    //    public bool IsAdmin
    //    {
    //        get
    //        {
    //            return this._IsAdmin;
    //        }
    //        set
    //        {
    //            this._IsAdmin = (Globals.ConvertDBNulltoNullIfExistsBool(value) == null ? false : value);
    //        }
    //    }
    //    private bool _IsBlocked = false;
    //    [SwaggerSchema(Nullable = false)]
    //    public bool IsBlocked
    //    {
    //        get
    //        {
    //            return this._IsBlocked;
    //        }
    //        set
    //        {
    //            this._IsBlocked = (Globals.ConvertDBNulltoNullIfExistsBool(value) == null ? false : value);
    //        }
    //    }
    //    private string _TempBlockTillDateTime = "";
    //    [SwaggerSchema(Nullable = false)]
    //    public string TempBlockTillDateTime
    //    {
    //        get
    //        {
    //            return this._TempBlockTillDateTime;
    //        }
    //        set
    //        {
    //            string? Ret = Globals.ConvertDBNulltoNullIfExistsDateTime(value, true);
    //            this._TempBlockTillDateTime = (Ret == null ? "" : Ret);
    //        }
    //    }
    //    private string _PasswordExpiryDateTime = "";
    //    [SwaggerSchema(Nullable = false)]
    //    public string PasswordExpiryDateTime
    //    {
    //        get
    //        {
    //            return this._PasswordExpiryDateTime;
    //        }
    //        set
    //        {
    //            string? Ret = Globals.ConvertDBNulltoNullIfExistsDateTime(value, true);
    //            this._PasswordExpiryDateTime = (Ret == null ? "" : Ret);
    //        }
    //    }
    //    private string _TimeRegion = "";
    //    [SwaggerSchema(Nullable = false)]
    //    public string TimeRegion
    //    {
    //        get
    //        {
    //            return this._TimeRegion;
    //        }
    //        set
    //        {
    //            this._TimeRegion = (Globals.ConvertDBNulltoNullIfExistsString(value) == null ? "" : value);
    //        }
    //    }
    //    private string _TimeRegionShortName = "";
    //    [SwaggerSchema(Nullable = false)]
    //    public string TimeRegionShortName
    //    {
    //        get
    //        {
    //            return this._TimeRegionShortName;
    //        }
    //        set
    //        {
    //            this._TimeRegionShortName = (Globals.ConvertDBNulltoNullIfExistsString(value) == null ? "" : value);
    //        }
    //    }
    //    private int _TimeZoneID = 13;
    //    [SwaggerSchema(Nullable = false)]
    //    public int TimeZoneID
    //    {
    //        get
    //        {
    //            return this._TimeZoneID;
    //        }
    //        set
    //        {
    //            this._TimeZoneID = (Globals.ConvertDBNulltoNullIfExistsInt(value) == null ? 0 : value);
    //        }
    //    }
    //    private int _TimeOffset = -18000000;
    //    [SwaggerSchema(Nullable = false)]
    //    public int TimeOffset
    //    {
    //        get
    //        {
    //            return this._TimeOffset;
    //        }
    //        set
    //        {
    //            this._TimeOffset = (Globals.ConvertDBNulltoNullIfExistsInt(value) == null ? -18000000 : value);
    //        }
    //    }
    //    private string _NavUserName = "";
    //    [SwaggerSchema(Nullable = false)]
    //    public string NavUserName
    //    {
    //        get
    //        {
    //            return this._NavUserName;
    //        }
    //        set
    //        {
    //            this._NavUserName = (Globals.ConvertDBNulltoNullIfExistsString(value) == null ? "" : value.ToUpper());
    //        }
    //    }
    //    private string _NavApproverUserName = "";
    //    [SwaggerSchema(Nullable = false)]
    //    public string NavApproverUserName
    //    {
    //        get
    //        {
    //            return this._NavApproverUserName;
    //        }
    //        set
    //        {
    //            this._NavApproverUserName = (Globals.ConvertDBNulltoNullIfExistsString(value) == null ? "" : value.ToUpper());
    //        }
    //    }
    //    private string _UserTypeMTVCode = "";
    //    [SwaggerSchema(Nullable = false)]
    //    public string UserTypeMTVCode
    //    {
    //        get
    //        {
    //            return this._UserTypeMTVCode;
    //        }
    //        set
    //        {
    //            this._UserTypeMTVCode = (Globals.ConvertDBNulltoNullIfExistsString(value) == null ? "" : value.ToUpper());
    //        }
    //    }
    //    private int _RoleID = 0;
    //    [SwaggerSchema(Nullable = false)]
    //    public int RoleID
    //    {
    //        get
    //        {
    //            return this._RoleID;
    //        }
    //        set
    //        {
    //            this._RoleID = (Globals.ConvertDBNulltoNullIfExistsInt(value) == null ? 0 : value);
    //        }
    //    }
    //    private bool _IsGroupRoleID = false;
    //    [SwaggerSchema(Nullable = false)]
    //    public bool IsGroupRoleID
    //    {
    //        get
    //        {
    //            return this._IsGroupRoleID;
    //        }
    //        set
    //        {
    //            this._IsGroupRoleID = (Globals.ConvertDBNulltoNullIfExistsBool(value) == null ? false : value);
    //        }
    //    }
    //    private bool _IsApplicationAccessAllowed = false;
    //    [SwaggerSchema(Nullable = false)]
    //    public bool IsApplicationAccessAllowed
    //    {
    //        get
    //        {
    //            return this._IsApplicationAccessAllowed;
    //        }
    //        set
    //        {
    //            this._IsApplicationAccessAllowed = (Globals.ConvertDBNulltoNullIfExistsBool(value) == null ? false : value);
    //        }
    //    }
    //    private bool _IsAPIAccessAllowed = false;
    //    [SwaggerSchema(Nullable = false)]
    //    public bool IsAPIAccessAllowed
    //    {
    //        get
    //        {
    //            return this._IsAPIAccessAllowed;
    //        }
    //        set
    //        {
    //            this._IsAPIAccessAllowed = (Globals.ConvertDBNulltoNullIfExistsBool(value) == null ? false : value);
    //        }
    //    }
    //    [SwaggerSchema(Nullable = false)]
    //    [JsonIgnore]
    //    [IgnoreDataMember]
    //    [NotMapped]
    //    public string encrypted_key { get; set; } = "";
    //}
}
