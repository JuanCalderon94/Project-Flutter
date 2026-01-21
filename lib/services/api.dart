import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../core/config.dart';
import 'auth_service.dart';

Future<List<Product>> fetchProducts({required String baseUrl}) async {
  final endpoint = kProductosEndpoint;
  final fullUrl = '$baseUrl$endpoint';

  try {
    final uri = Uri.parse(fullUrl);
    final authService = AuthService();
    final token = await authService.getToken();

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Agregar token si existe
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    final res = await http
        .get(uri, headers: headers)
        .timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw Exception('Timeout: La conexión tardó demasiado tiempo');
          },
        );

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body) as List;
      return data
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList();
    } else if (res.statusCode == 401) {
      throw Exception(
        '❌ No autorizado (401)\n\n'
        'El servidor rechazó tu token.\n\n'
        '🔧 Soluciones:\n'
        '1. Verifica que estés autenticado\n'
        '2. Que tu token sea válido\n'
        '3. Revisa la configuración de autenticación en Laravel',
      );
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
        '🔍 O prueba en el navegador: $fullUrl',
      );
    } else if (res.statusCode == 500) {
      final errorBody = res.body.length > 300
          ? '${res.body.substring(0, 300)}...'
          : res.body;
      throw Exception(
        '❌ Error interno del servidor (500)\n\n'
        'El backend tiene un error.\n\n'
        'Respuesta del servidor:\n$errorBody\n\n'
        '🔧 Revisa los logs de Laravel:\n'
        'tail -f storage/logs/laravel.log',
      );
    } else {
      final errorBody = res.body.length > 300
          ? '${res.body.substring(0, 300)}...'
          : res.body;
      throw Exception(
        'Error ${res.statusCode} desde $fullUrl\n\n'
        'Respuesta del servidor:\n$errorBody',
      );
    }
  } catch (e) {
    final errorMsg = e.toString();

    // Detectar errores de CORS
    if (errorMsg.contains('XMLHttpRequest') ||
        errorMsg.contains('CORS') ||
        errorMsg.contains('type: HttpException')) {
      throw Exception(
        '❌ Error de CORS - Conexión bloqueada\n\n'
        'El servidor no permite conexiones desde tu cliente.\n\n'
        'URL intentada: $fullUrl\n\n'
        '🔧 Pasos para solucionar:\n'
        '1. En tu proyecto Laravel, instala CORS:\n'
        '   composer require fruitcake/laravel-cors\n'
        '2. Publica la configuración:\n'
        '   php artisan config:publish cors\n'
        '3. Edita config/cors.php y asegúrate de que tenga:\n'
        '   \'paths\' => [\'api/*\'],\n'
        '   \'allowed_origins\' => [\'*\'],\n'
        '   \'allowed_methods\' => [\'*\'],\n'
        '   \'allowed_headers\' => [\'*\'],\n'
        '4. Reinicia Laravel:\n'
        '   php artisan serve',
      );
    }

    // Detectar errores de conexión
    if (errorMsg.contains('Failed host lookup') ||
        errorMsg.contains('Connection refused') ||
        errorMsg.contains('Timeout')) {
      throw Exception(
        '❌ No se puede conectar con el servidor\n\n'
        'URL intentada: $fullUrl\n\n'
        '🔧 Pasos para solucionar:\n'
        '1. Verifica que Laravel esté corriendo:\n'
        '   php artisan serve\n'
        '2. Comprueba la URL: http://216.24.57.251:8000/api\n'
        '3. Si usas localhost, asegúrate de estar en la red correcta\n'
        '4. Revisa el firewall\n'
        '5. Usa un VPN si es necesario\n\n'
        'Error: $errorMsg',
      );
    }

    rethrow;
  }
}

/// Función auxiliar para hacer peticiones autenticadas
Future<http.Response> authenticatedRequest(
  String method,
  Uri url, {
  Map<String, String>? headers,
  Object? body,
}) async {
  final authService = AuthService();
  final token = await authService.getToken();

  final finalHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    ...?headers,
  };

  if (token != null) {
    finalHeaders['Authorization'] = 'Bearer $token';
  }

  switch (method.toUpperCase()) {
    case 'GET':
      return http.get(url, headers: finalHeaders);
    case 'POST':
      return http.post(url, headers: finalHeaders, body: body);
    case 'PUT':
      return http.put(url, headers: finalHeaders, body: body);
    case 'DELETE':
      return http.delete(url, headers: finalHeaders);
    default:
      throw Exception('Método HTTP no soportado: $method');
  }
}
