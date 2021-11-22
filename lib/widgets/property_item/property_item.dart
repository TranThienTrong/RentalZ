import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_apartments_finder/models/store/property.dart';
import 'package:rental_apartments_finder/providers/rentlist_provider.dart';
import 'package:rental_apartments_finder/providers/wishlist_provider.dart';
import 'package:rental_apartments_finder/screens/properties/property_detail_main_screen.dart';

class ProductItem extends StatelessWidget {
  late Property property;

  ProductItem(this.property);

  @override
  Widget build(BuildContext context) {
    double deviceHeight = (MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top);
    double deviceWidth = MediaQuery.of(context).size.width;

    /* ___________________________ Provider __________________________ */
    RentListProvider rentList = Provider.of<RentListProvider>(context);
    WishlistProvider wishlist = Provider.of<WishlistProvider>(context);

    return GestureDetector(
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(0),
            margin: EdgeInsets.all(0),
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
            child: Column(
              children: [
                Container(
                  width: deviceHeight * 0.25,
                  height: deviceHeight * 0.13,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    child: GridTile(
                      child: GestureDetector(
                        onTap: () => {},
                        child: Image.network(property.imageUrl![0],
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
                Container(
                    width: deviceWidth,
                    margin: EdgeInsets.all(4),
                    alignment: Alignment.center,
                    child: Text(property.name!)),
                Container(
                  width: deviceWidth,
                  child: ListTile(
                    minVerticalPadding: 0,
                    contentPadding: EdgeInsets.all(0),
                    leading: Text(property.rentPrice.toString()),
                    trailing: Container(
                      padding: EdgeInsets.all(0),
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            padding: EdgeInsets.all(0),
                            icon: wishlist.wishlistItemList
                                    .contains(property.id)
                                ? const Icon(Icons.favorite,
                                    color: Colors.red, size: 20)
                                : const Icon(Icons.favorite_border, size: 20),
                            onPressed: () {
                              property.toggleFavourite();
                              if (property.isFavourite == true) {
                                wishlist.addWishlistItem(property.id);
                              } else {
                                wishlist.removeWishlistItem(property.id);
                              }
                            },
                          ),
                          IconButton(
                            padding: EdgeInsets.all(0),
                            icon: rentList.rentListItemList.keys
                                    .contains(property.id)
                                ? Icon(Icons.shopping_cart,
                                    color: Colors.amber, size: 20)
                                : Icon(Icons.shopping_cart_outlined, size: 20),
                            onPressed: () {
                              rentList.addRentListItem(property.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Add to rent_list'),
                                  duration: Duration(seconds: 3),
                                  action: SnackBarAction(
                                    label: 'Undo',
                                    onPressed: () {
                                      rentList
                                          .decreaseRentListItem(property.id);
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: Badge(
              toAnimate: true,
              shape: BadgeShape.square,
              badgeColor: Colors.redAccent,
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(15)),
              badgeContent: Text(
                'NEW',
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),
        ],
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider.value(
              value: property,
              child: PropertyDetailScreen(
                property: property,
              ),
            ),
          ),
        );
      },
    );
  }
}
