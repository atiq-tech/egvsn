import 'package:hive/hive.dart';

class UpdateProduct {
  String? id;
  String? orderId;
  String? name;
  String? img;
  String? status;
  double? qtn;
  double? sellingPrice;
  String? purchasePrice;
  double? totalPrice;

  UpdateProduct({this.id,this.orderId,this.name, this.img, this.status, this.qtn, this.sellingPrice,this.purchasePrice, this.totalPrice,});

  UpdateProduct.fromJson(Map<String, dynamic> json) {
    id = json["product_id"];
    orderId = json["order_id"];
    purchasePrice = json["purchase_rate"];
    sellingPrice = json["sale_rate"];
    qtn = json["quantity"];
    totalPrice = json["total"];
    status = json["status"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["product_id"] = id;
    data["order_id"] = orderId;
    data["purchase_rate"] = purchasePrice;
    data["sale_rate"] = sellingPrice;
    data["quantity"] = qtn;
    data["total"] = totalPrice;
    data["status"] = status;
    return data;
  }

}

class UpdateProductAdapter extends TypeAdapter<UpdateProduct> {
  @override
  final typeId = 1;

  @override
  UpdateProduct read(BinaryReader reader) {
    final name = reader.readString();
    final id = reader.readString();
    final orderId = reader.readString();
    final img = reader.readString();
    final status = reader.readString();
    final qtn = reader.readDouble();
    final sellingPrice = reader.readDouble();
    final puschacePrice = reader.readString();
    final totalPrice = reader.readDouble();
    return UpdateProduct(id: id, orderId: orderId, name: name, img: img, status: status, qtn: qtn, sellingPrice: sellingPrice,purchasePrice: puschacePrice,totalPrice:totalPrice );
  }

  @override
  void write(BinaryWriter writer, UpdateProduct obj) {
    writer.writeString("${obj.name}");
    writer.writeString("${obj.id}");
    writer.writeString("${obj.orderId}");
    writer.writeString("${obj.img}");
    writer.writeString("${obj.status}");
    writer.writeDouble(double.parse("${obj.qtn}"));
    writer.writeDouble(double.parse("${obj.sellingPrice}"));
    writer.writeString("${obj.purchasePrice}");
    writer.writeDouble(double.parse("${obj.totalPrice}"));
  }
}
