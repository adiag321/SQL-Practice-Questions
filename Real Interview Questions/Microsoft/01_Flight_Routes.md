### Microsoft SQL  Interview Questions: 

This SQL interview question was asked by Microsoft for a data analyst or data engineer position. The problem name is possible `flight routes`.

### Problem

Each row in the table flights contains information about a flight: the time of departure (start_time), time of landing (end_time), the code of its port of departure (start_port) and the code of its destination port (end _port).
Each row in the table airports contains information about an airport: the city name (city_name) and the port code (port_code). Each port_code is assigned to at most one airport.
A passenger wants to travel from New York to Tokyo in the shortest possible time. The passenger can start at any airport in New York and must finish their journey at any airport in Tokyo. They can change planes at most once. A plane change is possible if the first flight ends no later than the start time of the second flight. Note that it is possible to change planes if the end time of the first flight is equal to the start time of the second flight. The second flight must start from the airport at which the first flight ended.
Write an SQL query that finds the shortest time in which this journey can occur. Return the difference between the time of departure from New York and the time of arrival in Tokyo in minutes. If such a journey is impossible, return NULL.

### Sample Data

```SQL
CREATE TABLE airports (
    port_code VARCHAR(10) PRIMARY KEY,
    city_name VARCHAR(100)
);

CREATE TABLE flights (
    flight_id varchar (10),
    start_port VARCHAR(10),
    end_port VARCHAR(10),
    start_time datetime,
    end_time datetime
);

delete from airports;
INSERT INTO airports (port_code, city_name) VALUES
('JFK', 'New York'),
('LGA', 'New York'),
('EWR', 'New York'),
('LAX', 'Los Angeles'),
('ORD', 'Chicago'),
('SFO', 'San Francisco'),
('HND', 'Tokyo'),
('NRT', 'Tokyo'),
('KIX', 'Osaka');

delete from flights;
INSERT INTO flights VALUES
(1, 'JFK', 'HND', '2025-06-15 06:00', '2025-06-15 18:00'),
(2, 'JFK', 'LAX', '2025-06-15 07:00', '2025-06-15 10:00'),
(3, 'LAX', 'NRT', '2025-06-15 10:00', '2025-06-15 22:00'),
(4, 'JFK', 'LAX', '2025-06-15 08:00', '2025-06-15 11:00'),
(5, 'LAX', 'KIX', '2025-06-15 11:30', '2025-06-15 22:00'),
(6, 'LGA', 'ORD', '2025-06-15 09:00', '2025-06-15 12:00'),
(7, 'ORD', 'HND', '2025-06-15 11:30', '2025-06-15 23:30'),
(8, 'EWR', 'SFO', '2025-06-15 09:00', '2025-06-15 12:00'),
(9, 'LAX', 'HND', '2025-06-15 13:00', '2025-06-15 23:00'),
(10, 'KIX', 'NRT', '2025-06-15 08:00', '2025-06-15 10:00');
```

### Solution

```SQL

```