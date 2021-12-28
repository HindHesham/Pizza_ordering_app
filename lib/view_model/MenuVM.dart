import 'package:flutter/cupertino.dart';
import 'package:pizza_ordering_app/data/response/ApiResponse.dart';
import 'package:pizza_ordering_app/models/menu/MenuModel.dart';
import 'package:pizza_ordering_app/repository/menu/MenuRepo.dart';

class MenuVM extends ChangeNotifier {
  final _menuRepo = MenuRepo();
  ApiResponse<List<Menu>> restaurantMenu = ApiResponse.loading();

  void _setRestaurantMenu(ApiResponse<List<Menu>> response) {
    restaurantMenu = response;
    notifyListeners();
  }

  Future<void> fetchRestaurantMenu(int id) async {
    _setRestaurantMenu(ApiResponse.loading());
    await _menuRepo
        .getRestaurantMenu(id)
        .then((value) => _setRestaurantMenu(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            _setRestaurantMenu(ApiResponse.error(error.toString())));
  }
}
