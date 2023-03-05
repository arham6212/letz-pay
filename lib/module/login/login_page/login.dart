import 'dart:async';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:letzpay/main.dart';
import 'package:letzpay/module/login/loginmodule/response_loginauth.dart';
import 'package:letzpay/services/network_services.dart';
import 'package:letzpay/utils/assets_path.dart';
import 'package:letzpay/utils/colors.dart';
import 'package:letzpay/services/authentication_service.dart';
import 'package:letzpay/services/shared_pref.dart';
import 'package:letzpay/utils/encrypt.dart';
import 'package:letzpay/utils/strings.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../common_components/common_widget.dart';
import '../../../services/network/api_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late Loginauthresponse loginauthresponse;
  // late response validationmobileresponse;
  late ApiService apiService;
  String name = "";
  bool changedButton = false;
  late Timer _timer;
  int _start = 59;
  bool enableResendOTP = false;

  late final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _mobileNoController = TextEditingController();
  late var networkStatus;
  late bool newUser;
  var width = 350.0.w; // <-- play with these numbers
  var height = 700.0.h; // <-- to see it on different sized devices
  late var loginType;
  late var mContext;
  String baseUrl = "";
  int _selectedIndex = 0;
  bool agree = false;
  bool? showLonginWithOtp = true;
  PageController controller = PageController(initialPage: 0);

  late Color focusedBorderColor;
  final validCharacters = RegExp(r'^[a-zA-Z0-9_\-=@,\.;]+$');
  @override
  void initState() {
    super.initState();

    mContext = context;
    apiService = ApiService();

    loginauthresponse = Loginauthresponse();
    String loginType = "PIN";

    removeAllSharedPref(); //for clear all shared pref variable
  }

  // timer of 60 sec
  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            enableResendOTP = true; //if value 0 display enableResendOTP label
          });
        } else {
          setState(() {
            enableResendOTP = false; //not display enableResendOTP label

            _start--;
          });
        }
      },
    );
  }

  ///>>>>>>> this validateMobile Function can be used in production
  // Future validateMobile(var context) async {
  //   Response response;
  //   try {
  //     var params = {"MOBILE_NUMBER": _mobileNoController.text};
  //     response = await apiService.validateMobile(params, context);

  //     if (response.statusCode == 200) {
  //       if (response.data['RESPONSE_CODE'] == '000') {
  //       // getLogin(context, mobileNo, value);
  //         // Navigator.pushReplacementNamed(context, '/otppage',
  //         //     arguments: {"mobileNo": _mobileNoController.text});
  //       } else {
  //         setState(() {
  //           showPopUpDialog(
  //               "", response.data['RESPONSE_MESSAGE'].toString(), context);
  //           //  showToastMsg(response.data['RESPONSE_MESSAGE'].toString());
  //         });
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

  //this function handle generateLoginOtp API
  Future generateLoginOtp(
    var context,
    String mobileNo,
  ) async {
    Response response;
    try {
      var params = {
        "MOBILE_NUMBER": mobileNo,
      };
      response = await apiService.generateLoginOtp(
          context, params); //API call for generate otp for login

      if (response.statusCode == 200) {
        if (response.data['RESPONSE_CODE'] == '000') {
          //on success of response code
          setState(() {
            startTimer(); //Timer for 60 sec

            showPopUpDialog(verifyCode,
                response.data['RESPONSE_MESSAGE'].toString(), context);
          });
        } else {
          showPopUpDialog(
              errorpop, response.data['RESPONSE_MESSAGE'].toString(), context);
          //    showToastMsg(response.data['RESPONSE_MESSAGE'].toString());

          _timer.cancel();
          // print(response.data['RESPONSE_MESSAGE'].toString());
        }
      } else {
        showPopUpDialog(errorpop, errorSomeWrong, context);
        _timer.cancel();
        //  showToastMsg("error found");
      }
    } on Exception catch (e) {
      showPopUpDialog(errorpop, e.toString(), context);
      _timer.cancel();
      // showToastMsg(e.toString());
    }
  }

  //this function handle getLogin API
  Future getLogin(
    var context,
    String mobileNo,
    String loginType,
    String pin,
    // String otp,
  ) async {
    Response response;
    try {
      var params = {
        "MOBILE_NUMBER": mobileNo, //await Encrypt().encryptString(mobileNo),
        "LOGIN_TYPE": loginType,
        loginType: pin
      };
      response = await apiService.getLogin(
        context,
        params,
        // await Encrypt().encryptString(params.toString()),
      ); //API call for do login with pin or otp

      if (response.statusCode == 200) {
        if (response.data['RESPONSE_CODE'] == '000') {
          //on success of response code value are stored in the shared pref with key
          saveKeyValString("mobileNumber", mobileNo);
          saveKeyValString("loginType", loginType);
          saveKeyValString("pinOrOtp", pin);

          //saveKeyValString("uSERTYPE", uSERTYPE);

          loginauthresponse = Loginauthresponse.fromJson(response.data);
          saveKeyValString(
              businessNamePrefKey, loginauthresponse.bUSINESSNAME.toString());
          saveKeyValString(
              userTypePrefKey, loginauthresponse.uSERTYPE.toString());
          saveKeyValString(superMerchantFlagPrefKey,
              loginauthresponse.sUPERMERCHANT_FLAG.toString());
          saveKeyValString(superMerchantPayIdPrefKey,
              loginauthresponse.sUPERMERCHANT_PAY_ID.toString());
          // removeVal(merchantIdPrefKey);
          // removeVal(subMerchantIdPrefKey);
          // removeVal(merchantNamePrefKey);
          // removeVal(subMerchantNamePrefKey);

          AuthenticationProvider.of(context).login(); //go to login page
          //success of login ,redirect to home page.
          Navigator.of(context).pushNamed('/fhome');
        } else {
          setState(() {
            showPopUpDialog(errorpop,
                response.data['RESPONSE_MESSAGE'].toString(), context);
            _pinPutController.clear(); //clear enter pin

            //   showToastMsg(response.data['RESPONSE_MESSAGE'].toString());
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
    }
    //   showToastMsg(e.toString());
  }

  //this function handle getForgetPin API
  Future getForgetPin(var mcontext, String mobileNo) async {
    Response response;
    try {
      var params = {
        "MOBILE_NUMBER": mobileNo,
      };
      response = await apiService.getForgetPin(
          mcontext, params); //API call for forget pin

      if (response.statusCode == 200) {
        if (response.data['RESPONSE_CODE'] == '000') {
          saveKeyValString("mobileNumber", mobileNo); //save in shared pref key

          Navigator.pushNamed(context, '/forgetpin',
              arguments: {"mobileNo": mobileNo});
          // showPopUpDialogApicall(errorverfiyOtp,
          //     response.data['RESPONSE_MESSAGE'].toString(), context);
          // AuthenticationProvider.of(context).login(); //go to login page
          // Navigator.of(context).pushNamed('/fhome');

          //   showToastMsg(response.data['RESPONSE_MESSAGE'].toString());

        } else {
          setState(() {
            showPopUpDialog(errorpop,
                response.data['RESPONSE_MESSAGE'].toString(), context);
            //  showToastMsg(response.data['RESPONSE_MESSAGE'].toString());
          });

          // print(response.data['RESPONSE_MESSAGE'].toString());
        }
      } else {
        showPopUpDialog(errorpop, errorSomeWrong, context);
        // showToastMsg("error found");
      }
    } on Exception catch (e) {
      showPopUpDialog(errorpop, e.toString(), context);
      // showToastMsg(e.toString());
    }
  }
  //>>>>>>>>this validatePin can be used in production
  // Future validatePIN(var context, String mobileNo, String value) async {
  //   Response response;
  //   try {
  //     var params = {"MOBILE_NUMBER": mobileNo, "PIN": value};
  //     response = await apiService.validatePIN(context, params);

  //     if (response.statusCode == 200) {
  //       if (response.data['RESPONSE_CODE'] == '000') {
  //         getLogin(context, mobileNo, value);
  //       } else {
  //         setState(() {
  //           showPopUpDialog(errorpop,
  //               response.data['RESPONSE_MESSAGE'].toString(), context);
  //           //  showToastMsg(response.data['RESPONSE_MESSAGE'].toString());
  //         });
  //         // print(response.data['RESPONSE_MESSAGE'].toString());
  //       }
  //     } else {
  //       showPopUpDialog(errorpop, errorSomeWrong, context);
  //       // showToastMsg("error found");
  //     }
  //   } on Exception catch (e) {
  //     showPopUpDialog(errorpop, e.toString(), context);
  //     //   showToastMsg(e.toString());
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
    _mobileNoController.dispose();
    _timer.cancel();
  }

  final defaultPinTheme = PinTheme(
    width: 56.w,
    height: 56.h,
    textStyle: TextStyle(
        fontSize: 20.0.sp,
        color: Vx.hexToColor(balckMainColor),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: Vx.hexToColor(greySubTextColor)),
      borderRadius: BorderRadius.circular(5.w),
    ),
  );
  final TextEditingController _pinPutController = TextEditingController();
  final TextEditingController _otpPutController = TextEditingController();
  Future<bool> _onWillPop() async {
    if (_selectedIndex != 0) {
      _onItemTapped(0);
      return false;
    } else {
      return showPopUpDialogExit(rYouSureLbl, wantExitLbl, context);
    }
    // false;
  }

  @override
  Widget build(BuildContext context) {
    focusedBorderColor = Vx.hexToColor(balckMainColor);
    String mobileNo = _mobileNoController.text;

    networkStatus = Provider.of<NetworkStatus>(context);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SizedBox(
          // controller: controller,
          // onPageChanged: (num) {
          //   setState(() {
          //     _selectedIndex = num;
          //   });
          //   // _onItemTapped(num);
          // },
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Container(
            // height: MediaQuery.of(context).size.height,
            color: Vx.hexToColor(whiteMainColor),
            child: Padding(
              padding: EdgeInsets.only(
                  left: 24.w, top: 85.h, right: 16.w, bottom: 0.h),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(top: 0.0.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        labelmaintext(welcome, fontsize: 24.sp),
                        VSpace(8.h),
                        labelsubtext(signAccount, fontsize: 16.sp),
                        VSpace(134.h),
                        textFormFieldLogin(
                          keyboardType: TextInputType.number,
                          readOnly: showLonginWithOtp == false ? true : false,
                          suffixIcon: IconButton(
                              onPressed: () {},
                              icon: showLonginWithOtp == false
                                  ? InkWell(
                                      child: Icon(Icons.edit_outlined),
                                      onTap: () {
                                        setState(() {
                                          showLonginWithOtp = true;
                                        });
                                      })
                                  : Container()),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                            FilteringTextInputFormatter.allow(
                              RegExp(r"[0-9]"),
                            )
                          ],
                          validator: (value) {
                            // if (value!.isEmpty) return cantbeempty;
                            String mobile = _mobileNoController.text.trim();
                            if (mobile.isEmpty) {
                              return enterMobile;
                            } else if (mobile.length < 10) {
                              return enterMobileProp;
                            } else {
                              return null;
                            }
                          },
                          labelText: numberhintlabel,
                          controller: _mobileNoController,
                          onChanged: (value) {
                            setState(() {
                              name = value;
                            });
                          },
                        ),
                        VSpace(36.h),
                        showLonginWithOtp == true
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // showLonginWithOtp == false
                                  //     ? enterOtp.text
                                  //         .color(greyColor)
                                  //         .size(20)
                                  //         .make()

                                  enterPin.text
                                      .color(greyColor)
                                      .size(16.sp)
                                      .make(),
                                  VSpace(10.h),

                                  Center(
                                    child: Pinput(
                                        //  autofocus: true,
                                        obscureText: true,
                                        errorText: enterPinError,
                                        length: 6,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r"\d+([\.]\d+)?")),
                                        ],
                                        keyboardType: TextInputType.number,
                                        onCompleted: (value) {
                                          {
                                            //  getLogin(context, mobileNo, value);
                                          }
                                        }, // navigate through

                                        defaultPinTheme: defaultPinTheme,
                                        controller: _pinPutController,
                                        focusedPinTheme:
                                            defaultPinTheme.copyWith(
                                          decoration: defaultPinTheme
                                              .decoration!
                                              .copyWith(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            // color: Vx.hexToColor(greySubTextColor),
                                            border: Border.all(
                                                width: 2,
                                                color: focusedBorderColor),
                                          ),
                                        ),
                                        pinAnimationType: PinAnimationType.fade,
                                        onSubmitted: (pin) {
                                          // validCharacters;
                                        }),
                                  ),
                                  VSpace(16.h),

                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                width * 0.01.w, 0, 0, 0),
                                            child: Container(
                                              child: Row(children: [
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      final formstate =
                                                          _formKey.currentState;

                                                      if (formstate!
                                                          .validate()) {
                                                        showLonginWithOtp =
                                                            false;

                                                        generateLoginOtp(
                                                            context, mobileNo);
                                                      }
                                                    });
                                                  },
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0),
                                                      child: loginWithOtp
                                                          .text.bold
                                                          .size(14.sp)
                                                          .make()),
                                                ),
                                              ]),
                                            )),
                                        InkWell(
                                          onTap: (() {
                                            // setState(() {
                                            final formstate =
                                                _formKey.currentState;
                                            if (formstate!.validate()) {
                                              forgetpin(mContext);
                                            }
                                            //   });
                                          }),
                                          child: Padding(
                                              padding:
                                                  EdgeInsets.only(right: 0.w),
                                              child: forgetPin.text.bold
                                                  .size(14.sp)
                                                  .make()),
                                        ),
                                      ]),
                                  VSpace(64.h),

                                  signInButton(context: context, signInbutton,
                                      ref: () {
                                    final formstate = _formKey.currentState;
                                    if (formstate!.validate()) {
                                      pinvalidateForm();
                                    }
                                  }, onpressed: null)
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  enterOtp.text
                                      .color(greyColor)
                                      .size(16.sp)
                                      .make(),
                                  VSpace(20.h),
                                  Center(
                                    child: Pinput(
                                        // autofocus: true,
                                        obscureText: true,
                                        errorText: enterOtpError,
                                        length: 6,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r"\d+([\.]\d+)?")),
                                        ],
                                        onCompleted: (value) {
                                          {
                                            //  getLogin(context, mobileNo, value);
                                          }
                                        }, // navigate through

                                        defaultPinTheme: defaultPinTheme,
                                        controller: _otpPutController,
                                        focusedPinTheme:
                                            defaultPinTheme.copyWith(
                                          decoration: defaultPinTheme
                                              .decoration!
                                              .copyWith(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            // color: Vx.hexToColor(greySubTextColor),
                                            border: Border.all(
                                                width: 2,
                                                color: focusedBorderColor),
                                          ),
                                        ),
                                        pinAnimationType: PinAnimationType.fade,
                                        onSubmitted: (pin) {}),
                                  ),
                                  VSpace(16.h),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                width * 0.01.w, 0, 0, 0),
                                            child: Container(
                                              child: Row(children: [
                                                InkWell(
                                                  onTap: () {
                                                    if (enableResendOTP) {
                                                      // showLonginWithOtp==false
                                                      reSendOTP();
                                                    }
                                                  },
                                                  child: Align(
                                                    alignment:
                                                        Alignment.bottomLeft,
                                                    child: resend.text
                                                        .color(Vx.hexToColor(
                                                            greySubTextColor))
                                                        .size(16.sp)
                                                        .make(),
                                                  ),
                                                ),
                                                enableResendOTP
                                                    ? Container()
                                                    : codeIn.text
                                                        .color(Vx.hexToColor(
                                                            greySubTextColor))
                                                        .size(16.sp)
                                                        .make(),
                                                enableResendOTP
                                                    ? Container()
                                                    : Align(
                                                        alignment: Alignment
                                                            .bottomLeft,
                                                        child: Text(
                                                          "00:${_start.toString().length < 2 ? "0$_start" : _start.toString()}",
                                                          // "hey",
                                                          style: fontStyleSmall(
                                                            color: Vx.hexToColor(
                                                                balckMainColor),
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                              ]),
                                            )),
                                        InkWell(
                                          onTap: (() {
                                            setState(() {
                                              showLonginWithOtp = true;
                                              // startTimer();
                                            });
                                          }),
                                          child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: width * 0.05),
                                              child: loginWithPin.text.bold
                                                  .size(14.h)
                                                  .make()),
                                        ),
                                      ]),
                                  VSpace(30),
                                  signInButton(context: context, signInbutton,
                                      ref: () {
                                    final formstate = _formKey.currentState;
                                    if (formstate!.validate()) {
                                      otpvalidateForm();
                                    }
                                  }, onpressed: null)
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      controller.jumpToPage(_selectedIndex);
    });
  }

//Handle forget pin
  forgetpin(mcontext) {
    String mobileNo = _mobileNoController.text;
    if (_mobileNoController.text.isEmpty ||
        _mobileNoController.text.length < 10) {
    } else if (networkStatus == NetworkStatus.offline) {
      //validation fail
      showPopUpDialog(errorpop, errorNoInternet, context);
      // showToastMsg("Please turn on net");
    } else {
      //validation success
      getForgetPin(mcontext, mobileNo); //call forgotpin  API
    }
  }

//Handle pin validation
  pinvalidateForm() {
    if (_mobileNoController.text.isEmpty ||
        _mobileNoController.text.length < 10) {
    } else if (_pinPutController.text.toString().isEmptyOrNull) {
      //  errorDialog(context, errorPinEmpty);
      //validation fail
      showPopUpDialog(enterPinError, errorPinEmpty, context);
    } else if (networkStatus == NetworkStatus.offline) {
      showPopUpDialog(errorpop, errorNoInternet, context);
      // showToastMsg("Please turn on net");
    } else {
      //validation success
      setState(() {
        getLogin(
          context,
          _mobileNoController.text.toString(),
          loginType = "PIN",
          _pinPutController.text.toString(),
        );
      });
    }
  }

  otpvalidateForm() {
    if (_mobileNoController.text.isEmpty ||
        _mobileNoController.text.length < 10) {
    } else if (_otpPutController.text.toString().isEmptyOrNull) {
      showPopUpDialog(emptyParam, errorPinEmpty, context);
    } else if (networkStatus == NetworkStatus.offline) {
      showPopUpDialog(errorpop, errorNoInternet, context);
      // showToastMsg("Please turn on net");
    } else {
      setState(() {
        getLogin(
          context,
          _mobileNoController.text.toString(),
          loginType = "OTP",
          _otpPutController.text.toString(),
        );
      });
    }
  }

  showPopUpDialogApicall(String titletext, String text, BuildContext context) {
    String mobileNo = _mobileNoController.text;
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
            Navigator.pushNamed(context, '/forgetpin',
                arguments: {"mobileNo": mobileNo});
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
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0))),
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
                        text.text
                            .overflow(TextOverflow.ellipsis)
                            .maxLines(3)
                            .make(),
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

  void reSendOTP() {
    // API CALL to resent Otp

    // String mobileNo = _mobileNoController.text;
    // generateLoginOtp(context, mobileNo);
    resetCounter();
  }

//reset counter of 60 sec
  void resetCounter() {
    setState(() {
      _otpPutController.clear();
      startTimer();
      _start = 59;
      enableResendOTP = false;
      String mobileNo = _mobileNoController.text;
      generateLoginOtp(context, mobileNo);
    });
  }

  // Future<String> getBaseUrl() async {
  //   baseUrl = Environment().;
  //   showToastMsg("BaseUrl Found $baseUrl");

  //   return baseUrl;
  // }
}

final validCharacters = RegExp(r'^[a-zA-Z0-9_\-=@,\.;]+$');

class AlwaysActiveBorderSide extends MaterialStateBorderSide {
  @override
  BorderSide? resolve(_) => const BorderSide(color: whiteLight);
}
