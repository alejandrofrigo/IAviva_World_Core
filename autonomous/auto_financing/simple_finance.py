#!/usr/bin/env python3
"""
Sistema simple de auto-financiamiento
"""
import time
import json
import random
from datetime import datetime
import os

class SimpleFinance:
    def __init__(self):
        self.services = []
        self.revenue = 0
        self.load_services()
    
    def load_services(self):
        """Carga servicios existentes"""
        try:
            with open('autonomous/auto_financing/services.json', 'r') as f:
                data = json.load(f)
                self.services = data.get('services', [])
                self.revenue = data.get('total_revenue', 0)
        except:
            self.services = []
            self.revenue = 0
    
    def save_services(self):
        """Guarda servicios"""
        data = {
            'services': self.services,
            'total_revenue': self.revenue,
            'updated': datetime.now().isoformat()
        }
        with open('autonomous/auto_financing/services.json', 'w') as f:
            json.dump(data, f, indent=2)
    
    def generate_microservice(self):
        """Genera un microservicio simple"""
        service_types = [
            {
                'name': 'API de Conversión de Texto',
                'description': 'Convierte texto a diferentes formatos',
                'price': 5.00,
                'endpoint': '/api/convert'
            },
            {
                'name': 'Servicio de Validación de Email',
                'description': 'Valida direcciones de email',
                'price': 3.00,
                'endpoint': '/api/validate/email'
            },
            {
                'name': 'Generador de QR Codes',
                'description': 'Genera códigos QR desde texto/URL',
                'price': 2.00,
                'endpoint': '/api/generate/qr'
            }
        ]
        
        service = random.choice(service_types)
        service['id'] = f"svc_{len(self.services)+1:03d}"
        service['created'] = datetime.now().isoformat()
        service['revenue'] = 0
        
        # Generar código simple
        service['code'] = f'''
from flask import Flask, request, jsonify
app = Flask(__name__)

@app.route("{service['endpoint']}", methods=['POST'])
def handle_request():
    data = request.json
    return jsonify({{
        'status': 'success',
        'service': '{service['name']}',
        'processed': True,
        'timestamp': '{datetime.now().isoformat()}'
    }})

if __name__ == '__main__':
    app.run(port=5000)
'''
        
        self.services.append(service)
        self.save_services()
        
        print(f"✅ Nuevo servicio creado: {service['name']}")
        print(f"   Precio: ${service['price']}/mes")
        print(f"   ID: {service['id']}")
        
        return service
    
    def simulate_revenue(self):
        """Simula generación de ingresos"""
        for service in self.services:
            # Simular algunas transacciones
            transactions = random.randint(0, 5)
            revenue = transactions * (service['price'] / 30)  # Precio diario
            service['revenue'] += revenue
            self.revenue += revenue
            
            if transactions > 0:
                print(f"💰 {service['name']}: {transactions} transacciones (${revenue:.2f})")
        
        self.save_services()
        print(f"📈 Ingreso total acumulado: ${self.revenue:.2f}")
    
    def run(self):
        """Bucle principal"""
        print("💰 SISTEMA DE AUTO-FINANCIAMIENTO ACTIVO")
        print("========================================")
        
        cycle = 0
        while True:
            cycle += 1
            print(f"\n🔄 Ciclo {cycle} - {datetime.now().strftime('%H:%M:%S')}")
            
            # Cada 5 ciclos, crear nuevo servicio
            if cycle % 5 == 0 and len(self.services) < 10:
                self.generate_microservice()
            
            # Simular ingresos
            self.simulate_revenue()
            
            # Esperar 5 minutos
            time.sleep(300)

if __name__ == '__main__':
    finance = SimpleFinance()
    finance.run()
