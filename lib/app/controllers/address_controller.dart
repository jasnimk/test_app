// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class AddressController extends GetxController {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final RxBool isLoading = false.obs;
//   final RxString error = ''.obs;
//   final RxList<Map<String, dynamic>> addresses = <Map<String, dynamic>>[].obs;
//   @override
//   void onInit() {
//     @override
//     void onInit() {
//       super.onInit();
//       try {
//         User? currentUser = _auth.currentUser;
//         if (currentUser != null) {
//           loadAddresses(currentUser.uid);
//         } else {
//           error.value = 'No user logged in.';
//           Get.snackbar(
//             'Error',
//             'Please log in to view your addresses.',
//             backgroundColor: Get.theme.dialogBackgroundColor,
//             colorText: Get.theme.colorScheme.onError,
//           );
//         }
//       } catch (e) {
//         error.value = e.toString();
//         Get.snackbar(
//           'Error',
//           'An unexpected error occurred.',
//           backgroundColor: Get.theme.dialogBackgroundColor,
//           colorText: Get.theme.colorScheme.onError,
//         );
//       }
//     }
//   }

//   Future<void> addAddress(
//       String userId, Map<String, dynamic> addressData) async {
//     try {
//       isLoading.value = true;
//       final data = {
//         ...addressData,
//         'createdAt': FieldValue.serverTimestamp(),
//       };
//       await _firestore
//           .collection('users')
//           .doc(userId)
//           .collection('addresses')
//           .add(data);
//       await loadAddresses(userId);
//       Get.back();
//       Get.snackbar(
//         'Success',
//         'Address saved successfully',
//         backgroundColor: Get.theme.primaryColor,
//         colorText: Get.theme.colorScheme.onPrimary,
//       );
//     } catch (e) {
//       error.value = e.toString();
//       Get.snackbar(
//         'Error',
//         'Failed to save address',
//         backgroundColor: Get.theme.dialogBackgroundColor,
//         colorText: Get.theme.colorScheme.onError,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> loadAddresses(String userId) async {
//     try {
//       isLoading.value = true;
//       final snapshot = await _firestore
//           .collection('users')
//           .doc(userId)
//           .collection('addresses')
//           .orderBy('createdAt', descending: true)
//           .get();

//       addresses.value = snapshot.docs.map((doc) {
//         final data = doc.data();
//         return {
//           'id': doc.id,
//           ...data,
//         };
//       }).toList();
//     } catch (e) {
//       error.value = e.toString();
//       Get.snackbar(
//         'Error',
//         'Failed to load addresses',
//         backgroundColor: Get.theme.dialogBackgroundColor,
//         colorText: Get.theme.colorScheme.onError,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> updateAddress(
//       String userId, String addressId, Map<String, dynamic> addressData) async {
//     try {
//       isLoading.value = true;
//       final data = {
//         ...addressData,
//         'updatedAt': FieldValue.serverTimestamp(),
//       };
//       await _firestore
//           .collection('users')
//           .doc(userId)
//           .collection('addresses')
//           .doc(addressId)
//           .update(data);
//       await loadAddresses(userId);
//       Get.back();
//       Get.snackbar(
//         'Success',
//         'Address updated successfully',
//         backgroundColor: Get.theme.primaryColor,
//         colorText: Get.theme.colorScheme.onPrimary,
//       );
//     } catch (e) {
//       error.value = e.toString();
//       Get.snackbar(
//         'Error',
//         'Failed to update address',
//         backgroundColor: Get.theme.canvasColor,
//         colorText: Get.theme.colorScheme.onError,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> deleteAddress(String userId, String addressId) async {
//     try {
//       isLoading.value = true;
//       await _firestore
//           .collection('users')
//           .doc(userId)
//           .collection('addresses')
//           .doc(addressId)
//           .delete();
//       await loadAddresses(userId);
//       Get.snackbar(
//         'Success',
//         'Address deleted successfully',
//         backgroundColor: Get.theme.primaryColor,
//         colorText: Get.theme.colorScheme.onPrimary,
//       );
//     } catch (e) {
//       error.value = e.toString();
//       Get.snackbar(
//         'Error',
//         'Failed to delete address',
//         backgroundColor: Get.theme.cardColor,
//         colorText: Get.theme.colorScheme.onError,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddressController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxList<Map<String, dynamic>> addresses = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    initializeAddresses();
  }

  Future<void> initializeAddresses() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        await loadAddresses(currentUser.uid);
      } else {
        error.value = 'No user logged in.';
        Get.snackbar(
          'Error',
          'Please log in to view your addresses.',
          backgroundColor: Get.theme.dialogBackgroundColor,
          colorText: Get.theme.colorScheme.onError,
        );
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'An unexpected error occurred.',
        backgroundColor: Get.theme.dialogBackgroundColor,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }

  Future<void> addAddress(
      String userId, Map<String, dynamic> addressData) async {
    try {
      isLoading.value = true;
      final data = {
        ...addressData,
        'createdAt': FieldValue.serverTimestamp(),
      };
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('addresses')
          .add(data);
      await loadAddresses(userId);
      Get.back();
      Get.snackbar(
        'Success',
        'Address saved successfully',
        backgroundColor: Get.theme.primaryColor,
        colorText: Get.theme.colorScheme.onPrimary,
      );
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to save address',
        backgroundColor: Get.theme.dialogBackgroundColor,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadAddresses(String userId) async {
    try {
      isLoading.value = true;
      error.value = ''; // Clear any previous errors

      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('addresses')
          .orderBy('createdAt', descending: true)
          .get();

      if (snapshot.docs.isEmpty) {
        addresses.clear();
        return;
      }

      addresses.value = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          ...data,
        };
      }).toList();
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to load addresses',
        backgroundColor: Get.theme.dialogBackgroundColor,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateAddress(
      String userId, String addressId, Map<String, dynamic> addressData) async {
    try {
      isLoading.value = true;
      final data = {
        ...addressData,
        'updatedAt': FieldValue.serverTimestamp(),
      };
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('addresses')
          .doc(addressId)
          .update(data);
      await loadAddresses(userId);
      Get.back();
      Get.snackbar(
        'Success',
        'Address updated successfully',
        backgroundColor: Get.theme.primaryColor,
        colorText: Get.theme.colorScheme.onPrimary,
      );
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to update address',
        backgroundColor: Get.theme.canvasColor,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteAddress(String userId, String addressId) async {
    try {
      isLoading.value = true;
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('addresses')
          .doc(addressId)
          .delete();
      await loadAddresses(userId);
      Get.snackbar(
        'Success',
        'Address deleted successfully',
        backgroundColor: Get.theme.primaryColor,
        colorText: Get.theme.colorScheme.onPrimary,
      );
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to delete address',
        backgroundColor: Get.theme.cardColor,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Helper method to refresh addresses
  Future<void> refreshAddresses() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      await loadAddresses(currentUser.uid);
    }
  }
}
