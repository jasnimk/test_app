import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_ecommerce_app/app/controllers/profile_controller.dart';
import 'package:test_ecommerce_app/app/screens/address_screen.dart';
import 'package:test_ecommerce_app/app/screens/order_screen.dart';
import 'package:test_ecommerce_app/app/widgets/text_style.dart';

class ProfileView extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              _buildProfileHeader(),
              _buildProfileTile(
                title: 'Order History',
                subtitle: '${controller.ordersCount} Orders',
                onTap: () => Get.to(() => OrdersScreen()),
              ),
              _buildProfileTile(
                title: 'Shipping Addresses',
                subtitle: '${controller.addressCount} addresses',
                onTap: () => Get.to(() => AddressListView()),
              ),
              _buildProfileTile(
                title: 'Wallet',
                subtitle:
                    'Balance: \₹${controller.walletBalance.toStringAsFixed(2)} NA',
                onTap: () {},
              ),
              _buildProfileTile(
                title: 'Settings',
                subtitle: 'NA',
                onTap: () {},
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProfileHeader() {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(1),
      ),
      shadowColor: const Color.fromARGB(210, 5, 57, 51),
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40.0,
              backgroundImage: controller.userData['imageUrl'] != null
                  ? NetworkImage(controller.userData['imageUrl'])
                  : const AssetImage('assets/Images/profile.png')
                      as ImageProvider,
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.getUserName(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.montserratBold.copyWith(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    controller.getUserEmail(),
                    style: AppTextStyles.montserratRegular.copyWith(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTile({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      shape: BeveledRectangleBorder(),
      child: ListTile(
        title: Text(
          title,
          style: AppTextStyles.montserratRegular.copyWith(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
