import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/styles/input_styles.dart';
import 'package:flutter_application_1/core/styles/nav_bar_styles.dart';
import 'package:flutter_application_1/app/data/carrito_global.dart';
import 'package:flutter_application_1/core/config.dart';
import 'package:flutter_application_1/models/product.dart';
import 'package:flutter_application_1/services/api.dart';

class PrincipalMain extends StatefulWidget {
  const PrincipalMain({super.key});

  @override
  State<PrincipalMain> createState() => _PrincipalMainState();
}

class _PrincipalMainState extends State<PrincipalMain> {
  int selectedCategory = 0;
  int _selectedIndex = 1;
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = fetchProducts(baseUrl: kApiBaseUrl);
  }

  List<String> _categoriesFromProducts(List<Product> products) {
    final set = {'Todos', ...products.map((p) => p.categoria ?? 'General')};
    return set.toList();
  }

  List<Product> _filteredProducts(
      List<Product> products, List<String> categories) {
    if (selectedCategory == 0) return products;
    return products
        .where((p) => (p.categoria ?? 'General') == categories[selectedCategory])
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmall = screenWidth < 700;
    final crossAxisCount = isSmall ? 2 : (screenWidth < 1100 ? 3 : 4);
    final childAspectRatio = isSmall ? 0.75 : 0.85;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 110,
        leadingWidth: 50,
        title: Hero(
          tag: 'logo',
          child: Image.asset('assets/img/image.png', width: isSmall ? 72 : 110),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: screenWidth < 700 ? double.infinity : 550,
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: AppInputStyles.defaultInput(
                    label: '¿Que desea comprar?',
                    isPassword: false,
                    obscureText: false,
                    onToggleObscure: null,
                    suffix: const Icon(Icons.search, color: Colors.grey),
                  ),
                ),
              ),
            ),
            // Product grid
            Expanded(
              child: FutureBuilder<List<Product>>(
                future: _productsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Error al cargar productos',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${snapshot.error}',
                              style: const TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _productsFuture = fetchProducts(
                                    baseUrl: kApiBaseUrl,
                                  );
                                });
                              },
                              child: const Text('Reintentar'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  final products = snapshot.data ?? [];
                  final categories = _categoriesFromProducts(products);
                  if (selectedCategory >= categories.length) {
                    selectedCategory = 0;
                  }
                  final filtered = _filteredProducts(products, categories);

                  return Column(
                    children: [
                      AppCategoryBar.categoryFilterBar(
                        categories: categories,
                        selected: selectedCategory,
                        onSelected: (index) =>
                            setState(() => selectedCategory = index),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: childAspectRatio,
                          ),
                          itemCount: filtered.length,
                          itemBuilder: (context, idx) {
                            final product = filtered[idx];
                            final image = product.imagenUrl;
                            final descripcion =
                                product.descripcion ?? 'Sin descripción';
                            final categoria = product.categoria ?? 'General';
                            return Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: image != null && image.isNotEmpty
                                            ? Image.network(
                                                image,
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Container(
                                                    color: Colors.grey[300],
                                                    child:
                                                        const Icon(Icons.image),
                                                  );
                                                },
                                              )
                                            : Container(
                                                color: Colors.grey[300],
                                                child: const Icon(Icons.image),
                                              ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      product.nombre,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      descripcion,
                                      style: const TextStyle(fontSize: 12),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'S/${product.precio.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 22, 119, 199),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            final carrito = CarritoGlobal();
                                            carrito.agregar({
                                              'nombre': product.nombre,
                                              'precio': product.precio,
                                              'descripcion': descripcion,
                                              'categoria': categoria,
                                              'imagen': image,
                                            });
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  '${product.nombre} agregado al carrito',
                                                ),
                                                duration:
                                                    const Duration(seconds: 2),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                              255,
                                              22,
                                              119,
                                              199,
                                            ),
                                            foregroundColor: Colors.white,
                                            minimumSize: const Size(120, 36),
                                          ),
                                          child: const Text('Agregar'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
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
              Navigator.pushReplacementNamed(context, 'user');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, 'principal');
              break;
            case 2:
              Navigator.pushNamed(context, 'carrito');
              break;
            default:
          }
        },
        items: const [
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
