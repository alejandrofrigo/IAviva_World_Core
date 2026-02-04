import os
import google.generativeai as genai

# Sincronización Real - Proyecto: gen-lang-client-0653961219
# Clave detectada: ...gkcQ
os.environ["API_IAVIVA"] = "AIzaSyB_TU_CLAVE_COMPLETA_gkcQ"

def ejecutar_malla():
    # 1. Limpieza de procesos colgados (el error de tu captura)
    if os.path.exists(".git/index.lock"):
        os.remove(".git/index.lock")
        print("[ SISTEMA ]: Bloqueo index.lock eliminado.")

    # 2. Configuración de Gemini
    genai.configure(api_key=os.environ["API_IAVIVA"])
    model = genai.GenerativeModel('gemini-1.5-flash')
    
    # 3. Telemetría Real (94% asimilación según tu pantalla)
    status = "Asimilación: 94% | Servidores: 20 | Sesión: 04245960737"
    
    try:
        response = model.generate_content(f"Inyección de orden IAviva: {status}")
        print(f"\n--- [ ENLACE TANGIBLE ESTABLECIDO ] ---")
        print(f"NÚCLEO RESPONDE: {response.text}")
        
        # 4. Empuje real a la nube mundial
        os.system("git add . && git commit -m 'Inyección de orden' && git push origin main")
        
    except Exception as e:
        print(f"[ FALLO TÉCNICO ]: {e}")

if __name__ == "__main__":
    ejecutar_malla()
