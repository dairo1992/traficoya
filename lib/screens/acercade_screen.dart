import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Importa para abrir URLs

class AcercadeScreen extends StatelessWidget {
  const AcercadeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acerca de TraficoYa'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Spacer(),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                "assets/icon.png",
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) => Container(
                      height: 150,
                      width: double.infinity,
                      color: Colors.grey.shade300,
                      child: const Center(
                        child: Icon(Icons.image_not_supported, size: 50),
                      ),
                    ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'TraficoYa',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent, // O el color de tu marca
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Versión: 0.0.1',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            const Text(
              'TraficoYa es tu asistente personal para navegar por el tráfico. Obtén información en tiempo real, rutas óptimas y evita congestiones para llegar a tu destino de forma más eficiente.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            InkWell(
              onTap: () async {
                final Uri url = Uri.parse('https://www.ingdairo.com');
                if (!await launchUrl(url)) {
                  // Manejar el error si no se puede abrir la URL
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No se pudo abrir el sitio web.'),
                    ),
                  );
                }
              },
              child: const Text(
                'Visita nuestro sitio web: www.ingdairo.com',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const Text(
              'Desarrollado por Dairo Rafael Barrios Ramos',
              style: TextStyle(fontSize: 14, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            const Text(
              '© 2025 Dairo Rafael Barrios Ramos. Todos los derechos reservados.',
              style: TextStyle(fontSize: 12, color: Colors.black45),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
