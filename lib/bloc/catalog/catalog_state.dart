import '../../domain/product.dart';
import 'catalog_event.dart';

class CatalogState {
  final List<Product> all;
  final List<Product> visible;
  final String query;
  final String? category;
  final String? location;
  final PriceSort sort;
  final bool loading;

  const CatalogState({
    required this.all,
    required this.visible,
    required this.query,
    required this.category,
    required this.location,
    required this.sort,
    required this.loading,
  });

  factory CatalogState.initial() => const CatalogState(
    all: [],
    visible: [],
    query: '',
    category: null,
    location: null,
    sort: PriceSort.none,
    loading: true,
  );

  CatalogState copyWith({
    List<Product>? all,
    List<Product>? visible,
    String? query,
    String? Function()? clearQuery,
    String? category,
    String? Function()? clearCategory,
    String? location,
    String? Function()? clearLocation,
    PriceSort? sort,
    bool? loading,
  }) {
    return CatalogState(
      all: all ?? this.all,
      visible: visible ?? this.visible,
      query: clearQuery != null ? '' : (query ?? this.query),
      category: clearCategory != null ? null : (category ?? this.category),
      location: clearLocation != null ? null : (location ?? this.location),
      sort: sort ?? this.sort,
      loading: loading ?? this.loading,
    );
  }
}