# docker-ejbca

This is the EJBCA container on CentOS 7.2 1511.
This container requires an external database : postgresql / mariadb are compatible.
For a container that uses embedded database, use bsarda/ejbca-embedded.

Steps do configure:

- Create a user on postgres owner in database
  `create user ejb_user with password 'P@ssw0rd!';`
- Create a database on postgres for ejbca (default: ejbca)
  `create database ejbca with owner ejb_user;`


Sample usage:  
`docker run -P -d --name pki jroberto/ejbca`  

`docker logs -f pki`  

When logs shows 'EJBCA Initialized.[...]', you should download the superadmin token  
`docker cp pki:/superadmin.p12 ~/`  

And install it in the user's personal store. Defaut password = ejbca  

Note the ports used to connect:  
`docker port pki`  

Open the interface from a brower, like https://192.168.63.5:32768/ejbca  

## Database settings
The database settings are to set according to the target DB. The user must be the db owner. At this time, only mariadb and postgresql are supported and tested.  

**database settings**
- DB_USER => database user => default: ejbca  
- DB_PASSWORD => database password => default: ejbca  
- DB_URL => database jdbc url => default: jdbc:postgresql://banco:5432/ejbca  
  adapt ip address/port as needed.
- DB_DRIVER => database driver => org.postgresql.Driver
- DB_NAME => database name => postgres  

## Options as environment vars
**cli user/pass**  
- EJBCA_CLI_USER => default 'ejbca'  
- EJBCA_CLI_PASSWORD => default 'ejbca'  
  
**keystore**  
- EJBCA_KS_PASS => keystore password => default 'foo123'  
  
**certificate authority**  
- CA_NAME => name (CN) of the cert authority => default 'ManagementCA'  
- CA_DN => DN of the cert authority => default 'CN=ManagementCA,O=EJBCA,C=FR'  
- CA_KEYSPEC => key size => default '2048'  
- CA_KEYTYPE => key type => default 'RSA'  
- CA_SIGNALG => signature algorithm => default 'SHA256WithRSA'  
- CA_VALIDITY => validity in days => default '3650' (10 years)  
  
**web server**  
- WEB_SUPERADMIN => superadmin name => default 'SuperAdmin'  
- WEB_JAVA_TRUSTPASSWORD => java truststore password => default 'changeit'  
- WEB_HTTP_PASSWORD => password for http server => default 'serverpwd'  
- WEB_HTTP_HOSTNAME => hostname of the http server => default 'localhost'  
- WEB_HTTP_DN => DN of the http server => default 'CN=localhost,O=EJBCA,C=FR'  
- WEB_SELFREG => enable self-service registration => default 'true'  


**HSM Dinamo configure (Vide os manuais http://docs.dinamonetworks.com**
- 	DFENCE_PKCS11_IP => IP da máquina
-	DFENCE_PKCS11_USER => Usuário do HSM
-	DFENCE_PKCS11_ENCRYPTED =>  Se a conexão será encriptada
-	DFENCE_PKCS11_AUTO_RECONNECT => Se terá autoreconexão
-	DFENCE_PKCS11_HANDLE_CACHE_TIMEOUT => Qual o tempo de armazenamento de cache
-	HSM_LOG_PATH => Caminho para armazenamento da log do client
-	HSM_LOG_LEVEL => Nível de log
-	DFENCE_LOG_FLUSH=1 => Se vai ter flush
-	DFENCE_PKCS11_LOG_PATH => Caminho da log da P11

**Configure ejbcaClientToolBox**
Na pasta `/opt/ejbca_ce_6_3_1_1/dist/clientToolBox` execute o seguinte comando para testar configuração com HSM:
```
./ejbcaClientToolBox.sh PKCS11HSMKeyTool test /usr/lib64/libtacndp11.so 1
``` 
Para gerar uma chave no HSM execute:
``` 
./ejbcaClientToolBox.sh PKCS11HSMKeyTool generate /usr/lib64/libtacndp11.so 2048 teste_key 1
``` 