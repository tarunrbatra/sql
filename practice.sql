CREATE database sql_practice;

drop database sql_practice;

CREATE TABLE
    employee (name TEXT);

use sql_practice;

-- create table
CREATE TABLE
    employee (name TEXT);

SELECT
    *
FROM
    employee;

# drop database command
-- drop database command
/*
This command can be used to drop a database, so 
should be used very carefully.
*/
DROP TABLE employee;

SELECT
    *
FROM
    employee;

CREATE TABLE
    employee (name TEXT, age INT, department TEXT, salary INT);

SELECT
    *
FROM
    employee;

INSERT INTO
    employee (Name, Age, Department, Salary)
VALUES
    ('name1', 10, 'dept1', 10000);

SELECT
    *
FROM
    employee;

INSERT INTO
    employee (Name, Age, Department, Salary)
VALUES
    ('name2', 20, 'dept2', 20000);

INSERT INTO
    employee (Name, Age, Department, Salary)
VALUES
    ('name3', 30, 'dept3', 30000);

INSERT INTO
    employee (Name, Age, Department, Salary)
VALUES
    ('name4', 40, 'dept4', 40000);

SELECT
    *
FROM
    employee;

-----------------------------------------------------------------------------------------------

SELECT 
    *
FROM
    employee;

-- alter table
ALTER TABLE employee
ADD email text;

ALTER TABLE employee
ADD id int; 

ALTER TABLE employee
DROP COLUMN id; 

INSERT INTO
    employee (Name, Age, Department, Salary, email)
VALUES
    ('name5', 35, 'dept2', 25000, 'name5@mail.com');


-- filter records
SELECT * FROM employee
where department = 'dept2';

SELECT * FROM employee
where department != 'dept2';

SELECT * FROM employee
where department <> 'dept2';

SELECT * FROM employee
where email is null;

SELECT * FROM employee
where email is not null;

-----------------------------------------------------------------------------------------------
/* 
Only showing the records from the table
where salary in greater than 20000 
*/
SELECT name, department, salary FROM employee
where salary > 20000;

-- and or not
SELECT name, department, salary FROM employee
where salary < 50000 and salary > 20000;

SELECT name, department, salary FROM employee
where salary < 50000 or salary > 20000;

SELECT name, department, salary FROM employee
where not department = 'dept2';


-----------------------------------------------------------------------------------------------

-- search for pattern
SELECT name, department, salary FROM employee
where department like 'dept%';

INSERT INTO
    employee (Name, Age, Department, Salary, email)
VALUES
    ('name6', 35, 'department2', 55000, 'name6@mail.com');
    
SELECT name, department, salary FROM employee
where department like 'dep%';

-- between
SELECT name, department, salary FROM employee
where salary between 30000 and 50000;

-- filer multiple values
SELECT * FROM employee
where name in ('name1', 'name3','name6');
