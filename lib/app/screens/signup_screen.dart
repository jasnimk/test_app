// // // signup_screen.dart
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:test_ecommerce_app/app/controllers/auth_controller.dart';
// // import 'package:test_ecommerce_app/app/widgets/custom_button.dart';
// // import 'package:test_ecommerce_app/app/widgets/text_form.dart';

// // class SignUpScreen extends StatelessWidget {
// //   final authController = Get.find<AuthController>();
// //   final _formKey = GlobalKey<FormState>();

// //   final TextEditingController usernameController = TextEditingController();
// //   final TextEditingController emailController = TextEditingController();
// //   final TextEditingController phoneController = TextEditingController();
// //   final TextEditingController passwordController = TextEditingController();
// //   final TextEditingController confirmPasswordController = TextEditingController();

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text('Sign Up')),
// //       body: SingleChildScrollView(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Form(
// //           key: _formKey,
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.stretch,
// //             children: [
// //               CustomTextFormField(
// //                 controller: usernameController,
// //                 label: 'Username',
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) {
// //                     return 'Please enter username';
// //                   }
// //                   return null;
// //                 },
// //               ),
// //               SizedBox(height: 16),
// //               CustomTextFormField(
// //                 controller: emailController,
// //                 label: 'Email',
// //                 keyboardType: TextInputType.emailAddress,
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) {
// //                     return 'Please enter email';
// //                   }
// //                   if (!GetUtils.isEmail(value)) {
// //                     return 'Please enter valid email';
// //                   }
// //                   return null;
// //                 },
// //               ),
// //               SizedBox(height: 16),
// //               CustomTextFormField(
// //                 controller: phoneController,
// //                 label: 'Phone Number',
// //                 keyboardType: TextInputType.phone,
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) {
// //                     return 'Please enter phone number';
// //                   }
// //                   if (!GetUtils.isPhoneNumber(value)) {
// //                     return 'Please enter valid phone number';
// //                   }
// //                   return null;
// //                 },
// //               ),
// //               SizedBox(height: 16),
// //               CustomTextFormField(
// //                 controller: passwordController,
// //                 label: 'Password',
// //                 obscureText: true,
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) {
// //                     return 'Please enter password';
// //                   }
// //                   if (value.length < 6) {
// //                     return 'Password must be at least 6 characters';
// //                   }
// //                   return null;
// //                 },
// //               ),
// //               SizedBox(height: 16),
// //               CustomTextFormField(
// //                 controller: confirmPasswordController,
// //                 label: 'Confirm Password',
// //                 obscureText: true,
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) {
// //                     return 'Please confirm password';
// //                   }
// //                   if (value != passwordController.text) {
// //                     return 'Passwords do not match';
// //                   }
// //                   return null;
// //                 },
// //               ),
// //               SizedBox(height: 32),
// //               Obx(() => CustomButton(
// //                 text: 'Sign Up',
// //                 onPressed: () async {
// //                   if (_formKey.currentState?.validate() ?? false) {
// //                     // Start with phone verification
// //                     await authController.startPhoneSignup(
// //                       phoneController.text,
// //                       usernameController.text,
// //                       emailController.text,
// //                       passwordController.text,
// //                     );
// //                   }
// //                 },
// //                 isLoading: authController.isLoading.value,
// //               )),
// //               SizedBox(height: 16),
// //               TextButton(
// //                 onPressed: () => Get.toNamed('/login'),
// //                 child: Text('Already have an account? Login'),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:test_ecommerce_app/app/controllers/auth_controller.dart';
// import 'package:test_ecommerce_app/app/widgets/custom_button.dart';
// import 'package:test_ecommerce_app/app/widgets/text_form.dart';

// class SignUpScreen extends StatelessWidget {
//   final authController = Get.find<AuthController>();
//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController =
//       TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Sign Up')),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               CustomTextFormField(
//                 controller: usernameController,
//                 label: 'Username',
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter username';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16),
//               CustomTextFormField(
//                 controller: emailController,
//                 label: 'Email',
//                 keyboardType: TextInputType.emailAddress,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter email';
//                   }
//                   if (!GetUtils.isEmail(value)) {
//                     return 'Please enter valid email';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16),
//               CustomTextFormField(
//                 controller: phoneController,
//                 label: 'Phone Number (e.g., +1234567890)',
//                 keyboardType: TextInputType.phone,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter phone number';
//                   }
//                   final formattedPhone =
//                       authController.formatPhoneNumber(value);
//                   if (!authController.isValidPhoneNumber(formattedPhone)) {
//                     return 'Please enter valid phone number with country code';
//                   }
//                   return null;
//                 },
//                 //helperText: 'Include country code (e.g., +1 for US)',
//               ),
//               SizedBox(height: 16),
//               CustomTextFormField(
//                 controller: passwordController,
//                 label: 'Password',
//                 obscureText: true,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter password';
//                   }
//                   if (value.length < 6) {
//                     return 'Password must be at least 6 characters';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16),
//               CustomTextFormField(
//                 controller: confirmPasswordController,
//                 label: 'Confirm Password',
//                 obscureText: true,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please confirm password';
//                   }
//                   if (value != passwordController.text) {
//                     return 'Passwords do not match';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 32),
//               Obx(() => CustomButton(
//                     text: 'Sign Up',
//                     onPressed: () async {
//                       if (_formKey.currentState?.validate() ?? false) {
//                         await authController.startPhoneSignup(
//                           phoneController.text,
//                           usernameController.text,
//                           emailController.text,
//                           passwordController.text,
//                         );
//                       }
//                     },
//                     isLoading: authController.isLoading.value,
//                   )),
//               SizedBox(height: 16),
//               TextButton(
//                 onPressed: () => Get.toNamed('/login'),
//                 child: Text('Already have an account? Login'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_ecommerce_app/app/widgets/custom_button.dart';
import 'package:test_ecommerce_app/app/widgets/text_form.dart';

final _formKey = GlobalKey<FormState>();

final TextEditingController usernameController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController phoneController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController confirmPasswordController = TextEditingController();

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Variables to store error messages for each field
  String? usernameError;
  String? emailError;
  String? phoneError;
  String? passwordError;
  String? confirmPasswordError;

  void validateUsername(String value) {
    setState(() {
      if (value.isEmpty) {
        usernameError = 'Please enter username';
      } else {
        usernameError = null;
      }
    });
  }

  void validateEmail(String value) {
    setState(() {
      if (value.isEmpty) {
        emailError = 'Please enter email';
      } else if (!GetUtils.isEmail(value)) {
        emailError = 'Please enter a valid email';
      } else {
        emailError = null;
      }
    });
  }

  void validatePhone(String value) {
    setState(() {
      if (value.isEmpty) {
        phoneError = 'Please enter phone number';
      } else if (value.length < 10) {
        phoneError = 'Phone number must be at least 10 digits';
      } else {
        phoneError = null;
      }
    });
  }

  void validatePassword(String value) {
    setState(() {
      if (value.isEmpty) {
        passwordError = 'Please enter password';
      } else if (value.length < 6) {
        passwordError = 'Password must be at least 6 characters';
      } else {
        passwordError = null;
      }
    });
  }

  void validateConfirmPassword(String value) {
    setState(() {
      if (value.isEmpty) {
        confirmPasswordError = 'Please confirm password';
      } else if (value != passwordController.text) {
        confirmPasswordError = 'Passwords do not match';
      } else {
        confirmPasswordError = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Username Field
              CustomTextFormField(
                controller: usernameController,
                label: 'Username',
                validator: (value) {
                  validateUsername(value ?? '');
                  return null; // Will be handled via custom validation
                },
                onChanged: validateUsername,
              ),
              if (usernameError != null)
                Text(usernameError!, style: TextStyle(color: Colors.red)),

              SizedBox(height: 16),

              // Email Field
              CustomTextFormField(
                controller: emailController,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  validateEmail(value ?? '');
                  return null; // Will be handled via custom validation
                },
                onChanged: validateEmail,
              ),
              if (emailError != null)
                Text(emailError!, style: TextStyle(color: Colors.red)),

              SizedBox(height: 16),

              // Phone Field
              CustomTextFormField(
                controller: phoneController,
                label: 'Phone Number',
                keyboardType: TextInputType.phone,
                validator: (value) {
                  validatePhone(value ?? '');
                  return null; // Will be handled via custom validation
                },
                onChanged: validatePhone,
              ),
              if (phoneError != null)
                Text(phoneError!, style: TextStyle(color: Colors.red)),

              SizedBox(height: 16),

              // Password Field
              CustomTextFormField(
                controller: passwordController,
                label: 'Password',
                obscureText: true,
                validator: (value) {
                  validatePassword(value ?? '');
                  return null; // Will be handled via custom validation
                },
                onChanged: validatePassword,
              ),
              if (passwordError != null)
                Text(passwordError!, style: TextStyle(color: Colors.red)),

              SizedBox(height: 16),

              // Confirm Password Field
              CustomTextFormField(
                controller: confirmPasswordController,
                label: 'Confirm Password',
                obscureText: true,
                validator: (value) {
                  validateConfirmPassword(value ?? '');
                  return null; // Will be handled via custom validation
                },
                onChanged: validateConfirmPassword,
              ),
              if (confirmPasswordError != null)
                Text(confirmPasswordError!,
                    style: TextStyle(color: Colors.red)),

              SizedBox(height: 32),

              // Sign Up Button
              CustomButton(
                text: 'Sign Up',
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Proceed with your signup logic
                    print('Proceed to sign up');
                  }
                },
              ),

              SizedBox(height: 16),

              // Login Redirect
              TextButton(
                onPressed: () => Get.toNamed('/login'),
                child: Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
