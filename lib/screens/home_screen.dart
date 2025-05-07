import 'package:flutter/material.dart';
import 'package:traficoya/widgets/menu_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Expanded(child: Center(child: Text('Hello World!')))],
      ),
      bottomNavigationBar: const FooterMenu(),
    );
  }
}
