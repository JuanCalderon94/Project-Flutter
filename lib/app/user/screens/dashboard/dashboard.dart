import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// ==================== MODELOS ====================
class AdminProduct {
  String id;
  String nombre;
  double precio;
  String categoria;
  int stock;
  String imagen;

  AdminProduct({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.categoria,
    required this.stock,
    required this.imagen,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'nombre': nombre,
    'precio': precio,
    'categoria': categoria,
    'stock': stock,
    'imagen': imagen,
  };

  factory AdminProduct.fromMap(Map<String, dynamic> map) => AdminProduct(
    id: map['id'] ?? '',
    nombre: map['nombre'] ?? '',
    precio: (map['precio'] ?? 0).toDouble(),
    categoria: map['categoria'] ?? '',
    stock: map['stock'] ?? 0,
    imagen: map['imagen'] ?? '',
  );
}

class AdminOrder {
  String id;
  String clienteNombre;
  String clienteEmail;
  double total;
  String fecha;
  String estado; // pending, processing, completed, cancelled
  List<dynamic> items;

  AdminOrder({
    required this.id,
    required this.clienteNombre,
    required this.clienteEmail,
    required this.total,
    required this.fecha,
    required this.estado,
    required this.items,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'clienteNombre': clienteNombre,
    'clienteEmail': clienteEmail,
    'total': total,
    'fecha': fecha,
    'estado': estado,
    'items': items,
  };

  factory AdminOrder.fromMap(Map<String, dynamic> map) => AdminOrder(
    id: map['id'] ?? '',
    clienteNombre: map['clienteNombre'] ?? '',
    clienteEmail: map['clienteEmail'] ?? '',
    total: (map['total'] ?? 0).toDouble(),
    fecha: map['fecha'] ?? '',
    estado: map['estado'] ?? 'pending',
    items: map['items'] ?? [],
  );
}

// ==================== ADMIN DASHBOARD ====================
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedTab =
      0; // 0: Home, 1: Análisis, 2: Pendientes, 3: Notificaciones, 4: Productos, 5: Pedidos, 6: Inventario, 7: Usuarios, 8: Reportes
  List<AdminProduct> _products = [];
  List<AdminOrder> _orders = [];
  List<Map<String, dynamic>> _customers = [];
  bool _isLoading = true;
  bool _sidebarExpanded = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    // Cargar productos
    final productsJson = prefs.getString('admin_products');
    if (productsJson != null) {
      final list = jsonDecode(productsJson) as List;
      _products = list
          .map((e) => AdminProduct.fromMap(e as Map<String, dynamic>))
          .toList();
    } else {
      // Datos de ejemplo
      _products = [
        AdminProduct(
          id: '1',
          nombre: 'Mouse Gamer X',
          precio: 45.0,
          categoria: 'Mouse',
          stock: 50,
          imagen: 'assets/img/image.png',
        ),
        AdminProduct(
          id: '2',
          nombre: 'Teclado Mecánico',
          precio: 75.0,
          categoria: 'Teclados',
          stock: 30,
          imagen: 'assets/img/image.png',
        ),
      ];
      await _saveProducts();
    }

    // Cargar pedidos
    final ordersJson = prefs.getString('admin_orders');
    if (ordersJson != null) {
      final list = jsonDecode(ordersJson) as List;
      _orders = list
          .map((e) => AdminOrder.fromMap(e as Map<String, dynamic>))
          .toList();
    }

    // Cargar clientes desde purchases
    final purchasesJson = prefs.getString('purchases');
    if (purchasesJson != null) {
      final purchases = jsonDecode(purchasesJson) as List;
      _customers = purchases.cast<Map<String, dynamic>>();
    }

    setState(() => _isLoading = false);
  }

  Future<void> _saveProducts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'admin_products',
      jsonEncode(_products.map((p) => p.toMap()).toList()),
    );
  }

  Future<void> _saveOrders() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'admin_orders',
      jsonEncode(_orders.map((o) => o.toMap()).toList()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFE6F0FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7DB6F5),
        title: const Text(
          'Panel de Administración',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: Row(
        children: [
          // Sidebar (expandable)
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: _sidebarExpanded ? 250 : 72,
            color: const Color(0xFFB3D3F2),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: _sidebarExpanded
                            ? const Text(
                                'CDTECH Admin',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2B4C6F),
                                ),
                              )
                            : const Icon(
                                Icons.settings,
                                color: Color(0xFF2B4C6F),
                              ),
                      ),
                      IconButton(
                        icon: Icon(
                          _sidebarExpanded ? Icons.arrow_back_ios : Icons.menu,
                          color: const Color(0xFF2B4C6F),
                        ),
                        onPressed: () => setState(
                          () => _sidebarExpanded = !_sidebarExpanded,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildSidebarItem(0, Icons.dashboard, 'Dashboard'),
                  _buildSidebarItem(1, Icons.show_chart, 'Análisis de ventas'),
                  _buildSidebarItem(2, Icons.list_alt, 'Lista de pendientes'),
                  _buildSidebarItem(3, Icons.notifications, 'Notificaciones'),
                  _buildSidebarItem(4, Icons.inventory_2, 'Productos'),
                  _buildSidebarItem(5, Icons.shopping_cart, 'Pedidos'),
                  _buildSidebarItem(6, Icons.store, 'Inventario'),
                  _buildSidebarItem(7, Icons.people, 'Usuarios'),
                  _buildSidebarItem(8, Icons.assessment, 'Reportes'),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: _sidebarExpanded
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[400],
                              minimumSize: const Size(double.infinity, 44),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'Cerrar Sesión',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : SizedBox(
                            width: 48,
                            height: 44,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[400],
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: () => Navigator.pop(context),
                              child: const Icon(
                                Icons.logout,
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          // Contenido principal
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(int index, IconData icon, String label) {
    final isSelected = _selectedTab == index;
    if (_sidebarExpanded) {
      return Container(
        color: isSelected ? Colors.white.withOpacity(0.3) : Colors.transparent,
        child: ListTile(
          leading: Icon(icon, color: const Color(0xFF2B4C6F)),
          title: Text(
            label,
            style: TextStyle(
              color: const Color(0xFF2B4C6F),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          onTap: () => setState(() => _selectedTab = index),
        ),
      );
    }

    // Collapsed: show icon-only button with tooltip
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white.withOpacity(0.3) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Tooltip(
        message: label,
        child: InkWell(
          onTap: () => setState(() => _selectedTab = index),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Icon(icon, color: const Color(0xFF2B4C6F)),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedTab) {
      case 0:
        return _buildDashboard();
      case 1:
        return _buildAnalysisTab();
      case 2:
        return _buildPendingListTab();
      case 3:
        return _buildNotificationsTab();
      case 4:
        return _buildProductsTab();
      case 5:
        return _buildOrdersTab();
      case 6:
        return _buildInventoryTab();
      case 7:
        return _buildUsersTab();
      case 8:
        return _buildReportsTab();
      default:
        return const Center(child: Text('Sección no disponible'));
    }
  }

  // ==================== ANÁLISIS DE VENTAS ====================
  Widget _buildAnalysisTab() {
    final totalRevenue = _orders.fold<double>(0, (s, o) => s + o.total);
    final ordersCount = _orders.length;
    final avgTicket = ordersCount == 0 ? 0.0 : totalRevenue / ordersCount;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Análisis de Ventas',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2B4C6F),
            ),
          ),
          const SizedBox(height: 24),
          GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildStatCard(
                'Ingresos',
                'S/. ${totalRevenue.toStringAsFixed(2)}',
                Icons.attach_money,
                Colors.green,
              ),
              _buildStatCard(
                'Órdenes',
                ordersCount.toString(),
                Icons.shopping_bag,
                Colors.blue,
              ),
              _buildStatCard(
                'Ticket Promedio',
                'S/. ${avgTicket.toStringAsFixed(2)}',
                Icons.pie_chart,
                Colors.orange,
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Últimos 10 pedidos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2B4C6F),
            ),
          ),
          const SizedBox(height: 12),
          _buildOrdersTable(_orders.reversed.take(10).toList()),
        ],
      ),
    );
  }

  // ==================== LISTA DE PENDIENTES ====================
  Widget _buildPendingListTab() {
    final pending = _orders.where((o) => o.estado == 'pending').toList();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lista de pendientes',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2B4C6F),
            ),
          ),
          const SizedBox(height: 16),
          pending.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('No hay pendientes'),
                )
              : _buildOrdersTable(pending),
        ],
      ),
    );
  }

  // ==================== NOTIFICACIONES ====================
  Widget _buildNotificationsTab() {
    final notifications = [
      {
        'title': 'Stock bajo',
        'body': 'El producto Teclado Mecánico está bajo en stock.',
      },
      {
        'title': 'Nuevo pedido',
        'body': 'Se ha generado un nuevo pedido desde la tienda web.',
      },
      {
        'title': 'Backup diario',
        'body': 'Copia de seguridad completada correctamente.',
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Notificaciones y alertas',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2B4C6F),
            ),
          ),
          const SizedBox(height: 16),
          ...notifications.map(
            (n) => Card(
              child: ListTile(
                leading: const Icon(
                  Icons.notification_important,
                  color: Colors.orange,
                ),
                title: Text(n['title']!),
                subtitle: Text(n['body']!),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== INVENTARIO ====================
  Widget _buildInventoryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gestión de Inventario',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2B4C6F),
            ),
          ),
          const SizedBox(height: 16),
          if (_products.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text('No hay productos'),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Nombre')),
                  DataColumn(label: Text('Stock')),
                  DataColumn(label: Text('Acciones')),
                ],
                rows: _products.map((p) {
                  return DataRow(
                    cells: [
                      DataCell(Text(p.id)),
                      DataCell(Text(p.nombre)),
                      DataCell(Text(p.stock.toString())),
                      DataCell(
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                p.stock += 10;
                                setState(() {});
                                await _saveProducts();
                              },
                              child: const Text('Reabastecer'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                              ),
                              onPressed: () async {
                                p.stock = 0;
                                setState(() {});
                                await _saveProducts();
                              },
                              child: const Text('Marcar Agotado'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  // ==================== USUARIOS ====================
  Widget _buildUsersTab() {
    // Usamos _customers como fuente simple de usuarios (email o id)
    final users = <String, Map<String, dynamic>>{};
    for (final purchase in _customers) {
      final user = purchase['user'] ?? purchase['email'] ?? 'anonymous';
      users.putIfAbsent(user, () => {'user': user, 'visits': 0});
      users[user]!['visits'] = (users[user]!['visits'] as int) + 1;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Usuarios',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2B4C6F),
            ),
          ),
          const SizedBox(height: 16),
          if (users.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text('No hay usuarios'),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Usuario')),
                  DataColumn(label: Text('Visitas/Compras')),
                ],
                rows: users.values.map((u) {
                  return DataRow(
                    cells: [
                      DataCell(Text(u['user'] as String)),
                      DataCell(Text((u['visits'] as int).toString())),
                    ],
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  // ==================== DASHBOARD HOME ====================
  Widget _buildDashboard() {
    final totalProducts = _products.length;
    final totalOrders = _orders.length;
    final totalCustomers = _customers.length;
    final totalRevenue = _orders.fold<double>(
      0,
      (sum, order) => sum + order.total,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resumen General',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2B4C6F),
            ),
          ),
          const SizedBox(height: 24),
          GridView.count(
            crossAxisCount: 4,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildStatCard(
                'Productos',
                totalProducts.toString(),
                Icons.inventory_2,
                Colors.blue,
              ),
              _buildStatCard(
                'Pedidos',
                totalOrders.toString(),
                Icons.shopping_cart,
                Colors.green,
              ),
              _buildStatCard(
                'Clientes',
                totalCustomers.toString(),
                Icons.people,
                Colors.orange,
              ),
              _buildStatCard(
                'Ingresos',
                'S/. ${totalRevenue.toStringAsFixed(2)}',
                Icons.attach_money,
                Colors.purple,
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            'Últimos Pedidos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2B4C6F),
            ),
          ),
          const SizedBox(height: 16),
          _buildOrdersTable(_orders.take(5).toList()),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2B4C6F),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== GESTIÓN DE PRODUCTOS ====================
  Widget _buildProductsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Gestión de Productos',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2B4C6F),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddProductDialog(),
                icon: const Icon(Icons.add),
                label: const Text('Nuevo Producto'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A6DFF),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildProductsTable(),
        ],
      ),
    );
  }

  Widget _buildProductsTable() {
    if (_products.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text('No hay productos registrados'),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('ID')),
          DataColumn(label: Text('Nombre')),
          DataColumn(label: Text('Categoría')),
          DataColumn(label: Text('Precio')),
          DataColumn(label: Text('Stock')),
          DataColumn(label: Text('Acciones')),
        ],
        rows: _products.map((product) {
          return DataRow(
            cells: [
              DataCell(Text(product.id)),
              DataCell(Text(product.nombre)),
              DataCell(Text(product.categoria)),
              DataCell(Text('S/. ${product.precio.toStringAsFixed(2)}')),
              DataCell(Text(product.stock.toString())),
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showEditProductDialog(product),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteProduct(product.id),
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  void _showAddProductDialog() {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final categoryCtrl = TextEditingController();
    final stockCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nuevo Producto'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: categoryCtrl,
                decoration: const InputDecoration(labelText: 'Categoría'),
              ),
              TextField(
                controller: priceCtrl,
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: stockCtrl,
                decoration: const InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newProduct = AdminProduct(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                nombre: nameCtrl.text,
                precio: double.tryParse(priceCtrl.text) ?? 0,
                categoria: categoryCtrl.text,
                stock: int.tryParse(stockCtrl.text) ?? 0,
                imagen: 'assets/img/image.png',
              );
              setState(() => _products.add(newProduct));
              await _saveProducts();
              if (mounted) Navigator.pop(ctx);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _showEditProductDialog(AdminProduct product) {
    final nameCtrl = TextEditingController(text: product.nombre);
    final priceCtrl = TextEditingController(text: product.precio.toString());
    final categoryCtrl = TextEditingController(text: product.categoria);
    final stockCtrl = TextEditingController(text: product.stock.toString());

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Editar Producto'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: categoryCtrl,
                decoration: const InputDecoration(labelText: 'Categoría'),
              ),
              TextField(
                controller: priceCtrl,
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: stockCtrl,
                decoration: const InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final index = _products.indexWhere((p) => p.id == product.id);
              _products[index] = AdminProduct(
                id: product.id,
                nombre: nameCtrl.text,
                precio: double.tryParse(priceCtrl.text) ?? 0,
                categoria: categoryCtrl.text,
                stock: int.tryParse(stockCtrl.text) ?? 0,
                imagen: product.imagen,
              );
              setState(() {});
              await _saveProducts();
              if (mounted) Navigator.pop(ctx);
            },
            child: const Text('Guardar Cambios'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteProduct(String id) async {
    _products.removeWhere((p) => p.id == id);
    setState(() {});
    await _saveProducts();
  }

  // ==================== GESTIÓN DE PEDIDOS ====================
  Widget _buildOrdersTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gestión de Pedidos',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2B4C6F),
            ),
          ),
          const SizedBox(height: 24),
          _buildOrdersTable(_orders),
        ],
      ),
    );
  }

  Widget _buildOrdersTable(List<AdminOrder> orders) {
    if (orders.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text('No hay pedidos registrados'),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('ID')),
          DataColumn(label: Text('Cliente')),
          DataColumn(label: Text('Email')),
          DataColumn(label: Text('Total')),
          DataColumn(label: Text('Fecha')),
          DataColumn(label: Text('Estado')),
          DataColumn(label: Text('Acciones')),
        ],
        rows: orders.map((order) {
          return DataRow(
            cells: [
              DataCell(Text(order.id)),
              DataCell(Text(order.clienteNombre)),
              DataCell(Text(order.clienteEmail)),
              DataCell(Text('S/. ${order.total.toStringAsFixed(2)}')),
              DataCell(Text(order.fecha)),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.estado),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    order.estado,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
              DataCell(
                PopupMenuButton(
                  itemBuilder: (ctx) => [
                    PopupMenuItem(
                      child: const Text('Pendiente'),
                      onTap: () => _updateOrderStatus(order.id, 'pending'),
                    ),
                    PopupMenuItem(
                      child: const Text('Procesando'),
                      onTap: () => _updateOrderStatus(order.id, 'processing'),
                    ),
                    PopupMenuItem(
                      child: const Text('Completado'),
                      onTap: () => _updateOrderStatus(order.id, 'completed'),
                    ),
                    PopupMenuItem(
                      child: const Text('Cancelado'),
                      onTap: () => _updateOrderStatus(order.id, 'cancelled'),
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'processing':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> _updateOrderStatus(String orderId, String newStatus) async {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index >= 0) {
      _orders[index].estado = newStatus;
      setState(() {});
      await _saveOrders();
    }
  }

  // ==================== REPORTES ====================
  Widget _buildReportsTab() {
    final totalRevenue = _orders.fold<double>(
      0,
      (sum, order) => sum + order.total,
    );
    final averageOrderValue = _orders.isEmpty
        ? 0.0
        : totalRevenue / _orders.length;
    final topProduct = _products.isNotEmpty
        ? _products.reduce((a, b) => a.stock > b.stock ? a : b)
        : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Reportes y Análisis',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2B4C6F),
            ),
          ),
          const SizedBox(height: 24),
          GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildReportCard(
                'Ingresos Totales',
                'S/. ${totalRevenue.toStringAsFixed(2)}',
                Colors.green,
              ),
              _buildReportCard(
                'Ticket Promedio',
                'S/. ${averageOrderValue.toStringAsFixed(2)}',
                Colors.blue,
              ),
              _buildReportCard(
                'Producto más en Stock',
                topProduct?.nombre ?? 'N/A',
                Colors.orange,
              ),
              _buildReportCard(
                'Total de Órdenes',
                _orders.length.toString(),
                Colors.purple,
              ),
              _buildReportCard(
                'Total de Clientes',
                _customers.length.toString(),
                Colors.red,
              ),
              _buildReportCard(
                'Total de Productos',
                _products.length.toString(),
                Colors.teal,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(String title, String value, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.8), color.withOpacity(0.3)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
