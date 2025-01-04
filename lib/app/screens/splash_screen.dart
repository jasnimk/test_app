// splash_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_ecommerce_app/app/controllers/auth_controller.dart';

class SplashScreen extends StatelessWidget {
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (authController.user.value != null) {
          // User is logged in, navigate to home
          Future.delayed(Duration.zero, () => Get.offAllNamed('/home'));
        } else {
          // No user logged in, navigate to login
          Future.delayed(Duration.zero, () => Get.offAllNamed('/login'));
        }

        // Show loading screen while checking
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image.asset('', width: 150), // Add your logo
              SizedBox(height: 30),
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Loading...'),
            ],
          ),
        );
      }),
    );
  }
}
