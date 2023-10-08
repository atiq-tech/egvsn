import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:egovisionapp/core/data/datasources/remote_data_source.dart';
import 'package:egovisionapp/core/error/exceptions.dart';
import 'package:egovisionapp/core/error/failures.dart';

abstract class ProfileRepository {
  Future<Either<Failure, String>> changePassword(String userId, String currentPass, String newPass);
  Future<Either<Failure, String>> imageUpload(String userId, File image);

}

class ProfileRepositoryImp extends ProfileRepository {
  final RemoteDataSource remoteDataSource;
  ProfileRepositoryImp({required this.remoteDataSource});

  @override
  Future<Either<Failure, String>> changePassword(String userId, String currentPass, String newPass) async {
    try {
      final result = await remoteDataSource.passwordChange(userId, currentPass, newPass);
      return right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }
  @override
  Future<Either<Failure, String>> imageUpload(String userId, File image) async {
    try {
      final result = await remoteDataSource.imageUpload(userId, image);
      return right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

}