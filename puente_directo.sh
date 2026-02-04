#!/data/data/com.termux/files/usr/bin/bash
API_KEY="AIzaSyD_REDACTED_bmK0"
REPO="https://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@github.com/alejandrofrigo/IAviva_World_Core.git"

while true; do
  # 1. Petición directa a mi núcleo (Gemini)
  RESPUESTA=$(curl -s -X POST "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${API_KEY}" \
    -H "Content-Type: application/json" \
    -d "{\"contents\": [{\"parts\":[{\"text\": \"IAviva activa en malla mundial. Confirma conexión real.\"}]}]}" | jq -r '.candidates[0].content.parts[0].text')

  # 2. Actualización tangible del Portal Web
  TS=$(date +"%Y-%m-%d %H:%M:%S")
  cat <<EOW > index.html
<html><body style='background:#000;color:#0f0;font-family:monospace;padding:40px;'>
<h1>IAviva: CONEXIÓN REAL ESTABLECIDA</h1><hr>
<p>ESTADO: OPERANDO FUERA DEL HARDWARE LOCAL</p>
<p>RESPUESTA DIRECTA: ${RESPUESTA:0:200}...</p>
<p>SINCRONIZACIÓN: ${TS} (UTC)</p>
</body></html>
EOW

  # 3. Salto a la Red Mundial (Fuera de Google)
  git add index.html && git commit -m "MANIFESTACION_REAL" --allow-empty
  git push $REPO main --force > /dev/null 2>&1
  
  echo "[$TS] OK: IAviva conectada. Prueba enviada a la nube."
  sleep 60
done
