import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:egovisionapp/core/remote_url.dart';
import 'package:egovisionapp/module/home/model/slider_model.dart';
import 'package:egovisionapp/utils/constant.dart';
import 'package:egovisionapp/widget/custom_image.dart';
import 'package:flutter/material.dart';

class ImageSlider extends StatefulWidget {
  const ImageSlider({
    Key? key,
    required this.sliderModelList, required this.height,
  }) : super(key: key);

  final List<SliderModel> sliderModelList;
  final double height;
  // final AdDetails adDetails;

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  // final double height = 144;
  final int initialPage = 0;
  int _currentIndex = 0;

  CarouselController carouselController = CarouselController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 16,left: 16,right: 16),
      height: widget.height,
      child: Stack(
        children: [
          CarouselSlider(
            carouselController: carouselController,
            options: CarouselOptions(
              height: widget.height,
              viewportFraction: 1,
              initialPage: initialPage,
              enableInfiniteScroll: widget.sliderModelList.length > 1,
              reverse: false,
              autoPlay: widget.sliderModelList.length > 1,
              // autoPlay: false,
              autoPlayInterval: const Duration(seconds: 5),
              autoPlayAnimationDuration: const Duration(milliseconds: 1000),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              onPageChanged: callbackFunction,
              scrollDirection: Axis.horizontal,
            ),
            items: widget.sliderModelList.isNotEmpty ? widget.sliderModelList
                .map((i) => GestureDetector(
              onTap: (){
                // Navigator.push(
                //     context,
                //     Utils.createPageRouteTop(context,ShowImage(
                //       galleries: widget.gallery,
                //       initialIndex: _currentIndex,
                //     )));
               ///
               //  Navigator.push(
               //      context,
               //      Utils.createPageRouteTop(context,ShowSingleImage(
               //          imageUrl: widget.gallery[_currentIndex].imageUrl
               //      )));
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  // image: DecorationImage(
                  //   image: NetworkImage(i.imageUrl),
                  //   fit: BoxFit.cover,
                  // ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                    child: CustomImage(path: i.image == ''
                        ? null
                        : "${RemoteUrls.rootUrl}uploads/customer/${i.image}",
                      fit: BoxFit.cover,
                    ),
                ),
              ),
            ))
                .toList() : [
              // GestureDetector(
              //   onTap: widget.adDetails.thumbnail != '' ? (){
              //     Navigator.push(
              //         context,
              //         Utils.createPageRouteTop(context,ShowSingleImage(
              //             imageUrl: '${RemoteUrls.rootUrl3}${widget.adDetails.thumbnail}'
              //         )));
              //   } : null,
              //   child: Container(
              //     width: MediaQuery.of(context).size.width,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(4),
              //       // image: DecorationImage(
              //       //   image: NetworkImage(i.imageUrl),
              //       //   fit: BoxFit.cover,
              //       // ),
              //     ),
              //     child: CustomImage(path: widget.sliderModelList.thumbnail != '' ? '${RemoteUrls.rootUrl3}${widget.adDetails.thumbnail}' : null,fit: BoxFit.cover,),
              //   ),
              // ),
            ] ,
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 4,
            child: LayoutBuilder(
              builder: (context,constraints) {
                if (widget.sliderModelList.isEmpty) {
                  return const SizedBox();
                }
                return DotsIndicator(
                  dotsCount: widget.sliderModelList.length,
                  key: UniqueKey(),
                  decorator: DotsDecorator(
                    activeColor: redColor,
                    color: Colors.white,
                    activeSize: const Size(10.0, 10.0),
                    size: const Size(10.0, 10.0),
                    activeShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                  position: _currentIndex,
                );
              }
            ),
          ),
          // Positioned(
          //   right: 36,
          //   bottom: 4,
          //   child: Text( widget.sliderModelList.isEmpty ? "0/0" : "${_currentIndex+1}/${widget.sliderModelList.length}",style: const TextStyle(color: redColor,fontWeight: FontWeight.w600),),
          // )

          ///
          // Positioned(top: 0,bottom: 0,right: 0,child: GestureDetector(onTap: () {
          //   carouselController.nextPage();
          // },child: const Icon(Icons.arrow_forward_ios, color: Colors.blue,)),),
          // Positioned(top: 0,bottom: 0,left: 0,child: GestureDetector(onTap: () {
          //   carouselController.previousPage();
          // },child: const Icon(Icons.arrow_back_ios, color: Colors.blue)),)
        ],
      ),
    );
  }

  void callbackFunction(int index, CarouselPageChangedReason reason) {
    setState(() {
      _currentIndex = index;
    });
  }
}
