class CarritoGlobal {
  static final CarritoGlobal _instancia = CarritoGlobal._internal();
  factory CarritoGlobal() => _instancia;
  CarritoGlobal._internal();

  final List<Map<String, dynamic>> productos = [];
  bool isFromCart = false;

  void agregar(Map<String, dynamic> producto) {
    // Guardar una copia para evitar mutar la definición original
    productos.add(Map<String, dynamic>.from(producto));
  }

  void limpiar() {
    productos.clear();
  }

  void eliminar(int index) {
    if (index >= 0 && index < productos.length) {
      productos.removeAt(index);
    }
  }
}
