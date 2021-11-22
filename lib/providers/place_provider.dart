import 'package:flutter/material.dart';
import 'package:rental_apartments_finder/models/places/place.dart';

class PlaceProvider extends ChangeNotifier {
  Place? newAddress;

  void setNewPlace(Place newPlace) {
    newAddress = newPlace;
    notifyListeners();
  }
}
