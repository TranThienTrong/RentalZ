import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_apartments_finder/models/store/property_in_rent_list.dart';
import 'package:rental_apartments_finder/models/store/property.dart';
import 'package:rental_apartments_finder/providers/rentlist_provider.dart';
import 'package:rental_apartments_finder/services/stores/properties_service.dart';
import 'package:rental_apartments_finder/widgets/property_item/rent_list_item.dart';
import 'package:rental_apartments_finder/widgets/rounded_loading_button.dart';

class RentListScreen extends StatefulWidget {
  RentListScreen({Key? key}) : super(key: key);

  @override
  _RentListScreenState createState() => _RentListScreenState();
}

class _RentListScreenState extends State<RentListScreen> {
  RoundedLoadingButtonController controller =
      new RoundedLoadingButtonController();

  initState() {
    super.initState();
  }

  FirebasePropertyService productService = FirebasePropertyService();

  @override
  Widget build(BuildContext context) {
    RentListProvider rentListProvider = Provider.of<RentListProvider>(context);

    Map<String, PropertyInRentList> RentListList =
        rentListProvider.rentListItemList;
    List<PropertyInRentList> productInRentListList =
        RentListList.values.toList();

    AppBar appbar = AppBar(
      title: Text("Rent List"),
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
          itemCount: productInRentListList.length,
          itemBuilder: (context, index) {
            return RentListItem(productInRentListList[index],
                productStages: ProductStages.IN_RentList);
          },
        ),
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
            child: RoundedLoadingButton(
              controller: controller,
              onPressed: () {
                controller.start();
                Navigator.of(context).pushNamed('/checkout_screen');
                controller.stop();
              },
              height: 35,
              color: Colors.redAccent,
              valueColor: Colors.white,
              width: 200,
              borderColor: Colors.redAccent,
              child: Text("CHECK OUT"),
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
