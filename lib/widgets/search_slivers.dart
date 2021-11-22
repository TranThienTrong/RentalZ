import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:provider/provider.dart';
import 'package:rental_apartments_finder/models/places/address.dart';
import 'package:rental_apartments_finder/providers/place_provider.dart';
import 'package:rental_apartments_finder/screens/address/places_search_screen.dart';
import 'package:rental_apartments_finder/widgets/rounded_loading_button.dart';

class SearchSlivers extends StatefulWidget {
  double deviceWidth = 0.0;
  double deviceHeight = 0.0;

  Function getDirection;
  Function setNewAddress;

  SearchSlivers(
      {required this.deviceHeight,
      required this.deviceWidth,
      required this.getDirection,
      required this.setNewAddress,
      Key? key})
      : super(key: key);

  @override
  State<SearchSlivers> createState() => _SearchSliversState();
}

class _SearchSliversState extends State<SearchSlivers> {
  RoundedLoadingButtonController roundedLoadingButtonController =
      new RoundedLoadingButtonController();

  TextEditingController newAddressNameController = TextEditingController();

  Address newAddress = Address.empty();
  late AddressTypes newAddressType;
  late PlaceProvider placeProvider;

  @override
  void initState() {
    newAddressType = newAddress.placeType!;
    roundedLoadingButtonController = new RoundedLoadingButtonController();
    placeProvider = Provider.of<PlaceProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.deviceHeight * 0.23,
      width: widget.deviceWidth,
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 5.0,
            spreadRadius: 0.025,
            offset: Offset(0.5, 0.5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5.0,
                    spreadRadius: 0.05,
                    offset: Offset(0.7, 0.7),
                  ),
                ],
              ),
              child: GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: Colors.lightBlueAccent,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('search destination'),
                      ],
                    ),
                  ),
                  onTap: () async {
                    dynamic result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlacesSearchScreen(),
                        ));
                    switch (result) {
                      case 'getDirection':
                        await widget.getDirection();
                        break;
                      default:
                        break;
                    }
                  }),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GroupButton(
                        mainGroupAlignment: MainGroupAlignment.start,
                        isRadio: true,
                        spacing: 0,
                        buttonHeight: widget.deviceHeight * 0.05,
                        buttonWidth: 80,
                        selectedButton:
                            AddressTypes.values.indexOf(AddressTypes.HOME),
                        direction: Axis.horizontal,
                        onSelected: (index, isSelected) {
                          List<AddressTypes> addressTypesList =
                              AddressTypes.values;
                          newAddress.placeType = addressTypesList[index];
                        },
                        buttons: List<String>.from(AddressTypes.values.map(
                          (element) {
                            return EnumToString.convertToString(element);
                          },
                        ).toList()),
                        unselectedBorderColor: Colors.lightBlue,
                        unselectedColor: Theme.of(context).backgroundColor,
                        selectedColor: Colors.blue,
                      ),
                      Container(
                        height: widget.deviceHeight * 0.05,
                        width: widget.deviceWidth * 0.51,
                        margin: EdgeInsets.only(left: 5),
                        child: TextFormField(
                          controller: newAddressNameController,
                          style: TextStyle(color: Colors.indigo),
                          decoration: new InputDecoration(
                            filled: true,
                            fillColor: Theme.of(context).backgroundColor,
                            hintText: 'Address Name',
                            contentPadding: const EdgeInsets.only(left: 17.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.blue),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2)),
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                          ),
                          cursorColor: Colors.indigo,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter price';
                            } else if (double.parse(value) < 0.0) {
                              return 'Invalid Price';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            setState(() {});
                          },
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {},
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: RoundedLoadingButton(
                      height: widget.deviceHeight * 0.05,
                      width: widget.deviceWidth * 0.45,
                      onPressed: () async {
                        roundedLoadingButtonController.start();
                        newAddress.placeType = newAddressType;
                        newAddress.name = newAddressNameController.text
                                .toString()
                                .trim()
                                .isEmpty
                            ? 'Untitled'
                            : newAddressNameController.text;
                        Address.currentAddress = newAddress;
                        roundedLoadingButtonController.success();
                        widget.setNewAddress(newAddress);
                        Navigator.of(context).pop();
                        roundedLoadingButtonController.stop();
                      },
                      borderColor: Colors.white,
                      color: Colors.orange,
                      controller: roundedLoadingButtonController,
                      valueColor: Colors.white,
                      child: Text('Set New Address'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
