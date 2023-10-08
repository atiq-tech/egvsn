import 'package:egovisionapp/core/remote_name.dart';
import 'package:egovisionapp/core/remote_url.dart';
import 'package:egovisionapp/module/home/model/types_model.dart';
import 'package:egovisionapp/module/products/products_screen.dart';
import 'package:egovisionapp/widget/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';

class TypeListProductContainer extends StatefulWidget {
  const TypeListProductContainer({
    Key? key,
    required this.title, required this.onPressed, required this.typeModelList,
  }) : super(key: key);
  final List<TypeModel> typeModelList;
  final String title;
  final Function onPressed;

  @override
  State<TypeListProductContainer> createState() => TypeListProductContainerState();
}

class TypeListProductContainerState extends State<TypeListProductContainer> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 0),
      sliver: MultiSliver(
        children: [
          SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox()
              ],
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 10)),
          SliverLayoutBuilder(
            builder: (context,constraints){
              if (widget.typeModelList.isNotEmpty) {
                return SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      SizedBox(
                        height: 75,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.typeModelList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, RouteNames.productScreen,
                                    arguments: ProductsScreenArguments(widget.typeModelList[index].id, '', '', ''));
                              },
                              child: Container(
                                width: 90,
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey
                                  ),
                                  borderRadius: BorderRadius.circular(3)
                                ),
                                // color: Colors.blue,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 22,
                                      backgroundColor:
                                      Colors.grey.shade300,
                                      child: ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(100),
                                        child: CustomImage(
                                          path: widget.typeModelList[index].image !=
                                              ''
                                              ? "${RemoteUrls.rootUrl}uploads/apps/${widget.typeModelList[index].image}"
                                              : null,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 5,),
                                    SizedBox(
                                        child: Text(
                                          widget.typeModelList[index].name,
                                          maxLines: 1,
                                          style: const TextStyle(fontSize: 10,fontWeight: FontWeight.w500),
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                        ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(width: 5,);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return SliverToBoxAdapter(
                  child: SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: Center(
                      child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.black54)
                          ),
                          child: const Text("Product Not Found",style: TextStyle(color: Colors.black54,fontSize: 16,fontWeight: FontWeight.w500),)),
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}