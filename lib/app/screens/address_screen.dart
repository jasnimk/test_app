import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_ecommerce_app/app/controllers/address_controller.dart';
import 'package:test_ecommerce_app/app/screens/add_address.dart';
import 'package:test_ecommerce_app/app/widgets/add_on_widgets.dart';
import 'package:test_ecommerce_app/app/widgets/text_style.dart';

class AddressListView extends StatelessWidget {
  final AddressController addressController = Get.find<AddressController>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AddressListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shipping Addresses', style: AppTextStyles.montserratBold),
        elevation: 0,
      ),
      body: Obx(() {
        if (addressController.isLoading.value) {
          return buildLoadingIndicator(context: context);
        }

        if (addressController.addresses.isEmpty) {
          return buildEmptyStateWidget(
              message: 'NO ADDRESSES FOUND!', subMessage: 'Add Now!');
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
                        Text(address['name'] ?? '', style: styling()),
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
                                          final String userId =
                                              _auth.currentUser!.uid;
                                          addressController.deleteAddress(
                                              userId, address['id']);
                                          Get.back();
                                        },
                                        child: Text(
                                          'Delete',
                                          style: styling(),
                                        ),
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
                      style: styling(),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Phone: ${address['phone']}',
                      style: styling(
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
