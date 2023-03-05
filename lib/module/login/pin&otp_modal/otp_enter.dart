import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:letzpay/common_components/common_widget.dart';

import 'package:letzpay/services/authentication_service.dart';
import 'package:letzpay/utils/colors.dart';
import 'package:letzpay/utils/strings.dart';
import 'package:pinput/pinput.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../common_components/home_app_bar.dart';
import '../../../services/network/api_services.dart';

class OTP_Enter extends StatefulWidget {
  final String mobileNumber;
  const OTP_Enter({Key? key, required this.mobileNumber}) : super(key: key);

  @override
  State<OTP_Enter> createState() => _OTP_EnterState();
}

class _OTP_EnterState extends State<OTP_Enter> {
  late ApiService apiService;
  late var mContext;

  @override
  void initState() {
    super.initState();

    apiService = ApiService();
    startTimer();
    mContext = context;

    Future.delayed(Duration.zero, () {
      String mobileNo = widget.mobileNumber;
      generateLoginOtp(mContext, mobileNo);
    });
    // String mobileNo = widget.mobileNumber;
    // generateLoginOtp(context, mobileNo);
  }

  //generate otp for forget pin
  Future generateLoginOtp(
    var mContext,
    String mobileNo,
  ) async {
    Response response;
    try {
      var params = {
        "MOBILE_NUMBER": mobileNo,
      };
      response = await apiService.generateLoginOtp(
          mContext, params); //API call for generate otp

      if (response.statusCode == 200) {
        if (response.data['RESPONSE_CODE'] == '000') {
          AuthenticationProvider.of(context).login(); //go to login page
          Navigator.of(context).pushNamed('/fhome'); //redirect to home screen.

          //  getLogin(mobileNo, value);
        } else {
          setState(() {
            _pinPutController.clear();
            showPopUpDialog(errorpop,
                response.data['RESPONSE_MESSAGE'].toString(), context);
            //    showToastMsg(response.data['RESPONSE_MESSAGE'].toString());
          });
          // print(response.data['RESPONSE_MESSAGE'].toString());
        }
      } else {
        _pinPutController.clear();
        showPopUpDialog(errorpop, errorSomeWrong, context);
        //  showToastMsg("error found");
      }
    } on Exception catch (e) {
      _pinPutController.clear();
      showPopUpDialog(errorpop, e.toString(), context);
      // showToastMsg(e.toString());
    }
  }

  late Timer _timer;
  int _start = 59;
  bool enableResendOTP = false;
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
        color: inspireGreyColor, border: Border.all(color: inspireGreyColor)),
    // borderRadius: BorderRadius.circular(5),
  );

  final TextEditingController _pinPutController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    const focusedBorderColor = Colors.white;
    String mobileNo = widget.mobileNumber;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Vx.hexToColor(balckMainColor),
      appBar: buildHomeAppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: white),
              onPressed: () => {
                    Navigator.of(context).pushNamed('/login'),
                  }),
          title: const Text("")),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          margin: const EdgeInsets.all(18.0),
          padding: const EdgeInsets.only(top: 10.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VSpace(50.0),
                verifyCode.text.size(30).color(white).make(),
                VSpace(10.0),
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
                    ),
                  ]),
                ),
                VSpace(90.0),
                Column(
                  children: [
                    Center(
                      child: Pinput(
                          androidSmsAutofillMethod:
                              AndroidSmsAutofillMethod.smsRetrieverApi,
                          listenForMultipleSmsOnAndroid: true,
                          autofocus: true,
                          obscureText: true,
                          errorText: enterPin,
                          length: 6,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r"\d+([\.]\d+)?")),
                          ],
                          onCompleted: (value) {
                            {
                              // generateLoginOtp(context, mobileNo);
                              // saveKeyValString("moduleTypeSharedPrefKey",
                              //     'fhome'); // save the data in share prefrence
                              // AuthenticationProvider.of(context)
                              //     .login(); //go to login page
                              // Navigator.of(context).pushReplacementNamed('/fhome');
                            }
                          },
                          focusedPinTheme: defaultPinTheme.copyWith(
                            decoration: defaultPinTheme.decoration!.copyWith(
                              borderRadius: BorderRadius.circular(5),
                              // color: Vx.hexToColor(greySubTextColor),
                              border: Border.all(
                                  width: 2, color: focusedBorderColor),
                            ),
                          ),
                          submittedPinTheme: defaultPinTheme.copyWith(
                            decoration: defaultPinTheme.decoration!.copyWith(
                              color: inspireGreyColor,
                              // borderRadius: BorderRadius.circular(19),
                              // border: Border.all(color: focusedBorderColor),
                            ),
                          ), // navigate through

                          defaultPinTheme: defaultPinTheme,
                          controller: _pinPutController,
                          pinAnimationType: PinAnimationType.fade,
                          onSubmitted: (pin) {
                            _pinPutController.clear();
                            //  showToastMsg(pin);
                            // ScaffoldMessenger.of(context)
                            //     .showSnackBar(SnackBar(content: Text(pin)));
                          }),
                    ),
                  ],
                ),
                VSpace(20),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween, //Center Row contents horizontally,
                    crossAxisAlignment: CrossAxisAlignment
                        .center, //Center Row contents vertically,
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                if (enableResendOTP) {
                                  reSendOTP();
                                }
                              },
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: resend.text
                                    .color(Vx.hexToColor(greySubTextColor))
                                    .size(18)
                                    .make(),
                              ),
                            ),
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
                                            .color(
                                                Vx.hexToColor(whiteMainColor))
                                            .fontWeight(FontWeight.w500)
                                            .make(),
                                  ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed('/login');
                        },
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: loginWithPin.text
                              .size(18.0)
                              .color(Vx.hexToColor(greySubTextColor))
                              .make(),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child:
                        confirmation(context: context, continueButton, ref: () {
                      {
                        //   generateLoginOtp(context, mobileNo);
                        // validateOtp(
                        //   context,
                        //   mobileNo,
                        // );
                      }
                    }, onpressed: null),
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  void reSendOTP() {
    // API CALL to resent Otp

    String mobileNo = widget.mobileNumber;
    generateLoginOtp(context, mobileNo);
    String mobile = ""; //widget.mobile;
    resetCounter();
  }

//reset timer
  void resetCounter() {
    setState(() {
      _pinPutController.clear();
      _start = 59;
      enableResendOTP = false;
      startTimer();
    });
  }
}
