import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dental_clinic_app/models/product_model.dart';
import 'package:dental_clinic_app/providers/cart_provider.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final List<Product> _products = [
    Product(
      id: '1',
      name: 'Электрическая зубная щетка Pro',
      price: 4999,
      image: 'assets/images/toothbrush.jpg',
      description: 'Инновационная электрическая зубная щетка с 5 режимами чистки, таймером и индикатором зарядки. Удаляет до 99.9% бактерий, обеспечивая глубокую и бережную очистку полости рта.',
    ),
    Product(
      id: '2',
      name: 'Отбеливающая зубная паста',
      price: 599,
      image: 'assets/images/toothpaste.jpg',
      description: 'Профессиональная отбеливающая зубная паста с инновационной формулой. Эффективно удаляет потемнения, защищает эмаль и обеспечивает длительную свежесть дыхания.',
    ),
    Product(
      id: '3', 
      name: 'Ирригатор полости рта',
      price: 3499,
      image: 'assets/images/irrigator.jpg', 
      description: 'Мощный ирригатор для профессиональной гигиены полости рта. 3 режима интенсивности, 5 насадок в комплекте. Идеально подходит для чистки труднодоступных мест и профилактики заболеваний десен.',
    ),
    Product(
      id: '4',
      name: 'Набор для отбеливания зубов',
      price: 2999,
      image: 'assets/images/whitening_kit.jpg',
      description: 'Профессиональный набор для домашнего отбеливания. Включает гель, капу и LED-активатор. Безопасное и эффективное осветление зубов на несколько тонов.',
    ),
  ];

  void _showProductDetails(Product product) {
    showDialog(
      context: context,
      builder: (context) => ProductDetailsDialog(product: product),
    );
  }

  void _showCart() {
    showDialog(
      context: context,
      builder: (context) => const CartDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Магазин'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: _showCart,
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return Card(
            elevation: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showProductDetails(product),
                    child: Image.asset(
                      product.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${product.price} ₸',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          cartProvider.addToCart(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.name} добавлен в корзину'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: const Text('В корзину'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ProductDetailsDialog extends StatefulWidget {
  final Product product;

  const ProductDetailsDialog({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailsDialogState createState() => _ProductDetailsDialogState();
}

class _ProductDetailsDialogState extends State<ProductDetailsDialog> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.asset(
                widget.product.image,
                fit: BoxFit.cover,
                height: 250,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.product.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    '${widget.product.price} ₸',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          cartProvider.addToCart(widget.product);
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${widget.product.name} добавлен в корзину'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: const Text('Добавить в корзину'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Закрыть'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartDialog extends StatelessWidget {
  const CartDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.items;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Корзина',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          cartItems.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Ваша корзина пуста',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final product = cartItems[index];
                      return ListTile(
                        leading: Image.asset(
                          product.image,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(product.name),
                        subtitle: Text('${product.price} ₸'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            cartProvider.removeFromCart(product);
                          },
                        ),
                      );
                    },
                  ),
                ),
          if (cartItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Итого: ${cartProvider.totalPrice} ₸',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Переход на экран оплаты
                      Navigator.of(context).pushNamed('/payment');
                    },
                    child: const Text('Оформить заказ'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
