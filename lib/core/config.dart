import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

String get kApiBaseUrl {
  // Si se especifica manualmente, usar esa
  const envUrl = String.fromEnvironment('API_URL');
  if (envUrl.isNotEmpty) {
    return envUrl;
  }

  // Backend en Render (servidor remoto en la nube)
  // URL: https://proyecto-backend-web-1.onrender.com
  return 'https://proyecto-backend-web-1.onrender.com/api';
}

// Ruta del endpoint de productos
// Como la baseUrl ya incluye /api, aquí solo va la ruta después de /api
// Ejemplo: si la ruta completa es /api/productos/public, aquí va /productos/public
const String kProductosEndpoint = String.fromEnvironment(
  'PRODUCTOS_ENDPOINT',
  defaultValue: '/productos/public',
);
