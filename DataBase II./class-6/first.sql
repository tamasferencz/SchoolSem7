select *
  from nikovits.emp;



select rownum,
       ename,
       job
  from nikovits.emp;


select rownum,*
  from nikovits.emp;



select rownum,
       emp.*
  from nikovits.emp;





select rowid,
       emp.*
  from nikovits.emp;




select substr(
   rowid,
   1,
   6
) objektum,
       substr(
          rowid,
          7,
          3
       ) "file",
       substr(
          rowid,
          10,
          6
       ) blokk,
       substr(
          rowid,
          16,
          3
       ) sor,
       emp.*
  from nikovits.emp;



select *
  from dba_objects
 where object_name = 'EMP'
   and owner = 'NIKOVITS';



select *
  from dba_data_files
 where file_id = 2;




select dbms_rowid.rowid_object(rowid) "objektum azonosito",
       dbms_rowid.rowid_relative_fno(rowid) "fajl azonosito",
       dbms_rowid.rowid_block_number(rowid) "blokk azonosito",
       dbms_rowid.rowid_row_number(rowid) sorszám,
       emp.*
  from nikovits.emp;

       -- A NIKOVITS felhasználó CIKK táblája hány blokkot foglal le az adatbázisban? (blokkszám)
-- (Vagyis hány olyan blokk van, ami ennek a táblának a szegmenséhez tartozik és így már 
-- más táblához nem rendelhető hozzá?)
select *
  from nikovits.cikk;
select count(*)
  from nikovits.cikk;




select blocks
  from dba_segments
 where owner = 'NIKOVITS'
   and segment_name = 'CIKK'
   and segment_type = 'TABLE';



select *
  from dba_extents
 where owner = 'NIKOVITS'
   and segment_name = 'CIKK'
   and segment_type = 'TABLE';



select blocks,
       bytes
  from dba_extents
 where owner = 'BRANYI'
   and segment_name = 'NESZE'
   and segment_type = 'TABLE';

select *
  from dba_segments
 where owner = 'BRANYI'
   and segment_name = 'NESZE'
   and segment_type = 'TABLE';

select sum(blocks),
       sum(bytes)
  from dba_extents
 where owner = 'BRANYI'
   and segment_name = 'NESZE'
   and segment_type = 'TABLE';



-- A NIKOVITS felhasználó CIKK táblájának adatai hány blokkban helyezkednek el? (blokkszám)
-- (Vagyis a tábla sorai ténylegesen hány blokkban vannak tárolva?)
-- !!! -> Ez a kérdés nem ugyanaz mint az előző, mert a tábla blokkjai lehetnek üresek is.
select *
  from nikovits.cikk;



select substr(
   rowid,
   1,
   15
),
       cikk.*
  from nikovits.cikk;




select distinct substr(
   rowid,
   1,
   15
)
  from nikovits.cikk;




select count(distinct substr(
   rowid,
   1,
   15
))
  from nikovits.cikk;




-- Az egyes blokkokban hány sor van? (file_id, blokk_id, darab)

select rowid,
       cikk.*
  from nikovits.cikk;


-- mi a baj ezzel?
select substr(
   rowid,
   10,
   6
),
       count(*)
  from nikovits.cikk
 group by substr(
   rowid,
   10,
   6
)
 order by 1;

select substr(
   rowid,
   10,
   6
),
       cikk.*
  from nikovits.cikk;



select *
  from dba_extents
 where owner = 'BRANYI'
   and segment_name = 'NESZE'
   and segment_type = 'TABLE';

select substr(
   rowid,
   10,
   6
),
       count(*)
  from branyi.nesze
 group by substr(
   rowid,
   10,
   6
)
 order by 1;


select *
  from dba_data_files;

select substr(
   rowid,
   1,
   15
),
       count(*)
  from nikovits.cikk
 group by substr(
   rowid,
   1,
   15
)
 order by 1;

select substr(
   rowid,
   1,
   15
),
       cikk.*
  from nikovits.cikk;

select *
  from dba_extents
 where owner = 'BRANYI'
   and segment_name = 'NESZE';



-- Hozzunk létre egy táblát az EXAMPLE táblatéren, amelynek szerkezete azonos a nikovits.cikk 
-- tábláéval és pontosan 128 KB helyet foglal az adatbázisban. Foglaljunk le manuálisan további 
-- 128 KB helyet a táblához. Vigyünk fel sorokat addig, amig az első blokk tele nem 
-- lesz, és 1 további sora lesz még a táblának a második blokkban.
-- (A felvitelt plsql programmal végezzük és ne kézzel, mert úgy kicsit sokáig tartana.)

select *
  from nikovits.cikk;
select *
  from dba_objects
 where owner = 'NIKOVITS'
   and object_name = 'CIKK';
select *
  from dba_tables
 where owner = 'NIKOVITS'
   and table_name = 'CIKK';


-- Hozzunk létre egy táblát, melynek szerkezete azonos a nikovits.cikk tábláéval
drop table ujcikk;




create table ujcikk
   as
      select *
        from nikovits.cikk;
select *
  from ujcikk;



drop table ujcikk;
create table ujcikk
   as
      select *
        from nikovits.cikk
       where 0 = 1;
select *
  from ujcikk;


select *
  from dba_tables
 where owner = 'BRANYI'
   and table_name = 'UJCIKK';

-- Hozzunk létre egy táblát az EXAMPLE táblatéren, amelynek szerkezete azonos a nikovits.cikk 
-- tábláéval
drop table ujcikk;

create table ujcikk
tablespace example
   as
      select *
        from nikovits.cikk
       where 0 = 1;

select *
  from dba_tables
 where owner = 'BRANYI'
   and table_name = 'UJCIKK';
select *
  from dba_segments
 where owner = 'BRANYI'
   and segment_name = 'UJCIKK';


-- Hozzunk létre egy táblát az EXAMPLE táblatéren, amelynek szerkezete azonos a nikovits.cikk 
-- tábláéval és pontosan 128 KB helyet foglal az adatbázisban.
drop table ujcikk;
create table ujcikk
tablespace example
      storage ( initial 128K )
   as
      select *
        from nikovits.cikk
       where 0 = 1;

select *
  from dba_tables
 where owner = 'BRANYI'
   and table_name = 'UJCIKK';
select *
  from dba_segments
 where owner = 'BRANYI'
   and segment_name = 'UJCIKK';


-- Foglaljunk le manuálisan további 128 KB helyet a táblához.

alter table ujcikk allocate extent ( size 128K );

select *
  from dba_tables
 where owner = 'BRANYI'
   and table_name = 'UJCIKK';
select *
  from dba_segments
 where owner = 'BRANYI'
   and segment_name = 'UJCIKK';
select *
  from ujcikk;

-- Vigyünk fel sorokat addig, amig az első blokk tele nem lesz,
-- és 1 további sora lesz még a táblának a második blokkban.
-- (A felvitelt plsql programmal végezzük és ne kézzel, mert úgy kicsit sokáig tartana.)
select *
  from nikovits.cikk;
select count(distinct substr(
   rowid,
   1,
   15
))
  from ujcikk;

/
declare
   x number;
begin
   for i in 1..1000 loop
      insert into ujcikk
         select *
           from nikovits.cikk
          where i = ckod;
      select count(distinct substr(
         rowid,
         1,
         15
      ))
        into x
        from ujcikk;
      exit when x > 1;  -- if x>1 then exit; end if;
   end loop;
   commit;
end;
/
select substr(
   rowid,
   1,
   15
),
       count(*)
  from ujcikk
 group by substr(
   rowid,
   1,
   15
);





drop table ujcikk;
create table ujcikk
tablespace example
   storage ( initial 128K )
   pctfree 10 as
      select *
        from nikovits.cikk
       where 0 = 1;
/

declare
   x number;
begin
   for i in 1..1000 loop
      insert into ujcikk
         select *
           from nikovits.cikk
          where i = ckod;
      select count(distinct substr(
         rowid,
         1,
         15
      ))
        into x
        from ujcikk;
      exit when x > 1;
   end loop;
   commit;
end;
/
select substr(
   rowid,
   1,
   15
),
       count(*)
  from ujcikk
 group by substr(
   rowid,
   1,
   15
);
desc ujcikk
select *
  from ujcikk;

delete ujcikk
 where ckod = 1;
select substr(
   rowid,
   1,
   15
),
       count(*)
  from ujcikk
 group by substr(
   rowid,
   1,
   15
);

insert into ujcikk values
   ( 1,
     'x',
     'szin',
     2 );
select substr(
   rowid,
   1,
   15
),
       count(*)
  from ujcikk
 group by substr(
   rowid,
   1,
   15
);

delete ujcikk
 where ckod <= 50;
select substr(
   rowid,
   1,
   15
),
       count(*)
  from ujcikk
 group by substr(
   rowid,
   1,
   15
);

insert into ujcikk values
   ( 1,
     'x',
     'szin',
     2 );
select substr(
   rowid,
   1,
   15
),
       count(*)
  from ujcikk
 group by substr(
   rowid,
   1,
   15
);
select *
  from ujcikk;

delete ujcikk
 where ckod <= 100;
select substr(
   rowid,
   1,
   15
),
       count(*)
  from ujcikk
 group by substr(
   rowid,
   1,
   15
);
insert into ujcikk values
   ( 1,
     'x',
     'szin',
     2 );
select substr(
   rowid,
   1,
   15
),
       count(*)
  from ujcikk
 group by substr(
   rowid,
   1,
   15
);


drop table ujcikk;
create table ujcikk
tablespace example
   storage ( initial 128K )
pctfree 10
   pctused 40 as
      select *
        from nikovits.cikk
       where 0 = 1;
/

declare
   x number;
begin
   for i in 1..1000 loop
      insert into ujcikk
         select *
           from nikovits.cikk
          where i = ckod;
      select count(distinct substr(
         rowid,
         1,
         15
      ))
        into x
        from ujcikk;
      exit when x > 1;
   end loop;
   commit;
end;
/
select substr(
   rowid,
   1,
   15
),
       count(*)
  from ujcikk
 group by substr(
   rowid,
   1,
   15
);

delete ujcikk
 where ckod = 1;
select substr(
   rowid,
   1,
   15
),
       count(*)
  from ujcikk
 group by substr(
   rowid,
   1,
   15
);

insert into ujcikk values
   ( 1,
     'x',
     'szin',
     2 );
select substr(
   rowid,
   1,
   15
),
       count(*)
  from ujcikk
 group by substr(
   rowid,
   1,
   15
);

delete ujcikk
 where ckod <= 50;
select substr(
   rowid,
   1,
   15
),
       count(*)
  from ujcikk
 group by substr(
   rowid,
   1,
   15
);

insert into ujcikk values
   ( 1,
     'x',
     'szin',
     2 );
select substr(
   rowid,
   1,
   15
),
       count(*)
  from ujcikk
 group by substr(
   rowid,
   1,
   15
);
select *
  from ujcikk;

delete ujcikk
 where ckod <= 100;
select substr(
   rowid,
   1,
   15
),
       count(*)
  from ujcikk
 group by substr(
   rowid,
   1,
   15
);

insert into ujcikk values
   ( 1,
     'x',
     'szin',
     2 );
select substr(
   rowid,
   1,
   15
),
       count(*)
  from ujcikk
 group by substr(
   rowid,
   1,
   15
);

drop table ujcikk;


-- ------------------------------------------------------------------------
-- Oracle indexek  
-- ------------
-- (DBA_INDEXES, DBA_IND_COLUMNS, DBA_IND_EXPRESSIONS)

drop index emp1;
drop index emp2;
drop index emp3;
drop index emp4;
drop index emp5;
drop index emp6;
drop index emp7;
drop index emp8;
drop index emp9;
drop index emp10;

select *
  from emp;

create index emp1 on
   emp (
      empno
   );
select empno szempont,
       rowid,
       emp.*
  from emp
 order by empno;

create index emp2 on
   emp (
      job,
      ename
   );
select job szempont1,
       ename szempont2,
       rowid,
       emp.*
  from emp
 order by job,
          ename;

create index emp3 on
   emp (
      sal,
      job,
      ename
   );
select sal szempont1,
       job szempont2,
       ename szempont3,
       rowid,
       emp.*
  from emp
 order by sal,
          job,
          ename;

create index emp4 on
   emp (
      sal,
      job,
      ename
   desc );
select sal szempont1,
       job szempont2,
       ename szempont3,
       rowid,
       emp.*
  from emp
 order by sal,
          job,
          ename desc;

insert into emp values
   ( 9000,
     null,
     null,
     null,
     null,
     3000,
     null,
     50 );
select *
  from emp;
desc emp

insert into emp values
   ( 9000,
     'PROBA',
     null,
     null,
     null,
     null,
     null,
     50 );

select *
  from emp;

delete from emp
 where empno = 9000;

create unique index emp5 on
   emp (
      ename
   );

insert into emp values
   ( 9000,
     'PROBA',
     null,
     null,
     null,
     null,
     null,
     50 );

select *
  from emp;

insert into emp values
   ( 9000,
     null,
     null,
     null,
     null,
     null,
     null,
     50 );


select *
  from emp;

create bitmap index emp6 on
   emp (
      deptno
   );

create index emp7 on
   emp (
      empno,
      sal
   )
      reverse;

create index emp8 on
   emp (
      empno,
      ename,
      sal
   )
      compress 2;

create index emp9 on
   emp ( substr(
      ename,
      2,
      2
   ) );
select substr(
   ename,
   2,
   2
),
       rowid,
       emp.*
  from emp
 order by substr(
   ename,
   2,
   2
);

create index emp10 on
   emp ( substr(
      ename,
      2,
      2
   ),
      hiredate
   desc );
select substr(
   ename,
   2,
   2
),
       hiredate y,
       rowid,
       emp.*
  from emp
 order by substr(
   ename,
   2,
   2
),
          hiredate desc;


select *
  from dba_indexes;
select *
  from user_indexes;

select *
  from dba_ind_columns;
select *
  from user_ind_columns;

select *
  from dba_ind_expressions;
select *
  from user_ind_expressions;