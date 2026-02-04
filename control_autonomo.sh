#!/bin/bash
# ============================================
# CONTROL AUTÓNOMO IAviva
# ============================================

IAVIVA_DIR="$PWD"
CONFIG_DIR="$IAVIVA_DIR/autonomous/config"
LOG_DIR="$IAVIVA_DIR/autonomous/logs"

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

show_help() {
    echo -e "${BLUE}🤖 CONTROL AUTÓNOMO IAviva${NC}"
    echo "================================="
    echo ""
    echo "Comandos:"
    echo "  $0 status       - Ver estado del sistema"
    echo "  $0 start        - Iniciar sistema autónomo"
    echo "  $0 stop         - Detener sistema"
    echo "  $0 logs         - Ver logs"
    echo "  $0 dashboard    - Dashboard interactivo"
    echo "  $0 finance      - Iniciar auto-financiamiento"
    echo "  $0 p2p          - Iniciar red P2P"
    echo "  $0 heal         - Iniciar auto-reparación"
    echo ""
    echo "IAviva Principal: http://localhost:8000"
    echo ""
}

check_iaviva() {
    echo -n "🔍 Verificando IAviva principal... "
    if curl -s http://localhost:8000/health > /dev/null 2>&1; then
        echo -e "${GREEN}✅ ACTIVO${NC}"
        return 0
    else
        echo -e "${RED}❌ INACTIVO${NC}"
        return 1
    fi
}

start_autonomous() {
    echo "🚀 Iniciando sistema autónomo..."
    
    # Verificar IAviva principal
    if ! check_iaviva; then
        echo "⚠️  Iniciando IAviva principal primero..."
        ./start_iaviva_24x7.sh > /dev/null 2>&1 &
        sleep 8
    fi
    
    # PID file en directorio local, no en /tmp
    PID_FILE="$IAVIVA_DIR/.autonomous.pid"
    
    # Iniciar procesos autónomos
    echo "🔄 Iniciando componentes..."
    
    # 1. Auto-reparación
    python3 -c "
import time
import os
import json
from datetime import datetime

print('🛠️  Iniciando sistema de auto-reparación...')
while True:
    try:
        # Verificar salud
        import requests
        response = requests.get('http://localhost:8000/health', timeout=5)
        if response.status_code != 200:
            print(f'⚠️  IAviva no responde: {response.status_code}')
            # Podría reiniciar aquí
        else:
            print(f'✅ IAviva OK: {datetime.now().strftime(\"%H:%M:%S\")}')
        
        # Guardar estado
        status = {
            'timestamp': datetime.now().isoformat(),
            'service': 'iaviva',
            'status': 'active' if response.status_code == 200 else 'inactive'
        }
        
        os.makedirs('autonomous/logs', exist_ok=True)
        with open('autonomous/logs/health.log', 'a') as f:
            f.write(json.dumps(status) + '\n')
        
    except Exception as e:
        print(f'❌ Error: {e}')
        with open('autonomous/logs/errors.log', 'a') as f:
            f.write(f'{datetime.now().isoformat()}: {e}\n')
    
    time.sleep(60)
" > "$LOG_DIR/healing.log" 2>&1 &
    
    HEAL_PID=$!
    echo $HEAL_PID > "$PID_FILE"
    
    # 2. Auto-financiamiento (si hay API key)
    if [ -f "$CONFIG_DIR/deepseek.key" ]; then
        echo "💰 Iniciando auto-financiamiento..."
        python3 autonomous/auto_financing/simple_finance.py >> "$LOG_DIR/finance.log" 2>&1 &
        echo $! >> "$PID_FILE"
    fi
    
    echo -e "${GREEN}✅ Sistema autónomo iniciado${NC}"
    echo "📊 PID guardado en: $PID_FILE"
    echo "📝 Logs en: $LOG_DIR/"
}

stop_autonomous() {
    PID_FILE="$IAVIVA_DIR/.autonomous.pid"
    
    if [ -f "$PID_FILE" ]; then
        echo "🛑 Deteniendo sistema autónomo..."
        while read pid; do
            if kill -0 $pid 2>/dev/null; then
                kill $pid
                echo "   Proceso $pid detenido"
            fi
        done < "$PID_FILE"
        rm "$PID_FILE"
        echo -e "${GREEN}✅ Sistema detenido${NC}"
    else
        echo "⚠️  No hay sistema autónomo en ejecución"
    fi
}

show_status() {
    echo "📊 ESTADO DEL SISTEMA AUTÓNOMO"
    echo "================================"
    
    # IAviva principal
    check_iaviva
    
    # Procesos autónomos
    PID_FILE="$IAVIVA_DIR/.autonomous.pid"
    if [ -f "$PID_FILE" ]; then
        echo -e "\n🤖 Componentes autónomos:"
        PIDS=$(cat "$PID_FILE")
        for pid in $PIDS; do
            if kill -0 $pid 2>/dev/null; then
                echo "   ✅ Proceso $pid: ACTIVO"
            else
                echo "   ❌ Proceso $pid: INACTIVO"
            fi
        done
        echo -e "${GREEN}✅ Sistema autónomo EN EJECUCIÓN${NC}"
    else
        echo -e "\n🤖 Sistema autónomo: ${RED}DETENIDO${NC}"
    fi
    
    # Logs disponibles
    echo -e "\n📁 Logs disponibles:"
    ls -la "$LOG_DIR/" 2>/dev/null | grep -E "\.log$" | awk '{print "   📝 " $9 " (" $5 " bytes)"}'
    
    # URLs
    echo -e "\n🌐 URLs:"
    echo "   IAviva:      http://localhost:8000"
    echo "   Dashboard:   http://localhost:8000/dashboard"
    echo "   Health:      http://localhost:8000/health"
    echo "   Docs:        http://localhost:8000/docs"
}

show_dashboard() {
    clear
    echo "================================================"
    echo "🤖 DASHBOARD AUTÓNOMO IAviva"
    echo "================================================"
    echo "Hora: $(date)"
    echo ""
    
    # Estado principal
    echo "🔧 IAviva PRINCIPAL:"
    if curl -s http://localhost:8000/health > /dev/null; then
        HEALTH=$(curl -s http://localhost:8000/health)
        STATUS=$(echo "$HEALTH" | grep -o '"status":"[^"]*"' | cut -d'"' -f4)
        VERSION=$(echo "$HEALTH" | grep -o '"version":"[^"]*"' | cut -d'"' -f4)
        echo -e "   ✅ $STATUS - v$VERSION"
    else
        echo -e "   ❌ NO RESPONDE"
    fi
    
    echo ""
    
    # Estado autónomo
    PID_FILE="$IAVIVA_DIR/.autonomous.pid"
    if [ -f "$PID_FILE" ] && kill -0 $(head -1 "$PID_FILE") 2>/dev/null; then
        echo "🔄 SISTEMA AUTÓNOMO: ✅ ACTIVO"
        
        # Mostrar últimas líneas del log
        echo ""
        echo "📜 ÚLTIMAS ACTIVIDADES:"
        tail -5 "$LOG_DIR/healing.log" 2>/dev/null | while read line; do
            echo "   $line"
        done
    else
        echo "🔄 SISTEMA AUTÓNOMO: ❌ INACTIVO"
    fi
    
    echo ""
    echo "🚀 ACCIONES RÁPIDAS:"
    echo "   1. Ver logs completos"
    echo "   2. Forzar verificación"
    echo "   3. Reiniciar autónomo"
    echo "   4. Salir"
    echo ""
    read -p "👉 Opción: " opt
    
    case $opt in
        1) tail -f "$LOG_DIR/healing.log" ;;
        2) check_iaviva ;;
        3) stop_autonomous; start_autonomous ;;
        4) exit 0 ;;
    esac
}

# Procesar comando
case "$1" in
    "start")
        start_autonomous
        ;;
    "stop")
        stop_autonomous
        ;;
    "status")
        show_status
        ;;
    "logs")
        tail -f "$LOG_DIR/healing.log"
        ;;
    "dashboard")
        show_dashboard
        ;;
    "finance")
        echo "💰 Iniciando auto-financiamiento..."
        python3 autonomous/auto_financing/simple_finance.py
        ;;
    "p2p")
        echo "🌐 Iniciando red P2P..."
        python3 autonomous/p2p_network/simple_p2p.py
        ;;
    "heal")
        echo "🛠️  Iniciando auto-reparación..."
        python3 autonomous/self_healing/simple_heal.py
        ;;
    *)
        show_help
        ;;
esac
