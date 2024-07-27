using Data.Dtos;
using Data.Interfaces;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Data.AppContext
{
    public class CodeToCure_DB_Context_10 : CodeToCure_DB_Context<CodeToCure_DB_Context_10>, ICodeToCure_DB_Context_10
    {
        public CodeToCure_DB_Context_10(DbContextOptions<CodeToCure_DB_Context_10> options)
        : base(options)
        {
        }

        public ICodeToCure_DB_Context_10 DBContext_Instance
        {
            get
            {
                return this;
            }
        }

        public int Save()
        {
            return this.SaveChanges();
        }

        public async Task<int> SaveAsync()
        {
            return await this.SaveChangesAsync();
        }
    }
    public class CodeToCure_DB_Context_11 : CodeToCure_DB_Context<CodeToCure_DB_Context_11>, ICodeToCure_DB_Context_11
    {
        public CodeToCure_DB_Context_11(DbContextOptions<CodeToCure_DB_Context_11> options)
        : base(options)
        {
        }

        public ICodeToCure_DB_Context_11 DBContext_Instance
        {
            get
            {
                return this;
            }
        }

        public int Save()
        {
            return this.SaveChanges();
        }

        public async Task<int> SaveAsync()
        {
            return await this.SaveChangesAsync();
        }
    }
    public class CodeToCure_DB_Context_13 : CodeToCure_DB_Context<CodeToCure_DB_Context_13>, ICodeToCure_DB_Context_13
    {
        public CodeToCure_DB_Context_13(DbContextOptions<CodeToCure_DB_Context_13> options)
        : base(options)
        {
        }

        public ICodeToCure_DB_Context_13 DBContext_Instance
        {
            get
            {
                return this;
            }
        }

        public int Save()
        {
            return this.SaveChanges();
        }

        public async Task<int> SaveAsync()
        {
            return await this.SaveChangesAsync();
        }
    }
    public abstract partial class CodeToCure_DB_Context<T> : DbContext where T : DbContext
    {
        public CodeToCure_DB_Context(DbContextOptions<T> options)
        : base(options)
        {
        }

        #region DBSet
        //public virtual DbSet<TUser> User { get; set; } = null!;
        [NotMapped]
        public virtual DbSet<P_Get_User_Info_SP> P_Get_User_Info { get; set; } = null!;
        #endregion
        public int Save()
        {
            return this.SaveChanges();
        }
        public async Task<int> SaveAsync()
        {
            return await this.SaveChangesAsync();
        }
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
        }
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            #region modelBuilder

            #endregion

            OnModelCreatingPartial(modelBuilder);
        }
        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
