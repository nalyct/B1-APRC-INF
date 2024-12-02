# I. Service SSH


- [I. Service SSH](#i-service-ssh)
  - [1. Analyse du service](#1-analyse-du-service)
  - [2. Modification du service](#2-modification-du-service)

## 1. Analyse du service

> *Réalisez cette partie en entier sur `web.tp1.b1`.*

On va, dans cette première partie, analyser le service SSH qui est en cours d'exécution.
```
[abc@vbox ~]$ sudo hostnamectl
[sudo] password for abc:
   Static hostname: (unset)
Transient hostname: vbox
         Icon name: computer-vm
           Chassis: vm 🖴
        Machine ID: 85a2de0cc5184679ac57107ba1709a99
           Boot ID: fe3033b24d7d4e45af7739199b99c94e
    Virtualization: oracle
  Operating System: Rocky Linux 9.5 (Blue Onyx)
       CPE OS Name: cpe:/o:rocky:rocky:9::baseos
            Kernel: Linux 5.14.0-503.14.1.el9_5.x86_64
      Architecture: x86-64
   Hardware Vendor: innotek GmbH
    Hardware Model: VirtualBox
  Firmware Version: VirtualBox
[abc@vbox ~]$ sudo hostnamectl set-hostname web.tp1.b1
[abc@vbox ~]$ sudo hostnamectl
 Static hostname: web.tp1.b1
       Icon name: computer-vm
         Chassis: vm 🖴
      Machine ID: 85a2de0cc5184679ac57107ba1709a99
         Boot ID: fe3033b24d7d4e45af7739199b99c94e
  Virtualization: oracle
Operating System: Rocky Linux 9.5 (Blue Onyx)
     CPE OS Name: cpe:/o:rocky:rocky:9::baseos
          Kernel: Linux 5.14.0-503.14.1.el9_5.x86_64
    Architecture: x86-64
 Hardware Vendor: innotek GmbH
  Hardware Model: VirtualBox
Firmware Version: VirtualBox
[abc@vbox ~]$ exit
logout
Connection to 10.1.1.1 closed.
PS C:\Users\Naly> ssh abc@10.1.1.1
abc@10.1.1.1's password:
Last login: Mon Dec  2 17:50:48 2024 from 10.1.1.4
[abc@web ~]$
```
```
[abc@vbox ~]$ sudo hostnamectl
[sudo] password for abc:
   Static hostname: (unset)
Transient hostname: vbox
         Icon name: computer-vm
           Chassis: vm 🖴
        Machine ID: 85a2de0cc5184679ac57107ba1709a99
           Boot ID: 856d4b9860a54998a87054717f1a1105
    Virtualization: oracle
  Operating System: Rocky Linux 9.5 (Blue Onyx)
       CPE OS Name: cpe:/o:rocky:rocky:9::baseos
            Kernel: Linux 5.14.0-503.14.1.el9_5.x86_64
      Architecture: x86-64
   Hardware Vendor: innotek GmbH
    Hardware Model: VirtualBox
  Firmware Version: VirtualBox
[abc@vbox ~]$ sudo hostnamectl set-hostname monitoring.tp1.b1
[abc@vbox ~]$ sudo hostnamectl
 Static hostname: monitoring.tp1.b1
       Icon name: computer-vm
         Chassis: vm 🖴
      Machine ID: 85a2de0cc5184679ac57107ba1709a99
         Boot ID: 856d4b9860a54998a87054717f1a1105
  Virtualization: oracle
Operating System: Rocky Linux 9.5 (Blue Onyx)
     CPE OS Name: cpe:/o:rocky:rocky:9::baseos
          Kernel: Linux 5.14.0-503.14.1.el9_5.x86_64
    Architecture: x86-64
 Hardware Vendor: innotek GmbH
  Hardware Model: VirtualBox
Firmware Version: VirtualBox
[abc@vbox ~]$
```

🌞 **S'assurer que le service `sshd` est démarré**

```
[abc@vbox ~]$ systemctl status
● monitoring.tp1.b1
    State: running
    Units: 283 loaded (incl. loaded aliases)
     Jobs: 0 queued
   Failed: 0 units
    Since: Mon 2024-12-02 17:55:02 CET; 24min ago
  systemd: 252-46.el9_5.2.0.1
   CGroup: /
           ├─init.scope
           │ └─1 /usr/lib/systemd/systemd --switched-root --system --deserialize 31
           ├─system.slice
           │ ├─NetworkManager.service
           │ │ └─672 /usr/sbin/NetworkManager --no-daemon
           │ ├─auditd.service
           │ │ └─628 /sbin/auditd
           │ ├─chronyd.service
           │ │ └─667 /usr/sbin/chronyd -F 2
           │ ├─crond.service
           │ │ └─712 /usr/sbin/crond -n
           │ ├─dbus-broker.service
           │ │ ├─657 /usr/bin/dbus-broker-launch --scope system --audit
           │ │ └─659 dbus-broker --log 4 --controller 9 --machine-id 85a2de0cc5184679ac57107ba1709a99 --max-bytes 53687>
           │ ├─firewalld.service
           │ │ └─662 /usr/bin/python3 -s /usr/sbin/firewalld --nofork --nopid
           │ ├─rsyslog.service
           │ │ └─761 /usr/sbin/rsyslogd -n
           │ ├─sshd.service
           │ │ └─703 "sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups"
           │ ├─systemd-journald.service
           │ │ └─551 /usr/lib/systemd/systemd-journald
           │ ├─systemd-logind.service
           │ │ └─664 /usr/lib/systemd/systemd-logind
           │ └─systemd-udevd.service
           │   └─udev
           │     └─564 /usr/lib/systemd/systemd-udevd
lines 7-35
```



🌞 **Analyser les processus liés au service SSH**


🌞 **Déterminer le port sur lequel écoute le service SSH**



🌞 **Consulter les logs du service SSH**



## 2. Modification du service


🌞 **Identifier le fichier de configuration du serveur SSH**

🌞 **Modifier le fichier de conf**


🌞 **Redémarrer le service**



🌞 **Effectuer une connexion SSH sur le nouveau port**



✨ **Bonus : affiner la conf du serveur SSH**

- faites vos plus belles recherches internet pour améliorer la conf de SSH
- par "améliorer" on entend essentiellement ici : augmenter son niveau de sécurité
- le but c'est pas de me rendre 10000 lignes de conf que vous pompez sur internet pour le bonus, mais de vous éveiller à divers aspects de SSH, la sécu ou d'autres choses liées

![Such a hacker](./img/such_a_hacker.png)