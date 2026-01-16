import 'package:flutter/material.dart';

enum DashboardSection {
  dashboard,
  analisisVentas,
  listaPendientes,
  notificaciones,
  pedidos,
  ventas,
  productos,
  usuarios,
  listaUsuarios,
}

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  DashboardSection _selectedSection = DashboardSection.dashboard;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmall = screenWidth < 900;

    Widget sideMenu = Container(
      width: 260,
      color: const Color(0xFFB3D3F2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          // Logo y nombre
          Row(
            children: [
              const SizedBox(width: 16),
              Image.asset("assets/img/image.png", width: 40),
              const SizedBox(width: 12),
              const Text(
                "CDTECH",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFF2B4C6F),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Perfil
          Row(
            children: [
              const SizedBox(width: 16),
              CircleAvatar(
                backgroundImage: AssetImage("assets/img/user_profile.png"),
                radius: 22,
              ),
              const SizedBox(width: 12),
              const Text(
                "Carlos Yepes",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Color(0xFF2B4C6F),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Menú
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _MenuButton(
                  text: "Dashboard",
                  selected: _selectedSection == DashboardSection.dashboard,
                  icon: Icons.dashboard,
                  onTap: () => setState(
                    () => _selectedSection = DashboardSection.dashboard,
                  ),
                ),
                const SizedBox(height: 16),
                _MenuButton(
                  text: "Análisis de ventas",
                  selected: _selectedSection == DashboardSection.analisisVentas,
                  icon: Icons.show_chart,
                  onTap: () => setState(
                    () => _selectedSection = DashboardSection.analisisVentas,
                  ),
                ),
                _MenuButton(
                  text: "Lista de pendientes",
                  selected:
                      _selectedSection == DashboardSection.listaPendientes,
                  icon: Icons.list_alt,
                  onTap: () => setState(
                    () => _selectedSection = DashboardSection.listaPendientes,
                  ),
                ),
                _MenuButton(
                  text: "Notificaciones y alertas",
                  selected: _selectedSection == DashboardSection.notificaciones,
                  icon: Icons.notifications,
                  onTap: () => setState(
                    () => _selectedSection = DashboardSection.notificaciones,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  "Gestión de ventas",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2B4C6F),
                  ),
                ),
                _MenuButton(
                  text: "Pedidos",
                  selected: _selectedSection == DashboardSection.pedidos,
                  icon: Icons.shopping_cart,
                  onTap: () => setState(
                    () => _selectedSection = DashboardSection.pedidos,
                  ),
                ),
                _MenuButton(
                  text: "Ventas",
                  selected: _selectedSection == DashboardSection.ventas,
                  icon: Icons.attach_money,
                  onTap: () => setState(
                    () => _selectedSection = DashboardSection.ventas,
                  ),
                ),

                const SizedBox(height: 32),
                const Text(
                  "Gestión de Inventario",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2B4C6F),
                  ),
                ),
                _MenuButton(
                  text: "Productos",
                  selected: _selectedSection == DashboardSection.productos,
                  icon: Icons.inventory,
                  onTap: () => setState(
                    () => _selectedSection = DashboardSection.productos,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  "Usuarios",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2B4C6F),
                  ),
                ),
                _MenuButton(
                  text: "Lista de usuarios",
                  selected: _selectedSection == DashboardSection.listaUsuarios,
                  icon: Icons.people,
                  onTap: () => setState(
                    () => _selectedSection = DashboardSection.listaUsuarios,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    // For small screens use a Drawer; for large screens keep the side menu visible
    if (isSmall) {
      return Scaffold(
        backgroundColor: const Color(0xFFE6F0FA),
        appBar: AppBar(
          backgroundColor: const Color(0xFFB3D3F2),
          elevation: 0,
          centerTitle: false,
          titleSpacing: 0,
          title: const Text(
            'CDTECH',
            style: TextStyle(color: Color(0xFF2B4C6F), fontSize: 18),
          ),
          actions: [
            SizedBox(
              width: isSmall ? 40 : 48,
              child: IconButton(
                icon: const Icon(
                  Icons.notifications,
                  color: Color(0xFF2B4C6F),
                  size: 20,
                ),
                tooltip: 'Notificaciones',
                onPressed: () {},
                padding: EdgeInsets.zero,
              ),
            ),
            SizedBox(
              width: isSmall ? 40 : 48,
              child: IconButton(
                icon: const Icon(
                  Icons.smart_toy,
                  color: Color(0xFF2B4C6F),
                  size: 20,
                ),
                tooltip: 'Chatbot',
                onPressed: () {},
                padding: EdgeInsets.zero,
              ),
            ),
            SizedBox(
              width: isSmall ? 40 : 48,
              child: IconButton(
                icon: const Icon(
                  Icons.settings,
                  color: Color(0xFF2B4C6F),
                  size: 20,
                ),
                tooltip: 'Configuración',
                onPressed: () {},
                padding: EdgeInsets.zero,
              ),
            ),
            SizedBox(width: isSmall ? 4 : 8),
          ],
        ),
        drawer: Drawer(child: sideMenu),
        body: Column(
          children: [
            // Contenido dinámico
            Expanded(
              child: Container(
                color: Colors.transparent,
                child: _buildSection(_selectedSection),
              ),
            ),
          ],
        ),
      );
    }

    // Large screen layout with persistent side menu
    return Scaffold(
      backgroundColor: const Color(0xFFE6F0FA),
      body: Row(
        children: [
          if (!isSmall) sideMenu,
          Expanded(
            child: Column(
              children: [
                // Barra superior
                Container(
                  height: 60,
                  color: const Color(0xFFB3D3F2),
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmall ? 8.0 : 16.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (!isSmall)
                        const Padding(
                          padding: EdgeInsets.only(right: 16.0),
                          child: Text(
                            'Panel de Administración',
                            style: TextStyle(
                              color: Color(0xFF2B4C6F),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      const Spacer(),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: isSmall ? 40 : 48,
                            child: IconButton(
                              icon: const Icon(
                                Icons.smart_toy,
                                color: Color(0xFF2B4C6F),
                                size: 20,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              onPressed: () {},
                            ),
                          ),
                          SizedBox(width: isSmall ? 4 : 8),
                          SizedBox(
                            width: isSmall ? 40 : 48,
                            child: IconButton(
                              icon: const Icon(
                                Icons.notifications,
                                color: Color(0xFF2B4C6F),
                                size: 20,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              onPressed: () {},
                            ),
                          ),
                          SizedBox(width: isSmall ? 4 : 16),
                        ],
                      ),
                    ],
                  ),
                ),
                // Contenido dinámico
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.all(isSmall ? 8.0 : 16.0),
                      color: Colors.transparent,
                      child: _buildSection(_selectedSection),
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

  Widget _buildSection(DashboardSection section) {
    switch (section) {
      case DashboardSection.dashboard:
        return _DashboardHome();
      case DashboardSection.analisisVentas:
        return _AnalisisVentasSection();
      case DashboardSection.listaPendientes:
        return _ListaPendientesSection();
      case DashboardSection.notificaciones:
        return _NotificacionesSection();
      case DashboardSection.pedidos:
        return _PedidosSection();
      case DashboardSection.ventas:
        return _VentasSection();
      case DashboardSection.productos:
        return _ProductosSection();
      case DashboardSection.usuarios:
        return _PlaceholderSection("Usuarios");
      case DashboardSection.listaUsuarios:
        return _ListaUsuariosSection();
    }
  }
}

// Botón del menú lateral
class _MenuButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _MenuButton({
    required this.text,
    required this.icon,
    this.selected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFF2B4C6F) : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Row(
            children: [
              Icon(
                icon,
                color: selected ? Colors.white : const Color(0xFF2B4C6F),
              ),
              const SizedBox(width: 12),
              Text(
                text,
                style: TextStyle(
                  color: selected ? Colors.white : const Color(0xFF2B4C6F),
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Sección principal del dashboard (tarjetas y gráficos)
class _DashboardHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmall = screenWidth < 900;
    // Card width: on small screens two columns, on medium/large use fixed but slightly wider cards
    // Calcula el ancho de la tarjeta basado en el tamaño de la pantalla
    final cardWidth = isSmall
        ? (screenWidth - (32 + 8)) /
              2 // En móvil: 2 columnas con padding menor
        : (screenWidth < 1200)
        ? (screenWidth - (48 + 16)) /
              3 // En tablets: 3 columnas
        : (screenWidth - (64 + 24)) / 4; // En desktop: 4 columnas

    // Datos ficticios para gráficos y tablas
    final salesData = <double>[120, 150, 90, 200, 240, 180, 210]; // últimos 7
    final productCategories = {
      'Computadoras': 42,
      'Periféricos': 81,
      'Tinta': 35,
      'Almacenamiento': 28,
    };

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 12.0 : 24.0,
        vertical: isSmall ? 8.0 : 16.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Título y botón de actualización
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Panel Principal",
                style: TextStyle(
                  fontSize: isSmall ? 20 : 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2B4C6F),
                ),
              ),
              IconButton(
                icon: Icon(Icons.refresh, color: Color(0xFF2B4C6F)),
                onPressed: () {
                  // Aquí puedes agregar la lógica para actualizar los datos
                },
              ),
            ],
          ),
          SizedBox(height: isSmall ? 12 : 20),
          // Tarjetas resumen con layout responsivo
          Wrap(
            spacing: isSmall ? 8 : 16,
            runSpacing: isSmall ? 8 : 16,
            alignment: WrapAlignment.start,
            children: [
              _SummaryCard(
                color: Colors.purple[700]!,
                title: "Pedidos",
                value: "180",
                icon: Icons.shopping_cart,
                width: cardWidth,
              ),
              _SummaryCard(
                color: Colors.orange[700]!,
                title: "Ventas",
                value: "${salesData.reduce((a, b) => a + b).toInt()}",
                icon: Icons.attach_money,
                width: cardWidth,
              ),
              _SummaryCard(
                color: Colors.blue[700]!,
                title: "Inventario",
                value: "${productCategories.values.reduce((a, b) => a + b)}",
                icon: Icons.inventory,
                width: cardWidth,
              ),
              _SummaryCard(
                color: Colors.green[700]!,
                title: "Usuarios",
                value: "24",
                icon: Icons.people,
                width: cardWidth,
              ),
            ],
          ),
          SizedBox(height: isSmall ? 24 : 32),
          // Gráfico principal: gráfico de barras simple
          Container(
            constraints: BoxConstraints(
              minHeight: 220,
              maxHeight: isSmall ? 300 : 400,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Análisis de ventas (últimos 7) ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Expanded(child: _SalesBarChart(data: salesData)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Dos gráficos secundarios: en columna para mobile, en fila para desktop
          isSmall
              ? Column(
                  children: [
                    _smallBarChartCard(productCategories),
                    const SizedBox(height: 16),
                    _smallLineChartCard(salesData),
                  ],
                )
              : Row(
                  children: [
                    Expanded(child: _smallBarChartCard(productCategories)),
                    const SizedBox(width: 24),
                    Expanded(child: _smallLineChartCard(salesData)),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _smallBarChartCard(Map<String, int> categories) {
    return Container(
      constraints: const BoxConstraints(
        maxHeight: 140,
      ), // Altura máxima reducida
      padding: const EdgeInsets.all(6), // Padding reducido aún más
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize
            .max, // Ajustado para permitir que Expanded funcione correctamente
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Categorías de producto',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14, // Reducido el tamaño
            ),
          ),
          const SizedBox(height: 4), // Reducido el espaciado
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: categories.entries.map((e) {
                final maxVal = categories.values.fold<int>(
                  0,
                  (p, n) => n > p ? n : p,
                );
                final heightFactor = maxVal > 0 ? e.value / maxVal : 0.0;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4.0,
                    ), // Reducido el padding
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // Importante
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height:
                              4 +
                              (40 *
                                  heightFactor), // Reducida la altura base y el factor (ajustada para evitar overflow en pantallas pequeñas)
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(
                              4,
                            ), // Reducido el radio
                          ),
                        ),
                        const SizedBox(height: 4), // Reducido el espaciado
                        Text(
                          e.key,
                          textAlign: TextAlign.center,
                          maxLines: 1, // Limitar a una línea
                          overflow:
                              TextOverflow.ellipsis, // Mostrar ... si no cabe
                          style: const TextStyle(
                            fontSize: 10,
                          ), // Reducido el tamaño
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _smallLineChartCard(List<double> data) {
    return Container(
      height: 180,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tendencia de ventas',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: CustomPaint(painter: _LineChartPainter(data: data)),
          ),
        ],
      ),
    );
  }

  // end of _DashboardHome
}

// Simple bar chart widget used in main area
class _SalesBarChart extends StatelessWidget {
  final List<double> data;

  const _SalesBarChart({required this.data});

  @override
  Widget build(BuildContext context) {
    final maxValue = data.reduce((a, b) => a > b ? a : b);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: data.map((v) {
            final height = maxValue > 0
                ? (v / maxValue) *
                      (constraints.maxHeight - 30) // Increased padding
                : 0.0;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4.0,
                ), // Reduced horizontal padding
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Add this
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: height,
                      decoration: BoxDecoration(
                        color: Colors.lightGreen[700],
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 4), // Reduced vertical spacing
                    Text(
                      v.toInt().toString(),
                      style: const TextStyle(fontSize: 10), // Reduced font size
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

// Painter for a simple line chart
class _LineChartPainter extends CustomPainter {
  final List<double> data;
  _LineChartPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    final paint = Paint()
      ..color = Colors.deepPurple
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    final maxValue = data.reduce((a, b) => a > b ? a : b);
    final gap = size.width / (data.length - 1 == 0 ? 1 : (data.length - 1));
    final path = Path();
    for (int i = 0; i < data.length; i++) {
      final x = gap * i;
      final y =
          size.height -
          ((data[i] / (maxValue == 0 ? 1 : maxValue)) * size.height);
      if (i == 0)
        path.moveTo(x, y);
      else
        path.lineTo(x, y);
    }
    canvas.drawPath(path, paint);
    // draw points
    final pointPaint = Paint()..color = Colors.deepPurple;
    for (int i = 0; i < data.length; i++) {
      final x = gap * i;
      final y =
          size.height -
          ((data[i] / (maxValue == 0 ? 1 : maxValue)) * size.height);
      canvas.drawCircle(Offset(x, y), 3, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Tarjeta resumen
class _SummaryCard extends StatelessWidget {
  final Color color;
  final String title;
  final String value;
  final IconData icon;
  final double? width;

  const _SummaryCard({
    required this.color,
    required this.title,
    required this.value,
    required this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 140,
      height: 100,
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Secciones de ejemplo (puedes personalizar cada una)

class _AnalisisVentasSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final salesData = <double>[120, 150, 90, 200, 240, 180, 210];
    final topProducts = [
      ["1", "Laptop Gamer Pro", "1250.00", "230"],
      ["2", "Monitor 27\" 144Hz", "320.00", "180"],
      ["3", "RTX 3060", "399.00", "95"],
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Análisis de ventas',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            height: 260,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(12),
            child: _SalesBarChart(data: salesData),
          ),
          const SizedBox(height: 16),
          _SectionTable(
            title: 'Top productos vendidos',
            columns: const ["ID", "NOMBRE", "TOTAL (S/.)", "UNIDADES"],
            rows: topProducts,
            showActions: false,
          ),
        ],
      ),
    );
  }
}

class _ListaPendientesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _SectionTable(
      title: "Lista de pendientes",
      columns: const ["ID", "TIPO", "DESCRIPCION", "FECHA", "ESTADO"],
      rows: const [
        [
          "1",
          "Reparación",
          "Pantalla rota - Laptop 15\"",
          "01/10/2025",
          "PENDIENTE",
        ],
        [
          "2",
          "Pedido",
          "Envío retrasado - Orden #1234",
          "28/10/2025",
          "PENDIENTE",
        ],
      ],
      highlightColumn: 4,
      highlightColor: Colors.yellow,
      highlightValue: "PENDIENTE",
      showActions: true,
    );
  }
}

class _NotificacionesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        "title": "Stock bajo",
        "body": "Tinta EPSON azul por debajo del 10%",
        "time": "2h",
      },
      {
        "title": "Nuevo pedido",
        "body": "Orden #4523 ha sido creada",
        "time": "6h",
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0), // Reduced padding
      child: Column(
        mainAxisSize: MainAxisSize.min, // Add this
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Notificaciones',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ), // Reduced font size
          ),
          const SizedBox(height: 8), // Reduced spacing
          ...notifications.map(
            (n) => Padding(
              padding: const EdgeInsets.only(
                bottom: 8.0,
              ), // Add spacing between cards
              child: Card(
                margin: EdgeInsets.zero, // Remove card margin
                child: ListTile(
                  dense: true, // Make the list tile more compact
                  visualDensity:
                      VisualDensity.compact, // Make it even more compact
                  leading: const Icon(
                    Icons.notification_important,
                    color: Colors.orange,
                    size: 20, // Reduced icon size
                  ),
                  title: Text(
                    n['title']!,
                    style: const TextStyle(fontSize: 14), // Reduced font size
                  ),
                  subtitle: Text(
                    n['body']!,
                    style: const TextStyle(fontSize: 12), // Reduced font size
                  ),
                  trailing: Text(
                    n['time']!,
                    style: const TextStyle(fontSize: 12), // Reduced font size
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceholderSection extends StatelessWidget {
  final String title;
  const _PlaceholderSection(this.title);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(fontSize: 28, color: Colors.blueGrey),
      ),
    );
  }
}

// Ejemplo de sección de Pedidos
class _PedidosSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _SectionTable(
      title: "Gestión de pedidos",
      columns: const [
        "ID",
        "TOTAL(S/.)",
        "FECHA DE REGISTRO",
        "CLIENTE",
        "ESTADO",
        "INFO",
        "EDITAR",
        "ELIMINAR",
      ],
      rows: const [
        [
          "1",
          "89.00",
          "17/09/2025",
          "Sergio Lopez",
          "PENDIENTE",
          "🔍",
          "edit",
          "delete",
        ],
        [
          "2",
          "120.00",
          "12/09/2025",
          "Jose Aliaga",
          "PENDIENTE",
          "🔍",
          "edit",
          "delete",
        ],
      ],
      highlightColumn: 4,
      highlightColor: Colors.yellow,
      showActions: true,
    );
  }
}

// Ejemplo de sección de Ventas
class _VentasSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _SectionTable(
      title: "Gestión de ventas",
      columns: const [
        "ID",
        "TOTAL(S/.)",
        "FECHA DE REGISTRO",
        "CLIENTE",
        "INFO",
        "EDITAR",
        "ELIMINAR",
      ],
      rows: const [
        ["1", "65.00", "17/09/2025", "Usuario común", "🔍", "edit", "delete"],
      ],
      showActions: true,
    );
  }
}

// Ejemplo de sección de Productos
class _ProductosSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _SectionTable(
      title: "Gestión de productos",
      columns: const [
        "ID",
        "COSTO (UNID.)",
        "FECHA DE REGISTRO",
        "NOMBRE",
        "CATEGORIA",
        "INFO",
        "EDITAR",
        "ELIMINAR",
      ],
      rows: const [
        [
          "1",
          "59.99",
          "17/09/2025",
          "Intel Core i3",
          "PROCESADOR",
          "🔍",
          "edit",
          "delete",
        ],
        [
          "2",
          "39.99",
          "17/09/2025",
          "Tinta Azul EPSON",
          "TINTA",
          "🔍",
          "edit",
          "delete",
        ],
      ],
      highlightColumn: 4,
      highlightColor: Colors.yellow,
      showActions: true,
    );
  }
}

// Ejemplo de sección de Lista de Usuarios
class _ListaUsuariosSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _SectionTable(
      title: "Ventas pendientes",
      columns: const [
        "ID",
        "NOMBRE",
        "FECHA DE REGISTRO",
        "ROL",
        "INFO",
        "EDITAR",
        "ELIMINAR",
      ],
      rows: const [
        [
          "1",
          "Carlos Yepes",
          "123456789",
          "ADMINISTRADOR",
          "🔍",
          "edit",
          "delete",
        ],
        ["2", "Jose Aliaga", "1255444", "CLIENTE", "🔍", "edit", "delete"],
        ["3", "Sergio Lopez", "77777777", "CLIENTE", "🔍", "edit", "delete"],
        ["4", "Usuario común", "88888888", "CLIENTE", "🔍", "edit", "delete"],
      ],
      showActions: true,
    );
  }
}

// Widget para mostrar tablas de cada sección
class _SectionTable extends StatelessWidget {
  final String title;
  final List<String> columns;
  final List<List<String>> rows;
  final int? highlightColumn;
  final Color? highlightColor;
  final String? highlightValue;
  final bool showActions;

  const _SectionTable({
    required this.title,
    required this.columns,
    required this.rows,
    this.highlightColumn,
    this.highlightColor,
    this.highlightValue,
    this.showActions = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: columns.map((c) => DataColumn(label: Text(c))).toList(),
              rows: rows.map((row) {
                return DataRow(
                  cells: List.generate(row.length, (i) {
                    Color? cellColor;
                    if (highlightColumn != null && i == highlightColumn) {
                      if (highlightValue != null && row[i] == highlightValue) {
                        cellColor = highlightColor;
                      } else if (highlightValue == null) {
                        cellColor = highlightColor;
                      }
                    }
                    // Acciones
                    if (showActions &&
                        (row[i] == "edit" || row[i] == "delete")) {
                      return DataCell(
                        IconButton(
                          icon: Icon(
                            row[i] == "edit" ? Icons.edit : Icons.delete,
                            color: row[i] == "edit"
                                ? Colors.orange
                                : Colors.red,
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  row[i] == "edit" ? "Editar" : "Eliminar",
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                    return DataCell(
                      Container(
                        color: cellColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: Text(row[i]),
                      ),
                    );
                  }),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
