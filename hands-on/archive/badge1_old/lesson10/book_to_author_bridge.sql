use database library_card_catalog;
use role sysadmin;

create table book_to_author
(
    book_uid number
    ,author_uid number
);

insert into book_to_author(book_uid, author_uid)
values
(1, 1)
,(1, 2)
,(2, 3)
,(3, 4)
,(4, 5)
,(5, 6);

select * from book_to_author;

select *
from book_to_author
join author
    on book_to_author.author_uid = author.author_uid
join book
    on book.book_uid = book_to_author.book_uid;