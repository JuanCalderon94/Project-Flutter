# 📋 Checklist de Implementación

## Phase 1: Preparación de Flutter ✅ (COMPLETADO)

- [x] Actualizar `config.dart` con URL correcta
- [x] Reemplazar `AuthService` con versión que conecta a Laravel
- [x] Mejorar `api.dart` con mejor manejo de errores
- [x] Documentación completada
- [x] Ejemplos de código proporcionados

## Phase 2: Configuración de Laravel (TU TURNO)

### 2.1 Instalar CORS
```bash
[ ] composer require fruitcake/laravel-cors
[ ] php artisan config:publish cors
```

### 2.2 Configurar config/cors.php
```php
[ ] Editar paths: ['api/*']
[ ] Editar allowed_methods: ['*']
[ ] Editar allowed_origins: ['*']
[ ] Editar allowed_headers: ['*']
```

### 2.3 Actualizar app/Http/Kernel.php
```php
[ ] Agregar \Fruitcake\Cors\HandleCors::class en 'api' middleware
```

### 2.4 Crear routes/api.php
```php
[ ] Crear ruta POST /register
[ ] Crear ruta POST /login
[ ] Crear ruta POST /logout
[ ] Crear ruta GET /productos/public
[ ] Crear ruta GET /productos (protegida)
```

### 2.5 Iniciar Laravel
```bash
[ ] php artisan serve
[ ] Verificar que está corriendo en http://127.0.0.1:8000
```

## Phase 3: Pruebas con curl

### 3.1 Probar obtención de productos
```bash
[ ] curl http://216.24.57.251/api/productos/public
[ ] Recibir JSON con productos
```

### 3.2 Probar registro
```bash
[ ] curl -X POST http://216.24.57.251/api/register \
  -H "Content-Type: application/json" \
  -d '{"name":"Test","email":"test@test.com","password":"pass","password_confirmation":"pass"}'
[ ] Recibir token en respuesta
```

### 3.3 Probar login
```bash
[ ] curl -X POST http://216.24.57.251/api/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@test.com","password":"pass"}'
[ ] Recibir token en respuesta
```

### 3.4 Guardar el token
```bash
[ ] GUARDÉ EL TOKEN: ____________________________________
```

### 3.5 Probar petición autenticada
```bash
[ ] curl -X GET http://216.24.57.251/api/productos \
  -H "Authorization: Bearer <MI_TOKEN>"
[ ] Recibir productos privados
```

## Phase 4: Pruebas desde el navegador

### 4.1 Abrir consola del navegador (F12)
```javascript
[ ] Ejecutar en consola:
    fetch('http://216.24.57.251/api/productos/public')
      .then(r => r.json())
      .then(d => console.log('OK:', d))
      .catch(e => console.error('ERROR:', e))
[ ] Ver "OK: [...]" sin errores CORS
```

## Phase 5: Integrar con Flutter

### 5.1 Verificar que Flutter tiene dependencias correctas
```bash
[ ] flutter pub get
[ ] Sin errores
```

### 5.2 Actualizar pantalla de login
```dart
[ ] Copiar lógica de login_screen_example.dart
[ ] Integrar AuthService en tu pantalla actual
[ ] Probar que se abre la pantalla
```

### 5.3 Ejecutar Flutter
```bash
[ ] flutter run -d chrome
  O
[ ] flutter run -d emulator
  O
[ ] flutter run -d simulator
```

### 5.4 Probar login desde app
```
[ ] Abierta la pantalla de login
[ ] Ingresar credenciales de prueba
[ ] Presionar "Iniciar Sesión"
[ ] Ver spinner de carga
[ ] Recibir respuesta sin error
```

### 5.5 Verificar que el token se guardó
```dart
En la consola de Flutter:
[ ] Ver debug prints sin error
[ ] Token visible en SharedPreferences
```

## Phase 6: Funcionalidades Avanzadas

### 6.1 Cargar productos
```
[ ] Navegue a pantalla de productos
[ ] Productos se cargan automáticamente
[ ] Ver lista de productos
```

### 6.2 Logout
```
[ ] Botón de logout visible
[ ] Click en logout
[ ] Redirigir a login
[ ] Token eliminado
```

### 6.3 Datos del usuario
```dart
[ ] Mostrar nombre del usuario en pantalla
[ ] Mostrar email del usuario
```

### 6.4 Manejo de errores
```
[ ] Ingresar email incorrecto → Ver error
[ ] Ingresar password incorrecto → Ver error
[ ] Desconectar internet → Ver error amigable
[ ] Laravel caído → Ver error amigable
```

## 🐛 Si algo falla

### ❌ "Cannot connect to backend"
Revisar:
- [ ] Laravel está corriendo: `php artisan serve`
- [ ] IP correcta en config.dart
- [ ] Firewall permite conexión

### ❌ "CORS error"
Revisar:
- [ ] CORS está instalado: `composer require fruitcake/laravel-cors`
- [ ] CORS está configurado en `config/cors.php`
- [ ] Middleware CORS en `app/Http/Kernel.php`

### ❌ "404 Not Found"
Revisar:
- [ ] Ruta existe en `routes/api.php`
- [ ] Ruta está correcta: `php artisan route:list`
- [ ] URL en Flutter es correcta

### ❌ "401 Unauthorized"
Revisar:
- [ ] Token válido
- [ ] Token guardado correctamente
- [ ] Token incluido en headers

### ❌ "500 Internal Server Error"
Revisar:
- [ ] Logs de Laravel: `tail -f storage/logs/laravel.log`
- [ ] Código en controllers tiene errores
- [ ] Base de datos configurada

## 📊 Resumen

| Fase | Componente | Estado | Responsable |
|------|-----------|--------|------------|
| 1 | Flutter - AuthService | ✅ Done | Ya completado |
| 2 | Flutter - API Service | ✅ Done | Ya completado |
| 3 | Flutter - Config | ✅ Done | Ya completado |
| 4 | Laravel - CORS | ⏳ Pending | TÚ |
| 5 | Laravel - Routes | ⏳ Pending | TÚ |
| 6 | Laravel - Controllers | ⏳ Pending | TÚ |
| 7 | Testing - Curl | ⏳ Pending | TÚ |
| 8 | Testing - Browser | ⏳ Pending | TÚ |
| 9 | Testing - Flutter | ⏳ Pending | TÚ |
| 10 | Integration | ⏳ Pending | TÚ |

## 🎯 Objetivo Final

```
┌─────────────────┐         ┌─────────────────┐
│  Flutter App    │◄─────►  │ Laravel Backend │
│  ✓ Login        │ HTTP    │ ✓ Autenticación │
│  ✓ Productos    │ JSON    │ ✓ BD             │
│  ✓ Logout       │         │ ✓ CORS           │
└─────────────────┘         └─────────────────┘
        ↑                            ↑
        └────────────┬───────────────┘
                     │
            🎉 CONECTADOS 🎉
```

---

## ✅ Cuando todo esté listo

```
✓ Flutter compila sin errores
✓ Laravel responde a peticiones
✓ CORS configurado correctamente
✓ Login funciona
✓ Productos se cargan
✓ Logout limpia sesión
✓ Manejo de errores funciona
✓ App en producción 🚀
```

---

**¡Ahora es tu turno de configurar Laravel! 💪**
