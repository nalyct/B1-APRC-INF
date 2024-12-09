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
```
[abc@monitoring ~]$ sudo nano /etc/netdata/health.d/tcpcheck.conf
[abc@monitoring ~]$ sudo systemctl restart netdata
```
```
check:
  name: "WEB_web.tp1.b1"
  type: "tcp"
  host: "10.1.1.2"
  port: 4724
  timeout seconds: 1
```

🌞 **Ajouter un check**
```
[abc@monitoring ~]$ sudo nano /etc/netdata/health.d/tcpcheck.conf
[abc@monitoring ~]$ sudo systemctl restart netdata
```
```
check:
  name: "SSH_web.tp1.b1"
  type: "tcp"
  host: "10.1.1.2"
  port: 3421
  timeout seconds: 1
```

## 4. Ajouter des alertes


🌞 **Configurer l'alerting avec Discord**
🌞 **Tester que ça fonctionne**
```
[abc@monitoring ~]$ sudo nano /etc/netdata/health_alarm_notify.conf
[abc@monitoring ~]$ sudo systemctl restart netdata
[abc@monitoring ~]$ sudo /usr/libexec/netdata/plugins.d/alarm-notify.sh test

# SENDING TEST WARNING ALARM TO ROLE: sysadmin
time=2024-12-04T18:19:28.458+01:00 comm=alarm-notify.sh source=health level=error tid=37550 thread=alarm-notify msg_id=6db0018e83e34320ae2a659d78019fb7 node=monitoring.tp1.b1 instance=test.chart alert_id=1 alert_unique_id=1 alert=test_alarm alert_class=Test alert_recipient=sysadmin alert_duration=1 alert_value=100 alert_value_old=90 alert_status=WARNING alert_value_old=CLEAR alert_units=units alert_summary="a test alarm" alert_info="this is a test alarm to verify notifications work" request="'/usr/libexec/netdata/plugins.d/alarm-notify.sh' 'sysadmin' 'monitoring.tp1.b1' '1' '1' '1' '1733332768' 'test_alarm' 'test.chart' 'WARNING' 'CLEAR' '100' '90' '/usr/libexec/netdata/plugins.d/alarm-notify.sh' '1' '1' 'units' 'this is a test alarm to verify notifications work' 'new value' 'old value' 'evaluated expression' 'expression variable values' '0' '0' '' '' 'Test' 'command to edit the alarm=0=monitoring.tp1.b1' '' '' 'a test alarm' " msg="[ALERT NOTIFICATION]: Cannot find sendmail command in the system path. Disabling email notifications."
time=2024-12-04T18:19:29.639+01:00 comm=alarm-notify.sh source=health level=info tid=37569 thread=alarm-notify msg_id=6db0018e83e34320ae2a659d78019fb7 node=monitoring.tp1.b1 instance=test.chart alert_id=1 alert_unique_id=1 alert=test_alarm alert_class=Test alert_recipient=sysadmin alert_duration=1 alert_value=100 alert_value_old=90 alert_status=WARNING alert_value_old=CLEAR alert_units=units alert_summary="a test alarm" alert_info="this is a test alarm to verify notifications work" request="'/usr/libexec/netdata/plugins.d/alarm-notify.sh' 'sysadmin' 'monitoring.tp1.b1' '1' '1' '1' '1733332768' 'test_alarm' 'test.chart' 'WARNING' 'CLEAR' '100' '90' '/usr/libexec/netdata/plugins.d/alarm-notify.sh' '1' '1' 'units' 'this is a test alarm to verify notifications work' 'new value' 'old value' 'evaluated expression' 'expression variable values' '0' '0' '' '' 'Test' 'command to edit the alarm=0=monitoring.tp1.b1' '' '' 'a test alarm' " msg="[ALERT NOTIFICATION]: sent discord notification to 'everyone' for notification to 'sysadmin' for transition from CLEAR to WARNING, of alert 'test_alarm' = 'new value', of instance 'test.chart', context '' on host 'monitoring.tp1.b1'"
# OK

# SENDING TEST CRITICAL ALARM TO ROLE: sysadmin
time=2024-12-04T18:19:29.916+01:00 comm=alarm-notify.sh source=health level=error tid=37582 thread=alarm-notify msg_id=6db0018e83e34320ae2a659d78019fb7 node=monitoring.tp1.b1 instance=test.chart alert_id=1 alert_unique_id=1 alert=test_alarm alert_class=Test alert_recipient=sysadmin alert_duration=1 alert_value=100 alert_value_old=90 alert_status=CRITICAL alert_value_old=WARNING alert_units=units alert_summary="a test alarm" alert_info="this is a test alarm to verify notifications work" request="'/usr/libexec/netdata/plugins.d/alarm-notify.sh' 'sysadmin' 'monitoring.tp1.b1' '1' '1' '2' '1733332769' 'test_alarm' 'test.chart' 'CRITICAL' 'WARNING' '100' '90' '/usr/libexec/netdata/plugins.d/alarm-notify.sh' '1' '2' 'units' 'this is a test alarm to verify notifications work' 'new value' 'old value' 'evaluated expression' 'expression variable values' '0' '0' '' '' 'Test' 'command to edit the alarm=0=monitoring.tp1.b1' '' '' 'a test alarm' " msg="[ALERT NOTIFICATION]: Cannot find sendmail command in the system path. Disabling email notifications."
time=2024-12-04T18:19:31.109+01:00 comm=alarm-notify.sh source=health level=info tid=37604 thread=alarm-notify msg_id=6db0018e83e34320ae2a659d78019fb7 node=monitoring.tp1.b1 instance=test.chart alert_id=1 alert_unique_id=1 alert=test_alarm alert_class=Test alert_recipient=sysadmin alert_duration=1 alert_value=100 alert_value_old=90 alert_status=CRITICAL alert_value_old=WARNING alert_units=units alert_summary="a test alarm" alert_info="this is a test alarm to verify notifications work" request="'/usr/libexec/netdata/plugins.d/alarm-notify.sh' 'sysadmin' 'monitoring.tp1.b1' '1' '1' '2' '1733332769' 'test_alarm' 'test.chart' 'CRITICAL' 'WARNING' '100' '90' '/usr/libexec/netdata/plugins.d/alarm-notify.sh' '1' '2' 'units' 'this is a test alarm to verify notifications work' 'new value' 'old value' 'evaluated expression' 'expression variable values' '0' '0' '' '' 'Test' 'command to edit the alarm=0=monitoring.tp1.b1' '' '' 'a test alarm' " msg="[ALERT NOTIFICATION]: sent discord notification to 'everyone' for notification to 'sysadmin' for transition from WARNING to CRITICAL, of alert 'test_alarm' = 'new value', of instance 'test.chart', context '' on host 'monitoring.tp1.b1'"
# OK

# SENDING TEST CLEAR ALARM TO ROLE: sysadmin
time=2024-12-04T18:19:31.290+01:00 comm=alarm-notify.sh source=health level=error tid=37618 thread=alarm-notify msg_id=6db0018e83e34320ae2a659d78019fb7 node=monitoring.tp1.b1 instance=test.chart alert_id=1 alert_unique_id=1 alert=test_alarm alert_class=Test alert_recipient=sysadmin alert_duration=1 alert_value=100 alert_value_old=90 alert_status=CLEAR alert_value_old=CRITICAL alert_units=units alert_summary="a test alarm" alert_info="this is a test alarm to verify notifications work" request="'/usr/libexec/netdata/plugins.d/alarm-notify.sh' 'sysadmin' 'monitoring.tp1.b1' '1' '1' '3' '1733332771' 'test_alarm' 'test.chart' 'CLEAR' 'CRITICAL' '100' '90' '/usr/libexec/netdata/plugins.d/alarm-notify.sh' '1' '3' 'units' 'this is a test alarm to verify notifications work' 'new value' 'old value' 'evaluated expression' 'expression variable values' '0' '0' '' '' 'Test' 'command to edit the alarm=0=monitoring.tp1.b1' '' '' 'a test alarm' " msg="[ALERT NOTIFICATION]: Cannot find sendmail command in the system path. Disabling email notifications."
time=2024-12-04T18:19:32.386+01:00 comm=alarm-notify.sh source=health level=info tid=37638 thread=alarm-notify msg_id=6db0018e83e34320ae2a659d78019fb7 node=monitoring.tp1.b1 instance=test.chart alert_id=1 alert_unique_id=1 alert=test_alarm alert_class=Test alert_recipient=sysadmin alert_duration=1 alert_value=100 alert_value_old=90 alert_status=CLEAR alert_value_old=CRITICAL alert_units=units alert_summary="a test alarm" alert_info="this is a test alarm to verify notifications work" request="'/usr/libexec/netdata/plugins.d/alarm-notify.sh' 'sysadmin' 'monitoring.tp1.b1' '1' '1' '3' '1733332771' 'test_alarm' 'test.chart' 'CLEAR' 'CRITICAL' '100' '90' '/usr/libexec/netdata/plugins.d/alarm-notify.sh' '1' '3' 'units' 'this is a test alarm to verify notifications work' 'new value' 'old value' 'evaluated expression' 'expression variable values' '0' '0' '' '' 'Test' 'command to edit the alarm=0=monitoring.tp1.b1' '' '' 'a test alarm' " msg="[ALERT NOTIFICATION]: sent discord notification to 'everyone' for notification to 'sysadmin' for transition from CRITICAL to CLEAR, of alert 'test_alarm' = 'new value', of instance 'test.chart', context '' on host 'monitoring.tp1.b1'"
# OK
```

🌞 **Euh... tester que ça fonctionne pour de vrai**
```
[abc@monitoring ~]$ yes > /dev/null &
[1] 38015
```
Augmentation des métriques sur l'interface Web Netdata.

🌞 **Configurer une alerte quand le port du serveur Web ne répond plus**


🌞 **Tester que ça fonctionne !**
