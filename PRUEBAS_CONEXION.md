# 🧪 Pruebas Rápidas de Conexión - Laravel y Flutter

## 1️⃣ Verificar que Laravel esté corriendo

```bash
# En tu proyecto Laravel
php artisan serve
```

Resultado esperado:
```
Starting Laravel development server: http://127.0.0.1:8000
```

---

## 2️⃣ Probar las rutas desde la terminal

### Obtener productos públicos

```bash
curl http://216.24.57.251/api/productos/public
```

**Respuesta esperada:**
```json
[
  {
    "id": 1,
    "nombre": "Producto Ejemplo 1",
    "precio": 99.99,
    "imagen_url": "https://via.placeholder.com/300",
    "descripcion": "Descripción del producto",
    "categoria": "General"
  }
]
```

---

### Registrar un usuario

```bash
curl -X POST http://216.24.57.251/api/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Juan Pérez",
    "email": "juan@example.com",
    "password": "password123",
    "password_confirmation": "password123"
  }'
```

**Respuesta esperada:**
```json
{
  "message": "Usuario registrado exitosamente",
  "user": {
    "name": "Juan Pérez",
    "email": "juan@example.com"
  },
  "token": "dummy-token-..."
}
```

---

### Login

```bash
curl -X POST http://216.24.57.251/api/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "juan@example.com",
    "password": "password123"
  }'
```

**Respuesta esperada:**
```json
{
  "message": "Login exitoso",
  "user": {
    "id": 1,
    "name": "Juan Pérez",
    "email": "juan@example.com"
  },
  "token": "dummy-token-..."
}
```

Guarda el `token` para usarlo en peticiones autenticadas.

---

### Logout (con token)

```bash
curl -X POST http://216.24.57.251/api/logout \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer TU_TOKEN_AQUI"
```

---

## 3️⃣ Probar CORS desde el navegador

Abre la consola del navegador (F12) y ejecuta:

```javascript
// Probar si CORS funciona
fetch('http://216.24.57.251/api/productos/public')
  .then(res => res.json())
  .then(data => console.log('✅ CORS OK:', data))
  .catch(err => console.error('❌ Error CORS:', err));
```

Si funciona, deberías ver los productos en la consola. Si hay error de CORS, necesitas configurar CORS en Laravel.

---

## 4️⃣ Probar desde Flutter

### Obtener productos en Flutter

```dart
import 'package:flutter_application_1/services/api.dart';
import 'package:flutter_application_1/core/config.dart';

// En cualquier widget
void testProducts() async {
  try {
    final products = await fetchProducts(baseUrl: kApiBaseUrl);
    print('✅ Productos obtenidos: ${products.length}');
    for (var product in products) {
      print('  - ${product.nombre}: \$${product.precio}');
    }
  } catch (e) {
    print('❌ Error: $e');
  }
}
```

---

### Login desde Flutter

```dart
import 'package:flutter_application_1/services/auth_service.dart';

void testLogin() async {
  final authService = AuthService();
  
  final result = await authService.login(
    email: 'juan@example.com',
    password: 'password123',
  );

  if (result['success']) {
    print('✅ Login exitoso');
    print('Token: ${result['token']}');
    
    // Verificar que el token se guardó
    final token = await authService.getToken();
    print('Token guardado: $token');
    
    // Obtener datos del usuario
    final user = await authService.getCurrentUser();
    print('Usuario: $user');
  } else {
    print('❌ Error: ${result['message']}');
  }
}
```

---

## 5️⃣ Verificar logs de Laravel

Si hay errores, revisa los logs:

```bash
# En tiempo real
tail -f storage/logs/laravel.log

# O en Windows
Get-Content storage/logs/laravel.log -Wait
```

---

## 🐛 Solucionar Problemas

### ❌ "Connection refused"

```bash
# Laravel no está corriendo. Ejecuta:
php artisan serve
```

---

### ❌ "404 Not Found"

La ruta no existe. Verifica en `routes/api.php` que exista:

```bash
# Listar todas las rutas
php artisan route:list
```

Debería mostrar:
```
POST  /api/register
POST  /api/login
POST  /api/logout
GET   /api/productos/public
```

---

### ❌ "CORS error" en el navegador

CORS no está configurado. Ejecuta:

```bash
composer require fruitcake/laravel-cors
php artisan config:publish cors
```

Edita `config/cors.php`:

```php
'paths' => ['api/*'],
'allowed_methods' => ['*'],
'allowed_origins' => ['*'],
'allowed_headers' => ['*'],
```

---

### ❌ Error 500 en Laravel

```bash
# Revisa los logs
tail -f storage/logs/laravel.log

# O ejecuta artisan con debug
php artisan serve --debug
```

---

## ✅ Checklist de Verificación

- [ ] `php artisan serve` está corriendo
- [ ] `curl http://216.24.57.251/api/productos/public` retorna JSON
- [ ] CORS está configurado en `config/cors.php`
- [ ] Las rutas existen en `routes/api.php`
- [ ] El navegador muestra CORS OK en consola
- [ ] Flutter conecta sin errores
- [ ] Login funciona desde Flutter
- [ ] Productos se cargan correctamente

¡Si todo está ✅, tu conexión está funcionando correctamente! 🎉
