#!/bin/sh
echo "172.17.42.1 www.shibboleth.example" >> /etc/hosts && wget --no-check-certificate -O /data/metadata/sp-metadata.xml https://www.shibboleth.example/Shibboleth.sso/Metadata
