import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:rental_apartments_finder/constants/brand_colors.dart';
import 'package:rental_apartments_finder/providers/place_provider.dart';
import 'package:rental_apartments_finder/services/map_service.dart';
import 'dart:convert';

class PlacesSearchScreen extends StatefulWidget {
  PlacesSearchScreen({Key? key}) : super(key: key);

  @override
  _PlacesSearchScreenState createState() => _PlacesSearchScreenState();
}

class _PlacesSearchScreenState extends State<PlacesSearchScreen> {
  TextEditingController addressController = new TextEditingController();

  MapService mapService = new MapService();
  FocusNode focusNode = new FocusNode();

  List predictedPlacesList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    FocusScope.of(context).requestFocus(focusNode);
    super.didChangeDependencies();
  }

  void searchPlace(String placeName) async {
    if (placeName.trim().isNotEmpty) {
      Uri autoCompleteUrl = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=${MapService.GOOGLE_CLOUD_API_KEY}&language=vi&components=country:vn');

      http.Response response = await http.get(autoCompleteUrl);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        setState(() {
          predictedPlacesList = mapService.getPredictedPlacesList(response);
        });
      } else {
        return null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = (MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top);
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + deviceHeight * 0.02,
        ),
        height: deviceHeight * 0.85,
        width: deviceWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: [
                Positioned(
                  left: deviceWidth * 0.03,
                  child: GestureDetector(
                    child: Icon(Icons.arrow_back),
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                Center(
                  child: Text(
                    'Set Destination',
                    style: TextStyle(
                        fontSize: 17,
                        fontFamily: 'bolt',
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: deviceHeight * 0.03),
            ListTile(
              minLeadingWidth: 0,
              title: TextField(
                  focusNode: focusNode,
                  controller: addressController,
                  decoration: InputDecoration(
                    hintText: 'Choose Address',
                    fillColor: BrandColors.colorLightGrayFair,
                    filled: true,
                    isDense: true,
                    contentPadding:
                        EdgeInsets.only(left: 10, top: 7, bottom: 7),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    searchPlace(value);
                  }),
            ),
            Container(
              height: deviceHeight * 0.6,
              child: ListView.builder(
                itemCount: predictedPlacesList.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: ListTile(
                          leading: Icon(
                            Icons.place_outlined,
                            size: 17,
                          ),
                          minLeadingWidth: 0,
                          title: Text(predictedPlacesList[index].mainText),
                          subtitle:
                              Text(predictedPlacesList[index].secondaryText),
                        ),
                      ),
                      onTap: () {
                        showCupertinoDialog(
                          context: context,
                          builder: (context) => CupertinoAlertDialog(
                            title: Text(
                              "Here we go...",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        );
                        mapService.getPlaceDetail(
                            predictedPlacesList[index].placeID, context);
                        Navigator.pop(context);
                      });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
