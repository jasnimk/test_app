import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_ecommerce_app/app/controllers/auth_controller.dart';
import 'package:test_ecommerce_app/app/widgets/add_on_widgets.dart';
import 'package:test_ecommerce_app/app/widgets/text_style.dart';

class SplashScreen extends StatelessWidget {
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    // Introduce a delay before navigation
    Future.delayed(const Duration(seconds: 3), () {
      if (authController.user.value != null) {
        // User is logged in, navigate to home
        Get.offAllNamed('/home');
      } else {
        // No user logged in, navigate to login
        Get.offAllNamed('/login');
      }
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF15384E), Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/Images/logo.png', width: 150),
              SizedBox(height: 30),
              buildLoadingIndicator(context: context),
              SizedBox(height: 20),
              Text(
                'Loading...',
                style:
                    AppTextStyles.montserratBold.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
