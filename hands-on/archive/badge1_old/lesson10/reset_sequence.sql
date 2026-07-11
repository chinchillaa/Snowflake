use role sysadmin;

create or replace sequence library_card_catalog.public.seq_author_uid
    start = 3,
    increment = 1,
    ORDER,
    comment = 'Use this to fill in the AUTHOR_UID every time you add a row';

insert into author(author_uid, first_name, middle_name, last_name)
values
(seq_author_uid.nextval, 'Laura', 'K', 'Egendorf')
,(seq_author_uid.nextval, 'Jan', '', 'Grover')
,(seq_author_uid.nextval, 'Jennifer', '', 'Clapp')
,(seq_author_uid.nextval, 'Kathleen', '', 'Petelinsek');

select * from author;