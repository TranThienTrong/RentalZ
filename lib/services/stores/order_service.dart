import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:rental_apartments_finder/models/users/singned_account.dart';
import 'package:rental_apartments_finder/models/places/address.dart';
import 'package:rental_apartments_finder/models/store/order.dart';
import 'package:rental_apartments_finder/models/store/property_in_rent_list.dart';
import 'package:rental_apartments_finder/providers/rentlist_provider.dart';
import 'package:rental_apartments_finder/services/notifications/notification_service.dart';
import 'package:rental_apartments_finder/services/notifications/push_notification_service.dart';
import 'package:uuid/uuid.dart';

class OrderService {
  Future<void> setMyOrder(List<PropertyInRentList> productsInRentListList,
      RentListProvider RentListProvider) async {
    List<Map<String, dynamic>> productsList =
        productsInRentListList.map((productsInRentList) {
      return {
        'id': productsInRentList.product.id,
        'ownerID': productsInRentList.product.ownerId,
        'desc': productsInRentList.product.desc!,
        'name': productsInRentList.product.name!,
        'imageURL': productsInRentList.product.imageUrl!,
        'rentPrice': productsInRentList.product.rentPrice!,
        'postTime': productsInRentList.product.postTime!,
        'propertyType': EnumToString.convertToString(
            productsInRentList.product.propertyType!),
        'furnitureType': EnumToString.convertToString(
            productsInRentList.product.furnitureType!),
        'bedroom':
            EnumToString.convertToString(productsInRentList.product.bedroom!),
        'quantityBought': productsInRentList.quantity,
      };
    }).toList();

    String orderId = Uuid().v4();
    DateTime orderedTime = DateTime.now();

    await FirebaseFirestore.instance
        .collection('stores')
        .doc(SignedAccount.instance.id!)
        .update(
      {
        'myOrders': FieldValue.arrayUnion(
          [
            {
              'id': orderId,
              'address': Address.currentAddress!.address,
              'buyerID': SignedAccount.instance.id!,
              'orderedTime': orderedTime,
              'productsList': productsList,
              'totalPrice': RentListProvider.totalPrice,
            }
          ],
        ),
      },
    );

    Order order = new Order(
      id: orderId,
      address: Address.currentAddress!.address!,
      buyerId: SignedAccount.instance.id!,
      orderedTime: orderedTime,
      productsInRentListList: productsInRentListList,
      totalPrice: RentListProvider.totalPrice,
    );

    await PushNotificationService().sendPushNotificationForCorrectUser(
      newOrder: order,
      notifyTitle: '',
      notifyBody: '',
      notifyType: NotificationTypes.RENT,
    );

    setLessorOrder(order);
  }

  Future<void> setLessorOrder(Order order) async {
    Set<String> differentLessorsId = new Set<String>();

    order.productsInRentListList.forEach(
      (product) {
        differentLessorsId.add(product.product.ownerId);
        NotificationService().insertPropertyRentedNotification(
            notifyType: 'property_rented',
            ownerId: product.product.ownerId,
            productId: product.product.id);
      },
    );

    Map<String, List<PropertyInRentList>> productsOfEachLessor =
        new Map<String, List<PropertyInRentList>>();

    for (String lessorId in differentLessorsId) {
      List<PropertyInRentList> thisLessorProducts = order.productsInRentListList
          .where((productsInRentList) =>
              productsInRentList.product.ownerId == lessorId)
          .toList();
      productsOfEachLessor.putIfAbsent(lessorId, () => thisLessorProducts);
    }

    productsOfEachLessor.forEach(
      (String lessorId, List<PropertyInRentList> productsInRentListList) async {
        List<Map<String, dynamic>> productsList = productsInRentListList.map(
          (productsInRentList) {
            print(productsInRentList.product);

            return {
              'id': productsInRentList.product.id,
              'ownerID': productsInRentList.product.ownerId,
              'desc': productsInRentList.product.desc!,
              'name': productsInRentList.product.name!,
              'imageURL': productsInRentList.product.imageUrl!,
              'rentPrice': productsInRentList.product.rentPrice!,
              'postTime': productsInRentList.product.postTime!,
              'propertyType': EnumToString.convertToString(
                  productsInRentList.product.propertyType!),
              'furnitureType': 'FURNISHED',
              'bedroom': EnumToString.convertToString(
                  productsInRentList.product.bedroom!),
              'quantityBought': productsInRentList.quantity,
            };
          },
        ).toList();

        await FirebaseFirestore.instance
            .collection('stores')
            .doc(lessorId)
            .collection('productsOrdered')
            .add(
          {
            'orderId': order.id,
            'state': 'pending',
            'address': Address.currentAddress!.address,
            'buyerID': SignedAccount.instance.id!,
            'orderedTime': order.orderedTime,
            'productsList': productsList,
          },
        );
      },
    );
  }
}
