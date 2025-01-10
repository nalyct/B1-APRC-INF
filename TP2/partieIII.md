# Partie III : Script youtube-dl

**Dans cette partie, vous allez coder un petit script qui télécharge des vidéos Youtube.** On lui file une URL d'une vidéo en argument, et il la télécharge !

Dans un deuxième temps on automatisera un peu le truc, en exécutant notre script à l'aide d'un *service* : il téléchargera toutes les vidéos qu'on lui donnera (on écrira les URLs dans un fichier, et il le lit à intervalles réguliers).

![emoboi](./img/emoboy.png)

## Sommaire

- [Partie III : Script youtube-dl](#partie-iii--script-youtube-dl)
  - [Sommaire](#sommaire)
  - [1. Premier script youtube-dl](#1-premier-script-youtube-dl)
    - [A. Le principe](#a-le-principe)
    - [B. Rendu attendu](#b-rendu-attendu)
  - [2. MAKE IT A SERVICE](#2-make-it-a-service)
    - [A. Adaptation du script](#a-adaptation-du-script)
    - [B. Le service](#b-le-service)
    - [C. Rendu attendu](#c-rendu-attendu)
  - [3. Bonus](#3-bonus)

## 1. Premier script youtube-dl

### A. Le principe

**Un petit script qui télécharge des vidéos Youtube.** Vous l'appellerez `yt.sh`. Il sera stocké dans `/opt/yt/yt.sh`.

**Pour ça on va avoir besoin d'une commande : `youtube-dl`.** Suivez les instructions suivantes pour récupérer la commande `youtube-dl` :

```bash
# si vous êtes sur Rocky, sinon ¯\_(ツ)_/¯ 
$ curl -SL https://github.com/ytdl-org/ytdl-nightly/releases/download/2024.02.23/youtube-dl -o /usr/local/bin/youtube-dl
$ chmod +x /usr/local/bin/youtube-dl
```

Comme toujours, **PRENEZ LE TEMPS** de manipuler la commande et d'explorer un peu le `youtube-dl --help`.

Le contenu de votre script :

➜ **1. Permettre le téléchargement d'une vidéo youtube dont l'URL est passée au script**

- **la vidéo devra être téléchargée dans le dossier `/opt/yt/downloads/`**
  - tester que le dossier existe
  - vous pouvez utiliser la commande 🐚 `exit` pour que le script s'arrête
- plus précisément, **chaque téléchargement de vidéo créera un dossier**
  - `/opt/yt/downloads/<NOM_VIDEO>`
  - il vous faudra donc, avant de télécharger la vidéo, exécuter une commande pour récupérer son nom afin de créer le dossier en fonction
- la vidéo sera téléchargée dans
  - `/opt/yt/downloads/<NOM_VIDEO>/<NOM_VIDEO>.mp4`
- **la description de la vidéo sera aussi téléchargée**
  - dans `/opt/yt/downloads/<NOM_VIDEO>/description`
  - on peut récup la description avec une commande `youtube-dl`
- **la commande `youtube-dl` génère du texte dans le terminal, ce texte devra être masqué**
  - vous pouvez utiliser une redirection de flux vers `/dev/null`, c'est ce que l'on fait généralement pour se débarasser d'une sortie non-désirée

Il est possible de récupérer les arguments passés au script dans les variables `$1`, `$2`, etc.

```bash
$ cat script.sh
echo $1

$ ./script.sh toto
toto
```

➜ **2. Le script produira une sortie personnalisée**

- utilisez la commande `echo` pour écrire dans le terminal
- la sortie **DEVRA** être comme suit :

```bash
$ /opt/yt.sh https://www.youtube.com/watch?v=sNx57atloH8
Video https://www.youtube.com/watch?v=sNx57atloH8 was downloaded. 
File path : /srv/yt/downloads/tomato anxiety/tomato anxiety.mp4`
```

➜ **3. A chaque vidéo téléchargée, votre script produira une ligne de log dans le fichier `/var/log/yt/download.log`**

- votre script doit s'assurer que le dossier `/var/log/yt/` existe
  - tester que le dossier existe
  - sinon quitter en appelant la commande `exit`
- la ligne doit être comme suit :

```
[yy/mm/dd hh:mm:ss] Video <URL> was downloaded. File path : <PATH>`
```

Par exemple :

```
[21/11/12 13:22:47] Video https://www.youtube.com/watch?v=sNx57atloH8 was downloaded. File path : /srv/yt/downloads/tomato anxiety/tomato anxiety.mp4`
```

> Hint : La commande `date` permet d'afficher la date et de choisir à quel format elle sera affichée. Idéal pour générer des logs. [J'ai trouvé ce lien](https://www.geeksforgeeks.org/date-command-linux-examples/), premier résultat google pour moi, y'a de bons exemples (en bas de page surtout pour le formatage de la date en sortie).

### B. Rendu attendu

🌞 **Vous fournirez dans le compte-rendu :**

```
#!/bin/bash

# Vérifier si le dossier /var/log/yt existe
if [ ! -d "/var/log/yt" ]; then
    echo "Le dossier /var/log/yt n'existe pas. Veuillez le créer et réessayer."
    exit 1
fi

# Vérifier si le dossier /opt/yt/downloads existe
if [ ! -d "/opt/yt/downloads" ]; then
    echo "Le dossier /opt/yt/downloads n'existe pas. Veuillez le créer et réessayer."
    exit 1
fi

# Récupérer l'URL passée en argument
URL=$1

# Récupérer le nom de la vidéo
VIDEO_NAME=$(yt-dlp --get-title "$URL" | sed 's/ /_/g')

# Créer le dossier de téléchargement
mkdir -p "/opt/yt/downloads/$VIDEO_NAME"

# Télécharger la vidéo
yt-dlp -o "/opt/yt/downloads/$VIDEO_NAME/$VIDEO_NAME.mp4" "$URL" > /dev/null 2>&1

# Télécharger la description
yt-dlp --get-description "$URL" > "/opt/yt/downloads/$VIDEO_NAME/description" 2>/dev/null

# Enregistrer dans les logs
DATE=$(date +"[%y/%m/%d %H:%M:%S]")
echo "$DATE Video $URL was downloaded. File path : /opt/yt/downloads/$VIDEO_NAME/$VIDEO_NAME.mp4" >> /var/log/yt/download.log

# Afficher un message de confirmation
echo "Video $URL was downloaded."
echo "File path : /opt/yt/downloads/$VIDEO_NAME/$VIDEO_NAME.mp4"
```

## 2. MAKE IT A SERVICE

### A. Adaptation du script

YES. Yet again. **On va en faire un *service*.**

L'idée :

➜ plutôt que d'appeler la commande à la main quand on veut télécharger une vidéo, **on va créer un service qui les téléchargera pour nous**

➜ **le service s'exécute en permanence en tâche de fond**

- il surveille un fichier précis
- s'il trouve une nouvelle ligne dans le fichier, il vérifie que c'est bien une URL de vidéo youtube
  - si oui, il la télécharge, puis enlève la ligne
  - sinon, il enlève juste la ligne

➜ **qui écrit dans le fichier pour ajouter des URLs ? Bah vous !**

- vous pouvez écrire une liste d'URL, une par ligne, et le service devra les télécharger une par une

---

Pour ça, procédez par étape :

- **partez de votre script précédent** (gardez une copie propre du premier script, qui doit être livré dans le dépôt git)
  - le nouveau script s'appellera `yt-next-gen.sh` xd
  - vous le stockerez aussi dans `/opt/yt/`
- **adaptez-le pour qu'il lise les URL dans un fichier** plutôt qu'en argument sur la ligne de commande
- le script comporte une boucle qui :
  - lit un fichier ligne par ligne (chaque ligne contient une URL de vidéo youtube)
  - il télécharge la vidéo à l'URL indiquée
- une fois le fichier vide, le script se termine

### B. Le service

➜ **une fois que tout ça fonctionne, enfin, créez un service** qui lance votre script :

- créez un fichier `/etc/systemd/system/yt.service`. Il comporte :
  - une brève description
  - un `ExecStart` pour indiquer que ce service sert à lancer votre script
  - une clause `User=` pour indiquer que c'est l'utilisateur `yt` qui lance le script
    - créez l'utilisateur s'il n'existe pas
    - faites en sorte que le dossier `/opt/yt` et tout son contenu lui appartienne
    - le dossier de log doit lui appartenir aussi
    - l'utilisateur `yt` ne doit pas pouvoir se connecter sur la machine

```bash
[Unit]
Description=<Votre description>

[Service]
Type=oneshot
ExecStart=<Votre script>
User=yt

[Install]
WantedBy=multi-user.target
```

> Pour rappel, après la moindre modification dans le dossier `/etc/systemd/system/`, vous devez exécuter la commande `sudo systemctl daemon-reload` pour dire au système de lire les changements qu'on a effectué.

Vous pourrez alors interagir avec votre service à l'aide des commandes habituelles `systemctl` :

- `systemctl status yt`
- `sudo systemctl start yt`
- `sudo systemctl stop yt`

![Now witness](./img/now_witness.png)

### C. Rendu attendu

🌞 **Toutes les commandes que vous utilisez**
```
#!/bin/bash

# Chemins
DOWNLOAD_DIR="/opt/yt/downloads"
LOG_DIR="/var/log/yt"
LOG_FILE="$LOG_DIR/download.log"

# Vérifier si yt-dlp est installé
if ! command -v yt-dlp &> /dev/null; then
    echo "yt-dlp n'est pas installé. Veuillez l'installer avant d'exécuter ce script."
    exit 1
fi

# Vérifier que le dossier DOWNLOAD_DIR existe
if [ ! -d "$DOWNLOAD_DIR" ]; then
    echo "Le dossier $DOWNLOAD_DIR n'existe pas. Assurez-vous qu'il est créé et accessible."
    exit 1
fi

# Vérifier que le dossier LOG_DIR existe
if [ ! -d "$LOG_DIR" ]; then
    echo "Le dossier $LOG_DIR n'existe pas. Assurez-vous qu'il est créé et accessible."
    exit 1
fi

# Vérifier si une URL est passée en argument
if [ -z "$1" ]; then
    echo "Veuillez fournir une URL YouTube."
    exit 1
fi

URL="$1"

# Récupérer le nom de la vidéo
VIDEO_NAME=$(yt-dlp --get-title "$URL" 2>/dev/null | tr -d '/\\:*?\"<>|')
if [ -z "$VIDEO_NAME" ]; then
    echo "Impossible de récupérer le nom de la vidéo. Vérifiez l'URL."
    exit 1
fi

# Créer un dossier spécifique pour la vidéo
VIDEO_DIR="$DOWNLOAD_DIR/$VIDEO_NAME"
mkdir -p "$VIDEO_DIR"

# Télécharger la vidéo
VIDEO_PATH="$VIDEO_DIR/$VIDEO_NAME.mp4"
yt-dlp -o "$VIDEO_PATH" "$URL" > /dev/null 2>&1

# Télécharger la description
DESCRIPTION_PATH="$VIDEO_DIR/description"
yt-dlp --get-description "$URL" > "$DESCRIPTION_PATH" 2>/dev/null

# Sortie utilisateur
echo "Video $URL was downloaded."
echo "File path : $VIDEO_PATH"

# Journaliser l'opération
DATE=$(date "+%y/%m/%d %H:%M:%S")
echo "[$DATE] Video $URL was downloaded. File path : $VIDEO_PATH" >> "$LOG_FILE"
```
```
[abc@node1 ~]$ Video https://www.youtube.com/watch?v=dQw4w9WgXcQ was downloaded.
[abc@node1 ~]$ File path : /opt/yt/downloads/Never Gonna Give You Up/Never Gonna Give You Up.mp4
```
```
[abc@node1 ~]$ cat /var/log/yt/download.log
#!/bin/bash

# Vérifier si le dossier /var/log/yt existe
if [ ! -d "/var/log/yt" ]; then
    echo "Le dossier /var/log/yt n'existe pas. Veuillez le créer et réessayer."
    exit 1
fi

# Vérifier si le dossier /opt/yt/downloads existe
if [ ! -d "/opt/yt/downloads" ]; then
    echo "Le dossier /opt/yt/downloads n'existe pas. Veuillez le créer et réessayer."
    exit 1
fi

# Récupérer l'URL passée en argument
URL=$1
echo "URL: $URL"  # Ajoutez cette ligne pour afficher l'URL

# Récupérer le nom de la vidéo
VIDEO_NAME=$(yt-dlp --get-title "$URL" | sed 's/ /_/g')
echo "Nom de la vidéo: $VIDEO_NAME"  # Ajoutez cette ligne pour afficher le nom de la vidéo

# Créer le dossier de téléchargement
mkdir -p "/opt/yt/downloads/$VIDEO_NAME"

# Télécharger la vidéo
yt-dlp -o "/opt/yt/downloads/$VIDEO_NAME/$VIDEO_NAME.mp4" "$URL" > /dev/null 2>&1

# Télécharger la description
yt-dlp --get-description "$URL" > "/opt/yt/downloads/$VIDEO_NAME/description" 2>/dev/null

# Enregistrer dans les logs
DATE=$(date +"[%y/%m/%d %H:%M:%S]")
echo "$DATE Video $URL was downloaded. File path : /opt/yt/downloads/$VIDEO_NAME/$VIDEO_NAME.mp4" >> /var/log/yt/download.log
echo "Log écrit dans /var/log/yt/download.log"  # Confirmer que le log est écrit

# Afficher un message de confirmation
echo "Video $URL was downloaded."
echo "File path : /opt/yt/downloads/$VIDEO_NAME/$VIDEO_NAME.mp4"

[abc@node1 ~]$
```

🌞 **Le script `yt-next-gen.sh` dans le dépôt git**

🌞 **Le fichier `yt.service` dans le dépôt git**



🌟**BONUS** : get fancy. Livrez moi un gif ou un [asciinema](https://asciinema.org/) (PS : c'est le feu asciinema) de votre service en action, où on voit les URLs de vidéos disparaître, et les fichiers apparaître dans le fichier de destination

## 3. Bonus

Quelques bonus pour améliorer le fonctionnement de votre script et votre skill sur `bash` :

➜ **en accord avec les règles de [ShellCheck](https://www.shellcheck.net/)**

- bonnes pratiques, sécurité, lisibilité

➜ **votre script a une gestion d'options :**

- `-q` (comme *quality*) pour préciser la qualité des vidéos téléchargées (on peut choisir avec `youtube-dl`)
- `-o` (comme *output*) pour préciser un dossier autre que `/srv/yt/downloads/`
- `-h` (comme *help*) affiche l'usage

➜ **si votre script utilise des commandes non-présentes à l'installation** (`youtube-dl`, `jq` éventuellement, etc.)

- vous devez TESTER leur présence et refuser l'exécution du script
- le script refuse de s'exécuter si des commandes qu'il utilise ne sont pas installée, normal quoi !

➜  **contrôle d'existence et des permissions des dossiers**

- vous devez tester leur présence, sinon refuser l'exécution du script
- ajoutez des tests de contrôles sur les dossiers :
  - vérifier que `/srv/yt/downloads/` existe c'est bien
  - vérifier en + qu'on peut écrire à l'intérieur, c'est mieux

➜ **contrôle d'URL**

- contrôlez à l'aide d'une expression régulière que les strings saisies dans le fichier sont bien des URLs de vidéos Youtube
- si c'est pas une URL de vidéo youtube valide, supprimez la ligne, et générez une ligne de log qui indique que l'URL saisie n'était pas valide

➜ ***service* + *timer***

- plutôt que faire un script avec une boucle infinie et un `sleep` dégueulasses
- enlevez complètement la boucle infinie, et faites en sorte que le script soit juste one-shot :
  - il se lance, regarde le fichier, télécharge les vidéos indiquées, et quitte
- créez un *timer* pour lancer le service à intervalles réguliers
- un *timer* permet de déclencher l'exécution d'un service à intervalles réguliers
- appelez-moi si vous faites cette partie, je vous montre comment faire ça en deux-deux

> Notre OS a déjà la capacité de lancer un truc à intervalles réguliers, pourquoi faire une boucle infinie dégueue, et avoir notre programme qui passe le plus clair de son temps à ne rien faire ?

➜  **fonction `usage`**

- le script comporte une fonction `usage`
- c'est la fonction qui est appelée lorsque l'on appelle le script avec une erreur de syntaxe
- ou lorsqu'on appelle le `-h` du script