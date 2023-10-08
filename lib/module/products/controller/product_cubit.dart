import 'package:egovisionapp/module/home/controller/repo/home_repository.dart';
import 'package:egovisionapp/module/home/model/home_model.dart';
import 'package:egovisionapp/module/home/model/types_model.dart';
import 'package:egovisionapp/module/products/model/product_model.dart';
import 'package:egovisionapp/module/products/repository/products_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit(this.productRepository) : super(const ProductStateLoading());
  final ProductRepository productRepository;

  Future<void> getProducts(String typeId, String catId, String brandId, String colorId, bool isLoading) async {

    if (isLoading) {
      emit(const ProductStateLoading());
    }

    final body = {
      "${typeId}".isEmpty ? '' : "typeId": typeId,
      "${catId}".isEmpty ? '' : "catId": catId,
      "${brandId}".isEmpty ? '' : "brandId": brandId,
      "${colorId}".isEmpty ? '' : "colorId": colorId,
    };

    print("kjhjkasdf $body");

    final result = await productRepository.getProducts(body);
    result.fold(
      (error) => emit(
        ProductStateError(error.message),
      ),
      (data) => emit(
        ProductStateLoaded(data.where((element) => element.isFuture == '1').toList()),
      ),
    );
  }

}
