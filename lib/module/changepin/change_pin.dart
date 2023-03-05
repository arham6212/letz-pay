import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:letzpay/common_components/common_widget.dart';
import 'package:letzpay/common_components/home_app_bar.dart';
import 'package:letzpay/module/changepin/new_pin.dart';
import 'package:letzpay/services/network/api_services.dart';
import 'package:letzpay/utils/assets_path.dart';
import 'package:letzpay/utils/colors.dart';
import 'package:letzpay/utils/strings.dart';
import 'package:pinput/pinput.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../services/shared_pref.dart';

class ChangePin extends StatefulWidget {
  const ChangePin({
    Key? key,
  }) : super(key: key);

  @override
  State<ChangePin> createState() => _ChangePinState();
}

class _ChangePinState extends State<ChangePin> {
  late ApiService apiService;
  @override
  void initState() {
    super.initState();
    apiService = ApiService();
  }

  @override
  void setState(fn) {
    //this method is call for avoid memory leak issue.
    if (mounted) {
      super.setState(fn);
    }
  }

  Future validatePIN(var context, String value) async {
    Response response;
    try {
      var params = {
        "MOBILE_NUMBER": await getStringVal("mobileNumber"),
        "PIN": value
      };
      response = await apiService.validatePIN(
        context,
        params,
      ); //API call for validate pin

      if (response.statusCode == 200) {
        if (response.data['RESPONSE_CODE'] == '000') {
          // saveKeyValString("mobileNumber", mobileNo);
          // saveKeyValString("pinOrOtp", value);
          Navigator.of(context).pushReplacementNamed('/newpin',
              arguments: {"oldPin": _pinPutController.text});
          // showPopUpDialog(
          //     errorpop, response.data['RESPONSE_MESSAGE'].toString(), context);
          // showToastMsg(response.data['RESPONSE_MESSAGE'].toString());
        } else {
          setState(() {
            _pinPutController.clear();
            showPopUpDialog(errorpop,
                response.data['RESPONSE_MESSAGE'].toString(), context);
            // showToastMsg(response.data['RESPONSE_MESSAGE'].toString());
          });
          // print(response.data['RESPONSE_MESSAGE'].toString());
        }
      } else {
        _pinPutController.clear();
        showPopUpDialog(errorpop, errorSomeWrong, context);
        // showToastMsg("error found");
      }
    } on Exception catch (e) {
      _pinPutController.clear();
      showPopUpDialog(errorpop, e.toString(), context);
      //  showToastMsg(e.toString());
    }
  }

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
        fontSize: 20.0,
        color: Vx.hexToColor(whiteMainColor),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      color: inspireGreyColor,
      border: Border.all(color: inspireGreyColor),
      borderRadius: BorderRadius.circular(5),
    ),
  );
  final TextEditingController _pinPutController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const focusedBorderColor = Colors.white;

    // String mobileNo = widget.mobileNumber;
    // print(mobileNo);
    return Scaffold(
      resizeToAvoidBottomInset: true,

      backgroundColor: Vx.hexToColor(balckMainColor),
      // appBar: buildHomeAppBar(
      //   title: "".text.color(white).make(),
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            margin: EdgeInsets.only(right: 10.0.h, left: 10.0.h, top: 20.h),
            padding: EdgeInsets.only(top: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 12.h),
                  child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Image.asset(whiteArrow)),
                ),
                VSpace(50.0),
                Container(
                  padding: EdgeInsets.all(20.h),
                  child: oldPint.text
                      .color(Vx.hexToColor(whiteMainColor))
                      .size(20.0)
                      .make(),
                ),
                VSpace(50),
                Container(
                  padding: EdgeInsets.all(20.h),
                  child: Center(
                    child: Pinput(
                        //autofocus: true,
                        obscureText: true,
                        errorText: enterPinError,
                        length: 6,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r"\d+([\.]\d+)?")),
                        ],
                        onCompleted: (value) {
                          // validatePIN(context, value);
                          //showToastMsg("nextpage");
                        },
                        focusedPinTheme: defaultPinTheme.copyWith(
                          decoration: defaultPinTheme.decoration!.copyWith(
                            borderRadius: BorderRadius.circular(5),
                            // color: Vx.hexToColor(greySubTextColor),
                            border:
                                Border.all(width: 2, color: focusedBorderColor),
                          ),
                        ),
                        submittedPinTheme: defaultPinTheme.copyWith(
                          decoration: defaultPinTheme.decoration!.copyWith(
                            color: inspireGreyColor,
                            // borderRadius: BorderRadius.circular(19),
                            // border: Border.all(color: focusedBorderColor),
                          ),
                        ),
                        defaultPinTheme: defaultPinTheme,
                        controller: _pinPutController,
                        pinAnimationType: PinAnimationType.fade,
                        onSubmitted: (pin) {
                          //  showToastMsg(pin);
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //     SnackBar(content: Text(pin.toString())));
                        }),
                  ),
                ),
                VSpace(40),
                Container(
                  padding: EdgeInsets.all(20.h),
                  child: RichText(
                    text: TextSpan(
                        text: pinCriteria,
                        style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: 'Times New Roman Font',
                            fontWeight: FontWeight.bold,
                            color: Vx.hexToColor(whiteMainColor)),
                        children: <TextSpan>[
                          TextSpan(
                              text: pinStatment,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Times New Roman Font',
                                color: Vx.hexToColor(greySubTextColor),
                                fontSize: 18.0,
                              )),
                        ]),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20.h),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child:
                        confirmation(context: context, continueButton, ref: () {
                      {
                        validatePIN(context, _pinPutController.text.toString());
                      }
                    }, onpressed: null),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
