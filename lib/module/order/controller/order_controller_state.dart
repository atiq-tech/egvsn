
part of 'order_controller_cubit.dart';

abstract class OrderControllerState extends Equatable{
  const OrderControllerState();
  @override
  List<Object> get props => [];
}

class OrderControllerLoading extends OrderControllerState {
  const OrderControllerLoading();
}

class OrderControllerError extends OrderControllerState {
  final String errorMessage;
  const OrderControllerError({
    required this.errorMessage,
  });

  @override
  List<Object> get props => [errorMessage];
}

class OrderControllerLoaded extends OrderControllerState {
  final String msg;
  List<OrderModel> orderModel;
  OrderControllerLoaded(this.orderModel, this.msg);

  @override
  List<Object> get props => [msg, orderModel];
}
