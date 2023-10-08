part of 'order_details_controller_cubit.dart';

abstract class OrderDetailsControllerState extends Equatable{
  const OrderDetailsControllerState();
  @override
  List<Object> get props => [];
}

class OrderDetailsControllerLoading extends OrderDetailsControllerState {
  const OrderDetailsControllerLoading();
}

class OrderDetailsControllerError extends OrderDetailsControllerState {
  final String errorMessage;
  const OrderDetailsControllerError({
    required this.errorMessage,
  });

  @override
  List<Object> get props => [errorMessage];
}

class OrderDetailsControllerLoaded extends OrderDetailsControllerState {
  final String msg;
  final double result;
  List<OrderDetailsModel> orderDetailsModel;
  OrderDetailsControllerLoaded({required this.orderDetailsModel, required this.msg, required this.result});

  @override
  List<Object> get props => [msg, orderDetailsModel, result];
}
