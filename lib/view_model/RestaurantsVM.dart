import 'package:flutter/cupertino.dart';
import 'package:pizza_ordering_app/data/response/ApiResponse.dart';
import 'package:pizza_ordering_app/models/restaurants/RestaurantModel.dart';
import 'package:pizza_ordering_app/repository/restaurants/RestaurantsRepo.dart';

class RestaurantsVM extends ChangeNotifier {
  final _restaurantsRepo = RestaurantsRepo();
  ApiResponse<List<Restaurant>> restaurants = ApiResponse.loading();
  ApiResponse<Restaurant> restaurantDetails = ApiResponse.loading();

  void _setRestaurants(ApiResponse<List<Restaurant>> response) {
    restaurants = response;
    notifyListeners();
  }

  Future<void> fetchRestaurants() async {
    _setRestaurants(ApiResponse.loading());
    await _restaurantsRepo
        .getRestaurantsList()
        .then((value) => _setRestaurants(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            _setRestaurants(ApiResponse.error(error.toString())));
  }

  void _setRestaurantDetails(ApiResponse<Restaurant> response) {
    restaurantDetails = response;
    notifyListeners();
  }

  Future<void> fetchRestaurantDetails(int id) async {
    _setRestaurantDetails(ApiResponse.loading());
    await _restaurantsRepo
        .getRestaurantDetails(id)
        .then((value) => _setRestaurantDetails(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            _setRestaurantDetails(ApiResponse.error(error.toString())));
  }
}
