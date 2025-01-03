import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_ecommerce_app/app/data/product.dart';
import 'package:test_ecommerce_app/app/screens/product_list_screen.dart';
import 'package:test_ecommerce_app/app/utilities/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: CustomProductGridView(
        products: products,
      ),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      // For system theme:
      themeMode: ThemeMode.system,
    );
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}
