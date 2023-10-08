import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:egovisionapp/core/error/exceptions.dart';
import 'package:egovisionapp/core/remote_url.dart';
import 'package:egovisionapp/module/authentication/login/model/user_login_response_model.dart';
import 'package:egovisionapp/module/home/model/home_model.dart';
import 'package:egovisionapp/module/home/model/search_model.dart';
import 'package:egovisionapp/module/order/model/order_details_model.dart';
import 'package:egovisionapp/module/order/model/order_model.dart';

import 'package:egovisionapp/module/products/model/product_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';


abstract class RemoteDataSource{

  Future<UserLoginResponseModel> signIn(Map<String, dynamic> body);

  Future<HomeModel>getHomeData();
  Future<List<ProductModel>>getProducts(Map<String?, String> body);

  Future<String> userRegister(Map<String, dynamic> userInfo);
  Future<String> otpVerifyForUser(Map<String, dynamic> userInfo);
  // Future<String> orderPost(Map<String, dynamic> orderInfo);
  Future<List<ProductModel>> getSearchData();
  Future<List<OrderModel>> getAllOrderData(String userId, String status);
  Future<List<OrderDetailsModel>> getOrderDetails(String orderId);
  Future<String> passwordChange(String userId, String currentPass, String newPassa);
  Future<String> imageUpload(String userId, File image);
  Future<String> checkUserStatus(String userId);

}

typedef CallClientMethod = Future<http.Response> Function();

class RemoteDataSourceImpl extends RemoteDataSource{

  final http.Client client;
  final _className = 'RemoteDataSourceImpl';

  RemoteDataSourceImpl({required this.client});

  Future<dynamic> callClientWithCatchException(
      CallClientMethod callClientMethod) async {
    try {
      final response = await callClientMethod();
      log(response.statusCode.toString(), name: _className);
      log(response.body, name: _className);
      if (kDebugMode) {
        print("status code : ${response.statusCode}");
        print(response.body);
      }
      return _responseParser(response);
    } on SocketException {
      log('SocketException', name: _className);
      // var text = '';
      // var connectivityResult = await (Connectivity().checkConnectivity());
      // print(connectivityResult.name);
      // if (connectivityResult == ConnectivityResult.none) {
      //   text = 'Internet Connection';
      // }  else if (connectivityResult == ConnectivityResult.mobile) {
      //   text = 'Mobile Data Connection';
      // } else if (connectivityResult == ConnectivityResult.wifi) {
      //   text = 'Wifi Connection';
      // }
      throw const NetworkException('Please check your \nInternet Connection', 10061);
    } on FormatException {
      log('FormatException', name: _className);
      throw const DataFormatException('Data format exception', 422);
    } on http.ClientException {
      ///503 Service Unavailable
      log('http ClientException', name: _className);
      throw const NetworkException('Service unavailable', 503);
    } on TimeoutException {
      log('TimeoutException', name: _className);
      throw const NetworkException('Request timeout', 408);
    }
  }

  @override
  Future<UserLoginResponseModel> signIn(Map body) async {
    final headers = {'Accept': 'application/json'};
    final uri = Uri.parse(RemoteUrls.userLogin);

    final clientMethod = client.post(uri, headers: headers, body: body);
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);


    if (responseJsonBody["success"] == "failed") {
      final errorMsg = responseJsonBody['success'];
      throw UnauthorisedException(errorMsg, 401);
    } else{
      return UserLoginResponseModel.fromMap(responseJsonBody);
    }
  }

  @override
  Future<HomeModel>getHomeData() async {
    final uri = Uri.parse(RemoteUrls.getHomeData);

    print('Get home data $uri');

    final clientMethod = client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);

    // if (responseJsonBody["success"] == false) {
    //   final errorMsg = parsingDoseNotExist(responseJsonBody);
    //   throw UnauthorisedException(errorMsg, 401);
    // } {
    //   return List.from(responseJsonBody["data"]).map((e) => PlansBillingModel.fromMap(e)).toList();
    // }

    return HomeModel.fromMap(responseJsonBody);

  }

  @override
  Future<List<ProductModel>>getProducts(Map<String?, String> body) async {
    final uri = Uri.parse(RemoteUrls.getProducts);

    print('Get products $uri');

    final clientMethod = client.post(
      uri,
      headers: {'Content-Type': 'application/x-www-form-urlencoded', 'Accept': '*/*',},
      body: body,
    );
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);

    // if (responseJsonBody["success"] == false) {
    //   final errorMsg = parsingDoseNotExist(responseJsonBody);
    //   throw UnauthorisedException(errorMsg, 401);
    // } {
    //   return List.from(responseJsonBody["data"]).map((e) => PlansBillingModel.fromMap(e)).toList();
    // }

    return List.from(responseJsonBody["products"]).map((e) => ProductModel.fromMap(e)).toList();

  }

  @override
  Future<List<ProductModel>>getSearchData() async {
    final uri = Uri.parse(RemoteUrls.getSearchData);
    print('Get Search products $uri');

    final clientMethod = client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);

    // if (responseJsonBody["success"] == false) {
    //   final errorMsg = parsingDoseNotExist(responseJsonBody);
    //   throw UnauthorisedException(errorMsg, 401);
    // } {
    //   return List.from(responseJsonBody["data"]).map((e) => PlansBillingModel.fromMap(e)).toList();
    // }

    return List.from(responseJsonBody["contents"]).map((e) => ProductModel.fromMap(e)).toList();

  }

  @override
  Future<List<OrderModel>>getAllOrderData(String userId, String status) async {
    final uri = Uri.parse(RemoteUrls.getOrderData);
    print('Get All Orders $uri');

    final data = {
      "userId": userId,
      "status": status
    };

    print('data ajkshdfas $data');

    final clientMethod = client.post(
      uri,
      headers: {'Content-Type': 'application/x-www-form-urlencoded', 'Accept': '*/*',},
      body: data,
    );
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);

    // if (responseJsonBody["success"] == false) {
    //   final errorMsg = parsingDoseNotExist(responseJsonBody);
    //   throw UnauthorisedException(errorMsg, 401);
    // } {
    //   return List.from(responseJsonBody["data"]).map((e) => PlansBillingModel.fromMap(e)).toList();
    // }

    return List.from(responseJsonBody["contents"]).map((e) => OrderModel.fromMap(e)).toList();

  }

  @override
  Future<List<OrderDetailsModel>>getOrderDetails(String orderId) async {
    final uri = Uri.parse(RemoteUrls.getOrderDetails);
    print('Get Orders details $uri');

    final data = {
      "orderId": orderId
    };

    print('data ajkshdfas $data');

    final clientMethod = client.post(
      uri,
      headers: {'Content-Type': 'application/x-www-form-urlencoded', 'Accept': '*/*',},
      body: data,
    );
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);

    // if (responseJsonBody["success"] == false) {
    //   final errorMsg = parsingDoseNotExist(responseJsonBody);
    //   throw UnauthorisedException(errorMsg, 401);
    // } {
    //   return List.from(responseJsonBody["data"]).map((e) => PlansBillingModel.fromMap(e)).toList();
    // }

    return List.from(responseJsonBody["contents"]).map((e) => OrderDetailsModel.fromMap(e)).toList();
  }

  @override
  Future<String> userRegister(Map<String, dynamic> userInfo) async {
    final uri = Uri.parse(RemoteUrls.userVerify);

    print("Verify user url: $uri");

    final clientMethod = client.post(
      uri,
      headers: {'Accept': 'application/json'},
      body: userInfo,
    );
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);
    if (responseJsonBody["success"] == false) {
      final errorMsg = responseJsonBody['message'].toString();
      throw UnauthorisedException(errorMsg, 401);
    } {
      return responseJsonBody['message'];
    }
  }

  @override
  Future<String> passwordChange(String userId, String currentPass, String newPass) async {
    final uri = Uri.parse(RemoteUrls.changePassword);

    print("Password change url: $uri");
    final data = {
      "id": userId,
      "cpassword": currentPass,
      "password": newPass
    };
    print("Password change datas: $data");

    final clientMethod = client.post(
      uri,
      headers: {'Content-Type': 'application/x-www-form-urlencoded', 'Accept': '*/*',},
      body: data,
    );
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);
    if (responseJsonBody["success"] == false) {
      final errorMsg = responseJsonBody['message'].toString();
      throw UnauthorisedException(errorMsg, 401);
    } {
      return responseJsonBody['message'];
    }
  }

  @override
  Future<String> imageUpload(String userId, File image) async {
    final uri = Uri.parse(RemoteUrls.imageUpload);

    print("Image Upload url: $uri");
    final data = {
      "id": userId,
      "image": image.readAsBytesSync(),
    };
    print("Image Upload data: $data");

    final request = http.MultipartRequest("POST", uri,);
    request.fields['id'] = userId;
    request.files.add(await http.MultipartFile.fromPath('image', image.path));
    var response = await request.send();

    // Get the response from the server
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print('respomseeee+++++++++++++ ${responseString}');
    var res = responseString.replaceAll('{', '').replaceAll('}', '').split(':').last.replaceAll('"', '');
    print('jklahsfkjasfh ${res}');
    return res;
    // final responseJsonBody =
    // await callClientWithCatchException(() => clientMethod);
    // return responseJsonBody['success'];
    // if (responseJsonBody["success"] == false) {
    //   final errorMsg = responseJsonBody['message'].toString();
    //   throw UnauthorisedException(errorMsg, 401);
    // } {
    //   return responseJsonBody['success'];
    // }
  }

  @override
  Future<String> otpVerifyForUser(Map<String, dynamic> userInfo) async {
    final uri = Uri.parse(RemoteUrls.otpVerifyForUser);
    print("Verify user otp: $uri");
    print("Verify user otp: $userInfo");
    final clientMethod = client.post(
      uri,
      headers: {'Accept': 'application/json'},
      body: userInfo,
    );
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);
    if (responseJsonBody["success"] == false) {
      final errorMsg = responseJsonBody['message'].toString();
      throw UnauthorisedException(errorMsg, 401);
    } {
      return responseJsonBody['message'];
    }
  }


  @override
  Future<String>checkUserStatus(String userId) async {
    final uri = Uri.parse(RemoteUrls.checkUserStatus);
    print('Check User Status $uri');

    final data = {
      "id": userId
    };
    print('user status $data');
    final clientMethod = client.post(
      uri,
      headers: {'Content-Type': 'application/x-www-form-urlencoded', 'Accept': '*/*',},
      body: data,
    );
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);

    if (responseJsonBody["success"] == false) {
      // final errorMsg = parsingDoseNotExist(responseJsonBody);
      throw UnauthorisedException(responseJsonBody['message'], 401);
    } {
      return responseJsonBody['message'];
    }

  }

  // @override
  // Future<String> orderPost(Map<String, dynamic> orderInfo) async {
  //   final uri = Uri.parse(RemoteUrls.userOrders);
  //   print("User order url: $uri");
  //   print("User data: ${jsonEncode(orderInfo)}");
  //
  //   final clientMethod = client.post(
  //     uri,
  //     headers: {'Content-Type': 'multipart/form-data', 'Accept': '*/*',},
  //     body: "${orderInfo}",
  //   );
  //   final responseJsonBody =
  //   await callClientWithCatchException(() => clientMethod);
  //
  //   if (responseJsonBody["success"] == false) {
  //     final errorMsg = responseJsonBody['message'].toString();
  //     throw UnauthorisedException(errorMsg, 401);
  //   } {
  //     return responseJsonBody['message'];
  //   }
  // }








  dynamic _responseParser(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body);
        // if (responseJson["status"] != null) {
        //   if (responseJson["status"] == 0) {
        //     if (kDebugMode) {
        //       print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
        //     }
        //     final errorMsg = parsingDoseNotExist(responseJson["message"]);
        //     throw ServerResponseException(errorMsg, 201);
        //   }
        // }
        return responseJson;
      case 400:
        final errorMsg = parsingDoseNotExist(response.body);
        throw BadRequestException(errorMsg, 400);
      case 401:
        final errorMsg = parsingDoseNotExist(response.body);
        throw UnauthorisedException(errorMsg, 401);
      case 402:
        final errorMsg = parsingDoseNotExist(response.body);
        throw UnauthorisedException(errorMsg, 402);
      case 403:
        final errorMsg = parsingDoseNotExist(response.body);
        throw UnauthorisedException(errorMsg, 403);
      case 404:
        throw const UnauthorisedException('Request not found', 404);
      case 405:
        throw const UnauthorisedException('Method not allowed', 405);
      case 408:

      ///408 Request Timeout
        throw const NetworkException('Request timeout', 408);
      case 415:

      /// 415 Unsupported Media Type
        throw const DataFormatException('Data format exception');

      case 422:

      ///UnProcessable Entity
        final errorMsg = parsingError(response.body);
        throw InvalidInputException(errorMsg, 422);
      case 500:

      ///500 Internal Server Error
        throw const InternalServerException('Internal server error', 500);

      default:
        throw FetchDataException(
            'Error occurred while communication with Server',
            response.statusCode);
    }
  }
  String parsingError(String body) {
    final errorsMap = json.decode(body);
    try {
      if (errorsMap['errors'] != null) {
        final errors = errorsMap['errors'] as Map;
        final firstErrorMsg = errors.values.first;
        if (firstErrorMsg is List) return firstErrorMsg.first;
        return firstErrorMsg.toString();
      }
      if (errorsMap['message'] != null) {
        return errorsMap['message'];
      }
    } catch (e) {
      log(e.toString(), name: _className);
    }

    return 'Unknown error';
  }
  String parsingDoseNotExist(String body) {
    final errorsMap = json.decode(body);
    try {
      if (errorsMap['notification'] != null) {
        return errorsMap['notification'];
      }
      if (errorsMap['message'] != null) {
        return errorsMap['message'];
      }
    } catch (e) {
      log(e.toString(), name: _className);
    }
    return 'Credentials does not match';
  }

}