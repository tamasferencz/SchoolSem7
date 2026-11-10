-- =====================================================================
--  AB2 ZH – gyakorló feladatok (Oracle adatszótár)
--  Írd a megoldást a feladat alatti üres helyre, aztán szólj, és átnézem.
--  Ha nem tudod lefuttatni, az sem gond, a logikát akkor is ellenőrzöm.
--  Szögletes zárójelben: az eredmény oszlopai.
--  Nehézség: (*) könnyű, (**) közepes, (***) ZH-csavaros
-- =====================================================================


-- ---------------------------------------------------------------------
-- A) OBJEKTUMOK, OSZLOPOK
-- ---------------------------------------------------------------------

-- 1. (*) Kik azok a felhasználók, akiknek van szekvenciájuk és
--        szinonimájuk is, de nincs egyetlen procedúrájuk sem? [owner]
select owner
  from dba_objects
 where object_type = 'SEQUENCE'
intersect
select owner
  from dba_objects
 where object_type = 'SYNONYM'
minus
select owner
  from dba_objects
 where object_type = 'PROCEDURE';


-- 2. (**) Melyik objektumtípusból van a legtöbb az adatbázisban?
--         [object_type, darab]
select object_type,
       count(*) darab
  from dba_objects
 group by object_type
 order by darab desc
 fetch first 1 rows with ties;


-- 3. (*) A NIKOVITS.EMP tábla mely oszlopai engedik meg a NULL értéket?
--        Oszlopsorrendben. [column_name, column_id]
DESC dba_tab_columns;


select column_name,
       column_id
  from dba_tab_columns
 where owner = 'NIKOVITS'
   and table_name = 'EMP'
   and nullable = 'Y'
 order by column_id;



-- 4. (***) Adjuk meg azokat a TÁBLÁKAT (nézeteket ne!), amelyeknek
--          pontosan 2 NUMBER típusú oszlopa van, és az utolsó oszlopuk
--          DATE típusú. [owner, table_name]
select c.owner,
       c.table_name
  from dba_tab_columns c
  join dba_objects o
on o.owner = c.owner
   and o.object_name = c.table_name
 where o.object_type = 'TABLE'
 group by c.owner,
          c.table_name
having sum(
      case
         when c.data_type = 'NUMBER' then
            1
         else
            0
      end
   ) = 2
   and max(c.column_id) = max(
   case
      when c.data_type = 'DATE' then
         c.column_id
   end
);



-- ---------------------------------------------------------------------
-- B) TÁROLÁS (szegmensek, extensek, fájlok, ROWID)
-- ---------------------------------------------------------------------

-- 5. (**) Táblaterenként adjuk meg a szegmensek számát és összméretét
--         MB-ban, de csak azokat a táblatereket, ahol ez 100 MB fölött van.
--         [tablespace_name, darab, meret_mb]
select tablespace_name,
       count(*) darab,
       round(
          sum(bytes) / 1024 / 1024,
          2
       ) meret_mb
  from dba_segments
 group by tablespace_name
having sum(bytes) / 1024 / 1024 > 100;

select *
  from dba_segments;

-- 6. (**) A NIKOVITS felhasználó melyik (nem particionált) táblája áll
--         a legtöbb extensből? [segment_name, extents]
select owner,
       segment_type,
       segment_name,
       extents
  from dba_segments
 where segment_type = 'TABLE'
   and owner = 'NIKOVITS'
 order by extents desc
 fetch first 1 rows with ties;


-- 7. (***) A NIKOVITS.EMP táblára adjuk meg egy sorban: hány blokk tartozik
--          a szegmenséhez, és hány blokkban van ténylegesen adat.
--          [szegmens_blokk, adat_blokk]
select (
   select blocks
     from dba_segments
    where owner = 'NIKOVITS'
      and segment_name = 'EMP'
      and segment_type = 'TABLE'
) szegmens_blokk,
       ( (
          select count(distinct dbms_rowid.rowid_relative_fno(rowid)
                                || '.'
                                || dbms_rowid.rowid_block_number(rowid))
            from nikovits.emp
       ) ) adat_blokk
  from dual;


-- 8. (**) Melyik adatfájlokban foglal helyet a NIKOVITS felhasználó
--         összesen a legtöbb helyet? Fájlonként az összeg, csökkenő sorrendben.
--         [file_name, foglalt_byte]
-- MEGOLDÁS: extensek (NIKOVITS foglalása) + fájlnév -> join a file_id-n
select f.file_name,
       sum(e.bytes) foglalt_byte
  from dba_extents e
  join dba_data_files f
on f.file_id = e.file_id
 where e.owner = 'NIKOVITS'
 group by f.file_name
 order by foglalt_byte desc;



-- ---------------------------------------------------------------------
-- C) INDEXEK, IOT
-- ---------------------------------------------------------------------

-- 9. (*) Adjuk meg azokat a táblákat, amelyeknek legalább 2 bitmap
--        indexe van. [table_owner, table_name, darab]
-- MEGOLDÁS: "legalább N" -> GROUP BY + HAVING
-- (LIKE '%BITMAP', hogy a FUNCTION-BASED BITMAP is beleférjen)
select table_owner,
       table_name,
       count(*) darab
  from dba_indexes
 where index_type like '%BITMAP'
 group by table_owner,
          table_name
having count(*) >= 2;



-- 10. (**) A NIKOVITS.CUSTOMERS tábla indexei az indexelt oszlopokkal,
--          index szerint, azon belül oszlopsorrendben.
--          [index_name, column_name, column_position]
-- MEGOLDÁS: index oszlopai -> dba_ind_columns (table_owner!), két szintű rendezés
select index_name,
       column_name,
       column_position
  from dba_ind_columns
 where table_owner = 'NIKOVITS'
   and table_name = 'CUSTOMERS'
 order by index_name,
          column_position;



-- 11. (**) Mely index-szervezett tábláknak van túlcsordulási szegmense?
--          (Az eredeti IOT nevét add meg!) [owner, table_name]
-- MEGOLDÁS: a túlcsordulási rész maga is egy "tábla" a dba_tables-ben,
-- iot_type = 'IOT_OVERFLOW', az iot_name oszlopa az eredeti IOT neve
select owner,
       iot_name table_name
  from dba_tables
 where iot_type = 'IOT_OVERFLOW';



-- ---------------------------------------------------------------------
-- D) PARTÍCIÓ, KLASZTER
-- ---------------------------------------------------------------------

-- 12. (*) Mely particionált táblák rendelkeznek legalább 4 partícióval?
--         [owner, table_name, darab]
-- MEGOLDÁS: partíciók megszámolása táblánként
select table_owner owner,
       table_name,
       count(*) darab
  from dba_tab_partitions
 group by table_owner,
          table_name
having count(*) >= 4;
-- (rövidebb alternatíva: dba_part_tables.partition_count >= 4)



-- 13. (***) A NIKOVITS felhasználó particionált tábláinak tényleges mérete
--           MB-ban (alpartíciókat is beleszámolva), csökkenő sorrendben.
--           [table_name, meret_mb]
-- MEGOLDÁS: méret -> dba_segments; particionált tábla szegmensei a partíciók/alpartíciók,
-- a segment_name ilyenkor is a TÁBLA neve -> erre csoportosítunk
select segment_name table_name,
       round(
          sum(bytes) / 1024 / 1024,
          2
       ) meret_mb
  from dba_segments
 where owner = 'NIKOVITS'
   and segment_type in ( 'TABLE PARTITION',
                         'TABLE SUBPARTITION' )
 group by segment_name
 order by meret_mb desc;



-- 14. (**) Adjuk meg a klasztereken lévő táblákat a klaszter típusával
--          (INDEX vagy HASH) együtt. [owner, cluster_name, cluster_type, table_name]
-- MEGOLDÁS: tábla klasztere -> dba_tables.cluster_name; típusa -> dba_clusters
-- join owner + cluster_name
select t.owner,
       t.cluster_name,
       c.cluster_type,
       t.table_name
  from dba_tables t
  join dba_clusters c
on c.owner = t.owner
   and c.cluster_name = t.cluster_name
 order by t.owner,
          t.cluster_name,
          t.table_name;



-- 15. (***) Hány olyan táblája van a NIKOVITS felhasználónak, amelyik
--           sem particionált, sem IOT (és nem is túlcsordulási rész), sem
--           klaszteren lévő? [darab]
-- MEGOLDÁS: mindhárom jellemző a dba_tables-ben van
-- iot_type IS NULL kiszűri az IOT-t ÉS az IOT_OVERFLOW-t is
select count(*) darab
  from dba_tables
 where owner = 'NIKOVITS'
   and partitioned = 'NO'
   and iot_type is null
   and cluster_name is null;