import 'package:backdrop/app_bar.dart';
import 'package:backdrop/button.dart';
import 'package:backdrop/scaffold.dart';
import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_apartments_finder/models/store/category.dart';
import 'package:rental_apartments_finder/providers/rentlist_provider.dart';
import 'package:rental_apartments_finder/providers/wishlist_provider.dart';
import 'package:rental_apartments_finder/widgets/progress.dart';
import 'package:rental_apartments_finder/widgets/store/category_item.dart';

import 'category_screen.dart';

class StoreHomepageScreen extends StatefulWidget {
  StoreHomepageScreen({Key? key}) : super(key: key);

  @override
  _StoreHomepageScreenState createState() => _StoreHomepageScreenState();
}

class _StoreHomepageScreenState extends State<StoreHomepageScreen> {
  final List<String> imgList = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  ];

  @override
  Widget build(BuildContext context) {
    double deviceHeight = (MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top);
    double deviceWidth = MediaQuery.of(context).size.width;

    // CategoriesListProvider categoriesListProvider =
    //     Provider.of<CategoriesListProvider>(context);

    return BackdropScaffold(
      headerHeight: deviceHeight * 0.7,
      appBar: BackdropAppBar(
        title: Text("Backdrop Example"),
        leading: BackdropToggleButton(
          icon: AnimatedIcons.arrow_menu,
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(color: Colors.blue),
        ),
        actions: [
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
              builder: (_, RentListProvider, iconButton) {
                return Badge(
                  toAnimate: false,
                  animationType: BadgeAnimationType.scale,
                  shape: BadgeShape.circle,
                  badgeColor: Colors.red,
                  position: BadgePosition.topEnd(top: 2, end: 5),
                  badgeContent: Text(
                    RentListProvider.rentListItemQuantity.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.house, size: deviceWidth * 0.075),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/RentList_screen');
                    },
                  ),
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 3),
            child: Badge(
              toAnimate: false,
              animationType: BadgeAnimationType.scale,
              shape: BadgeShape.circle,
              badgeColor: Colors.red,
              position: BadgePosition.topEnd(top: 2, end: 5),
              badgeContent: Text(
                '0',
                style: TextStyle(color: Colors.white),
              ),
              child: IconButton(
                icon: Icon(Icons.notifications, size: deviceWidth * 0.075),
                onPressed: () {
                  Navigator.of(context).pushNamed('/notification_screen');
                },
              ),
            ),
          ),
        ],
      ),
      backLayer: Container(
        color: Colors.blue,
        child: Center(
          child: Text("Back Layer"),
        ),
      ),
      frontLayer: Container(
        height: deviceHeight * 0.8,
        width: deviceWidth,
        child: Column(
          children: [
            Container(
              height: deviceHeight * 0.2,
              margin: EdgeInsets.only(top: 1, bottom: 10),
              child: CarouselSlider(
                options: CarouselOptions(
                  height: deviceHeight * 0.2,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.8,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                ),
                items: imgList.map(
                  (image) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).backgroundColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 0.25,
                                spreadRadius: 0.025,
                                offset: Offset(0.5, 0.5),
                              ),
                            ],
                          ),
                          width: MediaQuery.of(context).size.width * 0.95,
                          margin: EdgeInsets.symmetric(horizontal: 0),
                          child: GestureDetector(
                            onTap: () => {},
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                              child: GridTile(
                                child: GestureDetector(
                                    onTap: () => {},
                                    child: Image.network(image,
                                        fit: BoxFit.cover)),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ).toList(),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 10, left: 20),
              alignment: Alignment.topLeft,
              child: Text(
                "Categories",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              width: deviceWidth,
              height: deviceWidth * 0.25,
              child: FutureBuilder(
                future:
                    FirebaseFirestore.instance.collection('categories').get(),
                builder: (context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    QuerySnapshot querySnapshot = snapshot.data;

                    List<CategoryItem> categoriesItemList =
                        querySnapshot.docs.map((document) {
                      Category category = Category.fromDocument(document);
                      return CategoryItem(category);
                    }).toList();

                    List<Category> categoriesList =
                        querySnapshot.docs.map((document) {
                      return Category.fromDocument(document);
                      ;
                    }).toList();

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categoriesItemList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            width: deviceWidth * 0.30,
                            height: deviceHeight * 0.30,
                            child: categoriesItemList[index],
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CategoryScreen(
                                    category: categoriesList[index]),
                              ),
                            );
                          },
                        );
                      },
                    );
                  } else {
                    return CircularProgress();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
