```
[abc@monitor ~]$ sudo systemctl status netdata
○ netdata.service - Real time performance monitoring
     Loaded: loaded (/usr/lib/systemd/system/netdata.service; enabled; preset: enabled)
     Active: inactive (dead)
[abc@monitor ~]$ cd /etc/netdata
[abc@monitor netdata]$ sudo nano health.d/tcpcheck.conf
```
```
alarm: jellyfin_tcp_check
    on: tcpcheck
    hosts: 10.3.1.11
    port: 8096
    lookup: localhost
    method: GET
    retries: 3
    timeout: 5
    warn: 5
    crit: 10
    delay: 30
    info: Jellyfin service check

```