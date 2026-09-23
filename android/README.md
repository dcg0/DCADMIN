# DCADMIN para Android y Chrome OS

Este módulo empaqueta la interfaz web de DCADMIN en un APK con `WebView`. El backend sigue ejecutándose en PHP y MySQL/MariaDB; el APK no contiene ni sustituye el servidor.

## Compilar

Requiere Android SDK con API 35, JDK 17 y Gradle 8.9 o superior. Desde esta carpeta:

```bash
gradle assembleDebug -PdcadminUrl=https://dcadmin.ejemplo.com
```

El APK queda en `app/build/outputs/apk/debug/app-debug.apk`. Para un equipo Chrome OS, instala el APK mediante `adb install` o el método de administración de aplicaciones Android de la organización.

Para una instalación local en la red, usa la dirección IP o el nombre DNS del equipo que ejecuta DCADMIN; **no uses `localhost`**, porque dentro del APK `localhost` apunta al Chromebook. Ejemplo:

```bash
gradle assembleDebug -PdcadminUrl=http://192.168.1.20:8080
```

La URL por defecto para el emulador Android es `http://10.0.2.2:8080`.

## Compatibilidad Chrome OS

El wrapper permite cambio de tamaño de ventana, orientación horizontal, teclado físico, tecla Escape como navegación atrás, zoom y enlaces externos. El servidor debe ser accesible desde el Chromebook y, si se usa internet, debe publicar HTTPS con un certificado válido.

Para uso únicamente en Chrome, el portal raíz también incluye `manifest.webmanifest` y `sw.js`: publícalo por HTTPS y usa **Instalar DCADMIN** desde el menú de Chrome. GitHub Pages puede servir esta PWA, pero no puede ejecutar el backend PHP.
