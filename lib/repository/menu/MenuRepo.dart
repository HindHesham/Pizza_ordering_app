import 'package:pizza_ordering_app/data/network/ApiEndPoints.dart';
import 'package:pizza_ordering_app/data/network/BaseApiService.dart';
import 'package:pizza_ordering_app/data/network/NetworkApiService.dart';
import 'package:pizza_ordering_app/models/menu/MenuModel.dart';

class MenuRepo {
  final BaseApiService _apiService = NetworkApiService();

  Future<List<Menu>> getRestaurantMenu(int restaurantID) async {
    try {
      dynamic response = await _apiService
          .getResponse(ApiEndPoints().getRestaurantMenu(restaurantID));
      final res = response.map<Menu>((json) => Menu.fromJson(json)).toList();
      return res;
    } catch (e) {
      rethrow;
    }
  }
}
