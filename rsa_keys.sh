#!/bin/bash

echo "Generar claves RSA"
read -p "Tamaño (2048 o 4096): " bits

if [[ "$bits" != "2048" && "$bits" != "4096" ]]; then
    echo "Tamaño inválido. Solo se permiten 2048 o 4096 bits."
    exit 1
fi

read -p "Ruta base para guardar (sin extensión): " ruta

if [[ -z "$ruta" ]]; then
    echo "Debe indicar una ruta de salida."
    exit 1
fi

# Crear clave privada y pública
openssl genpkey -algorithm RSA -out "${ruta}_private.pem" -pkeyopt rsa_keygen_bits:$bits 2>/dev/null
if [[ $? -ne 0 ]]; then
    echo "Error al generar la clave privada."
    exit 1
fi

openssl rsa -in "${ruta}_private.pem" -pubout -out "${ruta}_public.pem" 2>/dev/null

echo "Claves generadas con éxito:"
echo " - Privada: ${ruta}_private.pem"
echo " - Pública: ${ruta}_public.pem"
read -p "Pulse Enter para volver al menú..."