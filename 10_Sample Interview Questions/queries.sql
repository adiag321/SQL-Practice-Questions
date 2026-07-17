-- Questions with solutions

/**** Simple Questions *****/

-- 1> Write a SQL query to find the nth highest salary from employee table. 
-- Example: finding 3rd highest salary from employee table
select * from employee order by salary desc;
--- Limit N-1,1
select distinct salary from employee order by salary desc limit 2, 1;

-- 2>  Write a query to fetch only the first name(string before space) from the FullName column of user_name table.
select distinct(substring_index(full_names, ' ', 1)) first_name from user_name;

-- 3> Write a SQL query to find all the employees from employee table who are also managers
select e1.first_name, e2.last_name from employee e1 
join employee e2
on e1.employee_id = e2.manager_id;

-- 4> Write a SQL query to find all employees who have bonus record in bonus table
select * from employee;
select * from bonus;

select * from employee where employee_id in (
        select employee_ref_id from bonus where employee.employee_id = bonus.employee_ref_id);

-- 5> Write a SQL query to find only odd rows from employee table
select * from employee where MOD(employee_id,2)<>0;

-- 6> Write a SQL query to get combine name (first name and last name) of employees from employee table
select concat(first_name, ' ' ,last_name) as Name from employee;

-- 7> Write a SQL query to get the list of employees with the same salary
select e1.first_name, e2.last_name from employee e1, employee e2 where e1.salary = e2.salary and e1.employee_id != e2.employee_id; 

-- 8> Write a SQL query to show all departments along with the number of people working there. 
select * from employee;

select department, count(*) as 'Number of employees' from employee 
group by department 
order by count(department);

-- 9> Write a SQL query to show the last record from a table.
select * from employee where employee_id = (select max(employee_id) from employee);

----------------------------------------------------------------------------------------------------------------
/**** Advanced Real-World Questions *****/

-- 10> Write an SQL query that makes recommendations using the  pages that your friends liked. 
-- Assume you have two tables: a two-column table of users and their friends, and a two-column table of 
-- users and the pages they liked. It should not recommend pages you already like.


-- 11> Write SQL to find out what percent of students attend school on their birthday from attendance_events and all_students tables?
select * from all_students;
select * from attendance_events;

select (count(attendance_events.student_id) * 100 / (select count(student_id) from attendance_events)) as Percent
from attendance_events 
join all_students 
on all_students.student_id = attendance_events.student_id
where month(attendance_events.date_event) = month(all_students.date_of_birth)
and day(attendance_events.date_event) = day(all_students.date_of_birth);

-- 12> IMP: Given timestamps of logins, figure out how many people on Facebook were active all seven days of a week on a mobile phone from login info table?
select * from login_info;

-- Find users who logged in on all 7 distinct days of a week
select count(*) as users_active_all_7_days
from (
    select user_id
    from login_info
    group by user_id
    having count(date(login_time)) >= 7
) as active_users;

-- 13> IMP: Write a SQL query to find out the overall friend acceptance rate for a May month from user_action table.
select * from user_action;

-- Scenario 1: Find the overall friend acceptance rate for May month
-- Approach 1
select count(a.user_id_who_sent)*100 / (select count(user_id_who_sent) from user_action) as percent
from user_action a
join user_action b
on a.user_id_who_sent = b.user_id_who_sent and a.user_id_to_whom = b.user_id_to_whom
where month(a.date_action) = 5 and b.action = "accepted";

-- Approach 2
select
(select count(user_id_who_sent) from USER_ACTION where month(date_action) = 5)*100/count(*)
from USER_ACTION;

-- Scenario 2: Find how many friend requests were accepted in May month out of the total requests sent in the year
select
round(sum(case when action = 'accepted' then 1 else 0 end)*100.00/count(*), 2) as perc_accpted_in_may
from USER_ACTION
where month(date_action) = 5;

-- 14> IMP: How many total users follow sport accounts from tables all_users, sport_accounts, follow_relation?
select * from all_users;
select * from sport_accounts;
select * from follow_relation;

select
count(distinct a.user_id) as count_all_sports_followers
from follow_relation as f
join sport_accounts as s
on f.target_id = s.sport_player_id
join all_users as a
on f.follower_id = a.user_id;

-- 15> IMP: How many active users follow each type of sport?

select
s.sport_category,
count(distinct a.user_id) as count_all_sports_followers
from follow_relation as f
join sport_accounts as s
on f.target_id = s.sport_player_id
join all_users as a
on f.follower_id = a.user_id
where a.active_last_month = 1
group by 1;

-- 16> IMP: What percent of active accounts are fraud from ad_accounts table?
select * from ad_accounts;

select
count(distinct a.account_id)*100.00/(select count(distinct account_id) from ad_accounts where account_status = 'active') as percent
from ad_accounts a
join ad_accounts b
on a.account_id = b.account_id
where a.account_status = 'fraud' and b.account_status='active';

-- 17> IMP: How many accounts became fraud today for the first time from ad_accounts table?

-- Scenario 1: Find the number of accounts that became fraud for the first time today
select count(account_id) 'First time fraud accounts' from (
select distinct a.account_id, count(a.account_status) 
from ad_accounts a
join ad_accounts b
on a.account_id = b.account_id
where b.date = curdate() and a.account_status = 'fraud'
group by account_id
having count(a.account_status) = 1) ad_accnt;

-- Scenario 2: Find the number of accounts that became fraud for the first time (Not takinf today/current date into account)
select
count(distinct account_id) as num_of_fraud_accounts
from (
  select
  *,
  row_number() over(partition by account_id order by date) as rw_nm
  from ad_accounts
  ) as temp
where temp.rw_nm = 1 and temp.account_status = 'fraud';

-- 18> Write a SQL query to determine avg time spent per user per day from user_details and event_session_details
select * from event_session_details;
select * from user_details;

-- Approach 1:
select date, user_id, sum(timespend_sec)/count(*) as 'avg time spent per user per day'
from event_session_details
group by 1,2
order by 1;

-- Approach 2:
select date, user_id, avg(timespend_sec)
from event_session_details
group by 1,2
order by 1;

-- 19> Write a SQL query to find top 10 users that sent the most messages from messages_detail table.
select * from messages_detail;

select user_id, sum(messages_sent) as total_messages
from messages_detail
group by user_id
order by total_messages desc
limit 10;

-- 20> Write a SQL query to find distinct first name from full user name from user_name table
select * from user_name;

select distinct(substring_index(full_names, ' ', 1)) first_name from user_name;

-- 21> You have a table with userID, appID, type and timestamp. type is either 'click' or 'impression'. 
-- Calculate the click through rate from dialoglog table. Now do it for each app.
-- click through rate is defined as (number of clicks)/(number of impressions)
select * from dialoglog;

select app_id, 
ifnull(sum(case when type = 'click' then 1 else 0 end)*1.0 / sum(case when type = 'impression' then 1 else 0 end), 0 ) 
        AS 'CTR(click through rate)'
from dialoglog
group by app_id;

-- 22> IMP: Given two tables Friend_request (requestor_id, sent_to_id, time),  
-- Request_accepted (acceptor_id, requestor_id, time). Find the overall acceptance rate of requests.
-- Overall acceptate rate of requests = total number of acceptance / total number of requests.
select * from friend_request;
select * from request_accepted;

select ifnull(round(
(select count(*) from (select distinct acceptor_id, requestor_id from request_accepted) as A)
/ 
(select count(*) from (select distinct requestor_id, sent_to_id from friend_request ) as B), 2),0
) as basic;

-- 23> IMP: from a table of new_request_accepted, find a user with the most friends.
select * from new_request_accepted;

select id from
(
select id, count(*) as count
from (
select requestor_id as id from new_request_accepted
union all
select acceptor_id as id from new_request_accepted) as a
group by 1
order by count desc
limit 1) as table1;

-- 24> IMP: from the table count_request, find total count of requests sent and total count of requests sent failed 
-- per country
select * from count_request;

select country_code, Total_request_sent, Total_percent_of_request_sent_failed, 
cast((Total_request_sent*Total_percent_of_request_sent_failed)/100 as decimal) as Total_request_sent_failed
from
( 
select country_code, sum(count_of_requests_sent) as Total_request_sent,
cast(replace(ifnull(sum(percent_of_request_sent_failed),0), '%','') as decimal(2,1)) as Total_percent_of_request_sent_failed
from count_request
group by country_code
) as Table1;

-- 25> create a histogram of duration on x axis, no of users on y axis which is populated by volume in each bucket
-- from event_session_details
select * from event_session_details;

select floor(timespend_sec/500)*500 as bucket,
count(distinct user_id) as count_of_users
from event_session_details
group by 1;

-- 26> Write SQL query to calculate percentage of confirmed messages from two tables : 
-- confirmation_no (phone numbers that facebook sends the confirmation messages to) and 
-- confirmed_no (phone numbers that confirmed the verification)

-- Approach 1
select round((count(confirmed_no.phone_number)/count(confirmation_no.phone_number))*100, 2)
from confirmation_no
left join confirmed_no
on confirmed_no.phone_number= confirmation_no.phone_number;

-- Approach 2
select
distinct 100.0*(select count(distinct phone_number) from confirmed_no)/(select count(distinct phone_number) from confirmation_no) as confirmed_msgs
from confirmation_no;

-- 27> Write SQL query to find number of users who had 4 or more than 4 interactions on 2013-03-23 date 
-- from user_interaction table (user_1, user_2, date). 
-- assume there is only one unique interaction between a pair of users per day
select * from user_interaction;

select table1.user_id, sum(number_of_interactions) as Number_of_interactions
from (
        select user_1 as user_id, count(user_1) as number_of_interactions from user_interaction
        group by user_1
union all
        select user_2 as user_id, count(user_2) as number_of_interactions from user_interaction
        group by user_2 ) table1
group by table1.user_id
having sum(number_of_interactions) >= 4;

-- Approach 2
select users, count(*) as t
from ( 
        select user_1 as users from user_interaction where date = '2019-03-23'
union all
        select user_2 as users from user_interaction where date = '2019-03-23'
) as t
group by 1
having count(*) >=4;

-- 28> write a sql query to find the names of all salesperson that have order with samsonic from 
-- the table: salesperson, customer, orders

select s.name
from salesperson s
join orders o on s.id = o.salesperson_id
join customer c on o.cust_id = c.id
where c.name = 'Samsonic';

-- 29> write a sql query to find the names of all salesperson that do not have any order with Samsonic from the table: salesperson, customer, orders

select s.Name 
from Salesperson s
where s.ID NOT IN(
select o.salesperson_id from Orders o, Customer c
where o.cust_id = c.ID 
and c.Name = 'Samsonic');

-- 30> Wrie a sql query to find the names of salespeople that have 2  or more orders.
select s.name as 'salesperson', count(o.number) as 'number of orders'
from salesperson s
join orders o on s.id = o.salesperson_id
group by s.name
having count(o.number)>=2;

-- 31> Given two tables:  User(user_id, name, phone_num) and UserHistory(user_id, date, action), 
-- write a sql query that returns the name, phone number and most recent date for any user that has logged in 
-- over the last 30 days 
-- (you can tell a user has logged in if action field in UserHistory is set to 'logged_on')

select user.name, user.phone_num, max(userhistory.date)
from user,userhistory
where user.user_id = userhistory.user_id
and userhistory.action = 'logged_on'
and userhistory.date >= date_sub(curdate(), interval 30 day)
group by user.name;

-- 32> Given two tables:  User(user_id, name, phone_num) and UserHistory(user_id, date, action), 
-- Write a SQL query to determine which user_ids in the User table are not contained in the UserHistory table 
-- (assume the UserHistory table has a subset of the user_ids in User table). Do not use the SQL MINUS statement. 
-- Note: the UserHistory table can have multiple entries for each user_id. 
select user.user_id
from user
left join userhistory
on user.user_id = userhistory.user_id
where userhistory.user_id is null;

-- 34> select the most recent login time by values from the login_info table
select * from login_info
where login_time in (select max(login_time) from login_info
group by user_id)
order by login_time desc limit 1;
