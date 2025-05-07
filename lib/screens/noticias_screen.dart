import 'package:flutter/material.dart';
import 'package:traficoya/widgets/menu_widget.dart';

class NoticiasScreen extends StatelessWidget {
  const NoticiasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Noticias')),
      body: const Center(child: Text('Esta es la pantalla de noticias.')),
      bottomNavigationBar: const FooterMenu(),
    );
  }
}
