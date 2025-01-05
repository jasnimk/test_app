import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_ecommerce_app/app/models/product_model.dart';
import 'package:test_ecommerce_app/app/widgets/custom_snackbar.dart';

class ProductController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxBool isLoading = false.obs;
  final RxList<Product> productsList = <Product>[].obs;
  final RxString selectedCategory = ''.obs;
  final RxList<String> categories = <String>[].obs;
  final RxList similarProducts = [].obs;

  // Product Details Related
  final pageController = PageController();
  final currentPage = 0.obs;
  final Rx<Product?> selectedProduct = Rx<Product?>(null);

  @override
  void onInit() {
    super.onInit();
    initializeData();
  }

  Future fetchSimilarProducts(String currentProductId) async {
    try {
      isLoading.value = true;

      // Get the category of the current product first
      final currentProduct = selectedProduct.value;
      if (currentProduct == null) return;

      // Query products in the same category, excluding current product
      final QuerySnapshot snapshot = await _firestore
          .collection('products')
          .where('category', isEqualTo: currentProduct.category)
          .where(FieldPath.documentId, isNotEqualTo: currentProductId)
          .limit(10) // Limit to prevent loading too many products
          .get();

      similarProducts.value = snapshot.docs.map((doc) {
        return Product.fromMap(
          doc.data() as Map<String, dynamic>,
          id: doc.id,
        );
      }).toList();
    } catch (e) {
      print('Error fetching similar products: $e');
      showCustomSnackbar(
        title: '',
        message: 'Failed to fetch similar products',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> initializeData() async {
    try {
      isLoading.value = true;
      // Set default category first
      selectedCategory.value = '';

      // Fetch categories first
      await fetchCategories();

      // Then fetch products
      await fetchProducts();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCategories() async {
    try {
      // Get all products
      final QuerySnapshot snapshot =
          await _firestore.collection('products').get();

      // Extract unique categories from products
      final Set<String> uniqueCategories = snapshot.docs
          .map((doc) =>
              (doc.data() as Map<String, dynamic>)['category'] as String)
          .where((category) => category.isNotEmpty)
          .toSet();

      // Add "All Products" as the first option and sort the rest
      categories.value = ['All Products', ...uniqueCategories.toList()..sort()];
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      Query query = _firestore.collection('products');

      if (selectedCategory.value.isNotEmpty) {
        query = query.where('category', isEqualTo: selectedCategory.value);
      }

      final QuerySnapshot snapshot = await query.get();

      productsList.value = snapshot.docs.map((doc) {
        return Product.fromMap(
          doc.data() as Map<String, dynamic>,
          id: doc.id,
        );
      }).toList();
    } catch (e) {
      print('Error fetching products: $e');
      showCustomSnackbar(
        title: '',
        message: 'Failed to fetch products',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchProductDetails(String productId) async {
    try {
      isLoading.value = true;
      final DocumentSnapshot doc =
          await _firestore.collection('products').doc(productId).get();

      if (doc.exists) {
        selectedProduct.value = Product.fromMap(
          doc.data() as Map<String, dynamic>,
          id: doc.id,
        );
        await fetchSimilarProducts(productId);
      } else {
        showCustomSnackbar(
          title: '',
          message: 'Product not found',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('Error fetching product details: $e');
      showCustomSnackbar(
        title: '',
        message: 'Failed to load product details',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void setCategory(String category) {
    selectedCategory.value = category == 'All Products' ? '' : category;
    fetchProducts();
  }

  List<Product> getFeaturedProducts() {
    return productsList.where((product) => product.isFeatured).toList();
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
