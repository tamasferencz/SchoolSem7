create table q (
   a int
);

---

select *
  from user_objects;

select *
  from all_objects
 where owner = 'G0820E';

select count(*)
  from user_objects;

select count(*)
  from all_objects;

select count(*)
  from dba_objects;

---

create table "a b" (
   x int
);

select *
  from "a b";

---

select 1 + 1
  from dual;

create table dual (
   w int
);

insert into dual values
   ( - 1 );

delete from dual
 where rownum = 1;

select *
  from dual;

select 1 + 1
  from dual;

select *
  from sys.dual;

---

select distinct object_type
  from dba_objects;

select count(distinct object_type)
  from dba_objects;

select owner,
       count(distinct object_type)
  from dba_objects
 group by owner
having count(distinct object_type) > 10;


select distinct owner
  from dba_objects
 where object_type = 'VIEW';

select distinct owner
  from dba_objects
 where object_type = 'TRIGGER';


select distinct owner
  from dba_objects
 where object_type = 'VIEW'
intersect
select distinct owner
  from dba_objects
 where object_type = 'TRIGGER';


select distinct owner
  from dba_objects
 where object_type = 'VIEW'
minus
select distinct owner
  from dba_objects
 where object_type = 'TRIGGER';


select owner,
       count(*)
  from dba_objects
 where object_type = 'TABLE'
 group by owner
having count(*) > 20;

select owner,
       count(*)
  from dba_objects
 where object_type = 'INDEX'
 group by owner
having count(*) <= 15;

select owner
  from dba_objects
 where object_type = 'TABLE'
 group by owner
having count(*) > 20
intersect
select owner
  from dba_objects
 where object_type = 'INDEX'
 group by owner
having count(*) <= 15;

select owner
  from dba_objects
 where object_type = 'TABLE'
 group by owner
having count(*) > 20
minus
select owner
  from dba_objects
 where object_type = 'INDEX'
 group by owner
having count(*) > 15;