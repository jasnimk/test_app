import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:test_ecommerce_app/app/controllers/order_controller.dart';
import 'package:test_ecommerce_app/app/widgets/add_on_widgets.dart';
import 'package:test_ecommerce_app/app/widgets/custom_button.dart';

class OrdersScreen extends StatelessWidget {
  final OrderController orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => orderController.fetchUserOrders(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => orderController.fetchUserOrders(),
        child: Obx(() {
          if (orderController.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (orderController.errorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.red,
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      orderController.errorMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red[900],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: Icon(Icons.refresh),
                    label: Text('Retry'),
                    onPressed: () => orderController.refreshOrders(),
                  ),
                ],
              ),
            );
          }

          if (orderController.orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 48,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  buildEmptyStateWidget(message: 'NO ORDERS YET!')
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: orderController.orders.length,
            padding: EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final order = orderController.orders[index];
              return Card(
                shape: BeveledRectangleBorder(),
                margin: EdgeInsets.only(bottom: 16),
                child: ExpansionTile(
                  title: Text(
                    'Order #${order.orderId?.substring(0, 8) ?? 'Unknown'}',
                    style: styling(),
                  ),
                  subtitle: Text(
                    'Date: ${DateFormat('MMM dd, yyyy').format(order.createdAt)}\n'
                    'Status: ${order.orderStatus}\n'
                    'Total: ₹${order.totalAmount.toStringAsFixed(2)}',
                    style: styling(),
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Items:',
                            style: styling(),
                          ),
                          SizedBox(height: 8),
                          if (order.items.isNotEmpty) ...[
                            ...order.items.map((item) => Padding(
                                  padding: EdgeInsets.only(bottom: 4),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.productName,
                                          style: styling(),
                                        ),
                                      ),
                                      Text(
                                        '${item.quantity} x ₹${item.price.toStringAsFixed(2)}',
                                        style: styling(),
                                      ),
                                    ],
                                  ),
                                )),
                          ] else ...[
                            Text(
                              'Nothing Found here!',
                              style: styling(),
                            )
                          ],
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total:',
                                style: styling(),
                              ),
                              Text(
                                '₹${order.totalAmount.toStringAsFixed(2)}',
                                style: styling(),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: CustomButton(
                              text: 'Download Invoice',
                              onPressed: () {
                                orderController.generateAndDownloadInvoice(
                                    order.orderId ?? '');
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
