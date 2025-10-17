#!/bin/bash

TMP_KEY="aes_key_$$.bin"

echo "Cifrado híbrido RSA + AES"
echo "1) Cifrar archivo"
echo "2) Descifrar archivo"
echo "3) Volver al menú"
read -p "Seleccione una opción: " opt

case $opt in
    1)
        read -p "Archivo a cifrar: " infile
        read -p "Clave pública RSA: " pubkey
        read -p "Archivo de salida (sin extensión): " outfile

        if [[ ! -f "$pubkey" || ! -f "$infile" ]]; then
            echo "Archivo o clave no encontrado."
            exit 1
        fi

        # Generar clave AES temporal y cifrar
        openssl rand 32 > "$TMP_KEY"
        openssl enc -aes-256-cbc -pbkdf2 -salt -in "$infile" -out "${outfile}.enc" -pass file:"$TMP_KEY"
        openssl pkeyutl -encrypt -inkey "$pubkey" -pubin -in "$TMP_KEY" -out "${outfile}.key.enc"

        # Eliminar clave temporal
        shred -u "$TMP_KEY" 2>/dev/null || rm -f "$TMP_KEY"

        echo "✅ Archivo cifrado en ${outfile}.enc"
        echo "✅ Clave AES cifrada en ${outfile}.key.enc"
        ;;
    2)
        read -p "Archivo cifrado (.enc): " infile
        read -p "Clave cifrada (.key.enc): " keyfile
        read -p "Clave privada RSA: " privkey
        read -p "Archivo de salida descifrado: " outfile

        if [[ ! -f "$privkey" || ! -f "$infile" || ! -f "$keyfile" ]]; then
            echo "Archivos requeridos no encontrados."
            exit 1
        fi

        # Recuperar clave AES temporalmente
        openssl pkeyutl -decrypt -inkey "$privkey" -in "$keyfile" -out "$TMP_KEY" || {
            echo "Error al descifrar la clave AES."
            exit 1
        }

        # Descifrar archivo
        openssl enc -d -aes-256-cbc -pbkdf2 -in "$infile" -out "$outfile" -pass file:"$TMP_KEY"

        shred -u "$TMP_KEY" 2>/dev/null || rm -f "$TMP_KEY"

        echo "Archivo descifrado correctamente en $outfile"
        ;;
    3)
        exit 0
        ;;
    *)
        echo "Opción no válida."
        ;;
esac
read -p "Pulse Enter para volver al menú..."