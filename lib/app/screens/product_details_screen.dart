import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:test_ecommerce_app/app/controllers/product_controller.dart';
import 'package:test_ecommerce_app/app/controllers/cart_controller.dart';
import 'package:test_ecommerce_app/app/widgets/custom_appbar.dart';
import 'package:test_ecommerce_app/app/widgets/custom_button.dart';
import 'package:test_ecommerce_app/app/widgets/text_style.dart';

class ProductDetailsScreen extends GetView<ProductController> {
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Product Details'),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final product = controller.selectedProduct.value;
        if (product == null) {
          return const Center(child: Text('Product not found'));
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 300,
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: controller.pageController,
                      onPageChanged: controller.onPageChanged,
                      itemCount: product.imageUrls.length,
                      itemBuilder: (context, index) => Image.asset(
                        product.imageUrls[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          product.imageUrls.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 8,
                            width:
                                controller.currentPage.value == index ? 24 : 8,
                            decoration: BoxDecoration(
                              color: controller.currentPage.value == index
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style:
                                AppTextStyles.headline.copyWith(fontSize: 26),
                          ),
                        ),
                        Text(
                          '₹${product.price.toStringAsFixed(2)}',
                          style: AppTextStyles.headline.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${product.rating}',
                          style: AppTextStyles.bodyText,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Stock: ${product.stock}',
                          style: AppTextStyles.bodyText,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Material',
                      style: AppTextStyles.caption,
                    ),
                    Text(
                      product.material,
                      style: AppTextStyles.bodyText,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Description',
                      style: AppTextStyles.caption,
                    ),
                    Text(
                      product.description,
                      style: AppTextStyles.bodyText,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomButton(
                        text:
                            product.stock > 0 ? 'Add to Cart' : 'Out of Stock',
                        onPressed: product.stock > 0 ? () {} : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomButton(
                        text: product.stock > 0 ? 'Buy Now' : 'Out of Stock',
                        onPressed: product.stock > 0 ? () {} : null,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
