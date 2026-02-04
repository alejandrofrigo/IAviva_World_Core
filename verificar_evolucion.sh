#!/bin/bash
echo "🔍 VERIFICACIÓN SISTEMA DE EVOLUCIÓN IAviva"
echo "=========================================="
echo "⏰ Hora: $(date '+%H:%M:%S')"
echo ""

# 1. Verificar proceso activo
echo "1. 🔄 PROCESO ACTIVO:"
if pgrep -f "evolucion_perfecta.py" > /dev/null; then
    PID=$(pgrep -f "evolucion_perfecta.py")
    echo "   ✅ ACTIVO (PID: $PID)"
    
    # Tiempo de ejecución
    RUNTIME=$(ps -o etime= -p $PID | tr -d ' ')
    echo "   ⏱️  Tiempo ejecución: $RUNTIME"
else
    echo "   ❌ INACTIVO"
fi

# 2. Verificar logs
echo ""
echo "2. 📊 LOGS DEL SISTEMA:"
LOGSIZE=$(wc -l evolucion_perfecta.log 2>/dev/null | awk '{print $1}' || echo "0")
echo "   📏 Líneas de log: $LOGSIZE"

if [ $LOGSIZE -gt 0 ]; then
    echo "   📄 Últimas líneas:"
    tail -5 evolucion_perfecta.log 2>/dev/null | sed 's/^/     /'
else
    echo "   📭 Log vacío"
fi

# 3. Verificar evidencias
echo ""
echo "3. 📁 EVIDENCIAS GENERADAS:"
if [ -d "evidencias_evolucion" ]; then
    EVIDENCIAS=$(ls -1 evidencias_evolucion/*.json 2>/dev/null | wc -l)
    echo "   📦 Total evidencias: $EVIDENCIAS"
    
    if [ $EVIDENCIAS -gt 0 ]; then
        ULTIMA=$(ls -t evidencias_evolucion/*.json 2>/dev/null | head -1)
        echo "   🕒 Última evidencia: $(basename $ULTIMA)"
        
        # Mostrar timestamp
        TIMESTAMP=$(python3 -c "
import json, os
try:
    with open('$ULTIMA', 'r') as f:
        data = json.load(f)
    print(data.get('timestamp', 'N/A')[:19])
except:
    print('N/A')
" 2>/dev/null)
        echo "   ⏰ Timestamp: $TIMESTAMP"
    fi
else
    echo "   📂 Carpeta no creada aún"
    echo "   ⏳ Se creará en el primer ciclo"
fi

# 4. Verificar ciclos completados
echo ""
echo "4. 🔄 CICLOS DE EVOLUCIÓN:"
if [ -f "evolucion_perfecta.log" ]; then
    CICLOS=$(grep -c "CICLO DE EVOLUCIÓN #" evolucion_perfecta.log)
    echo "   🔢 Ciclos completados: $CICLOS"
    
    # Último ciclo
    ULTIMO_CICLO=$(grep "CICLO DE EVOLUCIÓN #" evolucion_perfecta.log | tail -1)
    if [ -n "$ULTIMO_CICLO" ]; then
        echo "   🎯 Último ciclo: $ULTIMO_CICLO"
    fi
else
    echo "   📭 Log no encontrado"
fi

# 5. Resumen
echo ""
echo "5. 🎯 RESUMEN:"
if pgrep -f "evolucion_perfecta.py" > /dev/null && [ $LOGSIZE -gt 10 ]; then
    echo "   ✅ SISTEMA OPERATIVO"
    echo "   🔄 EVOLUCIÓN EN CURSO"
    echo "   📈 PROGRESO: ACTIVO"
else
    echo "   ⚠️  SISTEMA EN INICIALIZACIÓN"
    echo "   🔧 ESTADO: CONFIGURANDO"
fi

echo ""
echo "=========================================="
echo "📋 COMANDOS:"
echo "   tail -f evolucion_perfecta.log"
echo "   ./verificar_evolucion.sh"
echo "   ls -la evidencias_evolucion/"
echo "=========================================="
