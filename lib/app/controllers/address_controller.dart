import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_ecommerce_app/app/widgets/custom_snackbar.dart';

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
        showCustomSnackbar(
            title: '', message: 'Please log in to view your addresses.');
      }
    } catch (e) {
      error.value = e.toString();
      showCustomSnackbar(title: '', message: 'An unexpected error occurred.');
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
      showCustomSnackbar(title: '', message: 'Address saved successfully');
    } catch (e) {
      error.value = e.toString();
      showCustomSnackbar(title: '', message: 'Failed to save address');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadAddresses(String userId) async {
    try {
      isLoading.value = true;
      error.value = '';

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
      showCustomSnackbar(title: '', message: 'Failed to load addresses');
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
      showCustomSnackbar(title: '', message: 'Address updated successfully');
    } catch (e) {
      error.value = e.toString();
      showCustomSnackbar(title: '', message: 'Failed to update address!');
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
      showCustomSnackbar(title: '', message: 'Address deleted successfully');
    } catch (e) {
      error.value = e.toString();
      showCustomSnackbar(title: '', message: 'Failed to delete address');
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
