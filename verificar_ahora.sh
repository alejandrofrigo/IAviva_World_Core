#!/data/data/com.termux/files/usr/bin/bash
cd ~/IAviva_FINAL

echo "🔍 VERIFICACIÓN INSTANTÁNEA IAviva"
echo "=================================="

# Verificar si el servidor está activo
if curl -s http://localhost:8000/health > /dev/null 2>&1; then
    echo "✅ Servidor: ACTIVO"
    
    # Test de verificación REAL
    echo ""
    echo "🧪 Probando verificación con Google..."
    curl -X POST http://localhost:8000/verify \
         -H "Content-Type: application/json" \
         -d '{"url":"https://www.google.com"}' \
         -s | python3 -m json.tool
    
    echo ""
    echo "📊 Estado del sistema:"
    curl -s http://localhost:8000/system | python3 -m json.tool
    
    echo ""
    echo "📋 Últimos logs:"
    curl -s "http://localhost:8000/logs?limit=5" | python3 -m json.tool
    
else
    echo "❌ Servidor: INACTIVO"
    echo "Iniciando IAviva..."
    ./start_iaviva_24x7.sh
fi
