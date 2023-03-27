FROM tomcat:8-jre8

COPY target/*.war /usr/local/tomcat/webapps/hello.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
