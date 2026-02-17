abstract class CategoryEvent {}

class CategoryLoadRequested extends CategoryEvent {}

class CategoryQueryChanged extends CategoryEvent {
  final String query;
  CategoryQueryChanged(this.query);
}