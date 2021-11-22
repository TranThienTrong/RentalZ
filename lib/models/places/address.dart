import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:rental_apartments_finder/models/users/singned_account.dart';
import 'package:uuid/uuid.dart';

enum AddressTypes { HOME, OFFICE }

class Address with ChangeNotifier {
  late String? id;
  late String? ownerId;
  late String? address;
  late String? name;
  late double? latitude;
  late double? longitude;
  AddressTypes? placeType;

  static Address? currentAddress;

  setCurrentAddress(Address? value) {
    Address.currentAddress = value;
    notifyListeners();
  }

  static init() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('stores')
        .doc(SignedAccount.instance.id!)
        .get();
    if (documentSnapshot['addressBook'].length > 0) {
      Address.currentAddress = documentSnapshot['addressBook'][0];
    }
  }

  Address(
      {this.id,
      this.ownerId,
      this.address,
      this.name,
      this.latitude,
      this.longitude,
      this.placeType});

  factory Address.empty() {
    return Address(
        id: Uuid().v4(),
        ownerId: SignedAccount.instance.id!,
        address: '',
        name: '',
        placeType: AddressTypes.HOME);
  }

  factory Address.fromJson(Map<String, dynamic> json) {
    late AddressTypes placeType;
    switch (json['placeType']) {
      case 'home':
        placeType = AddressTypes.HOME;
        break;
      case 'office':
        placeType = AddressTypes.OFFICE;
        break;
      default:
        placeType = AddressTypes.OFFICE;
        break;
    }

    return Address(
        id: json['id'],
        ownerId: json['ownerID'],
        address: json['address'],
        name: json['name'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        placeType: placeType);
  }

  @override
  String toString() {
    return " id: $id, owner: $ownerId, address: $address, name: $name";
  }
}
