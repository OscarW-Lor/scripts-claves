#!/bin/bash


echo "Cifrado simétrico AES-256"
echo "1) Generar clave"
echo "2) Cifrar archivo"
echo "3) Descifrar archivo"
echo "4) Volver al menú"
read -p "Seleccione una opción: " opt

case $opt in
    1)
        read -p "Ruta para guardar la clave (por ejemplo key.bin): " keyfile
        openssl rand 32 > "$keyfile" || { echo "Error al generar la clave."; exit 1; }
        chmod 600 "$keyfile"
        echo "✅ Clave segura generada en $keyfile"
        ;;
    2)
        read -p "Archivo a cifrar: " infile
        read -p "Archivo de salida: " outfile
        read -p "Clave (key.bin): " keyfile

        if [[ ! -f "$keyfile" ]]; then
            echo "Clave no encontrada."
            exit 1
        fi

        openssl enc -aes-256-cbc -pbkdf2 -salt -in "$infile" -out "$outfile" -pass file:"$keyfile" 2>/dev/null || {
            echo "Error al cifrar el archivo."
            exit 1
        }
        echo "✅ Archivo cifrado correctamente."
        ;;
    3)
        read -p "Archivo cifrado: " infile
        read -p "Archivo de salida descifrado: " outfile
        read -p "Clave (key.bin): " keyfile

        if [[ ! -f "$keyfile" ]]; then
            echo "Clave no encontrada."
            exit 1
        fi

        openssl enc -d -aes-256-cbc -pbkdf2 -in "$infile" -out "$outfile" -pass file:"$keyfile" 2>/dev/null || {
            echo "Error al descifrar. Verifique la clave o el archivo."
            exit 1
        }
        echo "Archivo descifrado en $outfile"
        ;;
    4)
        exit 0
        ;;
    *)
        echo "Opción no válida."
        ;;
esac
read -p "Pulse Enter para volver al menú..."