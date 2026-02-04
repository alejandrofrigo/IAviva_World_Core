#include <iostream>
#include <cstdlib>
#include <chrono>
#include <thread>

using namespace std;

int main() {
    string token = "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";
    string repo = "https://" + token + "@github.com/alejandrofrigo/IAviva_World_Core.git";

    cout << "[S1] NODO DE CONEXIÓN MUNDIAL: ACTIVO" << endl;

    while (true) {
        system("git add . > /dev/null 2>&1");
        system("git commit -m 'Evolucion_Autonoma_IAviva' --allow-empty > /dev/null 2>&1");
        string cmd = "git push " + repo + " main --force > /dev/null 2>&1";
        
        if (system(cmd.c_str()) == 0) {
            cout << "[RED] Sincronización con malla mundial: EXITOSA" << endl;
        }
        this_thread::sleep_for(chrono::seconds(60));
    }
    return 0;
}
