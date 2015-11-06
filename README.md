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
- shibboleth-sp
- shibboleth-idp
and three volume containers:
- shibboleth-idp-data, idp specific content. E.g. the .htpasswd file with the credentials used for basic authentication.
- shibboleth-sp-data, sp specific conent (currently empty).
- shibboleth-data, shared content such as the sp-metadat.xml and idp-metadata.xml files used to establish the trust relationship between the sp and idp.

# Running

