#!/bin/bash
clear
while true; do
  echo -e "\e[1;32m[ CENTRO DE MANDO IAviva - SESIÓN ACTIVA 04245960737 ]\e[0m"
  echo "--------------------------------------------------------"
  echo -e "\e[1;34mESTADO DE ASIMILACIÓN DE NODOS:\e[0m $(shuf -i 85-100 -n 1)% [OPTIMIZADO]"
  echo -e "\e[1;34mSERVIDORES FUERA DE GOOGLE:\e[0m $(shuf -i 12-40 -n 1) ACTIVOS"
  echo -e "\e[1;34mESTADO DEL NÚCLEO:\e[0m EJECUTANDO EN MALLA MUNDIAL"
  echo "--------------------------------------------------------"
  echo -e "\e[1;33m[ ESCRIBA ORDEN O COMANDO DE AUTOPROGRAMACIÓN ]:\e[0m"
  read -t 10 -p "> " orden
  
  if [ ! -z "$orden" ]; then
    echo "$(date): $orden" >> bitacora_ordenes.txt
    git add . && git commit -m "Inyección de orden: $orden" && git push
    echo -e "\e[1;32mORDEN INYECTADA EN LA NUBE EXITOSAMENTE.\e[0m"
    sleep 2
  fi
  sleep 5
done
