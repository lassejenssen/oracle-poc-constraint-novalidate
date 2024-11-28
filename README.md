# POC: Oracle Constraint Enable Novalidate
In this POC I'll test modifying a table with a NOT NULL constraint.
1) First create a large table (Big Table) in your database schema. See "src/main/resources/big_table.sql" (until the COMMIT command).
2) Configure connection towards you database and schema in "src/main/resources/application.properties".
3) Start 10 java applications doing updates every 10th millisecond towards the table BIG_TABLE, by running the run.sh bash script
````
sh run.sh
````
4) While the updates a running, create the constraint with ENABLE NOVALIDATE:
````
alter table big_table modify data_object_id constraint big_table_obj_id_nn not null enable novalidate;
````
This should complete without any delays or blocking.

5) Then change the constraint to VALIDATE:
````
alter table big_table modify constraint big_table_obj_id_nn validate;
````
You can also test this in parallel (delete the constraint, and repeate step 4 first again):
````
alter session force parallel ddl;
alter table big_table parallel 4;
alter table big_table modify constraint big_table_obj_id_nn validate;
alter table big_table noparallel;
alter session disable parallel ddl;
````
