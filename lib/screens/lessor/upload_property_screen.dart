import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:group_button/group_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:rental_apartments_finder/models/places/address.dart';
import 'package:rental_apartments_finder/models/store/category.dart';
import 'package:rental_apartments_finder/models/store/property.dart';
import 'package:rental_apartments_finder/providers/property_list_provider.dart';
import 'package:rental_apartments_finder/screens/address/address_book_screen.dart';
import 'package:rental_apartments_finder/screens/stores/checkout_screen.dart';
import 'package:rental_apartments_finder/services/stores/properties_service.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as imagePackage;

import 'lessor_homepage_screen.dart';

class UploadPropertyScreen extends StatefulWidget {
  Property? property;

  UploadPropertyScreen({this.property});

  @override
  State<StatefulWidget> createState() {
    return _UploadPropertyScreenState();
  }
}

class _UploadPropertyScreenState extends State<UploadPropertyScreen> {
  late String uuid;
  String? imageUrl;
  late PropertiesListProvider productsListProvider;
  ImagePicker _imagePicker = ImagePicker();

  setLocation(String location) {
    setState(() {
      this.locationController.text = location;
    });
  }

  /* __________________________ Form Value _____________________ */
  GlobalKey<FormState> _uploadPropertyFormKey = GlobalKey<FormState>();

  FocusNode _priceFocusNode = FocusNode();
  FocusNode _descFocusNode = FocusNode();
  FocusNode _imageURLFocusNode = FocusNode();

  File? imageFile;
  PropertyTypes? propertyType;
  FurnitureTypes? furnitureType;
  Bedrooms? bedroom;

  TextEditingController _imageUrlController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  /* __________________________ Field Attributes _____________________ */
  bool isLoading = false;

  /* __________________________ Firebase Attributes _____________________ */
  FirebasePropertyService productService = new FirebasePropertyService();

  @override
  initState() {
    uuid = Uuid().v4();
    if (widget.property != null) {
      setUpExistedProperty();
    } else {
      widget.property = Property.empty(uuid);
    }
    productsListProvider =
        Provider.of<PropertiesListProvider>(context, listen: false);
    propertyType = PropertyTypes.FLAT;
    furnitureType = FurnitureTypes.NONE;
    bedroom = Bedrooms.NONE;
    super.initState();
  }

  dispose() {
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    _imageURLFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: setProperty,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Form(
            key: _uploadPropertyFormKey,
            onChanged: () {
              _uploadPropertyFormKey.currentState!.save();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  child: Container(
                    height: deviceHeight * 0.13,
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
                                    leading: Icon(Icons.place,
                                        color: Colors.redAccent),
                                    minLeadingWidth: 0,
                                    contentPadding: EdgeInsets.all(0),
                                    title: Text(Address.currentAddress!.name
                                        .toString()),
                                    subtitle: Text(
                                        Address.currentAddress!.address
                                            .toString(),
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
                    dynamic result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddressBookScreen()));
                    if (result == 'setAddress') {
                      setState(() {});
                    }
                  },
                ),
                Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                  child: TextFormField(
                    controller: _titleController,
                    style: TextStyle(color: Colors.indigo),
                    decoration: new InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).backgroundColor,
                      hintText: 'Title',
                      contentPadding: const EdgeInsets.only(left: 17.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.blue),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(19)),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                    ),
                    cursorColor: Colors.indigo,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter title';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {});
                    },
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_priceFocusNode);
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
                  child: TextFormField(
                    controller: _descController,
                    style: TextStyle(color: Colors.indigo),
                    keyboardType: TextInputType.multiline,
                    minLines: 4,
                    maxLines: 100,
                    decoration: new InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).backgroundColor,
                      hintText: 'Description',
                      contentPadding: EdgeInsets.only(top: 17, left: 17.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.blue),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(19)),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                    ),
                    cursorColor: Colors.indigo,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter description';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {});
                    },
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_priceFocusNode);
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                  child: TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: TextStyle(color: Colors.indigo),
                    decoration: new InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).backgroundColor,
                      hintText: 'Price',
                      contentPadding: const EdgeInsets.only(left: 17.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.blue),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(19)),
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
                GestureDetector(
                  onTap: selectImage,
                  child: Container(
                    margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.all(
                        Radius.circular(19),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                      child: GridTile(child: setupImageWidget()),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                  child: Text(
                    "Property Type",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                        fontSize: 15),
                  ),
                ),
                Divider(),
                Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: GroupButton(
                    mainGroupAlignment: MainGroupAlignment.start,
                    isRadio: true,
                    spacing: 10,
                    selectedButton: widget.property != null
                        ? PropertyTypes.values
                            .indexOf(widget.property!.propertyType!)
                        : -1,
                    direction: Axis.horizontal,
                    onSelected: (index, isSelected) {
                      List<PropertyTypes> propertyTypesList =
                          PropertyTypes.values;
                      propertyType = propertyTypesList[index];
                    },
                    buttons: PropertyTypes.values.map((element) {
                      return EnumToString.convertToString(element);
                    }).toList(),
                    unselectedBorderColor: Colors.lightBlue,
                    unselectedColor: Theme.of(context).backgroundColor,
                    selectedColor: Colors.blue,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                  child: Text(
                    "Furniture",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                        fontSize: 15),
                  ),
                ),
                Divider(),
                Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: GroupButton(
                    mainGroupAlignment: MainGroupAlignment.start,
                    isRadio: true,
                    spacing: 10,
                    selectedButton: widget.property != null
                        ? FurnitureTypes.values
                            .indexOf(widget.property!.furnitureType!)
                        : -1,
                    direction: Axis.horizontal,
                    onSelected: (index, isSelected) {
                      List<FurnitureTypes> furnitureTypesList =
                          FurnitureTypes.values;
                      furnitureType = furnitureTypesList[index];
                    },
                    buttons: FurnitureTypes.values.map(
                      (element) {
                        return EnumToString.convertToString(element);
                      },
                    ).toList(),
                    selectedTextStyle: TextStyle(
                      fontSize: 14,
                    ),
                    unselectedTextStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    unselectedBorderColor: Colors.lightBlue,
                    unselectedColor: Theme.of(context).backgroundColor,
                    selectedColor: Colors.lightBlue,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                  child: Text(
                    "Bedroom",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                        fontSize: 15),
                  ),
                ),
                Divider(),
                Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: GroupButton(
                    mainGroupAlignment: MainGroupAlignment.start,
                    isRadio: true,
                    spacing: 10,
                    selectedButton: widget.property != null
                        ? Bedrooms.values.indexOf(widget.property!.bedroom!)
                        : -1,
                    direction: Axis.horizontal,
                    onSelected: (index, isSelected) {
                      List<Bedrooms> bedroomTypesList = Bedrooms.values;
                      bedroom = bedroomTypesList[index];
                    },
                    buttons: Bedrooms.values.map(
                      (element) {
                        return EnumToString.convertToString(element);
                      },
                    ).toList(),
                    selectedTextStyle: TextStyle(
                      fontSize: 14,
                    ),
                    unselectedTextStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    unselectedBorderColor: Colors.lightBlue,
                    unselectedColor: Theme.of(context).backgroundColor,
                    selectedColor: Colors.lightBlue,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget setupImageWidget() {
    if (widget.property!.id != uuid) {
      if (imageFile == null) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(widget.property!.imageUrl![0]),
            ),
          ),
        );
      } else {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: FileImage(imageFile!),
            ),
          ),
        );
      }
    } else {
      if (widget.property!.imageUrl!.isEmpty) {
        if (imageFile == null) {
          return Icon(Icons.add_box, size: 30, color: Colors.blue);
        } else {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: FileImage(imageFile!),
              ),
            ),
          );
        }
      } else {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(widget.property!.imageUrl![0]),
            ),
          ),
        );
      }
    }
  }

  /* ------------------------------------------------ SELECT IMAGE FROM FILE --------------------------------------- */
  Future<dynamic> selectImage() {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text("Create Post"),
          children: [
            SimpleDialogOption(
              child: Text("Open Camera"),
              onPressed: handleCameraPicture,
            ),
            SimpleDialogOption(
              child: Text("Open Gallery"),
              onPressed: handleGalleryPicture,
            ),
            SimpleDialogOption(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  void handleCameraPicture() async {
    Navigator.pop(context);
    XFile? file = await _imagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 650, maxWidth: 800);
    if (file != null) {
      setState(() {
        imageFile = File(file.path);
      });
    }
  }

  void handleGalleryPicture() async {
    Navigator.pop(context);
    XFile? file = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        imageFile = File(file.path);
      });
    }
  }

  /* ------------------------------------------------ UPLOAD IMAGE TO FIREBASE --------------------------------------- */

  Future<String> uploadImage(File imageFile) async {
    Reference storageReferences = FirebaseStorage.instance.ref();
    UploadTask uploadTask = storageReferences
        .child('images')
        .child('property')
        .child("property_$uuid")
        .putFile(imageFile);

    TaskSnapshot taskSnapshot = await uploadTask;
    String imageURL = await taskSnapshot.ref.getDownloadURL();
    return imageURL;
  }

  compressImage() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempDirPath = tempDir.path;

    imagePackage.Image decodedImage =
        imagePackage.decodeImage(imageFile!.readAsBytesSync())!;
    final compresssedImage = File("${tempDirPath}/img_$uuid}")
      ..writeAsBytesSync(imagePackage.encodeJpg(decodedImage, quality: 100));

    setState(() {
      imageFile = compresssedImage;
    });
  }

  void setUpExistedProperty() {
    _titleController.text = widget.property!.name!;
    _descController.text = widget.property!.desc!;
    _priceController.text = widget.property!.rentPrice.toString();
    propertyType = widget.property!.propertyType;
    furnitureType = widget.property!.furnitureType;
    bedroom = widget.property!.bedroom;
    imageUrl = widget.property!.imageUrl![0];
  }

  Future<void> setProperty() async {
    if (_uploadPropertyFormKey.currentState!.validate()) {
      if (widget.property!.id == uuid && imageFile == null) {
        AwesomeDialog(
          context: context,
          animType: AnimType.SCALE,
          dialogType: DialogType.WARNING,
          body: Center(
            child: Text(
              'Please choose image for your property!',
            ),
          ),
          btnOkOnPress: () {},
        )..show();
      } else if (Address.currentAddress == null) {
        AwesomeDialog(
          context: context,
          animType: AnimType.SCALE,
          dialogType: DialogType.WARNING,
          body: Center(
            child: Text(
              'Please specify your property address!',
            ),
          ),
          btnOkOnPress: () {},
        )..show();
      } else if (propertyType == null) {
        AwesomeDialog(
          context: context,
          animType: AnimType.SCALE,
          dialogType: DialogType.WARNING,
          body: Center(
            child: Text(
              'Please specify your property type!',
            ),
          ),
          btnOkOnPress: () {},
        )..show();
      } else if (furnitureType == null) {
        AwesomeDialog(
          context: context,
          animType: AnimType.SCALE,
          dialogType: DialogType.WARNING,
          body: Center(
            child: Text(
              'Please specify your property Furniture Type !',
            ),
          ),
          btnOkOnPress: () {},
        )..show();
      } else if (bedroom == null) {
        AwesomeDialog(
          context: context,
          animType: AnimType.SCALE,
          dialogType: DialogType.WARNING,
          body: Center(
            child: Text(
              'Please specify number of bedrooms!',
            ),
          ),
          btnOkOnPress: () {},
        )..show();
      } else {
        CoolAlert.show(
          context: context,
          type: CoolAlertType.loading,
          text: "Uploading your property!",
        );

        if (widget.property!.id != uuid) {
          if (imageFile != null) {
            imageUrl = await uploadImage(imageFile!);
          } else {
            imageUrl = widget.property!.imageUrl![0];
          }
          print(widget.property!.imageUrl!);
          widget.property!.imageUrl!.insert(0, imageUrl!);
        } else {
          imageUrl = await uploadImage(imageFile!);
          if (widget.property!.imageUrl!.isEmpty) {
            widget.property!.imageUrl!.add(imageUrl!);
          } else {
            widget.property!.imageUrl![0] = imageUrl!;
          }
        }

        widget.property!.name = _titleController.text.toString();
        widget.property!.desc = _descController.text.toString();
        widget.property!.rentPrice = double.parse(_priceController.text);
        widget.property!.propertyType = propertyType;
        widget.property!.furnitureType = furnitureType;
        widget.property!.bedroom = bedroom;
        widget.property!.postTime = DateTime.now();
        widget.property!.address = Address.currentAddress;
        _uploadPropertyFormKey.currentState!.save();
        productsListProvider.addProperty(widget.property!);

        if (widget.property!.id != uuid) {
          await productService.editProduct(widget.property!);
        } else {
          await productService.uploadProduct(widget.property!);
        }

        Navigator.pop(context);
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => LessorHomepageScreen()));
      }
    }
  }
}
