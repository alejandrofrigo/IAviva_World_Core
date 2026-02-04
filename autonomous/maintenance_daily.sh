#!/bin/bash
# Mantenimiento diario automático

echo "🧹 MANTENIMIENTO DIARIO - $(date)"
echo "================================"

cd ~/IAviva_FINAL

# Rotar logs grandes
find logs/ -name "*.log" -size +10M -exec truncate -s 5M {} \;

# Limpiar backups viejos (>7 días)
find autonomous/backups/ -name "*.backup" -mtime +7 -delete 2>/dev/null

# Backup de configuración
cp autonomous/health_status.json "autonomous/backups/health_$(date +%Y%m%d).backup" 2>/dev/null

echo "✅ Mantenimiento completado"
