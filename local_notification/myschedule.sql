DROP TABLE IF EXISTS schedules;
create table schedules (
    id INT NOT NULL,
    schedule_date VARCHAR(100) NOT NULL
);

insert into schedules (schedule_date, end_date) values ('2021-05-28 13:23:00', '2021-05-28 13:00:00');

select * from schedules;

