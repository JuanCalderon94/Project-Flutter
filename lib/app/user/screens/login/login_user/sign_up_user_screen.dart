import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/styles/input_styles.dart';
import 'package:flutter_application_1/core/styles/text_styles.dart';
import 'package:flutter_application_1/core/validators/login_validators.dart';

class SignUpUserScreen extends StatefulWidget {
  const SignUpUserScreen({super.key});

  @override
  State<SignUpUserScreen> createState() => _SignUpUserScreenState();
}

class _SignUpUserScreenState extends State<SignUpUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _dniController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
// Activado por defecto para "Registrarse"

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _lastnameController.dispose();
    _dniController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirma tu contraseña';
    }
    if (value != _passwordController.text) {
      return 'Las contraseñas no coinciden';
    }
    return null;
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
                    SizedBox(width: double.maxFinite,),
                    Hero(
                      tag: "logo",
                      child: Image.asset("assets/img/image.png", width: 100,)
                    ),
                    SizedBox(height: 10),
                    Text("Usuario", style: AppTextStyles.h1),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                          child: Text(
                            'Iniciar sesión',
                            style: AppTextStyles.h2,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, "login");
                          },
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
                            'Registrarse',
                            style: AppTextStyles.h2Invert,
                          ),
                          onPressed: () {
                            // Ya estás en la pantalla de registro, no hace nada
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
                    SizedBox(height: 12,),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: _nameController,
                        decoration: AppInputStyles.defaultInput(
                          label: "Nombres",
                          isPassword: false,
                          obscureText: false,
                          onToggleObscure: null,
                          suffix: null,
                        ),
                        validator: (value) =>
                          value == null || value.isEmpty ? 'Ingresa tus nombres' : null,
                      ),
                    ),
                    SizedBox(height: 12,),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: _lastnameController,
                        decoration: AppInputStyles.defaultInput(
                          label: "Apellidos",
                          isPassword: false,
                          obscureText: false,
                          onToggleObscure: null,
                          suffix: null,
                        ),
                        validator: (value) =>
                          value == null || value.isEmpty ? 'Ingresa tus apellidos' : null,
                      ),
                    ),
                    SizedBox(height: 12,),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: _dniController,
                        decoration: AppInputStyles.defaultInput(
                          label: "DNI",
                          isPassword: false,
                          obscureText: false,
                          onToggleObscure: null,
                          suffix: null,
                        ),
                        validator: (value) =>
                          value == null || value.isEmpty ? 'Ingresa tu DNI' : null,
                      ),
                    ),
                    SizedBox(height: 12,),
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
                    SizedBox(height: 12,),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        obscuringCharacter: '*',
                        decoration: AppInputStyles.defaultInput(
                          label: "Confirmar Contraseña",
                          isPassword: true,
                          obscureText: _obscureConfirmPassword,
                          onToggleObscure: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
                            });
                          },
                          suffix: null, 
                        ),
                        validator: _confirmPasswordValidator,
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
                            Navigator.pushNamed(context, "login");
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Crear cuenta"),
                            SizedBox(width: 6,),
                            Icon(Icons.login),
                          ],
                        )
                      ),
                    ),
                    SizedBox(height: 10,),
                  ],
                ),
              ),
            ),
            const Text("Al ingresar aceptas los ''Terminos y Condiciones''", style: TextStyle(fontSize: 16)),
            SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}