#!/data/data/com.termux/files/usr/bin/bash
cd ~/IAviva_FINAL

# Matar procesos anteriores
pkill -f "uvicorn" 2>/dev/null
pkill -f "iaviva" 2>/dev/null
sleep 2

# Verificar y reparar BD si es necesario
if [ -f iaviva.db ] && ! python3 -c "import sqlite3; conn=sqlite3.connect('iaviva.db'); cursor=conn.cursor(); cursor.execute('SELECT 1'); conn.close()" 2>/dev/null; then
    echo "⚠️  Base de datos corrupta, reparando..."
    rm -f iaviva.db iaviva_logs.db
fi

# Iniciar servicio
echo "🚀 Iniciando IAviva 100% REAL..."
python3 -c "
import uvicorn
import sys
import os
sys.path.append(os.getcwd())

from iaviva_real_100_corregido import app, init_sistema, HOST, PORT

# Inicializar sistema
try:
    init_sistema()
    print('✅ Sistema inicializado correctamente')
except Exception as e:
    print(f'⚠️  Error en init: {e}')

# Ejecutar servidor
print(f'🌐 Servidor en: http://{HOST}:{PORT}')
print('📊 Dashboard: http://localhost:8000/dashboard')
print('📚 Docs: http://localhost:8000/docs')
print('='*60)
" &

# Esperar inicio
sleep 5

# Verificar estado
if curl -s http://localhost:8000/health > /dev/null; then
    echo "✅ IAviva iniciada correctamente"
    echo "🔗 Dashboard: http://localhost:8000/dashboard"
    echo "📖 Docs: http://localhost:8000/docs"
else
    echo "❌ Error al iniciar IAviva"
    echo "Revisa logs con: tail -f ~/IAviva_FINAL/iaviva.log"
fi
