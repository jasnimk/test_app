import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_ecommerce_app/app/models/order_model.dart';
import 'package:test_ecommerce_app/app/models/order_item_model.dart';
import 'package:test_ecommerce_app/app/services/pdf_service.dart';
import 'package:test_ecommerce_app/app/widgets/custom_snackbar.dart';

class OrderController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final PdfService _pdfService = PdfService();

  final _orders = <CustomerOrder>[].obs;
  final _isLoading = false.obs;
  final _errorMessage = ''.obs;

  List<CustomerOrder> get orders => _orders;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;

  @override
  void onInit() {
    super.onInit();
    fetchUserOrders();
  }

  Future<void> fetchUserOrders() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      final userId = _auth.currentUser?.uid;
      if (userId == null) throw 'User not authenticated';

      final orderSnapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      _orders.value =
          orderSnapshot.docs.map((doc) => _parseOrderDocument(doc)).toList();
    } on FirebaseException catch (e) {
      _handleFirebaseError(e);
    } catch (e) {
      _handleError('Failed to fetch orders. Please try again.');
    } finally {
      _isLoading.value = false;
    }
  }

  CustomerOrder _parseOrderDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CustomerOrder(
      orderId: doc.id,
      userId: data['userId'] ?? '',
      addressId: data['addressId'] ?? '',
      items: _parseOrderItems(data['items'] as List?),
      totalAmount: (data['total'] ?? data['totalAmount'] ?? 0.0).toDouble(),
      paymentMethod: data['paymentMethod'] ?? '',
      paymentStatus: data['paymentStatus'] ?? '',
      orderStatus: data['status'] ?? data['orderStatus'] ?? 'Processing',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  List<OrderItem> _parseOrderItems(List? items) {
    return items
            ?.map((item) => OrderItem.fromMap({
                  'productId': item['productId'] ?? '',
                  'name': item['productName'] ?? 'Unknown Item',
                  'quantity': item['quantity'] ?? 0,
                  'price': (item['price'] ?? 0.0).toDouble(),
                  'imageUrl': item['imageUrl'] ?? '',
                  'totalPrice': (item['totalPrice'] ?? 0.0).toDouble(),
                }))
            .toList() ??
        [];
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      _isLoading.value = true;

      await _firestore.collection('orders').doc(orderId).update({
        'orderStatus': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _updateLocalOrderStatus(orderId, status);
      showCustomSnackbar(
        title: '',
        message: 'Order status updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      _handleError('Failed to update order status');
    } finally {
      _isLoading.value = false;
    }
  }

  void _updateLocalOrderStatus(String orderId, String status) {
    final orderIndex = _orders.indexWhere((order) => order.orderId == orderId);
    if (orderIndex != -1) {
      final order = _orders[orderIndex];
      _orders[orderIndex] = CustomerOrder(
        orderId: order.orderId,
        userId: order.userId,
        addressId: order.addressId,
        items: order.items,
        totalAmount: order.totalAmount,
        paymentMethod: order.paymentMethod,
        paymentStatus: order.paymentStatus,
        orderStatus: status,
        createdAt: order.createdAt,
      );
    }
  }

  void _handleFirebaseError(FirebaseException e) {
    print('Firebase Error: ${e.code} - ${e.message}');
    final errorMessage = _getFirebaseErrorMessage(e.code);
    _handleError(errorMessage);
  }

  void _handleError(String message) {
    _errorMessage.value = message;
    _showErrorSnackbar(message);
  }

  String _getFirebaseErrorMessage(String code) {
    switch (code) {
      case 'permission-denied':
        return 'Access denied. Please check your permissions.';
      case 'unavailable':
        return 'Service temporarily unavailable. Please try again.';
      case 'not-found':
        return 'Order not found.';
      case 'network-request-failed':
        return 'Network connection failed. Please check your internet.';
      default:
        return 'Failed to fetch orders. Please try again.';
    }
  }

  void _showErrorSnackbar(String message) {
    showCustomSnackbar(
      title: '',
      message: message,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> refreshOrders() => fetchUserOrders();

  Future<void> generateAndDownloadInvoice(String orderId) async {
    try {
      _isLoading.value = true;
      final order = _orders.firstWhere(
        (order) => order.orderId == orderId,
        orElse: () => throw 'Order not found',
      );

      await _pdfService.generateAndDownloadInvoice(order);

      showCustomSnackbar(
        title: '',
        message: 'Invoice downloaded successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      _handleError('Failed to generate invoice. Please try again.');
    } finally {
      _isLoading.value = false;
    }
  }
}
