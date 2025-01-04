import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_ecommerce_app/app/models/cart_model.dart';
import 'package:test_ecommerce_app/app/models/product_model.dart';
import 'package:test_ecommerce_app/app/screens/added_to_cart_success.dart';
import 'package:test_ecommerce_app/app/widgets/confirmation_Widget.dart';

class CartController extends GetxController {
  final RxList<CartItem> _items = <CartItem>[].obs;
  final RxBool _isLoading = false.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool get isLoading => _isLoading.value;
  List<CartItem> get items => _items;

  int get itemCount => _items.length;

  int get totalQuantity {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  double get subtotal {
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  double get totalAmount => subtotal;

  double get actualAmount {
    return _items.fold(
        0.0, (sum, item) => sum + (item.product.price * item.quantity));
  }

  double get discountAmount => actualAmount - totalAmount;

  Future<bool> checkStockAvailability(
      String productId, int requestedQuantity) async {
    try {
      final productDoc =
          await _firestore.collection('products').doc(productId).get();
      if (!productDoc.exists) return false;

      final currentStock = productDoc.data()?['stock'] as int? ?? 0;
      return currentStock >= requestedQuantity;
    } catch (e) {
      Get.snackbar('Error', 'Failed to check stock availability');
      return false;
    }
  }

  Future<void> updateProductStock(String productId, int quantityChange) async {
    try {
      final productRef = _firestore.collection('products').doc(productId);

      await _firestore.runTransaction((transaction) async {
        final productDoc = await transaction.get(productRef);
        if (!productDoc.exists) {
          throw Exception('Product not found');
        }

        final currentStock = productDoc.data()?['stock'] as int? ?? 0;
        final newStock = currentStock - quantityChange;

        if (newStock < 0) {
          throw Exception('Insufficient stock');
        }

        transaction.update(productRef, {'stock': newStock});
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to update product stock');
      throw e;
    }
  }

  Future<String> addToCart(Product product, BuildContext context,
      {bool fromProductPage = true}) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        Get.snackbar('Error', 'Please login to add items to cart');
        return '';
      }

      // First check if the item exists in Firestore
      final existingCartQuery = await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .where('productId', isEqualTo: product.id)
          .get();

      if (existingCartQuery.docs.isNotEmpty) {
        // Item exists in Firestore
        final existingCartDoc = existingCartQuery.docs.first;
        final currentQuantity = existingCartDoc.data()['quantity'] as int;
        final newQuantity = currentQuantity + 1;

        // Check stock availability before updating
        final hasStock = await checkStockAvailability(product.id!, newQuantity);
        if (!hasStock) {
          Get.snackbar('Error', 'Insufficient stock available');
          return '';
        }

        // Update stock in Firestore
        await updateProductStock(product.id!, 1);

        // Update cart item in Firestore
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('cart')
            .doc(existingCartDoc.id)
            .update({'quantity': newQuantity});

        // Update local cart items
        final index =
            _items.indexWhere((item) => item.product.id == product.id);
        if (index >= 0) {
          _items[index].quantity = newQuantity;
          _items.refresh();
        } else {
          // If item exists in Firestore but not in local list, add it
          final cartItem = CartItem(
            id: existingCartDoc.id,
            product: product,
            quantity: newQuantity,
          );
          _items.add(cartItem);
        }

        if (fromProductPage) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const CartSucces()));
        }

        return existingCartDoc.id;
      } else {
        // New item
        // Check stock availability for new item
        final hasStock = await checkStockAvailability(product.id!, 1);
        if (!hasStock) {
          Get.snackbar('Error', 'Product out of stock');
          return '';
        }

        // Update stock in Firestore
        await updateProductStock(product.id!, 1);

        // Create new cart item
        final cartRef =
            _firestore.collection('users').doc(userId).collection('cart').doc();

        final cartItem = CartItem(
          id: cartRef.id,
          product: product,
          quantity: 1,
        );

        await cartRef.set({
          'productId': product.id,
          'quantity': 1,
          'addedAt': FieldValue.serverTimestamp(),
        });

        _items.add(cartItem);

        if (fromProductPage) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const CartSucces()));
        }

        return cartRef.id;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to add item to cart');
      return '';
    }
  }

  Future<void> updateQuantity(
      CartItem item, int newQuantity, BuildContext context) async {
    try {
      if (newQuantity <= 0) {
        await removeFromCart(context, item);
        return;
      }

      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      // Calculate quantity change
      final quantityDifference = newQuantity - item.quantity;

      // Check stock if increasing quantity
      if (quantityDifference > 0) {
        final hasStock =
            await checkStockAvailability(item.product.id!, quantityDifference);
        if (!hasStock) {
          Get.snackbar('Error', 'Insufficient stock available');
          return;
        }
      }

      // Update stock in Firestore
      await updateProductStock(item.product.id!, quantityDifference);

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(item.id)
          .update({'quantity': newQuantity});

      final index = _items.indexOf(item);
      _items[index].quantity = newQuantity;
      _items.refresh();
    } catch (e) {
      Get.snackbar('Error', 'Failed to update quantity');
    }
  }

  Future<void> removeFromCart(BuildContext context, CartItem item) async {
    final bool? confirmed = await ConfirmationDialog.show(
      context: context,
      title: 'Remove Item',
      content:
          'Are you sure you want to remove ${item.product.name} from your cart?',
      confirmText: 'Remove',
      cancelText: 'Keep',
      onConfirm: () async {
        try {
          final userId = _auth.currentUser?.uid;
          if (userId == null) return;

          // Return stock when removing item
          await updateProductStock(item.product.id!, -item.quantity);

          await _firestore
              .collection('users')
              .doc(userId)
              .collection('cart')
              .doc(item.id)
              .delete();

          _items.remove(item);
          Get.snackbar('Success', '${item.product.name} removed from cart');
        } catch (e) {
          Get.snackbar('Error', 'Failed to remove item');
        }
      },
    );

    if (confirmed ?? false) {}
  }

  Future<void> clearCart() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      // Return stock for all items
      for (var item in _items) {
        await updateProductStock(item.product.id!, -item.quantity);
      }

      final batch = _firestore.batch();
      final cartDocs = await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .get();

      for (var doc in cartDocs.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      _items.clear();
    } catch (e) {
      Get.snackbar('Error', 'Failed to clear cart');
    }
  }

  Future<void> loadCartFromFirestore() async {
    try {
      _isLoading.value = true;

      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      final cartSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .orderBy('addedAt', descending: true)
          .get();

      _items.clear();

      for (var doc in cartSnapshot.docs) {
        final data = doc.data();
        final productDoc = await _firestore
            .collection('products')
            .doc(data['productId'])
            .get();

        if (productDoc.exists) {
          final product =
              Product.fromMap(productDoc.data()!, id: productDoc.id);
          final cartItem = CartItem(
            id: doc.id,
            product: product,
            quantity: data['quantity'] ?? 1,
          );
          _items.add(cartItem);
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load cart');
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadCartFromFirestore();
  }
}
