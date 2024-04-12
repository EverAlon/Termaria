import 'dart:io';
import 'package:flutter/services.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

Future<void> conectarMQTT(Function(String, String) onMessageReceived) async {
  final MqttServerClient client =
      MqttServerClient('a2btsw6c3gfljz-ats.iot.us-east-2.amazonaws.com', '');

  ByteData rootCA = await rootBundle.load('assets/cert/AmazonRootCA1.pem');
  ByteData deviceCert = await rootBundle.load(
      'assets/cert/3815de970410adf6e75a386d883cd15f4dfe1b14b9d03cc5009e2fcb007fd6db-certificate.pem.crt');
  ByteData privateKey = await rootBundle.load(
      'assets/cert/3815de970410adf6e75a386d883cd15f4dfe1b14b9d03cc5009e2fcb007fd6db-private.pem.key');

  // Configuración de TLS
  SecurityContext context = SecurityContext.defaultContext;
  context.setClientAuthoritiesBytes(rootCA.buffer.asUint8List());
  context.useCertificateChainBytes(deviceCert.buffer.asUint8List());
  context.usePrivateKeyBytes(privateKey.buffer.asUint8List());

  client.securityContext = context;
  client.logging(on: true);
  //client.keepAlivePeriod = 20;
  client.port = 8883;
  client.secure = true;
  client.onConnected = onConnected;
  client.onDisconnected = onDisconencted;
  client.pongCallback = pong;

  await client.connect();

  if (client.connectionStatus!.state == MqttConnectionState.connected) {
    print("Connected AWS Successfully");

    // Agrega el listener para los mensajes entrantes
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
      final String topic = c[0].topic;
      final payload =
          MqttPublishPayload.bytesToStringAsString(message.payload.message);

      // Aquí es donde se llama a tu función callback con el mensaje recibido
      onMessageReceived(topic, payload);
    });

    client.subscribe('termaria/temperatura', MqttQos.atMostOnce);
    client.subscribe('termaria/flujo', MqttQos.atMostOnce);

    final builder = MqttClientPayloadBuilder(); // Constructor del builder
    builder.addString('Hola a todo termaria'); // Agregar el mensaje al builder
    client.publishMessage('termaria/temperatura', MqttQos.atMostOnce,builder.payload!); // Utilizar el payload del builder
    client.publishMessage('termaria/flujo', MqttQos.atMostOnce,builder.payload!);
    //return client; // Devuelve el cliente si la conexión tiene éxito
  } else {
    print("No se pudo conectar");
  }
}

void onConnected() {
  print('Se conecto con exito');
}

void onDisconencted() {
  print('Se desconecto');
}

void pong() {
  print('No se pero funciona');
}
