import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:test_ecommerce_app/app/controllers/auth_controller.dart';
import 'package:test_ecommerce_app/app/screens/login_Screen.dart';
import 'package:test_ecommerce_app/app/screens/product_list_screen.dart';
import 'package:test_ecommerce_app/app/widgets/confirmation_Widget.dart';
import 'package:test_ecommerce_app/app/widgets/custom_appbar.dart';

class BaseScreen extends StatelessWidget {
  final RxInt currentIndex = 0.obs;
  final AuthController authController = Get.find<AuthController>();

  // List of screen titles corresponding to bottom nav items
  final List<String> titles = [
    'Jewels Online',
    'Shopping',
    'Cart',
    'Profile',
  ];

  final List<Widget> screens = [
    const Scaffold(body: Center(child: Text('Shopping'))),
    const ProductGridView(showAppBar: false),
    const Scaffold(body: Center(child: Text('Cart'))),
    const Scaffold(body: Center(child: Text('Profile'))),
  ];

  BaseScreen({Key? key}) : super(key: key);

  void _handleLogout(BuildContext context) async {
    final bool? confirm = await ConfirmationDialog.show(
      context: context,
      title: 'Logout',
      content: 'Are you sure you want to logout?',
      confirmText: 'Logout',
      onConfirm: () async {
        await authController.signOut();
        Future.delayed(const Duration(milliseconds: 100), () {
          Get.offAll(
            () => LoginScreen(),
            transition: Transition.fadeIn,
            duration: const Duration(milliseconds: 300),
          );
        });
      },
    );

    if (confirm == null || !confirm) {
      return;
    }
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: titles[currentIndex.value],
      actions: [
        IconButton(
          icon: const FaIcon(
            FontAwesomeIcons.rightFromBracket,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => _handleLogout(context),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: _buildAppBar(context),
          body: screens[currentIndex.value],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex.value,
            onTap: (index) => currentIndex.value = index,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.house),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.bagShopping),
                label: 'Shop',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.cartShopping),
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.user),
                label: 'Profile',
              ),
            ],
          ),
        ));
  }
}
