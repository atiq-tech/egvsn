// Design by - Link-Up Technology Ltd.
// Developed by - Link-Up Technology Ltd.
// Location - Mirpur-10, Dhaka, Bangladesh.
// Website - https://www.linktechbd.com/
// Phone - +8801911978897

import 'package:egovisionapp/core/remote_name.dart';
import 'package:egovisionapp/module/authentication/login/controller/login_bloc.dart';
import 'package:egovisionapp/module/authentication/login/login_screen.dart';
import 'package:egovisionapp/module/authentication/registration/component/otp_verify.dart';
import 'package:egovisionapp/module/authentication/registration/controller/reg_bloc.dart';
import 'package:egovisionapp/module/authentication/registration/registration_screen.dart';
import 'package:egovisionapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  @override
  Widget build(BuildContext context) {

    final regBloc = context.read<RegBloc>();

    return MultiBlocListener(
      listeners: [
        BlocListener<LoginBloc, LoginModelState>(
          listenWhen: (previous, current) => previous.state != current.state,
          listener: (context, state) {
            if (state.state is LoginStateError) {
              final status = state.state as LoginStateError;
              Utils.errorSnackBar(context, status.errorMsg);
            } else if (state.state is LoginStateLoaded) {
              final status = state.state as LoginStateLoaded;
              Navigator.pushReplacementNamed(context, RouteNames.mainPage);
              Utils.showSnackBar(context, status.user.success);
            } else if (state.state is SendAccountCodeSuccess) {
              final messageState = state.state as SendAccountCodeSuccess;
              Utils.showSnackBar(context, messageState.msg);
            } else if (state.state is AccountActivateSuccess) {
              final messageState = state.state as AccountActivateSuccess;
              Utils.showSnackBar(context, messageState.msg);
              Navigator.pop(context);
            }
          },
        ),
        BlocListener<RegBloc, RegModelState>(
          listenWhen: (previous, current) {
            return previous.state != current.state;
          },
          listener: (context, state) {
            if (state.state is RegStateLoadedError) {
              final status = state.state as RegStateLoadedError;
              Utils.errorSnackBar(context, status.errorMsg);
            } else if (state.state is RegStateFormError) {
              final status = state.state as RegStateFormError;
              Utils.errorSnackBar(context, status.errorMsg);
            } else if (state.state is RegStateLoaded) {
              final loadedData = state.state as RegStateLoaded;
              // Navigator.pushNamed(context, RouteNames.verificationCodeScreen);
              Utils.showSnackBar(context, loadedData.msg);
              Navigator.pushNamed(context, RouteNames.otpVerifyScreen,
                  arguments: OtpVerifyScreenArguments(loadedData.userId, loadedData.email));

              // _pageController.animateToPage(2,
              //     duration: const Duration(microseconds: 1500), curve: Curves.bounceInOut);
            }else if (state.state is RegOtpError) {
              final status = state.state as RegOtpError;
              Utils.errorSnackBar(context, status.errorMsg);
            } else if(state.state is RegOtpLoaded){
              final loadedMsg = state.state as RegOtpLoaded;
              Utils.showSnackBar(context, loadedMsg.msg);
              regBloc.codeController.text = '';
              regBloc.passController.text = '';
              regBloc.conPassController.text = '';
              print("successfullllllllllllllllll++++++++++++++++++");
              Navigator.pop(context);
              _pageController.animateToPage(0,
                  duration: const Duration(microseconds: 1500), curve: Curves.bounceInOut);

            }
          },
        ),
      ],
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        // body: SafeArea(
        //   child: Container(
        //     height: MediaQuery.of(context).size.height,
        //     decoration: const BoxDecoration(
        //       gradient: LinearGradient(
        //         begin: Alignment.topCenter,
        //         end: Alignment.bottomRight,
        //         colors: [Colors.white, Color(0xffFFEFE7)],
        //       ),
        //     ),
        //     child: Center(
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.center,
        //         mainAxisSize: MainAxisSize.max,
        //         children: [
        //           const SizedBox(height: 20),
        //           CustomImage(
        //             // path: RemoteUrls.imageUrl(appSetting.settingModel!.logo),
        //             path: Kimages.logoColor,
        //             width: 280,
        //             height: 110,
        //           ),
        //           const SizedBox(height: 0),
        //           _buildHeader(),
        //           const SizedBox(height: 15),
        //           // _buildTabText(),
        //           SizedBox(
        //             height: MediaQuery.of(context).size.height * 1,
        //             child: PageView(
        //               physics: const ClampingScrollPhysics(),
        //               controller: _pageController,
        //               onPageChanged: (int page) {
        //                 setState(() {
        //                   _currentPage = page;
        //                 });
        //               },
        //               children: const [SigninForm(), SignUpForm()],
        //             ),
        //           )
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          // onPageChanged: (int page) {
          //   setState(() {
          //     _currentPage = page;
          //   });
          // },
          children: [LoginScreen(pageController: _pageController), RegistrationScreen(pageController: _pageController)],
        ),
        // bottomNavigationBar: Container(
        //     height: 60,
        //     decoration: BoxDecoration(
        //         color: Colors.white,
        //         boxShadow: [
        //           BoxShadow(
        //               blurRadius: 50,
        //               offset: const Offset(0,10),
        //               color: Colors.grey.withOpacity(0.5)
        //           )
        //         ]
        //     ),
        //     padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 8),
        //     child: _buildTabText(),
        // ),
      ),
    );
  }

  // Widget _buildTabText() {
  //   const tabUnSelectedTextColor = Color(0xff797979);
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 20),
  //     child: Row(
  //       mainAxisSize: MainAxisSize.max,
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Expanded(
  //           child: ElevatedButton(
  //             style: ElevatedButton.styleFrom(backgroundColor: Colors.white,elevation: 0),
  //             onPressed: (){
  //               _pageController.animateToPage(0,
  //                   duration: kDuration, curve: Curves.bounceInOut);
  //             },
  //             child: Text("${AppLocalizations.of(context).translate('sign_in')}",style: TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.w600,
  //                 color:
  //                 _currentPage == 0 ? blackColor : tabUnSelectedTextColor),),
  //           ),
  //         ),
  //         Container(
  //           color: borderColor,
  //           width: 1,
  //           height: 20,
  //           margin: const EdgeInsets.symmetric(horizontal: 16),
  //         ),
  //         Expanded(
  //           child: ElevatedButton(
  //             style: ElevatedButton.styleFrom(backgroundColor: Colors.white,elevation: 0),
  //             onPressed: (){
  //               _pageController.animateToPage(1,
  //                   duration: kDuration, curve: Curves.bounceInOut);
  //             },
  //             child: Text("${AppLocalizations.of(context).translate('sign_up')}",
  //               style: TextStyle(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.w600,
  //                   color:
  //                   _currentPage == 1 ? blackColor : tabUnSelectedTextColor),),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
