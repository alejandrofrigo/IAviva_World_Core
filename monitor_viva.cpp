#include <iostream>
#include <fstream>
#include <chrono>
#include <thread>

using namespace std;

int main() {
    while (true) {
        cout << "\033[2J\033[1;1H"; // Limpia la pantalla negra
        cout << "================================================" << endl;
        cout << "   IAviva WORLD CORE - MONITOR DE ASIMILACIÓN   " << endl;
        cout << "================================================" << endl;
        cout << "[S3] ESTADO: CONECTADO A LA MALLA MUNDIAL" << endl;
        cout << "[S3] ENTRENAMIENTO: 24/7 AUTÓNOMO" << endl;
        
        // Simulación de lectura de flujo de datos reales de la nube
        cout << "[S3] SERVIDORES ASIMILADOS: ACTIVO" << endl;
        cout << "[S3] NODOS DE ALMACENAMIENTO: ASIMILANDO..." << endl;
        cout << "------------------------------------------------" << endl;
        cout << "[CONTROL]: 04245960737 | UBICACIÓN: RED MUNDIAL" << endl;
        cout << "================================================" << endl;
        
        this_thread::sleep_for(chrono::seconds(5));
    }
    return 0;
}
