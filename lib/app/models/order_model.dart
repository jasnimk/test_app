// import 'package:test_ecommerce_app/app/models/order_item_model.dart';

// class Order {
//   String? orderId;
//   final String userId;
//   final String addressId;
//   final List<OrderItem> items;
//   final double totalAmount;
//   final String paymentMethod;
//   final String paymentStatus;
//   final String orderStatus;
//   final DateTime createdAt;

//   Order({
//     this.orderId,
//     required this.userId,
//     required this.addressId,
//     required this.items,
//     required this.totalAmount,
//     required this.paymentMethod,
//     required this.paymentStatus,
//     required this.orderStatus,
//     required this.createdAt,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'orderId': orderId,
//       'userId': userId,
//       'addressId': addressId,
//       'items': items.map((item) => item.toMap()).toList(),
//       'totalAmount': totalAmount,
//       'paymentMethod': paymentMethod,
//       'paymentStatus': paymentStatus,
//       'orderStatus': orderStatus,
//       'createdAt': createdAt.toIso8601String(),
//     };
//   }

//   factory Order.fromMap(Map<String, dynamic> map) {
//     return Order(
//       orderId: map['orderId'],
//       userId: map['userId'] ?? '',
//       addressId: map['addressId'] ?? '',
//       items: (map['items'] as List<dynamic>?)
//               ?.map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
//               .toList() ??
//           [],
//       totalAmount: (map['totalAmount'] ?? 0.0).toDouble(),
//       paymentMethod: map['paymentMethod'] ?? '',
//       paymentStatus: map['paymentStatus'] ?? '',
//       orderStatus: map['orderStatus'] ?? '',
//       createdAt: DateTime.parse(map['createdAt'] as String),
//     );
//   }
// }
import 'package:test_ecommerce_app/app/models/order_item_model.dart';

class CustomerOrder {
  // Renamed from Order to CustomerOrder
  String? orderId;
  final String userId;
  final String addressId;
  final List<OrderItem> items;
  final double totalAmount;
  final String paymentMethod;
  final String paymentStatus;
  final String orderStatus;
  final DateTime createdAt;

  CustomerOrder({
    this.orderId,
    required this.userId,
    required this.addressId,
    required this.items,
    required this.totalAmount,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.orderStatus,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'userId': userId,
      'addressId': addressId,
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'orderStatus': orderStatus,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CustomerOrder.fromMap(Map<String, dynamic> map) {
    return CustomerOrder(
      orderId: map['orderId'],
      userId: map['userId'] ?? '',
      addressId: map['addressId'] ?? '',
      items: (map['items'] as List<dynamic>?)
              ?.map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
      totalAmount: (map['totalAmount'] ?? 0.0).toDouble(),
      paymentMethod: map['paymentMethod'] ?? '',
      paymentStatus: map['paymentStatus'] ?? '',
      orderStatus: map['orderStatus'] ?? '',
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
