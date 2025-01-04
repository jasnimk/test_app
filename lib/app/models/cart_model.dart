import 'package:test_ecommerce_app/app/models/product_model.dart';

class CartItem {
  final String id;
  final Product product;
  int quantity;

  double get totalPrice => product.price * quantity;

  CartItem({
    required this.id,
    required this.product,
    this.quantity = 1,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': product.id,
      'quantity': quantity,
      'price': product.price,
      'name': product.name,
      'imageUrl': product.imageUrls.isNotEmpty ? product.imageUrls[0] : '',
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map, Product product) {
    return CartItem(
      id: map['id'] ?? '',
      product: product,
      quantity: map['quantity']?.toInt() ?? 1,
    );
  }
}
