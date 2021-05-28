DROP TABLE IF EXISTS schedules;
create table schedules (
    id INT NOT NULL,
    schedule_date VARCHAR(100) NOT NULL
);

insert into schedules (`start_time`, `end_time`, `date`) values ('13:23:00', '13:00:00', '2021-05-28');

select * from schedules;

