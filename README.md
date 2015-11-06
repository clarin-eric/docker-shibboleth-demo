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

# Running

