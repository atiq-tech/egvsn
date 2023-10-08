import 'package:egovisionapp/module/animated_splash/animated_splash_screen.dart';
import 'package:egovisionapp/module/authentication/authentication_screen.dart';
import 'package:egovisionapp/module/authentication/login/login_screen.dart';
import 'package:egovisionapp/module/authentication/registration/component/otp_verify.dart';
import 'package:egovisionapp/module/authentication/registration/registration_screen.dart';
import 'package:egovisionapp/module/main/main_screen.dart';
import 'package:egovisionapp/module/order/checkout_screen.dart';
import 'package:egovisionapp/module/order/component/cancel_order_screen.dart';
import 'package:egovisionapp/module/order/component/ongoing_order_screen.dart';
import 'package:egovisionapp/module/order/component/received_order_screen.dart';
import 'package:egovisionapp/module/order_details/component/order_update.dart';
import 'package:egovisionapp/module/order_details/component/update_order_checkout.dart';
import 'package:egovisionapp/module/order_details/order_details.dart';
import 'package:egovisionapp/module/products/model/product_model.dart';
import 'package:egovisionapp/module/products/product_details_screen.dart';
import 'package:egovisionapp/module/products/products_screen.dart';
import 'package:flutter/material.dart';

class RouteNames {
  static const String animatedSplashScreen = '/';
  static const String mainPage = '/mainPage';

  static const String authenticationScreen = '/authenticationScreen';
  static const String productScreen = '/productScreen';
  static const String productDetailsScreen = '/productDetailsScreen';
  static const String otpVerifyScreen = '/otpVerifyScreen';
  static const String orderScreen = '/orderScreen';
  static const String orderUpdateScreen = '/orderUpdateScreen';
  static const String orderUpdate = '/orderUpdate';
  static const String orderDetailsScreen = '/orderDetailsScreen';
  static const String orderOnGoingScreen = '/orderOnGoingScreen';
  static const String receivedOrderScreen = '/receivedOrderScreen';
  static const String calcelOrderScreen = '/calcelOrderScreen';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.animatedSplashScreen:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const AnimatedSplashScreen());

      case RouteNames.mainPage:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const MainScreen());

      case RouteNames.productScreen:
        final event = settings.arguments as ProductsScreenArguments;
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => ProductsScreen(
                  typeId: event.typeId,
                  categoryId: event.categoryId,
                  brandId: event.brandId,
                  colorId: event.colorId,
                ));

      case RouteNames.authenticationScreen:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const AuthenticationScreen());

        case RouteNames.otpVerifyScreen:
          final event = settings.arguments as OtpVerifyScreenArguments;
          return MaterialPageRoute(
            settings: settings, builder: (_) => OtpVerifyScreen(
            emailOrPhone: event.email, userId: event.userId,
          ));

      case RouteNames.productDetailsScreen:
        final event = settings.arguments as ProductModel;
        return MaterialPageRoute(
            settings: settings, builder: (_) => ProductDetails(
          productModel: event,
        ));

      case RouteNames.orderScreen:
        final event = settings.arguments as int;
        return MaterialPageRoute(
            settings: settings, builder: (_) => OrderScreen(
          grandTotal: event,
        ));
      case RouteNames.orderUpdateScreen:
        final event = settings.arguments as UpdateOrderScreenArguments;
        return MaterialPageRoute(
            settings: settings, builder: (_) => UpdateOrderScreen(
          grandTotal: event.grandTotal,
          orderId: event.orderId,
        ));
      case RouteNames.orderUpdate:
        final event = settings.arguments as String;
        return MaterialPageRoute(
            settings: settings, builder: (_) => OrderUpdate(
            id: event,
        ));

        case RouteNames.orderDetailsScreen:
        final event = settings.arguments as OrderDetailsScreenArguments;
        return MaterialPageRoute(
            settings: settings, builder: (_) => OrderDetailsScreen(
          id: event.id,
          orderModel: event.orderModel,
          index: event.index,
          userLoginResponseModel: event.userLoginResponseModel,
        ));
        case RouteNames.orderOnGoingScreen:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const OngoingOrderScreen());
        case RouteNames.receivedOrderScreen:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const ReceivedOrderScreen());
        case RouteNames.calcelOrderScreen:
                return MaterialPageRoute(
                    settings: settings, builder: (_) => const CancelOrderScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
