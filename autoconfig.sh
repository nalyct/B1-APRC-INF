```
#!/bin/bash

log() {
    local level=$1
    local message=$2
    echo "$(date +'%H:%M:%S') [$level] $message"
}

log "INFO" "Le script d'autoconfiguration a démarré"

# Vérification des droits root
if [ "$(id -u)" -ne 0 ]; then
    log "ERROR" "Ce script doit être exécuté en tant que root. Arrêt."
    exit 1
fi
log "INFO" "Le script a bien été lancé en root"

# Vérification et modification de SELinux
SELINUX_STATUS=$(sestatus | grep "Current mode" | awk '{print $3}')
if [ "$SELINUX_STATUS" != "permissive" ]; then
    log "WARN" "SELinux est toujours activé !"
    setenforce 0
    log "INFO" "Désactivation de SELinux temporaire (setenforce)"
else
    log "INFO" "SELinux est déjà en mode permissive (temporaire)"
fi

SELINUX_CONFIG=$(grep "^SELINUX=" /etc/selinux/config | cut -d '=' -f2)
if [ "$SELINUX_CONFIG" != "permissive" ]; then
    sed -i 's/^SELINUX=.*/SELINUX=permissive/' /etc/selinux/config
    log "INFO" "Désactivation de SELinux définitive (fichier de config)"
else
    log "INFO" "Le fichier de configuration SELinux est déjà correct"
fi

# Vérification du firewall
if systemctl is-active --quiet firewalld; then
    log "INFO" "Service de firewalling firewalld est activé"
else
    log "ERROR" "Le service firewalld n'est pas activé ! Arrêt."
    exit 1
fi

# Vérification et modification du port SSH
SSH_PORT=$(grep "^Port " /etc/ssh/sshd_config | awk '{print $2}' || echo "22")
if [ "$SSH_PORT" == "22" ]; then
    log "WARN" "Le service SSH tourne toujours sur le port 22/TCP"
    NEW_PORT=$((RANDOM % 64512 + 1024))
    sed -i "s/^#Port 22/Port $NEW_PORT/" /etc/ssh/sshd_config
    sed -i "s/^Port 22/Port $NEW_PORT/" /etc/ssh/sshd_config
    log "INFO" "Modification du fichier de configuration SSH pour écouter sur le port $NEW_PORT/TCP"
    systemctl restart sshd
    log "INFO" "Redémarrage du service SSH"
    firewall-cmd --permanent --add-port=${NEW_PORT}/tcp
    firewall-cmd --permanent --remove-port=22/tcp
    firewall-cmd --reload
    log "INFO" "Ouverture du port $NEW_PORT/TCP dans firewalld"
else
    log "INFO" "Le service SSH n'utilise pas le port 22. Configuration actuelle correcte"
fi

# Changement du nom de la machine
CURRENT_HOSTNAME=$(hostnamectl --static)
if [ "$CURRENT_HOSTNAME" == "localhost" ]; then
    if [ -n "$1" ]; then
        hostnamectl set-hostname "$1"
        log "INFO" "Changement du nom pour $1"
    else
        log "WARN" "La machine s'appelle toujours localhost ! Aucun argument de nom fourni."
        exit 1
    fi
else
    log "INFO" "Le nom de la machine est déjà configuré : $CURRENT_HOSTNAME"
fi

# Vérification et ajout de l'utilisateur au groupe wheel
USER_NAME="abc"  
if id "$USER_NAME" &>/dev/null; then
    if groups "$USER_NAME" | grep -q "wheel"; then
        log "INFO" "L'utilisateur $USER_NAME appartient déjà au groupe wheel"
    else
        log "WARN" "L'utilisateur $USER_NAME n'est pas dans le groupe wheel !"
        usermod -aG wheel "$USER_NAME"
        log "INFO" "Ajout de l'utilisateur $USER_NAME au groupe wheel"
    fi
else
    log "ERROR" "L'utilisateur $USER_NAME n'existe pas !"
    exit 1
fi

log "INFO" "Le script d'autoconfiguration s'est correctement déroulé"


```

