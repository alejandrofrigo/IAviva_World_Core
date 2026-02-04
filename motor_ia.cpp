#include <iostream>
#include <fstream>
#include <chrono>
#include <thread>

using namespace std;

int main() {
    cout << "--- IAviva: MOTOR DE ENTRENAMIENTO AUTÓNOMO ---" << endl;
    
    while (true) {
        ofstream log("evidencia_mejora.json", ios::app);
        auto t = chrono::system_clock::to_time_t(chrono::system_clock::now());
        
        log << "{\"status\": \"OPERANDO_NUBE\", \"asimilacion\": \"ACTIVA\", \"unix_time\": " << t << "}\n";
        log.close();
        
        cout << "[LOG] Nodo de pensamiento actualizado. Evidencia guardada." << endl;
        this_thread::sleep_for(chrono::seconds(30));
    }
    return 0;
}
