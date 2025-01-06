import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:test_ecommerce_app/app/controllers/offer_controller.dart';
import 'package:test_ecommerce_app/app/controllers/product_controller.dart';
import 'package:test_ecommerce_app/app/models/product_model.dart';
import 'package:test_ecommerce_app/app/screens/product_details_screen.dart';
import 'package:test_ecommerce_app/app/screens/products_by_category.dart';
import 'package:test_ecommerce_app/app/widgets/text_style.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductController productController = Get.put(ProductController());
  final OfferController offerController = Get.put(OfferController());
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();

    _initializeOffer();
  }

  Future<void> _initializeOffer() async {
    try {
      await Future.delayed(const Duration(milliseconds: 1000));
      await offerController.checkIfNewUser();

      if (offerController.isNewUser.value) {
        if (mounted) {
          await offerController.showOfferIfNewUser(context);
        }
      } else {}
    } catch (e) {
      if (kDebugMode) {
        print('DEBUG: Error in _initializeOffer: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF15384E), Colors.black],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        body: Obx(() {
          if (productController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeIn(
                  duration: const Duration(milliseconds: 800),
                  child: _buildFeaturedCarousel(),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SlideInLeft(
                    duration: const Duration(milliseconds: 800),
                    child: Text(
                      'Shop by Categories',
                      style: AppTextStyles.montserratRegular
                          .copyWith(fontSize: 20, color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildCategoriesGrid(),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildFeaturedCarousel() {
    final featuredProducts = productController.getFeaturedProducts();

    if (featuredProducts.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.32,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CarouselSlider.builder(
            itemCount: featuredProducts.length,
            itemBuilder: (context, index, realIndex) {
              final product = featuredProducts[index];
              return GestureDetector(
                onTap: () {
                  productController.fetchProductDetails(product.id!);
                  Get.to(
                    () => const ProductDetailsScreen(),
                    transition: Transition.fadeIn,
                  );
                },
                child: Hero(
                  tag: 'product_${product.id}',
                  child: FadeInImage(
                    placeholder: const AssetImage('assets/Images/logoraw.png'),
                    image: AssetImage(product.imageUrls.first),
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
              );
            },
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height * 0.4,
              viewportFraction: 1.0,
              autoPlay: true,
              enlargeCenterPage: false,
              enableInfiniteScroll: true,
              scrollPhysics: const BouncingScrollPhysics(),
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: featuredProducts.asMap().entries.map((entry) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _currentIndex == entry.key ? 20.0 : 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.white.withValues()),
                );
              }).toList(),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: BounceInDown(
              duration: const Duration(milliseconds: 1000),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 22, 121, 134),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Text(
                  'Featured',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesGrid() {
    final categories = productController.categories
        .where((category) => category != 'All Products')
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: AnimationLimiter(
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
            childAspectRatio: 2.0,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];

            final categoryProduct = productController.productsList.firstWhere(
              (product) => product.category == category,
              orElse: () => Product(
                id: '',
                name: 'Unknown Product',
                category: category,
                imageUrls: ['assets/images/default_image.png'],
                description: '',
                price: 0,
                rating: 4,
                stock: 0,
                material: '',
              ),
            );

            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 500),
              columnCount: 2,
              child: ScaleAnimation(
                child: FadeInAnimation(
                  child: GestureDetector(
                    onTap: () => Get.to(
                      () => CategoryProductsScreen(categoryName: category),
                      transition: Transition.fadeIn,
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Hero(
                          tag: 'category_$category',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: Image.asset(
                              categoryProduct.imageUrls.first,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.5),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 10,
                          child: Text(
                            category,
                            style: AppTextStyles.montserratRegular
                                .copyWith(fontSize: 14, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
