#!/bin/bash
echo "🔍 VERIFICACIÓN COMPLETA DEL SISTEMA IAviva"
echo "=========================================="
echo "⏰ $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# 1. Verificar servidor principal
echo "1. 🖥️  SERVIDOR PRINCIPAL:"
SERVIDOR_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8000/health 2>/dev/null)
if [ "$SERVIDOR_STATUS" = "200" ]; then
    echo "   ✅ ACTIVO (HTTP $SERVIDOR_STATUS)"
else
    echo "   ⚠️  INACTIVO (Status: $SERVIDOR_STATUS)"
fi

# 2. Verificar autoprogramación
echo ""
echo "2. 🤖 AUTOPROGRAMACIÓN:"
curl -s http://localhost:8000/autoprogramacion/estado 2>/dev/null | python3 -c "
import json, sys
try:
    data = json.load(sys.stdin)
    print('   ✅ ' + data.get('estado', 'ACTIVO'))
    print('   📊 Ciclos:', data.get('ciclos_completados', 'N/A'))
    print('   ✨ Mejoras:', data.get('mejoras_aplicadas', 'N/A'))
except:
    print('   ⚠️  No disponible')
"

# 3. Contar evidencias
echo ""
echo "3. 📁 EVIDENCIAS TANGIBLES:"
EVIDENCIAS=$(ls -1 mejora_*.json 2>/dev/null | wc -l)
ULTIMA=$(ls -t mejora_*.json 2>/dev/null | head -1 2>/dev/null)
if [ $EVIDENCIAS -gt 0 ]; then
    echo "   ✅ $EVIDENCIAS archivos generados"
    echo "   🕒 Última: $ULTIMA"
    echo -n "   📝 Timestamp: "
    python3 -c "
import json, os, sys
if os.path.exists('$ULTIMA'):
    with open('$ULTIMA', 'r') as f:
        data = json.load(f)
    print(data.get('timestamp_validacion', 'N/A')[:19])
else:
    print('N/A')
" 2>/dev/null
else
    echo "   ⏳ Esperando primera evidencia..."
fi

# 4. Verificar logs activos
echo ""
echo "4. 📊 LOGS ACTIVOS:"
if ps aux | grep -v grep | grep -q "python3.*iaviva"; then
    echo "   ✅ Procesos activos detectados"
    ps aux | grep -v grep | grep "python3.*iaviva" | awk '{print "   PID:", $2, "|", $11, $12}'
else
    echo "   ⚠️  No hay procesos activos"
fi

# 5. Estado general
echo ""
echo "5. 🎯 ESTADO GENERAL:"
if [ "$SERVIDOR_STATUS" = "200" ] && [ $EVIDENCIAS -gt 0 ]; then
    echo "   ✅✅✅ SISTEMA 100% OPERATIVO"
    echo "   🤖 Modo: AUTÓNOMO COMPLETO"
    echo "   ⚡ Sin intervención humana necesaria"
elif [ $EVIDENCIAS -gt 0 ]; then
    echo "   ✅ AUTOPROGRAMACIÓN ACTIVA"
    echo "   ⚠️  Servidor necesita atención"
else
    echo "   🔴 SISTEMA INACTIVO"
fi

echo ""
echo "=========================================="
echo "📋 COMANDOS ÚTILES:"
echo "   ./dashboard_verificacion.sh  # Dashboard simple"
echo "   tail -f autonomous.log       # Logs autoprogramación"
echo "   curl localhost:8000/health   # Verificar servidor"
echo "=========================================="
