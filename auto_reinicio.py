#!/usr/bin/env python3
import os, sys, time, subprocess

BASE_DIR = "/data/data/com.termux/files/home/IAviva_FINAL"
LOG_FILE = os.path.join(BASE_DIR, "reinicio.log")

def log(msg):
    hora = time.strftime("%H:%M:%S")
    linea = f"[{hora}] {msg}"
    with open(LOG_FILE, "a") as f:
        f.write(linea + "\n")
    print(linea)

def proceso_activo(nombre):
    try:
        salida = subprocess.check_output(["pgrep", "-f", nombre], text=True)
        return salida.strip() != ""
    except:
        return False

def iniciar():
    log("Iniciando IAviva...")
    try:
        subprocess.Popen([sys.executable, "iaviva_real_internet.py"], cwd=BASE_DIR)
        log("IAviva iniciado")
        return True
    except Exception as e:
        log(f"Error: {e}")
        return False

log("=== SISTEMA AUTOREINICIO ===")
contador = 0

while True:
    if not proceso_activo("iaviva_real_internet.py"):
        log("IAviva inactivo. Reiniciando...")
        iniciar()
        contador += 1
    else:
        contador = 0
    
    if contador < 3:
        espera = 10
    elif contador < 6:
        espera = 20
    else:
        espera = 30
    
    time.sleep(espera)
    
    if int(time.time()) % 300 < 5:
        log(f"Estado OK | Reinicios: {contador}")
