import 'package:pizza_ordering_app/data/network/ApiEndPoints.dart';
import 'package:pizza_ordering_app/data/network/BaseApiService.dart';
import 'package:pizza_ordering_app/data/network/NetworkApiService.dart';
import 'package:pizza_ordering_app/models/restaurants/RestaurantModel.dart';

class RestaurantsRepo {
  final BaseApiService _apiService = NetworkApiService();

  Future<List<Restaurant>> getRestaurantsList() async {
    try {
      dynamic response =
          await _apiService.getResponse(ApiEndPoints().getRestaurants);
      final res = response
          .map<Restaurant>((json) => Restaurant.fromJson(json))
          .toList();
      return res;
    } catch (e) {
      rethrow;
    }
  }

  Future<Restaurant> getRestaurantDetails(int id) async {
    try {
      dynamic response = await _apiService
          .getResponse(ApiEndPoints().getRestaurants + id.toString());
      final res = Restaurant.fromJson(response);

      return res;
    } catch (e) {
      rethrow;
    }
  }
}
