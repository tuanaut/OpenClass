USE master;

-- If EBM doesn't exist, create it
IF DB_ID(N'EBM') IS NOT NULL DROP DATABASE EBM;

-- If database could not be created due to open connections, abort
IF @@ERROR = 3702 
   RAISERROR(N'Database cannot be dropped because there are still open connections.', 127, 127) WITH NOWAIT, LOG;

CREATE DATABASE EBM;
GO

USE EBM;
GO

---------------------------------------------------------------------
-- Create Tables
---------------------------------------------------------------------
CREATE TABLE dbo.Business
(
	-- businessID: GUID
	businessID		NVARCHAR(36)	NOT NULL,
	businessName	NVARCHAR(20)	NOT NULL,
	totalFunds		FLOAT			NULL,

	CONSTRAINT PK_Business PRIMARY KEY(businessID)
);

CREATE TABLE dbo.Departments
(
	-- departmentID: GUID
	departmentID	NVARCHAR(36)	NOT NULL,
	departmentName	NVARCHAR(20)	NOT NULL,
	departmentPriority	INT			NOT NULL,

	businessID		NVARCHAR(36)	NOT NULL,

	CONSTRAINT PK_Departments PRIMARY KEY(departmentID),
	CONSTRAINT FK_Departments_Business FOREIGN KEY(businessID)
		REFERENCES dbo.Business(businessID)
);

CREATE TABLE dbo.Users
(
	-- userID: GUID
	userID			NVARCHAR(36)	NOT NULL,
	username		NVARCHAR(20)	NOT NULL,
	passwd			NVARCHAR(20)	NOT NULL,
	accessRights	INT				NOT NULL,
	email			NVARCHAR(20)	NULL,

	departmentID		NVARCHAR(36)	NOT NULL,

	CONSTRAINT PK_Users PRIMARY KEY(userID),
	CONSTRAINT FK_Users_Department FOREIGN KEY(departmentID)
		REFERENCES dbo.Departments(departmentID)
);

CREATE TABLE dbo.Budget
(
	-- budgetID: GUID
	budgetID		NVARCHAR(36)	NOT NULL,
	timePeriodStart	DATE			NOT NULL,
	timePeriodEnd	DATE			NULL,
	emrgncyFunds	FLOAT			NOT NULL,
	totalAllowance	FLOAT			NOT NULL,

	userID			NVARCHAR(36)	NOT NULL,
	departmentID	NVARCHAR(36)	NOT NULL,

	CONSTRAINT PK_Budget PRIMARY KEY(budgetID),
	CONSTRAINT FK_Budget_Users FOREIGN KEY(userID)
		REFERENCES dbo.Users(userID),
	CONSTRAINT FK_Budget_Department FOREIGN KEY(departmentID)
		REFERENCES dbo.Departments(departmentID)
);

CREATE TABLE dbo.Categories
(
	-- categoryID: GUID
	categoryID		NVARCHAR(36)	NOT NULL,
	categoryName	NVARCHAR(20)	NOT NULL,
	details			NVARCHAR(200)	NULL,
	dateCreated		DATE			NOT NULL,

	CONSTRAINT PK_Categories PRIMARY KEY(categoryID)
);

CREATE TABLE dbo.Expenses
(
	-- expenseID: GUID
	expenseID		NVARCHAR(36)	NOT NULL,
	expenseName		NVARCHAR(20)	NOT NULL,
	dateOfExpense	DATE			NOT NULL,
	expenseValue	FLOAT			NOT NULL,
	details			NVARCHAR(200)	NULL,

	budgetID		NVARCHAR(36)	NOT NULL,
	categoryID		NVARCHAR(36)	NOT NULL,

	CONSTRAINT PK_Expenses PRIMARY KEY(expenseID),
	CONSTRAINT FK_Expenses_Budget FOREIGN KEY(budgetID)
		REFERENCES dbo.Budget(budgetID),
	CONSTRAINT FK_Expenses_Categories FOREIGN KEY(categoryID)
		REFERENCES dbo.Categories(categoryID)
);

CREATE TABLE dbo.BudgetRequests
(
	-- requestID: GUID
	requestID		NVARCHAR(36)	NOT NULL,
	dateRequested	DATE			NOT NULL,
	approvalStat	INT				NOT NULL,
	amount			FLOAT			NOT NULL,
	details			NVARCHAR(200)	NULL,

	-- Handler
	userID			NVARCHAR(36)	NOT NULL,
	categoryID		NVARCHAR(36)	NOT NULL,
	budgetID		NVARCHAR(36)	NOT NULL,

	CONSTRAINT PK_BudgetRequests PRIMARY KEY(requestID),
	CONSTRAINT FK_Requests_Users FOREIGN KEY(userID)
		REFERENCES dbo.Users(userID),
	CONSTRAINT FK_Requests_Categories FOREIGN KEY(categoryID)
		REFERENCES dbo.Categories(categoryID),
	CONSTRAINT FK_Requests_Budget FOREIGN KEY(budgetID)
		REFERENCES dbo.Budget(budgetID)
);

CREATE TABLE dbo.BudgetProjections
(
	-- projectionID: GUID
	projectionID	NVARCHAR(36)	NOT NULL,
	rangeStart		DATE			NOT NULL,
	rangeEnd		Date			NOT NULL,
	projectionData	NVARCHAR(50)	NULL,

	budgetID		NVARCHAR(36)	NOT NULL,
	-- creator
	userID			NVARCHAR(36)	NOT NULL,

	CONSTRAINT PK_BudgetProjections PRIMARY KEY(projectionID),
	CONSTRAINT FK_Projections_Budgets FOREIGN KEY(budgetID)
		REFERENCES dbo.Budget(budgetID),
	CONSTRAINT FK_Projections_Users FOREIGN KEY(userID)
		REFERENCES dbo.Users(userID)
);