# Phoenix JDBC (Thick) Connectivity using Java - Uber jar

This is a sample program showing Phoenix JDBC (thick) connectivity using Java. In this deployment pattern, all the required program files and configuration files are packaged with the jar file.

## Building the Uber jar
* Replace the template files in resources directory with the actual hbase-site.xml & core-site.xml
* Rename `connection.properties.template` to `connection.properties` and set the actual JDBC url in this file.
* Use `mvn clean install` or `mvn clean package` to build the jar.
* The above step should produce the `phoenix-jdbcapp1-1.0-SNAPSHOT-jar-with-dependencies.jar` under the `target` directory.
* This jar contains all dependent JARs and configuration files.

## Executing the program
On a secure cluster, get a kerberos ticket first. To run this program use the following syntax.
```
java -cp target/phoenix-jdbcapp1-1.0-SNAPSHOT-jar-with-dependencies.jar com.example.phoenixjdbc.PhoenixApp
```
