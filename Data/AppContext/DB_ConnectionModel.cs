namespace Data.AppContext
{
    public class CodeToCure_DB_ConnectionModel_10 : GeneralDatabaseConnectionModel
    {
        public override string ConnectionString
        {
            get
            {
                return $"Server={Server}; Initial Catalog={Initial_Catalog}; User Id = {User_Id}; Password = {Password}; Encrypt = {Encrypt.ToLower()}; TrustServerCertificate = {TrustServerCertificate.ToLower()};";
            }
        }
    }
    public class CodeToCure_DB_ConnectionModel_11 : GeneralDatabaseConnectionModel
    {
        public override string ConnectionString
        {
            get
            {
                return $"Server={Server}; Initial Catalog={Initial_Catalog}; User Id = {User_Id}; Password = {Password}; Encrypt = {Encrypt.ToLower()}; TrustServerCertificate = {TrustServerCertificate.ToLower()};";
            }
        }
    }
    public class CodeToCure_DB_ConnectionModel_12 : GeneralDatabaseConnectionModel
    {
        public override string ConnectionString
        {
            get
            {
                return $"Server={Server}; Initial Catalog={Initial_Catalog}; User Id = {User_Id}; Password = {Password}; Encrypt = {Encrypt.ToLower()}; TrustServerCertificate = {TrustServerCertificate.ToLower()};";
            }
        }
    }

    public class GeneralDatabaseConnectionModel
    {
        public string? Server { get; set; }
        public string? Initial_Catalog { get; set; }
        public int? Port { get; set; }
        public string? Provider { get; set; }
        public string? User_Id { get; set; }
        public string? Password { get; set; }
        public string? Encrypt { get; set; } = "false";
        public string? TrustServerCertificate { get; set; } = "false";
        public bool? Integrated_Security { get; set; }
        public virtual string? ConnectionString { get; }
    }
}
