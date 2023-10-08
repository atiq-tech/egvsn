import 'package:egovisionapp/module/authentication/login/controller/login_bloc.dart';
import 'package:egovisionapp/module/order/component/order_card.dart';
import 'package:egovisionapp/module/order/controller/order_controller_cubit.dart';
import 'package:egovisionapp/widget/please_signin_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliver_tools/sliver_tools.dart';

class PendingOrderScreen extends StatefulWidget {
  const PendingOrderScreen({super.key});

  @override
  State<PendingOrderScreen> createState() => _PendingOrderScreenState();
}

class _PendingOrderScreenState extends State<PendingOrderScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() => context.read<OrderCubit>().getAllOrderData(''));
  }

  @override
  Widget build(BuildContext context) {

    final orderBloc = context.read<OrderCubit>();

    return SafeArea(
      child: BlocBuilder<OrderCubit, OrderControllerState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          if (state is OrderControllerLoading) {
            print("Loading0");
            return const Center(child: CircularProgressIndicator());
          }
          if (state is OrderControllerError) {
            print("Loading1");
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.errorMessage == "Data format exception" ? "No Data Found" : state.errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 10)
                ],
              ),
            );
          }
          if(state is OrderControllerLoaded){
            print("Loading2");
            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  sliver: MultiSliver(
                    children: [
                      SliverLayoutBuilder(
                        builder: (context,constraints){
                          if (orderBloc.pendingList.isNotEmpty) {
                            return SliverList(
                              delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                  return OrderCard(
                                    orderModel: orderBloc.pendingList[index],
                                    index: index,
                                    from: 'pending',
                                  );
                                },
                                childCount: orderBloc.pendingList.length,
                              ),
                            );
                          } else {
                            return const SliverToBoxAdapter(
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 48.0),
                                  child: Text("No Data Found", style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20,
                                  ),),
                                ),
                              ),
                            );
                          }
                        },
                      )

                    ],
                  ),
                )
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
