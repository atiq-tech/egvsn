import 'dart:convert';

class SearchDataModel {
  String productSlNo;
  String productCode;
  String productName;
  String productCategoryId;
  String productPurchaseRate;
  String productSellingPrice;
  String image;
  String unitName;

  SearchDataModel({
    required this.productSlNo,
    required this.productCode,
    required this.productName,
    required this.productCategoryId,
    required this.productPurchaseRate,
    required this.productSellingPrice,
    required this.image,
    required this.unitName,
  });

  factory SearchDataModel.fromJson(String str) => SearchDataModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SearchDataModel.fromMap(Map<String, dynamic> json) => SearchDataModel(
    productSlNo: json["Product_SlNo"],
    productCode: json["Product_Code"],
    productName: json["Product_Name"],
    productCategoryId: json["ProductCategory_ID"],
    productPurchaseRate: json["Product_Purchase_Rate"],
    productSellingPrice: json["Product_SellingPrice"],
    image: json["image"],
    unitName: json["Unit_Name"],
  );

  Map<String, dynamic> toMap() => {
    "Product_SlNo": productSlNo,
    "Product_Code": productCode,
    "Product_Name": productName,
    "ProductCategory_ID": productCategoryId,
    "Product_Purchase_Rate": productPurchaseRate,
    "Product_SellingPrice": productSellingPrice,
    "image": image,
    "Unit_Name": unitName,
  };
}
