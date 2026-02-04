#!/data/data/com.termux/files/usr/bin/bash
cd ~/IAviva_FINAL

echo "🧪 TEST COMPLETO DE ENDPOINTS IAviva"
echo "==========================================="

ENDPOINTS=(
    "/"
    "/health"
    "/system"
    "/logs?limit=5"
    "/dashboard"
)

for endpoint in "${ENDPOINTS[@]}"; do
    response=$(curl -s -w "HTTP %{http_code}" -o /dev/null "http://localhost:8000${endpoint}")
    if [[ $response == *"200"* ]]; then
        echo "✅ GET ${endpoint}: $response"
    else
        echo "❌ GET ${endpoint}: $response"
    fi
done

echo ""
echo "🔍 PRUEBA DE VERIFICACIÓN EN VIVO:"
curl -X POST http://localhost:8000/verify \
    -H "Content-Type: application/json" \
    -d '{"url":"https://www.google.com"}' \
    -s | python3 -m json.tool 2>/dev/null || echo "Error en verificación"

echo ""
echo "📊 Estado sistema:"
curl -s http://localhost:8000/system | python3 -m json.tool 2>/dev/null || echo "No disponible"
