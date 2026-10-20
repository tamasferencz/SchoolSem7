-- Partícionálással kapcsolatos katalógusok (adatszótár nézetek):
-- (DBA_PART_TABLES, DBA_PART_INDEXES, DBA_TAB_PARTITIONS, DBA_IND_PARTITIONS, 
--  DBA_TAB_SUBPARTITIONS, DBA_IND_SUBPARTITIONS, DBA_PART_KEY_COLUMNS, DBA_SUBPART_KEY_COLUMNS)

drop table eladasok1;
drop table eladasok2;
drop table eladasok3;
drop table eladasok4;
drop table eladasok5;

-- Particionálás tartományok alapján
create table eladasok1 (
   szla_szam number(5),
   szla_nev  char(30),
   mennyiseg number(6),
   het       integer
)
   partition by range (
      het
   )
   ( partition negyedev1
      values less than ( 13 )
   segment creation immediate
      storage ( initial 8K next 8K )
   tablespace users,
   partition negyedev2
      values less than ( 26 )
   segment creation immediate
      storage ( initial 8K next 8K )
   tablespace example,
   partition negyedev3
      values less than ( 39 )
   segment creation immediate
      storage ( initial 8K next 8K )
   tablespace users );

insert into eladasok1 values
   ( 100,
     'Sport cikkek',
     231,
     2 );
insert into eladasok1 values
   ( 101,
     'Irodai termekek',
     1200,
     3 );
insert into eladasok1 values
   ( 102,
     'Eszkozok',
     43,
     4 );
insert into eladasok1 values
   ( 103,
     'Gepek',
     21,
     6 );
insert into eladasok1 values
   ( 104,
     'Butorok',
     31,
     7 );
insert into eladasok1 values
   ( 105,
     'Ingatlan',
     3,
     8 );
insert into eladasok1 values
   ( 106,
     'Szolgaltatasok',
     200,
     9 );
insert into eladasok1 values
   ( 107,
     'Elelmiszer',
     300,
     39 ); -- ezt már nem tudja beszúrni, 40 > 39 
select *
  from eladasok1;
-- Particionálás hash kulcs alapján
create table eladasok2 (
   szla_szam number(5),
   szla_nev  char(30),
   mennyiseg number(6),
   het       integer
)
   partition by hash ( het ) ( partition part1 segment creation immediate tablespace users,
   partition part2 segment creation immediate tablespace example,
   partition part3 segment creation immediate tablespace users );
insert into eladasok2 values
   ( 100,
     'Sport cikkek',
     231,
     2 );
insert into eladasok2 values
   ( 101,
     'Irodai termekek',
     1200,
     3 );
insert into eladasok2 values
   ( 102,
     'Eszkozok',
     43,
     4 );
insert into eladasok2 values
   ( 103,
     'Gepek',
     21,
     6 );
insert into eladasok2 values
   ( 104,
     'Butorok',
     31,
     7 );
insert into eladasok2 values
   ( 105,
     'Ingatlan',
     3,
     8 );
insert into eladasok2 values
   ( 106,
     'Szolgaltatasok',
     200,
     9 );
insert into eladasok2 values
   ( 107,
     'Elelmiszer',
     300,
     40 );
select *
  from eladasok2;
select rowid,
       eladasok2.*
  from eladasok2;
-- Particionálás lista alapján
create table eladasok3 (
   szla_szam number(5),
   szla_nev  char(30),
   mennyiseg number(6),
   het       integer
)
   partition by list ( het ) ( partition part1 values ( 1,
                                                        2,
                                                        3,
                                                        4,
                                                        5 ) segment creation immediate
      storage ( initial 8K next 8K )
   tablespace users,
      partition part2 values ( 6,
                               7,
                               8,
                               9 ) segment creation immediate
         storage ( initial 8K next 8K )
      tablespace example,
      partition part3 values ( 10,
                               11,
                               12,
                               13 ) segment creation immediate
         storage ( initial 8K next 8K )
      tablespace users
   ) -- ide sem tud beszúrni > 13-at
   ;
insert into eladasok3
   select *
     from eladasok2;
select *
  from eladasok3;
insert into eladasok3 values
   ( 100,
     'Sport cikkek',
     231,
     2 );
insert into eladasok3 values
   ( 101,
     'Irodai termekek',
     1200,
     3 );
insert into eladasok3 values
   ( 102,
     'Eszkozok',
     43,
     4 );
insert into eladasok3 values
   ( 103,
     'Gepek',
     21,
     6 );
insert into eladasok3 values
   ( 104,
     'Butorok',
     31,
     7 );
insert into eladasok3 values
   ( 105,
     'Ingatlan',
     3,
     8 );
insert into eladasok3 values
   ( 106,
     'Szolgaltatasok',
     200,
     9 );
insert into eladasok3 values
   ( 107,
     'Elelmiszer',
     300,
     40 );
select *
  from eladasok3;
-- Alparticiók létrehozása partición belül (range-en belül hash)
create table eladasok4 (
   szla_szam number(5),
   szla_nev  char(30),
   mennyiseg number(6),
   het       integer
)
   partition by range ( het )
      subpartition by hash ( mennyiseg ) subpartitions 3
   ( partition negyedev1
      values less than ( 13 )
   segment creation immediate
      storage ( initial 8K next 8K )
   tablespace users,partition negyedev2
      values less than ( 26 )
   segment creation immediate
      storage ( initial 8K next 8K )
   tablespace example,partition negyedev3
      values less than ( 39 )
   segment creation immediate
      storage ( initial 8K next 8K )
   tablespace users );

insert into eladasok4
   select *
     from eladasok2;
select *
  from eladasok4;
insert into eladasok4
   select *
     from eladasok1;
select *
  from eladasok4;

-- Range-list alparticiók létrehozása minta alapján. Ez akkor hasznos ha nagyon sok
-- partíció lenne, és így nem kell őket egyesével felsorolni
-- mintára vonatkozó infók: DBA_SUBPARTITION_TEMPLATES
create table eladasok5 (
   szla_szam number(5),
   szla_nev  char(30),
   mennyiseg number(6),
   het       integer
)
   partition by range ( mennyiseg ) subpartition by list ( het )
      subpartition template (
         subpartition lista values ( 1,
                                     2,
                                     3,
                                     4,
                                     5 ),
            subpartition other values ( default )
      )
   ( partition kicsi
      values less than ( 100 )
   segment creation immediate
      storage ( initial 8K next 8K )
   tablespace users,partition kozepes
      values less than ( 500 )
   segment creation immediate
      storage ( initial 8K next 8K )
   tablespace example,partition nagy
      values less than ( maxvalue )
   segment creation immediate
      storage ( initial 8K next 8K )
   tablespace users );
insert into eladasok5
   select *
     from eladasok2;
insert into eladasok5 values
   ( 100,
     'Sport cikkek',
     231,
     2 );
insert into eladasok5 values
   ( 101,
     'Irodai termekek',
     121200,
     3 );
insert into eladasok5 values
   ( 102,
     'Eszkozok',
     43,
     4 );
insert into eladasok5 values
   ( 103,
     'Gepek',
     21,
     6 );
insert into eladasok5 values
   ( 104,
     'Butorok',
     - 31,
     7 );
insert into eladasok5 values
   ( 105,
     'Ingatlan',
     3,
     8 );
insert into eladasok5 values
   ( 106,
     'Szolgaltatasok',
     200,
     9 );
insert into eladasok5 values
   ( 106,
     'Szolgaltatasok',
     200,
     19 );
insert into eladasok5 values
   ( 107,
     'Elelmiszer',
     300,
     40 );

select *
  from user_part_tables;
select *
  from dba_part_tables;

select *
  from user_tab_partitions;
select *
  from dba_tab_partitions;

select *
  from user_tab_subpartitions;
select *
  from dba_tab_subpartitions;

select *
  from user_part_key_columns;

select *
  from user_subpart_key_columns;

select *
  from user_segments;

select *
  from user_tables
 where table_name = 'ELADASOK5';



select *
  from user_segments;

select sum(darab)
  from nikovits.hivas,
       nikovits.kozpont,
       nikovits.primer
 where hivas.kozp_azon_hivo = kozpont.kozp_azon
   and kozpont.primer = primer.korzet
   and primer.varos = 'Szentendre'
   and datum + 1 = next_day(
   to_date('2012.01.31',
         'yyyy.mm.dd'),
   'hétfő'
);

select sum(darab)
  from nikovits.hivas,
       nikovits.kozpont,
       nikovits.primer
 where hivas.kozp_azon_hivo = kozpont.kozp_azon
   and kozpont.primer = primer.korzet
   and primer.varos = 'Szentendre'
   and datum = next_day(
   to_date('2012.01.31',
         'yyyy.mm.dd'),
   'hétfő'
) - 1;



select count(*)
  from nikovits.hivas,
       nikovits.kozpont,
       nikovits.primer;


select *
  from dba_part_tables
 where owner = 'SH';

select partition_name,
       blocks
  from dba_tab_partitions
 where table_owner = 'SH'
   and table_name = 'COSTS';

select count(*)
  from sh.sales;

select segment_name,
       partition_name,
       blocks
  from dba_segments
 where owner = 'SH'
   and segment_type = 'TABLE PARTITION'
   and segment_name = 'COSTS';

select partition_name,
       partition_position pos,
       high_value,
       partition_position
  from dba_tab_partitions
 where ( table_owner = 'NIKOVITS'
   and table_name = 'ELADASOK3'
    or table_owner = 'SH'
   and table_name = 'COSTS' )
   and partition_position = 2;


commit;
select *
  from eladasok5;
/****

A fenti táblákra vonatkozó információk az adatszótár nézetekben:
----------------------------------------------------------------
*/
select table_name,
       partitioning_type,
       subpartitioning_type,
       partition_count,
       def_subpartition_count
  from dba_part_tables
 where owner = 'NIKOVITS';
/*
t_name         p_type  sub_type  p_count sub_count
--------------------------------------------------
ELADASOK	RANGE	NONE	  3	  0
ELADASOK2	HASH	NONE	  3	  0
ELADASOK3	LIST	NONE	  3	  0
ELADASOK4	RANGE	HASH	  3	  3
ELADASOK5	RANGE	LIST	  3	  2

*/
select table_name,
       partition_position,
       partition_name,
       composite,
       subpartition_count,
       high_value
  from dba_tab_partitions
 where table_owner = 'NIKOVITS'
 order by 1,
          2;
/*
t_name      pos   p_name       comp   sub_c  high_value
-------------------------------------------------------
ELADASOK     1    NEGYEDEV1      NO     0    13
ELADASOK     2    NEGYEDEV2      NO     0    26
ELADASOK     3    NEGYEDEV3      NO     0    39
ELADASOK2    1    PART1          NO     0    null
ELADASOK2    2    PART2	         NO     0    null
ELADASOK2    3    PART3	         NO     0    null
ELADASOK3    1    PART1	         NO     0    1, 2, 3, 4, 5
ELADASOK3    2    PART2	         NO     0    6, 7, 8, 9
ELADASOK3    3    PART3	         NO     0    10, 11, 12, 13
ELADASOK4    1    NEGYEDEV1	 YES    3    13
ELADASOK4    2    NEGYEDEV2	 YES    3    26
ELADASOK4    3    NEGYEDEV3	 YES    3    39
ELADASOK5    1    KICSI	         YES    2    100
ELADASOK5    2    KOZEPES        YES    2    500
ELADASOK5    3    NAGY	         YES    2    MAXVALUE

*/
select table_name,
       partition_name,
       subpartition_position,
       subpartition_name,
       high_value
  from dba_tab_subpartitions
 where table_owner = 'NIKOVITS';
/*
t-name          p_name  pos    subp_name       high_value
-------------------------------------------------------------
ELADASOK5      KICSI    1      KICSI_LISTA     1, 2, 3, 4, 5
ELADASOK5      KICSI    2      KICSI_OTHER     DEFAULT
ELADASOK5      KOZEPES  1      KOZEPES_LISTA   1, 2, 3, 4, 5
ELADASOK5      KOZEPES  2      KOZEPES_OTHER   DEFAULT
ELADASOK5      NAGY     1      NAGY_LISTA      1, 2, 3, 4, 5
ELADASOK5      NAGY     2      NAGY_OTHER      DEFAULT
*/

select name,
       column_name,
       column_position
  from dba_part_key_columns
 where owner = 'NIKOVITS';
/*
name        col        pos 
--------------------------
ELADASOK    HET        1
ELADASOK2   HET        1
ELADASOK3   HET        1
ELADASOK4   HET        1
ELADASOK5   MENNYISEG  1
*/
select name,
       column_name,
       column_position
  from dba_subpart_key_columns
 where owner = 'NIKOVITS';
/*
name        col        pos 
--------------------------
ELADASOK4   MENNYISEG  1
ELADASOK5   HET        1

A szegmens neve megegyezik a tábla nevével, a tényleges adatobjektumok
pedig a partíciók illetve alpartíciók lesznek: 
*/
select segment_name,
       partition_name,
       segment_type
  from dba_segments
 where owner = 'NIKOVITS';

select *
  from dba_tables
 where owner = 'NIKOVITS';
/*
segment_name   partition_name   segment_type
--------------------------------------------------
ELADASOK5      KICSI_LISTA      TABLE SUBPARTITION
ELADASOK5      KICSI_OTHER      TABLE SUBPARTITION
ELADASOK5      KOZEPES_LISTA    TABLE SUBPARTITION
ELADASOK5      KOZEPES_OTHER    TABLE SUBPARTITION
ELADASOK5      NAGY_LISTA       TABLE SUBPARTITION
ELADASOK5      NAGY_OTHER       TABLE SUBPARTITION


-- Információk a clusterekről a katalógusban (adatszótár nézetekben): 
-- DBA_CLUSTERS 
-- DBA_TABLES (cluster_name oszlop -> melyik klaszteren van a tábla) 
-- DBA_CLU_COLUMNS (táblák oszlopainak megfeleltetése a klaszter kulcsának)
-- DBA_CLUSTER_HASH_EXPRESSIONS (hash klaszterek hash függvényei)
*/
select *
  from emp
natural join nikovits.dept;

drop table emp_clt;
drop table dept_clt;
drop cluster personnel_cl;
drop table cikk_hclt;
drop table szallit_hclt;
drop cluster cikk_hcl;
drop table cikk_hcl2t;
drop cluster cikk_hcl2;
drop cluster cikk_hcl3;

-- Cluster létrehozása (index cluster lesz):
create cluster personnel_cl ( department_number number(2) ) size 4K;

-- Táblák létrehozása a clusteren:
create table emp_clt (
   empno    number primary key,
   ename    varchar2(30),
   job      varchar2(27),
   mgr      number(4),
   hiredate date,
   sal      number(7,2),
   comm     number(7,2),
   deptno   number(2) not null
)
cluster personnel_cl ( deptno );

create table dept_clt (
   deptno number(2),
   dname  varchar2(42),
   loc    varchar2(39)
)
cluster personnel_cl ( deptno );

-- Index létrehozása (csak ezután lehet sorokat beszúrni):
create index personnel_cl_idx on cluster personnel_cl;
insert into emp_clt
   select *
     from nikovits.emp;
insert into dept_clt
   select *
     from nikovits.dept;
select *
  from emp_clt;
select *
  from dept_clt;
select *
  from emp_clt
natural join dept_clt;
/*******
A fentiek után nézzük meg az alábbi lekérdezés eredményét. Láthatjuk, hogy
egy osztálybeli sornak és egy dolgozóbeli sornak ugyanaz a ROWID-je.
*/
select rowid,
       ename ename_dname
  from emp_clt
 where deptno = 20
union
select rowid,
       dname
  from dept_clt
 where deptno = 20;
/*
rowid                ename_dname
--------------------------------
AAB7goAAEAAAPG9AAA   ACCOUNTING
AAB7goAAEAAAPG9AAA   CLARK
AAB7goAAEAAAPG9AAB   KING
AAB7goAAEAAAPG9AAC   MILLER
********/


-- Létrehozunk egy hash clustert (HASHKEYS kulcsszó miatt lesz hash cluster !!!) és rajta két táblát:

create cluster cikk_hcl ( ckod number ) size 4K hashkeys 30;
create table cikk_hclt (
   ckod number,
   cnev varchar2(20),
   szin varchar2(15),
   suly float
)
cluster cikk_hcl ( ckod );
insert into cikk_hclt
   select *
     from cikk;
create table szallit_hclt (
   szkod     number,
   ckod      number,
   pkod      number,
   mennyiseg number,
   datum     date
)
cluster cikk_hcl ( ckod );
insert into szallit_hclt
   select *
     from szallit;

-- Saját hash függvényt adunk meg:

create cluster cikk_hcl2 ( ckod number ) hashkeys 30 hash is mod(
   ckod,
   53
);
create table cikk_hcl2t (
   ckod number,
   cnev varchar2(20),
   szin varchar2(15),
   suly float
)
cluster cikk_hcl2 ( ckod );
insert into cikk_hcl2t
   select *
     from cikk;

create cluster cikk_hcl3 ( ckod number ) single table hashkeys 30;


/**************
Információk az adatszótárból:
*/
select cluster_name,
       cluster_type,
       function,
       hashkeys,
       single_table
  from dba_clusters
 where owner = 'NIKOVITS';
/*
cl_name        type    function        keys  single
---------------------------------------------------
CIKK_HCL       HASH    DEFAULT2         31    N
CIKK_HCL2      HASH    HASH EXPRESSION  31    N
CIKK_HCL3      HASH    DEFAULT2         31    Y
PERSONNEL_CL   INDEX   null              0    N
*/

select cluster_name,
       table_name
  from dba_tables
 where owner = 'NIKOVITS'
   and cluster_name is not null
 order by 1,
          2;
/*
cl_name       t_name
--------------------------
CIKK_HCL      CIKK_HCLT
CIKK_HCL      SZALLIT_HCLT
CIKK_HCL2     CIKK_HCL2T
PERSONNEL_CL  DEPT_CLT
PERSONNEL_CL  EMP_CLT
*/

select cluster_name,
       clu_column_name,
       table_name,
       tab_column_name
  from dba_clu_columns
 where owner = 'NIKOVITS';
/*
cl_name       cl_col             t_name        tab_col 
------------------------------------------------------
CIKK_HCL      CKOD               CIKK_HCLT     CKOD
CIKK_HCL      CKOD               SZALLIT_HCLT  CKOD
CIKK_HCL2     CKOD               CIKK_HCL2T    CKOD
PERSONNEL_CL  DEPARTMENT_NUMBER  DEPT_CLT      DEPTNO
PERSONNEL_CL  DEPARTMENT_NUMBER  EMP_CLT       DEPTNO

*/
select cluster_name,
       hash_expression
  from dba_cluster_hash_expressions
 where owner = 'NIKOVITS';
/*
cl_name      hash_expr
--------------------------
CIKK_HCL2    MOD(ckod, 53)


Az alábbi lekérdezésben nézzük meg az objektum és adatobjektum azonosítókat.
*/
select object_name,
       object_type,
       object_id,
       data_object_id
  from dba_objects
 where owner = 'NIKOVITS'
   and ( object_name like 'CIKK_HCL'
    or object_name like '%_HCLT' );
/*

object_name     object_type  object_id  data_object_id
------------------------------------------------------
SZALLIT_HCLT      TABLE      100652     100650
CIKK_HCLT         TABLE      100651     100650
CIKK_HCL          CLUSTER    100650     100650

Az alábbi lekérdezésből látható, hogy csak a clusternek van szegmense.
*/
select segment_name,
       segment_type,
       bytes
  from dba_segments
 where owner = 'NIKOVITS'
   and ( segment_name like 'CIKK_HCL'
    or segment_name like '%_HCLT' );
select *
  from user_tables;
/*
segment_name   segment_type   bytes
------------------------------------
CIKK_HCL       CLUSTER        589824

************/
select *
  from emp;




select rowid,
       emp.*
  from emp;

select rowid,
       dept.*
  from dept;

select *
  from dba_clusters;
select *
  from user_clusters;

select *
  from user_clu_columns;
select *
  from dba_clu_columns;

select owner,
       cluster_name
  from dba_clusters
minus
select owner,
       cluster_name
  from dba_tables;

select owner,
       cluster_name
  from dba_tables
 where cluster_name is not null
 group by owner,
          cluster_name
having count(*) >= 6;


select owner,
       cluster_name
  from dba_clu_columns
 group by owner,
          cluster_name
having count(distinct clu_column_name) = 3;

select count(*)
  from (
   select owner,
          cluster_name,
          hash_expression
     from dba_cluster_hash_expressions
);



desc nikovits.cikk
create table qwer (
   kozp_azon_hivo number(5,0),
   kozp_azon_fog  number(5,0),
   szol_azon      number(5,0),
   datum          date,
   ora            number(2,0),
   darab          number(12,0),
   masodperc      number(12,0)
);

insert into qwer
   select *
     from nikovits.hivas;


drop index sys_c00119426;

select *
  from qwer;
commit;

select *
  from user_indexes;
select *
  from user_ind_columns;