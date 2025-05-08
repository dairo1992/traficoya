import 'package:flutter/material.dart';
import 'package:traficoya/interfaces/noticia_interface.dart';
import 'package:traficoya/widgets/card_detalle_news.dart';
import 'package:traficoya/widgets/card_full_news.dart';

class NoticiasScreen extends StatefulWidget {
  const NoticiasScreen({super.key});

  @override
  State<NoticiasScreen> createState() => _NoticiasScreenState();
}

class _NoticiasScreenState extends State<NoticiasScreen> {
  final List<String> categories = [
    'Todo',
    'Accidentes',
    'Avances de obra',
    'Cierres de via',
  ];

  int selectedCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: false,
              snap: true,
              title: const Text(
                'Noticias',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // Implementar búsqueda
                  },
                ),
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
                  _buildCategorySelector(),
                  Container(
                    height: 220,
                    padding: const EdgeInsets.only(top: 16),
                    child: PageView.builder(
                      controller: PageController(viewportFraction: 0.9),
                      itemCount: 5, // Número de noticias destacadas
                      itemBuilder: (context, index) {
                        return CardFullNew(
                          noticia: Noticia(
                            id: index,
                            titular: "Titular de una noticia",
                            imagen: "$index",
                            categoria: categories[index % categories.length],
                            descripcion:
                                "Sint voluptate voluptate duis irure incididunt officia incididunt sunt voluptate aute dolor commodo amet. Amet in enim reprehenderit eu commodo dolore elit velit deserunt nulla nulla. Reprehenderit voluptate proident laboris irure dolor ut ex. Veniam pariatur sint mollit in do fugiat. Id mollit laboris officia ad dolor enim nulla aute irure. Eiusmod ullamco elit aute laboris tempor ad amet enim anim anim. Esse mollit elit laboris culpa nostrud pariatur officia cillum adipisicing cillum eu cupidatat.",
                            fecha: "01/01/2023",
                            estado: "ACTIVO",
                          ),
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
                    noticia: Noticia(
                      id: index,
                      titular: "Titular de una noticia",
                      imagen: "$index",
                      categoria: categories[index % categories.length],
                      descripcion:
                          "Sint voluptate voluptate duis irure incididunt officia incididunt sunt voluptate aute dolor commodo amet. Amet in enim reprehenderit eu commodo dolore elit velit deserunt nulla nulla. Reprehenderit voluptate proident laboris irure dolor ut ex. Veniam pariatur sint mollit in do fugiat. Id mollit laboris officia ad dolor enim nulla aute irure. Eiusmod ullamco elit aute laboris tempor ad amet enim anim anim. Esse mollit elit laboris culpa nostrud pariatur officia cillum adipisicing cillum eu cupidatat.",
                      fecha: "01/01/2023",
                      estado: "ACTIVO",
                    ),
                  );
                },
                childCount: 10, // Número de noticias
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = selectedCategoryIndex == index;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(categories[index]),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    selectedCategoryIndex = index;
                  });
                }
              },
              backgroundColor:
                  isSelected
                      ? Theme.of(context).colorScheme.primaryContainer
                      : null,
              labelStyle: TextStyle(
                color:
                    isSelected
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          );
        },
      ),
    );
  }
}
