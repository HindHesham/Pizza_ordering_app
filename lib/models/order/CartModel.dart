class Cart {
  Cart({this.menuItemId, this.quantity});

  int? menuItemId;
  int? quantity;

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        menuItemId: json['menuItemId'] ??= null,
        quantity: json['quantity'] ??= null,
      );

  Map<String, dynamic> toJson() => {
        "menuItemId": menuItemId ??= null,
        'quantity': quantity ??= null,
      };
}
