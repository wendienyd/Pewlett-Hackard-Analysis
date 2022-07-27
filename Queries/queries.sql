-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);

--Creating another table
CREATE TABLE employees (
	emp_no INT NOT NULL,
	birth_date DATE NOT NULL,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	gender VARCHAR NOT NULL,
	hire_date DATE NOT NULL,
	PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager (
dept_no VARCHAR(4) NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);

CREATE TABLE dept_employee (
	emp_no INT NOT NULL,
	dept_no VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no, from_date)
);
DROP TABLE dept_employee CASCADE;

CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no, title, from_date)
);
DROP TABLE titles CASCADE;

SELECT * FROM departments;
SELECT * FROM departments;
SELECT * FROM employees;
SELECT * FROM salaries;
SELECT * FROM dept_manager;
SELECT * FROM dept_employee;
SELECT * FROM titles;

SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31'

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31'

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31'

-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

DROP TABLE retirement_info;

SELECT * FROM retirement_info;

SELECT first_name, last_name, title
FROM employees as e
LEFT JOIN titles as t ON e.emp

-- Joining departments and dept_manager tables
SELECT dpt.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as dpt
INNER JOIN dept_manager as dm
ON dpt.dept_no = dm.dept_no;

-- Joining retirement_info and dept_emp tables
-- Add if employees have already left the company
SELECT retirement_info.emp_no,
    retirement_info.first_name,
	retirement_info.last_name,
    dept_employee.to_date
FROM retirement_info
LEFT JOIN dept_employee
ON retirement_info.emp_no = dept_employee.emp_no;

-- Using Aliases for less clutter
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date
FROM retirement_info as ri
LEFT JOIN dept_employee as de
ON ri.emp_no = de.emp_no;

-- Join ri and de tables
SELECT ri.emp_no,
    ri.first_name,
    ri.last_name,
	de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_employee as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

SELECT * FROM current_emp;

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
INTO department_counts
FROM current_emp as ce
LEFT JOIN dept_employee as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

SELECT * FROM department_counts;

SELECT * FROM salaries
ORDER BY to_date DESC;

--Use this code to repurpose for the next
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Filtering and updating the employee table (emp_information)
SELECT emp_no,
    first_name,
	last_name,
    gender
INTO emp_information
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
DROP TABLE emp_info;

-- List 1 Employee Infomation
SELECT e.emp_no,
    e.first_name,
	e.last_name,
    e.gender,
    s.salary,
    de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_employee as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');

SELECT * FROM emp_info;

-- List 2 Management
SELECT  dm.dept_no,
        dpt.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
INNER JOIN departments AS dpt
ON (dm.dept_no = d.dept_no)
INNER JOIN current_emp AS ce
ON (dm.emp_no = ce.emp_no);

-- List 3 Department Retirees
SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	dpt.dept_name
INTO dept_info
FROM current_emp AS ce
INNER JOIN dept_employee AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS dpt
ON (de.dept_no = dpt.dept_no);

SELECT * FROM retirement_info;
SELECT * FROM departments;

SELECT dm.emp_no,
	ri.first_name,
	ri.last_name,
	dpt.dept_name
INTO sales_retiree
FROM retirement_info AS ri
INNER JOIN dept_employee AS dm
ON (ri.emp_no = dm.emp_no)
INNER JOIN departments AS dpt
ON (dm.dept_no = dpt.dept_no)
WHERE dpt.dept_name = 'Sales';

SELECT dm.emp_no,
	ri.first_name,
	ri.last_name,
	dpt.dept_name
INTO mentoring_program
FROM retirement_info AS ri
INNER JOIN dept_employee AS dm
ON (ri.emp_no = dm.emp_no)
INNER JOIN departments AS dpt
ON (dm.dept_no = dpt.dept_no)
WHERE dept_name IN ('Sales', 'Development');
