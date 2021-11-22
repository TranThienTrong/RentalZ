import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:rental_apartments_finder/models/store/property.dart';

enum PropertyTypes { FLAT, HOUSE, BUNGALOW, VILLA, PEN_HOUSE }

enum FurnitureTypes { NONE, FURNISHED, PART_FURNISHED }

enum Bedrooms { NONE, STUDIO, ONE, TWO, THREE, MORE_THAN_THREE }

class Category {
  final String name;
  String image;

  // List<Property> productsList = [];

  Category({
    required this.name,
    required this.image,
    // required this.productsList,
  });

  factory Category.fromDocument(DocumentSnapshot document) {
    return Category(name: document['name'], image: document['image']);
  }
}
