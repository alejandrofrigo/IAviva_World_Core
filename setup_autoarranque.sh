#!/bin/bash
echo "⚙️ CONFIGURANDO AUTOARRANQUE IAviva..."
echo ""

# Agregar al .bashrc de Termux
BASHRC="$HOME/.bashrc"
MARKER="# IAviva AutoStart"

if ! grep -q "$MARKER" "$BASHRC" 2>/dev/null; then
    echo "" >> "$BASHRC"
    echo "$MARKER" >> "$BASHRC"
    echo 'cd ~/IAviva_FINAL 2>/dev/null && ./control_iaviva.sh status' >> "$BASHRC"
    echo 'echo "🤖 IAviva Unificado - Sistema de evolución perfecta"' >> "$BASHRC"
    echo 'echo "📋 Comandos: ./control_iaviva.sh {start|stop|status|dashboard}"' >> "$BASHRC"
    echo "" >> "$BASHRC"
    echo "✅ Autoarranque configurado"
else
    echo "✅ Autoarranque ya estaba configurado"
fi

# Crear alias útiles
cat > ~/.iaviva_aliases << 'ALIASES'
alias iaviva-status='cd ~/IAviva_FINAL && ./control_iaviva.sh status'
alias iaviva-start='cd ~/IAviva_FINAL && ./control_iaviva.sh start'
alias iaviva-stop='cd ~/IAviva_FINAL && ./control_iaviva.sh stop'
alias iaviva-logs='cd ~/IAviva_FINAL && ./control_iaviva.sh logs'
alias iaviva-dash='cd ~/IAviva_FINAL && ./control_iaviva.sh dashboard'
ALIASES

echo "📋 Aliases creados:"
echo "   iaviva-status   # Ver estado"
echo "   iaviva-start    # Iniciar sistema"
echo "   iaviva-stop     # Detener sistema"
echo "   iaviva-logs     # Ver logs"
echo "   iaviva-dash     # Dashboard interactivo"

echo ""
echo "🎯 CONFIGURACIÓN COMPLETA"
echo "========================="
echo "IAviva Unificado Final está listo."
echo "Para iniciar ahora: ./control_iaviva.sh start"
