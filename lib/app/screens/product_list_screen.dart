import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:test_ecommerce_app/app/controllers/product_controller.dart';
import 'package:test_ecommerce_app/app/screens/product_details_screen.dart';
import 'package:test_ecommerce_app/app/widgets/chip_widget.dart';
import 'package:test_ecommerce_app/app/widgets/custom_appbar.dart';
import 'package:test_ecommerce_app/app/widgets/text_style.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ProductGridView extends GetView<ProductController> {
  final bool showAppBar;

  const ProductGridView({
    Key? key,
    this.showAppBar = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar ? const CustomAppBar(title: 'Jewels Online') : null,
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: Obx(() {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.categories.length,
                itemBuilder: (context, index) {
                  final category = controller.categories[index];
                  return Obx(() {
                    final isSelected = category == 'All Products'
                        ? controller.selectedCategory.value.isEmpty
                        : controller.selectedCategory.value == category;

                    return ChipWidget(
                      category: category,
                      isSelected: isSelected,
                      onTap: () {
                        controller.selectedCategory.value =
                            category == 'All Products' ? '' : category;
                        controller.fetchProducts();
                      },
                    );
                  });
                },
              );
            }),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return AnimationLimiter(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: controller.productsList.length,
                  itemBuilder: (context, index) {
                    final product = controller.productsList[index];
                    return AnimationConfiguration.staggeredGrid(
                      position: index,
                      duration: const Duration(milliseconds: 800),
                      columnCount: 2,
                      child: ScaleAnimation(
                        child: FadeInAnimation(
                          child: GestureDetector(
                            onTap: () {
                              controller.fetchProductDetails(product.id!);
                              Get.to(() => const ProductDetailsScreen());
                            },
                            child: SizedBox(
                              child: Card(
                                elevation: 4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Image.asset(
                                        product.imageUrls[0],
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    product.name,
                                                    style: AppTextStyles.caption
                                                        .copyWith(fontSize: 13),
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    '₹${product.price.toStringAsFixed(2)}',
                                                    style: AppTextStyles
                                                        .bodyText
                                                        .copyWith(fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            IconButton(
                                                onPressed: () {},
                                                icon: FaIcon(
                                                    FontAwesomeIcons
                                                        .cartShopping,
                                                    size:
                                                        18, // Increase size for better visibility
                                                    color: Color.fromARGB(
                                                        255, 3, 37, 32)))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
