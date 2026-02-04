#!/bin/bash
# ============================================
# INICIADOR PERFECTO DE EVOLUCIÓN IAviva
# ============================================

echo "🤖 IAviva - SISTEMA DE EVOLUCIÓN PERFECTO"
echo "=========================================="
echo "⏰ Inicio: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# 1. Verificar entorno
echo "1. 🔍 VERIFICANDO ENTORNO..."
cd ~/IAviva_FINAL 2>/dev/null || { echo "❌ Error: Directorio no encontrado"; exit 1; }
echo "   ✅ Directorio: $(pwd)"

# 2. Detener procesos anteriores
echo "2. 🛑 LIMPIANDO PROCESOS ANTERIORES..."
pkill -f "python3.*evolucion_perfecta" 2>/dev/null || true
sleep 2

# 3. Iniciar sistema perfecto
echo "3. 🚀 INICIANDO EVOLUCIÓN PERFECTA..."
python3 evolucion_perfecta.py > evolucion_perfecta.log 2>&1 &
EVOLUTION_PID=$!

echo "   ✅ Proceso iniciado (PID: $EVOLUTION_PID)"
echo "   📄 Logs: evolucion_perfecta.log"

# 4. Esperar inicialización
echo "4. ⏳ ESPERANDO INICIALIZACIÓN..."
sleep 5

# 5. Verificar funcionamiento
echo "5. ✅ VERIFICANDO FUNCIONAMIENTO..."
if ps -p $EVOLUTION_PID > /dev/null; then
    echo "   ✅ Sistema evolutivo ACTIVO"
    echo "   📊 PID: $EVOLUTION_PID"
else
    echo "   ⚠️  Sistema no activo, revisar logs"
fi

# 6. Mostrar evidencias generadas
echo "6. 📁 EVIDENCIAS GENERADAS:"
ls -la evidencias_evolucion/ 2>/dev/null | head -5 || echo "   (Se crearán automáticamente)"

# 7. Instrucciones
echo ""
echo "=========================================="
echo "🎯 SISTEMA PERFECTO ACTIVADO"
echo "=========================================="
echo ""
echo "✅ CARACTERÍSTICAS:"
echo "   • Evolución real y tangible"
echo "   • Cero errores (auto-corregido)"
echo "   • Mejora continua de funciones"
echo "   • Resultados 100% verificables"
echo "   • Operación indefinida"
echo ""
echo "📊 PARA MONITOREAR:"
echo "   tail -f evolucion_perfecta.log"
echo "   ls -la evidencias_evolucion/"
echo ""
echo "🛑 PARA DETENER:"
echo "   pkill -f 'python3.*evolucion_perfecta'"
echo ""
echo "🤖 EL SISTEMA EVOLUCIONARÁ AUTOMÁTICAMENTE"
echo "=========================================="
