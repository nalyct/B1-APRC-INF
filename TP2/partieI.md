# Partie I : Des beaux one-liners

Une *one-liner* c'est le fait d'écrire en une ligne ce qu'on aurait pu écrire en plusieurs pour de la lisibilité.

Mais ça sert à quoi la lisibilité, hein ?! :d

![grep cut sed](./img/cutsedgrep.png)

## Sommaire

- [Partie I : Des beaux one-liners](#partie-i--des-beaux-one-liners)
  - [Sommaire](#sommaire)
  - [1. Intro](#1-intro)
  - [2. Let's go](#2-lets-go)

## 1. Intro

**Le but de cette première partie, c'est un échauffement, vous allez fabriquer des commandes pour aller récupérer des infos précises.**

## 2. Let's go

🌞 **Afficher la quantité d'espace disque disponible**
```
[abc@node1 ~]$ df -h --output=avail /
Avail
  16G
```
🌞 **Afficher combien de fichiers il est possible de créer**
```
[abc@node1 ~]$ df -i /
Filesystem                Inodes IUsed   IFree IUse% Mounted on
/dev/mapper/rl_vbox-root 8910848 31246 8879602    1% /
```


🌞 **Afficher l'heure et la date**
```
[abc@node1 ~]$ date +"%d/%m/%y %H:%M:%S"
09/12/24 15:44:09
```


🌞 **Afficher la version de l'OS précise**
```
[abc@node1 ~]$ source /etc/os-release && echo $PRETTY_NAME
Rocky Linux 9.5 (Blue Onyx)
```

🌞 **Afficher la version du kernel en cours d'utilisation précise**
```
[abc@node1 ~]$ uname -r
5.14.0-503.14.1.el9_5.x86_64
```


🌞 **Afficher le chemin vers la commande `python3`**
```
[abc@node1 ~]$ which python3
/usr/bin/python3
```
🌞 **Afficher l'utilisateur actuellement connecté**
```
[abc@node1 ~]$ echo $USER
abc
```


🌞 **Afficher le shell par défaut de votre utilisateur actuellement connecté**
```
[abc@node1 ~]$ cat /etc/passwd | grep $USER | awk -F: '{print $7}'
/bin/bash
```


🌞 **Afficher le nombre de paquets installés**
```
[abc@node1 ~]$ rpm -qa | wc -l
343
```


🌞 **Afficher le nombre de ports en écoute**
```
[abc@node1 ~]$ ss -tuln | grep LISTEN | wc -l
2
```




