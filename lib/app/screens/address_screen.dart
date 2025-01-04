import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_ecommerce_app/app/controllers/address_controller.dart';
import 'package:test_ecommerce_app/app/screens/add_address.dart';

class AddressListView extends StatelessWidget {
  final AddressController addressController = Get.find<AddressController>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AddressListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shipping Addresses'),
        elevation: 0,
      ),
      body: Obx(() {
        if (addressController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (addressController.addresses.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_off_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No addresses found',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: addressController.addresses.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final address = addressController.addresses[index];
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              shadowColor: const Color.fromARGB(210, 15, 63, 51),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          address['name'] ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                            fontFamily: 'Poppins-SemiBold',
                          ),
                        ),
                        PopupMenuButton(
                          iconColor: Colors.black,
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              child: const Text('Edit'),
                              onTap: () {
                                Get.to(() => AddAddressView(
                                      addressData: address,
                                      isEditing: true,
                                    ));
                              },
                            ),
                            PopupMenuItem(
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                              onTap: () {
                                Get.dialog(
                                  AlertDialog(
                                    title: const Text('Delete Address'),
                                    content: const Text(
                                        'Are you sure you want to delete this address?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Get.back(),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          final String userId = _auth
                                              .currentUser!
                                              .uid; // Replace with actual user ID
                                          addressController.deleteAddress(
                                              userId, address['id']);
                                          Get.back();
                                        },
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Text(
                      '${address['houseName']}\n'
                      '${address['locality']}\n'
                      '${address['district']}, ${address['city']}\n'
                      '${address['state']} - ${address['pincode']}',
                      style: const TextStyle(height: 1.5),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Phone: ${address['phone']}',
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const AddAddressView()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
