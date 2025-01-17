USE [AAMH]
GO
/****** Object:  UserDefinedFunction [dbo].[F_Get_Table_Fields_Column]    Script Date: 7/28/2024 1:39:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- select * from [dbo].[F_Get_Table_Fields_Column] ('')
CREATE FUNCTION [dbo].[F_Get_Table_Fields_Column]
(	
	@Json nvarchar(max)
)
returns @ReturnTable table
(Code nvarchar(150)
,[Name] nvarchar(150)
,IsColumnRequired bit
)
AS
Begin
	
	set @Json = isnull(@Json,'')

	if @Json = ''
	begin
		return
	end
	else
	begin
		if ISJSON(@Json) = 0
		begin
			return
		end
	end

	insert into @ReturnTable (Code ,[Name] ,IsColumnRequired)
	select distinct * from (
		select Code = isnull(ret.Code,'')
		,[Name] = isnull(ret.[Name],'')
		,IsColumnRequired = isnull(ret.IsColumnRequired,0)

		from OpenJson(@Json)
		WITH (
			Code nvarchar(150) '$.Code'
			,[Name] nvarchar(1000) '$.Name'
			,IsColumnRequired bit '$.IsColumnRequired'
		) ret
	) ilv where Code <> '' and IsColumnRequired = 0
	
	return

end
GO
/****** Object:  UserDefinedFunction [dbo].[F_Get_Table_Fields_Filter]    Script Date: 7/28/2024 1:39:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- select * from [dbo].[F_Get_Table_Fields_Filter] ('')
create FUNCTION [dbo].[F_Get_Table_Fields_Filter]
(	
	@Json nvarchar(max)
)
returns @ReturnTable table
(Code nvarchar(150)
,[Name] nvarchar(150)
,IsFilterApplied bit
)
AS
Begin
	
	set @Json = isnull(@Json,'')

	if @Json = ''
	begin
		return
	end
	else
	begin
		if ISJSON(@Json) = 0
		begin
			return
		end
	end

	insert into @ReturnTable (Code ,[Name] ,IsFilterApplied)
	select distinct * from (
		select Code = isnull(ret.Code,'')
		,[Name] = isnull(ret.[Name],'')
		,IsFilterApplied = isnull(ret.IsFilterApplied,0)

		from OpenJson(@Json)
		WITH (
			Code nvarchar(150) '$.Code'
			,[Name] nvarchar(1000) '$.Name'
			,IsFilterApplied bit '$.IsFilterApplied'
		) ret
	) ilv where Code <> '' and IsFilterApplied = 1
	
	return

end
GO
/****** Object:  UserDefinedFunction [dbo].[F_Get_Table_Hidden_Fields_Filter_2]    Script Date: 7/28/2024 1:39:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- select * from [POMS_DB].[dbo].[F_Get_Table_Hidden_Fields_Filter_2] ('')
create FUNCTION [dbo].[F_Get_Table_Hidden_Fields_Filter_2]
(	
	@Json nvarchar(max)
)
returns @ReturnTable table
(Code nvarchar(150)
,IsFilterApplied bit
,IsList bit 
,[Value] nvarchar(1000)
,ListType int
,Logic nvarchar(50)
,[Type] nvarchar(50)
)
AS
Begin
	
	set @Json = isnull(@Json,'')

	if @Json = ''
	begin
		return
	end
	else
	begin
		if ISJSON(@Json) = 0
		begin
			return
		end
	end

	insert into @ReturnTable (Code ,IsFilterApplied ,IsList ,[Value] ,ListType ,Logic ,[Type])
	select * from (
		select Code = isnull(ret.Code,'')
		,IsFilterApplied = isnull(ret.IsFilterApplied,0)
		,IsList = isnull(IsList,0)
		,[Value] = isnull([Value],'')
		,ListType = isnull(ListType,0)
		,Logic = isnull(Logic,'')
		,[Type] = isnull([Type],'')
		from OpenJson(@Json)
		WITH (
			Code nvarchar(150) '$.Code'
			,IsFilterApplied bit '$.IsFilterApplied'
			,ReportFilterObjectArry nvarchar(max) '$.reportFilterObjectArry' as json
		) ret
		CROSS APPLY openjson (ret.ReportFilterObjectArry,'$') 
		WITH (
			IsList bit '$.IsList'
			,[Value] nvarchar(1000) '$.Value'
			,ListType int '$.ListType'
			,Logic nvarchar(50) '$.Logic'
			,[Type] nvarchar(50) '$.Type'
		) ret2
	) ilv where Code <> ''
	
	return

end
GO
/****** Object:  Table [dbo].[T_Docs]    Script Date: 7/28/2024 1:39:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Docs](
	[TimeStamp] [timestamp] NOT NULL,
	[DOC_ID] [int] IDENTITY(1,1) NOT NULL,
	[Ref_ID] [int] NULL,
	[RefNo1] [nvarchar](40) NULL,
	[RefNo2] [nvarchar](40) NULL,
	[FileName] [nvarchar](250) NOT NULL,
	[FileExt] [nvarchar](50) NOT NULL,
	[Path] [nvarchar](250) NULL,
	[Base64] [nvarchar](max) NULL,
	[AttachmentType_MTV_ID] [int] NOT NULL,
	[Note] [nvarchar](max) NULL,
	[IsActive] [bit] NOT NULL,
	[AddedBy] [nvarchar](150) NOT NULL,
	[AddedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](150) NULL,
	[ModifiedOn] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[DOC_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Master_Type]    Script Date: 7/28/2024 1:39:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Master_Type](
	[TimeStamp] [timestamp] NOT NULL,
	[MT_ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](150) NULL,
	[IsActive] [bit] NOT NULL,
	[AddedBy] [nvarchar](150) NOT NULL,
	[AddedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](150) NULL,
	[ModifiedOn] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[MT_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Master_Type_Value]    Script Date: 7/28/2024 1:39:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Master_Type_Value](
	[TimeStamp] [timestamp] NOT NULL,
	[MTV_ID] [int] NOT NULL,
	[MTV_CODE] [nvarchar](20) NOT NULL,
	[MT_ID] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Sub_MTV_ID] [int] NOT NULL,
	[Sort_] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[AddedBy] [nvarchar](150) NOT NULL,
	[AddedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](150) NULL,
	[ModifiedOn] [datetime] NULL,
 CONSTRAINT [PK_T_Master_Type_Value] PRIMARY KEY CLUSTERED 
(
	[MTV_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Patient_Report]    Script Date: 7/28/2024 1:39:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Patient_Report](
	[TimeStamp] [timestamp] NOT NULL,
	[PR_ID] [int] IDENTITY(1,1) NOT NULL,
	[InvoiceNo] [int] NOT NULL,
	[Report_Title] [nvarchar](50) NOT NULL,
	[Indication] [nvarchar](200) NOT NULL,
	[ViralStatus] [nvarchar](200) NOT NULL,
	[RT_ID] [int] NOT NULL,
	[IsTemplate] [bit] NULL,
	[IsActive] [bit] NOT NULL,
	[AddedBy] [nvarchar](150) NOT NULL,
	[AddedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](150) NULL,
	[ModifiedOn] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[PR_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Patient_Report_Detail]    Script Date: 7/28/2024 1:39:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Patient_Report_Detail](
	[TimeStamp] [timestamp] NOT NULL,
	[PRD_ID] [int] IDENTITY(1,1) NOT NULL,
	[PR_ID] [int] NOT NULL,
	[Report_Header_Text] [nvarchar](50) NULL,
	[Report_Header_Value] [bit] NULL,
	[Report_Body_Text] [nvarchar](100) NULL,
	[Report_Body_Value] [nvarchar](max) NULL,
	[RT_ID] [int] NULL,
	[IsActive] [bit] NOT NULL,
	[AddedBy] [nvarchar](150) NOT NULL,
	[AddedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](150) NULL,
	[ModifiedOn] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[PRD_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Report_Templates]    Script Date: 7/28/2024 1:39:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Report_Templates](
	[TimeStamp] [timestamp] NOT NULL,
	[RT_ID] [int] IDENTITY(1,1) NOT NULL,
	[Report_Template_Name] [nvarchar](200) NOT NULL,
	[Report_Template_Html] [nvarchar](max) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[AddedBy] [nvarchar](150) NOT NULL,
	[AddedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](150) NULL,
	[ModifiedOn] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[RT_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[T_Docs] ADD  CONSTRAINT [DF_T_Docs_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[T_Docs] ADD  CONSTRAINT [DF_T_Docs_CreatedOn]  DEFAULT (getutcdate()) FOR [AddedOn]
GO
ALTER TABLE [dbo].[T_Master_Type] ADD  CONSTRAINT [DF_T_Master_Type_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[T_Master_Type] ADD  CONSTRAINT [DF_T_Master_Type_AddedOn]  DEFAULT (getutcdate()) FOR [AddedOn]
GO
ALTER TABLE [dbo].[T_Master_Type_Value] ADD  CONSTRAINT [DF_T_Master_Type_Value_Sub_MTV_ID]  DEFAULT ((0)) FOR [Sub_MTV_ID]
GO
ALTER TABLE [dbo].[T_Master_Type_Value] ADD  CONSTRAINT [DF_T_Master_Type_Value_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[T_Master_Type_Value] ADD  CONSTRAINT [DF_T_Master_Type_Value_AddedOn]  DEFAULT (getutcdate()) FOR [AddedOn]
GO
ALTER TABLE [dbo].[T_Patient_Report] ADD  CONSTRAINT [DF_T_Patient_Report_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[T_Patient_Report] ADD  CONSTRAINT [DF_T_Patient_Report_AddedOn]  DEFAULT (getutcdate()) FOR [AddedOn]
GO
ALTER TABLE [dbo].[T_Patient_Report_Detail] ADD  CONSTRAINT [DF_T_Patient_Report_Detail_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[T_Patient_Report_Detail] ADD  CONSTRAINT [DF_T_Patient_Report_Detail_AddedOn]  DEFAULT (getutcdate()) FOR [AddedOn]
GO
ALTER TABLE [dbo].[T_Report_Templates] ADD  CONSTRAINT [DF_T_Report_Templates_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[T_Report_Templates] ADD  CONSTRAINT [DF_T_Report_Templates_AddedOn]  DEFAULT (getutcdate()) FOR [AddedOn]
GO
ALTER TABLE [dbo].[T_Master_Type_Value]  WITH CHECK ADD  CONSTRAINT [FK_T_Master_Type_Value_T_Master_Type] FOREIGN KEY([MT_ID])
REFERENCES [dbo].[T_Master_Type] ([MT_ID])
GO
ALTER TABLE [dbo].[T_Master_Type_Value] CHECK CONSTRAINT [FK_T_Master_Type_Value_T_Master_Type]
GO
ALTER TABLE [dbo].[T_Patient_Report_Detail]  WITH CHECK ADD FOREIGN KEY([PR_ID])
REFERENCES [dbo].[T_Patient_Report] ([PR_ID])
GO
/****** Object:  StoredProcedure [dbo].[P_AddOrEdit_Patient_Report]    Script Date: 7/28/2024 1:39:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- EXEC [P_AddOrEdit_Patient_Report] '{"PR_ID":1,"IsSavedTemplate":0,"Report_Title":"ENDOSCOPY REPORT","InvoiceNo":"1","RT_ID":"1","Indication":" Chronic Dyspepsia","Report_Headers":[{"PRD_ID":"9","PR_ID":"1","Report_Header_Text":"OPD","Report_Header_Value":true,"RT_ID":"1"},{"PRD_ID":"10","PR_ID":"1","Report_Header_Text":"Indoor","Report_Header_Value":false,"RT_ID":"1"},{"PRD_ID":"11","PR_ID":"1","Report_Header_Text":"ER","Report_Header_Value":false,"RT_ID":"1"},{"PRD_ID":"0","PR_ID":"1","Report_Header_Text":"test","Report_Header_Value":false,"RT_ID":"1"}],"Report_Body":[{"PRD_ID":"9","PR_ID":"1","Report_Header_Text":"OPD","Report_Header_Value":true,"RT_ID":"1"},{"PRD_ID":"10","PR_ID":"1","Report_Header_Text":"Indoor","Report_Header_Value":false,"RT_ID":"1"},{"PRD_ID":"11","PR_ID":"1","Report_Header_Text":"ER","Report_Header_Value":false,"RT_ID":"1"},{"PRD_ID":"0","PR_ID":"1","Report_Header_Text":"test","Report_Header_Value":false,"RT_ID":"1"}]}'
CREATE   PROC [dbo].[P_AddOrEdit_Patient_Report]
	@Json NVARCHAR(MAX),
	@UserName NVARCHAR(25)
AS
BEGIN 
	DECLARE @PR_ID INT
	DECLARE @IsSavedTemplate BIT
	DECLARE @InvoiceNo INT
	DECLARE @RT_ID INT
	DECLARE @Report_Title NVARCHAR(250)
	DECLARE @Doctor_Name NVARCHAR(250)
	DECLARE @Patient_Name NVARCHAR(250)
	DECLARE @MR INT
	DECLARE @Date NVARCHAR(250)
	DECLARE @AgeGender NVARCHAR(250)
	DECLARE @ViralStatus NVARCHAR(250)
	DECLARE @Indication NVARCHAR(250)

	DECLARE @Return_Code BIT = 0
	DECLARE @Return_Text NVARCHAR(max) = ''

	DECLARE @Report_Headers TABLE(PR_ID INT, PRD_ID INT,Report_Header_Text NVARCHAR(200),Report_Header_Value BIT)
	DECLARE @Report_Body TABLE(PR_ID INT, PRD_ID INT,Report_Body_Text NVARCHAR(500),Report_Body_Value NVARCHAR(max))
		
	SELECT 
    @PR_ID = JSON_VALUE(@Json, '$.PR_ID'),
    @IsSavedTemplate = JSON_VALUE(@Json, '$.IsSavedTemplate'),
    @InvoiceNo = JSON_VALUE(@Json, '$.InvoiceNo'),
    @Report_Title = JSON_VALUE(@Json, '$.Report_Title'),
    @RT_ID = JSON_VALUE(@Json, '$.RT_ID'),
    @Doctor_Name = JSON_VALUE(@Json, '$.Doctor_Name'),
    @Patient_Name = JSON_VALUE(@Json, '$.Patient_Name'),
    @MR = JSON_VALUE(@Json, '$.MR'),
    @Date = JSON_VALUE(@Json, '$.Date'),
    @AgeGender = JSON_VALUE(@Json, '$.AgeGender'),
    @ViralStatus = JSON_VALUE(@Json, '$.ViralStatus'),
    @Indication = JSON_VALUE(@Json, '$.Indication');

	INSERT INTO @Report_Headers (PRD_ID, Report_Header_Text, Report_Header_Value)
	SELECT h.PRD_ID, h.Report_Header_Text, h.Report_Header_Value
    FROM OPENJSON(@Json, '$.Report_Headers') 
	WITH (PRD_ID INT '$.PRD_ID', Report_Header_Text NVARCHAR(MAX) '$.Report_Header_Text',  Report_Header_Value BIT '$.Report_Header_Value') AS h

	INSERT INTO @Report_Body (PRD_ID, Report_Body_Text, Report_Body_Value)
	SELECT b.PRD_ID, b.Report_Body_Text, b.Report_Body_Value
    FROM OPENJSON(@Json, '$.Report_Body') 
	WITH (PRD_ID INT '$.PRD_ID', Report_Body_Text NVARCHAR(MAX) '$.Report_Body_Text',Report_Body_Value NVARCHAR(MAX) '$.Report_Body_Value') AS b

	IF @IsSavedTemplate = 0 
	BEGIN 
		IF @PR_ID > 0 
		BEGIN 
			IF EXISTS (SELECT 1 FROM [dbo].[T_Patient_Report] WITH (NOLOCK) WHERE PR_ID = @PR_ID)
			BEGIN 
				UPDATE [dbo].[T_Patient_Report] SET InvoiceNo = @InvoiceNo, Report_Title = @Report_Title, Indication = @Indication, ViralStatus = @ViralStatus, RT_ID = @RT_ID
				WHERE PR_ID = @PR_ID

				DELETE FROM [dbo].[T_Patient_Report_Detail] WHERE PR_ID = @PR_ID
				INSERT INTO [dbo].[T_Patient_Report_Detail] (PR_ID,Report_Header_Text,Report_Header_Value,[RT_ID],AddedBy) 
				SELECT PR_ID = @PR_ID, Report_Header_Text, Report_Header_Value, RT_ID = @RT_ID, @UserName FROM @Report_Headers WHERE ISNULL(Report_Header_Text,'') <> '' 
				INSERT INTO [dbo].[T_Patient_Report_Detail] (PR_ID,Report_Body_Text,Report_Body_Value,[RT_ID],AddedBy) 
				SELECT PR_ID = @PR_ID, Report_Body_Text, Report_Body_Value, RT_ID = @RT_ID, @UserName FROM @Report_Body WHERE ISNULL(Report_Body_Text,'') <> '' AND ISNULL(Report_Body_Value,'') <> ''

				SET @Return_Code = 1
				SET @Return_Text = 'Updated Successfully!'
			END
			ELSE BEGIN 
				SET @Return_Code = 0
				SET @Return_Text = 'Data Already Exists!'
			END
		END
		ELSE BEGIN 
			IF NOT EXISTS (SELECT 1 FROM [dbo].[T_Patient_Report] WITH (NOLOCK) WHERE IsActive = 1 AND InvoiceNo = @InvoiceNo)
			BEGIN 
				INSERT INTO [dbo].[T_Patient_Report] (InvoiceNo,Report_Title,Indication,ViralStatus,RT_ID,AddedBy) 
				VALUES (@InvoiceNo, @Report_Title,@Indication,@ViralStatus,@RT_ID,@UserName)
				SET @PR_ID = SCOPE_IDENTITY()
				INSERT INTO [dbo].[T_Patient_Report_Detail] (PR_ID,Report_Header_Text,Report_Header_Value,[RT_ID],AddedBy) 
				SELECT PR_ID = @PR_ID, Report_Header_Text, Report_Header_Value, RT_ID = @RT_ID, @UserName FROM @Report_Headers
				INSERT INTO [dbo].[T_Patient_Report_Detail] (PR_ID,Report_Body_Text,Report_Body_Value,[RT_ID],AddedBy) 
				SELECT PR_ID = @PR_ID, Report_Body_Text, Report_Body_Value, RT_ID = @RT_ID, @UserName FROM @Report_Body
				SET @Return_Code = 1
				SET @Return_Text = 'Added Successfully!'
			END
			ELSE BEGIN 
				SET @Return_Code = 0
				SET @Return_Text = 'Data Already Exists!'
			END
		END	
	END
	ELSE 
	BEGIN 
		IF NOT EXISTS (SELECT 1 FROM [dbo].[T_Patient_Report] WITH (NOLOCK) WHERE IsActive = 1 AND InvoiceNo = @InvoiceNo)
		BEGIN 
			INSERT INTO [dbo].[T_Patient_Report] (InvoiceNo,Report_Title,Indication,ViralStatus,RT_ID,AddedBy) 
			VALUES (@InvoiceNo, @Report_Title,@Indication,@ViralStatus,@RT_ID,@UserName)
			SET @PR_ID = SCOPE_IDENTITY()
			INSERT INTO [dbo].[T_Patient_Report_Detail] (PR_ID,Report_Header_Text,Report_Header_Value,[RT_ID],AddedBy) 
			SELECT PR_ID = @PR_ID, Report_Header_Text, Report_Header_Value, RT_ID = @RT_ID, @UserName FROM @Report_Headers
			INSERT INTO [dbo].[T_Patient_Report_Detail] (PR_ID,Report_Body_Text,Report_Body_Value,[RT_ID],AddedBy) 
			SELECT PR_ID = @PR_ID, Report_Body_Text, Report_Body_Value, RT_ID = @RT_ID, @UserName FROM @Report_Body
			SET @Return_Code = 1
			SET @Return_Text = 'Added Successfully!'
		END
		ELSE BEGIN 
			SET @Return_Code = 0
			SET @Return_Text = 'Data Already Exists!'
		END
	END
	SELECT Return_Code = @Return_Code, Return_Text = @Return_Text
END






GO
/****** Object:  StoredProcedure [dbo].[P_Auto_Insert_Columns_In_Audit_Column_Table]    Script Date: 7/28/2024 1:39:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 create   PROCEDURE [dbo].[P_Auto_Insert_Columns_In_Audit_Column_Table]
AS
BEGIN

	drop table if exists #oldtmptablecolumn
	select * into #oldtmptablecolumn from (
		SELECT AC_ID, [TableName] ,[DbName] ,[ConcTableAndColumnName]=([TableName] + ' (' + [DbName] + ')')
		FROM [dbo].[T_Audit_Column] with (nolock)
	) ilv
	
	drop table if exists #newtmptablecolumn
	SELECT [Table Name]=ilv.[TABLE_NAME], [Column Name] = ilv.COLUMN_NAME, [Conc Table Column Name] = (ilv.[TABLE_NAME] + ' (' + ilv.[COLUMN_NAME] + ')') into #newtmptablecolumn FROM (
		SELECT isc.[TABLE_NAME],COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS isc
		inner join INFORMATION_SCHEMA.TABLES ist on isc.[TABLE_NAME] = ist.[TABLE_NAME] and ist.TABLE_TYPE = 'BASE TABLE' and ist.[TABLE_NAME] <> 'T_Audit_Column' 
		and isc.COLUMN_NAME not in ('TimeStamp',' CREATE OR ALTERdBy',' CREATE OR ALTERdOn','AddedBy','AddedOn','ModifiedBy','ModifiedOn','OrderID','OrderNo','OrderNoGUID')
	) ilv

	insert into [dbo].[T_Audit_Column] ([TableName],[DbName],[Name],[AddedBy])
	select [Table Name] ,[Column Name] ,[Column Name] ,'AUTOIMPORT' from #newtmptablecolumn A
	where A.[Conc Table Column Name] not in (Select B.[ConcTableAndColumnName] from #oldtmptablecolumn B)

	drop table if exists #deleteACIDs
	select * into #deleteACIDs from [dbo].[T_Audit_Column] au with (nolock)
	where (au.[TableName] + ' (' + au.[DbName] + ')') not in (select n.[Conc Table Column Name] from #newtmptablecolumn n)
	and au.AC_ID not in (select ah.AC_ID from [dbo].[T_Audit_History] ah with (nolock))

	delete from [dbo].[T_Audit_Column] where AC_ID in (select d.AC_ID from #deleteACIDs d)

END
GO
/****** Object:  StoredProcedure [dbo].[P_Get_Common_List]    Script Date: 7/28/2024 1:39:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 create   PROCEDURE [dbo].[P_Get_Common_List]
(
	@SelectSql nvarchar(max),
	@PageIndex int,
	@PageSize int,
	@SortExpression nvarchar(max),
	@FilterClause nvarchar(max),
	@SetTop int,
	@TotalRowCount int OUTPUT
)

AS

BEGIN 		

	Declare @Sql nvarchar(max)	

	if (@PageSize > 0) 
	begin
		--Get List with Pagination
		set @Sql =N'select * from (
						select top (' + cast(@SetTop as nvarchar(50)) + ') 
							RowNo = row_number() over (order by ' + @SortExpression + ')
							, ilv.*
						from ('+ replace(@SelectSql,',hidefield=0','') +') ilv
					where 1 = 1  '+ @FilterClause + ' order by rowno ) ilvouter '
					+ ' order by rowno 
					OFFSET ' + cast((@PageIndex * @PageSize) as nvarchar(100)) + ' ROWS
					FETCH NEXT ' + cast(@PageSize as nvarchar(100)) + ' ROWS ONLY;'
	end
	else
	begin
		set @Sql =N'select RowNo = row_number() over (order by ' + @SortExpression + ')
						, ilv.*
					from (' + replace(@SelectSql,',hidefield=0','') + ') as ilv
					where 1 = 1  ' + @FilterClause + ' order by rowno '  
	end
	
	Declare @SqlForCount nvarchar(max);
	Declare @ParmDefinition nvarchar(4000);
	
	set @SqlForCount = N'select @TotalRowCount = count(1) from  ( ' + replace(@SelectSql,',hidefield=0','--') + ') as ilv where 1 = 1  ' + @FilterClause;   
	set @ParmDefinition = N' @TotalRowCount int OUTPUT ';

	--select @SqlForCount
	--select @Sql

	exec sp_executesql @SqlForCount, @ParmDefinition, @TotalRowCount OUTPUT; 
	exec sp_executesql @Sql 

END

GO
/****** Object:  StoredProcedure [dbo].[P_Get_Patient_Report_Detail]    Script Date: 7/28/2024 1:39:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- EXEC P_Get_Patient_Report_Detail 1
CREATE   PROC [dbo].[P_Get_Patient_Report_Detail]
	@PR_ID INT
AS
BEGIN 
SELECT DISTINCT
	 pr.PR_ID
	,pr.InvoiceNo
	,pr.Report_Title
	,pr.RT_ID
	,Doctor_Name = vw.EmployeeName
	,Patient_Name = vw.PatientName
	,Report_Template_Html = ''
	,MR = vw.PatientID
	,[Date] = FORMAT(vw.AddedDateTime,'dd/MM/yyyy')
	,AgeGender = vw.Age + 'Y/' + vw.Gender
	,ViralStatus = pr.ViralStatus
	,pr.Indication
	,Report_Headers = (
	SELECT DISTINCT
	 prd_H.PRD_ID
	,prd_H.Report_Header_Text
	,prd_H.Report_Header_Value
	FROM [dbo].[T_Patient_Report_Detail] prd_H WITH (NOLOCK)
	WHERE prd_H.PR_ID = pr.PR_ID AND prd_H.IsActive = 1 AND prd_H.Report_Header_Text is not null AND prd_H.Report_Header_Value is not null 
	FOR JSON PATH)
	,Report_Body = (
	SELECT DISTINCT
	 prd_B.PRD_ID
	,prd_B.Report_Body_Text
	,prd_B.Report_Body_Value
	FROM [dbo].[T_Patient_Report_Detail] prd_B WITH (NOLOCK)
	WHERE prd_B.PR_ID = pr.PR_ID AND prd_B.IsActive = 1 AND prd_B.Report_Header_Text is null AND prd_B.Report_Header_Value is null 
	FOR JSON PATH)
FROM [dbo].[T_Patient_Report] pr WITH (NOLOCK)
INNER JOIN (SELECT DISTINCT AppointmentID, PatientID, InvoiceNo, PatientName, EmployeeName, Age, Gender = GenderName, AddedDateTime FROM [dbo].[vwServicesRecord] vw WITH (NOLOCK)) vw ON pr.InvoiceNo = vw.AppointmentID
WHERE pr.PR_ID = @PR_ID AND pr.IsActive = 1
FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
END






GO
/****** Object:  StoredProcedure [dbo].[P_Get_PatientReport_List]    Script Date: 7/28/2024 1:39:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--	Declare @TotalCount int = 0 EXEC [dbo].[P_Get_PatientReport_List] 'HAMMAS.KHAN', 0, 30, '', '', @TotalCount out, 18000000, '[]', '[{"Code":"RowNo","Name":"#","IsColumnRequired":true,"IsHidden":false,"IsChecked":false},{"Code":"PG_ID","Name":"Page ID","IsColumnRequired":true,"IsHidden":false,"IsChecked":false},{"Code":"PageGroupName","Name":"Page Group Name","IsColumnRequired":false,"IsHidden":false,"IsChecked":false},{"Code":"Sort_","Name":"Sort_","IsColumnRequired":true,"IsHidden":false,"IsChecked":false},{"Code":"IsHide","Name":"IsHide","IsColumnRequired":true,"IsHidden":false,"IsChecked":false},{"Code":"IsActive","Name":"IsActive","IsColumnRequired":false,"IsHidden":false,"IsChecked":false},{"Code":"Action","Name":"Action","IsColumnRequired":false,"IsHidden":false,"IsChecked":false}]' select @TotalCount
 CREATE PROCEDURE [dbo].[P_Get_PatientReport_List]
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
	SET @sortExpression = ' PR_ID asc '  
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
  Declare @Col1_Filtered bit = (case when exists(select code from #Table_Fields_Filter where isfilterapplied = 1 and code = 'Report_Title') then 1 else 0 end)
  Declare @Col2_Filtered bit = (case when exists(select code from #Table_Fields_Filter where isfilterapplied = 1 and code = 'Indication') then 1 else 0 end)
  Declare @Col3_Filtered bit = (case when exists(select code from #Table_Fields_Filter where isfilterapplied = 1 and code = 'Template_Name') then 1 else 0 end)
  Declare @Col4_Filtered bit = (case when exists(select code from #Table_Fields_Filter where isfilterapplied = 1 and code = 'ViralStatus') then 1 else 0 end)
  Declare @Col5_Filtered bit = (case when exists(select code from #Table_Fields_Filter where isfilterapplied = 1 and code = 'IsTemplate') then 1 else 0 end)
  Declare @Col6_Filtered bit = (case when exists(select code from #Table_Fields_Filter where isfilterapplied = 1 and code = 'IsActive') then 1 else 0 end)
  ---- End Set Filter Variables

  ---- Start Set Column Required Variables
  Declare @Col1_Req bit = (case when @Col1_Filtered = 0 and exists(select code from #Table_Fields_Column where iscolumnrequired = 0 and code = 'Report_Title') then 0 else 1 end)
  Declare @Col2_Req bit = (case when @Col2_Filtered = 0 and exists(select code from #Table_Fields_Column where iscolumnrequired = 0 and code = 'Indication') then 0 else 1 end)
  Declare @Col3_Req bit = (case when @Col3_Filtered = 0 and exists(select code from #Table_Fields_Column where iscolumnrequired = 0 and code = 'Template_Name') then 0 else 1 end)
  Declare @Col4_Req bit = (case when @Col2_Filtered = 0 and exists(select code from #Table_Fields_Column where iscolumnrequired = 0 and code = 'ViralStatus') then 0 else 1 end)
  Declare @Col5_Req bit = (case when @Col2_Filtered = 0 and exists(select code from #Table_Fields_Column where iscolumnrequired = 0 and code = 'IsTemplate') then 0 else 1 end)
  Declare @Col6_Req bit = (case when @Col2_Filtered = 0 and exists(select code from #Table_Fields_Column where iscolumnrequired = 0 and code = 'IsActive') then 0 else 1 end)
  ---- End Set Column Required Variables

  Declare @selectSql nvarchar(max);  
	set @selectSql = N'select pr.PR_ID, pr.RT_ID, InvoiceNo'
	+ char(10) + (case when @Col1_Filtered = 1 then '' else @HideField end) + (case when @Col1_Req = 0 then '' else ',Report_Title' end)
	+ char(10) + (case when @Col2_Filtered = 1 then '' else @HideField end) + (case when @Col2_Req = 0 then '' else ',Indication' end)
	+ char(10) + (case when @Col4_Filtered = 1 then '' else @HideField end) + (case when @Col4_Req = 0 then '' else ',ViralStatus' end)
	+ char(10) + (case when @Col3_Filtered = 1 then '' else @HideField end) + (case when @Col3_Req = 0 then '' else ', Template_Name = rt.Report_Template_Name' end)
	+ char(10) + (case when @Col5_Filtered = 1 then '' else @HideField end) + (case when @Col5_Req = 0 then '' else ',IsTemplate = pr.IsTemplate' end)
	+ char(10) + (case when @Col6_Filtered = 1 then '' else @HideField end) + (case when @Col6_Req = 0 then '' else ',IsActive = pr.IsActive' end)
	+ char(10) + 'FROM [dbo].[T_Patient_Report] pr WITH (NOLOCK)
LEFT JOIN [dbo].[T_Report_Templates] rt  WITH (NOLOCK) ON pr.RT_ID = rt.RT_ID'
	
	exec P_Get_Common_List @selectSql, @pageIndex, @pageSize, @sortExpression, @filterClause , @SetTop , @totalRowCount OUTPUT

END
GO
/****** Object:  StoredProcedure [dbo].[P_Get_ReportTemplate_List]    Script Date: 7/28/2024 1:39:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--	Declare @TotalCount int = 0 EXEC [dbo].[P_Get_ReportTemplate_List] 'HAMMAS.KHAN', 0, 30, '', '', @TotalCount out, 18000000, '[]', '[{"Code":"RowNo","Name":"#","IsColumnRequired":true,"IsHidden":false,"IsChecked":false},{"Code":"PG_ID","Name":"Page ID","IsColumnRequired":true,"IsHidden":false,"IsChecked":false},{"Code":"PageGroupName","Name":"Page Group Name","IsColumnRequired":false,"IsHidden":false,"IsChecked":false},{"Code":"Sort_","Name":"Sort_","IsColumnRequired":true,"IsHidden":false,"IsChecked":false},{"Code":"IsHide","Name":"IsHide","IsColumnRequired":true,"IsHidden":false,"IsChecked":false},{"Code":"IsActive","Name":"IsActive","IsColumnRequired":false,"IsHidden":false,"IsChecked":false},{"Code":"Action","Name":"Action","IsColumnRequired":false,"IsHidden":false,"IsChecked":false}]' select @TotalCount
CREATE PROCEDURE [dbo].[P_Get_ReportTemplate_List]
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
	SET @sortExpression = ' RT_ID asc '  
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
  Declare @Col1_Filtered bit = (case when exists(select code from #Table_Fields_Filter where isfilterapplied = 1 and code = 'Report_Title') then 1 else 0 end)
  Declare @Col2_Filtered bit = (case when exists(select code from #Table_Fields_Filter where isfilterapplied = 1 and code = 'Template_Name') then 1 else 0 end)
  ---- End Set Filter Variables

  ---- Start Set Column Required Variables
  Declare @Col1_Req bit = (case when @Col1_Filtered = 0 and exists(select code from #Table_Fields_Column where iscolumnrequired = 0 and code = 'Report_Title') then 0 else 1 end)
  Declare @Col2_Req bit = (case when @Col2_Filtered = 0 and exists(select code from #Table_Fields_Column where iscolumnrequired = 0 and code = 'Template_Name') then 0 else 1 end)
  ---- End Set Column Required Variables

  Declare @selectSql nvarchar(max);  
	set @selectSql = N'select pr.PR_ID, pr.RT_ID'
	+ char(10) + (case when @Col1_Filtered = 1 then '' else @HideField end) + (case when @Col1_Req = 0 then '' else ',Report_Title' end)
	+ char(10) + (case when @Col2_Filtered = 1 then '' else @HideField end) + (case when @Col2_Req = 0 then '' else ',Template_Name = rt.Report_Template_Name' end)
	+ char(10) + 'FROM [dbo].[T_Patient_Report] pr WITH (NOLOCK)
INNER JOIN [dbo].[T_Report_Templates] rt  WITH (NOLOCK) ON pr.RT_ID = rt.RT_ID
WHERE pr.IsTemplate = 1'
	
	exec P_Get_Common_List @selectSql, @pageIndex, @pageSize, @sortExpression, @filterClause , @SetTop , @totalRowCount OUTPUT

END
GO
/****** Object:  StoredProcedure [dbo].[P_Patient_Report_Add_Table_Data]    Script Date: 7/28/2024 1:39:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROC [dbo].[P_Patient_Report_Add_Table_Data]
As
BEGIN 

DROP TABLE [dbo].[T_Patient_Report_Detail]
DROP TABLE [dbo].[T_Patient_Report]
DROP TABLE [dbo].[T_Report_Templates]

CREATE TABLE [dbo].[T_Report_Templates](
	[TimeStamp] [timestamp] NOT NULL,
	[RT_ID] [int] NOT NULL Primary Key Identity(1,1),
	[Report_Template_Name] [nvarchar](200) NOT NULL,
	[Report_Template_Html] [nvarchar](max) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[AddedBy] [nvarchar](150) NOT NULL,
	[AddedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](150) NULL,
	[ModifiedOn] [datetime] NULL,
)
ALTER TABLE [dbo].[T_Report_Templates] ADD  CONSTRAINT [DF_T_Report_Templates_IsActive]  DEFAULT ((1)) FOR [IsActive]
ALTER TABLE [dbo].[T_Report_Templates] ADD  CONSTRAINT [DF_T_Report_Templates_AddedOn]  DEFAULT (getutcdate()) FOR [AddedOn]

CREATE TABLE [dbo].[T_Patient_Report](
	[TimeStamp] [timestamp] NOT NULL,
	[PR_ID] [int] NOT NULL Primary Key Identity(1,1),
	[InvoiceNo] [int] NOT NULL,
	[Report_Title] [nvarchar](50) NOT NULL,
	[Indication] [nvarchar](200) NOT NULL,
	[ViralStatus] [nvarchar](200) NOT NULL,
	[RT_ID] [int] NOT NULL,
	[IsTemplate] [BIT] NULL,
	[IsActive] [bit] NOT NULL,
	[AddedBy] [nvarchar](150) NOT NULL,
	[AddedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](150) NULL,
	[ModifiedOn] [datetime] NULL,
)
ALTER TABLE [dbo].[T_Patient_Report] ADD  CONSTRAINT [DF_T_Patient_Report_IsActive]  DEFAULT ((1)) FOR [IsActive]
ALTER TABLE [dbo].[T_Patient_Report] ADD  CONSTRAINT [DF_T_Patient_Report_AddedOn]  DEFAULT (getutcdate()) FOR [AddedOn]
 
CREATE TABLE [dbo].[T_Patient_Report_Detail](
	[TimeStamp] [timestamp] NOT NULL,
	[PRD_ID] [int] NOT NULL Primary Key Identity(1,1),	
	[PR_ID] [int] NOT NULL FOREIGN KEY ([PR_ID]) REFERENCES [T_Patient_Report]([PR_ID]),
	[Report_Header_Text] [nvarchar](50) NULL,
	[Report_Header_Value] BIT NULL,
	[Report_Body_Text] [nvarchar](100) NULL,
	[Report_Body_Value] [nvarchar](max) NULL,
	[RT_ID] [int] NULL,
	[IsActive] [bit] NOT NULL,
	[AddedBy] [nvarchar](150) NOT NULL,
	[AddedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](150) NULL,
	[ModifiedOn] [datetime] NULL,
)
ALTER TABLE [dbo].[T_Patient_Report_Detail] ADD  CONSTRAINT [DF_T_Patient_Report_Detail_IsActive]  DEFAULT ((1)) FOR [IsActive]
ALTER TABLE [dbo].[T_Patient_Report_Detail] ADD  CONSTRAINT [DF_T_Patient_Report_Detail_AddedOn]  DEFAULT (getutcdate()) FOR [AddedOn]

DECLARE @UserName NVARCHAR(120) = 'HAMMAS.KHAN'
DECLARE @Report_Template_Name NVARCHAR(120) = 'ENDOSCOPY'
DECLARE @PR_ID int 
DECLARE @RT_ID int 
DECLARE @HTML NVARCHAR(MAX) = '<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{report_title}}</title>
    <style>
        .container { padding: 40px;  margin: 0 auto; position: relative; font-family: Arial, sans-serif; }
        .header { text-align: center; }
            .header h1 { margin: 0; font-size: 18px; }
            .header p { margin: 0; font-size: 16px; }
        .section { margin-top: 20px; }
            .section h2 { font-size: 18px; margin-bottom: 5px; }
            .section p { margin: 5px 0; font-size: 16px; }
        .signature { margin-top: 80px;}
        .box { display: inline-block; width: 20px; height: 20px; border: 2px solid black; margin: 0 10px; vertical-align: middle; }
        .filled { background-color: black; }
        .larger-text { font-size: larger; }
		.section.body p {margin-bottom: 40px;}
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <img src="{{report_logo}}" style="width:12%;height:120px;position:absolute;display:block;" />
            <h1>AYESHA AMIR MEMORIAL HOSPITAL</h1>
            <p>Bangla Chowk Manun Kanjan.</p>
            <p>Contact Us: 041-3402647</p>
            <h2>{{report_title}}</h2>
        </div>
        <div class="section">
            <h4 style="text-align:center;">{{doctor_name}}</h4>
            <div style="display:flex;justify-content:space-between;">
                <p><strong>Patient Name:</strong> {{patient_name}}</p>
                <p><strong>MR:</strong> {{mr_number}}</p>
                <p><strong>Date:</strong> {{date}}</p>
            </div>
            <div style="display:flex;justify-content:space-between;">
                <p><strong>Age/Gender:</strong> {{age_gender}}</p>
                <p><strong>Viral Status:</strong> {{viral_status}}</p>
            </div>
            <h5><strong>Performed by:</strong> {{performed_by}}</h5>
            <div style="display:flex;justify-content:space-between;">
                <p><strong>Indication:</strong> {{indication}}</p>
                <p class="larger-text">
                    {{{report_header_section_types}}}
                </p>
            </div>
        </div>

        <hr />

        <div class="section body">
            {{{report_body_section}}}
        </div>
    </div>
</body>
</html>'

INSERT INTO [dbo].[T_Report_Templates] ([Report_Template_Name],Report_Template_Html,AddedBy) VALUES (@Report_Template_Name,@HTML,@UserName)

SET @RT_ID = SCOPE_IDENTITY()

INSERT INTO [dbo].[T_Patient_Report] (InvoiceNo,Report_Title,Indication,ViralStatus,RT_ID,IsTemplate,AddedBy) VALUES (7,'ENDOSCOPY REPORT','Chronic Dyspepsia','N/A',@RT_ID,0,'HAMMS.KHAN')

SET @PR_ID = SCOPE_IDENTITY()

INSERT INTO [dbo].[T_Patient_Report_Detail] (PR_ID,Report_Header_Text,Report_Header_Value,[RT_ID],AddedBy) 
VALUES (@PR_ID,'OPD',1,@RT_ID,@UserName)
INSERT INTO [dbo].[T_Patient_Report_Detail] (PR_ID,Report_Header_Text,Report_Header_Value,[RT_ID],AddedBy) 
VALUES (@PR_ID,'Indoor',0,@RT_ID,@UserName)
INSERT INTO [dbo].[T_Patient_Report_Detail] (PR_ID,Report_Header_Text,Report_Header_Value,[RT_ID],AddedBy) 
VALUES (@PR_ID,'ER',0,@RT_ID,@UserName)

INSERT INTO [dbo].[T_Patient_Report_Detail] (PR_ID,Report_Body_Text,Report_Body_Value,[RT_ID],AddedBy) 
VALUES (@PR_ID,'ESOPHAGUS','Normal mucosa of upper, middle and lower third. Lax LES.',@RT_ID,@UserName)

INSERT INTO [dbo].[T_Patient_Report_Detail] (PR_ID,Report_Body_Text,Report_Body_Value,[RT_ID],AddedBy) 
VALUES (@PR_ID,'STOMACH','Normal mucosa of fundus and body. Mild antral gastritis.',@RT_ID,@UserName)

INSERT INTO [dbo].[T_Patient_Report_Detail] (PR_ID,Report_Body_Text,Report_Body_Value,[RT_ID],AddedBy) 
VALUES (@PR_ID,'DUODENUM','Normal D1 and D2.',@RT_ID,@UserName)

INSERT INTO [dbo].[T_Patient_Report_Detail] (PR_ID,Report_Body_Text,Report_Body_Value,[RT_ID],AddedBy) 
VALUES (@PR_ID,'FINAL ENDOSCOPY FINDING','Lax LES. Antral Gastritis.',@RT_ID,@UserName)

INSERT INTO [dbo].[T_Patient_Report_Detail] (PR_ID,Report_Body_Text,Report_Body_Value,[RT_ID],AddedBy) 
VALUES (@PR_ID,'RECOMMENDATIONS','Follow up in OPD',@RT_ID,@UserName)


SELECT * FROM [dbo].[T_Patient_Report] WITH (NOLOCK)
SELECT * FROM [dbo].[T_Patient_Report_Detail] WITH (NOLOCK)
SELECT * FROM [dbo].[T_Report_Templates] WITH (NOLOCK)


END
GO
/****** Object:  StoredProcedure [dbo].[P_PatientReport_IsTemplate]    Script Date: 7/28/2024 1:39:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--		EXEC [dbo].[P_PatientReport_IsTemplate] 1
CREATE PROC [dbo].[P_PatientReport_IsTemplate]
    @PR_ID INT
AS
BEGIN
    DECLARE @Return_Code BIT = 0;
    DECLARE @Return_Text NVARCHAR(1000) = '';

    IF EXISTS (SELECT 1 FROM [dbo].[T_Patient_Report] WITH (NOLOCK) WHERE PR_ID = @PR_ID)
    BEGIN
        DECLARE @IsTemplate BIT;

		SELECT @IsTemplate = IsTemplate FROM [dbo].[T_Patient_Report] WITH (NOLOCK) WHERE PR_ID = @PR_ID
		
		IF @IsTemplate = 0
		BEGIN 
			UPDATE [dbo].[T_Patient_Report] SET IsTemplate = 1 WHERE PR_ID = @PR_ID
			SET @Return_Text = 'patient report template is Saved Successfully!'
            SET @Return_Code = 1
		END
		ELSE
		BEGIN 
			UPDATE [dbo].[T_Patient_Report] SET IsTemplate = 0 WHERE PR_ID = @PR_ID
			SET @Return_Text = 'Patient Report is not a template now.'
            SET @Return_Code = 1
		END
	END			
	ELSE
	BEGIN 
		SET @Return_Text = 'Patient Report is not exists.'
        SET @Return_Code = 0
	END
    SELECT @Return_Text AS Return_Text, @Return_Code AS Return_Code;
END
GO
/****** Object:  StoredProcedure [dbo].[P_Remove_Generic]    Script Date: 7/28/2024 1:39:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--		EXEC [dbo].[P_Remove_Generic] '','',1,'',''
 create   PROC [dbo].[P_Remove_Generic]
    @TableName NVARCHAR(150),
    @ColumnName NVARCHAR(150),
    @ColumnValue INT,
    @Username NVARCHAR(150),
    @IPAddress NVARCHAR(20) = ''
AS
BEGIN
    DECLARE @Return_Code BIT = 1;
    DECLARE @Return_Text NVARCHAR(1000) = '';

    IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = @TableName)
    BEGIN
        DECLARE @IsActive BIT;
        DECLARE @Sql NVARCHAR(MAX);

        SET @Sql = N'SELECT @IsActive = IsActive FROM ' + QUOTENAME(@TableName) + ' WHERE ' + QUOTENAME(@ColumnName) + ' = @ColumnValue;';

        EXEC sp_executesql @Sql, N'@ColumnValue INT, @IsActive BIT OUTPUT', @ColumnValue, @IsActive OUTPUT;

        IF @@ROWCOUNT > 0
        BEGIN
            IF @IsActive = 0
            BEGIN
                SET @Sql = N'UPDATE ' + QUOTENAME(@TableName) + ' SET IsActive = 1 WHERE ' + QUOTENAME(@ColumnName) + ' = @ColumnValue;';
                EXEC sp_executesql @Sql, N'@ColumnValue INT', @ColumnValue;
                SET @Return_Text = 'Record ACTIVE Successfully!';
                SET @Return_Code = 1;
            END
            ELSE
            BEGIN
                SET @Sql = N'UPDATE ' + QUOTENAME(@TableName) + ' SET IsActive = 0 WHERE ' + QUOTENAME(@ColumnName) + ' = @ColumnValue;';
                EXEC sp_executesql @Sql, N'@ColumnValue INT', @ColumnValue;
                SET @Return_Text = 'Record IN-ACTIVE Successfully!';
                SET @Return_Code = 1;
            END
        END
        ELSE
        BEGIN
            SET @Return_Text = 'Record with specified parm value does not exist!';
            SET @Return_Code = 0;
        END
    END
    ELSE
    BEGIN
        SET @Return_Text = 'Table does not exist!';
        SET @Return_Code = 0;
    END

    SELECT @Return_Text AS Return_Text, @Return_Code AS Return_Code;
END
GO
/****** Object:  StoredProcedure [dbo].[P_SignIn]    Script Date: 7/28/2024 1:39:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[P_SignIn]
@UserName nvarchar(25),
@Password nvarchar(25)
AS
BEGIN
	DECLARE @Return_Code BIT = 0
	DECLARE @Return_Text NVARCHAR(max) = ''
	
	IF NOT EXISTS(SELECT 1 FROM [dbo].[tblUsers] WITH (NOLOCK) WHERE Active = 1 AND UserID = @UserName)
	BEGIN 
		SET @Return_Code = 0
		SET @Return_Text = 'User Name Not Exists!'
		SELECT Return_Code = @Return_Code, Return_Text = @Return_Text
		return
	END

	IF NOT EXISTS(SELECT 1 FROM [dbo].[tblUsers] WITH (NOLOCK) WHERE Active = 1 AND UserID = @UserName AND [Password] =  @Password)
	BEGIN 
		SET @Return_Code = 0
		SET @Return_Text = 'Password Not Matched!'
		SELECT Return_Code = @Return_Code, Return_Text = @Return_Text
		return
	END

	--SELECT EmployeeCode, UserID, [Password] FROM [dbo].[tblUsers] WITH (NOLOCK) WHERE Active = 1 AND UserID = @UserName AND [Password] =  @Password
	
	SET @Return_Code = 1
	SET @Return_Text = 'Login Successfully!'

	SELECT Return_Code = @Return_Code, Return_Text = @Return_Text
END
GO
