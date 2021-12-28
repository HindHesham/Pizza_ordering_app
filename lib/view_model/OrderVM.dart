import 'package:flutter/material.dart';
import 'package:pizza_ordering_app/data/response/ApiResponse.dart';
import 'package:pizza_ordering_app/models/order/OrderObjModel.dart';
import 'package:pizza_ordering_app/models/order/OrderStatusModel.dart';
import 'package:pizza_ordering_app/repository/Order/OrderRepo.dart';

class OrderVM extends ChangeNotifier {
  final _orderRepo = OrderRepo();
  bool isEnabled = true;

  ApiResponse<OrderStatus> createOrder = ApiResponse.loading();

  _createOrder(ApiResponse<OrderStatus> response) {
    createOrder = response;
    notifyListeners();
  }

  Future<void> checkOut(Order createOrder) async {
    _createOrder(ApiResponse.loading());
    await _orderRepo
        .createOrder(createOrder)
        .then((value) => _createOrder(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            _createOrder(ApiResponse.error(error.toString())));
  }

  Future<void> orderStatus(int orderID) async {
    _createOrder(ApiResponse.loading());
    await _orderRepo
        .getOrderStatus(orderID)
        .then((value) => _createOrder(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            _createOrder(ApiResponse.error(error.toString())));
  }

  enableButton() {
    isEnabled = true;
    notifyListeners();
  }

  disableButton() {
    isEnabled = false;
    notifyListeners();
  }
}
