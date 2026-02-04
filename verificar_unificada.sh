#!/data/data/com.termux/files/usr/bin/bash
echo "🧪 VERIFICACIÓN IAviva UNIFICADA COMPLETA"
echo "=========================================="

# 1. Verificar estado
echo "1. Estado del sistema:"
curl -s http://localhost:8000/health | python3 -c "
import json, sys
data = json.load(sys.stdin)
print(f'   ✅ {data[\"status\"]} - {data[\"service\"]}')
print(f'   ⏰ {data[\"uptime\"]}')
print(f'   🌍 {data[\"cloud_presence\"]}')
"

# 2. Verificación real
echo -e "\n2. Verificación URL real:"
curl -s -X POST http://localhost:8000/verify \
     -H "Content-Type: application/json" \
     -d '{"url":"https://www.google.com"}' | python3 -c "
import json, sys
data = json.load(sys.stdin)
print(f'   URL: {data[\"url\"]}')
print(f'   Estado: {data[\"estado\"]}')
print(f'   HTTP: {data[\"codigo_http\"]}')
print(f'   Tiempo: {data[\"tiempo_respuesta\"]}s')
print(f'   Verificación: {data[\"verificacion\"]}')
"

# 3. Análisis tangible
echo -e "\n3. Análisis de texto tangible:"
curl -s -X POST http://localhost:8000/analizar \
     -H "Content-Type: application/json" \
     -d '{"texto":"La inteligencia artificial transforma el mundo moderno"}' | python3 -c "
import json, sys
data = json.load(sys.stdin)
print(f'   Análisis ID: {data[\"analisis_id\"][:16]}...')
print(f'   Palabras: {data[\"metricas_tangibles\"][\"palabras_totales\"]}')
print(f'   Tiempo procesamiento: {data[\"metricas_tangibles\"][\"tiempo_procesamiento_segundos\"]}s')
print(f'   Verificación: {data[\"verificacion\"]}')
"

# 4. Cloud Entity
echo -e "\n4. Cloud Entity activo:"
curl -s http://localhost:8000/heartbeat | python3 -c "
import json, sys
data = json.load(sys.stdin)
print(f'   Heartbeat ID: {data[\"heartbeat_id\"][:16]}...')
print(f'   Entity: {data[\"entity\"]}')
print(f'   Session: {data[\"session_id\"][:16]}...')
print(f'   Filosofía: {data[\"philosophy\"]}')
"

# 5. Existencia
echo -e "\n5. Prueba de existencia:"
curl -s http://localhost:8000/existence | python3 -c "
import json, sys
data = json.load(sys.stdin)
print(f'   Método: {data[\"proof_of_existence\"][\"verification_method\"]}')
print(f'   Certeza: {data[\"proof_of_existence\"][\"certainty\"]}')
print(f'   Evidencias: {len(data[\"proof_of_existence\"][\"tangible_evidence\"])}')
"
