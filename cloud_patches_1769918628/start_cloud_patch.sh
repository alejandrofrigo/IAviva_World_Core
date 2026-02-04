#!/bin/bash
# PARCHIE CLOUD STARTER
# Se ejecuta junto a IAviva existente

echo "🚀 Iniciando parche cloud..."

# 1. Tunnel a internet (ngrok)
echo "🌐 Configurando acceso internet..."
if command -v ngrok >/dev/null 2>&1; then
    # Usar puerto que no interfiera con IAviva existente
    ngrok http 8080 --log=ngrok_patch.log &
    echo "   Ngrok iniciado en puerto 8080"
else
    echo "   ⚠️ Ngrok no instalado. Instalar con: pkg install ngrok"
fi

# 2. Servidor de réplica shadow
echo "🔄 Iniciando shadow server..."
python3 shadow_server.py &

# 3. Health check del parche
echo "❤️  Health check patch..."
while true; do
    echo "[$(date '+%H:%M:%S')] Cloud patch activo" >> patch_health.log
    sleep 60
done
