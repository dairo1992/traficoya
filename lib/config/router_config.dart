import 'package:go_router/go_router.dart';
import 'package:traficoya/screens/acercade_screen.dart';
import 'package:traficoya/screens/alertas_screen.dart';
import 'package:traficoya/screens/emergencias_screen.dart';
import 'package:traficoya/screens/home_screen.dart';
import 'package:traficoya/screens/noticias_screen.dart';

final routes = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/news',
      builder: (context, state) => const NoticiasScreen(),
    ),
    GoRoute(
      path: '/alerts',
      builder: (context, state) => const AlertasScreen(),
    ),
    GoRoute(
      path: '/contacts',
      builder: (context, state) => const EmergenciasScreen(),
    ),
    GoRoute(
      path: '/about',
      builder: (context, state) => const AcercadeScreen(),
    ),
  ],
);
