import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:rental_apartments_finder/models/users/singned_account.dart';
import 'package:rental_apartments_finder/models/store/property.dart';

class FirebasePropertyService {
  CollectionReference storesRef =
      FirebaseFirestore.instance.collection('stores');
  CollectionReference productsRef =
      FirebaseFirestore.instance.collection('products');

  Future<List<Property>> getAllProduct() async {
    List<Property> allProductsList = [];
    await productsRef.get().then(
      (querySnapshot) {
        querySnapshot.docs.forEach(
          (document) {
            allProductsList.add(Property.fromDocument(document));
          },
        );
      },
    );
    return allProductsList;
  }

  Stream getPropertyStreamByDisplayName(String propertyName) {
    return FirebaseFirestore.instance
        .collection('products')
        .where("name", isGreaterThanOrEqualTo: propertyName)
        .where("name", isLessThan: propertyName + 'z')
        .snapshots();
  }

  Future<QuerySnapshot> getPredictedPropertyByDisplayName(String propertyName) {
    return FirebaseFirestore.instance
        .collection('products')
        .where("name", isGreaterThanOrEqualTo: propertyName)
        .where("name", isLessThan: propertyName + 'z')
        .get();
  }

  Future<Property?> findProduct(String productID) async {
    QuerySnapshot productSnapshot =
        await productsRef.where('id', isEqualTo: productID).get();
    Property? product = Property.fromDocument(productSnapshot.docs.first);
    print(product);
    return product;
  }

  Future<List<Property>> findUserProductsList() async {
    List<Property> userProductsList = [];

    QuerySnapshot productSnapshot = await productsRef
        .where('ownerID', isEqualTo: SignedAccount.instance.id)
        .get();

    productSnapshot.docs.forEach(
      (element) {
        try {
          Property? product = Property.fromDocument(element);
          if (product != null) {
            userProductsList.add(product);
          }
        } on Exception catch (e) {
          print(e);
        }
      },
    );
    return userProductsList;
  }

  Future uploadProduct(Property product) async {
    await productsRef.doc(product.id).set(
      {
        'id': product.id,
        'ownerID': product.ownerId,
        'name': product.name,
        'desc': product.desc,
        'rentPrice': product.rentPrice,
        'imageURL': FieldValue.arrayUnion(product.imageUrl!),
        'postTime': product.postTime,
        'roomsQuantity': product.roomsQuantity,
        'furnitureType': EnumToString.convertToString(product.furnitureType),
        'propertyType': EnumToString.convertToString(product.propertyType),
        'bedroom': EnumToString.convertToString(product.bedroom),
        'address': {
          'latitude': product.address!.latitude,
          'longitude': product.address!.longitude
        },
      },
      SetOptions(merge: true),
    );
  }

  Future editProduct(Property product) async {
    await productsRef.doc(product.id).set(
      {
        'id': product.id,
        'ownerID': product.ownerId,
        'name': product.name,
        'desc': product.desc,
        'rentPrice': product.rentPrice,
        'imageURL': product.imageUrl!,
        'postTime': product.postTime,
        'roomsQuantity': product.roomsQuantity,
        'furnitureType': EnumToString.convertToString(product.furnitureType),
        'propertyType': EnumToString.convertToString(product.propertyType),
        'bedroom': EnumToString.convertToString(product.bedroom),
        'address': {
          'latitude': product.address!.latitude,
          'longitude': product.address!.longitude
        },
      },
      SetOptions(merge: true),
    );
  }

  Future<DocumentSnapshot> getPropertyById(String propertyID) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('products')
        .doc(propertyID)
        .get();

    return documentSnapshot;
  }

  Future<String>? getImageOfProperty(String propertyID) async {
    DocumentSnapshot documentSnapshot = await getPropertyById(propertyID);
    return documentSnapshot['imageURL'][0];
  }
}
