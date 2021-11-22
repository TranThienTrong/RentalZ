class Place{
  String? placeID;
  String? placeName;
  double? latitude;
  double? longitude;
  String? placeFormattedAddress;

  Place({this.placeID, this.placeName, this.latitude, this.longitude,
      this.placeFormattedAddress});


  @override
  String toString() {
    return "$placeID!  $placeName  $placeFormattedAddress  $latitude    $longitude";
  }
}