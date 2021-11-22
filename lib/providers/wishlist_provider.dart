import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:rental_apartments_finder/providers/property_list_provider.dart';

class WishlistProvider with ChangeNotifier {
  PropertiesListProvider productProvider = new PropertiesListProvider();

  WishlistProvider();

  static Set<String> _wishlistItemList = {};

  Set<String> get wishlistItemList => _wishlistItemList;

  int get wishlistItemQuantity => this.wishlistItemList.length;

  void addWishlistItem(String productId) async {
    wishlistItemList.add(productId);
    notifyListeners();
  }

  void removeWishlistItem(String productId) async {
    wishlistItemList.remove(productId);
    notifyListeners();
  }
}
