import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Necesitarás agregar 'intl: ^0.19.0' o la versión más reciente a tu pubspec.yaml
// Modelo para un artículo de noticias
class NewsArticle {
  final String id;
  final String title;
  final String summary;
  final String imageUrl;
  final String source;
  final DateTime publishedDate;
  final String category;
  final String content; // Contenido completo para una vista detallada (opcional aquí)

  NewsArticle({
    required this.id,
    required this.title,
    required this.summary,
    required this.imageUrl,
    required this.source,
    required this.publishedDate,
    required this.category,
    this.content = "Contenido detallado del artículo...",
  });
}

// Datos de ejemplo
final List<NewsArticle> sampleArticles = [
  NewsArticle(
    id: '1',
    title: 'Flutter 3.22: Novedades y Mejoras de Rendimiento',
    summary:
        'Descubre las últimas características introducidas en Flutter 3.22, enfocadas en optimizar el rendimiento y la experiencia del desarrollador.',
    imageUrl: 'https://picsum.photos/seed/flutter/600/400', // Placeholder
    source: 'Flutter Team Blog',
    publishedDate: DateTime.now().subtract(const Duration(hours: 2)),
    category: 'Tecnología',
  ),
  NewsArticle(
    id: '2',
    title: 'El Futuro de la IA Generativa en el Diseño de Interfaces',
    summary:
        'Un análisis profundo sobre cómo la inteligencia artificial generativa está transformando la creación de UIs.',
    imageUrl: 'https://picsum.photos/seed/ai/600/400', // Placeholder
    source: 'TechCrunch',
    publishedDate: DateTime.now().subtract(const Duration(hours: 5)),
    category: 'IA',
  ),
  NewsArticle(
    id: '3',
    title: 'Tendencias de Diseño UX/UI para 2025',
    summary:
        'Explora las tendencias emergentes en diseño de experiencia de usuario e interfaz que dominarán el próximo año.',
    imageUrl: 'https://picsum.photos/seed/uxui/600/400', // Placeholder
    source: 'Smashing Magazine',
    publishedDate: DateTime.now().subtract(const Duration(days: 1)),
    category: 'Diseño',
  ),
  NewsArticle(
    id: '4',
    title: 'Desarrollo Sostenible: Innovaciones que Marcan la Diferencia',
    summary:
        'Conoce los proyectos de desarrollo sostenible más impactantes y cómo la tecnología juega un papel crucial.',
    imageUrl: 'https://picsum.photos/seed/sostenible/600/400', // Placeholder
    source: 'National Geographic',
    publishedDate: DateTime.now().subtract(const Duration(days: 2, hours: 3)),
    category: 'Global',
  ),
  NewsArticle(
    id: '5',
    title: 'La Nueva Era de los Dispositivos Plegables',
    summary:
        'Samsung y Google presentan sus nuevas apuestas en el mercado de los móviles plegables, ¿qué podemos esperar?',
    imageUrl: 'https://picsum.photos/seed/foldable/600/400', // Placeholder
    source: 'The Verge',
    publishedDate: DateTime.now().subtract(const Duration(hours: 8)),
    category: 'Tecnología',
  ),
];

class NoticiasScreen extends StatelessWidget {
  const NoticiasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Noticias Frescas',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        brightness: Brightness.light, // Tema claro por defecto
        fontFamily: 'Roboto', // Puedes usar una fuente personalizada
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 1,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepPurple,
          accentColor: Colors.amber, // Un color de acento vibrante
        ).copyWith(
          surface: Colors.white, // Fondo de las tarjetas
          onSurface: Colors.black87, // Texto sobre las tarjetas
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.black54),
          labelSmall: TextStyle(fontSize: 12, color: Colors.black45),
        ),
      ),
      home: const NewsScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _categories = [
    'Todas',
    'Tecnología',
    'IA',
    'Diseño',
    'Global'
  ];

  List<NewsArticle> _filteredArticles = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _filterArticles(); // Carga inicial
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      _filterArticles();
    }
  }

  void _filterArticles() {
    final selectedCategory = _categories[_tabController.index];
    setState(() {
      if (selectedCategory == 'Todas') {
        _filteredArticles = List.from(sampleArticles);
      } else {
        _filteredArticles = sampleArticles
            .where((article) => article.category == selectedCategory)
            .toList();
      }
      // Ordenar por fecha más reciente
      _filteredArticles.sort((a, b) => b.publishedDate.compareTo(a.publishedDate));
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Noticias Frescas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Lógica de búsqueda
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Funcionalidad de búsqueda no implementada')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Lógica para más opciones
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Theme.of(context).colorScheme.secondary,
          labelColor: Theme.of(context).colorScheme.secondary,
          unselectedLabelColor: Colors.black54,
          tabs: _categories.map((String category) {
            return Tab(text: category);
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _categories.map((String category) {
          // Podríamos pasar _filteredArticles directamente si no quisiéramos
          // una vista por cada tab en TabBarView, pero así es más explícito.
          // Para este ejemplo, el filtro ya se hizo en _filterArticles.
          if (_filteredArticles.isEmpty && category != 'Todas') {
             // Podríamos tener una lista específica por categoría si quisiéramos
             // evitar el filtro global _filteredArticles en cada build del TabBarView
             final categorySpecificArticles = sampleArticles
                .where((article) => article.category == category)
                .toList();
             categorySpecificArticles.sort((a, b) => b.publishedDate.compareTo(a.publishedDate));
             if (categorySpecificArticles.isEmpty) {
                return Center(child: Text('No hay noticias en "$category"'));
             }
             return NewsList(articles: categorySpecificArticles);
          }
          if (_filteredArticles.isEmpty && category == 'Todas' && sampleArticles.isNotEmpty) {
            // Caso borde si el filtro inicial fallara pero hay datos
             return NewsList(articles: sampleArticles..sort((a, b) => b.publishedDate.compareTo(a.publishedDate)));
          }
          if (_filteredArticles.isEmpty) {
             return Center(child: Text('No hay noticias en "$category"'));
          }
          return NewsList(articles: _filteredArticles);
        }).toList(),
      ),
    );
  }
}

class NewsList extends StatelessWidget {
  final List<NewsArticle> articles;

  const NewsList({super.key, required this.articles});

  @override
  Widget build(BuildContext context) {
    if (articles.isEmpty) {
      return const Center(
        child: Text(
          'No hay noticias para mostrar.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }
    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        return NewsArticleCard(article: article);
      },
    );
  }
}


class NewsArticleCard extends StatelessWidget {
  final NewsArticle article;

  const NewsArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final timeAgo = formatTimeAgo(article.publishedDate);

    return Card(
      // El estilo ya se define en ThemeData -> cardTheme
      child: InkWell(
        onTap: () {
          // Navegar a una pantalla de detalle del artículo
          // Navigator.push(context, MaterialPageRoute(builder: (context) => ArticleDetailScreen(article: article)));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Leyendo: ${article.title}')),
          );
        },
        borderRadius: BorderRadius.circular(12), // Para que el ripple effect coincida
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'news_image_${article.id}', // Tag único para la animación Hero
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  article.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  // Placeholder y error para la imagen
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                    return Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: const Center(child: Icon(Icons.broken_image, color: Colors.grey, size: 50)),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.category.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article.title,
                    style: Theme.of(context).textTheme.titleLarge,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article.summary,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        article.source,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      Text(
                        timeAgo, // Usar el tiempo formateado
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Función para formatear el tiempo transcurrido
String formatTimeAgo(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

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
    return DateFormat('dd MMM yyyy', 'es_ES').format(dateTime); // Formato más largo para fechas antiguas
  }
}

// Opcional: Si quieres una pantalla de detalle
// class ArticleDetailScreen extends StatelessWidget {
//   final NewsArticle article;
//   const ArticleDetailScreen({super.key, required this.article});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(article.source)),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Hero(
//               tag: 'news_image_${article.id}',
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: Image.network(
//                   article.imageUrl,
//                   fit: BoxFit.cover,
//                   width: double.infinity,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               article.title,
//               style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
//                 const SizedBox(width: 4),
//                 Text(
//                   DateFormat('dd MMM yyyy, HH:mm', 'es_ES').format(article.publishedDate),
//                   style: Theme.of(context).textTheme.bodySmall,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Text(
//               article.content, // Usar el contenido completo aquí
//               style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }