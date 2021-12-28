class ApiEndPoints {
  final String getRestaurants = "restaurants/";

  String getRestaurantMenu(int id) {
    return "restaurants/$id/menu";
  }

  final String createOrder = "orders/";
}
