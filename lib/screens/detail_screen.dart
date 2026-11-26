import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/lugares_provider.dart';
import 'form_screen.dart';

class PantallaDetalle extends ConsumerWidget {
  final String id;
  const PantallaDetalle(this.id, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escucha el documento en Firestore: si se edita, el detalle se actualiza solo.
    final estado = ref.watch(lugarProvider(id));
    final lugar = estado.value;

    if (lugar == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: estado.isLoading ? const CircularProgressIndicator() : const Text('Este lugar ya no existe.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(lugar.nombre),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PantallaForm(lugar: lugar)),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final controller = ref.read(lugaresControllerProvider);
              final avisos = ScaffoldMessenger.of(context);
              Navigator.pop(context); // volvemos al listado, donde el lugar desaparece solo
              try {
                await controller.eliminar(lugar.id);
              } catch (e) {
                avisos.showSnackBar(SnackBar(content: Text('No se pudo eliminar: $e')));
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              lugar.imagen, width: double.infinity, height: 250, fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const SizedBox(height: 250, child: Center(child: Icon(Icons.image_not_supported, size: 80))),
            ),
            const SizedBox(height: 16),
            Text(lugar.nombre, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('${lugar.categoria} · ${lugar.ubicacion}', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Text(lugar.descripcion),
          ],
        ),
      ),
    );
  }
}
