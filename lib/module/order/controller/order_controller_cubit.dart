
import 'dart:convert';

import 'package:egovisionapp/module/authentication/login/controller/login_bloc.dart';
import 'package:egovisionapp/module/order/model/order_details_model.dart';
import 'package:egovisionapp/module/order/model/order_model.dart';
import 'package:egovisionapp/module/order/repository/order_repository.dart';
import 'package:egovisionapp/utils/utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'order_controller_state.dart';

class OrderCubit extends Cubit<OrderControllerState> {
  // OrderCubit(this.orderRepository, this.loginBloc)
  //     : super(const OrderControllerLoading());
  OrderCubit(this.orderRepository, this.loginBloc)
      : super(const OrderControllerLoading()){
    getAllOrderData('');
  }

  final OrderRepository orderRepository;
  final LoginBloc loginBloc;

  bool isLoading = false;
  bool isUpdateLoading = false;

  List<OrderModel> allOrderList = [];
  List<OrderModel> pendingList = [];
  List<OrderModel> ongoingList = [];
  List<OrderModel> receivedList = [];
  List<OrderModel> cancelList = [];

  // Future<void> orderPost(context, bool isLoading, Map<String, dynamic> data) async {
  //
  //   emit(const OrderControllerLoading());
  //
  //   print("kjhjkasdf $data");
  //   print("kjhjkasdf ${jsonEncode(data)}");
  //
  //   final result = await orderRepository.orderPost(data);
  //   result.fold(
  //         (error) {
  //           emit(OrderControllerError(errorMessage: error.message),);
  //           Utils.errorSnackBar(context, "Error");
  //         },
  //         (success) {
  //           emit(OrderControllerLoaded(msg: success));
  //           Utils.showSnackBar(context, "Success");
  //         }
  //   );
  // }

  List<OrderDetailsModel> orderDetailsModel = [];

  Future<void> getAllOrderData(String status) async {
    emit(const OrderControllerLoading());

    final userId = loginBloc.userInfo?.user?.id;

    final result = await orderRepository.getAllOrderData(userId.toString(),status);

    result.fold(
            (failure) {
          emit(OrderControllerError(errorMessage: failure.message));
        },
            (data) {
              allOrderList = data;
              pendingList = allOrderList.where((element) => element.status == 'p').toList();
              ongoingList = allOrderList.where((element) => element.status == 'o').toList();
              receivedList = allOrderList.where((element) => element.status == 'h').toList();
              cancelList = allOrderList.where((element) => element.status == 'd').toList();

          emit(OrderControllerLoaded(data,''));
        }
    );
  }

}