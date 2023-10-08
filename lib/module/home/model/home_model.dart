import 'dart:convert';

import 'package:egovisionapp/module/home/model/brand_model.dart';
import 'package:egovisionapp/module/home/model/category_model.dart';
import 'package:egovisionapp/module/home/model/color_model.dart';
import 'package:egovisionapp/module/home/model/slider_model.dart';
import 'package:egovisionapp/module/home/model/types_model.dart';

class HomeModel {
  List<ColorModel> colorApi;
  List<TypeModel> types;
  List<BrandModel> brands;
  List<CategoryModel> categories;
  List<SliderModel> sliders;

  HomeModel({
    required this.colorApi,
    required this.types,
    required this.brands,
    required this.categories,
    required this.sliders,
  });

  factory HomeModel.fromJson(String str) => HomeModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory HomeModel.fromMap(Map<String, dynamic> json) => HomeModel(
    colorApi: json['colors'] != null
        ? List<ColorModel>.from(json['colors']
        .map((x) => ColorModel.fromMap(x)))
        : [],
    types: json['types'] != null
        ? List<TypeModel>.from(json['types']
        .map((x) => TypeModel.fromMap(x)))
        : [],
    brands: json['brands'] != null
        ? List<BrandModel>.from(json['brands']
        .map((x) => BrandModel.fromMap(x)))
        : [],
    categories:  json['categories'] != null
        ? List<CategoryModel>.from(json['categories']
        .map((x) => CategoryModel.fromMap(x)))
        : [],
    sliders:  json['sliders'] != null
        ? List<SliderModel>.from(json['sliders']
        .map((x) => SliderModel.fromMap(x)))
        : [],
  );

  Map<String, dynamic> toMap() => {
    "colorApi": List<dynamic>.from(colorApi.map((x) => x.toJson())),
    "types": List<dynamic>.from(types.map((x) => x.toJson())),
    "brands": List<dynamic>.from(brands.map((x) => x.toJson())),
    "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
    "sliders": List<dynamic>.from(sliders.map((x) => x.toJson())),
  };
}