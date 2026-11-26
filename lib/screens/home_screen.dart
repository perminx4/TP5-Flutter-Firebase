import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../providers/lugares_provider.dart';
import 'detail_screen.dart';
import 'form_screen.dart';

class PantallaHome extends ConsumerWidget {
  const PantallaHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lugares = ref.watch(lugaresProvider);
    final usuario = ref.watch(authProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: Text('Hola, ${usuario?.displayName ?? ''}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            // Al cerrar sesión, PantallaInicio vuelve a mostrar el login.
            onPressed: () => ref.read(authControllerProvider).cerrarSesion(),
          ),
        ],
      ),
      body: lugares.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error al cargar los lugares: $e')),
        data: (lista) {
          if (lista.isEmpty) {
            return const Center(child: Text('No hay lugares cargados. Agregá uno con el botón +'));
          }
          return ListView.builder(
            itemCount: lista.length,
            itemBuilder: (context, i) {
              final l = lista[i];
              return ListTile(
                leading: Image.network(
                  l.imagen, width: 60, height: 60, fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const Icon(Icons.image_not_supported, size: 60),
                ),
                title: Text(l.nombre),
                subtitle: Text(l.categoria),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PantallaDetalle(l.id))),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PantallaForm())),
        child: const Icon(Icons.add),
      ),
    );
  }
}
