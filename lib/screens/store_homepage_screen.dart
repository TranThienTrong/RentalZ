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
import 'stores/category_screen.dart';

class StoreHomepageScreen extends StatefulWidget {
  StoreHomepageScreen({Key? key}) : super(key: key);

  @override
  _StoreHomepageScreenState createState() => _StoreHomepageScreenState();
}

class _StoreHomepageScreenState extends State<StoreHomepageScreen> {
  final List<String> imgList = [
    "https://firebasestorage.googleapis.com/v0/b/rental-apartment-69e2b.appspot.com/o/images%2Fadvertisement_image%2F1.jpeg?alt=media&token=8be226c0-cb46-4da9-9708-5d8636c44395",
    "https://firebasestorage.googleapis.com/v0/b/rental-apartment-69e2b.appspot.com/o/images%2Fadvertisement_image%2F2.jpeg?alt=media&token=d22b04a6-65b2-4c69-b33a-5e00b57beb47",
    "https://firebasestorage.googleapis.com/v0/b/rental-apartment-69e2b.appspot.com/o/images%2Fadvertisement_image%2F3.jpeg?alt=media&token=0aab18bc-a9a1-43c8-b5bf-61a297b9ec93",
    "https://firebasestorage.googleapis.com/v0/b/rental-apartment-69e2b.appspot.com/o/images%2Fadvertisement_image%2F4.jpeg?alt=media&token=b12e0330-5b2b-4b50-b5e5-fbd7b50594b8",
    "https://firebasestorage.googleapis.com/v0/b/rental-apartment-69e2b.appspot.com/o/images%2Fadvertisement_image%2F5.jpeg?alt=media&token=44962fc1-9d92-48d2-bbf5-807b8ddf7cf1"
  ];

  @override
  Widget build(BuildContext context) {
    double deviceHeight = (MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top);
    double deviceWidth = MediaQuery.of(context).size.width;

    return BackdropScaffold(
      headerHeight: deviceHeight * 0.7,
      appBar: BackdropAppBar(
        title: Text("Rent"),
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
                    icon: Icon(Icons.message, size: deviceWidth * 0.075),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/messaging_main_screen');
                    },
                  ),
                );
              },
            ),
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
        child: Row(
          children: [],
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
