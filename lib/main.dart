import 'package:egovisionapp/core/data/datasources/local_data_source.dart';
import 'package:egovisionapp/core/data/datasources/remote_data_source.dart';
import 'package:egovisionapp/core/remote_name.dart';
import 'package:egovisionapp/module/animated_splash/controller/app_setting_cubit.dart';
import 'package:egovisionapp/module/animated_splash/repository/app_setting_repository.dart';
import 'package:egovisionapp/module/authentication/login/controller/login_bloc.dart';
import 'package:egovisionapp/module/authentication/registration/controller/reg_bloc.dart';
import 'package:egovisionapp/module/authentication/repository/auth_repository.dart';
import 'package:egovisionapp/module/home/controller/cubit/home_controller_cubit.dart';
import 'package:egovisionapp/module/home/controller/repo/home_repository.dart';
import 'package:egovisionapp/module/order/controller/order_controller_cubit.dart';
import 'package:egovisionapp/module/order/repository/order_repository.dart';
import 'package:egovisionapp/module/order_details/controller/order_details_controller_cubit.dart';
import 'package:egovisionapp/module/products/controller/product_cubit.dart';
import 'package:egovisionapp/module/products/repository/products_repository.dart';
import 'package:egovisionapp/module/profile/controller/profile_cubit.dart';
import 'package:egovisionapp/module/profile/repository/profile_repo.dart';
import 'package:egovisionapp/utils/hive/hive_adapter.dart';
import 'package:egovisionapp/utils/hive/update_product_adapter.dart';
import 'package:egovisionapp/utils/my_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

late final SharedPreferences _sharedPreferences;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(UpdateProductAdapter());
  await Hive.openBox<Product>('product');
  await Hive.openBox<UpdateProduct>('product_update');

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  _sharedPreferences = await SharedPreferences.getInstance();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        ///network client
        RepositoryProvider<Client>(
          create: (context) => Client(),
        ),
        RepositoryProvider<SharedPreferences>(
          create: (context) => _sharedPreferences,
        ),

        ///data source repository
        RepositoryProvider<RemoteDataSource>(
          create: (context) => RemoteDataSourceImpl(client: context.read()),
        ),
        RepositoryProvider<LocalDataSource>(
          create: (context) =>
              LocalDataSourceImpl(sharedPreferences: context.read()),
        ),

        ///Main Functionality
        RepositoryProvider<AuthRepository>(
                  create: (context) => AuthRepositoryImp(
                    remoteDataSource: context.read(),
                    localDataSource: context.read(),
                  ),
                ),
        RepositoryProvider<AppSettingRepository>(
          create: (context) => AppSettingRepositoryImp(
            remoteDataSource: context.read(),
            localDataSource: context.read(),
          ),
        ),
        RepositoryProvider<HomeRepository>(
          create: (context) => HomeRepositoryImp(
            remoteDataSource: context.read()
          ),
        ),
        RepositoryProvider<ProductRepository>(
          create: (context) => ProductRepositoryImp(
            remoteDataSource: context.read()
          ),
        ),
        RepositoryProvider<OrderRepository>(
          create: (context) => OrderRepositoryImp(
            remoteDataSource: context.read()
          ),
        ),
        RepositoryProvider<ProfileRepository>(
          create: (context) => ProfileRepositoryImp(
            remoteDataSource: context.read()
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [

          BlocProvider<AppSettingCubit>(
            create: (BuildContext context) => AppSettingCubit(context.read()),
          ),
          BlocProvider<HomeControllerCubit>(
            create: (BuildContext context) => HomeControllerCubit(
              context.read(),
              // context.read(),
            ),
          ),
          BlocProvider<ProductCubit>(
            create: (BuildContext context) => ProductCubit(context.read()),
          ),
          BlocProvider<LoginBloc>(
            create: (BuildContext context) => LoginBloc(
              authRepository: context.read(),
            ),
          ),
          BlocProvider<RegBloc>(
            create: (BuildContext context) => RegBloc(
              context.read(),
            ),
          ),
          BlocProvider<OrderCubit>(
            create: (BuildContext context) => OrderCubit(
              context.read(),context.read()
            ),
          ),
          // BlocProvider<OrderCubit>(
          //   create: (BuildContext context) => OrderCubit(
          //     context.read(),context.read()
          //   ),
          // ),
          BlocProvider<OrderDetailsCubit>(
            create: (BuildContext context) => OrderDetailsCubit(
              context.read(),context.read()
            ),
          ),
          BlocProvider<ProfileScreenCubit>(
            create: (BuildContext context) => ProfileScreenCubit(
              context.read(),context.read(),context.read()
            ),
          ),
        ],
        child: BlocBuilder<AppSettingCubit, AppSettingState> (
          builder: (context, localeState) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: MyTheme.theme,
              onGenerateRoute: RouteNames.generateRoute,
              initialRoute: RouteNames.animatedSplashScreen,
              onUnknownRoute: (RouteSettings settings) {
                return MaterialPageRoute(
                  builder: (_) => Scaffold(
                    body: Center(
                      child: Text('No route defined for ${settings.name}'),
                    ),
                  ),
                );
              },
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: child!,
                );
              },
            );
          }
        ),
      ),
    );
  }
}