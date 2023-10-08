// Design by - Link-Up Technology Ltd.
// Developed by - Link-Up Technology Ltd.
// Location - Mirpur-10, Dhaka, Bangladesh.
// Website - https://www.linktechbd.com/
// Phone - +8801911978897

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:egovisionapp/core/remote_url.dart';
import 'package:egovisionapp/module/authentication/login/controller/login_bloc.dart';
import 'package:egovisionapp/module/main/main_controller.dart';
import 'package:egovisionapp/module/order/controller/order_controller_cubit.dart';
import 'package:egovisionapp/utils/constant.dart';
import 'package:egovisionapp/utils/hive/hive_adapter.dart';
import 'package:egovisionapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key, required this.grandTotal});
  final int grandTotal;

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List<Product> productBox = [];

  final noteController = TextEditingController();

  final _homeController = MainController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productBox = Hive.box<Product>('product').values.toList();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Summery"),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  ///order details feild name
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 3),
                          decoration: const BoxDecoration(
                            color: redColor,
                          ),
                          alignment: Alignment.center,
                          child: const SizedBox(
                              child: Text(
                            "Name",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 3),
                          decoration: const BoxDecoration(
                            color: redColor,
                          ),
                          alignment: Alignment.center,
                          child: const SizedBox(
                              child: Text(
                            "Price",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 3),
                          decoration: const BoxDecoration(
                            color: redColor,
                          ),
                          alignment: Alignment.center,
                          child: const SizedBox(
                              child: Text(
                            "Quantity",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 3),
                          decoration: const BoxDecoration(
                            color: redColor,
                          ),
                          alignment: Alignment.center,
                          child: const SizedBox(
                              child: Text(
                            "Total",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                      ),
                    ],
                  ),

                  ///order details
                  ...List.generate(productBox.length, (index) {
                    return Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: SizedBox(
                                child: Text(
                              "${productBox[index].name}",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ))),
                        Expanded(
                            flex: 1,
                            child: SizedBox(
                                child: Text(
                              "${productBox[index].sellingPrice}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ))),
                        Expanded(
                            flex: 1,
                            child: SizedBox(
                                child: Text(
                              double.parse("${productBox[index].qtn}")
                                  .toStringAsFixed(0),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ))),
                        Expanded(
                            flex: 1,
                            child: SizedBox(
                                child: Text(
                              "${productBox[index].totalPrice} Tk",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: redColor, fontWeight: FontWeight.w500),
                            ))),
                      ],
                    );
                  }),

                  ///billing info
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 1),
                          blurRadius: 5,
                          color: Colors.black.withOpacity(0.3),
                        ),
                      ],
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      color: Colors.white,
                      child: const Text(
                        "Billing Info",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                      ),
                    ),
                  ),

                  ///Billing details
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        alignment: Alignment.center,
                        decoration:
                            BoxDecoration(color: Colors.white, boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 1),
                            blurRadius: 2,
                            color: Colors.black.withOpacity(0.3),
                          ),
                        ]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text("Sub total "),
                            Text(
                              "${double.parse("${widget.grandTotal}")} Tk",
                              style: const TextStyle(
                                  color: redColor, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        alignment: Alignment.center,
                        decoration:
                            BoxDecoration(color: Colors.white, boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 1),
                            blurRadius: 2,
                            color: Colors.black.withOpacity(0.3),
                          ),
                        ]),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("Shipping Charge "),
                            Text(
                              "0.0 Tk",
                              style: TextStyle(
                                  color: redColor, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        alignment: Alignment.center,
                        decoration:
                            BoxDecoration(color: Colors.white, boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 1),
                            blurRadius: 2,
                            color: Colors.black.withOpacity(0.3),
                          ),
                        ]),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("Discount "),
                            Text(
                              "0.0 Tk",
                              style: TextStyle(
                                  color: redColor, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        alignment: Alignment.center,
                        decoration:
                            BoxDecoration(color: Colors.white, boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 1),
                            blurRadius: 2,
                            color: Colors.black.withOpacity(0.3),
                          ),
                        ]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text("Total Payable"),
                            Text(
                              "${double.parse("${widget.grandTotal}")} Tk",
                              style: const TextStyle(
                                  color: redColor, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        alignment: Alignment.center,
                        decoration:
                            BoxDecoration(color: Colors.white, boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 1),
                            blurRadius: 2,
                            color: Colors.black.withOpacity(0.3),
                          ),
                        ]),
                        child: TextFormField(
                          decoration: const InputDecoration(hintText: 'Note'),
                          controller: noteController,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () async {
                            showDialog();
                          },
                          child: const Text('Confirm Order'),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
  showDialog(){
    Utils.showCustomDialog(
        context,
        child: StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 16),
              height: 180,
              width: double.infinity,
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "Confirm Order",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  const Center(
                    child: Text(
                      "Do you want to place this order?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 6,
                        child: SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                foregroundColor: redColor,
                                backgroundColor: Colors.white),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel"),
                          ),
                        ),
                      ),
                      const Expanded(flex: 1,child: SizedBox(),),
                      Expanded(
                        flex: 5,
                        child: SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                              backgroundColor: redColor
                            ),
                            onPressed: () async {
                              setState(() {
                                context.read<OrderCubit>().isLoading = true;
                              });
                              var jsonObjectsList = [];
                              for (var item in productBox) {
                                jsonObjectsList.add(item.toJson());
                              }
                              if (context.read<LoginBloc>().userInfo == null) {
                                Utils.errorSnackBar(
                                    context, "Please login first");
                              }
                              else {
                                setState(() {
                                  context.read<OrderCubit>().isLoading = true;
                                });
                                FormData data = FormData.fromMap({
                                  "order": jsonEncode({
                                    "customer_id": context.read<LoginBloc>().userInfo!.user!.id.toString(),
                                    "branch_id":
                                    context.read<LoginBloc>().userInfo!.user!.branchId.toString(),
                                    "order_date": Utils.formatDate(DateTime.now())
                                        .toString(),
                                    "subtotal": widget.grandTotal.toString(),
                                    "status": 'p',
                                    "note": noteController.text.trim()
                                  }),
                                  "cart": jsonEncode(jsonObjectsList),
                                });
                                print('fasdfasdf $data');
                                // orderBloc.orderPost(context, false, data);
                                final dio = Dio();
                                final response = await dio.post(
                                  RemoteUrls.userOrders,
                                  options: Options(headers: {
                                    "Content-Type": "application/json",
                                  }),
                                  data: data,
                                );
                                var result = jsonDecode(response.data);
                                if(result['success']==true){
                                  setState(() {
                                    context.read<OrderCubit>().isLoading = false;
                                    Hive.box<Product>('product').values.toList().clear();
                                  });
                                  Utils.showSnackBar(context, result['message']);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  _homeController.naveListener.sink.add(0);
                                  Hive.box<Product>('product').clear();
                                }
                                else{
                                  setState(() {
                                    context.read<OrderCubit>().isLoading = false;
                                  });
                                  Utils.errorSnackBar(context, result['message']);
                                }
                                print("asdfasf $result");
                              }
                            },
                            child: context.read<OrderCubit>().isLoading
                                ? const CircularProgressIndicator(color: Colors.white,)
                                : Text("Yes"),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          }
        ),
        barrierDismissible: true
    );
  }
}
