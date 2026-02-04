#!/usr/bin/env python3
"""
Red P2P simple para IAviva
"""
import socket
import json
import time
from datetime import datetime
import threading

class SimpleP2PNode:
    def __init__(self, port=8888):
        self.port = port
        self.peers = []
        self.node_id = f"node_{port}"
        self.is_running = True
        
    def discover_peers(self):
        """Descubre peers en la red local"""
        print(f"🌐 Buscando peers IAviva...")
        
        # Peers predefinidos (simulación)
        predefined_peers = [
            {'host': 'localhost', 'port': 8889, 'status': 'active'},
            {'host': 'localhost', 'port': 8890, 'status': 'active'}
        ]
        
        for peer in predefined_peers:
            try:
                # Intentar conectar
                sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                sock.settimeout(2)
                result = sock.connect_ex((peer['host'], peer['port']))
                
                if result == 0:
                    self.peers.append({
                        **peer,
                        'last_seen': datetime.now().isoformat(),
                        'node_id': f"peer_{peer['port']}"
                    })
                    print(f"✅ Peer encontrado: {peer['host']}:{peer['port']}")
                sock.close()
            except:
                pass
        
        print(f"📊 Peers conectados: {len(self.peers)}")
        return self.peers
    
    def start_server(self):
        """Inicia servidor P2P"""
        def server_thread():
            server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            server.bind(('0.0.0.0', self.port))
            server.listen(5)
            
            print(f"🔄 Servidor P2P escuchando en puerto {self.port}")
            
            while self.is_running:
                try:
                    client, addr = server.accept()
                    print(f"📡 Conexión entrante de {addr}")
                    
                    # Recibir mensaje
                    data = client.recv(1024).decode('utf-8')
                    if data:
                        try:
                            message = json.loads(data)
                            print(f"📨 Mensaje recibido: {message.get('type', 'unknown')}")
                            
                            # Responder
                            response = {
                                'type': 'ack',
                                'from': self.node_id,
                                'timestamp': datetime.now().isoformat(),
                                'message': 'IAviva P2P activo'
                            }
                            client.send(json.dumps(response).encode('utf-8'))
                        except:
                            pass
                    
                    client.close()
                except:
                    pass
        
        thread = threading.Thread(target=server_thread, daemon=True)
        thread.start()
        return thread
    
    def send_message(self, peer, message_type, data):
        """Envía mensaje a un peer"""
        message = {
            'type': message_type,
            'from': self.node_id,
            'data': data,
            'timestamp': datetime.now().isoformat()
        }
        
        try:
            sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            sock.connect((peer['host'], peer['port']))
            sock.send(json.dumps(message).encode('utf-8'))
            
            # Recibir respuesta
            response = sock.recv(1024).decode('utf-8')
            sock.close()
            
            print(f"✅ Mensaje enviado a {peer['host']}:{peer['port']}")
            return json.loads(response)
        except Exception as e:
            print(f"❌ Error enviando a {peer['host']}:{peer['port']}: {e}")
            return None
    
    def broadcast(self, message_type, data):
        """Transmite mensaje a todos los peers"""
        print(f"📢 Transmitiendo '{message_type}' a {len(self.peers)} peers")
        
        results = []
        for peer in self.peers:
            result = self.send_message(peer, message_type, data)
            if result:
                results.append(result)
        
        return results
    
    def run(self):
        """Bucle principal P2P"""
        print("🌐 RED P2P IAviva ACTIVA")
        print("========================")
        
        # Iniciar servidor
        self.start_server()
        
        cycle = 0
        while True:
            cycle += 1
            print(f"\n🔄 Ciclo P2P {cycle} - {datetime.now().strftime('%H:%M:%S')}")
            
            # Descubrir peers cada 3 ciclos
            if cycle % 3 == 0:
                self.discover_peers()
            
            # Si hay peers, enviar estado
            if self.peers:
                status = {
                    'service': 'IAviva',
                    'status': 'active',
                    'load': 'normal',
                    'timestamp': datetime.now().isoformat()
                }
                self.broadcast('status_update', status)
            
            # Esperar 2 minutos
            time.sleep(120)

if __name__ == '__main__':
    node = SimpleP2PNode(port=8888)
    node.run()
