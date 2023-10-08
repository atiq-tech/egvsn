import 'dart:convert';

import 'package:equatable/equatable.dart';

class UserLoginModel extends Equatable {
  final String id;
  final String code;
  final String name;
  final String phone;
  final String address;
  final String password;
  final dynamic organizationName;
  final dynamic image;
  final String status;
  final String branchId;
  final String customerSlNo;
  final String ownerName;
  final String customerMobile;
  final String customerEmail;
  final String customerAddress;
  final String area;
  final String officerName;


  const UserLoginModel({
    required this.id,
    required this.code,
    required this.name,
    required this.phone,
    required this.address,
    required this.password,
    required this.organizationName,
    required this.image,
    required this.status,
    required this.branchId,
    required this.customerSlNo,
    required this.ownerName,
    required this.customerMobile,
    required this.customerEmail,
    required this.customerAddress,
    required this.area,
    required this.officerName,
  });

  @override
  List<Object?> get props {
    return [
      id,
      code,
      name,
      phone,
      address,
      password,
      organizationName,
      image,
      status,
      branchId,
      customerSlNo,
      ownerName,
      customerMobile,
      customerEmail,
      customerAddress,
      area,
      officerName,
    ];
  }

  UserLoginModel copyWith({
    String? id,
    String? code,
    String? name,
    String? phone,
    String? address,
    String? password,
    dynamic organizationName,
    dynamic image,
    String? status,
    String? branchId,
    String? customerSlNo,
    String? ownerName,
    String? customerMobile,
    String? customerEmail,
    String? customerAddress,
    String? area,
    String? officerName,

  }) {
    return UserLoginModel(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      password: password ?? this.password,
      organizationName: organizationName ?? this.organizationName,
      image: image ?? this.image,
      status: status ?? this.status,
      branchId: branchId ?? this.branchId,
      customerSlNo: customerSlNo ?? this.customerSlNo,
      ownerName: ownerName ?? this.ownerName,
      customerMobile: customerMobile ?? this.customerMobile,
      customerEmail: customerEmail ?? this.customerEmail,
      customerAddress: customerAddress ?? this.customerAddress,
      area: area ?? this.area,
      officerName: officerName ?? this.officerName,

    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'code': code});
    result.addAll({'phone': phone});
    result.addAll({'address': address});
    result.addAll({'password': password});
    result.addAll({'organization_name': organizationName});
    result.addAll({'image': image});
    result.addAll({'status': status});
    result.addAll({'branch_id': branchId});
    result.addAll({'Customer_SlNo': customerSlNo});
    result.addAll({'owner_name': ownerName});
    result.addAll({'Customer_Mobile': customerMobile});
    result.addAll({'Customer_Email': customerEmail});
    result.addAll({'Customer_Address': customerAddress});
    result.addAll({'area': area});
    result.addAll({'officer_name': officerName});

    return result;
  }

  factory UserLoginModel.fromMap(Map<String, dynamic> map) {
    return UserLoginModel(
      id: map['id']?? '',
      code: map['code']?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      password: map['password'] ?? '',
      organizationName: map['organization_name'] ?? '',
      image: map['image'],
      status: map['status']??'',
      branchId: map['branch_id']??'',
      customerSlNo: map["Customer_SlNo"]??'',
      ownerName: map["owner_name"]??'',
      customerMobile: map["Customer_Mobile"]??'',
      customerEmail: map["Customer_Email"]??'',
      customerAddress: map["Customer_Address"]??'',
      area: map["area"]??'',
      officerName: map["officer_name"]??'',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserLoginModel.fromJson(String source) =>
      UserLoginModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserProfileModel(id: $id, name: $name,'
        'code: $code, image: $image, phone: $phone,'
        'status: $status, organization_name: $organizationName'
        'branch_id: $branchId, Customer_SlNo: $customerSlNo'
        'owner_name: $ownerName, Customer_Mobile: $customerMobile'
        'Customer_Email: $customerEmail, Customer_Address: $customerAddress'
        'area: $area, officer_name: $officerName'
        'address: $address, password": $password)';
  }
}
