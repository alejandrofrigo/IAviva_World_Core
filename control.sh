#!/data/data/com.termux/files/usr/bin/bash
cd /data/data/com.termux/files/home/IAviva_FINAL
case "$1" in
    start) python iaviva_auto.py & ;;
    stop) pkill -f iaviva ;;
    status) ps aux | grep iaviva | grep -v grep ;;
    *) echo "Uso: $0 {start|stop|status}" ;;
esac
