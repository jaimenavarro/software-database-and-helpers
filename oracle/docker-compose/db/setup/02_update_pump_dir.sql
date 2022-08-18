-------------------------
-- update DATA_PUMP_DIR
-------------------------
SELECT owner, directory_name, directory_path FROM dba_directories WHERE directory_name='DATA_PUMP_DIR';
CREATE OR REPLACE DIRECTORY "DATA_PUMP_DIR" as '/mnt/';