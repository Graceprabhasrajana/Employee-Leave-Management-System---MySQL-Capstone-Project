create database
employee_leave_management;

use employee_leave_management;

#Creating tables first (no foreign keys of their own)
create table Departments(department_id INT PRIMARY KEY, 
department_name VARCHAR(50) NOT NULL);

create table managers(manager_id INT PRIMARY KEY,
manager_name VARCHAR(50) NOT NULL);

create table leave_types(leave_type_id INT PRIMARY KEY,
leave_type_name VARCHAR(50) NOT NULL);


show tables;

CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    department_id INT,
    employee_name VARCHAR(50) NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(100),
    FOREIGN KEY (department_id)
        REFERENCES Departments(department_id)
);

show tables;

CREATE TABLE Leave_Requests (
    leave_id      INT PRIMARY KEY,
    employee_id   INT,
    manager_id    INT,
    leave_type_id INT,
    start_date    DATE,
    end_date      DATE,
    total_days    INT,
    status        VARCHAR(20),
    reason        VARCHAR(255),
    FOREIGN KEY (employee_id)   REFERENCES 
Employees(employee_id),
    FOREIGN KEY (manager_id)    REFERENCES 
Managers(manager_id),
    FOREIGN KEY (leave_type_id) REFERENCES 
Leave_Types(leave_type_id)
);


insert into departments (department_id, department_name) values
(1,'HR'),
(2,'IT'),
(3,'Finance'),
(4,'Sales'),
(5,'Administration');

INSERT INTO Managers (manager_id, 
manager_name) VALUES
(1,'Ramesh'),
(2,'Priya'),
(3,'Kiran'),
(4,'Sneha'),
(5,'Arun');

INSERT INTO Leave_Types (leave_type_id, 
leave_type_name) VALUES
(1,'Casual Leave'),
(2,'Sick Leave'),
(3,'Earned Leave'),
(4,'Maternity Leave'),
(5,'Unpaid Leave');

INSERT INTO Employees (employee_id, 
department_id, employee_name, phone, email) 
VALUES
(101,1,'Aarav','9876500001','aarav@mail.com
'),
(102,2,'Bhavya','9876500002','bhavya@mail.c
om'),
(103,3,'Charan','9876500003','charan@mail.c
om'),
(104,4,'Divya','9876500004','divya@mail.com
'),
(105,5,'Esha','9876500005','esha@mail.com'),
(106,2,'Farhan','9876500006','farhan@mail.c
om'),
(107,1,'Gopi','9876500007','gopi@mail.com')
,
(108,3,'Hari','9876500008','hari@mail.com')
,
(109,4,'Isha','9876500009','isha@mail.com')
,
(110,5,'John','9876500010','john@mail.com');


desc leave_requests;


INSERT INTO Leave_Requests
(leave_id, employee_id, manager_id, leave_type_id,
 start_date, end_date, total_days, status, reason)
VALUES
(1001, 101, 1, 1, '2026-07-01', '2026-07-03', 3, 'Approved', 'Personal work'),

(1002, 102, 2, 2, '2026-07-02', '2026-07-04', 3, 'Pending', 'Fever'),

(1003, 103, 3, 3, '2026-07-05', '2026-07-06', 2, 'Approved', 'Vacation'),

(1004, 104, 4, 1, '2026-07-07', '2026-07-08', 2, 'Rejected', 'Family function'),

(1005, 105, 5, 5, '2026-07-10', '2026-07-12', 3, 'Approved', 'Personal'),

(1006, 106, 2, 2, '2026-07-11', '2026-07-11', 1, 'Pending', 'Medical'),

(1007, 107, 1, 1, '2026-07-13', '2026-07-15', 3, 'Approved', 'Travel'),

(1008, 108, 3, 3, '2026-07-16', '2026-07-20', 5, 'Approved', 'Vacation'),

(1009, 109, 4, 2, '2026-07-18', '2026-07-19', 2, 'Rejected', 'Sick'),

(1010, 110, 5, 1, '2026-07-21', '2026-07-22', 2, 'Pending', 'Personal');

SELECT 'Departments' AS table_name, 
COUNT(*) AS row_count FROM Departments
UNION ALL
SELECT 'Managers', COUNT(*) FROM Managers
UNION ALL
SELECT 'Leave_Types', COUNT(*) FROM 
Leave_Types
UNION ALL
SELECT 'Employees', COUNT(*) FROM Employees
UNION ALL
SELECT 'Leave_Requests', COUNT(*) FROM 
Leave_Requests;


#-----------------------------------Queries starts from here-----------------------------#
#list all leave requests
select * from leave_requests;

#display leave request with employee_name
select lr.leave_id, e.employee_name, lr.start_date, lr.end_date, lr.status
from leave_requests as lr
join employees as e on lr.employee_id = e.employee_id;

#show approved leave requests
select * from leave_requests where status = 'approved';


#show pending leave requests
select * from leave_requests where status = 'pending';


#Employees currently on leave
#Real time -- version
select e.employee_name, lr.start_date, lr.end_date, lr.status
from leave_requests as lr
join employees e on lr.employee_id = e.employee_id
where curdate() between lr.start_date and lr.end_date and
lr.status = 'approved';

#fixed date version
select e.employee_name, lr.start_date, lr.end_date, lr.status
from leave_requests as lr
join employees e on lr.employee_id = e.employee_id
where '2026-07-14' between lr.start_date and lr.end_date and
lr.status = 'approved';

#count leave requests department - wise
select d.department_name, count(lr.leave_id) as total_requests
from departments d
join employees e on d.department_id = e.department_id
join leave_requests lr on e.employee_id = lr.employee_id
group by d.department_name;

#count leave requests by status
select status, count(*) as total
from leave_requests
group by status;

select * from employees;

#average leave days by department
SELECT d.department_name,
       ROUND(AVG(lr.total_days), 1) AS avg_leave_days
FROM departments d
JOIN employees e
    ON d.department_id = e.department_id
JOIN leave_requests lr
    ON e.employee_id = lr.employee_id
GROUP BY d.department_name;

#employees with maximum leave days
SELECT e.employee_name, lr.total_days
FROM Leave_Requests lr
JOIN Employees e ON lr.employee_id = e.employee_id
WHERE lr.total_days = (SELECT MAX(total_days) FROM Leave_Requests);

#department with maximum leave requests
SELECT d.department_name, COUNT(lr.leave_id) AS total_requests
FROM Departments d
JOIN Employees e ON d.department_id = e.department_id
JOIN Leave_Requests lr ON e.employee_id = lr.employee_id
GROUP BY d.department_name
ORDER BY total_requests DESC
LIMIT 1;

#Employees with more than 2 leave requests
SELECT e.employee_name, COUNT(lr.leave_id) AS total_requests
FROM Employees e
JOIN Leave_Requests lr ON e.employee_id = lr.employee_id
GROUP BY e.employee_name
HAVING COUNT(lr.leave_id) > 2;


#employees who never applied for leave
SELECT e.employee_name
FROM Employees e
LEFT JOIN Leave_Requests lr ON e.employee_id = lr.employee_id
WHERE lr.leave_id IS NULL;

#latest 5 leave requests
SELECT *
FROM Leave_Requests
ORDER BY start_date DESC
LIMIT 5;

#leave requests in last 30 days
SELECT *
FROM Leave_Requests
WHERE start_date >= DATE_SUB('2026-07-25', INTERVAL 30 DAY);

#display employees names in lower and upper case
SELECT employee_name,
UPPER(employee_name) AS upper_name,
LOWER(employee_name) AS lower_name
FROM Employees;

#show first 3 characters of employee
SELECT employee_name, LEFT(employee_name, 3) AS first_three_chars
FROM Employees;

#calculate leave duration
SELECT leave_id, start_date, end_date,
DATEDIFF(end_date, start_date) + 1 AS calculated_duration
FROM Leave_Requests;


#generate leave reference
SELECT leave_id, CONCAT('EL-', leave_id) AS leave_reference
FROM Leave_Requests;


#leave types used more than 5 types
SELECT lt.leave_type_name, COUNT(lr.leave_id) AS times_used
FROM Leave_Types lt
JOIN Leave_Requests lr ON lt.leave_type_id = lr.leave_type_id
GROUP BY lt.leave_type_name
HAVING COUNT(lr.leave_id) > 5;


#manager wise approved leave count
SELECT m.manager_name, COUNT(lr.leave_id) AS approved_count
FROM Managers m
JOIN Leave_Requests lr ON m.manager_id = lr.manager_id
WHERE lr.status = 'Approved'
GROUP BY m.manager_name;


#employees whose leaves exceeds the department wise average
SELECT e.employee_name, d.department_name, lr.total_days
FROM Leave_Requests lr
JOIN Employees e ON lr.employee_id = e.employee_id
JOIN Departments d ON e.department_id = d.department_id
WHERE lr.total_days > (
SELECT AVG(lr2.total_days)
FROM Leave_Requests lr2
JOIN Employees e2 ON lr2.employee_id = e2.employee_id
WHERE e2.department_id = e.department_id
);



#22- Show monthly wise leave statistics
SELECT YEAR(start_date) AS leave_year,
MONTHNAME(start_date) AS leave_month,
COUNT(*) AS total_requests,
SUM(total_days) AS total_leave_days
FROM Leave_Requests
GROUP BY YEAR(start_date), MONTHNAME(start_date);


#23 - longest leave taken
SELECT *
FROM Leave_Requests
ORDER BY total_days DESC
LIMIT 1;

#24 -- remaining leave balance
SELECT e.employee_name,
12 AS assumed_allocated_days,
COALESCE(SUM(lr.total_days), 0) AS days_taken,
12- COALESCE(SUM(lr.total_days), 0) AS remaining_balance
FROM Employees e
LEFT JOIN Leave_Requests lr
ON e.employee_id = lr.employee_id AND lr.status = 'Approved'
GROUP BY e.employee_name;


#open leave requests
SELECT *
FROM Leave_Requests
WHERE status = 'Pending';


#26 -- rejected leave requests
SELECT *
FROM Leave_Requests
WHERE status = 'Rejected';

#27 -- create a view for approved leaves
CREATE VIEW View_Approved_Leaves AS
SELECT lr.leave_id, e.employee_name, lr.start_date, lr.end_date, lr.total_days, lr.status
FROM Leave_Requests lr
JOIN Employees e ON lr.employee_id = e.employee_id
WHERE lr.status = 'Approved';



#28 -- create a view for pending leaves 
CREATE VIEW View_Pending_Leaves AS
SELECT lr.leave_id, e.employee_name, lr.start_date, lr.end_date, lr.total_days, lr.status
FROM Leave_Requests lr
JOIN Employees e ON lr.employee_id = e.employee_id
WHERE lr.status = 'Pending';


#29 -- transactions ton approve leave requests
START TRANSACTION;
UPDATE Leave_Requests
SET status = 'Approved'
WHERE leave_id = 1002;
COMMIT;


#30 -- transaction to cancel leave requests and restore the remaining balance
START TRANSACTION;
UPDATE Leave_Requests
SET status = 'Rejected'
WHERE leave_id = 1006;
COMMIT;



#after excuting all queries -------------------
select * from leave_requests;


SELECT 
    lr.leave_id,
    e.employee_name,
    d.department_name,
    lr.start_date,
    lr.end_date,
    lr.total_days,
    lr.status
FROM leave_requests lr
JOIN employees e
    ON lr.employee_id = e.employee_id
JOIN departments d
    ON e.department_id = d.department_id;
    
    
  #group by + aggregrate  
    SELECT 
    d.department_name,
    ROUND(AVG(lr.total_days), 1) AS avg_leave_days
FROM departments d
JOIN employees e
    ON d.department_id = e.department_id
JOIN leave_requests lr
    ON e.employee_id = lr.employee_id
GROUP BY d.department_name;


#filtering/ functions
SELECT 
    employee_name,
    UPPER(employee_name) AS upper_name,
    LOWER(employee_name) AS lower_name
FROM employees;


#views
CREATE VIEW approved_leaves AS
SELECT 
    lr.leave_id,
    e.employee_name,
    lr.start_date,
    lr.end_date,
    lr.total_days,
    lr.status
FROM leave_requests lr
JOIN employees e
    ON lr.employee_id = e.employee_id
WHERE lr.status = 'Approved';

SELECT * FROM approved_leaves;


#transactions
START TRANSACTION;

UPDATE leave_requests
SET status = 'Approved'
WHERE leave_id = 1002;

SELECT *
FROM leave_requests
WHERE leave_id = 1002;

COMMIT;


#--------------------------------stored procedures and triggers starts here----------------------
show procedure status
where db = 'employee_leave_management';


CALL Get_Manager_Leave_Requests(2);


#32-- Stored Procedure — Total Approved Leave Days
DELIMITER //

CREATE PROCEDURE Get_Approved_Leave_Days(IN p_employee_id INT)
BEGIN
    SELECT
        e.employee_name,
        COALESCE(SUM(lr.total_days), 0) AS total_approved_leave_days
    FROM employees e
    LEFT JOIN leave_requests lr
        ON e.employee_id = lr.employee_id
        AND lr.status = 'Approved'
    WHERE e.employee_id = p_employee_id
    GROUP BY e.employee_id, e.employee_name;
END //

DELIMITER ;


CALL Get_Approved_Leave_Days(101);

#33 - Trigger — Log New Leave Requests
CREATE TABLE Leave_Request_Log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    leave_id INT,
    employee_id INT,
    leave_type_id INT,
    status VARCHAR(20),
    created_date DATE
);


DELIMITER //

CREATE TRIGGER trg_leave_request_log
AFTER INSERT ON leave_requests
FOR EACH ROW
BEGIN
    INSERT INTO Leave_Request_Log
    (
        leave_id,
        employee_id,
        leave_type_id,
        status,
        created_date
    )
    VALUES
    (
        NEW.leave_id,
        NEW.employee_id,
        NEW.leave_type_id,
        NEW.status,
        CURRENT_DATE()
    );
END //

DELIMITER ;


INSERT INTO leave_requests
(
    leave_id,
    employee_id,
    manager_id,
    leave_type_id,
    start_date,
    end_date,
    total_days,
    status,
    reason
)
VALUES
(
    1011,
    101,
    1,
    2,
    '2026-09-25',
    '2026-09-26',
    2,
    'Pending',
    'Medical'
);


SELECT * FROM Leave_Request_Log;



#Q34. Trigger — Leave Status History
CREATE TABLE Leave_Status_History (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    leave_id INT,
    employee_id INT,
    old_status VARCHAR(20),
    new_status VARCHAR(20),
    change_date DATE
);

DELIMITER //

CREATE TRIGGER trg_leave_status_history
AFTER UPDATE ON leave_requests
FOR EACH ROW
BEGIN
    IF NOT (OLD.status <=> NEW.status) THEN

        INSERT INTO Leave_Status_History
        (
            leave_id,
            employee_id,
            old_status,
            new_status,
            change_date
        )
        VALUES
        (
            NEW.leave_id,
            NEW.employee_id,
            OLD.status,
            NEW.status,
            CURRENT_DATE()
        );

    END IF;
END //

DELIMITER ;


UPDATE leave_requests
SET status = 'Approved'
WHERE leave_id = 1002;



SELECT * FROM Leave_Status_History;




    