```
[abc@vbox ~]$ lsblk
NAME             MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda                8:0    0   20G  0 disk
├─sda1             8:1    0    1G  0 part /boot
└─sda2             8:2    0   19G  0 part
  ├─rl_vbox-root 253:0    0   17G  0 lvm  /
  └─rl_vbox-swap 253:1    0    2G  0 lvm  [SWAP]
sdb                8:16   0    4G  0 disk
sr0               11:0    1 1024M  0 rom
[abc@vbox ~]$ sudo fdisk /dev/sdb
[sudo] password for abc:

Welcome to fdisk (util-linux 2.37.4).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS disklabel with disk identifier 0xb523c018.

Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (1-4, default 1):
First sector (2048-8388607, default 2048): w
Value out of range.
First sector (2048-8388607, default 2048):
Command (m for help):
All unwritten changes will be lost, do you really want to quit?
Command (m for help): w

The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.

[abc@vbox ~]$ sudo mkfs.ext4 /dev/sdb
mke2fs 1.46.5 (30-Dec-2021)
Found a dos partition table in /dev/sdb
Proceed anyway? (y,N) y
Creating filesystem with 1048576 4k blocks and 262144 inodes
Filesystem UUID: 74cdbc9b-ce5d-4e92-b824-9c94a050faf2
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736

Allocating group tables: done
Writing inode tables: done
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done

[abc@vbox ~]$ sudo mkdir /mnt/backup
[abc@vbox ~]$ sudo mount /dev/sdb /mnt/backup
[abc@vbox ~]$ sudo nano /etc/fstab
[abc@vbox ~]$ sudo mount -a
```

```
[abc@vbox ~]$ sudo dnf install nfs-utils
Rocky Linux 9 - BaseOS                                                                  1.1 kB/s | 4.1 kB     00:03
Rocky Linux 9 - BaseOS                                                                  1.5 MB/s | 2.3 MB     00:01
Rocky Linux 9 - AppStream                                                               6.6 kB/s | 4.5 kB     00:00
Rocky Linux 9 - AppStream                                                               3.3 MB/s | 8.4 MB     00:02
Rocky Linux 9 - Extras                                                                  5.3 kB/s | 2.9 kB     00:00
Rocky Linux 9 - Extras                                                                   22 kB/s |  16 kB     00:00
Dependencies resolved.
========================================================================================================================
 Package                          Architecture           Version                           Repository              Size
========================================================================================================================
Installing:
 nfs-utils                        x86_64                 1:2.5.4-27.el9                    baseos                 431 k
Upgrading:
 libsss_certmap                   x86_64                 2.9.5-4.el9_5.4                   baseos                  90 k
 libsss_idmap                     x86_64                 2.9.5-4.el9_5.4                   baseos                  41 k
 libsss_nss_idmap                 x86_64                 2.9.5-4.el9_5.4                   baseos                  45 k
 libsss_sudo                      x86_64                 2.9.5-4.el9_5.4                   baseos                  35 k
 sssd-client                      x86_64                 2.9.5-4.el9_5.4                   baseos                 161 k
 sssd-common                      x86_64                 2.9.5-4.el9_5.4                   baseos                 1.6 M
 sssd-kcm                         x86_64                 2.9.5-4.el9_5.4                   baseos                 109 k
Installing dependencies:
 gssproxy                         x86_64                 0.8.4-7.el9                       baseos                 108 k
 libev                            x86_64                 4.33-5.el9.0.1                    baseos                  51 k
 libnfsidmap                      x86_64                 1:2.5.4-27.el9                    baseos                  59 k
 libtirpc                         x86_64                 1.3.3-9.el9                       baseos                  93 k
 libverto-libev                   x86_64                 0.3.2-3.el9                       baseos                  13 k
 python3-pyyaml                   x86_64                 5.4.1-6.el9                       baseos                 191 k
 quota                            x86_64                 1:4.09-2.el9                      baseos                 190 k
 quota-nls                        noarch                 1:4.09-2.el9                      baseos                  76 k
 rpcbind                          x86_64                 1.2.6-7.el9                       baseos                  56 k
 sssd-nfs-idmap                   x86_64                 2.9.5-4.el9_5.4                   baseos                  39 k

Transaction Summary
========================================================================================================================
Install  11 Packages
Upgrade   7 Packages

Total download size: 3.3 M
Is this ok [y/N]: y
Downloading Packages:
(1/18): libverto-libev-0.3.2-3.el9.x86_64.rpm                                            38 kB/s |  13 kB     00:00
(2/18): quota-nls-4.09-2.el9.noarch.rpm                                                 182 kB/s |  76 kB     00:00
(3/18): quota-4.09-2.el9.x86_64.rpm                                                     363 kB/s | 190 kB     00:00
(4/18): libtirpc-1.3.3-9.el9.x86_64.rpm                                                 371 kB/s |  93 kB     00:00
(5/18): rpcbind-1.2.6-7.el9.x86_64.rpm                                                  285 kB/s |  56 kB     00:00
(6/18): python3-pyyaml-5.4.1-6.el9.x86_64.rpm                                           698 kB/s | 191 kB     00:00
(7/18): libev-4.33-5.el9.0.1.x86_64.rpm                                                 343 kB/s |  51 kB     00:00
(8/18): sssd-nfs-idmap-2.9.5-4.el9_5.4.x86_64.rpm                                       284 kB/s |  39 kB     00:00
(9/18): gssproxy-0.8.4-7.el9.x86_64.rpm                                                 379 kB/s | 108 kB     00:00
(10/18): nfs-utils-2.5.4-27.el9.x86_64.rpm                                              1.5 MB/s | 431 kB     00:00
(11/18): libnfsidmap-2.5.4-27.el9.x86_64.rpm                                            295 kB/s |  59 kB     00:00
(12/18): sssd-kcm-2.9.5-4.el9_5.4.x86_64.rpm                                            664 kB/s | 109 kB     00:00
(13/18): sssd-client-2.9.5-4.el9_5.4.x86_64.rpm                                         1.0 MB/s | 161 kB     00:00
(14/18): libsss_sudo-2.9.5-4.el9_5.4.x86_64.rpm                                         244 kB/s |  35 kB     00:00
(15/18): libsss_nss_idmap-2.9.5-4.el9_5.4.x86_64.rpm                                    191 kB/s |  45 kB     00:00
(16/18): libsss_idmap-2.9.5-4.el9_5.4.x86_64.rpm                                        181 kB/s |  41 kB     00:00
(17/18): libsss_certmap-2.9.5-4.el9_5.4.x86_64.rpm                                      778 kB/s |  90 kB     00:00
(18/18): sssd-common-2.9.5-4.el9_5.4.x86_64.rpm                                         2.4 MB/s | 1.6 MB     00:00
------------------------------------------------------------------------------------------------------------------------
Total                                                                                   1.4 MB/s | 3.3 MB     00:02
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                                                1/1
  Installing       : libtirpc-1.3.3-9.el9.x86_64                                                                   1/25
  Upgrading        : libsss_idmap-2.9.5-4.el9_5.4.x86_64                                                           2/25
  Installing       : libnfsidmap-1:2.5.4-27.el9.x86_64                                                             3/25
  Installing       : sssd-nfs-idmap-2.9.5-4.el9_5.4.x86_64                                                         4/25
  Running scriptlet: rpcbind-1.2.6-7.el9.x86_64                                                                    5/25
  Installing       : rpcbind-1.2.6-7.el9.x86_64                                                                    5/25
  Running scriptlet: rpcbind-1.2.6-7.el9.x86_64                                                                    5/25
Created symlink /etc/systemd/system/multi-user.target.wants/rpcbind.service → /usr/lib/systemd/system/rpcbind.service.
Created symlink /etc/systemd/system/sockets.target.wants/rpcbind.socket → /usr/lib/systemd/system/rpcbind.socket.

  Upgrading        : libsss_certmap-2.9.5-4.el9_5.4.x86_64                                                         6/25
  Upgrading        : libsss_nss_idmap-2.9.5-4.el9_5.4.x86_64                                                       7/25
  Upgrading        : sssd-client-2.9.5-4.el9_5.4.x86_64                                                            8/25
  Running scriptlet: sssd-client-2.9.5-4.el9_5.4.x86_64                                                            8/25
  Upgrading        : libsss_sudo-2.9.5-4.el9_5.4.x86_64                                                            9/25
  Running scriptlet: sssd-common-2.9.5-4.el9_5.4.x86_64                                                           10/25
  Upgrading        : sssd-common-2.9.5-4.el9_5.4.x86_64                                                           10/25
  Running scriptlet: sssd-common-2.9.5-4.el9_5.4.x86_64                                                           10/25
  Installing       : libev-4.33-5.el9.0.1.x86_64                                                                  11/25
  Installing       : libverto-libev-0.3.2-3.el9.x86_64                                                            12/25
  Installing       : gssproxy-0.8.4-7.el9.x86_64                                                                  13/25
  Running scriptlet: gssproxy-0.8.4-7.el9.x86_64                                                                  13/25
  Installing       : python3-pyyaml-5.4.1-6.el9.x86_64                                                            14/25
  Installing       : quota-nls-1:4.09-2.el9.noarch                                                                15/25
  Installing       : quota-1:4.09-2.el9.x86_64                                                                    16/25
  Running scriptlet: nfs-utils-1:2.5.4-27.el9.x86_64                                                              17/25
  Installing       : nfs-utils-1:2.5.4-27.el9.x86_64                                                              17/25
  Running scriptlet: nfs-utils-1:2.5.4-27.el9.x86_64                                                              17/25
  Upgrading        : sssd-kcm-2.9.5-4.el9_5.4.x86_64                                                              18/25
  Running scriptlet: sssd-kcm-2.9.5-4.el9_5.4.x86_64                                                              18/25
  Running scriptlet: sssd-kcm-2.9.5-4.el9_5.1.x86_64                                                              19/25
  Cleanup          : sssd-kcm-2.9.5-4.el9_5.1.x86_64                                                              19/25
  Running scriptlet: sssd-kcm-2.9.5-4.el9_5.1.x86_64                                                              19/25
  Running scriptlet: sssd-common-2.9.5-4.el9_5.1.x86_64                                                           20/25
  Cleanup          : sssd-common-2.9.5-4.el9_5.1.x86_64                                                           20/25
  Running scriptlet: sssd-common-2.9.5-4.el9_5.1.x86_64                                                           20/25
  Running scriptlet: sssd-client-2.9.5-4.el9_5.1.x86_64                                                           21/25
  Cleanup          : sssd-client-2.9.5-4.el9_5.1.x86_64                                                           21/25
  Cleanup          : libsss_idmap-2.9.5-4.el9_5.1.x86_64                                                          22/25
  Cleanup          : libsss_nss_idmap-2.9.5-4.el9_5.1.x86_64                                                      23/25
  Cleanup          : libsss_sudo-2.9.5-4.el9_5.1.x86_64                                                           24/25
  Cleanup          : libsss_certmap-2.9.5-4.el9_5.1.x86_64                                                        25/25
  Running scriptlet: sssd-common-2.9.5-4.el9_5.4.x86_64                                                           25/25
  Running scriptlet: libsss_certmap-2.9.5-4.el9_5.1.x86_64                                                        25/25
  Verifying        : libverto-libev-0.3.2-3.el9.x86_64                                                             1/25
  Verifying        : quota-1:4.09-2.el9.x86_64                                                                     2/25
  Verifying        : quota-nls-1:4.09-2.el9.noarch                                                                 3/25
  Verifying        : libtirpc-1.3.3-9.el9.x86_64                                                                   4/25
  Verifying        : python3-pyyaml-5.4.1-6.el9.x86_64                                                             5/25
  Verifying        : rpcbind-1.2.6-7.el9.x86_64                                                                    6/25
  Verifying        : libev-4.33-5.el9.0.1.x86_64                                                                   7/25
  Verifying        : sssd-nfs-idmap-2.9.5-4.el9_5.4.x86_64                                                         8/25
  Verifying        : gssproxy-0.8.4-7.el9.x86_64                                                                   9/25
  Verifying        : nfs-utils-1:2.5.4-27.el9.x86_64                                                              10/25
  Verifying        : libnfsidmap-1:2.5.4-27.el9.x86_64                                                            11/25
  Verifying        : sssd-kcm-2.9.5-4.el9_5.4.x86_64                                                              12/25
  Verifying        : sssd-kcm-2.9.5-4.el9_5.1.x86_64                                                              13/25
  Verifying        : sssd-common-2.9.5-4.el9_5.4.x86_64                                                           14/25
  Verifying        : sssd-common-2.9.5-4.el9_5.1.x86_64                                                           15/25
  Verifying        : sssd-client-2.9.5-4.el9_5.4.x86_64                                                           16/25
  Verifying        : sssd-client-2.9.5-4.el9_5.1.x86_64                                                           17/25
  Verifying        : libsss_sudo-2.9.5-4.el9_5.4.x86_64                                                           18/25
  Verifying        : libsss_sudo-2.9.5-4.el9_5.1.x86_64                                                           19/25
  Verifying        : libsss_nss_idmap-2.9.5-4.el9_5.4.x86_64                                                      20/25
  Verifying        : libsss_nss_idmap-2.9.5-4.el9_5.1.x86_64                                                      21/25
  Verifying        : libsss_idmap-2.9.5-4.el9_5.4.x86_64                                                          22/25
  Verifying        : libsss_idmap-2.9.5-4.el9_5.1.x86_64                                                          23/25
  Verifying        : libsss_certmap-2.9.5-4.el9_5.4.x86_64                                                        24/25
  Verifying        : libsss_certmap-2.9.5-4.el9_5.1.x86_64                                                        25/25

Upgraded:
  libsss_certmap-2.9.5-4.el9_5.4.x86_64  libsss_idmap-2.9.5-4.el9_5.4.x86_64  libsss_nss_idmap-2.9.5-4.el9_5.4.x86_64
  libsss_sudo-2.9.5-4.el9_5.4.x86_64     sssd-client-2.9.5-4.el9_5.4.x86_64   sssd-common-2.9.5-4.el9_5.4.x86_64
  sssd-kcm-2.9.5-4.el9_5.4.x86_64
Installed:
  gssproxy-0.8.4-7.el9.x86_64           libev-4.33-5.el9.0.1.x86_64               libnfsidmap-1:2.5.4-27.el9.x86_64
  libtirpc-1.3.3-9.el9.x86_64           libverto-libev-0.3.2-3.el9.x86_64         nfs-utils-1:2.5.4-27.el9.x86_64
  python3-pyyaml-5.4.1-6.el9.x86_64     quota-1:4.09-2.el9.x86_64                 quota-nls-1:4.09-2.el9.noarch
  rpcbind-1.2.6-7.el9.x86_64            sssd-nfs-idmap-2.9.5-4.el9_5.4.x86_64

Complete!
```
```
[abc@music ~]$ sudo dnf install nfs-utils

```