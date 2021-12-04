
DROP TABLE IF exists services;
DROP TABLE IF exists class_car;
DROP TABLE IF exists services_and_class_car;
DROP TABLE IF exists masters;
DROP TABLE IF exists boxes;
DROP TABLE IF exists service_reservation;
DROP TABLE IF exists completed_services;
DROP TABLE IF exists day_schedule;
DROP TABLE IF exists master_schedule;

pragma foreign_keys = on;

CREATE TABLE services (
    id integer primary key autoincrement ,
    title text not null
);

INSERT INTO services (title) values
('Мойка двигателя'),
('Уборка салона'),
('Ополаскивание'),
('Полировка кузова'),
('Химчистка салона'),
('Чистка колесных дисков');

CREATE TABLE  class_car(
    id integer primary key autoincrement,
    title text not null
);

INSERT INTO class_car(title) values
('A-class'),
('B-class'),
('C-class'),
('D-class'),
('E-class');


CREATE TABLE  services_and_class_car(
    service_id integer not null,
    class_car_id integer not null,
    price real check(price > 0),
    duration integer check( duration > 0),
    foreign key (service_id) references services(id) on delete cascade,
    foreign key (class_car_id) references class_car(id) on delete cascade
);

INSERT INTO services_and_class_car ( service_id, class_car_id, duration, price) values
(1, 1, 20, 100.00),
(2, 1, 25, 120.00),
(3, 1, 10, 110.00),
(4, 1, 20, 150.00),
(5, 1, 30, 180.00),
(6, 1, 60, 140.00),

(1, 2, 20, 110.00),
(2, 2, 25, 130.00),
(3, 2,  10, 120.00),
(4, 2, 20, 160.00),
(5, 2, 30, 190.00),
(6, 2, 60, 150.00),

(1, 3, 20, 100.00),
(2, 3, 20, 120.00),
(3, 3, 10, 110.00),
(4, 3, 20, 150.00),
(5, 3, 30, 180.00),
(6, 3, 60, 140.00),

(1, 4, 40, 140.00),
(2, 4, 45, 160.00),
(3, 4, 30, 170.00),
(4, 4, 40, 210.00),
(5, 4, 50, 240.00),
(6, 4, 80, 200.00),

(1, 5, 40, 140.00),
(2, 5, 45, 160.00),
(3, 5, 30, 170.00),
(4, 5, 40, 210.00),
(5, 5, 50, 240.00),
(6, 5, 80, 200.00);


CREATE TABLE masters(
    id integer primary key autoincrement,
    first_name varchar(32)  not null,
    middle_name varchar(40),
    last_name varchar(40) not null,
    gender text check (gender = 'жен' or gender = 'муж'),
    birthdate date not null,
    salary_coef real default 1. check(salary_coef > 0.0 and salary_coef < 3.0),
    hiring_date date not null,
    firing_date date check(firing_date < hiring_date)
);

INSERT INTO masters (first_name, middle_name, last_name, gender, birthdate, salary_coef, hiring_date, firing_date)
values
('Петр', 'Иванович', 'Сидоров', 'муж', '1998-03-12', 1.5, '2021-11-20', null),
('Иван', 'Петрович', 'Иванов', 'муж', '1997-07-12', 2.5, '2021-11-20', null),
('Максим', 'Николаевич', 'Петров', 'муж', '2000-05-06', 2.0, '2021-11-20', null),
('Иван', 'Николаевич', 'Мохов', 'муж', '2001-09-08', 1.25, '2021-11-20', null),
('Данила', 'Александрович', 'Червяков', 'муж', '2000-02-10', 1.9, '2021-11-20', null);


CREATE TABLE boxes(
    number integer primary key check (number > 0)
);

INSERT INTO boxes(number)
values
(1),
(2),
(3),
(4);

CREATE TABLE service_reservation(
    service_id integer not null,
    class_car_id integer not null,
    master_id integer not null,
    box_number integer not null,
    date date not null,
    time time not null,
    foreign key (service_id) references services(id),
    foreign key (class_car_id) references class_car(id),
    foreign key (master_id) references masters(id),
    foreign key (box_number) references boxes(number)
);

INSERT INTO service_reservation(service_id, class_car_id, master_id, box_number, date, time)
values
(1, 1, 1, 1, '2021-12-01', '10:00'),
(2, 1, 2, 2, '2021-12-02', '10:00'),
(1, 3, 3, 3, '2021-12-01', '15:00');


CREATE TABLE completed_services
(
    service_id integer,
    master_id integer,
    class_car_id integer,
    date datetime ,
    FOREIGN key (class_car_id) REFERENCES class_car(id)
    foreign key (service_id) references services(id),
    foreign key (master_id) references masters(id)
);

INSERT INTO completed_services (service_id, class_car_id, master_id, date)
values
(1,1, 1, '2021-11-16 12:13'),
(1,2, 2, '2021-11-14 13:33'),
(1,3, 3, '2021-11-15 13:00'),
(1,5, 4, '2021-11-20 16:10');


CREATE TABLE day_schedule
(
    id integer primary key autoincrement,
    start_time time default '08:00' check(start_time >= '08:00' and start_time <= '14:00'),
    end_time time default '16:00' check(end_time >= '16:00' and end_time <= '22:00')
);

INSERT INTO day_schedule (start_time, end_time)
values
('08:00', '16:00'),
('09:00', '17:00'),
('10:00', '18:00'),
('11:00', '19:00'),
('12:00', '20:00'),
('13:00', '21:00'),
('14:00', '22:00');

CREATE TABLE  master_schedule
(
    day_schedule_id integer,
    master_id integer,
    day_of_week varchar(2),
    foreign key (day_schedule_id) references day_schedule(id),
    foreign key (master_id) references masters(id),
    check (day_of_week = 'Пн'
         or day_of_week = 'Вт'
         or day_of_week = 'Ср'
         or day_of_week = 'Чт' 
         or day_of_week = 'Пт' 
         or day_of_week = 'Сб' 
         or day_of_week = 'Вс')
);


INSERT INTO master_schedule (day_schedule_id, master_id, day_of_week)
values
(1, 1, 'Пн'),
(2, 1, 'Вт'),
(1, 1, 'Ср'),
(1, 1, 'Чт'),
(1, 1, 'Пт'),
(1, 1, 'Сб'),
(1, 1, 'Вс'),
(1, 2, 'Пн'),
(1, 2, 'Вт'),
(1, 2, 'Ср'),
(1, 2, 'Чт'),
(1, 2, 'Пт'),
(1, 2, 'Сб'),
(1, 2, 'Вс'),
(2, 3, 'Пн'),
(2, 3, 'Вт'),
(2, 3, 'Ср'),
(2, 3, 'Чт'),
(3, 3, 'Пт'),
(3, 4, 'Пн'),
(3, 4, 'Вт'),
(3, 4, 'Ср'),
(3, 4, 'Чт'),
(3, 4, 'Пт'),
(2, 4, 'Сб'),
(1, 4, 'Вс'),
(1, 5, 'Пн'),
(5, 5, 'Вт'),
(5, 5, 'Ср'),
(3, 5, 'Чт'),
(3, 5, 'Пт');