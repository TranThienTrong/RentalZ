import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_apartments_finder/models/messages/message.dart';
import 'package:rental_apartments_finder/models/store/property.dart';
import 'package:rental_apartments_finder/models/users/my_user.dart';
import 'package:rental_apartments_finder/models/users/singned_account.dart';
import 'package:rental_apartments_finder/providers/rentlist_provider.dart';
import 'package:rental_apartments_finder/providers/wishlist_provider.dart';
import 'package:rental_apartments_finder/screens/messages/conversation_detail_screen.dart';
import 'package:rental_apartments_finder/screens/notes/note_edit_screen.dart';
import 'package:rental_apartments_finder/services/user_service.dart';
import 'package:rental_apartments_finder/services/map_service.dart';
import 'package:rental_apartments_finder/services/message_service.dart';

class PropertyDetailBodyScreen extends StatefulWidget {
  Property property;

  PropertyDetailBodyScreen({required this.property, Key? key})
      : super(key: key);

  @override
  State<PropertyDetailBodyScreen> createState() =>
      _PropertyDetailBodyScreenState();
}

class _PropertyDetailBodyScreenState extends State<PropertyDetailBodyScreen> {
  int imageIndex = 0;
  late RentListProvider RentList;
  late WishlistProvider wishlist;
  late String locationImageUrl;

  @override
  void initState() {
    /* ___________________________ Provider __________________________ */
    RentList = Provider.of<RentListProvider>(context, listen: false);
    wishlist = Provider.of<WishlistProvider>(context, listen: false);

    locationImageUrl =
        "https://maps.googleapis.com/maps/api/staticmap?center=&${widget.property.address!.latitude!},${widget.property.address!.longitude!}&zoom=15&size=900x600&maptype=roadmap&markers=color:red%7Clabel:C%7C${widget.property.address!.latitude!},${widget.property.address!.longitude!}&key=${MapService.GOOGLE_CLOUD_API_KEY}";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            padding: EdgeInsets.only(left: 25, right: 25),
            width: size.width,
            height: size.height * 0.25,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
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
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
                child: GridTile(
                  child: GestureDetector(
                    onTap: () => {},
                    child: Image.network(widget.property.imageUrl![imageIndex],
                        fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.only(left: 25),
            height: 70,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.property.imageUrl!.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: 100,
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: imageIndex == index
                          ? Colors.orangeAccent
                          : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                    child: GridTile(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => imageIndex = index);
                        },
                        child: Image.network(widget.property.imageUrl![index],
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            height: (size.height * (0.37)) - 172,
            width: size.width,
            margin: EdgeInsets.only(top: 10),
            color: Colors.black,
            child: Image.network(locationImageUrl, fit: BoxFit.cover),
          ),
          Spacer(
            flex: 1,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Container(
                height: ((size.height * (1 - 0.4)) - 172),
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.0,
                      spreadRadius: 0.025,
                      offset: Offset(0.5, 0.5),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 25.0, top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      widget.property.name!,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 35),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      EnumToString.convertToString(
                                          widget.property.propertyType),
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 25),
                            child: Text(widget.property.desc!),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: size.height * 0.13,
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 15),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                padding: EdgeInsets.all(15),
                                width: 70,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25),
                                    bottomLeft: Radius.circular(25),
                                  ),
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.all(0),
                                  icon: wishlist.wishlistItemList
                                          .contains(widget.property.id)
                                      ? const Icon(Icons.favorite,
                                          color: Colors.red, size: 25)
                                      : const Icon(Icons.favorite,
                                          color: Colors.white, size: 25),
                                  onPressed: () {
                                    setState(() =>
                                        widget.property.toggleFavourite());
                                    if (widget.property.isFavourite == true) {
                                      wishlist
                                          .addWishlistItem(widget.property.id);
                                    } else {
                                      wishlist.removeWishlistItem(
                                          widget.property.id);
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 15),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                padding: EdgeInsets.all(15),
                                width: 70,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25),
                                    bottomLeft: Radius.circular(25),
                                  ),
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.all(0),
                                  icon: Icon(Icons.sticky_note_2_sharp,
                                      color: Colors.white),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => NoteEditScreen(
                                          referencesProperty: widget.property,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 15),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                padding: EdgeInsets.all(15),
                                width: 70,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25),
                                    bottomLeft: Radius.circular(25),
                                  ),
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.all(0),
                                  icon: Icon(Icons.chat, color: Colors.white),
                                  onPressed: () async {
                                    MessageService messageService =
                                        new MessageService();
                                    FirebaseUserService userService =
                                        new FirebaseUserService();

                                    MyUser user = MyUser.fromDocumentSnapshot(
                                        await userService.getUserById(
                                            widget.property.ownerId));

                                    String? conversationID =
                                        await messageService
                                            .createOrGetConversation(
                                                SignedAccount.instance.id!,
                                                user.id!);

                                    late Message message;
                                    if (conversationID == null) {
                                      message = Message(
                                        displayName: user.displayName,
                                        photoUrl: user.photoUrl,
                                      );
                                    } else {
                                      message = Message.fromDocumentSnapshot(
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(SignedAccount.instance.id)
                                              .collection('Conversations')
                                              .doc(user.id)
                                              .get());
                                    }

                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ConversationDetailScreen(
                                                user, message),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: size.width,
                        height: size.height * 0.055,
                        margin: EdgeInsets.only(left: 5, right: 5, bottom: 5),
                        decoration: BoxDecoration(
                          color: Colors.deepOrangeAccent,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 5.0,
                              spreadRadius: 0.025,
                              offset: Offset(0.5, 0.5),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              padding: EdgeInsets.all(0),
                              icon: RentList.rentListItemList.keys
                                      .contains(widget.property.id)
                                  ? Icon(Icons.check,
                                      color: Colors.white, size: 25)
                                  : Icon(Icons.shopping_cart_outlined,
                                      size: 25, color: Colors.white),
                              onPressed: () async {
                                await RentList.addRentListItem(
                                    widget.property.id);
                                setState(() {});
                              },
                            ),
                            Text(
                              RentList.rentListItemList.keys
                                      .contains(widget.property.id)
                                  ? "ALREADY IN LIST"
                                  : "ADD TO RENT LIST",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
