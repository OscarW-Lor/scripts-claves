#!/bin/bash
if ! command -v openssl &>/dev/null; then
    echo "Error: OpenSSL no está instalado. Instálalo con 'sudo apt install openssl'"
    exit 1
fi

while true; do
    clear
    echo "MENÚ PRINCIPAL"
    echo "1) Generar claves RSA (2048 / 4096)"
    echo "2) Cifrado simétrico AES-256"
    echo "3) Cifrado híbrido (RSA + AES)"
    echo "4) Gestión de claves públicas"
    echo "5) Salir"
    read -p "Seleccione una opción [1-5]: " opcion

    case $opcion in
        1) bash rsa_keys.sh ;;
        2) bash aes_sym.sh ;;
        3) bash hybrid_crypto.sh ;;
        4) bash pubkey_mgmt.sh ;;
        5) echo "Saliendo del programa..."; exit 0 ;;
        *) echo "Opción no válida. Intente de nuevo."; sleep 10 ;;
    esac
done