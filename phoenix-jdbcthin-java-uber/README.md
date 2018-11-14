# Phoenix JDBC (Thin) Connectivity using Java - Uber jar

This is a sample program showing Phoenix JDBC (Thin) connectivity using Java. In this deployment pattern, all the required program files and configuration files are packaged with the jar file.

## Building the Uber jar
- Replace the template files in resources directory with the actual hbase-site.xml & core-site.xml
- Rename `connection.properties.template` to `connection.properties` and set the actual JDBC url in this file.
- Set the actual JDBC url in this file. The connectivity will happen via the Phoenix query server. Two types of URLs are possible
    - Use the following syntax to login from keytab - `jdbc:phoenix:thin:url=http://<Phoenix Query Server Host>:8765;serialization=PROTOBUF;authentication=SPENGO;principal=user@EXAMPLE.COM;keytab=/<keytab-path>/user.keytab`
    - Use this syntax to login from ticket cache - `jdbc:phoenix:thin:url=http://<Phoenix Query Server Host>:8765;serialization=PROTOBUF;authentication=SPENGO`. In this case the additional JVM argument `-Djavax.security.auth.useSubjectCredsOnly=false` need to be used during execution.
- Use `mvn clean install` or `mvn clean package` to build the jar.
- The above step should produce the `phoenix-jdbcapp4-1.0-SNAPSHOT-jar-with-dependencies.jar` under the `target` directory.
- This jar contains all dependent JARs and configuration files.

## Executing the program
If you are using Kerberos ticket from cache for a secure cluster, kinit first and get the kerberos ticket. To run this program use the following syntax.
```
java -Djavax.security.auth.useSubjectCredsOnly=false -cp target/phoenix-jdbcapp4-1.0-SNAPSHOT-jar-with-dependencies.jar com.example.phoenixjdbc.PhoenixApp2
```
