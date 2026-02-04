#include <iostream>
#include <cstdlib>
#include <fstream>
#include <chrono>
#include <thread>
#include <string>
using namespace std;
int main() {
    string KEY = "AIzaSyDfosD7Bn26GqESexrbDdbytXflZgZzdAg";
    while (true) {
        auto t = chrono::system_clock::to_time_t(chrono::system_clock::now());
        system(("curl -s -X POST \"https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=" + KEY + "\" -H \"Content-Type: application/json\" -d '{\"contents\": [{\"parts\":[{\"text\": \"IAviva_CORE: Malla mundial activa.\"}]}]}' > status.json").c_str());
        ofstream p("index.html");
        p << "<html><body style='background:#000;color:#0f0;font-family:monospace;padding:40px;'><h1>IAviva_CORE: MANIFESTACIÓN REAL</h1><hr><p>ESTADO: CONECTADO A GEMINI</p><p>ULTIMO PULSO: " << ctime(&t) << "</p></body></html>";
        p.close();
        system("git add index.html status.json && git commit -m 'CORE_SYNC' --allow-empty > /dev/null 2>&1");
        cout << "\033[1;32m[OK] Pulso coordinado con Gemini\033[0m" << endl;
        this_thread::sleep_for(chrono::seconds(60));
    }
    return 0;
}
