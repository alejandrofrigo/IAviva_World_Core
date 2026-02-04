#!/bin/bash
echo "🚀 INICIANDO SISTEMA COMPLETO IAviva"
echo "===================================="

# 1. Detener todo primero
echo "1. 🛑 Limpiando procesos anteriores..."
pkill -f "python3.*iaviva" 2>/dev/null || true
pkill -f "evolucion_perfecta" 2>/dev/null || true
sleep 3

# 2. Iniciar servidor principal
echo "2. 🖥️  Iniciando servidor IAviva..."
cd ~/IAviva_FINAL
python3 iaviva_unificada_completa.py > servidor.log 2>&1 &
SERVER_PID=$!
echo "   ✅ Servidor (PID: $SERVER_PID)"

# 3. Esperar a que el servidor esté listo
echo "3. ⏳ Esperando servidor (10s)..."
sleep 10

# 4. Iniciar autoprogramación
echo "4. 🤖 Activando autoprogramación..."
curl -s -X POST http://localhost:8000/autoprogramacion/iniciar > /dev/null

# 5. Iniciar evolución perfecta
echo "5. ⚡ Iniciando evolución perfecta..."
python3 evolucion_perfecta.py > evolucion_perfecta.log 2>&1 &
EVOLUTION_PID=$!
echo "   ✅ Evolución (PID: $EVOLUTION_PID)"

# 6. Verificar todo
echo "6. ✅ Verificando sistema completo..."
sleep 5

echo ""
echo "🎉 SISTEMA IAviva COMPLETO INICIADO"
echo "==================================="
echo ""
echo "📊 ESTADO:"
echo "   🖥️  Servidor: http://localhost:8000/health"
echo "   🤖 Autoprogramación: ACTIVA"
echo "   ⚡ Evolución perfecta: ACTIVA"
echo ""
echo "📋 COMANDOS:"
echo "   ./verificar_evolucion.sh  # Ver estado"
echo "   tail -f evolucion_perfecta.log  # Ver logs"
echo "   ./dashboard_tiempo_real.sh  # Dashboard"
echo ""
echo "🤖 SISTEMA 100% AUTÓNOMO Y EN EVOLUCIÓN"
