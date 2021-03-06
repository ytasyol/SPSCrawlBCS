USE [StackOverflow]
GO
/****** Object:  DatabaseRole [SPSearchCrawl]    Script Date: 6/16/2015 8:28:35 PM ******/
CREATE ROLE [SPSearchCrawl]
GO
/****** Object:  View [dbo].[uv_AllQuestions]    Script Date: 6/16/2015 8:28:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[uv_AllQuestions]
AS
SELECT	p.Id,
		p.ParentId,
		p.AcceptedAnswerId,
		p.AnswerCount,
		p.Body,
		p.ClosedDate,
		p.CommentCount,
		p.CommunityOwnedDate,
		p.CreationDate,
		p.FavoriteCount,
		p.LastActivityDate,
		p.LastEditDate,
		p.LastEditorDisplayName,
		p.Score,
		p.Tags,
		p.Title,
		p.ViewCount,
		u.DisplayName,
		PT.Type as PostType
  FROM	dbo.Posts AS p 
		left outer JOIN Users AS u ON p.OwnerUserId = u.Id 
		left outer JOIN PostTypes AS PT ON p.PostTypeId = PT.Id
 WHERE	p.ParentId = 0





GO
/****** Object:  View [dbo].[uv_AllQuestionComments]    Script Date: 6/16/2015 8:28:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[uv_AllQuestionComments]
AS
SELECT	c.Id AS CommentID, 
		c.CreationDate, 
		c.PostId, 
		c.Score, 
		c.Text, 
		c.UserId, 
		u.DisplayName
  FROM	dbo.Comments c
		INNER JOIN	dbo.Users u ON u.Id = c.UserId
 where	exists (
			select	1
			  from	uv_AllQuestions
			 where	Id = c.PostId
		)


GO
/****** Object:  View [dbo].[uv_AllResponses]    Script Date: 6/16/2015 8:28:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [dbo].[uv_AllResponses]
AS
SELECT	p.Id,
		p.ParentId,
		p.AnswerCount,
		p.Body,
		p.ClosedDate,
		p.CommentCount,
		p.CommunityOwnedDate,
		p.CreationDate,
		p.FavoriteCount,
		p.LastActivityDate,
		p.LastEditDate,
		p.LastEditorDisplayName,
		p.Score,
		p.Tags,
		p.Title,
		p.ViewCount,
		u.DisplayName,
		PT.Type as PostType
  FROM	dbo.Posts AS p 
		left outer JOIN Users AS u ON p.OwnerUserId = u.Id 
		left outer JOIN PostTypes AS PT ON p.PostTypeId = PT.Id
 WHERE	p.ParentId <> 0
   and	Not exists (
			select	1 
			  from	dbo.Posts 
			 where	AcceptedAnswerId = p.Id
		)







GO
/****** Object:  View [dbo].[uv_AllResponseComments]    Script Date: 6/16/2015 8:28:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[uv_AllResponseComments]
AS
SELECT	c.Id AS CommentID, 
		c.CreationDate, 
		c.PostId, 
		c.Score, 
		c.Text, 
		c.UserId, 
		u.DisplayName
  FROM	dbo.Comments c
		INNER JOIN	dbo.Users u ON u.Id = c.UserId
 where	exists (
			select	1
			  from	uv_AllResponses
			 where	Id = c.PostId
		)


GO
/****** Object:  View [dbo].[uv_AllAcceptedAnswers]    Script Date: 6/16/2015 8:28:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [dbo].[uv_AllAcceptedAnswers]
AS
SELECT	p.Id,
		p.ParentId,
		p.AnswerCount,
		p.Body,
		p.ClosedDate,
		p.CommentCount,
		p.CommunityOwnedDate,
		p.CreationDate,
		p.FavoriteCount,
		p.LastActivityDate,
		p.LastEditDate,
		p.LastEditorDisplayName,
		p.Score,
		p.Tags,
		p.Title,
		p.ViewCount,
		u.DisplayName,
		PT.Type as PostType
  FROM	dbo.Posts AS p 
		left outer JOIN Users AS u ON p.OwnerUserId = u.Id 
		left outer JOIN PostTypes AS PT ON p.PostTypeId = PT.Id
 WHERE	p.ParentId > 0
   and	exists (
			select	1 
			  from	dbo.Posts 
			 where	AcceptedAnswerId = p.Id
		)







GO
/****** Object:  View [dbo].[uv_AllAnswerComments]    Script Date: 6/16/2015 8:28:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [dbo].[uv_AllAnswerComments]
AS
SELECT	c.Id AS CommentID, 
		c.CreationDate, 
		c.PostId, 
		c.Score, 
		c.Text, 
		c.UserId, 
		u.DisplayName
  FROM	dbo.Comments c
		INNER JOIN	dbo.Users u ON u.Id = c.UserId
 where	exists (
			select	1
			  from	uv_AllAcceptedAnswers aaa
			 where	aaa.Id = c.PostId
		)



GO
/****** Object:  View [dbo].[uv_AllComments]    Script Date: 6/16/2015 8:28:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[uv_AllComments]
AS
SELECT	c.Id AS CommentID, 
		c.CreationDate, 
		c.PostId, 
		c.Score, 
		c.Text, 
		c.UserId,
		u.DisplayName
FROM         dbo.Comments c
		INNER JOIN dbo.Users u ON c.UserId = u.Id


GO
/****** Object:  View [dbo].[uv_AllUsers]    Script Date: 6/16/2015 8:28:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[uv_AllUsers]
AS

SELECT
  u.Id,
  u.AboutMe,
  u.Age,
  u.CreationDate,
  u.DisplayName,
  u.DownVotes,
  u.LastAccessDate,
  u.Location,
  u.Reputation,
  u.UpVotes,
  u.[Views],
  u.WebsiteUrl
FROM Users u

GO
/****** Object:  StoredProcedure [dbo].[usp_getAcceptedAnswer]    Script Date: 6/16/2015 8:28:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_getAcceptedAnswer] @AnswerID INT AS
  SELECT 	aa.Id,
			aa.ParentId,
			aa.AnswerCount,
			aa.Body,
			aa.ClosedDate,
			aa.CommentCount,
			aa.CommunityOwnedDate,
			aa.CreationDate,
			aa.FavoriteCount,
			aa.LastActivityDate,
			aa.LastEditDate,
			aa.LastEditorDisplayName,
			aa.Score,
			aa.Tags,
			aa.Title,
			aa.ViewCount,
			aa.DisplayName,
			aa.PostType
    FROM dbo.uv_AllAcceptedAnswers aa 
   WHERE aa.Id	=@AnswerID 


GO
/****** Object:  StoredProcedure [dbo].[usp_getAccpetedAnswersByQuestionID]    Script Date: 6/16/2015 8:28:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_getAccpetedAnswersByQuestionID] @QuestionID INT AS
  SELECT 	aaa.Id,
			aaa.ParentId,
			aaa.AnswerCount,
			aaa.Body,
			aaa.ClosedDate,
			aaa.CommentCount,
			aaa.CommunityOwnedDate,
			aaa.CreationDate,
			aaa.FavoriteCount,
			aaa.LastActivityDate,
			aaa.LastEditDate,
			aaa.LastEditorDisplayName,
			aaa.Score,
			aaa.Tags,
			aaa.Title,
			aaa.ViewCount,
			aaa.DisplayName,
			aaa.PostType
    FROM uv_AllAcceptedAnswers aaa
   WHERE aaa.ParentId = @questionID 


GO
/****** Object:  StoredProcedure [dbo].[usp_getChangedAnswerComments]    Script Date: 6/16/2015 8:28:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_getChangedAnswerComments] @LastRunDate datetime output AS
  if @LastRunDate != CAST('1900-1-1' as datetime)
	  SELECT CommentID
		FROM dbo.uv_AllAnswerComments 
	   WHERE CreationDate > @LastRunDate
  set @LastRunDate = CURRENT_TIMESTAMP

GO
/****** Object:  StoredProcedure [dbo].[usp_getChangedAnswers]    Script Date: 6/16/2015 8:28:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getChangedAnswers] @LastRunDate datetime output AS
  if @LastRunDate != CAST('1900-1-1' as datetime)
	  SELECT 	aa.Id
		FROM dbo.uv_AllAcceptedAnswers aa 
	   WHERE aa.LastEditDate > @LastRunDate
  set @LastRunDate = CURRENT_TIMESTAMP

GO
/****** Object:  StoredProcedure [dbo].[usp_getChangedComments]    Script Date: 6/16/2015 8:28:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_getChangedComments] @LastRunDate datetime output AS
  if @LastRunDate != CAST('1900-1-1' as datetime)
	  SELECT 	ac.CommentID
		FROM dbo.uv_AllComments ac
	   WHERE ac.CreationDate > @LastRunDate
set @LastRunDate = CURRENT_TIMESTAMP

GO
/****** Object:  StoredProcedure [dbo].[usp_getChangedQuestionComments]    Script Date: 6/16/2015 8:28:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_getChangedQuestionComments] @LastRunDate datetime output AS
  if @LastRunDate != CAST('1900-1-1' as datetime)
	  SELECT CommentID
		FROM dbo.uv_AllQuestionComments 
	   WHERE CreationDate > @LastRunDate
  set @LastRunDate = CURRENT_TIMESTAMP

GO
/****** Object:  StoredProcedure [dbo].[usp_getChangedQuestions]    Script Date: 6/16/2015 8:28:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_getChangedQuestions] @LastRunDate datetime output AS
  if @LastRunDate != CAST('1900-1-1' as datetime)
	  SELECT  	aq.Id
		FROM dbo.uv_AllQuestions aq 
	   WHERE aq.LastEditDate > @LastRunDate
set @LastRunDate = CURRENT_TIMESTAMP

GO
/****** Object:  StoredProcedure [dbo].[usp_getChangedResponseComments]    Script Date: 6/16/2015 8:28:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_getChangedResponseComments] @LastRunDate datetime output AS
  if @LastRunDate != CAST('1900-1-1' as datetime)
	  SELECT CommentID
		FROM dbo.uv_AllResponseComments 
	   WHERE CreationDate > @LastRunDate
  set @LastRunDate = CURRENT_TIMESTAMP

GO
/****** Object:  StoredProcedure [dbo].[usp_getChangedResponses]    Script Date: 6/16/2015 8:28:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_getChangedResponses] @LastRunDate datetime output AS
  if @LastRunDate != CAST('1900-1-1' as datetime)
	  SELECT 	ar.Id
		FROM dbo.uv_AllResponses ar 
	   WHERE LastEditDate > @LastRunDate
set @LastRunDate = CURRENT_TIMESTAMP

GO
/****** Object:  StoredProcedure [dbo].[usp_getChangedUsers]    Script Date: 6/16/2015 8:28:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_getChangedUsers] @LastRunDate datetime output as
  if @LastRunDate != CAST('1900-1-1' as datetime)
	  SELECT  ua.Id
		FROM dbo.uv_AllUsers ua 
	   WHERE ua.CreationDate > @LastRunDate
set @LastRunDate = CURRENT_TIMESTAMP

GO
/****** Object:  StoredProcedure [dbo].[usp_getComment]    Script Date: 6/16/2015 8:28:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_getComment] @CommentID INT AS
  SELECT 	ac.CommentID,
			ac.CreationDate,
			ac.PostId,
			ac.Score,
			ac.Text,
			ac.UserId,
			ac.DisplayName
    FROM dbo.uv_AllComments ac
   WHERE CommentID	=@CommentID 


GO
/****** Object:  StoredProcedure [dbo].[usp_getCommentByPostID]    Script Date: 6/16/2015 8:28:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[usp_getCommentByPostID] @postID INT AS
  SELECT 	ac.CommentID,
			ac.CreationDate,
			ac.PostId,
			ac.Score,
			ac.Text,
			ac.UserId,
			ac.DisplayName
    FROM dbo.uv_AllComments ac
   WHERE PostId	=@postID 

GO
/****** Object:  StoredProcedure [dbo].[usp_getDeletedAnswerComments]    Script Date: 6/16/2015 8:28:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].[usp_getDeletedAnswerComments] @LastRunDate datetime output AS
  SELECT CommentID
    FROM dbo.uv_AllAnswerComments 
   WHERE 0 = 1
set @LastRunDate = CURRENT_TIMESTAMP

GO
/****** Object:  StoredProcedure [dbo].[usp_getDeletedAnswers]    Script Date: 6/16/2015 8:28:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getDeletedAnswers] @LastRunDate datetime output AS
  SELECT 	aa.Id
    FROM dbo.uv_AllAcceptedAnswers aa 
   WHERE 0 = 1
  set @LastRunDate = CURRENT_TIMESTAMP

GO
/****** Object:  StoredProcedure [dbo].[usp_getDeletedComments]    Script Date: 6/16/2015 8:28:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_getDeletedComments] @LastRunDate datetime output AS
  SELECT 	ac.CommentID
    FROM dbo.uv_AllComments ac
   WHERE 0 = 1
set @LastRunDate = CURRENT_TIMESTAMP

GO
/****** Object:  StoredProcedure [dbo].[usp_getDeletedQuestionComments]    Script Date: 6/16/2015 8:28:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].[usp_getDeletedQuestionComments] @LastRunDate datetime output AS
  SELECT CommentID
    FROM dbo.uv_AllQuestionComments 
   WHERE 0 = 1
set @LastRunDate = CURRENT_TIMESTAMP

GO
/****** Object:  StoredProcedure [dbo].[usp_getDeletedQuestions]    Script Date: 6/16/2015 8:28:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_getDeletedQuestions] @LastRunDate datetime output AS
  SELECT  	aq.Id
    FROM dbo.uv_AllQuestions aq 
   WHERE 0 = 1
set @LastRunDate = CURRENT_TIMESTAMP

GO
/****** Object:  StoredProcedure [dbo].[usp_getDeletedResponseComments]    Script Date: 6/16/2015 8:28:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].[usp_getDeletedResponseComments] @LastRunDate datetime output AS
  SELECT CommentID
    FROM dbo.uv_AllResponseComments 
   WHERE 0 = 1
set @LastRunDate = CURRENT_TIMESTAMP

GO
/****** Object:  StoredProcedure [dbo].[usp_getDeletedResponses]    Script Date: 6/16/2015 8:28:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_getDeletedResponses] @LastRunDate datetime output AS
  SELECT 	ar.Id
    FROM dbo.uv_AllResponses ar 
   WHERE 0 = 1
set @LastRunDate = CURRENT_TIMESTAMP

GO
/****** Object:  StoredProcedure [dbo].[usp_getDeletedUsers]    Script Date: 6/16/2015 8:28:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_getDeletedUsers] @LastRunDate datetime output as
  SELECT  ua.Id
    FROM dbo.uv_AllUsers ua 
   WHERE 0 = 1
set @LastRunDate = CURRENT_TIMESTAMP


GO
/****** Object:  StoredProcedure [dbo].[usp_getPostByID]    Script Date: 6/16/2015 8:28:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_getPostByID] @postID INT AS
  SELECT p.Id,
		p.ParentId,
		p.AcceptedAnswerId,
		p.AnswerCount,
		p.Body,
		p.ClosedDate,
		p.CommentCount,
		p.CommunityOwnedDate,
		p.CreationDate,
		p.FavoriteCount,
		p.LastActivityDate,
		p.LastEditDate,
		p.LastEditorDisplayName,
		p.Score,
		p.Tags,
		p.Title,
		p.ViewCount,
		u.DisplayName,
		PT.Type as PostType
    FROM dbo.Posts p 
		left outer JOIN Users AS u ON p.OwnerUserId = u.Id 
		left outer JOIN PostTypes AS PT ON p.PostTypeId = PT.Id
   WHERE p.Id = @postID 


GO
/****** Object:  StoredProcedure [dbo].[usp_getQuestion]    Script Date: 6/16/2015 8:28:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getResponsesByQuestionID] @QuestionID INT AS
  SELECT 	ar.Id,
		ar.ParentId,
		ar.AnswerCount,
		ar.Body,
		ar.ClosedDate,
		ar.CommentCount,
		ar.CommunityOwnedDate,
		ar.CreationDate,
		ar.FavoriteCount,
		ar.LastActivityDate,
		ar.LastEditDate,
		ar.LastEditorDisplayName,
		ar.Score,
		ar.Tags,
		ar.Title,
		ar.ViewCount,
		ar.DisplayName,
		ar.PostType
    FROM dbo.uv_AllResponses ar
   WHERE ar.Id	=@questionID 

GO
/****** Object:  StoredProcedure [dbo].[usp_getUser]    Script Date: 6/16/2015 8:28:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getUser] @userID INT AS
  SELECT  ua.Id,
          ua.AboutMe,
          ua.Age,
          ua.CreationDate,
          ua.DisplayName,
          ua.DownVotes,
          ua.LastAccessDate,
          ua.Location,
          ua.Reputation,
          ua.UpVotes,
          ua.Views,
          ua.WebsiteUrl
    FROM dbo.uv_AllUsers ua 
   WHERE Id=@userid 

GO

Grant select, view definition on uv_AllAcceptedAnswers to SPSearchCrawl
Grant select, view definition on uv_AllAnswerComments to SPSearchCrawl
Grant select, view definition on uv_AllComments to SPSearchCrawl
Grant select, view definition on uv_AllQuestionComments to SPSearchCrawl
Grant select, view definition on uv_AllQuestions to SPSearchCrawl
Grant select, view definition on uv_AllResponseComments to SPSearchCrawl
Grant select, view definition on uv_AllResponses to SPSearchCrawl
Grant select, view definition on uv_AllUsers to SPSearchCrawl
grant execute on usp_getAcceptedAnswer to SPSearchCrawl
grant execute on usp_getAccpetedAnswersByQuestionID to SPSearchCrawl
grant execute on usp_getChangedAnswerComments to SPSearchCrawl
grant execute on usp_getChangedAnswers to SPSearchCrawl
grant execute on usp_getChangedComments to SPSearchCrawl
grant execute on usp_getChangedQuestionComments to SPSearchCrawl
grant execute on usp_getChangedQuestions to SPSearchCrawl
grant execute on usp_getChangedResponseComments to SPSearchCrawl
grant execute on usp_getChangedResponses to SPSearchCrawl
grant execute on usp_getChangedUsers to SPSearchCrawl
grant execute on usp_getComment to SPSearchCrawl
grant execute on usp_getCommentByPostID to SPSearchCrawl
grant execute on usp_getDeletedAnswerComments to SPSearchCrawl
grant execute on usp_getDeletedAnswers to SPSearchCrawl
grant execute on usp_getDeletedComments to SPSearchCrawl
grant execute on usp_getDeletedQuestionComments to SPSearchCrawl
grant execute on usp_getDeletedQuestions to SPSearchCrawl
grant execute on usp_getDeletedResponseComments to SPSearchCrawl
grant execute on usp_getDeletedResponses to SPSearchCrawl
grant execute on usp_getDeletedUsers to SPSearchCrawl
grant execute on usp_getPostByID to SPSearchCrawl
grant execute on usp_getResponsesByQuestionID to SPSearchCrawl
grant execute on usp_getUser to SPSearchCrawl

