# 📱 Guía Completa: Conectar Flutter con Laravel

## ✅ Cambios realizados en tu proyecto Flutter

He actualizado tu proyecto para conectar correctamente con tu backend Laravel:

1. **✅ URL Base Unificada**: `http://216.24.57.251/api`
2. **✅ AuthService Mejorado**: Ahora conecta con Laravel en lugar de usar solo datos locales
3. **✅ Mejor Manejo de Errores**: Mensajes claros sobre qué está fallando
4. **✅ Soporte para Tokens**: Almacenamiento seguro de tokens de autenticación

---

## 🔧 Requisitos en tu Backend Laravel

### Paso 1: Verificar que Laravel esté corriendo

```bash
# En la terminal de tu proyecto Laravel
php artisan serve
```

Deberías ver algo como:
```
Starting Laravel development server: http://127.0.0.1:8000
```

### Paso 2: Configurar CORS (IMPORTANTE)

CORS es lo que permite que Flutter Web/App se conecte a tu backend. Sin esto, la conexión será bloqueada.

#### Opción A: Usar el paquete `fruitcake/laravel-cors` (RECOMENDADO)

```bash
# En tu proyecto Laravel
composer require fruitcake/laravel-cors
php artisan config:publish cors
```

Edita `config/cors.php`:

```php
<?php

return [
    'paths' => ['api/*', 'sanctum/csrf-cookie'],
    
    'allowed_methods' => ['*'],
    
    'allowed_origins' => ['*'], // En producción: especifica tu dominio
    
    'allowed_origins_patterns' => [],
    
    'allowed_headers' => ['*'],
    
    'exposed_headers' => [],
    
    'max_age' => 0,
    
    'supports_credentials' => false,
];
```

Asegúrate de que el middleware esté registrado en `app/Http/Kernel.php`:

```php
protected $middlewareGroups = [
    'api' => [
        \Fruitcake\Cors\HandleCors::class, // ← Agrega esta línea
        'throttle:api',
        \Illuminate\Routing\Middleware\SubstituteBindings::class,
    ],
];
```

#### Opción B: Si Laravel ≥ 8 usa el middleware nativo

En `config/cors.php`:

```php
return [
    'paths' => ['api/*', 'sanctum/csrf-cookie'],
    'allowed_methods' => ['*'],
    'allowed_origins' => ['*'],
    'allowed_headers' => ['*'],
    'exposed_headers' => [],
    'max_age' => 0,
    'supports_credentials' => false,
];
```

### Paso 3: Crear las rutas de autenticación en Laravel

Edita `routes/api.php` y agrega estas rutas:

```php
<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

// RUTAS DE AUTENTICACIÓN
Route::post('/register', function (Request $request) {
    // Validar datos
    $validated = $request->validate([
        'name' => 'required|string|max:255',
        'email' => 'required|string|email|max:255|unique:users',
        'password' => 'required|string|min:8|confirmed',
    ]);

    // Crear usuario (si tienes modelo User)
    // $user = User::create([
    //     'name' => $validated['name'],
    //     'email' => $validated['email'],
    //     'password' => Hash::make($validated['password']),
    // ]);

    // Por ahora, retornar respuesta simple
    return response()->json([
        'message' => 'Usuario registrado exitosamente',
        'user' => [
            'name' => $validated['name'],
            'email' => $validated['email'],
        ],
        'token' => 'dummy-token-' . uniqid(),
    ], 201);
});

Route::post('/login', function (Request $request) {
    $validated = $request->validate([
        'email' => 'required|email',
        'password' => 'required|string',
    ]);

    // Aquí irá tu lógica de autenticación real
    // if (Auth::attempt($validated)) {
    //     $user = Auth::user();
    //     $token = $user->createToken('auth-token')->plainTextToken;
    //     return response()->json(['token' => $token, 'user' => $user]);
    // }

    // Por ahora, respuesta simple
    return response()->json([
        'message' => 'Login exitoso',
        'user' => [
            'id' => 1,
            'name' => 'Usuario Demo',
            'email' => $request->email,
        ],
        'token' => 'dummy-token-' . uniqid(),
    ], 200);
});

Route::post('/logout', function (Request $request) {
    return response()->json(['message' => 'Logout exitoso'], 200);
});

// RUTAS PÚBLICAS
Route::get('/productos/public', function () {
    return response()->json([
        [
            'id' => 1,
            'nombre' => 'Producto Ejemplo 1',
            'precio' => 99.99,
            'imagen_url' => 'https://via.placeholder.com/300',
            'descripcion' => 'Descripción del producto',
            'categoria' => 'General'
        ],
        [
            'id' => 2,
            'nombre' => 'Producto Ejemplo 2',
            'precio' => 149.99,
            'imagen_url' => 'https://via.placeholder.com/300',
            'descripcion' => 'Otro producto',
            'categoria' => 'Premium'
        ]
    ]);
});

// RUTAS PROTEGIDAS (requieren token)
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/user', function (Request $request) {
        return response()->json($request->user());
    });
    
    Route::get('/productos', function () {
        return response()->json([
            'message' => 'Productos privados del usuario',
        ]);
    });
});
```

### Paso 4: Crear un modelo User básico (opcional pero recomendado)

```bash
php artisan make:model User --migration
```

En `database/migrations/xxxx_create_users_table.php`:

```php
Schema::create('users', function (Blueprint $table) {
    $table->id();
    $table->string('name');
    $table->string('email')->unique();
    $table->timestamp('email_verified_at')->nullable();
    $table->string('password');
    $table->rememberToken();
    $table->timestamps();
});
```

Luego:

```bash
php artisan migrate
```

---

## 🧪 Pruebas de Conexión

### Test 1: ¿Laravel está corriendo?

```bash
# Desde otra terminal
curl http://216.24.57.251/api/productos/public
```

Deberías ver JSON con productos.

### Test 2: Probar desde el navegador

Abre: `http://216.24.57.251/api/productos/public`

Deberías ver JSON.

### Test 3: Probar registro

```bash
curl -X POST http://216.24.57.251/api/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Usuario Test",
    "email": "test@example.com",
    "password": "password123",
    "password_confirmation": "password123"
  }'
```

### Test 4: Probar login

```bash
curl -X POST http://216.24.57.251/api/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }'
```

---

## 🚀 Ejecutar tu app Flutter

### Para Web:

```bash
flutter run -d chrome
```

### Para Android:

```bash
flutter run -d emulator
```

### Para iOS:

```bash
flutter run -d simulator
```

---

## 🐛 Solucionar Problemas Comunes

### Error: "XMLHttpRequest error" o "CORS error"

**Causa**: CORS no está configurado en Laravel

**Solución**:
```bash
composer require fruitcake/laravel-cors
php artisan config:publish cors
```

Edita `config/cors.php` y asegúrate de que:
- `'allowed_origins' => ['*']`
- `'allowed_methods' => ['*']`

### Error: 404 - "Ruta no encontrada"

**Causa**: La ruta `/api/productos/public` no existe

**Solución**: Agrega la ruta en `routes/api.php` (ver Paso 3 arriba)

### Error: "Cannot connect to backend"

**Causa**: Laravel no está corriendo o la IP es incorrecta

**Solución**:
```bash
php artisan serve
# Y verifica que esté en: http://127.0.0.1:8000
```

Si necesitas un servidor accesible desde otra máquina:

```bash
php artisan serve --host=0.0.0.0 --port=8000
```

### Error: 401 - "No autorizado"

**Causa**: Falta el token de autenticación

**Solución**: Primero haz login, y asegúrate de guardar el token

---

## 📝 Resumen de Cambios en Flutter

### AuthService

Ahora tiene estos métodos:

```dart
// Login con Laravel
final result = await AuthService().login(
  email: 'user@example.com',
  password: 'password123',
);

if (result['success']) {
  print('Token: ${result['token']}');
  print('Usuario: ${result['user']}');
}

// Signup
final result = await AuthService().signUp(
  username: 'Juan',
  email: 'juan@example.com',
  password: 'password123',
  passwordConfirm: 'password123',
);

// Logout
await AuthService().logout();

// Verificar si está logueado
final isLoggedIn = await AuthService().isLoggedIn();

// Obtener token actual
final token = await AuthService().getToken();

// Obtener datos del usuario
final user = await AuthService().getCurrentUser();
```

### API Service

Ahora incluye autenticación:

```dart
// Obtener productos (con token si está disponible)
final products = await fetchProducts(
  baseUrl: kApiBaseUrl
);

// Para peticiones personalizadas
final response = await authenticatedRequest(
  'GET',
  Uri.parse('$kApiBaseUrl/productos'),
);
```

---

## ✅ Checklist Final

- [ ] Laravel está corriendo (`php artisan serve`)
- [ ] CORS está configurado en `config/cors.php`
- [ ] Las rutas `/register`, `/login`, `/logout` existen
- [ ] La ruta `/api/productos/public` existe
- [ ] Probé las rutas desde el navegador
- [ ] Probé las rutas con `curl`
- [ ] Flutter compila sin errores
- [ ] La app se conecta al backend

¡Si todo está marcado, tu conexión debería funcionar! 🎉
