import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_apartments_finder/models/store/property.dart';
import 'package:rental_apartments_finder/providers/property_list_provider.dart';
import 'package:rental_apartments_finder/providers/rentlist_provider.dart';
import 'package:rental_apartments_finder/providers/wishlist_provider.dart';
import 'package:rental_apartments_finder/services/stores/properties_service.dart';
import 'package:rental_apartments_finder/widgets/progress.dart';
import 'package:rental_apartments_finder/widgets/property_item/property_item.dart';

enum FilterProduct { Favorite, All }

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  PropertiesListProvider? productsListProvider;
  FilterProduct filter = FilterProduct.All;
  FirebasePropertyService productService = FirebasePropertyService();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (productsListProvider == null) {
      productsListProvider = Provider.of<PropertiesListProvider>(context);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = (MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top);
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Explore'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (FilterProduct selectedItem) {
              setState(
                () {
                  switch (selectedItem) {
                    case FilterProduct.Favorite:
                      filter = FilterProduct.Favorite;
                      break;
                    case FilterProduct.All:
                      filter = FilterProduct.All;
                      break;
                  }
                },
              );
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                  child: Text('Favorite'), value: FilterProduct.Favorite),
              PopupMenuItem(child: Text('All'), value: FilterProduct.All),
            ],
          ),
          Container(
            margin: EdgeInsets.only(right: 0),
            child: Consumer<WishlistProvider>(
              builder: (_, wishlistProvider, iconButton) {
                return Badge(
                  toAnimate: true,
                  animationType: BadgeAnimationType.scale,
                  shape: BadgeShape.circle,
                  badgeColor: Colors.red,
                  position: BadgePosition.topEnd(top: 2, end: 2),
                  badgeContent: Text(
                    wishlistProvider.wishlistItemQuantity.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                  child: IconButton(
                    icon:
                        Icon(Icons.favorite_rounded, size: deviceWidth * 0.075),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/wishlist_screen');
                    },
                  ),
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 3),
            child: Consumer<RentListProvider>(
              builder: (_, rentListProvider, iconButton) {
                return Badge(
                  toAnimate: false,
                  animationType: BadgeAnimationType.scale,
                  shape: BadgeShape.circle,
                  badgeColor: Colors.red,
                  position: BadgePosition.topEnd(top: 2, end: 5),
                  badgeContent: Text(
                    rentListProvider.rentListItemQuantity.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.shopping_bag, size: deviceWidth * 0.075),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/RentList_screen');
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            QuerySnapshot querySnapshot = snapshot.data!;
            productsListProvider!.propertyList = querySnapshot.docs
                .map((document) => Property.fromDocument(document))
                .toList();

            return Container(
              child: RefreshIndicator(
                onRefresh: refresh,
                child: Container(
                  child: GridView.count(
                    crossAxisCount: 2,
                    padding: EdgeInsets.all(20),
                    childAspectRatio: 0.8,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    children: productsListProvider!.propertyList
                        .where((element) {
                          if (filter == FilterProduct.Favorite) {
                            print(element);
                            if (element.isFavourite) {
                              return true;
                            } else {
                              return false;
                            }
                          }
                          return true;
                        })
                        .map(
                          (product) => ChangeNotifierProvider.value(
                            value: product,
                            child: ProductItem(product),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            );
          } else {
            return CircularProgress();
          }
        },
      ),
    );
  }

  Future<void> refresh() async {}
}
