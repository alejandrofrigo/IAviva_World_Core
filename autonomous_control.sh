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
