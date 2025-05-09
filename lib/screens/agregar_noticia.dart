// news_creation_screen.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:traficoya/providers/realtime_supa_base_provider.dart';
import 'package:traficoya/providers/supa_base_provider.dart';
import 'package:uuid/uuid.dart';

// Modelo de Noticia
class News {
  final String id;
  final String titular;
  final String imagen;
  final String categoria;
  final String descripcion;
  final String fecha;
  final String estado;

  News({
    required this.id,
    required this.titular,
    required this.imagen,
    required this.categoria,
    required this.descripcion,
    required this.fecha,
    required this.estado,
  });

  // Convertir de JSON a objeto News
  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'].toString(),
      titular: json['titular'] ?? '',
      imagen: json['imagen'] ?? '',
      categoria: json['categoria'] ?? '',
      descripcion: json['descripcion'] ?? '',
      fecha: json['fecha'] ?? '',
      estado: json['estado'] ?? 'ACTIVO',
    );
  }

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titular': titular,
      'imagen': imagen,
      'categoria': categoria,
      'descripcion': descripcion,
      'fecha': fecha,
      'estado': estado,
    };
  }
}

// Categorías disponibles para noticias
enum NewsCategory {
  // ACCIDENTE,
  // POLITICA,
  // ECONOMIA,
  // DEPORTES,
  // TECNOLOGIA,
  // SALUD,
  // CULTURA,
  // ENTRETENIMIENTO,
  ACCIDENTES,
  AVANCES_DE_OBRA,
  CIERRES_DE_VIA,
}

// Provider para manejar el estado del formulario de noticias
class NewsFormNotifier extends StateNotifier<AsyncValue<void>> {
  final SupabaseNotifier _supabaseNotifier;
  final ImagePicker _imagePicker = ImagePicker();

  NewsFormNotifier(this._supabaseNotifier) : super(const AsyncValue.data(null));

  // Método para subir una imagen a Supabase Storage
  Future<String?> _uploadImage(XFile image) async {
    try {
      final Uint8List bytes = await image.readAsBytes();
      final String fileName = '${const Uuid().v4()}_${image.name}';
      final path = 'news-media/$fileName';

      final imageUrl = await _supabaseNotifier.uploadFile(
        'news-media',
        path,
        bytes,
      );
      return imageUrl;
    } catch (e) {
      debugPrint('Error al subir imagen: ${e.toString()}');
      return null;
    }
  }

  // Método para seleccionar una imagen de la galería
  Future<XFile?> pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      return image;
    } catch (e) {
      debugPrint('Error al seleccionar imagen: ${e.toString()}');
      return null;
    }
  }

  // Método para crear una nueva noticia
  Future<bool> createNews({
    required String titular,
    required XFile? imagen,
    required NewsCategory categoria,
    required String descripcion,
  }) async {
    state = const AsyncValue.loading();

    try {
      // Formateamos la fecha actual
      final now = DateTime.now();
      final String formattedDate = DateFormat(
        'dd/MM/yyyy HH:mm:ss',
      ).format(now);

      // Subimos la imagen si existe
      String? imageUrl;
      if (imagen != null) {
        imageUrl = await _uploadImage(imagen);
        if (imageUrl == null) {
          state = AsyncValue.error(
            'Error al subir la imagen',
            StackTrace.current,
          );
          return false;
        }
      }

      // Creamos el objeto de noticia
      final news = News(
        id: const Uuid().v4(),
        titular: titular,
        imagen: imageUrl ?? '',
        categoria: categoria.toString().split('.').last,
        descripcion: descripcion,
        fecha: formattedDate,
        estado: 'ACTIVO',
      );

      // Guardamos en Supabase
      final result = await _supabaseNotifier.insertData('news', news.toJson());

      if (result != null) {
        state = const AsyncValue.data(null);
        return true;
      } else {
        state = AsyncValue.error(
          'Error al crear la noticia',
          StackTrace.current,
        );
        return false;
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }
}

// Provider para el formulario de noticias
final newsFormProvider =
    StateNotifierProvider<NewsFormNotifier, AsyncValue<void>>((ref) {
      final supabaseNotifier = ref.watch(supabaseNotifierProvider.notifier);
      return NewsFormNotifier(supabaseNotifier);
    });

// Provider para las noticias
final newsProvider = StateNotifierProvider.family<
  UseSupabaseList<News>,
  AsyncValue<List<News>>,
  String?
>((ref, categoryFilter) {
  return UseSupabaseList<News>(
    ref,
    'news',
    News.fromJson,
    orderColumn: 'fecha',
    ascending: false,
    filters: categoryFilter != null ? {'categoria': categoryFilter} : null,
  );
});

class NewsCreationScreen extends ConsumerStatefulWidget {
  const NewsCreationScreen({super.key});

  @override
  _NewsCreationScreenState createState() => _NewsCreationScreenState();
}

class _NewsCreationScreenState extends ConsumerState<NewsCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titularController = TextEditingController();
  final _descripcionController = TextEditingController();
  NewsCategory _selectedCategory = NewsCategory.AVANCES_DE_OBRA;
  XFile? _selectedImage;
  bool _isImageLoading = false;

  @override
  void dispose() {
    _titularController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  // Método para seleccionar una imagen
  Future<void> _pickImage() async {
    setState(() {
      _isImageLoading = true;
    });

    final newsForm = ref.read(newsFormProvider.notifier);
    final image = await newsForm.pickImage();

    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }

    setState(() {
      _isImageLoading = false;
    });
  }

  // Método para enviar el formulario
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final newsForm = ref.read(newsFormProvider.notifier);

      final success = await newsForm.createNews(
        titular: _titularController.text,
        imagen: _selectedImage,
        categoria: _selectedCategory,
        descripcion: _descripcionController.text,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Noticia creada con éxito!'),
            backgroundColor: Colors.green,
          ),
        );

        // Limpiamos el formulario
        _titularController.clear();
        _descripcionController.clear();
        setState(() {
          _selectedCategory = NewsCategory.ACCIDENTES;
          _selectedImage = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Observar el estado del formulario
    final formState = ref.watch(newsFormProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Noticia'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Imagen de la noticia
                GestureDetector(
                  onTap: _isImageLoading ? null : _pickImage,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child:
                        _isImageLoading
                            ? const Center(child: CircularProgressIndicator())
                            : _selectedImage != null
                            ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: FutureBuilder<Uint8List>(
                                future: _selectedImage!.readAsBytes(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  if (snapshot.hasData) {
                                    return Image.memory(
                                      snapshot.data!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    );
                                  }
                                  return const Center(child: Icon(Icons.error));
                                },
                              ),
                            )
                            : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.add_photo_alternate_outlined,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Seleccionar imagen',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                  ),
                ),
                const SizedBox(height: 24),

                // Titular
                TextFormField(
                  controller: _titularController,
                  decoration: InputDecoration(
                    labelText: 'Titular',
                    hintText: 'Escribe un titular impactante',
                    prefixIcon: const Icon(Icons.title),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa un titular';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Categoría
                DropdownButtonFormField<NewsCategory>(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Categoría',
                    prefixIcon: const Icon(Icons.category),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  items:
                      NewsCategory.values.map((category) {
                        return DropdownMenuItem<NewsCategory>(
                          value: category,
                          child: Text(category.toString().split('.').last),
                        );
                      }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Descripción
                TextFormField(
                  controller: _descripcionController,
                  decoration: InputDecoration(
                    labelText: 'Descripción',
                    hintText: 'Escribe el contenido de la noticia',
                    prefixIcon: const Icon(Icons.description),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  maxLines: 6,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa una descripción';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Botón para crear noticia
                ElevatedButton(
                  onPressed: formState.isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  child:
                      formState.isLoading
                          ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                          : const Text(
                            'PUBLICAR NOTICIA',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),

                // Mostrar error si existe
                if (formState.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      'Error: ${formState.error.toString()}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
