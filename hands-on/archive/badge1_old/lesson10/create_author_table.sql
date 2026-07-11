create or replace table author
(
    author_uid number
    ,first_name varchar(50)
    ,middle_name varchar(50)
    ,lastname varchar(50)
);

insert into author(author_uid, first_name, middle_name, lastname)
values
(1, 'Fiona', '', 'Macdonald')
,(2,'Gian', 'Paulo', 'Faleschini');

select * from author;