Hygieia
======================
Hygieia is an enterprise hospital management system which comes with the base components to allow hospitals to added new patients, create new medical files for patients, and employee records. All these components are stored in the centralized database that has multiple layers of security.

## Prerequisites ##

### Local Development Environment ###
- OS: OS X 10.11 El Capitan
- IDE: Eclipse 4.5.2 (Mars 2)
- Eclipse plugins: Sysdeo Eclipse Tomcat Launcher, EGit, ERFlute, AmaterasUML
- JDK version: 1.8.0
- Tomcat version: 8.0.39
- MySQL version: 5.7.13
- JDBC version: 5.1.40

### Local Runtime Environment ###
- Vagrant version: 1.8.1
- OS: CentOS 6.6
- OpenJDK version: 1.8.0
- Tomcat version: 8.0.39
- Apache HTTP Server version: 2.4.25
- MySQL version: 5.7.17
- JDBC version: 5.1.40

### Remote Runtime Environment ###
- Hosting Server: Amazon EC2
- AMI: Amazon Linux AMI (HVM / 64-bit) version 2016.09.1.20170119
- OpenJDK version: 1.8.0
- Tomcat version: 8.0.39
- Apache HTTP Server version: 2.4.25
- MySQL version: 5.7.17
- JDBC version: 5.1.40

## Installation ##

### Development Environment (Mac) ###

#### Tomcat ####

Download Tomcat 8.0.41 binary `tar.gz` from http://tomcat.apache.org/download-80.cgi

Unpack `tar.gz`

Move the unpacked folder to /Applications

Give *.sh files a permission of 755

    $ chmod 755 /Applications/apache-tomcat-8.0.39/bin/*.sh

Start Tomcat

    $ ./startup.sh

Check Tomcat is running in browser on URL with http://localhost:8080/

Stop Tomcat

    $ ./shutdown.sh

#### Eclipse Configuration ####

Download Eclipse Tomcat plugin `tomcatPluginV331.zip` from http://www.eclipsetotale.com/tomcatPlugin.html

Unzip tomcatPluginV331.zip

Move the unzipped folder to Eclipse/plugins

    $ mv ~/Downloads/com.sysdeo.eclipse.tomcat_3.3.1.jar /Applications/Eclipse.app/Contents/Eclipse/plugins

Start Eclipse.app

Select `Preferences` from the window menu

Select `Tomcat` folder

Select `Version 7.x` for Tomcat version

Type or browse `/Applications/apache-tomcat-8.0.39` for Tomcat home

Type or browse `/Applications/apache-tomcat-8.0.39/conf/server.xml` for Configuration file of Server.xml

Click the `Apply` button

Restart Eclipse.app

Select `Preferences` from the window menu

Expand `Server` folder and then select `Runtime Environments`

Add `Apache Tomcat v8.0`

Type or browse `/Applications/apache-tomcat-8.0.39` for Tomcat installation directory

Click the `Finish` button

Select `Tomcat` from the window menu and then select `Start Tomcat`

Check Tomcat is running in browser on URL with http://localhost:8080/

Select `Stop Tomcat`

#### MySQL ####

Install MySQL 5.7 using Homebrew

    $ sudo brew install mysql
    $ mysql --version
    mysql  Ver 14.14 Distrib 5.7.13, for osx10.11 (x86_64) using  EditLine wrapper

Start MySQL

    $ sudo mysql.server start
    Starting MySQL
    .. SUCCESS!

Stop MySQL

    $ sudo mysql.server stop
    Shutting down MySQL
    .. SUCCESS!

#### MySQL JDBC Driver ####

Download `mysql-connector-java-5.1.40.tar.gz` from https://dev.mysql.com/downloads/connector/j/

Unpack `mysql-connector-java-5.1.40.tar.gz`

Copy the .jar file in the unpacked folder to Tomcat /lib directory

    $ cp ~/Downloads/mysql-connector-java-5.1.40/mysql-connector-java-5.1.40-bin.jar /Applications/apache-tomcat-8.0.39/lib/

### Runtime Environment (Linux) ###

#### Vagrant (for local runtime) ####

Add a CentOS6.6 Vagrant box

    $ vagrant box add CentOS6.6 https://github.com/tommy-muehle/puppet-vagrant-boxes/releases/download/1.0.0/centos-6.6-x86_64.box

#### JDK ####

Install OpenJDK 1.8

    $ sudo yum -y install java-1.8.0-openjdk
    $ sudo yum -y install java-1.8.0-openjdk-devel

Change the default JDK from 1.7 to 1.8 (for Amazon EC2)

    $ sudo alternatives --config java

Check the JDK version

    $ java -version
    openjdk version "1.8.0_121"
    OpenJDK Runtime Environment (build 1.8.0_121-b13)
    OpenJDK 64-Bit Server VM (build 25.121-b13, mixed mode)

#### Tomcat ####

Create `tomcat` user

    $ sudo useradd -s /sbin/nologin tomcat

Download Tomcat 8.0.39 source package

    $ wget http://ftp.riken.jp/net/apache/tomcat/tomcat-8/v8.0.39/bin/apache-tomcat-8.0.39.tar.gz
    $ tar -xzvf apache-tomcat-8.0.39.tar.gz

Make a Tomcat installation directory

    $ sudo mkdir /opt/tomcat
    $ sudo mv apache-tomcat-8.0.39 /opt/tomcat
    $ sudo chown -R tomcat:tomcat /opt/tomcat

Check the full path (location) of Java

    $ readlink $(readlink $(which java))
    /usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin/java

Set Java home and Tomcat home

    $ sudo vi /etc/profile

    JRE_HOME=/usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin/java
    CATALINA_HOME=/opt/tomcat/apache-tomcat-8.0.39
    export JRE_HOME CATALINA_HOME

Logout and Login to read environment variables

Start Tomcat

    $ sudo -u tomcat /opt/tomcat/apache-tomcat-8.0.39/bin/startup.sh

Check Tomcat is running in browser on URL with http://xxxxxx:8080/

- Vagrant: http://192.168.33.10:8080/
- EC2: http://ec2-52-xx-xxx-xxx.compute-1.amazonaws.com:8080/

Stop Tomcat

    $ sudo -u tomcat /opt/tomcat/apache-tomcat-8.0.39/bin/shutdown.sh

#### MySQL ####

Install MySQL 5.7 from the official Yum repository

    $ sudo yum -y install https://dev.mysql.com/get/mysql57-community-release-el6-9.noarch.rpm
    $ sudo yum -y install mysql-community-server
    $ mysql --version
    mysql  Ver 14.14 Distrib 5.7.17, for Linux (x86_64) using  EditLine wrapper

#### MySQL JDBC Driver ####

Download `mysql-connector-java-5.1.40.tar.gz` from https://dev.mysql.com/downloads/connector/j/

Unpack `mysql-connector-java-5.1.40.tar.gz` locally

Transfer `mysql-connector-java-5.1.40-bin.jar` in the unpacked directory to the server

Move the .jar file to Tomcat /lib directory

    $ sudo mv ~/mysql-connector-java-5.1.40-bin.jar /opt/tomcat/apache-tomcat-8.0.39/lib/
    $ cd /opt/tomcat/apache-tomcat-8.0.39/lib/
    $ sudo chown -R tomcat:tomcat mysql-connector-java-5.1.40-bin.jar

#### Apache HTTP Server ####

Install prerequisite libraries

    $ sudo yum -y install pcre pcre-devel wget gcc make

Download Apache Portable Runtime (APR) source `apr-1.5.2.tar.gz` from http://apr.apache.org/download.cgi

Transfer `apr-1.5.2.tar.gz` to the server and then move it to /usr/local/src

Unpack `apr-1.5.2.tar.gz`

    $ cd /usr/local/src/
    $ sudo tar -xvzf apr-1.5.2.tar.gz

Run ./configure

    $ cd apr-1.5.2
    $ sudo ./configure --prefix=/opt/apr/apr-1.5.2

Run make

    $ sudo make
    $ sudo make test
    $ sudo make install

Download APR-util source `apr-util-1.5.4.tar.gz` from http://apr.apache.org/download.cgi

Transfer `apr-util-1.5.4.tar.gz` to the server and then move it to /usr/local/src

Unpack `apr-util-1.5.4.tar.gz`

    $ cd /usr/local/src/
    $ sudo tar -xvzf apr-util-1.5.4.tar.gz

Run ./configure

    $ cd apr-util-1.5.4
    $ sudo ./configure --prefix=/opt/apr-util/apr-util-1.5.4 --with-apr=/opt/apr/apr-1.5.2

Run make

    $ sudo make
    $ sudo make test
    $ sudo make install

Download Apache HTTP Server (httpd) the latest stable release `httpd-2.4.25.tar.gz` from http://httpd.apache.org/download.cgi

Transfer `httpd-2.4.25.tar.gz` to the server and then move it to /usr/local/src

Unpack `httpd-2.4.25.tar.gz`

    $ cd /usr/local/src/
    $ sudo tar -xvzf httpd-2.4.25.tar.gz

Run ./configure

    $ cd httpd-2.4.25
    $ sudo ./configure --prefix=/opt/httpd/httpd-2.4.25 --with-apr=/opt/apr/apr-1.5.2 --with-apr-util=/opt/apr-util/apr-util-1.5.4

Run make

    $ sudo make
    $ sudo make install

Start Apache

    $ sudo /opt/httpd/httpd-2.4.25/bin/apachectl start

Check Apache is running in browser

Stop Apache

    $ sudo /opt/httpd/httpd-2.4.25/bin/apachectl stop

#### Connecting Apache 2.4 to Tomcat 8 ####

Check if the following lines exist in `/opt/tomcat/apache-tomcat-8.0.39/conf/server.xml`

    <!-- Define an AJP 1.3 Connector on port 8009 -->
    <Connector port="8009" protocol="AJP/1.3" redirectPort="8443" />

Check if the following modules exist just under the `/opt/httpd/httpd-2.4.25/modules`

    mod_proxy.so
    mod_proxy_ajp.so

Uncomment the following lines in `/opt/httpd/httpd-2.4.25/conf/httpd.conf`

    LoadModule proxy_module modules/mod_proxy.so
    LoadModule proxy_ajp_module modules/mod_proxy_ajp.so

Create an empty file `httpd-proxy.conf`

    $ cd /opt/httpd/httpd-2.4.25/conf/extra
    $ sudo vi httpd-proxy.conf

Add the following line to the bottom of `http.conf` to load `httpd-proxy.conf`

```
$ sudo vi /opt/httpd/httpd-2.4.25/conf/httpd.conf
```
```
Include /opt/httpd/httpd-2.4.25/conf/extra/httpd-proxy.conf
```

Add the following line to `httpd-proxy.conf`

```
$ sudo vi /opt/httpd/httpd-2.4.25/conf/extra/httpd-proxy.conf
```
```
ProxyPass / ajp://localhost:8009/
```

Stop Apache and Tomcat

    $ sudo /opt/httpd/httpd-2.4.25/bin/apachectl start
    $ sudo -u tomcat /opt/tomcat/apache-tomcat-8.0.39/bin/shutdown.sh

Start Apache and Tomcat

    $ sudo -u tomcat /opt/tomcat/apache-tomcat-8.0.39/bin/startup.sh
    $ sudo /opt/httpd/httpd-2.4.25/bin/apachectl stop

## Database ##

### Initialization & Creation ###

Set a new password for the root user (for Mac)

    $ mysql.server start --skip-grant-tables --skip-networking
    $ mysql -u root
    mysql> FLUSH PRIVILEGES;
    mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY 'YourNewPassword’;
    $ mysql.server stop
    $ mysql.server start

Set a new password for the root user (for Linux)

    $ sudo service mysqld start --skip-grant-tables --skip-networking
    $ mysql -u root
    mysql> FLUSH PRIVILEGES;
    mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY 'YourNewPassword';
    $ sudo service mysqld stop
    $ sudo service mysqld start

Create `hygieia_db` database

    $ mysql -u root -p
    mysql> CREATE DATABASE hygieia_db;

Create a new user and grant all privileges on `hygieia_db`

    mysql> GRANT ALL ON hygieia_db. * TO YourDatabaseUser@localhost IDENTIFIED BY 'YourDatabasePassword';

## Configuration ##

### Application and Tomcat ###

Go through the following 3 steps to change the JDBC interface from java.sql.DriverManager to javax.sql.DataSource

I. Create `context.xml` under the `/META-INF` of the Eclipse Dynamic Web Project

```
<?xml version="1.0" encoding="UTF-8"?>
<Context>
  <Resource
      name="jdbc/test"
      auth="Container"
      type="javax.sql.DataSource"
      driverClassName="com.mysql.jdbc.Driver"
      url="jdbc:mysql://localhost:3306/test"
      connectionProperties="autoReconnect=true;verifyServerCertificate=false;useSSL=false;requireSSL=false"
      username="YourDatabaseUser"
      password="YourDatabasePassword"
      validationQuery="select 1"/>
</Context>
```

II. Create `web.xml` under the `/WEB-INF` of the Eclipse Dynamic Web Project

```
<?xml version="1.0" encoding="UTF-8"?>
<resource-ref>
    <res-ref-name>jdbc/test</res-ref-name>
    <res-type>javax.sql.DataSource</res-type>
    <res-auth>Container</res-auth>
</resource-ref>
```

III. Add the following lines between `<GlobalNamingResources>` and  `</GlobalNamingResources>` in `server.xml`

```
$ sudo vi /opt/tomcat/apache-tomcat-8.0.39/conf/server.xml
```
```
<Resource name="jdbc/test"
        auth="Container"
        type="javax.sql.DataSource"
        driverClassName="com.mysql.jdbc.Driver"
        url="jdbc:mysql://localhost:3306/test"
        username="YourDatabaseUser"
        password="YourDatabasePassword" />
```

### MySQL ###

Change the value of `wait_timeout` to 288000 seconds to prevent connection timeouts (the default value is 28800 seconds = 8 hours)

```
$ sudo vi /etc/my.cnf
```
```
wait_timeout=288000
interactive_timeout = 288000
```
```
$ sudo service mysqld restart
```
```
mysql> show global variables like '%timeout%';
+-----------------------------+----------+
| Variable_name               | Value    |
+-----------------------------+----------+
| connect_timeout             | 10       |
| delayed_insert_timeout      | 300      |
| have_statement_timeout      | YES      |
| innodb_flush_log_at_timeout | 1        |
| innodb_lock_wait_timeout    | 50       |
| innodb_rollback_on_timeout  | OFF      |
| interactive_timeout         | 288000   |
| lock_wait_timeout           | 31536000 |
| net_read_timeout            | 30       |
| net_write_timeout           | 60       |
| rpl_stop_slave_timeout      | 31536000 |
| slave_net_timeout           | 60       |
| wait_timeout                | 288000   |
+-----------------------------+----------+
```

### Shell Script and Cron ###

Create a SQL file to set `bed_usage.status` to 0 (means empty) from 1 (means occupied) if the record is past `end_date`

```
$ cd /usr/local/bin/
$ sudo vi batch.sql
```
```
UPDATE bed_usage SET updated_at = CURRENT_TIMESTAMP, status = 0 WHERE status = 1 AND end_date < CURRENT_DATE;
```

Make a directory for log files (stdout logs and error logs)

    $ sudo mkdir logs
    $ sudo chmod 777 logs

Create a shell script to execute the SQL file

```
$ sudo vi bed_usage_status_update.sh
```
```
#!/bin/bash

BASEDIR="$(cd $(dirname $0) && pwd)"
STDOUT_LOG="$BASEDIR/logs/result.`date '+%Y-%m-%d'`.log"
STDERR_LOG="$BASEDIR/logs/error.`date '+%Y-%m-%d'`.log"
exec 1> >(awk '{print strftime("[%Y-%m-%d %H:%M:%S] "),$0 } { fflush() } ' >> $STDOUT_LOG)
exec 2> >(awk '{print strftime("[%Y-%m-%d %H:%M:%S] "),$0 } { fflush() } ' >> $STDERR_LOG)

mysql -u YourDatabaseUser -pYourDatabasePassword hygieia_db < $BASEDIR/batch.sql
exit 0
```
```
$ sudo chmod +x bed_usage_status_update.sh
```

Install crontab and starting a cron process

    $ cd ~/
    $ sudo yum -y install cronie-noanacron
    $ sudo yum -y remove cronie-anacron
    $ sudo /etc/init.d/crond start
    $ service crond status

Create a cron job (executed at 0:05 a.m. every day)

```
$ sudo crontab -u root -e
```
```
5 0 * * * /usr/local/bin/bed_usage_status_update.sh >/dev/null 2>&1
```

List cron jobs

    $ sudo crontab -u root -l
    5 0 * * * /usr/local/bin/bed_usage_status_update.sh >/dev/null 2>&1

Delete the cron job

    $ sudo crontab -u root -r

License
----------
This project is licensed under the [Apache License, Version 2.0][Apache]

[Apache]: http://www.apache.org/licenses/LICENSE-2.0
