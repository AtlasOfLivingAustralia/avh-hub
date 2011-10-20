#!/bin/sh
# These steps should be ran manually and as super user

rm -Rf /usr/share/tomcat6/webapps/ozcam*
rm -Rf /usr/share/tomcat6/webapps/avh*
rm hubs-webapp-1.0-SNAPSHOT.war
wget http://maven.ala.org.au/repository/au/org/ala/hubs-webapp/1.0-SNAPSHOT/hubs-webapp-1.0-SNAPSHOT.war
cp hubs-webapp-1.0-SNAPSHOT.war /usr/share/tomcat6/webapps/avh-demo.war
cp hubs-webapp-1.0-SNAPSHOT.war /usr/share/tomcat6/webapps/ozcam-demo.war
sleep 2 #
mv /usr/share/tomcat6/webapps/ozcam-demo/WEB-INF/classes/hubs.properties.OZCAM /usr/share/tomcat6/webapps/ozcam-demo/WEB-INF/classes/hubs.properties
mv /usr/share/tomcat6/webapps/avh-demo/WEB-INF/classes/hubs.properties.AVH /usr/share/tomcat6/webapps/avh-demo/WEB-INF/classes/hubs.properties

cd /usr/share/tomcat6/webapps/ozcam-demo/WEB-INF/
sed  's/>ala</>ozcam</g' < web.xml  | sed 's/localhost:8080/ozcam-demo.ala.org.au/g' > web.xml.ozcam
mv web.xml.ozcam web.xml

cd /usr/share/tomcat6/webapps/avh-demo/WEB-INF/
sed  's/>ala</>avh</g' < web.xml  | sed 's/localhost:8080/avh-demo.ala.org.au/g' > web.xml.avh
mv web.xml.avh web.xml


/etc/init.d/tomcat6 restart
