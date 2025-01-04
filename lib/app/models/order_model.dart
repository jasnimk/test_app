// // import 'package:test_ecommerce_app/app/models/order_item_model.dart';

// // class Order {
// //   final String id;
// //   final String userId;
// //   final String addressId;
// //   final List<OrderItem> items;
// //   final double totalAmount;
// //   final double shippingCharge;
// //   final String paymentMethod;
// //   final String paymentStatus;
// //   final String orderStatus;
// //   final DateTime createdAt;
// //   final String? paymentId;

// //   Order({
// //     required this.id,
// //     required this.userId,
// //     required this.addressId,
// //     required this.items,
// //     required this.totalAmount,
// //     required this.shippingCharge,
// //     required this.paymentMethod,
// //     required this.paymentStatus,
// //     required this.orderStatus,
// //     required this.createdAt,
// //     this.paymentId,
// //   });

// //   Map<String, dynamic> toMap() {
// //     return {
// //       'id': id,
// //       'userId': userId,
// //       'addressId': addressId,
// //       'items': items.map((item) => item.toMap()).toList(),
// //       'totalAmount': totalAmount,
// //       'shippingCharge': shippingCharge,
// //       'paymentMethod': paymentMethod,
// //       'paymentStatus': paymentStatus,
// //       'orderStatus': orderStatus,
// //       'createdAt': createdAt.toIso8601String(),
// //       'paymentId': paymentId,
// //     };
// //   }

// //   factory Order.fromMap(Map<String, dynamic> map) {
// //     return Order(
// //       id: map['id'] as String,
// //       userId: map['userId'] as String,
// //       addressId: map['addressId'] as String,
// //       items: (map['items'] as List<dynamic>)
// //           .map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
// //           .toList(),
// //       totalAmount: (map['totalAmount'] as num).toDouble(),
// //       shippingCharge: (map['shippingCharge'] as num).toDouble(),
// //       paymentMethod: map['paymentMethod'] as String,
// //       paymentStatus: map['paymentStatus'] as String,
// //       orderStatus: map['orderStatus'] as String,
// //       createdAt: DateTime.parse(map['createdAt'] as String),
// //       paymentId: map['paymentId'] as String?,
// //     );
// //   }
// // }
// // order_status.dart
// import 'package:test_ecommerce_app/app/models/order_item_model.dart';

// enum OrderStatus {
//   pending,
//   processing,
//   shipped,
//   delivered,
//   cancelled;

//   String toShortString() {
//     return toString().split('.').last;
//   }
// }

// enum PaymentStatus {
//   pending,
//   completed,
//   failed,
//   refunded;

//   String toShortString() {
//     return toString().split('.').last;
//   }
// }

// enum PaymentMethod {
//   cod,
//   wallet,
//   card;

//   String toShortString() {
//     return toString().split('.').last;
//   }
// }

// // purchase_order.dart
// class PurchaseOrder {
//   final String id;
//   final String userId;
//   final String addressId;
//   final List<OrderItem> items;
//   final double totalAmount;
//   final double shippingCharge;
//   final PaymentMethod paymentMethod;
//   final PaymentStatus paymentStatus;
//   final OrderStatus orderStatus;
//   final DateTime createdAt;
//   final String? paymentId;

//   PurchaseOrder({
//     required this.id,
//     required this.userId,
//     required this.addressId,
//     required this.items,
//     required this.totalAmount,
//     required this.shippingCharge,
//     required this.paymentMethod,
//     required this.paymentStatus,
//     required this.orderStatus,
//     required this.createdAt,
//     this.paymentId,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'userId': userId,
//       'addressId': addressId,
//       'items': items.map((item) => item.toMap()).toList(),
//       'totalAmount': totalAmount,
//       'shippingCharge': shippingCharge,
//       'paymentMethod': paymentMethod.toShortString(),
//       'paymentStatus': paymentStatus.toShortString(),
//       'orderStatus': orderStatus.toShortString(),
//       'createdAt': createdAt.toIso8601String(),
//       'paymentId': paymentId,
//     };
//   }

//   factory PurchaseOrder.fromMap(Map<String, dynamic> map) {
//     return PurchaseOrder(
//       id: map['id'] as String,
//       userId: map['userId'] as String,
//       addressId: map['addressId'] as String,
//       items: (map['items'] as List<dynamic>)
//           .map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
//           .toList(),
//       totalAmount: (map['totalAmount'] as num).toDouble(),
//       shippingCharge: (map['shippingCharge'] as num).toDouble(),
//       paymentMethod: PaymentMethod.values.firstWhere(
//         (e) => e.toShortString() == map['paymentMethod'],
//       ),
//       paymentStatus: PaymentStatus.values.firstWhere(
//         (e) => e.toShortString() == map['paymentStatus'],
//       ),
//       orderStatus: OrderStatus.values.firstWhere(
//         (e) => e.toShortString() == map['orderStatus'],
//       ),
//       createdAt: DateTime.parse(map['createdAt'] as String),
//       paymentId: map['paymentId'] as String?,
//     );
//   }
// }

// order_model.dart
import 'package:test_ecommerce_app/app/models/order_item_model.dart';

class Order {
  String? orderId; // Made nullable and renamed from id to orderId
  final String userId;
  final String addressId;
  final List<OrderItem> items;
  final double totalAmount;
  final String paymentMethod;
  final String paymentStatus;
  final String orderStatus;
  final DateTime createdAt;

  Order({
    this.orderId, // Optional in constructor
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

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
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
