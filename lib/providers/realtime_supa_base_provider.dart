// supabase_hooks.dart
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:traficoya/providers/supa_base_provider.dart';

// Provider para Stream de datos en tiempo real
final tableStreamProvider =
    StreamProvider.family<List<Map<String, dynamic>>, String>((ref, table) {
      final supabaseNotifier = ref.watch(supabaseNotifierProvider.notifier);
      return supabaseNotifier.streamData(table);
    });

// Hook para obtener datos de una tabla específica
class SupabaseDataHook {
  static AsyncValue<List<Map<String, dynamic>>> useTableStream(
    WidgetRef ref,
    String table,
  ) {
    return ref.watch(tableStreamProvider(table));
  }
}

// Hook para cargar una lista de datos desde Supabase
class UseSupabaseList<T> extends StateNotifier<AsyncValue<List<T>>> {
  final Ref ref;
  final String table;
  final T Function(Map<String, dynamic>) fromJson;
  final String? orderColumn;
  final bool ascending;
  final Map<String, dynamic>? filters;

  UseSupabaseList(
    this.ref,
    this.table,
    this.fromJson, {
    this.orderColumn,
    this.ascending = false,
    this.filters,
  }) : super(const AsyncValue.loading()) {
    loadData();
  }

  Future<void> loadData() async {
    state = const AsyncValue.loading();
    try {
      final supabaseNotifier = ref.read(supabaseNotifierProvider.notifier);
      List<Map<String, dynamic>>? data = await supabaseNotifier.getAllData(
        table,
      );

      if (data != null) {
        // Aplicar filtros si existen
        if (filters != null && filters!.isNotEmpty) {
          for (final entry in filters!.entries) {
            data =
                data!.where((item) => item[entry.key] == entry.value).toList();
          }
        }

        // Ordenar si se especifica una columna
        if (orderColumn != null) {
          data!.sort((a, b) {
            final valueA = a[orderColumn];
            final valueB = b[orderColumn];

            if (valueA == null || valueB == null) {
              return 0;
            }

            int compareResult;
            if (valueA is String && valueB is String) {
              compareResult = valueA.compareTo(valueB);
            } else if (valueA is num && valueB is num) {
              compareResult = valueA.compareTo(valueB);
            } else if (valueA is DateTime && valueB is DateTime) {
              compareResult = valueA.compareTo(valueB);
            } else {
              compareResult = 0;
            }

            return ascending ? compareResult : -compareResult;
          });
        }

        final List<T> items = data!.map((item) => fromJson(item)).toList();
        state = AsyncValue.data(items);
      } else {
        state = const AsyncValue.data([]);
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addItem(Map<String, dynamic> data) async {
    try {
      final supabaseNotifier = ref.read(supabaseNotifierProvider.notifier);
      await supabaseNotifier.insertData(table, data);
      await loadData();
    } catch (error) {
      debugPrint('Error al añadir item: ${error.toString()}');
    }
  }

  Future<void> updateItem(String id, Map<String, dynamic> data) async {
    try {
      final supabaseNotifier = ref.read(supabaseNotifierProvider.notifier);
      await supabaseNotifier.updateData(table, id, data);
      await loadData();
    } catch (error) {
      debugPrint('Error al actualizar item: ${error.toString()}');
    }
  }

  Future<void> deleteItem(String id) async {
    try {
      final supabaseNotifier = ref.read(supabaseNotifierProvider.notifier);
      await supabaseNotifier.deleteData(table, id);
      await loadData();
    } catch (error) {
      debugPrint('Error al eliminar item: ${error.toString()}');
    }
  }
}

// Provider para utilizar UseSupabaseList
final supabaseListProvider = StateNotifierProvider.family<
  UseSupabaseList<dynamic>,
  AsyncValue<List<dynamic>>,
  SupabaseListParams
>(
  (ref, params) => UseSupabaseList(
    ref,
    params.table,
    params.fromJson,
    orderColumn: params.orderColumn,
    ascending: params.ascending,
    filters: params.filters,
  ),
);

// Clase para parámetros del provider
class SupabaseListParams {
  final String table;
  final dynamic Function(Map<String, dynamic>) fromJson;
  final String? orderColumn;
  final bool ascending;
  final Map<String, dynamic>? filters;

  SupabaseListParams({
    required this.table,
    required this.fromJson,
    this.orderColumn,
    this.ascending = false,
    this.filters,
  });
}

// Hook para cargar un solo elemento de Supabase
class UseSupabaseItem<T> extends StateNotifier<AsyncValue<T?>> {
  final Ref ref;
  final String table;
  final String id;
  final T Function(Map<String, dynamic>) fromJson;

  UseSupabaseItem(this.ref, this.table, this.id, this.fromJson)
    : super(const AsyncValue.loading()) {
    loadData();
  }

  Future<void> loadData() async {
    state = const AsyncValue.loading();
    try {
      final supabaseNotifier = ref.read(supabaseNotifierProvider.notifier);
      final data = await supabaseNotifier.getDataById(table, id);

      if (data != null) {
        state = AsyncValue.data(fromJson(data));
      } else {
        state = const AsyncValue.data(null);
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateItem(Map<String, dynamic> data) async {
    try {
      final supabaseNotifier = ref.read(supabaseNotifierProvider.notifier);
      await supabaseNotifier.updateData(table, id, data);
      await loadData();
    } catch (error) {
      debugPrint('Error al actualizar item: ${error.toString()}');
    }
  }

  Future<void> deleteItem() async {
    try {
      final supabaseNotifier = ref.read(supabaseNotifierProvider.notifier);
      await supabaseNotifier.deleteData(table, id);
      state = const AsyncValue.data(null);
    } catch (error) {
      debugPrint('Error al eliminar item: ${error.toString()}');
    }
  }
}

// Provider para utilizar UseSupabaseItem
final supabaseItemProvider = StateNotifierProvider.family<
  UseSupabaseItem<dynamic>,
  AsyncValue<dynamic>,
  SupabaseItemParams
>(
  (ref, params) =>
      UseSupabaseItem(ref, params.table, params.id, params.fromJson),
);

// Clase para parámetros del provider de item
class SupabaseItemParams {
  final String table;
  final String id;
  final dynamic Function(Map<String, dynamic>) fromJson;

  SupabaseItemParams({
    required this.table,
    required this.id,
    required this.fromJson,
  });
}
