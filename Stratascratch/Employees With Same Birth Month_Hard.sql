--Employees With Same Birth Month (ID 10355)
/* 
Problem Description
Identify the number of employees within each department that share the same birth month. Return the result as a table 
with one row per department and one column per month (Month_1 to Month_12). If a month has no employees born in it 
within a specific department, report this month as having 0 employees. 
The profession column stores the department names of each employee. 

Link - https://platform.stratascratch.com/coding/10355-employees-with-same-birth-month?code_type=1
*/

-- DDL for employee_list table
CREATE TABLE employee_list (
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    profession VARCHAR(50),
    employee_id INT PRIMARY KEY,
    birthday DATE,
    birth_month INT
);
INSERT INTO employee_list (first_name, last_name, profession, employee_id, birthday, birth_month) VALUES
('John', 'Smith', 'Engineer', 1, '1985-02-15', 2),
('Sarah', 'Johnson', 'Doctor', 2, '1970-11-13', 11),
('Johnson', 'Miller', 'Teacher', 3, '1988-07-08', 7),
('Emma', 'Johnson', 'Doctor', 4, '1968-08-04', 8),
('Paul', 'Johnson', 'Manager', 5, '1986-01-14', 1),
('Johnson', 'Kent', 'Doctor', 6, '1969-01-24', 1),
('David', 'Baker', 'Software Dev.', 7, '1968-02-24', 2),
('Mary', 'White', 'Nurse', 8, '1977-06-23', 6),
('Johnson', 'Grey', 'Lawyer', 9, '1989-01-02', 1),
('Susan', 'Johnson', 'Engineer', 10, '1990-04-06', 4),
('Ethan', 'Davis', 'Doctor', 11, '1990-08-30', 8),
('Emily', 'Clark', 'Teacher', 12, '1960-12-26', 12),
('Johnson', 'Moore', 'Accountant', 13, '2000-07-31', 7),
('Michael', 'Johnson', 'Manager', 14, '1964-08-10', 8),
('Johnson', 'Taylor', 'Engineer', 15, '2001-06-04', 6),
('Nancy', 'Johnson', 'Doctor', 16, '1964-01-31', 1),
('Daniel', 'Thompson', 'Software Dev.', 17, '1982-09-21', 9),
('Betty', 'Wilson', 'Nurse', 18, '1970-10-14', 10),
('Johnson', 'Jackson', 'Lawyer', 19, '1998-12-31', 12),
('Johnson', 'Martin', 'Engineer', 20, '1959-06-01', 6),
('Jack', 'Johnson', 'Doctor', 21, '1990-11-24', 11),
('Helen', 'Walker', 'Teacher', 22, '1993-03-15', 3),
('Johnson', 'Allen', 'Accountant', 23, '1977-03-01', 3),
('Robert', 'Johnson', 'Manager', 24, '1970-09-04', 9),
('Hannah', 'Johnson', 'Doctor', 26, '1985-07-07', 7),
('Johnson', 'Hernandez', 'Teacher', 27, '1986-10-21', 10),
('Joshua', 'King', 'Software Dev.', 28, '1998-05-25', 5),
('Megan', 'Johnson', 'Manager', 29, '1976-03-29', 3),
('Johnson', 'Wright', 'Engineer', 30, '1991-12-09', 12),
('Andrew', 'Lopez', 'Doctor', 31, '1982-03-13', 3),
('Grace', 'Johnson', 'Teacher', 32, '1964-09-19', 9),
('Johnson', 'Hill', 'Accountant', 33, '1991-09-30', 9),
('Charles', 'Johnson', 'Manager', 34, '2000-10-20', 10),
('Johnson', 'Scott', 'Engineer', 35, '1961-06-22', 6),
('Elizabeth', 'Johnson', 'Doctor', 36, '1982-04-11', 4),
('Noah', 'Adams', 'Software Dev.', 37, '1980-08-21', 8),
('Samantha', 'Johnson', 'Nurse', 38, '1968-08-26', 8),
('Johnson', 'Baker', 'Lawyer', 39, '1976-01-11', 1),
('James', 'Johnson', 'Engineer', 40, '1966-08-12', 8),
('Chloe', 'Rivera', 'Doctor', 41, '1979-01-05', 1),
('Johnson', 'Cooper', 'Teacher', 42, '1987-09-19', 9),
('Justin', 'Johnson', 'Software Dev.', 43, '1989-12-23', 12),
('Johnson', 'Cox', 'Manager', 44, '1981-08-13', 8),
('Ava', 'Johnson', 'Engineer', 45, '2001-02-24', 2),
('Liam', 'Richardson', 'Doctor', 46, '1998-05-27', 5),
('Johnson', 'Howard', 'Teacher', 47, '1985-11-08', 11),
('Sophia', 'Johnson', 'Software Dev.', 48, '1997-06-19', 6),
('Johnson', 'Torres', 'Manager', 49, '1976-09-10', 9),
('Ethan', 'Johnson', 'Engineer', 50, '1968-05-17', 5),
('Emma', 'Johnson', 'Doctor', 51, '1988-11-02', 11),
('Johnson', 'Peterson', 'Teacher', 52, '1990-02-26', 2),
('Oliver', 'King', 'Software Dev.', 53, '1973-05-26', 5),
('Ava', 'Johnson', 'Manager', 54, '1983-09-04', 9),
('Johnson', 'Diaz', 'Engineer', 55, '2000-05-06', 5),
('Noah', 'Lopez', 'Doctor', 56, '1961-03-22', 3),
('Mia', 'Johnson', 'Teacher', 57, '1999-12-10', 12),
('Johnson', 'Hill', 'Accountant', 58, '1996-08-02', 8),
('William', 'Johnson', 'Manager', 59, '1986-11-25', 11),
('Johnson', 'Scott', 'Engineer', 60, '1961-09-30', 9),
('Emily', 'Johnson', 'Doctor', 61, '1987-03-26', 3),
('Benjamin', 'Adams', 'Software Dev.', 62, '1965-11-23', 11),
('Harper', 'Johnson', 'Nurse', 63, '1989-03-28', 3),
('Johnson', 'Perry', 'Lawyer', 64, '1980-04-28', 4),
('James', 'Johnson', 'Engineer', 65, '1985-08-19', 8),
('Evelyn', 'Rivera', 'Doctor', 66, '1969-10-29', 10),
('Johnson', 'Cooper', 'Teacher', 67, '1999-02-27', 2),
('Lucas', 'Johnson', 'Software Dev.', 68, '2000-07-09', 7),
('Johnson', 'Bryant', 'Manager', 69, '1993-03-16', 3),
('Charlotte', 'Johnson', 'Engineer', 70, '1975-08-26', 8),
('Matthew', 'Richardson', 'Doctor', 71, '1964-07-03', 7),
('Johnson', 'Howard', 'Teacher', 72, '1988-12-04', 12),
('Amelia', 'Johnson', 'Software Dev.', 73, '1982-07-05', 7),
('Johnson', 'Foster', 'Manager', 74, '1987-03-20', 3),
('Ethan', 'Johnson', 'Engineer', 75, '1978-10-20', 10),
('Isabella', 'Johnson', 'Doctor', 76, '1990-09-12', 9),
('Johnson', 'Bailey', 'Teacher', 77, '1985-10-12', 10),
('Jackson', 'Simmons', 'Software Dev.', 78, '1986-09-24', 9),
('Sofia', 'Johnson', 'Manager', 79, '1958-01-09', 1),
('Johnson', 'Perry', 'Engineer', 80, '1970-10-28', 10),
('Aiden', 'Reynolds', 'Doctor', 81, '1984-08-08', 8),
('Abigail', 'Johnson', 'Teacher', 82, '1999-12-28', 12),
('Johnson', 'Mendoza', 'Accountant', 83, '2001-06-24', 6),
('Lucas', 'Johnson', 'Manager', 84, '1970-05-12', 5),
('Johnson', 'Ruiz', 'Engineer', 85, '1980-05-30', 5),
('Madison', 'Johnson', 'Doctor', 86, '1996-08-15', 8),
('Elijah', 'Carter', 'Software Dev.', 87, '1972-08-09', 8),
('Elizabeth', 'Johnson', 'Nurse', 88, '1972-06-25', 6),
('Johnson', 'Brooks', 'Lawyer', 89, '1966-09-28', 9),
('Benjamin', 'Johnson', 'Engineer', 90, '1992-05-09', 5),
('Mia', 'Gibson', 'Doctor', 91, '1998-07-20', 7),
('Johnson', 'Boyd', 'Teacher', 92, '1987-05-09', 5),
('Noah', 'Johnson', 'Software Dev.', 93, '1962-01-24', 1),
('Johnson', 'Vasquez', 'Manager', 94, '2001-05-30', 5),
('Harper', 'Johnson', 'Engineer', 95, '1992-04-01', 4),
('Oliver', 'Freeman', 'Doctor', 96, '1965-05-22', 5),
('Johnson', 'Mullen', 'Teacher', 97, '2000-08-28', 8),
('Evelyn', 'Johnson', 'Software Dev.', 98, '1978-12-31', 12),
('Johnson', 'Rodgers', 'Manager', 99, '1969-11-25', 11),
('Lucas', 'Johnson', 'Engineer', 100, '1961-03-16', 3);

SELECT * FROM employee_list LIMIT 10;

-- ----------------------------------------------
-- My solution
-- ----------------------------------------------
-- Solution: Manual Pivot using SUM and CASE
SELECT
    profession,
    SUM(CASE WHEN birth_month = 1 THEN 1 ELSE 0 END) AS Month_1,
    SUM(CASE WHEN birth_month = 2 THEN 1 ELSE 0 END) AS Month_2,
    SUM(CASE WHEN birth_month = 3 THEN 1 ELSE 0 END) AS Month_3,
    SUM(CASE WHEN birth_month = 4 THEN 1 ELSE 0 END) AS Month_4,
    SUM(CASE WHEN birth_month = 5 THEN 1 ELSE 0 END) AS Month_5,
    SUM(CASE WHEN birth_month = 6 THEN 1 ELSE 0 END) AS Month_6,
    SUM(CASE WHEN birth_month = 7 THEN 1 ELSE 0 END) AS Month_7,
    SUM(CASE WHEN birth_month = 8 THEN 1 ELSE 0 END) AS Month_8,
    SUM(CASE WHEN birth_month = 9 THEN 1 ELSE 0 END) AS Month_9,
    SUM(CASE WHEN birth_month = 10 THEN 1 ELSE 0 END) AS Month_10,
    SUM(CASE WHEN birth_month = 11 THEN 1 ELSE 0 END) AS Month_11,
    SUM(CASE WHEN birth_month = 12 THEN 1 ELSE 0 END) AS Month_12
FROM employee_list
GROUP BY profession;