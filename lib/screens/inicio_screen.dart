import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import 'home_screen.dart';
import 'login_screen.dart';

// Pantalla inicial: al abrir la app comprueba si hay una sesión activa.
// Como escucha authProvider, al iniciar o cerrar sesión cambia sola de pantalla.
class PantallaInicio extends ConsumerWidget {
  const PantallaInicio({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuario = ref.watch(authProvider);

    return usuario.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (u) => u != null ? const PantallaHome() : const PantallaLogin(),
    );
  }
}
