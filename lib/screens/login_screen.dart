import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import 'registro_screen.dart';

class PantallaLogin extends ConsumerStatefulWidget {
  const PantallaLogin({super.key});
  @override
  ConsumerState<PantallaLogin> createState() => _PantallaLoginState();
}

class _PantallaLoginState extends ConsumerState<PantallaLogin> {
  final email = TextEditingController();
  final contrasena = TextEditingController();
  String mensaje = '';
  bool cargando = false;

  Future<void> ingresar() async {
    if (email.text.trim().isEmpty || contrasena.text.isEmpty) {
      setState(() => mensaje = 'Completá todos los campos.');
      return;
    }
    setState(() { cargando = true; mensaje = ''; });
    try {
      await ref.read(authControllerProvider).iniciarSesion(email.text.trim(), contrasena.text);
      // No hace falta navegar: PantallaInicio detecta la sesión y muestra el listado.
    } on FirebaseAuthException catch (e) {
      if (mounted) setState(() => mensaje = mensajeDeError(e));
    } finally {
      if (mounted) setState(() => cargando = false);
    }
  }

  @override
  void dispose() { email.dispose(); contrasena.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email')),
              TextField(controller: contrasena, obscureText: true, decoration: const InputDecoration(labelText: 'Contraseña')),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: cargando ? null : ingresar,
                child: Text(cargando ? 'Ingresando...' : 'Ingresar'),
              ),
              Text(mensaje, style: const TextStyle(color: Colors.red)),
              TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PantallaRegistro())),
                child: const Text('Crear cuenta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
