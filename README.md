lutter app demo con arquitectura BLoC que incluye:

* Catálogo con imágenes desde URL, búsqueda local y filtros (categoría, locación y precio).
* Carrito de compras con animaciones, cantidades y total.
* Pantalla de Categorías (grid), navegación desde “Todo”.
* Autenticación Firebase (Login / Crear cuenta) y recuperación de contraseña.
* Perfil con edición (nombre, ciudad, teléfono, rol Vendedor/Comprador), cambio de foto desde la galería, preferencias y Log Out.


-Este proyecto prioriza UI nativa de Flutter sin paquetes de UI externos. Las imágenes de productos y banners se cargan por URL (sin API). La foto de perfil se selecciona del dispositivo.

-Tabla de contenido

1) requisitos
2) estructura-del-proyecto
3) instalación-y-configuración
4) arquitectura-bloc
5) módulos-y-funcionalidades:
#catálogo
#carrito-de-compras
#categorías
#autenticación-loginsignup
#perfil


6) temas-theme-y-estilo 
7) rutas-y-navegación
8) assets-y-localización
9) troubleshooting
10) mejoras-futuras

1) Requisitos
1-Flutter 3.3+ y Dart 3.3+
2-Android SDK 33+ / iOS 12+
3-Proyecto en Firebase configurado (Auth y, opcionalmente, Firestore/Storage si decides persistir perfil en la nube)

2) Estructura del proyecto:
lib/
├─ main.dart
├─ app.dart                              # MaterialApp y tema
├─ core/theme.dart                       # Tema y estilos base
├─ data/
│   ├─ fake_products.dart                # Datos de productos (URL)
│   ├─ fake_categories.dart              # Datos de categorías (URL)
│   └─ auth_repository.dart              # Wrapper de FirebaseAuth
├─ domain/
│   ├─ product.dart
│   ├─ cart_item.dart
│   └─ user_role.dart                    # enum Vendedor/Comprador
├─ bloc/
│   ├─ catalog/                          # BLoC del catálogo
│   │   ├─ catalog_bloc.dart
│   │   ├─ catalog_event.dart
│   │   └─ catalog_state.dart
│   ├─ cart/                             # BLoC del carrito
│   │   ├─ cart_bloc.dart
│   │   ├─ cart_event.dart
│   │   └─ cart_state.dart
│   ├─ category/                         # BLoC de categorías (grid)
│   │   ├─ category_bloc.dart
│   │   ├─ category_event.dart
│   │   └─ category_state.dart
│   ├─ auth/                             # BLoC de autenticación
│   │   ├─ auth_bloc.dart
│   │   ├─ auth_event.dart
│   │   └─ auth_state.dart
│   └─ profile/                          # BLoC del perfil
│       ├─ profile_bloc.dart
│       ├─ profile_event.dart
│       └─ profile_state.dart
├─ presentation/
│   ├─ screens/
│   │   ├─ catalog_page.dart
│   │   ├─ cart_page.dart
│   │   ├─ categories_page.dart
│   │   ├─ login_page.dart
│   │   ├─ signup_page.dart
│   │   └─ profile_page.dart
│   └─ widgets/
│       ├─ product_card.dart
│       └─ category_tile.dart
└─ firebase_options.dart                 # generado por FlutterFire CLI

3) Instalación y configuración 
* Clonar e instalar dependencias
[
   flutter pub get
   ]
* Pubspec (principales)
[
   dependencies:
   flutter:
   sdk: flutter
   flutter_bloc: ^8.1.4
   firebase_core: ^2.27.0
   firebase_auth: ^4.17.4
   image_picker: ^1.0.7
   ]
* Configurar Firebase
-Instala FlutterFire CLI
[dart pub global activate flutterfire_cli]
-En el root del proyecto:
[flutterfire configure]
-Elige tu proyecto de Firebase.
-Se generará lib/firebase_options.dart.
-Android: agrega google-services.json en android/app/.
-iOS: agrega GoogleService-Info.plist en ios/Runner/ y habilita el plugin.
* Permisos (iOS para galería)
-ios/Runner/Info.plist:
[<key>NSPhotoLibraryUsageDescription</key>
   <string>Necesitamos acceso a tu galería para la foto de perfil.</string>]
* Ejecutar
[flutter run]
4) Arquitectura BLoC

-Patrón BLoC para separar presentación, estado y lógica de negocio.
-Cada módulo tiene sus Events, States y Bloc:

* CatalogBloc: carga de productos en memoria, búsqueda local, filtros, orden de precio.
* CartBloc: agregar/quitar items, incrementar/decrementar cantidades, total y animación de badge.
* CategoryBloc: gestión de grid de categorías con búsqueda local.
* AuthBloc: inicio/registro de sesión con FirebaseAuth, reset de contraseña y control de loading/errores.
* ProfileBloc: edición de perfil, selección de rol, selección de foto local, preferencias, y logout (FirebaseAuth.signOut).

-Ciclo típico
* UI → Bloc.add(Event) → Bloc procesa y emite State → UI se reconstruye con BlocBuilder/BlocConsumer.
5) Módulos y funcionalidades
* Catálogo:
* Imágenes por URL (sin API) usando Image.network o FadeInImage.assetNetwork.
* Búsqueda local: CatalogQueryChanged filtra por título, categoría, ubicación o vendedor.
- Filtros:
* Categoría y Localidad mediante PopupMenuButton.
- Precio: none, lowToHigh, highToLow (ordenamiento local).
-Animaciones:
* Al agregar al carrito: “bump” del ícono + badge con AnimatedSwitcher.
* Botón “+” en la tarjeta con ScaleTransition.

-Claves de implementación

* CatalogBloc._applyFilters() aplica búsqueda, filtro por categoría/ubicación y orden de precio.
* ProductCard presenta título, precio, unidad, rating y acción de “+” para agregar al carrito.
  Carrito de compras

-Maneja CartItem (product + qty).
* Acciones: add, remove, increase, decrease, clear.
* Total y cantidad total derivados del estado.
-Pantalla CartPage:
* Listado de ítems con imagen, precio y stepper de cantidad.
* Resumen con Total y botón Checkout (demo).

-Categorías

* Pantalla CategoriesPage (grid 2×N) con búsqueda local.
* Ítems con imagen por URL + overlay y título.
* Desde Home/Catálogo:

* Se agregó botón “Todo” en la fila de filtros de categoría.
* Al tocar, navega a CategoriesPage; al elegir una categoría se retorna su nombre y se aplica el filtro en CatalogBloc.
  Autenticación (Login/SignUp)

-FirebaseAuth:

* Login y Crear Cuenta vía email/contraseña.
* Forgot Password? (sendPasswordResetEmail).
* UI:

* Estilo acorde al proyecto: botones redondeados, primary green, imagen inferior por URL.
* Navegación:

* Tras éxito (AuthState.success == true) → CatalogPage con pushAndRemoveUntil.
* App inicia revisando FirebaseAuth.instance.authStateChanges() para abrir directamente CatalogPage si hay sesión.
-Claves

* AuthRepository encapsula FirebaseAuth.
* AuthBloc maneja:

* AuthSubmitted (login o signup según AuthMode).
* AuthResetPasswordRequested.
* Toggle de visibilidad del password.

-Perfil

* Estado por defecto: name = "usuario", role = comprador, photoPath = null, notifications = true.
* Pantalla ProfilePage:

* Encabezado con avatar, nombre y ciudad.
* Opción Edit Profile: abre BottomSheet con Nombre, Ciudad, Número de contacto y selector de Rol (ChoiceChip Vendedor/Comprador).
* Selección de foto de perfil desde la galería (image_picker).
* Notification Preferences con Switch.
* Botón Log Out: FirebaseAuth.signOut() y navegación a Login.


-Actualizar datos:

* ProfileSaved actualiza el estado en ProfileBloc (en memoria).
* Los cambios se reflejan inmediatamente en la UI (nombre, ciudad, rol, avatar).
* Si deseas persistir, ver sección “Mejoras futuras”.

-Claves

* ProfilePhotoChanged(path) guarda la ruta local del archivo.
* ProfileLogoutRequested → FirebaseAuth.signOut() y loggedOut = true → redirección a Login.
  
6) Temas (Theme) y estilo

* Color primario verde: #19C463.
* ThemeData con useMaterial3: true.
* InputDecorationTheme con bordes redondeados, filled: true, y paddings consistentes.
* CardTheme y ChipTheme definidos para mantener identidad visual en cards, filtros y botones.
  
7) Rutas y navegación

* Inicio de app (main.dart):
* Inicializa Firebase.
* StreamBuilder a authStateChanges() decide entre CatalogPage o LoginPage.

* CatalogPage:

* NavigationBar inferior; al tocar Profile (índice 4) navega a ProfilePage con BlocProvider(ProfileBloc).
* Botón FAB abre CartPage.
* Filtro “Todo” abre CategoriesPage y retorna la categoría seleccionada.

* Login/SignUp:

* Tras éxito → CatalogPage con pushAndRemoveUntil para evitar volver atrás.

* Profile:
* Botón Log Out → va a Login con pushAndRemoveUntil.
 
8) Assets y localización
* Imágenes:

* Productos y banners: URLs (Unsplash u otras).
* Foto de perfil: archivo local seleccionado por el usuario (no se sube por defecto).
* Opcional: agregar un PNG 1×1 transparente como placeholder si usas FadeInImage.assetNetwork.

* En pubspec.yaml:
[ flutter:
  assets:
    - assets/transparent.png
]
* Localización: strings base en es/en directamente en código. Se puede migrar a intl o flutter_localizations si se requiere.
  
-Troubleshooting

* No abre CatalogPage tras login

* Verifica que AuthBloc emite success = true (sin errorMessage).
* Revisa que en LoginPage/SignUpPage, el BlocConsumer haga pushAndRemoveUntil a CatalogPage.

* image_picker no abre galería

* iOS: confirma NSPhotoLibraryUsageDescription en Info.plist.
* Emuladores sin galería pueden fallar; probar en dispositivo físico o emulador con media.

* Fallo de Firebase

* Asegúrate que firebase_options.dart existe y Firebase.initializeApp se invoca con DefaultFirebaseOptions.currentPlatform.
* Verifica google-services.json (Android) y GoogleService-Info.plist (iOS) en rutas correctas.

* Búsqueda o filtros no responden

* Confirma que CatalogBloc recibe eventos (CatalogQueryChanged, CatalogCategoryChanged, etc.) y _applyFilters retorna visible con datos.

* Animación del carrito no se ve

* Revisa BlocListener<CartBloc, CartState> (comparación c.bump != p.bump) y que el botón “+” dispare CartItemAdded.
10) Mejoras futuras
* Persistencia de Perfil en Cloud Firestore y subida de foto a Firebase Storage (guardar la URL).
* Hydrated BLoC para preservar estados offline (carrito, filtros, perfil).
* Pruebas unitarias de BLoC (events → states).
* Efecto “fly-to-cart” animando el producto hacia el icono del carrito.
* Dark Mode y Localización con intl.
* Ruteo con go_router para navegación declarativa.
-Cómo contribuir
* Crea una rama: feat/mi-funcionalidad.
* Asegura que compila en Android/iOS.
* Envía PR con descripción y screenshots si involucra UI.
-Notas finales

* El perfil parte de un estado local (“usuario”) y se actualiza en memoria. Para apps productivas recomienda persistir esos datos por usuario en Firestore (users/{uid}) y almacenar la foto en Storage.
* El catálogo y categorías usan seeds locales con URLs; conecta una API/DB cuando lo necesites.
