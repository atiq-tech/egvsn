import 'dart:convert';

class ProductModel {
  String productSlNo;
  String productCode;
  String productName;
  String ton;
  String productCategoryId;
  String typeId;
  String color;
  String brand;
  String size;
  String vat;
  String productReOrederLevel;
  String productPurchaseRate;
  String productSellingPrice;
  String productMinimumSellingPrice;
  String productWholesaleRate;
  String oneCartunEqual;
  String isService;
  String unitId;
  String image;
  String isFuture;
  String status;
  String addBy;
  String addTime;
  String updateBy;
  String updateTime;
  String productBranchid;
  String productCategoryName;
  String brandName;
  String name;

  ProductModel({
    required this.productSlNo,
    required this.productCode,
    required this.productName,
    required this.ton,
    required this.productCategoryId,
    required this.typeId,
    required this.color,
    required this.brand,
    required this.size,
    required this.vat,
    required this.productReOrederLevel,
    required this.productPurchaseRate,
    required this.productSellingPrice,
    required this.productMinimumSellingPrice,
    required this.productWholesaleRate,
    required this.oneCartunEqual,
    required this.isService,
    required this.unitId,
    required this.image,
    required this.isFuture,
    required this.status,
    required this.addBy,
    required this.addTime,
    required this.updateBy,
    required this.updateTime,
    required this.productBranchid,
    required this.productCategoryName,
    required this.brandName,
    required this.name,
  });

  factory ProductModel.fromJson(String str) => ProductModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductModel.fromMap(Map<String, dynamic> json) => ProductModel(
    productSlNo: json["Product_SlNo"]??"",
    productCode: json["Product_Code"]??"",
    productName: json["Product_Name"]??"",
    ton: json["ton"]??'',
    productCategoryId: json["ProductCategory_ID"]??"",
    typeId: json["type_id"]??'',
    color: json["color"]??'',
    brand: json["brand"]??'',
    size: json["size"]??'',
    vat: json["vat"]??"",
    productReOrederLevel: json["Product_ReOrederLevel"]??"",
    productPurchaseRate: json["Product_Purchase_Rate"]??"",
    productSellingPrice: json["Product_SellingPrice"]??"",
    productMinimumSellingPrice: json["Product_MinimumSellingPrice"]??"",
    productWholesaleRate: json["Product_WholesaleRate"]??"",
    oneCartunEqual: json["one_cartun_equal"]??"",
    isService: json["is_service"]??"",
    unitId: json["Unit_ID"]??"",
    image: json["image"]??"",
    isFuture: json["is_future"]??"",
    status: json["status"]??"",
    addBy: json["AddBy"]??"",
    addTime: json["AddTime"]??"",
    updateBy: json["UpdateBy"]??"",
    updateTime: json["UpdateTime"]??"",
    productBranchid: json["Product_branchid"]??"",
    productCategoryName: json["ProductCategory_Name"]??"",
    brandName: json["brand_name"]??"",
    name: json["name"]??"",
  );

  Map<String, dynamic> toMap() => {
    "Product_SlNo": productSlNo,
    "Product_Code": productCode,
    "Product_Name": productName,
    "ton": ton,
    "ProductCategory_ID": productCategoryId,
    "type_id": typeId,
    "color": color,
    "brand": brand,
    "size": size,
    "vat": vat,
    "Product_ReOrederLevel": productReOrederLevel,
    "Product_Purchase_Rate": productPurchaseRate,
    "Product_SellingPrice": productSellingPrice,
    "Product_MinimumSellingPrice": productMinimumSellingPrice,
    "Product_WholesaleRate": productWholesaleRate,
    "one_cartun_equal": oneCartunEqual,
    "is_service": isService,
    "Unit_ID": unitId,
    "image": image,
    "is_future": isFuture,
    "status": status,
    "AddBy": addBy,
    "AddTime": addTime,
    "UpdateBy": updateBy,
    "UpdateTime": updateTime,
    "Product_branchid": productBranchid,
    "ProductCategory_Name": productCategoryName,
    "brand_name": brandName,
    "name": name,
  };
}
