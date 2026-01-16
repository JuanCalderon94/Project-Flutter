import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/styles/text_styles.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  int selectedCategory = 0;
  int _selectedIndex = 0; // Asegúrate de que este valor sea siempre 0, 1 o 2

  // Placeholder user data
  final String userName = "Juan Pérez";
  final String userEmail = "juan.perez@example.com";
  final String userDNI = "12345678";
  final String profileImageUrl = "assets/img/user_profile.png";

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
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(width: double.maxFinite),
                SizedBox(height: 20),

                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color.fromARGB(
                        255,
                        57,
                        64,
                        70,
                      ), // Color del borde
                      width: 1.0, // Grosor del borde
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(profileImageUrl),
                    backgroundColor: Colors.grey[200],

                    child: profileImageUrl.isEmpty
                        ? Icon(
                            Icons.person,
                            size: 60,
                            color: const Color.fromARGB(255, 98, 99, 156),
                          )
                        : null,
                  ),
                ),
                SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Card(
                    elevation: 5, // Adds a shadow to the card
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        15,
                      ), // Rounded corners for the card
                    ),
                    color: Colors
                        .blue
                        .shade50, // Light blue background for the card
                    child: Padding(
                      padding: const EdgeInsets.all(
                        20.0,
                      ), // Padding inside the card
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // Align text to the start
                        children: [
                          Text(
                            "Nombre: $userName",
                            style: AppTextStyles.h2.copyWith(
                              color: Colors.blue.shade800,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Correo: $userEmail",
                            style: AppTextStyles.h2.copyWith(
                              color: Colors.blue.shade800,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "DNI: $userDNI",
                            style: AppTextStyles.h2.copyWith(
                              color: Colors.blue.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20), // More space before the button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 22, 119, 199),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, "alert").then((_) {
                      setState(() {
                        _selectedIndex = 0;
                      });
                    });
                  },
                  child: Text(
                    "Pedidos realizados",
                    style: AppTextStyles.h2Invert,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7DB6F5),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, "metodo_pago_user");
                  },
                  child: const Text("Métodos de Pago"),
                ),
              ],
            ),
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
