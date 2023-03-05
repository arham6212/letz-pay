import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:letzpay/services/authentication_service.dart';
import 'package:letzpay/utils/assets_path.dart';
import 'package:letzpay/utils/colors.dart';
import 'package:letzpay/utils/strings.dart';
import 'package:velocity_x/velocity_x.dart';

VSpace(double height) {
  return SizedBox(
    height: height,
  );
}

pagepadding() {
  return EdgeInsets.all(12.0.sp);
}

HSpace(double width) {
  return SizedBox(
    width: width,
  );
}

VSpaceWithBg(double height) {
  return SizedBox(
    height: height,
    child: Container(
      width: 5.w,
      color: red,
    ),
  );
}

imageView(String imagePath, double? height, double? width,
    {BoxFit? boxfitType}) {
  return Image.asset(imagePath, fit: boxfitType, height: height, width: width);
}

welcomeLbl(String title) {
  return Text(
    title,
    style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
  );
}

//Main Text
labelmaintext(String text, {fontsize, FontWeight? fontweight}) {
  return Text(
      textAlign: TextAlign.start,
      maxLines: 1,
      overflow: TextOverflow.visible,
      softWrap: false,
      text,
      style: TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.w700,
        color: Vx.hexToColor(balckMainColor),
      )
      //  style: TextStyle(fontSize: fontsize, color: whiteMedLight),
      );
}

// Sub Text
labelsubtext(String text, {fontsize, FontWeight? fontweight}) {
  return Padding(
      // padding: const EdgeInsets.only(left:150.0),
      padding: EdgeInsets.only(left: 0.0.w),
      child: Text(
        textAlign: TextAlign.start,
        maxLines: 1,
        overflow: TextOverflow.visible,
        softWrap: false,
        text,
        style: TextStyle(
            fontSize: 16.0.sp,
            fontWeight: fontweight,
            color: Vx.hexToColor(greySubTextColor)),
        //  style: TextStyle(fontSize: fontsize, color: whiteMedLight),
      ));
}

edgeSymmetric(double vertical, double horizontal) {
  return EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal);
}

circleButton(String text, bool selected) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      decoration: BoxDecoration(
        color: selected ? buttonColor : lightGreyColor,
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(
              color: selected ? Colors.white : inspireGreyColor,
              fontSize: 14.0),
        ),
      ),
    ),
  );
}

textButton(
  String text, {
  ref,
  color = buttonColor,
  required onPressed,
  required Text child,
}) {
  // print('receivbed color'+buttonColor.toString());
  return ElevatedButton(
    onPressed: () {
      ref.call();
    },
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: buttonStyleSmall(),
      ),
    ),
    style: ElevatedButton.styleFrom(
        primary: color,

        // animationDuration: const Duration(milliseconds: 1000),
        shape: const StadiumBorder()),
  );
}

getBorder() {
  return const OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.grey, width: 0.5),
  );
}

fontStyleHeader({fontsize = 18.0}) {
  return TextStyle(
      fontSize: fontsize, color: inspireGreyColor, fontWeight: FontWeight.w300);
}

fontStyleBasic({fontWt = FontWeight.w300}) {
  return TextStyle(fontSize: 18.0, color: inspireGreyColor, fontWeight: fontWt);
}

fontStyleBasicUnderline({fontWt = FontWeight.w300, fontSize = 18.0}) {
  return TextStyle(
      fontSize: fontSize,
      color: inspireGreyColor,
      decoration: TextDecoration.underline,
      fontWeight: fontWt);
}

fontStyleSmall(
    {color = greyColor,
    fontSize = 14.0,
    TextDecoration = TextDecoration.none,
    fontWeight = FontWeight.w300}) {
  return TextStyle(
      fontSize: fontSize,
      color: color,
      decoration: TextDecoration,
      fontWeight: fontWeight);
}

fontStyleSmallBottomTab(
    {TextDecoration: TextDecoration.none, fontWeight: FontWeight.w300}) {
  return TextStyle(
      fontSize: 18,
      // fontFamily: fontFamily,
      decoration: TextDecoration,
      fontWeight: fontWeight);
}

commonTextStyle(String text, Color text_color, double font_size,
    FontWeight text_font_weight) {
  return Text(
    text,
    style: TextStyle(
      color: text_color,
      // fontFamily: font_family,
      fontSize: font_size,
      fontWeight: text_font_weight,
    ),
  );
}

commonPaddingOnly(double top_padding, double bottom_padding,
    double left_padding, double right_padding) {
  return EdgeInsets.only(
      top: top_padding,
      bottom: bottom_padding,
      left: left_padding,
      right: right_padding);
}

fontStyleMedium() {
  return const TextStyle(
      fontSize: 18.0, color: inspireGreyColor, fontWeight: FontWeight.w500);
}

buttonStyleMedium() {
  return const TextStyle(
      fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.w400);
}

buttonStyleSmall() {
  return const TextStyle(
      fontSize: 12.0, color: Colors.white, fontWeight: FontWeight.w400);
}

fontStyleHeaderBold({fontSize = 18.0, letterSpac = 1.0}) {
  return TextStyle(
      fontSize: fontSize,
      letterSpacing: letterSpac,
      color: inspireGreyColor,
      fontWeight: FontWeight.w700);
}

succesdailog(BuildContext context) {
  Widget cancelButton = Center(
    child: TextButton(
      child: Text(
        okText,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        Navigator.pushReplacementNamed(
          context,
          '/login',
        );
      },
    ),
  );
  AlertDialog alert = AlertDialog(
    title: const Center(
        child: Icon(
      Icons.check_circle_rounded,
      color: Colors.green,
      size: 60,
    )),

    //Text("AlertDialog"),
    content: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(child: Text("Error")),
          ],
        )),
    actions: [
      cancelButton,
      // continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

drawericon(String imagePath) {
  return SvgPicture.asset(imagePath, height: 20.h, width: 20.w);
}

dashboardicon(String imagePath) {
  return SvgPicture.asset(imagePath, height: 28.h, width: 28.w);
}

showPopUpDialog(String titletext, String text, BuildContext context) {
  // // set up the buttons
  // Widget remindButton = TextButton(
  //   child: Text("Remind me later"),
  //   onPressed:  () {},
  // );
  Widget cancelButton = Container(
    padding: EdgeInsets.only(bottom: 10.h),
    child: Column(
      children: [
        popUpButton(context: context, okText, ref: () {
          Navigator.pop(context);
        }, onpressed: null)
      ],
    ),
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Center(
      child: Container(
        width: MediaQuery.of(context).size.width.w,
        height: 50.h,
        decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0))),
        child: Center(
          child: titletext.text.size(16.sp).white.make().p(10.sp),
        ),
      ),
    ),
    titlePadding: const EdgeInsets.all(0),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0))),
    content: Container(
        width: MediaQuery.of(context).size.width.w,
        color: white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
                child: Padding(
              padding: EdgeInsets.only(top: 10.0.h),
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        text,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ],
                  )),
            )),
          ],
        )),
    actions: [
      Center(child: cancelButton),
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showToastMsg(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0.sp);
}

// ignore: non_constant_identifier_names
textFormField({
  required String HintText,
}) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: TextFormField(
      keyboardType: TextInputType.number,
      style: TextStyle(
        fontSize: 15.sp,
        color: white,
      ),
      decoration: InputDecoration(
        hintText: HintText,
        hintStyle: TextStyle(color: greyColor, fontSize: 15.0.sp),
        prefixIcon: Padding(
          padding: EdgeInsets.only(bottom: 8.0.h),
          child: SizedBox(
            child: Center(
              widthFactor: 0.0.w,
              child: Text(
                '+91 -',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Text txt = Text("+91 -");
Text vline = Text(
  "|",
  style: TextStyle(color: Colors.red[800], fontWeight: FontWeight.bold),
);
getValueFromvtxt() {
  var value1 = vline.data;
}

getValueFromtxt() {
  var value = txt.data;
}

//String string = "|";
textFormFieldLogin({
  //required String HintText,
  required String labelText,
  required TextEditingController controller,
  final String? Function(String?)? validator,
  required Null Function(dynamic value) onChanged,
  required TextInputType keyboardType,
  final String? Function(String?)? sufixfunction,
  final List<TextInputFormatter>? inputFormatters,
  final bool? readOnly,
  final Widget? suffixIcon,
}) {
  return Padding(
    padding: EdgeInsets.only(
        top: 10.0.sp, left: 00.0.sp, right: 0.0.sp, bottom: 0.0.sp),
    child: TextFormField(
      maxLines: 1,
      validator: validator,
      controller: controller,
      obscureText: false,
      readOnly: readOnly!,
      keyboardType: keyboardType,
      style: TextStyle(
          fontSize: 16.sp,
          color: Vx.hexToColor(balckMainColor),
          fontWeight: FontWeight.bold),
      cursorColor: Colors.black,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        // hintText: HintText,
        labelText: labelText,
        // border: InputBorder.greyColor,
        // focusedBorder: InputBorder.none,
        // enabledBorder: InputBorder.none,
        // errorBorder: InputBorder.none,
        // disabledBorder: InputBorder.none,
        //  contentPadding: EdgeInsets.symmetric(horizontal: 0),
//not able to Add vx color in hinttext
        labelStyle: TextStyle(
            color: greyColor, fontSize: 18.0.sp, fontWeight: FontWeight.w400),
        suffixIcon: suffixIcon,
        prefixIcon: SizedBox(
          child: Center(
            widthFactor: 0.0.w,
            child: SvgPicture.asset(phoneIcon),
            //imageView(phoneIcon, 40, 40),
          ),
        ),
      ),
    ),
  );
}

//This backbutton is for only ios
backButtonwhite(BuildContext context) {
  if (Platform.isIOS) {
    Image.asset(whiteArrow);
  } else {}
}

customtextfeildreadonly({
  final List<TextInputFormatter>? inputFormatters,
  required final TextEditingController Controller,
  final String? Function(String?)? validator,
  String? helperText,
  TextInputType? keyboardType,
  String? errorText,
  void Function(dynamic text)? onChanged,
  AutovalidateMode? autovalidateMode,
  GlobalKey<FormFieldState>? key,
  Null Function(String value)? onSaved,
  TextInputAction? textInputAction,
  FocusNode? focusNode,
  String? labelText,
}) {
  return Container(
    padding: const EdgeInsets.only(
      left: 15,
      right: 15,
    ),
    // margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
    child: TextFormField(
      // obscureText: true,
      // enableInteractiveSelection: true,
      validator: validator,
      autocorrect: true,
      enabled: false,
      readOnly: true,
      enableSuggestions: false,
      controller: Controller,

      toolbarOptions: ToolbarOptions(
        copy: false,
        paste: false,
        cut: false,
        selectAll: false,
      ),
      //  autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      cursorColor: Colors.black,
      //  validator: validator,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        /* border: OutlineInputBorder(
          borderSide: const BorderSide(color: greyColor, width: 1.0),
          borderRadius: BorderRadius.circular(15),
        ), */
        errorText: errorText,
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.0),
          borderRadius: BorderRadius.circular(15),
        ),
        focusColor: Colors.black,
        //focusedBorder:

        helperText: helperText,
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.black),
      ),
    ),
  );
}

customtextfeild({
  final List<TextInputFormatter>? inputFormatters,
  required final TextEditingController Controller,
  final String? Function(String?)? validator,
  String? helperText,
  TextInputType? keyboardType,
  String? errorText,
  void Function(dynamic text)? onChanged,
  AutovalidateMode? autovalidateMode,
  GlobalKey<FormFieldState>? key,
  Null Function(String value)? onSaved,
  TextInputAction? textInputAction,
  FocusNode? focusNode,
  String? labelText,
  String? HintText,
}) {
  return Container(
    padding: const EdgeInsets.only(
      left: 15,
      right: 15,
    ),
    // margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
    child: TextFormField(
      // obscureText: true,
      // enableInteractiveSelection: true,
      validator: validator,
      autocorrect: true,

      enableSuggestions: false,
      controller: Controller,
      toolbarOptions: ToolbarOptions(
        copy: false,
        paste: false,
        cut: false,
        selectAll: false,
      ),
      //  autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,

      cursorColor: Colors.black,

      //  validator: validator,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        /* border: OutlineInputBorder(
          borderSide: const BorderSide(color: greyColor, width: 1.0),
          borderRadius: BorderRadius.circular(15),
        ), */
        errorText: errorText,

        // errorBorder: OutlineInputBorder(
        //   borderSide: BorderSide(color: Colors.red, width: 1.0),
        //   borderRadius: BorderRadius.circular(15),
        // ),
        focusColor: Colors.black,
        //focusedBorder:
        hintText: HintText,
        helperText: helperText,
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.black),
      ),
    ),
  );
}

customtextfeildInvoice({
  final List<TextInputFormatter>? inputFormatters,
  required final TextEditingController Controller,
  final String? Function(String?)? validator,
  String? helperText,
  TextInputType? keyboardType,
  String? errorText,
  void Function(dynamic text)? onChanged,
  AutovalidateMode? autovalidateMode,
  GlobalKey<FormFieldState>? key,
  Null Function(String value)? onSaved,
  TextInputAction? textInputAction,
  FocusNode? focusNode,
  String? labelText,
  String? HintText,
}) {
  return Container(
    padding: const EdgeInsets.only(
      left: 15,
      right: 15,
    ),
    // margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
    child: TextFormField(
      // obscureText: true,
      // enableInteractiveSelection: true,
      validator: validator,
      autocorrect: true,

      enableSuggestions: false,
      controller: Controller,
      toolbarOptions: const ToolbarOptions(
        copy: false,
        paste: false,
        cut: false,
        selectAll: false,
      ),
      //  autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,

      cursorColor: Colors.black,
      decoration: InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        hintText: HintText,
      ),
      //  validator: validator,
    ),
  );
}

cupertinotextfeild() {
  TextEditingController phoneController = TextEditingController();
  return Container(
    child: CupertinoTextField(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      controller: phoneController,
      clearButtonMode: OverlayVisibilityMode.editing,
      keyboardType: TextInputType.phone,
      maxLines: 1,
      placeholder: '+91...',
    ),
  );
}

Widget nameTextFeild({required Icon prefixIcon}) {
  return TextFormField(
    decoration: InputDecoration(
      border: OutlineInputBorder(
          borderSide: BorderSide(color: Vx.hexToColor(darkblue), width: 2)),
      prefixIcon: prefixIcon,
    ),
  );
}

exitWarningPopUp(context) async {
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(rYouSureLbl),
      content: Text(wantExitLbl),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(noLbl),
        ),
        TextButton(
          onPressed: () => {
            if (Platform.isAndroid)
              {SystemNavigator.pop()}
            else if (Platform.isIOS)
              {exit(0)}
          },
          child: Text(yesLbl),
        ),
      ],
    ),
  );
}

drawerLbl(String title) {
  return Text(
    title,
    style: TextStyle(
        fontSize: 14.0.sp,
        fontWeight: FontWeight.w700,
        color: Vx.hexToColor(balckMainColor)),
  );
}

signInButton(String text, {context, ref, required onpressed}) {
  return Center(
    child: Container(
      height: 48.h,
      width: 335.w,
      //  width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Vx.hexToColor(balckMainColor),
        borderRadius: BorderRadius.all(
          Radius.circular(4.0.w),
        ),
      ),
      child: MaterialButton(
        minWidth: double.infinity,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: const StadiumBorder(),
        child: Center(
          child: text.text.size(14.sp).bold.color(white).make(),
        ),
        onPressed: () {
          ref.call();
        },
      ),
    ),
  );
}

showPopUpDialogClose(String titletext, String text, BuildContext context,
    {refYes, refNo}) {
  // // set up the buttons
  // Widget remindButton = TextButton(
  //   child: Text("Remind me later"),
  //   onPressed:  () {},
  // );
  Widget yesButton = Container(
    padding: EdgeInsets.only(bottom: 10.h),
    child: Column(
      children: [
        popUpButton(context: context, yesLbl, ref: () {
          refYes.call();
          // if (Platform.isAndroid) {
          //   AuthenticationProvider.of(context).logout();
          // } else if (Platform.isIOS) {
          //   exit(0);
          // }
        }, onpressed: null)
      ],
    ),
  );

  Widget noButton = Container(
    padding: EdgeInsets.only(bottom: 10.h),
    child: Column(
      children: [
        popUpButton(context: context, noLbl, ref: () {
          refNo.call();

          // Navigator.of(context).pop(false);
        }, onpressed: null)
      ],
    ),
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Center(
      child: Container(
        width: MediaQuery.of(context).size.width.w,
        height: 50.h,
        decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0))),
        child: Center(
          child: titletext.text
              .size(16.sp)
              .fontWeight(FontWeight.w700)
              .white
              .make()
              .p(10.sp),
        ),
      ),
    ),
    titlePadding: const EdgeInsets.all(0),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0))),
    content: Container(
        width: MediaQuery.of(context).size.width.w,
        color: white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
                child: Padding(
              padding: EdgeInsets.only(top: 10.0.h),
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        text,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ],
                  )),
            )),
          ],
        )),
    actions: [
      Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [noButton, HSpace(10.0.w), yesButton],
      )),
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showPopUpDialogExit(String titletext, String text, BuildContext context) {
  // // set up the buttons
  // Widget remindButton = TextButton(
  //   child: Text("Remind me later"),
  //   onPressed:  () {},
  // );
  Widget cancelButton = Container(
    padding: EdgeInsets.only(bottom: 10.h),
    child: Column(
      children: [
        popUpButton(context: context, yesLbl, ref: () {
          if (Platform.isAndroid) {
            SystemNavigator.pop();
          } else if (Platform.isIOS) {
            exit(0);
          }
        }, onpressed: null)
      ],
    ),
  );

  Widget okButton = Container(
    padding: EdgeInsets.only(bottom: 10.h),
    child: Column(
      children: [
        popUpButton(context: context, noLbl, ref: () {
          Navigator.of(context).pop(false);
        }, onpressed: null)
      ],
    ),
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Center(
      child: Container(
        width: MediaQuery.of(context).size.width.w,
        height: 50.h,
        decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0))),
        child: Center(
          child: titletext.text
              .size(16.sp)
              .fontWeight(FontWeight.w700)
              .white
              .make()
              .p(10.sp),
        ),
      ),
    ),
    titlePadding: const EdgeInsets.all(0),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0))),
    content: Container(
        width: MediaQuery.of(context).size.width.w,
        color: white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
                child: Padding(
              padding: EdgeInsets.only(top: 10.0.h),
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        text,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ],
                  )),
            )),
          ],
        )),
    actions: [
      Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [cancelButton, HSpace(10.0.w), okButton],
      )),
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

popUpButton(String text, {context, ref, required onpressed}) {
  return Center(
    child: Container(
      height: 48.h,
      width: 100.w,
      //  width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Vx.hexToColor(balckMainColor),
        borderRadius: BorderRadius.all(
          Radius.circular(4.0.w),
        ),
      ),
      child: MaterialButton(
        // minWidth: double.infinity,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: const StadiumBorder(),
        child: Center(
          child: text.text.size(14.sp).bold.color(white).make(),
        ),
        onPressed: () {
          ref.call();
        },
      ),
    ),
  );
}

ReportButton(String text, {context, ref, required onpressed}) {
  return Center(
    child: Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Vx.hexToColor(balckMainColor),
        borderRadius: const BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      child: MaterialButton(
        minWidth: double.infinity,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: const StadiumBorder(),
        child: Center(
          child: text.text
              .size(15)
              .color(Vx.hexToColor(balckMainColor))
              .bold
              .make(),
        ),
        onPressed: () {
          ref.call();
        },
      ),
    ),
  );
}

//Confirmation button
confirmation(String text, {context, ref, required onpressed}) {
  return Center(
    child: Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Vx.hexToColor(whiteMainColor),
        borderRadius: const BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      child: MaterialButton(
        minWidth: double.infinity,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: const StadiumBorder(),
        child: Center(
          child: text.text
              .size(15)
              .color(Vx.hexToColor(balckMainColor))
              .bold
              .make(),
        ),
        onPressed: () {
          ref.call();
        },
      ),
    ),
  );
}

formbutton(
  String text, {
  context,
  ref,
  required onpressed,
  // required Text Child,
}) {
  return Center(
      child: Container(
    width: MediaQuery.of(context).size.width - 180,
    padding: EdgeInsets.symmetric(vertical: 8),
    decoration: const ShapeDecoration(
      shape: StadiumBorder(),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color.fromARGB(255, 20, 73, 117),
          Color.fromARGB(255, 13, 10, 106),
          Color.fromARGB(255, 15, 9, 74)
        ],
      ),
    ),
    child: MaterialButton(
      minWidth: double.infinity,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: const StadiumBorder(),
      child: Center(
        child: text.text.size(15).color(white).make(),
      ),
      onPressed: () {
        ref.call();
      },
    ),
  ));
}

resendbutton(
  String text, {
  ref,
  required onpressed,
  // required Text Child,
}) {
  return Center(
    child: Container(
      height: 48.h,
      width: 220.w,
      //  width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Vx.hexToColor(balckMainColor),
        borderRadius: BorderRadius.all(
          Radius.circular(4.0.w),
        ),
      ),
      child: MaterialButton(
        minWidth: double.infinity,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: const StadiumBorder(),
        child: Center(
          child: text.text.size(14.sp).bold.color(white).make(),
        ),
        onPressed: () {
          ref.call();
        },
      ),
    ),
  );
}

getbutton(
  String text, {
  ref,
  required onpressed,
  // required Text Child,
}) {
  return Center(
    child: Container(
      height: 48.h,
      width: 120.w,
      //  width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Vx.hexToColor(balckMainColor),
        borderRadius: BorderRadius.all(
          Radius.circular(4.0.w),
        ),
      ),
      child: MaterialButton(
        minWidth: double.infinity,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: const StadiumBorder(),
        child: Center(
          child: text.text.size(10.sp).bold.color(white).make(),
        ),
        onPressed: () {
          ref.call();
        },
      ),
    ),
  );
}

void showLsearchPopUp(BuildContext context, String mainText, List listType,
    {required Function() typeFunction}) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    // shape: RoundedRectangleBorder(
    //   borderRadius: BorderRadius.only(
    //     topLeft: Radius.circular(25),
    //     topRight: Radius.circular(25),
    //   ),
    // ),
    builder: (context) => Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Positioned(
          top: -400.h,
          bottom: 0,
          //  right: 12.w,
          child: CircleAvatar(
            radius: 26.sp,
            backgroundColor: flashbarcolor,
            child: IconButton(
              icon: const Icon(
                Icons.close_outlined,
                size: 32,
                color: white,
              ),
              //SvgPicture.asset(closeIcon),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.4,
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: commonPaddingOnly(40, 10, 15, 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: commonTextStyle(mainText,
                            Vx.hexToColor(blackColor), 22, FontWeight.w500),
                      ),
                      Divider(),
                      VSpace(10.h),
                      ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          // physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: listType.length,
                          itemBuilder: (
                            BuildContext context,
                            int index,
                          ) {
                            return InkWell(
                              onTap: typeFunction,
                              child: Container(
                                margin: EdgeInsets.all(10.sp),
                                height: 30.h,
                                padding: EdgeInsets.only(bottom: 10.h),
                                color: white,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      listType[index],
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18.0.sp),
                                    ),
                                    const Icon(
                                      Icons.arrow_back_ios_rounded,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
