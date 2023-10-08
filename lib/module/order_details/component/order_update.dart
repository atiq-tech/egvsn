// Design by - Link-Up Technology Ltd.
// Developed by - Link-Up Technology Ltd.
// Location - Mirpur-10, Dhaka, Bangladesh.
// Website - https://www.linktechbd.com/
// Phone - +8801911978897

import 'package:egovisionapp/core/remote_name.dart';
import 'package:egovisionapp/core/remote_url.dart';
import 'package:egovisionapp/module/order_details/component/update_order_checkout.dart';
import 'package:egovisionapp/utils/constant.dart';
import 'package:egovisionapp/utils/hive/hive_adapter.dart';
import 'package:egovisionapp/utils/hive/update_product_adapter.dart';
import 'package:egovisionapp/utils/utils.dart';
import 'package:egovisionapp/widget/custom_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class OrderUpdate extends StatefulWidget {
  const OrderUpdate({super.key, required this.id});
  final String id;
  @override
  State<OrderUpdate> createState() => _OrderUpdateState();
}

class _OrderUpdateState extends State<OrderUpdate> {

  // Get all persons in the list
  // List<Product> productBox {
  //   final productBox = Hive.box<Product>('product');
  //   return productBox.values.toList();
  // }
  List<UpdateProduct> productUpdateBox = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productUpdateBox = Hive.box<UpdateProduct>('product_update').values.toList();
    print('sdkjhgjklsdfghk ${widget.id}');
  }

  int grandTotal = 0;
  // int qtn = 0;
  // int total = 0;


  @override
  Widget build(BuildContext context) {

    grandTotal = productUpdateBox.fold(0, (previousValue, element) => previousValue.toInt()+element.totalPrice!.toInt());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF78359E),
        scrolledUnderElevation: 0,
        title: const SizedBox(
            child: Text(
              "Order Update",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white),
            )),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: productUpdateBox.isNotEmpty ? Column(
          children: [
            // Row(
            //   mainAxisAlignment:
            //   MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text("My Cart (${productBox.length})",style: const TextStyle(
            //         fontSize: 14,fontWeight: FontWeight.bold
            //     ),),
            //     GestureDetector(
            //       onTap: () {
            //
            //         Utils.showCustomDialog(context,
            //           child: StatefulBuilder(
            //               builder: (context, sateState) {
            //                 return Container(
            //                   padding: const EdgeInsets.symmetric(
            //                       horizontal: 16, vertical: 16),
            //                   height: 150,
            //                   width: double.infinity,
            //                   child: Column(
            //                     children: [
            //                       const Align(
            //                         alignment: Alignment.topLeft,
            //                         child: Text(
            //                           "Are you sure?",
            //                           style: TextStyle(
            //                               color: Colors.black,
            //                               fontSize: 16,
            //                               fontWeight: FontWeight.w600),
            //                         ),
            //                       ),
            //                       const Spacer(),
            //                       const Center(
            //                         child: Text(
            //                           'Do you want to delete all of this items?',
            //                           style: TextStyle(
            //                               color: Colors.black54,
            //                               fontSize: 14,
            //                               fontWeight: FontWeight.w400),
            //                         ),
            //                       ),
            //                       const Spacer(),
            //                       Row(
            //                         mainAxisAlignment: MainAxisAlignment.end,
            //                         children: [
            //                           TextButton(
            //                             style: TextButton.styleFrom(
            //                                 foregroundColor: redColor),
            //                             onPressed: () {
            //                               Navigator.pop(context);
            //                             },
            //                             child: const Text("No"),
            //                           ),
            //                           TextButton(
            //                             style: TextButton.styleFrom(
            //                                 foregroundColor: redColor),
            //                             onPressed: () {
            //                               Navigator.pop(context);
            //                               setState(() {
            //                                 print('jklhfsgjkdsfg ${productBox.length}');
            //                                 productBox.clear();
            //                                 Hive.box<Product>('product').clear();
            //                               });
            //                               Utils.showSnackBar(context, "All items are removed successfully");
            //                             },
            //                             child: const Text("Yes"),
            //                           ),
            //                         ],
            //                       )
            //                     ],
            //                   ),
            //                 );
            //               }
            //           ),
            //           barrierDismissible: true,
            //         );
            //       },
            //       child: const Text("Delete All",style: TextStyle(
            //           fontSize: 14,fontWeight: FontWeight.bold
            //       ),),
            //     ),
            //   ],
            // ),
            const SizedBox(height: 10,),
            Expanded(child: ListView.separated(
              itemBuilder: (context, index) {
                return Container(
                  height: 80,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 1),
                        blurRadius: 5,
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 80,
                              height: double.infinity,
                              child: CustomImage(
                                path: "${RemoteUrls.rootUrl}uploads/product/${productUpdateBox[index].img}",
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 10,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${productUpdateBox[index].name}",style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),
                                Row(
                                  children: [
                                    Text("${productUpdateBox[index].sellingPrice} X "),
                                    Text("${productUpdateBox[index].qtn}"),
                                    const SizedBox(width: 10,),
                                    GestureDetector(
                                      onTap: () {
                                        if(productUpdateBox[index].qtn!>1) {
                                          setState(() {
                                            productUpdateBox[index].qtn = productUpdateBox[index].qtn! - 1;
                                            Hive.box<UpdateProduct>('product_update').put(index, UpdateProduct(qtn: double.parse("${productUpdateBox[index].qtn}")));
                                            productUpdateBox[index].totalPrice = productUpdateBox[index].qtn! * double.parse("${productUpdateBox[index].sellingPrice}");
                                            Hive.box<UpdateProduct>('product_update').put(index, UpdateProduct(totalPrice: double.parse("${productUpdateBox[index].totalPrice}")));
                                          });
                                        }
                                      },
                                      child: Container(
                                        height: 25,
                                        width: 25,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(3),
                                        ),
                                        child: const Text('-',style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),
                                      ),
                                    ),
                                    const SizedBox(width: 5,),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          productUpdateBox[index].qtn = productUpdateBox[index].qtn! +1;
                                          Hive.box<UpdateProduct>('product_update').put(index, UpdateProduct(qtn: double.parse("${productUpdateBox[index].qtn}")));
                                          productUpdateBox[index].totalPrice = productUpdateBox[index].qtn! * double.parse("${productUpdateBox[index].sellingPrice}");
                                          Hive.box<UpdateProduct>('product_update').put(index, UpdateProduct(totalPrice: double.parse("${productUpdateBox[index].totalPrice}")));
                                        });
                                      },
                                      child: Container(
                                        height: 25,
                                        width: 25,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(3),
                                        ),
                                        child: const Text('+',style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),
                                      ),
                                    ),
                                    const SizedBox(width: 5,),
                                    const Text('='),
                                    const SizedBox(width: 5,),
                                    Text('${productUpdateBox[index].totalPrice} Tk',style: const TextStyle(fontWeight: FontWeight.bold, color: redColor),)
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      // Positioned(
                      //   top: 0,
                      //   right: 0,
                      //   child: GestureDetector(
                      //     onTap: () {
                      //       setState(() {
                      //         productUpdateBox.removeAt(index);
                      //         Hive.box<Product>('product').deleteAt(index);
                      //       });
                      //       Utils.showSnackBar(context, "Item removed successfully");
                      //     },
                      //     child: Container(
                      //       padding: const EdgeInsets.all(8),
                      //       decoration: const BoxDecoration(
                      //           color: Colors.red,
                      //           borderRadius: BorderRadius.only(
                      //               bottomLeft: Radius.circular(16),
                      //               topRight: Radius.circular(16)
                      //           )
                      //       ),
                      //       child: const Icon(Icons.delete, color: Colors.white,),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 20,);
              },
              itemCount: productUpdateBox.length,
            ),),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.grey.shade300
              ),
              child: Row(
                children: [
                  Text("Subtotal : $grandTotal Tk",style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                  const Expanded(flex: 1,child: SizedBox()),
                  Expanded(flex: 4,child: SizedBox(
                    height: 40,
                    child: ElevatedButton.icon(onPressed: () {
                      Navigator.pushNamed(context, RouteNames.orderUpdateScreen,
                          arguments: UpdateOrderScreenArguments(widget.id, grandTotal));
                    }, icon: const Icon(Icons.logout),
                      label: const SizedBox(
                        child: Text("Checkout",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14
                          ),),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white
                      ),),
                  ),),
                ],
              ),
            ),

          ],
        ) : const Center(
          child: Text("No Data Found", style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20,
          ),),
        ),
      ),
    );
  }
}
