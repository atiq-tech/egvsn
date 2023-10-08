// Design by - Link-Up Technology Ltd.
// Developed by - Link-Up Technology Ltd.
// Location - Mirpur-10, Dhaka, Bangladesh.
// Website - https://www.linktechbd.com/
// Phone - +8801911978897

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:egovisionapp/core/remote_name.dart';
import 'package:egovisionapp/core/remote_url.dart';
import 'package:egovisionapp/module/authentication/login/controller/login_bloc.dart';
import 'package:egovisionapp/module/home/component/brand_list_controller.dart';
import 'package:egovisionapp/module/home/component/category_list_container.dart';
import 'package:egovisionapp/module/home/component/color_list_container.dart';
import 'package:egovisionapp/module/home/component/image_slider_section.dart';
import 'package:egovisionapp/module/home/component/type_list_container.dart';
import 'package:egovisionapp/module/home/controller/cubit/home_controller_cubit.dart';
import 'package:egovisionapp/module/home/model/search_model.dart';
import 'package:egovisionapp/module/products/model/product_model.dart';
import 'package:egovisionapp/utils/constant.dart';
import 'package:egovisionapp/widget/custom_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String? searchValue;
  final refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    context.read<HomeControllerCubit>().userCheck(context.read<LoginBloc>().userInfo!.user!.id).then((value){
      print('User Status ${context.read<HomeControllerCubit>().userStatus}');

      if(context.read<HomeControllerCubit>().userStatus == "User not found"){
        Navigator.pushNamedAndRemoveUntil(context,
            RouteNames.authenticationScreen, (route) => false,);
      }
    });
    context.read<HomeControllerCubit>().getSearchData();
  }

  @override
  Widget build(BuildContext context) {
    final homeBolc = context.read<HomeControllerCubit>();
    return SafeArea(
      child: BlocBuilder<HomeControllerCubit, HomeControllerState>(
          buildWhen: (previous, current) => previous != current,
          builder: (context, state) {
            if (state is HomeControllerLoading) {
              print("Loading0");
              return const Center(child: CircularProgressIndicator());
            }

            if (state is HomeControllerError) {
              print("Loading1");
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.errorMessage,
                      style: const TextStyle(color: redColor),
                    ),
                    const SizedBox(height: 10)
                  ],
                ),
              );
            }

            if (state is HomeControllerLoaded) {
              print("Loading2");
              return Scaffold(
                backgroundColor: const Color(0xFFF6F7FE),
                // appBar: AppBar(
                //   backgroundColor: const Color(0xFF78359E),
                //   // centerTitle: true,
                //   scrolledUnderElevation: 0,
                //   title: const Text("Homepage", style: TextStyle(color: Colors.white),),
                // ),
                body: RefreshIndicator(
                  key: refreshKey,
                  onRefresh: () =>homeBolc.getHomeData(),
                  child: CustomScrollView(
                    slivers: [
                      ///Search Bar
                      SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverToBoxAdapter(
                          child: TypeAheadFormField(
                            textFieldConfiguration:
                            TextFieldConfiguration(
                              onChanged: (value){
                                if (value == '') {
                                  searchValue = '';
                                }
                              },
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                              controller: homeBolc.searchController,
                              decoration: InputDecoration(
                                hintText: 'Search Product',
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
                                suffix: searchValue == '' ? null : GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      homeBolc.searchController.text = '';
                                    });
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 3),
                                    child: Icon(Icons.close,size: 14,),
                                  ),
                                ),
                              ),
                            ),
                            suggestionsCallback: (pattern) {
                              return homeBolc.productModel
                                  .where((element) => element.isFuture == '1')
                                  .where((element) => element.productName.toString()
                                  .toLowerCase()
                                  .contains(pattern
                                  .toString()
                                  .toLowerCase()))
                                  .take(homeBolc.productModel.length)
                                  .toList();
                            },
                            itemBuilder: (context, suggestion) {
                              return ListTile(
                                leading: CircleAvatar(
                                  radius: 22,
                                  backgroundColor:
                                  Colors.grey.shade300,
                                  child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(100),
                                    child: CustomImage(
                                      path: suggestion.image !=
                                          ''
                                          ? "${RemoteUrls.rootUrl}uploads/product/${suggestion.image}"
                                          : null,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                title: SizedBox(child: Text(suggestion.productName,style: const TextStyle(fontSize: 12), maxLines: 1,overflow: TextOverflow.ellipsis,)),
                                subtitle: SizedBox(child: Text("${suggestion.productSellingPrice} Tk",style: const TextStyle(fontSize: 12, color: redColor), maxLines: 1,overflow: TextOverflow.ellipsis,)),
                              );
                            },
                            transitionBuilder:
                                (context, suggestionsBox, controller) {
                              return suggestionsBox;
                            },
                            onSuggestionSelected:
                                (ProductModel suggestion) {
                              homeBolc.searchController.text = suggestion.productName;
                              Navigator.pushNamed(context, RouteNames.productDetailsScreen,
                                arguments: suggestion);
                              setState(() {
                                searchValue = suggestion.productName.toString();
                              });
                            },
                            onSaved: (value) {},
                          ),
                        ),
                      ),

                      ///Types List Value
                      TypeListProductContainer(
                        typeModelList: state.homeModel.types..sort(
                          (a, b) {
                            return a.name.toLowerCase().compareTo(b.name.toLowerCase());
                          },
                        ),
                        title: 'Types',
                         onPressed: (){},
                      ),

                      const SliverToBoxAdapter(child: SizedBox(height: 10,),),

                      ///Category List Value
                      CategoryListContainer(
                        categoryModel: state.homeModel.categories..sort(
                              (a, b) {
                            return a.productCategoryName.toLowerCase().compareTo(b.productCategoryName.toLowerCase());
                          },
                        ),
                          title: 'Category',
                        onPressed: (){},
                      ),

                      const SliverToBoxAdapter(child: SizedBox(height: 10,),),

                      ///Brand List Value
                      BrandListContainer(
                        brandModelList: state.homeModel.brands..sort(
                              (a, b) {
                            return a.brandName.toLowerCase().compareTo(b.brandName.toLowerCase());
                          },
                        ),
                        title: 'Brand',
                        onPressed: (){},
                      ),

                      const SliverToBoxAdapter(child: SizedBox(height: 10,),),

                      ///Color List Value
                      ColorListContainer(
                        colorModelList: state.homeModel.colorApi..sort(
                              (a, b) {
                            return a.colorName.toLowerCase().compareTo(b.colorName.toLowerCase());
                          },
                        ),
                        title: 'Color',
                        onPressed: (){},
                      ),

                      ///Image Slider Section
                      SliverToBoxAdapter(
                        child: ImageSlider(
                          sliderModelList: state.homeModel.sliders,
                          height: MediaQuery.of(context).size.width * 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox();
          }
      ),
    );
  }
  final int initialPage = 0;
  int currentIndex = 0;

  CarouselController carouselController = CarouselController();
  void callbackFunction(int index, CarouselPageChangedReason reason) {
    setState(() {
      currentIndex = index;
    });
  }

}
