import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/text_form.dart';

class VerifyOTPScreen extends StatelessWidget {
  final authController = Get.find<AuthController>();
  final TextEditingController otpController = TextEditingController();

  Map<String, dynamic> get userData =>
      Get.arguments as Map<String, dynamic>? ?? {};

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF15384E), Colors.black],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Verify Phone Number'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Obx(() => Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        'Enter the OTP sent to\n${userData['phone'] ?? ''}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      CustomTextFormField(
                        controller: otpController,
                        label: 'Enter OTP',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter OTP';
                          }
                          return null;
                        },
                        // maxLength: 6,
                        //textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      CustomButton(
                        text: 'Verify OTP',
                        onPressed: authController.isLoading.value
                            ? null
                            : () {
                                if (otpController.text.length == 6) {
                                  authController.verifySignupOTP(
                                      otpController.text, userData);
                                } else {
                                  Get.snackbar(
                                    'Error',
                                    'Please enter a valid 6-digit OTP',
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                }
                              },
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: authController.isLoading.value
                            ? null
                            : () {
                                authController.resendOTP(userData);
                              },
                        child: const Text(
                          'Resend OTP',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                if (authController.isLoading.value)
                  Container(
                    color: Colors.black54,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            )),
      ),
    );
  }
}
