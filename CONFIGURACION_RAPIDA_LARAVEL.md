# 🚀 Script de Configuración Rápida - Laravel

## 1️⃣ Instalar dependencias de CORS

```bash
# En tu proyecto Laravel
composer require fruitcake/laravel-cors
php artisan config:publish cors
```

## 2️⃣ Configurar CORS

Edita `config/cors.php` y copia esto:

```php
<?php

return [
    'paths' => ['api/*', 'sanctum/csrf-cookie'],
    'allowed_methods' => ['*'],
    'allowed_origins' => ['*'],
    'allowed_origins_patterns' => [],
    'allowed_headers' => ['*'],
    'exposed_headers' => [],
    'max_age' => 0,
    'supports_credentials' => false,
];
```

## 3️⃣ Configurar Kernel.php

Edita `app/Http/Kernel.php` y asegúrate de que en `$middlewareGroups['api']` esté:

```php
protected $middlewareGroups = [
    'api' => [
        \Fruitcake\Cors\HandleCors::class, // ← Agregar esta línea
        'throttle:api',
        \Illuminate\Routing\Middleware\SubstituteBindings::class,
    ],
];
```

## 4️⃣ Crear rutas de autenticación

Reemplaza todo `routes/api.php` con esto:

```php
<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

// RUTAS DE AUTENTICACIÓN
Route::post('/register', function (Request $request) {
    $validated = $request->validate([
        'name' => 'required|string|max:255',
        'email' => 'required|string|email|max:255|unique:users',
        'password' => 'required|string|min:8|confirmed',
    ]);

    return response()->json([
        'message' => 'Usuario registrado exitosamente',
        'user' => [
            'name' => $validated['name'],
            'email' => $validated['email'],
        ],
        'token' => 'token-' . uniqid(),
    ], 201);
});

Route::post('/login', function (Request $request) {
    $validated = $request->validate([
        'email' => 'required|email',
        'password' => 'required|string',
    ]);

    return response()->json([
        'message' => 'Login exitoso',
        'user' => [
            'id' => 1,
            'name' => 'Usuario Demo',
            'email' => $request->email,
        ],
        'token' => 'token-' . uniqid(),
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

// RUTAS PROTEGIDAS
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

## 5️⃣ Iniciar Laravel

```bash
php artisan serve
```

Deberías ver:
```
Starting Laravel development server: http://127.0.0.1:8000
```

---

## ✅ Verificar que funciona

```bash
# Terminal 1: Laravel
php artisan serve

# Terminal 2: Probar conexión
curl http://127.0.0.1:8000/api/productos/public

# Deberías ver JSON con los productos
```

---

## 🎯 Listo!

Tu backend está configurado y listo para conectar con Flutter. 🚀
