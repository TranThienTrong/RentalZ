import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:rental_apartments_finder/models/store/property.dart';
import 'package:rental_apartments_finder/models/store/property_in_rent_list.dart';
import 'package:rental_apartments_finder/services/stores/properties_service.dart';
import 'package:uuid/uuid.dart';

class RentListProvider with ChangeNotifier {
  FirebasePropertyService productService = FirebasePropertyService();
  Uuid uuid = Uuid();

  RentListProvider();

  static Map<String, PropertyInRentList> _rentListItemList = {};

  Map<String, PropertyInRentList> get rentListItemList => _rentListItemList;

  int get rentListItemQuantity => this.rentListItemList.length;

  Future<void> addRentListItem(String productId) async {
    Property? product = await productService.findProduct(productId);

    if (product != null) {
      if (rentListItemList.containsKey(productId)) {
        rentListItemList.update(
            productId,
            (existRentListItem) => PropertyInRentList(
                product: product, quantity: existRentListItem.quantity += 1));
      } else {
        rentListItemList.putIfAbsent(
          productId,
          () => PropertyInRentList(product: product, quantity: 1),
        );
      }
    }

    notifyListeners();
  }

  void decreaseRentListItem(String productId) async {
    Property? product = await productService.findProduct(productId);

    if (product != null) {
      if (rentListItemList.containsKey(productId)) {
        if (rentListItemList[productId]!.quantity > 1) {
          rentListItemList.update(
              productId,
              (existRentListItem) => PropertyInRentList(
                  product: product, quantity: existRentListItem.quantity -= 1));
        } else if (rentListItemList[productId]!.quantity == 1) {
          rentListItemList.remove(productId);
        }
      }
    }
    notifyListeners();
  }

  void removeRentListItem(String productId) {
    if (rentListItemList.containsKey(productId)) {
      rentListItemList.remove(productId);
      notifyListeners();
    }
  }

  double get totalPrice {
    double sum = 0;
    this.rentListItemList.forEach(
      (RentListID, productInRentList) {
        sum +=
            productInRentList.product.rentPrice! * productInRentList.quantity;
      },
    );
    return sum;
  }

  void clear() {
    rentListItemList.clear();
    notifyListeners();
  }
}
