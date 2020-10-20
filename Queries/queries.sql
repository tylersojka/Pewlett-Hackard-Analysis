--select employees born between 1952-1955
SELECT first_name, last_name
from employees
where birth_date BETWEEN '1952-01-01' and '1955-12-31';

--select employees born in 1952
SELECT first_name, last_name
from employees
where birth_date BETWEEN '1952-01-01' and '1952-12-31';

--select employees born in 1953
SELECT first_name, last_name
from employees
where birth_date BETWEEN '1953-01-01' and '1953-12-31';

--select employees born in 1954
SELECT first_name, last_name
from employees
where birth_date BETWEEN '1954-01-01' and '1954-12-31';

--select employees born in 1955
SELECT first_name, last_name
from employees
where birth_date BETWEEN '1955-01-01' and '1955-12-31';

--retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--Count the number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--creating/exporting table
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--view new table retirement_info
SELECT * FROM retirement_info

--drop retirement_info table bc it doesnt have emp_no to join to other tables
DROP TABLE retirement_info;
--
--
--
-- JOINS
--
--
--
--recreate retirement_info table with emp_no so it can join to dept_emp table on emp_no
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Check the new retirement_info table
SELECT * FROM retirement_info;

-- Joining departments and dept_manager tables
SELECT departments.dept_name,
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
     retirement_info.first_name,
     retirement_info.last_name,
     dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;

-- Joining retirement_info and dept_emp tables using aliases
SELECT ri.emp_no,
    ri.first_name,
    ri.last_name,
    de.to_date
FROM retirement_info as ri
LEFT JOIN dept_emp as de
on ri.emp_no = de.emp_no;

-- Joining departments and dept_manager tables using aliases
SELECT d.dept_name,
    dm.emp_no,
    dm.from_date,
    dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
on d.dept_no = dm.dept_no;

--Joining retirement_info and dept_emp tables using aliases, WHERE emp still employed INTO new table, CURRENT_EMP
SELECT ri.emp_no,
    ri.first_name,
    ri.last_name,
    de.to_date
    INTO current_emp
    FROM retirement_info as ri
    LEFT JOIN dept_emp as de
    ON ri.emp_no = de.emp_no
    WHERE de.to_date = ('9999-01-01');
-- COULDNT WE HAVE JUST JOINED EMP WITH DEPT EMP AND ADDED WHERE TODATE='9999-01-01' 
-- AND HIRE DATE BETWEEN """"? TO CREATE THE TABLE IN ONE GO?
--
--
--
-- COUNT, GROUP BY, and ORDER BY
--
--
--
-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no;

-- Employee count by department number and ordered
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

-- Employee count by department number to a NEW TABLE
SELECT COUNT(ce.emp_no), de.dept_no
INTO retiring_by_dept
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no;

--show new retirement_by_dept table
select * from retiring_by_dept
--
--
--
-- MORE LISTS
--
--
--
--Retiring Employee Information: A list of employees containing their unique 
-- employee number, their last name, first name, gender, and salary

---  check to see if salary dates are useful, they arent bc its all jumbled
SELECT * FROM salaries;

--- order the dates in salary, they arent useful bc none of them are recent
SELECT * FROM salaries
ORDER BY to_date DESC;

-- Create a new table to hold what was in retirement info (emps who were born 
-- between 1952-1955 and hired between 1985-1988), PLUS gender
SELECT emp_no, first_name, last_name, gender
INTO emp_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--join the 3 tables holding all the info we need
SELECT e.emp_no,
    e.first_name,
    e.last_name,
    e.gender,
    s.salary,
    de.to_date
INTO emp_info       -- create a new table to hold the data
FROM employees as e
INNER JOIN salaries as s    --first join employees to salary on emp_no
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de    --second join employees to dept_emp on emp_no
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
    AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
    AND (de.to_date = '9999-01-01');

-- show new table  emp_info
SELECT * 
FROM emp_info;

--Management: A list of managers for each department, including the 
-- department number, name, and the manager's employee number, last name, 
-- first name, and the starting and ending employment dates
-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);

SELECT * 
FROM manager_info;

--Department Retirees: An updated current_emp list that includes everything 
--it currently has, but also the employee's departments

SELECT  ce.emp_no,
        ce.first_name,
        ce.last_name,
        d.dept_name
INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);

SELECT * 
FROM dept_info;
--
--
--
-- 7.3.6 queries
--
--
--
-- get all the sales department people who will be retiring
select * 
from dept_info
where dept_name = 'Sales';

-- get all the sales and development department people who will be retiring
SELECT * 
FROM dept_info
WHERE dept_name IN ('Sales', 'Development')
ORDER BY dept_name;