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
[abc@web ~]$ systemctl status
● web.tp1.b1
    State: running
    Units: 284 loaded (incl. loaded aliases)
     Jobs: 0 queued
   Failed: 0 units
    Since: Wed 2024-12-04 08:12:58 CET; 52s ago
  systemd: 252-46.el9_5.2.0.1
   CGroup: /
           ├─init.scope
           │ └─1 /usr/lib/systemd/systemd --switched-root --system --deserialize 31
           ├─system.slice
           │ ├─NetworkManager.service
           │ │ └─673 /usr/sbin/NetworkManager --no-daemon
           │ ├─auditd.service
           │ │ └─624 /sbin/auditd
           │ ├─chronyd.service
           │ │ └─663 /usr/sbin/chronyd -F 2
           │ ├─crond.service
           │ │ └─712 /usr/sbin/crond -n
           │ ├─dbus-broker.service
           │ │ ├─654 /usr/bin/dbus-broker-launch --scope system --audit
           │ │ └─656 dbus-broker --log 4 --controller 9 --machine-id 85a2de0cc5184679ac57107ba1709a99 --max-bytes 53687>
           │ ├─firewalld.service
           │ │ └─659 /usr/bin/python3 -s /usr/sbin/firewalld --nofork --nopid
           │ ├─rsyslog.service
           │ │ └─756 /usr/sbin/rsyslogd -n
           │ ├─sshd.service
           │ │ └─705 "sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups"
           │ ├─system-getty.slice
lines 1-29

```



🌞 **Analyser les processus liés au service SSH**
```
[abc@web ~]$ ps aux | grep sshd
root         705  0.0  0.5  16796  9344 ?        Ss   08:13   0:00 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
root         751  0.1  0.6  20316 11520 ?        Ss   08:13   0:00 sshd: abc [priv]
abc         1230  0.1  0.3  20316  7112 ?        S    08:13   0:00 sshd: abc@pts/0
abc         1288  0.0  0.1   6408  2304 pts/0    S+   08:15   0:00 grep --color=auto sshd
```
🌞 **Déterminer le port sur lequel écoute le service SSH**
```
[abc@web ~]$ sudo ss -tlnp
[sudo] password for abc:
State      Recv-Q     Send-Q         Local Address:Port         Peer Address:Port    Process
LISTEN     0          128                  0.0.0.0:22                0.0.0.0:*        users:(("sshd",pid=705,fd=3))
LISTEN     0          128                     [::]:22                   [::]:*        users:(("sshd",pid=705,fd=4))
```


🌞 **Consulter les logs du service SSH**
```
[abc@web ~]$ sudo journalctl -u sshd
Dec 04 08:13:14 web.tp1.b1 systemd[1]: Starting OpenSSH server daemon...
Dec 04 08:13:14 web.tp1.b1 sshd[705]: Server listening on 0.0.0.0 port 22.
Dec 04 08:13:14 web.tp1.b1 sshd[705]: Server listening on :: port 22.
Dec 04 08:13:14 web.tp1.b1 systemd[1]: Started OpenSSH server daemon.
Dec 04 08:13:25 web.tp1.b1 sshd[751]: Accepted password for abc from 10.1.1.4 port 58993 ssh2
```
```
[abc@web ~]$ sudo tail -n 10 /var/log/secure
Dec  4 08:17:04 web sudo[1290]: pam_unix(sudo:session): session closed for user root
Dec  4 08:19:27 web sudo[1297]:     abc : TTY=pts/0 ; PWD=/home/abc ; USER=root ; COMMAND=/bin/journalctl -u ssh
Dec  4 08:19:27 web sudo[1297]: pam_unix(sudo:session): session opened for user root(uid=0) by abc(uid=1000)
Dec  4 08:19:27 web sudo[1297]: pam_unix(sudo:session): session closed for user root
Dec  4 08:20:14 web sudo[1301]:     abc : TTY=pts/0 ; PWD=/home/abc ; USER=root ; COMMAND=/bin/journalctl -u sshd
Dec  4 08:20:14 web sudo[1301]: pam_unix(sudo:session): session opened for user root(uid=0) by abc(uid=1000)
Dec  4 08:20:14 web sudo[1301]: pam_unix(sudo:session): session closed for user root
Dec  4 08:20:22 web sudo[1305]:     abc : TTY=pts/0 ; PWD=/home/abc ; USER=root ; COMMAND=/bin/tail -n 10 /var/log/auth.log
Dec  4 08:20:22 web sudo[1305]: pam_unix(sudo:session): session opened for user root(uid=0) by abc(uid=1000)
Dec  4 08:20:22 web sudo[1305]: pam_unix(sudo:session): session closed for user root
```


## 2. Modification du service


🌞 **Identifier le fichier de configuration du serveur SSH**
```
[abc@web ~]$ sudo cat /etc/ssh/sshd_config
#       $OpenBSD: sshd_config,v 1.104 2021/07/02 05:11:21 dtucker Exp $

# This is the sshd server system-wide configuration file.  See
# sshd_config(5) for more information.

# This sshd was compiled with PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin

# The strategy used for options in the default sshd_config shipped with
# OpenSSH is to specify options with their default value where
# possible, but leave them commented.  Uncommented options override the
# default value.

# To modify the system-wide sshd configuration, create a  *.conf  file under
#  /etc/ssh/sshd_config.d/  which will be automatically included below
Include /etc/ssh/sshd_config.d/*.conf

# If you want to change the port on a SELinux system, you have to tell
# SELinux about this change.
# semanage port -a -t ssh_port_t -p tcp #PORTNUMBER
#
#Port 22
#AddressFamily any
#ListenAddress 0.0.0.0
#ListenAddress ::

#HostKey /etc/ssh/ssh_host_rsa_key
#HostKey /etc/ssh/ssh_host_ecdsa_key
#HostKey /etc/ssh/ssh_host_ed25519_key

# Ciphers and keying
#RekeyLimit default none

# Logging
#SyslogFacility AUTH
#LogLevel INFO

# Authentication:

#LoginGraceTime 2m
#PermitRootLogin prohibit-password
#StrictModes yes
#MaxAuthTries 6
#MaxSessions 10

#PubkeyAuthentication yes

# The default is to check both .ssh/authorized_keys and .ssh/authorized_keys2
# but this is overridden so installations will only check .ssh/authorized_keys
AuthorizedKeysFile      .ssh/authorized_keys

#AuthorizedPrincipalsFile none

#AuthorizedKeysCommand none
#AuthorizedKeysCommandUser nobody

# For this to work you will also need host keys in /etc/ssh/ssh_known_hosts
#HostbasedAuthentication no
# Change to yes if you don't trust ~/.ssh/known_hosts for
# HostbasedAuthentication
#IgnoreUserKnownHosts no
# Don't read the user's ~/.rhosts and ~/.shosts files
#IgnoreRhosts yes

# To disable tunneled clear text passwords, change to no here!
#PasswordAuthentication yes
#PermitEmptyPasswords no

# Change to no to disable s/key passwords
#KbdInteractiveAuthentication yes

# Kerberos options
#KerberosAuthentication no
#KerberosOrLocalPasswd yes
#KerberosTicketCleanup yes
#KerberosGetAFSToken no
#KerberosUseKuserok yes

# GSSAPI options
#GSSAPIAuthentication no
#GSSAPICleanupCredentials yes
#GSSAPIStrictAcceptorCheck yes
#GSSAPIKeyExchange no
#GSSAPIEnablek5users no

# Set this to 'yes' to enable PAM authentication, account processing,
# and session processing. If this is enabled, PAM authentication will
# be allowed through the KbdInteractiveAuthentication and
# PasswordAuthentication.  Depending on your PAM configuration,
# PAM authentication via KbdInteractiveAuthentication may bypass
# the setting of "PermitRootLogin without-password".
# If you just want the PAM account and session checks to run without
# PAM authentication, then enable this but set PasswordAuthentication
# and KbdInteractiveAuthentication to 'no'.
# WARNING: 'UsePAM no' is not supported in RHEL and may cause several
# problems.
#UsePAM no

#AllowAgentForwarding yes
#AllowTcpForwarding yes
#GatewayPorts no
#X11Forwarding no
#X11DisplayOffset 10
#X11UseLocalhost yes
#PermitTTY yes
#PrintMotd yes
#PrintLastLog yes
#TCPKeepAlive yes
#PermitUserEnvironment no
#Compression delayed
#ClientAliveInterval 0
#ClientAliveCountMax 3
#UseDNS no
#PidFile /var/run/sshd.pid
#MaxStartups 10:30:100
#PermitTunnel no
#ChrootDirectory none
#VersionAddendum none

# no default banner path
#Banner none

# override default of no subsystems
Subsystem       sftp    /usr/libexec/openssh/sftp-server

# Example of overriding settings on a per-user basis
#Match User anoncvs
#       X11Forwarding no
#       AllowTcpForwarding no
#       PermitTTY no
#       ForceCommand cvs server
```
🌞 **Modifier le fichier de conf**
```
[abc@web ~]$ echo $RANDOM
3421
[abc@web ~]$ sudo nano /etc/ssh/sshd_config
[abc@web ~]$ sudo cat /etc/ssh/sshd_config | grep Port
Port 3421
```
```
[abc@web ~]$ sudo firewall-cmd --list-all | grep 3421
  ports: 3421/tcp
```


🌞 **Redémarrer le service**
```
[abc@web ~]$ sudo systemctl restart sshd
```


🌞 **Effectuer une connexion SSH sur le nouveau port**

```
PS C:\Users\Naly> ssh abc@10.1.1.1 -p 3421
abc@10.1.1.1's password:
Last login: Wed Dec  4 08:48:15 2024 from 10.1.1.4
[abc@web ~]$
```

✨ **Bonus : affiner la conf du serveur SSH**

- faites vos plus belles recherches internet pour améliorer la conf de SSH
- par "améliorer" on entend essentiellement ici : augmenter son niveau de sécurité
- le but c'est pas de me rendre 10000 lignes de conf que vous pompez sur internet pour le bonus, mais de vous éveiller à divers aspects de SSH, la sécu ou d'autres choses liées

![Such a hacker](./img/such_a_hacker.png)