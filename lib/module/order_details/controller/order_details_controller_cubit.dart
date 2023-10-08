
import 'dart:convert';

import 'package:egovisionapp/module/authentication/login/controller/login_bloc.dart';
import 'package:egovisionapp/module/order/model/order_details_model.dart';
import 'package:egovisionapp/module/order/model/order_model.dart';
import 'package:egovisionapp/module/order/repository/order_repository.dart';
import 'package:egovisionapp/utils/utils.dart';
import 'package:egovisionapp/module/order/model/order_details_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'order_details_controller_state.dart';

class OrderDetailsCubit extends Cubit<OrderDetailsControllerState> {
  // OrderCubit(this.orderRepository, this.loginBloc)
  //     : super(const OrderControllerLoading());
  OrderDetailsCubit(this.orderRepository, this.loginBloc)
      : super(const OrderDetailsControllerLoading());

  final OrderRepository orderRepository;
  final LoginBloc loginBloc;

  bool isLoading = false;

  List<OrderDetailsModel> orderDetailsModel = [];


  Future<void> getOrderDetails(String orderId) async {
    emit(const OrderDetailsControllerLoading());

    final result = await orderRepository.getOrderDetails(orderId);

    result.fold(
            (failure) {
          emit(OrderDetailsControllerError(errorMessage: failure.message));
        },
            (data) {
          orderDetailsModel = data;
          print("jhkahfdjkasfh ${orderDetailsModel.length}");

          var result = orderDetailsModel.map((e) => double.parse(e.total)).fold(0.0, (previousValue, element) => previousValue + element);
          print("jhkahfdjkasfh ${result}");
          emit(OrderDetailsControllerLoaded(orderDetailsModel: data,msg: '',result: result));
        }
    );
  }



}