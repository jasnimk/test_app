// checkout_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:test_ecommerce_app/app/controllers/cart_controller.dart';
import 'package:test_ecommerce_app/app/models/cart_model.dart';
import 'package:test_ecommerce_app/app/services/stripe_service.dart';

class CheckoutController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final StripeService _stripeService;

  final selectedPaymentMethod = 'cod'.obs;
  final selectedAddressId = ''.obs;
  final isLoading = false.obs;
  final addresses = <Map<String, dynamic>>[].obs;
  final orderProcessing = false.obs;
  final isDirectCheckout = false.obs;
  final directCheckoutItem = Rxn<CartItem>();

  @override
  void onInit() {
    super.onInit();
    initializeServices();
    loadAddresses();
  }

  void setDirectCheckout(CartItem item) {
    isDirectCheckout.value = true;
    directCheckoutItem.value = item;
  }

  void clearDirectCheckout() {
    isDirectCheckout.value = false;
    directCheckoutItem.value = null;
  }

  void initializeServices() {
    try {
      _stripeService = Get.find<StripeService>();
    } catch (e) {
      _stripeService = Get.put(StripeService());
    }
  }

  Future<void> loadAddresses() async {
    try {
      isLoading(true);
      final user = _auth.currentUser;
      if (user != null) {
        final snapshot = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('addresses')
            .get();

        addresses.value = snapshot.docs
            .map((doc) => {
                  'id': doc.id,
                  ...doc.data(),
                })
            .toList();

        if (addresses.isNotEmpty && selectedAddressId.isEmpty) {
          selectedAddressId.value = addresses[0]['id'];
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load addresses: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> processOrder() async {
    if (selectedAddressId.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select a delivery address',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    List<CartItem> itemsToProcess;
    double total;

    if (isDirectCheckout.value && directCheckoutItem.value != null) {
      // Process single item for direct checkout
      itemsToProcess = [directCheckoutItem.value!];
      total = directCheckoutItem.value!.totalPrice;
    } else {
      // Process cart items
      final cartController = Get.find<CartController>();
      itemsToProcess = cartController.items;
      total = cartController.totalAmount;
    }

    if (itemsToProcess.isEmpty) {
      Get.snackbar(
        'Error',
        'No items to process',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      orderProcessing(true);

      // Handle payment
      if (selectedPaymentMethod.value == 'stripe') {
        final paymentSuccess = await _stripeService.processPayment(
          amount: total,
        );
        if (!paymentSuccess) {
          throw Exception('Payment failed');
        }
      }

      // Create and save order
      final orderId = await createOrder(itemsToProcess, total);

      // Update stock
      for (var item in itemsToProcess) {
        await Get.find<CartController>()
            .updateProductStock(item.product.id!, item.quantity);
      }

      // Clear cart if not direct checkout
      if (!isDirectCheckout.value) {
        final cartController = Get.find<CartController>();
        await cartController.clearCart();
      }

      // Clear direct checkout state
      clearDirectCheckout();

      Get.offNamed('/order-success', arguments: orderId);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to process order: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      orderProcessing(false);
    }
  }

  Future<String> createOrder(
      List<CartItem> cartItems, double totalAmount) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final orderRef = _firestore.collection('orders').doc();

    final orderItems = cartItems
        .map((item) => {
              'productId': item.product.id,
              'productName': item.product.name,
              'quantity': item.quantity,
              'price': item.product.price,
              'imageUrl': item.product.imageUrls.isNotEmpty
                  ? item.product.imageUrls[0]
                  : '',
              'totalPrice': item.totalPrice,
            })
        .toList();

    final orderData = {
      'orderId': orderRef.id,
      'userId': user.uid,
      'addressId': selectedAddressId.value,
      'items': orderItems,
      'totalAmount': totalAmount,
      'paymentMethod': selectedPaymentMethod.value,
      'paymentStatus':
          selectedPaymentMethod.value == 'cod' ? 'pending' : 'completed',
      'orderStatus': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    };

    await orderRef.set(orderData);
    return orderRef.id;
  }
}
