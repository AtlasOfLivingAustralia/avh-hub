#!/bin/sh
# These steps should be ran manually and as super user
echo "Downloading war file..."
rm -Rf /usr/share/tomcat6/webapps/hubs*
rm hubs-webapp-1.0-SNAPSHOT.war
wget http://maven.ala.org.au/repository/au/org/ala/hubs-webapp/1.0-SNAPSHOT/hubs-webapp-1.0-SNAPSHOT.war
echo "Copying war file to tomcat/webapps..."
cp hubs-webapp-1.0-SNAPSHOT.war /usr/share/tomcat6/webapps/hubs-webapp.war
#sleep 5
webappExploded=false
while [ ! $webappExploded ]; 
do
    sleep 2
    if [  -d "/usr/share/tomcat6/webapps/hubs-webapp/WEB-INF/" ]; then
       webappExploded=true
    fi
done
echo "Editting web.xml and restarting tomcat..."
cd /usr/share/tomcat6/webapps/hubs-webapp/WEB-INF/
cat web.xml  | sed 's/localhost:8080/biocache.ala.org.au/g' > web.xml.ala
mv web.xml.ala web.xml

/etc/init.d/tomcat6 restart

