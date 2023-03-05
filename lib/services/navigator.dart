import 'package:flutter/material.dart';
import 'package:letzpay/module/SpashScreen/splashScreen.dart';
import 'package:letzpay/module/t&c/privacy_policy.dart';

import 'package:letzpay/module/t&c/term_condition.dart';
import 'package:letzpay/module/invoicepage/search_model/invoice_search.dart';
import 'package:letzpay/module/payment_form/form_page.dart';
import 'package:letzpay/module/analytics/report_chart_page/report.dart';
import 'package:letzpay/module/payment_form/qr_payment_dailouge/qrcode_modal/qr_page.dart';
import 'package:letzpay/module/analytics/report_chart_page/salescapture.dart';
import 'package:letzpay/module/payment_form/qr_payment_dailouge/qrcode_modal/qrcode_pg_view.dart';
import 'package:letzpay/module/payment_form/qr_payment_dailouge/qrcode_modal/qrcode_upi_view.dart';
import 'package:letzpay/module/invoicepage/search_model/search_transaction.dart';

import 'package:letzpay/module/history/transaction_detail_page/status_transaction.dart';

import 'package:letzpay/module/changepin/change_pin.dart';
import 'package:letzpay/module/changepin/new_pin.dart';
import 'package:letzpay/module/login/pin&otp_modal/confirmpage.dart';
import 'package:letzpay/module/login/pin&otp_modal/otp_enter.dart';
import 'package:letzpay/module/login/pin&otp_modal/otp_view.dart';

import 'package:letzpay/module/login/pin&otp_modal/reset_pin.dart';

import 'package:letzpay/module/loignhistory/log_history_page/log_histort_list.dart';
import 'package:letzpay/module/profile/profile_modal/profile_page.dart';

import 'package:velocity_x/velocity_x.dart';
import 'package:letzpay/module/homepage/home_page/dashboard_page.dart';
import 'package:letzpay/common_components/loading_screen.dart';
import 'package:letzpay/module/login/login_page/login.dart';
import 'package:letzpay/services/auth_guard.dart';
import 'package:letzpay/services/authentication_service.dart';
import 'package:letzpay/services/shared_pref.dart';
import 'package:letzpay/utils/strings.dart';

import '../module/login/pin&otp_modal/forget_pin.dart';
import '../module/history/transaction_history_new/transaction_history_new.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // final args = settings.arguments;
    var moduleType = getStringVal(moduleTypeSharedPrefKey);

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => AuthGuard(
                child: FHomePage(),
                loadingScreen: LoadingScreen(),
                unauthenticatedHandler: (BuildContext context) =>
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/SplashScreen', (route) => false),
                authenticationStream: AuthenticationProvider.of(_).user().map(
                    (user) => user.isEmptyOrNull
                        ? AuthGuardStatus.notAuthenticated
                        : AuthGuardStatus.authenticated)));

      case '/fhome':
        return _GoToPage(settings, FHomePage());

      case '/login':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/SplashScreen':
        return MaterialPageRoute(builder: (_) => const SplashScreenVieW());
      case '/privacyPolicy':
        return MaterialPageRoute(builder: (_) => privacyPolicyView());
      case '/termNdCondition':
        return MaterialPageRoute(builder: (_) => termView());
      case '/allpage':
        final args = settings.arguments as Map;
        return _GoToPage(settings, AllPage(title: args["title"]));
      case '/qrcode':
        final args = settings.arguments as Map;
        return _GoToPage(settings, QrCodePage(qr_code: args["qr_code"]));
      case '/profilescreen':
        return _GoToPage(settings, ProfileScreen());
      case '/loginhistory':
        return _GoToPage(settings, LogHistoryPage());
      // case '/ChangePin':
      //   return _GoToPage(settings, ChangePin());

      case '/Invoicsearch':
        return _GoToPage(settings, InvoiceSearch());
      case '/Searchtransaction':
        return _GoToPage(settings, SearchTranscation());
      case '/Salecapture':
        return _GoToPage(settings, SaleCapture());
      case '/Reportview':
        return _GoToPage(settings, ReportView());

      case '/Upicode':
        return _GoToPage(settings, UPICode());
      case '/Pgcode':
        return _GoToPage(settings, PGCode());
      // case '/newpin':
      //   return _GoToPage(settings, NewPin());
      case '/changepage':
        return _GoToPage(settings, ChangePin());

      // case '/succestrasaction':
      //   return _GoToPage(settings, SuccessTransaction());
      case '/succestrasaction':
        final args = settings.arguments as Map;
        return _GoToPage(
            settings,
            SuccessTransaction(
                invoice: args["invoice"],
                amount: args["amount"],
                mComingFrom: args["mComingFrom"]));

      // case '/succestrasaction':
      //   final args = settings.arguments as Map;
      //   return _GoToPage(
      //       settings,R
      //       SuccessTransaction(
      //           transactionDetail: args["transactionDetail"].toString()));
      case '/newpin':
        final args = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (_) => NewPin(oldPin: args["oldPin"]));
      case '/confirmpage':
        final args = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (_) => ConfirmPage(mobileNumber: args["mobileNo"]));
      // case '/changepage':
      //   return MaterialPageRoute(builder: (_) => ChangePin());
      // case '/otppage':      //otp page is not navigated for  new apk
      //   final args = settings.arguments as Map;
      //   return MaterialPageRoute(
      //       builder: (_) => OTP_View(mobileNumber: args["mobileNo"]));
      case '/resetpin':
        final args = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (_) => ResetPinView(mobileNumber: args["mobileNo"]));
      case '/otpenter':
        final args = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (_) => OTP_Enter(mobileNumber: args["mobileNo"]));
      case '/forgetpin':
        final args = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (_) => Resendpin_View(
                mobileNumber: args["mobileNo"])); //mobile: args["mobileNo"]
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: "Error".text.make(),
        ),
        body: Center(
          child: "Something Went Wrong".text.make(),
        ),
      );
    });
  }

  static _GoToPage(RouteSettings settings, Widget pageName) {
    BuildContext context;
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => AuthGuard(
            child: pageName,
            loadingScreen: LoadingScreen(),
            unauthenticatedHandler: (BuildContext context) =>
                Navigator.of(context).pushReplacementNamed('/login'),
            authenticationStream: AuthenticationProvider.of(context).user().map(
                (user) => user.isEmptyOrNull
                    ? AuthGuardStatus.notAuthenticated
                    : AuthGuardStatus.authenticated)),
        // transitionsBuilder: (context, animation, secondaryAnimation, child) {
        //   const begin = Offset(1.0, 1.0);
        //   const end = Offset.zero;
        //   // const curve = Curves.ease;

        //   var tween = Tween(begin: begin, end: end)
        //       .chain(CurveTween(curve: curveList[39]));

        //   return SlideTransition(
        //     position: animation.drive(tween),
        //     child: child,
        //   );
        // },
        transitionsBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation, Widget child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: Offset(-1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        });

    // MaterialPageRoute(
    //     // settings: settings,
    //     builder: (_) => AuthGuard(
    //         child: pageName,
    //         loadingScreen: LoadingScreen(),
    //         unauthenticatedHandler: (BuildContext context) =>
    //             Navigator.of(context).pushReplacementNamed('/login'),
    //         authenticationStream: AuthenticationProvider.of(_).user().map(
    //             (user) => user.isEmptyOrNull
    //                 ? AuthGuardStatus.notAuthenticated
    //                 : AuthGuardStatus.authenticated)));
  }
}
