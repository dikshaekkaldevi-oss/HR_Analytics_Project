create database hr_analytics;

use hr_analytics

select * from hr;

-- Q1. What is the total monthly income by gender?
select Gender,
        sum(MonthlyIncome) AS total_income
from hr
group by Gender;


-- Q2. What is the attrition count by department?
select Department,
       count(*) AS attrition_count
from hr
where Attrition='Yes'
group by Department;

-- Q3. What is the average monthly income by job role?
select JobRole,
       round(avg(MonthlyIncome),2) AS avg_income
from hr
group by JobRole
order by avg_income desc;

-- Q4. Which education fields have the highest attrition rate?
select EducationField,
       count(*) AS attrition_count
from hr
where Attrition='Yes'
group by EducationField
order by attrition_count desc;

-- Q5. Which job roles have the highest job satisfaction on average?
select jobRole,
       round(avg(JobSatisfaction),2) AS avg_satisfaction
from hr
group by JobRole
order by avg_satisfaction asc;

-- Q6. Which employees have worked more than 10 years and still have high performance rating?
select EmpId,Age,JobRole,TotalWorkingYears,PerformanceRating
from hr
where TotalWorkingYears>10
and PerformanceRating=4;

-- Q7. Rank employees within each department by Monthly Income
select EmpId,Department,MonthlyIncome,
	rank() over(partition by Department order by MonthlyIncome desc ) AS income_rank
from hr;

-- Q8. Top 3 highest paid employees in each department
with ranked_emp As (
     select EmpId,Department,MonthlyIncome,
     rank() over  (partition by Department order by MonthlyIncome desc) AS rnk
     from hr
     )
select * 
from ranked_emp
where rnk<=3;

-- Q9. Employees who are high performers but low salary
select EmpId,JobRole,MonthlyIncome,PerformanceRating
from hr
where PerformanceRating=4
and MonthlyIncome<(select avg(MonthlyIncome) from hr);

-- Q10. Years at company vs attrition trend
select YearsAtCompany,
       count(*) AS total_employees,
       sum(case when Attrition='Yes' then 1 else 0 end ) AS attrition_count
from hr
group by YearsAtCompany
order by YearsAtCompany;

-- Q11. Gender-wise promotion potential (based on Job Level)
select Gender,
       round(avg(JobLevel),2) AS avg_job_level
from hr
group by Gender;

-- Q12. Overtime impact on income
select OverTime,
       round(avg(MonthlyIncome),2) AS avg_income
from hr
group by OverTime;
