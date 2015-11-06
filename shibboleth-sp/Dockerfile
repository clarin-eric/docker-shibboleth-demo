FROM debian:jessie

RUN apt-get update -y && \
    apt-get install -y openssl apache2 libapache2-mod-shib2 libapache2-mod-jk supervisor && \
    a2enmod ssl && \
    a2enmod shib2 && \
    a2enmod jk && \	
    a2enmod proxy && \
    a2enmod proxy_http && \
    a2enmod headers

RUN mkdir -p /etc/apache2/certs && \    
    echo "[req]" >> /etc/apache2/certs/certs.config && \
    echo "prompt=no" >> /etc/apache2/certs/certs.config && \
    echo "default_bits=2048" >> /etc/apache2/certs/certs.config && \
    echo "encrypt_key=no" >> /etc/apache2/certs/certs.config && \
    echo "default_md=sha2" >> /etc/apache2/certs/certs.config && \
    echo "distinguished_name=req_distinguished_name" >> /etc/apache2/certs/certs.config && \
    echo "# PrintableStrings only" >> /etc/apache2/certs/certs.config && \
    echo "string_mask=MASK:0002" >> /etc/apache2/certs/certs.config && \
    echo "[req_distinguished_name]" >> /etc/apache2/certs/certs.config && \
    echo "0.organizationName = sp.test.clarin.eu" >> /etc/apache2/certs/certs.config && \
    echo "emailAddress = info@sp.test.clarin.eu" >> /etc/apache2/certs/certs.config && \
    echo "countryName = EU" >> /etc/apache2/certs/certs.config && \
    echo "commonName = test.clarin.eu" >> /etc/apache2/certs/certs.config && \
    openssl req -config /etc/apache2/certs/certs.config -new -x509 -days 365 -keyout /etc/apache2/certs/apache.key -out /etc/apache2/certs/apache.crt && \
    chmod 0700 /etc/apache2/certs/apache.crt && \
    chmod 0700 /etc/apache2/certs/apache.key
    
RUN mkdir -p /etc/shibboleth/certs && \
    echo "[req]" >> /etc/shibboleth/certs/certs.config && \
    echo "prompt=no" >> /etc/shibboleth/certs/certs.config && \
    echo "default_bits=2048" >> /etc/shibboleth/certs/certs.config && \
    echo "encrypt_key=no" >> /etc/shibboleth/certs/certs.config && \
    echo "default_md=sha1" >> /etc/shibboleth/certs/certs.config && \
    echo "distinguished_name=dn" >> /etc/shibboleth/certs/certs.config && \
    echo "# PrintableStrings only" >> /etc/shibboleth/certs/certs.config && \
    echo "string_mask=MASK:0002" >> /etc/shibboleth/certs/certs.config && \
    echo "x509_extensions=ext" >> /etc/shibboleth/certs/certs.config && \
    echo "[dn]" >> /etc/shibboleth/certs/certs.config && \
    echo "CN=test.clarin.eu" >> /etc/shibboleth/certs/certs.config && \
    echo "[ext]" >> /etc/shibboleth/certs/certs.config && \
    echo "subjectAltName=DNS:www.example.org,URI:https://www.example.org/idp/shibboleth" >> /etc/shibboleth/certs/certs.config && \
    echo "subjectKeyIdentifier=hash" >> /etc/shibboleth/certs/certs.config && \
    openssl req -config /etc/shibboleth/certs/certs.config -new -x509 -days 365 -keyout /etc/shibboleth/certs/shib.key -out /etc/shibboleth/certs/shib.crt && \
    chmod 0700 /etc/shibboleth/certs/shib.crt && \
    chmod 0700 /etc/shibboleth/certs/shib.key

RUN rm /etc/apache2/sites-enabled/000-default.conf 
ADD default-ssl.conf /etc/apache2/sites-enabled/default-ssl.conf 

RUN mkdir -p mkdir -p /var/run/shibboleth && \
    sed -i 's/entityID="https:\/\/sp.example.org\/shibboleth"/entityID="https:\/\/test.clarin.eu\/sp\/shibboleth"/g' /etc/shibboleth/shibboleth2.xml && \
    sed -i 's/handlerSSL="false"/handlerSSL="true"/g' /etc/shibboleth/shibboleth2.xml && \
    sed -i 's/<CredentialResolver type="File" key="sp-key.pem" certificate="sp-cert.pem"\/>/<CredentialResolver type="File" key="\/etc\/shibboleth\/certs\/shib.key" certificate="\/etc\/shibboleth\/certs\/shib.crt"\/>/g' /etc/shibboleth/shibboleth2.xml

#RUN mkdir -p /data/sp/metadata && \
#    cp /opt/shibboleth/metadata/idp-metadata.xml /data/idp/metadata/idp-metadata.xml

#RUN ln -sf /dev/stderr /var/log/apache2/error.log
#RUN ln -sf /dev/stdout /var/log/apache2/access.log
#RUN ln -sf /dev/stdout /var/log/apache2/mod_jk.log

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD index.html /var/www/index.html
ADD worker.properties etc/libapache2-mod-jk/workers.properties

#Fetch sp metadata after running
#curl -k -o /tmp/metadata.xml https://localhost/Shibboleth.sso/Metadata

VOLUME ["/var/www", "/var/log/apache2", "/var/log/shibboleth", "/etc/supervisor", "/var/log/supervisor"]

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
