# Employee Leave Management System

## 📌 Project Overview

The **Employee Leave Management System** is a MySQL-based database project designed to manage employee leave information in an organization. It provides a centralized database for storing employee details, departments, managers, leave types, and leave requests.

The project demonstrates practical SQL concepts including database design, normalization, constraints, CRUD operations, joins, aggregate functions, string and date functions, subqueries, views, and transactions.

## 🎯 Project Objective

The main objective of this project is to develop a structured relational database that can:

* Store employee and department information
* Manage different types of employee leaves
* Record and track leave requests
* Maintain approval status
* Generate leave-related reports
* Perform analytical operations using SQL

## 🛠️ Technologies Used

* **Database:** MySQL
* **Tool:** MySQL Workbench
* **Language:** SQL

## 🗄️ Database Name

```sql
employee_leave_management
```

## 📊 Database Tables

The project contains the following tables:

### 1. Departments

Stores department information.

* `department_id`
* `department_name`

### 2. Managers

Stores manager information.

* `manager_id`
* `manager_name`

### 3. Leave_Types

Stores different types of employee leave.

Examples:

* Casual Leave
* Sick Leave
* Earned Leave
* Maternity Leave
* Unpaid Leave

### 4. Employees

Stores employee information and connects employees with departments.

* `employee_id`
* `department_id`
* `employee_name`
* `phone`
* `email`

### 5. Leave_Requests

Stores employee leave requests.

* `leave_id`
* `employee_id`
* `manager_id`
* `leave_type_id`
* `start_date`
* `end_date`
* `total_days`
* `status`
* `reason`

## 🔗 Database Relationships

The database uses foreign keys to establish relationships between tables.

```text
Departments
     │
     └── Employees
            │
            └── Leave_Requests
                 │
                 ├── Managers
                 │
                 └── Leave_Types
```

## ⚙️ Key Features

* Employee management
* Department management
* Manager management
* Leave type management
* Leave request tracking
* Approved/Pending/Rejected leave tracking
* Department-wise leave analysis
* Monthly leave statistics
* Leave balance calculation
* Maximum and longest leave analysis
* Employee leave history
* Approved and pending leave views
* Transaction-based leave status updates

## 🧠 SQL Concepts Used

This project demonstrates:

* Database creation
* Table creation
* Primary Keys
* Foreign Keys
* Constraints
* INSERT operations
* SELECT queries
* UPDATE operations
* DELETE operations
* INNER JOIN
* LEFT JOIN
* GROUP BY
* HAVING
* ORDER BY
* Aggregate functions
* Subqueries
* String functions
* Date functions
* Views
* Transactions
* COMMIT
* CRUD operations

## 🔍 Sample Queries

### Display Leave Requests with Employee Names

```sql
SELECT lr.leave_id,
       e.employee_name,
       lr.start_date,
       lr.end_date,
       lr.status
FROM leave_requests lr
JOIN employees e
ON lr.employee_id = e.employee_id;
```

### Count Leave Requests Department-Wise

```sql
SELECT d.department_name,
       COUNT(lr.leave_id) AS total_requests
FROM departments d
JOIN employees e
ON d.department_id = e.department_id
JOIN leave_requests lr
ON e.employee_id = lr.employee_id
GROUP BY d.department_name;
```

### Calculate Leave Duration

```sql
SELECT leave_id,
       start_date,
       end_date,
       DATEDIFF(end_date, start_date) + 1
       AS calculated_duration
FROM Leave_Requests;
```

### Create Approved Leave View

```sql
CREATE VIEW approved_leaves AS
SELECT lr.leave_id,
       e.employee_name,
       lr.start_date,
       lr.end_date,
       lr.total_days,
       lr.status
FROM leave_requests lr
JOIN employees e
ON lr.employee_id = e.employee_id
WHERE lr.status = 'Approved';
```

## 🔄 Transactions

Transactions are used to safely update leave request statuses.

Example:

```sql
START TRANSACTION;

UPDATE leave_requests
SET status = 'Approved'
WHERE leave_id = 1002;

COMMIT;
```

## 📈 Project Output

The system can generate useful information such as:

* Approved leave requests
* Pending leave requests
* Rejected leave requests
* Employees currently on leave
* Department-wise leave request counts
* Average leave days by department
* Employees with maximum leave days
* Monthly leave statistics
* Remaining leave balance
* Manager-wise approved leave counts

## 👥 Team Members

| S.No | Team Member    |
| ---- | -------------- |
| 1    | R.G. Prabhas   |
| 2    | P. Syam Sundar |
| 3    | Vasu Dev       |

## 🚀 Future Enhancements

The database can be extended by developing a web or mobile application on top of the MySQL database.

Possible enhancements include:

* Employee login system
* Manager dashboard
* HR dashboard
* Online leave application
* Email notifications
* Automatic leave balance calculation
* Leave approval notifications
* Interactive reports and dashboards

## 📁 Project Structure

```text
Employee-Leave-Management-System/
│
├── employee_leave_management.sql
├── Employee_Leave_Management_System_Presentation.pptx
└── README.md
```

## 👨‍💻 Team

**Employee Leave Management System – MySQL Capstone Project**

Developed by:

**R.G. Prabhas**
**P. Syam Sundar**
**Vasu Dev**
