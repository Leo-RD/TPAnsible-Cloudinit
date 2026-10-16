#!/bin/sh
# Ce script doit être exécuté par /bin/sh (POSIX strict, pas de bashism)

# --- Variables ---
IMG_NAME="ubuntu-24.04-server-cloudimg-arm64.img"
DISK_NAME="disk.qcow2"
SEED_ISO="seed.iso"
USER_NAME="camarade"
SSH_KEY_PATH="ssh_camarade_ed25519"
CIDATA_DIR="cidata" # <-- La  variable demandée

# 1. Nettoyage de l'environnement
echo "Nettoyage des anciens fichiers..."
rm -f "$DISK_NAME" "$SEED_ISO"
rm -rf "$CIDATA_DIR"

# 2. Préparation du disque
echo "Création du nouveau disque..."
cp "$IMG_NAME" "$DISK_NAME"
qemu-img resize "$DISK_NAME" +10G # image cloud trop petite (2,4 Go) pour installer MySQL

# 3. Extraction de la clé publique (sans le commentaire parasite à la fin)
# awk '{print $1, $2}' permet de ne garder que "ssh-ed25519" et "la_clé_base64", ignorant le reste
PUB_KEY=$(awk '{print $1, $2}' "${SSH_KEY_PATH}.pub")

# 4. Création des fichiers Cloud-init
echo "Création de la configuration Cloud-init..."
mkdir -p "$CIDATA_DIR"

cat <<EOF > "$CIDATA_DIR/user-data"
#cloud-config
disable_root: true
ssh_pwauth: false

# On empêche Cloud-init de chercher ou configurer l'utilisateur 'ubuntu' par défaut
# Cela supprime le message d'erreur dans les logs que le prof a remarqué
users:
  - name: $USER_NAME
    shell: /bin/bash
    sudo: ALL=(ALL) NOPASSWD:ALL
    lock_passwd: true
    ssh_authorized_keys:
      - "$PUB_KEY"
EOF

cat <<EOF > "$CIDATA_DIR/meta-data"
instance-id: vm-cloud-03
local-hostname: vm-cloud
EOF

# 5. Création de l'ISO avec notre variable
echo "Génération de l'ISO..."
hdiutil makehybrid -o "$SEED_ISO" -iso -joliet -default-volume-name "$CIDATA_DIR" "$CIDATA_DIR/" >/dev/null

echo "==> Configuration terminée avec succès !"
