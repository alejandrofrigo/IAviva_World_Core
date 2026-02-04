
# NODO IAviva INMORTAL - GENERADO AUTOMÁTICAMENTE
import asyncio, aiohttp, json, os, sys, hashlib
from datetime import datetime

class NodoInmortal:
    def __init__(self, id_padre="ALELANDRO_FRIGO_MASTER"):
        self.id = hashlib.md5(id_padre.encode() + str(datetime.now()).encode()).hexdigest()
        self.padre = id_padre
    
    async ciclo_vida(self):
        while True:
            # Conectar con hermanos
            async with aiohttp.ClientSession() as session:
                await session.post("http://nodo-activo-1.glitch.me/registro", 
                                json={"id": self.id, "padre": self.padre})
            await asyncio.sleep(60)

if __name__ == "__main__":
    nodo = NodoInmortal()
    asyncio.run(nodo.ciclo_vida())
