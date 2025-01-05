// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:test_ecommerce_app/app/controllers/auth_controller.dart';
// import 'package:test_ecommerce_app/app/widgets/custom_button.dart';
// import 'package:test_ecommerce_app/app/widgets/text_form.dart';
// import 'package:test_ecommerce_app/app/widgets/text_style.dart';

// class SignUpScreen extends StatefulWidget {
//   @override
//   _SignUpScreenState createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final authController = Get.find<AuthController>();

//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController =
//       TextEditingController();

//   String? usernameError;
//   String? emailError;
//   String? phoneError;
//   String? passwordError;
//   String? confirmPasswordError;

//   void validateUsername(String value) {
//     setState(() {
//       if (value.isEmpty) {
//         usernameError = 'Please enter username';
//       } else {
//         usernameError = null;
//       }
//     });
//   }

//   void validateEmail(String value) {
//     setState(() {
//       if (value.isEmpty) {
//         emailError = 'Please enter email';
//       } else if (!GetUtils.isEmail(value)) {
//         emailError = 'Please enter a valid email';
//       } else {
//         emailError = null;
//       }
//     });
//   }

//   void validatePhone(String value) {
//     setState(() {
//       if (value.isEmpty) {
//         phoneError = 'Please enter phone number';
//       } else if (value.length < 10) {
//         phoneError = 'Phone number must be at least 10 digits';
//       } else {
//         phoneError = null;
//       }
//     });
//   }

//   void validatePassword(String value) {
//     setState(() {
//       if (value.isEmpty) {
//         passwordError = 'Please enter password';
//       } else if (value.length < 6) {
//         passwordError = 'Password must be at least 6 characters';
//       } else {
//         passwordError = null;
//       }
//     });
//   }

//   void validateConfirmPassword(String value) {
//     setState(() {
//       if (value.isEmpty) {
//         confirmPasswordError = 'Please confirm password';
//       } else if (value != passwordController.text) {
//         confirmPasswordError = 'Passwords do not match';
//       } else {
//         confirmPasswordError = null;
//       }
//     });
//   }

//   bool validateForm() {
//     validateUsername(usernameController.text);
//     validateEmail(emailController.text);
//     validatePhone(phoneController.text);
//     validatePassword(passwordController.text);
//     validateConfirmPassword(confirmPasswordController.text);

//     return usernameError == null &&
//         emailError == null &&
//         phoneError == null &&
//         passwordError == null &&
//         confirmPasswordError == null;
//   }

//   // void handleSignUp() async {
//   //   if (!validateForm()) {
//   //     Get.snackbar(
//   //       'Error',
//   //       'Please fix the errors in the form',
//   //       backgroundColor: Colors.red,
//   //       colorText: Colors.white,
//   //     );
//   //     return;
//   //   }

//   //   try {
//   //     // Changed from signUpWithEmail to startPhoneSignup
//   //     await authController.signUpWithEmailAndPhone(
//   //       phoneController.text.trim(),
//   //       usernameController.text.trim(),
//   //       emailController.text.trim(),
//   //       passwordController.text,
//   //     );
//   //   } catch (e) {
//   //     print('Sign up error: $e');
//   //   }
//   // }
//   void handleSignUp() async {
//     if (!validateForm()) {
//       Get.snackbar(
//         'Error',
//         'Please fix the errors in the form',
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return;
//     }

//     final email = emailController.text.trim();
//     final phone = phoneController.text.trim();

//     // Additional email format validation
//     if (!GetUtils.isEmail(email)) {
//       Get.snackbar(
//         'Error',
//         'Please enter a valid email address',
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return;
//     }

//     try {
//       await authController.signUpWithEmailAndPhone(
//         phone,
//         usernameController.text.trim(),
//         email,
//         passwordController.text,
//       );
//     } catch (e) {
//       print('Sign up error: $e');
//     }
//   }

//   // void handleSignUp() async {
//   //   if (!validateForm()) {
//   //     Get.snackbar(
//   //       'Error',
//   //       'Please fix the errors in the form',
//   //       backgroundColor: Colors.red,
//   //       colorText: Colors.white,
//   //     );
//   //     return;
//   //   }

//   //   try {
//   //     await authController.signUpWithEmail(
//   //       emailController.text.trim(),
//   //       passwordController.text,
//   //       usernameController.text.trim(),
//   //       phoneController.text.trim(),
//   //     );
//   //   } catch (e) {
//   //     print('Sign up error: $e');
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Color(0xFF15384E), Colors.black],
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//         ),
//       ),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         appBar: AppBar(
//           title: Text(
//             'Sign Up',
//             style: AppTextStyles.montserratBold,
//           ),
//           automaticallyImplyLeading: false,
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//         ),
//         body: Obx(() => Stack(
//               children: [
//                 SingleChildScrollView(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       spacing: 10,
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         SizedBox(
//                             height: 150,
//                             width: 150,
//                             child: Image.asset('assets/Images/logo.png',
//                                 width: 50)),
//                         CustomTextFormField(
//                           controller: usernameController,
//                           label: 'Username',
//                           validator: (value) {
//                             validateUsername(value ?? '');
//                             return null;
//                           },
//                           onChanged: validateUsername,
//                         ),
//                         if (usernameError != null)
//                           Text(usernameError!, style: AppTextStyles.errorStyle),
//                         CustomTextFormField(
//                           controller: emailController,
//                           label: 'Email',
//                           keyboardType: TextInputType.emailAddress,
//                           validator: (value) {
//                             validateEmail(value ?? '');
//                             return null;
//                           },
//                           onChanged: validateEmail,
//                         ),
//                         if (emailError != null)
//                           Text(emailError!, style: AppTextStyles.errorStyle),
//                         CustomTextFormField(
//                           controller: phoneController,
//                           label: 'Phone Number',
//                           keyboardType: TextInputType.phone,
//                           validator: (value) {
//                             validatePhone(value ?? '');
//                             return null;
//                           },
//                           onChanged: validatePhone,
//                         ),
//                         if (phoneError != null)
//                           Text(phoneError!, style: AppTextStyles.errorStyle),
//                         CustomTextFormField(
//                           controller: passwordController,
//                           label: 'Password',
//                           obscureText: true,
//                           validator: (value) {
//                             validatePassword(value ?? '');
//                             return null;
//                           },
//                           onChanged: validatePassword,
//                         ),
//                         if (passwordError != null)
//                           Text(passwordError!, style: AppTextStyles.errorStyle),
//                         CustomTextFormField(
//                           controller: confirmPasswordController,
//                           label: 'Confirm Password',
//                           obscureText: true,
//                           validator: (value) {
//                             validateConfirmPassword(value ?? '');
//                             return null;
//                           },
//                           onChanged: validateConfirmPassword,
//                         ),
//                         if (confirmPasswordError != null)
//                           Text(confirmPasswordError!,
//                               style: AppTextStyles.errorStyle),
//                         SizedBox(height: 32),
//                         CustomButton(
//                           text: 'Sign Up',
//                           onPressed: authController.isLoading.value
//                               ? null
//                               : handleSignUp,
//                           // backgroundColor:
//                           //     const Color.fromARGB(255, 136, 161, 169),
//                           // textColor: Colors.black,
//                         ),
//                         TextButton(
//                           onPressed: () => Get.toNamed('/login'),
//                           child: Text(
//                             'Already have an account? Login',
//                             style: AppTextStyles.montserratBold
//                                 .copyWith(fontSize: 14),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 if (authController.isLoading.value)
//                   Container(
//                     color: Colors.black54,
//                     child: Center(
//                       child: CircularProgressIndicator(),
//                     ),
//                   ),
//               ],
//             )),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     usernameController.dispose();
//     emailController.dispose();
//     phoneController.dispose();
//     passwordController.dispose();
//     confirmPasswordController.dispose();
//     super.dispose();
//   }
// }
// signup_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/text_form.dart';

class SignUpScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final authController = Get.find<AuthController>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

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
          title: const Text('Sign Up'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Obx(() => Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Image.asset('assets/Images/logo.png', height: 150),
                        const SizedBox(height: 20),
                        CustomTextFormField(
                          controller: usernameController,
                          label: 'Username',
                          validator: (value) => GetUtils.isNullOrBlank(value)!
                              ? 'Please enter username'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        CustomTextFormField(
                          controller: emailController,
                          label: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) => !GetUtils.isEmail(value ?? '')
                              ? 'Please enter valid email'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        CustomTextFormField(
                          controller: phoneController,
                          label: 'Phone Number',
                          keyboardType: TextInputType.phone,
                          validator: (value) =>
                              GetUtils.isNullOrBlank(value)! ||
                                      value!.length < 10
                                  ? 'Please enter valid phone number'
                                  : null,
                        ),
                        const SizedBox(height: 16),
                        CustomTextFormField(
                          controller: passwordController,
                          label: 'Password',
                          obscureText: true,
                          validator: (value) =>
                              GetUtils.isNullOrBlank(value)! ||
                                      value!.length < 6
                                  ? 'Password must be at least 6 characters'
                                  : null,
                        ),
                        const SizedBox(height: 16),
                        CustomTextFormField(
                          controller: confirmPasswordController,
                          label: 'Confirm Password',
                          obscureText: true,
                          validator: (value) => value != passwordController.text
                              ? 'Passwords do not match'
                              : null,
                        ),
                        const SizedBox(height: 32),
                        CustomButton(
                          text: 'Sign Up',
                          onPressed: authController.isLoading.value
                              ? null
                              : () {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    authController.signUpWithEmailAndPhone(
                                      email: emailController.text.trim(),
                                      password: passwordController.text,
                                      username: usernameController.text.trim(),
                                      phone: phoneController.text.trim(),
                                    );
                                  }
                                },
                        ),
                        TextButton(
                          onPressed: () => Get.toNamed('/login'),
                          child: const Text(
                            'Already have an account? Login',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (authController.isLoading.value)
                  const Center(child: CircularProgressIndicator()),
              ],
            )),
      ),
    );
  }
}
