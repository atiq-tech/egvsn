import 'dart:async';

import 'package:egovisionapp/core/remote_name.dart';
import 'package:egovisionapp/module/authentication/registration/controller/reg_bloc.dart';
import 'package:egovisionapp/utils/constant.dart';
import 'package:egovisionapp/utils/k_images.dart';
import 'package:egovisionapp/utils/utils.dart';
import 'package:egovisionapp/widget/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

class OtpVerifyScreenArguments {
  final String userId;
  final String email;

  OtpVerifyScreenArguments(this.userId, this.email);
}

class OtpVerifyScreen extends StatefulWidget {
  OtpVerifyScreen({Key? key, required this.userId, required this.emailOrPhone})
      : super(key: key);
  String userId;
  String emailOrPhone;

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  bool _passwordVisible = false;
  bool resendBtnVisible = false;

  late int _currentSeconds;
  late Timer _timer;

  @override
  void initState() {
    context.read<RegBloc>().codeController.text = '';
    super.initState();
    _currentSeconds = 120;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_currentSeconds > 0) {
          _currentSeconds--;
        } else {
          _timer.cancel();
          resendBtnVisible = true;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final regBloc = context.read<RegBloc>();

    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              sliver: SliverToBoxAdapter(
                child: Form(

                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 16),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 80,
                          backgroundColor: redColor.withOpacity(0.2),
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(30),
                            child: const CustomImage(
                              path: Kimages.otpVerify,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Verify ${widget.emailOrPhone}",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Enter the OTP code to verify your email",
                          style: TextStyle(fontSize: 12),
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(0, 1),
                                  blurRadius: 5,
                                  color: Colors.black.withOpacity(0.3),
                                ),
                              ]),
                          child: Pinput(
                            controller: regBloc.codeController,
                            validator: (value) {
                              if(value!=null || value.toString().isNotEmpty){
                                regBloc.codeController.text = value.toString();
                              }
                              else{
                                return "Enter OTP";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              regBloc.codeController.text = value.trim();
                            },
                            androidSmsAutofillMethod:
                                AndroidSmsAutofillMethod.smsRetrieverApi,
                          ),
                        ),

                        const SizedBox(
                          height: 15,
                        ),

                        resendBtnVisible
                            ? Align(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        resendBtnVisible = false;
                                        isTxtFldHide = false;
                                        _currentSeconds = 120;
                                        regBloc.codeController.text = '';
                                      });
                                      _startTimer();
                                      regBloc
                                          .add(RegEventUserId(widget.userId));
                                      regBloc.add(
                                          RegEventEmail(widget.emailOrPhone));
                                      regBloc.add(RegEventSubmit());
                                    },
                                    child: const Text("Resend",style: TextStyle(
                                      color: redColor, fontSize: 16, fontWeight: FontWeight.bold
                                    ),)),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Text(
                                    'Resend after ',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      // Navigator.pop(context);
                                      // Navigator.pop(context);
                                      ///
                                      // widget.pageController.animateToPage(0,
                                      //     duration: kDuration,
                                      //     curve: Curves.bounceInOut);
                                    },
                                    child: Text(
                                      '${_currentSeconds} second',
                                      style: const TextStyle(
                                          color: redColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),

                        SizedBox(
                          height: 15,
                        ),

                        Visibility(
                          visible: isTxtFldHide,
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0)),
                                child: TextFormField(
                                  style: const TextStyle(
                                    color: Colors
                                        .white, // set the text color to blue
                                  ),
                                  obscureText: _isObscurePass,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter Password';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    regBloc.passController.text = value.trim();
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.lock,
                                        color: Colors.white),
                                    fillColor: Colors.blueGrey,
                                    hintText: 'Password',
                                    hintStyle: const TextStyle(
                                        color: Colors.white, fontSize: 14),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isObscurePass
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isObscurePass = !_isObscurePass;
                                        });
                                      },
                                    ),
                                  ),
                                  // controller: _idController,
                                  keyboardType: TextInputType.text,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0)),
                                child: TextFormField(
                                  style: const TextStyle(
                                    color: Colors
                                        .white, // set the text color to blue
                                  ),
                                  obscureText: _isObscureCPass,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter Confirm Password';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    regBloc.conPassController.text = value.trim();
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.lock,
                                        color: Colors.white),
                                    fillColor: Colors.blueGrey,
                                    hintText: 'Confirm Password',
                                    hintStyle: const TextStyle(
                                        color: Colors.white, fontSize: 14),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isObscureCPass
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isObscureCPass = !_isObscureCPass;
                                        });
                                      },
                                    ),
                                  ),
                                  // controller: _idController,
                                  keyboardType: TextInputType.text,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Visibility(
                          visible: !isRegBtnClk,
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                if(regBloc.codeController.text!=''||regBloc.codeController.text.isNotEmpty){
                                  setState(() {
                                    isNextBtnClk = true;
                                  });
                                  Future.delayed(
                                    Duration(seconds: 3),
                                        () {
                                      setState(() {
                                        isNextBtnClk = false;
                                        isRegBtnClk = true;
                                        isTxtFldHide = true;
                                      });
                                    },
                                  );
                                }else{
                                  Utils.errorSnackBar(context, "Please Enter OTP");
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero),
                                backgroundColor: redColor,
                              ),
                              child: isNextBtnClk
                                  ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                                  : Text("Next"),
                            ),
                          ),
                        ),

                        Visibility(
                          visible: isRegBtnClk,
                          child: SizedBox(
                            height: 48,
                            child: BlocBuilder<RegBloc, RegModelState>(
                                buildWhen: (previous, current) =>
                                previous.state != current.state,
                                builder: (context, state) {
                                  if(state.state is RegStateLoading){
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                return ElevatedButton(
                                  onPressed: () {
                                    if(regBloc.passController.text != regBloc.conPassController.text){
                                      Utils.errorSnackBar(context, "Password doesn't matched");
                                    }else if(regBloc.passController.text.isEmpty || regBloc.conPassController.text.isEmpty){
                                      Utils.errorSnackBar(context, "Password and confirm password is required");
                                    }
                                    else{
                                      print('all done');
                                      regBloc.register(regBloc.codeController.text.trim(), regBloc.passController.text.trim());
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero),
                                    backgroundColor: redColor,
                                  ),
                                  child:Text("Register"),
                                );
                              }
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  bool isNextBtnClk = false;
  bool isRegBtnClk = false;
  bool isTxtFldHide = false;
  bool _isObscurePass = false;
  bool _isObscureCPass = false;
  bool onPressed = true;
}
