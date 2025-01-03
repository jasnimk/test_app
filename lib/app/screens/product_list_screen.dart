import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:test_ecommerce_app/app/data/product.dart';
import 'package:test_ecommerce_app/app/models/product_model.dart';
import 'package:test_ecommerce_app/app/screens/product_details_screen.dart';
import 'package:test_ecommerce_app/app/services/bindings.dart';
import 'package:test_ecommerce_app/app/widgets/custom_appbar.dart';
import 'package:test_ecommerce_app/app/widgets/text_style.dart';

class CustomProductGridView extends StatefulWidget {
  final List<Map<String, dynamic>> products;
  const CustomProductGridView({Key? key, required this.products})
      : super(key: key);

  @override
  _CustomProductGridViewState createState() => _CustomProductGridViewState();
}

class _CustomProductGridViewState extends State<CustomProductGridView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Product> _products;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _controller.forward();
    _products = widget.products.map((map) => Product.fromMap(map)).toList();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Jewels Online'),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.75,
        ),
        itemCount: widget.products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return GestureDetector(
            onTap: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (ctx) => ProductDetailsScreen(),
              //   ),
              // );

              Get.to(() => ProductDetailsScreen(),
                  binding: ProductDetailsBinding(),
                  arguments: {'productId': product.id});
            },
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final delay = (index / widget.products.length) * 0.4;
                final animationValue =
                    (_controller.value - delay).clamp(0.0, 1.0);
                return Transform.translate(
                  offset: Offset(0, 30 * (1.0 - animationValue)),
                  child: Opacity(
                    opacity: animationValue,
                    child: child,
                  ),
                );
              },
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
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: AppTextStyles.caption,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Text(
                              '₹${product.price.toStringAsFixed(2)}',
                              style: AppTextStyles.bodyText,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
