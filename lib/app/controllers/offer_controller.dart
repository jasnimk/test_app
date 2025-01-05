// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_ecommerce_app/app/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:test_ecommerce_app/app/controllers/cart_controller.dart';
import 'package:test_ecommerce_app/app/widgets/custom_snackbar.dart';
import 'package:test_ecommerce_app/app/widgets/offer_dialog.dart';

class OfferController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final CartController _cartController;

  Rx<Product?> welcomeOfferProduct = Rx<Product?>(null);
  RxBool hasShownOffer = false.obs;
  final RxBool isNewUser = false.obs;
  RxBool isInitialized = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      // Wait for CartController to be ready
      await Get.putAsync(() async {
        _cartController = Get.find<CartController>();
        return _cartController;
      }, permanent: true);

      // Mark as initialized
      isInitialized.value = true;

      // Check user status after initialization
      await checkIfNewUser();
    } catch (e) {
      if (kDebugMode) {
        print('Error during initialization: $e');
      }
    }
  }

  Future<void> checkIfNewUser() async {
    if (!isInitialized.value) {
      await _initialize();
    }

    final user = _auth.currentUser;

    if (user == null) {
      isNewUser.value = false;
      return;
    }

    try {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        await _firestore.collection('users').doc(user.uid).set({
          'createdAt': FieldValue.serverTimestamp(),
          'isNewUser': true,
          'hasReceivedWelcomeOffer': false,
        });
        isNewUser.value = true;
        return;
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      final createdAt = userData['createdAt'] as Timestamp?;
      final hasReceivedOffer =
          userData['hasReceivedWelcomeOffer'] as bool? ?? false;
      final newUserStatus = userData['isNewUser'] as bool? ?? false;

      isNewUser.value = newUserStatus &&
          !hasReceivedOffer &&
          createdAt != null &&
          DateTime.now().difference(createdAt.toDate()) <
              const Duration(minutes: 125);
    } catch (e) {
      isNewUser.value = false;
    }
  }

  Future<Product?> getRandomProduct() async {
    try {
      final QuerySnapshot productsSnapshot = await _firestore
          .collection('products')
          .where('stock', isGreaterThan: 0)
          .limit(20)
          .get();

      if (productsSnapshot.docs.isEmpty) {
        return null;
      }

      final random =
          DateTime.now().millisecondsSinceEpoch % productsSnapshot.docs.length;
      final productDoc = productsSnapshot.docs[random];

      final product = Product.fromMap(
        productDoc.data() as Map<String, dynamic>,
        id: productDoc.id,
      );
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<void> showOfferIfNewUser(BuildContext context) async {
    if (!isNewUser.value) {
      print('Not showing offer - user is not new');
      return;
    }

    if (hasShownOffer.value) {
      return;
    }

    try {
      final product = await getRandomProduct();

      if (product == null) {
        return;
      }

      if (!context.mounted) {
        return;
      }

      welcomeOfferProduct.value = product;
      hasShownOffer.value = true;

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => WelcomeOfferDialog(
          product: product,
          onAccept: () => addFreeProductToCart(product, context),
          onDecline: () => _handleOfferDecline(context),
        ),
      );
    } catch (e) {
      hasShownOffer.value = false;
    }
  }

  Future<void> _handleOfferDecline(BuildContext context) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        await _firestore.collection('users').doc(userId).update({
          'hasReceivedWelcomeOffer': true,
          'welcomeOfferDeclined': true,
          'isNewUser': false,
          'welcomeOfferDate': FieldValue.serverTimestamp(),
        });
      }
      if (context.mounted) Navigator.of(context).pop();
    } catch (e) {
      if (kDebugMode) {
        print('Error handling offer decline: $e');
      }
    }
  }

  Future<void> showWelcomeOffer(BuildContext context) async {
    try {
      final product = await getRandomProduct();
      if (product == null) return;

      welcomeOfferProduct.value = product;

      if (!context.mounted) return;
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => WelcomeOfferDialog(
          product: product,
          onAccept: () => addFreeProductToCart(product, context),
          onDecline: () async {
            final userId = _auth.currentUser?.uid;
            if (userId != null) {
              await _firestore.collection('users').doc(userId).update({
                'hasReceivedWelcomeOffer': true,
                'welcomeOfferDeclined': true,
                'welcomeOfferDate': FieldValue.serverTimestamp(),
              });
            }
            Navigator.of(context).pop();
          },
        ),
      );
    } catch (e) {
      showCustomSnackbar(title: '', message: 'showing welcome offer: $e');
    }
  }

  Future<void> addFreeProductToCart(
      Product product, BuildContext context) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      // Add product with special "offer" flag
      final cartItemId =
          await _cartController.addToCartWithOffer(product, context);

      if (cartItemId.isNotEmpty) {
        // Record that this user has received their welcome offer
        await _firestore.collection('users').doc(userId).update({
          'hasReceivedWelcomeOffer': true,
          'welcomeOfferProductId': product.id,
          'welcomeOfferDate': FieldValue.serverTimestamp(),
          'welcomeOfferAccepted': true,
          'welcomeOfferCartItemId': cartItemId,
        });

        // Also store the offer details in a separate collection for persistence
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('offers')
            .doc('welcome_offer')
            .set({
          'productId': product.id,
          'cartItemId': cartItemId,
          'dateAccepted': FieldValue.serverTimestamp(),
          'isActive': true,
        });

        showCustomSnackbar(
          title: '',
          message: 'Your free welcome gift has been added to your cart.',
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.TOP,
        );
      }

      Navigator.of(context).pop();
    } catch (e) {
      showCustomSnackbar(
          title: '', message: 'Failed to add welcome offer to cart');
    }
  }
}
