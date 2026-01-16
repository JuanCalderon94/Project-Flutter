# Configurar CORS en Laravel para Flutter Web

El error "XMLHttpRequest error" indica que Laravel está bloqueando las peticiones desde Flutter Web por CORS.

## Solución Rápida

### Opción 1: Usar el paquete `fruitcake/laravel-cors` (Recomendado)

1. **Instalar el paquete** (si no lo tienes):
```bash
composer require fruitcake/laravel-cors
```

2. **Publicar la configuración**:
```bash
php artisan config:publish cors
```

3. **Editar `config/cors.php`**:
```php
<?php

return [
    'paths' => ['api/*', 'sanctum/csrf-cookie', 'productos/*'],
    
    'allowed_methods' => ['*'],
    
    'allowed_origins' => ['*'], // En producción, especifica tu dominio
    
    'allowed_origins_patterns' => [],
    
    'allowed_headers' => ['*'],
    
    'exposed_headers' => [],
    
    'max_age' => 0,
    
    'supports_credentials' => false,
];
```

4. **Asegúrate de que el middleware esté registrado** en `app/Http/Kernel.php`:
```php
protected $middlewareGroups = [
    'web' => [
        // ... otros middlewares
    ],

    'api' => [
        \Fruitcake\Cors\HandleCors::class, // Asegúrate de que esté aquí
        // ... otros middlewares
    ],
];
```

### Opción 2: Configurar manualmente en el controlador

Si prefieres no usar el paquete, puedes agregar headers manualmente en tu controlador:

```php
public function productosPublic()
{
    $productos = Producto::all(); // Tu lógica aquí
    
    return response()->json($productos)
        ->header('Access-Control-Allow-Origin', '*')
        ->header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS')
        ->header('Access-Control-Allow-Headers', 'Origin, Content-Type, Accept, Authorization');
}
```

### Opción 3: Middleware personalizado

Crea un middleware para manejar CORS:

```bash
php artisan make:middleware CorsMiddleware
```

En `app/Http/Middleware/CorsMiddleware.php`:
```php
<?php

namespace App\Http\Middleware;

use Closure;

class CorsMiddleware
{
    public function handle($request, Closure $next)
    {
        $response = $next($request);
        
        $response->headers->set('Access-Control-Allow-Origin', '*');
        $response->headers->set('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
        $response->headers->set('Access-Control-Allow-Headers', 'Origin, Content-Type, Accept, Authorization');
        
        return $response;
    }
}
```

Regístralo en `app/Http/Kernel.php`:
```php
protected $middleware = [
    // ...
    \App\Http\Middleware\CorsMiddleware::class,
];
```

## Verificar que funciona

1. **Abre la consola del navegador** (F12 → Network)
2. **Recarga la app Flutter**
3. **Busca la petición a `/productos/public`**
4. **Verifica los headers de respuesta**:
   - Debe incluir `Access-Control-Allow-Origin: *`
   - Status debe ser 200

## Nota importante

- `allowed_origins: ['*']` permite cualquier origen (solo para desarrollo)
- En producción, especifica tu dominio exacto: `'allowed_origins' => ['https://tudominio.com']`
- Asegúrate de que tu ruta `/productos/public` esté en `routes/api.php` o tenga el prefijo `api/`

## Si aún no funciona

1. Verifica que Laravel esté corriendo: `php artisan serve` (puerto 8000)
2. Prueba la ruta directamente en el navegador: `http://127.0.0.1:8000/productos/public`
3. Revisa los logs de Laravel: `storage/logs/laravel.log`
4. Verifica que la ruta esté definida en `routes/api.php`:
```php
Route::get('/productos/public', [ProductoController::class, 'public']);
```
