import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:letzpay/environment/environment.dart';
import 'package:letzpay/module/login/login_page/login.dart';

import 'package:letzpay/services/authentication_service.dart';

import 'package:letzpay/services/navigator.dart';
import 'package:letzpay/services/network_services.dart';

import 'package:letzpay/utils/assets_path.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:letzpay/utils/strings.dart';
import 'package:letzpay/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;
Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.black));

  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: Environment.fileName);
  setupLocator();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));
  // runApp(MyApp());
}

void setupLocator() {
  GetIt.instance
      .registerLazySingleton<NavigationService>(() => NavigationService());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) {
        return MultiProvider(
          providers: [
            StreamProvider(
                create: (context) => NetworkService().controller.stream,
                initialData: NetworkStatus.online)
          ],
          child: AuthenticationProvider(
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: appName,
              themeMode: ThemeMode.light,
              theme: MyTheme.lightTheme(context),
              darkTheme: MyTheme.darkTheme(context),
              navigatorKey: locator<NavigationService>().navigatorKey,
              initialRoute: "/",
              // home: SplashScreen(
              //   imageBackground: const AssetImage(splashScreenImage),
              //   seconds: 3,
              //   navigateAfterSeconds: LoginPage(),
              //   useLoader: false,
              // ),
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: child!,
                );
              },

              onGenerateRoute: RouteGenerator.generateRoute,
              // home: LoginPage(),
            ),
          ),
        );
      },
      designSize: Size(375, 812),
    );
  }
}
