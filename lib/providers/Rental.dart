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

  Future<void> fetchAndSetRentals() async {
    final url =
        'https://car-rental-5d8bb-default-rtdb.firebaseio.com/rentals.json?auth=$authToken';
    final response = await http.get(url);
    final List<RentalItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      if (orderData["rentalMakerId"] == userId) {
        loadedOrders.add(
          RentalItem(
              id: orderId,
              total: orderData['total'],
              startDate: DateTime.parse(orderData['startDate']),
              endDate: DateTime.parse(orderData['endDate']),
              carName: orderData['carName'],
              rentalMakerId: orderData["rentalMakerId"]),
        );
      }
    });
    _rentals = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> archiveRental(RentalItem order) async {
    final rentalId = order.id;
    final archiveUrl =
        'https://car-rental-5d8bb-default-rtdb.firebaseio.com/archive.json?auth=$authToken';
    final timestamp = DateTime.now();
    final response = await http.post(
      archiveUrl,
      body: json.encode({
        'carName': order.carName,
        'total': order.total,
        'startDate': order.startDate.toIso8601String(),
        'endDate': order.endDate.toIso8601String(),
      }),
    );

    final rentalUrl =
        'https://car-rental-5d8bb-default-rtdb.firebaseio.com/rentals/$rentalId.json?auth=$authToken';
    final existingOrderIndex = _rentals.indexWhere((o) => o.id == rentalId);
    var existingOrder = _rentals[existingOrderIndex];
    _rentals.removeAt(existingOrderIndex);
    notifyListeners();
    final responseOrder = await http.delete(rentalUrl);
    if (responseOrder.statusCode >= 400) {
      _rentals.insert(existingOrderIndex, existingOrder);
      notifyListeners();
      throw HttpException('Could not archive the rental.');
    }
    existingOrder = null;

    notifyListeners();
  }

  Future<bool> canIRentIt(DateTime startDate, DateTime endDate) async {
    final url =
        'https://car-rental-5d8bb-default-rtdb.firebaseio.com/rentals.json?auth=$authToken';
    final response = await http.get(url);
    final List<RentalItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return false;
    }

    extractedData.forEach((orderId, orderData) {
      DateTime start = DateTime.parse(orderData['startDate']);
      DateTime end = DateTime.parse(orderData['endDate']);
      if ((startDate.isAfter(start) && endDate.isBefore(end)) ||
          (startDate.isBefore(start) && endDate.isAfter(end)) ||
          (startDate.isBefore(start) && endDate.isBefore(end)) ||
          (startDate.isAfter(start) && endDate.isAfter(end)) &&
              (startDate == start && endDate == end)) {
        return true;
      }
    });

    return false;
  }

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

  Future<void> cancelRental(RentalItem order) async {
    final rentalId = order.id;

    final rentalUrl =
        'https://car-rental-5d8bb-default-rtdb.firebaseio.com/rentals/$rentalId.json?auth=$authToken';
    final existingOrderIndex = _rentals.indexWhere((o) => o.id == rentalId);
    var existingOrder = _rentals[existingOrderIndex];
    _rentals.removeAt(existingOrderIndex);
    notifyListeners();
    final responseOrder = await http.delete(rentalUrl);
    if (responseOrder.statusCode >= 400) {
      _rentals.insert(existingOrderIndex, existingOrder);
      notifyListeners();
      throw HttpException('Could not delete the rental.');
    }
    existingOrder = null;

    notifyListeners();
  }
}
