import 'package:egovisionapp/core/data/datasources/local_data_source.dart';
import 'package:egovisionapp/core/data/datasources/remote_data_source.dart';
import 'package:egovisionapp/core/error/exceptions.dart';
import 'package:egovisionapp/core/error/failures.dart';
import 'package:dartz/dartz.dart';

abstract class AppSettingRepository {
  Either<Failure, bool> checkOnBoarding();
  Future<Either<Failure, bool>> cacheOnBoarding();
}

class AppSettingRepositoryImp extends AppSettingRepository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;
  AppSettingRepositoryImp({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Either<Failure, bool> checkOnBoarding() {
    try {
      final result = localDataSource.checkOnBoarding();

      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> cacheOnBoarding() async {
    try {
      return Right(await localDataSource.cacheOnBoarding());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }
}
