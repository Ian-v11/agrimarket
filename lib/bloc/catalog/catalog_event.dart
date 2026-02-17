import '../../domain/product.dart';

abstract class CatalogEvent {}

class CatalogLoadRequested extends CatalogEvent {}

class CatalogQueryChanged extends CatalogEvent {
  final String query;
  CatalogQueryChanged(this.query);
}

class CatalogCategoryChanged extends CatalogEvent {
  final String? category; // null -> Todas
  CatalogCategoryChanged(this.category);
}

class CatalogLocationChanged extends CatalogEvent {
  final String? location; // null -> Todas
  CatalogLocationChanged(this.location);
}

enum PriceSort { none, lowToHigh, highToLow }

class CatalogPriceSortChanged extends CatalogEvent {
  final PriceSort sort;
  CatalogPriceSortChanged(this.sort);
}