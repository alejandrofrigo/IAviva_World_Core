#!/bin/bash
# ============================================
# AUTOARRANQUE IAviva AUTOPROGRAMABLE
# ============================================

echo "🤖 INICIANDO SISTEMA AUTÓNOMO..."
echo "⏰ $(date)"
echo ""

# 1. Ir al directorio automáticamente
cd ~/IAviva_FINAL

# 2. Iniciar servidor en segundo plano
echo "🚀 Iniciando servidor IAviva..."
python3 iaviva_unificada_completa.py &
SERVER_PID=$!
echo "✅ Servidor iniciado (PID: $SERVER_PID)"

# 3. Esperar a que el servidor esté listo
echo "⏳ Esperando inicialización del servidor..."
sleep 5

# 4. Iniciar autoprogramación AUTOMÁTICAMENTE
echo "🔧 Activando autoprogramación autónoma..."
curl -s -X POST http://localhost:8000/autoprogramacion/iniciar > /dev/null

# 5. Verificar estado automáticamente
echo "📊 Verificando estado autónomo..."
curl -s http://localhost:8000/autoprogramacion/estado | python3 -m json.tool

echo ""
echo "============================================"
echo "✅ SISTEMA AUTÓNOMO ACTIVADO"
echo "============================================"
echo ""
echo "El sistema ahora:"
echo "1. ✅ Se autoprograma automáticamente"
echo "2. ✅ Genera evidencias tangibles"
echo "3. ✅ Opera sin intervención humana"
echo "4. ✅ Se mejora continuamente"
echo ""
echo "Evidencias generadas automáticamente en:"
echo "~/IAviva_FINAL/mejora_*.json"
echo ""
echo "Para ver logs en tiempo real:"
echo "tail -f ~/IAviva_FINAL/iaviva_autoprogramacion.log"
echo ""
