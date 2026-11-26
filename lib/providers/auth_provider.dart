import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Estado de autenticación: emite el usuario logueado (o null) cada vez que cambia la sesión.
// userChanges() también avisa cuando se actualiza el perfil (por ejemplo, el nombre).
final authProvider = StreamProvider<User?>((ref) => FirebaseAuth.instance.userChanges());

// Acciones de autenticación. Las contraseñas las maneja solo Firebase Authentication.
class AuthController {
  final _auth = FirebaseAuth.instance;

  Future<void> registrar(String nombre, String email, String contrasena) async {
    final credencial = await _auth.createUserWithEmailAndPassword(email: email, password: contrasena);
    await credencial.user!.updateDisplayName(nombre); // el nombre queda en el perfil del usuario
    await credencial.user!.reload();
  }

  Future<void> iniciarSesion(String email, String contrasena) =>
      _auth.signInWithEmailAndPassword(email: email, password: contrasena);

  Future<void> cerrarSesion() => _auth.signOut();
}

final authControllerProvider = Provider((ref) => AuthController());

// Traduce los códigos de error de Firebase a mensajes claros.
String mensajeDeError(FirebaseAuthException e) {
  switch (e.code) {
    case 'email-already-in-use':
      return 'Ese email ya está registrado.';
    case 'invalid-email':
      return 'El email no es válido.';
    case 'weak-password':
      return 'La contraseña debe tener al menos 6 caracteres.';
    case 'invalid-credential':
    case 'user-not-found':
    case 'wrong-password':
      return 'Email o contraseña incorrectos.';
    case 'user-disabled':
      return 'Esta cuenta está deshabilitada.';
    case 'too-many-requests':
      return 'Demasiados intentos. Probá de nuevo más tarde.';
    case 'network-request-failed':
      return 'No hay conexión a internet.';
    case 'operation-not-allowed':
      return 'El ingreso con email y contraseña no está habilitado en Firebase.';
    default:
      return 'Ocurrió un error: ${e.message ?? e.code}';
  }
}
