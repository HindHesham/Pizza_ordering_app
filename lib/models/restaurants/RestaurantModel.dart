class Restaurant {
  Restaurant(
      {this.id, this.name, this.address1, this.address2, this.lat, this.long});

  int? id;
  String? name;
  String? address1;
  String? address2;
  double? lat;
  double? long;

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
      id: json['id'] ??= null,
      name: json['name'] ??= null,
      address1: json['address1'] ??= null,
      address2: json['address2'] ??= null,
      lat: json['latitude'] ??= null,
      long: json['longitude'] ??= null);

  Map<String, dynamic> toJson() => {
        "id": id ??= null,
        'name': name ??= null,
        'address1': address1 ??= null,
        'address2': address2 ??= null,
        'latitude': lat ??= null,
        'longitude': long ??= null,
      };
}
