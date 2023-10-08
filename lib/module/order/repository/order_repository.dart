import 'package:dartz/dartz.dart';
import 'package:egovisionapp/core/data/datasources/remote_data_source.dart';
import 'package:egovisionapp/core/error/exceptions.dart';
import 'package:egovisionapp/core/error/failures.dart';
import 'package:egovisionapp/module/order/model/order_details_model.dart';
import 'package:egovisionapp/module/order/model/order_model.dart';

abstract class OrderRepository {
  // Future<Either<Failure, String>> orderPost(Map<String, dynamic> body);
  Future<Either<Failure, List<OrderModel>>> getAllOrderData(String userId, String status);
  Future<Either<Failure, List<OrderDetailsModel>>> getOrderDetails(String orderId);
}

class OrderRepositoryImp extends OrderRepository {
  final RemoteDataSource remoteDataSource;
  OrderRepositoryImp({required this.remoteDataSource});

  // @override
  // Future<Either<Failure, String>> orderPost(Map<String, dynamic> body) async {
  //   try {
  //     final result = await remoteDataSource.orderPost(body);
  //     return right(result);
  //   } on ServerException catch (e) {
  //     return Left(ServerFailure(e.message, e.statusCode));
  //   }
  // }
  @override
    Future<Either<Failure, List<OrderModel>>> getAllOrderData(String userId, String status) async {
      try {
        final result = await remoteDataSource.getAllOrderData(userId, status);
        return right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message, e.statusCode));
      }
    }

  @override
    Future<Either<Failure, List<OrderDetailsModel>>> getOrderDetails(String orderId) async {
      try {
        final result = await remoteDataSource.getOrderDetails(orderId);
        return right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message, e.statusCode));
      }
    }

}