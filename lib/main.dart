import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:traficoya/config/router_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const key =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp3bWdybXR1YnB1bWVla2pyeHRqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDY3MTE3OTYsImV4cCI6MjA2MjI4Nzc5Nn0.hb0QEs9Xp_d6mhRQKDr6QScLBgSm1Mvk_iTfqqkwFg8";
  HttpOverrides.global = MyHttpOverrides();
  await Supabase.initialize(
    url: 'https://jwmgrmtubpumeekjrxtj.supabase.co',
    anonKey: key,
  );
  runApp(ProviderScope(child: MyApp()));
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
      routerConfig: routes,
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
