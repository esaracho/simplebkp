#!/bin/bash
#Copyright 2016 - Esteban Daniel Saracho
#
#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.

#contraseña si el fichero va a ser encriptado
PASS="abc123"

#Define el nombre del fichero
FILENAME=`date +%d-%m-%G`".tar.gz"

#muestra la ayuda
function showhelp(){
  echo -e "simplebkp [-e] [-c] -o <directorio de origen> -d <directorio de destino>\n
  -e Encriptar el fichero de backup
  -c subir el fichero de backup a Google Drive\n"
  exit 0
}

#se parsean los argumentos

while [ $# -ne 0 ]
do
  case "$1" in
    -h|--help)
      showhelp
      ;;
    -c)
      CLOUD=1
      ;;
    -e)
      ENC=1
      ;;
    -o)
      ORIGEN="$2"
      shift
      ;;
    -d)
      DESTINO="$2"
      shift
      ;;
    *)
      echo -e "Argumento no valido\n"
      showhelp
      ;;
    esac
    shift
done

#verifica directorio de destino y origen
if [[ -z $ORIGEN ]] || [[ -z $DESTINO ]]
then
  echo "Los directorios de origen y destino son obligatorios\n"
  showhelp
fi

#realiza el backup
tar cvzf $DESTINO/$FILENAME $ORIGEN

#encripta el fichero
if [ -n "$ENC" ]
then
  FILENAMEENC=$FILENAME".enc"
  openssl enc -e -aes-256-cbc -pass pass:$PASS -in $DESTINO/$FILENAME -out $DESTINO/$FILENAMEENC
  FILENAME=$FILENAMEENC
fi

#sube el archivo a google drive
if [ -n "$CLOUD" ]
then
  gdrive upload $DESTINO/$FILENAME
fi
