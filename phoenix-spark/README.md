# Phoenix Spark

### Spark Submit command
```
spark-submit --master=yarn --deploy-mode=client \
--executor-memory=2g --executor-cores=3 \
--conf "spark.executor.extraClassPath=/usr/hdp/current/phoenix-client/phoenix-spark2.jar:/usr/hdp/current/phoenix-client/phoenix-client.jar" \
--conf "spark.driver.extraClassPath=/usr/hdp/current/phoenix-client/phoenix-spark2.jar:/usr/hdp/current/phoenix-client/phoenix-client.jar" \
filename.py
```


### To run this interactively
Start a pyspark shell using the following command
```
pyspark --master yarn --name "pyspark-test" \
--driver-memory 1g --executor-memory 2g --num-executors 2 --executor-cores 2 \
--jars /usr/hdp/current/phoenix-client/phoenix-spark2.jar,/usr/hdp/current/phoenix-client/phoenix-client.jar
```