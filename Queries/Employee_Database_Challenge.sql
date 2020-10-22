--
--
-- DELIVERABLE 1
--
-- join employee and titles table to get list of "retiring" 
--employees (birthdate 1952-1955) and their titles
SELECT e.emp_no, 
        e.first_name,
        e.last_name,
        ti.title,
        ti.from_date,
        ti.to_date
INTO retirement_titles
FROM employees as e
INNER JOIN titles as ti
ON e.emp_no = ti.emp_no
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY emp_no
;

-- get rid of duplicates from the retirement_titles table
SELECT DISTINCT ON (emp_no) emp_no, first_name, last_name, title
INTO unique_titles
FROM retirement_titles
ORDER BY emp_no, from_date DESC
;

-- group the count of retiring employees by title
SELECT COUNT(title) count, title
INTO retiring_titles
FROM unique_titles
GROUP BY (title) 
ORDER BY count DESC
;
-- 
--
-- DELIVERABLE 2
--
--
--create a Mentorship Eligibility table for current employees who 
-- were born between January 1, 1965 and December 31, 1965
SELECT DISTINCT ON (emp_no)
        e.emp_no, 
        e.first_name,
        e.last_name,
        e.birth_date,
        de.from_date,
        de.to_date,
        ti.title
INTO mentorship_eligibility
FROM employees as e
INNER JOIN dept_emp as de
ON e.emp_no = de.emp_no
INNER JOIN titles as ti
ON e.emp_no = ti.emp_no
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31') AND de.to_date = '9999-01-01'
ORDER BY emp_no, ti.from_date DESC
;
--
--
-- ADDITIONAL QUERIES
--
--
--
-- get the number of eligible mentors grouped by title
SELECT COUNT(title) count, title
INTO mentor_count_title
FROM mentorship_eligibility
GROUP BY (title) 
ORDER BY count DESC

-- Get list of current employees eligible for retirement 
SELECT DISTINCT ON (emp_no)
        ce.emp_no, 
        ce.first_name,
        ce.last_name,
        ti.title,
        ti.from_date,
        ti.to_date
INTO current_retirement_titles
FROM current_emp as ce
INNER JOIN titles as ti
ON ce.emp_no = ti.emp_no
ORDER BY emp_no, from_date DESC
;

-- get a table of the title count for current employees
SELECT COUNT(title) count, title
INTO current_count_title
FROM current_retirement_titles
GROUP BY (title) 
ORDER BY count DESC;