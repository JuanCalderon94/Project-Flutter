class Product {
  final int id;
  final String nombre;
  final double precio;
  final String? imagenUrl; // puede ser null o vacío
  final String? descripcion;
  final String? categoria;

  Product({
    required this.id,
    required this.nombre,
    required this.precio,
    this.imagenUrl,
    this.descripcion,
    this.categoria,
  });

  factory Product.fromJson(Map<String, dynamic> j) => Product(
        id: (j['id'] ?? 0) as int,
        nombre: (j['nombre'] ?? 'Producto') as String,
        precio: (j['precio'] ?? 0).toDouble(),
        imagenUrl: j['imagen_url'] as String?,
        descripcion: j['descripcion'] as String?,
        categoria: j['categoria'] as String?,
      );
}
