import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rental_apartments_finder/models/store/property.dart';
import 'package:rental_apartments_finder/providers/dark_theme_provider.dart';
import 'package:rental_apartments_finder/providers/rentlist_provider.dart';
import 'package:rental_apartments_finder/screens/lessor/upload_property_screen.dart';
import 'package:rental_apartments_finder/screens/notes/note_edit_screen.dart';
import 'package:rental_apartments_finder/services/stores/properties_service.dart';

class MyPropertyItem extends StatefulWidget {
  Property property;

  MyPropertyItem(this.property, {Key? key}) : super(key: key);

  @override
  _MyPropertyItemState createState() => _MyPropertyItemState();
}

class _MyPropertyItemState extends State<MyPropertyItem> {
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

    return StreamBuilder<Object>(
      stream: FirebaseFirestore.instance
          .collection('products')
          .doc(widget.property.id)
          .snapshots(),
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          widget.property = Property.fromDocument(snapshot.data);
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
              rentListProvider.removeRentListItem(widget.property.id);
            }
          },
          child: Container(
            height: deviceHeight * 0.17,
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
                          height: deviceHeight * 0.17,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                            ),
                            child: GridTile(
                              child: GestureDetector(
                                onTap: () => {},
                                child: Image.network(
                                    widget.property.imageUrl![0],
                                    fit: BoxFit.cover),
                              ),
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
                                widget.property.name!,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                widget.property.rentPrice!.toString(),
                              ),
                              Spacer(
                                flex: 1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      margin: EdgeInsets.only(top: 15),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: EdgeInsets.all(15),
                          width: 70,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              bottomRight: Radius.circular(15),
                            ),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.all(0),
                            icon: Icon(Icons.sticky_note_2_sharp,
                                color: Colors.white),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => NoteEditScreen(
                                    referencesProperty: widget.property,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
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
                      onTap: () {},
                    ),
                  ),
                  Positioned(
                    right: 10,
                    bottom: deviceHeight * 0.17 / 2,
                    child: GestureDetector(
                      child: Container(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              padding: const EdgeInsets.all(0.0),
                              child: FaIcon(FontAwesomeIcons.edit,
                                  size: 20, color: Colors.orange),
                            ),
                            Text(
                              "edit",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.orange),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => UploadPropertyScreen(
                                property: widget.property)));
                      },
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
