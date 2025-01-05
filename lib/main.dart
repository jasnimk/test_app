import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:test_ecommerce_app/app/data/consts.dart';
import 'package:test_ecommerce_app/app/screens/add_address.dart';
import 'package:test_ecommerce_app/app/screens/base_screen.dart';
import 'package:test_ecommerce_app/app/screens/checkout_screen.dart';
import 'package:test_ecommerce_app/app/screens/home_screen.dart';
import 'package:test_ecommerce_app/app/screens/login_Screen.dart';
import 'package:test_ecommerce_app/app/screens/order_placed.dart';
import 'package:test_ecommerce_app/app/screens/phone_login.dart';
import 'package:test_ecommerce_app/app/screens/select_Sddress.dart';
import 'package:test_ecommerce_app/app/screens/signup_screen.dart';
import 'package:test_ecommerce_app/app/screens/splash_screen.dart';
import 'package:test_ecommerce_app/app/screens/verify_otp.dart';
import 'package:test_ecommerce_app/app/services/bindings.dart';
import 'package:test_ecommerce_app/app/utilities/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: AppBinding(),
      //home: const ProductGridView(),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => SplashScreen()),
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/signup', page: () => SignUpScreen()),
        GetPage(name: '/verify-otp', page: () => VerifyOTPScreen()),
        GetPage(name: '/home', page: () => BaseScreen()),
        GetPage(name: '/phone-login', page: () => PhoneLoginScreen()),
        GetPage(name: '/checkout', page: () => CheckoutScreen()),
        GetPage(name: '/order-success', page: () => OrderPlaced()),
        GetPage(name: '/select-address', page: () => AddressSelectionPage()),
        GetPage(name: '/add-address', page: () => AddAddressView()),
        GetPage(name: '/home', page: () => const HomeScreen()),
      ],
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Stripe.instance.applySettings();
  Stripe.publishableKey = stripePublishableKey;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}
