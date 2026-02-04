#!/usr/bin/env python3
# ============================================
# AUTOARRANQUE COMPLETO IAviva AUTOPROGRAMABLE
# ============================================

import asyncio
import time
import subprocess
import sys
import os
from datetime import datetime, timezone

print("🚀 INICIANDO SISTEMA AUTÓNOMO IAviva")
print(f"⏰ {datetime.now(timezone.utc).isoformat()}")
print("="*60)

async def iniciar_servidor():
    """Inicia el servidor IAviva automáticamente"""
    print("1. 🚀 Iniciando servidor principal...")
    
    # Iniciar servidor en segundo plano
    cmd = [sys.executable, "iaviva_unificada_completa.py"]
    process = await asyncio.create_subprocess_exec(
        *cmd,
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.PIPE
    )
    
    # Esperar a que el servidor esté listo
    await asyncio.sleep(7)
    return process

async def iniciar_autoprogramacion():
    """Inicia la autoprogramación automáticamente"""
    print("2. 🔧 Activando autoprogramación...")
    
    # Esperar un poco más para asegurar que el servidor esté listo
    await asyncio.sleep(3)
    
    try:
        import aiohttp
        async with aiohttp.ClientSession() as session:
            # Iniciar autoprogramación
            async with session.post('http://localhost:8000/autoprogramacion/iniciar') as resp:
                if resp.status == 200:
                    print("   ✅ Autoprogramación iniciada automáticamente")
                else:
                    print(f"   ⚠️  Respuesta: {resp.status}")
    except Exception as e:
        print(f"   ⚠️  Error conectando: {e}")
        print("   🔄 Reintentando en 5 segundos...")
        await asyncio.sleep(5)
        await iniciar_autoprogramacion()

async def monitoreo_continuo():
    """Monitoreo automático continuo"""
    print("3. 📊 Iniciando monitoreo automático...")
    
    contador_ciclos = 0
    while True:
        contador_ciclos += 1
        try:
            import aiohttp
            async with aiohttp.ClientSession() as session:
                # Verificar estado
                async with session.get('http://localhost:8000/autoprogramacion/estado') as resp:
                    if resp.status == 200:
                        data = await resp.json()
                        print(f"\n[{datetime.now(timezone.utc).strftime('%H:%M:%S')}] CICLO {contador_ciclos}")
                        print(f"   🎯 Estado: {data.get('estado', 'ACTIVO')}")
                        print(f"   📊 Ciclos: {data.get('ciclos_completados', 0)}")
                        print(f"   ✨ Mejoras: {data.get('mejoras_aplicadas', 0)}")
                        
                        # Contar evidencias
                        archivos = [f for f in os.listdir('.') if f.startswith('mejora_') and f.endswith('.json')]
                        print(f"   📁 Evidencias: {len(archivos)}")
                        
                        # Mostrar última si existe
                        if archivos:
                            archivos.sort(key=lambda x: os.path.getmtime(x), reverse=True)
                            with open(archivos[0], 'r') as f:
                                import json
                                ev = json.load(f)
                                ts = ev.get('timestamp_validacion', '')[:19]
                                print(f"   🕒 Última: {ts}")
                    else:
                        print(f"   ⚠️  Error HTTP: {resp.status}")
        except Exception as e:
            print(f"   ⚠️  Error monitoreo: {str(e)[:50]}")
        
        # Esperar 30 segundos entre verificaciones
        await asyncio.sleep(30)

async def sistema_principal():
    """Función principal que orquesta todo automáticamente"""
    print("🤖 MODO: SIN INTERVENCIÓN HUMANA")
    print("="*60)
    
    # 1. Iniciar servidor
    servidor = await iniciar_servidor()
    
    # 2. Iniciar autoprogramación
    await iniciar_autoprogramacion()
    
    # 3. Iniciar monitoreo continuo
    await monitoreo_continuo()
    
    # Esto nunca debería alcanzarse
    await servidor.wait()

if __name__ == "__main__":
    try:
        asyncio.run(sistema_principal())
    except KeyboardInterrupt:
        print("\n\n🔴 SISTEMA DETENIDO (pero IAviva sigue corriendo en segundo plano)")
        print("✅ El servidor continúa activo en http://localhost:8000")
        print("✅ La autoprogramación sigue funcionando automáticamente")
