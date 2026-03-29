/*
Project: HR Workforce Distribution & Salary Structure Analysis

Business Context:
Swift HR Office manages employee, departmental, and regional data across multiple
locations and operational units. Leadership requires insight into workforce
distribution, operational concentration, hiring activity, and cost drivers
to support strategic HR and organizational decisions.

Key Objectives:
- Analyse workforce distribution across regions, departments, and locations
- Identify operational and cost concentration areas
- Highlight organisational gaps impacting HR efficiency

This analysis supports data-driven workforce planning and operational efficiency.
*/

/* =====================================================================
SECTION 01 — DATA FAMILIARIZATION & STRUCTURE VALIDATION
Objective: Understand schema relationships and validate core HR tables
===================================================================== */

-- [1] Inspecting core HR and organizational tables

select * from countries
limit 10;

select * from departments
limit 10;

select * from employees
limit 10;

select * from job_history
limit 10;

select * from jobs
limit 10;

select * from locations
limit 10;

select * from regions
limit 10;

/* =============================================================================
SECTION 02 — OPERATIONAL FOOTPRINT ANALYSIS
Objective: Identify geographic and departmental concentration of operations
============================================================================= */

-- [2] Region with the Most Operational Units
select
	R.region_id,
    region_name,
    count(department_id) as num_of_departments
from regions as R
	inner join countries using(region_id)
		inner join locations using(country_id)
			inner join departments using(location_id)
group by 1,2
order by 3 desc
limit 1;   

-- [3] Departments with the Highest Number of Employees
select
	D.department_id,
    department_name,
    count(employee_id) as num_of_employees
from departments as D
	inner join employees using(department_id)
group by 1,2
order by 3 desc;

-- [4] Location Hosting the Highest Number of Departments
select
	L.location_id,
    L.city,
    count(department_id) as num_of_departments
from locations L
	join departments using(location_id)
group by 1
order by 3 desc
limit 1;

/* =================================================================
SECTION 03 — WORKFORCE DISTRIBUTION & HIRING ACTIVITY
Objective: Evaluate workforce composition and recent hiring trends
================================================================= */

-- [5] Most Recently Hired Employee(s)
select
	concat(first_name, ' ', last_name) full_name,
    hire_date
from employees
where hire_date = (select max(hire_date) from employees);

/* =================================================================
SECTION 04 — COMPENSATION & OPERATIONAL COST ANALYSIS
Objective: Identify salary concentration and compensation patterns
================================================================= */

-- [6] Region with Highest Total Salary Cost
select
	R.region_id,
    region_name,
    sum(E.salary) as operational_cost
from regions R
	join countries using(region_id)
		join locations using(country_id)
			join departments using(location_id)
				join employees E using(department_id)
group by 1,2
order by 3 desc
limit 1;

-- [7] Employees Receiving Commission
select
	count(employee_id) as num_of_employees_on_commission
from employees
where commission_pct is not null;

-- [8] Department with Highest Average Salary
select
	D.department_id,
    D.department_name,
    avg(salary) as average_salary
from departments D
	join employees using(department_id)
where department_id is not null
group by 1,2
order by 3 desc
limit 1;

/* ================================================================
SECTION 05 — ORGANIZATIONAL GAPS & STRUCTURAL RISKS
Objective: Identify structural inefficiencies and governance gaps
================================================================ */

-- [9] Departments Without Assigned Managers
select
	department_id,
    department_name
from departments
where manager_id is null;

-- [10] Employees Not Assigned to Any Department
select
	concat(first_name, (' '), last_name) full_name
from employees
where department_id is null;

/* ==========================================================
SECTION 06 — FUNCTIONAL & DEPARTMENT-SPECIFIC ANALYSIS
Objective: Analyze department-level workforce concentration
========================================================== */

-- [11] City with the Highest Number of Sales Employees
select
	L.city,
    count(employee_id) as num_of_employees
from employees
	join departments using(department_id)
		join locations L using(location_id)
where department_name = 'Sales'
group by 1
order by 2 desc;

/* ================================================================
SECTION 07 — EXECUTIVE SUMMARY OUTPUT (BOARD-READY METRICS)
Objective: Provide concise HR KPIs for leadership decision-making
================================================================ */

-- [12] Total Workforce Size
select
	count(*) as total_employees
from employees;

-- [13] Region with Highest Salary Cost
select
    region_name,
    sum(E.salary) as total_salary_cost
from regions R
	join countries using(region_id)
		join locations using(country_id)
			join departments using(location_id)
				join employees E using(department_id)
group by 1
order by 2 desc
limit 1;

-- [14] Department with Largest Workforce
select
    department_name,
    count(employee_id) as employee_count
from departments
join employees using(department_id)
group by 1
order by 2 desc
limit 1;

-- [15] Percentage of Employees on Commission
select
    round((sum(case when commission_pct is not null then 1 else 0 end) / COUNT(*)) * 100, 2) as commission_percentage
from employees;

-- [16] Number of departments Without Managers
select
	count(*) as departments_without_managers
from departments
where manager_id is null;