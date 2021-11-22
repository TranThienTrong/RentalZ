import 'package:flutter/material.dart';
import 'package:patterns_canvas/patterns_canvas.dart';
import 'package:provider/provider.dart';
import 'package:rental_apartments_finder/models/places/address.dart';
import 'package:rental_apartments_finder/models/store/property.dart';
import 'package:rental_apartments_finder/models/store/property_in_rent_list.dart';
import 'package:rental_apartments_finder/providers/rentlist_provider.dart';
import 'package:rental_apartments_finder/screens/address/address_book_screen.dart';
import 'package:rental_apartments_finder/services/notifications/notification_service.dart';
import 'package:rental_apartments_finder/services/notifications/push_notification_service.dart';
import 'package:rental_apartments_finder/services/stores/properties_service.dart';
import 'package:rental_apartments_finder/services/stores/order_service.dart';
import 'package:rental_apartments_finder/widgets/property_item/rent_list_item.dart';
import 'package:rental_apartments_finder/widgets/rounded_loading_button.dart';
import 'package:uuid/uuid.dart';

class CheckoutScreen extends StatefulWidget {
  CheckoutScreen({Key? key}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  Uuid uuid = new Uuid();
  RoundedLoadingButtonController controller =
      new RoundedLoadingButtonController();

  OrderService orderService = OrderService();
  PushNotificationService pushNotificationService = PushNotificationService();
  NotificationService storeNotificationService = NotificationService();

  late RentListProvider rentListProvider;
  late Map<String, PropertyInRentList> rentListList;
  late List<PropertyInRentList> productsInRentListList;

  initState() {
    super.initState();
  }

  didChangeDependencies() {
    rentListProvider = Provider.of<RentListProvider>(context);
    rentListList = rentListProvider.rentListItemList;
    productsInRentListList = rentListList.values.toList();
    super.didChangeDependencies();
  }

  FirebasePropertyService productService = FirebasePropertyService();

  @override
  Widget build(BuildContext context) {
    Address addressProvider = Provider.of<Address>(context);

    AppBar appbar = AppBar(
      title: Text("Checkout"),
    );

    double deviceHeight = (MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top) -
        appbar.preferredSize.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: appbar,
      body: Column(
        children: [
          GestureDetector(
            child: Container(
              height: deviceHeight * 0.14,
              width: deviceWidth,
              padding: EdgeInsets.only(left: 0, right: 0, top: 5),
              margin: EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Stack(
                children: [
                  Address.currentAddress != null
                      ? Positioned(
                          top: 0,
                          left: 10,
                          child: Container(
                            width: deviceWidth * 0.9,
                            child: ListTile(
                              leading:
                                  Icon(Icons.place, color: Colors.redAccent),
                              minLeadingWidth: 0,
                              contentPadding: EdgeInsets.all(0),
                              title:
                                  Text(Address.currentAddress!.name.toString()),
                              subtitle: Text(
                                  Address.currentAddress!.address.toString(),
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15)),
                            ),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Please select your address',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                  Positioned(
                    right: 0,
                    top: ((deviceHeight * 0.12) / 2) / 2,
                    child: IconButton(
                      icon: Icon(Icons.arrow_forward_ios, size: 16),
                      onPressed: () {},
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
                        painter: ContainerPatternPainter(),
                        child: Container(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () async {
              dynamic result = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddressBookScreen()));
              if (result == 'setAddress') {
                setState(() {});
              }
            },
          ),
          Container(
            height: deviceHeight * (0.5),
            child: ListView.builder(
              itemCount: productsInRentListList.length,
              itemBuilder: (context, index) {
                return RentListItem(productsInRentListList[index],
                    productStages: ProductStages.IN_CHECKOUT);
              },
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        width: deviceWidth,
        height: deviceHeight * 0.15,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 2.5,
              spreadRadius: 0.025,
              offset: Offset(0.5, 0.5),
            ),
          ],
        ),
        child: ListTile(
          minLeadingWidth: 0,
          contentPadding: EdgeInsets.all(0),
          leading: Container(
            height: 35,
            width: 200,
            margin: EdgeInsets.only(top: 10),
            child: RoundedLoadingButton(
              controller: controller,
              height: 35,
              color: Colors.redAccent,
              valueColor: Colors.white,
              width: 200,
              borderColor: Colors.redAccent,
              child: Text("ORDER"),
              onPressed: () async {
                controller.start();
                await orderService.setMyOrder(
                    productsInRentListList, rentListProvider);
                controller.success();
                controller.stop();
              },
            ),
          ),
          trailing: Chip(
              padding: EdgeInsets.only(right: 15),
              label: Text(
                "\$${rentListProvider.totalPrice}",
                style: TextStyle(fontSize: 18),
              ),
              labelStyle: TextStyle(color: Colors.redAccent),
              backgroundColor: Theme.of(context).backgroundColor),
        ),
      ),
    );
  }
}

class ContainerPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    DiagonalStripesThick(
            bgColor: Colors.lightBlueAccent, fgColor: Colors.redAccent)
        .paintOnWidget(canvas, size);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
