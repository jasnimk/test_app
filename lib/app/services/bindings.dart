import 'package:get/get.dart';
import 'package:test_ecommerce_app/app/controllers/address_controller.dart';
import 'package:test_ecommerce_app/app/controllers/auth_controller.dart';
import 'package:test_ecommerce_app/app/controllers/cart_controller.dart';
import 'package:test_ecommerce_app/app/controllers/checkout_controller.dart';
import 'package:test_ecommerce_app/app/controllers/product_controller.dart';
import 'package:test_ecommerce_app/app/controllers/profile_controller.dart';
import 'package:test_ecommerce_app/app/services/stripe_service.dart';

class ProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(StripeService(), permanent: true);
    Get.put(ProductController());
    Get.put(AuthController());
    Get.put(CartController());
    Get.put(ProfileController());
    Get.put(AddressController());
    Get.put(CheckoutController());
  }
}
