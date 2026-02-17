import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/category.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final List<CategoryItem> seed;

  CategoryBloc(this.seed) : super(CategoryState.initial()) {
    on<CategoryLoadRequested>(_onLoad);
    on<CategoryQueryChanged>(_onQuery);
  }

  void _onLoad(CategoryLoadRequested e, Emitter<CategoryState> emit) {
    emit(state.copyWith(all: seed, visible: seed, loading: false));
  }

  void _onQuery(CategoryQueryChanged e, Emitter<CategoryState> emit) {
    final q = e.query.trim().toLowerCase();
    final filtered = q.isEmpty
        ? state.all
        : state.all.where((c) => c.name.toLowerCase().contains(q)).toList();
    emit(state.copyWith(query: e.query, visible: filtered));
  }
}