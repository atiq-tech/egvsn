// Design by - Link-Up Technology Ltd.
// Developed by - Link-Up Technology Ltd.
// Location - Mirpur-10, Dhaka, Bangladesh.
// Website - https://www.linktechbd.com/
// Phone - +8801911978897

import 'dart:io';

import 'package:egovisionapp/core/remote_url.dart';
import 'package:egovisionapp/module/authentication/login/controller/login_bloc.dart';
import 'package:egovisionapp/module/profile/component/change_password.dart';
import 'package:egovisionapp/module/profile/controller/profile_cubit.dart';
import 'package:egovisionapp/utils/constant.dart';
import 'package:egovisionapp/widget/custom_image.dart';
import 'package:egovisionapp/widget/please_signin_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // bool isEditBtnClk = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<ProfileScreenCubit>().isPasswordBtnClk = false;
    context.read<ProfileScreenCubit>().currentPassCtrl.text = '';
    context.read<ProfileScreenCubit>().newPassCtrl.text = '';
    context.read<ProfileScreenCubit>().confirmPassCtrl.text = '';
  }

  @override
  Widget build(BuildContext context) {
    final userData = context.read<LoginBloc>().userInfo;
    final bloc = context.read<ProfileScreenCubit>();

    print('User info $userData');

    if (userData == null) {
      return const PleaseSignInWidget();
    }

    return SafeArea(
      child: Center(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    ///Image upload section
                    SizedBox(
                      height: 140,
                      width: 140,
                      child: Stack(
                        children: [
                          Container(
                            height: 140,
                            width: 140,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white,
                                    width: 4,
                                    strokeAlign: BorderSide.strokeAlignOutside),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      blurRadius: 16,
                                      offset: const Offset(0, 0)),
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      blurRadius: 16,
                                      offset: const Offset(0, 0)),
                                ]),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: LayoutBuilder(
                                    builder: (context, constraints) {
                                  if (file == null) {
                                    return CustomImage(
                                      path: userData.user?.image == ''
                                          ? null
                                          : '${RemoteUrls.rootUrl}uploads/customer/${userData.user!.image}',
                                      height: 140,
                                      width: 140,
                                      fit: BoxFit.cover,
                                    );
                                  }
                                  return Image(
                                    image: FileImage(file!),
                                    fit: BoxFit.cover,
                                  );
                                })),
                          ),
                          Positioned(
                              right: 0,
                              bottom: 10,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 4)),
                                child: Material(
                                  color: Colors.white,
                                  shape: const CircleBorder(),
                                  child: InkWell(
                                    onTap: () {
                                      if(file == null) {
                                        chooseImageFrom();
                                      }else{
                                        setState(() {
                                          bloc.isImgLoading = true;
                                        });
                                        bloc.imageUpload(context, file!).then((value){
                                          setState(() {
                                            bloc.isImgLoading = false;
                                          });
                                        });
                                        // print("All OkKKKk");
                                      }
                                    },
                                    child: images?.path == null
                                        ? const Icon(Icons.edit) : bloc.isImgLoading ? const SizedBox(height: 20,width: 20,child: CircularProgressIndicator(color: redColor))
                                        : const Icon(Icons.done_outline,color: redColor,),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    ///User Info
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 1),
                            blurRadius: 5,
                            color: Colors.black.withOpacity(0.3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            width: double.infinity,
                            color: redColor,
                            child: const Text(
                              "Info",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            color: Colors.white,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Customer ID"),
                                    Text("${userData.user!.code}"),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Customer Name"),
                                    Text("${userData.user!.name}"),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Owner Name"),
                                    Text("${userData.user!.ownerName}"),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Phone"),
                                    Text("${userData.user!.phone}"),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("E-mail"),
                                    Text("${userData.user!.customerEmail}"),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Address"),
                                    const SizedBox(width: 20,),
                                    // Spacer(),
                                    Expanded(child: SizedBox(child: Text("${userData.user!.address}",textAlign: TextAlign.end,overflow: TextOverflow.ellipsis,))),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Area"),
                                    Text("${userData.user!.area}"),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Officer"),
                                    Text("${userData.user!.officerName}"),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Organization"),
                                    Text("${userData.user!.organizationName}"),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    Visibility(
                      visible: !bloc.isPasswordBtnClk,
                      child: SizedBox(
                        height: 45,
                        width: 200,
                        child: ElevatedButton(onPressed: () {
                          setState(() {
                            bloc.isPasswordBtnClk = true;
                          });
                        },
                          child: const Text("Update Password"),
                        ),
                      ),
                    ),

                    Visibility(
                      visible: bloc.isPasswordBtnClk,
                      child: const Column(
                        children: [
                          SizedBox(height: 20,),
                          ChangePassEdit(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  XFile? images;
  File? file;

  chooseImageFrom() async {
    ImagePicker picker = ImagePicker();
    images = await picker.pickImage(source: ImageSource.gallery);
    file = File("${images?.path}");
    setState(() {});
  }
}
