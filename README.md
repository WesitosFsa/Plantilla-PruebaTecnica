# PokeAPI CRUD - Flutter Template 🚀

Esta es una plantilla de Flutter diseñada para demostrar un flujo completo de **CRUD (Create, Read, Update, Delete)** consumiendo una API externa (**PokeAPI**) y gestionando la persistencia de datos e imágenes de forma local con **Hive**.

## 🌟 Características

- **Consumo de API:** Uso de `Dio` para peticiones HTTP eficientes.
- **Persistencia Local:** Almacenamiento NoSQL ultra rápido con `Hive`.
- **Gestión de Imágenes:** Descarga de imágenes desde la API y almacenamiento en formato de bytes (`Uint8List`) dentro de la base de datos para total compatibilidad con **Web, Android e iOS**.
- **Arquitectura Modular:** Separación clara entre Modelos, Servicios y UI para facilitar la reutilización.
- **CRUD Completo:**
  - **Create:** Captura de Pokémon y descarga de su imagen.
  - **Read:** Búsqueda en la API y listado de la colección local.
  - **Update:** Edición de datos (como el nombre) de los registros locales.
  - **Delete:** Eliminación de registros de la base de datos local.

## 🛠️ Tecnologías Utilizadas

- **Flutter:** Framework principal.
- **Hive:** Base de datos local ligera y rápida.
- **Dio:** Cliente HTTP para consumir PokeAPI.
- **Build Runner / Hive Generator:** Para la generación automática de adaptadores de datos.
- **Path Provider:** (Opcional en esta versión) Para gestión de rutas en móvil.

## 📂 Estructura del Proyecto

```text
lib/
├── models/
│   ├── pokemon.dart       # Definición del objeto y adaptador de Hive
│   └── pokemon.g.dart     # Archivo generado por build_runner
├── services/
│   ├── api_service.dart   # Lógica de consumo de PokeAPI y descarga de imágenes
│   └── hive_service.dart  # Lógica de persistencia y CRUD local
├── ui/
│   └── home_screen.dart   # Interfaz de usuario con pestañas (Buscar/Capturados)
└── main.dart              # Inicialización de Hive y arranque de la app
```

## 🚀 Instalación y Configuración

1. **Clonar el repositorio:**
   ```bash
   git clone <url-del-repo>
   ```

2. **Instalar dependencias:**
   ```bash
   flutter pub get
   ```

3. **Generar el adaptador de Hive:**
   Si realizas cambios en el modelo `pokemon.dart`, debes ejecutar:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Ejecutar la aplicación:**
   ```bash
   flutter run
   ```

## 📖 Cómo Usar la Plantilla

### 1. Buscar y Capturar (Read API -> Create Local)
En la pestaña **"Buscar API"**, introduce el ID de un Pokémon (1-1025). Al visualizarlo, pulsa **"Capturar"**. La aplicación descargará los datos y la imagen, guardándolos en la base de datos local. Puedes capturar varias veces el mismo Pokémon; cada uno tendrá su propia entrada.

### 2. Gestionar Colección (Read/Update/Delete Local)
En la pestaña **"Capturados"**, verás tu lista de Pokémon.
- **Imagen:** Se carga directamente desde los bytes guardados localmente (funciona sin internet).
- **Editar:** Pulsa el icono azul para cambiar el nombre del Pokémon en tu base de datos (no afecta a la API).
- **Liberar:** Pulsa el icono rojo para eliminar el registro permanentemente.

## 🔄 Reutilización para otras APIs

Para usar esta plantilla con otra API:
1. Modifica el modelo en `lib/models/` para que coincida con la nueva estructura JSON.
2. Cambia la URL base en `lib/services/api_service.dart`.
3. Vuelve a ejecutar el `build_runner`.

---
Creado con ❤️ para desarrolladores de Flutter.


## Comandos para instalar herramientas desde powershell me ahorra mas tiempo XD
- winget install OpenJS.NodeJS.LTS
- winget install Microsoft.VisualStudioCode
- winget install Google.Chrome
- winget install Flutter.Flutter
## Por si acaso me quedo trabado y necesito ayuda
- npm install -g @google/gemini-cli
## CMD
- code --install-extension dart-code.flutter si no instalo manualmente y no pasa nada
- flutter run -d chrome agilizar por si acaso pero me va ir bien :D
