import 'package:flutter/material.dart';
import 'package:traficoya/widgets/menu_widget.dart';

class AcercadeScreen extends StatelessWidget {
  const AcercadeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Acerca de')),
      body: const Center(child: Text("Acerca de la app")),
      bottomNavigationBar: const FooterMenu(),
    );
  }
}
