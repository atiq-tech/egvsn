import 'package:device_info_plus/device_info_plus.dart';
import 'package:egovisionapp/core/remote_name.dart';
import 'package:egovisionapp/module/authentication/login/controller/login_bloc.dart';
import 'package:egovisionapp/module/order/model/order_model.dart';
import 'package:egovisionapp/module/order_details/order_details.dart';
import 'package:egovisionapp/utils/constant.dart';
import 'package:egovisionapp/utils/hive/hive_adapter.dart';
import 'package:egovisionapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';

class OrderCard extends StatefulWidget {
  const OrderCard(
      {Key? key,
      required this.orderModel,
      required this.index,
      required this.from,
      })
      : super(key: key);
  final OrderModel orderModel;
  final int index;
  final String from;

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  LoginBloc? loginBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loginBloc = context.read<LoginBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RouteNames.orderDetailsScreen,
            arguments: OrderDetailsScreenArguments(widget.orderModel.id,
                widget.orderModel, widget.index, loginBloc!.userInfo));
        // _createPDF(filename: '${widget.orderModel.invoice}', context: context, index: widget.index);
      },
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                // margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.grey.shade200,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.index + 1}",
                      style: const TextStyle(
                          fontSize: 20,
                          color: redColor,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            child: Text(
                              "Date: ${Utils.formatDate(widget.orderModel.createAt)}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ),
                        // Text("Time: ${Utils.formatDatewithTime(widget.orderModel.createAt)}"),
                        SizedBox(
                          child: Text(
                            "Name: ${widget.orderModel.name}",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text("Total: ${widget.orderModel.total}"),
                        Text("Invoice: ${widget.orderModel.invoice}"),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 10,
                top: 10,
                child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: widget.orderModel.status == 'p'
                      ? Colors.orange.shade700
                      : widget.orderModel.status == 'o'
                      ? const Color(0xFF1B6AAA)
                      : widget.orderModel.status == 'h'
                      ? const Color(0xFf157347)
                      : widget.orderModel.status == 'd'
                      ? Colors.red.shade700
                      : null,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  widget.orderModel.status == 'p'
                      ? "Pending"
                      : widget.orderModel.status == 'o'
                      ? "Ongoing"
                      : widget.orderModel.status == 'h'
                      ? "Received"
                      : widget.orderModel.status == 'd'
                      ? "Canceled"
                      : '',
                  style: const TextStyle(color: Colors.white,fontSize: 12),
                ),
              ),
              )
              // Visibility(
              //   visible: widget.from == 'pending',
              //   child: Positioned(
              //     right: -5,
              //     top: -10,
              //     child: IconButton(
              //       onPressed: () {
              //         // final productBox = Hive.box<Product>('product');
              //         // final products = Product(
              //         //   id: widget.orderModel.id,
              //         //   name: widget.orderModel.name,
              //         //   img: widget.orderModel.image,
              //         //   qtn: widget.orderModel.quantity,
              //         //   puschacePrice: widget.productModel.productPurchaseRate,
              //         //   status: 'a',
              //         //   sellingPrice: double.parse(widget.productModel.productSellingPrice),
              //         //   totalPrice: double.parse(widget.productModel.productSellingPrice)*quantity,
              //         // );
              //         // productBox.add(products);
              //       },
              //       icon: Icon(
              //         Icons.edit,
              //         color: Colors.red.shade800,
              //         size: 20,
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
          const Visibility(
            visible: true /*index != state.planList.length-1*/,
            child: Divider(
              color: Colors.black12,
            ),
          ),
        ],
      ),
    );
  }
}
