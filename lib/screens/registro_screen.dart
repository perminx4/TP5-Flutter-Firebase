import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

class PantallaRegistro extends ConsumerStatefulWidget {
  const PantallaRegistro({super.key});
  @override
  ConsumerState<PantallaRegistro> createState() => _PantallaRegistroState();
}

class _PantallaRegistroState extends ConsumerState<PantallaRegistro> {
  final nombre = TextEditingController();
  final email = TextEditingController();
  final contrasena = TextEditingController();
  final confirmar = TextEditingController();
  String mensaje = '';
  bool cargando = false;

  final formatoEmail = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  Future<void> registrar() async {
    if (nombre.text.trim().isEmpty || email.text.trim().isEmpty || contrasena.text.isEmpty || confirmar.text.isEmpty) {
      setState(() => mensaje = 'Completá todos los campos.');
      return;
    }
    if (!formatoEmail.hasMatch(email.text.trim())) {
      setState(() => mensaje = 'El email no tiene un formato válido.');
      return;
    }
    if (contrasena.text != confirmar.text) {
      setState(() => mensaje = 'Las contraseñas no coinciden.');
      return;
    }
    setState(() { cargando = true; mensaje = ''; });
    try {
      await ref.read(authControllerProvider).registrar(nombre.text.trim(), email.text.trim(), contrasena.text);
      // Firebase deja la sesión iniciada: volvemos y PantallaInicio muestra el listado.
      if (mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (mounted) setState(() { mensaje = mensajeDeError(e); cargando = false; });
    }
  }

  @override
  void dispose() {
    nombre.dispose(); email.dispose(); contrasena.dispose(); confirmar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear cuenta')),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: nombre, decoration: const InputDecoration(labelText: 'Nombre')),
            TextField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: contrasena, obscureText: true, decoration: const InputDecoration(labelText: 'Contraseña')),
            TextField(controller: confirmar, obscureText: true, decoration: const InputDecoration(labelText: 'Confirmar contraseña')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: cargando ? null : registrar,
              child: Text(cargando ? 'Registrando...' : 'Registrarme'),
            ),
            Text(mensaje, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
