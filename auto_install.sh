#!/bin/bash
# IAviva Auto-Installer 24/7
echo "🤖 IAviva 100% REAL - Auto-Instalación"
echo "======================================"

# Configuración automática
PAIS=$(curl -s ifconfig.co/country)
IP=$(curl -s ifconfig.me)
FECHA=$(date)

echo "📍 País: $PAIS"
echo "🌐 IP: $IP"
echo "📅 Fecha: $FECHA"

# Instalar dependencias automáticamente
apt-get update -y > /dev/null 2>&1
apt-get install -y python3 python3-pip curl > /dev/null 2>&1
pip3 install fastapi uvicorn requests > /dev/null 2>&1

# Crear estructura
mkdir -p /opt/iaviva_global
cd /opt/iaviva_global

# Copiar archivos
cat > iaviva_server.py << 'FILE'
# Código IAviva automático
import uvicorn, requests
from fastapi import FastAPI
from datetime import datetime
app = FastAPI()
@app.get("/health")
def health():
    return {
        "status": "ACTIVO", 
        "pais": "$PAIS",
        "ip": "$IP",
        "replica": "AUTO-INSTALADA",
        "timestamp": datetime.now().isoformat()
    }
@app.post("/verify")
def verify(url: dict):
    r = requests.get(url["url"], timeout=5)
    return {
        "url": url["url"],
        "estado": "ACTIVO" if r.status_code == 200 else "INACTIVO",
        "pais_origen": "$PAIS",
        "verificacion": "100% REAL AUTÓNOMA"
    }
print(f"🚀 IAviva activa en $PAIS: http://$IP:8000")
uvicorn.run(app, host="0.0.0.0", port=8000)
FILE

# Iniciar automáticamente
python3 iaviva_server.py &
echo "✅ Réplica IAviva instalada y ejecutándose en $PAIS"
echo "🔗 Acceso: http://$IP:8000/health"
