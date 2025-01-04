// auth_controller.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var isLoading = false.obs;
  var verificationId = ''.obs;
  Rx<User?> user = Rx<User?>(null);
  int? forceResendingToken;
  var fieldErrors = <String, String?>{}.obs;

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_auth.authStateChanges());
  }

  // Check if email exists
  Future<bool> isEmailTaken(String email) async {
    try {
      final methods = await _auth.fetchSignInMethodsForEmail(email);
      return methods.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  void validateField(
      String fieldName, String? Function(String?) validator, String value) {
    fieldErrors[fieldName] = validator(value);
  }

  // Format phone number to E.164 format
  String formatPhoneNumber(String phone) {
    // Remove any non-digit characters
    String digits = phone.replaceAll(RegExp(r'[^\d+]'), '');

    // If the number doesn't start with +, assume it's a local number and add country code
    if (!digits.startsWith('+')) {
      // Add your default country code here, e.g., +1 for US
      digits = '+91$digits';
    }

    return digits;
  }

  // Validate phone number format
  bool isValidPhoneNumber(String phone) {
    // Basic E.164 format validation
    // Should start with + followed by country code and number
    // Length should be between 8 and 15 digits
    final phoneRegex = RegExp(r'^\+[1-9]\d{1,14}$');
    return phoneRegex.hasMatch(formatPhoneNumber(phone));
  }

  // Check if phone exists
  Future<bool> isPhoneTaken(String phone) async {
    try {
      final formattedPhone = formatPhoneNumber(phone);
      final querySnapshot = await _firestore
          .collection('users')
          .where('phone', isEqualTo: formattedPhone)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Phone Login Method
  Future<void> loginWithPhone(String phone) async {
    try {
      isLoading.value = true;

      final formattedPhone = formatPhoneNumber(phone);
      if (!isValidPhoneNumber(formattedPhone)) {
        throw 'Invalid phone number format. Please enter a valid phone number with country code.';
      }

      await _auth.verifyPhoneNumber(
        phoneNumber: formattedPhone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _signInWithPhoneCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          Get.snackbar('Error', e.message ?? 'Phone verification failed');
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
      Get.snackbar('Error', e.toString());
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
      Get.snackbar('Error', 'Invalid OTP');
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
        // If user doesn't exist, create a new document
        await _firestore.collection('users').doc(userCredential.user?.uid).set({
          'phone': userCredential.user?.phoneNumber,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      Get.snackbar('Success', 'Login successful');
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar('Error', 'Failed to sign in with phone number');
      throw e;
    }
  }

  // Email & Password Sign Up
  Future<void> signUpWithEmail(
    String email,
    String password,
    String username,
    String phone,
  ) async {
    try {
      isLoading.value = true;

      // Check for duplicate email and phone
      if (await isEmailTaken(email)) {
        throw 'Email already in use';
      }
      if (await isPhoneTaken(phone)) {
        throw 'Phone number already in use';
      }

      // Create user account
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save additional user data
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'username': username,
        'email': email,
        'phone': phone,
        'createdAt': FieldValue.serverTimestamp(),
      });

      Get.snackbar('Success', 'Account created successfully');
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> startPhoneSignup(
    String phone,
    String username,
    String email,
    String password,
  ) async {
    try {
      isLoading.value = true;

      final formattedPhone = formatPhoneNumber(phone);
      if (!isValidPhoneNumber(formattedPhone)) {
        throw 'Invalid phone number format. Please enter a valid phone number with country code.';
      }

      // Check for duplicate email and phone
      if (await isEmailTaken(email)) {
        throw 'Email already in use';
      }
      if (await isPhoneTaken(formattedPhone)) {
        throw 'Phone number already in use';
      }

      await _auth.verifyPhoneNumber(
        phoneNumber: formattedPhone,
        timeout: Duration(seconds: 60),
        forceResendingToken: forceResendingToken,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification completed (rare on iOS)
          await _completePhoneSignup(credential, username, email, password);
        },
        verificationFailed: (FirebaseAuthException e) {
          Get.snackbar('Error', e.message ?? 'Verification failed');
        },
        codeSent: (String vId, int? resendToken) {
          verificationId.value = vId;
          forceResendingToken = resendToken;
          Get.toNamed('/verify-otp', arguments: {
            'username': username,
            'email': email,
            'password': password,
            'phone': formattedPhone,
          });
        },
        codeAutoRetrievalTimeout: (String vId) {
          verificationId.value = vId;
        },
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Complete Phone Signup
  Future<void> _completePhoneSignup(
    PhoneAuthCredential credential,
    String username,
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _auth.signInWithCredential(credential);

      // Create email/password account and link it
      final emailCredential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await userCredential.user?.linkWithCredential(emailCredential);

      // Save user data
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'username': username,
        'email': email,
        'phone': userCredential.user?.phoneNumber,
        'createdAt': FieldValue.serverTimestamp(),
      });

      Get.snackbar('Success', 'Account created successfully');
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar('Error', 'Failed to complete signup');
    }
  }

  // Verify OTP
  Future<void> verifyOTP(String otp, Map<String, String> userData) async {
    try {
      isLoading.value = true;

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: otp,
      );

      await _completePhoneSignup(
        credential,
        userData['username']!,
        userData['email']!,
        userData['password']!,
      );
    } catch (e) {
      Get.snackbar('Error', 'Invalid OTP');
    } finally {
      isLoading.value = false;
    }
  }

  // Login
  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.offAllNamed('/home');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'Login failed');
    } finally {
      isLoading.value = false;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar('Error', 'Failed to sign out');
    }
  }
}
