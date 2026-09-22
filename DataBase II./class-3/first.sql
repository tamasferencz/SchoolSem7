create database link aramis_db
   connect to g0820e identified by g0820e
using 'aramis.inf.elte.hu:1521/aramis';

select *
  from nikovits.folyok@aramis_db;

select *
  from nfa;

create sequence szamol start with 15 increment by 3 nocycle;

select szamol
  from dual;

select szamol.currval
  from dual;

select szamol.nextval
  from dual;


create table proba (
   id int,
   x  varchar(20)
);

insert into proba values
   ( szamol.nextval,
     'elso' );

select *
  from proba;

insert into proba values
   ( szamol.nextval,
     'masodik' );

insert into proba values
   ( szamol.currval,
     'masodik2' );


select *
  from user_sequences;

select *
  from all_sequences;

  -- Az emp, dept és sz TÁBLÁK KÖZVETLEN LÉTREHOZÁSA --

drop table emp;
drop table dept;

create table dept (
   deptno number(2) not null,
   dname  varchar2(14),
   loc    varchar2(13)
);

insert into dept values
   ( 10,
     'ACCOUNTING',
     'NEW YORK' );
insert into dept values
   ( 20,
     'RESEARCH',
     'DALLAS' );
insert into dept values
   ( 30,
     'SALES',
     'CHICAGO' );
insert into dept values
   ( 40,
     'OPERATIONS',
     'BOSTON' );

alter session set nls_date_language = english;
alter session set nls_date_format = 'DD-MON-YYYY';

create table emp (
   empno    number(4) not null,
   ename    varchar2(10),
   job      varchar2(9),
   mgr      number(4),
   hiredate date,
   sal      number(7,2),
   comm     number(7,2),
   deptno   number(2) not null
);

insert into emp values
   ( 7839,
     'KING',
     'PRESIDENT',
     null,
     '17-NOV-1981',
     5000,
     null,
     10 );
insert into emp values
   ( 7698,
     'BLAKE',
     'MANAGER',
     7839,
     '1-MAY-1981',
     2850,
     null,
     30 );
insert into emp values
   ( 7782,
     'CLARK',
     'MANAGER',
     7839,
     '9-JUN-1981',
     2450,
     null,
     10 );
insert into emp values
   ( 7566,
     'JONES',
     'MANAGER',
     7839,
     '2-APR-1981',
     2975,
     null,
     20 );
insert into emp values
   ( 7654,
     'MARTIN',
     'SALESMAN',
     7698,
     '28-SEP-1981',
     1250,
     1400,
     30 );
insert into emp values
   ( 7499,
     'ALLEN',
     'SALESMAN',
     7698,
     '20-FEB-1981',
     1600,
     300,
     30 );
insert into emp values
   ( 7844,
     'TURNER',
     'SALESMAN',
     7698,
     '8-SEP-1981',
     1500,
     0,
     30 );
insert into emp values
   ( 7900,
     'JAMES',
     'CLERK',
     7698,
     '3-DEC-1981',
     950,
     null,
     30 );
insert into emp values
   ( 7521,
     'WARD',
     'SALESMAN',
     7698,
     '22-FEB-1981',
     1250,
     500,
     30 );
insert into emp values
   ( 7902,
     'FORD',
     'ANALYST',
     7566,
     '3-DEC-1981',
     3000,
     null,
     20 );
insert into emp values
   ( 7369,
     'SMITH',
     'CLERK',
     7902,
     '17-DEC-1980',
     800,
     null,
     20 );
insert into emp values
   ( 7788,
     'SCOTT',
     'ANALYST',
     7566,
     '09-DEC-1982',
     3000,
     null,
     20 );
insert into emp values
   ( 7876,
     'ADAMS',
     'CLERK',
     7788,
     '12-JAN-1983',
     1100,
     null,
     20 );
insert into emp values
   ( 7934,
     'MILLER',
     'CLERK',
     7782,
     '23-JAN-1982',
     1300,
     null,
     10 );
insert into emp values
   ( 8000,
     'PROBA',
     'DOLGOZO',
     null,
     '27-NOV-1980',
     6000,
     null,
     50 );

alter session set nls_date_language = hungarian;
alter session set nls_date_format = 'YYYY-MON-DD';

grant select on dept to public;
grant select on emp to public;

select *
  from emp;
select *
  from dept;


  ----

drop table sz;
create table sz (
   n  varchar2(15),
   gy varchar2(15)
);

insert into sz values
   ( 'Füles',
     'málna' );
insert into sz values
   ( 'Füles',
     'körte' );
insert into sz values
   ( 'Füles',
     'alma' );
insert into sz values
   ( 'Micimackó',
     'málna' );
insert into sz values
   ( 'Micimackó',
     'körte' );
insert into sz values
   ( 'Micimackó',
     'dió' );
insert into sz values
   ( 'Kanga',
     'körte' );
insert into sz values
   ( 'Nyuszi',
     'eper' );
insert into sz values
   ( 'Malacka',
     'körte' );
insert into sz values
   ( 'Malacka',
     'alma' );
insert into sz values
   ( 'Malacka',
     'eper' );
insert into sz values
   ( 'Malacka',
     'málna' );
insert into sz values
   ( 'Malacka',
     'dió' );
insert into sz values
   ( 'Tigris',
     'körte' );
insert into sz values
   ( 'Tigris',
     'málna' );

drop table szm;
create table szm (
   n  varchar2(15),
   gy varchar2(15),
   m  number(2)
);

insert into szm values
   ( 'Füles',
     'málna',
     6 );
insert into szm values
   ( 'Füles',
     'körte',
     9 );
insert into szm values
   ( 'Füles',
     'alma',
     7 );
insert into szm values
   ( 'Micimackó',
     'málna',
     10 );
insert into szm values
   ( 'Micimackó',
     'körte',
     4 );
insert into szm values
   ( 'Micimackó',
     'dió',
     2 );
insert into szm values
   ( 'Kanga',
     'körte',
     10 );
insert into szm values
   ( 'Nyuszi',
     'eper',
     6 );
insert into szm values
   ( 'Malacka',
     'körte',
     5 );
insert into szm values
   ( 'Malacka',
     'alma',
     7 );
insert into szm values
   ( 'Malacka',
     'eper',
     3 );
insert into szm values
   ( 'Malacka',
     'málna',
     2 );
insert into szm values
   ( 'Malacka',
     'dió',
     5 );
insert into szm values
   ( 'Tigris',
     'körte',
     7 );
insert into szm values
   ( 'Tigris',
     'málna',
     3 );

-- Az emp, dept és sz struktúrájának lekérdezése

select *
  from emp;
select *
  from dept;
select *
  from sz;
select *
  from szm;


select *
  from user_views;

select *
  from dba_views;


  