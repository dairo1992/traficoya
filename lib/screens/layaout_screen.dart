import 'package:flutter/material.dart';
import 'package:traficoya/widgets/menu_widget.dart';

class LayaoutScreen extends StatelessWidget {
  final Widget child;
  const LayaoutScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200, // Un fondo suave para toda la app
      body: SafeArea(
        bottom: false, // Para que el contenido no se solape con el FooterMenu elevado
        child: ClipRRect(
          // Agregamos bordes redondeados al contenido principal
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          child: Container(
            color: Colors.white,
            child: child, // El contenido de la pantalla actual
          ),
        ),
      ),
      extendBody: true, // Importante para que el contenido pueda verse detrás del navbar transparente
      bottomNavigationBar: const FooterMenu(),
    );
  }
}