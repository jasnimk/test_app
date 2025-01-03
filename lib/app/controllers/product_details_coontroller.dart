import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_ecommerce_app/app/data/product.dart';
import 'package:test_ecommerce_app/app/models/product_model.dart';

class ProductDetailsController extends GetxController {
  final pageController = PageController();
  final currentPage = 0.obs;
  late final Product product;

  @override
  void onInit() {
    super.onInit();
    initializeProduct();
  }

  void initializeProduct() {
    try {
      final productMap = Map<String, dynamic>.from(
        products.firstWhere(
          (p) => p['id'] == Get.arguments['productId'],
          orElse: () => <String, dynamic>{},
        ),
      );

      product = productMap.isNotEmpty
          ? Product.fromMap(productMap)
          : _getDefaultProduct('Product Not Found');
    } catch (e) {
      product = _getDefaultProduct('Error Loading Product');
    }
  }

  Product _getDefaultProduct(String errorMessage) => Product(
        id: '',
        name: errorMessage,
        description: 'No description available',
        price: 0.0,
        imageUrls: [],
        category: '',
        rating: 0.0,
        stock: 0,
        material: '',
      );

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
