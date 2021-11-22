import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_apartments_finder/models/users/singned_account.dart';
import 'package:rental_apartments_finder/models/store/property.dart';
import 'package:rental_apartments_finder/providers/property_list_provider.dart';
import 'package:rental_apartments_finder/screens/lessor/upload_property_screen.dart';
import 'package:rental_apartments_finder/services/stores/properties_service.dart';
import 'package:rental_apartments_finder/widgets/progress.dart';
import 'package:rental_apartments_finder/widgets/property_item/my_property_item.dart';

class LessorHomepageScreen extends StatefulWidget {
  LessorHomepageScreen({Key? key}) : super(key: key);

  @override
  _LessorHomepageScreenState createState() => _LessorHomepageScreenState();
}

class _LessorHomepageScreenState extends State<LessorHomepageScreen> {
  FirebasePropertyService productService = FirebasePropertyService();
  List<Property> myProductsList = [];

  double deviceHeight = 0.0;
  double deviceWidth = 0.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    PropertiesListProvider productsListProvider =
        Provider.of<PropertiesListProvider>(context);
    List<Property> myProductsList =
        productsListProvider.getPropertyList().where(
      (element) {
        if (element.ownerId != SignedAccount.instance.id) {
          return false;
        } else {
          return true;
        }
      },
    ).toList();

    deviceHeight = (MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top);
    deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: deviceHeight * 0.9,
        width: deviceWidth,
        child: Stack(
          children: [
            FutureBuilder(
              future: productService.findUserProductsList(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.hasData) {
                  productsListProvider.propertyList =
                      List<Property>.from(snapshot.data!);
                  return Positioned(
                    child: Container(
                      margin: EdgeInsets.only(top: 60, left: 5, right: 5),
                      child: ListView.builder(
                        itemCount: productsListProvider.propertyList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return MyPropertyItem(
                              productsListProvider.propertyList[index]);
                        },
                      ),
                    ),
                  );
                } else {
                  return CircularProgress();
                }
              },
            ),
            Positioned(
              right: 0,
              top: 32,
              child: Container(
                padding: EdgeInsets.all(0),
                width: 75,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    bottomLeft: Radius.circular(40),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.add_business,
                          size: deviceWidth * 0.07, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                UploadPropertyScreen(property: null),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 32,
              child: Container(
                margin: EdgeInsets.only(left: 12),
                width: deviceWidth * 0.75,
                height: deviceHeight * 0.08,
                child: TextField(
                  autocorrect: false,
                  style: TextStyle(color: Colors.blue),
                  decoration: new InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).backgroundColor,
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.blue,
                    ),
                    hintText: 'Title',
                    contentPadding: const EdgeInsets.only(left: 17.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.blue),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 1.0,
                      ),
                    ),
                  ),
                  onSubmitted: (value) {
                    setState(() {
                      // searchName = value;
                      // print(searchName);
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
