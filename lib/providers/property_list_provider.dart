import 'package:flutter/material.dart';
import 'package:rental_apartments_finder/models/store/property.dart';
import 'package:rental_apartments_finder/services/stores/properties_service.dart';

class PropertiesListProvider with ChangeNotifier {
  FirebasePropertyService propertyService = new FirebasePropertyService();

  ProductsListProvider() {
    propertyService = new FirebasePropertyService();
  }

  List<Property> propertyList = [];

  Future<Property?> findProduct(String id) async {
    for (Property property in propertyList) {
      if (property.id == id) {
        return property;
      }
    }
    return null;
  }

  List<Property> getPropertyList() {
    return propertyList;
  }

  addProperty(Property property) {
    propertyList.add(property);
    print("${property.name} + added");
    notifyListeners();
  }
}
