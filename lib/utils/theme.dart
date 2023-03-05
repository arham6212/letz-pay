import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:letzpay/utils/colors.dart';
import 'package:velocity_x/velocity_x.dart';

class MyTheme {
  static ThemeData lightTheme(BuildContext context) => ThemeData(
      buttonTheme: const ButtonThemeData(
        buttonColor: buttonColor,
        textTheme: ButtonTextTheme.primary,
      ),
      iconTheme: const IconThemeData(
        color: black,
      ),
      fontFamily: 'Times New Roman Font',
      // canvasColor: white,
      // fontFamily: GoogleFonts.lato().fontFamily,
      // fontFamily: 'Hero',
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Vx.hexToColor(balckMainColor),
        elevation: 0.0,
        iconTheme: const IconThemeData(color: white),
        foregroundColor: white,
        // toolbarTextStyle: Theme.of(context).textTheme.bodyText2,
        // titleTextStyle: Theme.of(context).textTheme.headline6
      ));

  static ThemeData darkTheme(BuildContext context) => ThemeData(
      brightness: Brightness.dark,
      buttonTheme: const ButtonThemeData(
        buttonColor: buttonColor,
        textTheme: ButtonTextTheme.primary,
      ),
      iconTheme: const IconThemeData(
        color: black,
      ),
      canvasColor: Colors.white,
      // fontFamily: GoogleFonts.lato().fontFamily,
      appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          // backgroundColor: Vx.hexToColor(balckMainColor),
          elevation: 0.0,
          iconTheme: const IconThemeData(color: white),
          foregroundColor: white,
          toolbarTextStyle: Theme.of(context).textTheme.bodyText2,
          titleTextStyle: Theme.of(context).textTheme.headline6));
}
