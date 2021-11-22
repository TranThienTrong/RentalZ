import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rental_apartments_finder/models/users/my_user.dart';
import 'package:rental_apartments_finder/models/store/category.dart';
import 'package:rental_apartments_finder/models/store/property.dart';
import 'package:rental_apartments_finder/services/user_service.dart';
import 'package:rental_apartments_finder/services/stores/properties_service.dart';
import 'package:rental_apartments_finder/widgets/progress.dart';
import 'package:rental_apartments_finder/widgets/property_item/property_item.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen();

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  double deviceHeight = 0.0;
  double deviceWidth = 0.0;

  String? searchName;
  PropertyTypes? propertyValue;
  FurnitureTypes? furnitureValue;
  Bedrooms? bedroomValue;
  FirebaseUserService userService = new FirebaseUserService();
  FirebasePropertyService propertyService = new FirebasePropertyService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(context) {
    deviceHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            SearchBar(),
            (searchName == null || searchName!.isEmpty)
                ? StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('products')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData) {
                        QuerySnapshot querySnapshot = snapshot.data;

                        return usersContactListView(
                            handleTypeSearch(querySnapshot));
                      } else {
                        return CircularProgress();
                      }
                    },
                  )
                : StreamBuilder(
                    stream: propertyService
                        .getPropertyStreamByDisplayName(searchName!),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData) {
                        QuerySnapshot querySnapshot = snapshot.data;
                        return usersContactListView(
                            handleTypeSearch(querySnapshot));
                        ;
                      } else {
                        return CircularProgress();
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget SearchBar() {
    return Container(
      height: deviceHeight * 0.165,
      decoration: BoxDecoration(
        color: Colors.blue,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: deviceHeight * 0.085,
            width: deviceWidth,
            padding: EdgeInsets.only(
                top: deviceHeight * 0.0175,
                right: deviceWidth * 0.04,
                left: deviceWidth * 0.04),
            child: Container(
              margin: EdgeInsets.only(top: 15),
              child: TextFormField(
                autocorrect: false,
                style: TextStyle(color: Colors.blue),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: Icon(Icons.cancel, size: 20),
                  filled: true,
                  fillColor: Theme.of(context).backgroundColor,
                  hintText: 'Search',
                  contentPadding:
                      const EdgeInsets.only(left: 17.0, top: 5, bottom: 5),
                  focusedBorder: OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.blue),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 1.0,
                    ),
                  ),
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (value) {
                  setState(() => searchName = value);
                },
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 16, top: 5, right: 10),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5, left: 5),
                  margin: EdgeInsets.only(right: 2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                  child: DropdownButton<PropertyTypes>(
                    value: propertyValue,
                    focusColor: Colors.white,
                    iconEnabledColor: Colors.blue,
                    dropdownColor: Colors.white,
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 11,
                    ),
                    isDense: true,
                    icon: Icon(Icons.arrow_drop_down),
                    hint: Text(
                      "Choose Property",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                      ),
                    ),
                    items: PropertyTypes.values
                        .map<DropdownMenuItem<PropertyTypes>>(
                      (PropertyTypes value) {
                        return DropdownMenuItem<PropertyTypes>(
                          value: value,
                          child: Text(EnumToString.convertToString(value)),
                        );
                      },
                    ).toList(),
                    onChanged: (PropertyTypes? newValue) {
                      setState(() => propertyValue = newValue!);
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5, left: 10),
                  margin: EdgeInsets.only(right: 2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                  child: DropdownButton<FurnitureTypes>(
                    value: furnitureValue,
                    focusColor: Colors.white,
                    iconEnabledColor: Colors.blue,
                    dropdownColor: Colors.white,
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 11,
                    ),
                    isDense: true,
                    hint: Text(
                      "Choose Furniture",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                      ),
                    ),
                    icon: Icon(Icons.arrow_drop_down),
                    items: FurnitureTypes.values
                        .map<DropdownMenuItem<FurnitureTypes>>(
                      (FurnitureTypes value) {
                        return DropdownMenuItem<FurnitureTypes>(
                          value: value,
                          alignment: AlignmentDirectional.center,
                          child: Text(
                            EnumToString.convertToString(value),
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    ).toList(),
                    onChanged: (FurnitureTypes? newValue) {
                      setState(() => furnitureValue = newValue!);
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                  child: DropdownButton<Bedrooms>(
                    value: bedroomValue,
                    focusColor: Colors.white,
                    iconEnabledColor: Colors.blue,
                    dropdownColor: Colors.white,
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 11,
                    ),
                    isDense: true,
                    hint: Text(
                      "Choose Bedrooms",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                      ),
                    ),
                    icon: Icon(Icons.arrow_drop_down),
                    items: Bedrooms.values.map<DropdownMenuItem<Bedrooms>>(
                      (Bedrooms value) {
                        return DropdownMenuItem<Bedrooms>(
                          value: value,
                          alignment: AlignmentDirectional.center,
                          child: Text(
                            EnumToString.convertToString(value),
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    ).toList(),
                    onChanged: (Bedrooms? newValue) {
                      setState(() => bedroomValue = newValue!);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget usersContactListView(List<Property> propertiesList) {
    return Container(
      height: deviceHeight - (deviceHeight * 0.08) - 110,
      child: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(20),
        childAspectRatio: 0.8,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        children: propertiesList
            .map((product) => ChangeNotifierProvider.value(
                  value: product,
                  child: ProductItem(product),
                ))
            .toList(),
      ),
    );
  }

  List<Property> handleTypeSearch(QuerySnapshot querySnapshot) {
    List<Property> propertyList = [];
    Set<String> totalList = Set<String>();
    Set<String> propertiesList = Set<String>();
    Set<String> furnitureList = Set<String>();

    if (propertyValue != null) {
      querySnapshot.docs.forEach((element) {
        if (EnumToString.fromString(
                PropertyTypes.values, element['propertyType']) ==
            propertyValue) {
          propertiesList.add(element['id']);
          totalList.add(element['id']);
        }
      });
    }
    if (furnitureValue != null) {
      querySnapshot.docs.forEach((element) {
        if (EnumToString.fromString(
                FurnitureTypes.values, element['furnitureType']) ==
            furnitureValue) {
          furnitureList.add(element['id']);
          totalList.add(element['id']);
        }
      });
    }
    if (furnitureValue == null && propertyValue == null) {
      querySnapshot.docs.forEach((element) {
        totalList.add(element['id']);
      });
    }

    if (furnitureValue != null) {
      totalList = totalList.intersection(furnitureList);
    }
    if (propertyValue != null) {
      totalList = totalList.intersection(propertiesList);
    }

    propertyList = querySnapshot.docs
        .where((document) => totalList.contains(document['id']))
        .map((document) => Property.fromDocument(document))
        .toList();

    return propertyList;
  }
}
