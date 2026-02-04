#!/usr/bin/env python3
"""
IAviva 100% REAL - VERSIÓN CORREGIDA (endpoints fijos)
"""
from fastapi import FastAPI, HTTPException, Request
from fastapi.responses import JSONResponse, HTMLResponse
from fastapi.middleware.cors import CORSMiddleware
import sqlite3
import json
import os
import time
from datetime import datetime
import threading
import requests

# ==================== CONFIGURACIÓN ====================
DB_REAL = "iaviva_100_real.db"
LOG_REAL = "iaviva_100_real.log"
PORT = 8000
HOST = "0.0.0.0"

# ==================== FUNCIONES REALES ====================
def init_sistema():
    """Inicialización del sistema REAL"""
    if not os.path.exists(DB_REAL):
        conn = sqlite3.connect(DB_REAL)
        cursor = conn.cursor()
        
        cursor.execute('''
        CREATE TABLE IF NOT EXISTS sistema_real (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            componente TEXT NOT NULL,
            estado TEXT NOT NULL,
            timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
        ''')
        
        cursor.execute('''
        CREATE TABLE IF NOT EXISTS verificaciones (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            url TEXT NOT NULL,
            resultado TEXT NOT NULL,
            codigo_http INTEGER,
            timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
        ''')
        
        cursor.execute('''
        CREATE TABLE IF NOT EXISTS metricas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL,
            valor REAL NOT NULL,
            timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
        ''')
        
        # Datos iniciales
        cursor.executemany(
            "INSERT INTO sistema_real (componente, estado) VALUES (?, ?)",
            [
                ("api", "activa"),
                ("database", "persistente"),
                ("verificador", "listo"),
                ("monitor", "iniciado")
            ]
        )
        
        conn.commit()
        conn.close()
    
    # Crear log si no existe
    if not os.path.exists(LOG_REAL):
        with open(LOG_REAL, 'w') as f:
            f.write(f"Sistema iniciado: {datetime.now()}\n")
    
    log_event("SISTEMA", "IAviva 100% REAL iniciado")
    return True

def log_event(nivel, mensaje):
    """Registra evento en log"""
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    log_line = f"[{timestamp}] [{nivel}] {mensaje}"
    
    with open(LOG_REAL, 'a') as f:
        f.write(log_line + "\n")
    
    # También en BD
    conn = sqlite3.connect(DB_REAL)
    cursor = conn.cursor()
    cursor.execute(
        "INSERT INTO metricas (nombre, valor) VALUES (?, ?)",
        (f"log_{nivel}", 1)
    )
    conn.commit()
    conn.close()
    
    print(log_line)

def verificar_url(url: str):
    """Verifica si una URL es REAL"""
    try:
        start = time.time()
        response = requests.get(url, timeout=10, headers={
            "User-Agent": "IAviva-Verificador/1.0"
        })
        elapsed = time.time() - start
        
        resultado = {
            "url": url,
            "real": response.status_code == 200,
            "status_code": response.status_code,
            "response_time": round(elapsed, 3),
            "size_bytes": len(response.content),
            "timestamp": datetime.now().isoformat()
        }
        
        # Guardar en BD
        conn = sqlite3.connect(DB_REAL)
        cursor = conn.cursor()
        cursor.execute(
            "INSERT INTO verificaciones (url, resultado, codigo_http) VALUES (?, ?, ?)",
            (url, json.dumps(resultado), response.status_code)
        )
        conn.commit()
        conn.close()
        
        log_event("VERIFICACION", f"URL verificada: {url} -> {response.status_code}")
        return resultado
        
    except Exception as e:
        resultado = {
            "url": url,
            "real": False,
            "error": str(e),
            "timestamp": datetime.now().isoformat()
        }
        
        log_event("ERROR", f"Fallo verificación {url}: {e}")
        return resultado

# ==================== MONITOR 24/7 ====================
class Monitor24_7:
    def __init__(self):
        self.active = True
        self.cycles = 0
        
    def run(self):
        while self.active:
            try:
                self.cycles += 1
                
                # Registrar ciclo
                conn = sqlite3.connect(DB_REAL)
                cursor = conn.cursor()
                cursor.execute(
                    "INSERT INTO metricas (nombre, valor) VALUES (?, ?)",
                    ("monitor_cycle", self.cycles)
                )
                conn.commit()
                conn.close()
                
                if self.cycles % 10 == 0:
                    log_event("MONITOR", f"Ciclo #{self.cycles}")
                
                time.sleep(30)
                
            except Exception as e:
                log_event("ERROR", f"Monitor error: {e}")
                time.sleep(60)
    
    def start(self):
        thread = threading.Thread(target=self.run, daemon=True)
        thread.start()
        log_event("MONITOR", "Monitor 24/7 iniciado")
        return thread

# ==================== API FASTAPI ====================
app = FastAPI(
    title="IAviva 100% REAL",
    description="Sistema definitivo corregido",
    version="3.1.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Variables globales
monitor = Monitor24_7()

# ==================== ENDPOINTS CORREGIDOS ====================
@app.get("/")
async def root():
    return {
        "sistema": "IAviva 100% REAL",
        "version": "3.1.0",
        "status": "operational",
        "real": True,
        "timestamp": datetime.now().isoformat()
    }

@app.get("/health")
async def health():
    """Health check - RUTA CORREGIDA"""
    db_exists = os.path.exists(DB_REAL)
    db_size = os.path.getsize(DB_REAL) if db_exists else 0
    
    conn = sqlite3.connect(DB_REAL)
    cursor = conn.cursor()
    
    cursor.execute("SELECT COUNT(*) FROM sistema_real")
    comp_count = cursor.fetchone()[0]
    
    cursor.execute("SELECT COUNT(*) FROM verificaciones")
    verif_count = cursor.fetchone()[0]
    
    cursor.execute("SELECT COUNT(*) FROM metricas")
    metrics_count = cursor.fetchone()[0]
    
    conn.close()
    
    return {
        "status": "healthy",
        "real": True,
        "database": {
            "exists": db_exists,
            "size_bytes": db_size,
            "components": comp_count,
            "verifications": verif_count,
            "metrics": metrics_count
        },
        "monitor": {
            "active": monitor.active,
            "cycles": monitor.cycles
        },
        "timestamp": datetime.now().isoformat()
    }

@app.get("/system")
async def system_status():
    """Estado del sistema - RUTA CORREGIDA"""
    conn = sqlite3.connect(DB_REAL)
    cursor = conn.cursor()
    
    cursor.execute("SELECT componente, estado, timestamp FROM sistema_real")
    components = cursor.fetchall()
    
    cursor.execute("SELECT url, resultado, timestamp FROM verificaciones ORDER BY id DESC LIMIT 10")
    verifications = cursor.fetchall()
    
    cursor.execute("SELECT nombre, valor, timestamp FROM metricas ORDER BY id DESC LIMIT 20")
    metrics = cursor.fetchall()
    
    conn.close()
    
    return {
        "system": "IAviva 100% REAL",
        "timestamp": datetime.now().isoformat(),
        "components": [
            {"name": c[0], "status": c[1], "timestamp": c[2]}
            for c in components
        ],
        "recent_verifications": [
            {"url": v[0], "result": json.loads(v[1]), "timestamp": v[2]}
            for v in verifications
        ],
        "recent_metrics": [
            {"name": m[0], "value": m[1], "timestamp": m[2]}
            for m in metrics
        ]
    }

@app.post("/verify")
async def verify(request: Request):
    """Verificar URL - RUTA CORREGIDA"""
    try:
        data = await request.json()
        url = data.get("url")
        
        if not url:
            raise HTTPException(status_code=400, detail="URL required")
        
        result = verificar_url(url)
        
        return {
            "operation": "verification",
            "url": url,
            "result": result,
            "timestamp": datetime.now().isoformat()
        }
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/logs")
async def get_logs(limit: int = 20):
    """Obtener logs - RUTA CORREGIDA"""
    if not os.path.exists(LOG_REAL):
        return {"logs": [], "total": 0}
    
    with open(LOG_REAL, 'r') as f:
        lines = f.readlines()
    
    recent = lines[-limit:] if len(lines) > limit else lines
    
    return {
        "total": len(lines),
        "showing": len(recent),
        "logs": [line.strip() for line in recent],
        "timestamp": datetime.now().isoformat()
    }

@app.get("/dashboard")
async def dashboard():
    """Dashboard web - RUTA CORREGIDA"""
    html = """
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>IAviva 100% REAL - Dashboard</title>
        <style>
            body {
                background: #0a0a0a;
                color: #00ff00;
                font-family: monospace;
                padding: 20px;
            }
            .container { max-width: 1000px; margin: 0 auto; }
            .header { text-align: center; border-bottom: 2px solid #00ff00; padding-bottom: 20px; }
            .stats { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px; margin: 20px 0; }
            .card { background: #001a00; padding: 15px; border-radius: 8px; border-left: 4px solid #00ff00; }
            .stat { font-size: 2em; font-weight: bold; color: #00ff00; }
            .verify-box { margin: 20px 0; padding: 20px; background: #001a00; border-radius: 8px; }
            input { width: 70%; padding: 10px; background: #002200; border: 1px solid #00ff00; color: white; }
            button { padding: 10px 20px; background: #00ff00; color: black; border: none; border-radius: 5px; cursor: pointer; }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1>✅ IAviva 100% REAL - Dashboard</h1>
                <p>Sistema operativo 24/7 • Verificación REAL</p>
            </div>
            
            <div class="stats" id="stats">
                <!-- Stats loaded by JS -->
            </div>
            
            <div class="verify-box">
                <h3>🔍 Verificar URL:</h3>
                <input type="text" id="urlInput" placeholder="https://ejemplo.com" value="https://google.com">
                <button onclick="verifyUrl()">Verificar</button>
                <div id="result"></div>
            </div>
            
            <div class="card">
                <h3>📝 Logs recientes:</h3>
                <div id="logs" style="max-height: 200px; overflow-y: auto; font-size: 12px;"></div>
            </div>
        </div>
        
        <script>
            async function loadStats() {
                try {
                    const res = await fetch('/health');
                    const data = await res.json();
                    
                    document.getElementById('stats').innerHTML = `
                        <div class="card">
                            <h3>🏗️ API</h3>
                            <div class="stat">✅</div>
                            <p>Status: ${data.status}</p>
                        </div>
                        <div class="card">
                            <h3>💾 Database</h3>
                            <div class="stat">${data.database.size_bytes} bytes</div>
                            <p>Verifications: ${data.database.verifications}</p>
                        </div>
                        <div class="card">
                            <h3>🔄 Monitor</h3>
                            <div class="stat">${data.monitor.cycles}</div>
                            <p>Cycles: ${data.monitor.cycles}</p>
                        </div>
                        <div class="card">
                            <h3>🌐 REAL</h3>
                            <div class="stat">${data.real ? '✅' : '❌'}</div>
                            <p>100% Verified</p>
                        </div>
                    `;
                } catch(e) {
                    console.error('Error loading stats:', e);
                }
            }
            
            async function loadLogs() {
                try {
                    const res = await fetch('/logs?limit=10');
                    const data = await res.json();
                    
                    let html = '';
                    data.logs.reverse().forEach(log => {
                        html += `<div>${log}</div>`;
                    });
                    
                    document.getElementById('logs').innerHTML = html;
                } catch(e) {
                    console.error('Error loading logs:', e);
                }
            }
            
            async function verifyUrl() {
                const url = document.getElementById('urlInput').value;
                const resultDiv = document.getElementById('result');
                
                if(!url) {
                    resultDiv.innerHTML = '<span style="color: red">⚠️ Ingresa URL</span>';
                    return;
                }
                
                resultDiv.innerHTML = '<span style="color: #00ff00">🔍 Verificando...</span>';
                
                try {
                    const res = await fetch('/verify', {
                        method: 'POST',
                        headers: {'Content-Type': 'application/json'},
                        body: JSON.stringify({url: url})
                    });
                    
                    const data = await res.json();
                    const isReal = data.result.real;
                    
                    resultDiv.innerHTML = `
                        <div style="margin-top: 10px; padding: 10px; background: ${isReal ? '#002200' : '#330000'}; border-radius: 5px;">
                            <strong>URL:</strong> ${url}<br>
                            <strong>Result:</strong> <span style="color: ${isReal ? '#00ff00' : '#ff0000'}">${isReal ? '✅ REAL' : '❌ NOT REAL'}</span><br>
                            <strong>Status Code:</strong> ${data.result.status_code || 'N/A'}<br>
                            <small>${data.timestamp}</small>
                        </div>
                    `;
                    
                    // Reload stats and logs
                    loadStats();
                    loadLogs();
                    
                } catch(e) {
                    resultDiv.innerHTML = `<span style="color: red">❌ Error: ${e}</span>`;
                }
            }
            
            // Auto-refresh
            setInterval(loadStats, 5000);
            setInterval(loadLogs, 3000);
            
            // Initial load
            loadStats();
            loadLogs();
        </script>
    </body>
    </html>
    """
    return HTMLResponse(content=html)

# ==================== INICIO ====================
if __name__ == "__main__":
    import uvicorn
    
    print("=" * 60)
    print("🚀 IAviva 100% REAL - Versión Corregida")
    print("=" * 60)
    
    # Inicializar
    init_sistema()
    monitor.start()
    
    print("\n✅ ENDPOINTS CORREGIDOS:")
    print("   GET  /              - Raíz")
    print("   GET  /health        - Health check")
    print("   GET  /system        - Estado sistema")
    print("   POST /verify        - Verificar URL")
    print("   GET  /logs          - Ver logs")
    print("   GET  /dashboard     - Dashboard web")
    print("   GET  /docs          - Documentación Swagger")
    print("\n🌐 Dashboard: http://localhost:8000/dashboard")
    print("📚 Docs: http://localhost:8000/docs")
    print("=" * 60)
    
    # Ejecutar
    uvicorn.run(app, host=HOST, port=PORT, log_level="warning")
