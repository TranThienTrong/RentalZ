import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:rental_apartments_finder/models/places/place.dart';
import 'package:rental_apartments_finder/models/places/predicted_place.dart';
import 'package:rental_apartments_finder/providers/place_provider.dart';

class MapService {
  static String GOOGLE_CLOUD_API_KEY =
      'AIzaSyB7G5FtGhn9ybJcO_DSQnsBNBMvJp_r9nY';

  /*______________________________ GET CURRENT POSITION ________________________________*/
  Future<Position> setupCurrentPositionLocation(
      Position currentPosition, BuildContext context) async {
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);

    String? currentAddress =
        await getAddress(currentPosition.latitude, currentPosition.longitude);
    Place place = new Place(
      placeName: currentAddress,
      latitude: currentPosition.latitude,
      longitude: currentPosition.longitude,
      placeFormattedAddress: currentAddress,
    );
    Provider.of<PlaceProvider>(context, listen: false).setNewPlace(place);

    return currentPosition;
  }

  /*______________________________ GET ADDRESS ________________________________*/
  Future<String?> getAddress(double latitude, double longitude) async {
    try {
      Uri url = Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$GOOGLE_CLOUD_API_KEY');

      http.Response response = await http.get(url);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        String address =
            json.decode(response.body)['results'][0]['formatted_address'];
        return address;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  /*______________________________ GET PREDICTED PLACE LIST ________________________________*/
  List getPredictedPlacesList(http.Response response) {
    Map valueMap = json.decode(response.body);
    List<dynamic> predictedPlaceList = valueMap['predictions'].map((item) {
      return PredictedPlace.fromJSON(item);
    }).toList();

    return predictedPlaceList;
  }

  /*================================ GET PLACE DETAIL ================================*/
  getPlaceDetail(String placeID, BuildContext context) async {
    Uri url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeID&key=$GOOGLE_CLOUD_API_KEY');

    http.Response response = await http.get(url);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      Place place = new Place();

      place.placeName = json.decode(response.body)['result']['name'];
      place.placeFormattedAddress =
          json.decode(response.body)['result']['formatted_address'];
      place.placeID = json.decode(response.body)['result']['place_id'];
      place.latitude =
          json.decode(response.body)['result']['geometry']['location']['lat'];
      place.longitude =
          json.decode(response.body)['result']['geometry']['location']['lng'];

      Provider.of<PlaceProvider>(context, listen: false).setNewPlace(place);
      print(Provider.of<PlaceProvider>(context, listen: false).newAddress);

      Navigator.pop(context, 'getDirection');
    } else {
      return null;
    }
  }
}
