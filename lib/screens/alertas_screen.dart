import 'package:flutter/material.dart';
import 'package:traficoya/widgets/menu_widget.dart';

class AlertasScreen extends StatelessWidget {
  const AlertasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alertas')),
      body: Center(child: const Text('Alertas')),
      bottomNavigationBar: const FooterMenu(),
    );
  }
}
