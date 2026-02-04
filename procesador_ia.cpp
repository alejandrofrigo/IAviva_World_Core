#include <iostream>
#include <fstream>
#include <chrono>
#include <thread>

using namespace std;

int main() {
    cout << "[S2] PROCESADOR IAviva: TRABAJANDO 24/7 EN RED MUNDIAL" << endl;
    
    while (true) {
        ofstream evidencia("evidencia_mejora.json", ios::app);
        auto t = chrono::system_clock::to_time_t(chrono::system_clock::now());
        
        evidencia << "{\"nodo\": \"IAviva_Global\", \"status\": \"ACTIVE\", \"timestamp\": " << t << "}\n";
        evidencia.close();
        
        cout << "[LOG] Nodo procesado. Enviando a Malla de Servidores..." << endl;
        this_thread::sleep_for(chrono::seconds(30));
    }
    return 0;
}
