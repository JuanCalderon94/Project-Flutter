import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/styles/text_styles.dart';
import 'package:flutter_application_1/app/data/carrito_global.dart';
import 'package:intl/intl.dart';

// Agregar acceso a ver pedidos (AlertScreen)

class ShopCartScreen extends StatefulWidget {
  const ShopCartScreen({super.key});

  @override
  State<ShopCartScreen> createState() => _ShopCartScreenState();
}

class _ShopCartScreenState extends State<ShopCartScreen> {
  int selectedCategory = 0;
  int _selectedIndex = 2;

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
        actions: [
          IconButton(
            tooltip: 'Ver mis pedidos',
            icon: const Icon(Icons.history, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, 'alert');
            },
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Builder(
              builder: (context) {
                final carrito = CarritoGlobal().productos;
                if (carrito.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(width: double.maxFinite),
                      SizedBox(height: 30),
                      SizedBox(
                        child: Text(
                          "Tu carrito de compras",
                          style: AppTextStyles.h1.copyWith(
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          color: Colors.blue.shade50,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "---------------------------",
                                  style: AppTextStyles.h3.copyWith(
                                    color: Colors.blue.shade800,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  "No haz agregado productos a tu carrito de compras",
                                  style: AppTextStyles.h3.copyWith(
                                    color: Colors.blue.shade800,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  "---------------------------",
                                  style: AppTextStyles.h3.copyWith(
                                    color: Colors.blue.shade800,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                    ],
                  );
                }

                return Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: carrito.length,
                    itemBuilder: (context, index) {
                      final producto = carrito[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage: producto["imagen"] != null
                              ? AssetImage(producto["imagen"]) as ImageProvider
                              : null,
                        ),
                        title: Text(producto["nombre"]),
                        subtitle: producto['fecha'] != null
                            ? Text(
                                DateFormat('dd/MM/yyyy HH:mm').format(
                                  DateTime.parse(producto['fecha']).toLocal(),
                                ),
                              )
                            : null,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (producto['qrData'] != null ||
                                producto['confirmed'] == true)
                              IconButton(
                                icon: const Icon(
                                  Icons.qr_code,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  final fecha = producto['fecha'] ?? '';
                                  Navigator.pushNamed(
                                    context,
                                    'qr',
                                    arguments: {
                                      'producto': producto['nombre'],
                                      'fecha': fecha,
                                    },
                                  );
                                },
                              ),
                            Text("S/ ${producto["precio"]}"),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                CarritoGlobal().eliminar(index);
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            //const Text("Al ingresar aceptas los ''Terminos y Condiciones''", style: TextStyle(fontSize: 14,)),
            SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        backgroundColor: const Color.fromARGB(255, 22, 119, 199),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, "user");
              break;
            case 1:
              Navigator.pushReplacementNamed(context, "principal");
              break;
            case 2:
              Navigator.pushReplacementNamed(context, "shop_cart");
              break;
            default:
          }
          // Aquí puedes navegar a otras páginas si lo deseas
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Usuario'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Tienda'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Carrito',
          ),
        ],
      ),
    );
  }
}
