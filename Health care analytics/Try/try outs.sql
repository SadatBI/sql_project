SELECT *
FROM parks_and_recreation.employee_demographics;


SELECT first_name, 
last_name, 
birth_date,
age,
age + 10
FROM employee_demographics;



select distinct gender 
from parks_and_recreation.employee_demographics;


select first_name, last_name, gender
from employee_demographics
where gender = 'male';


select * 
from employee_salary
where salary >= 50000
;

select *
from employee_demographics
where gender != 'female';

select *
from employee_demographics
where birth_date >= '1980-11-11'
;


select * 
from employee_demographics
where birth_date >= '1985-05-11'
and gender = 'male'
;

select *
from employee_demographics
where age >= 30
and gender = 'male'
;


Select *
from parks_and_recreation.employee_salary
where salary >= 15000
;

select
first_name,
last_name,
gender,
age
from employee_demographics
where gender = 'male'
and age >= 39
;

select *
from employee_demographics
;

select *
from employee_demographics
where first_name like 'a%'
;

select *
from employee_demographics
where first_name like '%a%'
;

-- the more _ the more the values
select *
from employee_demographics
where first_name like 'a__'
;

-- everybody born in that year  
select *
from parks_and_recreation.employee_demographics
where birth_date like '1980%'
; 


select gender 
from employee_demographics
group by gender;


-- finding the average age of gender 
select gender, avg(age)
from employee_demographics
group by gender 
;

-- finding the average, minimum and maximum age of gender 
select gender, max(age), min(age)
from employee_demographics
group by gender
;

-- finding the number of females and males 
select gender, count(age)
from employee_demographics
group by gender 
;


-- finding the list of occupation
select occupation
from employee_salary
group by occupation
;

select occupation, salary 
from employee_salary
group by occupation, salary
;


-- Ascending or Descending order 

select *
from employee_demographics
order by first_name
;

select *
from employee_demographics
order by first_name desc
;

select *
from employee_demographics
order by gender, age
;

select *
from employee_demographics
order by gender, age desc
;

select first_name, last_name, gender, age 
from employee_demographics
where gender = 'male'
order by age 
;

select gender, min(age)
from employee_demographics
group by gender
having min(age) > 10 
;

select occupation, min(salary)
from employee_salary
group by occupation
;

select occupation, min(salary)
from employee_salary
where occupation like '%manager%'
group by occupation 
having min(salary) > 20000
;

select *
from employee_demographics
where gender = 'male'
;

select IsOfficial, count(IsOfficial)
from world.countrylanguage
group by IsOfficial
;

select *
from store
;

select * 
from employee_demographics
order by gender, age
;

select *
from employee_demographics
order by age desc
limit 3
;

select gender, AVG(age) As Avg_age
from employee_demographics
group by gender
;


--- Or you can simply use 
select gender, Avg(age) AVG_AGE
from employee_demographics
group by gender 
;


-- joining two tables 

select *
from employee_demographics
join employee_salary
	on employee_demographics.employee_id = employee_salary.employee_id
    ;
    
select *
from employee_demographics
 inner join employee_salary
	on employee_demographics.employee_id = employee_salary.employee_id
    ;


-- usimg alias 
select *
from employee_demographics As dem
join employee_salary As sal
	on dem.employee_id = sal.employee_id
    ;
    
select dem.employee_id, dem.first_name, dem.last_name, dem.gender, sal.occupation, sal.salary
from employee_demographics as dem
join employee_salary as sal
	on dem.employee_id = sal.employee_id
    ;
    
    
-- right joins, joints every cell and the missing as nulls 

select *
from employee_demographics as dem
right join employee_salary as sal
	on dem.employee_id = sal.employee_id
    ;

-- asgning employee id 1 to the next employee id 
select * 
from employee_demographics as dem1
join employee_demographics as dem2
	on dem1.employee_id + 1 = dem2.employee_id
    ;


-- joining multiple together
 select *
from employee_demographics As dem
join employee_salary As sal
	on dem.employee_id = sal.employee_id
    ;
    

select *
from parks_departments
;

-- so joining the refrence table to the two table
select *
from employee_demographics as dem
join employee_salary as sal 
	on dem.employee_id = sal.employee_id
join parks_departments as pd
	on sal.dept_id = pad.department_id
    ;
    
  select *
  from employee_demographics
  where gender = 'Male'
  order by Age desc
  limit 3
  ;


-- unions in my sql 

