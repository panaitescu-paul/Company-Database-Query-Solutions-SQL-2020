
--######################################################################--
--#                                                                    #--
--#           SQL Queries for Company Database [28.APR.2020]           #--
--#                    Author: Paul Panaitescu                         #--
--#                                                                    #--
--######################################################################--


--|---------------------------|--
--|     List of Queries       |--
--|---------------------------|--

--  1: Retrieve the name and address of all employees who work for the "Research" department
--  2: Retrieve the name of each employee who has a dependent with the same gender as the employee
--  3: Retrieve the names of employees who have no dependents
--  4: Retrieve the names of all employees who are managers and who have at least one dependent
--  5: Retrieve the Social Security numbers of all employees who work on project numbers 1, 2, or 3
--  6: Retrieve the sum of the salaries of all employees, the maximum salary, the minimum salary, and the average salary
--  7: Retrieve the sum of the salaries of all employees of the "Research" department,
--  as well as the maximum salary, the minimum salary, and the average salary in this department
--  8: Retrieve the total number of employees in the company
--  9: Retrieve the total number of employees in the "Research" department
--  10: Retrieve the number of distinct salary values in the database
--  11: Retrieve the names of all employees who have two or more dependents
--  12: Retrieve for each department, the number of employees it has, and their average salary according to their gender
--  13: Retrieve for each project, its number, its name, and the number of employees who work on that project
--  14: Retrieve for each department, its department number, the combined salary in that department, and the number of employees who work in that department
--  15: Retrieve for each project on which more than two employees work,
--  the project number, the project name, and the number of employees who work on the project
--  16: Retrieve for each project, the project number, the project name,
--  and the number of employees from the 'administration' who work on the project
--  17: Retrive the total number of employees whose salaries exceed $32000 in each department which more than two employees
--  18: Create a view that contains the info about a project name, number of employees working on it, and total salary of them


--|--------------------------------|--
--|     Solutions for Queries      |--
--|--------------------------------|--

----------------------------------------------------------------------------------------------------------------
--  1: Retrieve the name and address of all employees who work for the "Research" department
----------------------------------------------------------------------------------------------------------------
--  1.1.
USE company;
SELECT Fname, Lname, Address
FROM employee
WHERE Dno IN (SELECT Dnumber 
		FROM department 
		WHERE Dname = "Research" );

--  1.2.
USE company;
SELECT Fname, Lname, Address
FROM employee, department
WHERE  Dname = 'Research' AND Dnumber = Dno;

----------------------------------------------------------------------------------------------------------------
--  2: Retrieve the name of each employee who has a dependent with the same gender as the employee
----------------------------------------------------------------------------------------------------------------
--  2.1.
USE company;
SELECT Fname, Lname
FROM employee e
WHERE Ssn IN (SELECT Essn 
		FROM dependent d
		WHERE e.Sex = d.Sex );

--  2.2.
SELECT e.Fname, e.Lname
	FROM employee AS e, dependent AS d
	WHERE e.Ssn = d.Essn AND e.Sex = d.Sex;

----------------------------------------------------------------------------------------------------------------
--  3: Retrieve the names of employees who have no dependents
----------------------------------------------------------------------------------------------------------------
--  3.
USE company;
SELECT Fname, Lname
FROM employee e
WHERE Ssn NOT IN (SELECT Essn
                 FROM dependent d )

----------------------------------------------------------------------------------------------------------------
--  4: Retrieve the names of all employees who are managers and who have at least one dependent
----------------------------------------------------------------------------------------------------------------
--  4.
USE company;
SELECT Fname, Lname
FROM employee e
WHERE Ssn IN (SELECT Mgr_ssn
	FROM department d1, dependent d2
	WHERE d1.Mgr_ssn = d2.Essn );

----------------------------------------------------------------------------------------------------------------
--  5: Retrieve the Social Security numbers of all employees who work on project numbers 1, 2, or 3
----------------------------------------------------------------------------------------------------------------
--  5.1.
USE company;
SELECT DISTINCT Essn
	FROM works_on
	WHERE Pno IN (1,2,3);

--  5.2.
USE company;
SELECT Ssn
FROM employee e
WHERE Ssn IN (SELECT Essn
	FROM works_on w
	WHERE w.Pno IN (SELECT Pnumber
		FROM project p
		WHERE p.Pnumber = '1' OR p.Pnumber = '2' OR p.Pnumber = '3'));

----------------------------------------------------------------------------------------------------------------
--  6: Retrieve the sum of the salaries of all employees, the maximum salary, the minimum salary, and the average salary
----------------------------------------------------------------------------------------------------------------
--  6.1.
USE company;
SELECT  SUM(e.salary) AS Sum_of_salaries, 
				MAX(e.salary) AS Max_of_salaries, 
				MIN(e.salary) AS Min_of_salaries, 
				AVG(e.salary) AS Avg_of_salaries
                FROM employee e;

--  6.2.
USE company;
SELECT SUM(Salary), MAX(Salary), MIN(Salary), AVG(Salary)
	FROM employee;

----------------------------------------------------------------------------------------------------------------
--  7: Retrieve the sum of the salaries of all employees of the "Research" department,
--  as well as the maximum salary, the minimum salary, and the average salary in this department
----------------------------------------------------------------------------------------------------------------
-- 7.1.
USE company;
SELECT  SUM(e.salary) AS Sum_of_salaries, 
				MAX(e.salary) AS Max_of_salaries, 
				MIN(e.salary) AS Min_of_salaries, 
				AVG(e.salary) AS Avg_of_salaries
                FROM employee e
				WHERE Dno IN (SELECT Dnumber 
						FROM department 
						WHERE Dname = "Research" );

--  7.2.
USE company;
SELECT SUM(SALARY), MAX(SALARY), MIN(SALARY), AVG(SALARY)
FROM EMPLOYEE, DEPARTMENT
WHERE DNO = DNUMBER AND DNAME = 'Research';

----------------------------------------------------------------------------------------------------------------
--  8: Retrieve the total number of employees in the company
----------------------------------------------------------------------------------------------------------------
--  8.1.
USE company;
SELECT  COUNT(e.Ssn) AS Total_number_of_employees
		FROM employee e

--  8.2.
SELECT COUNT(*)
FROM employee;

----------------------------------------------------------------------------------------------------------------
--  9: Retrieve the total number of employees in the "Research" department
----------------------------------------------------------------------------------------------------------------
--  9.1.
USE company;
SELECT  COUNT(e.Ssn) AS Total_number_of_employees
		FROM employee e
        WHERE Dno IN (SELECT Dnumber 
						FROM department 
						WHERE Dname = "Research" );

--  9.2.
USE company;
SELECT COUNT(*)
FROM EMPLOYEE, DEPARTMENT
WHERE DNO = DNUMBER AND DNAME = 'Research';

----------------------------------------------------------------------------------------------------------------
--  10: Retrieve the number of distinct salary values in the database
----------------------------------------------------------------------------------------------------------------
--  10.
USE company;
SELECT  COUNT(DISTINCT e.salary)
		FROM employee e

----------------------------------------------------------------------------------------------------------------
--  11: Retrieve the names of all employees who have two or more dependents
----------------------------------------------------------------------------------------------------------------
--  11.1.
SELECT Fname, Lname
		FROM employee e
		WHERE (SELECT COUNT(*)
				FROM dependent d
				WHERE e.Ssn = d.Essn) >= 2;

--  11.2.
USE company;
SELECT  Fname, Lname
		FROM employee e
        WHERE e.Ssn IN (SELECT d.Essn
			FROM dependent d
			GROUP BY d.Essn
			HAVING  COUNT(*) >= 2 );

----------------------------------------------------------------------------------------------------------------
--  12: Retrieve for each department, the number of employees it has, and their average salary according to their gender
----------------------------------------------------------------------------------------------------------------
--  12.
USE company;
SELECT e.Dno AS Dep_number, 
		COUNT(e.Ssn) AS Number_of_employees, 
		AVG (e.Salary) AS Average_salary, 
		e.Sex AS Gender
FROM Employee AS e
GROUP BY e.Dno, e.Sex;

----------------------------------------------------------------------------------------------------------------
--  13: Retrieve for each project, its number, its name, and the number of employees who work on that project
----------------------------------------------------------------------------------------------------------------
--  13.
USE company;
SELECT Pnumber, Pname, COUNT(Pno) AS Number_of_employees
	FROM Project, Works_on
	WHERE Pnumber = Pno
		GROUP BY Pnumber, Pname;

----------------------------------------------------------------------------------------------------------------
--  14: Retrieve for each department, its department number, the combined salary in that department, and the number of employees who work in that department
----------------------------------------------------------------------------------------------------------------
--  14.
USE company;
SELECT Dno, SUM(Salary), COUNT(*) AS Number_of_employees
		FROM Employee
			GROUP BY Dno;

----------------------------------------------------------------------------------------------------------------
--  15: Retrieve for each project on which more than two employees work,
--the project number, the project name, and the number of employees who work on the project
----------------------------------------------------------------------------------------------------------------
--  15.
USE company;
SELECT Pnumber, Pname, COUNT(*) AS Number_of_employees
	FROM Project, Works_on
	WHERE Pnumber = Pno
		GROUP BY Pnumber, Pname
		HAVING COUNT(*) > 2;

----------------------------------------------------------------------------------------------------------------
--  16: Retrieve for each project, the project number, the project name,
--and the number of employees from the 'administration' who work on the project
----------------------------------------------------------------------------------------------------------------
--  16.
USE company;
SELECT Pnumber, Pname, COUNT(*) AS Number_of_employees
		FROM Project, Works_on, Department
		WHERE Pnumber = Pno AND Dnumber = Dnum AND Dname = 'Administration'
			GROUP BY Pnumber, Pname

----------------------------------------------------------------------------------------------------------------
--  17: Retrieve the total number of employees whose salaries exceed $32000 in each department which more than two employees
----------------------------------------------------------------------------------------------------------------
--  17.
USE company;
SELECT Dnumber, COUNT(*) AS Number_of_employees
		FROM Department, Employee
		WHERE Dnumber = Dno AND Salary > 32000 AND Dno IN (SELECT Dno
				FROM Employee
					GROUP BY Dno
					HAVING COUNT(*) > 2)
		GROUP BY Dnumber;

----------------------------------------------------------------------------------------------------------------
--  18: Create a view that contains the info about a project name, number of employees working on it, and total salary of them
----------------------------------------------------------------------------------------------------------------
--  18.
USE company;

-- DROP VIEW Project_info;
CREATE VIEW Project_info
AS SELECT Pname, COUNT(*) AS Number_of_employees, SUM(Salary)
		FROM Project, Works_on, Employee
		WHERE Pnumber = Pno AND Ssn = Essn
			GROUP BY Pname;

----------------------------------------------------------------------------------------------------------------
