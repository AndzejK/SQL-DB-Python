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