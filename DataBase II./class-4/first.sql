select *
  from dba_data_files;

select *
  from dba_temp_files;

select file_name,
       file_id,
       tablespace_name,
       bytes,
       blocks
  from dba_data_files
union
select file_name,
       file_id,
       tablespace_name,
       bytes,
       blocks
  from dba_temp_files;

select *
  from dba_tablespaces;

select *
  from user_segments;
select *
  from all_segments;

select *
  from dba_segments;

select *
  from dba_segments
 where bytes = (
   select max(bytes)
     from dba_segments
);

select *
  from dba_extents;

select *
  from dba_extents
 where owner = 'MARJAI';

select *
  from dba_extents
 where segment_type = 'INDEX'
   and bytes = (
   select max(bytes)
     from dba_segments
    where segment_type = 'INDEX'
);

select *
  from user_tables;

select *
  from dba_tables;