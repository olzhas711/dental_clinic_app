import 'package:flutter/material.dart';
import 'package:dental_clinic_app/screens/auth_screen.dart';

class Product {
  final String name;
  final String description;
  final double price;
  final String imageUrl;

  Product({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });
}

class StoreScreen extends StatefulWidget {
  final bool isGuest;

  const StoreScreen({super.key, this.isGuest = false});

  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final List<Product> _products = [
    Product(
      name: 'Электрическая зубная щетка',
      description: 'Профессиональная щетка с 5 режимами чистки',
      price: 3999.99,
      imageUrl: 'https://example.com/toothbrush.jpg', // Замените на реальную ссылку
    ),
    Product(
      name: 'Отбеливающая зубная паста',
      description: 'Комплексная защита и отбеливание',
      price: 599.50,
      imageUrl: 'https://example.com/toothpaste.jpg', // Замените на реальную ссылку
    ),
    Product(
      name: 'Ирригатор полости рта',
      description: 'Портативный ирригатор для гигиены полости рта',
      price: 2499.00,
      imageUrl: 'https://example.com/irrigator.jpg', // Замените на реальную ссылку
    ),
  ];

  final List<Product> _cart = [];

  void _addToCart(Product product) {
    setState(() {
      _cart.add(product);
    });
  }

  void _removeFromCart(Product product) {
    setState(() {
      _cart.removeWhere((item) => item.name == product.name);
    });
  }

  void _checkout() {
    if (widget.isGuest) {
      _showAuthRequiredDialog();
    } else {
      _showCheckoutDialog();
    }
  }

  void _showAuthRequiredDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Требуется авторизация'),
        content: Text('Для оформления заказа необходимо войти в аккаунт.'),
        actions: [
          TextButton(
            child: Text('Отмена'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          ElevatedButton(
            child: Text('Войти'),
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AuthScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showCheckoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Оформление заказа'),
        content: Text('Заказ успешно оформлен. Спасибо за покупку!'),
        actions: [
          TextButton(
            child: Text('Ок'),
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() {
                _cart.clear();
              });
            },
          ),
        ],
      ),
    );
  }

  double get _totalPrice {
    return _cart.fold(0, (total, product) => total + product.price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Стоматологический магазин'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  _showCartBottomSheet();
                },
              ),
              if (_cart.isNotEmpty)
                Positioned(
                  right: 0,
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 10,
                    child: Text(
                      _cart.length.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Наши товары',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(product.imageUrl),
                        radius: 30,
                        backgroundColor: Colors.teal.shade100,
                      ),
                      title: Text(
                        product.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.description,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${product.price.toStringAsFixed(2)} ₽',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.add_shopping_cart),
                        onPressed: () => _addToCart(product),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCartBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Корзина',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            if (_cart.isEmpty)
              Text('Корзина пуста')
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _cart.length,
                  itemBuilder: (ctx, index) {
                    final product = _cart[index];
                    return ListTile(
                      title: Text(product.name),
                      subtitle: Text('${product.price.toStringAsFixed(2)} ₽'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            _removeFromCart(product);
                          });
                          Navigator.of(ctx).pop();
                          _showCartBottomSheet();
                        },
                      ),
                    );
                  },
                ),
              ),
            SizedBox(height: 16),
            Text(
              'Итого: ${_totalPrice.toStringAsFixed(2)} ₽',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _cart.isNotEmpty ? _checkout : null,
              child: Text('Оформить заказ'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
