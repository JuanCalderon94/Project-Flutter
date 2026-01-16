import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/styles/text_styles.dart';

class SelectScreen extends StatefulWidget {
  const SelectScreen({super.key});

  @override
  State<SelectScreen> createState() => _SelectScreenState();
}

class _SelectScreenState extends State<SelectScreen> {
  int repeticiones = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(width: double.maxFinite),
                  Hero(
                    tag: "logo",
                    child: Image.asset("assets/img/image.png", width: 150),
                  ),
                  SizedBox(height: 10),
                  Text("¡Bienvenido(a)!", style: AppTextStyles.h1),
                  SizedBox(height: 10),
                  Text(
                    "Seleccione un tipo de usuario",
                    style: AppTextStyles.h2,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, "login");
                    },
                    child: Text("USUARIO", style: AppTextStyles.h2Invert),
                  ),
                  SizedBox(height: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, "principal");
                    },
                    child: Text("VISITANTE", style: AppTextStyles.h2Invert),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent, // Fondo transparente
                      elevation: 0, // Elimina la elevación
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        "login_admin", // Reemplaza OtraPagina con tu widget de destino
                      );
                    },
                    child: Text(
                      "Soy administrador",
                      style: TextStyle(fontSize: 20, fontFamily: "Courier"),
                    ),
                  ),

                  //ElevatedButton(onPressed: onPressed, child: child),
                  //Expanded(child: SizedBox(),),
                ],
              ),
            ),
            const Text(
              "Al ingresar aceptas los ''Terminos y Condiciones''",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void listpkmn() {
    repeticiones++;
  }
}
