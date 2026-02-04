#!/bin/bash
# ============================================
# SISTEMA AUTÓNOMO COMPLETO PARA IAviva
# Inicia todo y se auto-repara automáticamente
# ============================================

echo "🤖 INICIANDO SISTEMA AUTÓNOMO IAviva"
echo "===================================="

cd ~/IAviva_FINAL

# Crear estructura de directorios
mkdir -p autonomous logs
mkdir -p autonomous/{backups,config,monitoring}

# Inicializar archivos necesarios
touch autonomous/health_status.json
touch autonomous/repair_history.json
echo '{"repairs": []}' > autonomous/repair_history.json

# 1. Verificar e iniciar IAviva principal
echo "🔧 Verificando IAviva principal..."
if ! curl -s http://localhost:8000/health > /dev/null 2>&1; then
    echo "⚠️  IAviva no responde - Iniciando..."
    
    # Detener cualquier proceso previo
    pkill -f "python.*8000" 2>/dev/null
    pkill -f "iaviva" 2>/dev/null
    sleep 2
    
    # Iniciar IAviva
    ./start_iaviva_24x7.sh > logs/autonomous_startup.log 2>&1 &
    IAVIVA_PID=$!
    echo "📌 IAviva iniciado (PID: $IAVIVA_PID)"
    
    # Esperar inicio
    echo "⏳ Esperando 15 segundos para inicio..."
    sleep 15
    
    # Verificar
    if curl -s http://localhost:8000/health > /dev/null; then
        echo "✅ IAviva iniciado exitosamente"
    else
        echo "❌ IAviva no responde - Ver logs: logs/autonomous_startup.log"
    fi
else
    echo "✅ IAviva ya está activo"
fi

# 2. Iniciar sistema de auto-reparación
echo "🚀 Iniciando sistema de auto-reparación..."
python3 autonomous/termux_monitor.py > logs/autonomous_monitor.log 2>&1 &
MONITOR_PID=$!
echo $MONITOR_PID > .autonomous_monitor.pid
echo "📌 Monitor PID: $MONITOR_PID"

# 3. Iniciar sistema de auto-financiamiento (si existe)
if [ -f "autonomous/auto_financing/simple_finance.py" ]; then
    echo "💰 Iniciando auto-financiamiento..."
    python3 autonomous/auto_financing/simple_finance.py > logs/autonomous_finance.log 2>&1 &
    FINANCE_PID=$!
    echo $FINANCE_PID > .autonomous_finance.pid
    echo "📌 Finance PID: $FINANCE_PID"
fi

# 4. Crear script de control simple
cat > autonomous_control.sh << 'CONTROL_EOF'
#!/bin/bash
cd ~/IAviva_FINAL

case "$1" in
    status)
        echo "📊 ESTADO SISTEMA AUTÓNOMO"
        echo "=========================="
        
        # IAviva principal
        if curl -s http://localhost:8000/health > /dev/null; then
            echo "🔧 IAviva: ✅ ACTIVO"
            curl -s http://localhost:8000/health | grep -o '"status":"[^"]*"' | head -1
        else
            echo "🔧 IAviva: ❌ INACTIVO"
        fi
        
        # Monitor
        if [ -f .autonomous_monitor.pid ] && kill -0 $(cat .autonomous_monitor.pid) 2>/dev/null; then
            echo "🤖 Auto-reparación: ✅ ACTIVO"
        else
            echo "🤖 Auto-reparación: ❌ INACTIVO"
        fi
        
        # Finance
        if [ -f .autonomous_finance.pid ] && kill -0 $(cat .autonomous_finance.pid) 2>/dev/null; then
            echo "💰 Auto-financiamiento: ✅ ACTIVO"
        else
            echo "💰 Auto-financiamiento: ❌ INACTIVO"
        fi
        
        # Última verificación
        if [ -f autonomous/health_status.json ]; then
            echo ""
            echo "📈 Última verificación:"
            grep -o '"timestamp":"[^"]*"' autonomous/health_status.json | tail -1
        fi
        ;;
    
    logs)
        echo "📜 LOGS DEL SISTEMA:"
        echo "1. Monitor"
        echo "2. IAviva principal"
        echo "3. Financiamiento"
        echo "4. Errores"
        read -p "👉 Selecciona (1-4): " choice
        
        case $choice in
            1) tail -f logs/autonomous_monitor.log ;;
            2) tail -f logs/server.log ;;
            3) tail -f logs/autonomous_finance.log ;;
            4) tail -f logs/error.log ;;
            *) echo "Opción no válida" ;;
        esac
        ;;
    
    restart)
        echo "🔄 Reiniciando sistema..."
        pkill -f "termux_monitor" 2>/dev/null
        pkill -f "simple_finance" 2>/dev/null
        sleep 2
        ./start_autonomous_system.sh
        ;;
    
    stop)
        echo "🛑 Deteniendo sistema autónomo..."
        pkill -f "termux_monitor" 2>/dev/null
        pkill -f "simple_finance" 2>/dev/null
        rm -f .autonomous_*.pid
        echo "✅ Sistema detenido"
        ;;
    
    dashboard)
        echo "📊 DASHBOARD IAviva AUTÓNOMO"
        echo "============================"
        echo "IAviva Principal: http://localhost:8000"
        echo "Dashboard:        http://localhost:8000/dashboard"
        echo "Health:           http://localhost:8000/health"
        echo ""
        echo "🔧 Comandos:"
        echo "  ./autonomous_control.sh status"
        echo "  ./autonomous_control.sh logs"
        echo "  ./autonomous_control.sh restart"
        echo "  ./autonomous_control.sh stop"
        ;;
    
    *)
        echo "🤖 CONTROL AUTÓNOMO IAviva"
        echo "Uso: $0 {status|logs|restart|stop|dashboard}"
        ;;
esac
CONTROL_EOF

chmod +x autonomous_control.sh

# 5. Crear script de mantenimiento automático
cat > autonomous/maintenance_daily.sh << 'MAINT_EOF'
#!/bin/bash
# Mantenimiento diario automático

echo "🧹 MANTENIMIENTO DIARIO - $(date)"
echo "================================"

cd ~/IAviva_FINAL

# Rotar logs grandes
find logs/ -name "*.log" -size +10M -exec truncate -s 5M {} \;

# Limpiar backups viejos (>7 días)
find autonomous/backups/ -name "*.backup" -mtime +7 -delete 2>/dev/null

# Backup de configuración
cp autonomous/health_status.json "autonomous/backups/health_$(date +%Y%m%d).backup" 2>/dev/null

echo "✅ Mantenimiento completado"
MAINT_EOF

chmod +x autonomous/maintenance_daily.sh

# 6. Configurar auto-ejecución al inicio (opcional)
echo "⏰ Configurando auto-ejecución..."
cat > ~/.bashrc_iaviva << 'BASHRC_EOF'
# Auto-ejecutar IAviva al iniciar Termux (si no está corriendo)
if [ -d "~/IAviva_FINAL" ] && ! curl -s http://localhost:8000/health > /dev/null 2>&1; then
    echo "🤖 Iniciando IAviva automáticamente..."
    cd ~/IAviva_FINAL
    ./start_autonomous_system.sh > /dev/null 2>&1 &
fi
BASHRC_EOF

# Solo añadir si no existe
if ! grep -q "bashrc_iaviva" ~/.bashrc; then
    echo "source ~/.bashrc_iaviva" >> ~/.bashrc
fi

echo ""
echo "✅ SISTEMA AUTÓNOMO CONFIGURADO COMPLETAMENTE"
echo ""
echo "📊 Para ver estado: ./autonomous_control.sh status"
echo "📜 Para ver logs:   ./autonomous_control.sh logs"
echo "🔧 Para dashboard:  ./autonomous_control.sh dashboard"
echo "🔄 Para reiniciar:  ./autonomous_control.sh restart"
echo ""
echo "🌍 IAviva Principal: http://localhost:8000"
echo "🤖 El sistema se auto-reparará automáticamente cada 60 segundos"
echo ""
