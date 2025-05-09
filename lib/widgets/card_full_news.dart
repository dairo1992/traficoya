import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:traficoya/interfaces/noticia_interface.dart';
import 'package:intl/intl.dart';

class CardFullNew extends StatelessWidget {
  final Noticia noticia;

  const CardFullNew({super.key, required this.noticia});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/nueva-detalle', extra: {'noticia': noticia}),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                'https://jwmgrmtubpumeekjrxtj.supabase.co/storage/v1/object/public/${noticia.imagen}',
                fit: BoxFit.cover,
                loadingBuilder:
                    (context, child, loadingProgress) =>
                        loadingProgress == null
                            ? child
                            : const Center(child: CircularProgressIndicator()),
                errorBuilder:
                    (_, __, ___) => Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey.shade300,
                      child: const Center(
                        child: Icon(Icons.image_not_supported, size: 50),
                      ),
                    ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      color: Colors.white70,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      formatTimeAgo(noticia.fecha),
                      // '${index + 1}h atrás',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          noticia.categoria.replaceAll('_', ' '),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        noticia.titular,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatTimeAgo(String dateTime) {
    final fecha = DateTime.parse(dateTime);
    final String formattedDate = DateFormat(
      'yyyy-dd-MMTHH:mm:ss',
    ).format(fecha);
    final fechaf = DateTime.parse(formattedDate);
    final now = DateTime.now();
    final difference = now.difference(fechaf);

    if (difference.inSeconds < 60) {
      return 'hace ${difference.inSeconds} seg';
    } else if (difference.inMinutes < 60) {
      return 'hace ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'hace ${difference.inHours} h';
    } else if (difference.inDays == 1) {
      return 'ayer';
    } else if (difference.inDays < 7) {
      return 'hace ${difference.inDays} días';
    } else {
      return DateFormat(
        'dd MMM yyyy',
        'es_ES',
      ).format(fecha); // Formato más largo para fechas antiguas
    }
  }
}
