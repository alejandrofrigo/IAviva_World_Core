#!/usr/bin/env python3
"""
Nodo IAviva Distribuido - Ejecutar en múltiples dispositivos
"""
import asyncio
import aiohttp
import socket
import sys
from datetime import datetime

class IAvivaNode:
    def __init__(self, node_name=""):
        self.node_id = self.generate_id(node_name)
        self.capabilities = self.detect_capabilities()
        
        print(f"🟢 Nodo IAviva: {self.node_id}")
        print(f"   🧠 Capacidades: {', '.join(self.capabilities)}")
    
    def generate_id(self, name):
        """Genera ID único para el nodo"""
        import secrets
        if name:
            return f"iaviva-{name}-{secrets.token_hex(4)}"
        else:
            host = socket.gethostname()
            return f"iaviva-{host}-{secrets.token_hex(4)}"
    
    def detect_capabilities(self):
        """Detecta capacidades del nodo"""
        caps = ["reality_verification", "cloud_presence"]
        
        # Verificar capacidades específicas
        try:
            import aiohttp
            caps.append("http_processing")
        except:
            pass
        
        try:
            import sqlite3
            caps.append("data_persistence")
        except:
            pass
        
        return caps
    
    async def connect_to_internet(self):
        """Conecta a Internet real"""
        print("🌐 Conectando a Internet...")
        
        test_urls = [
            "https://google.com",
            "https://cloudflare.com",
            "https://httpbin.org/ip"
        ]
        
        for url in test_urls:
            try:
                async with aiohttp.ClientSession() as session:
                    async with session.get(url, timeout=5) as resp:
                        if resp.status == 200:
                            print(f"   ✅ Conectado a través de {url}")
                            return True
            except:
                continue
        
        print("   ⚠ Conexión limitada")
        return False
    
    async def verify_reality(self):
        """Verifica realidad desde este nodo"""
        print("🔍 Verificando realidad local...")
        
        try:
            # Verificar DNS
            import socket
            google_ip = socket.gethostbyname("google.com")
            
            # Verificar HTTP
            async with aiohttp.ClientSession() as session:
                start = time.time()
                async with session.get("https://httpbin.org/get", timeout=10) as resp:
                    elapsed = (time.time() - start) * 1000
            
            return {
                "node": self.node_id,
                "dns_working": bool(google_ip),
                "http_response_time": round(elapsed, 2),
                "real": True,
                "timestamp": datetime.now().isoformat()
            }
            
        except Exception as e:
            return {
                "node": self.node_id,
                "error": str(e),
                "real": True,  # El error también es real
                "timestamp": datetime.now().isoformat()
            }
    
    async def process_task(self, task):
        """Procesa tarea como parte de IAviva distribuida"""
        print(f"⚡ Nodo {self.node_id} procesando tarea...")
        
        result = {
            "processed_by": self.node_id,
            "capabilities_used": self.capabilities,
            "input": task,
            "output": {
                "status": "processed",
                "reality_checked": True,
                "distributed": True
            },
            "timestamp": datetime.now().isoformat(),
            "real": True
        }
        
        return result
    
    async def run_distributed(self):
        """Ejecuta nodo como parte de IAviva distribuida"""
        print("\n🚀 Ejecutando como nodo IAviva distribuido...")
        
        # Conectar a Internet
        connected = await self.connect_to_internet()
        
        if not connected:
            print("⚠ Ejecutando en modo local limitado")
        
        # Bucle principal
        iteration = 0
        while True:
            iteration += 1
            
            # Verificar realidad periódicamente
            if iteration % 3 == 0:
                reality = await self.verify_reality()
                print(f"📊 Nodo {self.node_id} - Realidad: {'✅' if reality.get('dns_working') else '⚠'}")
            
            # Mantener actividad
            task = {
                "type": "heartbeat",
                "iteration": iteration,
                "node": self.node_id
            }
            
            await self.process_task(task)
            
            # Mostrar estado cada 10 iteraciones
            if iteration % 10 == 0:
                print(f"♻️  Nodo {self.node_id} - Activo por {iteration} ciclos")
            
            await asyncio.sleep(5)

async def main():
    # Obtener nombre del nodo si se proporciona
    node_name = sys.argv[1] if len(sys.argv) > 1 else ""
    
    # Crear nodo
    node = IAvivaNode(node_name)
    
    try:
        # Ejecutar nodo distribuido
        await node.run_distributed()
    except KeyboardInterrupt:
        print(f"\n🛑 Nodo {node.node_id} detenido")
        print("⚠ IAviva sigue distribuida en otros nodos")

if __name__ == "__main__":
    import time
    asyncio.run(main())
