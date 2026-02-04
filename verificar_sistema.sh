#!/bin/bash
echo "🔍 VERIFICACIÓN COMPLETA DEL SISTEMA IAviva"
echo "=========================================="
echo "⏰ Hora: $(date '+%Y-%m-%d %H:%M:%S')"
echo "📁 Directorio: $(pwd)"
echo ""

# 1. Procesos activos
echo "1. ⚙️  PROCESOS ACTIVOS:"
echo "   🔹 Servidor IAviva:"
if pgrep -f "python3.*iaviva_unificada" > /dev/null; then
    PID1=$(pgrep -f "python3.*iaviva_unificada")
    echo "      ✅ ACTIVO (PID: $PID1)"
    echo "      🕒 Tiempo: $(ps -o etime= -p $PID1 2>/dev/null | tr -d ' ' || echo 'N/A')"
else
    echo "      ❌ INACTIVO"
fi

echo ""
echo "   🔹 Evolución Perfecta:"
if pgrep -f "evolucion_perfecta.py" > /dev/null; then
    PID2=$(pgrep -f "evolucion_perfecta.py")
    echo "      ✅ ACTIVO (PID: $PID2)"
    echo "      🕒 Tiempo: $(ps -o etime= -p $PID2 2>/dev/null | tr -d ' ' || echo 'N/A')"
else
    echo "      ❌ INACTIVO"
fi

# 2. Servidor web
echo ""
echo "2. 🌐 SERVIDOR WEB:"
if curl -s -o /dev/null -w "%{http_code}" http://localhost:8000/health 2>/dev/null | grep -q "200"; then
    echo "   ✅ ACTIVO (HTTP 200)"
    echo "   📍 URL: http://localhost:8000"
else
    echo "   ❌ NO RESPONDE"
fi

# 3. Estado de autoprogramación
echo ""
echo "3. 🤖 AUTOPROGRAMACIÓN:"
AUTO_STATUS=$(curl -s http://localhost:8000/autoprogramacion/estado 2>/dev/null || echo "NO_DISPONIBLE")
if echo "$AUTO_STATUS" | grep -q "ACTIVO"; then
    echo "   ✅ ACTIVA"
    # Extraer ciclos
    CICLOS_AUTO=$(echo "$AUTO_STATUS" | python3 -c "
import json, sys
try:
    data = json.load(sys.stdin)
    print(data.get('ciclos_completados', 'N/A'))
except:
    print('N/A')
" 2>/dev/null)
    echo "   🔄 Ciclos: $CICLOS_AUTO"
else
    echo "   ⚠️  Estado: $AUTO_STATUS"
fi

# 4. Sistema de evolución
echo ""
echo "4. ⚡ SISTEMA DE EVOLUCIÓN:"
if [ -f "evolucion_perfecta.log" ]; then
    LOG_SIZE=$(wc -l evolucion_perfecta.log | awk '{print $1}')
    echo "   📏 Log: $LOG_SIZE líneas"
    
    CICLOS_EVO=$(grep -c "CICLO DE EVOLUCIÓN #" evolucion_perfecta.log 2>/dev/null || echo "0")
    echo "   🔄 Ciclos evolución: $CICLOS_EVO"
    
    # Última línea del log
    echo "   📝 Último log:"
    tail -1 evolucion_perfecta.log 2>/dev/null | sed 's/^/      /'
else
    echo "   📭 Log no encontrado"
fi

# 5. Evidencias tangibles
echo ""
echo "5. 📁 EVIDENCIAS TANGIBLES:"
if [ -d "evidencias_evolucion" ]; then
    EVIDENCIAS_TOTAL=$(ls -1 evidencias_evolucion/*.json 2>/dev/null | wc -l)
    echo "   📦 Total: $EVIDENCIAS_TOTAL archivos"
    
    if [ $EVIDENCIAS_TOTAL -gt 0 ]; then
        ULTIMA_EVID=$(ls -t evidencias_evolucion/*.json 2>/dev/null | head -1)
        echo "   🕒 Última: $(basename "$ULTIMA_EVID")"
        
        # Tamaño
        TAMANO=$(du -sh evidencias_evolucion/ 2>/dev/null | cut -f1)
        echo "   📏 Tamaño total: ${TAMANO:-0}"
    fi
else
    echo "   📂 Carpeta no existe (se creará automáticamente)"
fi

# 6. Resumen general
echo ""
echo "6. 🎯 RESUMEN GENERAL:"
ACTIVOS=0
TOTAL=3

if pgrep -f "python3.*iaviva_unificada" > /dev/null; then
    ACTIVOS=$((ACTIVOS + 1))
fi
if pgrep -f "evolucion_perfecta.py" > /dev/null; then
    ACTIVOS=$((ACTIVOS + 1))
fi
if curl -s http://localhost:8000/health > /dev/null 2>&1; then
    ACTIVOS=$((ACTIVOS + 1))
fi

echo "   📊 $ACTIVOS/$TOTAL sistemas activos"

if [ $ACTIVOS -eq $TOTAL ]; then
    echo "   ✅✅✅ SISTEMA COMPLETO OPERATIVO"
    echo "   🤖 Modo: AUTÓNOMO PERFECTO"
elif [ $ACTIVOS -ge 2 ]; then
    echo "   ✅ SISTEMA PARCIALMENTE OPERATIVO"
    echo "   ⚠️  Algunos componentes necesitan atención"
else
    echo "   ❌ SISTEMA INACTIVO"
    echo "   🔧 Necesita reinicio completo"
fi

echo ""
echo "=========================================="
echo "📋 ACCIONES RECOMENDADAS:"
if [ $ACTIVOS -eq $TOTAL ]; then
    echo "   ✅ Todo funciona, monitorear con:"
    echo "      ./dashboard_tiempo_real.sh"
elif [ $ACTIVOS -eq 0 ]; then
    echo "   🔄 Reiniciar sistema completo:"
    echo "      ./iniciar_sistema_simple.sh"
else
    echo "   🔧 Componentes a revisar:"
    if ! pgrep -f "python3.*iaviva_unificada" > /dev/null; then echo "      - Servidor principal"; fi
    if ! pgrep -f "evolucion_perfecta.py" > /dev/null; then echo "      - Sistema de evolución"; fi
    if ! curl -s http://localhost:8000/health > /dev/null 2>&1; then echo "      - Servidor web"; fi
fi
echo "=========================================="
