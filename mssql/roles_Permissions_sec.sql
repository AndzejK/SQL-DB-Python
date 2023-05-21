create database [sec principles]

use [sec principles]
go
select * from sys.server_principals
select * from [authority].sys.database_principals
alter login [admin-pc\noBody] enable
select * from sys.fn_my_permissions(null,'server')
use master
grant control server to [admin-pc\noBody]
create login [admin-pc\noBody] from windows

create user [admin-PC\noBody] -- sid 0x010500000000000515000000A31EC434782C91040B28ED94EC030000
select * from [sec principles].sys.database_principals
select * from [model].sys.database_principals

create role db_myRole
use [authority]

select user
setuser 'noBody'
0
-- creating creds for the Group from Wind as login too!
-- Creds for Server sidw
create login [admin-pc\CrewMem_sql] from windows -- #1
create user [crew member] from login [admin-pc\CrewMem_sql] -- #2
select * from sys.server_principals
grant select on object::numbers to [crew member]

-- sql server roles in DB!
create role pilot
select * from sys.database_principals
sp_addrolemember 'pilot','noBody'

-- Schemas
create database securityII
use securityII
select * from securityII.sys.schemas as s
select * from securityII.sys.database_principals p
-- check / see who owns the schemas 
select s.name as [Schema Name],s.schema_id,p.name as [Name from DB_prin] from securityII.sys.schemas as s
inner join securityII.sys.database_principals p
on s.principal_id=p.principal_id
-- that's where we create a user to DB not to the server! Server=Login, DB=user
create user nologin without login
create user noone from login [admin-PC\noBody]
-- creating a new user with diffrent non existing schema
create user no0ne from login [admin-PC\noone] with default_schema = suacer
select * from securityII.sys.database_principals p
where name in ('noone','no0ne','nologin')
-- change schema
alter user noone with default_schema=saucer
-- check if this user has permissions to run schemas
select * from sys.fn_my_permissions('securityII','database')

-- an atomic statement, when you have a lot statements and if one fails the whole statement won't run~
-- create a new shema applying to the new created tables
create schema saucer
create table plantes
(
id int primary key,
name varchar(50)
)
create table stars
(
id int primary key,
name varchar(50)
)
create table comets
(
id int primary key,
name varchar(50)
)
create view places
as 
select id,name from plantes
union
select id,name from stars
union
select id,name from comets;
use securityII
-- checking schema
select * from sys.schemas 
where name='saucer'
-- checking saucer sys tables :)
select * from sys.objects
where schema_id=5

select * from saucer.places
select id,name from stars -- running without "saucer" scheme fails due to being logged in as SA default schema for this user is "dbo"

setuser 'noone' --  changing db's, securityII, user to noone
setuser

-- better way of setting an user
execute as user='no0ne'
select user -- checking the current user
revert -- swithing back to the original user same as the command setuser
select * from plantes

-- Even though no0ne has default schema 'saucer' but it does not have right permissions to access this table 
grant select on saucer.places to no0ne

create schema dangers authorization no0ne
create table bad_planets
(id int primary key,name varchar(50))

-- checking who owns the dangers schema
select * from sys.schemas as s 
select * from sys.database_principals as p
select s.name as [Schema Name],p.* from sys.schemas as s 
inner join sys.database_principals as p 
on s.principal_id=p.principal_id
where s.name='dangers'
-- checking permission for 'no0ne' user for 'dangers' schema
select * from sys.fn_my_permissions('dangers','schema')
revert
 
grant create table to no0ne -- granting this access on DB level but jsut for dangers schema 

create table dangers.[status] (id int primary key, [level] varchar(20))

select * from dangers.bad_planets
revert
execute as user='noone' -- no permission for noone at that stage
select * from dangers.bad_planets
 
-- granting permissions to noone, as a no0ne
grant select on dangers.bad_planets to noone
select * from dangers.bad_planets -- now noone has access dangers.bad_planets

----------------- ROLES -----------------
use securityII
sp_helpsrvrole
select * from sys.database_principals where type='r' -- DB Roles
select * from sys.server_principals where type='r' -- Server Roles

-- give access to server, DB->securityII 
create login [admin-PC\workerbee] from windows 
-- lookup fr member in a role
sp_helpsrvrolemember 'sysadmin'

-- add a member, workerbee to sysadmin role
sp_addsrvrolemember 'admin-PC\workerbee', 'sysadmin'
-- remove add a member, workerbee to sysadmin role
sp_dropsrvrolemember 'admin-PC\workerbee', 'sysadmin'

-- DB roles: fixed and flexible
sp_helpdbfixedrole
-- add a member, workerbee to database principle by creating a user 
create user [admin-PC\workerbee] 
select * from sys.database_principals

execute as user='admin-PC\workerbee'
revert
-- Make a member,ce a reader just to read tables
sp_addrolemember 'db_datareader','admin-PC\workerbee'
-- constrict access for the workerbee using flexible setup, denying acces on schema suacer
deny select on schema::saucer to [admin-PC\workerbee]
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
revert
-- create a new role, flexible approach
create role saucer_reader -- just these member can read data for saucer schema
grant select on schema::saucer to saucer_reader
select * from sys.database_principals where type='r' -- DB Roles

-- checking the user/principle ROLEs
select prin.name as role, prin2.name as [priciple/user] from  sys.database_role_members as rm
inner join sys.database_principals as prin
on prin.principal_id=rm.role_principal_id
inner join sys.database_principals as prin2
on prin2.principal_id=rm.member_principal_id

-- add a member, workerbee to a new created role  saucer_reader
sp_addrolemember 'saucer_reader','admin-PC\workerbee'
execute as user='admin-PC\workerbee'
select * from sys.fn_my_permissions(null,'database')
revert
select user
-- a new role that denies access to schema saucer
create role no_saucer
deny control on schema::saucer to no_saucer
sp_addrolemember 'saucer_reader','admin-PC\workerbee'

-- delete the DENY permission on a schema for a user
revoke select on schema::saucer to [admin-PC\workerbee]
-- remove/drop user from role 
alter role [no_saucer] drop member [admin-PC\workerbee]
sp_droprolemember 'admin-PC\workerbee', 'no_saucer'
select * from saucer.places

----------------- Execution -----------------
-- Imperative
create database Context
-- make admin-PC\workerbee the owner of Context DB
alter authorization on database::Context to [admin-PC\workerbee]
use Context
use securityII
create table tests (id int, location varchar(50))
select * from tests
-- we add the user workerbee to this DB-Context
create user [admin-PC\workerbee]
grant select on tests to [admin-PC\workerbee]
grant control on schema::dbo to [admin-PC\workerbee]
select * from sys.syslogins
execute as user='admin-PC\workerbee'
-- to LOGIN as 
execute as login='admin-PC\workerbee'
select user
revert
select * from Context.dbo.tests

create database ExecuteAs
use ExecuteAs
create table wormHoles (id int, size varchar(50))
create user workerbee from login [admin-PC\workerbee]
execute as user='workerbee'
insert into wormHoles values(1,'small')
revert
-- we create a procedure to insert some values to the tbl rather than giving permssions to an user
create proc ShootMeAnAstroid (@key int, @size varchar(50))
as
insert into wormHoles values (@key,@size)
-- grant access to workerbee to excute procedure
grant execute on ShootMeAnAstroid to workerbee
exec ShootMeAnAstroid 1,'small'
select user
select * from wormHoles