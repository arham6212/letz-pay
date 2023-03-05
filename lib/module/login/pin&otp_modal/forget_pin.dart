import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:letzpay/common_components/common_widget.dart';
import 'package:letzpay/services/shared_pref.dart';
import 'package:letzpay/utils/assets_path.dart';
import 'package:letzpay/utils/colors.dart';
import 'package:letzpay/utils/strings.dart';
import 'package:pinput/pinput.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../services/network/api_services.dart';

//Forget pin page
class Resendpin_View extends StatefulWidget {
  final String mobileNumber;
  const Resendpin_View({Key? key, required this.mobileNumber})
      : super(key: key);

  @override
  State<Resendpin_View> createState() => _Resendpin_ViewState();
}

class _Resendpin_ViewState extends State<Resendpin_View> {
  late Timer _timer;
  num _start = 59;
  bool enableResendOTP = false;
  late ApiService apiService;
  late var mContext;

  // String mobileNo = mobileNumber;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();

    startTimer();

    mContext = context;

    // Future.delayed(Duration.zero, () {
    //   String mobileNo = widget.mobileNumber;
    //   getForgetPin(mContext, mobileNo);
    // });
  }

  @override
  void setState(fn) {
    //this method is call for avoid memory leak issue.
    if (mounted) {
      super.setState(fn);
    }
  }

  Future validateOtp(
    var context,
    String mobileNo,
  ) async {
    Response response;
    try {
      var params = {
        "MOBILE_NUMBER": mobileNo,
        "OTP": _pinPutController.text.toString()
      };
      response = await apiService.validateOtp(
          context, params); //API call for for validate otp enter by user

      if (response.statusCode == 200) {
        if (response.data['RESPONSE_CODE'] == '000') {
          saveKeyValString("mobileNumber", mobileNo); //save in shared pref key

          Navigator.pushReplacementNamed(context, '/resetpin',
              arguments: {"mobileNo": mobileNo});
          // showPopUpDialog(otpVerfied,
          //     response.data['RESPONSE_MESSAGE'].toString(), context);

          // showToastMsg(response.data['RESPONSE_MESSAGE'].toString());
        } else {
          setState(() {
            _pinPutController.clear();
            showPopUpDialog(errorpop,
                response.data['RESPONSE_MESSAGE'].toString(), context);

            //  showToastMsg(response.data['RESPONSE_MESSAGE'].toString());
          });

          // print(response.data['RESPONSE_MESSAGE'].toString());
        }
      } else {
        _pinPutController.clear();
        showPopUpDialog(errorpop, errorSomeWrong, context);
        // showToastMsg("error found");
      }
    } on Exception catch (e) {
      // showToastMsg(e.toString());
    }
  }

  // Future getForgetPin(var mcontext, String mobileNo) async {
  //   Response response;
  //   try {
  //     var params = {
  //       "MOBILE_NUMBER": mobileNo,
  //     };
  //     response = await apiService.getForgetPin(mcontext, params);

  //     if (response.statusCode == 200) {
  //       if (response.data['RESPONSE_CODE'] == '000') {
  //         saveKeyValString("mobileNumber", mobileNo);

  //         // AuthenticationProvider.of(context).login(); //go to login page
  //         // Navigator.of(context).pushNamed('/fhome');
  //         // AuthenticationProvider.of(context).login(); //go to login page
  //         // Navigator.of(context).pushNamed('/fhome');
  //         showPopUpDialog(errorverfiyOtp,
  //             response.data['RESPONSE_MESSAGE'].toString(), context);
  //         //   showToastMsg(response.data['RESPONSE_MESSAGE'].toString());
  //       } else {
  //         setState(() {
  //           showPopUpDialog(errorverfiyOtp,
  //               response.data['RESPONSE_MESSAGE'].toString(), context);
  //           //  showToastMsg(response.data['RESPONSE_MESSAGE'].toString());
  //         });

  // print(response.data['RESPONSE_MESSAGE'].toString());
  //       }
  //      else {
  //       _pinPutController.clear();
  //       showPopUpDialog(errorpop, errorSomeWrong, context);
  //       // showToastMsg("error found");
  //     }
  //     Exception catch (e) {
  //     _pinPutController.clear();
  //     showPopUpDialog(errorpop, e.toString(), context);
  //     // showToastMsg(e.toString());
  //   }

  // //         // print(response.data['RESPONSE_MESSAGE'].toString());
  //       }
  //     } else {
  //       showPopUpDialog(errorpop, errorSomeWrong, context);
  //       // showToastMsg("error found");
  //     }
  //   } on Exception catch (e) {
  //     showPopUpDialog(errorpop, e.toString(), context);
  //     // showToastMsg(e.toString());
  //   }
  // }

  //start timer of 60 sec
  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            enableResendOTP = true;
          });
        } else {
          setState(() {
            enableResendOTP = false;
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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
    String mobileNo = widget.mobileNumber;

    const focusedBorderColor = Colors.white;

    // getForgetPin(context, mobileNo);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Vx.hexToColor(balckMainColor),
      // appBar: buildHomeAppBar(
      //     leading: IconButton(
      //         icon: Icon(Icons.arrow_back, color: white),
      //         onPressed: () => {
      //               Navigator.of(context).pushReplacementNamed('/login'),
      //             }),
      //     title: const Text("")),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height.h,
          margin: EdgeInsets.all(18.0.sp),
          padding: EdgeInsets.only(top: 10.h),
          // width: double.infinity,
          // height: double.infinity,
          // color: Colors.white,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed(
                          '/login'); //redirect to login screen.
                    },
                    child: Image.asset(whiteArrow)),
                VSpace(50.0.h),
                verifyCode.text.size(30).color(white).make(),
                VSpace(20.0),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: forMobileNumber,
                      style: TextStyle(
                        color: Vx.hexToColor(greySubTextColor),
                        fontSize: 18.0,
                      ),
                    ),
                    TextSpan(
                      text: mobileNo,
                      style: TextStyle(
                        color: Vx.hexToColor(whiteMainColor),
                        fontSize: 18.0,
                      ),
                      //style: fontStyleHeaderBold(vs),
                    ),
                  ]),
                ),
                VSpace(90.0),
                Column(
                  children: [
                    Pinput(
                        androidSmsAutofillMethod:
                            AndroidSmsAutofillMethod.smsRetrieverApi,
                        listenForMultipleSmsOnAndroid: true,
                        //  autofillHints: true,
                        autofocus: true,
                        obscureText: false,
                        errorText: enterOtpError,
                        length: 6,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r"\d+([\.]\d+)?")),
                        ],
                        onCompleted: (value) {
                          // Navigator.pop(context,_controller.text);
                        }, // navigate through
                        //   focusedPinTheme: defaultPinTheme,

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
                          // showToastMsg(pin);
                          // ScaffoldMessenger.of(context)
                          //     .showSnackBar(SnackBar(content: Text(pin.toString())));
                        }),
                    VSpace(30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            if (enableResendOTP) {
                              reSendOTP(context);
                            }
                          },
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: resend.text
                                .color(Vx.hexToColor(greySubTextColor))
                                .size(18)
                                .make(),
                          ),
                        ),
                        HSpace(4.0),
                        enableResendOTP
                            ? Container()
                            : codeIn.text
                                .color(Vx.hexToColor(greySubTextColor))
                                .size(18)
                                .make(),
                        enableResendOTP
                            ? Container()
                            : Align(
                                alignment: Alignment.bottomLeft,
                                child:
                                    "00:${_start.toString().length < 2 ? "0$_start" : _start.toString()}"
                                        .text
                                        .color(Vx.hexToColor(whiteMainColor))
                                        .fontWeight(FontWeight.w500)
                                        .make(),
                              ),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child:
                        confirmation(context: context, continueButton, ref: () {
                      {
                        validateOtp(
                          context,
                          mobileNo,
                        );
                      }
                    }, onpressed: null),
                  ),
                ),
              ]),
        ),
      ),
    );
  }

//resend otp
  void reSendOTP(var context) {
    // API CALL to resent Otp
    String mobileNo = widget.mobileNumber;
    // getForgetPin(context, mobileNo);
    // print(getForgetPin(mobileNo));

    resetCounter();
  }

//reset timer
  void resetCounter() {
    setState(() {
      _pinPutController.clear();
      startTimer();
      _start = 59;
      enableResendOTP = false;
    });
  }
}
