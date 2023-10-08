// To parse this JSON data, do
//
//     final brandModel = brandModelFromJson(jsonString);

import 'dart:convert';

class BrandModel {
  String brandSiNo;
  String productCategorySlNo;
  String brandName;
  String status;
  String brandBranchid;
  dynamic image;

  BrandModel({
    required this.brandSiNo,
    required this.productCategorySlNo,
    required this.brandName,
    required this.status,
    required this.brandBranchid,
    this.image,
  });

  factory BrandModel.fromJson(String str) => BrandModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BrandModel.fromMap(Map<String, dynamic> json) => BrandModel(
    brandSiNo: json["brand_SiNo"],
    productCategorySlNo: json["ProductCategory_SlNo"],
    brandName: json["brand_name"],
    status: json["status"],
    brandBranchid: json["brand_branchid"],
    image: json["image"],
  );

  Map<String, dynamic> toMap() => {
    "brand_SiNo": brandSiNo,
    "ProductCategory_SlNo": productCategorySlNo,
    "brand_name": brandName,
    "status": status,
    "brand_branchid": brandBranchid,
    "image": image,
  };
}
