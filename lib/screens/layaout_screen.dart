import 'package:flutter/material.dart';
import 'package:traficoya/widgets/menu_widget.dart';

class LayaoutScreen extends StatelessWidget {
  final Widget child;
  const LayaoutScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: child, // Aquí se renderiza el contenido de cada pantalla
          ),
        ],
      ),
      bottomNavigationBar: const FooterMenu(),
    );
  }
}