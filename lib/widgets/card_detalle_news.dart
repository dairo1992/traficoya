import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:traficoya/interfaces/noticia_interface.dart';
import 'package:intl/intl.dart';

class CardDetalleNews extends StatelessWidget {
  final BuildContext context;
  final Noticia noticia;

  const CardDetalleNews({
    super.key,
    required this.context,
    required this.noticia,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap:
            () => context.push('/nueva-detalle', extra: {'noticia': noticia}),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  'https://jwmgrmtubpumeekjrxtj.supabase.co/storage/v1/object/public/${noticia.imagen}',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  loadingBuilder:
                      (context, child, loadingProgress) =>
                          loadingProgress == null
                              ? child
                              : const Center(
                                child: CircularProgressIndicator(),
                              ),
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
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            noticia.categoria.replaceAll('_', ' '),
                            style: TextStyle(
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color:
                                  Theme.of(context).textTheme.bodySmall?.color,
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              formatTimeAgo(noticia.fecha),
                              style: TextStyle(
                                color:
                                    Theme.of(
                                      context,
                                    ).textTheme.bodySmall?.color,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      noticia.titular,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      noticia.descripcion,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
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
