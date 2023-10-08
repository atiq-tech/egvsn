// Design by - Link-Up Technology Ltd.
// Developed by - Link-Up Technology Ltd.
// Location - Mirpur-10, Dhaka, Bangladesh.
// Website - https://www.linktechbd.com/
// Phone - +8801911978897

import 'package:egovisionapp/core/remote_url.dart';
import 'package:egovisionapp/module/main/main_controller.dart';
import 'package:egovisionapp/module/products/model/product_model.dart';
import 'package:egovisionapp/utils/constant.dart';
import 'package:egovisionapp/utils/hive/hive_adapter.dart';
import 'package:egovisionapp/utils/utils.dart';
import 'package:egovisionapp/widget/custom_image.dart';
import 'package:flutter/material.dart';

import 'package:hive/hive.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key, required this.productModel});

  final ProductModel productModel;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final _homeController = MainController();

  double quantity = 1;



  // @override
  //   void initState() {
  //     // TODO: implement initState
  //     super.initState();
  //     // print('asdfsfasf ${productBox.map((e) => e.id).contains(widget.productModel.productSlNo)}');
  //
  //     // if(productBox.isNotEmpty) {
  //     //   Product product = productBox.singleWhere((element) =>
  //     //   element.id == widget.productModel.productSlNo);
  //     //   print('asdfsfasf ${product.id}');
  //     // }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  bool isAlreadyAdded = false;

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Product Details"),
        ),
        body: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomImage(
                      width: MediaQuery.of(context).size.width,
                      height: 250,
                      path:'${RemoteUrls.rootUrl}uploads/product/${widget.productModel.image}',
                      fit: BoxFit.contain,
                      // path: widget.productModel.image,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      widget.productModel.productName,
                      style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                            "Price : ${widget.productModel.productSellingPrice} Tk",
                            style: const TextStyle(
                                color: redColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            if(quantity>1) {
                              setState(() {
                                quantity--;
                              });
                            }else{
                              Utils.errorSnackBar(context, "Quantity can't 0");
                            }
                          },
                          child: Container(
                            height: 30,
                            width: 30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: const Text('-',style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),
                          ),
                        ),
                        const SizedBox(width: 5,),
                        Container(
                          height: 30,
                          width: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text('${quantity.toStringAsFixed(0)}',style: TextStyle(color: Colors.black87,fontSize: 16,fontWeight: FontWeight.bold),),
                        ),
                        const SizedBox(width: 5,),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              quantity++;
                            });
                          },
                          child: Container(
                            height: 30,
                            width: 30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: const Text('+',style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Row(
                      children: [
                        Text(
                          "Stock Availability :",
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "In Stock",
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        bottomSheet: SizedBox(
          height: 45,
          child: ElevatedButton.icon(
            onPressed: () {
              List<Product> productBox = Hive.box<Product>('product').values.toList();
              isAlreadyAdded = productBox.map((e) => e.id).contains(widget.productModel.productSlNo);

              if (isAlreadyAdded) {
                Utils.errorSnackBar(context, "Item already added to cart");
              } else {
                final productBox = Hive.box<Product>('product');
                final products = Product(
                  id: widget.productModel.productSlNo,
                  name: widget.productModel.productName,
                  img: widget.productModel.image,
                  qtn: quantity,
                  purchasePrice: widget.productModel.productPurchaseRate,
                  status: 'a',
                  sellingPrice: double.parse(widget.productModel.productSellingPrice),
                  totalPrice: double.parse(widget.productModel.productSellingPrice)*quantity,
                );
                productBox.add(products);
                print("lskgjhksdlfglk ${productBox.length}");

                Utils.showSnackBarWithAction(
                    context, "Successfully added to cart",
                    actionText: 'View Cart', () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  _homeController.naveListener.sink.add(2);
                });
                setState(() {
                  isAlreadyAdded = true;
                });
              }
            },
            icon: const Icon(Icons.shopping_cart),
            label: const Text("Add to Cart"),
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
          ),
        ),
      ),
    );
  }
}
