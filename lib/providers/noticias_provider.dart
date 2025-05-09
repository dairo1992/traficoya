import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:traficoya/interfaces/noticia_interface.dart';

// Modelo para el estado de noticias
class NewsState {
  final List<Noticia> noticias;
  final List<Noticia> noticiasFilter;
  final bool isLoading;
  final String? error;

  NewsState({
    this.noticias = const [],
    this.noticiasFilter = const [],
    this.isLoading = false,
    this.error,
  });

  NewsState copyWith({
    List<Noticia>? noticias,
    List<Noticia>? noticiasFilter,
    bool? isLoading,
    String? error,
  }) {
    return NewsState(
      noticias: noticias ?? this.noticias,
      noticiasFilter: noticiasFilter ?? this.noticiasFilter,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// Clase principal del proveedor de Noticias
class NewsNotifier extends StateNotifier<NewsState> {
  final SupabaseClient _supabase;
  final String _table = 'news'; // Nombre de la tabla en Supabase
  RealtimeChannel? _subscription;

  NewsNotifier(this._supabase) : super(NewsState()) {
    // Inicializar cargando las noticias
    fetchAllNews();
  }

  @override
  void dispose() {
    _subscription?.unsubscribe();
    super.dispose();
  }

  // Método para obtener todas las noticias
  Future<void> fetchAllNews() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _supabase
          .from(_table)
          .select()
          .order('fecha', ascending: false);
      final List<Noticia> noticias =
          List<Map<String, dynamic>>.from(
            response,
          ).map((data) => Noticia.fromJson(data)).toList();

      state = state.copyWith(
        noticias: noticias,
        isLoading: false,
        noticiasFilter: noticias,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<List<Noticia>> getAll() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _supabase
          .from(_table)
          .select()
          .order('fecha', ascending: false);
      final List<Noticia> noticias =
          List<Map<String, dynamic>>.from(
            response,
          ).map((data) => Noticia.fromJson(data)).toList();

      return noticias;
    } catch (e) {
      return [];
    }
  }

  // Método para obtener noticias por categoría
  Future<void> fetchNewsByCategory(String categoria) async {
    try {
      // if (categoria.toUpperCase() == 'TODAS') {
      state = state.copyWith(noticiasFilter: state.noticias, isLoading: false);
      // }
      final List<Noticia> noticias =
          state.noticias
              .where((element) => element.categoria == categoria.toUpperCase())
              .toList();
      state = state.copyWith(noticiasFilter: noticias, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      debugPrint('Error al obtener noticias por categoría: ${e.toString()}');
    }
  }

  // Método para obtener noticias por estado
  Future<void> fetchNewsByStatus(String estado) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _supabase
          .from(_table)
          .select()
          .eq('estado', estado)
          .order('fecha', ascending: false);
      final List<Noticia> noticias =
          List<Map<String, dynamic>>.from(
            response,
          ).map((data) => Noticia.fromJson(data)).toList();
      state = state.copyWith(noticias: noticias, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      debugPrint('Error al obtener noticias por estado: ${e.toString()}');
    }
  }

  // Método para obtener una noticia por ID - actualiza el estado pero también devuelve la noticia
  Future<void> getNewsById(int id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response =
          await _supabase.from(_table).select().eq('id', id).single();
      final noticia = Noticia.fromJson(response);

      // Actualizar el estado con la noticia encontrada en una lista de un solo elemento
      state = state.copyWith(noticias: [noticia], isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      debugPrint('Error al obtener noticia por ID: ${e.toString()}');
    }
  }

  // Método para buscar noticias por titular
  Future<void> searchNews(String query) async {
    if (query.isEmpty) {
      state = state.copyWith(noticiasFilter: state.noticias, isLoading: false);
      return;
    }

    state = state.copyWith(
      isLoading: true,
      error: null,
      noticiasFilter: state.noticias,
    );
    try {
      final List<Noticia> noticias =
          state.noticias
              .where(
                (noticia) =>
                    (noticia.titular.toLowerCase().contains(
                          query.toLowerCase(),
                        ) ||
                        noticia.descripcion.toLowerCase().contains(
                          query.toLowerCase(),
                        )),
              )
              .toList();
      state = state.copyWith(noticiasFilter: noticias, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      debugPrint('Error al buscar noticias: ${e.toString()}');
    }
  }

  // Método para crear una nueva noticia
  Future<void> createNews(Noticia noticia) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response =
          await _supabase
              .from(_table)
              .insert(noticia.toJson())
              .select()
              .single();
      final newNoticia = Noticia.fromJson(response);

      // Actualizar la lista de noticias en el estado
      final updatedNoticias = [newNoticia, ...state.noticias];
      state = state.copyWith(noticias: updatedNoticias, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      debugPrint('Error al crear noticia: ${e.toString()}');
    }
  }

  // Método para filtrar noticias por categoría en memoria
  void getNewsByCategory(String categoria) {
    try {
      state = state.copyWith(noticiasFilter: state.noticias, isLoading: false);
      if (categoria.toUpperCase() == 'TODAS') {
        return;
      }
      final List<Noticia> noticias =
          state.noticias
              .where(
                (element) =>
                    element.categoria ==
                    categoria.toUpperCase().replaceAll(' ', '_'),
              )
              .toList();
      state = state.copyWith(noticiasFilter: noticias, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      debugPrint('Error al obtener noticias por categoría: ${e.toString()}');
    }
  }

  // Método para filtrar noticias activas y actualizar el estado
  void getActiveNews() {
    var activeNoticias =
        state.noticias.where((noticia) => noticia.estado == 'activo').toList();

    state = state.copyWith(noticias: activeNoticias, isLoading: false);
  }
}

// Un único proveedor para el NewsNotifier
final newsProvider = StateNotifierProvider.autoDispose<NewsNotifier, NewsState>(
  (ref) {
    final supabaseClient = Supabase.instance.client;
    return NewsNotifier(supabaseClient);
  },
);
