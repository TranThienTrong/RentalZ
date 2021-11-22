import 'package:flutter/material.dart';
import 'package:rental_apartments_finder/models/places/address.dart';

class AddressItem extends StatefulWidget {
  List<Address> addressList;
  Address address;
  Address currentAddress;

  AddressItem(this.addressList, this.address, this.currentAddress, {Key? key})
      : super(key: key);

  @override
  _AddressItemState createState() => _AddressItemState();
}

class _AddressItemState extends State<AddressItem> {
  @override
  Widget build(BuildContext context) {
    return RadioListTile<Address>(
      title: Text(widget.address.name!),
      subtitle: Text(widget.address.address!),
      value: widget.address,
      groupValue: widget.currentAddress,
      onChanged: (Address? value) {
        setState(() {
          widget.currentAddress = value!;
        });
      },
    );
  }
}
