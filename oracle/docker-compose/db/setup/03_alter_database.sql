-------------------------
-- update TABLESPACE USERS
-------------------------
ALTER TABLESPACE USERS ADD DATAFILE '/opt/oracle/oradata/ORCLCDB/users02.dbf' SIZE 20M AUTOEXTEND ON;
ALTER TABLESPACE USERS ADD DATAFILE '/opt/oracle/oradata/ORCLCDB/users03.dbf' SIZE 20M AUTOEXTEND ON;

ALTER SYSTEM SET PROCESSES=1200 SCOPE=SPFILE; 
ALTER SYSTEM SET SESSIONS=1200 SCOPE=SPFILE;

