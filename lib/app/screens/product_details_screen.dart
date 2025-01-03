// import 'package:flutter/material.dart';
// import 'package:test_ecommerce_app/app/data/product.dart';
// import 'package:test_ecommerce_app/app/models/product_model.dart';
// import 'package:test_ecommerce_app/app/widgets/custom_appbar.dart';
// import 'package:test_ecommerce_app/app/widgets/text_style.dart';

// class ProductDetailsScreen extends StatefulWidget {
//   final String productId;

//   const ProductDetailsScreen({super.key, required this.productId});

//   @override
//   State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
// }

// class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
//   late final PageController _pageController;
//   int _currentPage = 0;
//   late final Product product;
//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController();

//     try {
//       Map<String, dynamic> productMap = Map<String, dynamic>.from(
//         products.firstWhere(
//           (p) => p['id'] == widget.productId,
//           orElse: () => <String, dynamic>{},
//         ),
//       );

//       product = productMap.isNotEmpty
//           ? Product.fromMap(productMap)
//           : Product(
//               id: '',
//               name: 'Product Not Found',
//               description: 'No description available',
//               price: 0.0,
//               imageUrls: [],
//               category: '',
//               rating: 0.0,
//               stock: 0,
//               material: '',
//             );
//     } catch (e) {
//       print('Error initializing product: $e');
//       product = Product(
//         id: '',
//         name: 'Error Loading Product',
//         description: 'There was an error loading the product details',
//         price: 0.0,
//         imageUrls: [],
//         category: '',
//         rating: 0.0,
//         stock: 0,
//         material: '',
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(title: product.name),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(
//               height: 300,
//               child: Stack(
//                 children: [
//                   PageView.builder(
//                     controller: _pageController,
//                     onPageChanged: (index) {
//                       setState(() => _currentPage = index);
//                     },
//                     itemCount: product.imageUrls.length,
//                     itemBuilder: (context, index) {
//                       return Image.asset(
//                         product.imageUrls[index],
//                         fit: BoxFit.cover,
//                       );
//                     },
//                   ),
//                   Positioned(
//                     bottom: 16,
//                     left: 0,
//                     right: 0,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: List.generate(
//                         product.imageUrls.length,
//                         (index) => AnimatedContainer(
//                           duration: const Duration(milliseconds: 300),
//                           margin: const EdgeInsets.symmetric(horizontal: 4),
//                           height: 8,
//                           width: _currentPage == index ? 24 : 8,
//                           decoration: BoxDecoration(
//                             color: _currentPage == index
//                                 ? Theme.of(context).primaryColor
//                                 : Colors.grey,
//                             borderRadius: BorderRadius.circular(4),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//       Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Text(
//                     product.name,
//                     style: AppTextStyles.headline,
//                   ),
//                 ),
//                 Text(
//                   '₹${product.price.toStringAsFixed(2)}',
//                   style: AppTextStyles.headline.copyWith(
//                     color: Theme.of(context).primaryColor,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 Icon(
//                   Icons.star,
//                   color: Colors.amber,
//                   size: 20,
//                 ),
//                 const SizedBox(width: 4),
//                 Text(
//                   '${product.rating}',
//                   style: AppTextStyles.bodyText,
//                 ),
//                 const SizedBox(width: 16),
//                 Text(
//                   'Stock: ${product.stock}',
//                   style: AppTextStyles.bodyText,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'Material',
//               style: AppTextStyles.caption,
//             ),
//             Text(
//               product.material,
//               style: AppTextStyles.bodyText,
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'Description',
//               style: AppTextStyles.caption,
//             ),
//             Text(
//               product.description,
//               style: AppTextStyles.bodyText,
//             ),
//           ],
//         ),
//       ),
//     ],
//   ),
// ),
//       bottomNavigationBar: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Row(
//             spacing: 10,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: ElevatedButton(
//                   onPressed: product.stock > 0
//                       ? () {
//                           // Add to cart functionality
//                         }
//                       : null,
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                   ),
//                   child: Text(
//                     product.stock > 0 ? 'Add to Cart' : 'Out of Stock',
//                     style: AppTextStyles.montserratBold,
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: ElevatedButton(
//                   onPressed: product.stock > 0
//                       ? () {
//                           // Add to cart functionality
//                         }
//                       : null,
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                   ),
//                   child: Text(
//                     product.stock > 0 ? 'Buy Now' : 'Out of Stock',
//                     style: AppTextStyles.montserratBold,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:test_ecommerce_app/app/controllers/product_details_coontroller.dart';
import 'package:test_ecommerce_app/app/widgets/custom_appbar.dart';
import 'package:test_ecommerce_app/app/widgets/custom_button.dart';
import 'package:test_ecommerce_app/app/widgets/text_style.dart';

class ProductDetailsScreen extends GetView<ProductDetailsController> {
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: controller.product.name),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 300,
              child: Stack(
                children: [
                  PageView.builder(
                    controller: controller.pageController,
                    onPageChanged: (index) =>
                        controller.currentPage.value = index,
                    itemCount: controller.product.imageUrls.length,
                    itemBuilder: (context, index) => Image.asset(
                      controller.product.imageUrls[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            controller.product.imageUrls.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              height: 8,
                              width: controller.currentPage.value == index
                                  ? 24
                                  : 8,
                              decoration: BoxDecoration(
                                color: controller.currentPage.value == index
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        )),
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
                          controller.product.name,
                          style: AppTextStyles.headline,
                        ),
                      ),
                      Text(
                        '₹${controller.product.price.toStringAsFixed(2)}',
                        style: AppTextStyles.headline.copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${controller.product.rating}',
                        style: AppTextStyles.bodyText,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Stock: ${controller.product.stock}',
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
                    controller.product.material,
                    style: AppTextStyles.bodyText,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Description',
                    style: AppTextStyles.caption,
                  ),
                  Text(
                    controller.product.description,
                    style: AppTextStyles.bodyText,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Rest of your UI remains the same, just use controller.product instead of product

      // Bottom navigation bar remains the same, use controller.product

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: CustomButton(
                text: controller.product.stock > 0
                    ? 'Add to Cart'
                    : 'Out of Stock',
                onPressed: controller.product.stock > 0 ? () {} : null,
              )),
              Expanded(
                  child: CustomButton(
                text: controller.product.stock > 0 ? 'Buy Now' : 'Out of Stock',
                onPressed: controller.product.stock > 0 ? () {} : null,
              )),
            ],
          ),
        ),
      ),
    );
  }
}
