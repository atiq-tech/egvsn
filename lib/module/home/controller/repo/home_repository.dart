import 'package:dartz/dartz.dart';
import 'package:egovisionapp/core/error/exceptions.dart';
import 'package:egovisionapp/core/error/failures.dart';
import 'package:egovisionapp/module/home/model/home_model.dart';
import 'package:egovisionapp/module/home/model/search_model.dart';
import 'package:egovisionapp/module/home/model/types_model.dart';
import 'package:egovisionapp/module/products/model/product_model.dart';
import '../../../../core/data/datasources/remote_data_source.dart';


abstract class HomeRepository {
  Future<Either<Failure, HomeModel>> getHomeData();
  Future<Either<Failure, List<ProductModel>>> getSearchData();
  Future<Either<Failure, String>> checkUser(String userId);
}

class HomeRepositoryImp extends HomeRepository {
  final RemoteDataSource remoteDataSource;
  HomeRepositoryImp({required this.remoteDataSource});

  @override
  Future<Either<Failure, HomeModel>> getHomeData() async {
    try {
      final result = await remoteDataSource.getHomeData();
      return right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, List<ProductModel>>> getSearchData() async {
    try {
      final result = await remoteDataSource.getSearchData();
      return right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, String>> checkUser(String userId) async {
    try {
      final result = await remoteDataSource.checkUserStatus(userId);
      return right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }
}
