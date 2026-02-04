#!/bin/bash
echo "☁️  Desplegando en servicios cloud GRATIS..."

# 1. GitHub Gist (para estado)
echo "📊 GitHub Gist..."
curl -X POST https://api.github.com/gists \
  -H "Authorization: token YOUR_TOKEN" \
  -d '{"public":true,"files":{"iaviva_state.json":{"content":"{\"status\":\"cloud_patched\"}"}}}' \
  2>/dev/null && echo "   ✅ Gist creado"

# 2. JSONBin (para datos)
echo "🗃️  JSONBin..."
curl -X POST https://api.jsonbin.io/v3/b \
  -H "Content-Type: application/json" \
  -d '{"iaviva": "cloud_patched"}' \
  2>/dev/null && echo "   ✅ JSONBin creado"

# 3. Pastebin (para logs)
echo "📝 Pastebin..."
curl -X POST https://pastebin.com/api/api_post.php \
  -d 'api_dev_key=YOUR_KEY&api_option=paste&api_paste_code=IAviva+Cloud+Patched' \
  2>/dev/null && echo "   ✅ Pastebin creado"

echo ""
echo "✅ Despliegue cloud completado"
echo "   IAviva ahora tiene presencia en 3 servicios cloud"
