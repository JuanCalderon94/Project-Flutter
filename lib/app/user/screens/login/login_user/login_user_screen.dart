import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/data/carrito_global.dart';
import 'package:flutter_application_1/core/styles/input_styles.dart';
import 'package:flutter_application_1/core/styles/text_styles.dart';
import 'package:flutter_application_1/core/validators/login_validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  // Estado inicial

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(width: double.maxFinite),
                    Hero(
                      tag: "logo",
                      child: Image.asset("assets/img/image.png", width: 100),
                    ),
                    SizedBox(height: 20),
                    Text("Usuario", style: AppTextStyles.h1),

                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
                            'Iniciar sesión',
                            style: AppTextStyles.h2Invert,
                          ),
                          onPressed: () {
                            // Ya estás en la pantalla de login, no hace nada
                          },
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                          child: Text('Registrarse', style: AppTextStyles.h2),
                          onPressed: () {
                            Navigator.pushNamed(context, "signup");
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: AppInputStyles.defaultInput(
                          label: "Correo electronico",
                          isPassword: false,
                          obscureText: false,
                          onToggleObscure: null,
                          suffix: null,
                        ),
                        validator: Validators.email,
                      ),
                    ),
                    SizedBox(height: 12),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        obscuringCharacter: '*',
                        decoration: AppInputStyles.defaultInput(
                          label: "Contraseña",
                          isPassword: true,
                          obscureText: _obscurePassword,
                          onToggleObscure: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          suffix: null,
                        ),
                        validator: Validators.password,
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: 200.0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (CarritoGlobal().isFromCart) {
                              CarritoGlobal().isFromCart = false;
                              Navigator.pushNamed(context, "carrito");
                            } else {
                              Navigator.pushNamed(context, "principal");
                            }
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Ingresar", style: AppTextStyles.h2Invert),
                            SizedBox(width: 6),
                            Icon(Icons.login),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
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
}
