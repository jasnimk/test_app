// // profile_controller.dart
// import 'package:get/get.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ProfileController extends GetxController {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   final Rx<User?> user = Rx<User?>(null);
//   final RxMap<String, dynamic> userData = RxMap<String, dynamic>();
//   final RxInt ordersCount = 0.obs;
//   final RxInt addressCount = 0.obs;
//   final RxDouble walletBalance = 0.0.obs;
//   final RxBool isLoading = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     user.value = _auth.currentUser;
//     loadUserData();
//     loadCounts();
//   }

//   Future<void> loadUserData() async {
//     if (user.value != null) {
//       try {
//         isLoading.value = true;
//         final doc =
//             await _firestore.collection('users').doc(user.value!.uid).get();
//         if (doc.exists) {
//           userData.value = doc.data() ?? {};
//         }
//       } catch (e) {
//         Get.snackbar('Error', 'Failed to load user data');
//       } finally {
//         isLoading.value = false;
//       }
//     }
//   }

//   Future<void> loadCounts() async {
//     if (user.value != null) {
//       try {
//         final ordersSnapshot = await _firestore
//             .collection('users')
//             .doc(user.value!.uid)
//             .collection('orders')
//             .get();
//         ordersCount.value = ordersSnapshot.docs.length;

//         final addressSnapshot = await _firestore
//             .collection('users')
//             .doc(user.value!.uid)
//             .collection('addresses')
//             .get();
//         addressCount.value = addressSnapshot.docs.length;

//         // Load wallet balance
//         final walletDoc = await _firestore
//             .collection('users')
//             .doc(user.value!.uid)
//             .collection('wallet')
//             .doc('balance')
//             .get();
//         if (walletDoc.exists) {
//           walletBalance.value =
//               (walletDoc.data()?['balance'] ?? 0.0).toDouble();
//         }
//       } catch (e) {
//         Get.snackbar('Error', 'Failed to load user statistics');
//       }
//     }
//   }
// }
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final Rx<User?> user = Rx<User?>(null);
  // Changed from RxMap<String, dynamic> to just RxMap to match Firestore data
  final RxMap userData = RxMap();
  final RxInt ordersCount = 0.obs;
  final RxInt addressCount = 0.obs;
  final RxDouble walletBalance = 0.0.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    user.value = _auth.currentUser;
    loadUserData();
    loadCounts();
  }

  Future<void> loadUserData() async {
    if (user.value != null) {
      try {
        isLoading.value = true;
        final doc =
            await _firestore.collection('users').doc(user.value!.uid).get();
        if (doc.exists) {
          userData.value = doc.data() ?? {};
        }
      } catch (e) {
        print('Error loading user data: $e');
        Get.snackbar('Error', 'Failed to load user data');
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> loadCounts() async {
    if (user.value != null) {
      try {
        // Query orders from separate collection where userId matches
        final ordersSnapshot = await _firestore
            .collection('orders')
            .where('userId', isEqualTo: user.value!.uid)
            .get();
        ordersCount.value = ordersSnapshot.docs.length;

        final addressSnapshot = await _firestore
            .collection('users')
            .doc(user.value!.uid)
            .collection('addresses')
            .get();
        addressCount.value = addressSnapshot.docs.length;

        // Load wallet balance
        final walletDoc = await _firestore
            .collection('users')
            .doc(user.value!.uid)
            .collection('wallet')
            .doc('balance')
            .get();
        if (walletDoc.exists) {
          walletBalance.value =
              (walletDoc.data()?['balance'] ?? 0.0).toDouble();
        }
      } catch (e) {
        print('Error loading counts: $e');
        Get.snackbar('Error', 'Failed to load user statistics');
      }
    }
  }

  // Helper method to safely access user data
  dynamic getUserData(String key) {
    return userData[key];
  }

  // Method to refresh data
  Future<void> refreshData() async {
    await loadUserData();
    await loadCounts();
  }
}
