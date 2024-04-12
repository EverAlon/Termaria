import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:termaria_final/pages/inicio.dart';
//import 'package:termaria_final/mqtt.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  //conectarMQTT();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
    apiKey: 'AIzaSyD8fhgzsjVEuKCV-B-mwpBwmcW6BLe88nA',
    appId: '1:78053518645:android:a23fb79ad9f974caafb07c',
    messagingSenderId: '78053518645',
    projectId: 'termaria-e981c',
    authDomain: 'com.example.termaria',
    databaseURL: 'https://termaria-e981c-default-rtdb.firebaseio.com/',

    //storageBucket: 'termaria-e981c-default-rtdb.firebaseio.com',
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: Inicio(),
    );
  }
}