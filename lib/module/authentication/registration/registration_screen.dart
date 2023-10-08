import 'package:egovisionapp/core/remote_name.dart';
import 'package:egovisionapp/module/authentication/registration/controller/reg_bloc.dart';
import 'package:egovisionapp/utils/constant.dart';
import 'package:egovisionapp/utils/k_images.dart';
import 'package:egovisionapp/utils/utils.dart';
import 'package:egovisionapp/widget/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class RegistrationScreen extends StatefulWidget {
  RegistrationScreen({Key? key,  required this.pageController}) : super(key: key);

  PageController pageController = PageController();

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<RegBloc>().emailPhoneController.text = '';
    context.read<RegBloc>().userIdController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    final regBloc = context.read<RegBloc>();

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            sliver: SliverToBoxAdapter(
              child: Form(
                key: regBloc.formKey,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                  child: Column(
                    children: [
                      // AnimatedContainer(
                      //   padding: const EdgeInsets.symmetric(horizontal: 20),
                      //   alignment: Alignment.topLeft,
                      //   duration: kDuration,
                      //   child: Center(
                      //     child: Text(
                      //       "Log in",
                      //       style: const TextStyle(
                      //           fontWeight: FontWeight.bold, fontSize: 30),
                      //     ),
                      //   ),
                      // ),
                      // const SizedBox(height: 12),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     const Text(
                      //       'Don\'t have an account? ',
                      //       style: TextStyle(color: Colors.black54),
                      //     ),
                      //     GestureDetector(
                      //       onTap: () {
                      //         widget.pageController!.animateToPage(1,
                      //             duration: kDuration,
                      //             curve: Curves.bounceInOut);
                      //       },
                      //       child: const Text(
                      //         'Register',
                      //         style: TextStyle(
                      //             color: redColor, fontWeight: FontWeight.bold),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      //
                      // const SizedBox(height: 12),
                      const CustomImage(path: Kimages.loginLogo, height: 200,),

                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0)),
                        child: BlocBuilder<RegBloc, RegModelState>(
                            buildWhen: (previous, current) =>
                            previous.customerId != current.customerId,
                            builder: (context, state) {
                              return TextFormField(
                                style: const TextStyle(
                                  color: Colors.white, // set the text color to blue
                                ),
                                obscureText: false,
                                decoration: const InputDecoration(
                                  prefixIcon:
                                  Icon(Icons.person, color: Colors.white),
                                  fillColor: Colors.blueGrey,
                                  hintText: 'User ID',
                                  hintStyle:
                                  TextStyle(color: Colors.white, fontSize: 14),
                                ),
                                validator: (value) {
                                  if (value != null || value.toString().isNotEmpty) {
                                    regBloc.userIdController.text = value.toString().trim();
                                  }
                                  else{
                                    return 'Enter Email';
                                  }
                                  return null;
                                },
                                onChanged: (value) => regBloc.add(RegEventUserId(value)),
                                keyboardType: TextInputType.text,
                              );
                            }
                        ),
                      ),

                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0)),
                        child: BlocBuilder<RegBloc, RegModelState>(
                            buildWhen: (previous, current) =>
                            previous.email != current.email,
                            builder: (context, state) {
                              return TextFormField(
                                style: const TextStyle(
                                  color: Colors.white, // set the text color to blue
                                ),
                                controller: regBloc.emailPhoneController,
                                // obscureText: _isObscure,
                                validator: (value) {
                                  if (value != null || value.toString().isNotEmpty) {
                                    regBloc.emailPhoneController.text = value.toString().trim();
                                  }else{
                                    return 'Enter Email or Phone';
                                  }
                                  return null;
                                },
                                onChanged: (value) =>
                                    regBloc.add(RegEventEmail(value)),
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.email, color: Colors.white),
                                  fillColor: Colors.blueGrey,
                                  hintText: 'Enter email or phone',
                                  hintStyle:
                                  TextStyle(color: Colors.white, fontSize: 14),
                                ),
                                // controller: _idController,
                                keyboardType: TextInputType.text,
                              );
                            }
                        ),
                      ),

                      BlocBuilder<RegBloc, RegModelState>(
                        buildWhen: (previous, current) =>
                        previous.state != current.state,
                        builder: (context, state) {
                          if (state.state is RegStateLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return SizedBox(
                              height: 48,
                              child: ElevatedButton(
                                onPressed: () {
                                  Utils.closeKeyBoard(context);
                                  regBloc.add(RegEventSubmit());
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero),
                                  backgroundColor: redColor,
                                ),
                                child: const Text("Continue"),
                              ),
                            );
                        },
                      ),
                      const SizedBox(height: 10),
                      ///
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account? ',
                            style: TextStyle(color: Colors.black54),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.pageController.animateToPage(0,
                                  duration: kDuration,
                                  curve: Curves.bounceInOut);
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                  color: redColor, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),


                //
                // child: Container(
                //   padding:
                //   const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                //   child: Column(
                //     children: [
                //
                //       //
                //       // Container(
                //       //     margin: EdgeInsets.only(bottom: 20),
                //       //     decoration: BoxDecoration(
                //       //         borderRadius: BorderRadius.circular(8.0)
                //       //     ),
                //       //     child: TextFormField(
                //       //       style: TextStyle(
                //       //         color: Colors.white, // set the text color to blue
                //       //       ),
                //       //       obscureText: false,
                //       //       decoration: InputDecoration(
                //       //         prefixIcon: Icon(Icons.person, color: Colors.white),
                //       //         fillColor: Colors.blueGrey,
                //       //         hintText: 'User ID',
                //       //         hintStyle: TextStyle(color: Colors.white, fontSize: 14),
                //       //
                //       //       ),
                //       //       // controller: _idController,
                //       //       keyboardType: TextInputType.text,
                //       //     )),
                //       //
                //       //
                //       //
                //       // Container(
                //       //     margin: EdgeInsets.only(bottom: 20),
                //       //     decoration: BoxDecoration(
                //       //         borderRadius: BorderRadius.circular(8.0)
                //       //     ),
                //       //     child: TextFormField(
                //       //       style: TextStyle(
                //       //         color: Colors.white, // set the text color to blue
                //       //       ),
                //       //
                //       //
                //       //       decoration: InputDecoration(
                //       //         prefixIcon: Icon(Icons.email, color: Colors.white),
                //       //         fillColor: Colors.blueGrey,
                //       //         hintText: 'Email',
                //       //         hintStyle: TextStyle(color: Colors.white, fontSize: 14),
                //       //
                //       //       ),
                //       //       // controller: _idController,
                //       //       keyboardType: TextInputType.text,
                //       //     )),
                //
                //       SizedBox(
                //         height: 50.0,
                //         child: ElevatedButton(
                //           onPressed: () {
                //
                //           },
                //           style: ElevatedButton.styleFrom(
                //
                //               shape: RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.circular(8.0),
                //               ),
                //               backgroundColor: redColor),
                //           child: const Text("Registration Now"),
                //         ),
                //       ),
                //       const SizedBox(height: 10),
                //       //
                //       // Row(
                //       //   mainAxisAlignment: MainAxisAlignment.center,
                //       //   children: [
                //       //     const Text(
                //       //       'Already have an account? ',
                //       //       style: TextStyle(color: Colors.black54),
                //       //     ),
                //       //     GestureDetector(
                //       //       onTap: () {
                //       //         // widget.pageController!.animateToPage(1,
                //       //         //     duration: kDuration,
                //       //         //     curve: Curves.bounceInOut);
                //       //         Navigator.pushNamed(
                //       //             context, RouteNames.loginPage);
                //       //       },
                //       //       child: const Text(
                //       //         'Login',
                //       //         style: TextStyle(
                //       //             color: redColor, fontWeight: FontWeight.bold),
                //       //       ),
                //       //     ),
                //       //   ],
                //       // ),
                //       //
                //     ],
                //   ),
                // ),
                //
              ),
            ),
          )
        ],
      ),
    );
  }
}