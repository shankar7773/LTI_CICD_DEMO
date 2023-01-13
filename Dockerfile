FROM tomcat:latest
RUN mv /usr/local/tomcat/webapps.dist/* /usr/local/tomcat/webapps/
RUN apt-get update && apt-get install -y wget
ARG host_name
ARG artifact_id
ARG version
ARG build_no
RUN wget --no-check-certificate --user=admin --password=Vicky@7773 -O /project2/01-maven-web-app/4.1.30-104/01-maven-web-app-4.1.30-104.war http://$host_name/repository/project2/project2/$artifact_id/$version-$build_no/$artifact_id-$version-$build_no.war
RUN mv $artifact_id-$version-$build_no.war /usr/local/tomcat/webapps/
