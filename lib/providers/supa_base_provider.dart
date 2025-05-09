// supabase_provider.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Modelo para el estado de autenticación
class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;

  AuthState({this.user, this.isLoading = false, this.error});

  AuthState copyWith({User? user, bool? isLoading, String? error}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// Clase principal del proveedor de Supabase
class SupabaseNotifier extends StateNotifier<AuthState> {
  final SupabaseClient _supabase;

  SupabaseNotifier(this._supabase) : super(AuthState()) {
    // Inicializar escuchando los cambios de autenticación
    _supabase.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      if (event == AuthChangeEvent.signedIn ||
          event == AuthChangeEvent.userUpdated) {
        state = state.copyWith(
          user: session?.user,
          isLoading: false,
          error: null,
        );
      } else if (event == AuthChangeEvent.signedOut) {
        state = AuthState();
      }
    });

    // Verificar si ya hay una sesión activa
    _checkCurrentSession();
  }

  Future<void> _checkCurrentSession() async {
    state = state.copyWith(isLoading: true);
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser != null) {
        state = state.copyWith(user: currentUser, isLoading: false);
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // Método para iniciar sesión con Google
  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      if (kIsWeb) {
        // Implementación para Web
        await _supabase.auth.signInWithOAuth(
          OAuthProvider.google,
          redirectTo: 'tu-redirect-url',
        );
      } else {
        // Implementación para móvil
        await _supabase.auth.signInWithOAuth(OAuthProvider.google);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // Método para cerrar sesión
  Future<void> signOut() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _supabase.auth.signOut();
      state = AuthState();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // MÉTODOS PARA MANEJO DE DATOS

  // Método genérico para insertar datos
  Future<Map<String, dynamic>?> insertData(
    String table,
    Map<String, dynamic> data,
  ) async {
    try {
      final response =
          await _supabase.from(table).insert(data).select().single();
      return response;
    } catch (e) {
      debugPrint('Error al insertar datos: ${e.toString()}');
      return null;
    }
  }

  // Método genérico para actualizar datos
  Future<Map<String, dynamic>?> updateData(
    String table,
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response =
          await _supabase
              .from(table)
              .update(data)
              .eq('id', id)
              .select()
              .single();
      return response;
    } catch (e) {
      debugPrint('Error al actualizar datos: ${e.toString()}');
      return null;
    }
  }

  // Método genérico para eliminar datos
  Future<void> deleteData(String table, String id) async {
    try {
      await _supabase.from(table).delete().eq('id', id);
    } catch (e) {
      debugPrint('Error al eliminar datos: ${e.toString()}');
    }
  }

  // Método genérico para obtener todos los datos de una tabla
  Future<List<Map<String, dynamic>>?> getAllData(String table) async {
    try {
      final response = await _supabase.from(table).select();
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error al obtener datos: ${e.toString()}');
      return null;
    }
  }

  // Método genérico para obtener datos por ID
  Future<Map<String, dynamic>?> getDataById(String table, String id) async {
    try {
      final response =
          await _supabase.from(table).select().eq('id', id).single();
      return response;
    } catch (e) {
      debugPrint('Error al obtener dato por ID: ${e.toString()}');
      return null;
    }
  }

  // Método genérico para buscar datos con filtros personalizados
  Future<List<Map<String, dynamic>>?> queryData(
    String table,
    String column,
    dynamic value,
  ) async {
    try {
      final response = await _supabase.from(table).select().eq(column, value);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error al consultar datos: ${e.toString()}');
      return null;
    }
  }

  // Método para subir archivos
  Future<String?> uploadFile(
    String bucket,
    String path,
    Uint8List fileBytes,
  ) async {
    try {
      // await _supabase.storage.from(bucket).uploadBinary(path, fileBytes);
      // final String fileUrl = _supabase.storage.from(bucket).getPublicUrl(path);
      // return fileUrl;
      final String fullPath = await _supabase.storage
          .from(bucket)
          .uploadBinary(
            path,
            fileBytes,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      return fullPath;
    } catch (e) {
      debugPrint('Error al subir archivo: ${e.toString()}');
      return null;
    }
  }

  // Método para eliminar archivos
  Future<void> deleteFile(String bucket, String path) async {
    try {
      await _supabase.storage.from(bucket).remove([path]);
    } catch (e) {
      debugPrint('Error al eliminar archivo: ${e.toString()}');
    }
  }

  // Método para escuchar cambios en tiempo real
  Stream<List<Map<String, dynamic>>> streamData(String table) {
    return _supabase
        .from(table)
        .stream(primaryKey: ['id'])
        .map((event) => List<Map<String, dynamic>>.from(event));
  }
}

// Proveedores para usar con Riverpod

// Proveedor del cliente de Supabase
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// Proveedor del notificador de Supabase
final supabaseNotifierProvider =
    StateNotifierProvider<SupabaseNotifier, AuthState>((ref) {
      final supabaseClient = ref.watch(supabaseClientProvider);
      return SupabaseNotifier(supabaseClient);
    });

// Proveedor para acceder al usuario actual
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(supabaseNotifierProvider).user;
});

// Proveedor para verificar si el usuario está autenticado
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(supabaseNotifierProvider).user != null;
});
