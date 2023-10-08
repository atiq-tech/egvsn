import 'package:egovisionapp/core/remote_name.dart';
import 'package:egovisionapp/module/authentication/login/controller/login_bloc.dart';
import 'package:egovisionapp/utils/constant.dart';
import 'package:egovisionapp/utils/k_images.dart';
import 'package:egovisionapp/utils/utils.dart';
import 'package:egovisionapp/widget/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key, required this.pageController}) : super(key: key);

  PageController pageController = PageController();

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  bool _checkBoxSelect = false;
  bool _passwordVisible = false;
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    final loginBloc = context.read<LoginBloc>();
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            sliver: SliverToBoxAdapter(
              child: Form(
                key: loginBloc.formKey,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                  child: Column(
                    children: [
                      const CustomImage(
                        path: Kimages.loginLogo,
                        height: 200,
                      ),
                      const SizedBox(height: 20),

                      Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0)),
                          child: BlocBuilder<LoginBloc, LoginModelState>(
                              buildWhen: (previous, current) =>
                              previous.userID != current.userID,
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
                                  if (value == null || value.isEmpty) {
                                    return 'Enter Email';
                                  }
                                  return null;
                                },
                                onChanged: (value) =>
                                    loginBloc.add(LoginEventUserId(value)),                                keyboardType: TextInputType.text,
                              );
                            }
                          ),
                      ),

                      Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0)),
                          child: BlocBuilder<LoginBloc, LoginModelState>(
                              buildWhen: (previous, current) =>
                              previous.password != current.password,
                              builder: (context, state) {
                              return TextFormField(
                                style: const TextStyle(
                                  color: Colors.white, // set the text color to blue
                                ),
                                obscureText: _isObscure,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter Password';
                                  }
                                  return null;
                                },
                                onChanged: (value) =>
                                    loginBloc.add(LoginEventPassword(value)),
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.lock, color: Colors.white),
                                  fillColor: Colors.blueGrey,
                                  hintText: 'Password',
                                  hintStyle:
                                      const TextStyle(color: Colors.white, fontSize: 14),
                                  suffixIcon: IconButton(
                                    icon: Icon(_isObscure
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                    onPressed: () {
                                      setState(() {
                                        _isObscure = !_isObscure;
                                      });
                                    },
                                  ),
                                ),
                                // controller: _idController,
                                keyboardType: TextInputType.text,
                              );
                            }
                          ),
                      ),

                      BlocBuilder<LoginBloc, LoginModelState>(
                        buildWhen: (previous, current) =>
                        previous.state != current.state,
                        builder: (context, state) {
                          if (state.state is LoginStateLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          return SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                Utils.closeKeyBoard(context);
                                loginBloc.add(const LoginEventSubmit());
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero),
                                  backgroundColor: redColor),
                              child: const Text("Log In"),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Don\'t have an account? ',
                            style: TextStyle(color: Colors.black54),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.pageController.animateToPage(1,
                                  duration: kDuration,
                                  curve: Curves.bounceInOut);
                            },
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                  color: redColor, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
