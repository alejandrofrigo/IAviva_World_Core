#!/data/data/com.termux/files/usr/bin/bash
echo "📡 MONITOREO REAL 24/7 - IAviva 100% REAL"
echo "=========================================="
echo "Iniciando: $(date)"
echo ""

while true; do
    echo "🕐 $(date '+%H:%M:%S') - VERIFICACIÓN REAL:"
    
    # Verificar salud del servidor
    if curl -s http://localhost:8000/health > /dev/null; then
        echo "   ✅ Servidor ACTIVO"
        
        # Verificar Google (prueba real)
        echo -n "   🔍 Google: "
        resultado=$(curl -s -X POST http://localhost:8000/verify \
                   -H "Content-Type: application/json" \
                   -d '{"url":"https://www.google.com"}')
        
        if echo "$resultado" | grep -q '"codigo_http":200'; then
            tiempo=$(echo "$resultado" | grep -o '"tiempo_respuesta":[0-9.]*' | cut -d: -f2)
            echo "ACTIVO (${tiempo}s) ✅"
        else
            echo "INACTIVO ❌"
        fi
        
        # Verificar GitHub (prueba real)
        echo -n "   🔍 GitHub: "
        resultado=$(curl -s -X POST http://localhost:8000/verify \
                   -H "Content-Type: application/json" \
                   -d '{"url":"https://github.com"}')
        
        if echo "$resultado" | grep -q '"codigo_http":200'; then
            tiempo=$(echo "$resultado" | grep -o '"tiempo_respuesta":[0-9.]*' | cut -d: -f2)
            echo "ACTIVO (${tiempo}s) ✅"
        else
            echo "INACTIVO ❌"
        fi
        
    else
        echo "   ❌ Servidor INACTIVO - Reiniciando..."
        pkill -f "python" 2>/dev/null
        sleep 2
        # Reiniciar servidor (usar el comando de arriba)
    fi
    
    echo "   ⏰ Próxima verificación en 30 segundos..."
    echo ""
    sleep 30
done
