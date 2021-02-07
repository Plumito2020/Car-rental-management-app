import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class RentalItem {
  String id;
  String rentalMakerId;
  double total;
  String carName;
  DateTime startDate;
  DateTime endDate;

  RentalItem({
    @required this.id,
    @required this.total,
    @required this.rentalMakerId,
    @required this.carName,
    @required this.startDate,
    @required this.endDate,
  });
}

class Rentals with ChangeNotifier {
  List<RentalItem> _rentals = [];
  final String authToken;
  final String userId;

  Rentals(this.authToken, this.userId, this._rentals);

  List<RentalItem> get rentals {
    return [..._rentals];
  }

  Future<void> fetchAndSetAllRentals() async {
    final url =
        'https://car-rental-5d8bb-default-rtdb.firebaseio.com/rentals.json?auth=$authToken';
    final response = await http.get(url);
    final List<RentalItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        RentalItem(
            id: orderId,
            total: orderData['total'],
            startDate: DateTime.parse(orderData['startDate']),
            endDate: DateTime.parse(orderData['endDate']),
            carName: orderData['carName'],
            rentalMakerId: orderData["rentalMakerId"]),
      );
    });
    _rentals = loadedOrders.reversed.toList();
    notifyListeners();
  }

  // Future<void> fetchAndSetRentals() async {
  //   final url =
  //       'https://car-rental-5d8bb-default-rtdb.firebaseio.com/rentals.json?auth=$authToken';
  //   final response = await http.get(url);
  //   final List<RentalItem> loadedOrders = [];
  //   final extractedData = json.decode(response.body) as Map<String, dynamic>;
  //   if (extractedData == null) {
  //     return;
  //   }
  //   extractedData.forEach((orderId, orderData) {
  //     if (orderData["userId"] == userId) {
  //       loadedOrders.add(
  //         RentalItem(
  //           id: orderId,
  //           amount: orderData['amount'],
  //           dateTime: DateTime.parse(orderData['dateTime']),
  //           products: (orderData['products'] as List<dynamic>)
  //               .map(
  //                 (item) => CartItem(
  //                   id: item['id'],
  //                   price: item['price'],
  //                   quantity: item['quantity'],
  //                   title: item['title'],
  //                 ),
  //               )
  //               .toList(),
  //           orderState: orderData['state'],
  //           deliveryAddress: orderData['deliveryAddress'],
  //           deliveryOption: orderData['deliveryOption'],
  //           orderMakerId: orderData['userId'],
  //           deliveryDate: DateTime.parse(orderData['deliveryDate']),
  //         ),
  //       );
  //     }
  //   });
  //   _rentals = loadedOrders.reversed.toList();
  //   notifyListeners();
  // }

  // Future<void> archiveOrder(OrderItem order) async {
  //   final orderId = order.id;
  //   final archiveUrl =
  //       'https://stage-1a56d.firebaseio.com/archive.json?auth=$authToken';
  //   final timestamp = DateTime.now();
  //   final response = await http.post(
  //     archiveUrl,
  //     body: json.encode({
  //       'amount': order.amount,
  //       'archiveDateTime': timestamp.toIso8601String(),
  //       'orderDateTime': order.dateTime.toIso8601String(),
  //       'products': order.products
  //           .map((cp) => {
  //                 'id': cp.id,
  //                 'title': cp.title,
  //                 'quantity': cp.quantity,
  //                 'price': cp.price,
  //               })
  //           .toList(),
  //       'state': order.orderState,
  //     }),
  //   );

  //   final orderUrl =
  //       'https://stage-1a56d.firebaseio.com/orders/$orderId.json?auth=$authToken';
  //   final existingOrderIndex = _orders.indexWhere((o) => o.id == orderId);
  //   var existingOrder = _orders[existingOrderIndex];
  //   _orders.removeAt(existingOrderIndex);
  //   notifyListeners();
  //   final responseOrder = await http.delete(orderUrl);
  //   if (responseOrder.statusCode >= 400) {
  //     _orders.insert(existingOrderIndex, existingOrder);
  //     notifyListeners();
  //     throw HttpException('Could not archive the order.');
  //   }
  //   existingOrder = null;

  //   notifyListeners();
  // }

  // Future<void> deleteOrderFromUser(OrderItem order) async {
  //   final orderId = order.id;

  //   final orderUrl =
  //       'https://stage-1a56d.firebaseio.com/orders/$orderId.json?auth=$authToken';
  //   final existingOrderIndex = _orders.indexWhere((o) => o.id == orderId);
  //   var existingOrder = _orders[existingOrderIndex];
  //   _orders.removeAt(existingOrderIndex);
  //   notifyListeners();
  //   final responseOrder = await http.delete(orderUrl);
  //   if (responseOrder.statusCode >= 400) {
  //     _orders.insert(existingOrderIndex, existingOrder);
  //     notifyListeners();
  //     throw HttpException('Could not archive the order.');
  //   }
  //   existingOrder = null;

  //   notifyListeners();
  // }

  Future<void> rentCar(double total, String carName, DateTime startDate,
      DateTime endDate) async {
    final url =
        'https://car-rental-5d8bb-default-rtdb.firebaseio.com/rentals.json?auth=$authToken';

    final response = await http.post(
      url,
      body: json.encode({
        'rentalMakerId': userId,
        'carName': carName,
        'total': total,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      }),
    );
    _rentals.insert(
      0,
      RentalItem(
        id: json.decode(response.body)['name'],
        total: total,
        startDate: startDate,
        endDate: endDate,
        carName: carName,
        rentalMakerId: userId,
      ),
    );
    notifyListeners();
  }

  // Future<void> confirmOrCancelOrder(String id, OrderItem order) async {
  //   final orderIndex = _orders.indexWhere((order) => order.id == id);

  //   if (orderIndex >= 0) {
  //     final url =
  //         'https://stage-1a56d.firebaseio.com/orders/$id.json?auth=$authToken';
  //     await http.patch(url,
  //         body: json.encode({
  //           'userId': order.orderMakerId,
  //           'amount': order.amount,
  //           'dateTime': order.dateTime.toIso8601String(),
  //           'products': order.products
  //               .map((cp) => {
  //                     'id': cp.id,
  //                     'title': cp.title,
  //                     'quantity': cp.quantity,
  //                     'price': cp.price,
  //                   })
  //               .toList(),
  //           'state': order.orderState,
  //           'deliveryOption': order.deliveryOption,
  //           'deliveryAddress': order.deliveryAddress,
  //           'deliveryDate': order.deliveryDate.toIso8601String(),
  //         }));
  //     _orders[orderIndex] = order;
  //     print(order.orderState);
  //     notifyListeners();
  //   } else {
  //     print('...');
  //   }
  // }
}
