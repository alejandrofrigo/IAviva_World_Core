#!/bin/bash
echo "🤖 MONITOREO AUTOMÁTICO IAviva"
echo "⏰ Iniciado: $(date)"
echo ""

while true; do
    echo "[$(date '+%H:%M:%S')] Verificando estado..."
    
    # Verificar estado
    curl -s http://localhost:8000/autoprogramacion/estado | python3 -c "
import json, sys, os
try:
    data = json.load(sys.stdin)
    print(f'✅ Estado: {data.get(\"estado\", \"ACTIVO\")}')
    print(f'📊 Ciclos: {data.get(\"ciclos_completados\", 0)}')
    print(f'✨ Mejoras: {data.get(\"mejoras_aplicadas\", 0)}')
    
    # Contar evidencias
    archivos = [f for f in os.listdir('.') if f.startswith('mejora_') and f.endswith('.json')]
    print(f'📁 Evidencias: {len(archivos)} archivos')
    
    # Mostrar última evidencia
    if archivos:
        archivos.sort(key=lambda x: os.path.getmtime(x), reverse=True)
        with open(archivos[0], 'r') as f:
            ev = json.load(f)
            print(f'🕒 Última: {ev.get(\"timestamp_validacion\", \"\")[:19]}')
    
except Exception as e:
    print(f'⚠️ Error: {e}')
"
    
    echo "---"
    sleep 30
done
