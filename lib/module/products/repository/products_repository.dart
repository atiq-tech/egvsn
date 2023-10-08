import 'package:dartz/dartz.dart';
import 'package:egovisionapp/core/data/datasources/remote_data_source.dart';
import 'package:egovisionapp/core/error/exceptions.dart';
import 'package:egovisionapp/core/error/failures.dart';
import 'package:egovisionapp/module/products/model/product_model.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<ProductModel>>> getProducts(Map<String?, String> body);

}

class ProductRepositoryImp extends ProductRepository {
  final RemoteDataSource remoteDataSource;
  ProductRepositoryImp({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ProductModel>>> getProducts(Map<String?, String> body) async {
    try {
      final result = await remoteDataSource.getProducts(body);
      return right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

}