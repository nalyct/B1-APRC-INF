# III. Monitoring et alerting

Dernière partie : on a monté un serveur Web c'est bien, le surveiller, c'est mieux.

**On va utiliser un outil qui s'appelle Netdata pour le monitoring. C'est comme piloter un vaisseau spatial c'est cool.**

![Monitor](./img/monitor.webp)

## Sommaire

- [III. Monitoring et alerting](#iii-monitoring-et-alerting)
  - [Sommaire](#sommaire)
  - [1. Installation](#1-installation)
  - [2. Un peu d'analyse de service](#2-un-peu-danalyse-de-service)
  - [3. Ajouter un check](#3-ajouter-un-check)
  - [4. Ajouter des alertes](#4-ajouter-des-alertes)

## 1. Installation

## 2. Un peu d'analyse de service


🌞 **Démarrer le service `netdata`**
```
[abc@monitoring ~]$ systemctl status netdata
○ netdata.service - Real time performance monitoring
     Loaded: loaded (/usr/lib/systemd/system/netdata.service; enabled; preset: enabled)
     Active: inactive (dead)
[abc@monitoring ~]$ sudo systemctl start netdata
[abc@monitoring ~]$ systemctl status netdata
● netdata.service - Real time performance monitoring
     Loaded: loaded (/usr/lib/systemd/system/netdata.service; enabled; preset: enabled)
     Active: active (running) since Wed 2024-12-04 10:43:59 CET; 1s ago
    Process: 3251 ExecStartPre=/bin/mkdir -p /var/cache/netdata (code=exited, status=0/SUCCESS)
    Process: 3253 ExecStartPre=/bin/chown -R netdata /var/cache/netdata (code=exited, status=0/SUCCESS)
    Process: 3254 ExecStartPre=/bin/mkdir -p /run/netdata (code=exited, status=0/SUCCESS)
    Process: 3255 ExecStartPre=/bin/chown -R netdata /run/netdata (code=exited, status=0/SUCCESS)
   Main PID: 3256 (netdata)
      Tasks: 7 (limit: 11084)
     Memory: 13.7M
        CPU: 1.156s
     CGroup: /system.slice/netdata.service
             ├─3256 /usr/sbin/netdata -P /run/netdata/netdata.pid -D
             ├─3257 "spawn-plugins    " "  " "                        " "  "
             ├─3259 sh /usr/libexec/netdata/plugins.d/system-info.sh
             ├─3380 curl --fail -s --connect-timeout 1 -m 3 --noproxy "*" -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1
             └─3381 grep -sq computeMetadata

Dec 04 10:43:59 monitoring.tp1.b1 systemd[1]: Starting Real time performance monitoring...
Dec 04 10:43:59 monitoring.tp1.b1 systemd[1]: Started Real time performance monitoring.
```

🌞 **Déterminer sur quel port tourne Netdata**
```
[abc@monitoring ~]$ sudo ss -tlnp | grep netdata
LISTEN 0      4096       127.0.0.1:8125       0.0.0.0:*    users:(("netdata",pid=3256,fd=95))
LISTEN 0      4096         0.0.0.0:19999      0.0.0.0:*    users:(("netdata",pid=3256,fd=6))
LISTEN 0      4096           [::1]:8125          [::]:*    users:(("netdata",pid=3256,fd=94))
LISTEN 0      4096            [::]:19999         [::]:*    users:(("netdata",pid=3256,fd=7))
[abc@monitoring ~]$ sudo firewall-cmd --permanent --add-port=19999/tcp
success
[abc@monitoring ~]$ sudo firewall-cmd --reload
success
```
Il tourne sur le port 19999.

🌞 **Visiter l'interface Web**
```
[abc@monitoring ~]$ curl -s http://10.1.1.2:19999 > output.txt
[abc@monitoring ~]$ head -n 7 output.txt
<!doctype html><html lang="en" dir="ltr"><head><meta charset="utf-8"/><title>Netdata</title><script>const CONFIG = {
      cache: {
        agentInfo: false,
        cloudToken: true,
        agentToken: true,
      }
    }
```

## 3. Ajouter un check

🌞 **Ajouter un check**


🌞 **Ajouter un check**


## 4. Ajouter des alertes


🌞 **Configurer l'alerting avec Discord**


🌞 **Tester que ça fonctionne**


🌞 **Euh... tester que ça fonctionne pour de vrai**



🌞 **Configurer une alerte quand le port du serveur Web ne répond plus**


🌞 **Tester que ça fonctionne !**
