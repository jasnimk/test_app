import 'package:flutter/material.dart';
import 'package:test_ecommerce_app/app/models/product_model.dart';

class WelcomeOfferDialog extends StatelessWidget {
  final Product product;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const WelcomeOfferDialog({
    Key? key,
    required this.product,
    required this.onAccept,
    required this.onDecline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Welcome Gift! 🎁',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            if (product.imageUrls.isNotEmpty)
              Image.asset(
                product.imageUrls[0],
                height: 200,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            SizedBox(height: 16),
            Text(
              product.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            Text(
              'Get this product for FREE!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.green,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: onDecline,
                  child: Text('No, thanks'),
                ),
                ElevatedButton(
                  onPressed: onAccept,
                  child: Text('Add to Cart'),
                  style: ElevatedButton.styleFrom(
                    //  primary: Theme.of(context).primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
