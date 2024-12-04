# II. Service HTTP

**Dans cette partie, on ne va pas se limiter à un service déjà présent sur la machine : on va ajouter un service à la machine.**


**Ok bon on y va ?**

- [II. Service HTTP](#ii-service-http)
  - [1. Mise en place](#1-mise-en-place)
  - [2. Analyser la conf de NGINX](#2-analyser-la-conf-de-nginx)
  - [3. Déployer un nouveau site web](#3-déployer-un-nouveau-site-web)

## 1. Mise en place


🌞 **Installer le serveur NGINX**
```
[abc@web ~]$ sudo dnf install nginx
[sudo] password for abc:
Last metadata expiration check: 0:26:22 ago on Wed 04 Dec 2024 08:39:25 AM CET.
Dependencies resolved.
========================================================================================================================
 Package                         Architecture         Version                             Repository               Size
========================================================================================================================
Installing:
 nginx                           x86_64               2:1.20.1-20.el9.0.1                 appstream                36 k
Installing dependencies:
 nginx-core                      x86_64               2:1.20.1-20.el9.0.1                 appstream               566 k
 nginx-filesystem                noarch               2:1.20.1-20.el9.0.1                 appstream               8.4 k
 rocky-logos-httpd               noarch               90.15-2.el9                         appstream                24 k

Transaction Summary
========================================================================================================================
Install  4 Packages

Total download size: 634 k
Installed size: 1.8 M
Is this ok [y/N]: y
Downloading Packages:
(1/4): nginx-filesystem-1.20.1-20.el9.0.1.noarch.rpm                                     46 kB/s | 8.4 kB     00:00
(2/4): nginx-1.20.1-20.el9.0.1.x86_64.rpm                                               179 kB/s |  36 kB     00:00
(3/4): rocky-logos-httpd-90.15-2.el9.noarch.rpm                                         112 kB/s |  24 kB     00:00
(4/4): nginx-core-1.20.1-20.el9.0.1.x86_64.rpm                                          2.2 MB/s | 566 kB     00:00
------------------------------------------------------------------------------------------------------------------------
Total                                                                                   844 kB/s | 634 kB     00:00
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                                                1/1
  Running scriptlet: nginx-filesystem-2:1.20.1-20.el9.0.1.noarch                                                    1/4
  Installing       : nginx-filesystem-2:1.20.1-20.el9.0.1.noarch                                                    1/4
  Installing       : nginx-core-2:1.20.1-20.el9.0.1.x86_64                                                          2/4
  Installing       : rocky-logos-httpd-90.15-2.el9.noarch                                                           3/4
  Installing       : nginx-2:1.20.1-20.el9.0.1.x86_64                                                               4/4
  Running scriptlet: nginx-2:1.20.1-20.el9.0.1.x86_64                                                               4/4
  Verifying        : rocky-logos-httpd-90.15-2.el9.noarch                                                           1/4
  Verifying        : nginx-filesystem-2:1.20.1-20.el9.0.1.noarch                                                    2/4
  Verifying        : nginx-2:1.20.1-20.el9.0.1.x86_64                                                               3/4
  Verifying        : nginx-core-2:1.20.1-20.el9.0.1.x86_64                                                          4/4

Installed:
  nginx-2:1.20.1-20.el9.0.1.x86_64                              nginx-core-2:1.20.1-20.el9.0.1.x86_64
  nginx-filesystem-2:1.20.1-20.el9.0.1.noarch                   rocky-logos-httpd-90.15-2.el9.noarch

Complete!
[abc@web ~]$
```

🌞 **Démarrer le service NGINX**
```
[abc@web ~]$ sudo systemctl start nginx
```
🌞 **Déterminer sur quel port tourne NGINX**
```
[abc@web ~]$ sudo ss -tlnp | grep nginx
LISTEN 0      511          0.0.0.0:80        0.0.0.0:*    users:(("nginx",pid=2548,fd=6),("nginx",pid=2547,fd=6))
LISTEN 0      511             [::]:80           [::]:*    users:(("nginx",pid=2548,fd=7),("nginx",pid=2547,fd=7))
```
```
[abc@web ~]$ sudo firewall-cmd --permanent --add-port=80/tcp
success
[abc@web ~]$ sudo firewall-cmd --reload
success
```


🌞 **Déterminer les processus liés au service NGINX**
```
[abc@web ~]$ ps aux | grep nginx
root        2547  0.0  0.0  11292  1592 ?        Ss   09:06   0:00 nginx: master process /usr/sbin/nginx
nginx       2548  0.0  0.2  15532  5176 ?        S    09:06   0:00 nginx: worker process
abc         2562  0.0  0.1   6408  2304 pts/0    S+   09:13   0:00 grep --color=auto nginx
```

🌞 **Déterminer le nom de l'utilisateur qui lance NGINX**
```
[abc@web ~]$ sudo cat /etc/passwd | grep nginx
nginx:x:996:993:Nginx web server:/var/lib/nginx:/sbin/nologin
```


🌞 **Test !**

```
[abc@web ~]$ curl http://10.1.1.1:80 | head
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>HTTP Server Test Page powered by: Rocky Linux</title>
    <style type="text/css">
      /*<![CDATA[*/

      html {
100  7620  100  7620    0     0   201k      0 --:--:-- --:--:-- --:--:--  323k
curl: (23) Failed writing body
```

## 2. Analyser la conf de NGINX

🌞 **Déterminer le path du fichier de configuration de NGINX**
```
[abc@web ~]$ ls -al /etc/nginx/nginx.conf
-rw-r--r--. 1 root root 2334 Nov  8 17:43 /etc/nginx/nginx.conf
```


🌞 **Trouver dans le fichier de conf**
```
[abc@web ~]$ cat /etc/nginx/nginx.conf | grep 80 -A 14
        listen       80;
        listen       [::]:80;
        server_name  _;
        root         /usr/share/nginx/html;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        error_page 404 /404.html;
        location = /404.html {
        }

        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
        }
    }
[abc@web ~]$ cat /etc/nginx/nginx.conf | grep "include /usr/"
include /usr/share/nginx/modules/*.conf;
[abc@web ~]$ cat /etc/nginx/nginx.conf | grep "user n"
user nginx;
[abc@web ~]$ cat /etc/nginx/nginx.conf | grep "user n"

```

## 3. Déployer un nouveau site web

🌞 **Créer un site web**
```
[abc@web ~]$ sudo mkdir -p /var/www/tp1_parc
[sudo] password for abc:
[abc@web ~]$ sudo nano /var/www/tp1_parc/index.html
[abc@web ~]$ cat /var/www/tp1_parc/index.html
<h1>MEOW mon premier serveur web</h1>

```


🌞 **Gérer les permissions**
```
[abc@web ~]$ ps aux | grep nginx
root        2547  0.0  0.0  11292  1592 ?        Ss   09:06   0:00 nginx: master process /usr/sbin/nginx
nginx       2548  0.0  0.3  15532  5816 ?        S    09:06   0:00 nginx: worker process
abc         2607  0.0  0.1   6408  2304 pts/0    S+   09:50   0:00 grep --color=auto nginx
[abc@web ~]$ sudo chown -R nginx:nginx /var/www/tp1_parc
[abc@web ~]$ ls -l /var/www/tp1_parc
total 4
-rw-r--r--. 1 nginx nginx 39 Dec  4 09:48 index.html
```


🌞 **Adapter la conf NGINX**
🌞 **Visitez votre super site web**
```
[abc@web ~]$ sudo firewall-cmd --zone=public --add-port=4724/tcp --permanent
Warning: ALREADY_ENABLED: 4724:tcp
success
[abc@web ~]$ sudo firewall-cmd --reload
success
[abc@web ~]$ sudo firewall-cmd --zone=public --remove-port=80/tcp --permanent
Warning: NOT_ENABLED: 80:tcp
success
[abc@web ~]$ sudo firewall-cmd --reload
success
[abc@web ~]$ curl http://<IP_VM>:4724 | head
-bash: IP_VM: No such file or directory
[abc@web ~]$ curl http://10.1.1.1:4724 | head
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    39  100    39    0     0    293      0 --:--:-- --:--:-- --:--:--  1560
<h1>MEOW mon premier serveur web</h1>

```


