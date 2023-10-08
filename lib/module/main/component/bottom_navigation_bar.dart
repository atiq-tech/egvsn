import 'package:egovisionapp/utils/constant.dart';
import 'package:egovisionapp/utils/hive/hive_adapter.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../main_controller.dart';

class MyBottomNavigationBar extends StatelessWidget {
  const MyBottomNavigationBar({
    Key? key,
    required this.mainController,
    required this.selectedIndex,
  }) : super(key: key);
  final MainController mainController;
  final int selectedIndex;
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 9,
      color: const Color(0x00ffffff),
      shadowColor: blackColor,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(0)),
        child: BottomNavigationBar(
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,

          selectedLabelStyle: const TextStyle(fontSize: 14, color: redColor),
          unselectedLabelStyle:
              const TextStyle(fontSize: 14, color: Color(0xff85959E)),
          items: <BottomNavigationBarItem>[

            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined,
                  color: paragraphColor),
              activeIcon: Icon(Icons.home,color: redColor,),
              label: "Home",
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.pending_outlined,
                  color: paragraphColor),
              activeIcon: Icon(Icons.pending,color: redColor,),
              label: "Pending",
            ),

            BottomNavigationBarItem(
              tooltip: "Cart",
              activeIcon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.shopping_cart, color: redColor),
                  Positioned(child: Text('${Hive.box<Product>('product').values.toList().length}',style: const TextStyle(color: Color(
                      0xFFE51C0E)),),right: -8,top: -8,)
                ],
              ),
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.shopping_cart_outlined, color: paragraphColor),
                  Positioned(child: Text('${Hive.box<Product>('product').values.toList().length}',style: const TextStyle(color: Color(0xFFE51C0E)),),right: -8,top: -8,)
                ],
              ),
              label: "Cart",
            ),
            const BottomNavigationBarItem(
              tooltip: "All",
              activeIcon:
              Icon(Icons.all_inbox, color: redColor),
              icon:
              Icon(Icons.all_inbox_outlined, color: paragraphColor),
              label: "All",
            ),

            const BottomNavigationBarItem(
              tooltip: "Profile",
              activeIcon:
              Icon(Icons.person, color: redColor),
              icon:
              Icon(Icons.person_outline, color: paragraphColor),
              label: "Profile",
            ),
          ],
          // type: BottomNavigationBarType.fixed,
          currentIndex: selectedIndex,
          onTap: (int index) {
            print("$index");
            mainController.naveListener.sink.add(index);
          },
        ),
      ),
    );
  }
}
