import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:letzpay/common_components/common_widget.dart';
import 'package:letzpay/common_components/home_app_bar.dart';
import 'package:letzpay/utils/assets_path.dart';
import 'package:letzpay/utils/colors.dart';
import 'package:letzpay/utils/strings.dart';
import 'package:pinput/pinput.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../services/network/api_services.dart';
import '../../services/shared_pref.dart';

class NewPin extends StatefulWidget {
  final String oldPin;
  const NewPin({Key? key, required this.oldPin}) : super(key: key);

  @override
  State<NewPin> createState() => _NewPinState();
}

class _NewPinState extends State<NewPin> {
  late ApiService apiService;
  late final GlobalKey<FormState> _formKey = GlobalKey();

  var mobileNo;
  // final TextEditingController _pinPutController =
  //     TextEditingController(text: );
  @override
  void initState() {
    super.initState();
    apiService = ApiService();

    loadata();
  }

  @override
  void setState(fn) {
    //this method is call for avoid memory leak issue.
    if (mounted) {
      super.setState(fn);
    }
  }

  loadata() async {
    mobileNo = await getStringVal("mobileNumber");

    setState(() {});
  }

  //This function handle update old pin with new pin.
  Future getUpdatePin(
    var context,
  ) async {
    Response response;
    try {
      //request parameter
      var params = {
        "NEW_PIN": _newpinController.text.toString(),
        "CONFIRM_PIN": _confirmpinController.text.toString(),
        "OLD_PIN": widget.oldPin,
        "MOBILE_NUMBER": mobileNo,
      };
      response = await apiService.getUpdatePin(
          context, params); //API call for update pin

      if (response.statusCode == 200) {
        if (response.data['RESPONSE_CODE'] == '000') {
          Navigator.pushReplacementNamed(context, '/confirmpage',
              arguments: {"mobileNo": mobileNo}); //redirect to confirm page
          // showPopUpDialog(successVal,
          //     response.data['RESPONSE_MESSAGE'].toString(), context);
          //  showToastMsg(response.data['RESPONSE_MESSAGE'].toString());
        } else {
          setState(() {
            _newpinController.clear();
            _confirmpinController.clear();
            showPopUpDialog(errorpop,
                response.data['RESPONSE_MESSAGE'].toString(), context);
            //showToastMsg(response.data['RESPONSE_MESSAGE'].toString());
          });

          // print(response.data['RESPONSE_MESSAGE'].toString());
        }
      } else {
        showPopUpDialog(errorpop, errorSomeWrong, context);
        //  showToastMsg("error found");
      }
    } on Exception catch (e) {
      showPopUpDialog(errorpop, e.toString(), context);
      //showToastMsg(e.toString());
    }
  }

  @override
  void dispose() {
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

  final TextEditingController _newpinController = TextEditingController();
  final TextEditingController _confirmpinController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String oldPin = widget.oldPin;
    final TextEditingController _pinPutController =
        TextEditingController(text: oldPin);
    const focusedBorderColor = Colors.white;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Vx.hexToColor(balckMainColor),
      // appBar: buildHomeAppBar(
      //   title: "".text.color(white).make(),
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height,
            margin: const EdgeInsets.all(18.0),
            padding: const EdgeInsets.only(top: 10),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Image.asset(whiteArrow)),
                  //OLD PIN
                  VSpace(20.0),
                  oldPint.text
                      .color(Vx.hexToColor(whiteMainColor))
                      .size(20.0)
                      .make(),
                  VSpace(20.0),
                  Center(
                    child: Pinput(
                        autofocus: true,
                        obscureText: true,
                        errorText: enterPinError,
                        length: 6,
                        readOnly: true,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r"\d+([\.]\d+)?")),
                        ],
                        onCompleted: (value) {
                          // showToastMsg("nextpage");
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
                          // showToastMsg(pin);
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(pin.toString())));
                        }),
                  ),

                  //NEW PIN
                  VSpace(20),
                  newPin.text
                      .size(20.0)
                      .color(Vx.hexToColor(whiteMainColor))
                      .make(),
                  VSpace(20),
                  Center(
                    child: Pinput(
                        autofocus: true,
                        obscureText: true,
                        errorText: enterPinError,
                        length: 6,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r"\d+([\.]\d+)?")),
                        ],
                        onCompleted: (value) {
                          // showToastMsg("nextpage");
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
                        controller: _newpinController,
                        pinAnimationType: PinAnimationType.fade,
                        onSubmitted: (pin) {
                          //  showToastMsg(pin);
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(pin.toString())));
                        }),
                  ),
                  VSpace(20),
                  //CONFIRM PIN

                  confirmPin.text
                      .size(20.0)
                      .color(Vx.hexToColor(whiteMainColor))
                      .make(),
                  VSpace(20),
                  Center(
                    child: Pinput(
                        autofocus: true,
                        obscureText: true,
                        errorText: enterPinError,
                        length: 6,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r"\d+([\.]\d+)?")),
                        ],
                        onCompleted: (value) {
                          //  updateOtp(context);
                          //  showToastMsg("nextpage");
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
                        controller: _confirmpinController,
                        pinAnimationType: PinAnimationType.fade,
                        onSubmitted: (pin) {
                          // showToastMsg(pin);
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //     SnackBar(content: Text(pin.toString())));
                        }),
                  ),

                  VSpace(20),
                  confirmation(context: context, continueButton, ref: () {
                    {
                      updateOtp(context);
                    }
                  }, onpressed: null),

                  VSpace(30),
                  RichText(
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
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'Times New Roman Font',
                                  color: Vx.hexToColor(greySubTextColor))),
                        ]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  updateOtp(var context) {
    if (_newpinController.text.isEmptyOrNull &&
        _confirmpinController.text.isEmptyOrNull) {
      //validation fail
      showPopUpDialog(errorpop, emptyParam, context);
    } else if (_newpinController.text == _confirmpinController.text) {
      //validation success
      getUpdatePin(
        context,
      );
    } else {
      showPopUpDialog(errorpop, errorSomeWrong, context);
      // showToastMsg("SomeThing Went Wrong");
    }
  }
}
