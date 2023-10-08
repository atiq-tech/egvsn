import 'dart:convert';

class CategoryModel {
  String productCategorySlNo;
  String productCategoryName;
  String productCategoryDescription;
  String status;
  String addBy;
  DateTime addTime;
  String updateBy;
  String updateTime;
  String categoryBranchid;
  dynamic image;

  CategoryModel({
    required this.productCategorySlNo,
    required this.productCategoryName,
    required this.productCategoryDescription,
    required this.status,
    required this.addBy,
    required this.addTime,
    required this.updateBy,
    required this.updateTime,
    required this.categoryBranchid,
    this.image,
  });

  factory CategoryModel.fromJson(String str) => CategoryModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromMap(Map<String, dynamic> json) => CategoryModel(
    productCategorySlNo: json["ProductCategory_SlNo"],
    productCategoryName: json["ProductCategory_Name"],
    productCategoryDescription: json["ProductCategory_Description"],
    status: json["status"],
    addBy: json["AddBy"],
    addTime: DateTime.parse(json["AddTime"]),
    updateBy: json["UpdateBy"],
    updateTime: json["UpdateTime"],
    categoryBranchid: json["category_branchid"],
    image: json["image"],
  );

  Map<String, dynamic> toMap() => {
    "ProductCategory_SlNo": productCategorySlNo,
    "ProductCategory_Name": productCategoryName,
    "ProductCategory_Description": productCategoryDescription,
    "status": status,
    "AddBy": addBy,
    "AddTime": addTime.toIso8601String(),
    "UpdateBy": updateBy,
    "UpdateTime": updateTime,
    "category_branchid": categoryBranchid,
    "image": image,
  };
}
