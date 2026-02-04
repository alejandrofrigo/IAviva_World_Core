#!/bin/bash
# IAviva 100% REAL - Script de inicio 24/7 sin errores

echo "================================================"
echo "🚀 IAviva 100% REAL - Sistema 24/7"
echo "================================================"

# Configuración
APP_NAME="IAviva_100_REAL"
APP_FILE="iaviva_real_100.py"
LOG_FILE="iaviva_100_control.log"
PORT=8000
MAX_RESTARTS=100
RESTART_DELAY=5

# Función para log de control
log_control() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Función para verificar si el puerto está libre
check_port_free() {
    if netstat -tulpn 2>/dev/null | grep ":$PORT " > /dev/null; then
        log_control "⚠️  Puerto $PORT ocupado. Liberando..."
        fuser -k $PORT/tcp 2>/dev/null
        sleep 3
    fi
}

# Función para verificar si la API responde
check_api_alive() {
    if curl -s http://localhost:$PORT/health > /dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

# Función para iniciar la aplicación
start_application() {
    log_control "▶️  Iniciando $APP_NAME..."
    
    # Verificar puerto libre
    check_port_free
    
    # Iniciar aplicación en background
    python3 "$APP_FILE" >> "$LOG_FILE" 2>&1 &
    APP_PID=$!
    
    log_control "📝 PID: $APP_PID"
    
    # Esperar a que inicie
    local timeout=30
    local count=0
    
    while [ $count -lt $timeout ]; do
        if check_api_alive; then
            log_control "✅ $APP_NAME iniciado correctamente"
            return 0
        fi
        sleep 1
        ((count++))
    done
    
    log_control "❌ Timeout esperando $APP_NAME"
    return 1
}

# Función para monitoreo continuo
monitor_application() {
    local restart_count=0
    
    while [ $restart_count -lt $MAX_RESTARTS ]; do
        if ! check_api_alive; then
            log_control "⚠️  $APP_NAME no responde. Reiniciando..."
            ((restart_count++))
            
            # Matar proceso si existe
            pkill -f "$APP_FILE" 2>/dev/null
            
            # Reiniciar
            if start_application; then
                log_control "🔄 Reinicio #$restart_count exitoso"
            else
                log_control "❌ Falló reinicio #$restart_count"
                sleep $RESTART_DELAY
            fi
        else
            # Todo bien, esperar
            sleep 10
        fi
    done
    
    log_control "❌ Límite de reinicios alcanzado ($MAX_RESTARTS)"
}

# ==================== EJECUCIÓN PRINCIPAL ====================

# Limpiar log anterior
> "$LOG_FILE"

log_control "🔄 Iniciando sistema $APP_NAME"

# Inicio inicial
if start_application; then
    log_control "================================================"
    log_control "✅ SISTEMA 100% REAL OPERATIVO"
    log_control "🌐 API: http://localhost:$PORT"
    log_control "📊 Dashboard: http://localhost:$PORT/dashboard"
    log_control "📚 Docs: http://localhost:$PORT/docs"
    log_control "💾 Control: $LOG_FILE"
    log_control "================================================"
    log_control "🔄 Iniciando monitoreo 24/7..."
    
    # Iniciar monitoreo
    monitor_application
    
else
    log_control "❌ No se pudo iniciar $APP_NAME"
    exit 1
fi
