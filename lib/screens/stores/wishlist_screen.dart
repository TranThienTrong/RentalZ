import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_apartments_finder/providers/rentlist_provider.dart';
import 'package:rental_apartments_finder/providers/wishlist_provider.dart';
import 'package:rental_apartments_finder/screens/stores/rent_list_screen.dart';
import 'package:rental_apartments_finder/widgets/property_item/wishlist_item.dart';
import 'package:rental_apartments_finder/widgets/rounded_loading_button.dart';

class WishlistScreen extends StatefulWidget {
  WishlistScreen({Key? key}) : super(key: key);

  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    WishlistProvider wishlistProvider = Provider.of<WishlistProvider>(context);
    RentListProvider rentlistProvider = Provider.of<RentListProvider>(context);
    Set<String> productList = wishlistProvider.wishlistItemList;

    AppBar appbar = AppBar(
      title: Text("Wishlist"),
    );

    double deviceHeight = (MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top) -
        appbar.preferredSize.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: appbar,
      body: Container(
        height: deviceHeight * (0.8),
        child: ListView.builder(
          itemCount: productList.length,
          itemBuilder: (context, index) {
            return WishlistItem(productList.elementAt(index));
          },
        ),
      ),
      bottomSheet: Container(
        width: deviceWidth,
        height: deviceHeight * 0.075,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 5.0,
              spreadRadius: 0.025,
              offset: Offset(0.5, 0.5),
            ),
          ],
        ),
        child: Container(
          child: RoundedLoadingButton(
            onPressed: () async {
              wishlistProvider.wishlistItemList.forEach((propertyId) async {
                await rentlistProvider.addRentListItem(propertyId);
              });

              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => RentListScreen()));
            },
            height: 35,
            color: Colors.blue,
            valueColor: Colors.white,
            width: deviceWidth,
            controller: new RoundedLoadingButtonController(),
            borderColor: Colors.transparent,
            child: Text("To Rent List"),
          ),
        ),
      ),
    );
  }
}
