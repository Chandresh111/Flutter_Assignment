import 'package:flutter/material.dart';

import 'mock_api.dart';
import 'product.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mock API Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ProductPage(),
    );
  }
}

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final MockApi api = MockApi();

  List<Product>? products;
  String? errorMessage;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await api.fetchProducts();

      setState(() {
        products = result;
        isLoading = false;
        errorMessage = null;
      });
    } catch (error) {
      setState(() {
        errorMessage = 'Failed to fetch products';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    // Loading state
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Error state
    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 50),
            const SizedBox(height: 12),
            Text(
              errorMessage!,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: fetchData,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Null or empty response
    if (products == null || products!.isEmpty) {
      return const Center(
        child: Text('No products available', style: TextStyle(fontSize: 18)),
      );
    }

    // Display API data
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: products!.length,
      itemBuilder: (context, index) {
        final product = products![index];

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: ListTile(
            leading: CircleAvatar(child: Text('${product.id}')),
            title: Text(
              product.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              product.price == null
                  ? 'Price not available'
                  : 'Price: ₹${product.price}',
            ),
          ),
        );
      },
    );
  }
}
