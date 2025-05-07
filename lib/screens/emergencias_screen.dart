import 'package:flutter/material.dart';
import 'package:traficoya/widgets/menu_widget.dart';

class EmergenciasScreen extends StatelessWidget {
  const EmergenciasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Emergencias")),
      body: Center(child: Text("Emergencias")),
      bottomNavigationBar: const FooterMenu(),
    );
  }
}
