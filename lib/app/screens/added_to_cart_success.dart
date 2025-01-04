import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:test_ecommerce_app/app/screens/cart_screen.dart';
import 'package:test_ecommerce_app/app/screens/product_list_screen.dart';
import 'package:test_ecommerce_app/app/widgets/custom_button.dart';

class CartSucces extends StatelessWidget {
  const CartSucces({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: 250,
              child: Lottie.asset(
                  'assets/animations/Animation - 1735834409097.json')),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Go to Cart',
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacement(MaterialPageRoute(builder: (ctx) {
                        return CartScreen();
                      }));
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomButton(
                    text: 'Continue Shopping',
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacement(MaterialPageRoute(builder: (ctx) {
                        return ProductGridView();
                      }));
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
