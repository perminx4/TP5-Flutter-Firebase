import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/lugar.dart';

// Colección de Firestore donde se guardan los lugares.
final _coleccion = FirebaseFirestore.instance.collection('lugares');

// Listado de lugares. snapshots() escucha Firestore en tiempo real,
// así que cualquier alta, modificación o baja se refleja sola en la pantalla.
final lugaresProvider = StreamProvider.autoDispose<List<Lugar>>((ref) {
  return _coleccion.orderBy('nombre').snapshots().map(
        (snap) => snap.docs.map((doc) => Lugar.desdeMapa(doc.id, doc.data())).toList(),
      );
});

// Un solo lugar por id (para el detalle). Devuelve null si el documento ya no existe.
final lugarProvider = StreamProvider.autoDispose.family<Lugar?, String>((ref, id) {
  return _coleccion.doc(id).snapshots().map(
        (doc) => doc.exists ? Lugar.desdeMapa(doc.id, doc.data()!) : null,
      );
});

// Operaciones de alta, modificación y baja sobre Firestore.
class LugaresController {
  Future<void> agregar(Lugar l) => _coleccion.add(l.aMapa());

  Future<void> modificar(Lugar l) => _coleccion.doc(l.id).update(l.aMapa());

  Future<void> eliminar(String id) => _coleccion.doc(id).delete();
}

final lugaresControllerProvider = Provider((ref) => LugaresController());
