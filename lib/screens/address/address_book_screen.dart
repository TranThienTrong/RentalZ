import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_apartments_finder/models/users/singned_account.dart';
import 'package:rental_apartments_finder/models/places/address.dart';
import 'package:rental_apartments_finder/screens/address/places_homepage_screen.dart';
import 'package:rental_apartments_finder/widgets/progress.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class AddressBookScreen extends StatefulWidget {
  AddressBookScreen({Key? key}) : super(key: key);

  @override
  _AddressBookScreenState createState() => _AddressBookScreenState();
}

class _AddressBookScreenState extends State<AddressBookScreen> {
  Uuid uuid = new Uuid();

  didChangeDependencies() {}

  @override
  Widget build(BuildContext context) {
    double deviceHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Address Book'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context, 'setAddress'),
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('stores')
            .doc(SignedAccount.instance.id!)
            .get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            DocumentSnapshot documentSnapshot = snapshot.data!;
            List<Address> addressList = [];
            if (documentSnapshot['addressBook'] != null) {
              addressList =
                  List<Address>.from(documentSnapshot['addressBook'].map(
                (address) {
                  return Address.fromJson(address);
                },
              ).toList());
            }
            return SingleChildScrollView(
              child: AddressRadioButtonList(addressList),
            );
          } else {
            return CircularProgress();
          }
        },
      ),
    );
  }
}

class AddressRadioButtonList extends StatefulWidget {
  List<Address> addressList;

  AddressRadioButtonList(this.addressList, {Key? key}) : super(key: key);

  @override
  _AddressRadioButtonListState createState() => _AddressRadioButtonListState();
}

class _AddressRadioButtonListState extends State<AddressRadioButtonList> {
  late Address? currentAddress = Address.currentAddress;
  late Address addressProvider;

  @override
  void initState() {
    addressProvider = Provider.of<Address>(context, listen: false);
    if (widget.addressList.length > 0) {
      if (Address.currentAddress == null) {
        currentAddress = widget.addressList[0];
        Address.currentAddress = currentAddress;
      } else {
        currentAddress = widget.addressList
            .firstWhere((address) => address.id == Address.currentAddress!.id);
      }
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (widget.addressList.length > 0) {
      if (Address.currentAddress == null) {
        currentAddress = widget.addressList[0];
        Address.currentAddress = currentAddress;
      } else {
        currentAddress = widget.addressList
            .firstWhere((address) => address.id == Address.currentAddress!.id);
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = (MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top);
    double deviceWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Container(
          height: deviceHeight * 0.79,
          child: ListView.builder(
            itemCount: widget.addressList.length,
            itemBuilder: (context, index) {
              return Container(
                width: deviceWidth,
                margin: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                padding: EdgeInsets.only(top: 5, bottom: 5, left: 0, right: 0),
                decoration: BoxDecoration(
                  color: Colors.white,
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
                child: RadioListTile<Address>(
                  title: Text(widget.addressList[index].name!),
                  subtitle: Text(widget.addressList[index].address!),
                  value: widget.addressList[index],
                  groupValue: currentAddress,
                  onChanged: (Address? value) async {
                    setState(() {
                      currentAddress = value!;
                      addressProvider.setCurrentAddress(value);
                    });
                  },
                ),
              );
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 7, right: 7, bottom: 7),
          child: DottedBorder(
            borderType: BorderType.RRect,
            radius: Radius.circular(7),
            strokeWidth: 1.25,
            color: Colors.blue,
            padding: EdgeInsets.all(6),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              child: GestureDetector(
                child: Container(
                  height: deviceHeight * 0.075,
                  width: deviceWidth,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_location, color: Colors.blue),
                        Text('Add Address',
                            style: TextStyle(color: Colors.blue))
                      ]),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PlacesHomepageScreen()));
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
