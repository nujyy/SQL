Part 1: Advanced Joins (1-5)
1.Retrieve the first name, last name, and department name of employees who started working after their department manager’s hire date.
-- Question 1: Employees who started working after their department manager's hire date
SELECT 
    e.first_name, 
    e.last_name, 
    d.dept_name
FROM 
    employees e
JOIN 
    dept_emp de ON e.emp_no = de.emp_no
JOIN 
    departments d ON de.dept_no = d.dept_no
JOIN 
    dept_manager dm ON d.dept_no = dm.dept_no
WHERE 
    de.from_date > dm.from_date;

2.List the department names and the total number of employees in each department who have the title of “Senior Engineer”.
-- Question 2: Department names and the total number of employees with title 'Senior Engineer'
SELECT 
    d.dept_name,
    COUNT(*) AS total_senior_engineers
FROM 
    departments d
JOIN 
    dept_emp de ON d.dept_no = de.dept_no
JOIN 
    titles t ON de.emp_no = t.emp_no
WHERE 
    t.title = 'Senior Engineer'
GROUP BY 
    d.dept_name;

3.Find the first name, last name, and salary of employees who have worked in multiple departments.
-- Question 3: Employees who have worked in multiple departments
SELECT 
    e.first_name, 
    e.last_name, 
    MAX(s.salary) AS salary
FROM 
    employees e
JOIN 
    dept_emp de ON e.emp_no = de.emp_no
JOIN 
    salaries s ON e.emp_no = s.emp_no
GROUP BY 
    e.emp_no
HAVING 
    COUNT(DISTINCT de.dept_no) > 1;

4.Retrieve the employee numbers of employees who currently do not have any active title assignments.
-- Question 4: Employees without any active title assignments
SELECT 
    e.emp_no
FROM 
    employees e
LEFT JOIN 
    titles t ON e.emp_no = t.emp_no
WHERE 
    t.to_date < CURRENT_DATE OR t.to_date IS NULL;

5.List all departments and the number of employees in each department who earn more than 100,000.
-- Question 5: Departments and number of employees earning more than 100,000
SELECT 
    d.dept_name,
    COUNT(*) AS employees_earning_100k_plus
FROM 
    departments d
JOIN 
    dept_emp de ON d.dept_no = de.dept_no
JOIN 
    salaries s ON de.emp_no = s.emp_no
WHERE 
    s.salary > 100000
GROUP BY 
    d.dept_name;

Part 2: Nested Queries (6-10)
6.Find the first name and last name of employees who earn more than the highest salary in
department “d003”.
-- Question 6: Employees who earn more than the highest salary in department "d003"
SELECT 
    e.first_name, 
    e.last_name
FROM 
    employees e
JOIN 
    salaries s ON e.emp_no = s.emp_no
WHERE 
    s.salary > (
        SELECT 
            MAX(salary)
        FROM 
            salaries s
        JOIN 
            dept_emp de ON s.emp_no = de.emp_no
        WHERE 
            de.dept_no = 'd003'
    );

7.Retrieve the employee numbers of employees whose salaries are greater than the average
salary of all employees in the same department.
-- Employees with salaries greater than the average salary of their department (Using JOIN)
SELECT 
    s.emp_no
FROM 
    salaries s
JOIN 
    dept_emp de ON s.emp_no = de.emp_no
JOIN 
    (
        SELECT 
            de_inner.dept_no,
            AVG(s_inner.salary) AS avg_salary
        FROM 
            salaries s_inner
        JOIN 
            dept_emp de_inner ON s_inner.emp_no = de_inner.emp_no
        GROUP BY 
            de_inner.dept_no
    ) avg_dept ON de.dept_no = avg_dept.dept_no
WHERE 
    s.salary > avg_dept.avg_salary;

8.Find the departments where at least one employee earns more than 80,000 and works as a
“Staff”.
-- Question 8: Departments where at least one employee earns more than 80,000 and works as "Staff"
SELECT 
    DISTINCT d.dept_name
FROM 
    departments d
JOIN 
    dept_emp de ON d.dept_no = de.dept_no
JOIN 
    salaries s ON de.emp_no = s.emp_no
JOIN 
    titles t ON de.emp_no = t.emp_no
WHERE 
    s.salary > 80000 AND t.title = 'Staff';

9.Retrieve the employee numbers of employees who have never earned more than 50,000 during their entire career.
-- Question 9: Employees who have never earned more than 50,000
SELECT 
    s.emp_no
FROM 
    salaries s
GROUP BY 
    s.emp_no
HAVING 
    MAX(s.salary) <= 50000;

10.Find the department names where all employees earn less than 90,000.
SELECT 
    d.dept_name
FROM 
    departments d
JOIN 
    dept_emp de ON d.dept_no = de.dept_no
JOIN 
    salaries s ON de.emp_no = s.emp_no
GROUP BY 
    d.dept_no, d.dept_name
HAVING 
    MAX(s.salary) < 90000;

Part 3: Aggregations (11-15)
11.Find the average salary of employees for each title.
-- Question 11: Average salary for each title
SELECT 
    t.title, 
    AVG(s.salary) AS average_salary
FROM 
    titles t
JOIN 
    salaries s ON t.emp_no = s.emp_no
GROUP BY 
    t.title;

12.List the top 3 departments with the highest average salaries across all employees.
-- Question 12: Top 3 departments with the highest average salaries
SELECT 
    d.dept_name, 
    AVG(s.salary) AS average_salary
FROM 
    departments d
JOIN 
    dept_emp de ON d.dept_no = de.dept_no
JOIN 
    salaries s ON de.emp_no = s.emp_no
GROUP BY 
    d.dept_name
ORDER BY 
    average_salary DESC
LIMIT 3;

13.Retrieve the employee numbers and the total number of titles they have held over their career.
-- Question 13: Employee numbers and total number of titles held
SELECT 
    t.emp_no, 
    COUNT(DISTINCT t.title) AS total_titles
FROM 
    titles t
GROUP BY 
    t.emp_no;

14.Find the department name and the total compensation of employees for each department.
-- Question 14: Department names and total compensation for each department
SELECT 
    d.dept_name, 
    SUM(s.salary) AS total_compensation
FROM 
    departments d
JOIN 
    dept_emp de ON d.dept_no = de.dept_no
JOIN 
    salaries s ON de.emp_no = s.emp_no
GROUP BY 
    d.dept_name;

15.Retrieve the first name, last name, and maximum salary of employees who have been “Managers”
SELECT 
    e.first_name, 
    e.last_name, 
    MAX(s.salary) AS max_salary
FROM 
    employees e
JOIN 
    dept_manager dm ON e.emp_no = dm.emp_no
JOIN 
    salaries s ON e.emp_no = s.emp_no
GROUP BY 
    e.emp_no, e.first_name, e.last_name;
    
Part 4: Set Operations (16-20)
16.Retrieve the names of employees who have worked in both “Development” and “Sales”
departments.
-- Question 16: Employees who worked in both "Development" and "Sales"
SELECT 
    e.first_name, 
    e.last_name
FROM 
    employees e
JOIN 
    dept_emp de1 ON e.emp_no = de1.emp_no
JOIN 
    departments d1 ON de1.dept_no = d1.dept_no
JOIN 
    dept_emp de2 ON e.emp_no = de2.emp_no
JOIN 
    departments d2 ON de2.dept_no = d2.dept_no
WHERE 
    d1.dept_name = 'Development'
    AND d2.dept_name = 'Sales';

17.List the employee numbers of employees who have had the title “Assistant Engineer” but
have never worked in the “Production” department.
-- Question 17: Employees with title "Assistant Engineer" but never worked in "Production"
SELECT 
    t.emp_no
FROM 
    titles t
WHERE 
    t.title = 'Assistant Engineer'
    AND t.emp_no NOT IN (
        SELECT 
            de.emp_no
        FROM 
            dept_emp de
        JOIN 
            departments d ON de.dept_no = d.dept_no
        WHERE 
            d.dept_name = 'Production'
    );

18.Retrieve the department names where no employees currently hold the title “Technician”.
-- Question 18: Departments where no employees currently hold the title "Technician"
SELECT 
    d.dept_name
FROM 
    departments d
LEFT JOIN 
    dept_emp de ON d.dept_no = de.dept_no
LEFT JOIN 
    titles t ON de.emp_no = t.emp_no
WHERE 
    t.title != 'Technician' OR t.title IS NULL
GROUP BY 
    d.dept_name;

19.Find the names of employees who have worked as both “Senior Engineer” and “Senior Staff”.
-- Question 19: Employees who have worked as both "Senior Engineer" and "Senior Staff"
SELECT 
    e.first_name, 
    e.last_name
FROM 
    employees e
JOIN 
    titles t1 ON e.emp_no = t1.emp_no
JOIN 
    titles t2 ON e.emp_no = t2.emp_no
WHERE 
    t1.title = 'Senior Engineer'
    AND t2.title = 'Senior Staff';

20.List all departments and indicate whether each has at least one employee earning more than 150,000 (“Yes” or “No”).
-- Question 20: Departments and indication if any employee earns more than 150,000
SELECT 
    d.dept_name,
    CASE 
        WHEN MAX(s.salary) > 150000 THEN 'Yes'
        ELSE 'No'
    END AS has_high_earner
FROM 
    departments d
JOIN 
    dept_emp de ON d.dept_no = de.dept_no
JOIN 
    salaries s ON de.emp_no = s.emp_no
GROUP BY 
    d.dept_name;
