import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

String get kApiBaseUrl {
  // Si se especifica manualmente, usar esa
  const envUrl = String.fromEnvironment('API_URL');
  if (envUrl.isNotEmpty) {
    return envUrl;
  }

  // Detectar plataforma automáticamente
  // Nota: La base URL ya incluye /api según auth_service.dart
  if (kIsWeb) {
    // Para web, usar localhost con /api
    return 'http://127.0.0.1:8000/api';
  } else if (Platform.isAndroid) {
    // Para emulador Android, usar 10.0.2.2 con /api
    return 'http://10.0.2.2:8000/api';
  } else {
    // Para iOS simulator y otros, usar localhost con /api
    return 'http://127.0.0.1:8000/api';
  }
}

// Ruta del endpoint de productos
// Como la baseUrl ya incluye /api, aquí solo va la ruta después de /api
// Ejemplo: si la ruta completa es /api/productos/public, aquí va /productos/public
const String kProductosEndpoint = String.fromEnvironment(
  'PRODUCTOS_ENDPOINT',
  defaultValue: '/productos/public',
);
