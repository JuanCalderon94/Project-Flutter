import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrScreen extends StatelessWidget {
  const QrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    final producto = args?['producto'] ?? 'Producto desconocido';
    final fecha = args?['fecha'] ?? 'Fecha desconocida';
    final qrData = args?['qrData'] ?? 'Producto: $producto\nFecha: $fecha';

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 110,
        leadingWidth: 50,
        title: Hero(
          tag: "logo",
          child: Image.asset("assets/img/image.png", width: 100),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Card(
          margin: EdgeInsets.all(14),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '¡Compra realizada!',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text('Producto: $producto', style: TextStyle(fontSize: 16)),
                Text('Fecha: $fecha', style: TextStyle(fontSize: 16)),
                SizedBox(height: 24),
                QrImageView(
                  data: qrData,
                  version: QrVersions.auto,
                  size: 220.0,
                ),
                SizedBox(height: 16),
                Text(
                  'Muestra este QR para verificar tu compra',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
