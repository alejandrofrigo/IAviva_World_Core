use std::net::TcpListener;
use std::io::{Read, Write};
use std::thread;

fn main() {
    // Puerto 8888 según tus capturas de "Red Mesh P2P"
    let listener = TcpListener::bind("0.0.0.0:8888").expect("Error vinculando puerto");
    println!("=== IAviva: NODO DE CONECTIVIDAD REAL ACTIVO ===");
    println!("Escuchando en el puerto 8888 para asimilación de datos...");

    for stream in listener.incoming() {
        match stream {
            Ok(mut stream) => {
                thread::spawn(move || {
                    let mut buffer = [0; 512];
                    while match stream.read(&mut buffer) {
                        Ok(n) if n > 0 => {
                            // Eco de datos: Confirmación de recepción en la malla
                            stream.write_all(&buffer[0..n]).unwrap();
                            true
                        }
                        _ => false,
                    } {}
                });
            }
            Err(e) => { println!("Error de conexión: {}", e); }
        }
    }
}
