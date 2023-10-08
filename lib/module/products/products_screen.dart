// Design by - Link-Up Technology Ltd.
// Developed by - Link-Up Technology Ltd.
// Location - Mirpur-10, Dhaka, Bangladesh.
// Website - https://www.linktechbd.com/
// Phone - +8801911978897

import 'package:egovisionapp/module/products/components/grid_product_container.dart';
import 'package:egovisionapp/module/products/controller/product_cubit.dart';
import 'package:egovisionapp/module/products/model/product_model.dart';
import 'package:egovisionapp/utils/constant.dart';
import 'package:egovisionapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsScreenArguments {
  final String typeId;
  final String categoryId;
  final String brandId;
  final String colorId;

  ProductsScreenArguments(this.typeId, this.categoryId, this.brandId, this.colorId);
}

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key, this.typeId, this.categoryId, this.brandId, this.colorId});
  final String? typeId;
  final String? categoryId;
  final String? brandId;
  final String? colorId;

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {

  String search = '';
  List<ProductModel> searchList = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ProductCubit>().getProducts("${widget.typeId}", "${widget.categoryId}", "${widget.brandId}", "${widget.colorId}", true));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Products"),
        ),
        body: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            if (state is ProductStateLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ProductStateError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: redColor),
                ),
              );
            }
            if (state is ProductStateLoaded) {
              // state.productList.where((element) => element.isFuture == '1');
              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverToBoxAdapter(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: redColor),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            search = value;
                            setState((){
                              if(search.isNotEmpty){
                                for(final product in state.productList){
                                  if(product.productName.toLowerCase().contains(search)){
                                    searchList.add(product);
                                  } else{
                                    searchList.remove(product);
                                  }
                                }
                              }else{
                                searchList.clear();
                              }
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Search Here...',
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: redColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: redColor),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: redColor),
                            ),
                            prefixIcon: const Icon(Icons.search),
                          ),
                        ),
                      ),
                    ),
                  ),
                  GridProductContainer(
                    productModelList: state.productList,
                    onPressed: () {},
                    searchList: searchList,
                  ),
                ],
              );
            }
            return const SizedBox();
          }
        ),
      ),
    );
  }
}
