// Design by - Link-Up Technology Ltd.
// Developed by - Link-Up Technology Ltd.
// Location - Mirpur-10, Dhaka, Bangladesh.
// Website - https://www.linktechbd.com/
// Phone - +8801911978897

import 'dart:developer';
import 'package:egovisionapp/core/remote_name.dart';
import 'package:egovisionapp/module/animated_splash/controller/app_setting_cubit.dart';
import 'package:egovisionapp/module/authentication/login/controller/login_bloc.dart';
import 'package:egovisionapp/utils/constant.dart';
import 'package:egovisionapp/utils/k_images.dart';
import 'package:egovisionapp/widget/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnimatedSplashScreen extends StatefulWidget {
  const AnimatedSplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<AnimatedSplashScreen>
    with SingleTickerProviderStateMixin {
  final _className = '_SplashScreenState';
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() {
      if (mounted) setState(() {});
    });
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final appSettingBloc = context.read<AppSettingCubit>();
    final loginBloc = context.read<LoginBloc>();

    return Scaffold(
      body: BlocConsumer<AppSettingCubit, AppSettingState>(
          listener: (context, state) async {
            if (state is AppSettingStateLoaded){
              print('State Loaded');
              if (loginBloc.isLoggedIn) {
                Navigator.pushReplacementNamed(context, RouteNames.mainPage);
              } else if (appSettingBloc.isOnBoardingShown) {
                Navigator.pushReplacementNamed(context, RouteNames.authenticationScreen);
              } else {
                Navigator.pushReplacementNamed(context, RouteNames.authenticationScreen);
              }
            }
          },

          builder: (context, state) {
          return AnimationWidget(animation: animation);
        }
      ),
    );
  }
}

class AnimationWidget extends StatelessWidget {
  const AnimationWidget({
    Key? key,
    required this.animation,
  }) : super(key: key);

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [whiteColor, whiteColor],
            ),
          ),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          // child: const CustomImage(path: Kimages.backgroundShape),
          child: const SizedBox(),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomImage(
              path: Kimages.appLogo,
              width: animation.value * 250,
              height: animation.value * 250,
            ),
            const SizedBox(height: 50),
            const Center(child: CircularProgressIndicator(color: Color(0xFF3F51B5),))
          ],
        ),
      ],
    );
  }
}
