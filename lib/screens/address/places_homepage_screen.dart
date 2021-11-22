import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rental_apartments_finder/models/places/place.dart';
import 'package:rental_apartments_finder/models/users/singned_account.dart';
import 'package:rental_apartments_finder/models/places/address.dart';
import 'package:rental_apartments_finder/providers/place_provider.dart';
import 'package:rental_apartments_finder/services/map_service.dart';
import 'package:rental_apartments_finder/widgets/progress.dart';
import 'package:rental_apartments_finder/widgets/rounded_loading_button.dart';
import 'package:rental_apartments_finder/widgets/search_slivers.dart';

class PlacesHomepageScreen extends StatefulWidget {
  PlacesHomepageScreen({Key? key}) : super(key: key);

  @override
  _PlacesHomepageScreenState createState() => _PlacesHomepageScreenState();
}

class _PlacesHomepageScreenState extends State<PlacesHomepageScreen> {
  late GoogleMapController googleMapController;
  GlobalKey<ScaffoldState> placesHomepageScreenKey =
      new GlobalKey<ScaffoldState>();

  MapService mapService = new MapService();
  late PlaceProvider placeProvider;

  late Position currentPosition;

  late DatabaseReference placeDBRef = FirebaseDatabase.instance.reference();

  Set<Polyline> polylinesSet = {};
  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};

  bool isSelectedDestination = false;

  double deviceHeight = 0.0;
  double deviceWidth = 0.0;
  double mapBottomPadding = 0.0;

  setCurrentPosition() async {
    currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    return currentPosition;
  }

  @override
  initState() {
    getPermission();
    setCurrentPosition();
    placeProvider = Provider.of<PlaceProvider>(context, listen: false);
    placeDBRef = FirebaseDatabase.instance.reference();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      key: placesHomepageScreenKey,
      body: Container(
        width: deviceWidth,
        child: FutureBuilder(
            future: setCurrentPosition(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Stack(
                  children: [
                    GoogleMap(
                      polylines: polylinesSet,
                      markers: markersSet,
                      circles: circlesSet,
                      padding: EdgeInsets.only(
                          bottom: mapBottomPadding,
                          top: MediaQuery.of(context).padding.top),
                      mapType: MapType.normal,
                      myLocationButtonEnabled: true,
                      myLocationEnabled: true,
                      zoomGesturesEnabled: true,
                      zoomControlsEnabled: true,
                      onTap: selectLocation,
                      initialCameraPosition:
                          CameraPosition(target: LatLng(1, 1), zoom: 0),
                      onMapCreated: (GoogleMapController controller) {
                        googleMapController = controller;
                        CameraPosition cameraPosition = new CameraPosition(
                            target: LatLng(currentPosition.latitude,
                                currentPosition.longitude),
                            zoom: 15);
                        googleMapController.animateCamera(
                            CameraUpdate.newCameraPosition(cameraPosition));
                        mapService.setupCurrentPositionLocation(
                            currentPosition, context);

                        updateYourOwnLocation();
                        setState(() {
                          mapBottomPadding = deviceHeight * 0.33;
                        });
                      },
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        child: SearchSlivers(
                          deviceHeight: deviceHeight,
                          deviceWidth: deviceWidth,
                          getDirection: drawDirectionPolyline,
                          setNewAddress: setNewAddress,
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return CircularProgress();
              }
            }),
      ),
    );
  }

  /*_________________________________   HELPER FUNCTIONS _________________________________ */
  Future<void> getPermission() async {
    await Permission.location.request();
  }

  Future<void> drawDirectionPolyline() async {
    polylinesSet.clear();
    markersSet.clear();
    circlesSet.clear();

    var placeProvider = Provider.of<PlaceProvider>(context, listen: false);

    Place destinationPlace = placeProvider.newAddress!;

    LatLng destinationLatLng =
        LatLng(destinationPlace.latitude!, destinationPlace.longitude!);

    if (destinationLatLng != null) {
      /*_________________________________ Set Marker and Circle_________________________________ */

      Marker destinationMarker = Marker(
        markerId: MarkerId('Address'),
        position: destinationLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
            title: destinationPlace.placeFormattedAddress,
            snippet: 'New Address'),
      );

      setState(() {
        markersSet.add(destinationMarker);
        isSelectedDestination = true;
        CameraPosition cameraPosition =
            CameraPosition(target: destinationLatLng, zoom: 15);
        googleMapController
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      });
    }
  }

  void resetMap() {
    setState(() {
      polylinesSet.clear();
      circlesSet.clear();
      markersSet.clear();
      isSelectedDestination = false;
      placeProvider.newAddress = null;
    });
  }

  void updateYourOwnLocation() {
    Geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 4,
    ).listen((Position position) async {
      currentPosition = position;
      mapService.setupCurrentPositionLocation(position, context);
      CameraPosition cameraPosition = new CameraPosition(
          target: LatLng(position.latitude, position.longitude), zoom: 15);
      googleMapController
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    });
  }

  void selectLocation(LatLng location) async {
    setState(() {
      Place newPlace =
          new Place(latitude: location.latitude, longitude: location.longitude);
      placeProvider.setNewPlace(newPlace);
      markersSet.add(new Marker(
          markerId: MarkerId(SignedAccount.instance.id!), position: location));
      CameraPosition cameraPosition =
          CameraPosition(target: location, zoom: 15);
      googleMapController
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    });
    await drawDirectionPolyline();
  }

  void setNewAddress(Address newAddress) async {
    Address.currentAddress = newAddress;
    Address.currentAddress!.address =
        placeProvider.newAddress!.placeFormattedAddress!;
    newAddress.latitude = placeProvider.newAddress!.latitude!;
    newAddress.longitude = placeProvider.newAddress!.longitude!;

    placeProvider.notifyListeners();
    await FirebaseFirestore.instance
        .collection('stores')
        .doc(SignedAccount.instance.id)
        .update(
      {
        'addressBook': FieldValue.arrayUnion(
          [
            {
              'id': newAddress.id,
              'address': newAddress.address,
              'name': newAddress.name,
              'ownerID': newAddress.ownerId,
              'latitude': newAddress.latitude,
              'longitude': newAddress.longitude,
            }
          ],
        ),
      },
    );
  }
}
