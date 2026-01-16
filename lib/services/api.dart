import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../core/config.dart';

Future<List<Product>> fetchProducts({required String baseUrl}) async {
  final endpoint = kProductosEndpoint;
  final fullUrl = '$baseUrl$endpoint';
  
  try {
    final uri = Uri.parse(fullUrl);
    final res = await http.get(uri);
    
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body) as List;
      return data
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList();
    } else if (res.statusCode == 404) {
      throw Exception(
        '❌ Ruta no encontrada (404)\n\n'
        '🔗 URL intentada: $fullUrl\n\n'
        '📋 Pasos para solucionar:\n'
        '1. Abre tu proyecto Laravel\n'
        '2. Ejecuta: php artisan route:list | findstr productos\n'
        '3. Copia la ruta exacta que aparece\n'
        '4. Ejecuta Flutter con:\n'
        '   flutter run -d chrome --dart-define=PRODUCTOS_ENDPOINT=/tu/ruta/aqui\n\n'
        '💡 Rutas comunes en Laravel:\n'
        '   • /api/productos/public\n'
        '   • /api/productos\n'
        '   • /productos/public\n'
        '   • /productos\n\n'
        '🔍 O prueba en el navegador: $fullUrl'
      );
    } else {
      final errorBody = res.body.length > 300 
          ? '${res.body.substring(0, 300)}...' 
          : res.body;
      throw Exception(
        'Error ${res.statusCode} desde $fullUrl\n\n'
        'Respuesta del servidor:\n$errorBody'
      );
    }
  } catch (e) {
    // Detectar errores de CORS o conexión
    final errorMsg = e.toString();
    if (errorMsg.contains('XMLHttpRequest') || 
        errorMsg.contains('CORS') ||
        errorMsg.contains('Failed host lookup')) {
      throw Exception(
        'Error de conexión con el backend.\n\n'
        'URL intentada: $fullUrl\n\n'
        'Verifica:\n'
        '1. Que Laravel tenga CORS configurado\n'
        '2. Que el backend esté corriendo en $baseUrl\n'
        '3. Revisa la consola del navegador (F12) para más detalles'
      );
    }
    rethrow;
  }
}
