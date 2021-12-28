class Menu {
  Menu(
      {this.id,
      this.name,
      this.category,
      this.topping,
      this.price,
      this.rank,
      this.itemCounter});

  int? id;
  String? name;
  String? category;
  List<String>? topping;
  int? price;
  int? rank;
  int? itemCounter = 0;

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        id: json['id'] ??= null,
        name: json['name'] ??= null,
        category: json['category'] ??= null,
        price: json['price'] ??= null,
        rank: json['rank'] ??= 0,
        itemCounter: json['itemCounter'] ?? 0,
        topping: List<String>.from(
          json["topping"] ??= [],
        ),
      );

  Map<String, dynamic> toJson() => {
        "id": id ??= null,
        'name': name ??= null,
        'category': category ??= null,
        'price': price ??= null,
        'rank': rank ??= null,
        'topping': topping ??= null,
      };
}
