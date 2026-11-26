# TP5 - Lugares Turísticos (Flutter + Firebase + Riverpod)

Continuación del TP4: misma app de lugares turísticos, pero ahora:

- **Firebase Authentication** (email y contraseña) para registro, inicio y cierre de sesión.
- **Cloud Firestore** para guardar los lugares (colección `lugares`), así el ABM se conserva entre ejecuciones.
- **Riverpod** para el estado de la sesión, el listado y las operaciones de alta, modificación y baja.

## Estructura

```
lib/
  main.dart                  Inicializa Firebase y arranca la app
  firebase_options.dart      Lo genera "flutterfire configure"
  models/lugar.dart          Lugar (id = ID del documento de Firestore)
  providers/
    auth_provider.dart       Sesión (authProvider) + registrar / iniciar / cerrar sesión
    lugares_provider.dart    Listado y detalle en tiempo real + agregar / modificar / eliminar
  screens/
    inicio_screen.dart       Al abrir la app decide: login o listado (según la sesión)
    login_screen.dart
    registro_screen.dart
    home_screen.dart         Listado
    detail_screen.dart       Detalle con editar y eliminar
    form_screen.dart         Alta y edición
firestore.rules              Reglas de seguridad de Firestore
```

Cada lugar tiene: id, nombre, descripción, imagen (URL), ubicación y categoría.

## Cómo configurar Firebase (una sola vez)

1. Entrá a https://console.firebase.google.com con tu cuenta y creá un proyecto (por ejemplo `tp5-lugares`).
2. **Authentication** → Comenzar → pestaña *Sign-in method* → habilitá **Correo electrónico/contraseña**.
3. **Firestore Database** → Crear base de datos → elegí una ubicación (por ejemplo `southamerica-east1`) → modo producción.
   Después, en la pestaña **Reglas**, pegá el contenido de `firestore.rules` y tocá **Publicar**.
4. En la terminal, dentro de la carpeta del proyecto:

   ```bash
   npm install -g firebase-tools        # si no lo tenés
   firebase login                       # inicia sesión con tu cuenta de Google
   dart pub global activate flutterfire_cli
   flutterfire configure                # elegí tu proyecto y las plataformas (android, ios, web...)
   ```

   Esto reemplaza `lib/firebase_options.dart` con los datos de tu proyecto.

5. Instalá las dependencias y corré la app:

   ```bash
   flutter pub get
   flutter run
   ```

## Cómo probar la persistencia

1. Registrate (nombre, email, contraseña y confirmación).
2. Agregá un lugar con el botón **+** (por ejemplo, una URL de imagen de https://picsum.photos/400).
3. Cerrá la app por completo y volvé a abrirla: la sesión sigue iniciada y el lugar sigue en el listado.
4. Editalo, cerrá y abrí la app: se ven los cambios. Lo mismo después de eliminarlo.
5. Cerrá sesión con el ícono de salida: vuelve a la pantalla de ingreso.
