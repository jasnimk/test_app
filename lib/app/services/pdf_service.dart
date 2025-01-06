import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:test_ecommerce_app/app/models/order_item_model.dart';
import 'package:test_ecommerce_app/app/models/order_model.dart';

class PdfService {
  Future<void> generateAndDownloadInvoice(CustomerOrder order) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => _buildInvoicePage(order),
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/Invoice_${order.orderId}.pdf');
    await file.writeAsBytes(await pdf.save());
    await OpenFile.open(file.path);
  }

  pw.Widget _buildInvoicePage(CustomerOrder order) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        pw.SizedBox(height: 20),
        _buildOrderDetails(order),
        pw.SizedBox(height: 20),
        _buildItemsHeader(),
        pw.SizedBox(height: 10),
        _buildItemsList(order),
        pw.Divider(thickness: 2),
        _buildTotal(order),
        pw.SizedBox(height: 40),
        _buildFooter(),
      ],
    );
  }

  pw.Widget _buildHeader() {
    return pw.Text(
      'Invoice-Jewelo Online Jewellery',
      style: pw.TextStyle(
        fontSize: 22,
        fontWeight: pw.FontWeight.bold,
      ),
    );
  }

  pw.Widget _buildOrderDetails(CustomerOrder order) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Order ID: ${order.orderId}'),
        pw.Text('Date: ${DateFormat('MMM dd, yyyy').format(order.createdAt)}'),
        pw.Text('Status: ${order.orderStatus}'),
        pw.Text('Payment Method: ${order.paymentMethod}'),
        pw.Text('Payment Status: ${order.paymentStatus}'),
      ],
    );
  }

  pw.Widget _buildItemsHeader() {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Expanded(flex: 3, child: _headerText('Item')),
        pw.Expanded(flex: 1, child: _headerText('Qty')),
        pw.Expanded(flex: 1, child: _headerText('Price')),
        pw.Expanded(flex: 1, child: _headerText('Total')),
      ],
    );
  }

  pw.Text _headerText(String text) {
    return pw.Text(text, style: pw.TextStyle(fontWeight: pw.FontWeight.bold));
  }

  pw.Widget _buildItemsList(CustomerOrder order) {
    return pw.Column(
      children: [
        for (var i = 0; i < order.items.length; i++) ...[
          _buildItemRow(order.items[i]),
          if (i < order.items.length - 1) pw.SizedBox(height: 10),
        ],
      ],
    );
  }

  pw.Widget _buildItemRow(OrderItem item) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 5),
      decoration: pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            color: PdfColors.grey300,
            width: 0.5,
          ),
        ),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Expanded(
            flex: 4,
            child: pw.Text(
              item.productName,
              style: pw.TextStyle(fontSize: 11),
            ),
          ),
          pw.Expanded(
            flex: 1,
            child: pw.Text(
              item.quantity.toString(),
              style: pw.TextStyle(fontSize: 11),
            ),
          ),
          pw.Expanded(
            flex: 1,
            child: pw.Text(
              '\$${item.price.toStringAsFixed(2)}',
              style: pw.TextStyle(fontSize: 11),
            ),
          ),
          pw.Expanded(
            flex: 1,
            child: pw.Text(
              '\$${(item.price * item.quantity).toStringAsFixed(2)}',
              style: pw.TextStyle(fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildTotal(CustomerOrder order) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text('Total Amount:',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Text('\$${order.totalAmount.toStringAsFixed(2)}',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      ],
    );
  }

  pw.Widget _buildFooter() {
    return pw.Text(
      'Thank you for your business!',
      style: pw.TextStyle(fontStyle: pw.FontStyle.italic),
    );
  }
}
