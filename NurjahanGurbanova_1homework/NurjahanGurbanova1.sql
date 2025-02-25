Part 1: Basic Queries
1. Retrieve the first name, last name, and hire date of employees hired after January 1, 2000.

SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date > '2000-01-01';

2. List the department names from the departments table where the department name starts with the letter ‘S’.

SELECT dept_name
FROM departments
WHERE dept_name LIKE 'S%';

3. Find all employees whose salary is greater than 80,000. Include their emp_no, salary, and from_date in the result.

SELECT emp_no, salary, from_date
FROM salaries
WHERE salary > 80000;

4. . Retrieve the titles and the count of employees for each title in the titles table. Sort the results by the count of employees in descending order.

SELECT title, COUNT(emp_no) AS employee_count
FROM titles
GROUP BY title
ORDER BY employee_count DESC;

5. List the department numbers and average salary of employees for each department. Sort the results by department number. 

SELECT d.dept_no, AVG(s.salary) AS average_salary
FROM dept_emp AS d
JOIN salaries AS s ON d.emp_no = s.emp_no
GROUP BY d.dept_no
ORDER BY d.dept_no;

Part 2: Joins and Set Operations
6. Retrieve the first name, last name, and department name of all employees working in the “Sales” department. (Use a join between employees, dept_emp, and departments.) 

SELECT 
    e.first_name, 
    e.last_name, 
    d.dept_name 
FROM 
    employees AS e
JOIN 
    dept_emp AS de 
    ON e.emp_no = de.emp_no
JOIN 
    departments AS d 
    ON de.dept_no = d.dept_no
WHERE 
    d.dept_name = 'Sales';

7. List the first name, last name, and manager’s first name for all employees who report to managers. (Use a join between employees and dept_manager.) 

SELECT 
    e.first_name AS employee_first_name, 
    e.last_name AS employee_last_name, 
    m.first_name AS manager_first_name
FROM 
    dept_emp AS de
JOIN 
    employees AS e 
    ON de.emp_no = e.emp_no
JOIN 
    dept_manager AS dm 
    ON de.dept_no = dm.dept_no
JOIN 
    employees AS m 
    ON dm.emp_no = m.emp_no
LIMIT 0, 50000;

8. Find the employee number and salary of employees whose salary is greater than the average salary of all employees.

SELECT emp_no, salary
FROM salaries
WHERE salary > (SELECT AVG(salary) FROM salaries);

9. Retrieve the employee numbers of employees who work in the “Sales” or “Marketing” departments. (Use UNION to combine results.) 

SELECT de.emp_no
FROM dept_emp AS de
JOIN departments AS d ON de.dept_no = d.dept_no
WHERE d.dept_name = 'Sales'
UNION
SELECT de.emp_no
FROM dept_emp AS de
JOIN departments AS d ON de.dept_no = d.dept_no
WHERE d.dept_name = 'Marketing';

10. List the first name and last name of employees who have never worked in any department. 

SELECT e.first_name, e.last_name
FROM employees AS e
LEFT JOIN dept_emp AS de ON e.emp_no = de.emp_no
WHERE de.emp_no IS NULL;

Part 3: Nested Queries
11. Retrieve the employee number, salary, and department name of
employees who earn more than the average salary of their department.

WITH DeptAvgSalaries AS (
    SELECT 
        de.dept_no, 
        AVG(s.salary) AS avg_salary
    FROM 
        salaries AS s
    JOIN 
        dept_emp AS de 
        ON s.emp_no = de.emp_no
    GROUP BY 
        de.dept_no
)
SELECT 
    e.emp_no, 
    s.salary, 
    d.dept_name
FROM 
    employees AS e
JOIN 
    salaries AS s 
    ON e.emp_no = s.emp_no
JOIN 
    dept_emp AS de 
    ON e.emp_no = de.emp_no
JOIN 
    departments AS d 
    ON de.dept_no = d.dept_no
JOIN 
    DeptAvgSalaries AS das 
    ON de.dept_no = das.dept_no
WHERE 
    s.salary > das.avg_salary;

12. Find the first name and last name of employees who hold the title of
“Manager” and earn the highest salary in their department.

SELECT 
    e.first_name, 
    e.last_name
FROM 
    employees AS e
JOIN 
    titles AS t 
    ON e.emp_no = t.emp_no
JOIN 
    salaries AS s 
    ON e.emp_no = s.emp_no
JOIN 
    dept_emp AS de 
    ON e.emp_no = de.emp_no
WHERE 
    t.title = 'Manager'
    AND s.salary = (
        SELECT MAX(s.salary)
        FROM salaries AS s
        JOIN dept_emp AS de
        ON s.emp_no = de.emp_no
        WHERE de.dept_no = de.dept_no
    );

13. List the department names where the average salary of employees
exceeds 70,000.

SELECT 
    d.dept_name
FROM 
    departments AS d
JOIN 
    dept_emp AS de 
    ON d.dept_no = de.dept_no
JOIN 
    salaries AS s 
    ON de.emp_no = s.emp_no
GROUP BY 
    d.dept_no
HAVING 
    AVG(s.salary) > 70000;

14. Retrieve the employee number and title of employees whose salary is
greater than the maximum salary in department “d005”.

SELECT 
    e.emp_no, 
    t.title
FROM 
    employees AS e
JOIN 
    titles AS t 
    ON e.emp_no = t.emp_no
JOIN 
    salaries AS s 
    ON e.emp_no = s.emp_no
WHERE 
    s.salary > (
        SELECT MAX(s.salary)
        FROM salaries AS s
        JOIN dept_emp AS de 
        ON s.emp_no = de.emp_no
        WHERE de.dept_no = 'd005'
    );

15. Find the employee numbers of employees who have worked in more than one department.

SELECT 
    emp_no
FROM 
    dept_emp
GROUP BY 
    emp_no
HAVING 
    COUNT(DISTINCT dept_no) > 1;

Part 4: Views and Aggregations
16. Create a view named high_salary_employees that lists the emp_no,
first_name, last_name, and salary of employees earning more than 100,000.

CREATE VIEW high_salary_employees AS
SELECT 
    e.emp_no, 
    e.first_name, 
    e.last_name, 
    s.salary
FROM 
    employees AS e
JOIN 
    salaries AS s 
    ON e.emp_no = s.emp_no
WHERE 
    s.salary > 100000;

17. Use the high_salary_employees view to retrieve all employees working in
the “Development” department.
SELECT 
    hse.emp_no, 
    hse.first_name, 
    hse.last_name, 
    hse.salary
FROM 
    high_salary_employees AS hse
JOIN 
    dept_emp AS de 
    ON hse.emp_no = de.emp_no
JOIN 
    departments AS d 
    ON de.dept_no = d.dept_no
WHERE 
    d.dept_name = 'Development';

18. Create a view named dept_avg_salary that shows the department number,
department name, and average salary for each department.
CREATE VIEW dept_avg_salary AS
SELECT 
    d.dept_no, 
    d.dept_name, 
    AVG(s.salary) AS avg_salary
FROM 
    departments AS d
JOIN 
    dept_emp AS de 
    ON d.dept_no = de.dept_no
JOIN 
    salaries AS s 
    ON de.emp_no = s.emp_no
GROUP BY 
    d.dept_no, d.dept_name;

19. Retrieve departments where the average salary (from the dept_avg_salary
SELECT 
    dept_no, 
    dept_name, 
    avg_salary
FROM 
    dept_avg_salary
WHERE 
    avg_salary > 90000;

20. Find the top 5 highest-paid employees, including their first name, last
name, and salary.
SELECT 
    e.first_name, 
    e.last_name, 
    s.salary
FROM 
    employees AS e
JOIN 
    salaries AS s 
    ON e.emp_no = s.emp_no
ORDER BY 
    s.salary DESC
LIMIT 5;
