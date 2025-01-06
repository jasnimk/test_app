import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_ecommerce_app/app/controllers/cart_controller.dart';
import 'package:test_ecommerce_app/app/controllers/checkout_controller.dart';
import 'package:test_ecommerce_app/app/models/cart_model.dart';
import 'package:test_ecommerce_app/app/widgets/add_on_widgets.dart';
import 'package:test_ecommerce_app/app/widgets/custom_snackbar.dart';
import 'package:test_ecommerce_app/app/widgets/text_style.dart';

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
                  Text('Delivery Address',
                      style: AppTextStyles.montserratBold
                          .copyWith(fontSize: 16, color: Colors.black)),
                  TextButton(
                    onPressed: () async {
                      final result = await Get.toNamed('/select-address');
                      if (result == true) {
                        await controller.refreshAddresses();
                      }
                    },
                    child: Text('Change',
                        style: AppTextStyles.montserratLight
                            .copyWith(fontSize: 12, color: Colors.black)),
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
                    style: AppTextStyles.montserratRegular
                        .copyWith(fontSize: 14, color: Colors.black)),
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
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Method',
            style: AppTextStyles.montserratBold
                .copyWith(fontSize: 16, color: Colors.black),
          ),
          GetX<CheckoutController>(
            builder: (_) => Column(
              children: [
                RadioListTile(
                  title: Text('Cash on Delivery',
                      style: AppTextStyles.montserratBold
                          .copyWith(fontSize: 14, color: Colors.black)),
                  value: 'cod',
                  groupValue: controller.selectedPaymentMethod.value,
                  onChanged: (value) =>
                      controller.selectedPaymentMethod.value = value.toString(),
                ),
                RadioListTile(
                  title: Text('Pay Online',
                      style: AppTextStyles.montserratBold
                          .copyWith(fontSize: 14, color: Colors.black)),
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

  final double maxDiscount = 10000.0;

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

  double calculateFinalPrice(double originalPrice, double discountedPrice) {
    double discount = originalPrice - discountedPrice;
    if (discount > maxDiscount) {
      discount = maxDiscount;
    }
    return originalPrice - discount;
  }

  Widget _buildItemRow(CartItem item) {
    double originalTotal = item.totalPrice * item.quantity;
    double finalPrice = calculateFinalPrice(originalTotal, item.totalPrice);

    // Discount Calculation based on Price
    double discount = originalTotal - finalPrice;
    double discountPercent = (discount / originalTotal) * 100;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              item.product.imageUrls[0],
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey.shade200,
                  child: Icon(Icons.image_not_supported,
                      color: Colors.grey.shade400),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              spacing: 3,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.product.name, style: styling(fontSize: 14)),
                Text(
                  'Qty: ${item.quantity}',
                  style: styling(
                    color: Colors.grey.shade600,
                    fontSize: 11,
                  ),
                ),
                if (discountPercent > 0) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${discountPercent.toStringAsFixed(0)}% OFF',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (discountPercent > 0)
                Text(
                  '₹${originalTotal.toStringAsFixed(2)}',
                  style: styling(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
              Text('₹${finalPrice.toStringAsFixed(2)}', style: styling()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    double amount, {
    bool isTotal = false,
    bool isDiscount = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: styling(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            isDiscount
                ? '-₹${amount.abs().toStringAsFixed(2)}'
                : '₹${amount.toStringAsFixed(2)}',
            style: styling(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
              color: isDiscount ? Colors.green.shade700 : null,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: GetX<CheckoutController>(
        builder: (_) {
          final subtotal = calculateSubtotal();
          final total = subtotal + shippingCharge;
          final items = controller.isDirectCheckout.value
              ? [controller.directCheckoutItem.value!]
              : Get.find<CartController>().items;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order Summary',
                style: styling(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              // Product List
              ...items.map((item) => _buildItemRow(item)),
              const Divider(height: 24),
              // Price Summary
              _buildSummaryRow('Subtotal', subtotal),
              if (shippingCharge > 0) ...[
                _buildSummaryRow('Shipping', shippingCharge),
              ],
              const Divider(height: 24),
              _buildSummaryRow('Total', total, isTotal: true),
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
                    showCustomSnackbar(
                        title: '', message: 'Please select a delivery address');
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
