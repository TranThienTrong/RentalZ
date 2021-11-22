import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_apartments_finder/models/store/property.dart';
import 'package:rental_apartments_finder/providers/dark_theme_provider.dart';

import '../progress.dart';

class WishlistItem extends StatefulWidget {
  String productID;
  WishlistItem(this.productID, {Key? key}) : super(key: key);

  @override
  _WishlistState createState() => _WishlistState();
}

class _WishlistState extends State<WishlistItem> {
  @override
  Widget build(BuildContext context) {
    var themeChange = Provider.of<DarkThemeProvider>(context);

    double deviceHeight = (MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top);
    double deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      height: deviceHeight * 0.17,
      width: deviceWidth,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5.0,
            spreadRadius: 0.025,
            offset: Offset(0.5, 0.5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 0, left: 0, top: 0, bottom: 0),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('products')
                      .doc(widget.productID)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      Property property = Property.fromDocument(snapshot.data);
                      return Row(
                        children: [
                          Container(
                            width: deviceWidth * 0.27,
                            height: deviceHeight * 0.17,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  bottomLeft: Radius.circular(15)),
                              child: GridTile(
                                child: GestureDetector(
                                    onTap: () => {},
                                    child: Image.network(property.imageUrl![0],
                                        fit: BoxFit.cover)),
                              ),
                            ),
                          ),
                          Container(
                            height: deviceHeight * 0.17,
                            padding: EdgeInsets.only(left: 15, top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  property.name!,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  property.rentPrice!.toString(),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return CircularProgress();
                    }
                  }),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: IconButton(
                icon: Icon(Icons.cancel_outlined, color: Colors.redAccent),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
