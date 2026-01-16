class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingrese su correo';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Correo no válido';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingrese su contraseña';
    }
    return null;
  }
}