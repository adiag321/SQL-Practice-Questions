-- Schemas for Sample Interview Questions

CREATE TABLE Employee (
	EMPLOYEE_ID INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	FIRST_NAME CHAR(25),
	LAST_NAME CHAR(25),
	SALARY INT(15),
	JOINING_DATE DATETIME,
	DEPARTMENT CHAR(25), 
    MANAGER_ID INT
);
INSERT INTO Employee
	(EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY, JOINING_DATE, DEPARTMENT,MANAGER_ID) VALUES
		(001, 'James', 'Smith', 100000, '17-02-20 09.00.00', 'HR', 002),
		(002, 'Jessica', 'Kohl', 80000, '17-06-11 09.00.00', 'Admin', 005),
		(003, 'Alex', 'Garner', 300000, '17-02-20 09.00.00', 'HR', 011),
		(004, 'Pratik', 'Pandey', 500000, '17-02-20 09.00.00', 'Admin', 020),
		(005, 'Christine', 'Robinson', 500000, '17-06-11 09.00.00', 'Admin', 007),
		(006, 'Deepak', 'Gupta', 200000, '17-06-11 09.00.00', 'Account', 015),
		(007, 'Jennifer', 'Paul', 75000, '17-01-20 09.00.00', 'Account', 012),
		(008, 'Deepika', 'Sharma', 90000, '17-04-11 09.00.00', 'Admin', 017),
		(009, 'Rahul', 'Verma', 120000, '17-03-15 09.00.00', 'HR', 003),
		(010, 'Sarah', 'Connor', 95000, '17-05-22 09.00.00', 'Account', 006),
		(011, 'Michael', 'Brown', 450000, '17-01-10 09.00.00', 'Admin', 004),
		(012, 'Anita', 'Desai', 67000, '17-07-18 09.00.00', 'HR', 001),
		(013, 'Kevin', 'Hart', 150000, '17-08-25 09.00.00', 'Account', 010);

CREATE TABLE Bonus (
	EMPLOYEE_REF_ID INT,
	BONUS_AMOUNT INT(10),
	BONUS_DATE DATETIME,
	FOREIGN KEY (EMPLOYEE_REF_ID)
		REFERENCES Employee(EMPLOYEE_ID)
        ON DELETE CASCADE
);
INSERT INTO Bonus (EMPLOYEE_REF_ID, BONUS_AMOUNT, BONUS_DATE) VALUES
		(001, 5000, '18-02-20'),
		(002, 3000, '18-06-11'),
		(003, 4000, '18-02-20'),
		(001, 4500, '18-02-20'),
		(002, 3500, '18-06-11'),
		(004, 6000, '18-03-15'),
		(005, 2500, '18-04-20'),
		(006, 3200, '18-05-11'),
		(007, 1500, '18-01-25'),
		(008, 2800, '18-07-10'),
		(009, 4200, '18-08-14'),
		(010, 3100, '18-09-05');
        
CREATE TABLE Title (
	EMPLOYEE_REF_ID INT,
	EMPLOYEE_TITLE CHAR(25),
	AFFECTED_FROM DATETIME,
	FOREIGN KEY (EMPLOYEE_REF_ID)
		REFERENCES Employee(EMPLOYEE_ID)
        ON DELETE CASCADE
);
INSERT INTO Title (EMPLOYEE_REF_ID, EMPLOYEE_TITLE, AFFECTED_FROM) VALUES
 (001, 'Manager', '2018-02-20 00:00:00'),
 (002, 'Executive', '2018-06-11 00:00:00'),
 (008, 'Executive', '2018-06-11 00:00:00'),
 (005, 'Manager', '2018-06-11 00:00:00'),
 (004, 'Asst. Manager', '2018-06-11 00:00:00'),
 (007, 'Executive', '2018-06-11 00:00:00'),
 (006, 'Lead', '2018-06-11 00:00:00'),
 (003, 'Lead', '2018-06-11 00:00:00'),
 (009, 'Executive', '2018-03-15 00:00:00'),
 (010, 'Asst. Manager', '2018-05-22 00:00:00'),
 (011, 'Manager', '2018-01-10 00:00:00'),
 (012, 'Executive', '2018-07-18 00:00:00'),
 (013, 'Lead', '2018-08-25 00:00:00');
 
 
 CREATE TABLE all_students (
		student_id INT NOT NULL PRIMARY KEY,
        school_id INT,
        grade_level INT,
        date_of_birth DATETIME,
        hometown CHAR(25)
 );
 CREATE TABLE attendance_events (
		date_event DATETIME,
        student_id INT,
        attendance CHAR(20),
        FOREIGN KEY (student_id)
		REFERENCES all_students(student_id)
        ON DELETE CASCADE
 );
  
 INSERT INTO all_students
 (student_id, school_id, grade_level, date_of_birth, hometown) VALUES
 (110111, 205, 1, '2013-01-10', 'Pleasanton'),
 (110115, 205, 1, '2013-03-15', 'Dublin'),
 (110119, 205, 2, '2012-02-13', 'San Ramon'),
 (110121, 205, 3, '2011-01-13', 'Dublin'),
 (110125, 205, 2, '2012-04-25','Dublin'),
 (110129, 205, 3, '2011-02-22', 'San Ramon'),
 (110133, 210, 1, '2013-05-07', 'Pleasanton'),
 (110137, 210, 2, '2012-08-19', 'Livermore'),
 (110141, 205, 3, '2011-06-30', 'Livermore'),
 (110145, 210, 1, '2013-11-14', 'San Ramon');

 INSERT INTO attendance_events
 (date_event, student_id, attendance) VALUES
 ('2018-01-10', 110111, 'present'),
 ('2018-01-10', 110121, 'present' ),
 ('2018-01-12', 110115, 'absent'),
 ('2018-01-13', 110119, 'absent'),
 ('2018-01-13', 110121, 'present'),
 ('2018-01-14', 110125, 'present'),
 ('2018-02-05', 110111, 'absent'),
 ('2018-02-17', 110115, 'present'),
 ('2018-02-22', 110129, 'absent'),
 ('2018-01-15', 110119, 'present'),
 ('2018-02-10', 110125, 'absent'),
 ('2018-03-01', 110111, 'present'),
 ('2018-03-05', 110121, 'absent'),
 ('2018-03-12', 110115, 'present'),
 ('2018-03-18', 110129, 'present');
 
 CREATE TABLE login_info (
 user_id INT,
 login_time DATETIME
 );
 INSERT INTO login_info 
 (user_id, login_time) VALUES
 (1, '2017-08-10 14:32:25'),
 (2, '2017-08-11 14:32:25'),
 (3, '2017-08-11 14:32:25'),
 (2, '2017-08-13 14:32:25'),
 (3, '2017-08-14 14:32:25'),
 (4, '2017-08-15 14:32:25'),
 (5, '2017-08-12 14:32:25'),
 (2, '2017-08-18 14:32:25'),
 (1, '2017-08-11 14:32:25'),
 (1, '2017-08-12 14:32:25'),
 (1, '2017-08-13 14:32:25'),
 (1, '2017-08-14 14:32:25'),
 (1, '2017-08-15 14:32:25'),
 (1, '2017-08-16 14:32:25'),
 (1, '2017-08-17 14:32:25'),
 (3, '2017-08-20 14:32:25'),
 (5, '2017-08-16 14:32:25'),
 (2, '2017-08-21 14:32:25'),
 (3, '2017-08-22 14:32:25'),
 (4, '2017-08-18 14:32:25'),
 (4, '2017-08-20 14:32:25'),
 (5, '2017-08-22 14:32:25'),
 (5, '2017-08-25 14:32:25'),
 (2, '2017-08-25 14:32:25'),
 (3, '2017-08-28 14:32:25');
 
 CREATE TABLE USER_ACTION (
 user_id_who_sent INT,
 user_id_to_whom INT, 
 date_action DATETIME,
 action CHAR(25)
 );
 INSERT INTO USER_ACTION 
 (user_id_who_sent, user_id_to_whom, date_action, action) VALUES
 (20251, 28272, '2018-05-24','accepted'),
 (19209, 64638,'2018-06-13' , 'sent'),
 (43744, 16373, '2018-04-15' ,'accepted'),
 (20251, 18171, '2018-05-19' , 'sent'),
 (54875, 36363, '2018-01-11' ,'rejected'),
 (38292, 16373, '2018-05-24','accepted'),
 (19209, 26743, '2018-06-12' ,'accepted'),
 (27623, 28272, '2018-05-24','accepted'),
 (20251, 37378, '2018-03-17','rejected'),
 (43744, 18171, '2018-05-24' ,'accepted'),
 (54875, 28272, '2018-02-14', 'sent'),
 (38292, 37378, '2018-06-01', 'rejected'),
 (27623, 64638, '2018-07-10', 'sent'),
 (19209, 36363, '2018-04-22', 'accepted'),
 (20251, 16373, '2018-08-05', 'accepted');
 
 CREATE TABLE all_users(
 user_id INT NOT NULL PRIMARY KEY,
 user_name CHAR(25),
 registration_date DATETIME,
 active_last_month BOOLEAN
 );
 INSERT INTO all_users
 (user_id, user_name, registration_date, active_last_month) VALUES
 (1, 'sam', '2018-01-21', 1),
 (2, 'phelp', '2018-01-15', 1),
 (3, 'peyton', '2018-03-12', 1),
 (4, 'ryan', '2018-02-17', 0),
 (5, 'james', '2018-01-21', 0),
 (6, 'christine', '2018-02-27', 1),
 (7, 'bolt', '2018-02-28', 0),
 (8, 'jessica', '2018-01-11', 1),
 (9, 'paul', '2018-04-23', 1),
 (10, 'brian', '2018-03-12', 0),
 (11, 'lena', '2018-05-14', 1),
 (12, 'derek', '2018-06-02', 0),
 (13, 'maria', '2018-04-08', 1),
 (14, 'tom', '2018-03-29', 1),
 (15, 'nina', '2018-07-11', 0);
 
 CREATE TABLE sport_accounts(
 sport_player_id INT,
 sport_player CHAR(25), 
 sport_category CHAR(25), 
 FOREIGN KEY (sport_player_id)
		REFERENCES all_users(user_id)
        ON DELETE CASCADE
 );
 INSERT INTO sport_accounts 
 (sport_player_id, sport_player, sport_category) VALUES
 (2, 'phelp', 'swimming'),
 (7, 'bolt', 'running'),
 (8,'jessica', 'swimming'),
 (9, 'paul', 'basketball'),
 (10, 'brian', 'cricket'),
 (5, 'james', 'cricket'),
 (1, 'sam', 'tennis'),
 (3, 'peyton', 'football'),
 (11, 'lena', 'gymnastics'),
 (14, 'tom', 'running');
 
 CREATE TABLE follow_relation(
 follower_id INT, 
 target_id INT, 
 following_date DATETIME, 
 FOREIGN KEY (follower_id)
		REFERENCES all_users(user_id)
        ON DELETE CASCADE,
FOREIGN KEY (target_id)
		REFERENCES all_users(user_id)
        ON DELETE CASCADE
 );
 INSERT INTO follow_relation
 (follower_id, target_id, following_date) VALUES
 (1,8, '2018-01-02'),
 (5,2,'2018-01-02'),
 (9,10, '2018-01-02'),
 (10,8, '2018-01-02'),
 (8,3, '2018-01-02'),	
 (4, 6, '2018-01-02'),
 (2,8, '2018-01-02'),
 (6,9, '2018-01-02'),
 (1,7, '2018-01-02'),
 (10,2, '2018-01-02'), 
 (1,2, '2018-01-02'),
 (3, 5, '2018-01-05'),
 (11, 1, '2018-01-10'),
 (14, 3, '2018-01-12'),
 (13, 9, '2018-01-15'),
 (12, 7, '2018-01-18');
 
 CREATE TABLE ad_accounts(
 account_id INT, 
 date DATETIME, 
 account_status CHAR(15)
);INSERT INTO ad_accounts
(account_id, date, account_status) VALUES
(101, '2019-01-21', 'active'),
(102, '2019-01-17', 'active'),
(117, '2019-02-06', 'active'),
(112, '2019-01-16', 'active'),
(110, '2019-03-22', 'fraud'),
(115, '2019-04-28', 'fraud'),
(103, '2019-02-07', 'close'),
(112, '2019-04-15', 'fraud'),
(101, '2019-04-28', 'fraud'),
(117, '2019-04-22', 'fraud'),
(102, '2019-03-19', 'fraud'),
(106, '2019-04-28', 'fraud'),
(105, '2019-03-02', 'active'),
(110, '2019-04-28', 'fraud'),
(108, '2019-01-30', 'active'),
(109, '2019-02-14', 'active'),
(108, '2019-05-10', 'close'),
(113, '2019-03-05', 'active'),
(113, '2019-06-01', 'fraud'),
(109, '2019-04-18', 'fraud');

CREATE TABLE user_details(
date DATETIME,
session_id INT, 
user_id INT
);
INSERT INTO user_details 
(date, session_id, user_id) values
('2019-01-10', 201, 6),
('2019-01-10', 202, 7),
('2019-01-10', 203, 6),
('2019-01-11', 204, 8),
('2019-01-10', 205, 6),
('2019-01-11', 206, 8),
('2019-01-12', 207, 9),
('2019-01-13', 211, 10),
('2019-01-13', 212, 6),
('2019-01-14', 213, 11),
('2019-01-15', 214, 7),
('2019-01-15', 215, 12);

CREATE TABLE event_session_details(
date DATETIME, 
session_id INT, 
timespend_sec INT,
user_id INT
);
INSERT INTO event_session_details
(date, session_id, timespend_sec, user_id) VALUES
('2019-01-10', 201, 1200, 6),
('2019-01-10', 202, 100, 7),
('2019-01-10', 203, 1500, 6),
('2019-01-11', 204, 2000, 8),
('2019-01-10', 205, 1010, 6),
('2019-01-11', 206, 1780, 8),
('2019-01-12', 207, 2500, 9),
('2019-01-12', 208, 500, 9),
('2019-01-21', 209, 2798, 15),
('2019-01-25', 210, 1278, 18),
('2019-01-13', 211, 900, 10),
('2019-01-13', 212, 1350, 6),
('2019-01-14', 213, 2100, 11),
('2019-01-15', 214, 450, 7),
('2019-01-15', 215, 1800, 12);

CREATE TABLE messages_detail(
user_id INT NOT NULL, 
messages_sent INT,
date DATE
);
INSERT INTO messages_detail
(user_id, messages_sent, date) VALUES
(1, 120, '2014-04-27'),
(2, 50, '2014-04-27'),
(3, 222, '2014-04-27'),
(4, 70, '2014-04-27'),
(5, 250, '2014-04-27'),
(6, 246, '2014-04-27'),
(7, 179, '2014-04-27'),
(8, 116, '2014-04-27'),
(9, 84, '2014-04-27'),
(10, 215, '2014-04-27'),
(11, 105, '2014-04-27'),
(12, 174, '2014-04-27'),	
(13, 158, '2014-04-27'),
(14, 30, '2014-04-27'),
(15, 48, '2014-04-27'),
(16, 310, '2014-04-27'),
(17, 92, '2014-04-27'),
(18, 205, '2014-04-27'),
(19, 67, '2014-04-27'),
(20, 143, '2014-04-27'),
(1, 95, '2014-04-28'),
(3, 180, '2014-04-28'),
(5, 310, '2014-04-28'),
(6, 198, '2014-04-28'),
(7, 220, '2014-04-28'),
(10, 175, '2014-04-28'),
(12, 130, '2014-04-28'),
(16, 275, '2014-04-28'),
(18, 160, '2014-04-28'),
(20, 110, '2014-04-28'),
(1, 85, '2014-04-29'),
(3, 140, '2014-04-29'),
(5, 195, '2014-04-29'),
(6, 210, '2014-04-29'),
(8, 90, '2014-04-29'),
(10, 160, '2014-04-29'),
(16, 290, '2014-04-29'),
(18, 135, '2014-04-29'),
(2, 75, '2014-04-29'),
(13, 200, '2014-04-29');

CREATE TABLE user_name (
full_names CHAR(30)
);
INSERT INTO user_name
(full_names) VALUES
('Jessica Taylor'),
('Erin Russell'),
('Amanda Smith'),
('Sam Brown'),
('Robert Kehrer'),
('Diana Prince'),
('Marcus Lee'),
('Olivia Johnson'),
('Nathan Brooks');


CREATE TABLE DIALOGLOG(
user_id INT,
app_id CHAR(5),
type CHAR(15),
date TIMESTAMP
);
INSERT INTO DIALOGLOG
(user_id, app_id, type, date) VALUES
(1, 'a', 'impression', '2019-02-04'),
(2, 'a', 'impression', '2019-02-04'),
(2, 'a', 'click', '2019-02-04'),
(3, 'b', 'impression', '2019-02-04'),
(4, 'c', 'click', '2019-02-04'),
(4, 'd', 'impression', '2019-02-04'),
(5, 'd', 'click', '2019-02-04'),
(6, 'd', 'impression', '2019-02-04'),
(6, 'e', 'impression', '2019-02-04'),
(3, 'a', 'impression', '2019-02-04'), 
(3, 'b', 'click', '2019-02-04'),
(1, 'b', 'impression', '2019-02-05'),
(1, 'b', 'click', '2019-02-05'),
(5, 'a', 'impression', '2019-02-05'),
(7, 'c', 'impression', '2019-02-05'),
(7, 'c', 'click', '2019-02-05'),
(8, 'e', 'impression', '2019-02-06'),
(8, 'e', 'click', '2019-02-06');

CREATE TABLE friend_request(
requestor_id INT, 
sent_to_id INT,
time DATE
);
INSERT INTO friend_request
(requestor_id, sent_to_id, time) VALUES
(1, 2, '2018-06-03'),
(1, 3, '2018-06-08'),
(2, 4, '2018-06-09'),
(3, 4, '2018-06-11'),
(3, 5, '2018-06-11'),
(3, 5, '2018-06-12'),
(4, 1, '2018-06-15'),
(2, 5, '2018-06-18'),
(5, 1, '2018-06-20'),
(4, 3, '2018-06-22');

CREATE TABLE request_accepted(
acceptor_id INT,
requestor_id INT, 
time DATE
);
INSERT INTO request_accepted VALUES
(2, 1, '2018-08-01'),
(3, 1, '2018-08-01'),
(4, 2, '2018-08-02'),
(5, 3, '2018-08-03'),
(5, 3, '2018-08-04'),
(1, 4, '2018-08-05'),
(5, 2, '2018-08-06'),
(1, 5, '2018-08-08'),
(3, 4, '2018-08-10');

CREATE TABLE new_request_accepted(
acceptor_id INT, 
requestor_id INT, 
accept_date DATE
);
INSERT INTO new_request_accepted
(acceptor_id, requestor_id, accept_date) Values
(2, 1, '2018-05-01'),
(3, 1, '2018-05-02'),
(4, 2, '2018-05-02'),
(5, 3, '2018-05-03'),
(3, 4, '2018-05-04'),
(1, 5, '2018-05-05'),
(4, 3, '2018-05-06'),
(2, 5, '2018-05-07'),
(5, 4, '2018-05-08');

CREATE TABLE count_request(
country_code CHAR(10),
count_of_requests_sent INT,
percent_of_request_sent_failed CHAR(10), 
sent_date DATE
);
INSERT INTO count_request
(country_code, count_of_requests_sent, percent_of_request_sent_failed, sent_date) VALUES
('AU', 23676, '5.2%', '2018-09-07'),
('NZ', 12714, '2.1%', '2018-09-08'), 
('IN', 24545, '4.6%', '2018-09-09'),
('IN', 34353, '5.3%', '2018-09-10'),
('AU', 24255, '1.7%', '2018-09-11'),
('NZ', 23131, '2.9%', '2018-09-12'),
('US', 49894, '5.3%','2018-09-13'),
('IN', 19374, '2.4%', '2018-09-14'),
('AU', 18485, '2.7%','2018-09-15'),
('IN', 38364, '3.5%', '2018-09-16'),
('US', 52100, '4.8%', '2018-09-17'),
('NZ', 15892, '3.3%', '2018-09-18'),
('AU', 27340, '2.0%', '2018-09-19'),
('US', 46210, '6.1%', '2018-09-20'),
('IN', 41200, '4.0%', '2018-09-21');


CREATE TABLE confirmed_no(
phone_number CHAR(20)
);
INSERT INTO confirmed_no 
(phone_number) VALUES
('232-473-3433'),
('545-038-2294'),
('647-294-1837'),
('492-485-9727'),
('545-383-7837'),
('184-483-9575'),
('493-420-4902'),
('282-595-8373'),
('594-959-2948'),
('718-392-4851'),
('305-847-2910'),
('612-553-7764');

CREATE TABLE user_interaction(
user_1 CHAR(5),
user_2 CHAR(5), 
date DATE
);
INSERT INTO user_interaction
(user_1, user_2, date) VALUES
('A', 'B', '2019-03-23'),
('A', 'C', '2019-03-23'),
('B', 'D', '2019-03-23'),
('B', 'F', '2019-03-23'),
('C', 'D', '2019-03-23'),
('A', 'D', '2019-03-23'),
('B','C', '2019-03-23'),
('A','E', '2019-03-23'),
('C', 'F', '2019-03-24'),
('D', 'E', '2019-03-24'),
('E', 'F', '2019-03-25'),
('D', 'A', '2019-03-25'),
('F', 'A', '2019-03-26');

create table salesperson(
id INT,
name CHAR(25),
age INT,
salary INT
);
INSERT into salesperson
(id, name, age, salary) values
(1, 'Abe', 61, 140000),
(2, 'Bob', 34, 44000),
(5, 'Chris', 34, 40000),
(7, 'Dan', 41, 52000),
(8, 'Ken', 57, 115000),
(11, 'Joe', 38, 38000),
(3, 'Lucy', 29, 48000),
(4, 'Mark', 45, 72000),
(9, 'Sara', 52, 98000),
(10, 'Tom', 36, 55000);

create table customer(
id INT, 
name char(25),
city char(25),
industry_type char(1)
);
INSERT into customer
(id, name, city, industry_type) values
(4, 'Samsonic', 'pleasant', 'J'),
(6, 'Panasung', 'oaktown', 'J'),
(7, 'Samsony', 'jackson', 'B'),
(9, 'Orange', 'jackson', 'B'),
(10, 'Appleton', 'liberty', 'J'),
(11, 'MicroTech', 'pleasant', 'B'),
(12, 'DigiCorp', 'oaktown', 'J'),
(13, 'NovaStar', 'liberty', 'B');

create table orders(
number int,
order_date date,
cust_id int,
salesperson_id int,
amount int
);
INSERT into orders
(number, order_date, cust_id, salesperson_id, amount) values
(10, '1996-02-08', 4, 2, 540),
(20, '1999-01-30', 4, 8, 1800),
(30, '1995-07-14', 9, 1, 460),
(40, '1998-01-29', 7, 2, 2400),
(50, '1998-02-03', 6, 7, 600),
(60, '1998-03-02', 6, 7, 720),
(70, '1998-05-06', 6, 7, 150),
(80, '1997-08-12', 10, 5, 980),
(90, '1999-04-22', 11, 1, 1300),
(100, '1998-11-15', 12, 3, 2100),
(110, '1996-06-20', 13, 9, 750),
(120, '1999-09-10', 4, 4, 1650),
(130, '1997-12-05', 9, 10, 890);

create table event_log(
user_id INT,
event_date_time INT #Using plain INT column type to store unix timestamp is the most trivial option.
);
INSERT into event_log
(user_id, event_date_time) values
(7494212, 1535308430),
(7494212, 1535308433),
(1475185, 1535308444),
(6946725, 1535308475),
(6946725, 1535308476),
(6946725, 1535308477),
(7494212, 1535308500),
(1475185, 1535308510),
(1475185, 1535308515),
(2938471, 1535308490),
(2938471, 1535308492),
(8573920, 1535308520),
(8573920, 1535308525);

-- Q26: confirmation_no - phone numbers that Facebook sends the confirmation messages to
CREATE TABLE confirmation_no(
phone_number CHAR(20)
);
INSERT INTO confirmation_no
(phone_number) VALUES
('232-473-3433'),
('545-038-2294'),
('647-294-1837'),
('492-485-9727'),
('545-383-7837'),
('184-483-9575'),
('493-420-4902'),
('282-595-8373'),
('594-959-2948'),
('718-392-4851'),
('305-847-2910'),
('612-553-7764'),
('415-293-8472'),
('310-485-9301'),
('628-774-3920'),
('917-553-2847');

-- Q31, Q32: User table (user_id, name, phone_num)
CREATE TABLE user(
user_id INT NOT NULL PRIMARY KEY,
name CHAR(25),
phone_num CHAR(20)
);
INSERT INTO user
(user_id, name, phone_num) VALUES
(1, 'Alice', '232-473-3433'),
(2, 'Bob', '545-038-2294'),
(3, 'Charlie', '647-294-1837'),
(4, 'Diana', '492-485-9727'),
(5, 'Eve', '545-383-7837'),
(6, 'Frank', '184-483-9575'),
(7, 'Grace', '493-420-4902'),
(8, 'Hank', '282-595-8373');

-- Q31, Q32: UserHistory table (user_id, date, action)
CREATE TABLE userhistory(
user_id INT,
date DATETIME,
action CHAR(25),
FOREIGN KEY (user_id)
    REFERENCES user(user_id)
    ON DELETE CASCADE
);
INSERT INTO userhistory
(user_id, date, action) VALUES
(1, '2026-02-01 08:30:00', 'logged_on'),
(1, '2026-02-05 09:15:00', 'logged_on'),
(1, '2026-02-10 10:00:00', 'logged_on'),
(2, '2026-02-02 14:20:00', 'logged_on'),
(2, '2026-02-08 11:45:00', 'logged_on'),
(3, '2026-01-15 16:00:00', 'logged_on'),
(3, '2026-02-20 13:30:00', 'logged_on'),
(4, '2026-02-18 07:50:00', 'logged_on'),
(5, '2025-12-01 09:00:00', 'logged_on'),
(6, '2026-02-25 17:00:00', 'logged_on'),
(1, '2026-02-15 08:00:00', 'page_view'),
(2, '2026-02-12 10:30:00', 'page_view'),
(4, '2026-02-20 14:10:00', 'page_view');

-- Q33: compare table (numbers)
CREATE TABLE compare(
numbers INT(4)
);
INSERT INTO compare
(numbers) VALUES
(66),
(44),
(22),
(99),
(55),
(77),
(33),
(88),
(11);
