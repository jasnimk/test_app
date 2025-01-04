import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_ecommerce_app/app/controllers/address_controller.dart';
import 'package:test_ecommerce_app/app/controllers/checkout_controller.dart';

class AddressSelectionPage extends StatelessWidget {
  final AddressController addressController = Get.put(AddressController());
  final CheckoutController checkoutController = Get.find<CheckoutController>();

  AddressSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Address'),
      ),
      body: Obx(() {
        if (addressController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (addressController.error.isNotEmpty) {
          return Center(
            child: Text('Error: ${addressController.error.value}'),
          );
        }

        if (addressController.addresses.isEmpty) {
          return const Center(
            child: Text('No addresses added yet!'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: addressController.addresses.length,
          itemBuilder: (context, index) {
            final address = addressController.addresses[index];
            final name = address['name'] ?? 'Unknown';
            final houseName = address['houseName'] ?? '';
            final locality = address['locality'] ?? '';
            final district = address['district'] ?? '';
            final city = address['city'] ?? '';
            final stateName = address['state'] ?? '';
            final pincode = address['pincode'] ?? '';

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: RadioListTile<String>(
                title: Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  '$houseName\n$locality\n$district, $city\n$stateName - $pincode',
                  style: const TextStyle(height: 1.5),
                ),
                value: address['id'] as String,
                groupValue: checkoutController.selectedAddressId.value,
                onChanged: (value) {
                  if (value != null) {
                    checkoutController.selectedAddressId.value = value;
                    Get.back();
                  }
                },
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/add-address'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
