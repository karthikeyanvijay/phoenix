from pyspark import SparkContext,SQLContext
from pyspark import SparkFiles
from pyspark.sql import *
from pyspark.sql.functions import *
sc = SparkContext(appName="phoenix-spark-sparkapi")
sqlContext = SQLContext(sc)

# Approach 1 - Using the Spark driver
zkUrl='zookeeper.example.com:2181/hbase-secure'
df_phoenixTable = sqlContext.read\
.format('org.apache.phoenix.spark')\
.option('table', 'schema.table')\
.option('zkUrl',zkUrl)\
.load()

## Use Spark API to filter
df_phoenixTable_filtered=df_phoenixTable.filter((df_phoenixTable['col1'] == lit('98765')) & \
(df_phoenixTable['col2'] == 'A') & (df_phoenixTable['col3'] == lit('123456')))
df_phoenixTable_filtered.show()

## Use SQL to filter
df_phoenixTable.registerTempTable("df_phoenixTable")
df_phoenixTable_sql=sqlContext.sql('SELECT col1,col2,col3 FROM df_phoenixTable WHERE col1=98765 AND col2=\'A\' AND col3=\'123456\'')
df_phoenixTable_sql.show()

# Sample upsert back to Phoenix
df_phoenixTable_sql.write.format('org.apache.phoenix.spark').mode('overwrite').option('table', 'schema.targetTable').option('zkUrl',zkUrl).save()
