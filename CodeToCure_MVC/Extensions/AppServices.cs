using Data.AppContext;
using Data.Dtos;
using Data.Interfaces;
using Microsoft.EntityFrameworkCore;
using Services.AccountServices;
using Services.GlobalServices;
using Services.PatientReportServices;

namespace CodeToCure_MVC.Extensions
{
    public static class AppServices
    {
        public static void ApplicationDI(this IServiceCollection services, DbStringCollection dbStringCollection)
        {
            services.AddDbContext<ICodeToCure_DB_Context_10, CodeToCure_DB_Context_10>(op => op.UseSqlServer(dbStringCollection.CodeToCure_DB_ConnectionModel_10.ConnectionString, optionBuilder => optionBuilder.MigrationsAssembly("Data")));
            services.AddDbContext<ICodeToCure_DB_Context_11, CodeToCure_DB_Context_11>(op => op.UseSqlServer(dbStringCollection.CodeToCure_DB_ConnectionModel_11.ConnectionString, optionBuilder => optionBuilder.MigrationsAssembly("Data")));
            services.AddDbContext<ICodeToCure_DB_Context_13, CodeToCure_DB_Context_13>(op => op.UseSqlServer(dbStringCollection.CodeToCure_DB_ConnectionModel_12.ConnectionString, optionBuilder => optionBuilder.MigrationsAssembly("Data")));

            services.AddScoped<IADORepository, ADORepository>();
            services.AddScoped<ILogFile, LogFile>();
        }

        public static void AddOtherServices(this IServiceCollection services)
        {
            services.AddTransient<IPatientReportService, PatientReportService>();
            services.AddTransient<IAccountService, AccountService>();
        }
    }
}
