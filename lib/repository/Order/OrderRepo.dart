import 'dart:convert';

import 'package:pizza_ordering_app/data/network/ApiEndPoints.dart';
import 'package:pizza_ordering_app/data/network/BaseApiService.dart';
import 'package:pizza_ordering_app/data/network/NetworkApiService.dart';
import 'package:pizza_ordering_app/models/order/OrderObjModel.dart';
import 'package:pizza_ordering_app/models/order/OrderStatusModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderRepo {
  final BaseApiService _apiService = NetworkApiService();

  Future<OrderStatus> createOrder(Order order) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      dynamic response = await _apiService.postResponse(
          ApiEndPoints().createOrder, order.toJson());

      final res = OrderStatus.fromJson(response);
      await prefs.setInt("orderID", res.orderId!);
      return res;
    } catch (e) {
      rethrow;
    }
  }

  Future<OrderStatus> getOrderStatus(int orederID) async {
    try {
      String url = ApiEndPoints().createOrder + orederID.toString();
      dynamic response = await _apiService.getResponse(url);
      final res = OrderStatus.fromJson(response);
      return res;
    } catch (e) {
      rethrow;
    }
  }
}
