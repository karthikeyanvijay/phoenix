# Phoenix JDBC (Thick) Connectivity using Java with external dependencies

This is a sample program showing Phoenix JDBC (thick) connectivity using Java. In this deployment pattern the program execution will depend on jar files & configuration external to the program.

## Building the package
* Move the `somepath` directory elsewhere in the file system. This directory contains files which can be located anywhere in the host file system. For testing purposes you can leave it within the project directory. Note the path of this directory because this is needed for classpath execution.
* Use `mvn clean install` or `mvn clean package` to build the jar.
* The above step should produce the `phoenix-jdbcapp2-1.0-SNAPSHOT.jar` under the `target` directory.
* This jar does not comprise of any dependent JARs or configuration files.

## Executing the program
Use the following steps for executing the program - 
  
- The following artifacts needs to be supplied to the classpath for successful execution. If you try to run it without the additional classpath, then the program would fail. 
    - Phoenix Client JAR file  
    - Path to hbase-site.xml  
    - Path to core-site.xml  
- Customize 
    - Rename `connection.properties.template` to `connection.properties` and set the actual JDBC url in this file.  
    - On a secured HBase/Phoenix server, get a kerberos ticket.

To run this program use the following syntax.
```
java -cp target/phoenix-jdbcapp2-1.0-SNAPSHOT.jar:/etc/hadoop/conf:/etc/hbase/conf:/usr/hdp/current/phoenix-client/phoenix-client.jar:./somepath/ com.example.phoenixjdbc.PhoenixApp
```

## Other dependencies
In this program, the log4j properties file containing the setting to suppress the warnings is included in the package. This is not necessary. If you have an external file, use the following syntax.

```
java -Dlog4j.configuration=file:./somepath/log4j.properties -cp target/phoenix-jdbcapp2-1.0-SNAPSHOT.jar:/etc/hadoop/conf:/etc/hbase/conf:/usr/hdp/current/phoenix-client/phoenix-client.jar:./somepath/ com.example.phoenixjdbc.PhoenixApp
```
