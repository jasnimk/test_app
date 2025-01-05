import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_ecommerce_app/app/models/cart_model.dart';
import 'package:test_ecommerce_app/app/models/product_model.dart';
import 'package:test_ecommerce_app/app/screens/added_to_cart_success.dart';
import 'package:test_ecommerce_app/app/widgets/confirmation_Widget.dart';
import 'package:test_ecommerce_app/app/widgets/custom_snackbar.dart';

class CartController extends GetxController {
  final RxList<CartItem> _items = <CartItem>[].obs;
  final RxBool _isLoading = false.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool get isLoading => _isLoading.value;
  List<CartItem> get items => _items.toList();

  int get itemCount => _items.length;

  int get totalQuantity {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  double get subtotal {
    return _items.fold(0.0, (sum, item) {
      if (item.isOffer) {
        return sum + 0;
      }
      return sum + (item.product.price * item.quantity);
    });
  }

  double get totalAmount => subtotal;

  double get actualAmount {
    return _items.fold(
        0.0, (sum, item) => sum + (item.product.price * item.quantity));
  }

  double get discountAmount => actualAmount - totalAmount;

  // Check if item is a gift/offer product
  bool isGiftProduct(CartItem item) {
    return item.isOffer;
  }

  // Check if quantity update is allowed
  bool canUpdateQuantity(CartItem item) {
    return !isGiftProduct(item);
  }

  Future<void> updateQuantity(
      CartItem item, int newQuantity, BuildContext context) async {
    if (item.isOffer) {
      Get.closeAllSnackbars();

      showCustomSnackbar(title: '', message: 'Sorry, CAnnot Modify Gift!');
      return;
    }

    try {
      _isLoading.value = true;
      if (newQuantity <= 0) {
        await removeFromCart(context, item);
        return;
      }

      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      final quantityDifference = newQuantity - item.quantity;

      if (quantityDifference > 0) {
        final hasStock =
            await checkStockAvailability(item.product.id!, quantityDifference);
        if (!hasStock) {
          Get.closeAllSnackbars();
          showCustomSnackbar(
              title: '', message: 'Insufficient stock available');
          return;
        }
      }

      await updateProductStock(item.product.id!, quantityDifference);

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(item.id)
          .update({'quantity': newQuantity});

      final index = _items.indexWhere((i) => i.id == item.id);
      if (index >= 0) {
        _items[index].quantity = newQuantity;
        _items.refresh();
      }
    } catch (e) {
      Get.closeAllSnackbars();
      showCustomSnackbar(title: '', message: 'Failed to update quantity!');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> removeFromCart(BuildContext context, CartItem item) async {
    if (item.isOffer) {
      Get.closeAllSnackbars();
      showCustomSnackbar(
          title: '', message: 'Gift products cannot be removed from cart!');

      return;
    }
    final bool? confirmed = await ConfirmationDialog.show(
      context: context,
      title: 'Remove Item',
      content:
          'Are you sure you want to remove ${item.product.name} from your cart?',
      confirmText: 'Remove',
      cancelText: 'Keep',
      onConfirm: () async {
        try {
          _isLoading.value = true;
          final userId = _auth.currentUser?.uid;
          if (userId == null) return;

          await updateProductStock(item.product.id!, -item.quantity);

          await _firestore
              .collection('users')
              .doc(userId)
              .collection('cart')
              .doc(item.id)
              .delete();

          _items.removeWhere((i) => i.id == item.id);
          showCustomSnackbar(title: '', message: 'Removed from Cart!');
        } catch (e) {
          showCustomSnackbar(title: '', message: 'Failed to remove item');
        } finally {
          _isLoading.value = false;
        }
      },
    );

    if (confirmed ?? false) {}
  }

  @override
  void onInit() {
    super.onInit();
    loadCartFromFirestore();
  }

  Future<bool> checkStockAvailability(
      String productId, int requestedQuantity) async {
    try {
      final productDoc =
          await _firestore.collection('products').doc(productId).get();
      if (!productDoc.exists) return false;

      final currentStock = productDoc.data()?['stock'] as int? ?? 0;
      print(
          'Product $productId - Current Stock: $currentStock, Requested: $requestedQuantity'); // Debug log
      return currentStock >= requestedQuantity;
    } catch (e) {
      print('Stock check error: $e'); // Debug log
      showCustomSnackbar(
          title: '', message: 'Error, Failed to check stock availability');
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
      print('Stock update error: $e'); // Add logging for debugging
      showCustomSnackbar(
          title: '', message: 'Failed to update product stock: $e');
      throw e; // Re-throw to handle in calling code
    }
  }

  Future<String> addToCart(Product product, BuildContext context,
      {bool fromProductPage = true}) async {
    try {
      _isLoading.value = true;
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        showCustomSnackbar(title: '', message: 'Verification Failed!');
        ('Error', 'Please login to add items to cart');
        return '';
      }

      final existingCartQuery = await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .where('productId', isEqualTo: product.id)
          .where('isOffer', isEqualTo: false) // Only match non-offer items
          .get();

      if (existingCartQuery.docs.isNotEmpty) {
        final existingCartDoc = existingCartQuery.docs.first;
        final currentQuantity = existingCartDoc.data()['quantity'] as int;
        final newQuantity = currentQuantity + 1;

        final hasStock = await checkStockAvailability(product.id!, newQuantity);
        if (!hasStock) {
          showCustomSnackbar(
              title: '', message: 'Insufficient stock available!');
          return '';
        }

        await updateProductStock(product.id!, 1);

        await _firestore
            .collection('users')
            .doc(userId)
            .collection('cart')
            .doc(existingCartDoc.id)
            .update({'quantity': newQuantity});

        final index = _items.indexWhere(
            (item) => item.product.id == product.id && !(item.isOffer));
        if (index >= 0) {
          _items[index].quantity = newQuantity;
          _items.refresh();
        } else {
          final cartItem = CartItem(
            id: existingCartDoc.id,
            product: product,
            quantity: newQuantity,
            isOffer: false,
          );
          _items.add(cartItem);
        }

        if (fromProductPage) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const CartSucces()));
        }

        return existingCartDoc.id;
      } else {
        final hasStock = await checkStockAvailability(product.id!, 1);
        if (!hasStock) {
          showCustomSnackbar(title: '', message: 'Product out of stock!');
          return '';
        }

        await updateProductStock(product.id!, 1);

        final cartRef =
            _firestore.collection('users').doc(userId).collection('cart').doc();

        final cartItem = CartItem(
          id: cartRef.id,
          product: product,
          quantity: 1,
          isOffer: false,
        );

        await cartRef.set({
          'productId': product.id,
          'quantity': 1,
          'isOffer': false,
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
      showCustomSnackbar(title: '', message: 'Failed to add item to cart!');
      return '';
    } finally {
      _isLoading.value = false;
    }
  }

  Future<String> addToCartWithOffer(
      Product product, BuildContext context) async {
    try {
      _isLoading.value = true;
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        showCustomSnackbar(
            title: '', message: 'Please Login to add items to cart!');
        return '';
      }

      final cartRef =
          _firestore.collection('users').doc(userId).collection('cart').doc();

      final cartItem = CartItem(
        id: cartRef.id,
        product: product,
        quantity: 1,
        isOffer: true,
      );

      await cartRef.set({
        'productId': product.id,
        'quantity': 1,
        'isOffer': true,
        'addedAt': FieldValue.serverTimestamp(),
      });

      _items.add(cartItem);
      return cartRef.id;
    } catch (e) {
      showCustomSnackbar(
          title: '', message: 'Failed to add offer item to cart!');
      return '';
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> clearCart() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      for (var item in _items) {
        if (!(item.isOffer)) {
          await updateProductStock(item.product.id!, -item.quantity);
        }
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
      showCustomSnackbar(title: '', message: 'Failed to clear cart');
    }
  }

  Future<void> loadCartFromFirestore() async {
    try {
      _isLoading.value = true;

      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        _items.clear();
        return;
      }

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
            isOffer: data['isOffer'] ?? false,
          );
          _items.add(cartItem);
        }
      }
    } catch (e) {
      showCustomSnackbar(title: '', message: 'Failed to load Cart!');
    } finally {
      _isLoading.value = false;
    }
  }
}
