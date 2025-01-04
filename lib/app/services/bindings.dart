import 'package:get/get.dart';
import 'package:test_ecommerce_app/app/controllers/auth_controller.dart';
import 'package:test_ecommerce_app/app/controllers/product_controller.dart';

class ProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ProductController());
    Get.put(AuthController());
  }
}
