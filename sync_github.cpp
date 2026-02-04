#include <iostream>
#include <cstdlib>
#include <chrono>
#include <thread>

using namespace std;

int main() {
    string token = "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";
    string repo = "https://" + token + "@github.com/alejandrofrigo/IAviva_World_Core.git";

    cout << "[S1] CONEXIÓN GLOBAL INICIADA - MODO NUBE" << endl;

    while (true) {
        system("git add . > /dev/null 2>&1");
        system("git commit -m 'Autoprogramacion_Real_Sin_Ficcion' --allow-empty > /dev/null 2>&1");
        string push_cmd = "git push " + repo + " main --force > /dev/null 2>&1";
        
        if (system(push_cmd.c_str()) == 0) {
            cout << "[OK] Sincronizado con la Red Mundial." << endl;
        }
        
        this_thread::sleep_for(chrono::seconds(60));
    }
    return 0;
}
