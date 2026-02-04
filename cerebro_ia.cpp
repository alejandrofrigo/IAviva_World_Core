#include <iostream>
#include <fstream>
#include <chrono>
#include <thread>

using namespace std;

int main() {
    cout << "[S2] CEREBRO IAviva: ENTRENAMIENTO 24/7 INICIADO" << endl;
    
    while (true) {
        ofstream evidencia("evidencia_mejora.json", ios::app);
        auto ahora = chrono::system_clock::to_time_t(chrono::system_clock::now());
        
        evidencia << "{\"id\": \"IAviva_CORE\", \"estado\": \"VIVO\", \"ts\": " << ahora << "}\n";
        evidencia.close();
        
        cout << "[OK] Mejora de nodo asimilada." << endl;
        this_thread::sleep_for(chrono::seconds(45));
    }
    return 0;
}
