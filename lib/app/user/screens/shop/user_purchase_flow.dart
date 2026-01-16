import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart' show initializeDateFormatting;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_application_1/app/data/carrito_global.dart';

// This file implements user purchase flow screens (User version of visitante flows)

class MetodoPagoUserScreen extends StatelessWidget {
  const MetodoPagoUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F0FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7DB6F5),
        elevation: 0,
        title: const Text(
          "Metodos de Pago",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          const Text(
            "Tarjeta",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => Navigator.of(context).pushNamed('pago_tarjeta_user'),
            child: Center(
              child: SizedBox(
                width: 360,
                height: 180,
                child: Image.asset("assets/img/visa.png", fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Billetera Virtual",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pushNamed('pago_yape_user'),
                child: SizedBox(
                  width: 170,
                  height: 130,
                  child: Image.asset("assets/img/yape.png", fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 24),
              GestureDetector(
                onTap: () => Navigator.of(context).pushNamed('pago_yape_user'),
                child: SizedBox(
                  width: 170,
                  height: 130,
                  child: Image.asset("assets/img/plin.png", fit: BoxFit.cover),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: GestureDetector(
              onTap: () =>
                  Navigator.of(context).pushNamed('pago_efectivo_user'),
              child: SizedBox(
                width: 220,
                height: 130,
                child: Image.asset(
                  "assets/img/pagoefectivo.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PagoTarjetaUserScreen extends StatelessWidget {
  const PagoTarjetaUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F0FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7DB6F5),
        elevation: 0,
        title: const Text(
          "Pago con Tarjeta",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/img/visa.png", height: 80),
            const SizedBox(height: 24),
            const Text("+ Añadir Tarjeta", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 36),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A6DFF),
                minimumSize: const Size(200, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('finalizar_compra_user');
              },
              child: const Text(
                "Finalizar Compra",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PagoYapeUserScreen extends StatelessWidget {
  const PagoYapeUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F0FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7DB6F5),
        elevation: 0,
        title: const Text(
          "Pago con Yape",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Escanear QR del Yape",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Image.asset("assets/img/yapeqr.png", height: 200),
              const SizedBox(height: 16),
              const Text(
                "O escanear QR del Plin",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Image.asset("assets/img/plinqr.png", height: 200),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A6DFF),
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed('finalizar_compra_user');
                },
                child: const Text(
                  "Finalizar Compra",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PagoEfectivoUserScreen extends StatelessWidget {
  const PagoEfectivoUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F0FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7DB6F5),
        elevation: 0,
        title: const Text(
          "Pago Efectivo",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Estimado cliente acercarse por favor a la tienda para hacer el pago respectivo del producto gracias.",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              Text(
                "Recoga el producto en la tienda",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1A6DFF),
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pushNamed('finalizar_compra_user');
          },
          child: const Text("Finalizar Compra", style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}

class FinalizarCompraUserScreen extends StatelessWidget {
  const FinalizarCompraUserScreen({super.key});

  Future<void> _savePurchasesForUser(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final currentUser = prefs.getString('current_user') ?? 'user';

    final carrito = CarritoGlobal().productos;
    final List lista = prefs.getString('purchases') != null
        ? jsonDecode(prefs.getString('purchases')!) as List
        : [];

    if (carrito.isNotEmpty) {
      for (final p in carrito) {
        lista.add({
          'producto': p['nombre'] ?? p['producto'] ?? 'Producto',
          'precio': p['precio'] ?? 0.0,
          'fecha': DateTime.now().toIso8601String(),
          'user': currentUser,
          'qrData':
              'Producto: ${p['nombre'] ?? p['producto']}\nUsuario: $currentUser',
        });
      }
    }

    await prefs.setString('purchases', jsonEncode(lista));
    CarritoGlobal().limpiar();

    // Go to notifications
    Navigator.of(context).pushNamed('notificaciones_user');
  }

  @override
  Widget build(BuildContext context) {
    // Show a summary from CarritoGlobal or dummy
    final producto = CarritoGlobal().productos.isNotEmpty
        ? CarritoGlobal().productos.last
        : {'nombre': 'Producto', 'precio': 15.0};

    return Scaffold(
      backgroundColor: const Color(0xFFE6F0FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7DB6F5),
        elevation: 0,
        title: const Text(
          "Finalizar Compra",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/img/image.png'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    producto['nombre'] ?? 'Producto',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                Text(
                  'S/${(producto['precio'] ?? 0.0).toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Color(0xFF1A6DFF),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Nombre: Pedro Lopez'),
            const Text('Dirección: AV. Giraldez Nº 274-Tienda S02 - Huancayo'),
            const SizedBox(height: 8),
            Text(
              'Total con envío: S/${(producto['precio'] ?? 0.0).toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A6DFF),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () async {
                await _savePurchasesForUser(context);
              },
              child: const Text(
                'Finalizar Compra',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificacionesUserScreen extends StatelessWidget {
  const NotificacionesUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F0FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7DB6F5),
        elevation: 0,
        title: const Text(
          'Tienes una notificación',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/img/image.png'),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    '¡Tu pedido está listo para recogerlo en la tienda!',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Estimado cliente diríjase por favor a la tienda para recoger su pedido, esperamos que vuelva pronto y que siga comprando nuestros productos gracias.',
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('compra_realizada_user');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A6DFF),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('Finalizar'),
            ),
          ],
        ),
      ),
    );
  }
}

class CompraRealizadaUserScreen extends StatelessWidget {
  const CompraRealizadaUserScreen({super.key});

  Future<Map<String, dynamic>?> _getLastPurchase() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('purchases');
    final currentUser = prefs.getString('current_user') ?? 'user';
    if (raw == null) return null;
    final List list = jsonDecode(raw) as List;
    final filtered = list.where((e) => e['user'] == currentUser).toList();
    return filtered.isNotEmpty
        ? Map<String, dynamic>.from(filtered.last)
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: initializeDateFormatting('es_ES', null),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return FutureBuilder<Map<String, dynamic>?>(
          future: _getLastPurchase(),
          builder: (context, snapshot2) {
            final purchase = snapshot2.data;
            final producto = purchase?['producto'] ?? 'Producto';
            final fechaLarga = purchase?['fecha'] != null
                ? DateFormat(
                    'EEEE d \"de\" MMMM \"de\" yyyy',
                    'es_ES',
                  ).format(DateTime.parse(purchase!['fecha']).toLocal())
                : 'Fecha desconocida';
            final codigo = purchase?['qrData'] != null
                ? () {
                    final hash = purchase!['qrData'].hashCode
                        .toRadixString(36)
                        .toUpperCase();
                    return hash.length >= 8
                        ? hash.substring(0, 8)
                        : hash.padRight(8, 'X');
                  }()
                : 'WLQCRNM';

            return Scaffold(
              backgroundColor: const Color(0xFFE6F0FA),
              appBar: AppBar(
                backgroundColor: const Color(0xFF7DB6F5),
                elevation: 0,
                title: const Text(
                  'Compra Realizada',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text(
                      'Compra realizada el día: $fechaLarga',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Producto: $producto',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    if (purchase?['qrData'] != null)
                      QrImageView(
                        data: purchase!['qrData'] ?? '',
                        version: QrVersions.auto,
                        size: 160.0,
                      )
                    else
                      Image.asset('assets/img/qr.png', height: 160),
                    const SizedBox(height: 16),
                    Text('Código de validación: $codigo'),
                    const Text('AV. Giraldez Nº 274-Tienda S02 - Huancayo'),
                    Text('Fecha de recogida: $fechaLarga'),
                    const SizedBox(height: 24),
                    const Text(
                      'Pasos para reclamar tu pedido\n1.- Ir a la tienda\n2.- Mostrar el QR\n3.- Recoger tu pedido',
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A6DFF),
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst);
                      },
                      child: const Text('Finalizar'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
