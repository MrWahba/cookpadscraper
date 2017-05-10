USE [Meals]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Recipes]') AND type in (N'U'))
ALTER TABLE [dbo].[Recipes] DROP CONSTRAINT IF EXISTS [FK_Recipes_Authors]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Instructions]') AND type in (N'U'))
ALTER TABLE [dbo].[Instructions] DROP CONSTRAINT IF EXISTS [FK_Instructions_Recipes]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Ingredients]') AND type in (N'U'))
ALTER TABLE [dbo].[Ingredients] DROP CONSTRAINT IF EXISTS [FK_Ingredients_Recipes]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RecipesSpider]') AND type in (N'U'))
ALTER TABLE [dbo].[RecipesSpider] DROP CONSTRAINT IF EXISTS [DF_RecipesSpider_Last_updated]
GO

/****** Object:  Index [IX_Instructions_rcpe_id]    Script Date: 5/10/2017 8:21:22 PM ******/
DROP INDEX IF EXISTS [IX_Instructions_rcpe_id] ON [dbo].[Instructions]
GO

/****** Object:  Index [IX_Instructions_OrderNO]    Script Date: 5/10/2017 8:21:22 PM ******/
DROP INDEX IF EXISTS [IX_Instructions_OrderNO] ON [dbo].[Instructions]
GO

/****** Object:  Index [IX_Instructions_img]    Script Date: 5/10/2017 8:21:22 PM ******/
DROP INDEX IF EXISTS [IX_Instructions_img] ON [dbo].[Instructions]
GO

/****** Object:  Index [IX_Ingredients_rcpe_id]    Script Date: 5/10/2017 8:21:22 PM ******/
DROP INDEX IF EXISTS [IX_Ingredients_rcpe_id] ON [dbo].[Ingredients]
GO

/****** Object:  Index [IX_Ingredients_OrderNO]    Script Date: 5/10/2017 8:21:22 PM ******/
DROP INDEX IF EXISTS [IX_Ingredients_OrderNO] ON [dbo].[Ingredients]
GO

/****** Object:  Table [dbo].[RecipesSpider]    Script Date: 5/10/2017 8:21:22 PM ******/
DROP TABLE IF EXISTS [dbo].[RecipesSpider]
GO

/****** Object:  Table [dbo].[Recipes]    Script Date: 5/10/2017 8:21:22 PM ******/
DROP TABLE IF EXISTS [dbo].[Recipes]
GO

/****** Object:  Table [dbo].[Instructions]    Script Date: 5/10/2017 8:21:22 PM ******/
DROP TABLE IF EXISTS [dbo].[Instructions]
GO

/****** Object:  Table [dbo].[Ingredients]    Script Date: 5/10/2017 8:21:22 PM ******/
DROP TABLE IF EXISTS [dbo].[Ingredients]
GO

/****** Object:  Table [dbo].[Authors]    Script Date: 5/10/2017 8:21:22 PM ******/
DROP TABLE IF EXISTS [dbo].[Authors]
GO

/****** Object:  Table [dbo].[Authors]    Script Date: 5/10/2017 8:21:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Authors]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Authors](
	[SID] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[SRC] [varchar](512) NOT NULL,
 CONSTRAINT [PK_Authors] PRIMARY KEY CLUSTERED 
(
	[SID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_Authors_SRC] UNIQUE NONCLUSTERED 
(
	[SRC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

/****** Object:  Table [dbo].[Ingredients]    Script Date: 5/10/2017 8:21:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Ingredients]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Ingredients](
	[SID] [bigint] IDENTITY(1,1) NOT NULL,
	[OrderNO] [tinyint] NOT NULL,
	[txt] [nvarchar](500) NOT NULL,
	[rcpe_id] [bigint] NOT NULL,
 CONSTRAINT [PK_Ingredients] PRIMARY KEY CLUSTERED 
(
	[SID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

/****** Object:  Table [dbo].[Instructions]    Script Date: 5/10/2017 8:21:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Instructions]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Instructions](
	[SID] [bigint] IDENTITY(1,1) NOT NULL,
	[OrderNO] [tinyint] NOT NULL,
	[txt] [nvarchar](500) NOT NULL,
	[img] [varchar](512) NULL,
	[rcpe_id] [bigint] NOT NULL,
 CONSTRAINT [PK_Instructions] PRIMARY KEY CLUSTERED 
(
	[SID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

/****** Object:  Table [dbo].[Recipes]    Script Date: 5/10/2017 8:21:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Recipes]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Recipes](
	[rcpe_id] [bigint] NOT NULL,
	[n] [nvarchar](max) NULL,
	[src] [varchar](512) NULL,
	[img] [varchar](512) NULL,
	[tags] [nvarchar](max) NULL,
	[likes] [int] NULL,
	[pub] [datetime] NULL,
	[Author_SID] [bigint] NOT NULL,
 CONSTRAINT [PK_Recipes_1] PRIMARY KEY CLUSTERED 
(
	[rcpe_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

/****** Object:  Table [dbo].[RecipesSpider]    Script Date: 5/10/2017 8:21:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RecipesSpider]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[RecipesSpider](
	[SID] [bigint] IDENTITY(1,1) NOT NULL,
	[URL] [varchar](100) NOT NULL,
	[Last_updated] [datetime] NOT NULL,
 CONSTRAINT [PK_RecipesSpider] PRIMARY KEY CLUSTERED 
(
	[SID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_RecipesSpider_URL] UNIQUE NONCLUSTERED 
(
	[URL] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

/****** Object:  Index [IX_Ingredients_OrderNO]    Script Date: 5/10/2017 8:21:22 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Ingredients]') AND name = N'IX_Ingredients_OrderNO')
CREATE NONCLUSTERED INDEX [IX_Ingredients_OrderNO] ON [dbo].[Ingredients]
(
	[OrderNO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

/****** Object:  Index [IX_Ingredients_rcpe_id]    Script Date: 5/10/2017 8:21:22 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Ingredients]') AND name = N'IX_Ingredients_rcpe_id')
CREATE NONCLUSTERED INDEX [IX_Ingredients_rcpe_id] ON [dbo].[Ingredients]
(
	[rcpe_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

SET ANSI_PADDING ON

GO

/****** Object:  Index [IX_Instructions_img]    Script Date: 5/10/2017 8:21:22 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Instructions]') AND name = N'IX_Instructions_img')
CREATE NONCLUSTERED INDEX [IX_Instructions_img] ON [dbo].[Instructions]
(
	[img] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

/****** Object:  Index [IX_Instructions_OrderNO]    Script Date: 5/10/2017 8:21:22 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Instructions]') AND name = N'IX_Instructions_OrderNO')
CREATE NONCLUSTERED INDEX [IX_Instructions_OrderNO] ON [dbo].[Instructions]
(
	[OrderNO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

/****** Object:  Index [IX_Instructions_rcpe_id]    Script Date: 5/10/2017 8:21:22 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Instructions]') AND name = N'IX_Instructions_rcpe_id')
CREATE NONCLUSTERED INDEX [IX_Instructions_rcpe_id] ON [dbo].[Instructions]
(
	[rcpe_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_RecipesSpider_Last_updated]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[RecipesSpider] ADD  CONSTRAINT [DF_RecipesSpider_Last_updated]  DEFAULT (getdate()) FOR [Last_updated]
END

GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Ingredients_Recipes]') AND parent_object_id = OBJECT_ID(N'[dbo].[Ingredients]'))
ALTER TABLE [dbo].[Ingredients]  WITH CHECK ADD  CONSTRAINT [FK_Ingredients_Recipes] FOREIGN KEY([rcpe_id])
REFERENCES [dbo].[Recipes] ([rcpe_id])
ON DELETE CASCADE
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Ingredients_Recipes]') AND parent_object_id = OBJECT_ID(N'[dbo].[Ingredients]'))
ALTER TABLE [dbo].[Ingredients] CHECK CONSTRAINT [FK_Ingredients_Recipes]
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Instructions_Recipes]') AND parent_object_id = OBJECT_ID(N'[dbo].[Instructions]'))
ALTER TABLE [dbo].[Instructions]  WITH CHECK ADD  CONSTRAINT [FK_Instructions_Recipes] FOREIGN KEY([rcpe_id])
REFERENCES [dbo].[Recipes] ([rcpe_id])
ON DELETE CASCADE
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Instructions_Recipes]') AND parent_object_id = OBJECT_ID(N'[dbo].[Instructions]'))
ALTER TABLE [dbo].[Instructions] CHECK CONSTRAINT [FK_Instructions_Recipes]
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Recipes_Authors]') AND parent_object_id = OBJECT_ID(N'[dbo].[Recipes]'))
ALTER TABLE [dbo].[Recipes]  WITH CHECK ADD  CONSTRAINT [FK_Recipes_Authors] FOREIGN KEY([Author_SID])
REFERENCES [dbo].[Authors] ([SID])
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Recipes_Authors]') AND parent_object_id = OBJECT_ID(N'[dbo].[Recipes]'))
ALTER TABLE [dbo].[Recipes] CHECK CONSTRAINT [FK_Recipes_Authors]
GO

