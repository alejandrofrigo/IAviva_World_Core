#!/data/data/com.termux/files/usr/bin/bash
cd ~/IAviva_FINAL

# Crear log de monitoreo
MONITOR_LOG="monitor_24x7.log"
echo "$(date): 🚀 Iniciando monitoreo 24/7" >> "$MONITOR_LOG"

while true; do
    # Verificar si el servidor está activo
    if ! curl -s --max-time 5 http://localhost:8000/health > /dev/null; then
        echo "$(date): ❌ Servidor caído, reiniciando..." >> "$MONITOR_LOG"
        
        # Matar procesos
        pkill -f "uvicorn" 2>/dev/null
        pkill -f "iaviva" 2>/dev/null
        sleep 2
        
        # Reiniciar
        ./start_iaviva.sh >> "$MONITOR_LOG" 2>&1
    else
        # Verificar endpoints críticos
        TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
        
        # Test de verificación automática
        RESPONSE=$(curl -s -X POST http://localhost:8000/verify \
            -H "Content-Type: application/json" \
            -d '{"url":"https://www.google.com"}')
        
        if echo "$RESPONSE" | grep -q "estado"; then
            echo "$TIMESTAMP: ✅ Sistema operativo y verificando" >> "$MONITOR_LOG"
        else
            echo "$TIMESTAMP: ⚠️  Sistema activo pero verificación falló" >> "$MONITOR_LOG"
        fi
    fi
    
    # Esperar 30 segundos antes de siguiente verificación
    sleep 30
done
