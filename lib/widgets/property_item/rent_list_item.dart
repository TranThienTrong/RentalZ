import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_apartments_finder/models/store/property.dart';
import 'package:rental_apartments_finder/models/store/property_in_rent_list.dart';
import 'package:rental_apartments_finder/providers/dark_theme_provider.dart';
import 'package:rental_apartments_finder/providers/rentlist_provider.dart';
import 'package:rental_apartments_finder/services/stores/properties_service.dart';

class RentListItem extends StatefulWidget {
  PropertyInRentList productInRentList;
  ProductStages? productStages;

  RentListItem(this.productInRentList, {this.productStages, Key? key})
      : super(key: key);

  @override
  _RentListItemState createState() => _RentListItemState();
}

class _RentListItemState extends State<RentListItem> {
  late RentListProvider rentListProvider;
  FirebasePropertyService productService = new FirebasePropertyService();

  @override
  void didChangeDependencies() {
    rentListProvider = Provider.of<RentListProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var themeChange = Provider.of<DarkThemeProvider>(context);
    bool confirmDismiss = false;
    double deviceHeight = (MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top);
    double deviceWidth = MediaQuery.of(context).size.width;

    Property product = widget.productInRentList.product;

    return StreamBuilder<Object>(
      stream: FirebaseFirestore.instance
          .collection('products')
          .doc(product.id)
          .snapshots(),
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          product = Property.fromDocument(snapshot.data);
        }
        return Dismissible(
          key: UniqueKey(),
          background: Container(
            color: Theme.of(context).errorColor,
            alignment: Alignment.centerRight,
            child: Icon(Icons.delete, color: Colors.white, size: 40),
          ),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) {
            return showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: Text('Delete this product?'),
                actions: [
                  ElevatedButton(
                    child: Text('Yes'),
                    onPressed: () {
                      confirmDismiss = true;
                      Navigator.of(context).pop(true);
                    },
                  ),
                  ElevatedButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      confirmDismiss = false;
                      Navigator.of(context).pop(false);
                    },
                  ),
                ],
              ),
            );
          },
          onDismissed: (DismissDirection dismissDirection) async {
            if (confirmDismiss == true) {
              rentListProvider
                  .removeRentListItem(widget.productInRentList.product.id);
            }
          },
          child: Container(
            height: widget.productStages == ProductStages.IN_CHECKOUT
                ? deviceHeight * 0.12
                : deviceHeight * 0.17,
            width: deviceWidth,
            margin: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
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
              padding:
                  const EdgeInsets.only(right: 0, left: 0, top: 0, bottom: 0),
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Row(
                      children: [
                        Container(
                          width: deviceWidth * 0.27,
                          height: (widget.productStages ==
                                  ProductStages.IN_CHECKOUT)
                              ? deviceHeight * 0.12
                              : deviceHeight * 0.17,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                            ),
                            child: GridTile(
                              child: GestureDetector(
                                onTap: () => {},
                                child: Image.network(product.imageUrl![0],
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: (widget.productStages ==
                                  ProductStages.IN_CHECKOUT)
                              ? deviceHeight * 0.12
                              : deviceHeight * 0.17,
                          padding: EdgeInsets.only(left: 15, top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                product.name!,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                product.rentPrice!.toString(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 5,
                    child: GestureDetector(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(0.0),
                            width: 18.0,
                            child: Icon(Icons.keyboard_arrow_left,
                                color: Colors.redAccent),
                          ),
                          Text(
                            'delete',
                            style: TextStyle(
                                fontSize: 15, color: Colors.redAccent),
                          )
                        ],
                      ),
                      onTap: () {
                        rentListProvider.removeRentListItem(
                            widget.productInRentList.product.id);
                      },
                    ),
                  ),
                  if (widget.productStages == ProductStages.IN_CHECKOUT)
                    Container()
                  else
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_left,
                                  size: 45, color: Colors.blueAccent),
                              onPressed: () {
                                rentListProvider
                                    .decreaseRentListItem(product.id);
                              },
                            ),
                            Container(
                              width: 5,
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: widget.productInRentList.quantity
                                      .toString(),
                                  fillColor: Theme.of(context).backgroundColor,
                                  filled: true,
                                  contentPadding: EdgeInsets.all(0),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.arrow_right,
                                  size: 45, color: Colors.blueAccent),
                              onPressed: () {
                                rentListProvider.addRentListItem(product.id);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
