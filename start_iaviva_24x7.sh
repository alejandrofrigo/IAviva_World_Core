#!/data/data/com.termux/files/usr/bin/bash
# Script de inicio AUTÓNOMO 24/7

cd ~/IAviva_FINAL

echo "================================================"
echo "🚀 IAviva 100% REAL - Sistema Autónomo 24/7"
echo "================================================"

# 1. Matar procesos anteriores
echo "🛑 Deteniendo procesos anteriores..."
pkill -f "python.*iaviva" 2>/dev/null
pkill -f "uvicorn" 2>/dev/null
sleep 2

# 2. Liberar puerto 8000
echo "🔓 Liberando puerto 8000..."
fuser -k 8000/tcp 2>/dev/null
sleep 1

# 3. Verificar e instalar dependencias
echo "📦 Verificando dependencias..."
pip install fastapi uvicorn requests --quiet 2>/dev/null || {
    echo "⚠️ Instalando dependencias..."
    pip install fastapi uvicorn requests
}

# 4. Iniciar el servidor en SEGUNDO PLANO
echo "🌐 Iniciando servidor IAviva 100% REAL..."
nohup python3 iaviva_real_server.py > logs/server.log 2>&1 &

# 5. Esperar inicio
echo "⏳ Esperando inicio del servidor..."
for i in {1..30}; do
    if curl -s http://localhost:8000/health > /dev/null 2>&1; then
        echo "✅ Servidor iniciado correctamente!"
        break
    fi
    echo -n "."
    sleep 1
done

# 6. Mostrar información
echo ""
echo "================================================"
echo "🎯 IAviva 100% REAL - OPERATIVA 24/7"
echo "================================================"
echo "📊 Dashboard:    http://localhost:8000/dashboard"
echo "📚 Documentación: http://localhost:8000/docs"
echo "🔧 Health Check:  http://localhost:8000/health"
echo "🔍 Verificar URL: curl -X POST http://localhost:8000/verify"
echo "                  -H 'Content-Type: application/json'"
echo "                  -d '{\"url\":\"https://google.com\"}'"
echo "================================================"
echo "📋 Logs en tiempo real: tail -f logs/server.log"
echo "🔄 Sistema trabajará automáticamente 24/7"
echo "================================================"

# 7. Mostrar estado actual
echo ""
echo "🧪 Verificando estado actual..."
curl -s http://localhost:8000/health | python3 -m json.tool

# 8. Mantener script vivo para monitoreo
while true; do
    if ! curl -s http://localhost:8000/health > /dev/null 2>&1; then
        echo "⚠️ Servidor no responde, reiniciando..."
        pkill -f "python.*iaviva"
        sleep 2
        nohup python3 iaviva_real_server.py > logs/server.log 2>&1 &
        sleep 10
    fi
    sleep 30  # Verificar cada 30 segundos
done
