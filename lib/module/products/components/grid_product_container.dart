import 'package:egovisionapp/module/products/components/product_card.dart';
import 'package:egovisionapp/module/products/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../../main/main_controller.dart';

class GridProductContainer extends StatefulWidget {
  const GridProductContainer({
    Key? key,
    required this.productModelList,
    this.from,
    required this.onPressed,
    required this.searchList,
  }) : super(key: key);
  final List<ProductModel> productModelList;
  final Function onPressed;
  final String? from;
  final List<ProductModel> searchList;

  @override
  State<GridProductContainer> createState() => GridProductContainerState();
}

class GridProductContainerState extends State<GridProductContainer> {
  final MainController mainController = MainController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final logInBloc = context.read<LoginBloc>();
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: MultiSliver(
        children: [
          SliverLayoutBuilder(
            builder: (context, constraints) {
              if (widget.searchList.isEmpty) {
                return SliverGrid(
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      mainAxisExtent: 250,
                    ),
                    delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int pIndex) {
                          return ProductCard(
                            productModel: widget.productModelList[pIndex],
                            index: pIndex,
                            width: 200,
                          );
                        }, childCount: widget.productModelList.length));
              }
              else if(widget.searchList.isNotEmpty){
                return SliverGrid(
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      mainAxisExtent: 250,
                    ),
                    delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int pIndex) {
                          return ProductCard(
                            productModel: widget.searchList[pIndex],
                            index: pIndex,
                            width: 200,
                          );
                        }, childCount: widget.searchList.length));
              }
              else {
                return SliverToBoxAdapter(
                  child: SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: Center(
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.black54)),
                          child: const Text(
                            "Ads Not Found",
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                      ),
                    ),
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
