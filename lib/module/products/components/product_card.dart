import 'package:egovisionapp/core/remote_name.dart';
import 'package:egovisionapp/core/remote_url.dart';
import 'package:egovisionapp/module/products/model/product_model.dart';
import 'package:egovisionapp/utils/constant.dart';
import 'package:egovisionapp/widget/custom_image.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  final ProductModel? productModel;
  final double? width;
  final int? index;

  const ProductCard(
      {Key? key,
        this.productModel,
        this.width,
        this.index,
      })
      : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImage(
            path:'${RemoteUrls.rootUrl}uploads/product/${widget.productModel?.image}',
            height: 80,),
          const SizedBox(height: 10,),

          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 5),
          //   decoration: BoxDecoration(
          //     color: Colors.black54,
          //     borderRadius: BorderRadius.circular(10)
          //   ),
          //   child: SizedBox(child: Text('${widget.productModel?.productName}',maxLines: 1,overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 12),)),
          // ),
          // const SizedBox(height: 10,),
          Text('${widget.productModel?.productName}',maxLines: 1,overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 12),),
          const SizedBox(height: 10,),

          Text('${widget.productModel?.productSellingPrice} TK', style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 12),),
          const SizedBox(height: 10,),
          SizedBox(
            height: 40,
            child: ElevatedButton(onPressed: () {
              Navigator.pushNamed(context, RouteNames.productDetailsScreen,
                arguments: widget.productModel
              );
            },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: redColor,
              ), child: const SizedBox(
                child: Text("Add to Cart",maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 12),
            ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
