import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'core/theme.dart';
import 'data/auth_repository.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/auth/auth_event.dart';
import 'presentation/screens/login_page.dart';
import 'presentation/screens/catalog_page.dart';
import 'bloc/catalog/catalog_bloc.dart';
import 'bloc/catalog/catalog_event.dart';
import 'bloc/cart/cart_bloc.dart';
import 'data/fake_products.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const AgriMarketApp());
}

class AgriMarketApp extends StatelessWidget {
  const AgriMarketApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepo = AuthRepository();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CatalogBloc(initialProducts)..add(CatalogLoadRequested())),
        BlocProvider(create: (_) => CartBloc()),
        // AuthBloc se inyecta en cada pantalla de auth para poder tener modo login/signup
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AgriMarket',
        theme: buildTheme(),
        home: StreamBuilder<User?>(
          stream: authRepo.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            if (snapshot.data != null) {
              return const CatalogPage();
            }
            // No autenticado → Login
            return RepositoryProvider.value(
              value: authRepo,
              child: BlocProvider(
                create: (_) => AuthBloc(repository: authRepo, mode: AuthMode.login),
                child: const LoginPage(),
              ),
            );
          },
        ),
      ),
    );
  }
}