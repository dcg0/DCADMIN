# DCADMIN: acceso web y despliegue operativo

## Estado publicado

El repositorio incorpora `index.html`, una puerta de acceso estática diseñada para GitHub Pages. Esta página enlaza al panel web de DC Laboratory, que ya implementa los módulos de clientes, inventario, facturación y reportes con una base de datos propia.

GitHub Pages **no puede ejecutar PHP ni mantener una base de datos**, por lo que no puede alojar directamente el motor Dolibarr incluido en este repositorio. Pages solo debe usarse para la página de acceso o documentación.

## Activar GitHub Pages

Un propietario del repositorio debe abrir **Settings → Pages** en `dcg0/DCADMIN` y seleccionar **Deploy from a branch**, con la rama `main` y la carpeta `/(root)`. Al guardar, GitHub publicará el portal en:

`https://dcg0.github.io/DCADMIN/`

La integración automatizada no dispone del permiso administrativo `pages:write`, por eso este único ajuste requiere una acción de propietario.

## Ejecutar Dolibarr como ERP PHP

Para usar la instancia Dolibarr incluida en `htdocs/`, utilice una plataforma con PHP y MySQL/MariaDB o PostgreSQL. Configure el servidor web para que su raíz apunte a `htdocs/`, cree la base de datos, habilite escritura temporal en `htdocs/conf/` y complete el instalador desde `/install/`. Una vez terminado, retire el permiso de escritura de la configuración.

El repositorio mantiene Dolibarr como motor ERP completo; la aplicación WebDev complementaria proporciona el acceso móvil/web de DC Laboratory y no sustituye el requisito de hosting PHP para esta copia del ERP.
