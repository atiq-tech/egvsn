// Design by - Link-Up Technology Ltd.
// Developed by - Link-Up Technology Ltd.
// Location - Mirpur-10, Dhaka, Bangladesh.
// Website - https://www.linktechbd.com/
// Phone - +8801911978897

import 'package:egovisionapp/core/remote_name.dart';
import 'package:egovisionapp/core/remote_url.dart';
import 'package:egovisionapp/utils/constant.dart';
import 'package:egovisionapp/utils/hive/hive_adapter.dart';
import 'package:egovisionapp/utils/utils.dart';
import 'package:egovisionapp/widget/custom_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  // Get all persons in the list
  // List<Product> productBox {
  //   final productBox = Hive.box<Product>('product');
  //   return productBox.values.toList();
  // }
  List<Product> productBox = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productBox = Hive.box<Product>('product').values.toList();
  }

  int grandTotal = 0;


  @override
  Widget build(BuildContext context) {

    grandTotal = productBox.fold(0, (previousValue, element) => previousValue.toInt()+element.totalPrice!.toInt());

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: productBox.isNotEmpty ? Column(
        children: [
          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              Text("My Cart (${productBox.length})",style: const TextStyle(
                fontSize: 14,fontWeight: FontWeight.bold
              ),),
              GestureDetector(
                onTap: () {
                  Utils.showCustomDialog(context,
                      child: StatefulBuilder(
                        builder: (context, sateState) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            height: 150,
                            width: double.infinity,
                            child: Column(
                              children: [
                                const Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Are you sure?",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                const Spacer(),
                                const Center(
                                  child: Text(
                                    'Do you want to delete all of this items?',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                const Spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      style: TextButton.styleFrom(
                                          foregroundColor: redColor),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("No"),
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                          foregroundColor: redColor),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        setState(() {
                                          print('jklhfsgjkdsfg ${productBox.length}');
                                          productBox.clear();
                                          Hive.box<Product>('product').clear();
                                        });
                                        Utils.showSnackBar(context, "All items are removed successfully");
                                      },
                                      child: const Text("Yes"),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        }
                      ),
                      barrierDismissible: true,
                  );
                },
                child: const Text("Delete All",style: TextStyle(
                    fontSize: 14,fontWeight: FontWeight.bold
                ),),
              ),
            ],
          ),
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
                             path: "${RemoteUrls.rootUrl}uploads/product/${productBox[index].img}",
                             fit: BoxFit.cover,
                           ),
                         ),
                         const SizedBox(width: 10,),
                         Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text("${productBox[index].name}",style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),
                             Row(
                               children: [
                                 Text("${productBox[index].sellingPrice} X "),
                                 Text("${productBox[index].qtn}"),
                                 const SizedBox(width: 10,),
                                 GestureDetector(
                                   onTap: () {
                                     if(productBox[index].qtn!>1) {
                                       setState(() {
                                         productBox[index].qtn = productBox[index].qtn! - 1;
                                         Hive.box<Product>('product').put(index, Product(qtn: double.parse("${productBox[index].qtn}")));
                                         productBox[index].totalPrice = productBox[index].qtn! * double.parse("${productBox[index].sellingPrice}");
                                         Hive.box<Product>('product').put(index, Product(totalPrice: double.parse("${productBox[index].totalPrice}")));
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
                                       productBox[index].qtn = productBox[index].qtn! +1;
                                       Hive.box<Product>('product').put(index, Product(qtn: double.parse("${productBox[index].qtn}")));
                                       productBox[index].totalPrice = productBox[index].qtn! * double.parse("${productBox[index].sellingPrice}");
                                       Hive.box<Product>('product').put(index, Product(totalPrice: double.parse("${productBox[index].totalPrice}")));
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
                                 Text('${productBox[index].totalPrice} Tk',style: const TextStyle(fontWeight: FontWeight.bold, color: redColor),)
                               ],
                             )
                           ],
                         )
                       ],
                     ),
                   ),
                   Positioned(
                     top: 0,
                     right: 0,
                     child: GestureDetector(
                     onTap: () {
                       setState(() {
                         productBox.removeAt(index);
                         Hive.box<Product>('product').deleteAt(index);
                       });
                       Utils.showSnackBar(context, "Item removed successfully");
                     },
                     child: Container(
                       padding: const EdgeInsets.all(8),
                       decoration: const BoxDecoration(
                         color: Colors.red,
                         borderRadius: BorderRadius.only(
                           bottomLeft: Radius.circular(16),
                           topRight: Radius.circular(16)
                         )
                       ),
                         child: const Icon(Icons.delete, color: Colors.white,),
                     ),
                   ),
                   ),
                 ],
               ),
              );
          },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 20,);
            },
          itemCount: productBox.length,
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
                    Navigator.pushNamed(context, RouteNames.orderScreen,
                    arguments: grandTotal);
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
