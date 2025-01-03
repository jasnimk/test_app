/// Represents a product in the e-commerce application.
///
/// This model is designed to store the essential details
/// for a product, including its ID, name, description,
/// price, images, and other attributes.
///
/// Fields:
/// - `id`: A unique identifier for the product.
/// - `name`: The name of the product.
/// - `description`: A brief description of the product.
/// - `price`: The price of the product in double format.
/// - `imageUrls`: A list of URLs pointing to images of the product.
/// - `category`: The category to which the product belongs
/// - `rating`: The average customer rating for the product (0 to 5).
/// - `stock`: The quantity of the product available in stock.
/// - `isFeatured`: A flag indicating if the product is featured.
///   Default is `false`.
/// - `brand`: The name of the product's brand. Default is an empty string.
///
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<String> imageUrls;
  final String category;
  final double rating;
  final int stock;
  final String material;
  final bool isFeatured;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrls,
    required this.category,
    required this.rating,
    required this.stock,
    required this.material,
    this.isFeatured = false,
  });

  // A factory constructor to convert a Map<String, dynamic> to a Product object
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      price: map['price'],
      imageUrls: List<String>.from(map['imageUrls']),
      category: map['category'],
      rating: map['rating'],
      stock: map['stock'],
      material: map['material'],
      isFeatured: map['isFeatured'] ?? false,
    );
  }
}
