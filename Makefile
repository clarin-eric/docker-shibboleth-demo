
build:
	@docker build -t shibboleth/sp:1.0.0 shibboleth-sp/.
	@docker build -t shibboleth/idp:1.0.0 shibboleth-idp/.

initialize:
	@docker create --name shibboleth-data -v /data/metadata tianon/true
	@docker create --name shibboleth-idp-data -v /data/idp tianon/true
	@docker create --name shibboleth-sp-data -v /data/sp tianon/true

	@docker run --rm --volumes-from shibboleth-idp-data --volumes-from shibboleth-data --volumes-from shibboleth-sp-data shibboleth/sp:1.0.0 htpasswd -b -c /data/idp/.htpasswd user password
	@docker run --rm --volumes-from shibboleth-data --volumes-from shibboleth-sp-data shibboleth/sp:1.0.0 download-metadata.sh
	@docker run --rm --volumes-from shibboleth-data --volumes-from shibboleth-idp-data shibboleth/idp:1.0.0 cp /opt/shibboleth-idp/metadata/idp-metadata.xml /data/metadata/idp-metadata.xml

create:
	@docker create --name shibboleth-idp --volumes-from shibboleth-data --volumes-from shibboleth-idp-data -p 172.17.42.1:8080:8080 shibboleth/idp:1.0.0
	@docker create --name shibboleth-sp --volumes-from shibboleth-data --volumes-from shibboleth-sp-data shibboleth/sp:1.0.0

remove:
	@docker rm shibboleth-sp
	@docker rm shibboleth-idp

start:
	@docker start shibboleth-idp
	@docker start shibboleth-sp

stop:
	@docker stop shibboleth-sp
	@docker stop shibboleth-idp


