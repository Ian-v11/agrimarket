import '../../domain/category.dart';

class CategoryState {
  final List<CategoryItem> all;
  final List<CategoryItem> visible;
  final String query;
  final bool loading;

  const CategoryState({
    required this.all,
    required this.visible,
    required this.query,
    required this.loading,
  });

  factory CategoryState.initial() =>
      const CategoryState(all: [], visible: [], query: '', loading: true);

  CategoryState copyWith({
    List<CategoryItem>? all,
    List<CategoryItem>? visible,
    String? query,
    bool? loading,
  }) {
    return CategoryState(
      all: all ?? this.all,
      visible: visible ?? this.visible,
      query: query ?? this.query,
      loading: loading ?? this.loading,
    );
  }
}