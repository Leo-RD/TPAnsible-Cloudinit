#!/bin/sh
# Ce script doit être exécuté par /bin/sh

DISK_NAME="disk.qcow2"
SEED_ISO="seed.iso"

# Emplacement standard du firmware UEFI (edk2) installé via Homebrew sur Mac ARM
EFI_ROM="/opt/homebrew/share/qemu/edk2-aarch64-code.fd"

# Vérification basique
if [ ! -f "$DISK_NAME" ] || [ ! -f "$SEED_ISO" ]; then
    echo "Erreur : Les fichiers disques sont introuvables."
    echo "Avez-vous bien exécuté 01_setup_vm.sh ?"
    exit 1
fi

if [ ! -f "$EFI_ROM" ]; then
    echo "Erreur : Firmware UEFI introuvable dans $EFI_ROM."
    echo "Veuillez vérifier que QEMU est bien installé via Homebrew."
    exit 1
fi

echo "==> Démarrage de la VM sur Apple Silicon (accélération HVF)..."
echo "Pour quitter QEMU proprement : Appuyez sur Ctrl+A puis X."

# Lancement sans interface graphique (-nographic)
qemu-system-aarch64 \
    -machine virt,accel=hvf \
    -cpu host \
    -smp 2 \
    -m 2048 \
    -drive "if=pflash,format=raw,file=$EFI_ROM,readonly=on" \
    -nographic \
    -drive "if=virtio,format=qcow2,file=$DISK_NAME" \
    -drive "if=virtio,format=raw,file=$SEED_ISO" \
    -netdev user,id=net0,hostfwd=tcp::2222-:22,hostfwd=tcp::8080-:8080 \
    -device virtio-net-pci,netdev=net0
