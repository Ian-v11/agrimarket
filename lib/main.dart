import 'package:agrimarket/bloc/catalog/catalog_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app.dart';
import 'bloc/cart/cart_bloc.dart';
import 'bloc/catalog/catalog_bloc.dart';
import 'data/fake_products.dart';
import 'bloc/category/category_bloc.dart';
import 'data/fake_categories.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(

      MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => CatalogBloc(initialProducts)..add(CatalogLoadRequested())),
          BlocProvider(create: (_) => CartBloc()),
          BlocProvider(create: (_) => CategoryBloc(categoriesSeed)), // <— NUEVO
        ],
        child: const AgriMarketApp(),
      )
  );
      }