# HR Workforce Distribution & Salary Structure Analysis

# Project Overview
Analyzed Swift HR Office's data across 25 countries and 23 cities to evaluate workforce distribution, hiring patterns, and salary cost structures.

The project delivers insights to support strategic workforce planning, cost optimization, and organizational efficiency.

# Business Problem
Leadership lacked visibility into:

- Workforce concentration across regions and departments
- Salary cost drivers
- Organizational inefficiencies (e.g., unmanaged departments, uneven staffing)

# Data Overview
- 107 employees, 27 departments, 19 job roles
- Coverage across 23 cities / 25 countries / 4 regions
- Key data points: employee records, salaries, departments, locations, and job roles

# Tools & Technologies
- MySQL
- SQL (joins, aggregations, filtering, CASE logic)

# SQL Highlights
1. Region with Highest Salary Cost

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

2. Department Workforce Distribution

select
	D.department_id,
    department_name,
    count(employee_id) as num_of_employees
from departments as D
	inner join employees using(department_id)
group by 1,2
order by 3 desc;

3. Percentage of Employees on Commission

select
    round((sum(case when commission_pct is not null then 1 else 0 end) / COUNT(*)) * 100, 2) as commission_percentage
from employees;

# Key Insights
- Workforce concentration is uneven:
  - Shipping (45 employees) and Sales dominate staffing
  - Some departments have minimal or no staffing
- Operational activity is regionally concentrated:
  - Americas leads with 24 departments and highest salary cost (~363,400)
- Organizational structure gaps exist:
  - 16 departments lack managers → governance and oversight risk
  - At least one employee is not assigned to any department
- Location-level concentration is high:
  - Seattle hosts 21 departments, indicating operational centralization
- Sales operations are geographically skewed:
  - Oxford alone hosts 34 sales employees, suggesting dependency on specific locations
- Compensation structure insights:
  - 35 employees earn commission, indicating a strong performance-based component
 
# Recommendations
- Address organizational gaps:
  - Assign managers to all departments
  - Ensure all employees are mapped to functional units
- Rebalance workforce distribution:
  - Reduce over-reliance on specific departments (e.g., Shipping, Sales)
  - Strengthen under-resourced departments
- Optimize regional cost structure:
  - Review high-cost regions (e.g., Americas) for efficiency opportunities
- Decentralize operations where necessary:
  - Reduce concentration in single locations (e.g., Seattle, Oxford)
- Review incentive structures:
  - Evaluate effectiveness of commission-based roles on performance outcomes
 
# Outcome

Provided a clear view of workforce distribution, structural gaps, and cost concentration, enabling leadership to make data-driven HR and operational decisions.

# Next Steps
- Build workforce dashboards (Power BI/Tableau)
- Conduct employee productivity analysis
- Introduce workforce forecasting and capacity planning
