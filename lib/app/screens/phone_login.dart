// phone_login_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:test_ecommerce_app/app/controllers/auth_controller.dart';
import 'package:test_ecommerce_app/app/widgets/custom_button.dart';
import 'package:test_ecommerce_app/app/widgets/text_form.dart';

class PhoneLoginScreen extends StatelessWidget {
  final authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login with Phone'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextFormField(
                  controller: phoneController,
                  label: 'Phone Number',
                  hint: '+1234567890',
                  prefixIcon: Icon(Icons.phone),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    if (!GetUtils.isPhoneNumber(value)) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                Obx(() => CustomButton(
                      text: 'Send OTP',
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          authController.loginWithPhone(
                            phoneController.text.trim(),
                          );
                        }
                      },
                      isLoading: authController.isLoading.value,
                    )),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text('Login with Email Instead'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
