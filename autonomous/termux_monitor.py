#!/usr/bin/env python3
"""
Sistema de monitoreo nativo para Termux
Sin dependencias problemáticas
"""
import os
import time
import json
import subprocess
import requests
from datetime import datetime

class TermuxMonitor:
    def __init__(self):
        self.health_file = "autonomous/health_status.json"
        self.repair_log = "autonomous/repair_history.json"
        self.ensure_files()
    
    def ensure_files(self):
        """Asegura que existan los archivos necesarios"""
        os.makedirs("autonomous", exist_ok=True)
        
        if not os.path.exists(self.health_file):
            with open(self.health_file, 'w') as f:
                json.dump({"checks": [], "last_check": None}, f)
        
        if not os.path.exists(self.repair_log):
            with open(self.repair_log, 'w') as f:
                json.dump({"repairs": []}, f)
    
    def check_iaviva_service(self):
        """Verifica si IAviva está respondiendo"""
        try:
            response = requests.get("http://localhost:8000/health", timeout=5)
            return {
                "service": "IAviva API",
                "status": "healthy" if response.status_code == 200 else "unhealthy",
                "code": response.status_code,
                "details": response.json() if response.status_code == 200 else {}
            }
        except Exception as e:
            return {
                "service": "IAviva API",
                "status": "down",
                "error": str(e),
                "code": 0
            }
    
    def check_port_8000(self):
        """Verifica si hay algo escuchando en puerto 8000"""
        try:
            # Método para Termux
            result = subprocess.run(
                ["ss", "-tuln"],
                capture_output=True,
                text=True,
                timeout=5
            )
            
            if ":8000" in result.stdout:
                return {
                    "service": "Port 8000",
                    "status": "in_use",
                    "details": "Puerto 8000 ocupado"
                }
            else:
                return {
                    "service": "Port 8000",
                    "status": "free",
                    "details": "Puerto 8000 disponible"
                }
        except:
            # Método alternativo
            try:
                result = subprocess.run(
                    ["lsof", "-i", ":8000"],
                    capture_output=True,
                    text=True,
                    timeout=5
                )
                return {
                    "service": "Port 8000",
                    "status": "in_use" if result.stdout else "free",
                    "details": result.stdout[:100] if result.stdout else "No output"
                }
            except:
                return {
                    "service": "Port 8000",
                    "status": "unknown",
                    "details": "No se pudo verificar"
                }
    
    def check_iaviva_process(self):
        """Verifica si hay procesos de IAviva corriendo"""
        try:
            result = subprocess.run(
                ["ps", "aux"],
                capture_output=True,
                text=True,
                timeout=5
            )
            
            iaviva_processes = []
            for line in result.stdout.split('\n'):
                if "iaviva" in line.lower() and "grep" not in line:
                    iaviva_processes.append(line.strip())
            
            return {
                "service": "IAviva Processes",
                "status": "running" if iaviva_processes else "stopped",
                "count": len(iaviva_processes),
                "details": iaviva_processes[:3]  # Primeros 3 procesos
            }
        except Exception as e:
            return {
                "service": "IAviva Processes",
                "status": "unknown",
                "error": str(e)
            }
    
    def check_system_resources(self):
        """Verifica recursos del sistema (método Termux)"""
        try:
            # Memoria desde /proc/meminfo
            with open("/proc/meminfo", "r") as f:
                mem_info = f.read()
            
            # Extraer valores
            mem_total = 0
            mem_available = 0
            
            for line in mem_info.split('\n'):
                if line.startswith("MemTotal:"):
                    mem_total = int(line.split()[1])
                elif line.startswith("MemAvailable:"):
                    mem_available = int(line.split()[1])
            
            memory_percent = 0
            if mem_total > 0:
                memory_percent = 100 * (1 - (mem_available / mem_total))
            
            return {
                "service": "System Resources",
                "status": "ok" if memory_percent < 90 else "warning",
                "memory_percent": round(memory_percent, 1),
                "memory_total_kb": mem_total,
                "memory_available_kb": mem_available
            }
        except:
            return {
                "service": "System Resources",
                "status": "unknown",
                "details": "No se pudo verificar"
            }
    
    def perform_checks(self):
        """Realiza todas las verificaciones"""
        checks = [
            self.check_iaviva_service(),
            self.check_port_8000(),
            self.check_iaviva_process(),
            self.check_system_resources()
        ]
        
        # Guardar resultados
        check_data = {
            "timestamp": datetime.now().isoformat(),
            "checks": checks,
            "all_healthy": all(c["status"] in ["healthy", "running", "in_use", "ok"] 
                              for c in checks[:3])  # Excluye recursos
        }
        
        with open(self.health_file, 'w') as f:
            json.dump(check_data, f, indent=2)
        
        return check_data
    
    def auto_repair(self, check_results):
        """Reparación automática basada en resultados"""
        repairs = []
        
        # 1. Si IAviva no responde pero el puerto está ocupado
        if (check_results["checks"][0]["status"] == "down" and 
            check_results["checks"][1]["status"] == "in_use"):
            print("🔧 Detectado: IAviva no responde pero puerto ocupado")
            repairs.append(self.kill_and_restart())
        
        # 2. Si IAviva no responde y no hay procesos
        elif (check_results["checks"][0]["status"] == "down" and 
              check_results["checks"][2]["status"] == "stopped"):
            print("🔧 Detectado: IAviva detenido")
            repairs.append(self.start_iaviva())
        
        # 3. Si memoria muy alta
        elif (check_results["checks"][3]["status"] == "warning" and 
              check_results["checks"][3].get("memory_percent", 0) > 95):
            print("🔧 Detectado: Memoria crítica")
            repairs.append(self.clean_memory())
        
        # Registrar reparaciones
        if repairs:
            self.log_repairs(repairs)
        
        return repairs
    
    def kill_and_restart(self):
        """Mata procesos y reinicia"""
        print("🔄 Matando procesos y reiniciando IAviva...")
        
        try:
            # Matar procesos en puerto 8000
            subprocess.run(["pkill", "-f", "python.*8000"], timeout=10)
            subprocess.run(["pkill", "-f", "iaviva"], timeout=10)
            time.sleep(3)
            
            # Reiniciar
            result = self.start_iaviva()
            result["action"] = "kill_and_restart"
            return result
        except Exception as e:
            return {
                "action": "kill_and_restart",
                "success": False,
                "error": str(e),
                "timestamp": datetime.now().isoformat()
            }
    
    def start_iaviva(self):
        """Inicia IAviva"""
        print("🚀 Iniciando IAviva...")
        
        try:
            # Cambiar al directorio correcto
            os.chdir(os.path.expanduser("~/IAviva_FINAL"))
            
            # Iniciar en segundo plano
            process = subprocess.Popen(
                ["./start_iaviva_24x7.sh"],
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
                start_new_session=True
            )
            
            time.sleep(10)  # Esperar inicio
            
            # Verificar
            check = self.check_iaviva_service()
            success = check["status"] == "healthy"
            
            return {
                "action": "start_iaviva",
                "success": success,
                "pid": process.pid,
                "status": check["status"],
                "timestamp": datetime.now().isoformat()
            }
        except Exception as e:
            return {
                "action": "start_iaviva",
                "success": False,
                "error": str(e),
                "timestamp": datetime.now().isoformat()
            }
    
    def clean_memory(self):
        """Limpia memoria"""
        print("🧹 Limpiando memoria...")
        
        try:
            # Limpiar cache de Python
            subprocess.run(["python3", "-c", "import gc; gc.collect()"], timeout=5)
            
            # Limpiar logs grandes
            log_files = ["logs/server.log", "logs/error.log"]
            for log_file in log_files:
                if os.path.exists(log_file) and os.path.getsize(log_file) > 10485760:  # 10MB
                    with open(log_file, 'w') as f:
                        f.write(f"# Log limpiado automáticamente: {datetime.now()}\n")
            
            return {
                "action": "clean_memory",
                "success": True,
                "timestamp": datetime.now().isoformat()
            }
        except Exception as e:
            return {
                "action": "clean_memory",
                "success": False,
                "error": str(e),
                "timestamp": datetime.now().isoformat()
            }
    
    def log_repairs(self, repairs):
        """Registra reparaciones"""
        try:
            with open(self.repair_log, 'r') as f:
                data = json.load(f)
            
            data["repairs"].extend(repairs)
            
            # Mantener solo últimas 50 reparaciones
            if len(data["repairs"]) > 50:
                data["repairs"] = data["repairs"][-50:]
            
            with open(self.repair_log, 'w') as f:
                json.dump(data, f, indent=2)
        except:
            pass
    
    def run(self):
        """Ejecuta monitoreo continuo"""
        print("🤖 SISTEMA DE AUTO-REPARACIÓN IAviva ACTIVO")
        print("==========================================")
        print(f"Inicio: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        print("Chequeos cada 60 segundos")
        print("Reparación automática activada")
        print("")
        
        cycle = 0
        
        while True:
            cycle += 1
            print(f"\n🔄 Ciclo {cycle} - {datetime.now().strftime('%H:%M:%S')}")
            
            # Realizar verificaciones
            print("🔍 Realizando verificaciones...")
            check_results = self.perform_checks()
            
            # Mostrar resultados
            for check in check_results["checks"]:
                status_icon = "✅" if check["status"] in ["healthy", "running", "in_use", "ok"] else "⚠️" if check["status"] == "warning" else "❌"
                print(f"   {status_icon} {check['service']}: {check['status']}")
            
            # Reparación automática si es necesario
            if not check_results["all_healthy"]:
                print("🔧 Problemas detectados - Iniciando reparación automática...")
                repairs = self.auto_repair(check_results)
                
                if repairs:
                    for repair in repairs:
                        icon = "✅" if repair.get("success", False) else "❌"
                        print(f"   {icon} {repair['action']}: {'Éxito' if repair.get('success') else 'Fallo'}")
            else:
                print("✅ Todo funcionando correctamente")
            
            # Esperar 60 segundos
            time.sleep(60)

if __name__ == "__main__":
    monitor = TermuxMonitor()
    monitor.run()
