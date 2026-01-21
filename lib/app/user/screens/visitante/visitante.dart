import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/app/data/carrito_global.dart';
import 'package:flutter_application_1/services/auth_service.dart';

// ==================== DATOS DE PRODUCTOS ====================
final List<Map<String, dynamic>> categorias = [
  {"nombre": "Tintas"},
  {"nombre": "Procesadores"},
  {"nombre": "Mouse"},
  {"nombre": "Teclados"},
  {"nombre": "Discos duros"},
  {"nombre": "Toners"},
  {"nombre": "Computadores"},
];

final List<Map<String, dynamic>> productos = [
  {
    "nombre": "Mouse Gamer X",
    "precio": 45.0,
    "categoria": "Mouse",
    "imagen": "assets/img/image.png",
  },
  {
    "nombre": "Teclado Mecánico TKL",
    "precio": 75.0,
    "categoria": "Teclados",
    "imagen": "assets/img/image.png",
  },
  {
    "nombre": "Tinta Negra Compatible",
    "precio": 12.0,
    "categoria": "Tintas",
    "imagen": "assets/img/image.png",
  },
  {
    "nombre": "Disco Duro 1TB",
    "precio": 65.0,
    "categoria": "Discos duros",
    "imagen": "assets/img/image.png",
  },
  {
    "nombre": "Procesador Ryzen 5",
    "precio": 180.0,
    "categoria": "Procesadores",
    "imagen": "assets/img/image.png",
  },
  {
    "nombre": "Toner HP Genérico",
    "precio": 40.0,
    "categoria": "Toners",
    "imagen": "assets/img/image.png",
  },
  {
    "nombre": "SSD 512GB",
    "precio": 95.0,
    "categoria": "Discos duros",
    "imagen": "assets/img/image.png",
  },
];

// ==================== PANTALLA PRINCIPAL DE CATÁLOGO ====================
class VisitanteScreen extends StatefulWidget {
  const VisitanteScreen({super.key});

  @override
  State<VisitanteScreen> createState() => _VisitanteScreenState();
}

class _VisitanteScreenState extends State<VisitanteScreen> {
  String categoriaSeleccionada = "Todos";
  String busqueda = "";

  List<Map<String, dynamic>> get productosFiltrados {
    var lista = productos;
    if (categoriaSeleccionada != "Todos") {
      lista = lista
          .where((p) => p["categoria"] == categoriaSeleccionada)
          .toList();
    }
    if (busqueda.isNotEmpty) {
      lista = lista
          .where(
            (p) => p["nombre"].toLowerCase().contains(busqueda.toLowerCase()),
          )
          .toList();
    }
    return lista;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F0FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7DB6F5),
        elevation: 0,
        title: const Text(
          "Catálogo",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, 'carrito_visitante');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Buscador
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) => setState(() => busqueda = value),
              decoration: InputDecoration(
                hintText: "Búsqueda",
                prefixIcon: const Icon(Icons.search, color: Color(0xFF7DB6F5)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // Categorías
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildCategoriaChip("Todos"),
                ...categorias.map((cat) => _buildCategoriaChip(cat["nombre"])),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Grid de productos
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: productosFiltrados.length,
              itemBuilder: (context, index) {
                final producto = productosFiltrados[index];
                return _buildProductCard(producto);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriaChip(String nombre) {
    final isSelected = categoriaSeleccionada == nombre;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(nombre),
        selected: isSelected,
        onSelected: (selected) {
          setState(() => categoriaSeleccionada = nombre);
        },
        selectedColor: const Color(0xFF1A6DFF),
        backgroundColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> producto) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.asset(
                producto["imagen"],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFFE6F0FA),
                    child: const Icon(
                      Icons.image,
                      size: 50,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  producto["nombre"],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "S/ ${producto["precio"].toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: Color(0xFF1A6DFF),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A6DFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProcesoVentaScreen(producto: producto),
                        ),
                      );
                    },
                    child: const Text(
                      "Ver Detalles",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== PROCESO DE VENTA (DETALLE Y OPCIÓN COMPRA) ====================
class ProcesoVentaScreen extends StatefulWidget {
  final Map<String, dynamic> producto;
  const ProcesoVentaScreen({super.key, required this.producto});

  @override
  State<ProcesoVentaScreen> createState() => _ProcesoVentaScreenState();
}

class _ProcesoVentaScreenState extends State<ProcesoVentaScreen> {
  int cantidad = 1;
  bool _isLoading = false;

  Future<void> _agregarAlCarrito() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentUser = prefs.getString('current_user') ?? 'guest';

      if (currentUser == 'guest') {
        // Guardar acción pendiente
        final serializable = <String, dynamic>{};
        widget.producto.forEach((k, v) {
          if (v is String || v is num || v is bool) serializable[k] = v;
        });
        await prefs.setString(
          'pending_action',
          jsonEncode({
            'type': 'add',
            'producto': serializable,
            'cantidad': cantidad,
          }),
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Por favor inicia sesión para continuar'),
            ),
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(producto: widget.producto),
            ),
          );
        }
        return;
      }

      // Usuario autenticado: agregar al carrito
      for (int i = 0; i < cantidad; i++) {
        final now = DateTime.now().toIso8601String();
        final item = Map<String, dynamic>.from(widget.producto);
        item['fecha'] = now;
        item['user'] = currentUser;
        CarritoGlobal().agregar(item);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Se agregaron $cantidad unidad(es) al carrito'),
          ),
        );
        Navigator.pushNamed(context, 'carrito_visitante');
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F0FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7DB6F5),
        elevation: 0,
        title: const Text(
          "Detalles del Producto",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen del producto
              Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    widget.producto["imagen"],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.image,
                        size: 100,
                        color: Colors.grey,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Nombre
              Text(
                widget.producto["nombre"],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2B4C6F),
                ),
              ),
              const SizedBox(height: 8),
              // Categoría
              Chip(
                label: Text(widget.producto["categoria"]),
                backgroundColor: const Color(0xFF7DB6F5),
                labelStyle: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              // Precio
              Text(
                "S/ ${widget.producto["precio"].toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A6DFF),
                ),
              ),
              const SizedBox(height: 24),
              // Cantidad
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Cantidad:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    onPressed: cantidad > 1
                        ? () => setState(() => cantidad--)
                        : null,
                    icon: const Icon(Icons.remove_circle),
                  ),
                  Text(
                    "$cantidad",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() => cantidad++),
                    icon: const Icon(Icons.add_circle),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Botones de acción
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A6DFF),
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _isLoading ? null : _agregarAlCarrito,
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text(
                        "Agregar al Carrito",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  side: const BorderSide(color: Color(0xFF1A6DFF), width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _isLoading ? null : () => Navigator.pop(context),
                child: const Text(
                  "Volver al Catálogo",
                  style: TextStyle(fontSize: 18, color: Color(0xFF1A6DFF)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== SIGN UP ====================
class SignUpScreen extends StatefulWidget {
  final Map<String, dynamic>? producto;
  const SignUpScreen({Key? key, this.producto}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usuarioController = TextEditingController();
  final _correoController = TextEditingController();
  final _passController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _usuarioController.dispose();
    _correoController.dispose();
    _passController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final auth = AuthService();
      final result = await auth.signUp(
        username: _usuarioController.text,
        email: _correoController.text,
        password: _passController.text,
        passwordConfirm: _passController.text,
      );

      if (!result['success']) {
        if (mounted) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Error'),
              content: Text(result['message'] ?? 'Error en el registro.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
        return;
      }

      // Guardar usuario
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_user', _usuarioController.text);
      if (result['token'] != null) {
        await prefs.setString('auth_token', result['token']);
      }

      // Procesar acción pendiente si existe
      final pending = prefs.getString('pending_action');
      if (pending != null && mounted) {
        try {
          final action = jsonDecode(pending) as Map<String, dynamic>;
          await prefs.remove('pending_action');

          if (action['type'] == 'add') {
            final producto = Map<String, dynamic>.from(
              action['producto'] ?? {},
            );
            final cantidadA = (action['cantidad'] ?? 1) as int;
            for (int i = 0; i < cantidadA; i++) {
              final now = DateTime.now().toIso8601String();
              final item = Map<String, dynamic>.from(producto);
              item['fecha'] = now;
              item['user'] = _usuarioController.text;
              CarritoGlobal().agregar(item);
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Se agregaron $cantidadA unidad(es) al carrito'),
              ),
            );
            Navigator.pushNamed(context, 'carrito_visitante');
            return;
          }
        } catch (e) {
          // Ignore and continue
        }
      }

      if (mounted) {
        Navigator.pushReplacementNamed(context, 'login_visitante');
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F0FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7DB6F5),
        elevation: 0,
        title: const Text(
          'Crear Cuenta',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Bienvenido a la Tienda',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2B4C6F),
                  ),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _usuarioController,
                  decoration: InputDecoration(
                    labelText: 'USUARIO',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Ingrese un usuario' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _correoController,
                  decoration: InputDecoration(
                    labelText: 'CORREO',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Ingrese su correo' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passController,
                  decoration: InputDecoration(
                    labelText: 'CONTRASEÑA',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  obscureText: true,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Ingrese una contraseña' : null,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A6DFF),
                    minimumSize: const Size(double.infinity, 56),
                  ),
                  onPressed: _isLoading ? null : _handleSignUp,
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text(
                          'Registrarse',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          LoginScreen(producto: widget.producto),
                    ),
                  ),
                  child: const Text(
                    '¿Ya tienes cuenta? Inicia sesión',
                    style: TextStyle(color: Color(0xFF7DB6F5)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== LOGIN ====================
class LoginScreen extends StatefulWidget {
  final Map<String, dynamic>? producto;
  const LoginScreen({Key? key, this.producto}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _correoController = TextEditingController();
  final _passController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _correoController.dispose();
    _passController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final auth = AuthService();
      final result = await auth.login(
        email: _correoController.text,
        password: _passController.text,
      );

      if (!result['success']) {
        if (mounted) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Error'),
              content: Text(result['message'] ?? 'Credenciales inválidas.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
        return;
      }

      // Guardar usuario y token
      final prefs = await SharedPreferences.getInstance();
      if (result['token'] != null) {
        await prefs.setString('auth_token', result['token']);
      }
      final username = prefs.getString('username') ?? _correoController.text;
      await prefs.setString('current_user', username);

      // Procesar acción pendiente si existe
      final pending = prefs.getString('pending_action');
      if (pending != null && mounted) {
        try {
          final action = jsonDecode(pending) as Map<String, dynamic>;
          await prefs.remove('pending_action');

          if (action['type'] == 'add') {
            final producto = Map<String, dynamic>.from(
              action['producto'] ?? {},
            );
            final cantidadA = (action['cantidad'] ?? 1) as int;
            for (int i = 0; i < cantidadA; i++) {
              final now = DateTime.now().toIso8601String();
              final item = Map<String, dynamic>.from(producto);
              item['fecha'] = now;
              item['user'] = username;
              CarritoGlobal().agregar(item);
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Se agregaron $cantidadA unidad(es) al carrito'),
              ),
            );
            Navigator.pushNamed(context, 'carrito_visitante');
            return;
          }
        } catch (e) {
          // Ignore and continue
        }
      }

      if (mounted) {
        Navigator.pushReplacementNamed(context, 'login_visitante');
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F0FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7DB6F5),
        elevation: 0,
        title: const Text(
          'Iniciar Sesión',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Bienvenido',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2B4C6F),
                  ),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _correoController,
                  decoration: InputDecoration(
                    labelText: 'CORREO',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Ingrese su correo' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passController,
                  decoration: InputDecoration(
                    labelText: 'CONTRASEÑA',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  obscureText: true,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Ingrese una contraseña' : null,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A6DFF),
                    minimumSize: const Size(double.infinity, 56),
                  ),
                  onPressed: _isLoading ? null : _handleLogin,
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text(
                          'Iniciar Sesión',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SignUpScreen(producto: widget.producto),
                    ),
                  ),
                  child: const Text(
                    '¿No tienes cuenta? Regístrate',
                    style: TextStyle(color: Color(0xFF7DB6F5)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
