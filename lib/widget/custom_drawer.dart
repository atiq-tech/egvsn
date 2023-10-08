import 'package:egovisionapp/core/remote_name.dart';
import 'package:egovisionapp/core/remote_url.dart';
import 'package:egovisionapp/module/authentication/login/controller/login_bloc.dart';
import 'package:egovisionapp/module/main/main_controller.dart';
import 'package:egovisionapp/module/order/component/ongoing_order_screen.dart';
import 'package:egovisionapp/utils/hive/hive_adapter.dart';
import 'package:egovisionapp/utils/k_images.dart';
import 'package:egovisionapp/utils/utils.dart';
import 'package:egovisionapp/widget/custom_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CustomDrawer extends StatefulWidget {
  CustomDrawer({super.key, required this.loginBloc});
  LoginBloc loginBloc;
  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  ScrollController _listViewController = ScrollController();
  final _homeController = MainController();

  @override
  Widget build(BuildContext context) {

    var screenWidth = MediaQuery.of(context).size.width;
    final loginBolc = context.read<LoginBloc>();

    return SafeArea(
      child: Drawer(
        backgroundColor: Colors.grey[200],
        width: screenWidth - 110,
        child: ListView(
          controller: _listViewController,
          children: [
            SizedBox(
              height: 200,
              child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.purple[400],
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: Container(
                          height: 100,
                          width: 100,
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
                              child: CustomImage(
                                path: '${RemoteUrls.rootUrl}uploads/customer/${loginBolc.userInfo!.user!.image}',
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      SizedBox(child: Text("${loginBolc.userInfo?.user?.name}",maxLines: 1,overflow: TextOverflow.ellipsis,style: const TextStyle(color: Colors.white),)),
                    ],
                  )),
            ),
            Container(
              color: Colors.transparent,
              margin: const EdgeInsets.only(bottom: 8),
              height: 35,
              child: ListTile(
                leading: const Icon(Icons.home),
                title: const Text("Home"),
                dense: true,
                visualDensity: const VisualDensity(vertical: -4),
                onTap: () {
                  _homeController.naveListener.sink.add(0);
                  Navigator.pop(context);
                },
              ),
            ),
            Container(
              color: Colors.transparent,
              margin: const EdgeInsets.only(bottom: 8),
              height: 35,
              child: ListTile(
                leading: const Icon(Icons.pending_outlined),
                title: const Text("Pending Order"),

                dense: true,
                visualDensity: const VisualDensity(vertical: -4),
                onTap: () {
                  if(widget.loginBloc.userInfo != null){
                    Navigator.pop(context);
                    _homeController.naveListener.sink.add(1);
                  }else{
                    Navigator.pop(context);
                    _homeController.naveListener.sink.add(1);
                    Utils.errorSnackBar(context, "Please login first");
                  }
                },
              ),
            ),
            Container(
              color: Colors.transparent,
              margin: const EdgeInsets.only(bottom: 8),
              height: 35,
              child: ListTile(
                leading: const Icon(Icons.update),
                title: const Text("Ongoing Order"),

                dense: true,
                visualDensity: const VisualDensity(vertical: -4),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(
                      context,
                      RouteNames.orderOnGoingScreen);
                },
              ),
            ),
            Container(
              color: Colors.transparent,
              margin: const EdgeInsets.only(bottom: 8),
              height: 35,
              child: ListTile(
                leading: const Icon(Icons.mark_chat_read),
                title: const Text("Received Order"),

                dense: true,
                visualDensity: const VisualDensity(vertical: -4),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(
                      context,
                      RouteNames.receivedOrderScreen);
                },
              ),
            ),
            Container(
              color: Colors.transparent,
              margin: const EdgeInsets.only(bottom: 8),
              height: 35,
              child: ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text("Canceled Order"),

                dense: true,
                visualDensity: const VisualDensity(vertical: -4),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(
                      context,
                      RouteNames.calcelOrderScreen);
                },
              ),
            ),
            Container(
              color: Colors.transparent,
              margin: const EdgeInsets.only(bottom: 8),
              height: 35,
              child: ListTile(
                leading: const Icon(Icons.all_inbox_outlined),
                title: const Text("All Order"),

                dense: true,
                visualDensity: const VisualDensity(vertical: -4),
                onTap: () {
                  if(widget.loginBloc.userInfo != null){
                    Navigator.pop(context);
                    _homeController.naveListener.sink.add(3);
                  }else{
                    Navigator.pop(context);
                    _homeController.naveListener.sink.add(3);
                    Utils.errorSnackBar(context, "Please login first");
                  }
                },
              ),
            ),
            Container(
              color: Colors.transparent,
              margin: const EdgeInsets.only(bottom: 8),
              height: 35,
              child: ListTile(
                leading: const Icon(Icons.logout),
                title: Text(widget.loginBloc.userInfo == null ? "Login" : "Logout"),
                dense: true,
                visualDensity: const VisualDensity(vertical: -4),
                onTap: () {
                  print('dfskjghskdfg ${widget.loginBloc.userInfo}');
                  if(widget.loginBloc.userInfo == null){
                    Navigator.pop(context);

                    Navigator.popAndPushNamed(context, RouteNames.authenticationScreen);

                  }else{
                    Navigator.pop(context);
                    Hive.box<Product>('product').clear();
                    Utils.loadingDialog(context);
                    context.read<LoginBloc>().add(const LoginEventLogout());
                  }
                  // Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );

  }
}
//
// class CustomDrawer extends StatelessWidget {
//    CustomDrawer({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//
//     return SafeArea(
//       child: Drawer(
//         child: ListView(
//           // Important: Remove any padding from the ListView.
//           padding: EdgeInsets.zero,
//           children: [
//             const DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Colors.blue,
//               ),
//               child: Text('Drawer Header'),
//             ),
//             ListTile(
//               leading: Icon(
//                 Icons.home,
//               ),
//               title: const Text('Page 1'),
//               onTap: () {
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               leading: Icon(
//                 Icons.train,
//               ),
//               title: const Text('Page 2'),
//               onTap: () {
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//
//   }
// }