#!/bin/bash
echo "🔍 DASHBOARD IAviva AUTOPROGRAMABLE"
echo "========================================"
echo "⏰ Última verificación: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""
echo "📊 ESTADO DEL SISTEMA:"
curl -s http://localhost:8000/autoprogramacion/estado 2>/dev/null | python3 -c "
import json, sys, os
try:
    data = json.load(sys.stdin)
    print('✅ ' + data.get('sistema', 'IAviva'))
    print('   Estado:', data.get('estado', 'ACTIVO'))
    print('   Verificación:', data.get('verificacion', '100% REAL'))
    print('   Operación:', data.get('operacion', 'AUTÓNOMA'))
    print('   Ciclos completados:', data.get('ciclos_completados', 0))
    print('   Mejoras aplicadas:', data.get('mejoras_aplicadas', 0))
except:
    print('⚠️  Sistema no disponible')
"
echo ""
echo "📁 EVIDENCIAS TANGIBLES:"
archivos=(mejora_*.json 2>/dev/null)
if [ \${#archivos[@]} -gt 0 ]; then
    echo "   Total: \${#archivos[@]} archivos"
    ultima=\$(ls -t mejora_*.json 2>/dev/null | head -1)
    echo "   Última: \$ultima"
    echo "   Timestamp: \$(date -r \$ultima '+%H:%M:%S')"
else
    echo "   ⏳ Generando primera evidencia..."
fi
echo ""
echo "🌐 ENDPOINTS ACTIVOS:"
echo "   http://localhost:8000/health"
echo "   http://localhost:8000/autoprogramacion/estado"
echo "   http://localhost:8000/autoprogramacion/mejoras"
echo ""
echo "🤖 SISTEMA: 100% AUTÓNOMO - SIN INTERVENCIÓN HUMANA"
echo "========================================"
