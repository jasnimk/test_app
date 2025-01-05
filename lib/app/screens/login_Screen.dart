// // login_screen.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:test_ecommerce_app/app/controllers/auth_controller.dart';
// import 'package:test_ecommerce_app/app/widgets/custom_button.dart';
// import 'package:test_ecommerce_app/app/widgets/text_form.dart';

// class LoginScreen extends StatelessWidget {
//   final authController = Get.find<AuthController>();
//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final RxBool isPasswordVisible = false.obs;

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
//         appBar: AppBar(
//           title: Text('Login'),
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           // centerTitle: true,
//         ),
//         body: SafeArea(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(16.0),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   //Logo or Brand Image
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 32.0),
//                     child: Image.asset(
//                       'assets/Images/logo.png', // Add your logo here
//                       height: 150,
//                       width: 150,
//                     ),
//                   ),

//                   // Email Field
//                   CustomTextFormField(
//                     controller: emailController,
//                     label: 'Email',
//                     hint: 'Enter your email',
//                     prefixIcon: Icon(Icons.email),
//                     keyboardType: TextInputType.emailAddress,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your email';
//                       }
//                       if (!GetUtils.isEmail(value)) {
//                         return 'Please enter a valid email';
//                       }
//                       return null;
//                     },
//                   ),

//                   SizedBox(height: 16),

//                   // Password Field
//                   Obx(() => CustomTextFormField(
//                         controller: passwordController,
//                         label: 'Password',
//                         hint: 'Enter your password',
//                         prefixIcon: Icon(Icons.lock),
//                         obscureText: !isPasswordVisible.value,
//                         suffixicon: IconButton(
//                           icon: Icon(
//                             isPasswordVisible.value
//                                 ? Icons.visibility
//                                 : Icons.visibility_off,
//                           ),
//                           onPressed: () => isPasswordVisible.toggle(),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter your password';
//                           }
//                           return null;
//                         },
//                       )),

//                   SizedBox(height: 16),

//                   // Forgot Password Link
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: TextButton(
//                       onPressed: () => Get.toNamed('/forgot-password'),
//                       child: Text('Forgot Password?'),
//                     ),
//                   ),

//                   SizedBox(height: 24),

//                   // Login Button
//                   Obx(() => CustomButton(
//                         text: 'Login with Email',
//                         onPressed: () {
//                           if (_formKey.currentState?.validate() ?? false) {
//                             authController.login(
//                               emailController.text.trim(),
//                               passwordController.text.trim(),
//                             );
//                           }
//                         },
//                         isLoading: authController.isLoading.value,
//                       )),

//                   SizedBox(height: 16),

//                   // Or Divider
//                   Row(
//                     children: [
//                       Expanded(child: Divider()),
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 16),
//                         child: Text('OR'),
//                       ),
//                       Expanded(child: Divider()),
//                     ],
//                   ),

//                   SizedBox(height: 16),

//                   // Phone Login Button
//                   CustomButton(
//                     text: 'Login with Phone Number',
//                     onPressed: () => Get.toNamed('/phone-login'),
//                     // style: CustomButtonStyle.outlined,
//                   ),

//                   SizedBox(height: 24),

//                   // Sign Up Link
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text("Don't have an account?"),
//                       TextButton(
//                         onPressed: () => Get.toNamed('/signup'),
//                         child: Text('Sign Up'),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
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
import 'package:test_ecommerce_app/app/widgets/text_style.dart';

class LoginScreen extends StatelessWidget {
  final authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RxBool isPasswordVisible = false.obs;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradient background
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF15384E), Colors.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent, // Ensure transparency
          appBar: AppBar(
            title: Text(
              'Login',
              style: AppTextStyles.montserratBold.copyWith(color: Colors.white),
            ),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo or Brand Image
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32.0),
                    child: Image.asset(
                      'assets/Images/logo.png',
                      height: 150,
                      width: 150,
                    ),
                  ),

                  // Email Field
                  CustomTextFormField(
                    controller: emailController,
                    label: 'Email',
                    //hint: 'Enter your email',
                    prefixIcon: const Icon(Icons.email, color: Colors.white),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!GetUtils.isEmail(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Password Field
                  Obx(() => CustomTextFormField(
                        controller: passwordController,
                        label: 'Password',
                        // hint: 'Enter your password',
                        prefixIcon: const Icon(Icons.lock, color: Colors.white),
                        obscureText: !isPasswordVisible.value,
                        suffixicon: IconButton(
                          icon: Icon(
                            isPasswordVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () => isPasswordVisible.toggle(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      )),

                  const SizedBox(height: 16),

                  // Forgot Password Link
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Get.toNamed('/forgot-password'),
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Login Button
                  Obx(() => CustomButton(
                        text: 'Login with Email',
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            authController.login(
                              emailController.text.trim(),
                              passwordController.text.trim(),
                            );
                          }
                        },
                        isLoading: authController.isLoading.value,
                      )),

                  const SizedBox(height: 16),

                  // Or Divider
                  Row(
                    children: [
                      const Expanded(child: Divider(color: Colors.white)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OR',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const Expanded(child: Divider(color: Colors.white)),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Phone Login Button
                  CustomButton(
                    text: 'Login with Phone Number',
                    onPressed: () => Get.toNamed('/phone-login'),
                  ),

                  const SizedBox(height: 24),

                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(color: Colors.white),
                      ),
                      TextButton(
                        onPressed: () => Get.toNamed('/signup'),
                        child: const Text('Sign Up',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
