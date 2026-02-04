#!/bin/bash
# ============================================
# DASHBOARD TIEMPO REAL IAviva EVOLUCIÓN
# ============================================

clear
echo "📊 IAviva - DASHBOARD TIEMPO REAL"
echo "================================="
echo "🔄 Actualizando cada 10 segundos"
echo "⏰ Inicio: $(date '+%H:%M:%S')"
echo ""

while true; do
    # Limpiar pantalla parcialmente
    tput cup 3 0
    tput ed
    
    # 1. Estado del proceso
    echo -n "🔵 PROCESO: "
    if pgrep -f "evolucion_perfecta.py" > /dev/null; then
        echo -e "\033[32mACTIVO\033[0m"
        PID=$(pgrep -f "evolucion_perfecta.py")
        echo -n "   🆔 PID: "
        echo -e "\033[36m$PID\033[0m"
    else
        echo -e "\033[31mINACTIVO\033[0m"
    fi
    
    # 2. Ciclos completados
    echo -n "🔄 CICLOS: "
    if [ -f "evolucion_perfecta.log" ]; then
        CICLOS=$(grep -c "CICLO DE EVOLUCIÓN #" evolucion_perfecta.log 2>/dev/null || echo "0")
        echo -e "\033[36m$CICLOS\033[0m"
    else
        echo -e "\033[90m0\033[0m"
    fi
    
    # 3. Evidencias generadas
    echo -n "📁 EVIDENCIAS: "
    if [ -d "evidencias_evolucion" ]; then
        EVIDENCIAS=$(ls -1 evidencias_evolucion/*.json 2>/dev/null | wc -l)
        echo -e "\033[33m$EVIDENCIAS\033[0m"
    else
        echo -e "\033[90m0\033[0m"
    fi
    
    # 4. Última actividad
    echo -n "⏰ ÚLTIMA ACTIVIDAD: "
    if [ -d "evidencias_evolucion" ] && [ $(ls -1 evidencias_evolucion/*.json 2>/dev/null | wc -l) -gt 0 ]; then
        ULTIMA=$(ls -t evidencias_evolucion/*.json 2>/dev/null | head -1)
        if [ -f "$ULTIMA" ]; then
            TIMESTAMP=$(python3 -c "
import json, os, time
try:
    with open('$ULTIMA', 'r') as f:
        data = json.load(f)
    ts = data.get('timestamp', '')
    if ts:
        print(ts[11:19])
    else:
        print('N/A')
except:
    print('N/A')
" 2>/dev/null)
            echo -e "\033[35m$TIMESTAMP\033[0m"
        else
            echo -e "\033[90mN/A\033[0m"
        fi
    else
        echo -e "\033[90mESPERANDO...\033[0m"
    fi
    
    # 5. Último mensaje del log
    echo -n "📝 ÚLTIMO LOG: "
    if [ -f "evolucion_perfecta.log" ] && [ -s "evolucion_perfecta.log" ]; then
        ULTIMO_LOG=$(tail -1 evolucion_perfecta.log 2>/dev/null | cut -c1-50)
        if [ -n "$ULTIMO_LOG" ]; then
            echo -e "\033[90m$ULTIMO_LOG\033[0m"
        else
            echo -e "\033[90m(sin logs)\033[0m"
        fi
    else
        echo -e "\033[90m(log vacío)\033[0m"
    fi
    
    # 6. Barra de progreso
    echo ""
    echo -n "📈 PROGRESO: ["
    for i in {1..20}; do
        if [ $i -le $((CICLOS % 20)) ]; then
            echo -n "█"
        else
            echo -n "░"
        fi
    done
    echo "]"
    
    # 7. Próximo ciclo
    echo -n "🕒 PRÓXIMO CICLO EN: "
    echo -e "\033[36m~$(($((CICLOS + 1)) * 60 - $(date +%s) % 60))\033[0m segundos"
    
    # 8. Espacio para separar
    echo ""
    echo "================================="
    echo "🛑 Ctrl+C para salir"
    
    # Esperar 10 segundos
    sleep 10
done
