/*	Name: Caleb Solares
	Project 3
	PantherId: 5696329
	Semester: Fall 2017
*/
Use Sola_C5696329
go

insert into master.dbo.assignments
(pantherId, firstName, lastName, databasename, assignment)
values
('5696329', 'Caleb', 'Solares', 'Sola_C5696329', 3)
go

CREATE TABLE EmployeeAudit
(
    empNumber char(8) not null,
    firstName varchar(25),
    lastName varchar(25),
    ssn char(9),
    address varchar(50),
    state char(2),
    zip char(5),
    jobCode char(4),
    dateOfBirth date,
    certification bit,
    salary money,
    Operation varchar(50),
	DateTimeStamp datetime
)
GO

CREATE TABLE JobAudit
(
    jobCode char(4) not null,
    jobDesc varchar(50),
	Operation varchar(50),
	DateTimeStamp datetime
)
GO

 CREATE TABLE ProjectMainAudit
( 
	projectId  char(4) not null,
	projectName varchar(50),
	firmFedID char(9), 
	fundedBudget decimal(16,2),
	projectStartDate date, 
	projectStatus varchar(25), 
	projectTypeCode char(5),
	projectedEndDate date,
	projectManager char(8),
	Operation varchar(50),
	DateTimeStamp datetime
)
GO

CREATE TABLE ActivityMainAudit
(
	activityId char(4) not null,
	activityName varchar(50),
	projectId  char(4) not null,
	costToDate decimal(16,2),
	activityStatus varchar(25),
	startDate date,
	endDate date,
	Operation varchar(50),
	DateTimeStamp datetime
)
GO

CREATE TRIGGER trgEmployee ON Employee
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
	IF exists(select 1 from inserted) 
	 BEGIN 
		 INSERT INTO EmployeeAudit 
		 (empNumber, firstName, lastName, ssn, address, state, zip, jobCode, dateOfBirth, certification, 
		 salary, DateTimeStamp, Operation)
		 SELECT empNumber, firstName, lastName, ssn, address, state, zip, jobCode, dateOfBirth, certification, 
		 salary, getDate(), 'INSERTED'
		 FROM inserted
	 END
	   
	 IF exists(select 1 from deleted)
	 BEGIN
		INSERT INTO EmployeeAudit 
		 (empNumber, firstName, lastName, ssn, address, state, zip, jobCode, dateOfBirth, certification, salary, 
		 DateTimeStamp, Operation)
		 SELECT empNumber, firstName, lastName, ssn, address, state, zip, jobCode, dateOfBirth, certification, salary, 
		 getDate(), 'DELETED'
		 FROM deleted
	 END

	  IF (UPDATE(empNumber) OR UPDATE(firstName) OR UPDATE(lastName) OR UPDATE(ssn) OR UPDATE(address) 
	  OR UPDATE(state) OR UPDATE(zip) OR UPDATE(jobCode) OR UPDATE(dateOfBirth) OR UPDATE(certification) 
	  OR UPDATE(salary))
		BEGIN
		INSERT INTO EmployeeAudit 
		 (empNumber, firstName, lastName, ssn, address, state, zip, jobCode, dateOfBirth, certification, salary, 
		 DateTimeStamp, Operation)
		 SELECT empNumber, firstName, lastName, ssn, address, state, zip, jobCode, dateOfBirth, certification, salary, 
		 getDate(), 'DELETED'
		 FROM deleted
		 INSERT INTO EmployeeAudit 
		 (empNumber, firstName, lastName, ssn, address, state, zip, jobCode, dateOfBirth, certification, salary, 
		 DateTimeStamp, Operation)
		 SELECT empNumber, firstName, lastName, ssn, address, state, zip, jobCode, dateOfBirth, certification, salary, 
		 getDate(), 'INSERTED'
		 FROM inserted
		END
END
GO

CREATE TRIGGER trgJob ON JobAudit
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
	IF exists(select 1 from inserted) 
	 BEGIN 
		 INSERT INTO JobAudit 
		 (jobCode, jobDesc, Operation, DateTimeStamp)
		 SELECT jobCode, jobDesc, 'INSERTED', getDate()
		 FROM inserted
	 END
	   
	 IF exists(select 1 from deleted)
	 BEGIN
		INSERT INTO JobAudit 
		 (jobCode, jobDesc, Operation, DateTimeStamp)
		 SELECT jobCode, jobDesc, 'DELETED', getDate()
		 FROM deleted
	 END

	 IF (UPDATE(jobCode) OR UPDATE(jobDesc))
	 BEGIN
	 INSERT INTO JobAudit 
		 (jobCode, jobDesc, Operation, DateTimeStamp)
		 SELECT jobCode, jobDesc, 'DELETED', getDate()
		 FROM deleted
	 INSERT INTO JobAudit 
		 (jobCode, jobDesc, Operation, DateTimeStamp)
		 SELECT jobCode, jobDesc, 'INSERTED', getDate()
		 FROM inserted
	 END
		
END
GO

CREATE TRIGGER trgProjectMain ON ProjectMainAudit
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
	IF exists(select 1 from inserted) 
	 BEGIN 
		 INSERT INTO ProjectMainAudit 
		 (projectId, projectName, firmFedID, fundedBudget, projectStartDate, projectStatus, projectTypeCode, 
		 projectedEndDate, projectManager, Operation, DateTimeStamp)
		 SELECT projectId, projectName, firmFedID, fundedBudget, projectStartDate, projectStatus, projectTypeCode, 
		 projectedEndDate, projectManager, 'INSERTED', getDate()
		 FROM inserted
	 END
	   
	 IF exists(select 1 from deleted)
	 BEGIN
		INSERT INTO ProjectMainAudit 
		 (projectId, projectName, firmFedID, fundedBudget, projectStartDate, projectStatus, projectTypeCode, 
		 projectedEndDate, projectManager, Operation, DateTimeStamp)
		 SELECT projectId, projectName, firmFedID, fundedBudget, projectStartDate, projectStatus, projectTypeCode, 
		 projectedEndDate, projectManager, 'DELETED', getDate()
		 FROM deleted
	 END

	 IF (UPDATE(projectID) OR UPDATE(projectName) OR UPDATE(firmFedID) OR 
	     UPDATE(fundedbudget) OR UPDATE(projectStartDate) OR UPDATE(projectstatus) OR 
		 UPDATE(projectTypeCode) OR UPDATE(projectedEndDate) OR UPDATE(projectManager))
		 BEGIN
			INSERT INTO ProjectMainAudit 
				(projectId, projectName, firmFedID, fundedBudget, projectStartDate, projectStatus, projectTypeCode, 
				 projectedEndDate, projectManager, Operation, DateTimeStamp)
				 SELECT projectId, projectName, firmFedID, fundedBudget, projectStartDate, projectStatus, projectTypeCode, 
				 projectedEndDate, projectManager, 'DELETED', getDate()
				 FROM deleted
			INSERT INTO ProjectMainAudit 
				(projectId, projectName, firmFedID, fundedBudget, projectStartDate, projectStatus, projectTypeCode, 
				 projectedEndDate, projectManager, Operation, DateTimeStamp)
				 SELECT projectId, projectName, firmFedID, fundedBudget, projectStartDate, projectStatus, projectTypeCode, 
				 projectedEndDate, projectManager, 'INSERTED', getDate()
				 FROM inserted
		 END
		 
END
GO

CREATE TRIGGER trgActivityMain ON ActivityMainAudit
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
	IF exists(select 1 from inserted) 
	 BEGIN 
		 INSERT INTO ActivityMainAudit 
		 (activityId, activityName, projectId, costToDate, activityStatus, startDate, endDate, 
		 Operation, DateTimeStamp)
		 SELECT activityId, activityName, projectId, costToDate, activityStatus, startDate, endDate, 
		 'INSERTED', getDate()
		 FROM inserted
	 END
	   
	 IF exists(select 1 from deleted)
	 BEGIN
		INSERT INTO ActivityMainAudit 
		 (activityId, activityName, projectId, costToDate, activityStatus, startDate, endDate, 
		 Operation, DateTimeStamp)
		 SELECT activityId, activityName, projectId, costToDate, activityStatus, startDate, endDate, 
		 'DELETED', getDate()
		 FROM deleted
	 END

	 IF (UPDATE(activityID) OR UPDATE(activityName) OR UPDATE(projectID) OR UPDATE(costToDate) OR 
	     UPDATE(activityStatus) OR UPDATE(startDate) OR UPDATE(endDate))
	 BEGIN
		INSERT INTO ActivityMainAudit 
		 (activityId, activityName, projectId, costToDate, activityStatus, startDate, endDate, 
		 Operation, DateTimeStamp)
		 SELECT activityId, activityName, projectId, costToDate, activityStatus, startDate, endDate, 
		 'DELETED', getDate()
		 FROM deleted
		INSERT INTO ActivityMainAudit 
		 (activityId, activityName, projectId, costToDate, activityStatus, startDate, endDate, 
		 Operation, DateTimeStamp)
		 SELECT activityId, activityName, projectId, costToDate, activityStatus, startDate, endDate, 
		 'INSERTED', getDate()
		 FROM deleted
	 END
END
GO

CREATE VIEW vw_TableNoIndexes
AS
(
		SELECT Name 'Tables without any Indexes'
		FROM SYS.tables
		WHERE OBJECTPROPERTY(OBJECT_ID,'TableHasIndex')=0  
)
GO

CREATE VIEW vw_ProjectIdTables
AS
(
       SELECT TABLE_NAME
       FROM INFORMATION_SCHEMA.COLUMNS
	   WHERE column_name = 'projectId'
)
GO

CREATE VIEW vw_Last7Obj
AS
(
       SELECT NAME
       FROM sys.objects
	   WHERE type = 'p' OR type = 'u'
	   AND DATEDIFF(D,modify_date, GETDATE()) < 7
)
GO

CREATE VIEW vw_ProjectProcs
AS
(
       SELECT ROUTINE_NAME
       FROM INFORMATION_SCHEMA.ROUTINES
	   WHERE ROUTINE_NAME LIKE '%project%'
	   AND ROUTINE_TYPE = 'PROCEDURE'
)
GO

CREATE PROCEDURE SP_ActiveConnections
(
	 @databasename varchar(250)
) AS
BEGIN
	SELECT DB_NAME(sP.dbid) AS DatabaseName
	, COUNT(sP.spid) AS NumberOfConnections
	, SYSTEM_USER AS LoginName
	FROM sys.sysprocesses sP
	WHERE DB_NAME(sP.dbid) = @databasename
	GROUP BY DB_NAME(sP.dbid)
END
GO

CREATE PROCEDURE SP_LogFileStatus
(
	 @databasename varchar(250)
) AS
BEGIN
	SELECT DB_NAME(mF.database_id) AS DatabaseName
	, COUNT(mF.size) AS LogSize
	, COUNT(mF.max_size) AS TotalSize
	FROM sys.master_files mF
	WHERE DB_NAME(mF.database_id) = @databasename
	GROUP BY DB_NAME(mF.database_id)
END
GO