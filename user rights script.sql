CREATE TABLE [dbo].[T_User_Report_Rights](
	[TimeStamp] [timestamp] NOT NULL,
	[URR_ID] [int] NOT NULL Primary Key Identity(1,1),	
	[UserId] nvarchar(250) NOT NULL,
	[RT_ID] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[AddedBy] [nvarchar](150) NOT NULL,
	[AddedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](150) NULL,
	[ModifiedOn] [datetime] NULL,
)
ALTER TABLE [dbo].[T_User_Report_Rights] ADD  CONSTRAINT [DF_T_User_Report_Rights_IsActive]  DEFAULT ((1)) FOR [IsActive]
ALTER TABLE [dbo].[T_User_Report_Rights] ADD  CONSTRAINT [DF_T_User_Report_Rights_AddedOn]  DEFAULT (getutcdate()) FOR [AddedOn]


--	Declare @TotalCount int = 0 EXEC [dbo].[P_Get_UserReportRight_List] 'HAMMAS.KHAN', 0, 30, '', '', @TotalCount out, 18000000, '[]', '[{"Code":"RowNo","Name":"#","IsColumnRequired":true,"IsHidden":false,"IsChecked":false},{"Code":"PG_ID","Name":"Page ID","IsColumnRequired":true,"IsHidden":false,"IsChecked":false},{"Code":"PageGroupName","Name":"Page Group Name","IsColumnRequired":false,"IsHidden":false,"IsChecked":false},{"Code":"Sort_","Name":"Sort_","IsColumnRequired":true,"IsHidden":false,"IsChecked":false},{"Code":"IsHide","Name":"IsHide","IsColumnRequired":true,"IsHidden":false,"IsChecked":false},{"Code":"IsActive","Name":"IsActive","IsColumnRequired":false,"IsHidden":false,"IsChecked":false},{"Code":"Action","Name":"Action","IsColumnRequired":false,"IsHidden":false,"IsChecked":false}]' select @TotalCount
 CREATE PROCEDURE [dbo].[P_Get_UserReportRight_List]
(	
	@Username nvarchar(150),
	@PageIndex int,  
	@PageSize int,  
	@SortExpression nvarchar(max),  
	@FilterClause nvarchar(max),  
	@TotalRowCount int OUTPUT,
	@TimeZoneID int = 0,
	@FilterObject nvarchar(max) = '',
	@ColumnObject nvarchar(max) = ''
)

AS

BEGIN 		

	IF(@filterClause = '' OR @filterClause = null)  
	BEGIN SET @filterClause = ' AND 1=1' END 

	IF(@pageIndex = null)  
	BEGIN SET @pageIndex = 0 END  
  
	IF(@pageSize = null)  
	BEGIN SET @pageSize = 0 END  

	Declare @SetTop int = 30
	SET @SetTop = (@pageindex + 1) * @pagesize

	IF len(@sortExpression) = 0  
	SET @sortExpression = ' URR_ID asc '  
	ELSE
	SET @sortExpression = @sortExpression + ' '

	DROP TABLE IF exists #Table_Fields_Filter
	 CREATE TABLE #Table_Fields_Filter (code nvarchar(150) ,name_ nvarchar(150) ,isfilterapplied bit)
	INSERT INTO #Table_Fields_Filter
	SELECT [Code],[Name],[IsFilterApplied] from [dbo].[F_Get_Table_Fields_Filter] (@filterobject)

	DROP TABLE IF exists #Table_Fields_Column
	 CREATE TABLE #Table_Fields_Column (code nvarchar(150) ,name_ nvarchar(150) ,iscolumnrequired bit)
	INSERT INTO #Table_Fields_Column
	SELECT [Code],[Name],[IsColumnRequired] FROM [dbo].[F_Get_Table_Fields_Column] (@columnobject)

	Declare @HideField nvarchar(50) = ',hidefield=0'

	 ---- Start Set Filter Variables
  Declare @Col1_Filtered bit = (case when exists(select code from #Table_Fields_Filter where isfilterapplied = 1 and code = 'UserId') then 1 else 0 end)
  Declare @Col2_Filtered bit = (case when exists(select code from #Table_Fields_Filter where isfilterapplied = 1 and code = 'ReportName') then 1 else 0 end)
  Declare @Col6_Filtered bit = (case when exists(select code from #Table_Fields_Filter where isfilterapplied = 1 and code = 'IsActive') then 1 else 0 end)
  ---- End Set Filter Variables

  ---- Start Set Column Required Variables
  Declare @Col1_Req bit = (case when @Col1_Filtered = 0 and exists(select code from #Table_Fields_Column where iscolumnrequired = 0 and code = 'UserId') then 0 else 1 end)
  Declare @Col2_Req bit = (case when @Col2_Filtered = 0 and exists(select code from #Table_Fields_Column where iscolumnrequired = 0 and code = 'ReportName') then 0 else 1 end)
  Declare @Col6_Req bit = (case when @Col2_Filtered = 0 and exists(select code from #Table_Fields_Column where iscolumnrequired = 0 and code = 'IsActive') then 0 else 1 end)
  ---- End Set Column Required Variables

  Declare @selectSql nvarchar(max);  
	set @selectSql = N'select URR_ID, urr.RT_ID'
	+ char(10) + (case when @Col1_Filtered = 1 then '' else @HideField end) + (case when @Col1_Req = 0 then '' else ',UserId' end)
	+ char(10) + (case when @Col2_Filtered = 1 then '' else @HideField end) + (case when @Col2_Req = 0 then '' else ',ReportName = rt.Report_Template_Name' end)
	+ char(10) + (case when @Col6_Filtered = 1 then '' else @HideField end) + (case when @Col6_Req = 0 then '' else ',IsActive = urr.IsActive' end)
	+ char(10) + 'FROM [dbo].[T_User_Report_Rights] urr WITH (NOLOCK)
	INNER JOIN [dbo].[T_Report_Templates] rt WITH (NOLOCK) ON urr.RT_ID = rt.RT_ID'
	
	exec P_Get_Common_List @selectSql, @pageIndex, @pageSize, @sortExpression, @filterClause , @SetTop , @totalRowCount OUTPUT

END


-- EXEC [P_AddOrEdit_UserReportRights] 0,'ameer.hamza',1,'hammas.khan'
CREATE PROC [dbo].[P_AddOrEdit_UserReportRights]
	@URR_ID INT = 0,
	@UserId nvarchar(250),
	@RT_ID INT,
	@UserName NVARCHAR(25)
AS
BEGIN 
	
	DECLARE @Return_Code BIT = 0
	DECLARE @Return_Text NVARCHAR(max) = ''

	IF @URR_ID > 0 
	BEGIN 
		IF EXISTS (SELECT 1 FROM [dbo].[T_User_Report_Rights] WITH (NOLOCK) WHERE URR_ID = @URR_ID)
		BEGIN 
			UPDATE [dbo].[T_User_Report_Rights] SET UserId = @UserId, RT_ID = @RT_ID WHERE URR_ID = @URR_ID
	
			SET @Return_Code = 1
			SET @Return_Text = 'Updated Successfully!'
		END
		ELSE BEGIN 
			SET @Return_Code = 0
			SET @Return_Text = 'Data does not Exists!'
		END
	END
	ELSE BEGIN 
			INSERT INTO [dbo].[T_User_Report_Rights] (UserId,RT_ID,AddedBy) 
			VALUES (@UserId,@RT_ID,@UserName)
			
			SET @Return_Code = 1
			SET @Return_Text = 'Added Successfully!'
	END	
	SELECT Return_Code = @Return_Code, Return_Text = @Return_Text
END