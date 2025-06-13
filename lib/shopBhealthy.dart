import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Product {
  final String name;
  final double price;
  final String description;
  final String imageUrl;

  Product({
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
  });
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class Shopbhealthy extends StatefulWidget {
  const Shopbhealthy({super.key});

  @override
  _ShopbhealthyState createState() => _ShopbhealthyState();
}

class _ShopbhealthyState extends State<Shopbhealthy> {
  final List<Product> products = [
    Product(
      name: 'جهاز الركض',
      price: 99.99,
      description:
          'جهاز الركض الأحدث يقوم بحساب دقات القلب ويوجد فيه سرعات وأنظمة مختلفة تناسب جميع الأعمار.',
      imageUrl: 'img/danubl1.jfif',
    ),
    Product(
      name: 'كرة القدم التقليدية',
      price: 1.99,
      description: 'كرة القدم التقليدية يوجد منها ألوان وشعارات مختلفة.',
      imageUrl: 'img/danubl2.jfif',
    ),
    Product(
      name: 'أثقال رياضية تقليدية',
      price: 45.99,
      description:
          'أثقال رياضية تقليدية مصنوعة من الحديد ومطلية بالألمنيوم لمقاومة الصدأ، مثالية لتدريبات القوة والتحمل.',
      imageUrl: 'img/danubl3.jfif',
    ),
    Product(
      name: 'أثقال رياضية حديثة',
      price: 79.99,
      description:
          'أثقال رياضية حديثة مصنوعة من الحديد المطلي بالكروم، توفر قبضة مريحة ومقاومة للصدأ، مثالية لتدريبات القوة والتحمل. يمكنك من خلالها وضع الوزن المناسب لتدريبك.',
      imageUrl: 'img/danubl4.jfif',
    ),
    Product(
      name: 'حذاء رياضي',
      price: 19.99,
      description:
          'حذاء رياضي مريح وخفيف الوزن، مثالي للجري والتمارين الرياضية اليومية.',
      imageUrl: 'img/danubl5.jfif',
    ),
    Product(
      name: 'ساعة توقيت رياضية رقمية',
      price: 3.99,
      description:
          'ساعة توقيت رياضية رقمية مع ميزات تتبع النشاط، مثالية للرياضيين.',
      imageUrl: 'img/danubl6.jfif',
    ),
    Product(
      name: 'أدوات لياقة بدنية',
      price: 29.99,
      description:
          'مجموعة أدوات لياقة بدنية تشمل حبل القفز، كرة التوازن، وأثقال اليد، مثالية للتمارين المنزلية.',
      imageUrl: 'img/danubl.jfif',
    ),
  ];

  final List<CartItem> cart = [];
  final List<CartItem> orderedItems = [];

  void addToCart(Product product, int quantity) {
    setState(() {
      var existingItem = cart.firstWhere(
        (item) => item.product.name == product.name,
        orElse: () => CartItem(product: product, quantity: 0),
      );
      if (cart.contains(existingItem)) {
        existingItem.quantity += quantity;
      } else {
        existingItem.quantity = quantity;
        cart.add(existingItem);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم إضافة ${product.name} ($quantity) إلى السلة')),
    );
  }

  void removeFromCart(CartItem item) {
    final navigator = Navigator.of(context);
    setState(() {
      if (item.quantity > 1) {
        item.quantity--;
      } else {
        cart.remove(item);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم إزالة ${item.product.name} من السلة')),
    );
    if (cart.isEmpty && navigator.canPop()) {
      navigator.pop();
    }
  }

  void addToOrderedItems(List<CartItem> items) {
    setState(() {
      orderedItems.addAll(items);
    });
  }

  void navigateToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartPage(
          cart: cart,
          onRemove: removeFromCart,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFAAAAAA),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF0B5022),
        actions: [
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.bookmark),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => RequestedProductsPage(
                  orderedItems: orderedItems,
                ),
              ));
            },
          ),
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.shopping_cart),
            onPressed: navigateToCart,
          ),
          const SizedBox(width: 110),
          const Text(
            'المتجر الإلكتروني',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection("online_store").get(),
        builder: (context, snapshot) {
          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.55,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              Uint8List bytes =
                  base64Decode(snapshot.data!.docs[index]["imageUrl"]);
              final product = products[index];
              return Card(
                elevation: 5,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsPage(
                          product: product,
                          onAddToCart: addToCart,
                        ),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.memory(
                        bytes,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          snapshot.data!.docs[index]["name"],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Center(
                        child: Text(
                          '${snapshot.data!.docs[index]["price"]} دينار',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          snapshot.data!.docs[index]["description"],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ProductDetailsPage extends StatefulWidget {
  final Product product;
  final Function(Product, int) onAddToCart;

  const ProductDetailsPage({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int quantity = 1;

  void incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFAAAAAA),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF0B5022),
        actions: [
          const SizedBox(width: 170),
          Text(
            widget.product.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Image.asset(
              widget.product.imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Text(
              widget.product.name,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.product.price} دينار',
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.product.description,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: incrementQuantity,
                ),
                Text(
                  '$quantity',
                  style: const TextStyle(fontSize: 18),
                ),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: decrementQuantity,
                ),
                const SizedBox(width: 16),
                const Text(
                  'الكمية:',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0B5022),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  widget.onAddToCart(widget.product, quantity);
                  Navigator.pop(context);
                },
                child: const Text('إضافة إلى السلة'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  final List<CartItem> cart;
  final Function(CartItem) onRemove;

  const CartPage({super.key, required this.cart, required this.onRemove});

  void navigateToCheckout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutPage(
          cart: cart,
          clearCart: () {
            final shopState =
                context.findAncestorStateOfType<_ShopbhealthyState>();
            shopState?.setState(() {
              shopState.cart.clear();
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(context) {
    double totalPrice = cart.fold(
      0,
      (sum, item) => sum + item.product.price * item.quantity,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFAAAAAA),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF0B5022),
        actions: [
          const SizedBox(width: 170),
          const Text(
            'سلة الشراء',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: cart.isEmpty
          ? const Center(child: Text('السلة فارغة'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final item = cart[index];
                      return ListTile(
                        leading: Image.asset(
                          item.product.imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          item.product.name,
                          textAlign: TextAlign.right,
                        ),
                        subtitle: Text(
                          'السعر: ${item.product.price} دينار | الكمية: ${item.quantity}',
                          textAlign: TextAlign.right,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'الإجمالي: ${item.product.price * item.quantity} دينار',
                              textAlign: TextAlign.right,
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => onRemove(item),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'الإجمالي: $totalPrice دينار',
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0B5022),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => navigateToCheckout(context),
                    child: const Text('تأكيد الطلب'),
                  ),
                ),
              ],
            ),
    );
  }
}

class CheckoutPage extends StatefulWidget {
  final List<CartItem> cart;
  final VoidCallback clearCart;

  const CheckoutPage({super.key, required this.cart, required this.clearCart});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String paymentMethod = 'عند الاستلام';
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  String? cardError;
  String? expiryError;
  String? cvvError;

  bool validateCardDetails() {
    setState(() {
      cardError = null;
      expiryError = null;
      cvvError = null;
    });

    bool isValid = true;

    if (paymentMethod == 'فيزا') {
      if (cardNumberController.text.replaceAll(' ', '').length != 16) {
        cardError = 'رقم البطاقة يجب أن يتكون من 16 رقمًا';
        isValid = false;
      }

      final expiry = expiryDateController.text;
      final RegExp expiryRegex = RegExp(r'^(0[1-9]|1[0-2])/([0-9]{2})$');
      if (!expiryRegex.hasMatch(expiry)) {
        expiryError = 'تاريخ الصلاحية يجب أن يكون بصيغة MM/YY';
        isValid = false;
      } else {
        final parts = expiry.split('/');
        final month = int.parse(parts[0]);
        final year = int.parse('20${parts[1]}');
        final now = DateTime.now();
        final expiryDate = DateTime(year, month + 1);
        if (expiryDate.isBefore(now)) {
          expiryError = 'البطاقة منتهية الصلاحية';
          isValid = false;
        }
      }

      final cvv = cvvController.text;
      if (cvv.length < 3 || cvv.length > 4) {
        cvvError = 'CVV يجب أن يتكون من 3 إلى 4 أرقام';
        isValid = false;
      }
    }

    return isValid;
  }

  @override
  void dispose() {
    cardNumberController.dispose();
    expiryDateController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = widget.cart.fold(
      0,
      (sum, item) => sum + item.product.price * item.quantity,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFAAAAAA),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF0B5022),
        actions: [
          const SizedBox(width: 170),
          const Text(
            'تأكيد الطلب',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'ملخص الطلب',
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...widget.cart.map(
              (item) => ListTile(
                title: Text(
                  item.product.name,
                  textAlign: TextAlign.right,
                ),
                subtitle: Text(
                  'الكمية: ${item.quantity}',
                  textAlign: TextAlign.right,
                ),
                trailing: Text(
                  '${item.product.price * item.quantity} دينار',
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'الإجمالي: $totalPrice دينار',
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'اختر طريقة الدفع',
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            RadioListTile(
              title: const Text('عند الاستلام'),
              value: 'عند الاستلام',
              groupValue: paymentMethod,
              onChanged: (value) {
                setState(() {
                  paymentMethod = value.toString();
                  cardNumberController.clear();
                  expiryDateController.clear();
                  cvvController.clear();
                  cardError = null;
                  expiryError = null;
                  cvvError = null;
                });
              },
            ),
            RadioListTile(
              title: const Text('فيزا'),
              value: 'فيزا',
              groupValue: paymentMethod,
              onChanged: (value) {
                setState(() {
                  paymentMethod = value.toString();
                });
              },
            ),
            if (paymentMethod == 'فيزا') ...[
              const SizedBox(height: 16),
              TextField(
                controller: cardNumberController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                  CardNumberInputFormatter(),
                ],
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  labelText: 'رقم البطاقة',
                  errorText: cardError,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: expiryDateController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                        ExpiryDateInputFormatter(),
                      ],
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        labelText: 'تاريخ الصلاحية (MM/YY)',
                        errorText: expiryError,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: cvvController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        labelText: 'CVV',
                        errorText: cvvError,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0B5022),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  if (validateCardDetails()) {
                    final shopState =
                        context.findAncestorStateOfType<_ShopbhealthyState>();
                    shopState?.addToOrderedItems(List.from(widget.cart));
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RequestedProductsPage(
                          orderedItems: List.from(widget.cart),
                        ),
                      ),
                    ).then((_) {
                      widget.clearCart();
                    });
                  }
                },
                child: const Text('إتمام الطلب'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RequestedProductsPage extends StatelessWidget {
  final List<CartItem> orderedItems;

  const RequestedProductsPage({
    super.key,
    required this.orderedItems,
  });

  @override
  Widget build(BuildContext context) {
    double totalPrice = orderedItems.fold(
      0,
      (sum, item) => sum + item.product.price * item.quantity,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFAAAAAA),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF0B5022),
        actions: [
          const SizedBox(width: 170),
          const Text(
            'المنتجات المطلوبة',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: orderedItems.isEmpty
            ? const Center(child: Text('لا توجد منتجات مطلوبة'))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'تفاصيل الطلب',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: orderedItems.length,
                      itemBuilder: (context, index) {
                        final item = orderedItems[index];
                        return ListTile(
                          leading: Image.asset(
                            item.product.imageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(
                            item.product.name,
                            textAlign: TextAlign.right,
                          ),
                          subtitle: Text(
                            'الكمية: ${item.quantity}',
                            textAlign: TextAlign.right,
                          ),
                          trailing: Text(
                            '${item.product.price * item.quantity} دينار',
                            textAlign: TextAlign.right,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'الإجمالي: $totalPrice دينار',
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'سوف يصل الطلب خلال 14 يومًا من عملية الإتمام وسيتم التواصل معك عند الوصول.',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0B5022),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.popAndPushNamed(
                          context,
                          'shop',
                        );
                      },
                      child: const Text('العودة إلى المتجر'),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll(' ', '');
    if (text.length > 16) return oldValue;
    String newText = '';
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) newText += ' ';
      newText += text[i];
    }
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll('/', '');
    if (text.length > 4) return oldValue;
    String newText = '';
    for (int i = 0; i < text.length; i++) {
      if (i == 2) newText += '/';
      newText += text[i];
    }
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
