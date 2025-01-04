// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:test_ecommerce_app/app/controllers/auth_controller.dart';
// import 'package:test_ecommerce_app/app/widgets/custom_button.dart';
// import 'package:test_ecommerce_app/app/widgets/text_form.dart';

// class VerifyOTPScreen extends StatelessWidget {
//   final authController = Get.find<AuthController>();
//   final TextEditingController otpController = TextEditingController();
//   final Map<String, String> userData = Get.arguments;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Verify OTP')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             CustomTextFormField(
//               controller: otpController,
//               label: 'Enter OTP',
//               keyboardType: TextInputType.number,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter OTP';
//                 }
//                 return null;
//               },
//             ),
//             SizedBox(height: 20),
//             Obx(() => CustomButton(
//                   text: 'Verify OTP',
//                   onPressed: () async {
//                     if (otpController.text.isNotEmpty) {
//                       await authController.verifyOTP(
//                         otpController.text,
//                         userData,
//                       );
//                     }
//                   },
//                   isLoading: authController.isLoading.value,
//                 )),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_ecommerce_app/app/controllers/auth_controller.dart';
import 'package:test_ecommerce_app/app/widgets/custom_button.dart';
import 'package:test_ecommerce_app/app/widgets/text_form.dart';

class VerifyOTPScreen extends StatelessWidget {
  final authController = Get.find<AuthController>();
  final TextEditingController otpController = TextEditingController();
  final Map<String, String> userData = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                ),
                const SizedBox(height: 20),
                Obx(() => CustomButton(
                      text: 'Verify OTP',
                      onPressed: () async {
                        if (otpController.text.isNotEmpty) {
                          await authController.verifyOTP(
                            otpController.text,
                            userData,
                          );
                        }
                      },
                      isLoading: authController.isLoading.value,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
