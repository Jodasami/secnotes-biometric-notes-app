import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'home_screen.dart';

/*
 TODO -- En este caso de la pantalla de login, es necesario utilizar el Stateful Widget
 TODO -- Para poder manipular datos
*/
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LocalAuthentication auth = LocalAuthentication();


  Future<void> _login() async {
    bool authenticated = false;

    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Autentícate para continuar',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      debugPrint('Error de autenticación: $e');
    }

    if (authenticated && context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }



  // TODO -------------------------- PANTALLA LOGIN --------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold( // TODO -- Scaffold es como para cargar los widgets

      // TODO -- Para la barra de arriba
      appBar: AppBar
        (
        title: const Text(
            'SecNotes',
            style: TextStyle(
                color: Colors.white
            )
        ),

        backgroundColor: Colors.blue,

      ),


      // TODO -- Para el "cuerpo" de la app
      body:
      Center( // TODO -- centrado

        child:

        Column(
          // TODO -- acomodado por columnas para mostrarlos verticalmente
          mainAxisAlignment: MainAxisAlignment.center,
          children: [ // TODO -- Esto es para mostrarlos como una lista

            // TODO -- Iconos y elementos
            const Icon(Icons.lock_person, size: 200),
            const Text('Selecciona un método de autenticación'),
            const SizedBox(height: 20),

            // TODO -- Esto es un boton que realiza la acción del void _loginWithFingerprint
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Column(
                  children: [

                    IconButton(
                      icon: const Icon(Icons.lock_open, size: 80),
                      onPressed: _login,
                      color: Colors.blue,
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Autenticarse",
                      style: TextStyle(fontSize: 18),
                    ),

                  ],
                )
              ],
            )
          ],
        ),

      ),


      // TODO -- Esto es para la barra de abajo
      bottomNavigationBar:

      BottomNavigationBar
        (

        currentIndex: 0, // TODO -- Aqui indicamos que estamos actualmente en el indice 0 (Modo Biometrico)
        onTap: (index) {
          if (index == 1) { // TODO -- Si se elije la opcion de contraseña
            // Debería de ocultar el texto de lector y el boton y mostrar un "textbox" y un "label" para
            // la contraseña

            // TODO -- Mostramos un mensaje emergente (inferior)
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Funcionalidad en desarrollo')),
            );
          }
        },

        // TODO -- Aqui se agregan los elementos de la barra de navegacion
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.fingerprint),
            label: 'Biometría',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.password),
            label: 'Contraseña',
          ),
        ],
      ),

    );
  }
// TODO -------------------------- FIN PANTALLA LOGIN --------------------------
}