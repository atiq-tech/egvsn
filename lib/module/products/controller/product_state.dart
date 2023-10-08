part of 'product_cubit.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductStateInitial extends ProductState {
  const ProductStateInitial();
}

class ProductStateLoading extends ProductState {
  const ProductStateLoading();
}

class ProductStateLoadMore extends ProductState {
  const ProductStateLoadMore();
}

class ProductStateError extends ProductState {
  final String message;

  const ProductStateError(this.message);
  @override
  List<Object> get props => [message];
}

class ProductStateMoreError extends ProductState {
  final String message;
  final int statusCode;

  const ProductStateMoreError(this.message, this.statusCode);
  @override
  List<Object> get props => [message, statusCode];
}

class ProductStateLoaded extends ProductState {
  final List<ProductModel> productList;
  const ProductStateLoaded(this.productList);

  @override
  List<Object> get props => [productList];
}

class ProductStateMoreLoaded extends ProductState {
  final List<ProductModel> productList;
  const ProductStateMoreLoaded(this.productList);

  @override
  List<Object> get props => [productList];
}
