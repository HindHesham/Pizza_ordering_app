import 'dart:convert';

import 'CartModel.dart';

class Order {
  Order({this.restaurantId, this.cartItemList});

  int? restaurantId;
  List<Cart>? cartItemList;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        cartItemList: json["cart"] == null
            ? null
            : List<Cart>.from(json["cart"].map((x) => Cart.fromJson(x))),
        restaurantId: json['restuarantId'] ??= null,
      );

  Map<String, dynamic> toJson() => {
        "cart": cartItemList == null
            ? null
            : List<dynamic>.from(cartItemList!.map((x) => x.toJson()).toList()),
        'restuarantId': restaurantId ??= null,
      };
}
