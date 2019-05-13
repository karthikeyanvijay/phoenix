from pyspark import SparkContext,SQLContext
from pyspark import SparkFiles
from pyspark.sql import *
from pyspark.sql.functions import *
sc = SparkContext(appName="phoenix-spark-jdbc")
sqlContext = SQLContext(sc)

# Approach 2 - Using the Phoenix JDBC
sql='SELECT col1,col2,col3 FROM schema.tablename WHERE col1=98765 AND col2=\'A\' AND col3=\'123456\''
url='jdbc:phoenix:zookeeper.example.com:2181:/hbase-secure'
df_phoenixTable_jdbc = sqlContext.read\
.format('jdbc')\
.option('driver', 'org.apache.phoenix.jdbc.PhoenixDriver')\
.option('dbtable', sql)\
.option('url', url)\
.load()

# Sample write to HDFS as CSV
df_phoenixTable_jdbc.write \
    .format('csv') \
    .options(delimiter="\0") \
    .option("ignoreLeadingWhiteSpace","false") \
    .option("ignoreTrailingWhiteSpace","false") \
    .save('hdfs:///tmp/targetdir')