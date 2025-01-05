// // // auth_controller.dart
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:get/get.dart';
// // import 'package:test_ecommerce_app/app/controllers/offer_controller.dart';

// // class AuthController extends GetxController {
// //   final FirebaseAuth _auth = FirebaseAuth.instance;
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// //   final OfferController _offerController = Get.put(OfferController());

// //   var isLoading = false.obs;
// //   var verificationId = ''.obs;
// //   Rx<User?> user = Rx<User?>(null);
// //   int? forceResendingToken;
// //   var fieldErrors = <String, String?>{}.obs;
// //   Map<String, String>? _tempSignupData;

// //   @override
// //   void onInit() {
// //     super.onInit();
// //     user.bindStream(_auth.authStateChanges());
// //   }

// //   // Check if email exists
// //   Future<bool> isEmailTaken(String email) async {
// //     try {
// //       final methods = await _auth.fetchSignInMethodsForEmail(email);
// //       return methods.isNotEmpty;
// //     } catch (e) {
// //       return false;
// //     }
// //   }

// //   void validateField(
// //       String fieldName, String? Function(String?) validator, String value) {
// //     fieldErrors[fieldName] = validator(value);
// //   }

// //   // Format phone number to E.164 format
// //   String formatPhoneNumber(String phone) {
// //     // Remove any non-digit characters
// //     String digits = phone.replaceAll(RegExp(r'[^\d+]'), '');

// //     // If the number doesn't start with +, assume it's a local number and add country code
// //     if (!digits.startsWith('+')) {
// //       // Add your default country code here, e.g., +1 for US
// //       digits = '+91$digits';
// //     }

// //     return digits;
// //   }

// //   // Validate phone number format
// //   bool isValidPhoneNumber(String phone) {
// //     // Basic E.164 format validation
// //     // Should start with + followed by country code and number
// //     // Length should be between 8 and 15 digits
// //     final phoneRegex = RegExp(r'^\+[1-9]\d{1,14}$');
// //     return phoneRegex.hasMatch(formatPhoneNumber(phone));
// //   }

// //   // Check if phone exists
// //   Future<bool> isPhoneTaken(String phone) async {
// //     try {
// //       final formattedPhone = formatPhoneNumber(phone);
// //       final querySnapshot = await _firestore
// //           .collection('users')
// //           .where('phone', isEqualTo: formattedPhone)
// //           .get();
// //       return querySnapshot.docs.isNotEmpty;
// //     } catch (e) {
// //       return false;
// //     }
// //   }

// //   // Phone Login Method
// //   Future<void> loginWithPhone(String phone) async {
// //     try {
// //       isLoading.value = true;

// //       final formattedPhone = formatPhoneNumber(phone);
// //       if (!isValidPhoneNumber(formattedPhone)) {
// //         throw 'Invalid phone number format. Please enter a valid phone number with country code.';
// //       }

// //       await _auth.verifyPhoneNumber(
// //         phoneNumber: formattedPhone,
// //         verificationCompleted: (PhoneAuthCredential credential) async {
// //           await _signInWithPhoneCredential(credential);
// //         },
// //         verificationFailed: (FirebaseAuthException e) {
// //            showCustomSnackbar(title: '', message: 'Verification Failed!');('Error', e.message ?? 'Phone verification failed');
// //         },
// //         codeSent: (String vId, int? resendToken) {
// //           verificationId.value = vId;
// //           Get.toNamed('/verify-login-otp',
// //               arguments: {'phone': formattedPhone});
// //         },
// //         codeAutoRetrievalTimeout: (String vId) {
// //           verificationId.value = vId;
// //         },
// //       );
// //     } catch (e) {
// //        showCustomSnackbar(title: '', message: 'Verification Failed!');('Error', e.toString());
// //     } finally {
// //       isLoading.value = false;
// //     }
// //   }

// //   // Verify Phone Login OTP
// //   Future<void> verifyLoginOTP(String otp) async {
// //     try {
// //       isLoading.value = true;

// //       PhoneAuthCredential credential = PhoneAuthProvider.credential(
// //         verificationId: verificationId.value,
// //         smsCode: otp,
// //       );

// //       await _signInWithPhoneCredential(credential);
// //     } catch (e) {
// //        showCustomSnackbar(title: '', message: 'Verification Failed!');('Error', 'Invalid OTP');
// //     } finally {
// //       isLoading.value = false;
// //     }
// //   }

// //   // Helper method to sign in with phone credential
// //   Future<void> _signInWithPhoneCredential(
// //       PhoneAuthCredential credential) async {
// //     try {
// //       final userCredential = await _auth.signInWithCredential(credential);

// //       // Check if user exists in Firestore
// //       final userDoc = await _firestore
// //           .collection('users')
// //           .doc(userCredential.user?.uid)
// //           .get();

// //       if (!userDoc.exists) {
// //         // If user doesn't exist, create a new document
// //         await _firestore.collection('users').doc(userCredential.user?.uid).set({
// //           'phone': userCredential.user?.phoneNumber,
// //           'createdAt': FieldValue.serverTimestamp(),
// //         });
// //       }

// //        showCustomSnackbar(title: '', message: 'Verification Failed!');('Success', 'Login successful');
// //       Get.offAllNamed('/home');
// //     } catch (e) {
// //        showCustomSnackbar(title: '', message: 'Verification Failed!');('Error', 'Failed to sign in with phone number');
// //       throw e;
// //     }
// //   }

// //   // // Email & Password Sign Up
// //   // Future<void> signUpWithEmail(
// //   //   String email,
// //   //   String password,
// //   //   String username,
// //   //   String phone,
// //   // ) async {
// //   //   try {
// //   //     isLoading.value = true;

// //   //     // Check for duplicate email and phone
// //   //     if (await isEmailTaken(email)) {
// //   //       throw 'Email already in use';
// //   //     }
// //   //     if (await isPhoneTaken(phone)) {
// //   //       throw 'Phone number already in use';
// //   //     }

// //   //     // Create user account
// //   //     UserCredential userCredential =
// //   //         await _auth.createUserWithEmailAndPassword(
// //   //       email: email,
// //   //       password: password,
// //   //     );

// //   //     // Save additional user data
// //   //     await _firestore.collection('users').doc(userCredential.user?.uid).set({
// //   //       'username': username,
// //   //       'email': email,
// //   //       'phone': phone,
// //   //       'createdAt': FieldValue.serverTimestamp(),
// //   //       'hasReceivedWelcomeOffer': false,
// //   //     });
// //   //     await _offerController.showWelcomeOffer(Get.context!);

// //   //      showCustomSnackbar(title: '', message: 'Verification Failed!');('Success', 'Account created successfully');
// //   //     // Get.offAllNamed('/home');
// //   //   } catch (e) {
// //   //      showCustomSnackbar(title: '', message: 'Verification Failed!');('Error', e.toString());
// //   //   } finally {
// //   //     isLoading.value = false;
// //   //   }
// //   // }
// //   Future<void> signUpWithEmail(
// //     String email,
// //     String password,
// //     String username,
// //     String phone,
// //   ) async {
// //     try {
// //       isLoading.value = true;

// //       // Check for duplicate email and phone
// //       if (await isEmailTaken(email)) {
// //         throw 'Email already in use';
// //       }
// //       if (await isPhoneTaken(phone)) {
// //         throw 'Phone number already in use';
// //       }

// //       // Store the signup data temporarily
// //       _tempSignupData = {
// //         'email': email,
// //         'password': password,
// //         'username': username,
// //         'phone': phone,
// //       };

// //       // Start phone verification
// //       final formattedPhone = formatPhoneNumber(phone);
// //       if (!isValidPhoneNumber(formattedPhone)) {
// //         throw 'Invalid phone number format. Please enter a valid phone number with country code.';
// //       }

// //       await _auth.verifyPhoneNumber(
// //         phoneNumber: formattedPhone,
// //         timeout: Duration(seconds: 60),
// //         verificationCompleted: (PhoneAuthCredential credential) async {
// //           // Auto-verification completed (rare on iOS)
// //           await _completeEmailSignup(credential);
// //         },
// //         verificationFailed: (FirebaseAuthException e) {
// //            showCustomSnackbar(title: '', message: 'Verification Failed!');('Error', e.message ?? 'Phone verification failed');
// //         },
// //         codeSent: (String vId, int? resendToken) {
// //           verificationId.value = vId;
// //           forceResendingToken = resendToken;
// //           Get.toNamed('/verify-signup-otp',
// //               arguments: {'phone': formattedPhone});
// //         },
// //         codeAutoRetrievalTimeout: (String vId) {
// //           verificationId.value = vId;
// //         },
// //       );
// //     } catch (e) {
// //        showCustomSnackbar(title: '', message: 'Verification Failed!');('Error', e.toString());
// //     } finally {
// //       isLoading.value = false;
// //     }
// //   }

// //   // New method to verify OTP and complete email signup
// //   Future<void> verifySignupOTP(String otp) async {
// //     try {
// //       isLoading.value = true;

// //       if (_tempSignupData == null) {
// //         throw 'Signup data not found';
// //       }

// //       PhoneAuthCredential phoneCredential = PhoneAuthProvider.credential(
// //         verificationId: verificationId.value,
// //         smsCode: otp,
// //       );

// //       await _completeEmailSignup(phoneCredential);
// //     } catch (e) {
// //        showCustomSnackbar(title: '', message: 'Verification Failed!');('Error', 'Invalid OTP or signup failed');
// //     } finally {
// //       isLoading.value = false;
// //     }
// //   }

// //   // Helper method to complete email signup after phone verification
// //   Future<void> _completeEmailSignup(PhoneAuthCredential phoneCredential) async {
// //     try {
// //       if (_tempSignupData == null) {
// //         throw 'Signup data not found';
// //       }

// //       // Create user with email/password
// //       UserCredential userCredential =
// //           await _auth.createUserWithEmailAndPassword(
// //         email: _tempSignupData!['email']!,
// //         password: _tempSignupData!['password']!,
// //       );

// //       // Link phone credential
// //       await userCredential.user?.linkWithCredential(phoneCredential);

// //       // Save user data
// //       await _firestore.collection('users').doc(userCredential.user?.uid).set({
// //         'username': _tempSignupData!['username'],
// //         'email': _tempSignupData!['email'],
// //         'phone': _tempSignupData!['phone'],
// //         'createdAt': FieldValue.serverTimestamp(),
// //         'hasReceivedWelcomeOffer': false,
// //       });

// //       // Show welcome offer
// //       await _offerController.showWelcomeOffer(Get.context!);

// //       // Clear temporary data
// //       _tempSignupData = null;

// //        showCustomSnackbar(title: '', message: 'Verification Failed!');('Success', 'Account created successfully');
// //       Get.offAllNamed('/home');
// //     } catch (e) {
// //        showCustomSnackbar(title: '', message: 'Verification Failed!');('Error', 'Failed to complete signup: ${e.toString()}');
// //       throw e;
// //     }
// //   }

// //   Future<void> startPhoneSignup(
// //     String phone,
// //     String username,
// //     String email,
// //     String password,
// //   ) async {
// //     try {
// //       isLoading.value = true;

// //       final formattedPhone = formatPhoneNumber(phone);
// //       if (!isValidPhoneNumber(formattedPhone)) {
// //         throw 'Invalid phone number format. Please enter a valid phone number with country code.';
// //       }

// //       // Check for duplicate email and phone
// //       if (await isEmailTaken(email)) {
// //         throw 'Email already in use';
// //       }
// //       if (await isPhoneTaken(formattedPhone)) {
// //         throw 'Phone number already in use';
// //       }

// //       await _auth.verifyPhoneNumber(
// //         phoneNumber: formattedPhone,
// //         timeout: Duration(seconds: 60),
// //         forceResendingToken: forceResendingToken,
// //         verificationCompleted: (PhoneAuthCredential credential) async {
// //           // Auto-verification completed (rare on iOS)
// //           await _completePhoneSignup(credential, username, email, password);
// //         },
// //         verificationFailed: (FirebaseAuthException e) {
// //            showCustomSnackbar(title: '', message: 'Verification Failed!');('Error', e.message ?? 'Verification failed');
// //         },
// //         codeSent: (String vId, int? resendToken) {
// //           verificationId.value = vId;
// //           forceResendingToken = resendToken;
// //           Get.toNamed('/verify-otp', arguments: {
// //             'username': username,
// //             'email': email,
// //             'password': password,
// //             'phone': formattedPhone,
// //           });
// //         },
// //         codeAutoRetrievalTimeout: (String vId) {
// //           verificationId.value = vId;
// //         },
// //       );
// //     } catch (e) {
// //        showCustomSnackbar(title: '', message: 'Verification Failed!');('Error', e.toString());
// //     } finally {
// //       isLoading.value = false;
// //     }
// //   }

// //   // Complete Phone Signup
// //   Future<void> _completePhoneSignup(
// //     PhoneAuthCredential credential,
// //     String username,
// //     String email,
// //     String password,
// //   ) async {
// //     try {
// //       final userCredential = await _auth.signInWithCredential(credential);

// //       // Create email/password account and link it
// //       final emailCredential = EmailAuthProvider.credential(
// //         email: email,
// //         password: password,
// //       );
// //       await userCredential.user?.linkWithCredential(emailCredential);

// //       // Save user data
// //       await _firestore.collection('users').doc(userCredential.user?.uid).set({
// //         'username': username,
// //         'email': email,
// //         'phone': userCredential.user?.phoneNumber,
// //         'createdAt': FieldValue.serverTimestamp(),
// //       });

// //        showCustomSnackbar(title: '', message: 'Verification Failed!');('Success', 'Account created successfully');
// //       Get.offAllNamed('/home');
// //     } catch (e) {
// //        showCustomSnackbar(title: '', message: 'Verification Failed!');('Error', 'Failed to complete signup');
// //     }
// //   }

// //   // Verify OTP
// //   Future<void> verifyOTP(String otp, Map<String, String> userData) async {
// //     try {
// //       isLoading.value = true;

// //       PhoneAuthCredential credential = PhoneAuthProvider.credential(
// //         verificationId: verificationId.value,
// //         smsCode: otp,
// //       );

// //       await _completePhoneSignup(
// //         credential,
// //         userData['username']!,
// //         userData['email']!,
// //         userData['password']!,
// //       );
// //     } catch (e) {
// //        showCustomSnackbar(title: '', message: 'Verification Failed!');('Error', 'Invalid OTP');
// //     } finally {
// //       isLoading.value = false;
// //     }
// //   }

// //   // Login
// //   Future<void> login(String email, String password) async {
// //     try {
// //       isLoading.value = true;
// //       await _auth.signInWithEmailAndPassword(
// //         email: email,
// //         password: password,
// //       );
// //       Get.offAllNamed('/home');
// //     } on FirebaseAuthException catch (e) {
// //        showCustomSnackbar(title: '', message: 'Verification Failed!');('Error', e.message ?? 'Login failed');
// //     } finally {
// //       isLoading.value = false;
// //     }
// //   }

// //   // Sign Out
// //   Future<void> signOut() async {
// //     try {
// //       await _auth.signOut();
// //       Get.offAllNamed('/login');
// //     } catch (e) {
// //        showCustomSnackbar(title: '', message: 'Verification Failed!');('Error', 'Failed to sign out');
// //     }
// //   }
// // }

// // auth_controller.dart
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';

// class AuthController extends GetxController {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   var isLoading = false.obs;
//   var verificationId = ''.obs;
//   Rx<User?> user = Rx<User?>(null);
//   int? forceResendingToken;
//   var fieldErrors = <String, String?>{}.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     user.bindStream(_auth.authStateChanges());
//   }

//   // Check if email exists
//   Future<bool> isEmailTaken(String email) async {
//     try {
//       final methods = await _auth.fetchSignInMethodsForEmail(email);
//       return methods.isNotEmpty;
//     } catch (e) {
//       return false;
//     }
//   }

//   void validateField(
//       String fieldName, String? Function(String?) validator, String value) {
//     fieldErrors[fieldName] = validator(value);
//   }

//   // Format phone number to E.164 format
//   String formatPhoneNumber(String phone) {
//     // Remove any non-digit characters
//     String digits = phone.replaceAll(RegExp(r'[^\d+]'), '');

//     // If the number doesn't start with +, assume it's a local number and add country code
//     if (!digits.startsWith('+')) {
//       // Add your default country code here, e.g., +1 for US
//       digits = '+91$digits';
//     }

//     return digits;
//   }

//   // Validate phone number format
//   bool isValidPhoneNumber(String phone) {
//     // Basic E.164 format validation
//     // Should start with + followed by country code and number
//     // Length should be between 8 and 15 digits
//     final phoneRegex = RegExp(r'^\+[1-9]\d{1,14}$');
//     return phoneRegex.hasMatch(formatPhoneNumber(phone));
//   }

//   // Check if phone exists
//   Future<bool> isPhoneTaken(String phone) async {
//     try {
//       final formattedPhone = formatPhoneNumber(phone);
//       final querySnapshot = await _firestore
//           .collection('users')
//           .where('phone', isEqualTo: formattedPhone)
//           .get();
//       return querySnapshot.docs.isNotEmpty;
//     } catch (e) {
//       return false;
//     }
//   }

//   // Phone Login Method
//   Future<void> loginWithPhone(String phone) async {
//     try {
//       isLoading.value = true;

//       final formattedPhone = formatPhoneNumber(phone);
//       if (!isValidPhoneNumber(formattedPhone)) {
//         throw 'Invalid phone number format. Please enter a valid phone number with country code.';
//       }

//       await _auth.verifyPhoneNumber(
//         phoneNumber: formattedPhone,
//         verificationCompleted: (PhoneAuthCredential credential) async {
//           await _signInWithPhoneCredential(credential);
//         },
//         verificationFailed: (FirebaseAuthException e) {
//            showCustomSnackbar(title: '', message: 'Verification Failed!');('Error', e.message ?? 'Phone verification failed');
//         },
//         codeSent: (String vId, int? resendToken) {
//           verificationId.value = vId;
//           Get.toNamed('/verify-login-otp',
//               arguments: {'phone': formattedPhone});
//         },
//         codeAutoRetrievalTimeout: (String vId) {
//           verificationId.value = vId;
//         },
//       );
//     } catch (e) {
//        showCustomSnackbar(title: '', message: 'Verification Failed!');('Error', e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // Verify Phone Login OTP
//   Future<void> verifyLoginOTP(String otp) async {
//     try {
//       isLoading.value = true;

//       PhoneAuthCredential credential = PhoneAuthProvider.credential(
//         verificationId: verificationId.value,
//         smsCode: otp,
//       );

//       await _signInWithPhoneCredential(credential);
//     } catch (e) {
//        showCustomSnackbar(title: '', message: 'Verification Failed!');('Error', 'Invalid OTP');
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // Helper method to sign in with phone credential
//   Future<void> _signInWithPhoneCredential(
//       PhoneAuthCredential credential) async {
//     try {
//       final userCredential = await _auth.signInWithCredential(credential);

//       // Check if user exists in Firestore
//       final userDoc = await _firestore
//           .collection('users')
//           .doc(userCredential.user?.uid)
//           .get();

//       if (!userDoc.exists) {
//         // If user doesn't exist, create a new document
//         await _firestore.collection('users').doc(userCredential.user?.uid).set({
//           'phone': userCredential.user?.phoneNumber,
//           'createdAt': FieldValue.serverTimestamp(),
//         });
//       }

//        showCustomSnackbar(title: '', message: 'Verification Failed!');('Success', 'Login successful');
//       Get.offAllNamed('/home');
//     } catch (e) {
//        showCustomSnackbar(title: '', message: 'Verification Failed!');('Error', 'Failed to sign in with phone number');
//       throw e;
//     }
//   }

//   // Email & Password Sign Up
//   Future<void> signUpWithEmail(
//     String email,
//     String password,
//     String username,
//     String phone,
//   ) async {
//     try {
//       isLoading.value = true;

//       // Check for duplicate email and phone
//       if (await isEmailTaken(email)) {
//         throw 'Email already in use';
//       }
//       if (await isPhoneTaken(phone)) {
//         throw 'Phone number already in use';
//       }

//       // Create user account
//       UserCredential userCredential =
//           await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       // Save additional user data
//       await _firestore.collection('users').doc(userCredential.user?.uid).set({
//         'username': username,
//         'email': email,
//         'phone': phone,
//         'createdAt': FieldValue.serverTimestamp(),
//       });

//        showCustomSnackbar(title: '', message: 'Verification Failed!');('Success', 'Account created successfully');
//       Get.offAllNamed('/home');
//     } catch (e) {
//        showCustomSnackbar(title: '', message: 'Verification Failed!');('Error', e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> startPhoneSignup(
//     String phone,
//     String username,
//     String email,
//     String password,
//   ) async {
//     try {
//       isLoading.value = true;

//       final formattedPhone = formatPhoneNumber(phone);
//       if (!isValidPhoneNumber(formattedPhone)) {
//         throw 'Invalid phone number format. Please enter a valid phone number with country code.';
//       }

//       // Check for duplicate email and phone
//       if (await isEmailTaken(email)) {
//         throw 'Email already in use';
//       }
//       if (await isPhoneTaken(formattedPhone)) {
//         throw 'Phone number already in use';
//       }

//       await _auth.verifyPhoneNumber(
//         phoneNumber: formattedPhone,
//         timeout: Duration(seconds: 60),
//         forceResendingToken: forceResendingToken,
//         verificationCompleted: (PhoneAuthCredential credential) async {
//           // Auto-verification completed (rare on iOS)
//           await _completePhoneSignup(credential, username, email, password);
//         },
//         verificationFailed: (FirebaseAuthException e) {
//            showCustomSnackbar(title: '', message: 'Verification Failed!');('Error', e.message ?? 'Verification failed');
//         },
//         codeSent: (String vId, int? resendToken) {
//           verificationId.value = vId;
//           forceResendingToken = resendToken;
//           Get.toNamed('/verify-otp', arguments: {
//             'username': username,
//             'email': email,
//             'password': password,
//             'phone': formattedPhone,
//           });
//         },
//         codeAutoRetrievalTimeout: (String vId) {
//           verificationId.value = vId;
//         },
//       );
//     } catch (e) {
//        showCustomSnackbar(title: '', message: 'Verification Failed!');('Error', e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // Complete Phone Signup
//   Future<void> _completePhoneSignup(
//     PhoneAuthCredential credential,
//     String username,
//     String email,
//     String password,
//   ) async {
//     try {
//       final userCredential = await _auth.signInWithCredential(credential);

//       // Create email/password account and link it
//       final emailCredential = EmailAuthProvider.credential(
//         email: email,
//         password: password,
//       );
//       await userCredential.user?.linkWithCredential(emailCredential);

//       // Save user data
//       await _firestore.collection('users').doc(userCredential.user?.uid).set({
//         'username': username,
//         'email': email,
//         'phone': userCredential.user?.phoneNumber,
//         'createdAt': FieldValue.serverTimestamp(),
//       });

//        showCustomSnackbar(title: '', message: 'Verification Failed!');('Success', 'Account created successfully');
//       Get.offAllNamed('/home');
//     } catch (e) {
//        showCustomSnackbar(title: '', message: 'Verification Failed!');('Error', 'Failed to complete signup');
//     }
//   }

//   // Verify OTP
//   Future<void> verifyOTP(String otp, Map<String, String> userData) async {
//     try {
//       isLoading.value = true;

//       PhoneAuthCredential credential = PhoneAuthProvider.credential(
//         verificationId: verificationId.value,
//         smsCode: otp,
//       );

//       await _completePhoneSignup(
//         credential,
//         userData['username']!,
//         userData['email']!,
//         userData['password']!,
//       );
//     } catch (e) {
//        showCustomSnackbar(title: '', message: 'Verification Failed!');('Error', 'Invalid OTP');
//     } finally {
//       isLoading.value = false;
//     }
//   }
// // Combined signup method for both email and phone
//   Future<void> signUpWithEmailAndPhone(
//     String email,
//     String password,
//     String username,
//     String phone,
//   ) async {
//     try {
//       isLoading.value = true;

//       // Format and validate phone number
//       final formattedPhone = formatPhoneNumber(phone);
//       if (!isValidPhoneNumber(formattedPhone)) {
//         throw 'Invalid phone number format';
//       }

//       // Check for existing accounts
//       if (await isEmailTaken(email)) {
//         throw 'Email already in use';
//       }
//       if (await isPhoneTaken(formattedPhone)) {
//         throw 'Phone number already in use';
//       }

//       // First create account with email/password
//       UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       // Automatically verify phone without showing reCAPTCHA
//       await _auth.verifyPhoneNumber(
//         phoneNumber: formattedPhone,
//         timeout: const Duration(seconds: 60),
//         verificationCompleted: (PhoneAuthCredential credential) async {
//           // Link phone credential with email account
//           await userCredential.user?.linkWithCredential(credential);

//           // Save user data to Firestore
//           await _saveUserData(
//             userCredential.user!.uid,
//             username,
//             email,
//             formattedPhone,
//           );

//            showCustomSnackbar(title: '', message: 'Verification Failed!');('Success', 'Account created successfully');
//           Get.offAllNamed('/home');
//         },
//         verificationFailed: (FirebaseAuthException e) {
//            showCustomSnackbar(title: '', message: 'Verification Failed!');('Error', e.message ?? 'Verification failed');
//         },
//         codeSent: (String vId, int? resendToken) {
//           verificationId.value = vId;
//           Get.toNamed('/verify-signup-otp', arguments: {
//             'uid': userCredential.user?.uid,
//             'username': username,
//             'email': email,
//             'phone': formattedPhone,
//           });
//         },
//         codeAutoRetrievalTimeout: (String vId) {
//           verificationId.value = vId;
//         },
//         forceResendingToken: null,
//       );
//     } catch (e) {
//        showCustomSnackbar(title: '', message: 'Verification Failed!');('Error', e.toString());
//       // Clean up if account creation fails
//       if (_auth.currentUser != null) {
//         await _auth.currentUser?.delete();
//       }
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // Verify OTP for signup
//   Future<void> verifySignupOTP(String otp, Map<String, String> userData) async {
//     try {
//       isLoading.value = true;

//       // Create phone credential
//       PhoneAuthCredential phoneCredential = PhoneAuthProvider.credential(
//         verificationId: verificationId.value,
//         smsCode: otp,
//       );

//       // Link phone credential to existing user
//       await _auth.currentUser?.linkWithCredential(phoneCredential);

//       // Save user data to Firestore
//       await _saveUserData(
//         _auth.currentUser!.uid,
//         userData['username']!,
//         userData['email']!,
//         userData['phone']!,
//       );

//        showCustomSnackbar(title: '', message: 'Verification Failed!');('Success', 'Phone number verified successfully');
//       Get.offAllNamed('/home');
//     } catch (e) {
//        showCustomSnackbar(title: '', message: 'Verification Failed!');('Error', 'Invalid OTP');
//       // Clean up if verification fails
//       if (_auth.currentUser != null) {
//         await _auth.currentUser?.delete();
//       }
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // Helper method to save user data
//   Future<void> _saveUserData(
//     String uid,
//     String username,
//     String email,
//     String phone,
//   ) async {
//     await _firestore.collection('users').doc(uid).set({
//       'username': username,
//       'email': email,
//       'phone': phone,
//       'createdAt': FieldValue.serverTimestamp(),
//     });
//   }

//   // Login
//   Future<void> login(String email, String password) async {
//     try {
//       isLoading.value = true;
//       await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       Get.offAllNamed('/home');
//     } on FirebaseAuthException catch (e) {
//        showCustomSnackbar(title: '', message: 'Verification Failed!');('Error', e.message ?? 'Login failed');
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // Sign Out
//   Future<void> signOut() async {
//     try {
//       await _auth.signOut();
//       Get.offAllNamed('/login');
//     } catch (e) {
//        showCustomSnackbar(title: '', message: 'Verification Failed!');('Error', 'Failed to sign out');
//     }
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:test_ecommerce_app/app/widgets/custom_snackbar.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var isLoading = false.obs;
  var verificationId = ''.obs;
  Rx<User?> user = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_auth.authStateChanges());
  }

  Future<void> startSignup({
    required String email,
    required String password,
    required String username,
    required String phone,
  }) async {
    try {
      isLoading.value = true;

      // Validate email
      if (!GetUtils.isEmail(email)) {
        throw 'Invalid email format';
      }

      // Format and validate phone
      final formattedPhone = formatIndianPhoneNumber(phone);

      // Check if email/phone already exists
      if (await isEmailTaken(email)) {
        throw 'Email already in use';
      }
      if (await isPhoneTaken(formattedPhone)) {
        throw 'Phone number already in use';
      }

      // Create user with email/password first
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Send OTP to phone
      await _auth.verifyPhoneNumber(
        phoneNumber: formattedPhone,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification completed (rare on iOS)
          await _completeSignup(
            credential: credential,
            uid: userCredential.user!.uid,
            username: username,
            email: email,
            phone: formattedPhone,
          );
        },
        verificationFailed: (FirebaseAuthException e) {
          showCustomSnackbar(title: '', message: 'Verification Failed!');
          _auth.currentUser?.delete(); // Clean up if verification fails
        },
        codeSent: (String vId, int? resendToken) {
          verificationId.value = vId;
          Get.toNamed('/verify-otp', arguments: {
            'uid': userCredential.user?.uid,
            'username': username,
            'email': email,
            'phone': formattedPhone,
            'password': password,
          });
        },
        codeAutoRetrievalTimeout: (String vId) {
          verificationId.value = vId;
        },
      );
    } catch (e) {
      showCustomSnackbar(title: '', message: 'Error, e.toString()');
      // Clean up if anything fails
      if (_auth.currentUser != null) {
        await _auth.currentUser?.delete();
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Verify OTP for signup
  Future<void> verifySignupOTP(
      String otp, Map<String, dynamic> userData) async {
    try {
      isLoading.value = true;

      PhoneAuthCredential phoneCredential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: otp,
      );

      await _completeSignup(
        credential: phoneCredential,
        uid: userData['uid'],
        username: userData['username'],
        email: userData['email'],
        phone: userData['phone'],
      );
    } catch (e) {
      showCustomSnackbar(title: '', message: 'Invalid OTP');
      if (_auth.currentUser != null) {
        await _auth.currentUser?.delete();
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Resend OTP
  Future<void> resendOTP(Map<String, dynamic> userData) async {
    try {
      isLoading.value = true;

      await _auth.verifyPhoneNumber(
        phoneNumber: userData['phone'],
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _completeSignup(
            credential: credential,
            uid: userData['uid'],
            username: userData['username'],
            email: userData['email'],
            phone: userData['phone'],
          );
        },
        verificationFailed: (FirebaseAuthException e) {
          showCustomSnackbar(
              title: '', message: 'Error, e.message ?? Failed to resend OTP');
        },
        codeSent: (String vId, int? resendToken) {
          verificationId.value = vId;
          showCustomSnackbar(title: '', message: 'OTP Sen Succesfully!');
        },
        codeAutoRetrievalTimeout: (String vId) {
          verificationId.value = vId;
        },
      );
    } catch (e) {
      showCustomSnackbar(title: '', message: 'Error, Failed to resend OTP');
    } finally {
      isLoading.value = false;
    }
  }

  // Helper method to complete signup
  Future<void> _completeSignup({
    required PhoneAuthCredential credential,
    required String uid,
    required String username,
    required String email,
    required String phone,
  }) async {
    try {
      // Link phone credential with email account
      await _auth.currentUser?.linkWithCredential(credential);

      // Save user data to Firestore
      await _firestore.collection('users').doc(uid).set({
        'username': username,
        'email': email,
        'phone': phone,
        'createdAt': FieldValue.serverTimestamp(),
        'isNewUser': true,
      });

      showCustomSnackbar(
          title: '', message: 'Success. Account created successfully');
      Get.offAllNamed('/home');
    } catch (e) {
      showCustomSnackbar(title: '', message: 'Verification Failed!');
      ('Error', 'Failed to complete signup');
      throw e;
    }
  }

  // Format phone number to E.164 format for India
  String formatIndianPhoneNumber(String phone) {
    String digits = phone.replaceAll(RegExp(r'[^\d]'), '');
    // Remove leading zeros
    digits = digits.replaceAll(RegExp(r'^0+'), '');
    // Ensure 10 digits for Indian numbers
    if (digits.length > 10) {
      digits = digits.substring(digits.length - 10);
    }
    return '+91$digits';
  }

  // Check if email exists
  Future<bool> isEmailTaken(String email) async {
    try {
      // ignore: deprecated_member_use
      final methods = await _auth.fetchSignInMethodsForEmail(email);
      return methods.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Check if phone exists
  Future<bool> isPhoneTaken(String phone) async {
    try {
      final formattedPhone = formatIndianPhoneNumber(phone);
      final querySnapshot = await _firestore
          .collection('users')
          .where('phone', isEqualTo: formattedPhone)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Login with Email and Password
  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.offAllNamed('/home');
    } on FirebaseAuthException {
      showCustomSnackbar(title: '', message: 'Login Failed!');
    } finally {
      isLoading.value = false;
    }
  }

  // Phone Login Method
  Future<void> loginWithPhone(String phone) async {
    try {
      isLoading.value = true;
      final formattedPhone = formatIndianPhoneNumber(phone);

      await _auth.verifyPhoneNumber(
        phoneNumber: formattedPhone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _signInWithPhoneCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          showCustomSnackbar(title: '', message: 'Phone Verification Failed!');
        },
        codeSent: (String vId, int? resendToken) {
          verificationId.value = vId;
          Get.toNamed('/verify-login-otp',
              arguments: {'phone': formattedPhone});
        },
        codeAutoRetrievalTimeout: (String vId) {
          verificationId.value = vId;
        },
      );
    } catch (e) {
      showCustomSnackbar(title: '', message: 'Error, ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // Verify Phone Login OTP
  Future<void> verifyLoginOTP(String otp) async {
    try {
      isLoading.value = true;
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: otp,
      );
      await _signInWithPhoneCredential(credential);
    } catch (e) {
      showCustomSnackbar(title: '', message: 'Invalid OTP');
    } finally {
      isLoading.value = false;
    }
  }

  // Helper method to sign in with phone credential
  Future<void> _signInWithPhoneCredential(
      PhoneAuthCredential credential) async {
    try {
      final userCredential = await _auth.signInWithCredential(credential);

      // Check if user exists in Firestore
      final userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user?.uid)
          .get();

      if (!userDoc.exists) {
        await _firestore.collection('users').doc(userCredential.user?.uid).set({
          'phone': userCredential.user?.phoneNumber,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      showCustomSnackbar(title: '', message: 'Login successful');
      Get.offAllNamed('/home');
    } catch (e) {
      showCustomSnackbar(
          title: '', message: 'Failed to sign in with phone number!');
      throw e;
    }
  }

  // Combined Email and Phone Signup
  Future<void> signUpWithEmailAndPhone({
    required String email,
    required String password,
    required String username,
    required String phone,
  }) async {
    try {
      isLoading.value = true;

      // Validate email
      if (!GetUtils.isEmail(email)) {
        throw 'Invalid email format';
      }

      // Format and validate phone
      final formattedPhone = formatIndianPhoneNumber(phone);

      // Check if email/phone already exists
      if (await isEmailTaken(email)) {
        throw 'Email already in use';
      }
      if (await isPhoneTaken(formattedPhone)) {
        throw 'Phone number already in use';
      }

      // Create user with email/password
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Send OTP to phone
      await _auth.verifyPhoneNumber(
        phoneNumber: formattedPhone,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _completeSignup(
            credential: credential,
            uid: userCredential.user!.uid,
            username: username,
            email: email,
            phone: formattedPhone,
          );
        },
        verificationFailed: (FirebaseAuthException e) {
          showCustomSnackbar(title: '', message: 'Verification Failed!');
          _auth.currentUser?.delete();
        },
        codeSent: (String vId, int? resendToken) {
          verificationId.value = vId;
          Get.toNamed('/verify-otp', arguments: {
            'uid': userCredential.user?.uid,
            'username': username,
            'email': email,
            'phone': formattedPhone,
          });
        },
        codeAutoRetrievalTimeout: (String vId) {
          verificationId.value = vId;
        },
      );
    } catch (e) {
      showCustomSnackbar(title: '', message: 'Error, ${e.toString()}');
      if (_auth.currentUser != null) {
        await _auth.currentUser?.delete();
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Verify OTP for Signup
  Future<void> verifyOTP(String otp, Map<String, String> userData) async {
    try {
      isLoading.value = true;

      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: otp,
      );

      await _completeSignup(
        credential: credential,
        uid: userData['uid']!,
        username: userData['username']!,
        email: userData['email']!,
        phone: userData['phone']!,
      );
    } catch (e) {
      showCustomSnackbar(title: '', message: 'Invalid OTP');
      if (_auth.currentUser != null) {
        await _auth.currentUser?.delete();
      }
    } finally {
      isLoading.value = false;
    }
  }

  // // Helper method to complete signup process
  // Future<void> _completeSignup({
  //   required PhoneAuthCredential credential,
  //   required String uid,
  //   required String username,
  //   required String email,
  //   required String phone,
  // }) async {
  //   try {
  //     // Link phone credential with email account
  //     await _auth.currentUser?.linkWithCredential(credential);

  //     // Save user data
  //     await _firestore.collection('users').doc(uid).set({
  //       'username': username,
  //       'email': email,
  //       'phone': phone,
  //       'createdAt': FieldValue.serverTimestamp(),
  //     });

  //      showCustomSnackbar(title: '', message: 'Verification Failed!');('Success', 'Account created successfully');
  //     Get.offAllNamed('/home');
  //   } catch (e) {
  //      showCustomSnackbar(title: '', message: 'Verification Failed!');('Error', 'Failed to complete signup');
  //     throw e;
  //   }
  // }

  // Sign Out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      Get.offAllNamed('/login');
    } catch (e) {
      showCustomSnackbar(title: '', message: 'Failed To SignOut!');
    }
  }
}
