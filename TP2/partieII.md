# Partie II : Un premier ptit script

![Automate](./img/automate.jpg)

## Sommaire

- [Partie II : Un premier ptit script](#partie-ii--un-premier-ptit-script)
  - [Sommaire](#sommaire)
  - [1. Intro script](#1-intro-script)
  - [2. Premiers pas scripting](#2-premiers-pas-scripting)
  - [3. Amélioration du script](#3-amélioration-du-script)
  - [4. Bannière](#4-bannière)
  - [5. Bonus : des paillettes](#5-bonus--des-paillettes)

## 1. Intro script


## 2. Premiers pas scripting

🌞 **Ecrire un script qui produit exactement l'affichage demandé**
```
# Récupération des valeurs nécessaires avec les commandes précédentes
USER_NAME=$(echo $USER)
CURRENT_DATE=$(date +"%d/%m/%y %H:%M:%S")
USER_SHELL=$(cat /etc/passwd | grep $USER | awk -F: '{print $7}')
OS_NAME=$(source /etc/os-release && echo $PRETTY_NAME)
KERNEL_VERSION=$(uname -r)
FREE_RAM=$(free -mh | grep 'Mem:' | tr -s ' ' | cut -d' ' -f7)
DISK_SPACE=$(df -h --output=avail / | tail -n 1)
INODE_COUNT=$(df -i / | awk 'NR==2 {print $4}')
PACKAGES_COUNT=$(rpm -qa | wc -l)
OPEN_PORTS=$(ss -tuln | grep LISTEN | wc -l)
PYTHON_PATH=$(which python3)

# Affichage des résultats dans le format spécifié
echo "Salu a toa ${USER_NAME}."
echo "Nouvelle connexion ${CURRENT_DATE}."
echo "Connecté avec le shell ${USER_SHELL}."
echo "OS : ${OS_NAME} - Kernel : ${KERNEL_VERSION}"
echo "Ressources :"
echo "  - ${FREE_RAM} RAM dispo"
echo "  - ${DISK_SPACE} espace disque dispo"
echo "  - ${INODE_COUNT} fichiers restants"
echo "Actuellement : "
```

```
[abc@node1 ~]$ /opt/id.sh
Salu a toa abc.
Nouvelle connexion 09/12/24 16:00:10.
Connecté avec le shell /bin/bash.
OS : Rocky Linux 9.5 (Blue Onyx) - Kernel : 5.14.0-503.14.1.el9_5.x86_64
Ressources :
  - 1.5Gi RAM dispo
  -   16G espace disque dispo
  - 8879601 fichiers restants
Actuellement :
  - 343 paquets installés
  - 2 port(s) ouvert(s)
Python est bien installé sur la machine au chemin : /usr/bin/python3
```

## 3. Amélioration du script

🌞 **Le script `id.sh` affiche l'état du firewall**
```
[abc@node1 ~]$  /opt/id.sh
Salu a toa abc.
Nouvelle connexion 09/12/24 16:09:46.
Connecté avec le shell /bin/bash.
OS : Rocky Linux 9.5 (Blue Onyx) - Kernel : 5.14.0-503.14.1.el9_5.x86_64
Ressources :
  - 1.5Gi RAM dispo
  -   16G espace disque dispo
  - 8879601 fichiers restants
Actuellement :
  - 343 paquets installés
  - 2 port(s) ouvert(s)
Python est bien installé sur la machine au chemin : /usr/bin/python3
Le firewall est actif.
```


🌞 **Le script `id.sh` affiche l'URL vers une photo de chat random**



## 4. Bannière



🌞 **Stocker le fichier `id.sh` dans `/opt`**

🌞 **Prouvez que tout le monde peut exécuter le script**


🌞 **Ajouter l'exécution au `.bashrc` de votre utilisateur**


## 5. Bonus : des paillettes



⭐ **BONUS** : propose un script `id.sh` un peu plus...
