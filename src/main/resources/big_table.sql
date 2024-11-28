-- drop table big_table purge;
create table big_table
as
select rownum id,
       OWNER, OBJECT_NAME, SUBOBJECT_NAME,
       OBJECT_ID, DATA_OBJECT_ID,
       OBJECT_TYPE, CREATED, LAST_DDL_TIME,
   TIMESTAMP, STATUS, TEMPORARY,
   GENERATED, SECONDARY
   from all_objects a
   where 1=0
   /
alter table big_table nologging;

declare
   l_cnt number;
   l_rows number := 1000000;
begin
   insert /*+ append */ into big_table
      select rownum,
             OWNER, OBJECT_NAME, SUBOBJECT_NAME,
             OBJECT_ID, DATA_OBJECT_ID,
             OBJECT_TYPE, CREATED, LAST_DDL_TIME,
         TIMESTAMP, STATUS, TEMPORARY,
         GENERATED, SECONDARY
      from all_objects a
      where rownum <= 1000000;

l_cnt := sql%rowcount;

   commit;

   while (l_cnt < l_rows) loop
      insert /*+ APPEND */ into big_table
         select rownum+l_cnt,
                   OWNER, OBJECT_NAME, SUBOBJECT_NAME,
                   OBJECT_ID, DATA_OBJECT_ID,
                   OBJECT_TYPE, CREATED, LAST_DDL_TIME,
               TIMESTAMP, STATUS, TEMPORARY,
               GENERATED, SECONDARY
            from big_table
            where rownum <= l_rows-l_cnt;
            l_cnt := l_cnt + sql%rowcount;
      commit;
   end loop;

end;
/

alter table big_table add constraint
   big_table_pk primary key(id)
/

begin
   dbms_stats.gather_table_stats(
      ownname    => user,
      tabname    => 'BIG_TABLE',
      cascade    => TRUE );
end;
/


update big_table set object_id=1, data_object_id = (case when data_object_id is null then 0 else data_object_id end);
commit;

/* Div spørringer */
select count(*) over (partition by 1) cnt, t.* from big_table t where object_id>1;


alter table big_table modify data_object_id constraint big_table_obj_id_nn not null enable novalidate;
alter table big_table modify constraint big_table_obj_id_nn validate;