import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_apartments_finder/models/store/property.dart';
import 'package:rental_apartments_finder/providers/rentlist_provider.dart';
import 'package:rental_apartments_finder/screens/properties/property_detail_body_screen.dart';

class PropertyDetailScreen extends StatefulWidget {
  Property property;

  PropertyDetailScreen({required this.property, Key? key}) : super(key: key);

  @override
  _PropertyDetailScreenState createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  @override
  Widget build(BuildContext context) {
    double deviceHeight = (MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top);
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(4.5),
      body: ChangeNotifierProvider.value(
        value: widget.property,
        child: PropertyDetailBodyScreen(
          property: widget.property,
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  double rating;

  CustomAppBar(this.rating) : preferredSize = Size.fromHeight(60.0);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Consumer<RentListProvider>(
            builder: (_, rentListProvider, iconButton) {
              return Badge(
                toAnimate: true,
                animationType: BadgeAnimationType.scale,
                shape: BadgeShape.circle,
                badgeColor: Colors.red,
                position: BadgePosition.topEnd(top: 2, end: 5),
                badgeContent: Text(
                  rentListProvider.rentListItemQuantity.toString(),
                  style: TextStyle(color: Colors.white),
                ),
                child: IconButton(
                  icon: Icon(Icons.shopping_bag, color: Colors.black),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/RentList_screen');
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
