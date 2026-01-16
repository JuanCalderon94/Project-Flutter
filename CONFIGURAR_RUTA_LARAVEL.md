# Configurar la ruta de productos en Laravel

El error 404 indica que la ruta `/productos/public` no existe en tu backend Laravel.

## Solución: Crear la ruta en Laravel

### Opción 1: Ruta simple en `routes/api.php` (Recomendado)

1. **Abre el archivo** `routes/api.php` en tu proyecto Laravel

2. **Agrega esta ruta**:
```php
<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

// Ruta para obtener productos públicos (sin autenticación)
Route::get('/productos/public', function () {
    // Aquí debes reemplazar con tu modelo y lógica real
    // Ejemplo básico:
    return response()->json([
        [
            'id' => 1,
            'nombre' => 'Producto Ejemplo',
            'precio' => 99.99,
            'imagen_url' => 'https://via.placeholder.com/300',
            'descripcion' => 'Descripción del producto',
            'categoria' => 'General'
        ]
    ]);
});
```

### Opción 2: Usar un Controlador (Mejor práctica)

1. **Crea el controlador** (si no existe):
```bash
php artisan make:controller ProductoController
```

2. **En `app/Http/Controllers/ProductoController.php`**:
```php
<?php

namespace App\Http\Controllers;

use App\Models\Producto; // Ajusta según tu modelo
use Illuminate\Http\Request;

class ProductoController extends Controller
{
    public function public()
    {
        // Obtener productos públicos (sin autenticación)
        $productos = Producto::where('publico', true)
            ->orWhere('estado', 'activo')
            ->get()
            ->map(function ($producto) {
                return [
                    'id' => $producto->id,
                    'nombre' => $producto->nombre,
                    'precio' => (float) $producto->precio,
                    'imagen_url' => $producto->imagen_url ?? null,
                    'descripcion' => $producto->descripcion ?? null,
                    'categoria' => $producto->categoria ?? 'General',
                ];
            });
        
        return response()->json($productos);
    }
}
```

3. **En `routes/api.php`**:
```php
use App\Http\Controllers\ProductoController;

Route::get('/productos/public', [ProductoController::class, 'public']);
```

### Opción 3: Si tu ruta tiene otro nombre

Si tu ruta en Laravel tiene otro nombre (por ejemplo `/api/productos` o `/productos`), puedes:

**Opción A**: Cambiar la ruta en Flutter editando `lib/services/api.dart`:
```dart
final uri = Uri.parse('$baseUrl/api/productos'); // Ajusta según tu ruta
```

**Opción B**: Crear un alias en Laravel en `routes/api.php`:
```php
Route::get('/productos/public', [ProductoController::class, 'public']);
```

## Verificar que funciona

1. **Prueba la ruta directamente en el navegador**:
   ```
   http://127.0.0.1:8000/productos/public
   ```
   O si usas el prefijo `api/`:
   ```
   http://127.0.0.1:8000/api/productos/public
   ```

2. **Debe devolver JSON** con este formato:
```json
[
  {
    "id": 1,
    "nombre": "Producto 1",
    "precio": 99.99,
    "imagen_url": "url_de_imagen",
    "descripcion": "Descripción",
    "categoria": "Categoría"
  }
]
```

## Estructura esperada por Flutter

Flutter espera que la respuesta sea un **array JSON** con objetos que tengan estos campos:
- `id` (número)
- `nombre` (string)
- `precio` (número)
- `imagen_url` (string, opcional)
- `descripcion` (string, opcional)
- `categoria` (string, opcional)

## Nota importante sobre el prefijo `api/`

Si tus rutas en Laravel usan el prefijo `api/` (común en Laravel), la URL completa sería:
```
http://127.0.0.1:8000/api/productos/public
```

En ese caso, actualiza `lib/services/api.dart`:
```dart
final uri = Uri.parse('$baseUrl/api/productos/public');
```

## Si aún no funciona

1. Verifica que Laravel esté corriendo: `php artisan serve`
2. Lista todas las rutas: `php artisan route:list`
3. Busca la ruta de productos en la lista
4. Ajusta la URL en Flutter para que coincida exactamente
