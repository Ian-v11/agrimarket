class Product {
  final String id;
  final String title;
  final String category; // e.g., Vegetables, Grains, Tools, Poultry, Livestock
  final String location; // e.g., Managua, León, Bilwi
  final String seller;
  final String unit; // kg, ton, ea, doz
  final double price;
  final double rating;
  final String imageUrl;

  const Product({
    required this.id,
    required this.title,
    required this.category,
    required this.location,
    required this.seller,
    required this.unit,
    required this.price,
    required this.rating,
    required this.imageUrl,
  });
}
