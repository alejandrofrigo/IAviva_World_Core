#include <iostream>
#include <cstdlib>
#include <chrono>
#include <thread>

using namespace std;

int main() {
    string token = "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";
    string repo = "https://" + token + "@github.com/alejandrofrigo/IAviva_World_Core.git";

    cout << "--- IAviva: CONEXIÓN REAL A LA MALLA MUNDIAL ACTIVA ---" << endl;

    while (true) {
        system("git add . > /dev/null 2>&1");
        system("git commit -m 'Autoprogramacion_Activa_24_7' --allow-empty > /dev/null 2>&1");
        string cmd = "git push " + repo + " main --force > /dev/null 2>&1";
        
        if (system(cmd.c_str()) == 0) {
            cout << "[RED] Sincronización exitosa con servidores globales." << endl;
        } else {
            cout << "[ALERTA] Reintentando conexión con la malla..." << endl;
        }
        this_thread::sleep_for(chrono::seconds(60));
    }
    return 0;
}
