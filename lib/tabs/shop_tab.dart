import 'package:flutter/material.dart';

class ShopTab extends StatefulWidget {
  const ShopTab({super.key});

  @override
  State<ShopTab> createState() => _ShopTabState();
}

class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  Product({required this.id, required this.title, required this.description, required this.price, required this.imageUrl});
}

class _ShopTabState extends State<ShopTab> {
  final List<Product> _products = [
    Product(id: 'cap', title: 'Cap', description: 'Black cap with 4 Watches logo', price: 12.99, imageUrl: ''),
    Product(id: 'tshirt', title: 'T-Shirt', description: 'Cotton T-Shirt', price: 19.99, imageUrl: ''),
    Product(id: 'hoodie', title: 'Hoodie', description: 'Warm hoodie', price: 34.99, imageUrl: ''),
    Product(id: 'calendar', title: 'Wall Calendar', description: '14-Year wall calendar', price: 9.99, imageUrl: ''),
  ];

  final Map<String, int> _cart = {};

  void _addToCart(Product p) {
    setState(() {
      _cart[p.id] = (_cart[p.id] ?? 0) + 1;
    });
  }

  void _removeFromCart(Product p) {
    setState(() {
      final q = (_cart[p.id] ?? 0) - 1;
      if (q <= 0) {
        _cart.remove(p.id);
      } else {
        _cart[p.id] = q;
      }
    });
  }

  void _clearCart() {
    setState(() => _cart.clear());
  }

  double _cartTotal() {
    double total = 0;
    for (final id in _cart.keys) {
      final p = _products.firstWhere((e) => e.id == id);
      total += p.price * _cart[id]!;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shop')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _products.length,
              itemBuilder: (ctx, i) {
                final p = _products[i];
                final qty = _cart[p.id] ?? 0;
                return Card(
                  color: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        // placeholder for image
                        Container(width: 72, height: 72, color: Colors.white10, child: const Icon(Icons.image, color: Colors.white24)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              Text(p.description, style: const TextStyle(color: Colors.white70)),
                              const SizedBox(height: 6),
                              Text('\$${p.price.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          children: [
                            IconButton(onPressed: () => _addToCart(p), icon: const Icon(Icons.add_circle, color: Colors.green)),
                            Text('$qty', style: const TextStyle(color: Colors.white)),
                            IconButton(onPressed: () => _removeFromCart(p), icon: const Icon(Icons.remove_circle, color: Colors.red)),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.black,
            child: Row(
              children: [
                Expanded(child: Text('Items: ${_cart.values.fold<int>(0, (a,b) => a+b)}', style: const TextStyle(color: Colors.white))),
                Expanded(child: Text('Total: \$${_cartTotal().toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                ElevatedButton(onPressed: _cart.isEmpty ? null : () { _clearCart(); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Checkout not implemented'))); }, child: const Text('Checkout')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
