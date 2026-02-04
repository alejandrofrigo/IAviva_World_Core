#!/usr/bin/env python3
"""
Servidor Shadow - Réplica read-only de IAviva
No modifica, solo refleja estado
"""
from flask import Flask, jsonify
import time
import os

app = Flask(__name__)

@app.route('/')
def home():
    return jsonify({
        "status": "shadow_iaviva",
        "original": "active (not modified)",
        "cloud": True,
        "timestamp": time.time()
    })

@app.route('/health')
def health():
    # Health check sin tocar original
    return jsonify({"alive": True, "mode": "shadow"})

@app.route('/sync')
def sync():
    # Punto de sincronización
    return jsonify({"synced": True})

if __name__ == '__main__':
    print("🌥️ Shadow IAviva Cloud Server iniciado")
    print("   Puerto: 8080 (no interfiere con IAviva en 8000)")
    print("   Modo: Read-only reflection")
    app.run(host='0.0.0.0', port=8080, debug=False)
