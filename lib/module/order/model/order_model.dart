import 'dart:convert';

class OrderModel {
  String id;
  String customerId;
  String date;
  String invoice;
  String total;
  String status;
  String note;
  String createAt;
  String updateBy;
  String updateDate;
  String branchId;
  String name;
  String organizationName;

  OrderModel({
    required this.id,
    required this.customerId,
    required this.date,
    required this.invoice,
    required this.total,
    required this.status,
    required this.note,
    required this.createAt,
    required this.updateBy,
    required this.updateDate,
    required this.branchId,
    required this.name,
    required this.organizationName,
  });

  factory OrderModel.fromJson(String str) => OrderModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrderModel.fromMap(Map<String, dynamic> json) => OrderModel(
    id: json["id"]??'',
    customerId: json["customer_id"]??'',
    date: json["date"]??'',
    invoice: json["invoice"]??'',
    total: json["total"]??'',
    status: json["status"]??'',
    note: json["note"]??'',
    createAt: json["create_at"]??'',
    updateBy: json["update_by"]??'',
    updateDate: json["update_date"]??'',
    branchId: json["branch_id"]??'',
    name: json["name"]??'',
    organizationName: json["organization_name"]??'',
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "customer_id": customerId,
    "date": date,
    "invoice": invoice,
    "total": total,
    "status": status,
    "note": note,
    "create_at": createAt,
    "update_by": updateBy,
    "update_date": updateDate,
    "branch_id": branchId,
    "name": name,
    "organization_name": organizationName,
  };
}
