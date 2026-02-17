import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/product.dart';
import 'catalog_event.dart';
import 'catalog_state.dart';

class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  final List<Product> seed;

  CatalogBloc(this.seed) : super(CatalogState.initial()) {
    on<CatalogLoadRequested>(_onLoad);
    on<CatalogQueryChanged>(_onQuery);
    on<CatalogCategoryChanged>(_onCategory);
    on<CatalogLocationChanged>(_onLocation);
    on<CatalogPriceSortChanged>(_onSort);
  }

  void _onLoad(CatalogLoadRequested e, Emitter<CatalogState> emit) {
    emit(state.copyWith(all: seed, loading: false));
    emit(_applyFilters(state.copyWith(all: seed)));
  }

  void _onQuery(CatalogQueryChanged e, Emitter<CatalogState> emit) {
    emit(_applyFilters(state.copyWith(query: e.query)));
  }

  void _onCategory(CatalogCategoryChanged e, Emitter<CatalogState> emit) {
    emit(_applyFilters(state.copyWith(category: e.category)));
  }

  void _onLocation(CatalogLocationChanged e, Emitter<CatalogState> emit) {
    emit(_applyFilters(state.copyWith(location: e.location)));
  }

  void _onSort(CatalogPriceSortChanged e, Emitter<CatalogState> emit) {
    emit(_applyFilters(state.copyWith(sort: e.sort)));
  }

  CatalogState _applyFilters(CatalogState s) {
    var list = List<Product>.from(s.all);

    // Búsqueda local
    final q = s.query.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((p) {
        return p.title.toLowerCase().contains(q) ||
            p.category.toLowerCase().contains(q) ||
            p.location.toLowerCase().contains(q) ||
            p.seller.toLowerCase().contains(q);
      }).toList();
    }

    if (s.category != null) {
      list = list.where((p) => p.category == s.category).toList();
    }
    if (s.location != null) {
      list = list.where((p) => p.location == s.location).toList();
    }

    switch (s.sort) {
      case PriceSort.lowToHigh:
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case PriceSort.highToLow:
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case PriceSort.none:
        break;
    }

    return s.copyWith(visible: list);
  }
}
