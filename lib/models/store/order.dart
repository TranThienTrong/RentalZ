import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:rental_apartments_finder/models/store/property.dart';
import 'package:rental_apartments_finder/models/store/property_in_rent_list.dart';

import '../places/address.dart';

class Order with ChangeNotifier {
  String id;
  String buyerId;
  String address;
  String? note;
  double totalPrice;
  List<PropertyInRentList> productsInRentListList;
  DateTime orderedTime;

  Order(
      {required this.id,
      required this.buyerId,
      required this.address,
      this.note,
      required this.totalPrice,
      required this.productsInRentListList,
      required this.orderedTime});

  factory Order.fromJson(Map<String, dynamic> json) {
    List<PropertyInRentList> productsInRentList =
        List<PropertyInRentList>.from(json['productsList'].map((product) {
      return PropertyInRentList(
          product: Property.fromJson(product),
          quantity: product['quantityBought']);
    }).toList());

    return Order(
      id: json["id"],
      address: json['address'],
      buyerId: json['buyerID'],
      orderedTime: json['orderedTime'].toDate(),
      totalPrice: json['totalPrice'].toDouble(),
      productsInRentListList: productsInRentList,
    );
  }

  factory Order.fromDocument(DocumentSnapshot document) {
    List<PropertyInRentList> productsInRentList =
        List<PropertyInRentList>.from(document['productsList'].map((product) {
      return PropertyInRentList(
          product: Property.fromJson(product),
          quantity: product['quantityBought']);
    }).toList());

    return Order(
      id: document["id"],
      address: document['address'],
      buyerId: document['buyerID'],
      orderedTime: document['orderedTime'].toDate(),
      totalPrice: document['totalPrice'].toDouble(),
      productsInRentListList: productsInRentList,
    );
  }

  toString() {
    return " id: $id, address: $address, buyerId: $buyerId, product list: $productsInRentListList";
  }
}
