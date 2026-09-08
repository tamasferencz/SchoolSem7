-- gyak 1

create table gyak01
   as
      select table_name
        from all_tables
       where owner = 'NIKOVITS'
         and table_name like '%B%';

-- Tasks checker
select *
  from dba_objects
 where owner = 'G0820E';