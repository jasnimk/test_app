// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:test_ecommerce_app/app/controllers/cart_controller.dart';
// import 'package:test_ecommerce_app/app/controllers/checkout_controller.dart';

// class CheckoutScreen extends StatelessWidget {
//   final CheckoutController controller = Get.put(CheckoutController());
//   final double shippingCharge = 60.0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Checkout')),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return Center(child: CircularProgressIndicator());
//         }

//         return SingleChildScrollView(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildAddressSection(),
//               SizedBox(height: 24),
//               _buildPaymentMethodSection(),
//               SizedBox(height: 24),
//               _buildOrderSummary(),
//             ],
//           ),
//         );
//       }),
//       bottomNavigationBar: _buildBottomBar(),
//     );
//   }

//   Widget _buildAddressSection() {
//     return Container(
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade300),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Obx(() {
//         final selectedAddress = controller.addresses.firstWhere(
//           (addr) => addr['id'] == controller.selectedAddressId.value,
//           orElse: () => {},
//         );

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Delivery Address',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 TextButton(
//                   onPressed: () => Get.toNamed('/select-address'),
//                   child: Text('Change'),
//                 ),
//               ],
//             ),
//             if (selectedAddress.isNotEmpty) ...[
//               Text(selectedAddress['name'] ?? ''),
//               Text(
//                 '${selectedAddress['houseName']}, ${selectedAddress['locality']}\n'
//                 '${selectedAddress['district']}, ${selectedAddress['city']}\n'
//                 '${selectedAddress['state']} - ${selectedAddress['pincode']}\n'
//                 'Phone: ${selectedAddress['phone']}',
//               ),
//             ],
//           ],
//         );
//       }),
//     );
//   }

//   Widget _buildPaymentMethodSection() {
//     return Container(
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade300),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Payment Method',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           Obx(() => Column(
//             children: [
//               RadioListTile(
//                 title: Text('Cash on Delivery'),
//                 value: 'cod',
//                 groupValue: controller.selectedPaymentMethod.value,
//                 onChanged: (value) =>
//                     controller.selectedPaymentMethod.value = value.toString(),
//               ),
//               RadioListTile(
//                 title: Text('Pay Online'),
//                 value: 'stripe',
//                 groupValue: controller.selectedPaymentMethod.value,
//                 onChanged: (value) =>
//                     controller.selectedPaymentMethod.value = value.toString(),
//               ),
//             ],
//           )),
//         ],
//       ),
//     );
//   }

//   Widget _buildOrderSummary() {
//     return Container(
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade300),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Order Summary',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text('Subtotal'),
//               Text('₹${calculateSubtotal().toStringAsFixed(2)}'),
//             ],
//           ),
//           SizedBox(height: 8),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text('Shipping'),
//               Text('₹${shippingCharge.toStringAsFixed(2)}'),
//             ],
//           ),
//           Divider(height: 24),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Total',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 '₹${(calculateSubtotal() + shippingCharge).toStringAsFixed(2)}',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBottomBar() {
//     return Container(
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.shade200,
//             blurRadius: 10,
//             offset: Offset(0, -5),
//           ),
//         ],
//       ),
//       child: ElevatedButton(
//         onPressed: (){},// => controller.processOrder(
//         //   Get.find<CartController>().items,
//         //   calculateSubtotal() + shippingCharge,
//         // ),
//         child: Text('Place Order'),
//         style: ElevatedButton.styleFrom(
//           minimumSize: Size(double.infinity, 50),
//         ),
//       ),
//     );
//   }

//   double calculateSubtotal() {
//     // Replace this with your actual cart total calculation
//     return Get.find<CartController>().items.fold(
//       0,
//       (total, item) => total + item.totalPrice,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_ecommerce_app/app/controllers/cart_controller.dart';
import 'package:test_ecommerce_app/app/controllers/checkout_controller.dart';

class CheckoutScreen extends StatelessWidget {
  final CheckoutController controller = Get.put(CheckoutController());
  final double shippingCharge = 60.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Checkout')),
      body: GetX<CheckoutController>(
        builder: (controller) {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AddressSection(controller: controller),
                SizedBox(height: 24),
                PaymentMethodSection(controller: controller),
                SizedBox(height: 24),
                OrderSummarySection(
                  controller: controller,
                  shippingCharge: shippingCharge,
                ),
                SizedBox(height: 10),
                OrderButton(
                  controller: controller,
                  shippingCharge: shippingCharge,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class AddressSection extends StatelessWidget {
  final CheckoutController controller;

  const AddressSection({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: GetX<CheckoutController>(
        builder: (_) {
          final selectedAddress = controller.addresses.firstWhere(
            (addr) => addr['id'] == controller.selectedAddressId.value,
            orElse: () => {},
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Delivery Address',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Get.toNamed('/select-address'),
                    child: Text('Change'),
                  ),
                ],
              ),
              if (selectedAddress.isNotEmpty) ...[
                Text(selectedAddress['name'] ?? ''),
                Text(
                  '${selectedAddress['houseName']}, ${selectedAddress['locality']}\n'
                  '${selectedAddress['district']}, ${selectedAddress['city']}\n'
                  '${selectedAddress['state']} - ${selectedAddress['pincode']}\n'
                  'Phone: ${selectedAddress['phone']}',
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class PaymentMethodSection extends StatelessWidget {
  final CheckoutController controller;

  const PaymentMethodSection({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Method',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          GetX<CheckoutController>(
            builder: (_) => Column(
              children: [
                RadioListTile(
                  title: Text('Cash on Delivery'),
                  value: 'cod',
                  groupValue: controller.selectedPaymentMethod.value,
                  onChanged: (value) =>
                      controller.selectedPaymentMethod.value = value.toString(),
                ),
                RadioListTile(
                  title: Text('Pay Online'),
                  value: 'stripe',
                  groupValue: controller.selectedPaymentMethod.value,
                  onChanged: (value) =>
                      controller.selectedPaymentMethod.value = value.toString(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OrderSummarySection extends StatelessWidget {
  final CheckoutController controller;
  final double shippingCharge;

  const OrderSummarySection({
    Key? key,
    required this.controller,
    required this.shippingCharge,
  }) : super(key: key);

  double calculateSubtotal() {
    if (controller.isDirectCheckout.value &&
        controller.directCheckoutItem.value != null) {
      return controller.directCheckoutItem.value!.totalPrice;
    } else {
      return Get.find<CartController>()
          .items
          .fold(0, (total, item) => total + item.totalPrice);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: GetX<CheckoutController>(
        builder: (_) {
          final subtotal = calculateSubtotal();
          final total = subtotal + shippingCharge;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order Summary',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Subtotal'),
                  Text('₹${subtotal.toStringAsFixed(2)}'),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Shipping'),
                  Text('₹${shippingCharge.toStringAsFixed(2)}'),
                ],
              ),
              Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '₹${total.toStringAsFixed(2)}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class OrderButton extends StatelessWidget {
  final CheckoutController controller;
  final double shippingCharge;

  const OrderButton({
    Key? key,
    required this.controller,
    required this.shippingCharge,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<CheckoutController>(
      builder: (_) {
        final isProcessing = controller.orderProcessing.value;
        final hasAddress = controller.selectedAddressId.isNotEmpty;

        return ElevatedButton(
          onPressed: isProcessing || !hasAddress
              ? null
              : () async {
                  if (!hasAddress) {
                    Get.snackbar(
                      'Error',
                      'Please select a delivery address',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red.shade100,
                    );
                    return;
                  }
                  await controller.processOrder();
                },
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50),
            backgroundColor: hasAddress ? null : Colors.grey,
          ),
          child: isProcessing
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text('Processing...'),
                  ],
                )
              : Text('Place Order'),
        );
      },
    );
  }
}
