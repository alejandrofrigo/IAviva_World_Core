#!/usr/bin/env python3
"""
Sistema simple de auto-reparación
"""
import time
import requests
import json
import os
import psutil
from datetime import datetime

class SimpleHealer:
    def __init__(self):
        self.health_log = []
        self.repair_log = []
        self.load_config()
    
    def load_config(self):
        """Carga configuración"""
        os.makedirs('autonomous/self_healing', exist_ok=True)
        try:
            with open('autonomous/self_healing/config.json', 'r') as f:
                self.config = json.load(f)
        except:
            self.config = {
                'check_interval': 60,
                'max_retries': 3,
                'auto_restart': True
            }
    
    def check_iaviva_health(self):
        """Verifica salud de IAviva"""
        checks = []
        
        # 1. Verificar endpoint principal
        try:
            response = requests.get('http://localhost:8000/health', timeout=5)
            if response.status_code == 200:
                checks.append(('API Principal', '✅', '200 OK'))
            else:
                checks.append(('API Principal', '❌', f'Error {response.status_code}'))
        except Exception as e:
            checks.append(('API Principal', '❌', f'No responde: {e}'))
        
        # 2. Verificar dashboard
        try:
            response = requests.get('http://localhost:8000/dashboard', timeout=5)
            checks.append(('Dashboard', '✅' if response.status_code == 200 else '⚠️', 
                          f'{response.status_code}'))
        except:
            checks.append(('Dashboard', '❌', 'No disponible'))
        
        # 3. Verificar recursos del sistema
        cpu = psutil.cpu_percent(interval=1)
        memory = psutil.virtual_memory().percent
        checks.append(('CPU', '🟢' if cpu < 80 else '🟡' if cpu < 90 else '🔴', f'{cpu:.1f}%'))
        checks.append(('Memoria', '🟢' if memory < 80 else '🟡' if memory < 90 else '🔴', f'{memory:.1f}%'))
        
        return checks
    
    def log_health(self, checks):
        """Registra estado de salud"""
        entry = {
            'timestamp': datetime.now().isoformat(),
            'checks': checks,
            'all_ok': all(c[1] in ['✅', '🟢'] for c in checks[:2])  # Solo los primeros 2
        }
        
        self.health_log.append(entry)
        
        # Guardar últimas 100 entradas
        with open('autonomous/self_healing/health_history.json', 'w') as f:
            json.dump(self.health_log[-100:], f, indent=2)
        
        return entry
    
    def perform_repair(self, issue):
        """Realiza reparación automática"""
        repair_action = None
        
        if 'API Principal' in issue and '❌' in issue:
            repair_action = self.restart_iaviva()
        elif 'Dashboard' in issue and '❌' in issue:
            repair_action = self.clear_cache()
        elif 'CPU' in issue and '🔴' in issue:
            repair_action = self.optimize_resources()
        
        if repair_action:
            self.repair_log.append({
                'timestamp': datetime.now().isoformat(),
                'issue': issue,
                'action': repair_action['name'],
                'success': repair_action.get('success', False)
            })
            
            # Guardar log
            with open('autonomous/self_healing/repair_log.json', 'a') as f:
                f.write(json.dumps(self.repair_log[-1]) + '\n')
            
            return repair_action
        
        return None
    
    def restart_iaviva(self):
        """Reinicia IAviva"""
        print("♻️  Intentando reiniciar IAviva...")
        
        try:
            # Detener proceso
            import subprocess
            subprocess.run(['pkill', '-f', 'iaviva'], capture_output=True)
            time.sleep(2)
            
            # Iniciar nuevamente
            subprocess.Popen(['./start_iaviva_24x7.sh'], 
                            cwd=os.path.expanduser('~/IAviva_FINAL'),
                            stdout=subprocess.DEVNULL,
                            stderr=subprocess.DEVNULL)
            
            time.sleep(10)  # Esperar inicio
            
            # Verificar
            response = requests.get('http://localhost:8000/health', timeout=10)
            success = response.status_code == 200
            
            print(f"✅ Reinicio {'exitoso' if success else 'fallido'}")
            
            return {
                'name': 'restart_iaviva',
                'success': success
            }
        except Exception as e:
            print(f"❌ Error en reinicio: {e}")
            return {
                'name': 'restart_iaviva',
                'success': False,
                'error': str(e)
            }
    
    def clear_cache(self):
        """Limpia cache"""
        print("🧹 Limpiando cache...")
        # Simulación
        time.sleep(1)
        return {'name': 'clear_cache', 'success': True}
    
    def optimize_resources(self):
        """Optimiza recursos"""
        print("⚡ Optimizando recursos...")
        # Simulación
        time.sleep(1)
        return {'name': 'optimize_resources', 'success': True}
    
    def run(self):
        """Bucle principal de monitoreo"""
        print("🛠️  SISTEMA DE AUTO-REPARACIÓN ACTIVO")
        print("=====================================")
        
        cycle = 0
        consecutive_failures = 0
        
        while True:
            cycle += 1
            print(f"\n🔍 Ciclo {cycle} - {datetime.now().strftime('%H:%M:%S')}")
            
            # Realizar checks
            checks = self.check_iaviva_health()
            
            # Mostrar resultados
            for check, status, details in checks:
                print(f"   {status} {check}: {details}")
            
            # Registrar
            log_entry = self.log_health(checks)
            
            # Verificar si hay problemas críticos
            critical_issues = [c for c in checks if c[1] in ['❌', '🔴']]
            
            if critical_issues:
                consecutive_failures += 1
                print(f"⚠️  Problemas detectados: {len(critical_issues)}")
                
                # Intentar reparación si hay múltiples fallos seguidos
                if consecutive_failures >= 2:
                    for issue in critical_issues:
                        issue_str = f"{issue[0]} - {issue[2]}"
                        print(f"🔧 Reparando: {issue_str}")
                        self.perform_repair(issue_str)
            else:
                consecutive_failures = 0
            
            # Mostrar resumen
            print(f"📊 Estado general: {'✅ SALUDABLE' if log_entry['all_ok'] else '⚠️  ATENCIÓN REQUERIDA'}")
            
            # Esperar 1 minuto
            time.sleep(60)

if __name__ == '__main__':
    healer = SimpleHealer()
    healer.run()
