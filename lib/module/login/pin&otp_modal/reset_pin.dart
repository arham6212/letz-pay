import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:letzpay/services/network/api_services.dart';
import 'package:pinput/pinput.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../common_components/common_widget.dart';
import '../../../services/shared_pref.dart';
import '../../../utils/assets_path.dart';
import '../../../utils/colors.dart';
import '../../../utils/strings.dart';

//Forget Pin page
class ResetPinView extends StatefulWidget {
  final String mobileNumber;
  const ResetPinView({Key? key, required this.mobileNumber}) : super(key: key);
  @override
  State<ResetPinView> createState() => _ResetPinViewState();
}

class _ResetPinViewState extends State<ResetPinView> {
  // late Timer _timer;
  // num _start = 59;
  // bool enableResendOTP = false;
  late ApiService apiService;

  late Color focusedBorderColor;
  //String mobileNo = widget.mobileNumber;

  @override
  void initState() {
    apiService = ApiService();
    super.initState();

    // getForgetPin(mobileNo);
  }

//set old PIN to new PIN
  Future getResentPin(
    var context,
    String mobileNo,
  ) async {
    Response response;
    try {
      var params = {
        "MOBILE_NUMBER": mobileNo,
        "NEW_PIN": _pinPutController.text.toString(),
        "CONFIRM_NEW_PIN": _confirmpinController.text.toString(),
      };
      response = await apiService.getResentPin(
          context, params); //API call for update new pin

      if (response.statusCode == 200) {
        if (response.data['RESPONSE_CODE'] == '000') {
          saveKeyValString("mobileNumber", mobileNo); //save in shared pref key
          Navigator.pushNamed(context, '/confirmpage',
              arguments: {"mobileNo": mobileNo});
          // Navigator.of(context).pushNamed('/confirmpage');

          // showToastMsg(response.data['RESPONSE_MESSAGE'].toString());
        } else {
          setState(() {
            _pinPutController.clear();
            _confirmpinController.clear();
            showPopUpDialog(errorpop,
                response.data['RESPONSE_MESSAGE'].toString(), context);
            //  showToastMsg(response.data['RESPONSE_MESSAGE'].toString());
          });

          // print(response.data['RESPONSE_MESSAGE'].toString());
        }
      } else {
        _pinPutController.clear();
        _confirmpinController.clear();
        showPopUpDialog(errorpop, errorSomeWrong, context);
        // showToastMsg("error found");
      }
    } on Exception catch (e) {
      _pinPutController.clear();
      _confirmpinController.clear();
      showPopUpDialog(errorpop, e.toString(), context);
      // showToastMsg(e.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  final defaultPinTheme = PinTheme(
    width: 56.w,
    height: 56.h,
    textStyle: TextStyle(
        fontSize: 20.0.sp,
        color: Vx.hexToColor(balckMainColor),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: Vx.hexToColor(balckMainColor)),
      borderRadius: BorderRadius.circular(5.w),
    ),
  );
  final TextEditingController _pinPutController = TextEditingController();
  final TextEditingController _confirmpinController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    focusedBorderColor = Vx.hexToColor(balckMainColor);
    String mobileNo = widget.mobileNumber;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: (Vx.hexToColor(whiteMainColor)),
      body: SafeArea(
        child: ListView(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                margin: EdgeInsets.all(18.0.sp),
                padding: EdgeInsets.only(top: 10.0.h),
                // width: double.infinity,
                // height: double.infinity,
                // color: Colors.white,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //  VSpace(50.0),
                      InkWell(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/forgetpin',
                                arguments: {"mobileNo": mobileNo});
                          },
                          child: Image.asset(blackArrow)),
                      VSpace(50.0.h),
                      resetPin.text
                          .size(24.sp)
                          .bold
                          .color(Vx.hexToColor(balckMainColor))
                          .make(),
                      VSpace(10.0),
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: newPinStatment,
                            style: TextStyle(
                              color: Vx.hexToColor(greySubTextColor),
                              fontSize: 18.0.sp,
                            ),
                          ),
                          // TextSpan(
                          //   text: mobileNo,
                          //   style: TextStyle(
                          //     color: Vx.hexToColor(whiteMainColor),
                          //     fontSize: 18.0,
                          //   ),
                          //   //style: fontStyleHeaderBold(),
                          // ),
                        ]),
                      ),
                      VSpace(90),
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(
                                10.0,
                              ),
                              child: newPin.text
                                  .size(18.0)
                                  .color(Vx.hexToColor(greySubTextColor))
                                  .make(),
                            ),
                          ),
                          Center(
                            child: Pinput(
                                //  autofillHints: true,
                                autofocus: true,
                                obscureText: true,
                                errorText: enterOtpError,
                                length: 6,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r"\d+([\.]\d+)?")),
                                ],
                                onCompleted: (value) {
                                  {
                                    // getForgetPin(mobileNo);

                                  }
                                }, // navigate through

                                defaultPinTheme: defaultPinTheme,
                                controller: _pinPutController,
                                pinAnimationType: PinAnimationType.fade,
                                onSubmitted: (pin) {
                                  //  showToastMsg(pin);
                                  // ScaffoldMessenger.of(context)
                                  //     .showSnackBar(SnackBar(content: Text(pin.toString())));
                                }),
                          ),

                          //confirmation pin
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(
                                10.0,
                              ),
                              child: confirmPin.text
                                  .size(20.0)
                                  .color(Vx.hexToColor(greySubTextColor))
                                  .make(),
                            ),
                          ),
                          Column(
                            children: [
                              Pinput(
                                  autofocus: true,
                                  obscureText: true,
                                  errorText: enterPinError,
                                  length: 6,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r"\d+([\.]\d+)?")),
                                  ],
                                  onCompleted: (value) {
                                    //  showToastMsg("nextpage");
                                  },
                                  defaultPinTheme: defaultPinTheme,
                                  focusedPinTheme: defaultPinTheme.copyWith(
                                    decoration:
                                        defaultPinTheme.decoration!.copyWith(
                                      borderRadius: BorderRadius.circular(5),
                                      // color: Vx.hexToColor(greySubTextColor),
                                      border: Border.all(
                                          width: 2, color: focusedBorderColor),
                                    ),
                                  ),
                                  controller: _confirmpinController,
                                  pinAnimationType: PinAnimationType.fade,
                                  onSubmitted: (pin) {
                                    //showToastMsg(pin);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(pin.toString())));
                                  }),
                            ],
                          ),
                        ],
                      ),

                      //NEW PIN

                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: signInButton(context: context, confirmNP,
                              ref: () {
                            if (_pinPutController.text.isEmptyOrNull &&
                                _confirmpinController.text.isEmptyOrNull) {
                              showPopUpDialog(errorpop, emptyParam, context);
                            } else if (_pinPutController !=
                                _confirmpinController) {
                              getResentPin(
                                context,
                                mobileNo,
                              );
                            } else {
                              showPopUpDialog(
                                  errorpop, errorSomeWrong, context);
                            }
                          }, onpressed: null),
                        ),
                      ),
                    ]),
              ),
            ]),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    String mobileNo = widget.mobileNumber;
    // set up the buttons
    Widget cancelButton = Center(
      child: TextButton(
        child: const Text(
          okText,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/otppage',
              arguments: {"mobileNo": mobileNo});
        },
      ),
    );

    //   AlertDialog alert = AlertDialog(
    //     title: const Center(
    //         child: Icon(
    //       Icons.check_circle_rounded,
    //       color: Colors.green,
    //       size: 60,
    //     )),

    //     //Text("AlertDialog"),
    //     content: Text(dailogcontext),
    //     actions: [
    //       cancelButton,
    //       // continueButton,
    //     ],
    //   );

    //   // show the dialog
    //   showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return alert;
    //     },
    //   );
    // }

    void reSendOTP() {
      // API CALL to resent Otp
      String mobileNo = widget.mobileNumber;
      // getForgetPin(mobileNo);
      // print(getForgetPin(mobileNo));
    }
  }
}
