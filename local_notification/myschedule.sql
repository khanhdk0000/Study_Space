DROP TABLE IF EXISTS schedules;
create table schedules (
    id INT NOT NULL,
    schedule_date VARCHAR(100) NOT NULL
);

insert into schedules (id, schedule_date) values (1, '2021-05-14 09:00:00');
insert into schedules (id, schedule_date) values (2, '2021-05-14 10:00:00');
insert into schedules (id, schedule_date) values (3, '2021-05-14 11:00:00');

select * from schedules;

