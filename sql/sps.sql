USE [Meals]
GO

/****** Object:  StoredProcedure [dbo].[USP_Recipes_upsert]    Script Date: 5/10/2017 8:30:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[USP_Recipes_upsert]
GO

/****** Object:  StoredProcedure [dbo].[UDP_RecipesSpider_upsert]    Script Date: 5/10/2017 8:30:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[UDP_RecipesSpider_upsert]
GO

/****** Object:  StoredProcedure [dbo].[UDP_RecipesSpider_upsert]    Script Date: 5/10/2017 8:30:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UDP_RecipesSpider_upsert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[UDP_RecipesSpider_upsert] AS' 
END
GO

ALTER proc [dbo].[UDP_RecipesSpider_upsert]
@URL nvarchar(1000)
as
update [dbo].[RecipesSpider] set [Last_updated]=getdate() where [url]=@URL

if (@@ROWCOUNT = 0)
begin
INSERT INTO [dbo].[RecipesSpider]
           ([URL])
     VALUES
           (@URL)
end

GO

/****** Object:  StoredProcedure [dbo].[USP_Recipes_upsert]    Script Date: 5/10/2017 8:30:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_Recipes_upsert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_Recipes_upsert] AS' 
END
GO



ALTER proc [dbo].[USP_Recipes_upsert]
@json NVARCHAR(MAX)
as


declare @likes int, @n nvarchar(500),@src varchar(512),@img varchar(512),@tags nvarchar(max),@pub datetime,
@_auth  nvarchar(max),@ingrd nvarchar(max),@instrct nvarchar(max),@auth_anme  nvarchar(200),@auth_src varchar(512),@rcpe_id bigint

declare @Author_SID bigint

SELECT
  @n = JSON_VALUE(@json, '$.n'),
  @src=JSON_VALUE(@json, '$.src'),
  @rcpe_id=convert(bigint,JSON_VALUE(@json, '$.rcpe_id')),
  @img=JSON_VALUE(@json, '$.img'),
  @tags=JSON_QUERY(@json, '$.tags'),
  @likes=convert(int,JSON_VALUE(@json, '$.likes')) ,
  @pub=convert(date,JSON_VALUE(@json, '$.pub')),
  @_auth=JSON_QUERY(@json, '$.auth'),
  @ingrd=JSON_QUERY(@json, '$.ingrd'),
  @instrct=JSON_QUERY(@json, '$.instrct')

select @auth_anme=JSON_VALUE(@_auth, '$.n'),@auth_src=JSON_VALUE(@_auth, '$.src')

select top 1 @Author_SID=SID from Authors with(nolock) where src=@auth_src
if(@Author_SID is null)
  begin
    insert Authors(name,src)values(@auth_anme,@auth_src)
	select @Author_SID= SCOPE_IDENTITY()
  end

 MERGE Recipes AS target  
    USING (SELECT @rcpe_id) AS source (rcpe_id)  
    ON (target.rcpe_id = source.rcpe_id)  
    WHEN MATCHED THEN   
        UPDATE SET n = @n,src=@src,img=@img,tags=@tags,likes=@likes,pub=@pub,Author_SID=@Author_SID  
    WHEN NOT MATCHED THEN  
    INSERT  (rcpe_id,n,src,img,tags,likes,pub,Author_SID)  
    VALUES (@rcpe_id,@n,@src,@img,@tags,@likes,@pub,@Author_SID); 


delete Ingredients with(rowlock) where rcpe_id=@rcpe_id

insert Ingredients(OrderNO,txt,rcpe_id)
SELECT OrderNO,txt,@rcpe_id as rcpe_id
FROM OPENJSON(@ingrd)  
  WITH (OrderNO int 'strict $.in', txt nvarchar(500) '$.n')
  
 
delete Instructions with(rowlock) where rcpe_id=@rcpe_id

insert Instructions(OrderNO,txt,img,rcpe_id)
SELECT OrderNO,txt,img,@rcpe_id as rcpe_id
FROM OPENJSON(@instrct)  
  WITH (OrderNO int 'strict $.in', txt nvarchar(500) '$.txt',img nvarchar(500) '$.img' ) 

update Instructions with(rowlock) set img =null where img=''
GO

