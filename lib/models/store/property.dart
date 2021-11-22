import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:rental_apartments_finder/models/note.dart';
import 'package:rental_apartments_finder/models/places/address.dart';
import '../users/singned_account.dart';
import 'category.dart';

enum ProductStages {
  YOUR_PROPERTY,
  IN_RentList,
  IN_CHECKOUT,
}

class Property with ChangeNotifier {
  late String _id;
  late String _ownerId;
  String? _name;
  String? _desc;
  double? _rentPrice;
  int? _roomsQuantity;
  List<String>? _imageUrl;
  DateTime? _postTime;
  Address? address;
  PropertyTypes? _propertyType;
  FurnitureTypes? _furnitureType;
  Bedrooms? _bedroom;
  Note? note;
  bool isFavourite = false;

  Property(
      {required id,
      required ownerId,
      required name,
      required desc,
      required rentPrice,
      required roomsQuantity,
      required postTime,
      required imageUrl,
      required propertyType,
      required furnitureType,
      required bedroom,
      this.address,
      this.isFavourite = false}) {
    this.id = id;
    this.ownerId = ownerId;
    this.name = name;
    this.desc = desc;
    this.rentPrice = rentPrice;
    this.postTime = postTime;
    this.roomsQuantity = roomsQuantity;
    this.imageUrl = List<String>.from(imageUrl);
    this.propertyType = propertyType;
    this.furnitureType = furnitureType;
    this.bedroom = bedroom;
    this.isFavourite = isFavourite;
  }

  factory Property.fromDocument(DocumentSnapshot document) {
    return Property(
        id: document.id,
        ownerId: document['ownerID'],
        name: document['name'],
        desc: document['desc'],
        rentPrice: document['rentPrice'].toDouble(),
        roomsQuantity: document['roomsQuantity'],
        imageUrl: List<String>.from(document['imageURL']),
        postTime: document['postTime'].toDate(),
        propertyType: EnumToString.fromString(
            PropertyTypes.values, document['propertyType']),
        furnitureType: EnumToString.fromString(
            FurnitureTypes.values, document['furnitureType']),
        bedroom: EnumToString.fromString(Bedrooms.values, document['bedroom']),
        address: Address(
            latitude: document['address.latitude'],
            longitude: document['address.longitude']));
  }

  factory Property.fromJson(Map<String, dynamic> json) {
    List<String> imageList = <String>[];

    if (!(json['imageURL'] is List<dynamic>)) {
      imageList = <String>[json['imageURL']];
    } else {
      imageList = List<String>.from(json['imageURL']);
    }

    return Property(
        id: json['id'].toString(),
        ownerId: json['ownerID'].toString(),
        name: json['name'].toString(),
        desc: json['desc'].toString(),
        rentPrice: json['rentPrice'].toDouble(),
        roomsQuantity: json['roomsQuantity'],
        imageUrl: imageList,
        postTime: json['postTime'].toDate(),
        propertyType:
            EnumToString.fromString(PropertyTypes.values, json['propertyType']),
        furnitureType: EnumToString.fromString(
            FurnitureTypes.values, json['furnitureType']),
        bedroom: EnumToString.fromString(Bedrooms.values, json['bedroom']));
  }

  factory Property.empty(String id) {
    return Property(
        id: id,
        ownerId: SignedAccount.instance.id,
        name: '',
        desc: '',
        rentPrice: 0.0,
        imageUrl: <String>[],
        roomsQuantity: 1,
        postTime: DateTime.now(),
        propertyType: PropertyTypes.FLAT,
        bedroom: Bedrooms.NONE,
        furnitureType: FurnitureTypes.NONE);
  }

  DateTime? get postTime => _postTime;

  set postTime(DateTime? value) {
    _postTime = value;
  }

  toString() {
    return "Product{ id: $id, ownerID: $ownerId, name: $name, desc: $desc, rent_price: $rentPrice, propertyType: $propertyType, furniture_type: $furnitureType, bedroom: $bedroom, isFavourite: $isFavourite}";
  }

  String get ownerId => _ownerId;

  set ownerId(String value) {
    _ownerId = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  void toggleFavourite() {
    if (isFavourite) {
      isFavourite = false;
    } else {
      isFavourite = true;
    }
    notifyListeners();
  }

  String? get name => _name;

  set name(String? value) {
    _name = value;
  }

  PropertyTypes? get propertyType => _propertyType;

  set propertyType(PropertyTypes? value) {
    _propertyType = value;
  }

  List<String>? get imageUrl => _imageUrl;

  set imageUrl(List<String>? value) {
    _imageUrl = value;
  }

  double? get rentPrice => _rentPrice;

  set rentPrice(double? value) {
    _rentPrice = value;
  }

  String? get desc => _desc;

  set desc(String? value) {
    _desc = value;
  }

  int? get roomsQuantity => _roomsQuantity;

  set roomsQuantity(int? value) {
    _roomsQuantity = value;
  }

  FurnitureTypes? get furnitureType => _furnitureType;

  set furnitureType(FurnitureTypes? value) {
    _furnitureType = value;
  }

  Bedrooms? get bedroom => _bedroom;

  set bedroom(Bedrooms? value) {
    _bedroom = value;
  }
}
