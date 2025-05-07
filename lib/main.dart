import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:traficoya/config/router_config.dart';

void main() {
  runApp(
    // Envolvemos la aplicación con ProviderScope para usar Riverpod
    ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Traficoya',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade900),
      ),
      // Usamos el routerConfig de nuestro archivo de rutas
      routerConfig: routes,
    );
  }
}
