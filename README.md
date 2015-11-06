# Docker Shibboleth Demo

This project provides a working shibboleth demo environment including a service provider (2.5.3) and an identity provider (3.1.2).
The identity provider uses basic authentication with "user" as the username and "password" as the password.

# Container overview

After running the makefile you'll end up with an environment similar to the following figure:
```
 +------------------+                              +-------------------+
 |                  |                              |                   |
 | Service Provider |                              | Identity Provider |
 |                  |                              |                   |
 +------------------+                              +-------------------+
      ^        ^                                        ^         ^ 
      |        |                                        |         |  
      |        |                                        |         |
      |        |     +----------------------------+     |         |
      |        |     | volume container           |     |         |
      |        +----<|     /data/sp-metadata.xml  |>----+         |
      |              |     /data/idp-metadata.xml |               |
      |              +----------------------------+               |
      |                                                           |
      |                                                           |
      |     +------------------+        +-------------------+     |
      |     | volume container |        | volume container  |     |
      +----<|     /data/sp/... |        |     /data/idp/... |>----+
            |                  |        |                   |
            +------------------+        +-------------------+
```

The setup consists of two running containers:
- shibboleth-sp, running supervisord in the foreground which in turns runs the shibd daemon, the apache 2,4 server and a tomcat 8 server.
- shibboleth-idp, running tomcat 8 in the foreground with the IDP servlet deployed.

and three volume containers:
- shibboleth-idp-data, idp specific content. E.g. the .htpasswd file with the credentials used for basic authentication.
- shibboleth-sp-data, sp specific content (currently empty).
- shibboleth-data, shared content such as the sp-metadat.xml and idp-metadata.xml files used to establish the trust relationship between the sp and idp.


# Running


After starting both containers your `docker ps` output should loook like the following:
```
CONTAINER ID        IMAGE                  COMMAND                CREATED             STATUS              PORTS                                      NAMES
487ec85fdbc3        shibboleth/idp:1.0.0   "usr/share/tomcat8/b   20 minutes ago      Up 20 minutes       8080/tcp, 172.17.42.1:8009->8009/tcp       compassionate_hawking
8a5b25f7d352        shibboleth/sp:1.0.0    "/usr/bin/supervisor   34 minutes ago      Up 34 minutes       0.0.0.0:80->80/tcp, 0.0.0.0:443->443/tcp   sick_shockley
```

To add more user accounts execute the following command (replace `<user>` and `<password>` with your desired values):
```
docker run --rm --volumes-from shibboleth-idp-data --volumes-from shibboleth-data --volumes-from shibboleth-sp-data shibboleth/sp:1.0.0 htpasswd -b /data/idp/.htpasswd <user> <password>
```

