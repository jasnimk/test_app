import 'package:get/get.dart';
import 'package:test_ecommerce_app/app/controllers/address_controller.dart';
import 'package:test_ecommerce_app/app/controllers/auth_controller.dart';
import 'package:test_ecommerce_app/app/controllers/cart_controller.dart';
import 'package:test_ecommerce_app/app/controllers/checkout_controller.dart';
import 'package:test_ecommerce_app/app/controllers/offer_controller.dart';
import 'package:test_ecommerce_app/app/controllers/product_controller.dart';
import 'package:test_ecommerce_app/app/controllers/profile_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ProductController(), permanent: true);
    Get.put(CartController(), permanent: true);
    Get.put(AuthController(), permanent: true);
    Get.put(AddressController(), permanent: true);
    Get.put(() => OfferController());
    Get.put(CheckoutController(), permanent: true);

    Get.lazyPut(() => ProfileController());
  }
}
