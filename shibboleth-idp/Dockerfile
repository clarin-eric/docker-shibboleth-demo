FROM debian:jessie

ENV JAVA_HOME="/usr"
ENV CATALINA_PID="/var/run/tomcat8.pid"
ENV CATALINA_HOME="/usr/share/tomcat8"
ENV CATALINA_BASE="/var/lib/tomcat8"
ENV JAVA_OPTS="-Xmx1024m"

RUN apt-get update -y && \
    apt-get install -y tomcat8 wget curl vim

RUN cd /root && \
    wget http://shibboleth.net/downloads/identity-provider/latest/shibboleth-identity-provider-3.1.2.tar.gz && \
    tar -xf shibboleth-identity-provider-3.1.2.tar.gz && \
    mkdir -p /root/shibboleth-identity-provider-3.1.2/edit-webapp/WEB-INF/lib/ && \
    cd /root/shibboleth-identity-provider-3.1.2/edit-webapp/WEB-INF/lib/&& \
    wget https://build.shibboleth.net/nexus/service/local/repositories/thirdparty/content/javax/servlet/jstl/1.2/jstl-1.2.jar

RUN cd /root/shibboleth-identity-provider-3.1.2/bin && \
    ./install.sh -Didp.sealer.password=notasecurepassword -Didp.src.dir=/root/shibboleth-identity-provider-3.1.2 -Didp.target.dir=/opt/shibboleth-idp -Didp.host.name=idp.shibboleth.example -Dentityid=https://idp.shibboleth.example/idp/shibboleth -Didp.scope=idp.shibboleth.example -Didp.keystore.password=notasecurepassword && \
    sed -i 's/ password/notasecurepassword/g' /opt/shibboleth-idp/conf/idp.properties && \
    rm /root/shibboleth-identity-provider-3.1.2.tar.gz
 
RUN   rm -r /var/lib/tomcat8/webapps/ROOT

COPY tomcat/server.xml /etc/tomcat8/server.xml
COPY tomcat/ROOT.xml /etc/tomcat8/Catalina/localhost/ROOT.xml

COPY idp/metadata-providers.xml /opt/shibboleth-idp/conf/metadata-providers.xml
COPY idp/idp.properties /opt/shibboleth-idp/conf/idp.properties
COPY idp/attribute-resolver.xml /opt/shibboleth-idp/conf/attribute-resolver.xml

VOLUME ["/var/log"]
EXPOSE 8009 8080

CMD ["usr/share/tomcat8/bin/catalina.sh", "run"]
