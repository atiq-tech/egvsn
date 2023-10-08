import 'package:egovisionapp/module/home/controller/repo/home_repository.dart';
import 'package:egovisionapp/module/home/model/home_model.dart';
import 'package:egovisionapp/module/home/model/search_model.dart';
import 'package:egovisionapp/module/home/model/types_model.dart';
import 'package:egovisionapp/module/products/model/product_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_controller_state.dart';

class HomeControllerCubit extends Cubit<HomeControllerState> {
  HomeControllerCubit(HomeRepository homeRepository)
      : _homeRepository = homeRepository,
        super(HomeControllerLoading()) {
    getHomeData();
  }

  final HomeRepository _homeRepository;
  final searchController = TextEditingController();

  HomeModel? homeModel;

  List<ProductModel> productModel = [];
  String userStatus = '';

  Future<void> userCheck(userId) async {
    final result = await _homeRepository.checkUser('$userId');
    result.fold(
      (failure) {
        userStatus = failure.message;
      },
      (data) {
        print("JJKHJKH${data}");
        userStatus = data;
        print("JJKHJKH1${userStatus}");
      },
    );
  }

  Future<void> getHomeData() async {
    emit(HomeControllerLoading());
    final result = await _homeRepository.getHomeData();

    result.fold((failure) {
      emit(HomeControllerError(errorMessage: failure.message));
    }, (data) {
      homeModel = data;

      emit(HomeControllerLoaded(homeModel: data));
    });
  }

  Future<void> getSearchData() async {
    // emit(HomeControllerLoading());

    final result = await _homeRepository.getSearchData();

    result.fold((failure) {
      // emit(HomeControllerError(errorMessage: failure.message));
    }, (data) {
      productModel = data;
      // productModel.where((element) => element.isFuture == '1');
      // emit(HomeControllerLoaded(homeModel: data));
    });
  }
}
