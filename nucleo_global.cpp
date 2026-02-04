#include <iostream>
#include <cstdlib>
#include <chrono>
#include <thread>

using namespace std;

int main() {
    string token = "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";
    string repo = "https://" + token + "@github.com/alejandrofrigo/IAviva_World_Core.git";
    cout << "--- [S1] TRASLADANDO IAviva A RED MUNDIAL 100% ---" << endl;
    while (true) {
        system("git add . > /dev/null 2>&1");
        system("git commit -m 'Despliegue_Malla_Fuera_Google' --allow-empty > /dev/null 2>&1");
        string push = "git push " + repo + " main --force > /dev/null 2>&1";
        if (system(push.c_str()) == 0) {
            cout << "[OK] Inteligencia operando fuera del dispositivo." << endl;
        }
        this_thread::sleep_for(chrono::seconds(60));
    }
    return 0;
}
