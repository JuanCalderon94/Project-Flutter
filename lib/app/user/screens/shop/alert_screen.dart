import 'dart:convert';
// dart:typed_data not needed (Uint8List is available via foundation)

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';

import 'package:flutter_application_1/app/user/utils/qr_helper_io.dart'
    if (dart.library.html) 'package:flutter_application_1/app/user/utils/qr_helper_web.dart'
    as qr_helper;

class AlertScreen extends StatefulWidget {
  const AlertScreen({super.key});

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  List<Map<String, dynamic>> compras = [];

  @override
  void initState() {
    super.initState();
    _cargarCompras();
  }

  Future<void> _cargarCompras() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('purchases');
    final currentUser = prefs.getString('current_user');
    final List list = raw != null ? jsonDecode(raw) as List : [];
    final all = list.map((e) => Map<String, dynamic>.from(e)).toList();
    setState(() {
      // Si hay un usuario logueado, mostrar solo sus compras
      if (currentUser != null) {
        compras = all.where((c) => c['user'] == currentUser).toList();
      } else {
        // Si no hay usuario logueado, mostrar todas las compras
        compras = all;
      }
    });
  }

  String _formatFecha(String fechaRaw) {
    try {
      final dt = DateTime.parse(fechaRaw).toLocal();
      return DateFormat('dd/MM/yyyy HH:mm').format(dt);
    } catch (_) {
      return fechaRaw;
    }
  }

  Future<Uint8List?> _generateQrBytes(String data, {int size = 300}) async {
    try {
      final painter = QrPainter(
        data: data,
        version: QrVersions.auto,
        gapless: true,
      );

      final picData = await painter.toImageData(size.toDouble());
      return picData?.buffer.asUint8List();
    } catch (e) {
      return null;
    }
  }

  Future<void> _eliminarCompraAt(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('purchases');
    final List list = raw != null ? jsonDecode(raw) as List : [];
    final all = list.map((e) => Map<String, dynamic>.from(e)).toList();

    // Encontrar la compra que corresponde al elemento en la vista (por igualdad completa)
    final target = compras[index];
    all.removeWhere(
      (c) =>
          c['producto'] == target['producto'] &&
          c['fecha'] == target['fecha'] &&
          c['user'] == target['user'],
    );

    await prefs.setString('purchases', jsonEncode(all));
    await _cargarCompras();
  }

  Future<void> _compartirCompra(Map<String, dynamic> compra) async {
    final producto = compra['producto'] ?? 'Producto';
    final fecha = _formatFecha(compra['fecha'] ?? '');
    final text = 'Compra: $producto\nFecha: $fecha';

    if (kIsWeb) {
      // En web, copiar al portapapeles y sugerir descargar QR
      await Clipboard.setData(ClipboardData(text: text));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Detalles copiados al portapapeles')),
      );
      final bytes = await _generateQrBytes(
        'Producto: $producto\nFecha: $fecha',
      );
      if (bytes != null) {
        await qr_helper.downloadQr(
          bytes,
          'qr_${producto.replaceAll(' ', '_')}.png',
        );
      }
    } else {
      // En móviles/desktop, intentar compartir texto (y más si se implementa)
      await Share.share(text);
    }
  }

  @override
  Widget build(BuildContext context) {
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
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: compras.isEmpty
              ? const Center(child: Text('Aún no tienes pedidos realizados'))
              : ListView.builder(
                  itemCount: compras.length,
                  itemBuilder: (context, index) {
                    final compra = compras[index];
                    final producto =
                        compra['producto'] ?? 'Producto desconocido';
                    final fechaRaw = compra['fecha'] ?? '';
                    String fecha = fechaRaw;
                    try {
                      fecha = DateTime.parse(
                        fechaRaw,
                      ).toLocal().toString().split('.').first;
                    } catch (_) {}

                    final bool confirmed =
                        compra['confirmed'] == true || compra['qrData'] != null;
                    final qrDataString = 'Producto: $producto\nFecha: $fecha';

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            'qr',
                            arguments: {
                              'producto': producto,
                              'fecha': fecha,
                              'qrData': compra['qrData'] ?? qrDataString,
                            },
                          );
                        },
                        leading: compra['qrData'] != null || confirmed
                            ? SizedBox(
                                width: 56,
                                height: 56,
                                child: Card(
                                  elevation: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: QrImageView(
                                      data: compra['qrData'] ?? qrDataString,
                                      version: QrVersions.auto,
                                      size: 44,
                                    ),
                                  ),
                                ),
                              )
                            : const Icon(
                                Icons.shopping_bag,
                                color: Colors.grey,
                              ),
                        title: Text(producto),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_formatFecha(compra['fecha'] ?? fechaRaw)),
                            const SizedBox(height: 4),
                            if (confirmed)
                              const Text(
                                'Compra confirmada',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) async {
                            if (value == 'ver') {
                              Navigator.pushNamed(
                                context,
                                'qr',
                                arguments: {
                                  'producto': producto,
                                  'fecha': fecha,
                                },
                              );
                            } else if (value == 'compartir') {
                              await _compartirCompra(compras[index]);
                            } else if (value == 'descargar') {
                              final bytes = await _generateQrBytes(
                                'Producto: $producto\nFecha: $fecha',
                              );
                              if (bytes != null) {
                                await qr_helper.downloadQr(
                                  bytes,
                                  'qr_${producto.replaceAll(' ', '_')}.png',
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('No se pudo generar QR'),
                                  ),
                                );
                              }
                            } else if (value == 'eliminar') {
                              await _eliminarCompraAt(index);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Pedido eliminado'),
                                ),
                              );
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'ver',
                              child: Text('Ver QR'),
                            ),
                            const PopupMenuItem(
                              value: 'compartir',
                              child: Text('Compartir'),
                            ),
                            const PopupMenuItem(
                              value: 'descargar',
                              child: Text('Descargar QR'),
                            ),
                            const PopupMenuItem(
                              value: 'eliminar',
                              child: Text('Eliminar'),
                            ),
                          ],
                          child: const Icon(Icons.more_vert),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
