-- Drop tables if exist
--drop table if exists "departments"
--drop table if exists "dept_emp"
--drop table if exists "dept_manager"
--drop table if exists "employees"
--drop table if exists "salaries"
--drop table if exists "titles"

--Create the tables
create table "departments"(
"dept_no" varchar(30) not null,
"dept_name" varchar(30) not null,
constraint "pkey_dept" primary key ("dept_no")
);

create table "dept_emp"(
"emp_no" int not null,
"dept_no" varchar(30) not null
);

create table "dept_manager"(
"dept_no" varchar(30) not null,
"emp_no" int not null,
constraint "pkey_depMgr" primary key ("dept_no","emp_no")
);

create table "employees"(
"emp_no" int not null,
"emp_title_id" varchar(30) not null,
"birth_date" date not null,
"first_name" varchar(30) not null,
"last_name" varchar(30) not null,
"sex" varchar(30) not null,
"hire_date" date not null,
constraint "pkey_emp" primary key ("emp_no")
);

create table "salaries"(
"emp_no" int not null,
"salary" money not null,
constraint "pkey_Sal" primary key ("emp_no")
);

create table "titles"(
"title_id" varchar(30) not null,
"title"varchar(30) not null,
constraint "pkey_title" primary key ("title_id")
);

--Define foreign Keys
ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title" FOREIGN KEY("emp_title_id")
REFERENCES "titles" ("title_id");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

--Chek the import had worked
select * from salaries
select * from departments
select * from dept_emp
select * from dept_manager
select * from employees
select * from titles

--1. List the following details of each employee: employee number, last name, first name, sex, and salary.
select "employees"."emp_no", "employees"."last_name", "employees"."first_name", "employees"."sex","salaries"."salary"
from "employees", "salaries"
where "employees"."emp_no" = "salaries"."emp_no";

--2. List first name, last name, and hire date for employees who were hired in 1986.
Select "first_name", "last_name", "hire_date"
from "employees"
where hire_date between '1986-01-01' and '1986-12-31' order by hire_date;

---3. List the manager of each department with the following information: department number, department name, the manager's employee number, last name, first name.
SELECT
    "dept_manager"."dept_no", 
	"departments"."dept_name",
    "employees"."emp_no", "employees"."last_name", "employees"."first_name"
FROM
    "dept_manager" 
    INNER JOIN "departments" ON "dept_manager"."dept_no" = "departments"."dept_no"
    INNER JOIN "employees" ON "employees"."emp_no" = "dept_manager"."emp_no";
	
---4. List the department of each employee with the following information: employee number, last name, first name, and department name.
select 
employees.emp_no, employees.last_name, employees.first_name,
departments.dept_name
from employees
inner join dept_emp on "dept_emp"."emp_no" = "employees"."emp_no"
inner join departments on "dept_emp"."dept_no" = "departments"."dept_no";

---5. List first name, last name, and sex for employees whose first name is "Hercules" and last names begin with "B."
select 
first_name, last_name, sex
from employees
where first_name = 'Hercules' and last_name like 'B%';

---6. List all employees in the Sales department, including their employee number, last name, first name, and department name.
select employees.emp_no, employees.last_name, employees.first_name,
departments.dept_name
from employees
INNER JOIN "dept_emp" ON "employees"."emp_no" = "dept_emp"."emp_no"
INNER JOIN "departments" ON "dept_emp"."dept_no" = "departments"."dept_no"
WHERE "dept_name" = 'Sales';

---7. List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.
select employees.emp_no, employees.last_name, employees.first_name,
departments.dept_name
from employees
INNER JOIN "dept_emp" ON "employees"."emp_no" = "dept_emp"."emp_no"
INNER JOIN "departments" ON "dept_emp"."dept_no" = "departments"."dept_no"
WHERE "dept_name" = 'Sales' or "dept_name" = 'Development';

---8. List the frequency count of employee last names (i.e., how many employees share each last name) in descending order.
select last_name, count(last_name) as frequency
from employees
group by last_name
order by count(last_name) desc;