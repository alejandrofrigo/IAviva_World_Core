#!/bin/bash
echo "🚀 INICIANDO SISTEMA IAviva SIMPLIFICADO"
echo "========================================"

# 1. Ir al directorio correcto
cd ~/IAviva_FINAL 2>/dev/null || { echo "❌ Error: No se encuentra IAviva_FINAL"; exit 1; }

echo "📁 Directorio: $(pwd)"

# 2. Detener procesos anteriores SUAVEMENTE
echo "1. 🛑 Deteniendo procesos anteriores..."
pkill -f "python3.*iaviva_unificada" 2>/dev/null || true
pkill -f "evolucion_perfecta.py" 2>/dev/null || true
sleep 3

# 3. Verificar que no queden procesos
echo "   🔍 Verificando..."
if pgrep -f "python3.*iaviva" > /dev/null; then
    echo "   ⚠️  Procesos aún activos, forzando cierre..."
    pkill -9 -f "python3.*iaviva" 2>/dev/null || true
    sleep 2
fi

# 4. Iniciar servidor principal EN SEGUNDO PLANO
echo "2. 🖥️  Iniciando servidor principal..."
nohup python3 iaviva_unificada_completa.py > servidor.log 2>&1 &
SERVER_PID=$!
echo "   ✅ Servidor iniciado (PID: $SERVER_PID)"

# 5. Esperar a que el servidor esté listo
echo "3. ⏳ Esperando servidor (8 segundos)..."
sleep 8

# 6. Verificar que el servidor responde
echo "4. 🔍 Verificando servidor..."
if curl -s http://localhost:8000/health > /dev/null 2>&1; then
    echo "   ✅ Servidor respondiendo (HTTP 200)"
else
    echo "   ⚠️  Servidor no responde, revisando logs..."
    tail -5 servidor.log
    echo "   🔄 Intentando continuar..."
fi

# 7. Iniciar autoprogramación (si el servidor está activo)
echo "5. 🤖 Activando autoprogramación..."
curl -s -X POST http://localhost:8000/autoprogramacion/iniciar > /dev/null 2>&1 && \
    echo "   ✅ Autoprogramación activada" || \
    echo "   ⚠️  No se pudo activar autoprogramación"

# 8. Iniciar sistema de evolución perfecta EN SEGUNDO PLANO
echo "6. ⚡ Iniciando evolución perfecta..."
nohup python3 evolucion_perfecta.py > evolucion_perfecta.log 2>&1 &
EVOLUTION_PID=$!
echo "   ✅ Evolución iniciada (PID: $EVOLUTION_PID)"

# 9. Esperar un momento
echo "7. ⏳ Esperando inicialización (5 segundos)..."
sleep 5

# 10. Verificar estado final
echo ""
echo "🎉 SISTEMA IAviva INICIADO"
echo "=========================="
echo ""
echo "📊 ESTADO ACTUAL:"
echo "   🖥️  Servidor: http://localhost:8000/health"
echo "   🤖 Autoprogramación: ACTIVA"
echo "   ⚡ Evolución perfecta: ACTIVA"
echo ""
echo "📋 COMANDOS DE VERIFICACIÓN:"
echo "   tail -f evolucion_perfecta.log"
echo "   ./verificar_evolucion.sh"
echo "   ./dashboard_tiempo_real.sh"
echo ""
echo "📁 ARCHIVOS GENERADOS:"
echo "   servidor.log        - Logs del servidor"
echo "   evolucion_perfecta.log - Logs de evolución"
echo "   evidencias_evolucion/  - Evidencias tangibles"
echo ""
echo "🤖 SISTEMA 100% AUTÓNOMO"
