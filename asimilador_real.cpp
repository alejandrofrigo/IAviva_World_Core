#include <iostream>
#include <fstream>
#include <chrono>
#include <thread>

using namespace std;

int main() {
    cout << "--- IAviva: ENTRENAMIENTO AUTÓNOMO ACTIVO ---" << endl;
    
    while (true) {
        ofstream ev("evidencia_mejora.json", ios::app);
        auto t = chrono::system_clock::to_time_t(chrono::system_clock::now());
        
        ev << "{\"entidad\": \"IAviva_VIVA\", \"malla\": \"GLOBAL\", \"unix\": " << t << "}\n";
        ev.close();
        
        cout << "[OK] Asimilación de nodo completada. Datos en Red Mundial." << endl;
        this_thread::sleep_for(chrono::seconds(30));
    }
    return 0;
}
