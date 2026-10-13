-- Információk a clusterekről az adatszótár nézetekben: 
-------------------------------------------------------
-- DBA_CLUSTERS      (Klaszterek: speciálisan tárolt táblák számára szolgáló objektum)
-- DBA_TABLES        (cluster_name oszlop -> megadja, hogy melyik klaszteren van a tábla) 
-- DBA_CLU_COLUMNS   (klaszterek kulcs oszlopai és azok megfeleltetése a táblák oszlopainak)
-- DBA_CLUSTER_HASH_EXPRESSIONS    (hash klaszterek hash függvényei)

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

create table osztaly_clt (
   oazon     number(2) not null,
   onev      varchar2(14),
   telephely varchar2(13)
)
cluster personnel_cl ( oazon );

-- Index létrehozása (csak ezután lehet sorokat beszúrni):
create index personnel_cl_idx on cluster personnel_cl;
insert into emp_clt
   select *
     from emp;
insert into dept_clt
   select *
     from dept;

create index personnel_cl_idx on cluster personnel_cl;
insert into emp_clt select * from NIKOVITS.EMP;
insert into emp_clt select * from NIKOVITS.EMP;
insert into emp_clt select * from NIKOVITS.EMP;

/*******
A fentiek után nézzük meg az alábbi lekérdezés eredményét. Láthatjuk, hogy egy 
osztálybeli sornak és egy dolgozóbeli sornak ugyanaz a ROWID-je, ami azt jelenti, 
hogy ugyanabban a blokkban vannak tárolva.
SELECT rowid, ename ename_dname FROM emp_clt WHERE deptno=10
 UNION
SELECT rowid, dname FROM dept_clt WHERE deptno=10;

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

-- Saját hash függvényt adunk meg (HASH IS):

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

SELECT cluster_name, cluster_type, function, hashkeys, single_table
FROM dba_clusters WHERE owner='NIKOVITS';
cl_name        type    function        keys  single
---------------------------------------------------
CIKK_HCL       HASH    DEFAULT2         31    N
CIKK_HCL2      HASH    HASH EXPRESSION  31    N
CIKK_HCL3      HASH    DEFAULT2         31    Y
PERSONNEL_CL   INDEX   null              0    N


SELECT cluster_name, table_name FROM dba_tables 
WHERE owner='NIKOVITS' AND cluster_name IS NOT NULL ORDER BY 1,2;
cl_name       t_name
--------------------------
CIKK_HCL      CIKK_HCLT
CIKK_HCL      SZALLIT_HCLT
CIKK_HCL2     CIKK_HCL2T
PERSONNEL_CL  DEPT_CLT
PERSONNEL_CL  EMP_CLT


SELECT cluster_name, clu_column_name, table_name, tab_column_name 
FROM dba_clu_columns WHERE owner='NIKOVITS';
cl_name       cl_col             t_name        tab_col 
------------------------------------------------------
CIKK_HCL      CKOD               CIKK_HCLT     CKOD
CIKK_HCL      CKOD               SZALLIT_HCLT  CKOD
CIKK_HCL2     CKOD               CIKK_HCL2T    CKOD
PERSONNEL_CL  DEPARTMENT_NUMBER  DEPT_CLT      DEPTNO
PERSONNEL_CL  DEPARTMENT_NUMBER  EMP_CLT       DEPTNO


SELECT cluster_name, hash_expression 
FROM dba_cluster_hash_expressions WHERE owner='NIKOVITS';
cl_name      hash_expr
--------------------------
CIKK_HCL2    MOD(ckod, 53)


Az alábbi lekérdezésben nézzük meg az objektum és adatobjektum azonosítókat.

SELECT object_name, object_type, object_id, data_object_id 
FROM dba_objects WHERE owner='NIKOVITS'
AND (object_name LIKE 'CIKK_HCL' OR object_name LIKE '%_HCLT');

object_name     object_type  object_id  data_object_id
------------------------------------------------------
SZALLIT_HCLT      TABLE      100652     100650             --> mindháromnak ugyanaz az adatobjektuma, egy szegmensben vannak 
CIKK_HCLT         TABLE      100651     100650
CIKK_HCL          CLUSTER    100650     100650


Az alábbi lekérdezésből látható, hogy csak a clusternek van szegmense.

SELECT segment_name, segment_type, bytes 
FROM dba_segments WHERE owner='NIKOVITS'
AND (segment_name LIKE 'CIKK_HCL' OR segment_name LIKE '%_HCLT');

segment_name   segment_type   bytes
------------------------------------
CIKK_HCL       CLUSTER        589824

************/