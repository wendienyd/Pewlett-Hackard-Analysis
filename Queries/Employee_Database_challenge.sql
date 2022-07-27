SELECT * FROM employees;
SELECT * FROM titles;

SELECT emp.emp_no,
	emp.first_name,
	emp.last_name,
	tl.title,
	tl.from_date,
	tl.to_date
INTO retirement_titles
FROM employees AS emp
INNER JOIN titles AS tl
ON (emp.emp_no = tl.emp_no)
WHERE (emp.birth_date BETWEEN ('1951-01-01') AND ('1955-12-31'))
ORDER BY emp.emp_no;

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (rt.emp_no) rt.emp_no,
	rt.first_name,
	rt.last_name,
	rt.title
INTO unique_titles
FROM retirement_titles AS rt
WHERE to_date = '9999-01-01'
ORDER BY rt.emp_no, rt.to_date DESC

SELECT COUNT(ut.title),
	ut.title
INTO retiring_titles
FROM unique_titles AS ut
GROUP BY ut.title
ORDER BY COUNT DESC;

SELECT DISTINCT ON(emp.emp_no) emp.emp_no,
	emp.first_name,
	emp.last_name,
	emp.birth_date,
	de.from_date,
	de.to_date,
	tl.title
INTO mentorship_eligibility
FROM employees AS emp
INNER JOIN dept_employee AS de
ON (emp.emp_no = de.emp_no)
INNER JOIN titles AS tl
ON (emp.emp_no = tl.emp_no)
WHERE de.to_date = '9999-01-01'
AND (emp.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY emp.emp_no;
