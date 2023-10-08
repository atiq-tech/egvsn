// Design by - Link-Up Technology Ltd.
// Developed by - Link-Up Technology Ltd.
// Location - Mirpur-10, Dhaka, Bangladesh.
// Website - https://www.linktechbd.com/
// Phone - +8801911978897

import 'dart:io';

import 'package:egovisionapp/core/remote_name.dart';
import 'package:egovisionapp/module/authentication/authentication_screen.dart';
import 'package:egovisionapp/module/authentication/login/controller/login_bloc.dart';
import 'package:egovisionapp/module/authentication/login/login_screen.dart';
import 'package:egovisionapp/module/cart/cart_screen.dart';
import 'package:egovisionapp/module/home/home_screen.dart';
import 'package:egovisionapp/module/order/component/all_order_screen.dart';
import 'package:egovisionapp/module/order/component/pending_order_screen.dart';
import 'package:egovisionapp/module/profile/profile_screen.dart';
import 'package:egovisionapp/utils/utils.dart';
import 'package:egovisionapp/widget/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upgrader/upgrader.dart';

import 'component/bottom_navigation_bar.dart';
import 'main_controller.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _homeController = MainController();

  late List<Widget> pageList;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<LoginBloc>().add(const LoginEventCheckProfile());
    });

    pageList = [
      const HomeScreen(),
      const PendingOrderScreen(),
      const CartScreen(),
      const AllOrderScreen(),
      const ProfileScreen(),
    ];
  }

  final _className = "MainPage";

  @override
  Widget build(BuildContext context) {

    final loginBloc = context.read<LoginBloc>();

    return StreamBuilder<int>(
      initialData: 0,
      stream: _homeController.naveListener.stream,
      builder: (context, AsyncSnapshot<int> snapshot) {
        int index = snapshot.data ?? 0;

        return BlocListener<LoginBloc, LoginModelState>(
          key: UniqueKey(),
          listener: (context, state) {
            if (state.state is LoginStateLogOut) {
              Utils.closeDialog(context);
              Navigator.pushNamedAndRemoveUntil(
                  context, RouteNames.authenticationScreen, (route) => false);
            } else if (state.state is LoginStateLogOutLoading) {
              Utils.loadingDialog(context);
            } else if (state.state is LoginStateSignOutError) {
              final currentState = state.state as LoginStateSignOutError;
              Utils.closeDialog(context);
              Utils.errorSnackBar(context, currentState.errorMsg);
            }
          },
          child: Scaffold(
            extendBody: true,
            key: UniqueKey(),
            appBar: AppBar(
              backgroundColor: const Color(0xFF78359E),
              scrolledUnderElevation: 0,
              title: const SizedBox(child: Text("Ego Vision",maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white),)),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: SizedBox(child: Text("Due: ${loginBloc.userInfo?.due}",maxLines: 1,overflow: TextOverflow.ellipsis,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                )
              ],
            ),
            drawer: CustomDrawer(
              loginBloc: context.read<LoginBloc>(),
            ),
            body: WillPopScope(
              onWillPop: () => _homeController.onBackPressed(context,index),
              child: UpgradeAlert(
                upgrader: Upgrader(
                  dialogStyle: Platform.isIOS ? UpgradeDialogStyle.cupertino : UpgradeDialogStyle.material,
                ),
                child: IndexedStack(
                  index: index,
                  children: pageList,
                ),
              ),
            ),
            bottomNavigationBar: MyBottomNavigationBar(
              mainController: _homeController, selectedIndex: index,
            ),
          ),
        );
      },
    );
  }
}