import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_ecommerce_app/app/widgets/custom_snackbar.dart';

class ProfileController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final Rx<User?> user = Rx<User?>(null);
  final RxMap<String, dynamic> userData = RxMap<String, dynamic>();
  final RxInt ordersCount = 0.obs;
  final RxInt addressCount = 0.obs;
  final RxDouble walletBalance = 0.0.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    user.value = _auth.currentUser;
    initializeUserData();
  }

  Future<void> initializeUserData() async {
    if (user.value != null) {
      try {
        isLoading.value = true;

        final userDoc =
            await _firestore.collection('users').doc(user.value!.uid).get();

        if (!userDoc.exists) {
          await _firestore.collection('users').doc(user.value!.uid).set({
            'email': user.value!.email ?? '',
            'name': user.value!.displayName ?? 'User',
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }

        await fetchData();
      } catch (e) {
        showCustomSnackbar(
          title: '',
          message: 'Failed to initialize user data',
          snackPosition: SnackPosition.BOTTOM,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> fetchData() async {
    if (user.value != null) {
      try {
        isLoading.value = true;

        final userDocFuture =
            _firestore.collection('users').doc(user.value!.uid).get();
        final ordersFuture = _firestore
            .collection('orders')
            .where('userId', isEqualTo: user.value!.uid)
            .get();
        final addressFuture = _firestore
            .collection('users')
            .doc(user.value!.uid)
            .collection('addresses')
            .get();

        final results = await Future.wait([
          userDocFuture,
          ordersFuture,
          addressFuture,
        ]);

        final userDoc = results[0] as DocumentSnapshot;
        final ordersSnapshot = results[1] as QuerySnapshot;
        final addressSnapshot = results[2] as QuerySnapshot;

        if (userDoc.exists) {
          userData.value = userDoc.data() as Map<String, dynamic>;
        } else {}

        ordersCount.value = ordersSnapshot.docs.length;
        addressCount.value = addressSnapshot.docs.length;
      } catch (e) {
        showCustomSnackbar(
          title: '',
          message: 'Failed to fetch profile data',
          snackPosition: SnackPosition.BOTTOM,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  String getUserName() {
    final name = userData['username'];

    return name ?? 'User';
  }

  String getUserEmail() {
    final email = userData['email'];
    return email ?? user.value?.email ?? 'No email';
  }

  Future<void> updateUserProfile({String? name, String? email}) async {
    try {
      isLoading.value = true;

      final updateData = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (name != null) updateData['name'] = name;
      if (email != null) updateData['email'] = email;

      await _firestore
          .collection('users')
          .doc(user.value!.uid)
          .update(updateData);

      await fetchData();

      showCustomSnackbar(
        title: '',
        message: 'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      showCustomSnackbar(
        title: '',
        message: 'Failed to update profile',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    await fetchData();
  }
}
