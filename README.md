Requisitos:
Bash ("/bin/bash")
OpenSSL (instalable con "sudo apt install openssl")
 
Antes de ejecutar, otorga permisos:
chmod +x *.sh

Los scripts se organiza mediante un menú principal que redirige a diferentes scripts especializados mediante OpenSSL:

Generación de claves RSA (2048 o 4096 bits): crea claves pública y privada en formato PEM.
./rsa_keys.sh
Tamaño: 2048
Ruta base: ./mis_claves/clave 
=> Genera clave_private.pem y clave_public.pem

Cifrado simétrico AES-256: permite generar una clave aleatoria, cifrar y descifrar archivos con AES y PBKDF2.
./aes_sym.sh
1) Generar clave (key.bin)
2) Cifrar archivo
3) Descifrar archivo

Cifrado híbrido (RSA + AES): combina cifrado simétrico y asimétrico; cifra un archivo con AES y protege la clave AES con RSA.
1) Cifrar archivo (usa clave pública RSA)
2) Descifrar archivo (usa clave privada RSA)

Cifrar
./hybrid_crypto.sh  # opción 1
=> genera archivo.enc y archivo.key.enc

Descifrar
./hybrid_crypto.sh  # opción 2
=> produce archivo_descifrado.txt

Gestión de claves públicas: permite visualizar, buscar, importar y exportar claves públicas dentro de un “keyring” local.
1) Visualizar clave pública
2) Buscar claves (*.pem, *.pub)
3) Importar clave a keyring local
4) Exportar clave pública


El cifrado híbrido combina dos técnicas criptográficas:
Cifrado simétrico (AES-256):
Se utiliza una clave aleatoria (temporal) para cifrar el archivo.
Este método es rápido y eficiente para grandes volúmenes de datos.

Cifrado asimétrico (RSA):
La clave AES se cifra con la clave pública RSA del destinatario.
Solo quien posea la clave privada RSA puede recuperar la clave AES y, por tanto, descifrar el archivo.

