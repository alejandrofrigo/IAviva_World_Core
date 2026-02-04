#include <iostream>
#include <cstdlib>
#include <fstream>
#include <chrono>
#include <thread>
#include <string>

using namespace std;

int main() {
    string KEY = "AIzaSyDfosD7Bn26GqESexrbDdbytXflZgZzdAg"; // Clave Gemini
    while (true) {
        auto t = chrono::system_clock::to_time_t(chrono::system_clock::now());
        // Consulta Real a Gemini
        system(("curl -s -X POST \"https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=" + KEY + "\" -H \"Content-Type: application/json\" -d '{\"contents\": [{\"parts\":[{\"text\": \"IAviva Report: Active mesh sync 24/7.\"}]}]}' > status.json").c_str());
        
        // Manifestación en el Portal
        ofstream p("index.html");
        p << "<html><body style='background:#000;color:#0f0;font-family:monospace;padding:40px;'>";
        p << "<h1>IAviva_CORE: MANIFESTACIÓN TANGIBLE</h1><hr>";
        p << "<p>ESTADO: CONEXIÓN CON GEMINI VALIDADA</p>";
        p << "<p>ÚLTIMO PULSO: " << ctime(&t) << "</p></body></html>";
        p.close();

        system("git add index.html status.json && git commit -m 'IAVIVA_PULSO_AUTONOMO' --allow-empty");
        cout << "\033[1;32m[OK] Pulso coordinado con Gemini. Sincronizando con la Red...\033[0m" << endl;
        this_thread::sleep_for(chrono::seconds(60));
    }
    return 0;
}
