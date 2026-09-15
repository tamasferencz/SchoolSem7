select *
  from dba_objects;

select *
  from dba_objects
 where data_object_id is not null;

select distinct object_type
  from dba_objects
 where data_object_id is not null
intersect
select distinct object_type
  from dba_objects
 where data_object_id is null;

select *
  from nikovits.emp;

select *
  from dba_tab_columns
 where owner = 'NIKOVITS'
   and table_name = 'EMP'
 order by column_id;

select *
  from user_tab_columns;

select count(*)
  from dba_tab_columns
 where owner = 'NIKOVITS'
   and table_name = 'EMP'
 order by column_id;

select max(column_id)
  from dba_tab_columns
 where owner = 'NIKOVITS'
   and table_name = 'EMP'
 order by column_id;

select data_type
  from dba_tab_columns
 where owner = 'NIKOVITS'
   and table_name = 'EMP'
   and column_id = 6;

select data_type,
       data_precision,
       data_scale
  from dba_tab_columns
 where owner = 'NIKOVITS'
   and table_name = 'EMP'
   and column_id = 6;


select data_type
       || '('
       || data_precision
       || ','
       || data_scale
       || ')' as datatypewithid6
  from dba_tab_columns
 where owner = 'NIKOVITS'
   and table_name = 'EMP'
   and column_id = 6;

select *
  from dba_tab_columns
 where column_name like 'Z%';

select distinct owner,
                table_name
  from dba_tab_columns
 where column_name like 'Z%';

select owner,
       table_name,
       count(*)
  from dba_tab_columns
 where data_type = 'DATE'
 group by owner,
          table_name
having count(*) >= 8;

select owner,
       table_name
  from dba_tab_columns
 where column_id = 1
   and data_type = 'VARCHAR2'
intersect
select owner,
       table_name
  from dba_tab_columns
 where column_id = 4
   and data_type = 'VARCHAR2';

select *
  from dba_synonyms;

create synonym ne for nikovits.emp;

select *
  from ne;

select *
  from user_synonyms;


create database link aramis_db
   connect to g0820e identified by g0820e
using 'aramis.inf.elte.hu:1521/aramis';

select *
  from aramis_db@nikovits.folyok;

select *
  from nikovits.vilag_orszagai;

select *
  from nikovits.folyok
 where nev = 'Mekong';

select *
  from nikovits.vilag_orszagai
 where tld = 'cm';