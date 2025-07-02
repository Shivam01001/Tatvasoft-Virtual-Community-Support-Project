-- ---
-- 1. CREATE Operations
-- ---

-- Create a new Database
CREATE DATABASE Tute1;

-- Create Tables
CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE employees (
    employee_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    hire_date DATE DEFAULT CURRENT_DATE,
    salary NUMERIC(10, 2) CHECK (salary > 0),
    department_id INT,
    CONSTRAINT chk_email_format CHECK (email LIKE '%@%.%')
);

-- Add a Foreign Key constraint
ALTER TABLE employees
ADD CONSTRAINT fk_department
FOREIGN KEY (department_id)
REFERENCES departments (department_id);

-- Example with Composite Primary Key
CREATE TABLE project_assignments (
    project_id INT,
    employee_id UUID,
    assignment_date DATE DEFAULT CURRENT_DATE,
    PRIMARY KEY (project_id, employee_id)
);

-- Insert Data
INSERT INTO departments (department_name) VALUES
('Sales'),
('Marketing'),
('Engineering'),
('Human Resources');

INSERT INTO employees (first_name, last_name, email, hire_date, salary, department_id) VALUES
('Alice', 'Smith', 'alice.smith@example.com', '2023-01-15', 60000.00, (SELECT department_id FROM departments WHERE department_name = 'Sales')),
('Bob', 'Johnson', 'bob.j@example.com', '2022-06-01', 75000.00, (SELECT department_id FROM departments WHERE department_name = 'Engineering')),
('Charlie', 'Brown', 'charlie.b@example.com', '2024-03-10', 55000.00, (SELECT department_id FROM departments WHERE department_name = 'Marketing')),
('Diana', 'Prince', 'diana.p@example.com', '2021-11-20', 80000.00, (SELECT department_id FROM departments WHERE department_name = 'Human Resources')),
('Eve', 'Adams', 'eve.a@example.com', '2023-09-01', 62000.00, (SELECT department_id FROM departments WHERE department_name = 'Sales'));

-- ---
-- 2. READ Operations
-- ---

-- Select all columns
SELECT * FROM employees;

-- Select specific columns
SELECT first_name, last_name, email FROM employees;

-- Column Aliases
SELECT first_name AS "First Name", last_name AS Surname FROM employees;

-- Order By
SELECT first_name, last_name, salary FROM employees
ORDER BY salary DESC, first_name ASC;

-- Select Distinct
SELECT DISTINCT department_id FROM employees;

-- Filtering Data (WHERE clause)
SELECT * FROM employees WHERE salary > 70000;
SELECT * FROM employees WHERE hire_date < '2023-01-01' AND department_id = (SELECT department_id FROM departments WHERE department_name = 'Engineering');
SELECT * FROM employees WHERE last_name IN ('Smith', 'Brown');
SELECT * FROM employees WHERE hire_date BETWEEN '2023-01-01' AND '2023-12-31';
SELECT * FROM employees WHERE email LIKE '%@example.com';
SELECT * FROM employees WHERE first_name ILIKE 'a%';
SELECT * FROM employees WHERE email IS NULL;

-- LIMIT & OFFSET
SELECT * FROM employees
ORDER BY employee_id
LIMIT 2 OFFSET 1;

-- Joins
-- INNER JOIN
SELECT e.first_name, e.last_name, d.department_name
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id;

-- LEFT JOIN
SELECT d.department_name, e.first_name
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id;

-- Subqueries
SELECT first_name, last_name, salary
FROM employees
WHERE department_id = (SELECT department_id FROM departments WHERE department_name = 'Marketing');

SELECT first_name, last_name, salary
FROM employees
WHERE salary > ANY (SELECT salary FROM employees WHERE department_id = (SELECT department_id FROM departments WHERE department_name = 'Sales'));

SELECT d.department_name
FROM departments d
WHERE EXISTS (SELECT 1 FROM employees e WHERE e.department_id = d.department_id AND e.salary > 70000);

-- ---
-- 3. UPDATE Operations
-- ---

UPDATE employees
SET salary = 65000.00
WHERE first_name = 'Alice' AND last_name = 'Smith';

UPDATE employees
SET email = 'bob.johnson@example.com', hire_date = '2022-05-15'
WHERE employee_id = (SELECT employee_id FROM employees WHERE first_name = 'Bob');

UPDATE employees
SET department_id = (SELECT department_id FROM departments WHERE department_name = 'Human Resources')
WHERE first_name = 'Eve';

-- ---
-- 4. DELETE Operations
-- ---

DELETE FROM employees
WHERE first_name = 'Charlie' AND last_name = 'Brown';

DELETE FROM employees
WHERE department_id = (SELECT department_id FROM departments WHERE department_name = 'Marketing');

-- ---
-- Interview Questions & Debugging
-- ---

-- How to debug a PostgreSQL query
EXPLAIN SELECT * FROM employees WHERE salary > 70000;
EXPLAIN ANALYZE SELECT * FROM employees WHERE salary > 70000;

-- Inner join without using INNER JOIN keyword
SELECT e.first_name, d.department_name
FROM employees e, departments d
WHERE e.department_id = d.department_id;
