import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:traficoya/providers/noticias_provider.dart';
import 'package:traficoya/widgets/card_detalle_news.dart';
import 'package:traficoya/widgets/card_full_news.dart';
import 'package:traficoya/widgets/categorias_news.dart';

class NoticiasScreen extends ConsumerWidget {
  const NoticiasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(newsProvider);
    final categorias = [
      "TODAS",
      "ACCIDENTES",
      "AVANCES DE OBRA",
      "CIERRES DE VIA",
    ];
    return Scaffold(
      body: SafeArea(
        child:
            state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      floating: true,
                      pinned: false,
                      snap: true,
                      title: Text(
                        'Noticias',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.notifications_outlined),
                          onPressed: () {
                            // Implementar notificaciones
                          },
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextFormField(
                              textInputAction: TextInputAction.search,
                              onFieldSubmitted: (query) {
                                 ref.read(newsProvider.notifier).searchNews(query);
                              },
                              decoration: InputDecoration(
                                hintText: 'Buscar noticias',
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.grey[100],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Noticias de Hoy',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Categorias(categorias: categorias),
                          Container(
                            height: 220,
                            padding: const EdgeInsets.only(top: 16),
                            child: PageView.builder(
                              controller: PageController(viewportFraction: 0.9),
                              itemCount:
                                  state
                                      .noticiasFilter
                                      .length, // Número de noticias destacadas
                              itemBuilder: (context, index) {
                                return CardFullNew(
                                  noticia: state.noticiasFilter[index],
                                );
                              },
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: Text(
                              'Últimas Noticias',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return CardDetalleNews(
                            context: context,
                            noticia: state.noticiasFilter[index],
                          );
                        },
                        childCount:
                            state.noticiasFilter.length, // Número de noticias
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
