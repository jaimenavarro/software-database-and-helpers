select value from v$parameter where name like '%service_name%';
SELECT owner, directory_name, directory_path FROM dba_directories WHERE directory_name='DATA_PUMP_DIR';

select resource_name, current_utilization, max_utilization, limit_value 
from v$resource_limit 
where resource_name in ('sessions', 'processes','transactions');

SELECT log_mode FROM v$database;
