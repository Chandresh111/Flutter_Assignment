import 'product.dart';

class MockApi {
  // Simulates an error on the first API request.
  bool _firstRequest = true;

  Future<List<Product>?> fetchProducts({bool returnNull = false}) async {
    // Simulate network delay.
    await Future.delayed(const Duration(seconds: 2));

    // Simulate API failure on the first request.
    if (_firstRequest) {
      _firstRequest = false;
      throw Exception('Failed to fetch products');
    }

    // Simulate a null API response.
    if (returnNull) {
      return null;
    }

    // Successful API response.
    return [
      Product(id: 1, name: 'Pizza', price: 299),
      Product(id: 2, name: 'Burger', price: 199),
      Product(id: 3, name: 'Pasta', price: null),
    ];
  }
}
