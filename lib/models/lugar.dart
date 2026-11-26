class Lugar {
  final String id, nombre, descripcion, imagen, ubicacion, categoria;
  const Lugar(this.id, this.nombre, this.descripcion, this.imagen, this.ubicacion, this.categoria);

  // Crea un Lugar a partir de un documento de Firestore (el id es el ID del documento).
  factory Lugar.desdeMapa(String id, Map<String, dynamic> datos) => Lugar(
        id,
        datos['nombre'] ?? '',
        datos['descripcion'] ?? '',
        datos['imagen'] ?? '',
        datos['ubicacion'] ?? '',
        datos['categoria'] ?? '',
      );

  // Datos que se guardan en Firestore (el id no se guarda, es el del documento).
  Map<String, dynamic> aMapa() => {
        'nombre': nombre,
        'descripcion': descripcion,
        'imagen': imagen,
        'ubicacion': ubicacion,
        'categoria': categoria,
      };
}
