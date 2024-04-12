import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:termaria_final/pages/monitor.dart';

final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

Future<void> signInWithEmailAndPassword(
    String email, String password, BuildContext context) async {
  try {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (credential.user != null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const Monitor()));
    }
  } on FirebaseAuthException catch (e) {
    String errorMessage;
    if (e.code == 'user-not-found') {
      errorMessage = 'Usuario no encontrado';
    } else if (e.code == 'wrong-password') {
      errorMessage = 'Contraseña incorrecta';
    } else {
      errorMessage = 'Error desconocido al iniciar sesión';
    }
    // Mostrar un diálogo o Snackbar con el mensaje de error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        duration: Duration(seconds: 3), // Opcional: ajusta la duración
      ),
    );
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromARGB(255, 225, 77, 1), Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.25, 1.0],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'TERMARIA',
                      style: TextStyle(
                        fontSize: 50,
                        fontFamily: "Prosto One",
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Formulario(),
                  ],
                ),
              ),
            ),
          ),
          const Botones(),
        ],
      ),
    );
  }
}

class Botones extends StatelessWidget {
  const Botones({super.key});
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 20),
          Center(
            child: SizedBox(
            width: 90,
            height: 90,
            child: IconButton(
              onPressed: () {
                // Acción para iniciar sesión con Google
              },
              icon: Image.asset('assets/google.png'),
              iconSize: 40,
            ),
          ),
          )
        ],
      ),
    );
  }
}

class Formulario extends StatelessWidget {
  const Formulario({super.key});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Correo',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
            onPressed: () {
              signInWithEmailAndPassword(
                _emailController.text, _passwordController.text, context);
            },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(255, 225, 77, 1),
                ),
              ),
              child: const Text(
                'Login',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                // Acción para recuperar contraseña
              },
              child: const Text(
                '¿Olvidó su contraseña?',
                style: TextStyle(color: Colors.orange, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

