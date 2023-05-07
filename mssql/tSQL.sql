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
select * from dbo.Meetings
select * from dbo.Departments
select * from dbo.Employees
select * from dbo.FacultyMeeting

-- Inneer join 3 tbls - returns just MATCHES!!!!
select * from dbo.FacultyMeeting as f inner join dbo.Teachers as t
on f.Faculty=t.EmployeeID inner join dbo.Meetings as m 
on m.MeetingID=f.Meeting

-- Inner join 3 tbls
select e.LastName+' '+e.FirstName as [last and firt name], t.EmployeeID,t.AcademicRank,d.Name 
from dbo.Teachers as t inner join dbo.Departments as d
on t.Department=d.DeptCode inner join dbo.Employees as e 
on t.EmployeeID=e.EmployeeID

-- outer join lef/righ, same, return all records and if some values don't exist = NULL
select * from dbo.FacultyMeeting as f left outer join dbo.Teachers as t
on f.Faculty=t.EmployeeID


insert into dbo.FacultyMeeting (Faculty,Meeting)
values(3,1),(2,2),(1,3)

-- alter column's type
alter table dbo.Meetings
alter column Venue varchar(100)

-- adding data and time
declare @addhours INT=2 
declare @timeNow time=convert(time, GETDATE(), 114) -- getiing current time and store in var
insert into dbo.Meetings(Date,timeStart,timeEnd,Venue)
values (GETDATE(),convert(time, GETDATE(), 114),dateadd(HOUR,@addhours,@timeNow),'Amsterdam')