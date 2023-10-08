import 'dart:convert';

class TypeModel {
  String id;
  String name;
  String status;
  String image;

  TypeModel({
    required this.id,
    required this.name,
    required this.status,
    required this.image,
  });

  factory TypeModel.fromJson(String str) => TypeModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TypeModel.fromMap(Map<String, dynamic> json) => TypeModel(
    id: json["id"]??'',
    name: json["name"]??'',
    status: json["status"]??'',
    image: json["image"]??'',
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "status": status,
    "image": image,
  };
}
