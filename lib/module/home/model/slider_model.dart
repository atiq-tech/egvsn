import 'dart:convert';

class SliderModel {
  String id;
  String image;
  String status;

  SliderModel({
    required this.id,
    required this.image,
    required this.status,
  });

  factory SliderModel.fromJson(String str) => SliderModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SliderModel.fromMap(Map<String, dynamic> json) => SliderModel(
    id: json["id"],
    image: json["image"],
    status: json["status"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "image": image,
    "status": status,
  };
}
