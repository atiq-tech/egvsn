import 'dart:convert';

class ColorModel {
  String colorSiNo;
  String colorName;
  String description;
  String status;
  dynamic image;

  ColorModel({
    required this.colorSiNo,
    required this.colorName,
    required this.description,
    required this.status,
    this.image,
  });

  factory ColorModel.fromJson(String str) => ColorModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ColorModel.fromMap(Map<String, dynamic> json) => ColorModel(
    colorSiNo: json["color_SiNo"],
    colorName: json["color_name"],
    description: json["description"],
    status: json["status"],
    image: json["image"],
  );

  Map<String, dynamic> toMap() => {
    "color_SiNo": colorSiNo,
    "color_name": colorName,
    "description": description,
    "status": status,
    "image": image,
  };
}
