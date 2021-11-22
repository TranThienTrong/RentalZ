import 'dart:convert';

class PredictedPlace {
  final String placeID;
  final String mainText;
  final String secondaryText;

  PredictedPlace(
      {required this.placeID,
      required this.mainText,
      required this.secondaryText});

  factory PredictedPlace.fromJSON(Map<String, dynamic> responseBody) {
    String placeID = responseBody['place_id'];
    String mainText = responseBody['structured_formatting']['main_text'];
    String secondaryText =
        responseBody['structured_formatting']['secondary_text'];

    return PredictedPlace(
        placeID: placeID, mainText: mainText, secondaryText: secondaryText);
  }

  String toString() {
    return placeID + " " + mainText + " " + secondaryText;
  }
}
