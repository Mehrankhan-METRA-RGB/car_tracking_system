import 'package:flutter/cupertino.dart';

import '../Model/item_model.dart';

class CartController extends ChangeNotifier {
  final List<Item> _items = [];
  // List<Item> _uniqueItems = [];
  List<Item> get items => _items;
  List<Item> get uniqueItems => _items;
  int get cartItemsCount => _items.length;
  final List<Item> _currentProducts = [];
  List<Item> get currentProducts => _currentProducts;
  Map _productCount = {};
  Map get productCount => _productCount;

  double _totalPrice = 0;
  double get totalPrice => _totalPrice;

  void addItemCart(Item item) {
    _items.add(item);
    countTheProducts(_items);
    _getCurrentProducts(item);
    notifyListeners();
  }

  void removeItemFromCart(Item item) {
    List<Item> getArray = _items.where((e) => e.id == item.id).toList();
    _getCurrentProducts(item);
    if (getArray.isNotEmpty) {
      getArray.removeLast();
      _items.removeWhere((e) => e.id == item.id);
      _items.addAll(getArray);
    }
    countTheProducts(_items);
    notifyListeners();
  }

  void _getCurrentProducts(Item item) {
    _currentProducts.clear();
    _currentProducts.addAll(items.where((e) => e.id == item.id).toList());
  }

  void countTheProducts(List<Item> items) {
    List<int?> _items = items.map((e) => e.id).toList();
    // print(_items);

    Map count = {};
    for (var i in _items) {
      count[i] = (count[i] ?? 0) + 1;
    }
    // print(count.toString());
    _productCount = count;
    updatePrice();
  }

  void updatePrice() {
    List<double> prices = _items.map((e) => double.parse(e.price!)).toList();
    // print('Prices: $prices');
    if (prices.length > 1) {
      _totalPrice = (prices).reduce((a, b) => a + b);
    } else if (prices.length == 1) {
      _totalPrice = (prices).first;
    } else {
      _totalPrice = 0;
    }
  }

  void discount(amount) {
    String _discount = amount == null || amount == "" ||amount == "." ?  '0' : amount;
    updatePrice();
    _totalPrice = _totalPrice - double.parse(_discount);

    notifyListeners();
  }
}
