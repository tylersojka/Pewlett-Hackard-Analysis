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