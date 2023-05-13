USE [MyfirtDB]
GO
alter table [dbo].[Test_tbl] 
--add empAdded date 
add constraint CC_CheckSalaryNoLess0andNoMore100000 check (salary>0 and salary<100000)

select * from [dbo].[Test_tbl]

select * from [dbo].[Test_tbl]
where id=1
select * from [dbo].[Test_tbl]
where id>7 and salary>10000
select 'test'

-- like
select * from [dbo].[Test_tbl]
where [Column 3] like '999%'

-- rename the column name 
sp_rename '[dbo].[Test_tbl].[Column 3]', 'salary', 'COLUMN'
select * from [dbo].[Test_tbl]

-- WITH TIES [name of the col] - this clause returns any addtional rows that have the value in the specified in the roder by
select top 1 with ties id, FirstName,LastName,salary from [dbo].[Test_tbl]
where salary>1000 and salary<2000
order by salary desc

update [dbo].[Test_tbl]
set email='andrew@krupoves.com'
where FirstName='Andrew'

insert into dbo.Test_tbl(FirstName,LastName,salary,email)
values ('Michael','Water',99999,'micahel@water.com')

-- check/find constraints
select name from sys.check_constraints
where object_id=OBJECT_ID([dbo].[Test_tbl]) and parent_column_id=COL_NAME(emp_Added)

-- diff DB
USE [labActivity04]
GO
-- create a new tbl
create table Employees (
EmployeeID int identity(1,1) primary key not null,
FirstName varchar(50) not null,
LastName varchar(50) not null,
ContactNo varchar(20) 
)
select * from Employees

-- Insert rows into the tbl
insert into dbo.Employees(FirstName,LastName,ContactNo)
values 
('Michael','Water','111-111-111'),
('Sam','Mac','222-222-222'),
('Catie','Randwick','333-333-333'),
('Calob','Bondi','444-444-444'),
('John','Smith','555-555-555')

--insert into dbo.Teachers(EmployeeID,AcademicRank,RatePerUnit,Department)
--values (6,'Instructor',500, 'CPE')

--insert into dbo.Departments(DeptCode,Name,ContactNo)
--values ('ISP','Info System Tech','0101-01'), ('CPE','Computer Engin Depa','0202-02')
select * from dbo.Teachers
select * from dbo.Departments
select * from dbo.Employees
select * from dbo.Meetings
select * from dbo.FacultyMeeting
select * from dbo.Politicians 

insert into dbo.Politicians(Surname,GivenName,isActive)
values 
('John','Smith',1)

----------------------------------------

-- CROSS JOIN - combines every row from one tbl w\ every row from anothe tbl.
-- tbl A has 4 rows and tbl B - 3 rows, as result 12 rows 
select * from dbo.Employees
cross join dbo.Meetings

select * from dbo.Politicians 
select * from dbo.Employees
-- UNION - combines data from multiple tbls/queries and removes duplicates
-- the columns number must match and data tyoe too!!
select FirstName,LastName from dbo.Employees
union -- as a result the rows will be concatenated VERTICALLY, preserving column structure 
select Surname,GivenName from dbo.Politicians
-- UNION ALL - keeps duplicates and returns all rows

-- INTERSECT - identifies and retrieves similiar rows, good for finding intersections/overlapping datasets
select FirstName,LastName from dbo.Employees
intersect 
select Surname,GivenName from dbo.Politicians

-- EXCEPT operator removes any duplicate rows from the result set and returns only the distinct rows 
--  that are unique to the 1st SELECT statement
select Surname,GivenName from dbo.Politicians
EXCEPT
select FirstName,LastName from dbo.Employees

-- This querry finds who was not sign up for the meeting and later on returns the name of it
select * from dbo.Employees
where EmployeeID in (
select EmployeeID from dbo.Teachers
except
select Faculty from dbo.FacultyMeeting
)

select EmployeeID from dbo.Teachers
select Faculty from dbo.FacultyMeeting

-- SUBQUERRY
insert into dbo.Teachers(EmployeeID,AcademicRank,RatePerUnit,Department)
values (4,'Inter',300,'CPE')
select * from dbo.Teachers
select * from dbo.Employees
select top 2 * from dbo.Departments
select * from dbo.Employees
where EmployeeID=6 OR EmployeeID=2 OR EmployeeID=8 OR EmployeeID=1

select e.EmployeeID, e.FirstName,e.LastName,t.AcademicRank,t.AcademicRank from dbo.Teachers as t inner join dbo.Employees as e on t.EmployeeID=e.EmployeeID
where Department= (
select DeptCode from dbo.Departments
where Name like '%computer%')
-- just one record is returned, since we use '='
select FirstName,LastName from dbo.Employees
where EmployeeID=(select EmployeeID from dbo.Teachers
where Department=(select DeptCode from dbo.Departments where Name like '%computer%'))

-- LIST Value subquerry, using IN operator, where we reuturn multiple rows 
select FirstName,LastName from dbo.Employees
where EmployeeID IN (select EmployeeID from dbo.Teachers
where Department=(select DeptCode from dbo.Departments where Name like '%info%'))

----------------------------------------

-- Inneer join 3 tbls - returns just MATCHES!!!!
use labActivity04
go
select m.*,t.Department from dbo.FacultyMeeting as f inner join dbo.Teachers as t
on f.Faculty=t.EmployeeID inner join dbo.Meetings as m 
on m.MeetingID=f.Meeting

select * from dbo.FacultyMeeting
select * from dbo.Teachers
select * from dbo.Meetings
select * from dbo.Employees

-- Inner join 3 tbls
select e.LastName+' '+e.FirstName as [last and firt name], t.EmployeeID,t.AcademicRank,d.Name 
from dbo.Teachers as t inner join dbo.Departments as d
on t.Department=d.DeptCode inner join dbo.Employees as e 
on t.EmployeeID=e.EmployeeID

-- outer join lef/righ, same, return all records and if some values don't exist = NULL
select * from dbo.FacultyMeeting as f left outer join dbo.Teachers as t
on f.Faculty=t.EmployeeID


insert into dbo.FacultyMeeting (Faculty,Meeting)
values(1,4)

-- alter column's type
alter table dbo.Meetings
alter column Venue varchar(100)

-- adding data and time
declare @addhours INT=2 
declare @timeNow time=convert(time, GETDATE(), 114) -- getiing current time and store in var
insert into dbo.Meetings(Date,timeStart,timeEnd,Venue)
values (GETDATE(),convert(time, GETDATE(), 114),dateadd(HOUR,@addhours,@timeNow),'Sydney')

--------------------Delete, Insert, Update, DML-data manipulation Lang--------------------

create database LabActivity08  -- create DB
-- table Persons
create table Persons
(
PersonID int identity(100,1) primary key,
LastName nvarchar(50),
FirstName nvarchar(50)
) 

alter table dbo.Persons
alter column LastName nvarchar(50) not null -- adding not null 
alter table dbo.Persons
alter column FirstName nvarchar(50) not null


-- table Students
create table Students
(
StudentNo nchar(11) primary key not null,
LastName nvarchar(50) not null,
FirstName nvarchar(50) not null,
DegreeProgram nvarchar(50) not null,
YearLVL int,
Graduating bit,
Birthday date
)

insert into Students (StudentNo, LastName, FirstName, DegreeProgram, YearLVL, Graduating, Birthday)
values(20200912345,'Jobs','Steve','Marketing',1,0,'10/10/1980')
-- since some NOY NULL values are allowed, and thus I'm going to insert just needed columns
insert into Students (StudentNo, LastName, FirstName, DegreeProgram)
values(20210854321,'Dell','Miki','Electronics')
-- inserting a row without specifying column names
insert into Students
values(20231067890,'Tate','Andrew','Sales',3,0,'1982-09-15')

use LabActivity08
go

insert into dbo.Persons (LastName,FirstName)
values ('Miki','Dell'),
('Viki','Shmiki'),
('Brodie','Apple')
select * from dbo.Persons
select * from dbo.Students

-- INSERT, we select columns from tbl Persons, add missing columns from tbl Students in order to match the name and insert to Students tbl
insert into dbo.Students (StudentNo, LastName, FirstName, DegreeProgram, YearLVL, Graduating, Birthday)
select '20091234345', LastName,FirstName,'Information Tech',4,1,'1990-05-15' from dbo.Persons -- columns that match with another tbl we leave the columns the same, otherwise we provide values that need to be inserted 
where personID=102
select * from dbo.Students

-- return OUTPUT when something was inserted
insert into dbo.Persons (LastName,FirstName)
output inserted.PersonID --what would u like to see as a returned output using inserted.
values ('Friman','Alex')

insert into dbo.Persons (LastName,FirstName)
output inserted.PersonID, inserted.FirstName+' '+inserted.LastName as [Full Name]
values ('Smith','John')
select * from dbo.Persons

------- UPDATE -------
update dbo.Students
set YearLVL=2
where StudentNo=20210854321

-- Update multiple values 
update dbo.Students
set Graduating=0,Birthday=GETDATE() -- the desired updated values separated by comma
where StudentNo=20210854321

-- Replace function - instead of update, you do not need to provide where statement 
update dbo.Students
set DegreeProgram= REPLACE(DegreeProgram,'Information Tech','Information Technologies')

update dbo.Students
set Birthday='2000-10-16'
where Birthday='2023-05-10'
select * from dbo.Students

------- DELETE -------

delete from dbo.Persons
where PersonID=100

-- output deleted.<col> -> returns what was deleted
delete from dbo.Persons
output deleted.PersonID, deleted.FirstName --just displays these values 
where LastName='Smith'
select * from dbo.Persons


------------ VIEWS ------------
-- it's virtual table to view data without change it

------------ FUNCTIONS ------------
Select HAS_DBACCESS('MyfirtDB')

-- date fn
select CURRENT_TIMESTAMP
select DATEPART(MONTH,GETDATE()) -- 5
select SYSDATETIME()
select DATENAME(Month,getdate()), DATENAME(WEEKDAY,getdate()),DATENAME(DAY,getdate())
select DATEDIFF(Year,'1990-05-16 15:00:56.9666824', GETdate())
select DATEDIFF(YEAR,Birthday,GETDATE()) as year_diff from dbo.Students
select DATEADD(DAY,100,GETDATE()), DATENAME(Weekday,DATEADD(DAY,100,GETDATE()))

--str fn
select SUBSTRING('__Andrew__',3,6) -- Andrew
use LabActivity08
go
select SUBSTRING(FirstName,1,1)+SUBSTRING(LastName,1,1) as Initials, FirstName, LastName from dbo.Students

-- MATH fn
select RAND(), 10*(ROUND(rand(),1))

------------ Stored procudure ------------
 use labActivity04
 go
 select * from Employees
-- creation of User Defined Stored Procedure
create proc uspAddEmploee
@fname varchar(60)
,@lname varchar(60)
,@phNumber varchar(50)
as
begin
insert into dbo.Employees
values (@fname,@lname,@phNumber)
end

--alter this procedure
alter proc uspAddEmploee
@fname varchar(60)
,@lname varchar(60)
,@phNumber varchar(50)
as
begin
insert into dbo.Employees
values (@fname,@lname,@phNumber)
select @@IDENTITY as EmployeeID
select * from Employees
end

alter proc uspAddEmploee
@fname varchar(60)
,@lname varchar(60)
,@phNumber varchar(50)
as
begin
insert into dbo.Employees
values (@fname,@lname,@phNumber)
select * from Employees where EmployeeID=@@IDENTITY
end
-- we do not use brackets 
exec uspAddEmploee 'Samantha','Aubrey','670-414-6631'
go

-- stored procedure that updates values/rows
select * from Teachers
create proc uspUpdateTeachersRatePerUnit
@emp_id int,
@new_rate smallmoney
as
begin
update dbo.Teachers
set RatePerUnit=@new_rate
where EmployeeID=@emp_id
select @@ROWCOUNT as Updated_Row 
end

exec uspUpdateTeachersRatePerUnit 4,1000

------ Trigers ------ 
use labActivity04
go

select * from Employees
select * from EmployeesTest
select EmployeeID, ContactNo,LastName,FirstName into EmployeesTest
from Employees

create table EmployeeLog (
EmployeeID int,
[Status] varchar (50)
)
alter table EmployeeLog add  FirstName varchar (50),LastName varchar (50)

-- Insert Trigger
alter trigger EmployeesTest_INSERT on EmployeesTest
after insert -- The trigger is executed after an "insert" operation is performed 
as
begin
set nocount on -- SQL Server will supress the msg indicating the num if rows affected by this trigger
declare @EmployeeID int
select @EmployeeID=inserted.EmployeeID -- inserted is a virtual tbl to the @EmployeeID var
from inserted

insert into EmployeeLog -- the result will be stored in EmployeeLog tbl
values(@EmployeeID,'Inserted')
end

select * from Employees
insert into EmployeesTest(ContactNo,LastName,FirstName)
values('370-6-721-587','Jonas','Smith')

insert into EmployeesTest(ContactNo,LastName,FirstName)
values('62-004-009-007','Miki','Sydney')

select * from EmployeesTest
select * from EmployeeLog
select FirstName,LastName from EmployeesTest
where EmployeeID in (select EmployeeID from EmployeeLog)

-- Delete Tigger
alter trigger EmployeesTest_DELETE on EmployeesTest
after delete -- The trigger is executed after an "insert" operation is performed 
as
begin
set nocount on -- SQL Server will supress the msg indicating the num if rows affected by this trigger
declare @EmployeeID int
declare @empFName nvarchar(50)
declare @empLName nvarchar(50)
select @EmployeeID=deleted.EmployeeID, -- deleted is a virtual tbl to the @EmployeeID var
@empFName=deleted.FirstName,
@empLName=deleted.LastName
from deleted

insert into EmployeeLog -- the result will be stored in EmployeeLog tbl
values(@EmployeeID,'Deleted',@empFName,@empLName)
end 

select * from EmployeesTest
delete from EmployeesTest where EmployeeID=14
select * from EmployeeLog

-- Update Trigger
Create trigger EmployeesTest_UPDATE on EmployeesTest
after update -- The trigger is executed after an "insert" operation is performed 
as
begin
set nocount on -- SQL Server will supress the msg indicating the num if rows affected by this trigger
declare @EmployeeID int
declare @Action nvarchar(50)
declare @empLName nvarchar(50)
declare @empFName nvarchar(50)
select @EmployeeID=inserted.EmployeeID, @empFName=inserted.FirstName,@empLName=inserted.LastName -- inserted is a virtual tbl to the @EmployeeID var
from inserted

if UPDATE(ContactNo)
set @Action='Phone number was updated'
if update (LastName)
set @Action='Last name was updated'

insert into EmployeeLog -- the result will be stored in EmployeeLog tbl
values(@EmployeeID,@Action,@empFName,@empLName)
end 


select * from EmployeesTest
update EmployeesTest set ContactNo='371-6-852-782' where EmployeeID=1
update EmployeesTest set LastName='Shamamama' where EmployeeID=2
select * from EmployeeLog


-- Update/Insert Trigger make last name uppercases
create trigger EmployeesTest_INSERT_UPDATE on EmployeesTest
after insert, update
as
begin
UPDATE EmployeesTest set LastName=upper(LastName)
where LastName in (select LastName from inserted)
end

select * from EmployeesTest
insert into EmployeesTest (FirstName,LastName)
values('tesT1','tesT1'),('tesT2','tesT2'),('tesT3','tesT3')
  
---- TRY CATCH ---- 
use labActivity04
go
begin try
select 1/0
end try
begin catch
print ('The error has been generated') -- In Messages Tab you can find these msgs
print ('An error occured: '+convert(varchar,ERROR_number(),1) + ': '+ error_message())
print ('The severity is: ')+convert(varchar,ERROR_severity(),10)
end catch
select * from dbo.Employees

-- Try Catch using object_id, checking if a tbl exists 

declare @object_id_empl INT
declare @object_id_stud INT
set @object_id_empl=OBJECT_ID('dbo.Employees') -- if this tbl exists the INT will be returned, else NULL
set @object_id_stud=OBJECT_ID('dbo.Students')

begin try
if @object_id_empl is not null
select * from dbo.Employees
else 
Print 'The table does not exist'
if @object_id_stud is not null
select * from dbo.Students
else 
Print 'The table does not exist'
end try
begin catch
print ('The error has been generated by this request') -- In Messages Tab you can find these msgs
print ('An error occured: '+convert(varchar,ERROR_number(),1) + ': '+ error_message())
print ('The severity of the error is: ')+convert(varchar,ERROR_severity(),10)
end catch 

-- run all possible INSERT statements and if there is error just show me and move on

begin try 
insert into dbo.Students -- if I don't provide what to insert then I need to provide all of them
values ('20101010101','Rogan','Joe','Media',1,0,'1973-07-23') 
print 'SUCCESS: Record has been inserted'
end try
begin catch
print 'FAILURE: Record has NOT been inserted'
print 'Error '+convert(varchar,ERROR_number(),1) + ': '+ error_message()
end catch
begin try 
insert into dbo.Students -- if I don't provide what to insert then I need to provide all of them
values (19991099900,'Altman','Sam','AI',1,0,'1993-05-17') 
print 'SUCCESS: Record has been inserted'
end try
begin catch
print 'FAILURE: Record has NOT been inserted'
print 'Error '+convert(varchar,ERROR_number(),1) + ': '+ error_message()
end catch
begin try 
insert into dbo.Students -- if I don't provide what to insert then I need to provide all of them
values (19891077900,'Huberman','Andrew','Health',3,0,'1983-05-17') 
print 'SUCCESS: Record has been inserted'
end try
begin catch
print 'FAILURE: Record has NOT been inserted'
print 'Error '+convert(varchar,ERROR_number(),1) + ': '+ error_message()
end catch
select * from dbo.Students

-- Temprory table 
declare @employeeIdIden INT
set @employeeIdIden=@@IDENTITY
select * into #EmployeesTemp from dbo.Employees
--select * from #EmployeesTemp
insert into #EmployeesTemp
values(@employeeIdIden,'Sam','Kovolovskij','372-621-547-115')

select * into #StudentsCopy from dbo.Students
insert into #StudentsCopy
values (19891077900,'Huberman','Andrew','Health',3,0,'1983-05-17') 
select @@IDENTITY
select * from #StudentsCopy
select * from dbo.Students
drop table #StudentsCopy
