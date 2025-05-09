import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:traficoya/interfaces/noticia_interface.dart';

class NoticiaDetailScreen extends StatelessWidget {
  final Noticia noticia;

  const NoticiaDetailScreen({super.key, required this.noticia});

  @override
  Widget build(BuildContext context) {
    final fechaFormateada = DateFormat(
      'dd/MM/yyyy HH:mm',
    ).format(DateTime.parse(noticia.fecha));
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detalle de Noticia',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actionsIconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade900,
      ),
      body: SizedBox(
        height: 710,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen de la noticia (si existe)
              if (noticia.imagen.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    'https://jwmgrmtubpumeekjrxtj.supabase.co/storage/v1/object/public/${noticia.imagen}',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) => Container(
                          height: 200,
                          width: double.infinity,
                          color: Colors.grey.shade300,
                          child: const Center(
                            child: Icon(Icons.image_not_supported, size: 50),
                          ),
                        ),
                    loadingBuilder:
                        (context, child, loadingProgress) =>
                            loadingProgress == null
                                ? child
                                : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                  ),
                ),

              const SizedBox(height: 16),

              // Titular
              Text(
                noticia.titular,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              // Etiquetas e información adicional
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Chip(
                    label: Text(noticia.categoria.replaceAll('_', ' ')),
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Chip(
                    label: Text(fechaFormateada),
                    backgroundColor: Colors.green.shade100,
                    labelStyle: TextStyle(color: Colors.green.shade800),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              // Contenido
              const Text(
                'Contenido:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(noticia.descripcion),
            ],
          ),
        ),
      ),
    );
  }
}
