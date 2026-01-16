# Verificar Conexión con Backend Laravel

## Paso 1: Verificar que Laravel esté corriendo

Abre una terminal en tu proyecto Laravel y ejecuta:
```bash
php artisan serve
```

Debe mostrar algo como:
```
Starting Laravel development server: http://127.0.0.1:8000
```

## Paso 2: Probar la ruta directamente en el navegador

Abre tu navegador y ve a:
```
http://127.0.0.1:8000/api/productos/public
```

**O la ruta que tengas configurada en Laravel.**

**¿Qué deberías ver?**
- ✅ **Si funciona**: Deberías ver JSON con los productos (ejemplo: `[{"id":1,"nombre":"..."}]`)
- ❌ **Si no funciona**: Verás un error 404 o página de error

## Paso 3: Verificar CORS en Laravel

### Opción A: Verificar que CORS esté habilitado

1. Abre `config/cors.php` en tu proyecto Laravel
2. Verifica que tenga:
```php
'paths' => ['api/*', 'sanctum/csrf-cookie', 'productos/*'],
'allowed_methods' => ['*'],
'allowed_origins' => ['*'], // Para desarrollo
'allowed_headers' => ['*'],
```

### Opción B: Si no tienes CORS configurado

Instala el paquete:
```bash
composer require fruitcake/laravel-cors
php artisan config:publish cors
```

Luego configura `config/cors.php` como en la Opción A.

## Paso 4: Verificar la consola del navegador

1. En Chrome, presiona **F12** para abrir las herramientas de desarrollador
2. Ve a la pestaña **Console**
3. Ve a la pestaña **Network**
4. Recarga la página de Flutter
5. Busca la petición a `/api/productos/public` (o tu ruta)
6. Haz clic en ella y revisa:
   - **Status**: ¿200, 404, o CORS error?
   - **Headers**: ¿Tiene `Access-Control-Allow-Origin`?
   - **Response**: ¿Qué devuelve?

## Paso 5: Verificar la ruta exacta en Laravel

Ejecuta en tu proyecto Laravel:
```bash
php artisan route:list | findstr productos
```

O simplemente:
```bash
php artisan route:list
```

Busca la ruta que tenga "productos" y copia la ruta exacta.

## Errores comunes y soluciones

### Error: "Failed to fetch" o "Network error"
- **Causa**: El backend no está corriendo o la URL es incorrecta
- **Solución**: Verifica que `php artisan serve` esté corriendo

### Error: "CORS policy" o "Access-Control-Allow-Origin"
- **Causa**: CORS no está configurado en Laravel
- **Solución**: Configura CORS como en el Paso 3

### Error: 404 Not Found
- **Causa**: La ruta no existe en Laravel
- **Solución**: Verifica la ruta en el Paso 5 y ajusta Flutter

### Error: 500 Internal Server Error
- **Causa**: Error en el código de Laravel
- **Solución**: Revisa los logs: `storage/logs/laravel.log`
