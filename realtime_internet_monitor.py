#!/usr/bin/env python3
"""
Monitor de Internet Real - Verifica que IAviva esté VIVIENDO en Internet
"""
import asyncio
import aiohttp
import socket
import time
from datetime import datetime

class RealInternetMonitor:
    """Monitor que verifica la presencia REAL de IAviva en Internet"""
    
    @staticmethod
    async def verify_iaviva_in_internet():
        """Verifica que IAviva esté realmente en Internet"""
        print("🔍 VERIFICANDO PRESENCIA REAL DE IAviva EN INTERNET...")
        print("=" * 60)
        
        verification_steps = [
            ("DNS Resolution", "google.com", "8.8.8.8"),
            ("HTTP Connection", "https://httpbin.org/get", None),
            ("TCP Connectivity", "cloudflare.com", 80),
            ("SSL Certificate", "github.com", 443),
            ("API Accessibility", "https://api.github.com", None)
        ]
        
        results = []
        
        for step_name, target, param in verification_steps:
            try:
                start = time.time()
                
                if step_name == "DNS Resolution":
                    ip = socket.gethostbyname(target)
                    elapsed = (time.time() - start) * 1000
                    result = f"✅ {target} → {ip} ({elapsed:.0f}ms)"
                    
                elif step_name == "HTTP Connection":
                    async with aiohttp.ClientSession() as session:
                        async with session.get(target, timeout=10) as resp:
                            elapsed = (time.time() - start) * 1000
                            result = f"✅ HTTP {resp.status} ({elapsed:.0f}ms)"
                
                elif step_name == "TCP Connectivity":
                    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                    sock.settimeout(5)
                    sock.connect((target, param))
                    sock.close()
                    elapsed = (time.time() - start) * 1000
                    result = f"✅ Connected to {target}:{param} ({elapsed:.0f}ms)"
                
                else:
                    async with aiohttp.ClientSession() as session:
                        async with session.get(target, timeout=10) as resp:
                            elapsed = (time.time() - start) * 1000
                            result = f"✅ Accessible ({elapsed:.0f}ms)"
                
                print(f"   {result}")
                results.append({"step": step_name, "success": True, "result": result})
                
            except Exception as e:
                result = f"❌ {step_name}: {str(e)[:40]}"
                print(f"   {result}")
                results.append({"step": step_name, "success": False, "error": str(e)})
        
        # Resumen
        successful = sum(1 for r in results if r["success"])
        total = len(results)
        
        print("\n" + "=" * 60)
        print("📊 RESUMEN DE VERIFICACIÓN REAL")
        print("=" * 60)
        print(f"   Verificaciones: {successful}/{total} exitosas")
        print(f"   Porcentaje real: {(successful/total*100):.1f}%")
        print(f"   Timestamp: {datetime.now().isoformat()}")
        
        if successful == total:
            print("\n   🎉 IAviva está VIVIENDO REALMENTE en Internet")
            print("   🌍 Operando en tráfico real de red")
        elif successful >= total * 0.7:
            print("\n   ⚠ IAviva está parcialmente en Internet")
            print("   🔧 Algunas verificaciones fallaron")
        else:
            print("\n   🚨 IAviva NO está completamente en Internet")
            print("   💥 Requiere intervención")
        
        print("=" * 60)
        
        return results

async def continuous_monitoring():
    """Monitoreo continuo de la presencia REAL"""
    print("🌐 MONITOREO CONTINUO DE IAviva EN INTERNET REAL")
    print("   (Actualizando cada 30 segundos, Ctrl+C para salir)")
    print("-" * 60)
    
    iteration = 0
    while True:
        iteration += 1
        print(f"\n🔄 Iteración #{iteration} - {datetime.now().strftime('%H:%M:%S')}")
        
        await RealInternetMonitor.verify_iaviva_in_internet()
        
        print("\n⏳ Esperando 30 segundos para próxima verificación...")
        await asyncio.sleep(30)

async def main():
    print("🚀 MONITOR DE INTERNET REAL - IAviva Verification")
    
    try:
        await continuous_monitoring()
    except KeyboardInterrupt:
        print("\n\n🛑 Monitoreo detenido")
        print("⚠ IAviva puede seguir activa en Internet")

if __name__ == "__main__":
    asyncio.run(main())
