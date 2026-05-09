use database library_card_catalog;
use role sysadmin;

create or replace table book
(
    book_uid number autoincrement,
    title varchar(50),
    year_published number(4,0)
);

insert into book(title, year_published)
values
('Food', 2001),
('Food', 2006),
('Food', 2008),
('Food', 2016),
('Food', 2015);

select * from book;