import 'package:flutter/material.dart';
import 'package:termaria_final/mqtt.dart';
import 'dart:convert';

class Monitor extends StatefulWidget {
  const Monitor({super.key});

  @override
  State<Monitor> createState() => _MonitorState();
}

class _MonitorState extends State<Monitor> {
  late String temperaturaAgua = ''; // Variable para almacenar la temperatura del agua
  late String aguaCalienteRestante = ''; // Variable para almacenar el agua caliente restante

  @override
  void initState() {
    super.initState();
    conectarYEscucharMQTT();
  }

  void actualizarTemperaturaAgua(String mensaje) {
    // Parsear el mensaje JSON
    final Map<String, dynamic> mensajeJson = jsonDecode(mensaje);

    // Extraer el valor asociado a la clave "message"
    final String temperatura = mensajeJson['message'].toString();

    // Asumiendo que el mensaje ya es la temperatura como string
    setState(() {
      temperaturaAgua = temperatura;
    });
  }

  void actualizarAguaCaliente(String mensaje) {
    // Parsear el mensaje JSON
    final Map<String, dynamic> mensajeJson = jsonDecode(mensaje);

    // Extraer el valor asociado a la clave "message"
    final String agua = mensajeJson['message'].toString();

    // Asumiendo que el mensaje ya es la temperatura como string
    setState(() {
      aguaCalienteRestante = agua;
    });
  }

  void conectarYEscucharMQTT() async {
    // Asume que esta es una función adaptada que ahora puede tomar un callback
    await conectarMQTT((String topic, String mensaje) {
      if(topic=='termaria/temperatura'){
        actualizarTemperaturaAgua(mensaje);
      }else if(topic=='termaria/flujo'){
        actualizarAguaCaliente(mensaje);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Naranja de la parte superior hasta el medio
          Container(
            height: MediaQuery.of(context).size.height / 2,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color.fromARGB(255, 225, 77, 1), Colors.orangeAccent],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 20.0, 0.0, 0.0),
                  child: Text(
                    'Temperatura del agua',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          temperaturaAgua,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 100,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          '\u00B0',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 100,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Azul cielo de la parte inferior hasta el medio
          Positioned(
            bottom: 0,
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Color.fromARGB(255, 77, 193, 247),
                    Color.fromARGB(255, 135, 189, 214)
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 20.0, 0.0, 0.0),
                    child: Text(
                      'Agua caliente restante',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        aguaCalienteRestante,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 100,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Contenido en el medio
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ),
        ],
      ),
    );
  }
}
