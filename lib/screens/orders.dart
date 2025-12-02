import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderScreen extends StatelessWidget {
  final List<dynamic> cart; // receive full cart
  const OrderScreen({super.key, required this.cart});

  double _calculateTotal() {
    double total = 0;
    for (var item in cart) {
      total += (item['price'] ?? 0).toDouble();
    }
    return total;
  }

  Future<void> _placeOrder(BuildContext context) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to order')),
      );
      return;
    }

    try {
      for (var item in cart) {
        final totalPrice = (item['price'] ?? 0).toDouble();

        await Supabase.instance.client.from('orders').insert({
          'user_id': user.id,
          'product_id': item['id'],
          'quantity': 1,
          'total_price': totalPrice,
          'status': 'Ordered',

          // Store product details so Order History can display correct info
          'product_title': item['title'],
          'product_image': item['image_url'],
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Products ordered successfully! Total: ₦${_calculateTotal().toStringAsFixed(2)}'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context); // go back after ordering
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _confirmOrder(BuildContext context) {
    final totalPrice = _calculateTotal();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Order'),
        content: Text(
          'Do you want to order ${cart.length} items?\n\n'
              'Total Price: ₦$totalPrice',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _placeOrder(context);
            },
            child: const Text('Yes, Order'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = _calculateTotal();

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cart.length,
                itemBuilder: (context, index) {
                  final item = cart[index];
                  return Card(
                    child: ListTile(
                      leading: Image.network(
                        item['image_url'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(item['title']),
                      subtitle: Text('₦${item['price']}'),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Total: ₦$totalPrice',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.shopping_bag),
              label: const Text('Checkout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () => _confirmOrder(context),
            ),
          ],
        ),
      ),
    );
  }
}
