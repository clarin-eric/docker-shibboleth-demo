FROM debian:jessie

ENV JAVA_HOME=/usr

RUN apt-get update -y && \
    apt-get install -y openssl apache2 supervisor tomcat8  libapache2-mod-jk wget && \
    a2enmod ssl && \
    a2enmod jk && \	
    a2enmod headers

ADD default-ssl.conf /etc/apache2/sites-available/default.conf 
RUN a2dissite 000-default && \
    a2ensite default

RUN cd /root && \
    wget http://shibboleth.net/downloads/identity-provider/latest/shibboleth-identity-provider-3.1.2.tar.gz && \
    tar -xf shibboleth-identity-provider-3.1.2.tar.gz && \
    mkdir -p /root/shibboleth-identity-provider-3.1.2/edit-webapp/WEB-INF/lib/ && \
    cd /root/shibboleth-identity-provider-3.1.2/edit-webapp/WEB-INF/lib/&& \
    wget https://build.shibboleth.net/nexus/service/local/repositories/thirdparty/content/javax/servlet/jstl/1.2/jstl-1.2.jar

RUN cd /root/shibboleth-identity-provider-3.1.2/bin && \
    ./install.sh -Didp.sealer.password=notasecurepassword -Didp.src.dir=/root/shibboleth-identity-provider-3.1.2 -Didp.target.dir=/opt/shibboleth-idp -Didp.host.name=www.test.org -Dentityid=https://www.test.org/idp/shibboleth -Didp.scope=test.org -Didp.keystore.password=notasecurepassword && \
    sed -i 's/ password/notasecurepassword/g' /opt/shibboleth-idp/conf/idp.properties && \
    rm /root/shibboleth-identity-provider-3.1.2.tar.gz
 
RUN   rm -r /var/lib/tomcat8/webapps/ROOT

COPY ROOT.xml /etc/tomcat8/Catalina/localhost/ROOT.xml

COPY supervisor/tomcat-wrapper.sh /usr/bin/tomcat-wrapper.sh
RUN chmod u+x /usr/bin/tomcat-wrapper.sh

RUN mkdir -p /data/idp/metadata && \
    cp /opt/shibboleth-idp/metadata/idp-metadata.xml /data/idp/metadata/idp-metadata.xml

COPY metadata-providers.xml /opt/shibboleth-idp/conf/metadata-providers.xml
COPY idp.properties /opt/shibboleth-idp/conf/idp.properties
COPY attribute-resolver.xml /opt/shibboleth-idp/conf/attribute-resolver.xml

#ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
#ADD index.html /var/www/index.html
#ADD worker.properties etc/libapache2-mod-jk/workers.properties

VOLUME ["/data/idp"]

EXPOSE 443 8080

#CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
CMD ["/bin/bash"]
