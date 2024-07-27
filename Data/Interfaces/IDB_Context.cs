using Microsoft.EntityFrameworkCore;

namespace Data.Interfaces
{
    public interface ICodeToCure_DB_Context_10 : ICodeToCure_DB_Context
    {
        public ICodeToCure_DB_Context_10 DBContext_Instance { get; }
    }
    public interface ICodeToCure_DB_Context_11 : ICodeToCure_DB_Context
    {
        public ICodeToCure_DB_Context_11 DBContext_Instance { get; }
    }
    public interface ICodeToCure_DB_Context_13 : ICodeToCure_DB_Context
    {
        public ICodeToCure_DB_Context_13 DBContext_Instance { get; }
    }
    public interface ICodeToCure_DB_Context
    {
        //CodeToCure_DB_Context<TT> DBContext_Instance { get; }
        DbSet<T> Set<T>() where T : class;
        int Save();

        Task<int> SaveAsync();
    }
}
