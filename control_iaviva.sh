#!/bin/bash
# ============================================
# CONTROL UNIFICADO IAviva
# ============================================

IAVIVA_DIR="~/IAviva_FINAL"
IAVIVA_SCRIPT="iaviva_unificado_final.py"
IAVIVA_PORT=8000

cd $IAVIVA_DIR 2>/dev/null || { echo "❌ Error: No se encuentra $IAVIVA_DIR"; exit 1; }

case "$1" in
    start)
        echo "🚀 INICIANDO IAviva UNIFICADO..."
        
        # Detener procesos anteriores
        pkill -f "python3.*$IAVIVA_SCRIPT" 2>/dev/null || true
        sleep 2
        
        # Iniciar nuevo proceso
        nohup python3 $IAVIVA_SCRIPT > iaviva_unificado.log 2>&1 &
        IAVIVA_PID=$!
        
        echo "✅ Proceso iniciado (PID: $IAVIVA_PID)"
        echo "📄 Logs: iaviva_unificado.log"
        
        # Esperar a que esté listo
        sleep 8
        
        # Verificar
        if curl -s http://localhost:$IAVIVA_PORT/health > /dev/null 2>&1; then
            echo "🌐 Servidor activo: http://localhost:$IAVIVA_PORT"
            echo "🤖 Sistema: OPERATIVO Y EN EVOLUCIÓN"
        else
            echo "⚠️  Servidor no responde, revisar logs"
        fi
        ;;
    
    stop)
        echo "🛑 DETENIENDO IAviva..."
        pkill -f "python3.*$IAVIVA_SCRIPT" 2>/dev/null && echo "✅ Sistema detenido" || echo "⚠️  No había procesos activos"
        ;;
    
    status)
        echo "🔍 ESTADO DE IAviva UNIFICADO"
        echo "============================="
        
        # Proceso
        if pgrep -f "python3.*$IAVIVA_SCRIPT" > /dev/null; then
            PID=$(pgrep -f "python3.*$IAVIVA_SCRIPT")
            echo "✅ Proceso ACTIVO (PID: $PID)"
            echo "🕒 Tiempo: $(ps -o etime= -p $PID 2>/dev/null | tr -d ' ')"
        else
            echo "❌ Proceso INACTIVO"
        fi
        
        # Servidor web
        echo ""
        echo "🌐 SERVIDOR WEB:"
        if curl -s http://localhost:$IAVIVA_PORT/health > /dev/null 2>&1; then
            echo "✅ ACTIVO (puerto $IAVIVA_PORT)"
            # Mostrar estado
            curl -s http://localhost:$IAVIVA_PORT/estado | python3 -c "
import json, sys
try:
    data = json.load(sys.stdin)
    print('📊 Versión:', data.get('version', 'N/A'))
    print('🎯 Estado:', data.get('estado', 'N/A'))
    print('🔄 Ciclos:', data.get('estadisticas', {}).get('ciclos_completados', 0))
    print('✨ Mejoras:', data.get('estadisticas', {}).get('mejoras_aplicadas', 0))
except:
    print('   (No se pudo obtener detalles)')
" 2>/dev/null
        else
            echo "❌ NO RESPONDE"
        fi
        
        # Evidencias
        echo ""
        echo "📁 EVIDENCIAS:"
        if [ -d "evidencias" ]; then
            TOTAL_EVID=$(ls -1 evidencias/*.json 2>/dev/null | wc -l)
            echo "📦 Total: $TOTAL_EVID archivos"
            
            if [ $TOTAL_EVID -gt 0 ]; then
                ULTIMA=$(ls -t evidencias/*.json 2>/dev/null | head -1)
                echo "🕒 Última: $(basename $ULTIMA)"
            fi
        else
            echo "📂 Carpeta no existe"
        fi
        
        # Logs
        echo ""
        echo "📄 LOGS:"
        if [ -f "iaviva_unificado.log" ]; then
            LOG_LINES=$(wc -l iaviva_unificado.log | awk '{print $1}')
            echo "📏 Líneas: $LOG_LINES"
            echo "📝 Último:"
            tail -1 iaviva_unificado.log 2>/dev/null | cut -c1-60
        else
            echo "📭 Archivo no existe"
        fi
        ;;
    
    restart)
        echo "🔄 REINICIANDO IAviva..."
        $0 stop
        sleep 3
        $0 start
        ;;
    
    logs)
        echo "📄 MOSTRANDO LOGS EN TIEMPO REAL:"
        echo "🛑 Presiona Ctrl+C para salir"
        echo "============================="
        tail -f iaviva_unificado.log
        ;;
    
    dashboard)
        echo "📊 DASHBOARD IAviva UNIFICADO"
        echo "============================="
        echo "Actualizando cada 5 segundos..."
        echo ""
        
        while true; do
            clear
            echo "📊 IAviva UNIFICADO - DASHBOARD"
            echo "⏰ $(date '+%H:%M:%S')"
            echo "============================="
            
            # Estado del proceso
            echo -n "🔵 PROCESO: "
            if pgrep -f "python3.*$IAVIVA_SCRIPT" > /dev/null; then
                echo -e "\033[32mACTIVO\033[0m"
            else
                echo -e "\033[31mINACTIVO\033[0m"
            fi
            
            # Estado del servidor
            echo -n "🌐 SERVIDOR: "
            if curl -s http://localhost:$IAVIVA_PORT/health > /dev/null 2>&1; then
                echo -e "\033[32mACTIVO\033[0m"
            else
                echo -e "\033[31mINACTIVO\033[0m"
            fi
            
            # Estadísticas
            if curl -s http://localhost:$IAVIVA_PORT/estado > /dev/null 2>&1; then
                STATS=$(curl -s http://localhost:$IAVIVA_PORT/estado)
                echo -n "🔄 CICLOS: "
                echo "$STATS" | python3 -c "
import json, sys
try:
    data = json.load(sys.stdin)
    print(data.get('estadisticas', {}).get('ciclos_completados', 0))
except:
    print('0')
" 2>/dev/null
                
                echo -n "✨ MEJORAS: "
                echo "$STATS" | python3 -c "
import json, sys
try:
    data = json.load(sys.stdin)
    print(data.get('estadisticas', {}).get('mejoras_aplicadas', 0))
except:
    print('0')
" 2>/dev/null
            fi
            
            # Evidencias
            echo -n "📁 EVIDENCIAS: "
            if [ -d "evidencias" ]; then
                TOTAL=$(ls -1 evidencias/*.json 2>/dev/null | wc -l)
                echo -e "\033[33m$TOTAL\033[0m"
            else
                echo -e "\033[90m0\033[0m"
            fi
            
            # Último log
            echo ""
            echo "📝 ÚLTIMO LOG:"
            if [ -f "iaviva_unificado.log" ]; then
                tail -1 iaviva_unificado.log 2>/dev/null | cut -c1-70
            else
                echo "(sin logs)"
            fi
            
            echo ""
            echo "============================="
            echo "🛑 Ctrl+C para salir"
            sleep 5
        done
        ;;
    
    *)
        echo "📋 USO: $0 {start|stop|status|restart|logs|dashboard}"
        echo ""
        echo "   start     - Inicia IAviva Unificado"
        echo "   stop      - Detiene IAviva"
        echo "   status    - Muestra estado completo"
        echo "   restart   - Reinicia el sistema"
        echo "   logs      - Muestra logs en tiempo real"
        echo "   dashboard - Dashboard interactivo"
        echo ""
        echo "🎯 IAviva Unificado Final v3.0.0"
        echo "🤖 Sistema perfecto sin errores"
        exit 1
        ;;
esac
