import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/lugar.dart';
import '../providers/lugares_provider.dart';

class PantallaForm extends ConsumerStatefulWidget {
  final Lugar? lugar;
  const PantallaForm({super.key, this.lugar});

  @override
  ConsumerState<PantallaForm> createState() => _PantallaFormState();
}

class _PantallaFormState extends ConsumerState<PantallaForm> {
  late final nombre = TextEditingController(text: widget.lugar?.nombre ?? '');
  late final descripcion = TextEditingController(text: widget.lugar?.descripcion ?? '');
  late final imagen = TextEditingController(text: widget.lugar?.imagen ?? '');
  late final ubicacion = TextEditingController(text: widget.lugar?.ubicacion ?? '');
  late final categoria = TextEditingController(text: widget.lugar?.categoria ?? '');
  String mensaje = '';
  bool guardando = false;

  Future<void> guardar() async {
    final campos = [nombre, descripcion, imagen, ubicacion, categoria];
    if (campos.any((c) => c.text.trim().isEmpty)) {
      setState(() => mensaje = 'Completá todos los campos.');
      return;
    }
    // En el alta el id lo genera Firestore; en la edición se usa el del documento.
    final nuevo = Lugar(
      widget.lugar?.id ?? '',
      nombre.text.trim(), descripcion.text.trim(), imagen.text.trim(), ubicacion.text.trim(), categoria.text.trim(),
    );

    setState(() { guardando = true; mensaje = ''; });
    try {
      if (widget.lugar != null) {
        await ref.read(lugaresControllerProvider).modificar(nuevo);
      } else {
        await ref.read(lugaresControllerProvider).agregar(nuevo);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) setState(() { mensaje = 'No se pudo guardar: $e'; guardando = false; });
    }
  }

  @override
  void dispose() {
    nombre.dispose(); descripcion.dispose(); imagen.dispose(); ubicacion.dispose(); categoria.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.lugar != null ? 'Editar lugar' : 'Nuevo lugar')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: nombre, decoration: const InputDecoration(labelText: 'Nombre')),
            TextField(controller: descripcion, decoration: const InputDecoration(labelText: 'Descripción')),
            TextField(controller: imagen, decoration: const InputDecoration(labelText: 'URL de la imagen')),
            TextField(controller: ubicacion, decoration: const InputDecoration(labelText: 'Ubicación')),
            TextField(controller: categoria, decoration: const InputDecoration(labelText: 'Categoría')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: guardando ? null : guardar,
              child: Text(guardando ? 'Guardando...' : 'Guardar'),
            ),
            Text(mensaje, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
