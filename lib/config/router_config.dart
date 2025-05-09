import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:traficoya/interfaces/noticia_interface.dart';
import 'package:traficoya/screens/acercade_screen.dart';
import 'package:traficoya/screens/agregar_noticia.dart';
import 'package:traficoya/screens/alertas_screen.dart';
import 'package:traficoya/screens/emergencias_screen.dart';
import 'package:traficoya/screens/home_screen.dart';
import 'package:traficoya/screens/noticia_detalle_screen.dart';
import 'package:traficoya/screens/noticias_screen.dart';
import 'package:traficoya/screens/layaout_screen.dart';

// Clase para crear transiciones personalizadas
class CustomPageTransition extends CustomTransitionPage<void> {
  CustomPageTransition({
    required super.child,
    required String super.name,
    required PageTransition transitionType,
    super.key,
  }) : super(
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           // Definimos diferentes tipos de transiciones
           switch (transitionType) {
             case PageTransition.fade:
               return FadeTransition(
                 opacity: CurveTween(
                   curve: Curves.easeInOut,
                 ).animate(animation),
                 child: child,
               );
             case PageTransition.slideRight:
               return SlideTransition(
                 position: Tween<Offset>(
                   begin: const Offset(-1, 0),
                   end: Offset.zero,
                 ).animate(
                   CurveTween(curve: Curves.easeInOut).animate(animation),
                 ),
                 child: child,
               );
             case PageTransition.slideLeft:
               return SlideTransition(
                 position: Tween<Offset>(
                   begin: const Offset(1, 0),
                   end: Offset.zero,
                 ).animate(
                   CurveTween(curve: Curves.easeInOut).animate(animation),
                 ),
                 child: child,
               );
             case PageTransition.scale:
               return ScaleTransition(
                 scale: CurveTween(curve: Curves.easeInOut).animate(animation),
                 child: child,
               );
             default:
               return FadeTransition(
                 opacity: CurveTween(
                   curve: Curves.easeInOut,
                 ).animate(animation),
                 child: child,
               );
           }
         },
       );
}

// Enumeración para los tipos de transición
enum PageTransition { fade, slideRight, slideLeft, scale }

final routes = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return LayaoutScreen(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          pageBuilder:
              (context, state) => CustomPageTransition(
                name: 'home',
                child: const HomeScreen(),
                transitionType: PageTransition.fade,
              ),
        ),
        GoRoute(
          path: '/news',
          pageBuilder:
              (context, state) => CustomPageTransition(
                name: 'news',
                child: const NoticiasScreen(),
                transitionType: PageTransition.slideLeft,
              ),
        ),
        GoRoute(
          path: '/alerts',
          pageBuilder:
              (context, state) => CustomPageTransition(
                name: 'alerts',
                child: const AlertasScreen(),
                transitionType: PageTransition.slideLeft,
              ),
        ),
        GoRoute(
          path: '/contacts',
          pageBuilder:
              (context, state) => CustomPageTransition(
                name: 'contacts',
                child: const EmergenciasScreen(),
                transitionType: PageTransition.slideLeft,
              ),
        ),
        GoRoute(
          path: '/about',
          pageBuilder:
              (context, state) => CustomPageTransition(
                name: 'contacts',
                child: const AcercadeScreen(),
                transitionType: PageTransition.slideLeft,
              ),
        ),
        GoRoute(
          path: '/nueva-noticia',
          pageBuilder:
              (context, state) => CustomPageTransition(
                name: 'contacts',
                child: const NewsCreationScreen(),
                transitionType: PageTransition.slideLeft,
              ),
        ),
        GoRoute(
          path: '/nueva-detalle',
          pageBuilder: (context, state) {
            Map<String, dynamic> args = state.extra as Map<String, dynamic>;
            return CustomPageTransition(
              name: 'contacts',
              child: NoticiaDetailScreen(noticia: args['noticia']),
              transitionType: PageTransition.slideLeft,
            );
          },
        ),
      ],
    ),
  ],
);
