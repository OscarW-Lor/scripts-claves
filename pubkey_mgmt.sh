#!/bin/bash

KEYRING="./keyring"
mkdir -p "$KEYRING"

echo "Gestión de claves públicas"
echo "1) Visualizar clave pública"
echo "2) Buscar claves públicas"
echo "3) Importar clave al keyring local"
echo "4) Exportar clave pública"
echo "5) Volver al menú"
read -p "Seleccione una opción: " opt

case $opt in
    1)
        read -p "Ruta de la clave pública: " keyfile
        if [[ -f "$keyfile" ]]; then
            echo "----- CONTENIDO DE ${keyfile} -----"
            cat "$keyfile"
        else
            echo "Clave no encontrada."
        fi
        ;;
    2)
        read -p "Directorio donde buscar: " dir
        echo "🔍 Buscando claves públicas en $dir..."
        find "$dir" -type f \( -name "*.pem" -o -name "*.pub" -o -name "*_public.pem" \)
        ;;
    3)
        read -p "Ruta de la clave a importar: " src
        if [[ -f "$src" ]]; then
            cp "$src" "$KEYRING/"
            chmod 600 "$KEYRING/$(basename "$src")"
            echo "Clave importada en $KEYRING"
        else
            echo "Archivo no encontrado."
        fi
        ;;
    4)
        read -p "Nombre de la clave a exportar (en keyring): " src
        read -p "Ruta destino: " dst
        if [[ -f "$KEYRING/$src" ]]; then
            cp "$KEYRING/$src" "$dst"
            echo "Clave exportada a $dst"
        else
            echo "Clave no encontrada en el keyring."
        fi
        ;;
    5)
        exit 0
        ;;
    *)
        echo "Opción no válida."
        ;;
esac
read -p "Pulse Enter para volver al menú..."