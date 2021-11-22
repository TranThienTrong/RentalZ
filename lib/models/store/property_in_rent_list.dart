import 'package:rental_apartments_finder/models/store/property.dart';

class PropertyInRentList {
  Property product;
  int quantity;

  PropertyInRentList({required this.product, this.quantity = 1});

  @override
  String toString() {
    return " Product in rent_list { product: $product, quantity: $quantity}";
  }
}
