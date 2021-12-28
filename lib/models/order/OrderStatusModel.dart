class OrderStatus {
  OrderStatus(
      {this.orderId,
      this.totalPrice,
      this.status,
      this.orderedAt,
      this.esitmatedDelivery});
  int? orderId;
  int? totalPrice;
  String? status;
  String? orderedAt;
  String? esitmatedDelivery;

  factory OrderStatus.fromJson(Map<String, dynamic> json) => OrderStatus(
        orderId: json['orderId'] ??= null,
        totalPrice: json['totalPrice'] ??= null,
        status: json['status'] ??= null,
        orderedAt: json['orderedAt'] ??= null,
        esitmatedDelivery: json['esitmatedDelivery'] ??= null,
      );

  Map<String, dynamic> toJson() => {
        "orderId": orderId ??= null,
        'totalPrice': totalPrice ??= null,
        "status": status ??= null,
        'orderedAt': orderedAt ??= null,
        "esitmatedDelivery": esitmatedDelivery ??= null,
      };
}
