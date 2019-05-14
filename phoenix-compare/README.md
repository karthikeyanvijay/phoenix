# Phoenix Compare
This script compares the output of the same SQL across two environments

### Usage
```
# ./phoenix-compare.sh --help
INFO ---------------------------------------------------------------------------------------
INFO Please supply the required parameters for the script.
INFO
INFO          phoenix-compare.sh --conn1 server1:2181/hbase-secure --conn2 server2:2181/hbase-secure --dir /tmp --sqlfile compare.sql
INFO
INFO          Mandatory Parameters:
INFO                       --conn1          Zookeeper information for environment 1
INFO                       --conn2          Zookeeper information for environment 2
INFO                       --dir            Directory to dump the output of the SQL
INFO                       --sqlfile        File containing all sqls seperated by newline
INFO
INFO ---------------------------------------------------------------------------------------
```

### Sample output
```
INFO ---------------------------------------------------------------------------------------
INFO Parameters supplied for this run -
INFO     Script name:               phoenix-compare.sh
INFO     Connection 1:              env1:2181/hbase-secure
INFO     Connection 2:              env2:2181/hbase-secure
INFO     SQL File:                  compare.sql
INFO     Directory:                 /tmp
INFO ---------------------------------------------------------------------------------------
INFO  ---------------------------------------------------------------------------------------
INFO  Line Number:                 1
INFO  Statement:           SELECT * FROM schema.table1 ORDER BY 1 LIMIT 3
INFO  Command on env1 succeeded
INFO  Command on env2 succeeded
INFO  Command to get diff succeeded
INFO  No differences found
INFO  ---------------------------------------------------------------------------------------
INFO  ---------------------------------------------------------------------------------------
INFO  Line Number:                 2
INFO  Statement:           select * from schema.table2 ORDER BY 1 LIMIT 3
INFO  Command on env1 succeeded
INFO  Command on env2 succeeded
INFO  Command to get diff succeeded
INFO  No differences found
INFO  ---------------------------------------------------------------------------------------
INFO  ---------------------------------------------------------------------------------------
INFO  Line Number:                 3
INFO  Statement:           !describe schema.table1
INFO  Command on env1 succeeded
INFO  Command on env2 succeeded
INFO  Command to get diff succeeded
INFO  No differences found
INFO  ---------------------------------------------------------------------------------------
INFO  ---------------------------------------------------------------------------------------
INFO  Line Number:                 4
INFO  Statement:           !primarykeys schema.table2
INFO  Command on env1 succeeded
INFO  Command on env2 succeeded
INFO  Command to get diff succeeded
INFO  No differences found
INFO  ---------------------------------------------------------------------------------------
INFO  ---------------------------------------------------------------------------------------
INFO  Line Number:                 5
INFO  Statement:           !tables
INFO  Command on env1 succeeded
INFO  Command on env2 succeeded
INFO  Command to get diff succeeded
INFO  No differences found
INFO  ---------------------------------------------------------------------------------------
WARN  describe test not supported
INFO  ---------------------------------------------------------------------------------------
WARN  ALTER TABLE ABC not supported
INFO  ---------------------------------------------------------------------------------------
WARN  UPSERT ABC not supported
INFO  ---------------------------------------------------------------------------------------
WARN  INSERT ABC not supported
INFO  ---------------------------------------------------------------------------------------
WARN  CREATE TABLE TEST not supported
INFO  ---------------------------------------------------------------------------------------
WARN  DROP TABLE ABC12324343e343 not supported
INFO  ---------------------------------------------------------------------------------------
INFO  ---------------------------------------------------------------------------------------
INFO  Line Number:                 12
INFO  Statement:           !describe schema.table3
INFO  Command on env1 succeeded
INFO  Command on env2 succeeded
INFO  Command to get diff succeeded
INFO  No differences found
INFO  ---------------------------------------------------------------------------------------

```