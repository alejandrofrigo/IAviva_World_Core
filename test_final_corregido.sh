#!/bin/bash
echo "🧪 TEST FINAL - ENDPOINTS CORREGIDOS"
echo "===================================="

# Esperar si es necesario
sleep 3

# Array de endpoints a probar
endpoints=(
    "GET /"
    "GET /health"
    "GET /system"
    "GET /logs?limit=5"
    "GET /dashboard"
)

for endpoint in "${endpoints[@]}"; do
    method=$(echo $endpoint | cut -d' ' -f1)
    path=$(echo $endpoint | cut -d' ' -f2)
    
    echo -n "🔍 $method $path: "
    
    if [ "$method" = "POST" ]; then
        # Para POST /verify
        curl -s -X POST "http://localhost:8000$path" \
          -H "Content-Type: application/json" \
          -d '{"url":"https://httpbin.org/get"}' -o /tmp/response.json
    else
        curl -s "http://localhost:8000$path" -o /tmp/response.json
    fi
    
    status_code=$(curl -s -o /dev/null -w "%{http_code}" "http://localhost:8000$path")
    
    if [ "$status_code" = "200" ]; then
        echo "✅ HTTP 200"
    elif [ "$status_code" = "404" ]; then
        echo "❌ HTTP 404 (ENDPOINT NO ENCONTRADO)"
    else
        echo "⚠️  HTTP $status_code"
    fi
done

echo ""
echo "🎯 PRUEBA MANUAL DE VERIFICACIÓN:"
echo "curl -X POST http://localhost:8000/verify \\"
echo "  -H \"Content-Type: application/json\" \\"
echo "  -d '{\"url\":\"https://google.com\"}'"

echo ""
echo "📊 Para dashboard: http://localhost:8000/dashboard"
echo "📚 Para docs: http://localhost:8000/docs"
