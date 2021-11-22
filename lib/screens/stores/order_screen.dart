import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rental_apartments_finder/models/users/singned_account.dart';
import 'package:rental_apartments_finder/models/store/order.dart';
import 'package:rental_apartments_finder/models/store/property_in_rent_list.dart';
import 'package:rental_apartments_finder/widgets/progress.dart';

import 'checkout_screen.dart';

class OrderScreen extends StatefulWidget {
  OrderScreen({Key? key}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List<Order> orderList = [];

  @override
  Widget build(BuildContext context) {
    double deviceHeight = (MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top);
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: Text('Order')),
      body: Container(
        height: deviceHeight,
        color: Colors.black,
        child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('stores')
              .doc(SignedAccount.instance.id!)
              .get(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              DocumentSnapshot documentSnapshot = snapshot.data!;

              orderList = List<Order>.from(
                documentSnapshot['myOrders'].map(
                  (order) {
                    return Order.fromJson(order);
                  },
                ).toList(),
              );

              return CarouselSlider(
                options: CarouselOptions(
                  height: deviceHeight * 0.9,
                  initialPage: orderList.length,
                  enableInfiniteScroll: false,
                  reverse: false,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  scrollDirection: Axis.horizontal,
                ),
                items: orderList.map(
                  (order) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          margin: EdgeInsets.only(right: 5),
                          decoration: BoxDecoration(
                            color: Theme.of(context).backgroundColor,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: FutureBuilder(
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              return Container(
                                  width: deviceWidth,
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        child: Container(
                                          height: deviceHeight * 0.14,
                                          width: deviceWidth,
                                          padding: EdgeInsets.only(
                                              left: 0, right: 0, top: 5),
                                          margin: EdgeInsets.only(bottom: 5),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .backgroundColor,
                                            border:
                                                Border.all(color: Colors.white),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                top: 0,
                                                left: 10,
                                                child: Container(
                                                  width: deviceWidth * 0.7,
                                                  child: ListTile(
                                                    leading: Icon(Icons.place,
                                                        color:
                                                            Colors.redAccent),
                                                    minLeadingWidth: 0,
                                                    contentPadding:
                                                        EdgeInsets.all(0),
                                                    title: Text(order.address),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 0,
                                                left: 0,
                                                right: 0,
                                                child: Container(
                                                  width: deviceWidth,
                                                  height: 4.0,
                                                  child: CustomPaint(
                                                    painter:
                                                        ContainerPatternPainter(),
                                                    child: Container(),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: deviceHeight * (0.7),
                                        child: ListView.builder(
                                          itemCount: order
                                              .productsInRentListList.length,
                                          itemBuilder: (context, index) {
                                            PropertyInRentList
                                                productInRentList =
                                                order.productsInRentListList[
                                                    index];

                                            return Container(
                                              height: deviceHeight * 0.12,
                                              width: deviceWidth,
                                              margin: EdgeInsets.only(
                                                  top: 5,
                                                  bottom: 5,
                                                  left: 10,
                                                  right: 10),
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .backgroundColor,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15)),
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
                                                padding: const EdgeInsets.only(
                                                    right: 0,
                                                    left: 0,
                                                    top: 0,
                                                    bottom: 0),
                                                child: Stack(
                                                  children: [
                                                    Positioned(
                                                      left: 0,
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            width: deviceWidth *
                                                                0.27,
                                                            height:
                                                                deviceHeight *
                                                                    0.12,
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        15),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        15),
                                                              ),
                                                              child: GridTile(
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () =>
                                                                      {},
                                                                  child: Image.network(
                                                                      productInRentList
                                                                              .product
                                                                              .imageUrl![
                                                                          0],
                                                                      fit: BoxFit
                                                                          .cover),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            height:
                                                                deviceHeight *
                                                                    0.12,
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 15,
                                                                    top: 10),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  productInRentList
                                                                      .product
                                                                      .name!,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Text(
                                                                  productInRentList
                                                                      .product
                                                                      .rentPrice!
                                                                      .toString(),
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ));
                            },
                          ),
                        );
                      },
                    );
                  },
                ).toList(),
              );
            } else {
              return CircularProgress();
            }
          },
        ),
      ),
    );
  }
}
