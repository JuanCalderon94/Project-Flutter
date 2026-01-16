import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/data/carrito_global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/app/user/screens/visitante/visitante.dart'
    as visitante;

// ==================== CARRITO SCREEN ====================
class CarritoScreen extends StatefulWidget {
  const CarritoScreen({super.key});

  @override
  State<CarritoScreen> createState() => _CarritoScreenState();
}

class _CarritoScreenState extends State<CarritoScreen> {
  bool _hasUser = false;

  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  Future<void> _checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('current_user');
    setState(() {
      _hasUser = user != null && user.isNotEmpty && user != 'guest';
    });
  }

  @override
  Widget build(BuildContext context) {
    final carrito = CarritoGlobal().productos;
    return Scaffold(
      backgroundColor: const Color(0xFFE6F0FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7DB6F5),
        elevation: 0,
        title: const Text(
          "Carrito de compras",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (_hasUser)
            IconButton(
              tooltip: 'Ver mis pedidos',
              icon: const Icon(Icons.history, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, 'alert');
              },
            ),
        ],
      ),
      body: carrito.isEmpty
          ? const Center(
              child: Text(
                "El carrito está vacío",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: carrito.length,
              itemBuilder: (context, index) {
                final producto = carrito[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFF7DB6F5),
                      child: Icon(Icons.shopping_bag, color: Colors.white),
                    ),
                    title: Text(
                      producto["nombre"] ?? "Producto",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      "S/ ${producto["precio"]}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A6DFF),
                      ),
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1A6DFF),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: carrito.isEmpty
              ? null
              : () {
                  // Navegar directamente a MessageScreen
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const MessageScreen(),
                    ),
                  );
                },
          child: const Text(
            "Continuar con la compra",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

// ==================== MESSAGE SCREEN ====================
class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F0FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7DB6F5),
        elevation: 0,
        title: const Text(
          "Continuar con la compra",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
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
                child: Column(
                  children: [
                    const Icon(
                      Icons.lock_outline,
                      size: 64,
                      color: Color(0xFF7DB6F5),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Inicia sesión o regístrate",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2B4C6F),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Para continuar con tu compra y poder pagar el producto, necesitas tener una cuenta.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    // Botón de Login
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A6DFF),
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const visitante.LoginScreen(),
                          ),
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.login, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            "Iniciar sesión",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Botón de Registro
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        side: const BorderSide(
                          color: Color(0xFF7DB6F5),
                          width: 2,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                const visitante.SignUpScreen(),
                          ),
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_add, color: Color(0xFF7DB6F5)),
                          SizedBox(width: 8),
                          Text(
                            "Crear cuenta",
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF7DB6F5),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Volver al carrito",
                  style: TextStyle(color: Color(0xFF7DB6F5)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
