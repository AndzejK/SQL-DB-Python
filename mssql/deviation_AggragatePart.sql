-- Partitioniong (logical window like by the class) 
-- Rank within Rank, we have a few familly businesses and some members 
-- we can rank each member in a familly and later separate each family to
select [first name], [last name], [base rate], 
rank() over (partition by [last name] order by [base rate] desc) as [Rank]
from dbo.employees
order by [last name],[Rank]

-- partition fn can be used with any rank fn
-- how families doing quaterly  -- 151 result changes 
select [first name], [last name], [base rate], 
ntile(4) over (partition by [last name] order by [base rate] desc) as [Rank] 
from dbo.employees
--where [last name]='Duke'
order by [last name],[Rank]

-- Aggragate partition, in this case we calc how much a memeber of family is off AVG base rate
select [first name], [last name], [base rate],  -- BUT WITHIN family, based on [last name] 
[base rate]-AVG([base rate]) over (partition by [last name]) as [Rate Differance]
from dbo.employees
order by [last name],[Rate Differance]

--- Aggragate partition, compare to the whole table
select [first name], [last name], [base rate],  
[base rate]-AVG([base rate]) over (partition by 0) as [Rate Differance] -- partition by 'X' can be any number
from dbo.employees
order by [last name],[Rate Differance]

-- The goal is to calculate the deviation of each base rate value from 
-- the average of all base rate values. Deviation tells us how much each value differs from the average.
select [first name], [last name], [base rate], -- AVR=351.1846  STDEV=142,830380220323
[base rate]-AVG([base rate]) over (partition by 0) as [Rate Differance], -- -104.4250
round((([base rate]-AVG([base rate]) over (partition by 0))/(STDEV([base rate]) over (partition by 0)))*10,2) as Deviation
from dbo.employees
order by Deviation desc
--Example of the ID=1
select (246.7596-351.1846)/142.830380220323  

select STDEV([base rate]) from dbo.employees
select [base rate]-AVG([base rate]) as [Rate diff] from dbo.employees
group by [base rate]-AVG([base rate])