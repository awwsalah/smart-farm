import 'package:app/data/repositories/cart_repository.dart';
import 'package:app/models/product.dart';
import 'package:flutter/foundation.dart';

class CartProvider extends ChangeNotifier {
  CartProvider({CartRepository? repository})
      : _repository = repository ?? CartRepository();

  final CartRepository _repository;

  List<CartLineItem> items = [];
  int itemCount = 0;
  double total = 0;
  bool isLoading = false;

  Future<void> load() async {
    isLoading = true;
    notifyListeners();

    items = await _repository.getItems();
    itemCount = await _repository.getItemCount();
    total = await _repository.getTotal();

    isLoading = false;
    notifyListeners();
  }

  Future<void> addProduct(Product product, {int quantity = 1}) async {
    await _repository.addProduct(product.id, quantity: quantity);
    await load();
  }

  Future<void> updateQuantity(int cartItemId, int quantity) async {
    await _repository.updateQuantity(cartItemId, quantity);
    await load();
  }

  Future<void> removeItem(int cartItemId) async {
    await _repository.removeItem(cartItemId);
    await load();
  }

  Future<void> clear() async {
    await _repository.clear();
    await load();
  }
}