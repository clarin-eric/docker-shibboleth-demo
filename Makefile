
build:
	@docker build -t shibboleth/sp:1.0.0 shibboleth-sp/.
	@docker build -t shibboleth/idp:1.0.0 shibboleth-idp/.

