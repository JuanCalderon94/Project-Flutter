import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/styles/input_styles.dart';
import 'package:flutter_application_1/core/styles/text_styles.dart';
import 'package:flutter_application_1/core/validators/login_validators.dart';

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({super.key});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(width: double.maxFinite,),
                  Hero(
                    tag: "logo",
                    child: Image.asset("assets/img/image.png", width: 150,)
                    ),
                  SizedBox(height: 20),
                  Text("Recuperar Contraseña", style: AppTextStyles.h1),
                  SizedBox(height: 10),
                  Text("Ingrese un correo registrado:", style: AppTextStyles.h2),
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
                  SizedBox(height: 20),
                  
                  SizedBox(
                      width: 300.0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.pushNamed(context, "principal");
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Enviar correo de recuperación"),
                            SizedBox(width: 6,),
                            Icon(Icons.login),
                          ],
                        )
                      ),
                    ),
                ],
              ),
            ),
          const Text("Al ingresar aceptas los ''Terminos y Condiciones''", style: TextStyle(fontSize: 14,)),
          SizedBox(height: 20)
          ],
          
        ),
      ),

    );
  }
}