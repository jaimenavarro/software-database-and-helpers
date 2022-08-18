#!/bin/bash

echo "Remove previous dmp files";
rm /mnt/*dmp

echo "List available dumps in mirada server (password: dump)";
ssh -o "StrictHostKeyChecking=no" dump@dev-jenkins-cas-slave1 "ls -lrt /mnt/backups/db_backups/df_db_backups/izzidr/*dmp"

echo "Picked one file: (CV_MEX_MTV_D-04-12-21-T-07-00-01.dmp)";
read file

echo $file

echo "Donwloading dump file from mirada server (password: dump)";
scp -p dump@dev-jenkins-cas-slave1:/mnt/backups/db_backups/df_db_backups/izzidr/$file /mnt/dump.dmp

cd /mnt/
file=$(ls *dmp)

echo "FILE TO BE IMPORTED: "$file

impdp system/system directory=DATA_PUMP_DIR file=$file nologfile=y table_exists_action=replace remap_schema=CV_MEX_MTV:MIRADA EXCLUDE=USER,TABLE:"\"IN ('BMK_BOOKMARK','ACT_ACTIVITY_TAG','ACT_ACTIVITY_TAG_BAK','ACT_ACTIVITY','ACT_ACTIVITY_BAK','PROV_SERVICE_SUBSCRIPTION','YW_CUSTOMER_EPISODE_WATCHED','BILLING_VOD_PURCHASES','HEA_HEALTHCHECK_REPORT')\""
impdp system/system directory=DATA_PUMP_DIR file=$file nologfile=y table_exists_action=replace remap_schema=CV_MEX_MTV:MIRADA TABLES=CV_MEX_MTV.BMK_BOOKMARK,CV_MEX_MTV.ACT_ACTIVITY_TAG,CV_MEX_MTV.ACT_ACTIVITY,CV_MEX_MTV.PROV_SERVICE_SUBSCRIPTION,CV_MEX_MTV.YW_CUSTOMER_EPISODE_WATCHED,CV_MEX_MTV.BILLING_VOD_PURCHASES,CV_MEX_MTV.HEA_HEALTHCHECK_REPORT content=METADATA_ONLY