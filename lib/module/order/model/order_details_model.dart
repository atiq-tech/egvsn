import 'dart:convert';

class OrderDetailsModel {
  String id;
  String orderId;
  String productId;
  String purchaseRate;
  String saleRate;
  String discount;
  String quantity;
  String total;
  String status;
  String unitName;
  String productName;
  String productImage;

  OrderDetailsModel({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.purchaseRate,
    required this.saleRate,
    required this.discount,
    required this.quantity,
    required this.total,
    required this.status,
    required this.unitName,
    required this.productName,
    required this.productImage,
  });

  factory OrderDetailsModel.fromJson(String str) => OrderDetailsModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrderDetailsModel.fromMap(Map<String, dynamic> json) => OrderDetailsModel(
    id: json["id"],
    orderId: json["order_id"],
    productId: json["product_id"],
    purchaseRate: json["purchase_rate"],
    saleRate: json["sale_rate"],
    discount: json["discount"],
    quantity: json["quantity"],
    total: json["total"],
    status: json["status"],
    unitName: json["Unit_Name"],
    productName: json["Product_Name"],
    productImage: json["image"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "order_id": orderId,
    "product_id": productId,
    "purchase_rate": purchaseRate,
    "sale_rate": saleRate,
    "discount": discount,
    "quantity": quantity,
    "total": total,
    "status": status,
    "Unit_Name": unitName,
    "Product_Name": productName,
    "image": productImage,
  };
}
